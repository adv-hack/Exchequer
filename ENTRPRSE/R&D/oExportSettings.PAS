unit oExportSettings;

interface

Uses Classes, Dialogs, Forms, StdCtrls, SysUtils, Windows, IniFiles,
     LicRec, VarConst, GlobVar;

Type
  TExportSettings = Class(TObject)
  Private
    FFileDate                   : ShortString;

    FEntPath                    : ShortString;
    FFileVersion                : ShortString;
    FEnter1Date                 : ShortString;
    FEnter1FileVer              : ShortString;

    FExportSettingsResults      : TStringList;
    ReturnsList                 : TStringList;
    StockValueList              : TStringList;

    // Use internal TBits to track what has changed - it will be set in NeedAuditEntry and re-used in WriteAuditData
    FCurrencyNum                : Integer;
    FDebtLMode                  : AnsiString;
    FBUCCF                      : AnsiString;
    FCurConsMeth                : AnsiString;
    FReturns                    : AnsiString;
    FCurrVarTol                 : AnsiString;
    FCountryCode                : AnsiString;
    FAgeByInvoice               : AnsiString;
    FAuthMethod                 : AnsiString;
    FStockValueMeth             : AnsiString;
    FMultiLoc                   : AnsiString;
    FPcntMaskType               : AnsiString;
    FCopyStkToWO                : AnsiString;
    FDefaultPriority            : AnsiString;
    FAttachmentMethod           : AnsiString;
    FFaxUsing                   : AnsiString;
    FTotalCurrencies            : Integer;
    FCurrentTaxPeriod           : LongDate;
    FTaxScheme                  : AnsiString;
    FCurrentCISPeriod           : LongDate;
    FSubmitterType              : AnsiString;
    FGlobalEquivalentDate       : AnsiString;
    FLocalEquivalentDate        : AnsiString;
    FGlobalPeriod               : AnsiString;
    FLocalPeriod                : AnsiString;
    FGlobalStartYear            : AnsiString;
    FLocalStartYear             : AnsiString;
    FOfficeRefOrReverse         : AnsiString;

    // Modifiable Lables
    FVatLabel                   : AnsiString;
    FReturnsLabel               : AnsiString;
    FContractorCISDetailsLabel  : AnsiString;
    FCertificateTypeLabel       : AnsiString;
    FCertificateRefLabel        : AnsiString;
    FTypeOfSubmitterLabel       : AnsiString;
    FOfficeRefOrReverseLabel    : AnsiString;
    FLastReturnsLabel           : AnsiString;
    FCurrentPeriodLabel         : AnsiString;
    FReturnEveryMonthLabel      : AnsiString;
    FVatRateLabel               : AnsiString;

    // Setting Up Permissions
    FCurrencyPermission         : Boolean;
    FVATSetupPermission         : Boolean;
    FCISSetupPermission         : Boolean;
    FControlCodesPermission     : Boolean;
    FF6PeriodPermission         : Boolean;

    // Use internal TBits to track the number of currencies
    FCurrencyData               : TBits;

  Protected
  Public
    Property EntPath               : ShortString       Read FEntPath               Write FEntPath;
    Property ExportSettingsResults : TStringList       Read FExportSettingsResults Write FExportSettingsResults;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure BuildReport;
    Procedure SetupAppropriateVariablesForGenSysSet;
    Procedure SetupAppropriateVariablesForTaxRates;
    Procedure SetupAppropriateVariablesForCIS;
    Procedure SetupAppropriateVariablesForFinancialPeriod;
    Procedure GetAppropriatePermissions;
  End;

Var
  oExportSet : TExportSettings = NIL;

implementation

Uses StrUtils,   EntLic,    LicFuncU,   History,   APIUtil,  ETDateU,  BtSupu2,    SysU2,
     CustIntU,   PWarnU,    ETStrU,     ETMiscU,   SysU1,    JChkUseU, JobSup1U,   BTSupU1,
     EntLicence, Event1U,   ComnUnit, oSystemSetup;

//=========================================================================

Constructor TExportSettings.Create;
Var
  WSNetDir : ANSIString;
  today    : TDateTime;
Begin { Create }
  Inherited Create;

  today := Now;

  FFileDate := DateToStr(today);

  FFileVersion := '1.0.0';

  //Setting up the appropriate Label
  FVatLabel     :='Default'+CCVATName^+'Code';
  FReturnsLabel :='CurrencyOf'+CCVATName^+'Returns';

  if EuroVers then
    FTotalCurrencies := 2
  else
    FTotalCurrencies := 90;

  FCurrencyData := TBits.Create;
  FCurrencyData.Size := 91;  // 0-90 currencies

  // Create internal StringLists to store the Warnings and Survey Output
  FExportSettingsResults := TStringList.Create;

End; { Create }

//---------------------------------------

Destructor TExportSettings.Destroy;
Begin { Destroy }

  // destroy the data set list and the reports
  FreeAndNIL(ReturnsList);
  FreeAndNIL(StockValueList);
  FreeAndNIL(FExportSettingsResults);

  inherited;
End; { Destroy }

//--------------------------------------------------------------------------
Procedure TExportSettings.GetAppropriatePermissions;
Begin
  // Setting Up Permissions
  FCurrencyPermission         := ChkAllowed_In(199);
  FVATSetupPermission         := ChkAllowed_In(50);
  FCISSetupPermission         := ChkAllowed_In(422);
  FControlCodesPermission     := ChkAllowed_In(90);
  FF6PeriodPermission         := ChkAllowed_In(51);
End;

//--------------------------------------------------------------------------
Procedure TExportSettings.SetupAppropriateVariablesForTaxRates;
Begin
   FCurrentTaxPeriod  := Calc_NewVATPeriod(SyssVAT.VATRAtes.VATReturnDate,Trunc(SyssVAT.VATRAtes.VATInterval));
   if (SyssVAT.VATRAtes.VATScheme = 'N') Then
      FTaxScheme := 'Normal'
   else
      FTaxScheme := 'Cash Accounting';
End;

//--------------------------------------------------------------------------
Procedure TExportSettings.SetupAppropriateVariablesForFinancialPeriod;
Var
  EqDate     :  LongDate;
  LocEqDate  :  LongDate;
  EqPr       :  ShortInt;
  LocEqPr    :  ShortInt;
Begin
  FGlobalEquivalentDate   := '';
  FLocalEquivalentDate    := '';
  FGlobalPeriod           := '';
  FLocalPeriod            := '';
  FGlobalStartYear        := '';
  FLocalStartYear         := '';


  if (Syss.DispPrAsMonths = True) Then
     FGlobalPeriod := Copy(MonthAry[Syss.CPr],1,3)
  else
     FGlobalPeriod := IntToStr(Syss.CPr);

  if (UserProfile.UDispPrMnth = True) Then
     FLocalPeriod  := Copy(MonthAry[UserProfile.UCPr],1,3)
  else
     FLocalPeriod  := IntToStr(UserProfile.UCPr);

  EqDate    := SimplePr2Date(Syss.CPr,Syss.CYr);
  LocEqDate := SimplePr2Date(UserProfile.UCPr,UserProfile.UCYr);

  EqPr      := Part_Date('M',EqDate);
  LocEqPr   := Part_Date('M',LocEqDate);

  If (EQPr In [1..12]) then
    FGlobalEquivalentDate := Copy(MonthAry[EqPr],1,3);

  If (LocEQPr In [1..12]) then
    FLocalEquivalentDate  := Copy(MonthAry[LocEqPr],1,3);

  FGlobalStartYear        := IntToStr(Syss.CYr + 1900);
  FLocalStartYear         := IntToStr(UserProfile.UCYr + 1900);

  FGlobalEquivalentDate   := FGlobalEquivalentDate+'/'+Form_Int(Part_Date('Y',EqDate),4);
  FLocalEquivalentDate    := FLocalEquivalentDate+'/'+Form_Int(Part_Date('Y',LocEqDate),4);

End;

//--------------------------------------------------------------------------
Procedure TExportSettings.SetupAppropriateVariablesForCIS;
var
  SubmitTypeList : TStringList;
Begin
   FCurrentCISPeriod  := Calc_NewCISPeriod(SyssCIS.CISRates.CISReturnDate,Trunc(SyssCIS.CISRates.CISInterval));

   If (CurrentCountry=DefaultCountry) then
   Begin
      FLastReturnsLabel          := 'LastCISReturn';
      FCurrentPeriodLabel        := 'CurrentCISPeriod';
      FReturnEveryMonthLabel     := 'CISReturnEveryMonths';
      FVatRateLabel              := 'CISVatRate';

      FCertificateTypeLabel      := 'CISTaxRate';
      FCertificateRefLabel       := 'CTR';
      FTypeOfSubmitterLabel      := 'TypeOfSubmitter';
      FOfficeRefOrReverseLabel   := 'AccountOfficeRef';
      FOfficeRefOrReverse        :=  SyssCIS340.CIS340.CISACCONo;
      FContractorCISDetailsLabel := 'ContractorCISDetails';
   End
   else
      If (CurrentCountry=IECCode) then
      Begin
         FLastReturnsLabel          := 'LastRCTReturn';
         FCurrentPeriodLabel        := 'CurrentRCTPeriod';
         FReturnEveryMonthLabel     := 'RCTReturnEveryMonths';
         FVatRateLabel              := 'RCTVatRate';

         FCertificateTypeLabel      := 'C2CertRef';
         FCertificateRefLabel       := 'SerialNo';
         FTypeOfSubmitterLabel      := 'CertExpiry';
         FOfficeRefOrReverseLabel   := 'ReverseVATCode';
         FContractorCISDetailsLabel := 'ContractorRCTDetails';
         FOfficeRefOrReverse        :=  SyssCIS.CISRates.RCTRCV1;
      End
      else
         Begin
            FLastReturnsLabel          := 'LastReturn';
            FCurrentPeriodLabel        := 'CurrentPeriod';
            FReturnEveryMonthLabel     := 'ReturnEveryMonths';
            FVatRateLabel              := 'GSTRate';

            FCertificateTypeLabel := 'CertificateType';
            FCertificateRefLabel  := 'CertificateRef';
            FOfficeRefOrReverseLabel := 'ReverseVATCode';
         End;

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

  FSubmitterType := SubmitTypeList.Strings[SyssCIS340.CIS340.IGSubType];
  If (CurrentCountry=IECCode) then
     FSubmitterType := SyssCIS.CISRates.JCertExpiry;

  FreeAndNIL(SubmitTypeList);
End;

//--------------------------------------------------------------------------
Procedure TExportSettings.SetupAppropriateVariablesForGenSysSet;
Var
  MLLocIndex : Integer;
Begin

  // Set path to Exchequer directory
  FEntPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  // Initialise the Survey Details
  FEnter1Date    := '?';
  FEnter1FileVer := '';

  FEnter1Date    := DateToStr(FileDateToDateTime(FileAge(FEntPath + 'Enter1.Exe')));

  FEnter1FileVer := GetFileVersion(Application.ExeName);

  // Getting the appropriate Country Code
  if CCode2I(Syss.UsrCntryCode) = 0 Then
     FCountryCode := 'Australia (STX)  /061'
  else
     if CCode2I(Syss.UsrCntryCode) = 1 Then
        FCountryCode := 'New Zealand (GST) /064'
    else
       if CCode2I(Syss.UsrCntryCode) = 2 Then
          FCountryCode := 'Singapore (GST) /065'
      else
         if CCode2I(Syss.UsrCntryCode) = 3 Then
            FCountryCode := 'South Africa (VAT) /027'
        else
           if CCode2I(Syss.UsrCntryCode) = 4 Then
              FCountryCode := 'United Kingdom (VAT) /044'
          else
             if CCode2I(Syss.UsrCntryCode) = 5 Then
                FCountryCode := 'Ireland (VAT) /353';

   // Getting Debt Mode
   if (Syss.DebtLMode = 0) Then
      FDebtLMode := 'Weeks Single'
   else
     if (Syss.DebtLMode = 1) Then
        FDebtLMode := 'Days Single'
     else
        if (Syss.DebtLMode = 2) Then
           FDebtLMode := 'Weeks Escalating'
        else
           if (Syss.DebtLMode = 3) Then
              FDebtLMode := 'Days Escalating'
           else
              if (Syss.DebtLMode = 4) Then
                 FDebtLMode := 'Weeks Multiple'
              else
                 FDebtLMode := 'Days Multiple';

   // Getting the appropriate BUCCF
   With Syss Do
   Begin
    if Ord(PostCCNom)+Ord(PostCCDCombo) = 0 Then
       FBUCCF := 'No Budgeting by Cost Centre/Department'
    else
      if Ord(PostCCNom)+Ord(PostCCDCombo) = 1 Then
         FBUCCF := 'Budget by Cost Centre or Department only'
      else
         FBUCCF := 'Budget by CC, Dept & CC+Dept Combined'
   End;

   if (Syss.TotalConv=XDayCode = True) Then
       FCurConsMeth := 'Daily Rate'
   else
       FCurConsMeth := 'Company Rate';

  // Getting the appropriate Returns Text
  ReturnsList := TStringList.Create;
  ReturnsList.Clear;
  ReturnsList.Assign(STDCurrList);

  FReturns := ReturnsList.Strings[Syss.VATCurr];

  // Getting the appropriate Currency Variable Tolerance
  if Syss.AlTolMode = 0 Then
     FCurrVarTol := 'Disabled'
  else
    if Syss.AlTolMode = 1 Then
       FCurrVarTol := 'Fixed Value'
    else
       FCurrVarTol := 'Percentage';

   With Syss Do
   Begin
    if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 0 Then
       FAgeByInvoice := 'Do Not'
    else
      if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 1 Then
         FAgeByInvoice := 'Sales Ledger'
      else
         if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 2 Then
            FAgeByInvoice := 'Purchase Ledger'
         else
            FAgeByInvoice := 'Sales & Purchase'
   End;

   // Getting the appropriate Authorisation Method
   if (Syss.AuthMode In ['N',#0]) Then
       FAuthMethod := 'None'
   else
     if (Syss.AuthMode In ['A']) Then
        FAuthMethod := 'Automatic'
     else
        FAuthMethod := 'Manual';
        
{
  Sanjay Sonani
  Jira : ABSEXCH-14418 : Cannot assign a nil to a TStringList when exporting
                         System Settings in Non-Stock system.

  Cause : STDValList is initialize only when  ($IFDEF STK) activated so that for
          the Non stock case it was failing.  
  }


   {$IFDEF STK}
    // Dealing with the building of the Stock Value Method
    StockValueList := TStringList.Create;
    StockValueList.Clear;
    if Assigned(STDValList) then
      StockValueList.Assign(STDValList);
    {$IFDEF SOP}
        StockValueList.Add('Serial/Batch Average Cost');
    {$ENDIF}


    FStockValueMeth := StockValueList.Strings[StkVM2I(Syss.AutoStkVal)];


   {$ELSE}
      FStockValueMeth := '';
   {$ENDIF STK}

  // Get the appropriate ML Location
  if (Syss.UseLocDel) Then
      MLLocIndex := 2
  else
      MLLocIndex := Ord(Syss.UseMLoc);

     if (MLLocIndex = 0) Then
        FMultiLoc := 'Disabled'
     else
       if (MLLocIndex = 1) Then
          FMultiLoc := 'Enabled'
       else
          FMultiLoc := 'Use for Delivery Address';

  // Dealing with Copying Stock Notes to Works Order
   if (Syss.WOPStkCopMode = 0) Then
      FCopyStkToWO := 'Copy both Dated & General Notes'
   else
     if (Syss.WOPStkCopMode = 1) Then
        FCopyStkToWO := 'Copy General Notes Only'
     else
        FCopyStkToWO := 'Copy Dated Notes Only';

 // Dealing with Default Priority
   if (SyssEDI2.EDI2Value.EMPriority = 0) Then
      FDefaultPriority := 'Low'
   else
     if (SyssEDI2.EDI2Value.EMPriority = 1) Then
        FDefaultPriority := 'Normal'
     else
        FDefaultPriority := 'High';

  // Dealing with Attachement Method
   if (SyssEDI2.EDI2Value.emAttchMode = 0) Then
      FAttachmentMethod := 'Internal EDF Format'
   else
     if (SyssEDI2.EDI2Value.emAttchMode = 1) Then
        FAttachmentMethod := 'Adobe Acrobat PDF'
     else
        FAttachmentMethod := 'Internal PDF Format';

  // Dealing with Fax Using
   if (SyssEDI2.EDI2Value.FxUseMAPI = 0) Then
      FFaxUsing := 'Exchequer eComms'
   else
     if (SyssEDI2.EDI2Value.FxUseMAPI = 1) Then
        FFaxUsing := 'MAPI'
     else
        FFaxUsing := 'Third Party Fax';
End;

//--------------------------------------------------------------------------

Procedure TExportSettings.BuildReport;
Var
  I, J, iCount, iTotal : LongInt;
  iModule  : TelEntModuleEnum;
  S        : AnsiString;
  oStrList : TStringList;

  Function IIF (Const BoolCond : Boolean; Const TrueStr, FalseStr : ShortString) : ShortString;
  Begin { IIF }
    If BoolCond Then
      Result := TrueStr
    Else
      Result := FalseStr;
  End; { IIF }

  Function FixDodgyChars (Const DodgyString : ShortString) : ShortString;
  Var
    I : SmallInt;
  Begin // FixDodgyChars
    Result := '';
    For I := 1 To Length(DodgyString) Do
    Begin
      Case DodgyString[I] Of
        '<' : Result := Result + '&lt;';
        '>' : Result := Result + '&gt;';
        '"' : Result := Result + '&quot;';
        '&' : Result := Result + '&amp;';

      Else
        Result := Result + DodgyString[I];
      End; // Case DodgyString[I]
    End; // For I
  End; // FixDodgyChars

Begin { BuildReport }
  SetupAppropriateVariablesForGenSysSet;
  GetAppropriatePermissions;
  SetupAppropriateVariablesForTaxRates;
  SetupAppropriateVariablesForCIS;
  SetupAppropriateVariablesForFinancialPeriod;

  With FExportSettingsResults Do
  Begin
    Clear;

    Add ('<?xml version="1.0" encoding="ISO-8859-1" ?>');
    Add ('<ExchequerSystemSettings Version="' + CurrVersion + '" Company="' + FixDodgyChars(CustomisationCompanyCode) + '" >');

    Add ('  <Enter1 FileDate="' + FEnter1Date + '" FileVer="' + FEnter1FileVer + '" />');

    //------------------------------

    With EnterpriseLicence Do
    Begin
      Add ('  <Licensing>');
      Add ('    <ExchequerVersion>' + elExchequerVersionDescription + '</ExchequerVersion>');
      Add ('    <ExchequerEdition>' + licExchequerEditionToStr (TExchequerEdition(elExchequerEdition)) + '</ExchequerEdition>');
      Add ('    <Database>' + licDBToStr (Ord(elDatabaseType)) + '</Database>');
      Add ('    <Modules>');
      For iModule := Low(TelEntModuleEnum) To High(TelEntModuleEnum) Do
      Begin
        S := '      <Module Name="' + FixDodgyChars(licModuleDescEx (True, Ord(iModule))) + '" ReleaseStatus="' + licEntModRelToStr (0, Ord(elModules[iModule]), 0)  + '" ';

        If (iModule = modToolDLLR) Then
          // Toolkit DLL (Runtime)
          S := S + 'UserCount="' + IntToStr(elUserCounts [mucToolkitFull]) + '" UserCount30Day="' + IntToStr(elUserCounts [mucToolkit30]) + '" '
        Else If (iModule = modTrade) Then
          // Trade Counter
          S := S + 'UserCount="' + IntToStr(elUserCounts [mucTradeCounter]) + '" '
        Else If (iModule = modElerts) Then
          // Sentimail
          S := S + 'Sentinels="' + IntToStr(elUserCounts [mucElerts]) + '" ';

        Add (S + '/>');
      End; // For iModule

      Add ('    </Modules>');
      Add ('    <Companies>' + IntToStr(elUserCounts [mucCompanies]) + '</Companies>');
      Add ('  </Licensing>');
    End; // With EnterpriseLicence

    //------------------------------
    Add ('  <GeneralSettings>');
    Add ('    <Company>');
    Add ('      <CompanyName>' + FixDodgyChars(Syss.UserName) + '</CompanyName>');
    Add ('      <Address>');
    Add ('        <AddressLine>' + FixDodgyChars(Syss.DetailAddr[1]) + '</AddressLine>');
    Add ('        <AddressLine>' + FixDodgyChars(Syss.DetailAddr[2]) + '</AddressLine>');
    Add ('        <AddressLine>' + FixDodgyChars(Syss.DetailAddr[3]) + '</AddressLine>');
    Add ('        <AddressLine>' + FixDodgyChars(Syss.DetailAddr[4]) + '</AddressLine>');
    Add ('        <AddressLine>' + FixDodgyChars(Syss.DetailAddr[5]) + '</AddressLine>');
    Add ('      </Address>');
    Add ('      <Telephone>'   + FixDodgyChars(Syss.DetailTel) + '</Telephone>');
    Add ('      <Fax>'         + FixDodgyChars(Syss.DetailFax) + '</Fax>');
    Add ('      <VatReg>'      + FixDodgyChars(Syss.UserVATReg) + '</VatReg>');
    Add ('      <CountryCode>' + FixDodgyChars(FCountryCode) + '</CountryCode>');
    Add ('      <FinancialYearStart>'   + POutDateB(Syss.MonWk1) + '</FinancialYearStart>');
    Add ('      <PeriodsInYear>'        + IntToStr(Syss.PrInYr) + '</PeriodsInYear>');
    Add ('      <LastAuditDate>'        + POutDateB(Syss.AuditDate) + '</LastAuditDate>');
    // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
    //Add ('      <SettlementDisc>'       + formatfloat('#0.0%;-#0.0%',Syss.SettleDisc) + '</SettlementDisc>');
    //Add ('      <SettlementDays>'       + IntToStr(Syss.SettleDays) + '</SettlementDays>');
    Add ('      <PaymentTermsDays>'     + IntToStr(Syss.PayTerms) + '</PaymentTermsDays>');
    Add ('      <'+FVatLabel+'>'        + FixDodgyChars(Syss.VATCode) + '</'+FVatLabel+'>');
    Add ('      <DirectCustomerSRIs>'   + FixDodgyChars(Syss.DirectCust) + '</DirectCustomerSRIs>');
    Add ('      <DirectSupplierPPIs>'   + FixDodgyChars(Syss.DirectSupp) + '</DirectSupplierPPIs>');
    Add ('      <DebtChaseLetters>');
    Add ('        <Mode>'             + FDebtLMode + '</Mode>');
    Add ('        <FirstLetter>');
    Add ('          <StartUnits>'  + IntToStr(Syss.WKSODue) + '</StartUnits>');
    Add ('          <EndUnits>'    + IntToStr(Syss.DebTrig[1]) + '</EndUnits>');
    Add ('          <Form>'        + FixDodgyChars(SyssForms.FormDefs.PrimaryForm[38]) + '</Form>');
    Add ('        </FirstLetter>');
    Add ('        <SecondLetter>');
    Add ('          <EndUnits>'    + IntToStr(Syss.DebTrig[2]) + '</EndUnits>');
    Add ('          <Form>'        + FixDodgyChars(SyssForms.FormDefs.PrimaryForm[39]) + '</Form>');
    Add ('        </SecondLetter>');
    Add ('        <ThirdLetter>');
    Add ('          <EndUnits>'    + IntToStr(Syss.DebTrig[3]) + '</EndUnits>');
    Add ('          <Form>'        + FixDodgyChars(SyssForms.FormDefs.PrimaryForm[40]) + '</Form>');
    Add ('        </ThirdLetter>');
    Add ('      </DebtChaseLetters>');
    Add ('      <DefaultTradingTerms>');
    Add ('        <Enabled>'         + BoolToStr(Syss.TradeTerm, True) + '</Enabled>');
    Add ('        <Message1>'        + FixDodgyChars(Syss.TermsofTrade[1]) + '</Message1>');
    Add ('        <Message2>'        + FixDodgyChars(Syss.TermsofTrade[2]) + '</Message2>');
    Add ('      </DefaultTradingTerms>');
    Add ('    </Company>');
    Add ('    <SystemGeneralLedgerCurrency>');
    Add ('      <ExternalCustomerRecords>'  + BoolToStr(Syss.ExternCust, True) + '</ExternalCustomerRecords>');
    Add ('      <NumericTraderCodes>'       + BoolToStr(Syss.TradCodeNum, True) + '</NumericTraderCodes>');
    Add ('      <ExternalSINGeneration>'    + BoolToStr(Syss.ExternSIN, True) + '</ExternalSINGeneration>');
    Add ('      <UseExchequerDOSKeys>'      + BoolToStr(Syss.TxLateCr, True) + '</UseExchequerDOSKeys>');
    Add ('      <HideExchequerLogo>'        + BoolToStr(Syss.HideExLogo, True) + '</HideExchequerLogo>');
    Add ('      <ConserveMemorySlowerPerformance>' + BoolToStr(Syss.ConsvMem, True) + '</ConserveMemorySlowerPerformance>');
    Add ('      <UsePasswords>'                    + BoolToStr(Syss.UsePassWords, True) + '</UsePasswords>');
    Add ('      <HideUnauthorisedOptions>'         + BoolToStr(Syss.HideMenuOpt, True) + '</HideUnauthorisedOptions>');
    Add ('      <DisablePostingToPreviousPeriods>'              + BoolToStr(Syss.PrevPrOff, True) + '</DisablePostingToPreviousPeriods>');
    Add ('      <SetPeriodRelativeToDate>'                      + BoolToStr(Syss.AutoPrCalc, True) + '</SetPeriodRelativeToDate>');
    Add ('      <UseCostCentresAndDepartments>'                 + BoolToStr(Syss.UseCCDep, True) + '</UseCostCentresAndDepartments>');
    Add ('      <CCDeptBudgets>'                                + FixDodgyChars(FBUCCF) + '</CCDeptBudgets>');
    Add ('      <Auto-ClearPaymentsReceiptsInBank>'             + BoolToStr(Syss.AutoClearPay, True) + '</Auto-ClearPaymentsReceiptsInBank>');
    Add ('      <SplitLineDiscountsInGeneralLedgerWhenPosting>' + BoolToStr(Syss.SepDiscounts, True) + '</SplitLineDiscountsInGeneralLedgerWhenPosting>');
    {$IFDEF MC_On}
      Add ('      <CurrencyConsolidationMethod>'                  + FixDodgyChars(FCurConsMeth) + '</CurrencyConsolidationMethod>');
      Add ('      <'+FReturnsLabel+'>'                            + FixDodgyChars(FReturns) + '</'+FReturnsLabel+'>');
      Add ('      <AllocationCurrVarTolerance>'                   + FixDodgyChars(FCurrVarTol) + '</AllocationCurrVarTolerance>');
      Add ('      <Tolerance>'                                    + formatfloat('###,###,##0.00 ;###,###,##0.00-',Syss.AlTolVal) + '</Tolerance>');
    {$ENDIF}
    Add ('      <EnforceGeneralLedgerClasses>'                  + BoolToStr(Syss.UseGLClass, True) + '</EnforceGeneralLedgerClasses>');
    Add ('      <ECSalesThreshold>'                             + formatfloat('###,###,##0.00 ;###,###,##0.00-',SyssVAT.VATRates.ECSalesThreshold) + '</ECSalesThreshold>');
    Add ('      <EnableECServicesSupport>'                      + BoolToStr(SyssVAT.VATRates.EnableECServices, True) + '</EnableECServicesSupport>');
    Add ('      <DefaultReportPrinter>'                         + FixDodgyChars(SyssVAT.VATRates.ReportPrnN) + '</DefaultReportPrinter>');
    Add ('      <DefaultFormsPrinter>'                          + FixDodgyChars(SyssVAT.VATRates.FormsPrnN) + '</DefaultFormsPrinter>');
    Add ('    </SystemGeneralLedgerCurrency>');
    Add ('    <SalesLedgerPurchaseLedger>');
    Add ('      <UseCreditLimitCheck>'                     + BoolToStr(Syss.UseCRLimitChk, True) + '</UseCreditLimitCheck>');
    Add ('      <UseCreditStatusCheck>'                    + BoolToStr(Syss.UseCreditChk, True) + '</UseCreditStatusCheck>');
    Add ('      <IfOverCreditLimitPutOnStop>'              + BoolToStr(Syss.StopBadDr, True) + '</IfOverCreditLimitPutOnStop>');
    Add ('      <CalcOldestDebtWhenLeavingLedger>'         + BoolToStr(Syss.LiveCredS, True) + '</CalcOldestDebtWhenLeavingLedger>');
    Add ('      <DisableSettlementDiscAutomaticHold>'      + BoolToStr(Syss.NoHoldDisc, True) + '</DisableSettlementDiscAutomaticHold>');
    Add ('      <IncludeNotDueItemsOnStatement>'           + BoolToStr(Syss.IncNotDue, True) + '</IncludeNotDueItemsOnStatement>');
    Add ('      <AddToNotesWhenStatementIsPrinted>'        + BoolToStr(Syss.AutoNotes, True) + '</AddToNotesWhenStatementIsPrinted>');
    Add ('      <AgeByInvoiceDate>'                        + FixDodgyChars(FAgeByInvoice) + '</AgeByInvoiceDate>');
    Add ('      <KeepSQU-PQUsDateWhenConverted>'           + BoolToStr(Syss.QuoOwnDate, True) + '</KeepSQU-PQUsDateWhenConverted>');
    Add ('      <SRI-PPIToHaveOwnOurRefCount>'             + BoolToStr(Syss.DirOwnCount, True) + '</SRI-PPIToHaveOwnOurRefCount>');
    Add ('      <WarnIfDuplicateYourRefIsEntered>'         + BoolToStr(Syss.WarnYRef, True) + '</WarnIfDuplicateYourRefIsEntered>');
    Add ('      <ProtectYourRefInSPOP>'                    + BoolToStr(Syss.ProtectYRef, True) + '</ProtectYourRefInSPOP>');
    Add ('      <PromptToPrintSalesReceipts>'              + BoolToStr(Syss.PrintReciept, True) + '</PromptToPrintSalesReceipts>');
    Add ('      <UseSalesReceiptsPay-InRef>'               + BoolToStr(Syss.UsePayIn, True) + '</UseSalesReceiptsPay-InRef>');
    Add ('      <AutomaticChequeNumbers>'                  + BoolToStr(Syss.AutoCQNo, True) + '</AutomaticChequeNumbers>');
    Add ('      <StopManualEntryOfPPYs>'                   + BoolToStr(Syss.BatchPPY, True) + '</StopManualEntryOfPPYs>');
    Add ('      <ForceBatchTotalsToBalance>'               + BoolToStr(Syss.UseBatchTot, True) + '</ForceBatchTotalsToBalance>');
    Add ('      <UpdateTraderBalancesAfterPosting>'        + BoolToStr(Syss.UpBalOnPost, True) + '</UpdateTraderBalancesAfterPosting>');
    Add ('      <DefaultToPercentageDiscounts>'            + BoolToStr(Syss.DefPCDisc, True) + '</DefaultToPercentageDiscounts>');
    Add ('      <AuthorisationMethod>'                     + FixDodgyChars(FAuthMethod) + '</AuthorisationMethod>');
    // MH 05/09/2013 v7.XMRD MRD1.1.10: Added Consumer Support
    Add ('      <EnableConsumersForSales>'                 + BoolToStr(Syss.ssConsumersEnabled, True) + '</EnableConsumersForSales>');
    Add ('      <DecimalPlacesOnCostPrice>'                + formatfloat('###,###,##0 ;###,###,##0-',Syss.NoCosDec) + '</DecimalPlacesOnCostPrice>');
    Add ('      <DecimalPlacesOnSalePrice>'                + formatfloat('###,###,##0 ;###,###,##0-',Syss.NoNetDec) + '</DecimalPlacesOnSalePrice>');
    Add ('      <DecimalPlacesOnQty>'                      + formatfloat('###,###,##0 ;###,###,##0-',Syss.NoQtyDec) + '</DecimalPlacesOnQty>');
    Add ('    </SalesLedgerPurchaseLedger>');

    // MH 11/05/2015 v7.0.14 ABSEXCH-16284: Added new PPD Settings
    Add ('    <PromptPaymentDiscount>');
    With SystemSetup.PPD.PPDExpiredColours Do
      Add ('      <Category Desc="Expired" Background="' + IntToStr(poBackgroundColour) + '" FontColour="' + IntToStr(poFontColour) + '" FontStyle="' + IntToStr(FontStyleToInternal (poFontStyle)) + '" />');
    With SystemSetup.PPD, PPDRedColours Do
      Add ('      <Category Desc="1" Days="' + IntToStr(PPDRedDays) + '" Background="' + IntToStr(poBackgroundColour) + '" FontColour="' + IntToStr(poFontColour) + '" FontStyle="' + IntToStr(FontStyleToInternal (poFontStyle)) + '" />');
    With SystemSetup.PPD, PPDAmberColours Do
      Add ('      <Category Desc="2" Days="' + IntToStr(PPDAmberDays) + '" Background="' + IntToStr(poBackgroundColour) + '" FontColour="' + IntToStr(poFontColour) + '" FontStyle="' + IntToStr(FontStyleToInternal (poFontStyle)) + '" />');
    With SystemSetup.PPD.PPDGreenColours Do
      Add ('      <Category Desc="3" Background="' + IntToStr(poBackgroundColour) + '" FontColour="' + IntToStr(poFontColour) + '" FontStyle="' + IntToStr(FontStyleToInternal (poFontStyle)) + '" />');
    Add ('    </PromptPaymentDiscount>');

    Add ('    <StockSPOP>');
    Add ('      <DefaultStockValueMethod>'                 + FixDodgyChars(FStockValueMeth) + '</DefaultStockValueMethod>');
    Add ('      <MultiLocation>'                           + FixDodgyChars(FMultiLoc) + '</MultiLocation>');
    Add ('      <LiveStockCostOfSalesValuation>'           + BoolToStr(Syss.AutoValStk, True) + '</LiveStockCostOfSalesValuation>');
    Add ('      <DisplayInsufficientStockWarning>'         + BoolToStr(Syss.UseStock, True) + '</DisplayInsufficientStockWarning>');
    Add ('      <UseECSSDIntrastatFields>'                 + BoolToStr(Syss.IntraStat, True) + '</UseECSSDIntrastatFields>');
    Add ('      <DisplayUpdateBuildCostsReminder>'         + BoolToStr(Syss.AutoBillUp, True) + '</DisplayUpdateBuildCostsReminder>');
    Add ('      <AnalyseSalesOfDescOnlyStock>'             + BoolToStr(Syss.AnalStkDesc, True) + '</AnalyseSalesOfDescOnlyStock>');
    Add ('      <SetBOMComponentSer.NosOnSales>'           + BoolToStr(Syss.EditSinSer, True) + '</SetBOMComponentSer.NosOnSales>');
    Add ('      <DeductComponentsIfNoBOMsInStock>'         + BoolToStr(Syss.DeadBOM, True) + '</DeductComponentsIfNoBOMsInStock>');
    Add ('      <QuotesSQU-PQUToAllocateStock>'            + BoolToStr(Syss.QuAllocFlg, True) + '</QuotesSQU-PQUToAllocateStock>');
    Add ('      <FreeStockToExcludeSalesOrders>'           + BoolToStr(Syss.FreeExAll, True) + '</FreeStockToExcludeSalesOrders>');
    Add ('      <OrdersToAllocateStockWhenPicked>'         + BoolToStr(Syss.UsePick4All, True) + '</OrdersToAllocateStockWhenPicked>');
    Add ('      <SDNsToOnlyShowPickedItems>'               + BoolToStr(Syss.DelPickOnly, True) + '</SDNsToOnlyShowPickedItems>');
    Add ('      <UsePackQtyMultiplierOnTransactions>'      + BoolToStr(Syss.InpPack, True) + '</UsePackQtyMultiplierOnTransactions>');
    Add ('      <SDNDateIsTaxPointDate>'                   + BoolToStr(Syss.SDNOwnDate, True) + '</SDNDateIsTaxPointDate>');
    Add ('      <ShowPriceBandsAsMarginsNotM-Up>'          + BoolToStr(Syss.ShowStkGP, True) + '</ShowPriceBandsAsMarginsNotM-Up>');
    Add ('      <ManuallyUpdateReOrderCost>'               + BoolToStr(Syss.ManROCP, True) + '</ManuallyUpdateReOrderCost>');
    Add ('      <AutoPostUpliftToUpliftControlAccount>'    + BoolToStr(Syss.UseUpliftNC, True) + '</AutoPostUpliftToUpliftControlAccount>');
    Add ('      <RetainBinHistory>'                        + BoolToStr(Syss.KeepBinHist, True) + '</RetainBinHistory>');
    Add ('      <FilterSerial-Batch-BinPickListByLoc>'     + BoolToStr(Syss.FiltSNoBinLoc, True) + '</FilterSerial-Batch-BinPickListByLoc>');
    Add ('      <BinCodeMask>'                             + FixDodgyChars(Syss.BinMask) + '</BinCodeMask>');
    Add ('      <UseTransactionTotalDiscounts>'            + BoolToStr(Syss.EnableTTDDiscounts, True) + '</UseTransactionTotalDiscounts>');
    Add ('      <UseValueBasedDiscounts>'                  + BoolToStr(Syss.EnableVBDDiscounts, True) + '</UseValueBasedDiscounts>');
    Add ('      <UseOverrideLocationOnPurchases>'          + BoolToStr(Syss.EnableOverrideLocations, True) + '</UseOverrideLocationOnPurchases>');
    Add ('      <IncludeVATInCommittedBalances>'           + BoolToStr(Syss.IncludeVATInCommittedBalance, True) + '</IncludeVATInCommittedBalances>');
    // MH 21/07/2014: Order Payments
    Add ('      <EnableOrderPayments>'                     + BoolToStr(Syss.ssEnableOrderPayments, True) + '</EnableOrderPayments>');

    Add ('    </StockSPOP>');
    Add ('    <JobCosting>');
    Add ('      <WarnIfOverBudgetEnteringPIN>'             + BoolToStr(Syss.WarnJC, True) + '</WarnIfOverBudgetEnteringPIN>');
    Add ('      <UsePPIsNotNOMsForTimeSheets>'             + BoolToStr(SyssJob.JobSetup.GenPPI, True) + '</UsePPIsNotNOMsForTimeSheets>');
    Add ('      <PPISuppAccount>'                          + FixDodgyChars(SyssJob.JobSetup.PPIAcCode) + '</PPISuppAccount>');
    Add ('      <SplitJobBudgetsByPeriod>'                 + BoolToStr(SyssJob.JobSetup.PeriodBud, True) + '</SplitJobBudgetsByPeriod>');
    Add ('      <IncludeUnpostedPurchasesInCommitted>'     + BoolToStr(SyssJob.JobSetup.JCCommitPin, True) + '</IncludeUnpostedPurchasesInCommitted>');
    Add ('      <ProtectApplicationYourRef>'               + BoolToStr(Syss.ProtectYRef, True) + '</ProtectApplicationYourRef>');
    Add ('      <UseApplicationDateForInvoice>'            + BoolToStr(SyssJob.JobSetup.JAInvDate, True) + '</UseApplicationDateForInvoice>');
    Add ('      <DelayApplicationCommittedUntilCertified>' + BoolToStr(SyssJob.JobSetup.JADelayCert, True) + '</DelayApplicationCommittedUntilCertified>');
    Add ('      <SummaryCategoryTitles>');
    Add ('        <Revenue>'                 + FixDodgyChars(SyssJob.JobSetup.SummDesc[1]) + '</Revenue>');
    Add ('        <Labour>'                  + FixDodgyChars(SyssJob.JobSetup.SummDesc[2]) + '</Labour>');
    Add ('        <SubCont.Labour>'          + FixDodgyChars(SyssJob.JobSetup.SummDesc[11]) + '</SubCont.Labour>');
    Add ('        <DirectExpense1>'          + FixDodgyChars(SyssJob.JobSetup.SummDesc[3]) + '</DirectExpense1>');
    Add ('        <DirectExpense2>'          + FixDodgyChars(SyssJob.JobSetup.SummDesc[4]) + '</DirectExpense2>');
    Add ('        <StockIssues>'             + FixDodgyChars(SyssJob.JobSetup.SummDesc[5]) + '</StockIssues>');
    Add ('        <Materials2>'              + FixDodgyChars(SyssJob.JobSetup.SummDesc[12]) + '</Materials2>');
    Add ('        <Overheads>'               + FixDodgyChars(SyssJob.JobSetup.SummDesc[6]) + '</Overheads>');
    Add ('        <Overheads2>'              + FixDodgyChars(SyssJob.JobSetup.SummDesc[13]) + '</Overheads2>');
    Add ('        <Receipts>'                + FixDodgyChars(SyssJob.JobSetup.SummDesc[7]) + '</Receipts>');
    Add ('        <WorkinProgress>'          + FixDodgyChars(SyssJob.JobSetup.SummDesc[8]) + '</WorkinProgress>');
    Add ('        <RetentionsSalesLedger>'   + FixDodgyChars(SyssJob.JobSetup.SummDesc[9]) + '</RetentionsSalesLedger>');
    Add ('        <RetentionsPurchaseLedger>'+ FixDodgyChars(SyssJob.JobSetup.SummDesc[10]) + '</RetentionsPurchaseLedger>');
    Add ('        <SaleDeductions>'          + FixDodgyChars(SyssJob.JobSetup.SummDesc[14]) + '</SaleDeductions>');
    Add ('        <PurchDeductions>'         + FixDodgyChars(SyssJob.JobSetup.SummDesc[17]) + '</PurchDeductions>');
    Add ('        <SalesApps>'               + FixDodgyChars(SyssJob.JobSetup.SummDesc[15]) + '</SalesApps>');
    Add ('        <PurchaseApps>'            + FixDodgyChars(SyssJob.JobSetup.SummDesc[16]) + '</PurchaseApps>');
    Add ('      </SummaryCategoryTitles>');
    Add ('    </JobCosting>');
    Add ('    <WOP>');
    Add ('      <OrdersToAllocateStockWhenPicked>'         + BoolToStr(Syss.UseWIss4All, True) + '</OrdersToAllocateStockWhenPicked>');
    Add ('      <DisableWorkInProgress>'                   + BoolToStr(Syss.UseSTDWOP, True) + '</DisableWorkInProgress>');
    Add ('      <WhenCopyingStockNotesToAWorksOrder>'      + FixDodgyChars(FCopyStkToWO) + '</WhenCopyingStockNotesToAWorksOrder>');
    Add ('    </WOP>');
    Add ('    <FaxEmail>');
    Add ('      <EmailSetup>');
    Add ('        <YourEmailName>'          + FixDodgyChars(SyssEDI2.EDI2Value.EmName) + '</YourEmailName>');
    Add ('        <YourEmailAddress>'       + FixDodgyChars(SyssEDI2.EDI2Value.EMAddress) + '</YourEmailAddress>');
    Add ('        <SMTPServerAddr>'         + FixDodgyChars(SyssEDI2.EDI2Value.EMSMTP) + '</SMTPServerAddr>');
    Add ('        <DefaultPriority>'        + FixDodgyChars(FDefaultPriority) + '</DefaultPriority>');
    Add ('        <UseMAPIToSendEmail>'     + BoolToStr(SyssEDI2.EDI2Value.EmUseMAPI, True) + '</UseMAPIToSendEmail>');
    Add ('        <AttachmentPrinter>'      + FixDodgyChars(SyssEDI2.EDI2Value.EmailPrnN) + '</AttachmentPrinter>');
    Add ('        <AttachmentMethod>'       + FixDodgyChars(FAttachmentMethod) + '</AttachmentMethod>');
    Add ('      </EmailSetup>');
    Add ('      <FaxingSetup>');
    Add ('        <FaxPrinterDriver>'       + FixDodgyChars(SyssEDI2.EDI2Value.FaxPrnN) + '</FaxPrinterDriver>');
    Add ('        <FaxUsing>'               + FixDodgyChars(FFaxUsing) + '</FaxUsing>');
    Add ('        <FaxFromName>'            + FixDodgyChars(SyssEDI2.EDI2Value.FxName) + '</FaxFromName>');
    Add ('        <FaxFromTelNo>'           + FixDodgyChars(SyssEDI2.EDI2Value.FxPhone) + '</FaxFromTelNo>');
    Add ('        <FaxInterfacePath>'       + FixDodgyChars(SyssEDI2.EDI2Value.FaxDLLPath) + '</FaxInterfacePath>');
    Add ('      </FaxingSetup>');
    Add ('    </FaxEmail>');
    Add ('  </GeneralSettings>');

    //------------------------------

    if FCurrencyPermission Then
    Begin
      Add ('  <CurrencySetup>');

      For I := 0 To (FTotalCurrencies) Do
      Begin
          if (SyssCurr.Currencies[I].Desc <> '') Then
          Begin
               Add ('    <Currency  No="' + IntToStr(I) +
               '" Description= "'   + FixDodgyChars(SyssCurr.Currencies[I].Desc) +
               '" ScreenSymbol="'   + SyssCurr.Currencies[I].SSymb  +
               '" PrinterSymbol= "' + SyssCurr.Currencies[I].PSymb +
               '" DailyRate= "'     + Form_Real(SyssCurr.Currencies[I].CRates[True], 0, 6) +
               '" CompanyRate= "'   + Form_Real(SyssCurr.Currencies[I].CRates[False], 0, 6) +
               '" Invert= "'        + IIF(SyssGCur.GhostRates.TriInvert[I], 'Yes', '') +
               '" Floating= "'      + IIF(SyssGCur.GhostRates.TriFloat[I], 'Yes', '') +
               '" TriangulationCcy= "'  + IntToStr(SyssGCur.GhostRates.TriEuro[I]) +
               '" TriangulationRate= "' + Format('%8.6f', [SyssGCur.GhostRates.TriRates[I]]) + '" />');
          End
          Else
             Break;
      End; // For I

      Add ('  </CurrencySetup>');
    End;

    //------------------------------

    If FVATSetupPermission Then
    Begin
      Add ('  <VATRateSettings>');
      Add ('    <VATRates>');
      Add ('      <VATRate Code="S" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Standard].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Standard].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Standard].Include, True) + '" />');
      Add ('      <VATRate Code="E" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Exempt].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Exempt].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Exempt].Include, True) + '" />');
      Add ('      <VATRate Code="Z" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Zero].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Zero].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Zero].Include, True) + '" />');
      Add ('      <VATRate Code="1" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate1].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate1].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate1].Include, True) + '" />');
      Add ('      <VATRate Code="2" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate2].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate2].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate2].Include, True) + '" />');
      Add ('      <VATRate Code="3A" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate3].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate3].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate3].Include, True) + '" />');
      Add ('      <VATRate Code="4D" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate4].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate4].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate4].Include, True) + '" />');
      Add ('      <VATRate Code="5" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate5].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate5].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate5].Include, True) + '" />');
      Add ('      <VATRate Code="6" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate6].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate6].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate6].Include, True) + '" />');
      Add ('      <VATRate Code="7" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate7].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate7].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate7].Include, True) + '" />');
      Add ('      <VATRate Code="8" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate8].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate8].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate8].Include, True) + '" />');
      Add ('      <VATRate Code="9" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate9].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate9].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate9].Include, True) + '" />');
      Add ('      <VATRate Code="T" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate10].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate10].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate10].Include, True) + '" />');
      Add ('      <VATRate Code="X" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate11].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate11].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate11].Include, True) + '" />');
      Add ('      <VATRate Code="B" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate12].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate12].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate12].Include, True) + '" />');
      Add ('      <VATRate Code="C" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate13].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate13].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate13].Include, True) + '" />');
      Add ('      <VATRate Code="F" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate14].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate14].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate14].Include, True) + '" />');
      Add ('      <VATRate Code="G" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate15].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate15].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate15].Include, True) + '" />');
      Add ('      <VATRate Code="R" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate16].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate16].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate16].Include, True) + '" />');
      Add ('      <VATRate Code="W" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate17].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate17].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate17].Include, True) + '" />');
      Add ('      <VATRate Code="Y" Description="' +  FixDodgyChars(SyssVAT.VATRAtes.VAT[Rate18].Desc) +
                    '" Rate="'  + formatfloat('###,###,##0.00%',Pcnt2Full(SyssVAT.VATRAtes.VAT[Rate18].Rate)) +
                    '" Goods="' + BoolToStr(SyssVAT.VATRAtes.VAT[Rate18].Include, True) + '" />');
      Add ('    </VATRates>');
      Add ('    <LastTaxReturn>'       + POutDateB(SyssVAT.VATRAtes.VATReturnDate) + '</LastTaxReturn>');
      Add ('    <TaxReturnEveryMonth>' + IntToStr(SyssVAT.VATRAtes.VATInterval) + '</TaxReturnEveryMonth>');
      Add ('    <CurrentTaxPeriod>'    + POutDateB(FCurrentTaxPeriod) + '</CurrentTaxPeriod>');
      Add ('    <TaxScheme>'           + FixDodgyChars(FTaxScheme) + '</TaxScheme>');
      // MH 10/05/2013 ABSEXCH-13793 v7.0.4: Added new fields for XML VAT100 Export
      If (CurrentCountry = UKCCode) Then
      Begin
        Add ('    <VAT100XML>');
        Add ('      <SubmitterType>' + FixDodgyChars(SyssVAT.VATRAtes.VAT100SenderType) + '</SubmitterType>');
        Add ('    </VAT100XML>');
      End; // If (CurrentCountry = UKCCode)
      Add ('  </VATRateSettings>');
    End;

    //------------------------------

    if FCISSetupPermission Then
    Begin
      Add ('  <CISSettings>');
      Add ('    <'+FLastReturnsLabel+'>'            + POutDateB(SyssCIS.CISRates.CISReturnDate) + '</'+FLastReturnsLabel+'>');
      Add ('    <'+FReturnEveryMonthLabel+'>'       + IntToStr(SyssCIS.CISRates.CISInterval) + '</'+FReturnEveryMonthLabel+'>');
      If (CurrentCountry<>DefaultCountry) Then
         Add ('    <SchemeRef>' + SyssCIS.CISRates.CISTaxRef + '</SchemeRef>');

      Add ('    <'+FCurrentPeriodLabel+'>'          + POutDateB(FCurrentCISPeriod) + '</'+FCurrentPeriodLabel+'>');
      Add ('    <SetPeriodFromDateAllocated>'       + BoolToStr(SyssCIS.CISRates.CISAutoSetPr, True) + '</SetPeriodFromDateAllocated>');
      Add ('    <'+FVatRateLabel+'>'                + SyssCIS.CISRates.CISVATCode + '</'+FVatRateLabel+'>');

      If (CurrentCountry=IECCode) Or
         (CurrentCountry=DefaultCountry) then
      Begin
         Add ('    <'+FContractorCISDetailsLabel+'>');
         Add ('      <'+FCertificateTypeLabel+'>'    + TxLate_CISTypeStr(SyssCIS.CISRates.JCISType) + '</'+FCertificateTypeLabel+'>');
         Add ('      <'+FCertificateRefLabel+'>'     + FixDodgyChars(SyssCIS.CISRates.JCertNo) + '</'+FCertificateRefLabel+'>');

         If (CurrentCountry=IECCode) then
            Add ('      <'+FTypeOfSubmitterLabel+'>'    + POutDateB(FSubmitterType) + '</'+FTypeOfSubmitterLabel+'>')
         else
            Add ('      <'+FTypeOfSubmitterLabel+'>'    + FSubmitterType + '</'+FTypeOfSubmitterLabel+'>');

         Add ('      <ContractorNINO>'               + SyssCIS340.CIS340.CISCNINO + '</ContractorNINO>');
         Add ('      <UTR>'                          + FixDodgyChars(SyssCIS340.CIS340.CISCUTR) + '</UTR>');
         If (CurrentCountry=IECCode) Then
            Add ('      <UseRCTReverseVAT>'          + BoolToStr(SyssCIS.CISRates.RCTUseRCV, True) + '</UseRCTReverseVAT>');
         Add ('      <'+FOfficeRefOrReverseLabel+'>' + FOfficeRefOrReverse + '</'+FOfficeRefOrReverseLabel+'>');
         Add ('    </'+FContractorCISDetailsLabel+'>');
      End;

      Add ('    <CodeConstruction>');
      Add ('      <Description>'         + SyssCIS.CISRates.CISRate[Construct].Desc + '</Description>');
      Add ('      <Rate>'                + formatfloat('###,###,##0.00%',Pcnt2Full(SyssCIS.CISRates.CISRate[Construct].Rate)) + '</Rate>');
      Add ('      <GeneralLedgerCode>'   + IntToStr(SyssCIS.CISRates.CISRate[Construct].GLCode) + '</GeneralLedgerCode>');
      Add ('      <CC>'                  + SyssCIS.CISRates.CISRate[Construct].RCCDep[True] + '</CC>');
      Add ('      <Dept>'                + SyssCIS.CISRates.CISRate[Construct].RCCDep[False] + '</Dept>');
      Add ('    </CodeConstruction>');
      Add ('    <CodeTechnical>');
      Add ('      <Description>'         + SyssCIS.CISRates.CISRate[Technical].Desc + '</Description>');
      Add ('      <Rate>'                + formatfloat('###,###,##0.00%',Pcnt2Full(SyssCIS.CISRates.CISRate[Technical].Rate)) + '</Rate>');
      Add ('      <GeneralLedgerCode>'   + IntToStr(SyssCIS.CISRates.CISRate[Technical].GLCode) + '</GeneralLedgerCode>');
      Add ('      <CC>'                  + SyssCIS.CISRates.CISRate[Technical].RCCDep[True] + '</CC>');
      Add ('      <Dept>'                + SyssCIS.CISRates.CISRate[Technical].RCCDep[False] + '</Dept>');
      Add ('    </CodeTechnical>');
      Add ('  </CISSettings>');
    End;

    //------------------------------

     // Customisation Configuration Files - EntCustm.Ini for Core Exchequer and Trade\TCCustom.Ini for Trade Counter
    Add ('  <CustomisationConfiguration>');
    Add ('    <EntCustm>');
    If FileExists(ExtractFilePath(Application.ExeName) + 'EntCustm.Ini') Then
    Begin
      oStrList := TStringList.Create;
      Try
        oStrList.LoadFromFile(ExtractFilePath(Application.ExeName) + 'EntCustm.Ini');
        For I := 0 To (oStrList.Count - 1) Do
        Begin
          Add ('      <Line>' + FixDodgyChars(oStrList.Strings[I]) + '</Line>');
        End; // For I
      Finally
        oStrList.Free;
      End; // Try..Finally
    End; // If FileExists(ExtractFilePath(Application.ExeName) + 'EntCustm.Ini')
    Add ('    </EntCustm>');

    Add ('    <TCCustom>');
    If FileExists(ExtractFilePath(Application.ExeName) + 'Trade\TCCustom.Ini') Then
    Begin
      oStrList := TStringList.Create;
      Try
        oStrList.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Trade\TCCustom.Ini');
        For I := 0 To (oStrList.Count - 1) Do
        Begin
          Add ('      <Line>' + FixDodgyChars(oStrList.Strings[I]) + '</Line>');
        End; // For I
      Finally
        oStrList.Free;
      End; // Try..Finally
    End; // If FileExists(ExtractFilePath(Application.ExeName) + 'Trade\TCCustom.Ini')
    Add ('    </TCCustom>');
    Add ('  </CustomisationConfiguration>');

    //------------------------------

    if FControlCodesPermission Then
    Begin
      Add ('  <GeneralLedgerControlCodes>');
      Add ('    <VATInput>'                      + IntToStr(Syss.NomCtrlCodes[InVAT]) + '</VATInput>');
      Add ('    <VATOutput>'                     + IntToStr(Syss.NomCtrlCodes[OutVAT]) + '</VATOutput>');
      Add ('    <DebtorsControlAccountAR>'       + IntToStr(Syss.NomCtrlCodes[Debtors]) + '</DebtorsControlAccountAR>');
      Add ('    <CreditorsControlAccountAR>'     + IntToStr(Syss.NomCtrlCodes[Creditors]) + '</CreditorsControlAccountAR>');
      // MH 11/05/2015 v7.0.14 ABSEXCH-16284: Rebadged Settlement Discount to Prompt Payment
      Add ('    <PromptPaymentDiscGiven>'           + IntToStr(Syss.NomCtrlCodes[DiscountGiven]) + '</PromptPaymentDiscGiven>');
      Add ('    <PromptPaymentDiscTaken>'           + IntToStr(Syss.NomCtrlCodes[DiscountTaken]) + '</PromptPaymentDiscTaken>');
      // MH 11/05/2015 v7.0.14 ABSEXCH-16284: Added new Settlement Write-Off Control Code
      Add ('    <SettlementWriteOff>'            + IntToStr(SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL) + '</SettlementWriteOff>');
      Add ('    <LineDiscountsGiven>'            + IntToStr(Syss.NomCtrlCodes[LDiscGiven]) + '</LineDiscountsGiven>');
      Add ('    <LineDiscountsTaken>'            + IntToStr(Syss.NomCtrlCodes[LDiscTaken]) + '</LineDiscountsTaken>');
      Add ('    <ProfitLossBroughtFwd>'          + IntToStr(Syss.NomCtrlCodes[ProfitBF]) + '</ProfitLossBroughtFwd>');
      Add ('    <CurrencyVariance>'              + IntToStr(Syss.NomCtrlCodes[CurrVar]) + '</CurrencyVariance>');
      Add ('    <UnrealisedCurrencyDifference>'  + IntToStr(Syss.NomCtrlCodes[UnRCurrVar]) + '</UnrealisedCurrencyDifference>');
      Add ('    <ProfitAndLossAccountStart>'     + IntToStr(Syss.NomCtrlCodes[PLStart]) + '</ProfitAndLossAccountStart>');
      Add ('    <ProfitAndLossAccountFinish>'    + IntToStr(Syss.NomCtrlCodes[PLEnd]) + '</ProfitAndLossAccountFinish>');
      Add ('    <FreightUpliftControl>'          + IntToStr(Syss.NomCtrlCodes[FreightNC]) + '</FreightUpliftControl>');
      Add ('    <SalesAccrualControl>'           + IntToStr(Syss.NomCtrlCodes[SalesComm]) + '</SalesAccrualControl>');
      Add ('    <PurchaseAccrualControl>'        + IntToStr(Syss.NomCtrlCodes[PurchComm]) + '</PurchaseAccrualControl>');
      Add ('    <ReturnsRestockCharge>'          + IntToStr(Syss.NomCtrlCodes[RetSurcharge]) + '</ReturnsRestockCharge>');
      Add ('    <JobCostingTimeSheetControlAccounts>');
      Add ('      <Overhead>'                  + IntToStr(SyssJob.JobSetup.EmployeeNom[1,False]) + '</Overhead>');
      Add ('      <Production>'                + IntToStr(SyssJob.JobSetup.EmployeeNom[2,False]) + '</Production>');
      Add ('      <Sub-Contract>'              + IntToStr(SyssJob.JobSetup.EmployeeNom[3,False]) + '</Sub-Contract>');
      Add ('    </JobCostingTimeSheetControlAccounts>');
      Add ('  </GeneralLedgerControlCodes>');
    End;

    //------------------------------

    if FF6PeriodPermission Then
    Begin
      Add ('  <CurrentFinancialPeriod>');
      Add ('    <SetGloballySettings>');
      Add ('      <CurrentPeriodNumber>'       + FGlobalPeriod + '</CurrentPeriodNumber>');
      Add ('      <FinancialStartYear>'        + FGlobalStartYear + '</FinancialStartYear>');
      Add ('      <EquivalentDateMMYY>'        + FGlobalEquivalentDate + '</EquivalentDateMMYY>');
      Add ('      <ShowPeriodsAsMonths>'       + BoolToStr(Syss.DispPrAsMonths, True) + '</ShowPeriodsAsMonths>');
      Add ('    </SetGloballySettings>');
      Add ('    <SetLocallySettings>');
      Add ('      <CurrentPeriodNumber>'       + FLocalPeriod + '</CurrentPeriodNumber>');
      Add ('      <FinancialStartYear>'        + FLocalStartYear + '</FinancialStartYear>');
      Add ('      <EquivalentDateMMYY>'        + FLocalEquivalentDate + '</EquivalentDateMMYY>');
      Add ('      <ShowPeriodsAsMonths>'       + BoolToStr(UserProfile.UDispPrMnth, True) + '</ShowPeriodsAsMonths>');
      Add ('    </SetLocallySettings>');
      Add ('  </CurrentFinancialPeriod>');
    End;

    //------------------------------
    // PKR. 11/01/2016. ABSEXCH-17097. Export Intrastat settings
    // The existing functionality for exporting the System Setup fields to XML will be extended
    // with a new Intrastat section containing the:
    //   Use EC/SSD Intrastat Fields,
    //   Show Delivery Terms,
    //   Show Mode of Transport,
    //   Last Closed Intrastat Arrivals Date
    //   Last Closed Intrastat Dispatches Date.
    Add ('  <Intrastat>');
    Add ('    <UseECSSDIntrastat>' + BoolToStr(Syss.IntraStat, True) + '</UseECSSDIntrastat>');
    Add ('    <ShowDeliveryTerms>' + BoolToStr(SystemSetup.Intrastat.isShowDeliveryTerms, True) + '</ShowDeliveryTerms>');
    Add ('    <ShowModeOfTransport>' + BoolToStr(SystemSetup.Intrastat.isShowModeOfTransport, True) + '</ShowModeOfTransport>');
    Add ('    <LastClosedArrivalsDate>' + SystemSetup.Intrastat.isLastClosedArrivalsDate + '</LastClosedArrivalsDate>');
    Add ('    <LastClosedDispatchesDate>' + SystemSetup.Intrastat.isLastClosedDispatchesDate + '</LastClosedDispatchesDate>');
    Add ('  </Intrastat>');

    //------------------------------

   Add ('</ExchequerSystemSettings>');
  End; { With ReportMemo }
End; { BuildReport }

//--------------------------------------------------------------------------

Initialization
  // Create global object to store survey information
  oExportSet := TExportSettings.Create;
Finalization
  FreeAndNIL(oExportSet);
end.

