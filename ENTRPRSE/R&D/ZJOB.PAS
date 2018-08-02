unit zJob;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, zJobAct, zJobBudg, zJobRet;

type
  TCOMJob = class(TAutoIntfObject, ICOMJob, ICOMJob2, ICOMJob3, ICOMJob4, ICOMJob5)
  private
    FEntSysObj : TEnterpriseSystem;

    FJobActualO : TCOMJobActual;
    FJobActualI : ICOMJobActual;

    FJobBudgetO : TCOMJobBudget;
    FJobBudgetI : ICOMJobBudget;

    FJobRetO    : TCOMJobRetention;
    FJobRetI    : ICOMJobRetention;
  protected
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;

    function  Get_jrJobCode: WideString; safecall;
    procedure Set_jrJobCode(const Value: WideString); safecall;
    function  Get_jrJobDesc: WideString; safecall;
    procedure Set_jrJobDesc(const Value: WideString); safecall;
    function  Get_jrJobFolio: Integer; safecall;
    function  Get_jrCustCode: WideString; safecall;
    procedure Set_jrCustCode(const Value: WideString); safecall;
    function  Get_jrJobCat: WideString; safecall;
    procedure Set_jrJobCat(const Value: WideString); safecall;
    function  Get_jrJobAltCode: WideString; safecall;
    procedure Set_jrJobAltCode(const Value: WideString); safecall;
    function  Get_jrCompleted: Integer; safecall;
    procedure Set_jrCompleted(Value: Integer); safecall;
    function  Get_jrContact: WideString; safecall;
    procedure Set_jrContact(const Value: WideString); safecall;
    function  Get_jrJobMan: WideString; safecall;
    procedure Set_jrJobMan(const Value: WideString); safecall;
    function  Get_jrChargeType: Smallint; safecall;
    procedure Set_jrChargeType(Value: Smallint); safecall;
    function  Get_jrQuotePrice: Double; safecall;
    procedure Set_jrQuotePrice(Value: Double); safecall;
    function  Get_jrCurrPrice: Smallint; safecall;
    procedure Set_jrCurrPrice(Value: Smallint); safecall;
    function  Get_jrStartDate: WideString; safecall;
    procedure Set_jrStartDate(const Value: WideString); safecall;
    function  Get_jrEndDate: WideString; safecall;
    procedure Set_jrEndDate(const Value: WideString); safecall;
    function  Get_jrRevEDate: WideString; safecall;
    procedure Set_jrRevEDate(const Value: WideString); safecall;
    function  Get_jrSORRef: WideString; safecall;
    procedure Set_jrSORRef(const Value: WideString); safecall;
    function  Get_jrVATCode: WideString; safecall;
    procedure Set_jrVATCode(const Value: WideString); safecall;
    function  Get_jrDept: WideString; safecall;
    procedure Set_jrDept(const Value: WideString); safecall;
    function  Get_jrCostCentre: WideString; safecall;
    procedure Set_jrCostCentre(const Value: WideString); safecall;
    function  Get_jrJobAnal: WideString; safecall;
    procedure Set_jrJobAnal(const Value: WideString); safecall;
    function  Get_jrJobType: WideString; safecall;
    procedure Set_jrJobType(const Value: WideString); safecall;
    function  Get_jrJobStat: Integer; safecall;
    procedure Set_jrJobStat(Value: Integer); safecall;
    function  Get_jrUserDef1: WideString; safecall;
    procedure Set_jrUserDef1(const Value: WideString); safecall;
    function  Get_jrUserDef2: WideString; safecall;
    procedure Set_jrUserDef2(const Value: WideString); safecall;
    function  Get_jrUserDef3: WideString; safecall;
    procedure Set_jrUserDef3(const Value: WideString); safecall;
    function  Get_jrUserDef4: WideString; safecall;
    procedure Set_jrUserDef4(const Value: WideString); safecall;

    // ICOMJob2
    function Get_jrActual: ICOMJobActual; safecall;
    function Get_jrBudget: ICOMJobBudget; safecall;
    function Get_jrRetention: ICOMJobRetention; safecall;

    // ICOMJob3
    function Get_jrDefRetentionCcy: Integer; safecall;
    procedure Set_jrDefRetentionCcy(Value: Integer); safecall;
    function Get_jrJPTRef: WideString; safecall;
    procedure Set_jrJPTRef(const Value: WideString); safecall;
    function Get_jrJSTRef: WideString; safecall;
    procedure Set_jrJSTRef(const Value: WideString); safecall;
    function Get_jrQSCode: WideString; safecall;
    procedure Set_jrQSCode(const Value: WideString); safecall;

    // ICOMJob4
    function Get_jrUserDef5: WideString; safecall;
    procedure Set_jrUserDef5(const Value: WideString); safecall;
    function Get_jrUserDef6: WideString; safecall;
    procedure Set_jrUserDef6(const Value: WideString); safecall;
    function Get_jrUserDef7: WideString; safecall;
    procedure Set_jrUserDef7(const Value: WideString); safecall;
    function Get_jrUserDef8: WideString; safecall;
    procedure Set_jrUserDef8(const Value: WideString); safecall;
    function Get_jrUserDef9: WideString; safecall;
    procedure Set_jrUserDef9(const Value: WideString); safecall;
    function Get_jrUserDef10: WideString; safecall;
    procedure Set_jrUserDef10(const Value: WideString); safecall;

    //ICOMJob5
    function  Get_jrAnonymised: WordBool; safecall;
    function  Get_jrAnonymisedDate: WideString; safecall;
    function  Get_jrAnonymisedTime: WideString; safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitJob(EntSysObj : TEnterpriseSystem);
  End; { TCOMJob }

implementation

uses ComServ, CustIntU, ZUtils;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMJob.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMJob5);

  // Initialise sub-objects
  FJobActualO := NIL;
  FJobActualI := NIL;

  FJobBudgetO := NIL;
  FJobBudgetI := NIL;

  FJobRetO    := NIL;
  FJobRetI    := NIL;
End; { Create }

Destructor TCOMJob.Destroy;
begin
  // Set all sub-object references to NIL to destroy them
  FJobActualO := NIL;
  FJobActualI := NIL;  // Destroys object

  FJobBudgetO := NIL;
  FJobBudgetI := NIL;  // Destroys object

  FJobRetO    := NIL;
  FJobRetI    := NIL;  // Destroys object

  Inherited Destroy;
end;

{-----------------------------------------}

Procedure TCOMJob.InitJob(EntSysObj : TEnterpriseSystem);
Begin { InitJob }
  FEntSysObj := EntSysObj;

  If Assigned(FJobActualO) Then FJobActualO.InitJobActual(EntSysObj);
  If Assigned(FJobBudgetO) Then FJobBudgetO.InitJobBudget(EntSysObj);
  If Assigned(FJobRetO) Then FJobRetO.InitJobRetention(EntSysObj);
End; { InitJob }

{-----------------------------------------}

function TCOMJob.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FEntSysObj.Job.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMJob.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := FEntSysObj.Job.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMJob.Get_jrJobCode: WideString;
Begin { Get_jrJobCode }
  Result := FEntSysObj.Job.jrJobCode;
End; { Get_jrJobCode }

procedure TCOMJob.Set_jrJobCode(const Value: WideString);
Begin { Set_jrJobCode }
  FEntSysObj.Job.jrJobCode := Value;
End; { Set_jrJobCode }

{-----------------------------------------}

function TCOMJob.Get_jrJobDesc: WideString;
Begin { Get_jrJobDesc }
  Result := FEntSysObj.Job.jrJobDesc;
End; { Get_jrJobDesc }

procedure TCOMJob.Set_jrJobDesc(const Value: WideString);
Begin { Set_jrJobDesc }
  FEntSysObj.Job.jrJobDesc := Value;
End; { Set_jrJobDesc }

{-----------------------------------------}

function TCOMJob.Get_jrJobFolio: Integer;
Begin { Get_jrJobFolio }
  Result := FEntSysObj.Job.jrJobFolio;
End; { Get_jrJobFolio }

{-----------------------------------------}

function TCOMJob.Get_jrCustCode: WideString;
Begin { Get_jrCustCode }
  Result := FEntSysObj.Job.jrCustCode;
End; { Get_jrCustCode }

procedure TCOMJob.Set_jrCustCode(const Value: WideString);
Begin { Set_jrCustCode }
  FEntSysObj.Job.jrCustCode := Value;
End; { Set_jrCustCode }

{-----------------------------------------}

function TCOMJob.Get_jrJobCat: WideString;
Begin { Get_jrJobCat }
  Result := FEntSysObj.Job.jrJobCat;
End; { Get_jrJobCat }

procedure TCOMJob.Set_jrJobCat(const Value: WideString);
Begin { Set_jrJobCat }
  FEntSysObj.Job.jrJobCat := Value;
End; { Set_jrJobCat }

{-----------------------------------------}

function TCOMJob.Get_jrJobAltCode: WideString;
Begin { Get_jrJobAltCode }
  Result := FEntSysObj.Job.jrJobAltCode;
End; { Get_jrJobAltCode }

procedure TCOMJob.Set_jrJobAltCode(const Value: WideString);
Begin { Set_jrJobAltCode }
  FEntSysObj.Job.jrJobAltCode := Value;
End; { Set_jrJobAltCode }

{-----------------------------------------}

function TCOMJob.Get_jrCompleted: Integer;
Begin { Get_jrCompleted }
  Result := FEntSysObj.Job.jrCompleted;
End; { Get_jrCompleted }

procedure TCOMJob.Set_jrCompleted(Value: Integer);
Begin { Set_jrCompleted }
  FEntSysObj.Job.jrCompleted := Value;
End; { Set_jrCompleted }

{-----------------------------------------}

function TCOMJob.Get_jrContact: WideString;
Begin { Get_jrContact }
  Result := FEntSysObj.Job.jrContact;
End; { Get_jrContact }

procedure TCOMJob.Set_jrContact(const Value: WideString);
Begin { Set_jrContact }
  FEntSysObj.Job.jrContact := Value;
End; { Set_jrContact }

{-----------------------------------------}

function TCOMJob.Get_jrJobMan: WideString;
Begin { Get_jrJobMan }
  Result := FEntSysObj.Job.jrJobMan;
End; { Get_jrJobMan }

procedure TCOMJob.Set_jrJobMan(const Value: WideString);
Begin { Set_jrJobMan }
  FEntSysObj.Job.jrJobMan := Value;
End; { Set_jrJobMan }

{-----------------------------------------}

function TCOMJob.Get_jrChargeType: SmallInt;
Begin { Get_jrChargeType }
  Result := FEntSysObj.Job.jrChargeType;
End; { Get_jrChargeType }

procedure TCOMJob.Set_jrChargeType(Value: SmallInt);
Begin { Set_jrChargeType }
  FEntSysObj.Job.jrChargeType := Value;
End; { Set_jrChargeType }

{-----------------------------------------}

function TCOMJob.Get_jrQuotePrice: Double;
Begin { Get_jrQuotePrice }
  Result := FEntSysObj.Job.jrQuotePrice;
End; { Get_jrQuotePrice }

procedure TCOMJob.Set_jrQuotePrice(Value: Double);
Begin { Set_jrQuotePrice }
  FEntSysObj.Job.jrQuotePrice := Value;
End; { Set_jrQuotePrice }

{-----------------------------------------}

function TCOMJob.Get_jrCurrPrice: SmallInt;
Begin { Get_jrCurrPrice }
  Result := FEntSysObj.Job.jrCurrPrice;
End; { Get_jrCurrPrice }

procedure TCOMJob.Set_jrCurrPrice(Value: SmallInt);
Begin { Set_jrCurrPrice }
  FEntSysObj.Job.jrCurrPrice := Value;
End; { Set_jrCurrPrice }

{-----------------------------------------}

function TCOMJob.Get_jrStartDate: WideString;
Begin { Get_jrStartDate }
  Result := FEntSysObj.Job.jrStartDate;
End; { Get_jrStartDate }

procedure TCOMJob.Set_jrStartDate(const Value: WideString);
Begin { Set_jrStartDate }
  FEntSysObj.Job.jrStartDate := Value;
End; { Set_jrStartDate }

{-----------------------------------------}

function TCOMJob.Get_jrEndDate: WideString;
Begin { Get_jrEndDate }
  Result := FEntSysObj.Job.jrEndDate;
End; { Get_jrEndDate }

procedure TCOMJob.Set_jrEndDate(const Value: WideString);
Begin { Set_jrEndDate }
  FEntSysObj.Job.jrEndDate := Value;
End; { Set_jrEndDate }

{-----------------------------------------}

function TCOMJob.Get_jrRevEDate: WideString;
Begin { Get_jrRevEDate }
  Result := FEntSysObj.Job.jrRevEDate;
End; { Get_jrRevEDate }

procedure TCOMJob.Set_jrRevEDate(const Value: WideString);
Begin { Set_jrRevEDate }
  FEntSysObj.Job.jrRevEDate := Value;
End; { Set_jrRevEDate }

{-----------------------------------------}

function TCOMJob.Get_jrSORRef: WideString;
Begin { Get_jrSORRef }
  Result := FEntSysObj.Job.jrSORRef;
End; { Get_jrSORRef }

procedure TCOMJob.Set_jrSORRef(const Value: WideString);
Begin { Set_jrSORRef }
  FEntSysObj.Job.jrSORRef := Value;
End; { Set_jrSORRef }

{-----------------------------------------}

function TCOMJob.Get_jrVATCode: WideString;
Begin { Get_jrVATCode }
  Result := FEntSysObj.Job.jrVATCode;
End; { Get_jrVATCode }

procedure TCOMJob.Set_jrVATCode(const Value: WideString);
Begin { Set_jrVATCode }
  FEntSysObj.Job.jrVATCode := WideStrToChar (Value, ' ');
End; { Set_jrVATCode }

{-----------------------------------------}

function TCOMJob.Get_jrDept: WideString;
Begin { Get_jrDept }
  Result := FEntSysObj.Job.jrDept;
End; { Get_jrDept }

procedure TCOMJob.Set_jrDept(const Value: WideString);
Begin { Set_jrDept }
  FEntSysObj.Job.jrDept := Value;
End; { Set_jrDept }

{-----------------------------------------}

function TCOMJob.Get_jrCostCentre: WideString;
Begin { Get_jrCostCentre }
  Result := FEntSysObj.Job.jrCostCentre;
End; { Get_jrCostCentre }

procedure TCOMJob.Set_jrCostCentre(const Value: WideString);
Begin { Set_jrCostCentre }
  FEntSysObj.Job.jrCostCentre := Value;
End; { Set_jrCostCentre }

{-----------------------------------------}

function TCOMJob.Get_jrJobAnal: WideString;
Begin { Get_jrJobAnal }
  Result := FEntSysObj.Job.jrJobAnal;
End; { Get_jrJobAnal }

procedure TCOMJob.Set_jrJobAnal(const Value: WideString);
Begin { Set_jrJobAnal }
  FEntSysObj.Job.jrJobAnal := Value;
End; { Set_jrJobAnal }

{-----------------------------------------}

function TCOMJob.Get_jrJobType: WideString;
Begin { Get_jrJobType }
  Result := FEntSysObj.Job.jrJobType;
End; { Get_jrJobType }

procedure TCOMJob.Set_jrJobType(const Value: WideString);
Begin { Set_jrJobType }
  FEntSysObj.Job.jrJobType := WideStrToChar (Value, ' ');
End; { Set_jrJobType }

{-----------------------------------------}

function TCOMJob.Get_jrJobStat: Integer;
Begin { Get_jrJobStat }
  Result := FEntSysObj.Job.jrJobStat;
End; { Get_jrJobStat }

procedure TCOMJob.Set_jrJobStat(Value: Integer);
Begin { Set_jrJobStat }
  FEntSysObj.Job.jrJobStat := Value;
End; { Set_jrJobStat }

{-----------------------------------------}

function TCOMJob.Get_jrUserDef1: WideString;
Begin { Get_jrUserDef1 }
  Result := FEntSysObj.Job.jrUserDef1;
End; { Get_jrUserDef1 }

procedure TCOMJob.Set_jrUserDef1(const Value: WideString);
Begin { Set_jrUserDef1 }
  FEntSysObj.Job.jrUserDef1 := Value;
End; { Set_jrUserDef1 }

{-----------------------------------------}

function TCOMJob.Get_jrUserDef2: WideString;
Begin { Get_jrUserDef2 }
  Result := FEntSysObj.Job.jrUserDef2;
End; { Get_jrUserDef2 }

procedure TCOMJob.Set_jrUserDef2(const Value: WideString);
Begin { Set_jrUserDef2 }
  FEntSysObj.Job.jrUserDef2 := Value;
End; { Set_jrUserDef2 }

{-----------------------------------------}

function TCOMJob.Get_jrUserDef3: WideString;
Begin { Get_jrUserDef3 }
  Result := FEntSysObj.Job.jrUserDef3;
End; { Get_jrUserDef3 }

procedure TCOMJob.Set_jrUserDef3(const Value: WideString);
Begin { Set_jrUserDef3 }
  FEntSysObj.Job.jrUserDef3 := Value;
End; { Set_jrUserDef3 }

{-----------------------------------------}

function TCOMJob.Get_jrUserDef4: WideString;
Begin { Get_jrUserDef4 }
  Result := FEntSysObj.Job.jrUserDef4;
End; { Get_jrUserDef4 }

procedure TCOMJob.Set_jrUserDef4(const Value: WideString);
Begin { Set_jrUserDef4 }
  FEntSysObj.Job.jrUserDef4 := Value;
End; { Set_jrUserDef4 }

//------------------------------

function TCOMJob.Get_jrActual: ICOMJobActual;
begin
  If (Not Assigned(FJobActualO)) Then Begin
    { Create and initialise the Job Actuals sub-object }
    FJobActualO := TCOMJobActual.Create;
    FJobActualO.InitJobActual(FEntSysObj);

    FJobActualI := FJobActualO;
  End; { If (Not Assigned(FJobActualO)) }

  Result := FJobActualI;
end;

//------------------------------

function TCOMJob.Get_jrBudget: ICOMJobBudget;
begin
  If (Not Assigned(FJobBudgetO)) Then Begin
    { Create and initialise the Job Budget sub-object }
    FJobBudgetO := TCOMJobBudget.Create;
    FJobBudgetO.InitJobBudget(FEntSysObj);

    FJobBudgetI := FJobBudgetO;
  End; { If (Not Assigned(FJobBudgetO)) }

  Result := FJobBudgetI;
end;

//------------------------------

function TCOMJob.Get_jrRetention: ICOMJobRetention;
begin
  If (Not Assigned(FJobRetO)) Then Begin
    { Create and initialise the Job Retention sub-object }
    FJobRetO := TCOMJobRetention.Create;
    FJobRetO.InitJobRetention(FEntSysObj);

    FJobRetI := FJobRetO;
  End; { If (Not Assigned(FJobRetO)) }

  Result := FJobRetI;
end;

//------------------------------

function TCOMJob.Get_jrDefRetentionCcy: Integer;
Begin
  Result := (FEntSysObj.Job As TAbsJob3).jrDefRetentionCcy;
End;

procedure TCOMJob.Set_jrDefRetentionCcy(Value: Integer);
Begin
  (FEntSysObj.Job As TAbsJob3).jrDefRetentionCcy := Value;
End;

{-----------------------------------------}

function TCOMJob.Get_jrJPTRef: WideString;
Begin
  Result := (FEntSysObj.Job As TAbsJob3).jrJPTRef;
End;

procedure TCOMJob.Set_jrJPTRef(const Value: WideString);
Begin
  (FEntSysObj.Job As TAbsJob3).jrJPTRef := Value;
End;

{-----------------------------------------}

function TCOMJob.Get_jrJSTRef: WideString;
Begin
  Result := (FEntSysObj.Job As TAbsJob3).jrJSTRef;
End;

procedure TCOMJob.Set_jrJSTRef(const Value: WideString);
Begin
  (FEntSysObj.Job As TAbsJob3).jrJSTRef := Value;
End;

{-----------------------------------------}

function TCOMJob.Get_jrQSCode: WideString;
Begin
  Result := (FEntSysObj.Job As TAbsJob3).jrQSCode;
End;

procedure TCOMJob.Set_jrQSCode(const Value: WideString);
Begin
  (FEntSysObj.Job As TAbsJob3).jrQSCode := Value;
End;

//=========================================================================

function TCOMJob.Get_jrUserDef10: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob4).jrUserDef10;
end;

function TCOMJob.Get_jrUserDef5: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob4).jrUserDef5;
end;

function TCOMJob.Get_jrUserDef6: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob4).jrUserDef6;
end;

function TCOMJob.Get_jrUserDef7: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob4).jrUserDef7;
end;

function TCOMJob.Get_jrUserDef8: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob4).jrUserDef8;
end;

function TCOMJob.Get_jrUserDef9: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob4).jrUserDef9;
end;

procedure TCOMJob.Set_jrUserDef10(const Value: WideString);
begin
  (FEntSysObj.Job As TAbsJob4).jrUserDef10 := Value;
end;

procedure TCOMJob.Set_jrUserDef5(const Value: WideString);
begin
  (FEntSysObj.Job As TAbsJob4).jrUserDef5 := Value;
end;

procedure TCOMJob.Set_jrUserDef6(const Value: WideString);
begin
  (FEntSysObj.Job As TAbsJob4).jrUserDef6 := Value;
end;

procedure TCOMJob.Set_jrUserDef7(const Value: WideString);
begin
  (FEntSysObj.Job As TAbsJob4).jrUserDef7 := Value;
end;

procedure TCOMJob.Set_jrUserDef8(const Value: WideString);
begin
  (FEntSysObj.Job As TAbsJob4).jrUserDef8 := Value;
end;

procedure TCOMJob.Set_jrUserDef9(const Value: WideString);
begin
  (FEntSysObj.Job As TAbsJob4).jrUserDef9 := Value;
end;

//AP 15/12/2017 ABSEXCH-19486:DLL + COM Customisation Support
function TCOMJob.Get_jrAnonymised: WordBool;
begin
  Result := (FEntSysObj.Job As TAbsJob5).jrAnonymised;
end;

function TCOMJob.Get_jrAnonymisedDate: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob5).jrAnonymisedDate;
end;

function TCOMJob.Get_jrAnonymisedTime: WideString;
begin
  Result := (FEntSysObj.Job As TAbsJob5).jrAnonymisedTime;
end;

end.

