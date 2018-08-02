Unit AuditCurrencySetup;

Interface

Uses Classes, AuditBase, VarRec2U;

Type
  TCurrencySetupAudit = Class (TAuditBase)
  Private
    FBeforeCurr : CurrRec;
    FAfterCurr  : CurrRec;

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
    // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
    // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
    Procedure WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);  Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TTraderAudit

Implementation

Uses SysUtils, ETStrU;

//=========================================================================

Constructor TCurrencySetupAudit.Create;
Begin // Create
  Inherited Create;

  FChangedData := TBits.Create;
  FChangedData.Size := 91;  // 0-90 currencies
End; // Create

//------------------------------

Destructor TCurrencySetupAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TCurrencySetupAudit.GetBeforeData : Pointer;
Begin // GetBeforeData
  Result := @FBeforeCurr;
End; // GetBeforeData

Procedure TCurrencySetupAudit.SetBeforeData (Value : Pointer);
Begin // SetBeforeData
  Move (Value^, FBeforeCurr, SizeOf(FBeforeCurr));
End; // SetBeforeData

//------------------------------

Function TCurrencySetupAudit.GetAfterData : Pointer;
Begin // GetAfterData
  Result := @FAfterCurr;
End; // GetAfterData

Procedure TCurrencySetupAudit.SetAfterData (Value : Pointer);
Begin // SetAfterData
  Move (Value^, FAfterCurr, SizeOf(FAfterCurr));
End; // SetAfterData

//-------------------------------------------------------------------------

Function TCurrencySetupAudit.NeedAuditEntry : Boolean;
Var
  I         : SmallInt;
Begin // NeedAuditEntry
  // Run through the currencies checking for changes per currency
  For I := Low(FBeforeCurr.Currencies) To High(FBeforeCurr.Currencies) Do
  Begin
    FChangedData[I] := (FBeforeCurr.Currencies[I].Desc <> FAfterCurr.Currencies[I].Desc) Or
                       (FBeforeCurr.Currencies[I].SSymb <> FAfterCurr.Currencies[I].SSymb) Or
                       (FBeforeCurr.Currencies[I].CRates[False] <> FAfterCurr.Currencies[I].CRates[False]) Or
                       (FBeforeCurr.Currencies[I].CRates[True] <> FAfterCurr.Currencies[I].CRates[True]) Or
                       (FBeforeCurr.Currencies[I].PSymb <> FAfterCurr.Currencies[I].PSymb);
  End; // For I

  // Run through the flag checking for changes
  Result := False;
  For I := 0 To (FChangedData.Size - 1) Do
  Begin
    If FChangedData[I] Then
    Begin
      Result := True;
      Break;
    End; // If FChangedData[I]
  End; // For I
End; // NeedAuditEntry

//-------------------------------------------------------------------------

Procedure TCurrencySetupAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
  LoopCnt   : Integer;
  dummy : AnsiString;
Begin // WriteAuditData
  If (Destination = adAuditTrail) Then
  Begin
    WriteAuditSubTitle (AuditStrings, 'System Setup - Currency', '');
    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then
      Begin
        If (FBeforeCurr.Currencies[I].Desc <> FAfterCurr.Currencies[I].Desc) Then
          WriteDataChange (AuditStrings, IntToStr(I) + ': Description', FBeforeCurr.Currencies[I].Desc, FAfterCurr.Currencies[I].Desc);

        If (FBeforeCurr.Currencies[I].SSymb <> FAfterCurr.Currencies[I].SSymb) Then
          WriteDataChange (AuditStrings, IntToStr(I) + ': Screen Symbol', FBeforeCurr.Currencies[I].SSymb, FAfterCurr.Currencies[I].SSymb);

        If (FBeforeCurr.Currencies[I].CRates[False] <> FAfterCurr.Currencies[I].CRates[False]) Then
          WriteDataChange (AuditStrings, IntToStr(I) + ': Company Rate', Form_Real(FBeforeCurr.Currencies[I].CRates[False], 0, 6), Form_Real(FAfterCurr.Currencies[I].CRates[False], 0, 6));

        If (FBeforeCurr.Currencies[I].CRates[True] <> FAfterCurr.Currencies[I].CRates[True]) Then
          WriteDataChange (AuditStrings, IntToStr(I) + ': Daily Rate', Form_Real(FBeforeCurr.Currencies[I].CRates[True], 0, 6), Form_Real(FAfterCurr.Currencies[I].CRates[True], 0, 6));

        If (FBeforeCurr.Currencies[I].PSymb <> FAfterCurr.Currencies[I].PSymb) Then
          WriteDataChange (AuditStrings, IntToStr(I) + ': Print Symbol', FBeforeCurr.Currencies[I].PSymb, FAfterCurr.Currencies[I].PSymb);
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

