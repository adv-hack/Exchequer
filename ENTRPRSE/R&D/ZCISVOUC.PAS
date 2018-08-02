unit zCISVouc;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMCISVoucher = class(TAutoIntfObject, ICOMCISVoucher)
  private
    FEntSysObj : TEnterpriseSystem;
    FCISVoucher : TAbsCISVoucher;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_cvNumber: WideString; safecall;
    procedure Set_cvNumber(const Value: WideString); safecall;
    function Get_cvEmployee: WideString; safecall;
    procedure Set_cvEmployee(const Value: WideString); safecall;
    function Get_cvDate: WideString; safecall;
    procedure Set_cvDate(const Value: WideString); safecall;
    function Get_cvTransaction: WideString; safecall;
    procedure Set_cvTransaction(const Value: WideString); safecall;
    function Get_cvFolio: Integer; safecall;
    function Get_cvCertificateNo: WideString; safecall;
    procedure Set_cvCertificateNo(const Value: WideString); safecall;
    function Get_cvGrossTotal: Double; safecall;
    procedure Set_cvGrossTotal(Value: Double); safecall;
    function Get_cvType: Integer; safecall;
    procedure Set_cvType(Value: Integer); safecall;
    function Get_cvAutoTotalTax: Double; safecall;
    procedure Set_cvAutoTotalTax(Value: Double); safecall;
    function Get_cvManualTax: WordBool; safecall;
    procedure Set_cvManualTax(Value: WordBool); safecall;
    function Get_cvTaxableTotal: Double; safecall;
    procedure Set_cvTaxableTotal(Value: Double); safecall;
    function Get_cvCurrency: Integer; safecall;
    procedure Set_cvCurrency(Value: Integer); safecall;
    function Get_cvAddress(Index: Integer): WideString; safecall;
    procedure Set_cvAddress(Index: Integer; const Value: WideString); safecall;
    function Get_cvBehalf: WideString; safecall;
    procedure Set_cvBehalf(const Value: WideString); safecall;
    function Get_cvCorrection: WordBool; safecall;
    procedure Set_cvCorrection(Value: WordBool); safecall;
    function Get_cvTaxDue: Double; safecall;
    procedure Set_cvTaxDue(Value: Double); safecall;
    function Get_cvSupplier: WideString; safecall;
    procedure Set_cvSupplier(const Value: WideString); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitCISVoucher(EntSysObj: TEnterpriseSystem);
  End; { TCOMCISVoucher }


implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMCISVoucher.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMCISVoucher);

  FEntSysObj := Nil;
End; { Create }

//------------------------------

destructor TCOMCISVoucher.Destroy;
begin
  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMCISVoucher.InitCISVoucher(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FCISVoucher := FEntSysObj.JobCosting.CISVoucher;
end;

//-------------------------------------------------------------------------

function TCOMCISVoucher.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FCISVoucher.AccessRights);
end;

//------------------------------

function TCOMCISVoucher.Get_cvNumber: WideString;
begin
  Result := FCISVoucher.cvNumber;
end;

procedure TCOMCISVoucher.Set_cvNumber(const Value: WideString);
begin
  FCISVoucher.cvNumber := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvEmployee: WideString;
begin
  Result := FCISVoucher.cvEmployee;
end;

procedure TCOMCISVoucher.Set_cvEmployee(const Value: WideString);
begin
  FCISVoucher.cvEmployee := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvDate: WideString;
begin
  Result := FCISVoucher.cvDate;
end;

procedure TCOMCISVoucher.Set_cvDate(const Value: WideString);
begin
  FCISVoucher.cvDate := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvTransaction: WideString;
begin
  Result := FCISVoucher.cvTransaction;
end;

procedure TCOMCISVoucher.Set_cvTransaction(const Value: WideString);
begin
  FCISVoucher.cvTransaction := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvFolio: Integer;
begin
  Result := FCISVoucher.cvFolio;
end;

//------------------------------

function TCOMCISVoucher.Get_cvCertificateNo: WideString;
begin
  Result := FCISVoucher.cvCertificateNo;
end;

procedure TCOMCISVoucher.Set_cvCertificateNo(const Value: WideString);
begin
  FCISVoucher.cvCertificateNo := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvGrossTotal: Double;
begin
  Result := FCISVoucher.cvGrossTotal;
end;

procedure TCOMCISVoucher.Set_cvGrossTotal(Value: Double);
begin
  FCISVoucher.cvGrossTotal := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvType: Integer;
begin
  Result := FCISVoucher.cvType;
end;

procedure TCOMCISVoucher.Set_cvType(Value: Integer);
begin
  FCISVoucher.cvType := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvAutoTotalTax: Double;
begin
  Result := FCISVoucher.cvAutoTotalTax;
end;

procedure TCOMCISVoucher.Set_cvAutoTotalTax(Value: Double);
begin
  FCISVoucher.cvAutoTotalTax := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvManualTax: WordBool;
begin
  Result := FCISVoucher.cvManualTax;
end;

procedure TCOMCISVoucher.Set_cvManualTax(Value: WordBool);
begin
  FCISVoucher.cvManualTax := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvTaxableTotal: Double;
begin
  Result := FCISVoucher.cvTaxableTotal;
end;

procedure TCOMCISVoucher.Set_cvTaxableTotal(Value: Double);
begin
  FCISVoucher.cvTaxableTotal := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvCurrency: Integer;
begin
  Result := FCISVoucher.cvCurrency;
end;

procedure TCOMCISVoucher.Set_cvCurrency(Value: Integer);
begin
  FCISVoucher.cvCurrency := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvAddress(Index: Integer): WideString;
begin
  Result := FCISVoucher.cvAddress[Index];
end;

procedure TCOMCISVoucher.Set_cvAddress(Index: Integer; const Value: WideString);
begin
  FCISVoucher.cvAddress[Index] := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvBehalf: WideString;
begin
  Result := FCISVoucher.cvBehalf;
end;

procedure TCOMCISVoucher.Set_cvBehalf(const Value: WideString);
begin
  FCISVoucher.cvBehalf := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvCorrection: WordBool;
begin
  Result := FCISVoucher.cvCorrection;
end;

procedure TCOMCISVoucher.Set_cvCorrection(Value: WordBool);
begin
  FCISVoucher.cvCorrection := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvTaxDue: Double;
begin
  Result := FCISVoucher.cvTaxDue;
end;

procedure TCOMCISVoucher.Set_cvTaxDue(Value: Double);
begin
  FCISVoucher.cvTaxDue := Value;
end;

//------------------------------

function TCOMCISVoucher.Get_cvSupplier: WideString;
begin
  Result := FCISVoucher.cvSupplier;
end;

procedure TCOMCISVoucher.Set_cvSupplier(const Value: WideString);
begin
  FCISVoucher.cvSupplier := Value;
end;

//=========================================================================

end.
