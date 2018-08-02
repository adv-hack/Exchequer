Unit AuditSystemSetupTable;

Interface

Uses Classes, AuditBase, AuditIntf, oSystemSetup;

Type
  TSystemSetupTableAudit = Class (TAuditBase)
  Private
    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    FAuditType: TAuditType;

    FBeforeSetup : SystemSetupInternalSettingsRecType;
    FAfterSetup  : SystemSetupInternalSettingsRecType;

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
    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    Constructor Create(AuditType: TAuditType);
    Destructor Destroy; Override;
  End;

Implementation

Uses SysUtils, ETDateU, GDPRConst;

Const
  fldSettlementWriteOff = 0;
  // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
  fldLastClosedArrivalsDate = 1;
  fldLastClosedDispatchesDate = 2;
  fldLastReportPeriodYear = 3;
  fldLastReportFromDate = 4;
  fldLastReportToDate = 5;
  fldLastReportMode = 6;
  //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
  fldAnonymised = 7;
  fldAnonymisedDate = 8;
  fldAnonymisedTime = 9;
  fldGDPRTraderRetentionPeriod = 10;
  fldGDPRTraderDisplayPIITree = 11;
  fldGDPRTraderAnonNotesOption = 12;
  fldGDPRTraderAnonLettersOption = 13;
  fldGDPRTraderAnonLinksOption = 14;
  fldGDPREmployeeRetentionPeriod = 15;
  fldGDPREmployeeDisplayPIITree = 16;
  fldGDPREmployeeAnonNotesOption = 17;
  fldGDPREmployeeAnonLettersOption = 18;
  fldGDPREmployeeAnonLinksOption = 19;
  fldGDPRCompanyAnonLocations = 20;
  fldGDPRCompanyAnonCostCentres = 21;
  fldGDPRCompanyAnonDepartment = 22;
  fldGDPRCompanyNotesOption = 23;
  fldGDPRCompanyLettersOption = 24;
  fldGDPRCompanyLinksOption = 25;
  TotFields = fldGDPRCompanyLinksOption + 1;

//=========================================================================

Constructor TSystemSetupTableAudit.Create(AuditType: TAuditType);
Begin // Create
  Inherited Create;
  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
  // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
  FAuditType := AuditType;
End; // Create

//------------------------------

Destructor TSystemSetupTableAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSystemSetupTableAudit.GetBeforeData : Pointer;
Begin
  Result := @FBeforeSetup;
End;

Procedure TSystemSetupTableAudit.SetBeforeData (Value : Pointer);
Begin
  Move (Value^, FBeforeSetup, SizeOf(FBeforeSetup));
End;

//------------------------------

Function TSystemSetupTableAudit.GetAfterData : Pointer;
Begin
  Result := @FAfterSetup;
End;

Procedure TSystemSetupTableAudit.SetAfterData (Value : Pointer);
Begin
  Move (Value^, FAfterSetup, SizeOf(FAfterSetup));
End;

//-------------------------------------------------------------------------

Function TSystemSetupTableAudit.NeedAuditEntry : Boolean;
Var
  I : SmallInt;
Begin
  // We will flag all the data that has been changed
  if FAuditType = atSystemSetupTable then
  begin
    FChangedData[fldSettlementWriteOff]  := (FBeforeSetup.isSettlementWriteOffCtrlGL <> FAfterSetup.isSettlementWriteOffCtrlGL);
  end
  else if FAuditType = atIntrastatSettings then
  begin
    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    FChangedData[fldLastClosedArrivalsDate]   := (FBeforeSetup.isLastClosedArrivalsDate   <> FAfterSetup.isLastClosedArrivalsDate);
    FChangedData[fldLastClosedDispatchesDate] := (FBeforeSetup.isLastClosedDispatchesDate <> FAfterSetup.isLastClosedDispatchesDate);
    FChangedData[fldLastReportPeriodYear]     := (FBeforeSetup.isLastReportPeriodYear     <> FAfterSetup.isLastReportPeriodYear);
    FChangedData[fldLastReportFromDate]       := (FBeforeSetup.isLastReportFromDate       <> FAfterSetup.isLastReportFromDate);
    FChangedData[fldLastReportToDate]         := (FBeforeSetup.isLastReportToDate         <> FAfterSetup.isLastReportToDate);
    FChangedData[fldLastReportMode]           := (FBeforeSetup.isLastReportMode           <> FAfterSetup.isLastReportMode);
  end
  else if FAuditType = atGDPRConfig then
  begin
    //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
    FChangedData[fldAnonymised]                     := (FBeforeSetup.isAnonymised                   <> FAfterSetup.isAnonymised);
    FChangedData[fldAnonymisedDate]                 := (FBeforeSetup.isAnonymisedDate               <> FAfterSetup.isAnonymisedDate);
    FChangedData[fldAnonymisedTime]                 := (FBeforeSetup.isAnonymisedTime               <> FAfterSetup.isAnonymisedTime);
    FChangedData[fldGDPRTraderRetentionPeriod]      := (FBeforeSetup.isGDPRTraderRetentionPeriod    <> FAfterSetup.isGDPRTraderRetentionPeriod);
    FChangedData[fldGDPRTraderDisplayPIITree]       := (FBeforeSetup.isGDPRTraderDisplayPIITree     <> FAfterSetup.isGDPRTraderDisplayPIITree);
    FChangedData[fldGDPRTraderAnonNotesOption]      := (FBeforeSetup.isGDPRTraderAnonNotesOption    <> FAfterSetup.isGDPRTraderAnonNotesOption);
    FChangedData[fldGDPRTraderAnonLettersOption]    := (FBeforeSetup.isGDPRTraderAnonLettersOption  <> FAfterSetup.isGDPRTraderAnonLettersOption);
    FChangedData[fldGDPRTraderAnonLinksOption]      := (FBeforeSetup.isGDPRTraderAnonLinksOption    <> FAfterSetup.isGDPRTraderAnonLinksOption);
    FChangedData[fldGDPREmployeeRetentionPeriod]    := (FBeforeSetup.isGDPREmployeeRetentionPeriod  <> FAfterSetup.isGDPREmployeeRetentionPeriod);
    FChangedData[fldGDPREmployeeDisplayPIITree]     := (FBeforeSetup.isGDPREmployeeDisplayPIITree   <> FAfterSetup.isGDPREmployeeDisplayPIITree);
    FChangedData[fldGDPREmployeeAnonNotesOption]    := (FBeforeSetup.isGDPREmployeeAnonNotesOption  <> FAfterSetup.isGDPREmployeeAnonNotesOption);
    FChangedData[fldGDPREmployeeAnonLettersOption]  := (FBeforeSetup.isGDPREmployeeAnonLettersOption<> FAfterSetup.isGDPREmployeeAnonLettersOption);
    FChangedData[fldGDPREmployeeAnonLinksOption]    := (FBeforeSetup.isGDPREmployeeAnonLinksOption  <> FAfterSetup.isGDPREmployeeAnonLinksOption);
    FChangedData[fldGDPRCompanyAnonLocations]       := (FBeforeSetup.isGDPRCompanyAnonLocations     <> FAfterSetup.isGDPRCompanyAnonLocations);
    FChangedData[fldGDPRCompanyAnonCostCentres]     := (FBeforeSetup.isGDPRCompanyAnonCostCentres   <> FAfterSetup.isGDPRCompanyAnonCostCentres);
    FChangedData[fldGDPRCompanyAnonDepartment]      := (FBeforeSetup.isGDPRCompanyAnonDepartment    <> FAfterSetup.isGDPRCompanyAnonDepartment);
    FChangedData[fldGDPRCompanyNotesOption]         := (FBeforeSetup.isGDPRCompanyNotesOption       <> FAfterSetup.isGDPRCompanyNotesOption);
    FChangedData[fldGDPRCompanyLettersOption]       := (FBeforeSetup.isGDPRCompanyLettersOption     <> FAfterSetup.isGDPRCompanyLettersOption);
    FChangedData[fldGDPRCompanyLinksOption]         := (FBeforeSetup.isGDPRCompanyLinksOption       <> FAfterSetup.isGDPRCompanyLinksOption);
  end;

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

Procedure TSystemSetupTableAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
Begin
  If (Destination = adAuditTrail) Then
  Begin
    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
    if FAuditType = atSystemSetupTable then
      WriteAuditSubTitle (AuditStrings, 'System Setup - GL Control Codes Edited', '')
    else if FAuditType = atIntrastatSettings then
      WriteAuditSubTitle(AuditStrings, 'Intrastat - Close Period', '')
    else if FAuditType = atGDPRConfig then
      WriteAuditSubTitle(AuditStrings, 'GDPR Configuration', '');

    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then                                        //   Max 20 chars for descriptions
      Begin                                                          //            1         2
        Case I Of                                                    //   12345678901234567890
          fldSettlementWriteOff           : WriteDataChange (AuditStrings, 'Settlement Write-Off', IntToStr(FBeforeSetup.isSettlementWriteOffCtrlGL), IntToStr(FAfterSetup.isSettlementWriteOffCtrlGL));
          // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
          fldLastClosedArrivalsDate       : WriteDataChange (AuditStrings, 'Last Arrivals Date', FBeforeSetup.isLastClosedArrivalsDate, FAfterSetup.isLastClosedArrivalsDate);
          fldLastClosedDispatchesDate     : WriteDataChange (AuditStrings, 'Last Dispatches Date', FBeforeSetup.isLastClosedDispatchesDate, FAfterSetup.isLastClosedDispatchesDate);
          fldLastReportPeriodYear         : WriteDataChange (AuditStrings, 'Report Period Year', FBeforeSetup.isLastReportPeriodYear, FAfterSetup.isLastReportPeriodYear);
          fldLastReportFromDate           : WriteDataChange (AuditStrings, 'Report From Date', FBeforeSetup.isLastReportFromDate, FAfterSetup.isLastReportFromDate);
          fldLastReportToDate             : WriteDataChange (AuditStrings, 'Report To Date', FBeforeSetup.isLastReportToDate, FAfterSetup.isLastReportToDate);
          fldLastReportMode               : WriteDataChange (AuditStrings, 'Report Mode', IntToStr(FBeforeSetup.isLastReportMode), IntToStr(FAfterSetup.isLastReportMode));
          //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
          fldAnonymised                   : WriteDataChange (AuditStrings, 'Anonymised', BoolToStr(FBeforeSetup.isAnonymised, True), BoolToStr(FAfterSetup.isAnonymised, True));
          fldAnonymisedDate               : WriteDataChange (AuditStrings, 'Anonymised Date', FBeforeSetup.isAnonymisedDate, FAfterSetup.isAnonymisedDate);
          fldAnonymisedTime               : WriteDataChange (AuditStrings, 'Anonymised Time', FBeforeSetup.isAnonymisedTime, FAfterSetup.isAnonymisedTime);
          fldGDPRTraderRetentionPeriod    : WriteDataChange (AuditStrings, 'Trad Retention Per', IntToStr(FBeforeSetup.isGDPRTraderRetentionPeriod), IntToStr(FAfterSetup.isGDPRTraderRetentionPeriod));
          fldGDPRTraderDisplayPIITree     : WriteDataChange (AuditStrings, 'Trad Disp PII Tree', BoolToStr(FBeforeSetup.isGDPRTraderDisplayPIITree, True), BoolToStr(FAfterSetup.isGDPRTraderDisplayPIITree, True));
          fldGDPRTraderAnonNotesOption    : WriteDataChange (AuditStrings, 'Trad Anon Notes Opt', NotesAnonymisationControlCentreList[FBeforeSetup.isGDPRTraderAnonNotesOption], NotesAnonymisationControlCentreList[FAfterSetup.isGDPRTraderAnonNotesOption]);
          fldGDPRTraderAnonLettersOption  : WriteDataChange (AuditStrings, 'Trad Anon Letter Opt', LettersAnonymisationControlCentreList[FBeforeSetup.isGDPRTraderAnonLettersOption], LettersAnonymisationControlCentreList[FAfterSetup.isGDPRTraderAnonLettersOption]);
          fldGDPRTraderAnonLinksOption    : WriteDataChange (AuditStrings, 'Trad Anon Links Opt', LinksAnonymisationControlCentreList[FBeforeSetup.isGDPRTraderAnonLinksOption], LinksAnonymisationControlCentreList[FAfterSetup.isGDPRTraderAnonLinksOption]);
          fldGDPREmployeeRetentionPeriod  : WriteDataChange (AuditStrings, 'Emp Retention Per', IntToStr(FBeforeSetup.isGDPREmployeeRetentionPeriod), IntToStr(FAfterSetup.isGDPREmployeeRetentionPeriod));
          fldGDPREmployeeDisplayPIITree   : WriteDataChange (AuditStrings, 'Emp Display PII Tree', BoolToStr(FBeforeSetup.isGDPREmployeeDisplayPIITree, True), BoolToStr(FAfterSetup.isGDPREmployeeDisplayPIITree, True));
          fldGDPREmployeeAnonNotesOption  : WriteDataChange (AuditStrings, 'Emp Anon Notes Opt', NotesAnonymisationControlCentreList[FBeforeSetup.isGDPREmployeeAnonNotesOption], NotesAnonymisationControlCentreList[FAfterSetup.isGDPREmployeeAnonNotesOption]);
          fldGDPREmployeeAnonLettersOption: WriteDataChange (AuditStrings, 'Emp Anon Letter Opt', LettersAnonymisationControlCentreList[FBeforeSetup.isGDPREmployeeAnonLettersOption], LettersAnonymisationControlCentreList[FAfterSetup.isGDPREmployeeAnonLettersOption]);
          fldGDPREmployeeAnonLinksOption  : WriteDataChange (AuditStrings, 'Emp Anon Link Opt', LinksAnonymisationControlCentreList[FBeforeSetup.isGDPREmployeeAnonLinksOption], LinksAnonymisationControlCentreList[FAfterSetup.isGDPREmployeeAnonLinksOption]);
          fldGDPRCompanyAnonLocations     : WriteDataChange (AuditStrings, 'Comp Anon Locations', BoolToStr(FBeforeSetup.isGDPRCompanyAnonLocations, True), BoolToStr(FAfterSetup.isGDPRCompanyAnonLocations, True));
          fldGDPRCompanyAnonCostCentres   : WriteDataChange (AuditStrings, 'Comp Anon CCs', BoolToStr(FBeforeSetup.isGDPRCompanyAnonCostCentres, True), BoolToStr(FAfterSetup.isGDPRCompanyAnonCostCentres, True));
          fldGDPRCompanyAnonDepartment    : WriteDataChange (AuditStrings, 'Comp Anon Dep', BoolToStr(FBeforeSetup.isGDPRCompanyAnonDepartment, True), BoolToStr(FAfterSetup.isGDPRCompanyAnonDepartment, True));
          fldGDPRCompanyNotesOption       : WriteDataChange (AuditStrings, 'Comp Notes Opt', NotesAnonymisationControlCentreList[FBeforeSetup.isGDPRCompanyNotesOption], NotesAnonymisationControlCentreList[FAfterSetup.isGDPRCompanyNotesOption]);
          fldGDPRCompanyLettersOption     : WriteDataChange (AuditStrings, 'Comp Letters Opt', LettersAnonymisationControlCentreList[FBeforeSetup.isGDPRCompanyLettersOption], LettersAnonymisationControlCentreList[FAfterSetup.isGDPRCompanyLettersOption]);
          fldGDPRCompanyLinksOption       : WriteDataChange (AuditStrings, 'Comp Links Opt', LinksAnonymisationControlCentreList[FBeforeSetup.isGDPRCompanyLinksOption], LinksAnonymisationControlCentreList[FAfterSetup.isGDPRCompanyLinksOption]);
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

