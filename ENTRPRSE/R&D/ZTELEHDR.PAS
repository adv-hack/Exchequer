unit zTeleHdr;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, zTeleLin;

type
  TCOMTeleSales = class(TAutoIntfObject, ICOMTeleSales, ICOMTeleSales2, ICOMTeleSales3,
                                         ICOMTeleSales4)
  private
    FEntSysObj : TEnterpriseSystem;
    FTelesales : TAbsTelesales4;

    FTeleSalesLineO : TCOMTelesalesLine;
    FTeleSalesLineI : ICOMTelesalesLine;
  protected
    { Property methods }
    function Get_teCustCode: WideString; safecall;
    procedure Set_teCustCode(const Value: WideString); safecall;
    function Get_teCurrency: Integer; safecall;
    procedure Set_teCurrency(Value: Integer); safecall;
    function Get_teCompanyRate: Double; safecall;
    procedure Set_teCompanyRate(Value: Double); safecall;
    function Get_teDailyRate: Double; safecall;
    procedure Set_teDailyRate(Value: Double); safecall;
    function Get_teYourRef: WideString; safecall;
    procedure Set_teYourRef(const Value: WideString); safecall;
    function Get_teAltRef: WideString; safecall;
    procedure Set_teAltRef(const Value: WideString); safecall;
    function Get_teCostCentre: WideString; safecall;
    procedure Set_teCostCentre(const Value: WideString); safecall;
    function Get_teDepartment: WideString; safecall;
    procedure Set_teDepartment(const Value: WideString); safecall;
    function Get_teLocation: WideString; safecall;
    procedure Set_teLocation(const Value: WideString); safecall;
    function Get_teJobCode: WideString; safecall;
    procedure Set_teJobCode(const Value: WideString); safecall;
    function Get_teJobAnal: WideString; safecall;
    procedure Set_teJobAnal(const Value: WideString); safecall;
    function Get_teDelAddr(Index: Integer): WideString; safecall;
    procedure Set_teDelAddr(Index: Integer; const Value: WideString); safecall;
    function Get_teTransDate: WideString; safecall;
    procedure Set_teTransDate(const Value: WideString); safecall;
    function Get_teDueDate: WideString; safecall;
    procedure Set_teDueDate(const Value: WideString); safecall;
    function Get_teNetTotal: Double; safecall;
    procedure Set_teNetTotal(Value: Double); safecall;
    function Get_teVATTotal: Double; safecall;
    procedure Set_teVATTotal(Value: Double); safecall;
    function Get_teTotalDiscount: Double; safecall;
    procedure Set_teTotalDiscount(Value: Double); safecall;
    function Get_teUser: WideString; safecall;
    procedure Set_teUser(const Value: WideString); safecall;
    function Get_teInProgress: WordBool; safecall;
    procedure Set_teInProgress(Value: WordBool); safecall;
    function Get_teTransportNature: Integer; safecall;
    procedure Set_teTransportNature(Value: Integer); safecall;
    function Get_teTransportMode: Integer; safecall;
    procedure Set_teTransportMode(Value: Integer); safecall;
    function Get_teSSDDelTerms: WideString; safecall;
    procedure Set_teSSDDelTerms(const Value: WideString); safecall;
    function Get_teControlGL: Integer; safecall;
    procedure Set_teControlGL(Value: Integer); safecall;
    function Get_teVATCode: WideString; safecall;
    procedure Set_teVATCode(const Value: WideString); safecall;
    function Get_teHistoryAnalysisMode: Integer; safecall;
    procedure Set_teHistoryAnalysisMode(Value: Integer); safecall;
    function Get_teListScaleMode: Integer; safecall;
    procedure Set_teListScaleMode(Value: Integer); safecall;
    function Get_teWasNew: WordBool; safecall;
    procedure Set_teWasNew(Value: WordBool); safecall;
    function Get_teUseORate: Integer; safecall;
    procedure Set_teUseORate(Value: Integer); safecall;
    function Get_teDefaultGLCode: Integer; safecall;
    procedure Set_teDefaultGLCode(Value: Integer); safecall;
    function Get_teInclusiveVATCode: WideString; safecall;
    procedure Set_teInclusiveVATCode(const Value: WideString); safecall;
    function Get_teDefSettleDisc: Double; safecall;
    procedure Set_teDefSettleDisc(Value: Double); safecall;
    function Get_teTransactionType: Integer; safecall;
    procedure Set_teTransactionType(Value: Integer); safecall;
    function Get_teSalesLine: ICOMTelesalesLine; safecall;
    function Get_AccessRights: TRecordAccessStatus; safecall;

    // ICOMTeleSales2  MH 15/10/2013 v7.0.7
    function Get_teDeliveryPostCode: WideString; safecall;
    procedure Set_teDeliveryPostCode(const Value: WideString); safecall;

    // MH 26/11/2014: Added new field for Delivery Country Code
    function Get_teDeliveryCountry: WideString; safecall;
    procedure Set_teDeliveryCountry(const Value: WideString); safecall;

    // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - ICOMTeleSales4
    function Get_teSSDProcess: WideString; safecall;
    procedure Set_teSSDProcess(const Value: WideString); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitTelesales(EntSysObj : TEnterpriseSystem);
  End; { TCOMTeleSales }


implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMTeleSales.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMTeleSales4);

  FEntSysObj := Nil;

  // Create line sub-object
  FTeleSalesLineO := TCOMTelesalesLine.Create;
  FTeleSalesLineI := FTeleSalesLineO;
End; { Create }

//------------------------------

destructor TCOMTeleSales.Destroy;
begin
  FTeleSalesLineO := NIL;
  FTeleSalesLineI := NIL;   // Destroys object

  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMTeleSales.InitTelesales(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FTelesales := TABSTelesales4(EntSysObj.Telesales);

  FTeleSalesLineO.InitTeleLine(EntSysObj);
end;

//-------------------------------------------------------------------------


function TCOMTeleSales.Get_teCustCode: WideString;
begin
  Result := FTelesales.teCustCode;
end;

procedure TCOMTeleSales.Set_teCustCode(const Value: WideString);
begin
  FTelesales.teCustCode := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teCurrency: Integer;
begin
  Result := FTelesales.teCurrency;
end;

procedure TCOMTeleSales.Set_teCurrency(Value: Integer);
begin
  FTelesales.teCurrency := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teCompanyRate: Double;
begin
  Result := FTelesales.teCompanyRate;
end;

procedure TCOMTeleSales.Set_teCompanyRate(Value: Double);
begin
  FTelesales.teCompanyRate := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teDailyRate: Double;
begin
  Result := FTelesales.teDailyRate;
end;

procedure TCOMTeleSales.Set_teDailyRate(Value: Double);
begin
  FTelesales.teDailyRate := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teYourRef: WideString;
begin
  Result := FTelesales.teYourRef;
end;

procedure TCOMTeleSales.Set_teYourRef(const Value: WideString);
begin
  FTelesales.teYourRef := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teAltRef: WideString;
begin
  Result := FTelesales.teAltRef;
end;

procedure TCOMTeleSales.Set_teAltRef(const Value: WideString);
begin
  FTelesales.teAltRef := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teCostCentre: WideString;
begin
  Result := FTelesales.teCostCentre;
end;

procedure TCOMTeleSales.Set_teCostCentre(const Value: WideString);
begin
  FTelesales.teCostCentre := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teDepartment: WideString;
begin
  Result := FTelesales.teDepartment;
end;

procedure TCOMTeleSales.Set_teDepartment(const Value: WideString);
begin
  FTelesales.teDepartment := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teLocation: WideString;
begin
  Result := FTelesales.teLocation;
end;

procedure TCOMTeleSales.Set_teLocation(const Value: WideString);
begin
  FTelesales.teLocation := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teJobCode: WideString;
begin
  Result := FTelesales.teJobCode;
end;

procedure TCOMTeleSales.Set_teJobCode(const Value: WideString);
begin
  FTelesales.teJobCode := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teJobAnal: WideString;
begin
  Result := FTelesales.teJobAnal;
end;

procedure TCOMTeleSales.Set_teJobAnal(const Value: WideString);
begin
  FTelesales.teJobAnal := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teDelAddr(Index: Integer): WideString;
begin
  Result := FTelesales.teDelAddr[Index];
end;

procedure TCOMTeleSales.Set_teDelAddr(Index: Integer; const Value: WideString);
begin
  FTelesales.teDelAddr[Index] := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teTransDate: WideString;
begin
  Result := FTelesales.teTransDate;
end;

procedure TCOMTeleSales.Set_teTransDate(const Value: WideString);
begin
  FTelesales.teTransDate := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teDueDate: WideString;
begin
  Result := FTelesales.teDueDate;
end;

procedure TCOMTeleSales.Set_teDueDate(const Value: WideString);
begin
  FTelesales.teDueDate := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teNetTotal: Double;
begin
  Result := FTelesales.teNetTotal;
end;

procedure TCOMTeleSales.Set_teNetTotal(Value: Double);
begin
  FTelesales.teNetTotal := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teVATTotal: Double;
begin
  Result := FTelesales.teVATTotal;
end;

procedure TCOMTeleSales.Set_teVATTotal(Value: Double);
begin
  FTelesales.teVATTotal := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teTotalDiscount: Double;
begin
  Result := FTelesales.teTotalDiscount;
end;

procedure TCOMTeleSales.Set_teTotalDiscount(Value: Double);
begin
  FTelesales.teTotalDiscount := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teUser: WideString;
begin
  Result := FTelesales.teUser;
end;

procedure TCOMTeleSales.Set_teUser(const Value: WideString);
begin
  FTelesales.teUser := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teInProgress: WordBool;
begin
  Result := FTelesales.teInProgress;
end;

procedure TCOMTeleSales.Set_teInProgress(Value: WordBool);
begin
  FTelesales.teInProgress := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teTransportNature: Integer;
begin
  Result := FTelesales.teTransportNature;
end;

procedure TCOMTeleSales.Set_teTransportNature(Value: Integer);
begin
  FTelesales.teTransportNature := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teTransportMode: Integer;
begin
  Result := FTelesales.teTransportMode;
end;

procedure TCOMTeleSales.Set_teTransportMode(Value: Integer);
begin
  FTelesales.teTransportMode := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teSSDDelTerms: WideString;
begin
  Result := FTelesales.teSSDDelTerms;
end;

procedure TCOMTeleSales.Set_teSSDDelTerms(const Value: WideString);
begin
  FTelesales.teSSDDelTerms := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teControlGL: Integer;
begin
  Result := FTelesales.teControlGL;
end;

procedure TCOMTeleSales.Set_teControlGL(Value: Integer);
begin
  FTelesales.teControlGL := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teVATCode: WideString;
begin
  Result := FTelesales.teVATCode;
end;

procedure TCOMTeleSales.Set_teVATCode(const Value: WideString);
begin
  FTelesales.teVATCode := WideStrToChar (Value, ' ');
end;

//------------------------------

function TCOMTeleSales.Get_teHistoryAnalysisMode: Integer;
begin
  Result := FTelesales.teHistoryAnalysisMode;
end;

procedure TCOMTeleSales.Set_teHistoryAnalysisMode(Value: Integer);
begin
  FTelesales.teHistoryAnalysisMode := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teListScaleMode: Integer;
begin
  Result := FTelesales.teListScaleMode;
end;

procedure TCOMTeleSales.Set_teListScaleMode(Value: Integer);
begin
  FTelesales.teListScaleMode := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teWasNew: WordBool;
begin
  Result := FTelesales.teWasNew;
end;

procedure TCOMTeleSales.Set_teWasNew(Value: WordBool);
begin
  FTelesales.teWasNew := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teUseORate: Integer;
begin
  Result := FTelesales.teUseORate;
end;

procedure TCOMTeleSales.Set_teUseORate(Value: Integer);
begin
  FTelesales.teUseORate := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teDefaultGLCode: Integer;
begin
  Result := FTelesales.teDefaultGLCode;
end;

procedure TCOMTeleSales.Set_teDefaultGLCode(Value: Integer);
begin
  FTelesales.teDefaultGLCode := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teInclusiveVATCode: WideString;
begin
  Result := FTelesales.teInclusiveVATCode;
end;

procedure TCOMTeleSales.Set_teInclusiveVATCode(const Value: WideString);
begin
  FTelesales.teInclusiveVATCode := WideStrToChar (Value, ' ');
end;

//------------------------------

function TCOMTeleSales.Get_teDefSettleDisc: Double;
begin
  Result := FTelesales.teDefSettleDisc;
end;

procedure TCOMTeleSales.Set_teDefSettleDisc(Value: Double);
begin
  FTelesales.teDefSettleDisc := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teTransactionType: Integer;
begin
  Result := FTelesales.teTransactionType;
end;

procedure TCOMTeleSales.Set_teTransactionType(Value: Integer);
begin
  FTelesales.teTransactionType := Value;
end;

//------------------------------

function TCOMTeleSales.Get_teSalesLine: ICOMTelesalesLine;
begin
  Result := FTeleSalesLineI;
end;

//------------------------------

function TCOMTeleSales.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FTelesales.AccessRights);
end;

//-------------------------------------------------------------------------

// ICOMTeleSales2  MH 15/10/2013 v7.0.7
function TCOMTeleSales.Get_teDeliveryPostCode: WideString;
Begin // Get_teDeliveryPostCode
  Result := FTelesales.teDeliveryPostCode;
End; // Get_teDeliveryPostCode
procedure TCOMTeleSales.Set_teDeliveryPostCode(const Value: WideString);
Begin // Set_teDeliveryPostCode
  FTelesales.teDeliveryPostCode := Value;
End; // Set_teDeliveryPostCode

//-------------------------------------------------------------------------

// MH 26/11/2014: Added new field for Delivery Country Code
function TCOMTeleSales.Get_teDeliveryCountry: WideString;
Begin // Get_teDeliveryCountry
  Result := FTelesales.teDeliveryCountry
End; // Get_teDeliveryCountry
procedure TCOMTeleSales.Set_teDeliveryCountry(const Value: WideString);
Begin // Set_teDeliveryCountry
  FTelesales.teDeliveryCountry := Value
End; // Set_teDeliveryCountry

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016-R1: Intrastat enhancements - ICOMTeleSales4
function TCOMTeleSales.Get_teSSDProcess: WideString;
Begin // Get_teSSDProcess
  Result := FTelesales.teSSDProcess
End; // Get_teSSDProcess
procedure TCOMTeleSales.Set_teSSDProcess(const Value: WideString);
Begin // Set_teSSDProcess
  FTelesales.teSSDProcess := WideStrToChar (Value, ' ');
End; // Set_teSSDProcess

//=========================================================================

end.
