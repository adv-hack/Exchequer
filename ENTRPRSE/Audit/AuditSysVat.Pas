Unit AuditSysVat;

Interface

Uses Classes, AuditBase, VarConst, GlobVar;

Type
  TSysVatAudit = Class (TAuditBase)
  Private
    FBeforeVat : VATRecT;
    FAfterVAT  : VATRecT;

    BeforeCurTaxPeriod : LongDate;
    AfterCurTaxPeriod  : LongDate;

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
    // MH 08/03/2012 v6.10 ABSEXCH-12127: Added Destination flag to WriteAuditData so confidential details
    // can be suppressed if the logging is writing to a plain text .log file instead of the encrypted audit file
    Procedure WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);  Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TTraderAudit

Implementation

Uses SysUtils, ETDateU, ETMiscU, SysU1;

Const
  fldDescStandard  = 0;
  fldRateStandard  = 1;
  fldGoodsStandard = 2;

  fldDescExempt    = 3;
  fldRateExempt    = 4;
  fldGoodsExempt   = 5;

  fldDescZero      = 6;
  fldRateZero      = 7;
  fldGoodsZero     = 8;

  fldDescRate1     = 9;
  fldRateRate1     = 10;
  fldGoodsRate1    = 11;

  fldDescRate2     = 12;
  fldRateRate2     = 13;
  fldGoodsRate2    = 14;

  fldDescRate3     = 15;
  fldRateRate3     = 16;
  fldGoodsRate3    = 17;

  fldDescRate4     = 18;
  fldRateRate4     = 19;
  fldGoodsRate4    = 20;

  fldDescRate5     = 21;
  fldRateRate5     = 22;
  fldGoodsRate5    = 23;

  fldDescRate6     = 24;
  fldRateRate6     = 25;
  fldGoodsRate6    = 26;

  fldDescRate7     = 27;
  fldRateRate7     = 28;
  fldGoodsRate7    = 29;

  fldDescRate8     = 30;
  fldRateRate8     = 31;
  fldGoodsRate8    = 32;

  fldDescRate9     = 33;
  fldRateRate9     = 34;
  fldGoodsRate9    = 35;

  fldDescRate10     = 36;
  fldRateRate10     = 37;
  fldGoodsRate10    = 38;

  fldDescRate11     = 39;
  fldRateRate11     = 40;
  fldGoodsRate11    = 41;

  fldDescRate12     = 42;
  fldRateRate12     = 43;
  fldGoodsRate12    = 44;

  fldDescRate13     = 45;
  fldRateRate13     = 46;
  fldGoodsRate13    = 47;

  fldDescRate14     = 48;
  fldRateRate14     = 49;
  fldGoodsRate14    = 50;

  fldDescRate15     = 51;
  fldRateRate15     = 52;
  fldGoodsRate15    = 53;

  fldDescRate16     = 54;
  fldRateRate16     = 55;
  fldGoodsRate16    = 56;

  fldDescRate17     = 57;
  fldRateRate17     = 58;
  fldGoodsRate17    = 59;

  fldDescRate18     = 60;
  fldRateRate18     = 61;
  fldGoodsRate18    = 62;

  flgLastTaxReturn    = 63;
  flgTaxReturnMonths  = 64;
  flgCurrentTaxPeriod = 65;
  flgTaxScheme        = 66;

  // Added to deal with VAT options on the General Settings Screen
  fldECSalesThres     = 67;
  fldEnableECServ     = 68;
  flgReportPrnN       = 69;
  flgFormsPrnN        = 70;

  // MH 10/05/2013 ABSEXCH-13793 v7.0.4: Added new fields for XML VAT100 Export
  fldVAT100UserId     = 71;
  fldVAT100Password   = 72;
  fldVAT100SenderType = 73;

  TotFields = fldVAT100SenderType+1;

//=========================================================================

Constructor TSysVatAudit.Create;
Begin // Create
  Inherited Create;

  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TSysVatAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSysVatAudit.GetBeforeData : Pointer;
Begin // GetBeforeData
  Result := @FBeforeVAT;
End; // GetBeforeData

Procedure TSysVatAudit.SetBeforeData (Value : Pointer);
Begin // SetBeforeData
  Move (Value^, FBeforeVAT, SizeOf(FBeforeVAT));
End; // SetBeforeData

//------------------------------

Function TSysVatAudit.GetAfterData : Pointer;
Begin // GetAfterData
  Result := @FAfterVAT;
End; // GetAfterData

Procedure TSysVatAudit.SetAfterData (Value : Pointer);
Begin // SetAfterData
  Move (Value^, FAfterVAT, SizeOf(FAfterVAT));
End; // SetAfterData

//-------------------------------------------------------------------------

Function TSysVatAudit.NeedAuditEntry : Boolean;
Var
  I : SmallInt;
Begin // NeedAuditEntry

   // Initialise the variables used
   BeforeCurTaxPeriod  := '';
   AfterCurTaxPeriod   := '';

   BeforeCurTaxPeriod  := Calc_NewVATPeriod(FBeforeVAT.VATRAtes.VATReturnDate,Trunc(FBeforeVAT.VATRAtes.VATInterval));
   AfterCurTaxPeriod   := Calc_NewVATPeriod(FAfterVAT.VATRAtes.VATReturnDate,Trunc(FAfterVAT.VATRAtes.VATInterval));

   // Added new flag so if any details pertaining to General Settings screen have been changed then I will have a sub menu title to
   // depict this so that the customer does not get confused where the changes occured.
   GeneralSetFlag      := False;

   if ((FBeforeVAT.VATRAtes.ECSalesThreshold)   <>     (FAfterVAT.VATRAtes.ECSalesThreshold)) Or
       ((FBeforeVAT.VATRAtes.EnableECServices)  <>     (FAfterVAT.VATRAtes.EnableECServices)) Or
       ((FBeforeVAT.VATRAtes.ReportPrnN)        <>     (FAfterVAT.VATRAtes.ReportPrnN)) Or
       ((FBeforeVAT.VATRAtes.FormsPrnN)         <>     (FAfterVAT.VATRAtes.FormsPrnN)) Then
        GeneralSetFlag := True;

   FChangedData[fldDescStandard]  := (FBeforeVAT.VATRAtes.VAT[Standard].Desc) <> (FAfterVAT.VATRAtes.VAT[Standard].Desc);
   FChangedData[fldRateStandard]  := (FBeforeVAT.VATRAtes.VAT[Standard].Rate) <> (FAfterVAT.VATRAtes.VAT[Standard].Rate);
   FChangedData[fldGoodsStandard] := (FBeforeVAT.VATRAtes.VAT[Standard].Include) <> (FAfterVAT.VATRAtes.VAT[Standard].Include);

   FChangedData[fldDescExempt]    := (FBeforeVAT.VATRAtes.VAT[Exempt].Desc) <> (FAfterVAT.VATRAtes.VAT[Exempt].Desc);
   FChangedData[fldRateExempt]    := (FBeforeVAT.VATRAtes.VAT[Exempt].Rate) <> (FAfterVAT.VATRAtes.VAT[Exempt].Rate);
   FChangedData[fldGoodsExempt]   := (FBeforeVAT.VATRAtes.VAT[Exempt].Include) <> (FAfterVAT.VATRAtes.VAT[Exempt].Include);

   FChangedData[fldDescZero]      := (FBeforeVAT.VATRAtes.VAT[Zero].Desc) <> (FAfterVAT.VATRAtes.VAT[Zero].Desc);
   FChangedData[fldRateZero]      := (FBeforeVAT.VATRAtes.VAT[Zero].Rate) <> (FAfterVAT.VATRAtes.VAT[Zero].Rate);
   FChangedData[fldGoodsZero]     := (FBeforeVAT.VATRAtes.VAT[Zero].Include) <> (FAfterVAT.VATRAtes.VAT[Zero].Include);

   FChangedData[fldDescRate1]     := (FBeforeVAT.VATRAtes.VAT[Rate1].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate1].Desc);
   FChangedData[fldRateRate1]     := (FBeforeVAT.VATRAtes.VAT[Rate1].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate1].Rate);
   FChangedData[fldGoodsRate1]    := (FBeforeVAT.VATRAtes.VAT[Rate1].Include) <> (FAfterVAT.VATRAtes.VAT[Rate1].Include);

   FChangedData[fldDescRate2]     := (FBeforeVAT.VATRAtes.VAT[Rate2].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate2].Desc);
   FChangedData[fldRateRate2]     := (FBeforeVAT.VATRAtes.VAT[Rate2].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate2].Rate);
   FChangedData[fldGoodsRate2]    := (FBeforeVAT.VATRAtes.VAT[Rate2].Include) <> (FAfterVAT.VATRAtes.VAT[Rate2].Include);

   FChangedData[fldDescRate3]     := (FBeforeVAT.VATRAtes.VAT[Rate3].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate3].Desc);
   FChangedData[fldRateRate3]     := (FBeforeVAT.VATRAtes.VAT[Rate3].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate3].Rate);
   FChangedData[fldGoodsRate3]    := (FBeforeVAT.VATRAtes.VAT[Rate3].Include) <> (FAfterVAT.VATRAtes.VAT[Rate3].Include);

   FChangedData[fldDescRate4]     := (FBeforeVAT.VATRAtes.VAT[Rate4].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate4].Desc);
   FChangedData[fldRateRate4]     := (FBeforeVAT.VATRAtes.VAT[Rate4].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate4].Rate);
   FChangedData[fldGoodsRate4]    := (FBeforeVAT.VATRAtes.VAT[Rate4].Include) <> (FAfterVAT.VATRAtes.VAT[Rate4].Include);

   FChangedData[fldDescRate5]     := (FBeforeVAT.VATRAtes.VAT[Rate5].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate5].Desc);
   FChangedData[fldRateRate5]     := (FBeforeVAT.VATRAtes.VAT[Rate5].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate5].Rate);
   FChangedData[fldGoodsRate5]    := (FBeforeVAT.VATRAtes.VAT[Rate5].Include) <> (FAfterVAT.VATRAtes.VAT[Rate5].Include);

   FChangedData[fldDescRate6]     := (FBeforeVAT.VATRAtes.VAT[Rate6].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate6].Desc);
   FChangedData[fldRateRate6]     := (FBeforeVAT.VATRAtes.VAT[Rate6].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate6].Rate);
   FChangedData[fldGoodsRate6]    := (FBeforeVAT.VATRAtes.VAT[Rate6].Include) <> (FAfterVAT.VATRAtes.VAT[Rate6].Include);

   FChangedData[fldDescRate7]     := (FBeforeVAT.VATRAtes.VAT[Rate7].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate7].Desc);
   FChangedData[fldRateRate7]     := (FBeforeVAT.VATRAtes.VAT[Rate7].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate7].Rate);
   FChangedData[fldGoodsRate7]    := (FBeforeVAT.VATRAtes.VAT[Rate7].Include) <> (FAfterVAT.VATRAtes.VAT[Rate7].Include);

   FChangedData[fldDescRate8]     := (FBeforeVAT.VATRAtes.VAT[Rate8].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate8].Desc);
   FChangedData[fldRateRate8]     := (FBeforeVAT.VATRAtes.VAT[Rate8].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate8].Rate);
   FChangedData[fldGoodsRate8]    := (FBeforeVAT.VATRAtes.VAT[Rate8].Include) <> (FAfterVAT.VATRAtes.VAT[Rate8].Include);

   FChangedData[fldDescRate9]     := (FBeforeVAT.VATRAtes.VAT[Rate9].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate9].Desc);
   FChangedData[fldRateRate9]     := (FBeforeVAT.VATRAtes.VAT[Rate9].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate9].Rate);
   FChangedData[fldGoodsRate9]    := (FBeforeVAT.VATRAtes.VAT[Rate9].Include) <> (FAfterVAT.VATRAtes.VAT[Rate9].Include);

   FChangedData[fldDescRate10]     := (FBeforeVAT.VATRAtes.VAT[Rate10].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate10].Desc);
   FChangedData[fldRateRate10]     := (FBeforeVAT.VATRAtes.VAT[Rate10].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate10].Rate);
   FChangedData[fldGoodsRate10]    := (FBeforeVAT.VATRAtes.VAT[Rate10].Include) <> (FAfterVAT.VATRAtes.VAT[Rate10].Include);

   FChangedData[fldDescRate11]     := (FBeforeVAT.VATRAtes.VAT[Rate11].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate11].Desc);
   FChangedData[fldRateRate11]     := (FBeforeVAT.VATRAtes.VAT[Rate11].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate11].Rate);
   FChangedData[fldGoodsRate11]    := (FBeforeVAT.VATRAtes.VAT[Rate11].Include) <> (FAfterVAT.VATRAtes.VAT[Rate11].Include);

   FChangedData[fldDescRate12]     := (FBeforeVAT.VATRAtes.VAT[Rate12].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate12].Desc);
   FChangedData[fldRateRate12]     := (FBeforeVAT.VATRAtes.VAT[Rate12].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate12].Rate);
   FChangedData[fldGoodsRate12]    := (FBeforeVAT.VATRAtes.VAT[Rate12].Include) <> (FAfterVAT.VATRAtes.VAT[Rate12].Include);

   FChangedData[fldDescRate13]     := (FBeforeVAT.VATRAtes.VAT[Rate13].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate13].Desc);
   FChangedData[fldRateRate13]     := (FBeforeVAT.VATRAtes.VAT[Rate13].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate13].Rate);
   FChangedData[fldGoodsRate13]    := (FBeforeVAT.VATRAtes.VAT[Rate13].Include) <> (FAfterVAT.VATRAtes.VAT[Rate13].Include);

   FChangedData[fldDescRate14]     := (FBeforeVAT.VATRAtes.VAT[Rate14].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate14].Desc);
   FChangedData[fldRateRate14]     := (FBeforeVAT.VATRAtes.VAT[Rate14].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate14].Rate);
   FChangedData[fldGoodsRate14]    := (FBeforeVAT.VATRAtes.VAT[Rate14].Include) <> (FAfterVAT.VATRAtes.VAT[Rate14].Include);

   FChangedData[fldDescRate15]     := (FBeforeVAT.VATRAtes.VAT[Rate15].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate15].Desc);
   FChangedData[fldRateRate15]     := (FBeforeVAT.VATRAtes.VAT[Rate15].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate15].Rate);
   FChangedData[fldGoodsRate15]    := (FBeforeVAT.VATRAtes.VAT[Rate15].Include) <> (FAfterVAT.VATRAtes.VAT[Rate15].Include);

   FChangedData[fldDescRate16]     := (FBeforeVAT.VATRAtes.VAT[Rate16].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate16].Desc);
   FChangedData[fldRateRate16]     := (FBeforeVAT.VATRAtes.VAT[Rate16].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate16].Rate);
   FChangedData[fldGoodsRate16]    := (FBeforeVAT.VATRAtes.VAT[Rate16].Include) <> (FAfterVAT.VATRAtes.VAT[Rate16].Include);

   FChangedData[fldDescRate17]     := (FBeforeVAT.VATRAtes.VAT[Rate17].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate17].Desc);
   FChangedData[fldRateRate17]     := (FBeforeVAT.VATRAtes.VAT[Rate17].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate17].Rate);
   FChangedData[fldGoodsRate17]    := (FBeforeVAT.VATRAtes.VAT[Rate17].Include) <> (FAfterVAT.VATRAtes.VAT[Rate17].Include);

   FChangedData[fldDescRate18]     := (FBeforeVAT.VATRAtes.VAT[Rate18].Desc) <> (FAfterVAT.VATRAtes.VAT[Rate18].Desc);
   FChangedData[fldRateRate18]     := (FBeforeVAT.VATRAtes.VAT[Rate18].Rate) <> (FAfterVAT.VATRAtes.VAT[Rate18].Rate);
   FChangedData[fldGoodsRate18]    := (FBeforeVAT.VATRAtes.VAT[Rate18].Include) <> (FAfterVAT.VATRAtes.VAT[Rate18].Include);

   FChangedData[flgLastTaxReturn]    := (FBeforeVAT.VATRAtes.VATReturnDate <> FAfterVAT.VATRAtes.VATReturnDate);
   FChangedData[flgTaxReturnMonths]  := (FBeforeVAT.VATRAtes.VATInterval <> FAfterVAT.VATRAtes.VATInterval);
   FChangedData[flgCurrentTaxPeriod] := (BeforeCurTaxPeriod <> AfterCurTaxPeriod);
   FChangedData[flgTaxScheme]        := (FBeforeVAT.VATRAtes.VATScheme <> FAfterVAT.VATRAtes.VATScheme);

  // Added to deal with VAT options on the General Settings Screen
   FChangedData[fldECSalesThres]     := (FBeforeVAT.VATRAtes.ECSalesThreshold)  <>     (FAfterVAT.VATRAtes.ECSalesThreshold);
   FChangedData[fldEnableECServ]     := (FBeforeVAT.VATRAtes.EnableECServices)  <>     (FAfterVAT.VATRAtes.EnableECServices);
   FChangedData[flgReportPrnN]       := (FBeforeVAT.VATRAtes.ReportPrnN)        <>     (FAfterVAT.VATRAtes.ReportPrnN);
   FChangedData[flgFormsPrnN]        := (FBeforeVAT.VATRAtes.FormsPrnN)         <>     (FAfterVAT.VATRAtes.FormsPrnN);

  // MH 10/05/2013 ABSEXCH-13793 v7.0.4: Added new fields for XML VAT100 Export
  FChangedData[fldVAT100UserId]      := (FBeforeVAT.VATRAtes.VAT100UserID <> FAfterVAT.VATRAtes.VAT100UserID);
  FChangedData[fldVAT100Password]    := (FBeforeVAT.VATRAtes.VAT100Password <> FAfterVAT.VATRAtes.VAT100Password);
  FChangedData[fldVAT100SenderType]  := (FBeforeVAT.VATRAtes.VAT100SenderType <> FAfterVAT.VATRAtes.VAT100SenderType);

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

Procedure TSysVatAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I : SmallInt;
Begin // WriteAuditData
  If (Destination = adAuditTrail) Then
  Begin
    // CA 25/02/2013 v7.0.2: Added missing subtitle
    if (GeneralSetFlag = True) Then
      WriteAuditSubTitle (AuditStrings, 'System Setup - VAT / System Setup - General Settings', '')
    else
      WriteAuditSubTitle (AuditStrings, 'System Setup - VAT', '');

    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then
      Begin
        Case I Of
          fldDescStandard  : WriteDataChange (AuditStrings, 'Code S Description', FBeforeVAT.VATRAtes.VAT[Standard].Desc, FAfterVAT.VATRAtes.VAT[Standard].Desc);
          fldRateStandard  : WriteDataChange (AuditStrings, 'Code S Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Standard].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Standard].Rate)));
          fldGoodsStandard : WriteDataChange (AuditStrings, 'Code S Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Standard].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Standard].Include, True));

          fldDescExempt    : WriteDataChange (AuditStrings, 'Code E Description', FBeforeVAT.VATRAtes.VAT[Exempt].Desc, FAfterVAT.VATRAtes.VAT[Exempt].Desc);
          fldRateExempt    : WriteDataChange (AuditStrings, 'Code E Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Exempt].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Exempt].Rate)));
          fldGoodsExempt   : WriteDataChange (AuditStrings, 'Code E Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Exempt].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Exempt].Include, True));

          fldDescZero      : WriteDataChange (AuditStrings, 'Code Z Description', FBeforeVAT.VATRAtes.VAT[Zero].Desc, FAfterVAT.VATRAtes.VAT[Zero].Desc);
          fldRateZero      : WriteDataChange (AuditStrings, 'Code Z Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Zero].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Zero].Rate)));
          fldGoodsZero     : WriteDataChange (AuditStrings, 'Code Z Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Zero].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Zero].Include, True));

          fldDescRate1     : WriteDataChange (AuditStrings, 'Code 1 Description', FBeforeVAT.VATRAtes.VAT[Rate1].Desc, FAfterVAT.VATRAtes.VAT[Rate1].Desc);
          fldRateRate1     : WriteDataChange (AuditStrings, 'Code 1 Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate1].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate1].Rate)));
          fldGoodsRate1    : WriteDataChange (AuditStrings, 'Code 1 Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate1].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate1].Include, True));

          fldDescRate2     : WriteDataChange (AuditStrings, 'Code 2 Description', FBeforeVAT.VATRAtes.VAT[Rate2].Desc, FAfterVAT.VATRAtes.VAT[Rate2].Desc);
          fldRateRate2     : WriteDataChange (AuditStrings, 'Code 2 Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate2].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate2].Rate)));
          fldGoodsRate2    : WriteDataChange (AuditStrings, 'Code 2 Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate2].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate2].Include, True));

          fldDescRate3     : WriteDataChange (AuditStrings, 'Code 3/A Description', FBeforeVAT.VATRAtes.VAT[Rate3].Desc, FAfterVAT.VATRAtes.VAT[Rate3].Desc);
          fldRateRate3     : WriteDataChange (AuditStrings, 'Code 3/A Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate3].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate3].Rate)));
          fldGoodsRate3    : WriteDataChange (AuditStrings, 'Code 3/A Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate3].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate3].Include, True));

          fldDescRate4     : WriteDataChange (AuditStrings, 'Code 4/D Description', FBeforeVAT.VATRAtes.VAT[Rate4].Desc, FAfterVAT.VATRAtes.VAT[Rate4].Desc);
          fldRateRate4     : WriteDataChange (AuditStrings, 'Code 4/D Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate4].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate4].Rate)));
          fldGoodsRate4    : WriteDataChange (AuditStrings, 'Code 4/D Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate4].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate4].Include, True));

          fldDescRate5     : WriteDataChange (AuditStrings, 'Code 5 Description', FBeforeVAT.VATRAtes.VAT[Rate5].Desc, FAfterVAT.VATRAtes.VAT[Rate5].Desc);
          fldRateRate5     : WriteDataChange (AuditStrings, 'Code 5 Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate5].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate5].Rate)));
          fldGoodsRate5    : WriteDataChange (AuditStrings, 'Code 5 Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate5].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate5].Include, True));

          fldDescRate6     : WriteDataChange (AuditStrings, 'Code 6 Description', FBeforeVAT.VATRAtes.VAT[Rate6].Desc, FAfterVAT.VATRAtes.VAT[Rate6].Desc);
          fldRateRate6     : WriteDataChange (AuditStrings, 'Code 6 Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate6].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate6].Rate)));
          fldGoodsRate6    : WriteDataChange (AuditStrings, 'Code 6 Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate6].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate6].Include, True));

          fldDescRate7     : WriteDataChange (AuditStrings, 'Code 7 Description', FBeforeVAT.VATRAtes.VAT[Rate7].Desc, FAfterVAT.VATRAtes.VAT[Rate7].Desc);
          fldRateRate7     : WriteDataChange (AuditStrings, 'Code 7 Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate7].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate7].Rate)));
          fldGoodsRate7    : WriteDataChange (AuditStrings, 'Code 7 Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate7].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate7].Include, True));

          fldDescRate8     : WriteDataChange (AuditStrings, 'Code 8 Description', FBeforeVAT.VATRAtes.VAT[Rate8].Desc, FAfterVAT.VATRAtes.VAT[Rate8].Desc);
          fldRateRate8     : WriteDataChange (AuditStrings, 'Code 8 Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate8].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate8].Rate)));
          fldGoodsRate8    : WriteDataChange (AuditStrings, 'Code 8 Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate8].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate8].Include, True));

          fldDescRate9     : WriteDataChange (AuditStrings, 'Code 9 Description', FBeforeVAT.VATRAtes.VAT[Rate9].Desc, FAfterVAT.VATRAtes.VAT[Rate9].Desc);
          fldRateRate9     : WriteDataChange (AuditStrings, 'Code 9 Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate9].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate9].Rate)));
          fldGoodsRate9    : WriteDataChange (AuditStrings, 'Code 9 Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate9].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate9].Include, True));

          fldDescRate10    : WriteDataChange (AuditStrings, 'Code T Description', FBeforeVAT.VATRAtes.VAT[Rate10].Desc, FAfterVAT.VATRAtes.VAT[Rate10].Desc);
          fldRateRate10    : WriteDataChange (AuditStrings, 'Code T Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate10].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate10].Rate)));
          fldGoodsRate10   : WriteDataChange (AuditStrings, 'Code T Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate10].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate10].Include, True));

          fldDescRate11    : WriteDataChange (AuditStrings, 'Code X Description', FBeforeVAT.VATRAtes.VAT[Rate11].Desc, FAfterVAT.VATRAtes.VAT[Rate11].Desc);
          fldRateRate11    : WriteDataChange (AuditStrings, 'Code X Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate11].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate11].Rate)));
          fldGoodsRate11   : WriteDataChange (AuditStrings, 'Code X Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate11].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate11].Include, True));

          fldDescRate12    : WriteDataChange (AuditStrings, 'Code B Description', FBeforeVAT.VATRAtes.VAT[Rate12].Desc, FAfterVAT.VATRAtes.VAT[Rate12].Desc);
          fldRateRate12    : WriteDataChange (AuditStrings, 'Code B Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate12].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate12].Rate)));
          fldGoodsRate12   : WriteDataChange (AuditStrings, 'Code B Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate12].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate12].Include, True));

          fldDescRate13    : WriteDataChange (AuditStrings, 'Code C Description', FBeforeVAT.VATRAtes.VAT[Rate13].Desc, FAfterVAT.VATRAtes.VAT[Rate13].Desc);
          fldRateRate13    : WriteDataChange (AuditStrings, 'Code C Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate13].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate13].Rate)));
          fldGoodsRate13   : WriteDataChange (AuditStrings, 'Code C Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate13].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate13].Include, True));

          fldDescRate14    : WriteDataChange (AuditStrings, 'Code F Description', FBeforeVAT.VATRAtes.VAT[Rate14].Desc, FAfterVAT.VATRAtes.VAT[Rate14].Desc);
          fldRateRate14    : WriteDataChange (AuditStrings, 'Code F Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate14].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate14].Rate)));
          fldGoodsRate14   : WriteDataChange (AuditStrings, 'Code F Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate14].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate14].Include, True));

          fldDescRate15    : WriteDataChange (AuditStrings, 'Code G Description', FBeforeVAT.VATRAtes.VAT[Rate15].Desc, FAfterVAT.VATRAtes.VAT[Rate15].Desc);
          fldRateRate15    : WriteDataChange (AuditStrings, 'Code G Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate15].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate15].Rate)));
          fldGoodsRate15   : WriteDataChange (AuditStrings, 'Code G Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate15].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate15].Include, True));

          fldDescRate16    : WriteDataChange (AuditStrings, 'Code R Description', FBeforeVAT.VATRAtes.VAT[Rate16].Desc, FAfterVAT.VATRAtes.VAT[Rate16].Desc);
          fldRateRate16    : WriteDataChange (AuditStrings, 'Code R Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate16].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate16].Rate)));
          fldGoodsRate16   : WriteDataChange (AuditStrings, 'Code R Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate16].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate16].Include, True));

          fldDescRate17    : WriteDataChange (AuditStrings, 'Code W Description', FBeforeVAT.VATRAtes.VAT[Rate17].Desc, FAfterVAT.VATRAtes.VAT[Rate17].Desc);
          fldRateRate17    : WriteDataChange (AuditStrings, 'Code W Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate17].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate17].Rate)));
          fldGoodsRate17   : WriteDataChange (AuditStrings, 'Code W Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate17].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate17].Include, True));

          fldDescRate18    : WriteDataChange (AuditStrings, 'Code Y Description', FBeforeVAT.VATRAtes.VAT[Rate18].Desc, FAfterVAT.VATRAtes.VAT[Rate18].Desc);
          fldRateRate18    : WriteDataChange (AuditStrings, 'Code Y Rate', formatfloat('###,###,##0.00%',Pcnt2Full(FBeforeVAT.VATRAtes.VAT[Rate18].Rate)), formatfloat('###,###,##0.00%',Pcnt2Full(FAfterVAT.VATRAtes.VAT[Rate18].Rate)));
          fldGoodsRate18   : WriteDataChange (AuditStrings, 'Code Y Goods', BoolToStr(FBeforeVAT.VATRAtes.VAT[Rate18].Include, True), BoolToStr(FAfterVAT.VATRAtes.VAT[Rate18].Include, True));

          flgLastTaxReturn    : WriteDataChange (AuditStrings, 'Last Tax Return Date', POutDateB(FBeforeVAT.VATRAtes.VATReturnDate), POutDateB(FAfterVAT.VATRAtes.VATReturnDate));
          flgTaxReturnMonths  : WriteDataChange (AuditStrings, 'Tax Return Months', IntToStr(FBeforeVAT.VATRAtes.VATInterval), IntToStr(FAfterVAT.VATRAtes.VATInterval));
          flgCurrentTaxPeriod : WriteDataChange (AuditStrings, 'Current Tax Period', POutDateB(BeforeCurTaxPeriod), POutDateB(AfterCurTaxPeriod));
          flgTaxScheme        : WriteDataChange (AuditStrings, 'Tax Scheme', FBeforeVAT.VATRAtes.VATScheme, FAfterVAT.VATRAtes.VATScheme);

          // Added to deal with VAT options on the General Settings Screen
          fldECSalesThres     : WriteDataChange (AuditStrings, 'EC Sales Threshold',  formatfloat('###,###,##0.00 ;###,###,##0.00-',FBeforeVAT.VATRAtes.ECSalesThreshold),     formatfloat('###,###,##0.00 ;###,###,##0.00-',FAfterVAT.VATRAtes.ECSalesThreshold));
          fldEnableECServ     : WriteDataChange (AuditStrings, 'Enable EC Serv Supp', BoolToStr(FBeforeVAT.VATRAtes.EnableECServices, True),    BoolToStr(FAfterVAT.VATRAtes.EnableECServices, True));
          flgReportPrnN       : WriteDataChange (AuditStrings, 'Def Report Printer',  FBeforeVAT.VATRAtes.ReportPrnN,  FAfterVAT.VATRAtes.ReportPrnN);
          flgFormsPrnN        : WriteDataChange (AuditStrings, 'Def Forms Printer',   FBeforeVAT.VATRAtes.FormsPrnN,   FAfterVAT.VATRAtes.FormsPrnN);

          // MH 10/05/2013 ABSEXCH-13793 v7.0.4: Added new fields for XML VAT100 Export - NOTE: Details Confidential - do not write plain text
          fldVAT100UserId     : WriteDataChange (AuditStrings, 'VAT100 User ID',      StringOfChar('*', Length(FBeforeVAT.VATRAtes.VAT100UserID)), StringOfChar('*', Length(FAfterVAT.VATRAtes.VAT100UserID)));
          fldVAT100Password   : WriteDataChange (AuditStrings, 'VAT100 Password',     StringOfChar('*', Length(FBeforeVAT.VATRAtes.VAT100Password)), StringOfChar('*', Length(FAfterVAT.VATRAtes.VAT100Password)));
          fldVAT100SenderType : WriteDataChange (AuditStrings, 'VAT100 Sender Type',  FBeforeVAT.VATRAtes.VAT100SenderType, FAfterVAT.VATRAtes.VAT100SenderType);
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)

End; // WriteAuditData

//=========================================================================


End.
                                  
