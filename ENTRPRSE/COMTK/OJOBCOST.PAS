unit oJobCost;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     MiscFunc, oJob, oJobType, OJobAnal, oEmploy, oRates, oVoucher,
     ExceptIntf;

type
  TJobCosting = class(TAutoIntfObjectEx, IJobCosting, IJobCosting2)
  private
    // Note: All properties protected to allow descendants access

    // Analysis Codes
    FAnalCodeO : TJobAnalysis;
    FAnalCodeI : IJobAnalysis;

    // Employees
    FEmployeeO : TEmployee;
    FEmployeeI : IEmployee3;

    // Global Time Rates
    FTimeRatesO : TTimeRates;
    FTimeRatesI : ITimeRates;

    // Jobs
    FJobO      : TJob;
    FJobI      : IJob4;

    // Job Types
    FJobTypeO  : TJobType;
    FJobTypeI  : IJobType;

    //CIS Vouchers
    FCISVoucherO : TCISVoucher;
    FCISVoucherI : ICISVoucher;

    // Main Toolkit object
    FToolkit   : TObject;
  protected
    // IJobCosting
    function  Get_Job: IJob; safecall;
    function  Get_JobType: IJobType; safecall;
    function  Get_JobAnalysis: IJobAnalysis; safecall;
    function  Get_Employee: IEmployee; safecall;
    function  Get_TimeRates: ITimeRates; safecall;

    //IJobCosting2
    function Get_CISVoucher: ICISVoucher; safecall;

    // Local methods
    Procedure InitObjects;
    function GetJobType : TJobType;
    function  GetJobAnalysis: TJobAnalysis;
    function GetJob : TJob;
    function GetEmployee : TEmployee;
    function GetTimeRates : TTimeRates;
    function GetJobI : IJob;
  public
    Constructor Create (Const Toolkit : TObject);
    Destructor Destroy; override;
    property JobTypeO : TJobType read GetJobType;
    property JobAnalysisO : TJobAnalysis read GetJobAnalysis;
    property JobO : TJob read GetJob;
    property EmployeeO : TEmployee read GetEmployee;
    property TimeRatesO : TTimeRates read GetTimeRates;
    property JobI : IJob read GetJobI;

  end; { TJobCosting }

implementation

uses ComServ, BtKeys1U;

{-------------------------------------------------------------------------------------------------}

constructor TJobCosting.Create(const Toolkit: TObject);
begin
  Inherited Create (ComServer.TypeLib, IJobCosting2);

  // ensure all sub-objects initialised correctly
  InitObjects;

  // record handle to Toolkit object
  FToolkit := Toolkit;
end;

{-----------------------------------------}

destructor TJobCosting.Destroy;
begin
  { Destroy sub-ojects }
  InitObjects;

  inherited;
end;

{-----------------------------------------}

Procedure TJobCosting.InitObjects;
Begin { InitObjects }
  // Analysis Codes
  FAnalCodeO := Nil;
  FAnalCodeI := Nil;

  // Employees
  FEmployeeO := Nil;
  FEmployeeI := Nil;

  // Global Time Rates
  FTimeRatesO := Nil;
  FTimeRatesI := Nil;

  // Jobs
  FJobO := Nil;
  FJobI := Nil;

  // Job Types
  FJobTypeO := Nil;
  FJobTypeI := Nil;

  //CIS Vouchers
  FCISVoucherO := nil;
  FCISVoucherI := nil;


  // Main Toolkit object
  FToolkit := Nil;
End; { InitObjects }

{-----------------------------------------}

function TJobCosting.Get_Job: IJob;
begin
  If (Not Assigned(FJobO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FJobO := CreateTJob (FToolkit, 11);

    FJobI := FJobO;
  End; { If (Not Assigned(FJobO)) }

  Result := FJobI;
end;

{-----------------------------------------}
function  TJobCosting.Get_JobType: IJobType;
begin
  If (Not Assigned(FJobTypeO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FJobTypeO := CreateTJobType (FToolkit, 15);

    FJobTypeI := FJobTypeO;
  End; { If (Not Assigned(FJobO)) }

  Result := FJobTypeI;
end;

{-----------------------------------------}
function TJobCosting.GetJobType : TJobType;
Var
  DummyI : IJobType;
begin
  // Check Supplier sub-object exists
  If Not Assigned(FJobTypeO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_JobType;

  // Return reference to Supplier Object
  Result := FJobTypeO;
end;

{-----------------------------------------}
function  TJobCosting.Get_JobAnalysis: IJobAnalysis; safecall;
begin
  If (Not Assigned(FAnalCodeO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FAnalCodeO := CreateTJobAnalysis (FToolkit, 16);

    FAnalCodeI := FAnalCodeO;
  End; { If (Not Assigned(FJobO)) }

  Result := FAnalCodeI;
end;

{-----------------------------------------}
function TJobCosting.GetJobAnalysis : TJobAnalysis;
Var
  DummyI : IJobAnalysis;
begin
  // Check Supplier sub-object exists
  If Not Assigned(FAnalCodeO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_JobAnalysis;

  // Return reference to Supplier Object
  Result := FAnalCodeO;
end;


{-----------------------------------------}
function TJobCosting.GetJob : TJob;
Var
  DummyI : IJob;
begin
  // Check Supplier sub-object exists
  If Not Assigned(FJobO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_Job;

  // Return reference to Supplier Object
  Result := FJobO;
end;

{-----------------------------------------}
function TJobCosting.Get_Employee : IEmployee;
begin
  If (Not Assigned(FEmployeeO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FEmployeeO := CreateTEmployee (FToolkit, 19);

    FEmployeeI := FEmployeeO;
  End; { If (Not Assigned(FJobO)) }

  Result := FEmployeeI;
end;

{-----------------------------------------}
function TJobCosting.GetEmployee : TEmployee;
Var
  DummyI : IEmployee;
begin
  // Check Supplier sub-object exists
  If Not Assigned(FEmployeeO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_Employee;

  // Return reference to Supplier Object
  Result := FEmployeeO;
end;

{-----------------------------------------}
function TJobCosting.Get_TimeRates : ITimeRates;
begin
  If (Not Assigned(FTimeRatesO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FTimeRatesO := CreateTTimeRates (FToolkit, 20);

    FTimeRatesI := FTimeRatesO;
  End; { If (Not Assigned(FJobO)) }
  FTimeRatesO.EmployeeCode := FullNomKey(-1);
  Result := FTimeRatesI;
end;

{-----------------------------------------}
function TJobCosting.GetTimeRates : TTimeRates;
Var
  DummyI : ITimeRates;
begin
  // Check Supplier sub-object exists
  If Not Assigned(FTimeRatesO) Then
    // Force creation of Supplier Object and Interface
    DummyI := Get_TimeRates;

  // Return reference to Supplier Object
  Result := FTimeRatesO;
end;

function TJobCosting.Get_CISVoucher: ICISVoucher;
begin
  If (Not Assigned(FCISVoucherO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FCISVoucherO := CreateTCISVoucher (FToolkit, 33);

    FCISVoucherI := FCISVoucherO;
  End; { If (Not Assigned(FJobO)) }

  Result := FCISVoucherI;
end;

function TJobCosting.GetJobI : IJob;
begin
  Result := Get_Job;
end;



end.
