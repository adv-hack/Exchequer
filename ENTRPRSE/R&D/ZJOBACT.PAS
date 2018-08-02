unit zJobAct;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, zCcyTri;

type
  TCOMJobActual = class(TAutoIntfObject, ICOMJobActual)
  private
    FEntSysObj : TEnterpriseSystem;
    FJobACtual : TAbsJobActual;

    FCcyTriO  : TCOMCurrencyTriangulation;
    FCcyTriI  : ICOMCurrencyTriangulation;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_jaAnalysisCode: WideString; safecall;
    procedure Set_jaAnalysisCode(const Value: WideString); safecall;
    function Get_jaCurrency: Integer; safecall;
    procedure Set_jaCurrency(Value: Integer); safecall;
    function Get_jaPeriod: Integer; safecall;
    procedure Set_jaPeriod(Value: Integer); safecall;
    function Get_jaPosted: WordBool; safecall;
    procedure Set_jaPosted(Value: WordBool); safecall;
    function Get_jaLineFolio: Integer; safecall;
    procedure Set_jaLineFolio(Value: Integer); safecall;
    function Get_jaLineNumber: Integer; safecall;
    procedure Set_jaLineNumber(Value: Integer); safecall;
    function Get_jaDocRef: WideString; safecall;
    procedure Set_jaDocRef(const Value: WideString); safecall;
    function Get_jaStockCode: WideString; safecall;
    procedure Set_jaStockCode(const Value: WideString); safecall;
    function Get_jaDate: WideString; safecall;
    procedure Set_jaDate(const Value: WideString); safecall;
    function Get_jaQty: Double; safecall;
    procedure Set_jaQty(Value: Double); safecall;
    function Get_jaCost: Double; safecall;
    procedure Set_jaCost(Value: Double); safecall;
    function Get_jaCharge: Double; safecall;
    procedure Set_jaCharge(Value: Double); safecall;
    function Get_jaInvoiced: WordBool; safecall;
    procedure Set_jaInvoiced(Value: WordBool); safecall;
    function Get_jaInvoiceRef: WideString; safecall;
    procedure Set_jaInvoiceRef(const Value: WideString); safecall;
    function Get_jaEmployeeCode: WideString; safecall;
    procedure Set_jaEmployeeCode(const Value: WideString); safecall;
    function Get_jaAnalysisType: Integer; safecall;
    procedure Set_jaAnalysisType(Value: Integer); safecall;
    function Get_jaPostedRun: Integer; safecall;
    procedure Set_jaPostedRun(Value: Integer); safecall;
    function Get_jaReverseWIP: WordBool; safecall;
    procedure Set_jaReverseWIP(Value: WordBool); safecall;
    function Get_jaReconciled: WordBool; safecall;
    procedure Set_jaReconciled(Value: WordBool); safecall;
    function Get_jaDocType: TDocTypes; safecall;
    procedure Set_jaDocType(Value: TDocTypes); safecall;
    function Get_jaChargeCurrency: Integer; safecall;
    procedure Set_jaChargeCurrency(Value: Integer); safecall;
    function Get_jaAccountCode: WideString; safecall;
    procedure Set_jaAccountCode(const Value: WideString); safecall;
    function Get_jaHoldFlag: Integer; safecall;
    procedure Set_jaHoldFlag(Value: Integer); safecall;
    function Get_jaPostedToStock: WordBool; safecall;
    procedure Set_jaPostedToStock(Value: WordBool); safecall;
    function Get_jaCompanyRate: Double; safecall;
    procedure Set_jaCompanyRate(Value: Double); safecall;
    function Get_jaDailyRate: Double; safecall;
    procedure Set_jaDailyRate(Value: Double); safecall;
    function Get_jaTagged: WordBool; safecall;
    procedure Set_jaTagged(Value: WordBool); safecall;
    function Get_jaGLCode: Integer; safecall;
    procedure Set_jaGLCode(Value: Integer); safecall;
    function Get_jaUseORate: Integer; safecall;
    procedure Set_jaUseORate(Value: Integer); safecall;
    function Get_jaTriangulation: ICOMCurrencyTriangulation; safecall;
    function Get_jaPriceMultiplier: Double; safecall;
    procedure Set_jaPriceMultiplier(Value: Double); safecall;
    function Get_jaYear: Integer; safecall;
    procedure Set_jaYear(Value: Integer); safecall;
    function Get_jaUpliftTotal: Double; safecall;
    procedure Set_jaUpliftTotal(Value: Double); safecall;
    function Get_jaUpliftGL: Integer; safecall;
    procedure Set_jaUpliftGL(Value: Integer); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitJobActual(EntSysObj: TEnterpriseSystem);
  End; { TCOMJobActual }

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMJobActual.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMJobActual);

  FEntSysObj := Nil;

  FCcyTriO := NIL;
  FCcyTriI := NIL;
End; { Create }

//------------------------------

destructor TCOMJobActual.Destroy;
begin
  FCcyTriO := NIL;
  FCcyTriI := NIL;

  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMJobActual.InitJobActual(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FJobACtual := FEntSysObj.JobCosting.Job2.jrActual;

  If Assigned(FCcyTriO) Then FCcyTriO.InitCcyTri(FJobACtual.jaTriangulation);
end;

//-------------------------------------------------------------------------

function TCOMJobActual.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FJobACtual.AccessRights);
end;

//------------------------------

function TCOMJobActual.Get_jaAnalysisCode: WideString;
begin
  Result := FJobACtual.jaAnalysisCode;
end;

procedure TCOMJobActual.Set_jaAnalysisCode(const Value: WideString);
begin
  FJobACtual.jaAnalysisCode := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaCurrency: Integer;
begin
  Result := FJobACtual.jaCurrency;
end;

procedure TCOMJobActual.Set_jaCurrency(Value: Integer);
begin
  FJobACtual.jaCurrency := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaPeriod: Integer;
begin
  Result := FJobACtual.jaPeriod;
end;

procedure TCOMJobActual.Set_jaPeriod(Value: Integer);
begin
  FJobACtual.jaPeriod := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaPosted: WordBool;
begin
  Result := FJobACtual.jaPosted;
end;

procedure TCOMJobActual.Set_jaPosted(Value: WordBool);
begin
  FJobACtual.jaPosted := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaLineFolio: Integer;
begin
  Result := FJobACtual.jaLineFolio;
end;

procedure TCOMJobActual.Set_jaLineFolio(Value: Integer);
begin
  FJobACtual.jaLineFolio := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaLineNumber: Integer;
begin
  Result := FJobACtual.jaLineNumber;
end;

procedure TCOMJobActual.Set_jaLineNumber(Value: Integer);
begin
  FJobACtual.jaLineNumber := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaDocRef: WideString;
begin
  Result := FJobACtual.jaDocRef;
end;

procedure TCOMJobActual.Set_jaDocRef(const Value: WideString);
begin
  FJobACtual.jaDocRef := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaStockCode: WideString;
begin
  Result := FJobACtual.jaStockCode;
end;

procedure TCOMJobActual.Set_jaStockCode(const Value: WideString);
begin
  FJobACtual.jaStockCode := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaDate: WideString;
begin
  Result := FJobACtual.jaDate;
end;

procedure TCOMJobActual.Set_jaDate(const Value: WideString);
begin
  FJobACtual.jaDate := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaQty: Double;
begin
  Result := FJobACtual.jaQty;
end;

procedure TCOMJobActual.Set_jaQty(Value: Double);
begin
  FJobACtual.jaQty := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaCost: Double;
begin
  Result := FJobACtual.jaCost;
end;

procedure TCOMJobActual.Set_jaCost(Value: Double);
begin
  FJobACtual.jaCost := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaCharge: Double;
begin
  Result := FJobACtual.jaCharge;
end;

procedure TCOMJobActual.Set_jaCharge(Value: Double);
begin
  FJobACtual.jaCharge := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaInvoiced: WordBool;
begin
  Result := FJobACtual.jaInvoiced;
end;

procedure TCOMJobActual.Set_jaInvoiced(Value: WordBool);
begin
  FJobACtual.jaInvoiced := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaInvoiceRef: WideString;
begin
  Result := FJobACtual.jaInvoiceRef;
end;

procedure TCOMJobActual.Set_jaInvoiceRef(const Value: WideString);
begin
  FJobACtual.jaInvoiceRef := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaEmployeeCode: WideString;
begin
  Result := FJobACtual.jaEmployeeCode;
end;

procedure TCOMJobActual.Set_jaEmployeeCode(const Value: WideString);
begin
  FJobACtual.jaEmployeeCode := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaAnalysisType: Integer;
begin
  Result := FJobACtual.jaAnalysisType;
end;

procedure TCOMJobActual.Set_jaAnalysisType(Value: Integer);
begin
  FJobACtual.jaAnalysisType := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaPostedRun: Integer;
begin
  Result := FJobACtual.jaPostedRun;
end;

procedure TCOMJobActual.Set_jaPostedRun(Value: Integer);
begin
  FJobACtual.jaPostedRun := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaReverseWIP: WordBool;
begin
  Result := FJobACtual.jaReverseWIP;
end;

procedure TCOMJobActual.Set_jaReverseWIP(Value: WordBool);
begin
  FJobACtual.jaReverseWIP := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaReconciled: WordBool;
begin
  Result := FJobACtual.jaReconciled;
end;

procedure TCOMJobActual.Set_jaReconciled(Value: WordBool);
begin
  FJobACtual.jaReconciled := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaDocType: TDocTypes;
begin
  Result := Ord(FJobACtual.jaDocType);
end;

procedure TCOMJobActual.Set_jaDocType(Value: TDocTypes);
Var
  Doc : cuDocTypes;
Begin
  Doc := cuDocTypes(Ord(Value));
  FJobACtual.jaDocType := Doc;
end;

//------------------------------

function TCOMJobActual.Get_jaChargeCurrency: Integer;
begin
  Result := FJobACtual.jaChargeCurrency;
end;

procedure TCOMJobActual.Set_jaChargeCurrency(Value: Integer);
begin
  FJobACtual.jaChargeCurrency := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaAccountCode: WideString;
begin
  Result := FJobACtual.jaAccountCode;
end;

procedure TCOMJobActual.Set_jaAccountCode(const Value: WideString);
begin
  FJobACtual.jaAccountCode := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaHoldFlag: Integer;
begin
  Result := FJobACtual.jaHoldFlag;
end;

procedure TCOMJobActual.Set_jaHoldFlag(Value: Integer);
begin
  FJobACtual.jaHoldFlag := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaPostedToStock: WordBool;
begin
  Result := FJobACtual.jaPostedToStock;
end;

procedure TCOMJobActual.Set_jaPostedToStock(Value: WordBool);
begin
  FJobACtual.jaPostedToStock := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaCompanyRate: Double;
begin
  Result := FJobACtual.jaCompanyRate;
end;

procedure TCOMJobActual.Set_jaCompanyRate(Value: Double);
begin
  FJobACtual.jaCompanyRate := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaDailyRate: Double;
begin
  Result := FJobACtual.jaDailyRate;
end;

procedure TCOMJobActual.Set_jaDailyRate(Value: Double);
begin
  FJobACtual.jaDailyRate := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaTagged: WordBool;
begin
  Result := FJobACtual.jaTagged;
end;

procedure TCOMJobActual.Set_jaTagged(Value: WordBool);
begin
  FJobACtual.jaTagged := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaGLCode: Integer;
begin
  Result := FJobACtual.jaGLCode;
end;

procedure TCOMJobActual.Set_jaGLCode(Value: Integer);
begin
  FJobACtual.jaGLCode := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaUseORate: Integer;
begin
  Result := FJobACtual.jaUseORate;
end;

procedure TCOMJobActual.Set_jaUseORate(Value: Integer);
begin
  FJobACtual.jaUseORate := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaTriangulation: ICOMCurrencyTriangulation;
begin
  If (Not Assigned(FCcyTriO)) Then Begin
    { Create and initialise the Job Actuals sub-object }
    FCcyTriO := TCOMCurrencyTriangulation.Create;
    FCcyTriO.InitCcyTri(FJobActual.jaTriangulation);

    FCcyTriI := FCcyTriO;
  End; { If (Not Assigned(FCcyTriO)) }

  Result := FCcyTriI;
end;

//------------------------------

function TCOMJobActual.Get_jaPriceMultiplier: Double;
begin
  Result := FJobACtual.jaPriceMultiplier;
end;

procedure TCOMJobActual.Set_jaPriceMultiplier(Value: Double);
begin
  FJobACtual.jaPriceMultiplier := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaYear: Integer;
begin
  Result := FJobACtual.jaYear;
end;

procedure TCOMJobActual.Set_jaYear(Value: Integer);
begin
  FJobACtual.jaYear := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaUpliftTotal: Double;
begin
  Result := FJobACtual.jaUpliftTotal;
end;

procedure TCOMJobActual.Set_jaUpliftTotal(Value: Double);
begin
  FJobACtual.jaUpliftTotal := Value;
end;

//------------------------------

function TCOMJobActual.Get_jaUpliftGL: Integer;
begin
  Result := FJobACtual.jaUpliftGL;
end;

procedure TCOMJobActual.Set_jaUpliftGL(Value: Integer);
begin
  FJobACtual.jaUpliftGL := Value;
end;

//=========================================================================

end.
