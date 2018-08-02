unit oJobCost;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, oJob, ExWrap1U, oEmploye, oCISVouc, oTimeRat, oAnalCod,
     oJobAct, oJobBudg, oJobRet;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TJobCosting = Class(TAbsJobCosting)
  Private
    FCISVoucher  : TAbsCISVoucher;
    FEmployee    : TAbsEmployee;
    FEntSys      : TEnterpriseSystem;
    FJob         : TAbsJob2;
    FJobAnalysis : TAbsJobAnalysis;
    FTimeRate    : TAbsTimeRate;
  Protected
    // TAbsJobCosting methods
    Function GetCISVoucher : TAbsCISVoucher; Override;
    Function GetEmployee : TAbsEmployee; Override;
    Function GetJob2 : TAbsJob2; Override;
    Function GetJobAnalysis : TAbsJobAnalysis; Override;
    Function GetTimeRate : TAbsTimeRate; Override;

    // Internal Methods
    Function GetoCISVoucher : TCISVoucher;
    Function GetoEmployee : TEmployee;
    Function GetoJob : TJob;
    Function GetoJobActual : TJobActual;
    Function GetoJobAnalysis : TJobAnalysis;
    Function GetoJobBudget : TJobBudget;
    Function GetoJobRetention : TJobRetention;
    Function GetoTimeRate : TTimeRate;
  Public
    Property oCISVoucher   : TCISVoucher   Read GetoCISVoucher;
    Property oEmployee     : TEmployee     Read GetoEmployee;
    Property oJob          : TJob          Read GetoJob;
    Property oJobActual    : TJobActual    Read GetoJobActual;
    Property oJobAnalysis  : TJobAnalysis  Read GetoJobAnalysis;
    Property oJobBudget    : TJobBudget    Read GetoJobBudget;
    Property oJobRetention : TJobRetention Read GetoJobRetention;
    Property oTimeRate     : TTimeRate     Read GetoTimeRate;

    Constructor Create (Const hEntSys : TEnterpriseSystem; Const oJob : TAbsJob2);
    Destructor  Destroy; Override;

    Procedure Assign (Const WinId, HandlerId : LongInt;
                      Const ExLocal : TdExLocal);
  End; { TJobCosting }

implementation

//-------------------------------------------------------------------------

Constructor TJobCosting.Create (Const hEntSys : TEnterpriseSystem; Const oJob : TAbsJob2);
Begin
  Inherited Create;

  FEntSys := hEntSys;
  FJob := oJob;
  FCISVoucher := TCISVoucher.Create(FEntSys);
  FEmployee := TEmployee.Create(FEntSys);
  FJobAnalysis := TJobAnalysis.Create(FEntSys);
  FTimeRate := TTimeRate.Create(FEntSys);
End;

//-------------------------------------------------------------------------

Destructor TJobCosting.Destroy;
Begin { Destroy }
  FreeAndNIL(FCISVoucher);
  FreeAndNIL(FEmployee);
  FEntSys := NIL;
  FJob := NIL;
  FreeAndNIL(FJobAnalysis);
  FreeAndNIL(FTimeRate);

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TJobCosting.Assign (Const WinId, HandlerId : LongInt;
                              Const ExLocal : TdExLocal);
Begin { Assign }
  // NOTE: FJob already done from TEnterpriseSystem
  TCISVoucher(FCISVoucher).Assign(WinId, HandlerId, ExLocal.LJobDetl^);
  TEmployee(FEmployee).Assign(WinId, HandlerId, ExLocal.LJobMisc^);
  TJobAnalysis(FJobAnalysis).Assign(WinId, HandlerId, ExLocal.LJobMisc^);
  TTimeRate(FTimeRate).Assign(WinId, HandlerId, ExLocal.LJobCtrl^);
End; { Assign }

//-------------------------------------------------------------------------

Function TJobCosting.GetJob2 : TAbsJob2;
Begin
  Result := FJob;
End;

Function TJobCosting.GetoJob : TJob;
Begin
  Result := TJob(FJob);
End;

//------------------------------

Function TJobCosting.GetoJobActual : TJobActual;
Begin
  Result := TJob(FJob).oJobActual;
End;

Function TJobCosting.GetoJobBudget : TJobBudget;
Begin
  Result := TJob(FJob).oJobBudget;
End;

Function TJobCosting.GetoJobRetention : TJobRetention;
Begin
  Result := TJob(FJob).oJobRetention;
End;

//-------------------------------------------------------------------------

Function TJobCosting.GetCISVoucher : TAbsCISVoucher;
Begin
  Result := FCISVoucher;
End;

//------------------------------

Function TJobCosting.GetoCISVoucher : TCISVoucher;
Begin
  Result := TCISVoucher(FCISVoucher);
End;

//-------------------------------------------------------------------------

Function TJobCosting.GetEmployee : TAbsEmployee;
Begin
  Result := FEmployee;
End;

//------------------------------

Function TJobCosting.GetoEmployee : TEmployee;
Begin
  Result := TEmployee(FEmployee);
End;

//-------------------------------------------------------------------------

Function TJobCosting.GetJobAnalysis : TAbsJobAnalysis;
Begin
  Result := FJobAnalysis;
End;

//------------------------------

Function TJobCosting.GetoJobAnalysis : TJobAnalysis;
Begin
  Result := TJobAnalysis(FJobAnalysis);
End;
//-------------------------------------------------------------------------

Function TJobCosting.GetTimeRate : TAbsTimeRate;
Begin
  Result := FTimeRate;
End;

//------------------------------

Function TJobCosting.GetoTimeRate : TTimeRate;
Begin
  Result := TTimeRate(FTimeRate);
End;

//-------------------------------------------------------------------------

end.
