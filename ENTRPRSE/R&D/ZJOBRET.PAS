unit zJobRet;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMJobRetention = class(TAutoIntfObject, ICOMJobRetention, ICOMJobRetention2)
  private
    FEntSysObj : TEnterpriseSystem;
    FJobRetention : TAbsJobRetention;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_jrtAnalysisCode: WideString; safecall;
    procedure Set_jrtAnalysisCode(const Value: WideString); safecall;
    function Get_jrtOriginalCurrency: Integer; safecall;
    procedure Set_jrtOriginalCurrency(Value: Integer); safecall;
    function Get_jrtYear: Integer; safecall;
    procedure Set_jrtYear(Value: Integer); safecall;
    function Get_jrtPeriod: Integer; safecall;
    procedure Set_jrtPeriod(Value: Integer); safecall;
    function Get_jrtPosted: WordBool; safecall;
    procedure Set_jrtPosted(Value: WordBool); safecall;
    function Get_jrtPercent: Double; safecall;
    procedure Set_jrtPercent(Value: Double); safecall;
    function Get_jrtCurrency: Integer; safecall;
    procedure Set_jrtCurrency(Value: Integer); safecall;
    function Get_jrtValue: Double; safecall;
    procedure Set_jrtValue(Value: Double); safecall;
    function Get_jrtJobCode: WideString; safecall;
    procedure Set_jrtJobCode(const Value: WideString); safecall;
    function Get_jrtCreditDoc: WideString; safecall;
    procedure Set_jrtCreditDoc(const Value: WideString); safecall;
    function Get_jrtExpiryDate: WideString; safecall;
    procedure Set_jrtExpiryDate(const Value: WideString); safecall;
    function Get_jrtInvoiced: WordBool; safecall;
    procedure Set_jrtInvoiced(Value: WordBool); safecall;
    function Get_jrtAcCode: WideString; safecall;
    procedure Set_jrtAcCode(const Value: WideString); safecall;
    function Get_jrtEntryDate: WideString; safecall;
    procedure Set_jrtEntryDate(const Value: WideString); safecall;
    function Get_jrtCostCentre: WideString; safecall;
    procedure Set_jrtCostCentre(const Value: WideString); safecall;
    function Get_jrtDepartment: WideString; safecall;
    procedure Set_jrtDepartment(const Value: WideString); safecall;
    function Get_jrtDefVATCode: WideString; safecall;
    procedure Set_jrtDefVATCode(const Value: WideString); safecall;
    function Get_jrtTransaction: WideString; safecall;
    procedure Set_jrtTransaction(const Value: WideString); safecall;
    function Get_jrtCISTax: Double; safecall;
    procedure Set_jrtCISTax(Value: Double); safecall;
    function Get_jrtCISGross: Double; safecall;
    procedure Set_jrtCISGross(Value: Double); safecall;
    function Get_jrtCISEmployee: WideString; safecall;
    procedure Set_jrtCISEmployee(const Value: WideString); safecall;

    // ICOMJobRetention2
    function Get_jrtAppMode: Integer; safecall;
    procedure Set_jrtAppMode(Value: Integer); safecall;
  public
    Constructor Create;

    procedure InitJobRetention(EntSysObj: TEnterpriseSystem);
  End; { TCOMJobRetention }

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMJobRetention.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMJobRetention2);

  FEntSysObj := Nil;
End; { Create }

//-------------------------------------------------------------------------

procedure TCOMJobRetention.InitJobRetention(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FJobRetention := FEntSysObj.JobCosting.Job2.jrRetention;
end;

//-------------------------------------------------------------------------

function TCOMJobRetention.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FJobRetention.AccessRights);
end;

//------------------------------

function TCOMJobRetention.Get_jrtAnalysisCode: WideString;
begin
  Result := FJobRetention.jrtAnalysisCode;
end;

procedure TCOMJobRetention.Set_jrtAnalysisCode(const Value: WideString);
begin
  FJobRetention.jrtAnalysisCode := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtOriginalCurrency: Integer;
begin
  Result := FJobRetention.jrtOriginalCurrency;
end;

procedure TCOMJobRetention.Set_jrtOriginalCurrency(Value: Integer);
begin
  FJobRetention.jrtOriginalCurrency := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtYear: Integer;
begin
  Result := FJobRetention.jrtYear;
end;

procedure TCOMJobRetention.Set_jrtYear(Value: Integer);
begin
  FJobRetention.jrtYear := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtPeriod: Integer;
begin
  Result := FJobRetention.jrtPeriod;
end;

procedure TCOMJobRetention.Set_jrtPeriod(Value: Integer);
begin
  FJobRetention.jrtPeriod := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtPosted: WordBool;
begin
  Result := FJobRetention.jrtPosted;
end;

procedure TCOMJobRetention.Set_jrtPosted(Value: WordBool);
begin
  FJobRetention.jrtPosted := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtPercent: Double;
begin
  Result := FJobRetention.jrtPercent;
end;

procedure TCOMJobRetention.Set_jrtPercent(Value: Double);
begin
  FJobRetention.jrtPercent := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtCurrency: Integer;
begin
  Result := FJobRetention.jrtCurrency;
end;

procedure TCOMJobRetention.Set_jrtCurrency(Value: Integer);
begin
  FJobRetention.jrtCurrency := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtValue: Double;
begin
  Result := FJobRetention.jrtValue;
end;

procedure TCOMJobRetention.Set_jrtValue(Value: Double);
begin
  FJobRetention.jrtValue := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtJobCode: WideString;
begin
  Result := FJobRetention.jrtJobCode;
end;

procedure TCOMJobRetention.Set_jrtJobCode(const Value: WideString);
begin
  FJobRetention.jrtJobCode := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtCreditDoc: WideString;
begin
  Result := FJobRetention.jrtCreditDoc;
end;

procedure TCOMJobRetention.Set_jrtCreditDoc(const Value: WideString);
begin
  FJobRetention.jrtCreditDoc := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtExpiryDate: WideString;
begin
  Result := FJobRetention.jrtExpiryDate;
end;

procedure TCOMJobRetention.Set_jrtExpiryDate(const Value: WideString);
begin
  FJobRetention.jrtExpiryDate := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtInvoiced: WordBool;
begin
  Result := FJobRetention.jrtInvoiced;
end;

procedure TCOMJobRetention.Set_jrtInvoiced(Value: WordBool);
begin
  FJobRetention.jrtInvoiced := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtAcCode: WideString;
begin
  Result := FJobRetention.jrtAcCode;
end;

procedure TCOMJobRetention.Set_jrtAcCode(const Value: WideString);
begin
  FJobRetention.jrtAcCode := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtEntryDate: WideString;
begin
  Result := FJobRetention.jrtEntryDate;
end;

procedure TCOMJobRetention.Set_jrtEntryDate(const Value: WideString);
begin
  FJobRetention.jrtEntryDate := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtCostCentre: WideString;
begin
  Result := FJobRetention.jrtCostCentre;
end;

procedure TCOMJobRetention.Set_jrtCostCentre(const Value: WideString);
begin
  FJobRetention.jrtCostCentre := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtDepartment: WideString;
begin
  Result := FJobRetention.jrtDepartment;
end;

procedure TCOMJobRetention.Set_jrtDepartment(const Value: WideString);
begin
  FJobRetention.jrtDepartment := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtDefVATCode: WideString;
begin
  Result := FJobRetention.jrtDefVATCode;
end;

procedure TCOMJobRetention.Set_jrtDefVATCode(const Value: WideString);
begin
  FJobRetention.jrtDefVATCode := WideStrToChar (Value, ' ');
end;

//------------------------------

function TCOMJobRetention.Get_jrtTransaction: WideString;
begin
  Result := FJobRetention.jrtTransaction;
end;

procedure TCOMJobRetention.Set_jrtTransaction(const Value: WideString);
begin
  FJobRetention.jrtTransaction := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtCISTax: Double;
begin
  Result := FJobRetention.jrtCISTax;
end;

procedure TCOMJobRetention.Set_jrtCISTax(Value: Double);
begin
  FJobRetention.jrtCISTax := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtCISGross: Double;
begin
  Result := FJobRetention.jrtCISGross;
end;

procedure TCOMJobRetention.Set_jrtCISGross(Value: Double);
begin
  FJobRetention.jrtCISGross := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtCISEmployee: WideString;
begin
  Result := FJobRetention.jrtCISEmployee;
end;

procedure TCOMJobRetention.Set_jrtCISEmployee(const Value: WideString);
begin
  FJobRetention.jrtCISEmployee := Value;
end;

//------------------------------

function TCOMJobRetention.Get_jrtAppMode: Integer;
begin
  Result := (FJobRetention As TAbsJobRetention2).jrtAppMode;
end;

procedure TCOMJobRetention.Set_jrtAppMode(Value: Integer);
begin
  (FJobRetention As TAbsJobRetention2).jrtAppMode := Value;
end;

//=========================================================================

end.
