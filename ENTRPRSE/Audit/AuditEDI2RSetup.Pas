Unit AuditEDI2RSetup;

Interface

Uses Classes, AuditBase, VarConst, GlobVar;

Type
  TEDIRSetupAudit = Class (TAuditBase)
  Private
    FBeforeEDIR2Setup : EDI2Rec;
    FAfterEDIR2Setup  : EDI2Rec;

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
  flgYourEmailName          = 1;
  flgYourEmailAddress       = 2;
  flgSMTPServerAddress      = 3;

  flgDefaultPriority        = 4;
  flgUseMAPIToSendEmail     = 5;
  flgAttachedPrinter        = 6;

  flgAttachedMethod         = 7;
  flgFaxPrinterDriver       = 8;
  flgFaxUsing               = 9;

  flgFaxFromName            = 10;
  flgFaxFromTelNo           = 11;
  flgFaxInterfacePath       = 12;

  TotFields = flgFaxInterfacePath+1;

//=========================================================================

Constructor TEDIRSetupAudit.Create;
Begin // Create
  Inherited Create;
  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TEDIRSetupAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TEDIRSetupAudit.GetBeforeData : Pointer;
Begin
  Result := @FBeforeEDIR2Setup;
End;

Procedure TEDIRSetupAudit.SetBeforeData (Value : Pointer);
Begin
  Move (Value^, FBeforeEDIR2Setup, SizeOf(FBeforeEDIR2Setup));
End;

//------------------------------

Function TEDIRSetupAudit.GetAfterData : Pointer;
Begin
  Result := @FAfterEDIR2Setup;
End;

Procedure TEDIRSetupAudit.SetAfterData (Value : Pointer);
Begin
  Move (Value^, FAfterEDIR2Setup, SizeOf(FAfterEDIR2Setup));
End;

//-------------------------------------------------------------------------

Function TEDIRSetupAudit.NeedAuditEntry : Boolean;
Var
  I              : SmallInt;
Begin

  // We will flag all the data that has been changed
  FChangedData[flgYourEmailName]      := (FBeforeEDIR2Setup.EDI2Value.EMName      <>   FAfterEDIR2Setup.EDI2Value.EMName);
  FChangedData[flgYourEmailAddress]   := (FBeforeEDIR2Setup.EDI2Value.EMAddress   <>   FAfterEDIR2Setup.EDI2Value.EMAddress);
  FChangedData[flgSMTPServerAddress]  := (FBeforeEDIR2Setup.EDI2Value.EMSMTP      <>   FAfterEDIR2Setup.EDI2Value.EMSMTP);
  FChangedData[flgDefaultPriority]    := (FBeforeEDIR2Setup.EDI2Value.EMPriority  <>   FAfterEDIR2Setup.EDI2Value.EMPriority);
  FChangedData[flgUseMAPIToSendEmail] := (FBeforeEDIR2Setup.EDI2Value.EMUseMAPI   <>   FAfterEDIR2Setup.EDI2Value.EMUseMAPI);
  FChangedData[flgAttachedPrinter]    := (FBeforeEDIR2Setup.EDI2Value.EmailPrnN   <>   FAfterEDIR2Setup.EDI2Value.EmailPrnN);
  FChangedData[flgAttachedMethod]     := (FBeforeEDIR2Setup.EDI2Value.emAttchMode <>   FAfterEDIR2Setup.EDI2Value.emAttchMode);
  FChangedData[flgFaxPrinterDriver]   := (FBeforeEDIR2Setup.EDI2Value.FaxPrnN     <>   FAfterEDIR2Setup.EDI2Value.FaxPrnN);
  FChangedData[flgFaxUsing]           := (FBeforeEDIR2Setup.EDI2Value.FxUseMAPI   <>   FAfterEDIR2Setup.EDI2Value.FxUseMAPI);
  FChangedData[flgFaxFromName]        := (FBeforeEDIR2Setup.EDI2Value.FxName      <>   FAfterEDIR2Setup.EDI2Value.FxName);
  FChangedData[flgFaxFromTelNo]       := (FBeforeEDIR2Setup.EDI2Value.FxPhone     <>   FAfterEDIR2Setup.EDI2Value.FxPhone);
  FChangedData[flgFaxInterfacePath]   := (FBeforeEDIR2Setup.EDI2Value.FaxDLLPath  <>   FAfterEDIR2Setup.EDI2Value.FaxDLLPath);

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

Procedure TEDIRSetupAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
  BeforeDefPriority : String;
  AfterDefPriority  : String;
  BeforeAttchedMeth : String;
  AfterAttchedMeth  : String;
  BeforeFaxUsing    : String;
  AfterFaxUsing     : String;
Begin

  // Dealing with Default Priority
  if (FBeforeEDIR2Setup.EDI2Value.EMPriority <> FAfterEDIR2Setup.EDI2Value.EMPriority) Then
  Begin
     if (FBeforeEDIR2Setup.EDI2Value.EMPriority = 0) Then
        BeforeDefPriority := 'Low'
     else
       if (FBeforeEDIR2Setup.EDI2Value.EMPriority = 1) Then
          BeforeDefPriority := 'Normal'
       else
          BeforeDefPriority := 'High';

     if (FAfterEDIR2Setup.EDI2Value.EMPriority = 0) Then
        AfterDefPriority := 'Low'
     else
       if (FAfterEDIR2Setup.EDI2Value.EMPriority = 1) Then
          AfterDefPriority := 'Normal'
       else
          AfterDefPriority := 'High';
   End;

  // Dealing with Attachement Method
  if (FBeforeEDIR2Setup.EDI2Value.emAttchMode <> FAfterEDIR2Setup.EDI2Value.emAttchMode) Then
  Begin
     if (FBeforeEDIR2Setup.EDI2Value.emAttchMode = 0) Then
        BeforeAttchedMeth := 'Internal EDF Format'
     else
       if (FBeforeEDIR2Setup.EDI2Value.emAttchMode = 1) Then
          BeforeAttchedMeth := 'Adobe Acrobat PDF'
       else
          BeforeAttchedMeth := 'Internal PDF Format';

     if (FAfterEDIR2Setup.EDI2Value.emAttchMode = 0) Then
        AfterAttchedMeth := 'Internal EDF Format'
     else
       if (FAfterEDIR2Setup.EDI2Value.emAttchMode = 1) Then
          AfterAttchedMeth := 'Adobe Acrobat PDF'
       else
          AfterAttchedMeth := 'Internal PDF Format';
   End;

  // Dealing with Fax Using
  if (FBeforeEDIR2Setup.EDI2Value.FxUseMAPI <> FAfterEDIR2Setup.EDI2Value.FxUseMAPI) Then
  Begin
     if (FBeforeEDIR2Setup.EDI2Value.FxUseMAPI = 0) Then
        BeforeFaxUsing := 'Exchequer eComms'
     else
       if (FBeforeEDIR2Setup.EDI2Value.FxUseMAPI = 1) Then
          BeforeFaxUsing := 'MAPI'
       else
          BeforeFaxUsing := 'Third Party Fax';

     if (FAfterEDIR2Setup.EDI2Value.FxUseMAPI = 0) Then
        AfterFaxUsing := 'Exchequer eComms'
     else
       if (FAfterEDIR2Setup.EDI2Value.FxUseMAPI = 1) Then
          AfterFaxUsing := 'MAPI'
       else
          AfterFaxUsing := 'Third Party Fax';
   End;

  If (Destination = adAuditTrail) Then
  Begin
    // MH 13/02/2013 v7.0.2: Added missing subtitle
    WriteAuditSubTitle (AuditStrings, 'System Setup - General Settings (Fax/Email Tab)', '');
    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then
      Begin
        Case I Of                                              //   12345678901234567890
            flgYourEmailName      : WriteDataChange (AuditStrings, 'Your Email Name',     FBeforeEDIR2Setup.EDI2Value.EmailPrnN,                        FAfterEDIR2Setup.EDI2Value.EmailPrnN);
            flgYourEmailAddress   : WriteDataChange (AuditStrings, 'Your Email Address',  FBeforeEDIR2Setup.EDI2Value.EMAddress,                        FAfterEDIR2Setup.EDI2Value.EMAddress);
            flgSMTPServerAddress  : WriteDataChange (AuditStrings, 'SMTO Server Addr',    FBeforeEDIR2Setup.EDI2Value.EMSMTP,                           FAfterEDIR2Setup.EDI2Value.EmSMTP);

            flgDefaultPriority    : WriteDataChange (AuditStrings, 'Default Priority',    BeforeDefPriority,                                            AfterDefPriority);
            flgUseMAPIToSendEmail : WriteDataChange (AuditStrings, 'Use MAPI send email', BoolToStr(FBeforeEDIR2Setup.EDI2Value.EMUseMAPI, True),       BoolToStr(FAfterEDIR2Setup.EDI2Value.EMUseMAPI, True));
            flgAttachedPrinter    : WriteDataChange (AuditStrings, 'Attached Printer',    FBeforeEDIR2Setup.EDI2Value.EmailPrnN,                        FAfterEDIR2Setup.EDI2Value.EmailPrnN);

            flgAttachedMethod     : WriteDataChange (AuditStrings, 'Attached Method',     BeforeAttchedMeth,                                            AfterAttchedMeth);
            flgFaxPrinterDriver   : WriteDataChange (AuditStrings, 'Fax Printer Driver',  FBeforeEDIR2Setup.EDI2Value.FaxPrnN,                          FAfterEDIR2Setup.EDI2Value.FaxPrnN);
            flgFaxUsing           : WriteDataChange (AuditStrings, 'Fax Using',           BeforeFaxUsing,                                               AfterFaxUsing);

            flgFaxFromName        : WriteDataChange (AuditStrings, 'Fax From Name',       FBeforeEDIR2Setup.EDI2Value.FxName,                           FAfterEDIR2Setup.EDI2Value.FxName);
            flgFaxFromTelNo       : WriteDataChange (AuditStrings, 'Fax From Tel. No.',   FBeforeEDIR2Setup.EDI2Value.FxPhone,                          FAfterEDIR2Setup.EDI2Value.FxPhone);
            flgFaxInterfacePath   : WriteDataChange (AuditStrings, 'Fax Interface Path',  FBeforeEDIR2Setup.EDI2Value.FaxDLLPath,                       FAfterEDIR2Setup.EDI2Value.FaxDLLPath);
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)
End; // WriteAuditData

//=========================================================================


End.

