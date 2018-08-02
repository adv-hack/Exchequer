Unit AuditCISSetup;

Interface

Uses Classes, AuditBase, VarConst, GlobVar;

Type
  TCISSetupAudit = Class (TAuditBase)
  Private
    FBeforeCISSetup : CISRecT;
    FAfterCISSetup  : CISRecT;

    BeforeCurTaxPeriod : LongDate;
    AfterCurTaxPeriod  : LongDate;

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

Uses SysUtils, ETDateU, JChkUseU, JobSup1U, ETMiscU, BTSupU1, InvListU;

Const
  fldLastTaxReturn      = 0;
  fldReturnEveryMonths  = 1;
  fldCurrentTaxPeriod   = 2;
  fldSchemeRef          = 3;
  fldSetPeriodDateAlloc = 4;
  fldRate               = 5;
  fldCertificateType    = 6;
  fldCertificateRef     = 7;
  fldVATIndex1          = 8;     // RCTRVCF1
  fldVATIndex2          = 9;     // RCTRVCF2
  fldCDesc              = 10;
  fldCRate              = 11;
  fldCGLCode            = 12;
  fldCCC                = 13;
  fldCDept              = 14;
  fldTDesc              = 15;
  fldTRate              = 16;
  fldTGLCode            = 17;
  fldTCC                = 18;
  fldTDept              = 19;

  TotFields = fldTDept + 1;

//=========================================================================

Constructor TCISSetupAudit.Create;
Begin // Create
  Inherited Create;
  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TCISSetupAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TCISSetupAudit.GetBeforeData : Pointer;
Begin
  Result := @FBeforeCISSetup;
End;

Procedure TCISSetupAudit.SetBeforeData (Value : Pointer);
Begin
  Move (Value^, FBeforeCISSetup, SizeOf(FBeforeCISSetup));
End;

//------------------------------

Function TCISSetupAudit.GetAfterData : Pointer;
Begin
  Result := @FAfterCISSetup;
End;

Procedure TCISSetupAudit.SetAfterData (Value : Pointer);
Begin
  Move (Value^, FAfterCISSetup, SizeOf(FAfterCISSetup));
End;

//-------------------------------------------------------------------------

Function TCISSetupAudit.NeedAuditEntry : Boolean;
Var
  I          : SmallInt;
Begin
  // We will flag all the data that has been changed

  // Initialise the variables used
  BeforeCurTaxPeriod  := '';
  AfterCurTaxPeriod   := '';

  BeforeCurTaxPeriod  := Calc_NewCISPeriod(FBeforeCISSetup.CISRates.CISReturnDate,Trunc(FBeforeCISSetup.CISRates.CISInterval));
  AfterCurTaxPeriod   := Calc_NewCISPeriod(FAfterCISSetup.CISRates.CISReturnDate,Trunc(FAfterCISSetup.CISRates.CISInterval));

  FChangedData[fldLastTaxReturn]        := (FBeforeCISSetup.CISRates.CISReturnDate <> FAfterCISSetup.CISRates.CISReturnDate);
  FChangedData[fldReturnEveryMonths]    := (FBeforeCISSetup.CISRates.CISInterval <> FAfterCISSetup.CISRates.CISInterval);
  FChangedData[fldCurrentTaxPeriod]     := (BeforeCurTaxPeriod <> AfterCurTaxPeriod);
  FChangedData[fldSchemeRef]            := (FBeforeCISSetup.CISRates.CISTaxRef <> FAfterCISSetup.CISRates.CISTaxRef);
  FChangedData[fldSetPeriodDateAlloc]   := (FBeforeCISSetup.CISRates.CISAutoSetPr <> FAfterCISSetup.CISRates.CISAutoSetPr);
  FChangedData[fldRate]                 := (FBeforeCISSetup.CISRates.CISVATCode <> FAfterCISSetup.CISRates.CISVATCode);
  FChangedData[fldCertificateType]      := (FBeforeCISSetup.CISRates.JCISType <> FAfterCISSetup.CISRates.JCISType);
  FChangedData[fldCertificateRef]       := (FBeforeCISSetup.CISRates.JCertNo <> FAfterCISSetup.CISRates.JCertNo);

  // These never seem to be visible but just incase things change will leave the code
  //FChangedData[fldVATIndex1]            := (GetVATIndex(FBeforeCISSetup.CISRates.RCTRCV1) <> GetVATIndex(FAfterCISSetup.CISRates.RCTRCV1));
  //FChangedData[fldVATIndex2]            := (GetVATIndex(FBeforeCISSetup.CISRates.RCTRCV2) <> GetVATIndex(FAfterCISSetup.CISRates.RCTRCV2));

  FChangedData[fldCDesc]                := (FBeforeCISSetup.CISRates.CISRate[Construct].Desc <> FAfterCISSetup.CISRates.CISRate[Construct].Desc);
  FChangedData[fldCRate]                := (FBeforeCISSetup.CISRates.CISRate[Construct].Rate <> FAfterCISSetup.CISRates.CISRate[Construct].Rate);
  FChangedData[fldCGLCode]              := (FBeforeCISSetup.CISRates.CISRate[Construct].GLCode <> FAfterCISSetup.CISRates.CISRate[Construct].GLCode);
  FChangedData[fldCCC]                  := (FBeforeCISSetup.CISRates.CISRate[Construct].RCCDep[True] <> FAfterCISSetup.CISRates.CISRate[Construct].RCCDep[True]);
  FChangedData[fldCDept]                := (FBeforeCISSetup.CISRates.CISRate[Construct].RCCDep[False] <> FAfterCISSetup.CISRates.CISRate[Construct].RCCDep[False]);

  FChangedData[fldTDesc]                := (FBeforeCISSetup.CISRates.CISRate[Technical].Desc <> FAfterCISSetup.CISRates.CISRate[Technical].Desc);
  FChangedData[fldTRate]                := (FBeforeCISSetup.CISRates.CISRate[Technical].Rate <> FAfterCISSetup.CISRates.CISRate[Technical].Rate);
  FChangedData[fldTGLCode]              := (FBeforeCISSetup.CISRates.CISRate[Technical].GLCode <> FAfterCISSetup.CISRates.CISRate[Technical].GLCode);
  FChangedData[fldTCC]                  := (FBeforeCISSetup.CISRates.CISRate[Technical].RCCDep[True] <> FAfterCISSetup.CISRates.CISRate[Technical].RCCDep[True]);
  FChangedData[fldTDept]                := (FBeforeCISSetup.CISRates.CISRate[Technical].RCCDep[False] <> FAfterCISSetup.CISRates.CISRate[Technical].RCCDep[False]);

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

Procedure TCISSetupAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
Begin
  If (Destination = adAuditTrail) Then
  Begin
    // MH 13/02/2013 v7.0.2: Added missing subtitle
    WriteAuditSubTitle (AuditStrings, 'CIS Setup Edited', '');
    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then
      Begin
        Case I Of
          fldLastTaxReturn      : WriteDataChange (AuditStrings, 'Last CIS Return', POutDateB(FBeforeCISSetup.CISRates.CISReturnDate), POutDateB(FAfterCISSetup.CISRates.CISReturnDate));
          fldReturnEveryMonths  : WriteDataChange (AuditStrings, 'Return every Mths', IntToStr(FBeforeCISSetup.CISRates.CISInterval), IntToStr(FAfterCISSetup.CISRates.CISInterval));
          fldCurrentTaxPeriod   : WriteDataChange (AuditStrings, 'Current CIS Period', POutDateB(BeforeCurTaxPeriod), POutDateB(AfterCurTaxPeriod));
          fldSchemeRef          : WriteDataChange (AuditStrings, 'Scheme Ref', FBeforeCISSetup.CISRates.CISTaxRef, FAfterCISSetup.CISRates.CISTaxRef);
          fldSetPeriodDateAlloc : WriteDataChange (AuditStrings, 'Set Period From Date', BoolToStr(FBeforeCISSetup.CISRates.CISAutoSetPr, True), BoolToStr(FAfterCISSetup.CISRates.CISAutoSetPr, True));
          fldRate               : WriteDataChange (AuditStrings, 'CIS VAT Rate', FBeforeCISSetup.CISRates.CISVATCode, FAfterCISSetup.CISRates.CISVATCode);
          fldCertificateType    : WriteDataChange (AuditStrings, 'CIS Tax Rate', TxLate_CISTypeStr(FBeforeCISSetup.CISRates.JCISType), TxLate_CISTypeStr(FAfterCISSetup.CISRates.JCISType));
          fldCertificateRef     : WriteDataChange (AuditStrings, 'CTR', FBeforeCISSetup.CISRates.JCertNo, FAfterCISSetup.CISRates.JCertNo);

          // These never seem to be visible but just incase things change will leave the code
          //fldVATIndex1          : WriteDataChange (AuditStrings, 'VAT Index 1', IntToStr(GetVATIndex(FBeforeCISSetup.CISRates.RCTRCV1)), IntToStr(GetVATIndex(FAfterCISSetup.CISRates.RCTRCV1)));
          //fldVATIndex2          : WriteDataChange (AuditStrings, 'VAT Index 2', IntToStr(GetVATIndex(FBeforeCISSetup.CISRates.RCTRCV2)), IntToStr(GetVATIndex(FAfterCISSetup.CISRates.RCTRCV2)));

          fldCDesc              : WriteDataChange (AuditStrings, 'Construct Desc', FBeforeCISSetup.CISRates.CISRate[Construct].Desc, FAfterCISSetup.CISRates.CISRate[Construct].Desc);
          fldCRate              : WriteDataChange (AuditStrings, 'Construct Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeCISSetup.CISRates.CISRate[Construct].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterCISSetup.CISRates.CISRate[Construct].Rate)));
          fldCGLCode            : WriteDataChange (AuditStrings, 'Construct GL Code', IntToStr(FBeforeCISSetup.CISRates.CISRate[Construct].GLCode), IntToStr(FAfterCISSetup.CISRates.CISRate[Construct].GLCode));

          fldCCC                : WriteDataChange (AuditStrings, 'Construct CC', FBeforeCISSetup.CISRates.CISRate[Construct].RCCDep[True], FAfterCISSetup.CISRates.CISRate[Construct].RCCDep[True]);
          fldCDept              : WriteDataChange (AuditStrings, 'Construct Dept', FBeforeCISSetup.CISRates.CISRate[Construct].RCCDep[False], FAfterCISSetup.CISRates.CISRate[Construct].RCCDep[False]);

          fldTDesc              : WriteDataChange (AuditStrings, 'Technical Desc', FBeforeCISSetup.CISRates.CISRate[Technical].Desc, FAfterCISSetup.CISRates.CISRate[Technical].Desc);
          fldTRate              : WriteDataChange (AuditStrings, 'Technical Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeCISSetup.CISRates.CISRate[Technical].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterCISSetup.CISRates.CISRate[Technical].Rate)));
          fldTGLCode            : WriteDataChange (AuditStrings, 'Technical GL Code', IntToStr(FBeforeCISSetup.CISRates.CISRate[Technical].GLCode), IntToStr(FAfterCISSetup.CISRates.CISRate[Technical].GLCode));

          fldTCC                : WriteDataChange (AuditStrings, 'Technical CC', FBeforeCISSetup.CISRates.CISRate[Technical].RCCDep[True], FAfterCISSetup.CISRates.CISRate[Technical].RCCDep[True]);
          fldTDept              : WriteDataChange (AuditStrings, 'Technical Dept', FBeforeCISSetup.CISRates.CISRate[Technical].RCCDep[False], FAfterCISSetup.CISRates.CISRate[Technical].RCCDep[False]);
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

