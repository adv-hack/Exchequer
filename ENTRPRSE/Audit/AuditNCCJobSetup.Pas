Unit AuditNCCJobSetup;

Interface

Uses Classes, AuditBase, VarConst, GlobVar;

Type
  TNCCJobSetupAudit = Class (TAuditBase)
  Private
    FBeforeNCCJobSetup : JobSRecT;
    FAfterNCCJobSetup  : JobSRecT;

    GeneralSetFlag     : Boolean;

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
  fldOverhead                   = 0;
  fldProduction                 = 1;
  fldSubContract                = 2;

  flgUsePPIForTimeSheet         = 3;
  flgPPISuppAct                 = 4;
  flgSplitJobBudgets            = 5;
  flgIncUnpostedPurch           = 6;
  flgProtectApplication         = 7;
  flgUseAppDateForInv           = 8;
  flgDelayAppUntilCert          = 9;
  flgRevenue                    = 10;
  flgLabour                     = 11;
  flgSubContLabour              = 12;
  flgDirectExp1                 = 13;
  flgDirectExp2                 = 14;
  flgStockIssues                = 15;
  flgMaterials2                 = 16;
  flgOverheads                  = 17;
  flgOverheads2                 = 18;
  flgReceipts                   = 19;
  flgWorkInProgress             = 20;
  flgRetentionsSL               = 21;
  flgRetentionsPL               = 22;
  flgSaleDeductions             = 23;
  flgPurchDeductions            = 24;
  flgSalesApps                  = 25;
  flgPurchaseApps               = 26;


  TotFields = flgPurchaseApps+1;

//=========================================================================

Constructor TNCCJobSetupAudit.Create;
Begin // Create
  Inherited Create;
  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TNCCJobSetupAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TNCCJobSetupAudit.GetBeforeData : Pointer;
Begin
  Result := @FBeforeNCCJobSetup;
End;

Procedure TNCCJobSetupAudit.SetBeforeData (Value : Pointer);
Begin
  Move (Value^, FBeforeNCCJobSetup, SizeOf(FBeforeNCCJobSetup));
End;

//------------------------------

Function TNCCJobSetupAudit.GetAfterData : Pointer;
Begin
  Result := @FAfterNCCJobSetup;
End;

Procedure TNCCJobSetupAudit.SetAfterData (Value : Pointer);
Begin
  Move (Value^, FAfterNCCJobSetup, SizeOf(FAfterNCCJobSetup));
End;

//-------------------------------------------------------------------------

Function TNCCJobSetupAudit.NeedAuditEntry : Boolean;
Var
  I              : SmallInt;
Begin

   // Added new flag so if any details pertaining to General Settings screen have been changed then I will have a sub menu title to
   // depict this so that the customer does not get confused where the changes occured.
   GeneralSetFlag      := False;

   if ((FBeforeNCCJobSetup.JobSetup.GenPPI)        <>   (FAfterNCCJobSetup.JobSetup.GenPPI)) Or
       ((FBeforeNCCJobSetup.JobSetup.PPIAcCode)    <>   (FAfterNCCJobSetup.JobSetup.PPIAcCode)) Or
       ((FBeforeNCCJobSetup.JobSetup.PeriodBud)    <>   (FAfterNCCJobSetup.JobSetup.PeriodBud)) Or
       ((FBeforeNCCJobSetup.JobSetup.JCCommitPin)  <>   (FAfterNCCJobSetup.JobSetup.JCCommitPin)) Or
       ((FBeforeNCCJobSetup.JobSetup.JAInvDate)    <>   (FAfterNCCJobSetup.JobSetup.JAInvDate)) Or
       ((FBeforeNCCJobSetup.JobSetup.JADelayCert)  <>   (FAfterNCCJobSetup.JobSetup.JADelayCert)) Then
        GeneralSetFlag := True;

  // We will flag all the data that has been changed
  FChangedData[fldOverhead]             := (FBeforeNCCJobSetup.JobSetup.EmployeeNom[1,False]     <>   FAfterNCCJobSetup.JobSetup.EmployeeNom[1,False]);
  FChangedData[fldProduction]           := (FBeforeNCCJobSetup.JobSetup.EmployeeNom[2,False]     <>   FAfterNCCJobSetup.JobSetup.EmployeeNom[2,False]);
  FChangedData[fldSubContract]          := (FBeforeNCCJobSetup.JobSetup.EmployeeNom[3,False]     <>   FAfterNCCJobSetup.JobSetup.EmployeeNom[3,False]);

  // Added to deal with Job Costing options on the General Settings Screen
  FChangedData[flgUsePPIForTimeSheet]   := (FBeforeNCCJobSetup.JobSetup.GenPPI          <>    FAfterNCCJobSetup.JobSetup.GenPPI);
  FChangedData[flgPPISuppAct]           := (FBeforeNCCJobSetup.JobSetup.PPIAcCode       <>    FAfterNCCJobSetup.JobSetup.PPIAcCode);
  FChangedData[flgSplitJobBudgets]      := (FBeforeNCCJobSetup.JobSetup.PeriodBud       <>    FAfterNCCJobSetup.JobSetup.PeriodBud);

  FChangedData[flgIncUnpostedPurch]     := (FBeforeNCCJobSetup.JobSetup.JCCommitPin     <>    FAfterNCCJobSetup.JobSetup.JCCommitPin);
  FChangedData[flgProtectApplication]   := (FBeforeNCCJobSetup.JobSetup.JAInvDate       <>    FAfterNCCJobSetup.JobSetup.JAInvDate);
  FChangedData[flgDelayAppUntilCert]    := (FBeforeNCCJobSetup.JobSetup.JADelayCert     <>    FAfterNCCJobSetup.JobSetup.JADelayCert);

  FChangedData[flgRevenue]              := (FBeforeNCCJobSetup.JobSetup.SummDesc[1]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[1]);
  FChangedData[flgLabour]               := (FBeforeNCCJobSetup.JobSetup.SummDesc[2]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[2]);
  FChangedData[flgSubContLabour]        := (FBeforeNCCJobSetup.JobSetup.SummDesc[11]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[11]);
  FChangedData[flgDirectExp1]           := (FBeforeNCCJobSetup.JobSetup.SummDesc[3]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[3]);
  FChangedData[flgDirectExp2]           := (FBeforeNCCJobSetup.JobSetup.SummDesc[4]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[4]);
  FChangedData[flgStockIssues]          := (FBeforeNCCJobSetup.JobSetup.SummDesc[5]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[5]);
  FChangedData[flgMaterials2]           := (FBeforeNCCJobSetup.JobSetup.SummDesc[12]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[12]);
  FChangedData[flgOverheads]            := (FBeforeNCCJobSetup.JobSetup.SummDesc[6]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[6]);
  FChangedData[flgOverheads2]           := (FBeforeNCCJobSetup.JobSetup.SummDesc[13]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[13]);
  FChangedData[flgReceipts]             := (FBeforeNCCJobSetup.JobSetup.SummDesc[7]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[7]);
  FChangedData[flgWorkInProgress]       := (FBeforeNCCJobSetup.JobSetup.SummDesc[8]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[8]);
  FChangedData[flgRetentionsSL]         := (FBeforeNCCJobSetup.JobSetup.SummDesc[9]     <>    FAfterNCCJobSetup.JobSetup.SummDesc[9]);
  FChangedData[flgRetentionsPL]         := (FBeforeNCCJobSetup.JobSetup.SummDesc[10]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[10]);
  FChangedData[flgSaleDeductions]       := (FBeforeNCCJobSetup.JobSetup.SummDesc[14]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[14]);
  FChangedData[flgPurchDeductions]      := (FBeforeNCCJobSetup.JobSetup.SummDesc[17]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[17]);
  FChangedData[flgSalesApps]            := (FBeforeNCCJobSetup.JobSetup.SummDesc[15]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[15]);
  FChangedData[flgPurchaseApps]         := (FBeforeNCCJobSetup.JobSetup.SummDesc[16]    <>    FAfterNCCJobSetup.JobSetup.SummDesc[16]);

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

Procedure TNCCJobSetupAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
Begin
  If (Destination = adAuditTrail) Then
  Begin
    // MH 13/02/2013 v7.0.2: Added missing subtitle
    if (GeneralSetFlag) Then
       WriteAuditSubTitle (AuditStrings, 'System Setup - Job Costing GL Control Codes Edited / System Setup - General Settings', '')
    else
       WriteAuditSubTitle (AuditStrings, 'System Setup - Job Costing GL Control Codes Edited', '');

    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then                           //   Max 20 chars for descriptions
      Begin                                             //            1         2
        Case I Of                                       //   12345678901234567890
            fldOverhead    : WriteDataChange (AuditStrings, 'Overhead',           IntToStr(FBeforeNCCJobSetup.JobSetup.EmployeeNom[1,False]), IntToStr(FAfterNCCJobSetup.JobSetup.EmployeeNom[1,False]));
            fldProduction  : WriteDataChange (AuditStrings, 'Production',         IntToStr(FBeforeNCCJobSetup.JobSetup.EmployeeNom[2,False]), IntToStr(FAfterNCCJobSetup.JobSetup.EmployeeNom[2,False]));
            fldSubContract : WriteDataChange (AuditStrings, 'Sub-Contract',       IntToStr(FBeforeNCCJobSetup.JobSetup.EmployeeNom[3,False]), IntToStr(FAfterNCCJobSetup.JobSetup.EmployeeNom[3,False]));

            // Added to deal with Job Costing options on the General Settings Screen
                                                               //   12345678901234567890
            flgUsePPIForTimeSheet : WriteDataChange (AuditStrings, 'Use PPIs for T/S',     BoolToStr(FBeforeNCCJobSetup.JobSetup.GenPPI, True),        BoolToStr(FAfterNCCJobSetup.JobSetup.GenPPI, True));
            flgPPISuppAct         : WriteDataChange (AuditStrings, 'PPI Supp. A/C',        FBeforeNCCJobSetup.JobSetup.PPIAcCode,                      FAfterNCCJobSetup.JobSetup.PPIAcCode);
            flgSplitJobBudgets    : WriteDataChange (AuditStrings, 'Split Job Budgets',    BoolToStr(FBeforeNCCJobSetup.JobSetup.PeriodBud, True),     BoolToStr(FAfterNCCJobSetup.JobSetup.PeriodBud, True));

            flgIncUnpostedPurch   : WriteDataChange (AuditStrings, 'Inc Unposted PO',      BoolToStr(FBeforeNCCJobSetup.JobSetup.JCCommitPin, True),   BoolToStr(FAfterNCCJobSetup.JobSetup.JCCommitPin, True));
            flgProtectApplication : WriteDataChange (AuditStrings, 'App Date for Invoice', BoolToStr(FBeforeNCCJobSetup.JobSetup.JAInvDate, True),     BoolToStr(FAfterNCCJobSetup.JobSetup.JAInvDate, True));
            flgDelayAppUntilCert  : WriteDataChange (AuditStrings, 'Delay App until Cert', BoolToStr(FBeforeNCCJobSetup.JobSetup.JADelayCert, True),   BoolToStr(FAfterNCCJobSetup.JobSetup.JADelayCert, True));

            flgRevenue            : WriteDataChange (AuditStrings, 'Smry Cat Revenue',     FBeforeNCCJobSetup.JobSetup.SummDesc[1],                    FAfterNCCJobSetup.JobSetup.SummDesc[1]);
            flgLabour             : WriteDataChange (AuditStrings, 'Smry Cat Labour',      FBeforeNCCJobSetup.JobSetup.SummDesc[2],                    FAfterNCCJobSetup.JobSetup.SummDesc[2]);
            flgSubContLabour      : WriteDataChange (AuditStrings, 'Smry Cat Sub Cont.',   FBeforeNCCJobSetup.JobSetup.SummDesc[11],                   FAfterNCCJobSetup.JobSetup.SummDesc[11]);

            flgDirectExp1         : WriteDataChange (AuditStrings, 'Smry Cat Direct Exp1', FBeforeNCCJobSetup.JobSetup.SummDesc[3],                    FAfterNCCJobSetup.JobSetup.SummDesc[3]);
            flgDirectExp2         : WriteDataChange (AuditStrings, 'Smry Cat Direct Exp2', FBeforeNCCJobSetup.JobSetup.SummDesc[4],                    FAfterNCCJobSetup.JobSetup.SummDesc[4]);
            flgStockIssues        : WriteDataChange (AuditStrings, 'Smry Cat Stock Issue', FBeforeNCCJobSetup.JobSetup.SummDesc[5],                    FAfterNCCJobSetup.JobSetup.SummDesc[5]);

            flgMaterials2         : WriteDataChange (AuditStrings, 'Smry Cat Materials 2', FBeforeNCCJobSetup.JobSetup.SummDesc[12],                   FAfterNCCJobSetup.JobSetup.SummDesc[12]);
            flgOverheads          : WriteDataChange (AuditStrings, 'Smry Cat Overheads',   FBeforeNCCJobSetup.JobSetup.SummDesc[6],                    FAfterNCCJobSetup.JobSetup.SummDesc[6]);
            flgOverheads2         : WriteDataChange (AuditStrings, 'Smry Cat Overheads 2', FBeforeNCCJobSetup.JobSetup.SummDesc[13],                   FAfterNCCJobSetup.JobSetup.SummDesc[13]);

            flgReceipts           : WriteDataChange (AuditStrings, 'Smry Cat Receipts',    FBeforeNCCJobSetup.JobSetup.SummDesc[7],                    FAfterNCCJobSetup.JobSetup.SummDesc[7]);
            flgWorkInProgress     : WriteDataChange (AuditStrings, 'Smry Cat WIP',         FBeforeNCCJobSetup.JobSetup.SummDesc[8],                    FAfterNCCJobSetup.JobSetup.SummDesc[8]);
            flgRetentionsSL       : WriteDataChange (AuditStrings, 'Smry Cat Ret S/L',     FBeforeNCCJobSetup.JobSetup.SummDesc[9],                    FAfterNCCJobSetup.JobSetup.SummDesc[9]);

            flgRetentionsPL       : WriteDataChange (AuditStrings, 'Smry Cat Ret P/L',     FBeforeNCCJobSetup.JobSetup.SummDesc[10],                   FAfterNCCJobSetup.JobSetup.SummDesc[10]);
            flgSaleDeductions     : WriteDataChange (AuditStrings, 'Smry Cat Sale Ded',    FBeforeNCCJobSetup.JobSetup.SummDesc[14],                   FAfterNCCJobSetup.JobSetup.SummDesc[14]);
            flgPurchDeductions    : WriteDataChange (AuditStrings, 'Smry Cat Purch Ded',   FBeforeNCCJobSetup.JobSetup.SummDesc[17],                   FAfterNCCJobSetup.JobSetup.SummDesc[17]);

            flgSalesApps          : WriteDataChange (AuditStrings, 'Smry Cat Sales Apps',  FBeforeNCCJobSetup.JobSetup.SummDesc[15],                   FAfterNCCJobSetup.JobSetup.SummDesc[15]);
            flgPurchaseApps       : WriteDataChange (AuditStrings, 'Smry Cat Purch Apps',  FBeforeNCCJobSetup.JobSetup.SummDesc[16],                   FAfterNCCJobSetup.JobSetup.SummDesc[16]);
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

