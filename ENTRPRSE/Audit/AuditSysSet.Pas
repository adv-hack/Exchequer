Unit AuditSysSet;

Interface

Uses Classes, AuditBase, VarConst, GlobVar;

Type
  TSysSetAudit = Class (TAuditBase)
  Private
    FBeforeSysSet   : Sysrec;
    FAfterSysSet    : Sysrec;

    BeforeBUCCF     : String;
    AfterBUCCF      : String;

    BeforeCurConsMeth     : String;
    AfterCurConsMeth      : String;

    BeforeReturns         : String;
    AfterReturns          : String;

    BeforeCurrVarTol      : String;
    AfterCurrVarTol       : String;

    BeforeAgeByInvoice    : String;
    AfterAgeByInvoice     : String;

    BeforeStockValueMeth  : String;
    AfterStockValueMeth   : String;

    BeforeMultiLoc        : String;
    AfterMultiLoc         : String;

    BeforePcntMaskType    : Boolean;
    AfterPcntMaskType     : Boolean;

    // Use internal TBits to track what has changed - it will be set in NeedAuditEntry and re-used in WriteAuditData
    FChangedData    : TBits;
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

Uses SysUtils, ETDateU, ETMiscU, SysU1, CurrncyU, BtSupu2, SysU2, EncryptionUtils;

Const
  // Company Tab
  fldAddr1              = 0;
  fldAddr2              = 1;
  fldAddr3              = 2;

  fldAddr4              = 3;
  fldAddr5              = 4;
  fldPhone              = 5;

  fldFax                = 6;
  fldVRef               = 7;
  fldFinYrF             = 8;

  fldPeriodsInYear      = 9;
  fldLastAuditDate      = 10;
  // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
  //fldSettleDisc         = 11;
  //fldSettleDays         = 12;

  fldPayTerms           = 13;
  fldCode               = 14;

  fldDirCust            = 15;
  fldDirSupp            = 16;
  fldDebML              = 17;

  fldOverdFrstLet       = 18;
  fldUpTo1              = 19;
  fldUpTo2              = 20;

  fldUpTo3              = 21;
  fldBankName           = 22;
  fldBankAct            = 23;

  fldBankSortCode       = 24;
  fldBankRef            = 25;
  fldTradeTermMssg      = 26;

  fldTTMsg1             = 27;
  fldTTMsg2             = 28;

  // System/GL/Currency Tab
  fldExtCustRec         = 29;

  fldNumTradCode        = 30;
  fldExtSINGen          = 31;
  fldUseDOSkeys         = 32;

  fldHideExchLogo       = 33;
//  TG - 31-01-2017 -18119 : System Settings - Remove system switch 'Use Themes'
//  fldUseThemes          = 34;
//  fldThemeType          = 35;

  fldConsMemory         = 36;
  fldUsePasswords       = 37;
  fldHideUnauthOpt      = 38;

  fldDisablePost        = 39;
  fldSetPeriod          = 40;
  fldUseCCandDept       = 41;

  fldCCandDept          = 42;
  fldClearPayments      = 43;
  fldSplitLineGL        = 44;

  fldCurrConsMethod     = 45;
  fldReturns            = 46;
  fldCurrVarTol         = 47;

  fldTolerance          = 48;
  fldEnforceGLCls       = 49;

  // SL/PL
  fldCreditLimitChk     = 50;
  fldCreditStatChk      = 51;
  fldPutOnStop          = 52;

  fldOldestDebt         = 53;
  fldDisableSetle       = 54;
  fldIncludeNotDue      = 55;

  fldAddNotes           = 56;
  fldAgeByInvDate       = 57;
  fldKeepSQUPQU         = 58;

  flgOurRefCount        = 59;
  flgWarnIfDup          = 60;
  flgProtectYourRef     = 61;

  flgPromptSalesRec     = 62;
  flgPayInRef           = 63;
  flgAutoCheqNum        = 64;

  flgStopManEntry       = 65;
  flgForceBatchTot      = 66;
  flgUpdateTradBal      = 67;

  flgDefDiscount        = 68;
  flgAuthMethod         = 69;
  flgDecCostPrice       = 70;

  flgDecSalePrice       = 71;
  flgDecQty             = 72;

  // Stock/SPOP
  flgDefStockValMethod  = 73;
  flgMultiLoc           = 74;
  flgLiveSalesVal       = 75;

  flgDispInsufStock     = 76;
  flgUseECFields        = 77;
  flgUpdBuildCosts      = 78;

  flgDescOnly           = 79;
  flgSetBOMOnSales      = 80;
  flgDeductCompNoBOM    = 81;

  flgQuotesAllocStock   = 82;
  flgFreeStockExStock   = 83;
  flgOrderToAlloc       = 84;

  flgSDNShowPickedItems = 85;
  flgUsePackQtyOnTrans  = 86;
  flgSDNDateIsTaxPoint  = 87;

  flgShowPriceBands     = 88;
  flgManUpdateReOrder   = 89;
  flgAutoPostUplift     = 90;

  flgRetainBinHistory   = 91;
  flgFilterPickList     = 92;
  flgBinCodeMask        = 93;

  flgUseTransTotDisc    = 94;
  flgUseValueBasedDisc  = 95;
  flgUseOverrideLoc     = 96;

  flgIncludeVATInBal    = 97;

  // Job Costing
  flgWarnOverBudget     = 98;
  flgProtectApplication = 99;

  // WOP
  flgOrderAllocStockPick    = 100;
  flgDisableWorkInProgress  = 101;
  flgCopyingStockNotesToWO  = 102;

  flgCompanyName            = 103; // Missed out field

  // MH 05/09/2013 v7.XMRD MRD1.1.10: Added Consumer Support
  flgConsumersEnabled       = 104;

  // MH 21/07/2014: Added support for Order Payments flag
  fldEnableOrderPayments     = 105;

  TotFields = fldEnableOrderPayments+1;

//=========================================================================

Constructor TSysSetAudit.Create;
Begin // Create
  Inherited Create;

  FChangedData := TBits.Create;
  FChangedData.Size := TotFields;
End; // Create

//------------------------------

Destructor TSysSetAudit.Destroy;
Begin // Destroy
  FreeAndNIL(FChangedData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSysSetAudit.GetBeforeData : Pointer;
Begin // GetBeforeData
  Result := @FBeforeSysSet;
End; // GetBeforeData

Procedure TSysSetAudit.SetBeforeData (Value : Pointer);
Begin // SetBeforeData
  Move (Value^, FBeforeSysSet, SizeOf(FBeforeSysSet));
End; // SetBeforeData

//------------------------------

Function TSysSetAudit.GetAfterData : Pointer;
Begin // GetAfterData
  Result := @FAfterSysSet;
End; // GetAfterData

Procedure TSysSetAudit.SetAfterData (Value : Pointer);
Begin // SetAfterData
  Move (Value^, FAfterSysSet, SizeOf(FAfterSysSet));
End; // SetAfterData

//-------------------------------------------------------------------------

Function TSysSetAudit.NeedAuditEntry : Boolean;
Var
  I             : SmallInt;
  ReturnsList   : TStringList;
  StockValueList   : TStringList;
  BeforeMLLocIndex : Integer;
  AfterMLLocIndex  : Integer;
Begin // NeedAuditEntry

   // The contents have been taken from SetCISU.pas and the CBSubType.Items Component
   // Any new entries should be added to this list in the appropriate order

   // Reseting Currency Cosnolidation Method
   BeforeCurConsMeth  := '';
   AfterCurConsMeth   := '';

   // Extracted from Currncy function UseCoDayRate. Had to do it this way as need before rate and after
   if (FBeforeSysSet.TotalConv=XDayCode = True) Then
       BeforeCurConsMeth := 'Daily Rate'
   else
       BeforeCurConsMeth := 'Company Rate';

   if (FAfterSysSet.TotalConv=XDayCode = True) Then
       AfterCurConsMeth := 'Daily Rate'
   else
       AfterCurConsMeth := 'Company Rate';

   // Dealing with Budget Choice
   BeforeBUCCF := '';
   AfterBUCCF  := '';

   // Going to display the actual selection user has chosen

   With FBeforeSysSet Do
   Begin
    if Ord(PostCCNom)+Ord(PostCCDCombo) = 0 Then
       BeforeBUCCF := 'No Budgeting by Cost Centre/Department'
    else
      if Ord(PostCCNom)+Ord(PostCCDCombo) = 1 Then
         BeforeBUCCF := 'Budget by Cost Centre or Department only'
      else
         BeforeBUCCF := 'Budget by CC, Dept & CC+Dept Combined'
   End;

   With FAfterSysSet Do
   Begin
    if Ord(PostCCNom)+Ord(PostCCDCombo) = 0 Then
       AfterBUCCF := 'No Budgeting by Cost Centre/Department'
    else
      if Ord(PostCCNom)+Ord(PostCCDCombo) = 1 Then
         AfterBUCCF := 'Budget by Cost Centre or Department only'
      else
         AfterBUCCF := 'Budget by CC, Dept & CC+Dept Combined'
   End;

   // Setting up the appropriate returns
   BeforeReturns := '';
   AfterReturns  := '';

   ReturnsList := TStringList.Create;
   ReturnsList.Clear;
   ReturnsList.Assign(STDCurrList);

   BeforeReturns := ReturnsList.Strings[FBeforeSysSet.VATCurr];
   AfterReturns  := ReturnsList.Strings[FAfterSysSet.VATCurr];

   // Dealing with Allocation CurrVar Tolerance
   BeforeCurrVarTol := '';
   AfterCurrVarTol  := '';

   if FBeforeSysSet.AlTolMode = 0 Then
     BeforeCurrVarTol := 'Disabled'
   else
    if FBeforeSysSet.AlTolMode = 1 Then
       BeforeCurrVarTol := 'Fixed Value'
    else
       BeforeCurrVarTol := 'Percentage';

   if FAfterSysSet.AlTolMode = 0 Then
     AfterCurrVarTol := 'Disabled'
   else
    if FAfterSysSet.AlTolMode = 1 Then
       AfterCurrVarTol := 'Fixed Value'
    else
       AfterCurrVarTol := 'Percentage';

   // Dealing with Age by Invoice Date Dropdown
    BeforeAgeByInvoice   := '';
    AfterAgeByInvoice   := '';

   // Going to display the actual selection user has chosen

   With FBeforeSysSet Do
   Begin
    if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 0 Then
       BeforeAgeByInvoice := 'Do Not'
    else
      if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 1 Then
         BeforeAgeByInvoice := 'Sales Ledger'
      else
         if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 2 Then
            BeforeAgeByInvoice := 'Purchase Ledger'
         else
            BeforeAgeByInvoice := 'Sales & Purchase'
   End;

   With FAfterSysSet Do
   Begin
    if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 0 Then
       AfterAgeByInvoice := 'Do Not'
    else
      if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 1 Then
         AfterAgeByInvoice := 'Sales Ledger'
      else
         if (1*Ord(StaUIDate))+(2*Ord(PurchUIDate)) = 2 Then
            AfterAgeByInvoice := 'Purchase Ledger'
         else
            AfterAgeByInvoice := 'Sales & Purchase'
   End;

   // Just Initialising the Mask Setting
   BeforePcntMaskType  := False;
   AfterPcntMaskType   := False;

   if (FBeforeSysSet.AlTolVal) <>  (FAfterSysSet.AlTolVal) Then
   Begin
      if (FBeforeSysSet.AlTolMode = 2) Then
         BeforePcntMaskType := True;
      if (FAfterSysSet.AlTolMode = 2) Then
         AfterPcntMaskType := True;
   End;

   // Dealing with the building of the Stock Value Method
   BeforeStockValueMeth  := '';
   AfterStockValueMeth   := '';

   // MH 18/06/2013 v7.0.4 ABSEXCH-14316: Crashing in Non-Stock systems due to reference to Stock only variable
   {$IFDEF STK}
     StockValueList := TStringList.Create;
     StockValueList.Clear;
     StockValueList.Assign(STDValList);
     {$IFDEF SOP}
       StockValueList.Add('Serial/Batch Average Cost');
     {$ENDIF}

     BeforeStockValueMeth := StockValueList.Strings[StkVM2I(FBeforeSysSet.AutoStkVal)];
     AfterStockValueMeth  := StockValueList.Strings[StkVM2I(FAfterSysSet.AutoStkVal)];
   {$ENDIF STK}

  // Dealing with Multi Location
  if (FBeforeSysSet.UseLocDel) Then
      BeforeMLLocIndex := 2
  else
      BeforeMLLocIndex := Ord(FBeforeSysSet.UseMLoc);

  if (FAfterSysSet.UseLocDel) Then
      AfterMLLocIndex := 2
  else
      AfterMLLocIndex := Ord(FAfterSysSet.UseMLoc);

  if (BeforeMLLocIndex <> AfterMLLocIndex) Then
  Begin
     if (BeforeMLLocIndex = 0) Then
        BeforeMultiLoc := 'Disabled'
     else
       if (BeforeMLLocIndex = 1) Then
          BeforeMultiLoc := 'Enabled'
       else
          BeforeMultiLoc := 'Use for Delivery Address';

     if (AfterMLLocIndex = 0) Then
        AfterMultiLoc := 'Disabled'
     else
       if (AfterMLLocIndex = 1) Then
          AfterMultiLoc := 'Enabled'
       else
          AfterMultiLoc := 'Use for Delivery Address';
  End;


   // Initialise the variables used

   FChangedData[fldAddr1]               := (FBeforeSysSet.DetailAddr[1])     <>     (FAfterSysSet.DetailAddr[1]);
   FChangedData[fldAddr2]               := (FBeforeSysSet.DetailAddr[2])     <>     (FAfterSysSet.DetailAddr[2]);
   FChangedData[fldAddr3]               := (FBeforeSysSet.DetailAddr[3])     <>     (FAfterSysSet.DetailAddr[3]);

   FChangedData[fldAddr4]               := (FBeforeSysSet.DetailAddr[4])     <>     (FAfterSysSet.DetailAddr[4]);
   FChangedData[fldAddr5]               := (FBeforeSysSet.DetailAddr[5])     <>     (FAfterSysSet.DetailAddr[5]);
   FChangedData[fldPhone]               := (FBeforeSysSet.DetailTel)         <>     (FAfterSysSet.DetailTel);

   FChangedData[fldFax]                 := (FBeforeSysSet.DetailFax)         <>     (FAfterSysSet.DetailFax);
   FChangedData[fldVRef]                := (FBeforeSysSet.UserVATReg)        <>     (FAfterSysSet.UserVATReg);
   FChangedData[fldFinYrF]              := (FBeforeSysSet.MonWk1)            <>     (FAfterSysSet.MonWk1);

   FChangedData[fldPeriodsInYear]       := (FBeforeSysSet.PrInYr)            <>     (FAfterSysSet.PrInYr);
   FChangedData[fldLastAuditDate]       := (FBeforeSysSet.AuditDate)         <>     (FAfterSysSet.AuditDate);
   // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
   //FChangedData[fldSettleDisc]          := (FBeforeSysSet.SettleDisc)        <>     (FAfterSysSet.SettleDisc);
   //FChangedData[fldSettleDays]          := (FBeforeSysSet.SettleDays)        <>     (FAfterSysSet.SettleDays);

   FChangedData[fldPayTerms]            := (FBeforeSysSet.PayTerms)          <>     (FAfterSysSet.PayTerms);
   FChangedData[fldCode]                := (FBeforeSysSet.VATCode)           <>     (FAfterSysSet.VATCode);
   FChangedData[fldDirCust]             := (FBeforeSysSet.DirectCust)        <>     (FAfterSysSet.DirectCust);

   FChangedData[fldDirSupp]             := (FBeforeSysSet.DirectSupp)        <>     (FAfterSysSet.DirectSupp);
   FChangedData[fldDebML]               := (FBeforeSysSet.DebtLMode)         <>     (FAfterSysSet.DebtLMode);
   FChangedData[fldOverdFrstLet]        := (FBeforeSysSet.WKSODue)           <>     (FAfterSysSet.WKSODue);

   FChangedData[fldUpTo1]               := (FBeforeSysSet.DebTrig[1])        <>     (FAfterSysSet.DebTrig[1]);
   FChangedData[fldUpTo2]               := (FBeforeSysSet.DebTrig[2])        <>     (FAfterSysSet.DebTrig[2]);
   FChangedData[fldUpTo3]               := (FBeforeSysSet.DebTrig[3])        <>     (FAfterSysSet.DebTrig[3]);


    //PR: 28/08/2013 MRD Changed Sort Code/Account Code fields to SEPA/IBAN
   FChangedData[fldBankName]            := (FBeforeSysSet.UserBank)          <>     (FAfterSysSet.UserBank);
   FChangedData[fldBankAct]             := (FBeforeSysSet.ssBankAccountCode) <>     (FAfterSysSet.ssBankAccountCode);
   FChangedData[fldBankSortCode]        := (FBeforeSysSet.ssBankSortCode)    <>     (FAfterSysSet.ssBankSortCode);
   FChangedData[fldBankRef]             := (FBeforeSysSet.UserRef)           <>     (FAfterSysSet.UserRef);

   FChangedData[fldTradeTermMssg]       := (FBeforeSysSet.TradeTerm)         <>     (FAfterSysSet.TradeTerm);
   FChangedData[fldTTMsg1]              := (FBeforeSysSet.TermsofTrade[1])   <>     (FAfterSysSet.TermsofTrade[1]);
   FChangedData[fldTTMsg2]              := (FBeforeSysSet.TermsofTrade[2])   <>     (FAfterSysSet.TermsofTrade[2]);

   // System/GL/Currency Tab

   FChangedData[fldExtCustRec]          := (FBeforeSysSet.ExternCust)        <>     (FAfterSysSet.ExternCust);
   FChangedData[fldNumTradCode]         := (FBeforeSysSet.TradCodeNum)       <>     (FAfterSysSet.TradCodeNum);
   FChangedData[fldExtSINGen]           := (FBeforeSysSet.ExternSIN)         <>     (FAfterSysSet.ExternSIN);

   FChangedData[fldUseDOSkeys]          := (FBeforeSysSet.TxLateCr)          <>     (FAfterSysSet.TxLateCr);
   FChangedData[fldHideExchLogo]        := (FBeforeSysSet.HideExLogo)        <>     (FAfterSysSet.HideExLogo);
   // TG - 01-02-2017 -18119 : System Settings - Remove system switch 'Use Themes'
   // FChangedData[fldUseThemes]           := (FBeforeSysSet.UseBkTheme)        <>     (FAfterSysSet.UseBkTheme);
   // FChangedData[fldThemeType]           := (BeforeThemeType)                 <>     (AfterThemeType);

   FChangedData[fldConsMemory]          := (FBeforeSysSet.ConsvMem)          <>     (FAfterSysSet.ConsvMem);
   FChangedData[fldUsePasswords]        := (FBeforeSysSet.UsePassWords)      <>     (FAfterSysSet.UsePassWords);

   FChangedData[fldHideUnauthOpt]       := (FBeforeSysSet.HideMenuOpt)       <>     (FAfterSysSet.HideMenuOpt);
   FChangedData[fldDisablePost]         := (FBeforeSysSet.PrevPrOff)         <>     (FAfterSysSet.PrevPrOff);
   FChangedData[fldSetPeriod]           := (FBeforeSysSet.AutoPrCalc)        <>     (FAfterSysSet.AutoPrCalc);

   FChangedData[fldUseCCandDept]        := (FBeforeSysSet.UseCCDep)          <>     (FAfterSysSet.UseCCDep);
   FChangedData[fldCCandDept]           := (BeforeBUCCF)                     <>     (AfterBUCCF);
   FChangedData[fldClearPayments]       := (FBeforeSysSet.AutoClearPay)      <>     (FAfterSysSet.AutoClearPay);

   FChangedData[fldSplitLineGL]         := (FBeforeSysSet.SepDiscounts)      <>     (FAfterSysSet.SepDiscounts);
   FChangedData[fldCurrConsMethod]      := (BeforeCurConsMeth                <>     AfterCurConsMeth);
   FChangedData[fldReturns]             := BeforeReturns                     <>     AfterReturns;

   FChangedData[fldCurrVarTol]          := BeforeCurrVarTol                  <>     AfterCurrVarTol;
   FChangedData[fldTolerance]           := (FBeforeSysSet.AlTolVal)          <>     (FAfterSysSet.AlTolVal);
   FChangedData[fldEnforceGLCls]        := (FBeforeSysSet.UseGLClass)        <>     (FAfterSysSet.UseGLClass);

   // SL/PL Tab
   FChangedData[fldCreditLimitChk]      := (FBeforeSysSet.UseCRLimitChk)     <>     (FAfterSysSet.UseCRLimitChk);
   FChangedData[fldCreditStatChk]       := (FBeforeSysSet.UseCreditChk)      <>     (FAfterSysSet.UseCreditChk);
   FChangedData[fldPutOnStop]           := (FBeforeSysSet.StopBadDr)         <>     (FAfterSysSet.StopBadDr);

   FChangedData[fldOldestDebt]          := (FBeforeSysSet.LiveCredS)         <>     (FAfterSysSet.LiveCredS);
   FChangedData[fldDisableSetle]        := (FBeforeSysSet.NoHoldDisc)        <>     (FAfterSysSet.NoHoldDisc);
   FChangedData[fldIncludeNotDue]       := (FBeforeSysSet.IncNotDue)         <>     (FAfterSysSet.IncNotDue);

   FChangedData[fldAddNotes]            := (FBeforeSysSet.AutoNotes)         <>     (FAfterSysSet.AutoNotes);
   FChangedData[fldAgeByInvDate]        := BeforeAgeByInvoice                <>     AfterAgeByInvoice;
   FChangedData[fldKeepSQUPQU]          := (FBeforeSysSet.QuoOwnDate)        <>     (FAfterSysSet.QuoOwnDate);

   FChangedData[flgOurRefCount]         := (FBeforeSysSet.DirOwnCount)       <>     (FAfterSysSet.DirOwnCount);
   FChangedData[flgWarnIfDup]           := (FBeforeSysSet.WarnYRef)          <>     (FAfterSysSet.WarnYRef);
   FChangedData[flgProtectYourRef]      := (FBeforeSysSet.ProtectYRef)       <>     (FAfterSysSet.ProtectYRef);

   FChangedData[flgPromptSalesRec]      := (FBeforeSysSet.PrintReciept)      <>     (FAfterSysSet.PrintReciept);
   FChangedData[flgPayInRef]            := (FBeforeSysSet.UsePayIn)          <>     (FAfterSysSet.UsePayIn);
   FChangedData[flgAutoCheqNum]         := (FBeforeSysSet.AutoCQNo)          <>     (FAfterSysSet.AutoCQNo);

   FChangedData[flgStopManEntry]        := (FBeforeSysSet.BatchPPY)          <>     (FAfterSysSet.BatchPPY);
   FChangedData[flgForceBatchTot]       := (FBeforeSysSet.UseBatchTot)       <>     (FAfterSysSet.UseBatchTot);
   FChangedData[flgUpdateTradBal]       := (FBeforeSysSet.UpBalOnPost)       <>     (FAfterSysSet.UpBalOnPost);

   FChangedData[flgDefDiscount]         := (FBeforeSysSet.DefPCDisc)         <>     (FAfterSysSet.DefPCDisc);
   FChangedData[flgAuthMethod]          := (FBeforeSysSet.AuthMode)          <>     (FAfterSysSet.AuthMode);
   FChangedData[flgDecCostPrice]        := (FBeforeSysSet.NoCosDec)          <>     (FAfterSysSet.NoCosDec);

   FChangedData[flgDecSalePrice]        := (FBeforeSysSet.NoNetDec)          <>     (FAfterSysSet.NoNetDec);
   FChangedData[flgDecQty]              := (FBeforeSysSet.NoQtyDec)          <>     (FAfterSysSet.NoQtyDec);

   // Stock/SPOP Tab
   FChangedData[flgDefStockValMethod]   := (FBeforeSysSet.AutoStkVal)        <>     (FAfterSysSet.AutoStkVal);
   FChangedData[flgMultiLoc]            := (BeforeMLLocIndex)                <>     (AfterMLLocIndex);
   FChangedData[flgLiveSalesVal]        := (FBeforeSysSet.AutoValStk)        <>     (FAfterSysSet.AutoValStk);

   FChangedData[flgDispInsufStock]      := (FBeforeSysSet.UseStock)          <>     (FAfterSysSet.UseStock);
   FChangedData[flgUseECFields]         := (FBeforeSysSet.IntraStat)         <>     (FAfterSysSet.IntraStat);
   FChangedData[flgUpdBuildCosts]       := (FBeforeSysSet.AutoBillUp)        <>     (FAfterSysSet.AutoBillUp);

   FChangedData[flgDescOnly]            := (FBeforeSysSet.AnalStkDesc)       <>     (FAfterSysSet.AnalStkDesc);
   FChangedData[flgSetBOMOnSales]       := (FBeforeSysSet.EditSinSer)        <>     (FAfterSysSet.EditSinSer);
   FChangedData[flgDeductCompNoBOM]     := (FBeforeSysSet.DeadBOM)           <>     (FAfterSysSet.DeadBOM);

   FChangedData[flgQuotesAllocStock]    := (FBeforeSysSet.QuAllocFlg)        <>     (FAfterSysSet.QuAllocFlg);
   FChangedData[flgFreeStockExStock]    := (FBeforeSysSet.FreeExAll)         <>     (FAfterSysSet.FreeExAll);
   FChangedData[flgOrderToAlloc]        := (FBeforeSysSet.UsePick4All)       <>     (FAfterSysSet.UsePick4All);

   FChangedData[flgSDNShowPickedItems]  := (FBeforeSysSet.DelPickOnly)       <>     (FAfterSysSet.DelPickOnly);
   FChangedData[flgUsePackQtyOnTrans]   := (FBeforeSysSet.InpPack)           <>     (FAfterSysSet.InpPack);
   FChangedData[flgSDNDateIsTaxPoint]   := (FBeforeSysSet.SDNOwnDate)        <>     (FAfterSysSet.SDNOwnDate);

   FChangedData[flgShowPriceBands]      := (FBeforeSysSet.ShowStkGP)         <>     (FAfterSysSet.ShowStkGP);
   FChangedData[flgManUpdateReOrder]    := (FBeforeSysSet.ManROCP)           <>     (FAfterSysSet.ManROCP);
   FChangedData[flgAutoPostUplift]      := (FBeforeSysSet.UseUpliftNC)       <>     (FAfterSysSet.UseUpliftNC);

   FChangedData[flgRetainBinHistory]    := (FBeforeSysSet.KeepBinHist)       <>     (FAfterSysSet.KeepBinHist);
   FChangedData[flgFilterPickList]      := (FBeforeSysSet.FiltSNoBinLoc)     <>     (FAfterSysSet.FiltSNoBinLoc);
   FChangedData[flgBinCodeMask]         := (FBeforeSysSet.BinMask)           <>     (FAfterSysSet.BinMask);

   FChangedData[flgUseTransTotDisc]     := (FBeforeSysSet.EnableTTDDiscounts)        <>     (FAfterSysSet.EnableTTDDiscounts);
   FChangedData[flgUseValueBasedDisc]   := (FBeforeSysSet.EnableVBDDiscounts)        <>     (FAfterSysSet.EnableVBDDiscounts);
   FChangedData[flgUseOverrideLoc]      := (FBeforeSysSet.EnableOverrideLocations)   <>     (FAfterSysSet.EnableOverrideLocations);

   FChangedData[flgIncludeVATInBal]     := (FBeforeSysSet.IncludeVATInCommittedBalance)   <>     (FAfterSysSet.IncludeVATInCommittedBalance);
   FChangedData[flgWarnOverBudget]      := (FBeforeSysSet.WarnJC)                         <>     (FAfterSysSet.WarnJC);
   FChangedData[flgProtectApplication]  := (FBeforeSysSet.ProtectYRef)                    <>     (FAfterSysSet.ProtectYRef);

   // WOP Tab
   FChangedData[flgOrderAllocStockPick]     := (FBeforeSysSet.UseWIss4All)     <>     (FAfterSysSet.UseWIss4All);
   FChangedData[flgDisableWorkInProgress]   := (FBeforeSysSet.UseSTDWOP)       <>     (FAfterSysSet.UseSTDWOP);
   FChangedData[flgCopyingStockNotesToWO]   := (FBeforeSysSet.WOPStkCopMode)   <>     (FAfterSysSet.WOPStkCopMode);

   // Missing Field
   FChangedData[flgCompanyName]             := (FBeforeSysSet.UserName)        <>     (FAfterSysSet.UserName);

   // MH 05/09/2013 v7.XMRD MRD1.1.10: Added Consumer Support
   FChangedData[flgConsumersEnabled]       := (FBeforeSysSet.ssConsumersEnabled <> FAfterSysSet.ssConsumersEnabled);

   // MH 21/07/2014: Added support for Order Payments flag
   FChangedData[fldEnableOrderPayments]      := (FBeforeSysSet.ssEnableOrderPayments <> FAfterSysSet.ssEnableOrderPayments);

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

  // Clear all the stringlist created
  ReturnsList.Free;
  {$IFDEF STK}
    StockValueList.Free;
  {$ENDIF STK}
End; // NeedAuditEntry

//-------------------------------------------------------------------------

Procedure TSysSetAudit.WriteAuditData (Const Destination : TAuditLogDestination; AuditStrings : TStrings);
Var
  I           : SmallInt;
  BeforeTol   : String;
  AfterTol    : String;
  BeforeAuthMeth    : String;
  AfterAuthMeth     : String;
  BeforeCopyStkToWO : String;
  AfterCopyStkToWO  : String;
  BeforeDebML       : String;
  AfterDebML        : String;
Begin // WriteAuditData

  // The following will determine the format of the tolerance if it was altered
  if (BeforePcntMaskType) Then
     BeforeTol := formatfloat('#0.0%;-#0.0%',FBeforeSysSet.AlTolVal)
  else
     BeforeTol := formatfloat('###,###,##0.00 ;###,###,##0.00-',FBeforeSysSet.AlTolVal);

  if (AfterPcntMaskType) Then
     AfterTol := formatfloat('#0.0%;-#0.0%',FAfterSysSet.AlTolVal)
  else
     AfterTol := formatfloat('###,###,##0.00 ;###,###,##0.00-',FAfterSysSet.AlTolVal);

  // Dealing with Authorisation Method
  if (FBeforeSysSet.AuthMode <> FAfterSysSet.AuthMode) Then
  Begin
     if (FBeforeSysSet.AuthMode In ['N',#0]) Then
        BeforeAuthMeth := 'None'
     else
       if (FBeforeSysSet.AuthMode In ['A']) Then
          BeforeAuthMeth := 'Automatic'
       else
          BeforeAuthMeth := 'Manual';

     if (FAfterSysSet.AuthMode In ['N',#0]) Then
        AfterAuthMeth := 'None'
     else
       if (FAfterSysSet.AuthMode In ['A']) Then
          AfterAuthMeth := 'Automatic'
       else
          AfterAuthMeth := 'Manual';
  End;

  // Dealing with Copying Stock Notes to Works Order
  if (FBeforeSysSet.WOPStkCopMode <> FAfterSysSet.WOPStkCopMode) Then
  Begin
     if (FBeforeSysSet.WOPStkCopMode = 0) Then
        BeforeCopyStkToWO := 'Copy both Dated & General Notes'
     else
       if (FBeforeSysSet.WOPStkCopMode = 1) Then
          BeforeCopyStkToWO := 'Copy General Notes Only'
       else
          BeforeCopyStkToWO := 'Copy Dated Notes Only';

     if (FAfterSysSet.WOPStkCopMode = 0) Then
        AfterCopyStkToWO := 'Copy both Dated & General Notes'
     else
       if (FAfterSysSet.WOPStkCopMode = 1) Then
          AfterCopyStkToWO := 'Copy General Notes Only'
       else
          AfterCopyStkToWO := 'Copy Dated Notes Only';
   End;

  // Dealing with Deb ML
  if (FBeforeSysSet.DebtLMode <> FAfterSysSet.DebtLMode) Then
  Begin
     if (FBeforeSysSet.DebtLMode = 0) Then
        BeforeDebML := 'Weeks Single'
     else
       if (FBeforeSysSet.DebtLMode = 1) Then
          BeforeDebML := 'Days Single'
       else
          if (FBeforeSysSet.DebtLMode = 2) Then
             BeforeDebML := 'Weeks Escalating'
          else
             if (FBeforeSysSet.DebtLMode = 3) Then
                BeforeDebML := 'Days Escalating'
             else
                if (FBeforeSysSet.DebtLMode = 4) Then
                   BeforeDebML := 'Weeks Multiple'
                else
                   BeforeDebML := 'Days Multiple';

     if (FAfterSysSet.DebtLMode = 0) Then
        AfterDebML := 'Weeks Single'
     else
       if (FAfterSysSet.DebtLMode = 1) Then
          AfterDebML := 'Days Single'
       else
          if (FAfterSysSet.DebtLMode = 2) Then
             AfterDebML := 'Weeks Escalating'
          else
             if (FAfterSysSet.DebtLMode = 3) Then
                AfterDebML := 'Days Escalating'
             else
                if (FAfterSysSet.DebtLMode = 4) Then
                   AfterDebML := 'Weeks Multiple'
                else
                   AfterDebML := 'Days Multiple';
   End;

  If (Destination = adAuditTrail) Then
  Begin
    WriteAuditSubTitle (AuditStrings, 'System Setup - General Settings', '');
    WriteChangesHeader (AuditStrings);

    For I := 0 To (FChangedData.Size - 1) Do
    Begin
      If FChangedData[I] Then
      Begin
        Case I Of                                            //   12345678901234567890
          fldAddr1              : WriteDataChange (AuditStrings, 'Company Addr 1',      FBeforeSysSet.DetailAddr[1],            FAfterSysSet.DetailAddr[1]);
          fldAddr2              : WriteDataChange (AuditStrings, 'Company Addr 2',      FBeforeSysSet.DetailAddr[2],            FAfterSysSet.DetailAddr[2]);
          fldAddr3              : WriteDataChange (AuditStrings, 'Company Addr 3',      FBeforeSysSet.DetailAddr[3],            FAfterSysSet.DetailAddr[3]);

          fldAddr4              : WriteDataChange (AuditStrings, 'Company Addr 4',      FBeforeSysSet.DetailAddr[4],            FAfterSysSet.DetailAddr[4]);
          fldAddr5              : WriteDataChange (AuditStrings, 'Company Addr 5',      FBeforeSysSet.DetailAddr[5],            FAfterSysSet.DetailAddr[5]);
          fldPhone              : WriteDataChange (AuditStrings, 'Company Phone',       FBeforeSysSet.DetailTel,                FAfterSysSet.DetailTel);

          fldFax                : WriteDataChange (AuditStrings, 'Company Fax',         FBeforeSysSet.DetailFax,                FAfterSysSet.DetailFax);
          fldVRef               : WriteDataChange (AuditStrings, 'VAT Reg',             FBeforeSysSet.UserVATReg,               FAfterSysSet.UserVATReg);
          fldFinYrF             : WriteDataChange (AuditStrings, 'Financial Yr Start',  POutDateB(FBeforeSysSet.MonWk1),        POutDateB(FAfterSysSet.MonWk1));

          fldPeriodsInYear      : WriteDataChange (AuditStrings, 'Periods in Year',     IntToStr(FBeforeSysSet.PrInYr),         IntToStr(FAfterSysSet.PrInYr));
          fldLastAuditDate      : WriteDataChange (AuditStrings, 'Last Audit Date',     POutDateB(FBeforeSysSet.AuditDate),     POutDateB(FAfterSysSet.AuditDate));
          // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
          //fldSettleDisc         : WriteDataChange (AuditStrings, 'Sett. Discount',      formatfloat('#0.0%;-#0.0%',FBeforeSysSet.SettleDisc),     formatfloat('#0.0%;-#0.0%',FAfterSysSet.SettleDisc));
          //fldSettleDays         : WriteDataChange (AuditStrings, 'Sett. Days',          IntToStr(FBeforeSysSet.SettleDays),     IntToStr(FAfterSysSet.SettleDays));

          fldPayTerms           : WriteDataChange (AuditStrings, 'Payment Terms',       IntToStr(FBeforeSysSet.PayTerms),       IntToStr(FAfterSysSet.PayTerms));
          fldCode               : WriteDataChange (AuditStrings, 'Def VAT Code',        FBeforeSysSet.VATCode,                  FAfterSysSet.VATCode);
          fldDirCust            : WriteDataChange (AuditStrings, 'Direct Cust SRI',     FBeforeSysSet.DirectCust,               FAfterSysSet.DirectCust);

          fldDirSupp            : WriteDataChange (AuditStrings, 'Direct Supp PPI',     FBeforeSysSet.DirectSupp,               FAfterSysSet.DirectSupp);
          fldDebML              : WriteDataChange (AuditStrings, 'Debt Length Mode',    BeforeDebML,                            AfterDebML);
          fldOverdFrstLet       : WriteDataChange (AuditStrings, 'Overdue 1st Let',     IntToStr(FBeforeSysSet.WKSODue),        IntToStr(FAfterSysSet.WKSODue));

          fldUpTo1              : WriteDataChange (AuditStrings, 'DEBT wks o/due',      IntToStr(FBeforeSysSet.DebTrig[1]),     IntToStr(FAfterSysSet.DebTrig[1]));
          fldUpTo2              : WriteDataChange (AuditStrings, 'DEBT2 wks o/due',     IntToStr(FBeforeSysSet.DebTrig[2]),     IntToStr(FAfterSysSet.DebTrig[2]));
          fldUpTo3              : WriteDataChange (AuditStrings, 'DEBT3 wks o/due',     IntToStr(FBeforeSysSet.DebTrig[3]),     IntToStr(FAfterSysSet.DebTrig[3]));

          //PR: 28/08/2013 MRD Changed Sort Code/Account Code fields to SEPA/IBAN
          fldBankName           : WriteDataChange (AuditStrings, 'Bank Name',           FBeforeSysSet.UserBank,                 FAfterSysSet.UserBank);
          fldBankAct            : WriteDataChange (AuditStrings, 'Bank A/C',            DecryptBankAccountCode(FBeforeSysSet.ssBankAccountCode),
                                                                                          DecryptBankAccountCode(FAfterSysSet.ssBankAccountCode));
          fldBankSortCode       : WriteDataChange (AuditStrings, 'Bank Sort Code',      DecryptBankSortCode(FBeforeSysSet.ssBankSortCode),
                                                                                          DecryptBankSortCode(FAfterSysSet.ssBankSortCode));
          fldBankRef            : WriteDataChange (AuditStrings, 'Bank Ref',            FBeforeSysSet.UserRef,                  FAfterSysSet.UserRef);

          fldTradeTermMssg      : WriteDataChange (AuditStrings, 'Def Trade Msg',       BoolToStr(FBeforeSysSet.TradeTerm, True),     BoolToStr(FAfterSysSet.TradeTerm, True));
          fldTTMsg1             : WriteDataChange (AuditStrings, 'Def Trade Msg1',      FBeforeSysSet.TermsofTrade[1],                FAfterSysSet.TermsofTrade[1]);
          fldTTMsg2             : WriteDataChange (AuditStrings, 'Def Trade Msg2',      FBeforeSysSet.TermsofTrade[2],                FAfterSysSet.TermsofTrade[2]);

          // System/GL/Currency Tab
                                                             //   12345678901234567890
          fldExtCustRec         : WriteDataChange (AuditStrings, 'Ext Cust Rec',        BoolToStr(FBeforeSysSet.ExternCust, True),    BoolToStr(FAfterSysSet.ExternCust,True));
          fldNumTradCode        : WriteDataChange (AuditStrings, 'Num Trader Codes',    BoolToStr(FBeforeSysSet.TradCodeNum, True),   BoolToStr(FAfterSysSet.TradCodeNum,True));
          fldExtSINGen          : WriteDataChange (AuditStrings, 'Ext SIN Gen',         BoolToStr(FBeforeSysSet.ExternSIN, True),     BoolToStr(FAfterSysSet.ExternSIN,True));

          fldUseDOSkeys         : WriteDataChange (AuditStrings, 'Use Exch DOS Keys',   BoolToStr(FBeforeSysSet.TxLateCr, True),      BoolToStr(FAfterSysSet.TxLateCr,True));
          fldHideExchLogo       : WriteDataChange (AuditStrings, 'Hide Exchequer Logo', BoolToStr(FBeforeSysSet.HideExLogo, True),    BoolToStr(FAfterSysSet.HideExLogo,True));

          // TG - 01-02-2017 -18119 : System Settings - Remove system switch 'Use Themes'
          //  fldUseThemes          : WriteDataChange (AuditStrings, 'Use Themes',          BoolToStr(FBeforeSysSet.UseBkTheme, True),    BoolToStr(FAfterSysSet.UseBkTheme,True));
          //  fldThemeType          : WriteDataChange (AuditStrings, 'Theme Type',          BeforeThemeType,                              AfterThemeType);

          fldConsMemory         : WriteDataChange (AuditStrings, 'Conserve Memory',     BoolToStr(FBeforeSysSet.ConsvMem, True),      BoolToStr(FAfterSysSet.ConsvMem, True));
          fldUsePasswords       : WriteDataChange (AuditStrings, 'Use Passwords',       BoolToStr(FBeforeSysSet.UsePassWords, True),  BoolToStr(FAfterSysSet.UsePassWords, True));

          fldHideUnauthOpt      : WriteDataChange (AuditStrings, 'Hide Unauth Opts',    BoolToStr(FBeforeSysSet.HideMenuOpt, True),   BoolToStr(FAfterSysSet.HideMenuOpt, True));
          fldDisablePost        : WriteDataChange (AuditStrings, 'Dsbl Post Prev Per',  BoolToStr(FBeforeSysSet.PrevPrOff, True),     BoolToStr(FAfterSysSet.PrevPrOff, True));
          fldSetPeriod          : WriteDataChange (AuditStrings, 'Set Period to Date',  BoolToStr(FBeforeSysSet.AutoPrCalc, True),    BoolToStr(FAfterSysSet.AutoPrCalc, True));

          fldUseCCandDept       : WriteDataChange (AuditStrings, 'Use CC & Depts',      BoolToStr(FBeforeSysSet.UseCCDep, True),      BoolToStr(FAfterSysSet.UseCCDep, True));
          fldCCandDept          : WriteDataChange (AuditStrings, 'Budget Option',       BeforeBUCCF,                                  AfterBUCCF);
          fldClearPayments      : WriteDataChange (AuditStrings, 'Clear Pay/Recpts',    BoolToStr(FBeforeSysSet.AutoClearPay, True),  BoolToStr(FAfterSysSet.AutoClearPay, True));

          fldSplitLineGL        : WriteDataChange (AuditStrings, 'Split Line Disc GL',  BoolToStr(FBeforeSysSet.SepDiscounts, True),  BoolToStr(FAfterSysSet.SepDiscounts, True));
          fldCurrConsMethod     : WriteDataChange (AuditStrings, 'Cur Cons Method',     BeforeCurConsMeth,                            AfterCurConsMeth);
          fldReturns            : WriteDataChange (AuditStrings, 'Returns',             BeforeReturns,                                AfterReturns);

          fldCurrVarTol         : WriteDataChange (AuditStrings, 'Alloc CurrVar Tol',   BeforeCurrVarTol,                              AfterCurrVarTol);
          fldTolerance          : WriteDataChange (AuditStrings, 'Tolerance',           BeforeTol,                                    AfterTol);
          fldEnforceGLCls       : WriteDataChange (AuditStrings, 'Enforce G/L Classes', BoolToStr(FBeforeSysSet.UseGLClass, True),    BoolToStr(FAfterSysSet.UseGLClass, True));

          // SL/PL Tab
                                                             //   12345678901234567890
          fldCreditLimitChk     : WriteDataChange (AuditStrings, 'Credit Limit Check',   BoolToStr(FBeforeSysSet.UseCRLimitChk, True), BoolToStr(FAfterSysSet.UseCRLimitChk, True));
          fldCreditStatChk      : WriteDataChange (AuditStrings, 'Credit Status Check',  BoolToStr(FBeforeSysSet.UseCreditChk, True),  BoolToStr(FAfterSysSet.UseCreditChk, True));
          fldPutOnStop          : WriteDataChange (AuditStrings, 'Ovr Crd Put On Stop',  BoolToStr(FBeforeSysSet.StopBadDr, True),     BoolToStr(FAfterSysSet.StopBadDr, True));

          fldOldestDebt         : WriteDataChange (AuditStrings, 'Calc Oldest Debt',     BoolToStr(FBeforeSysSet.LiveCredS, True),     BoolToStr(FAfterSysSet.LiveCredS, True));
          fldDisableSetle       : WriteDataChange (AuditStrings, 'Disable STL Discount', BoolToStr(FBeforeSysSet.NoHoldDisc, True),    BoolToStr(FAfterSysSet.NoHoldDisc, True));
          fldIncludeNotDue      : WriteDataChange (AuditStrings, 'Inc Not Due to STMT',  BoolToStr(FBeforeSysSet.IncNotDue, True),     BoolToStr(FAfterSysSet.IncNotDue, True));

          fldAddNotes           : WriteDataChange (AuditStrings, 'Add Notes to STMT',    BoolToStr(FBeforeSysSet.AutoNotes, True),     BoolToStr(FAfterSysSet.AutoNotes, True));
          fldAgeByInvDate       : WriteDataChange (AuditStrings, 'Age By Invoice Date',  BeforeAgeByInvoice,                           AfterAgeByInvoice);
          fldKeepSQUPQU         : WriteDataChange (AuditStrings, 'Keep SQU/PQU Date',    BoolToStr(FBeforeSysSet.QuoOwnDate, True),    BoolToStr(FAfterSysSet.QuoOwnDate, True));

          flgOurRefCount        : WriteDataChange (AuditStrings, 'SRI/PPI Our Ref Cnt',  BoolToStr(FBeforeSysSet.DirOwnCount, True),   BoolToStr(FAfterSysSet.DirOwnCount, True));
          flgWarnIfDup          : WriteDataChange (AuditStrings, 'Warn DUP Your Ref',    BoolToStr(FBeforeSysSet.WarnYRef, True),      BoolToStr(FAfterSysSet.WarnYRef, True));
          flgProtectYourRef     : WriteDataChange (AuditStrings, 'Protect Your Ref SPOP',  BoolToStr(FBeforeSysSet.ProtectYRef, True),   BoolToStr(FAfterSysSet.ProtectYRef, True));

          flgPromptSalesRec     : WriteDataChange (AuditStrings, 'Prompt Prnt S/Rcpts',  BoolToStr(FBeforeSysSet.PrintReciept, True),  BoolToStr(FAfterSysSet.PrintReciept, True));
          flgPayInRef           : WriteDataChange (AuditStrings, 'Use Pay-In Ref',       BoolToStr(FBeforeSysSet.UsePayIn, True),      BoolToStr(FAfterSysSet.UsePayIn, True));
          flgAutoCheqNum        : WriteDataChange (AuditStrings, 'Auto Cheque Nos',      BoolToStr(FBeforeSysSet.AutoCQNo, True),      BoolToStr(FAfterSysSet.AutoCQNo, True));

          flgStopManEntry       : WriteDataChange (AuditStrings, 'Stop Man entry PPY',   BoolToStr(FBeforeSysSet.BatchPPY, True),      BoolToStr(FAfterSysSet.BatchPPY, True));
          flgForceBatchTot      : WriteDataChange (AuditStrings, 'Force batch totals',   BoolToStr(FBeforeSysSet.UseBatchTot, True),   BoolToStr(FAfterSysSet.UseBatchTot, True));
          flgUpdateTradBal      : WriteDataChange (AuditStrings, 'Upd Trader balances',  BoolToStr(FBeforeSysSet.UpBalOnPost, True),   BoolToStr(FAfterSysSet.UpBalOnPost, True));

          flgDefDiscount        : WriteDataChange (AuditStrings, 'Def to % discounts',   BoolToStr(FBeforeSysSet.DefPCDisc, True),     BoolToStr(FAfterSysSet.DefPCDisc, True));
          flgAuthMethod         : WriteDataChange (AuditStrings, 'Authorisation Method', BeforeAuthMeth,                               AfterAuthMeth);
          flgDecCostPrice       : WriteDataChange (AuditStrings, 'DP on Cost Price',     formatfloat('###,###,##0 ;###,###,##0-',FBeforeSysSet.NoCosDec),     formatfloat('###,###,##0 ;###,###,##0-',FAfterSysSet.NoCosDec));

          flgDecSalePrice       : WriteDataChange (AuditStrings, 'DP on Sales Price',    formatfloat('###,###,##0 ;###,###,##0-',FBeforeSysSet.NoNetDec),     formatfloat('###,###,##0 ;###,###,##0-',FAfterSysSet.NoNetDec));
          flgDecQty             : WriteDataChange (AuditStrings, 'DP on Qty',            formatfloat('###,###,##0 ;###,###,##0-',FBeforeSysSet.NoQtyDec),     formatfloat('###,###,##0 ;###,###,##0-',FAfterSysSet.NoQtyDec));

          // Stock/SPOP Tab
                                                             //   12345678901234567890
          flgDefStockValMethod  : WriteDataChange (AuditStrings, 'Def Stock Value Meth', BeforeStockValueMeth,                         AfterStockValueMeth);
          flgMultiLoc           : WriteDataChange (AuditStrings, 'Multi Location',       BeforeMultiLoc,                               AfterMultiLoc);
          flgLiveSalesVal       : WriteDataChange (AuditStrings, 'Live Stock/Cost Val',  BoolToStr(FBeforeSysSet.AutoValStk, True),    BoolToStr(FAfterSysSet.AutoValStk, True));

          flgDispInsufStock     : WriteDataChange (AuditStrings, 'Insuf Stock warning',  BoolToStr(FBeforeSysSet.UseStock, True),      BoolToStr(FAfterSysSet.UseStock, True));
          flgUseECFields        : WriteDataChange (AuditStrings, 'EC SSD/Intr fields',   BoolToStr(FBeforeSysSet.IntraStat, True),     BoolToStr(FAfterSysSet.IntraStat, True));
          flgUpdBuildCosts      : WriteDataChange (AuditStrings, 'Update Build Costs',   BoolToStr(FBeforeSysSet.AutoBillUp, True),    BoolToStr(FAfterSysSet.AutoBillUp, True));

          flgDescOnly           : WriteDataChange (AuditStrings, 'Analyse Desc Only',    BoolToStr(FBeforeSysSet.AnalStkDesc, True),   BoolToStr(FAfterSysSet.AnalStkDesc, True));
          flgSetBOMOnSales      : WriteDataChange (AuditStrings, 'Set BOM on Sales',     BoolToStr(FBeforeSysSet.EditSinSer, True),    BoolToStr(FAfterSysSet.EditSinSer, True));
          flgDeductCompNoBOM    : WriteDataChange (AuditStrings, 'Deduct BOMs Stock',    BoolToStr(FBeforeSysSet.DeadBOM, True),       BoolToStr(FAfterSysSet.DeadBOM, True));

          flgQuotesAllocStock   : WriteDataChange (AuditStrings, 'SQU/PQU to Alloc',     BoolToStr(FBeforeSysSet.QuAllocFlg, True),    BoolToStr(FAfterSysSet.QuAllocFlg, True));
          flgFreeStockExStock   : WriteDataChange (AuditStrings, 'Free Stock Exc S/O',   BoolToStr(FBeforeSysSet.FreeExAll, True),     BoolToStr(FAfterSysSet.FreeExAll, True));
          flgOrderToAlloc       : WriteDataChange (AuditStrings, 'Alloc stock picked',   BoolToStr(FBeforeSysSet.UsePick4All, True),   BoolToStr(FAfterSysSet.UsePick4All, True));

          flgSDNShowPickedItems : WriteDataChange (AuditStrings, 'Show SDN Pickd itms',  BoolToStr(FBeforeSysSet.DelPickOnly, True),   BoolToStr(FAfterSysSet.DelPickOnly, True));
          flgUsePackQtyOnTrans  : WriteDataChange (AuditStrings, 'Use Pack Qty',         BoolToStr(FBeforeSysSet.InpPack, True),       BoolToStr(FAfterSysSet.InpPack, True));
          flgSDNDateIsTaxPoint  : WriteDataChange (AuditStrings, 'SDN Date = Tax Date',  BoolToStr(FBeforeSysSet.SDNOwnDate, True),    BoolToStr(FAfterSysSet.SDNOwnDate, True));

          flgShowPriceBands     : WriteDataChange (AuditStrings, 'Show price bands',     BoolToStr(FBeforeSysSet.ShowStkGP, True),     BoolToStr(FAfterSysSet.ShowStkGP, True));
          flgManUpdateReOrder   : WriteDataChange (AuditStrings, 'Upd Re-Order Cost',    BoolToStr(FBeforeSysSet.ManROCP, True),       BoolToStr(FAfterSysSet.ManROCP, True));
          flgAutoPostUplift     : WriteDataChange (AuditStrings, 'Auto Post Uplift',     BoolToStr(FBeforeSysSet.UseUpliftNC, True),   BoolToStr(FAfterSysSet.UseUpliftNC, True));

          flgRetainBinHistory   : WriteDataChange (AuditStrings, 'Retain Bin History',   BoolToStr(FBeforeSysSet.KeepBinHist, True),   BoolToStr(FAfterSysSet.KeepBinHist, True));
          flgFilterPickList     : WriteDataChange (AuditStrings, 'Filter Ser/Batch/Bin', BoolToStr(FBeforeSysSet.FiltSNoBinLoc, True), BoolToStr(FAfterSysSet.FiltSNoBinLoc, True));
          flgBinCodeMask        : WriteDataChange (AuditStrings, 'Bin Code Mask',        FBeforeSysSet.BinMask,                        FAfterSysSet.BinMask);

          flgUseTransTotDisc    : WriteDataChange (AuditStrings, 'Use Trans Discounts', BoolToStr(FBeforeSysSet.EnableTTDDiscounts, True),      BoolToStr(FAfterSysSet.EnableTTDDiscounts, True));
          flgUseValueBasedDisc  : WriteDataChange (AuditStrings, 'Use Value Discounts', BoolToStr(FBeforeSysSet.EnableVBDDiscounts, True),      BoolToStr(FAfterSysSet.EnableVBDDiscounts, True));
          flgUseOverrideLoc     : WriteDataChange (AuditStrings, 'Override Loc on Purc', BoolToStr(FBeforeSysSet.EnableOverrideLocations, True), BoolToStr(FAfterSysSet.EnableOverrideLocations, True));

          flgIncludeVATInBal    : WriteDataChange (AuditStrings, 'Inc VAT in Balances', BoolToStr(FBeforeSysSet.IncludeVATInCommittedBalance, True), BoolToStr(FAfterSysSet.IncludeVATInCommittedBalance, True));

          // Job Costing Tab
                                                             //   12345678901234567890
          flgWarnOverBudget     : WriteDataChange (AuditStrings, 'Warn over budget',    BoolToStr(FBeforeSysSet.WarnJC, True),        BoolToStr(FAfterSysSet.WarnJC, True));
          flgProtectApplication : WriteDataChange (AuditStrings, 'Protect App Your Ref',BoolToStr(FBeforeSysSet.ProtectYRef, True),   BoolToStr(FAfterSysSet.ProtectYRef, True));

          // WOP Tab
                                                                //   12345678901234567890
          flgOrderAllocStockPick   : WriteDataChange (AuditStrings, 'Alloc Stock Picked',   BoolToStr(FBeforeSysSet.UseWIss4All, True),   BoolToStr(FAfterSysSet.UseWIss4All, True));
          flgDisableWorkInProgress : WriteDataChange (AuditStrings, 'Disable WIP',          BoolToStr(FBeforeSysSet.UseSTDWOP, True),     BoolToStr(FAfterSysSet.UseSTDWOP, True));
          flgCopyingStockNotesToWO : WriteDataChange (AuditStrings, 'Copying Stock to W/O', BeforeCopyStkToWO,                            AfterCopyStkToWO);

          // Missing Field
          flgCompanyName           : WriteDataChange (AuditStrings, 'Company Name',         FBeforeSysSet.UserName,                       FAfterSysSet.UserName);

          // MH 05/09/2013 v7.XMRD MRD1.1.10: Added Consumer Support
          flgConsumersEnabled      : WriteDataChange (AuditStrings, 'Enable Consumers',     BoolToStr(FBeforeSysSet.ssConsumersEnabled, True), BoolToStr(FAfterSysSet.ssConsumersEnabled, True));

          // MH 21/07/2014: Added support for Order Payments flag
          fldEnableOrderPayments   : WriteDataChange (AuditStrings, 'Enable Order Paymnts', BoolToStr(FBeforeSysSet.ssEnableOrderPayments, True), BoolToStr(FAfterSysSet.ssEnableOrderPayments, True));
        End; // Case I
      End; // If FChangedData[I]
    End; // For I
  End; // If (Destination = adAuditTrail)

End; // WriteAuditData

//=========================================================================


End.
                                  
