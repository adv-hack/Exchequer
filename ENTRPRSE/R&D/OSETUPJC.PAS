unit oSetupJC;

interface

Uses Forms, SysUtils, GlobVar, VarConst, CustAbsU, CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TCISRateSetup = Class(TAbsCISRateSetup)
  Private
    FRateCode : CISTaxType;
  Protected
    Function GetCode : Char; Override;
    Function GetDescription : cuStr10; Override;
    Function GetRate : Double; Override;
    Function GetGLCode : LongInt; Override;
    Function GetCostCentre : cuStr3; Override;
    Function GetDepartment : cuStr3; Override;
  Public
    Constructor Create (Const RateCode : CISTaxType);
  End; { TCISRateSetup }

  //------------------------------

  TCISCounterSetup = Class(TAbsCISCounterSetup)
  Private
    FVoucherIdx : Byte;
  Protected
    Function GetPrefix : cuStr3; Override;
    Function GetCounter : Int64; Override;
  Public
    Constructor Create (Const VoucherIdx : Byte);
  End; { TCISCounterSetup }

  //------------------------------

  TCISSetup = Class(TAbsCISSetup2)
  Private
    FCISRates    : Array [CISTaxType] Of TCISRateSetup;
    FCISVouchers : Array [4..6] Of TCISCounterSetup;
  Protected
    Function GetInterval : Byte; Override;
    Function GetAutoSetPeriod : Boolean; Override;
    Function GetReturnDate : cuLongDate; Override;
    Function GetTaxRef : cuStr20; Override;
    Function GetDefaultVatCode : Char; Override;
    Function GetFolioNumber : LongInt; Override;
    Function GetRate(RateCode : cuCISTaxType) : TAbsCISRateSetup; Override;
    Function GetVoucherCounter(VoucherType: cuCISVoucherType) : TAbsCISCounterSetup; Override;

    // TAbsCISSetup2
    Function GetContractorCertNo : ShortString; Override;
    Function ContractorCertExpiry : cuLongDate; Override;
    Function GetContractorCertType : Byte; Override;
  Public
    Constructor Create;
    Destructor  Destroy; Override;
  End; { TCISSetup }

  //-------------------------------------------------------------------------

  TJobCostingSetup = Class(TAbsJobCostingSetup)
  Protected
    Function GetUsePPIsForTimeSheets : Boolean; Override;
    Function GetSplitJobBudgetsByPeriod : Boolean; Override;
    Function GetPPISupAccount : cuStr6; Override;
    Function GetJobCategory(Index: cuJobCategoryType) : cuStr20; Override;
    Function GetCheckJobBudget : Boolean; Override;
    Function GetJobCostingGLCtrlCodes(Index: cuSystemSetupJobGLCtrlType) : LongInt; Override;
  End; { TJobCostingSetup }


implementation

//=========================================================================

constructor TCISRateSetup.Create(const RateCode: CISTaxType);
begin
  Inherited Create;

  FRateCode := RateCode;
end;

//-------------------------------------------------------------------------

Function TCISRateSetup.GetCode : Char;
Begin
  Result := SyssCIS^.CISRates.CISRate[FRateCode].Code;
End;

Function TCISRateSetup.GetDescription : cuStr10;
Begin
  Result := SyssCIS^.CISRates.CISRate[FRateCode].Desc;
End;

Function TCISRateSetup.GetRate : Double;
Begin
  Result := SyssCIS^.CISRates.CISRate[FRateCode].Rate;
End;

Function TCISRateSetup.GetGLCode : LongInt;
Begin
  Result := SyssCIS^.CISRates.CISRate[FRateCode].GLCode;
End;

Function TCISRateSetup.GetCostCentre : cuStr3;
Begin
  Result := SyssCIS^.CISRates.CISRate[FRateCode].RCCDep[BOn];
End;

Function TCISRateSetup.GetDepartment : cuStr3;
Begin
  Result := SyssCIS^.CISRates.CISRate[FRateCode].RCCDep[BOff];
End;

//=========================================================================

constructor TCISCounterSetup.Create(const VoucherIdx: Byte);
begin
  Inherited Create;

  FVoucherIdx := VoucherIdx;
end;

//-------------------------------------------------------------------------

Function TCISCounterSetup.GetPrefix : cuStr3;
Begin
  Result := SyssCIS^.CISRates.CisVouchers[FVoucherIdx].Prefix;
End;

Function TCISCounterSetup.GetCounter : Int64;
Begin
  Result := SyssCIS^.CISRates.CisVouchers[FVoucherIdx].Counter;
End;

//=========================================================================

constructor TCISSetup.Create;
Var
  I : CISTaxType;
  J : Byte;
begin
  Inherited Create;

  // Create sub-objects for CISRate and CISVouchers arrays
  For I := Low(FCISRates) To High(FCISRates) Do
    FCISRates[I] := TCISRateSetup.Create(I);

  For J := Low(FCISVouchers) To High(FCISVouchers) Do
    FCISVouchers[J] := TCISCounterSetup.Create(J);
end;

//------------------------------

destructor TCISSetup.Destroy;
Var
  I : CISTaxType;
  J : Byte;
begin
  // Destroy sub-objects for CISRate and CISVouchers arrays
  For I := Low(FCISRates) To High(FCISRates) Do
    FreeAndNIL(FCISRates[I]);
  For J := Low(FCISVouchers) To High(FCISVouchers) Do
    FreeAndNIL(FCISVouchers[J]);

  inherited;
end;

//-------------------------------------------------------------------------

Function TCISSetup.GetInterval : Byte;
Begin
  Result := SyssCIS^.CISRates.CISInterval;
End;

Function TCISSetup.GetAutoSetPeriod : Boolean;
Begin
  Result := SyssCIS^.CISRates.CISAutoSetPr;
End;

Function TCISSetup.GetReturnDate : cuLongDate;
Begin
  Result := SyssCIS^.CISRates.CISReturnDate;
End;

Function TCISSetup.GetTaxRef : cuStr20;
Begin
  Result := SyssCIS^.CISRates.CISTaxRef;
End;

Function TCISSetup.GetDefaultVatCode : Char;
Begin
  Result := SyssCIS^.CISRates.CISVATCode;
End;

Function TCISSetup.GetFolioNumber : LongInt;
Begin
  Result := SyssCIS^.CISRates.CISVFolio;
End;

Function TCISSetup.GetRate(RateCode : cuCISTaxType) : TAbsCISRateSetup;
Begin
  Result := FCISRates[CISTaxType(RateCode)];
End;

Function TCISSetup.GetVoucherCounter(VoucherType: cuCISVoucherType) : TAbsCISCounterSetup;
Begin
  Result := FCISVouchers[Ord(VoucherType)];
End;

Function TCISSetup.GetContractorCertNo : ShortString;
Begin
  Result := SyssCIS^.CISRates.JCertNo;
End;

Function TCISSetup.ContractorCertExpiry : cuLongDate;
Begin
  Result := SyssCIS^.CISRates.JCertExpiry;
End;

Function TCISSetup.GetContractorCertType : Byte;
Begin
  Result := SyssCIS^.CISRates.JCISType;
End;

//=========================================================================

Function TJobCostingSetup.GetUsePPIsForTimeSheets : Boolean;
Begin
  Result := SyssJob^.JobSetup.GenPPI;
End;

Function TJobCostingSetup.GetSplitJobBudgetsByPeriod : Boolean;
Begin
  Result := SyssJob^.JobSetup.PeriodBud;
End;

Function TJobCostingSetup.GetPPISupAccount : cuStr6;
Begin
  Result := SyssJob^.JobSetup.PPIAcCode;
End;

Function TJobCostingSetup.GetJobCategory(Index: cuJobCategoryType) : cuStr20;
Begin
  Result := SyssJob^.JobSetup.SummDesc[Succ(Ord(Index))]
End;

Function TJobCostingSetup.GetCheckJobBudget : Boolean;
Begin
  Result := Syss.WarnJC;
End;

Function TJobCostingSetup.GetJobCostingGLCtrlCodes(Index: cuSystemSetupJobGLCtrlType) : LongInt;
Begin
  Result := SyssJob^.JobSetup.EmployeeNom[Ord(Index) + 1, Boff];
End;

//=========================================================================

end.
