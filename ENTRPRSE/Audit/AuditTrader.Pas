Unit AuditTrader;

Interface

Uses Classes, AuditBase, VarConst;

Type
  TTraderAudit = Class (TAuditBase)
  Private
    FBeforeTrader : CustRec;
    FAfterTrader  : CustRec;

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

Uses SysUtils, ETDateU, EncryptionUtils;

Const
  fldBankAccount = 0;
  fldSortCode = 1;
  fldBankRef = 2;
// MH 03/06/2015 2015-R1 ABSEXCH-16306: Removed Credit Card Fields from Audit as they are now user defined fields
//  fldCardNo = 3;
//  fldValidFrom = 4;
//  fldExpiry = 5;
//  fldCardName = 6;
//  fldIssueNo = 7;

  //PR: 28/08/2013 MRD Added mandate fields
  fldMandateID = 8;
  fldMandateDate = 9;

  TotFields = fldMandateDate;

//=========================================================================

Constructor TTraderAudit.Create;
Begin // Create
  Inherited Create;
  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TTraderAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TTraderAudit.GetBeforeData : Pointer;
Begin // GetBeforeData
  Result := @FBeforeTrader;
End; // GetBeforeData

Procedure TTraderAudit.SetBeforeData (Value : Pointer);
Begin // SetBeforeData
  Move (Value^, FBeforeTrader, SizeOf(FBeforeTrader));
End; // SetBeforeData

//------------------------------

Function TTraderAudit.GetAfterData : Pointer;
Begin // GetAfterData
  Result := @FAfterTrader;
End; // GetAfterData

Procedure TTraderAudit.SetAfterData (Value : Pointer);
Begin // SetAfterData
  Move (Value^, FAfterTrader, SizeOf(FAfterTrader));
End; // SetAfterData

//-------------------------------------------------------------------------

Function TTraderAudit.NeedAuditEntry : Boolean;
Var
  I : SmallInt;
Begin // NeedAuditEntry

  //PR: 28/08/2013 MRD Changed sort code/bank ac fields to sepa/iban + added mandate fields
  FChangedData[fldBankAccount] := (FBeforeTrader.acBankAccountCode <> FAfterTrader.acBankAccountCode);
  FChangedData[fldSortCode] := (FBeforeTrader.acBankSortCode <> FAfterTrader.acBankSortCode);
  FChangedData[fldBankRef] := (FBeforeTrader.BankRef <> FAfterTrader.BankRef);
// MH 03/06/2015 2015-R1 ABSEXCH-16306: Removed Credit Card Fields from Audit as they are now user defined fields
//  FChangedData[fldCardNo] := (FBeforeTrader.CCDCardNo <> FAfterTrader.CCDCardNo);
//  FChangedData[fldValidFrom] := (FBeforeTrader.CCDSDate <> FAfterTrader.CCDSDate);
//  FChangedData[fldExpiry] := (FBeforeTrader.CCDEDate <> FAfterTrader.CCDEDate);
//  FChangedData[fldCardName] := (FBeforeTrader.CCDName <> FAfterTrader.CCDName);
//  FChangedData[fldIssueNo] := (FBeforeTrader.CCDSARef <> FAfterTrader.CCDSARef);

  FChangedData[fldMandateID] := (FBeforeTrader.acMandateID <> FAfterTrader.acMandateID);
  FChangedData[fldMandateDate] := (FBeforeTrader.acMandateDate <> FAfterTrader.acMandateDate);

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

// MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
// can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
Procedure TTraderAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
Begin // WriteAuditData
  Case FBeforeTrader.acSubType Of
    'C' : WriteAuditSubTitle (AuditStrings, 'Customer Edited', Trim(FBeforeTrader.CustCode) + ' - ' + Trim(FBeforeTrader.Company));
    'S' : WriteAuditSubTitle (AuditStrings, 'Supplier Edited', Trim(FBeforeTrader.CustCode) + ' - ' + Trim(FBeforeTrader.Company));
    'U' : WriteAuditSubTitle (AuditStrings, 'Consumer Edited', Trim(FBeforeTrader.acLongACCode) + ' - ' + Trim(FBeforeTrader.Company));
  Else
    Raise Exception.Create ('TTraderAudit.WriteAuditData: Unknown Account Type (' + FBeforeTrader.acSubType + ')');
  End; // Case FBeforeTrader.acSubType

  // MH 08/03/2012 v6.10 ABSEXCH-12127: Only write confidential banking / credit card details to encrypted audit file
  If (Destination = adAuditTrail) Then
  Begin
    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then   //PR: 28/08/2013 MRD Changed sort code/bank ac fields to sepa/iban + added mandate fields
      Begin
        Case I Of
          fldBankAccount  : WriteDataChange (AuditStrings, 'Bank Account', DecryptBankAccountCode(FBeforeTrader.acBankAccountCode),
                                                                           DecryptBankAccountCode(FAfterTrader.acBankAccountCode));
          fldSortCode     : WriteDataChange (AuditStrings, 'Sort Code', DecryptBankSortCode(FBeforeTrader.acBankSortCode),
                                                                        DecryptBankSortCode(FAfterTrader.acBankSortCode));
          fldBankRef      : WriteDataChange (AuditStrings, 'Bank Ref', FBeforeTrader.BankRef, FAfterTrader.BankRef);
// MH 03/06/2015 2015-R1 ABSEXCH-16306: Removed Credit Card Fields from Audit as they are now user defined fields
//          fldCardNo       : WriteDataChange (AuditStrings, 'Card Number', FBeforeTrader.CCDCardNo, FAfterTrader.CCDCardNo);
//          fldValidFrom    : WriteDataChange (AuditStrings, 'ValidFrom', POutDateB(FBeforeTrader.CCDSDate), POutDateB(FAfterTrader.CCDSDate));
//          fldExpiry       : WriteDataChange (AuditStrings, 'Expiry Date', POutDateB(FBeforeTrader.CCDEDate), POutDateB(FAfterTrader.CCDEDate));
//          fldCardName     : WriteDataChange (AuditStrings, 'Card Name', FBeforeTrader.CCDName, FAfterTrader.CCDName);
//          fldIssueNo      : WriteDataChange (AuditStrings, 'Issue No', FBeforeTrader.CCDSARef, FAfterTrader.CCDSARef);
          fldMandateID    : WriteDataChange (AuditStrings, 'Bank Account', DecryptBankMandateID(FBeforeTrader.acMandateID),
                                                                           DecryptBankMandateID(FAfterTrader.acMandateID));
          fldMandateDate  : WriteDataChange (AuditStrings, 'Card Number', FBeforeTrader.acMandateDate, FAfterTrader.acMandateDate);
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

