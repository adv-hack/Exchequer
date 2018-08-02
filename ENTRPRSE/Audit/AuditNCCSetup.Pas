Unit AuditNCCSetup;

Interface

Uses Classes, AuditBase, VarConst, GlobVar;

Type
  TNCCSetupAudit = Class (TAuditBase)
  Private
    FBeforeNCCSetup : Sysrec;
    FAfterNCCSetup  : Sysrec;

    // Use internal TBits to track what has changed - it will be set in NeedAuditEntry and re-used in WriteAuditData
    FChangedData : TBits;
  Protected
    // IBaseAudit
    Function GetBeforeData : Pointer; Override;
    Procedure SetBeforeData (Value : Pointer); Override;
    Function GetAfterData : Pointer; Override;
    Procedure SetAfterData (Value : Pointer); Override;

    // TAuditBase
    Function NeedAuditEntry : Boolean; Override;
    Procedure WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);  Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

Implementation

Uses SysUtils, ETDateU;

Const
  fldInput                      = 0;
  fldOutput                     = 1;
  fldDebtorsCtrl                = 2;
  fldCreditorsCtrl              = 3;
  fldSettlementDiscGiven        = 4;
  fldSettlementDiscTaken        = 5;
  fldLineDiscountGiven          = 6;
  fldLineDiscountTaken          = 7;
  fldProfitLostBrghtFwd         = 8;
  fldCurrencyVariance           = 9;
  fldUnrealisedCurrDiff         = 10;
  fldPLACStart                  = 11;
  fldPLACFinish                 = 12;
  fldFreightUpliftCtrl          = 13;
  fldSalesAccrualCtrl           = 14;
  fldPurchAccrualCtrl           = 15;
  fldReturnsRestockCharge       = 16;

  TotFields = fldReturnsRestockCharge+1;

//=========================================================================

Constructor TNCCSetupAudit.Create;
Begin // Create
  Inherited Create;
  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TNCCSetupAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TNCCSetupAudit.GetBeforeData : Pointer;
Begin
  Result := @FBeforeNCCSetup;
End;

Procedure TNCCSetupAudit.SetBeforeData (Value : Pointer);
Begin
  Move (Value^, FBeforeNCCSetup, SizeOf(FBeforeNCCSetup));
End;

//------------------------------

Function TNCCSetupAudit.GetAfterData : Pointer;
Begin
  Result := @FAfterNCCSetup;
End;

Procedure TNCCSetupAudit.SetAfterData (Value : Pointer);
Begin
  Move (Value^, FAfterNCCSetup, SizeOf(FAfterNCCSetup));
End;

//-------------------------------------------------------------------------

Function TNCCSetupAudit.NeedAuditEntry : Boolean;
Var
  I              : SmallInt;
Begin

  // We will flag all the data that has been changed
  FChangedData[fldInput]                := (FBeforeNCCSetup.NomCtrlCodes[InVAT]      <>   FAfterNCCSetup.NomCtrlCodes[InVAT]);
  FChangedData[fldOutput]               := (FBeforeNCCSetup.NomCtrlCodes[OutVAT]     <>   FAfterNCCSetup.NomCtrlCodes[OutVAT]);
  FChangedData[fldDebtorsCtrl]          := (FBeforeNCCSetup.NomCtrlCodes[Debtors]    <>   FAfterNCCSetup.NomCtrlCodes[Debtors]);
  FChangedData[fldCreditorsCtrl]        := (FBeforeNCCSetup.NomCtrlCodes[Creditors]  <>   FAfterNCCSetup.NomCtrlCodes[Creditors]);
  FChangedData[fldSettlementDiscGiven]  := (FBeforeNCCSetup.NomCtrlCodes[DiscountGiven] <> FAfterNCCSetup.NomCtrlCodes[DiscountGiven]);
  FChangedData[fldSettlementDiscTaken]  := (FBeforeNCCSetup.NomCtrlCodes[DiscountTaken] <> FAfterNCCSetup.NomCtrlCodes[DiscountTaken]);
  FChangedData[fldLineDiscountGiven]    := (FBeforeNCCSetup.NomCtrlCodes[LDiscGiven] <>   FAfterNCCSetup.NomCtrlCodes[LDiscGiven]);
  FChangedData[fldLineDiscountTaken]    := (FBeforeNCCSetup.NomCtrlCodes[LDiscTaken] <>   FAfterNCCSetup.NomCtrlCodes[LDiscTaken]);
  FChangedData[fldProfitLostBrghtFwd]   := (FBeforeNCCSetup.NomCtrlCodes[ProfitBF]   <>   FAfterNCCSetup.NomCtrlCodes[ProfitBF]);
  FChangedData[fldCurrencyVariance]     := (FBeforeNCCSetup.NomCtrlCodes[CurrVar]    <>   FAfterNCCSetup.NomCtrlCodes[CurrVar]);
  FChangedData[fldUnrealisedCurrDiff]   := (FBeforeNCCSetup.NomCtrlCodes[UnRCurrVar] <>   FAfterNCCSetup.NomCtrlCodes[UnRCurrVar]);
  FChangedData[fldPLACStart]            := (FBeforeNCCSetup.NomCtrlCodes[PLStart]    <>   FAfterNCCSetup.NomCtrlCodes[PLStart]);
  FChangedData[fldPLACFinish]           := (FBeforeNCCSetup.NomCtrlCodes[PLEnd]      <>   FAfterNCCSetup.NomCtrlCodes[PLEnd]);
  FChangedData[fldFreightUpliftCtrl]    := (FBeforeNCCSetup.NomCtrlCodes[FreightNC]  <>   FAfterNCCSetup.NomCtrlCodes[FreightNC]);
  FChangedData[fldSalesAccrualCtrl]     := (FBeforeNCCSetup.NomCtrlCodes[SalesComm]  <>   FAfterNCCSetup.NomCtrlCodes[SalesComm]);
  FChangedData[fldPurchAccrualCtrl]     := (FBeforeNCCSetup.NomCtrlCodes[PurchComm]  <>   FAfterNCCSetup.NomCtrlCodes[PurchComm]);
  FChangedData[fldReturnsRestockCharge] := (FBeforeNCCSetup.NomCtrlCodes[RetSurcharge] <> FAfterNCCSetup.NomCtrlCodes[RetSurcharge]);

  // Run through the flag checking for changes
  Result := False;
  For I := 0 To (FChangedData.Size - 1) Do
  Begin
    If FChangedData[I] Then
    Begin
      Result := True;
      Break;
    End;
  End;

End;

//-------------------------------------------------------------------------

Procedure TNCCSetupAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
Begin
  If (Destination = adAuditTrail) Then
  Begin
    // MH 13/02/2013 v7.0.2: Added missing subtitle
    WriteAuditSubTitle (AuditStrings, 'System Setup - GL Control Codes Edited', '');
    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then                                        //   Max 20 chars for descriptions
      Begin                                                          //            1         2
        Case I Of                                                    //   12345678901234567890
            fldInput                    : WriteDataChange (AuditStrings, CCVatName^+' Input',    IntToStr(FBeforeNCCSetup.NomCtrlCodes[InVAT]), IntToStr(FAfterNCCSetup.NomCtrlCodes[InVAT]));
            fldOutput                   : WriteDataChange (AuditStrings, CCVatName^+' Output',   IntToStr(FBeforeNCCSetup.NomCtrlCodes[OutVAT]), IntToStr(FAfterNCCSetup.NomCtrlCodes[OutVAT]));
            fldDebtorsCtrl              : WriteDataChange (AuditStrings, 'Debtors Ctrl A/C',     IntToStr(FBeforeNCCSetup.NomCtrlCodes[Debtors]), IntToStr(FAfterNCCSetup.NomCtrlCodes[Debtors]));
            fldCreditorsCtrl            : WriteDataChange (AuditStrings, 'Creditors Ctrl A/C',   IntToStr(FBeforeNCCSetup.NomCtrlCodes[Creditors]), IntToStr(FAfterNCCSetup.NomCtrlCodes[Creditors]));
            fldSettlementDiscGiven      : WriteDataChange (AuditStrings, 'PromptPay Disc Given', IntToStr(FBeforeNCCSetup.NomCtrlCodes[DiscountGiven]), IntToStr(FAfterNCCSetup.NomCtrlCodes[DiscountGiven]));
            fldSettlementDiscTaken      : WriteDataChange (AuditStrings, 'PromptPay Disc Taken', IntToStr(FBeforeNCCSetup.NomCtrlCodes[DiscountTaken]), IntToStr(FAfterNCCSetup.NomCtrlCodes[DiscountTaken]));
            fldLineDiscountGiven        : WriteDataChange (AuditStrings, 'Line Discounts Given', IntToStr(FBeforeNCCSetup.NomCtrlCodes[LDiscGiven]), IntToStr(FAfterNCCSetup.NomCtrlCodes[LDiscGiven]));
            fldLineDiscountTaken        : WriteDataChange (AuditStrings, 'Line Discounts Taken', IntToStr(FBeforeNCCSetup.NomCtrlCodes[LDiscTaken]), IntToStr(FAfterNCCSetup.NomCtrlCodes[LDiscTaken]));
            fldProfitLostBrghtFwd       : WriteDataChange (AuditStrings, 'P&L Brought Fwd',      IntToStr(FBeforeNCCSetup.NomCtrlCodes[ProfitBF]), IntToStr(FAfterNCCSetup.NomCtrlCodes[ProfitBF]));
            fldCurrencyVariance         : WriteDataChange (AuditStrings, 'Currency Variance',    IntToStr(FBeforeNCCSetup.NomCtrlCodes[CurrVar]), IntToStr(FAfterNCCSetup.NomCtrlCodes[CurrVar]));
            fldUnrealisedCurrDiff       : WriteDataChange (AuditStrings, 'Unrealised Curr Diff', IntToStr(FBeforeNCCSetup.NomCtrlCodes[UnRCurrVar]), IntToStr(FAfterNCCSetup.NomCtrlCodes[UnRCurrVar]));
            fldPLACStart                : WriteDataChange (AuditStrings, 'P&L A/C Start',        IntToStr(FBeforeNCCSetup.NomCtrlCodes[PLStart]), IntToStr(FAfterNCCSetup.NomCtrlCodes[PLStart]));
            fldPLACFinish               : WriteDataChange (AuditStrings, 'P&L A/C End',          IntToStr(FBeforeNCCSetup.NomCtrlCodes[PLEnd]), IntToStr(FAfterNCCSetup.NomCtrlCodes[PLEnd]));
            fldFreightUpliftCtrl        : WriteDataChange (AuditStrings, 'Freight/Uplift Ctrl',  IntToStr(FBeforeNCCSetup.NomCtrlCodes[FreightNC]), IntToStr(FAfterNCCSetup.NomCtrlCodes[FreightNC]));
            fldSalesAccrualCtrl         : WriteDataChange (AuditStrings, 'Sales Accrual Ctrl',   IntToStr(FBeforeNCCSetup.NomCtrlCodes[SalesComm]), IntToStr(FAfterNCCSetup.NomCtrlCodes[SalesComm]));
            fldPurchAccrualCtrl         : WriteDataChange (AuditStrings, 'Purch Accrual Ctrl',   IntToStr(FBeforeNCCSetup.NomCtrlCodes[PurchComm]), IntToStr(FAfterNCCSetup.NomCtrlCodes[PurchComm]));
            fldReturnsRestockCharge     : WriteDataChange (AuditStrings, 'Returns Restock Chrg', IntToStr(FBeforeNCCSetup.NomCtrlCodes[RetSurcharge]), IntToStr(FAfterNCCSetup.NomCtrlCodes[RetSurcharge]));
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

