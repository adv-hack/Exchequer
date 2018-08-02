Unit AuditCIS340Setup;

Interface

Uses Classes, AuditBase, VarConst, GlobVar;

Type
  TCIS340SetupAudit = Class (TAuditBase)
  Private
    FBeforeCIS340Setup : CIS340RecT;
    FAfterCIS340Setup  : CIS340RecT;

    BeforeSubMitType   : String;
    AfterSubMitType    : String;
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

Uses SysUtils, ETDateU, JChkUseU, JobSup1U, ETMiscU, BTSupU1;

Const
  fldTypeOfSubmitter    = 0;
  fldCISNNO             = 1;
  fldCISUTR             = 2;
  fldCISACCONo          = 3;

  TotFields = fldCISACCONo + 1;

//=========================================================================

Constructor TCIS340SetupAudit.Create;
Begin // Create
  Inherited Create;
  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TCIS340SetupAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TCIS340SetupAudit.GetBeforeData : Pointer;
Begin
  Result := @FBeforeCIS340Setup;
End;

Procedure TCIS340SetupAudit.SetBeforeData (Value : Pointer);
Begin
  Move (Value^, FBeforeCIS340Setup, SizeOf(FBeforeCIS340Setup));
End;

//------------------------------

Function TCIS340SetupAudit.GetAfterData : Pointer;
Begin
  Result := @FAfterCIS340Setup;
End;

Procedure TCIS340SetupAudit.SetAfterData (Value : Pointer);
Begin
  Move (Value^, FAfterCIS340Setup, SizeOf(FAfterCIS340Setup));
End;

//-------------------------------------------------------------------------

Function TCIS340SetupAudit.NeedAuditEntry : Boolean;
Var
  I              : SmallInt;
  SubmitTypeList : TStringList;
Begin

  // Setup the Submit Type List if any new ones are added place it here in the appropriate order
  BeforeSubMitType    := '';
  AfterSubMitType     := '';

  // The contents have been taken from SetCISU.pas and the CBSubType.Items Component
  // Any new entries should be added to this list in the appropriate order
  SubmitTypeList := TStringList.Create;
  SubmitTypeList.Clear;
  SubmitTypeList.Add('Individual');
  SubmitTypeList.Add('Company');
  SubmitTypeList.Add('Agent');
  SubmitTypeList.Add('Bureau');
  SubmitTypeList.Add('Partnership');
  SubmitTypeList.Add('Trust');
  SubmitTypeList.Add('Employer');
  SubmitTypeList.Add('Government');
  SubmitTypeList.Add('Acting in Capacity');
  SubmitTypeList.Add('Other');

  BeforeSubMitType := SubmitTypeList.Strings[FBeforeCIS340Setup.CIS340.IGSubType];
  AfterSubMitType  := SubmitTypeList.Strings[FAfterCIS340Setup.CIS340.IGSubType];

  // We will flag all the data that has been changed
  FChangedData[fldTypeOfSubmitter]      := (FBeforeCIS340Setup.CIS340.IGSubType <> FAfterCIS340Setup.CIS340.IGSubType);
  FChangedData[fldCISNNO]               := (FBeforeCIS340Setup.CIS340.CISCNINO <> FAfterCIS340Setup.CIS340.CISCNINO);
  FChangedData[fldCISUTR]               := (FBeforeCIS340Setup.CIS340.CISCUTR <> FAfterCIS340Setup.CIS340.CISCUTR);
  FChangedData[fldCISACCONo]            := (FBeforeCIS340Setup.CIS340.CISACCONo <> FAfterCIS340Setup.CIS340.CISACCONo);

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

  SubmitTypeList.Free;
End;

//-------------------------------------------------------------------------

Procedure TCIS340SetupAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
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
          fldTypeOfSubmitter    : WriteDataChange (AuditStrings, 'Type of Submitter', BeforeSubMitType, AfterSubMitType);
          fldCISNNO             : WriteDataChange (AuditStrings, 'Contract NINO', FBeforeCIS340Setup.CIS340.CISCNINO, FAfterCIS340Setup.CIS340.CISCNINO);
          fldCISUTR             : WriteDataChange (AuditStrings, 'UTR', FBeforeCIS340Setup.CIS340.CISCUTR, FAfterCIS340Setup.CIS340.CISCUTR);
          fldCISACCONo          : WriteDataChange (AuditStrings, 'A/C Office Ref', FBeforeCIS340Setup.CIS340.CISACCONo, FAfterCIS340Setup.CIS340.CISACCONo);
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

