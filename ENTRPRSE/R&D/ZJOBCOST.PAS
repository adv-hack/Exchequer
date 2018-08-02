unit zJobCost;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, zCISVouc, zEmploye, zJob,
  zAnalCod, zTimeRat;

type
  TCOMJobCosting = class(TAutoIntfObject, ICOMJobCosting)
  private
    FEntSysObj : TEnterpriseSystem;
    FComSysObj : TObject;

    FCISVoucherO : TCOMCISVoucher;
    FCISVoucherI : ICOMCISVoucher;

    FEmployeeO   : TCOMEmployee;
    FEmployeeI   : ICOMEmployee;

    FJobAnalO    : TCOMJobAnalysis;
    FJobAnalI    : ICOMJobAnalysis;

    FTimeRateO   : TCOMTimeRate;
    FTimeRateI   : ICOMTimeRate;
  protected
    { Property methods }
    function Get_CISVoucher: ICOMCISVoucher; safecall;
    function Get_Employee: ICOMEmployee; safecall;
    function Get_Job2: ICOMJob2; safecall;
    function Get_JobAnalysis: ICOMJobAnalysis; safecall;
    function Get_TimeRate: ICOMTimeRate; safecall;
  public
    Constructor Create(ComSysObj : TObject);
    Destructor Destroy; Override;

    procedure InitJobCosting(EntSysObj: TEnterpriseSystem);
  End; { TCOMJobCosting }


implementation

uses ComServ, CustIntU, zEvData, ZUtils;

//=========================================================================

Constructor TCOMJobCosting.Create(ComSysObj : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMJobCosting);

  FEntSysObj := Nil;
  FComSysObj := ComSysObj;

  // Create sub-objects
  FCISVoucherO := NIL;
  FCISVoucherI := NIL;

  FEmployeeO := NIL;
  FEmployeeI := NIL;

  FJobAnalO := NIL;
  FJobAnalI := NIL;

  FTimeRateO := NIL;
  FTimeRateI := NIL;
End; { Create }

//------------------------------

destructor TCOMJobCosting.Destroy;
begin
  // Destroy Sub-objects
  FCISVoucherO := NIL;
  FCISVoucherI := NIL;  // Destroys object

  FEmployeeO := NIL;
  FEmployeeI := NIL;    // Destroys object

  FJobAnalO := NIL;
  FJobAnalI := NIL;     // Destroys object

  FTimeRateO := NIL;
  FTimeRateI := NIL;    // Destroys object

  FComSysObj := NIL;
  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMJobCosting.InitJobCosting(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;

  // Init sub-objects
  If Assigned(FCISVoucherO) Then FCISVoucherO.InitCISVoucher(EntSysObj);
  If Assigned(FEmployeeO) Then FEmployeeO.InitEmployee(EntSysObj);
  // Job already done in TCOMEventData
  If Assigned(FJobAnalO) Then FJobAnalO.InitJobAnalysis(EntSysObj);
  If Assigned(FTimeRateO) Then FTimeRateO.InitTimeRate(EntSysObj);
end;

//-------------------------------------------------------------------------

function TCOMJobCosting.Get_CISVoucher: ICOMCISVoucher;
begin
  If (Not Assigned(FCISVoucherO)) Then Begin
    { Create and initialise CIS Voucher sub-object }
    FCISVoucherO := TCOMCISVoucher.Create;
    FCISVoucherO.InitCISVoucher(FEntSysObj);

    FCISVoucherI := FCISVoucherO;
  End; { If (Not Assigned(FCISVoucherO)) }

  Result := FCISVoucherI;
end;

//------------------------------

function TCOMJobCosting.Get_Employee: ICOMEmployee;
begin
  If (Not Assigned(FEmployeeO)) Then Begin
    { Create and initialise Employee sub-object }
    FEmployeeO := TCOMEmployee.Create;
    FEmployeeO.InitEmployee(FEntSysObj);

    FEmployeeI := FEmployeeO;
  End; { If (Not Assigned(FEmployeeO)) }

  Result := FEmployeeI;
end;

//------------------------------

function TCOMJobCosting.Get_Job2: ICOMJob2;
begin
  Result := (FComSysObj As TCOMEventData).JobI;
end;

//------------------------------

function TCOMJobCosting.Get_JobAnalysis: ICOMJobAnalysis;
begin
  If (Not Assigned(FJobAnalO)) Then Begin
    { Create and initialise Job Analysis Code sub-object }
    FJobAnalO := TCOMJobAnalysis.Create;
    FJobAnalO.InitJobAnalysis(FEntSysObj);

    FJobAnalI := FJobAnalO;
  End; { If (Not Assigned(FJobAnalO)) }

  Result := FJobAnalI;
end;

//------------------------------

function TCOMJobCosting.Get_TimeRate: ICOMTimeRate;
begin
  If (Not Assigned(FTimeRateO)) Then Begin
    { Create and initialise Time Rate sub-object }
    FTimeRateO := TCOMTimeRate.Create;
    FTimeRateO.InitTimeRate(FEntSysObj);

    FTimeRateI := FTimeRateO;
  End; { If (Not Assigned(FTimeRateO)) }

  Result := FTimeRateI;
end;

//=========================================================================

end.
