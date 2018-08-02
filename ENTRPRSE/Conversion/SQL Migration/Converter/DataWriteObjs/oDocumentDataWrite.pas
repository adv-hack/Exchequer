Unit oDocumentDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TDocumentDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    FTableName: string;
    thRunNoParam, thAcCodeParam, thNomAutoParam, thOurRefParam, thFolioNumParam, 
    thCurrencyParam, thYearParam, thPeriodParam, thDueDateParam, thVATPostDateParam, 
    thTransDateParam, thCustSuppParam, thCompanyRateParam, thDailyRateParam, 
    thOldYourRefParam, thBatchLinkParam, thOutstandingParam, thNextLineNumberParam, 
    thNextNotesLineNumberParam, thDocTypeParam, thVATAnalysisStandardParam, 
    thVATAnalysisExemptParam, thVATAnalysisZeroParam, thVATAnalysisRate1Param, 
    thVATAnalysisRate2Param, thVATAnalysisRate3Param, thVATAnalysisRate4Param, 
    thVATAnalysisRate5Param, thVATAnalysisRate6Param, thVATAnalysisRate7Param, 
    thVATAnalysisRate8Param, thVATAnalysisRate9Param, thVATAnalysisRateTParam, 
    thVATAnalysisRateXParam, thVATAnalysisRateBParam, thVATAnalysisRateCParam, 
    thVATAnalysisRateFParam, thVATAnalysisRateGParam, thVATAnalysisRateRParam, 
    thVATAnalysisRateWParam, thVATAnalysisRateYParam, thVATAnalysisRateIAdjParam, 
    thVATAnalysisRateOAdjParam, thVATAnalysisRateSpareParam, thNetValueParam,
    thTotalVATParam, thSettleDiscPercParam, thSettleDiscAmountParam, thTotalLineDiscountParam, 
    thSettleDiscDaysParam, thSettleDiscTakenParam, thAmountSettledParam, 
    thAutoIncrementParam, thUntilYearParam, thUntilPeriodParam, thTransportNatureParam, 
    thTransportModeParam, thRemitNoParam, thAutoIncrementTypeParam, thHoldFlagParam, 
    thAuditFlagParam, thTotalWeightParam, thDeliveryAddr1Param, thDeliveryAddr2Param, 
    thDeliveryAddr3Param, thDeliveryAddr4Param, thDeliveryAddr5Param, thVarianceParam, 
    thTotalOrderedParam, thTotalReservedParam, thTotalCostParam, thTotalInvoicedParam, 
    thLongYourRefParam, thUntilDateParam, thNOMVATIOParam, thExternalParam, 
    thPrintedParam, thRevalueAdjParam, thCurrSettledParam, thSettledVATParam, 
    thVATClaimedParam, thBatchGLParam, thAutoPostParam, thManualVATParam, 
    thDeliveryTermsParam, thIncludeInPickingRunParam, thOperatorParam, 
    thNoLabelsParam, thTaggedParam, thPickingRunNoParam, thOrdMatchParam, 
    thDeliveryNoteRefParam, thVATCompanyRateParam, thVATDailyRateParam, 
    thOriginalCompanyRateParam, thOriginalDailyRateParam, PostDiscAmParam, 
    thSpareNomCodeParam, thPostDiscTakenParam, thControlGLParam, thJobCodeParam,
    thAnalysisCodeParam, thTotalOrderOSParam, thAppDepartmentParam, thAppCostCentreParam, 
    thUserField1Param, thUserField2Param, thLineTypeAnalysis1Param, thLineTypeAnalysis2Param, 
    thLineTypeAnalysis3Param, thLineTypeAnalysis4Param, thLineTypeAnalysis5Param, 
    thLineTypeAnalysis6Param, thLastDebtChaseLetterParam, thBatchNowParam,
    thBatchThenParam, thUnTaggedParam, thOriginalBaseValueParam, thUseOriginalRatesParam,
    thOldCompanyRateParam, thOldDailyRateParam, thFixedRateParam, thUserField3Param,
    thUserField4Param, thProcessParam, thSourceParam, thCurrencyTriRateParam,
    thCurrencyTriEuroParam, thCurrencyTriInvertParam, thCurrencyTriFloatParam,
    thCurrencyTriSpareParam, thVATTriRateParam, thVATTriEuroParam, thVATTriInvertParam,
    thVATTriFloatParam, thVATTriSpareParam, thOriginalTriRateParam, thOriginalTriEuroParam,
    thOriginalTriInvertParam, thOriginalTriFloatParam, thOriginalTriSpareParam,
    thOldOriginalTriRateParam, thOldOriginalTriEuroParam, thOldOriginalTriInvertParam,
    thOldOriginalTriFloatParam, thOldOriginalTriSpareParam, thPostedDateParam,
    thPORPickSORParam, thBatchDiscAmountParam, thPrePostParam, thAuthorisedAmntParam,
    thTimeChangedParam, thTimeCreatedParam, thCISTaxDueParam, thCISTaxDeclaredParam,
    thCISManualTaxParam, thCISDateParam, thTotalCostApportionedParam, thCISEmployeeParam,
    thCISTotalGrossParam, thCISSourceParam, thTimesheetExportedParam, thCISExcludedFromGrossParam,
    thWeekMonthParam, thWorkflowStateParam, thOverrideLocationParam, thSpare5Param,
    thYourRefParam, thUserField5Param, thUserField6Param, thUserField7Param,
    thUserField8Param, thUserField9Param, thUserField10Param : TParameter;
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    thDeliveryPostCodeParam : TParameter;
    // MH 16/10/2013 v7.0.7 ABSEXCH-14705: Added support for new Transaction Originator fields
    thOriginatorParam, thCreationTimeParam, thCreationDateParam : TParameter;
    // MH 24/10/2014: Added support for new Order Payments fields
    thOrderPaymentOrderRefParam, thOrderPaymentElementParam, thOrderPaymentFlagsParam,
    thCreditCardTypeParam, thCreditCardNumberParam, thCreditCardExpiryParam,
    thCreditCardAuthorisationNoParam, thCreditCardReferenceNoParam, thCustomData1Param : TParameter;
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    thDeliveryCountryParam : TParameter;
    // MH 25/02/2015 v7.0.14 ABSEXCH-16284: Added support for Prompt Payment Discount fields
    thPPDPercentageParam, thPPDDaysParam, thPPDGoodsValueParam, thPPDVATValueParam, thPPDTakenParam : TParameter;
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    thPPDCreditNoteParam, thBatchPayPPDStatusParam,
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    thIntrastatOutOfPeriodParam,
    // CJS 2016-04-27 - Add support for new Tax fields
    thUserField11Param,
    thUserField12Param,
    thTaxRegionParam: TParameter;
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    thAnonymisedParam, thAnonymisedDateParam, thAnonymisedTimeParam : TParameter;
  Public
    Constructor Create(ForEBusiness: Boolean = False);
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TDocumentDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst;

//=========================================================================

Constructor TDocumentDataWrite.Create(ForEBusiness: Boolean);
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  if ForEBusiness then
    FTableName := 'EBUSDOC'
  else
    FTableName := 'DOCUMENT';
End; // Create

//------------------------------

Destructor TDocumentDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TDocumentDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
  sqlQuery := 'INSERT INTO [COMPANY].' + FTableName + ' (' +
                                               'thRunNo, ' +
                                               'thAcCode, ' +
                                               'thNomAuto, ' +
                                               'thOurRef, ' +
                                               'thFolioNum, ' +
                                               'thCurrency, ' +
                                               'thYear, ' +
                                               'thPeriod, ' +
                                               'thDueDate, ' +
                                               'thVATPostDate, ' +
                                               'thTransDate, ' +
                                               'thCustSupp, ' +
                                               'thCompanyRate, ' +
                                               'thDailyRate, ' +
                                               'thOldYourRef, ' +
                                               'thBatchLink, ' +
                                               'thOutstanding, ' +
                                               'thNextLineNumber, ' +
                                               'thNextNotesLineNumber, ' +
                                               'thDocType, ' +
                                               'thVATAnalysisStandard, ' +
                                               'thVATAnalysisExempt, ' +
                                               'thVATAnalysisZero, ' + 
                                               'thVATAnalysisRate1, ' + 
                                               'thVATAnalysisRate2, ' + 
                                               'thVATAnalysisRate3, ' + 
                                               'thVATAnalysisRate4, ' +
                                               'thVATAnalysisRate5, ' + 
                                               'thVATAnalysisRate6, ' + 
                                               'thVATAnalysisRate7, ' + 
                                               'thVATAnalysisRate8, ' + 
                                               'thVATAnalysisRate9, ' + 
                                               'thVATAnalysisRateT, ' + 
                                               'thVATAnalysisRateX, ' +
                                               'thVATAnalysisRateB, ' + 
                                               'thVATAnalysisRateC, ' + 
                                               'thVATAnalysisRateF, ' + 
                                               'thVATAnalysisRateG, ' + 
                                               'thVATAnalysisRateR, ' + 
                                               'thVATAnalysisRateW, ' +
                                               'thVATAnalysisRateY, ' +
                                               'thVATAnalysisRateIAdj, ' +
                                               'thVATAnalysisRateOAdj, ' + 
                                               'thVATAnalysisRateSpare, ' + 
                                               'thNetValue, ' + 
                                               'thTotalVAT, ' +
                                               'thSettleDiscPerc, ' +
                                               'thSettleDiscAmount, ' + 
                                               'thTotalLineDiscount, ' + 
                                               'thSettleDiscDays, ' + 
                                               'thSettleDiscTaken, ' +
                                               'thAmountSettled, ' + 
                                               'thAutoIncrement, ' + 
                                               'thUntilYear, ' + 
                                               'thUntilPeriod, ' + 
                                               'thTransportNature, ' + 
                                               'thTransportMode, ' +
                                               'thRemitNo, ' + 
                                               'thAutoIncrementType, ' + 
                                               'thHoldFlag, ' + 
                                               'thAuditFlag, ' + 
                                               'thTotalWeight, ' +
                                               'thDeliveryAddr1, ' + 
                                               'thDeliveryAddr2, ' + 
                                               'thDeliveryAddr3, ' + 
                                               'thDeliveryAddr4, ' + 
                                               'thDeliveryAddr5, ' +
                                               'thVariance, ' + 
                                               'thTotalOrdered, ' + 
                                               'thTotalReserved, ' + 
                                               'thTotalCost, ' + 
                                               'thTotalInvoiced, ' +
                                               'thLongYourRef, ' + 
                                               'thUntilDate, ' + 
                                               'thNOMVATIO, ' + 
                                               'thExternal, ' + 
                                               'thPrinted, ' + 
                                               'thRevalueAdj, ' + 
                                               'thCurrSettled, ' + 
                                               'thSettledVAT, ' + 
                                               'thVATClaimed, ' + 
                                               'thBatchGL, ' + 
                                               'thAutoPost, ' + 
                                               'thManualVAT, ' + 
                                               'thDeliveryTerms, ' + 
                                               'thIncludeInPickingRun, ' +
                                               'thOperator, ' +
                                               'thNoLabels, ' + 
                                               'thTagged, ' + 
                                               'thPickingRunNo, ' +
                                               'thOrdMatch, ' + 
                                               'thDeliveryNoteRef, ' +
                                               'thVATCompanyRate, ' +
                                               'thVATDailyRate, ' + 
                                               'thOriginalCompanyRate, ' + 
                                               'thOriginalDailyRate, ' + 
                                               'PostDiscAm, ' +
                                               'thSpareNomCode, ' + 
                                               'thPostDiscTaken, ' + 
                                               'thControlGL, ' + 
                                               'thJobCode, ' + 
                                               'thAnalysisCode, ' +
                                               'thTotalOrderOS, ' +
                                               'thAppDepartment, ' + 
                                               'thAppCostCentre, ' + 
                                               'thUserField1, ' + 
                                               'thUserField2, ' +
                                               'thLineTypeAnalysis1, ' + 
                                               'thLineTypeAnalysis2, ' + 
                                               'thLineTypeAnalysis3, ' + 
                                               'thLineTypeAnalysis4, ' + 
                                               'thLineTypeAnalysis5, ' +
                                               'thLineTypeAnalysis6, ' + 
                                               'thLastDebtChaseLetter, ' + 
                                               'thBatchNow, ' + 
                                               'thBatchThen, ' + 
                                               'thUnTagged, ' + 
                                               'thOriginalBaseValue, ' +
                                               'thUseOriginalRates, ' + 
                                               'thOldCompanyRate, ' + 
                                               'thOldDailyRate, ' + 
                                               'thFixedRate, ' + 
                                               'thUserField3, ' + 
                                               'thUserField4, ' + 
                                               'thProcess, ' + 
                                               'thSource, ' + 
                                               'thCurrencyTriRate, ' + 
                                               'thCurrencyTriEuro, ' + 
                                               'thCurrencyTriInvert, ' + 
                                               'thCurrencyTriFloat, ' + 
                                               'thCurrencyTriSpare, ' + 
                                               'thVATTriRate, ' +
                                               'thVATTriEuro, ' +
                                               'thVATTriInvert, ' + 
                                               'thVATTriFloat, ' + 
                                               'thVATTriSpare, ' + 
                                               'thOriginalTriRate, ' + 
                                               'thOriginalTriEuro, ' +
                                               'thOriginalTriInvert, ' +
                                               'thOriginalTriFloat, ' + 
                                               'thOriginalTriSpare, ' + 
                                               'thOldOriginalTriRate, ' +
                                               'thOldOriginalTriEuro, ' +
                                               'thOldOriginalTriInvert, ' + 
                                               'thOldOriginalTriFloat, ' + 
                                               'thOldOriginalTriSpare, ' +
                                               'thPostedDate, ' +
                                               'thPORPickSOR, ' + 
                                               'thBatchDiscAmount, ' +
                                               'thPrePost, ' + 
                                               'thAuthorisedAmnt, ' + 
                                               'thTimeChanged, ' +
                                               'thTimeCreated, ' + 
                                               'thCISTaxDue, ' + 
                                               'thCISTaxDeclared, ' + 
                                               'thCISManualTax, ' +
                                               'thCISDate, ' + 
                                               'thTotalCostApportioned, ' + 
                                               'thCISEmployee, ' + 
                                               'thCISTotalGross, ' + 
                                               'thCISSource, ' + 
                                               'thTimesheetExported, ' + 
                                               'thCISExcludedFromGross, ' + 
                                               'thWeekMonth, ' + 
                                               'thWorkflowState, ' + 
                                               'thOverrideLocation, ' + 
                                               'thSpare5, ' +
                                               'thYourRef, ' + 
                                               'thUserField5, ' + 
                                               'thUserField6, ' + 
                                               'thUserField7, ' + 
                                               'thUserField8, ' + 
                                               'thUserField9, ' +
                                               'thUserField10, ' +
                                               // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
                                               'thDeliveryPostCode, ' +
                                               // MH 16/10/2013 v7.0.7 ABSEXCH-14705: Added support for new Transaction Originator fields
                                               'thOriginator, ' +
                                               'thCreationTime, ' +
                                               'thCreationDate, ' +
                                               // MH 24/10/2014: Added support for new Order Payments fields
                                               'thOrderPaymentOrderRef, ' +
                                               'thOrderPaymentElement, ' +
                                               'thOrderPaymentFlags, ' +
                                               'thCreditCardType, ' +
                                               'thCreditCardNumber, ' +
                                               'thCreditCardExpiry, ' +
                                               'thCreditCardAuthorisationNo, ' +
                                               'thCreditCardReferenceNo, ' +
                                               'thCustomData1, ' +
                                               // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
                                               'thDeliveryCountry, ' +
                                               // MH 25/02/2015 v7.0.14 ABSEXCH-16284: Added support for Prompt Payment Discount fields
                                               'thPPDPercentage, ' +
                                               'thPPDDays, ' +
                                               'thPPDGoodsValue, ' +
                                               'thPPDVATValue, ' +
                                               'thPPDTaken, ' +
                                               'thPPDCreditNote, ' +
                                               'thBatchPayPPDStatus, ' +
                                               // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                                               'thIntrastatOutOfPeriod, ' +
                                               // CJS 2016-04-27 - Add support for new Tax fields
                                               'thUserField11, ' +
                                               'thUserField12, ' +
                                               'thTaxRegion, ' +
                                               // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                                               'thAnonymised, ' +
                                               'thAnonymisedDate, ' +
                                               'thAnonymisedTime' +
                                               ') ' +
              'VALUES (' +
                       ':thRunNo, ' +
                       ':thAcCode, ' +
                       ':thNomAuto, ' +
                       ':thOurRef, ' +
                       ':thFolioNum, ' +
                       ':thCurrency, ' +
                       ':thYear, ' +
                       ':thPeriod, ' +
                       ':thDueDate, ' +
                       ':thVATPostDate, ' +
                       ':thTransDate, ' +
                       ':thCustSupp, ' +
                       ':thCompanyRate, ' +
                       ':thDailyRate, ' +
                       ':thOldYourRef, ' +
                       ':thBatchLink, ' +
                       ':thOutstanding, ' +
                       ':thNextLineNumber, ' +
                       ':thNextNotesLineNumber, ' +
                       ':thDocType, ' +
                       ':thVATAnalysisStandard, ' +
                       ':thVATAnalysisExempt, ' +
                       ':thVATAnalysisZero, ' +
                       ':thVATAnalysisRate1, ' +
                       ':thVATAnalysisRate2, ' +
                       ':thVATAnalysisRate3, ' +
                       ':thVATAnalysisRate4, ' +
                       ':thVATAnalysisRate5, ' +
                       ':thVATAnalysisRate6, ' +
                       ':thVATAnalysisRate7, ' +
                       ':thVATAnalysisRate8, ' + 
                       ':thVATAnalysisRate9, ' + 
                       ':thVATAnalysisRateT, ' +
                       ':thVATAnalysisRateX, ' + 
                       ':thVATAnalysisRateB, ' + 
                       ':thVATAnalysisRateC, ' + 
                       ':thVATAnalysisRateF, ' +
                       ':thVATAnalysisRateG, ' +
                       ':thVATAnalysisRateR, ' +
                       ':thVATAnalysisRateW, ' + 
                       ':thVATAnalysisRateY, ' + 
                       ':thVATAnalysisRateIAdj, ' + 
                       ':thVATAnalysisRateOAdj, ' + 
                       ':thVATAnalysisRateSpare, ' +
                       ':thNetValue, ' +
                       ':thTotalVAT, ' + 
                       ':thSettleDiscPerc, ' + 
                       ':thSettleDiscAmount, ' + 
                       ':thTotalLineDiscount, ' + 
                       ':thSettleDiscDays, ' + 
                       ':thSettleDiscTaken, ' + 
                       ':thAmountSettled, ' + 
                       ':thAutoIncrement, ' +
                       ':thUntilYear, ' +
                       ':thUntilPeriod, ' + 
                       ':thTransportNature, ' +
                       ':thTransportMode, ' + 
                       ':thRemitNo, ' + 
                       ':thAutoIncrementType, ' + 
                       ':thHoldFlag, ' + 
                       ':thAuditFlag, ' + 
                       ':thTotalWeight, ' + 
                       ':thDeliveryAddr1, ' + 
                       ':thDeliveryAddr2, ' + 
                       ':thDeliveryAddr3, ' + 
                       ':thDeliveryAddr4, ' + 
                       ':thDeliveryAddr5, ' + 
                       ':thVariance, ' + 
                       ':thTotalOrdered, ' + 
                       ':thTotalReserved, ' + 
                       ':thTotalCost, ' + 
                       ':thTotalInvoiced, ' + 
                       ':thLongYourRef, ' + 
                       ':thUntilDate, ' +
                       ':thNOMVATIO, ' + 
                       ':thExternal, ' + 
                       ':thPrinted, ' +
                       ':thRevalueAdj, ' +
                       ':thCurrSettled, ' + 
                       ':thSettledVAT, ' + 
                       ':thVATClaimed, ' +
                       ':thBatchGL, ' + 
                       ':thAutoPost, ' + 
                       ':thManualVAT, ' +
                       ':thDeliveryTerms, ' +
                       ':thIncludeInPickingRun, ' + 
                       ':thOperator, ' + 
                       ':thNoLabels, ' + 
                       ':thTagged, ' + 
                       ':thPickingRunNo, ' +
                       ':thOrdMatch, ' +
                       ':thDeliveryNoteRef, ' +
                       ':thVATCompanyRate, ' + 
                       ':thVATDailyRate, ' + 
                       ':thOriginalCompanyRate, ' + 
                       ':thOriginalDailyRate, ' +
                       ':PostDiscAm, ' + 
                       ':thSpareNomCode, ' + 
                       ':thPostDiscTaken, ' +
                       ':thControlGL, ' + 
                       ':thJobCode, ' + 
                       ':thAnalysisCode, ' + 
                       ':thTotalOrderOS, ' + 
                       ':thAppDepartment, ' + 
                       ':thAppCostCentre, ' + 
                       ':thUserField1, ' + 
                       ':thUserField2, ' + 
                       ':thLineTypeAnalysis1, ' +
                       ':thLineTypeAnalysis2, ' + 
                       ':thLineTypeAnalysis3, ' + 
                       ':thLineTypeAnalysis4, ' + 
                       ':thLineTypeAnalysis5, ' +
                       ':thLineTypeAnalysis6, ' + 
                       ':thLastDebtChaseLetter, ' + 
                       ':thBatchNow, ' + 
                       ':thBatchThen, ' + 
                       ':thUnTagged, ' +
                       ':thOriginalBaseValue, ' +
                       ':thUseOriginalRates, ' + 
                       ':thOldCompanyRate, ' +
                       ':thOldDailyRate, ' + 
                       ':thFixedRate, ' + 
                       ':thUserField3, ' + 
                       ':thUserField4, ' + 
                       ':thProcess, ' + 
                       ':thSource, ' + 
                       ':thCurrencyTriRate, ' + 
                       ':thCurrencyTriEuro, ' + 
                       ':thCurrencyTriInvert, ' + 
                       ':thCurrencyTriFloat, ' + 
                       ':thCurrencyTriSpare, ' +
                       ':thVATTriRate, ' + 
                       ':thVATTriEuro, ' + 
                       ':thVATTriInvert, ' + 
                       ':thVATTriFloat, ' +
                       ':thVATTriSpare, ' +
                       ':thOriginalTriRate, ' +
                       ':thOriginalTriEuro, ' + 
                       ':thOriginalTriInvert, ' + 
                       ':thOriginalTriFloat, ' +
                       ':thOriginalTriSpare, ' + 
                       ':thOldOriginalTriRate, ' + 
                       ':thOldOriginalTriEuro, ' + 
                       ':thOldOriginalTriInvert, ' + 
                       ':thOldOriginalTriFloat, ' +
                       ':thOldOriginalTriSpare, ' + 
                       ':thPostedDate, ' + 
                       ':thPORPickSOR, ' + 
                       ':thBatchDiscAmount, ' + 
                       ':thPrePost, ' + 
                       ':thAuthorisedAmnt, ' +
                       ':thTimeChanged, ' + 
                       ':thTimeCreated, ' + 
                       ':thCISTaxDue, ' + 
                       ':thCISTaxDeclared, ' + 
                       ':thCISManualTax, ' + 
                       ':thCISDate, ' +
                       ':thTotalCostApportioned, ' +
                       ':thCISEmployee, ' + 
                       ':thCISTotalGross, ' + 
                       ':thCISSource, ' + 
                       ':thTimesheetExported, ' +
                       ':thCISExcludedFromGross, ' + 
                       ':thWeekMonth, ' + 
                       ':thWorkflowState, ' + 
                       ':thOverrideLocation, ' +
                       ':thSpare5, ' + 
                       ':thYourRef, ' +
                       ':thUserField5, ' +
                       ':thUserField6, ' +
                       ':thUserField7, ' +
                       ':thUserField8, ' +
                       ':thUserField9, ' +
                       ':thUserField10, ' +
                       // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
                       ':thDeliveryPostCode, ' +
                       // MH 16/10/2013 v7.0.7 ABSEXCH-14705: Added support for new Transaction Originator fields
                       ':thOriginator, ' +
                       ':thCreationTime, ' +
                       ':thCreationDate, ' +
                       // MH 24/10/2014: Added support for new Order Payments fields
                       ':thOrderPaymentOrderRef, ' +
                       ':thOrderPaymentElement, ' +
                       ':thOrderPaymentFlags, ' +
                       ':thCreditCardType, ' +
                       ':thCreditCardNumber, ' +
                       ':thCreditCardExpiry, ' +
                       ':thCreditCardAuthorisationNo, ' +
                       ':thCreditCardReferenceNo, ' +
                       ':thCustomData1, ' +
                       // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
                       ':thDeliveryCountry, ' +
                       // MH 25/02/2015 v7.0.14 ABSEXCH-16284: Added support for Prompt Payment Discount fields
                       ':thPPDPercentage, ' +
                       ':thPPDDays, ' +
                       ':thPPDGoodsValue, ' +
                       ':thPPDVATValue, ' +
                       ':thPPDTaken, ' +
                       ':thPPDCreditNote, ' +
                       ':thBatchPayPPDStatus, ' +
                       // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                       ':thIntrastatOutOfPeriod, ' +
                       // CJS 2016-04-27 - Add support for new Tax fields
                       ':thUserField11, ' +
                       ':thUserField12, ' +
                       ':thTaxRegion, ' +
                       // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                       ':thAnonymised, ' +
                       ':thAnonymisedDate, ' +
                       ':thAnonymisedTime' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    thRunNoParam := FindParam('thRunNo');
    thAcCodeParam := FindParam('thAcCode');
    thNomAutoParam := FindParam('thNomAuto');
    thOurRefParam := FindParam('thOurRef');
    thFolioNumParam := FindParam('thFolioNum');
    thCurrencyParam := FindParam('thCurrency');
    thYearParam := FindParam('thYear');
    thPeriodParam := FindParam('thPeriod');
    thDueDateParam := FindParam('thDueDate');
    thVATPostDateParam := FindParam('thVATPostDate');
    thTransDateParam := FindParam('thTransDate');
    thCustSuppParam := FindParam('thCustSupp');
    thCompanyRateParam := FindParam('thCompanyRate');
    thDailyRateParam := FindParam('thDailyRate');
    thOldYourRefParam := FindParam('thOldYourRef');
    thBatchLinkParam := FindParam('thBatchLink');
    thOutstandingParam := FindParam('thOutstanding');
    thNextLineNumberParam := FindParam('thNextLineNumber');
    thNextNotesLineNumberParam := FindParam('thNextNotesLineNumber');
    thDocTypeParam := FindParam('thDocType');
    thVATAnalysisStandardParam := FindParam('thVATAnalysisStandard');
    thVATAnalysisExemptParam := FindParam('thVATAnalysisExempt');
    thVATAnalysisZeroParam := FindParam('thVATAnalysisZero');
    thVATAnalysisRate1Param := FindParam('thVATAnalysisRate1');
    thVATAnalysisRate2Param := FindParam('thVATAnalysisRate2');
    thVATAnalysisRate3Param := FindParam('thVATAnalysisRate3');
    thVATAnalysisRate4Param := FindParam('thVATAnalysisRate4');
    thVATAnalysisRate5Param := FindParam('thVATAnalysisRate5');
    thVATAnalysisRate6Param := FindParam('thVATAnalysisRate6');
    thVATAnalysisRate7Param := FindParam('thVATAnalysisRate7');
    thVATAnalysisRate8Param := FindParam('thVATAnalysisRate8');
    thVATAnalysisRate9Param := FindParam('thVATAnalysisRate9');
    thVATAnalysisRateTParam := FindParam('thVATAnalysisRateT');
    thVATAnalysisRateXParam := FindParam('thVATAnalysisRateX');
    thVATAnalysisRateBParam := FindParam('thVATAnalysisRateB');
    thVATAnalysisRateCParam := FindParam('thVATAnalysisRateC');
    thVATAnalysisRateFParam := FindParam('thVATAnalysisRateF');
    thVATAnalysisRateGParam := FindParam('thVATAnalysisRateG');
    thVATAnalysisRateRParam := FindParam('thVATAnalysisRateR');
    thVATAnalysisRateWParam := FindParam('thVATAnalysisRateW');
    thVATAnalysisRateYParam := FindParam('thVATAnalysisRateY');
    thVATAnalysisRateIAdjParam := FindParam('thVATAnalysisRateIAdj');
    thVATAnalysisRateOAdjParam := FindParam('thVATAnalysisRateOAdj');
    thVATAnalysisRateSpareParam := FindParam('thVATAnalysisRateSpare');
    thNetValueParam := FindParam('thNetValue');
    thTotalVATParam := FindParam('thTotalVAT');
    thSettleDiscPercParam := FindParam('thSettleDiscPerc');
    thSettleDiscAmountParam := FindParam('thSettleDiscAmount');
    thTotalLineDiscountParam := FindParam('thTotalLineDiscount');
    thSettleDiscDaysParam := FindParam('thSettleDiscDays');
    thSettleDiscTakenParam := FindParam('thSettleDiscTaken');
    thAmountSettledParam := FindParam('thAmountSettled');
    thAutoIncrementParam := FindParam('thAutoIncrement');
    thUntilYearParam := FindParam('thUntilYear');
    thUntilPeriodParam := FindParam('thUntilPeriod');
    thTransportNatureParam := FindParam('thTransportNature');
    thTransportModeParam := FindParam('thTransportMode');
    thRemitNoParam := FindParam('thRemitNo');
    thAutoIncrementTypeParam := FindParam('thAutoIncrementType');
    thHoldFlagParam := FindParam('thHoldFlag');
    thAuditFlagParam := FindParam('thAuditFlag');
    thTotalWeightParam := FindParam('thTotalWeight');
    thDeliveryAddr1Param := FindParam('thDeliveryAddr1');
    thDeliveryAddr2Param := FindParam('thDeliveryAddr2');
    thDeliveryAddr3Param := FindParam('thDeliveryAddr3');
    thDeliveryAddr4Param := FindParam('thDeliveryAddr4');
    thDeliveryAddr5Param := FindParam('thDeliveryAddr5');
    thVarianceParam := FindParam('thVariance');
    thTotalOrderedParam := FindParam('thTotalOrdered');
    thTotalReservedParam := FindParam('thTotalReserved');
    thTotalCostParam := FindParam('thTotalCost');
    thTotalInvoicedParam := FindParam('thTotalInvoiced');
    thLongYourRefParam := FindParam('thLongYourRef');
    thUntilDateParam := FindParam('thUntilDate');
    thNOMVATIOParam := FindParam('thNOMVATIO');
    thExternalParam := FindParam('thExternal');
    thPrintedParam := FindParam('thPrinted');
    thRevalueAdjParam := FindParam('thRevalueAdj');
    thCurrSettledParam := FindParam('thCurrSettled');
    thSettledVATParam := FindParam('thSettledVAT');
    thVATClaimedParam := FindParam('thVATClaimed');
    thBatchGLParam := FindParam('thBatchGL');
    thAutoPostParam := FindParam('thAutoPost');
    thManualVATParam := FindParam('thManualVAT');
    thDeliveryTermsParam := FindParam('thDeliveryTerms');
    thIncludeInPickingRunParam := FindParam('thIncludeInPickingRun');
    thOperatorParam := FindParam('thOperator');
    thNoLabelsParam := FindParam('thNoLabels');
    thTaggedParam := FindParam('thTagged');
    thPickingRunNoParam := FindParam('thPickingRunNo');
    thOrdMatchParam := FindParam('thOrdMatch');
    thDeliveryNoteRefParam := FindParam('thDeliveryNoteRef');
    thVATCompanyRateParam := FindParam('thVATCompanyRate');
    thVATDailyRateParam := FindParam('thVATDailyRate');
    thOriginalCompanyRateParam := FindParam('thOriginalCompanyRate');
    thOriginalDailyRateParam := FindParam('thOriginalDailyRate');
    PostDiscAmParam := FindParam('PostDiscAm');
    thSpareNomCodeParam := FindParam('thSpareNomCode');
    thPostDiscTakenParam := FindParam('thPostDiscTaken');
    thControlGLParam := FindParam('thControlGL');
    thJobCodeParam := FindParam('thJobCode');
    thAnalysisCodeParam := FindParam('thAnalysisCode');
    thTotalOrderOSParam := FindParam('thTotalOrderOS');
    thAppDepartmentParam := FindParam('thAppDepartment');
    thAppCostCentreParam := FindParam('thAppCostCentre');
    thUserField1Param := FindParam('thUserField1');
    thUserField2Param := FindParam('thUserField2');
    thLineTypeAnalysis1Param := FindParam('thLineTypeAnalysis1');
    thLineTypeAnalysis2Param := FindParam('thLineTypeAnalysis2');
    thLineTypeAnalysis3Param := FindParam('thLineTypeAnalysis3');
    thLineTypeAnalysis4Param := FindParam('thLineTypeAnalysis4');
    thLineTypeAnalysis5Param := FindParam('thLineTypeAnalysis5');
    thLineTypeAnalysis6Param := FindParam('thLineTypeAnalysis6');
    thLastDebtChaseLetterParam := FindParam('thLastDebtChaseLetter');
    thBatchNowParam := FindParam('thBatchNow');
    thBatchThenParam := FindParam('thBatchThen');
    thUnTaggedParam := FindParam('thUnTagged');
    thOriginalBaseValueParam := FindParam('thOriginalBaseValue');
    thUseOriginalRatesParam := FindParam('thUseOriginalRates');
    thOldCompanyRateParam := FindParam('thOldCompanyRate');
    thOldDailyRateParam := FindParam('thOldDailyRate');
    thFixedRateParam := FindParam('thFixedRate');
    thUserField3Param := FindParam('thUserField3');
    thUserField4Param := FindParam('thUserField4');
    thProcessParam := FindParam('thProcess');
    thSourceParam := FindParam('thSource');
    thCurrencyTriRateParam := FindParam('thCurrencyTriRate');
    thCurrencyTriEuroParam := FindParam('thCurrencyTriEuro');
    thCurrencyTriInvertParam := FindParam('thCurrencyTriInvert');
    thCurrencyTriFloatParam := FindParam('thCurrencyTriFloat');
    thCurrencyTriSpareParam := FindParam('thCurrencyTriSpare');
    thVATTriRateParam := FindParam('thVATTriRate');
    thVATTriEuroParam := FindParam('thVATTriEuro');
    thVATTriInvertParam := FindParam('thVATTriInvert');
    thVATTriFloatParam := FindParam('thVATTriFloat');
    thVATTriSpareParam := FindParam('thVATTriSpare');
    thOriginalTriRateParam := FindParam('thOriginalTriRate');
    thOriginalTriEuroParam := FindParam('thOriginalTriEuro');
    thOriginalTriInvertParam := FindParam('thOriginalTriInvert');
    thOriginalTriFloatParam := FindParam('thOriginalTriFloat');
    thOriginalTriSpareParam := FindParam('thOriginalTriSpare');
    thOldOriginalTriRateParam := FindParam('thOldOriginalTriRate');
    thOldOriginalTriEuroParam := FindParam('thOldOriginalTriEuro');
    thOldOriginalTriInvertParam := FindParam('thOldOriginalTriInvert');
    thOldOriginalTriFloatParam := FindParam('thOldOriginalTriFloat');
    thOldOriginalTriSpareParam := FindParam('thOldOriginalTriSpare');
    thPostedDateParam := FindParam('thPostedDate');
    thPORPickSORParam := FindParam('thPORPickSOR');
    thBatchDiscAmountParam := FindParam('thBatchDiscAmount');
    thPrePostParam := FindParam('thPrePost');
    thAuthorisedAmntParam := FindParam('thAuthorisedAmnt');
    thTimeChangedParam := FindParam('thTimeChanged');
    thTimeCreatedParam := FindParam('thTimeCreated');
    thCISTaxDueParam := FindParam('thCISTaxDue');
    thCISTaxDeclaredParam := FindParam('thCISTaxDeclared');
    thCISManualTaxParam := FindParam('thCISManualTax');
    thCISDateParam := FindParam('thCISDate');
    thTotalCostApportionedParam := FindParam('thTotalCostApportioned');
    thCISEmployeeParam := FindParam('thCISEmployee');
    thCISTotalGrossParam := FindParam('thCISTotalGross');
    thCISSourceParam := FindParam('thCISSource');
    thTimesheetExportedParam := FindParam('thTimesheetExported');
    thCISExcludedFromGrossParam := FindParam('thCISExcludedFromGross');
    thWeekMonthParam := FindParam('thWeekMonth');
    thWorkflowStateParam := FindParam('thWorkflowState');
    thOverrideLocationParam := FindParam('thOverrideLocation');
    thSpare5Param := FindParam('thSpare5');
    thYourRefParam := FindParam('thYourRef');
    thUserField5Param := FindParam('thUserField5');
    thUserField6Param := FindParam('thUserField6');
    thUserField7Param := FindParam('thUserField7');
    thUserField8Param := FindParam('thUserField8');
    thUserField9Param := FindParam('thUserField9');
    thUserField10Param := FindParam('thUserField10');
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    thDeliveryPostCodeParam := FindParam('thDeliveryPostCode');
    // MH 16/10/2013 v7.0.7 ABSEXCH-14705: Added support for new Transaction Originator fields
    thOriginatorParam := FindParam('thOriginator');
    thCreationTimeParam := FindParam('thCreationTime');
    thCreationDateParam := FindParam('thCreationDate');
    // MH 24/10/2014: Added support for new Order Payments fields
    thOrderPaymentOrderRefParam := FindParam('thOrderPaymentOrderRef');
    thOrderPaymentElementParam := FindParam('thOrderPaymentElement');
    thOrderPaymentFlagsParam := FindParam('thOrderPaymentFlags');
    thCreditCardTypeParam := FindParam('thCreditCardType');
    thCreditCardNumberParam := FindParam('thCreditCardNumber');
    thCreditCardExpiryParam := FindParam('thCreditCardExpiry');
    thCreditCardAuthorisationNoParam := FindParam('thCreditCardAuthorisationNo');
    thCreditCardReferenceNoParam := FindParam('thCreditCardReferenceNo');
    thCustomData1Param := FindParam('thCustomData1');
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    thDeliveryCountryParam := FindParam('thDeliveryCountry');
    // MH 25/02/2015 v7.0.14 ABSEXCH-16284: Added support for Prompt Payment Discount fields
    thPPDPercentageParam := FindParam('thPPDPercentage');
    thPPDDaysParam := FindParam('thPPDDays');
    thPPDGoodsValueParam := FindParam('thPPDGoodsValue');
    thPPDVATValueParam := FindParam('thPPDVATValue');
    thPPDTakenParam := FindParam('thPPDTaken');
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    thPPDCreditNoteParam := FindParam('thPPDCreditNote');
    thBatchPayPPDStatusParam := FindParam('thBatchPayPPDStatus');
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    thIntrastatOutOfPeriodParam := FindParam('thIntrastatOutOfPeriod');
    // CJS 2016-04-27 - Add support for new Tax fields
    thUserField11Param := FindParam('thUserField11');
    thUserField12Param := FindParam('thUserField12');
    thTaxRegionParam := FindParam('thTaxRegion');
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    thAnonymisedParam := FindParam('thAnonymised');
    thAnonymisedDateParam := FindParam('thAnonymisedDate');
    thAnonymisedTimeParam := FindParam('thAnonymisedTime');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TDocumentDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^InvRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    thRunNoParam.Value := RunNo;                                                                                      // SQL=int, Delphi=Longint
    thAcCodeParam.Value := CustCode;                                                                                  // SQL=varchar, Delphi=String[10]
    thNomAutoParam.Value := NomAuto;                                                                                  // SQL=bit, Delphi=Boolean
    thOurRefParam.Value := OurRef;                                                                                    // SQL=varchar, Delphi=String[10]
    thFolioNumParam.Value := FolioNum;                                                                                // SQL=int, Delphi=Longint
    thCurrencyParam.Value := Currency;                                                                                // SQL=int, Delphi=Byte
    thYearParam.Value := AcYr;                                                                                        // SQL=int, Delphi=Byte
    thPeriodParam.Value := AcPr;                                                                                      // SQL=int, Delphi=Byte
    thDueDateParam.Value := DueDate;                                                                                  // SQL=varchar, Delphi=LongDate
    thVATPostDateParam.Value := VATPostDate;                                                                          // SQL=varchar, Delphi=LongDate
    thTransDateParam.Value := TransDate;                                                                              // SQL=varchar, Delphi=LongDate
    thCustSuppParam.Value := ConvertCharToSQLEmulatorVarChar(CustSupp);                                               // SQL=varchar, Delphi=Char
    thCompanyRateParam.Value := CXrate[False];                                                                        // SQL=float, Delphi=Double
    thDailyRateParam.Value := CXrate[True];                                                                           // SQL=float, Delphi=Double
    thOldYourRefParam.Value := OldYourRef;                                                                            // SQL=varchar, Delphi=String[10]
    // *** BINARY *** 
    thBatchLinkParam.Value := CreateVariantArray (@BatchLink, SizeOf(BatchLink));                      // SQL=varbinary, Delphi=String[12]
    thOutstandingParam.Value := ConvertCharToSQLEmulatorVarChar(AllocStat);                                           // SQL=varchar, Delphi=Char
    thNextLineNumberParam.Value := ILineCount;                                                                        // SQL=int, Delphi=LongInt
    thNextNotesLineNumberParam.Value := NLineCount;                                                                   // SQL=int, Delphi=LongInt
    thDocTypeParam.Value := InvDocHed;                                                                                // SQL=int, Delphi=DocTypes
    thVATAnalysisStandardParam.Value  := InvVatAnal[Standard];                                                                // SQL=float, Delphi=Double
    thVATAnalysisExemptParam.Value    := InvVatAnal[Exempt]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisZeroParam.Value      := InvVatAnal[Zero]    ;                                                                    // SQL=float, Delphi=Double
    thVATAnalysisRate1Param.Value     := InvVatAnal[Rate1]   ;                                                                   // SQL=float, Delphi=Double
    thVATAnalysisRate2Param.Value     := InvVatAnal[Rate2]   ;                                                                   // SQL=float, Delphi=Double
    thVATAnalysisRate3Param.Value     := InvVatAnal[Rate3]   ;                                                                   // SQL=float, Delphi=Double
    thVATAnalysisRate4Param.Value     := InvVatAnal[Rate4]   ;                                                                   // SQL=float, Delphi=Double
    thVATAnalysisRate5Param.Value     := InvVatAnal[Rate5]   ;                                                                   // SQL=float, Delphi=Double
    thVATAnalysisRate6Param.Value     := InvVatAnal[Rate6]   ;                                                                   // SQL=float, Delphi=Double
    thVATAnalysisRate7Param.Value     := InvVatAnal[Rate7]   ;                                                                   // SQL=float, Delphi=Double
    thVATAnalysisRate8Param.Value     := InvVatAnal[Rate8]   ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRate9Param.Value     := InvVatAnal[Rate9]   ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateTParam.Value     := InvVatAnal[Rate10]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateXParam.Value     := InvVatAnal[Rate11]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateBParam.Value     := InvVatAnal[Rate12]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateCParam.Value     := InvVatAnal[Rate13]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateFParam.Value     := InvVatAnal[Rate14]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateGParam.Value     := InvVatAnal[Rate15]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateRParam.Value     := InvVatAnal[Rate16]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateWParam.Value     := InvVatAnal[Rate17]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateYParam.Value     := InvVatAnal[Rate18]  ;                                                                  // SQL=float, Delphi=Double
    thVATAnalysisRateIAdjParam.Value  := InvVatAnal[IAdj]    ;                                                               // SQL=float, Delphi=Double
    thVATAnalysisRateOAdjParam.Value  := InvVatAnal[OAdj]    ;                                                               // SQL=float, Delphi=Double
    thVATAnalysisRateSpareParam.Value := InvVatAnal[Spare8]  ;                                                              // SQL=float, Delphi=Double
    thNetValueParam.Value := InvNetVal;                                                                               // SQL=float, Delphi=Real
    thTotalVATParam.Value := InvVat;                                                                                  // SQL=float, Delphi=Real
    thSettleDiscPercParam.Value := DiscSetl;                                                                          // SQL=float, Delphi=Real
    thSettleDiscAmountParam.Value := DiscSetAm;                                                                       // SQL=float, Delphi=Real
    thTotalLineDiscountParam.Value := DiscAmount;                                                                     // SQL=float, Delphi=Real
    thSettleDiscDaysParam.Value := DiscDays;                                                                          // SQL=int, Delphi=SmallInt
    thSettleDiscTakenParam.Value := DiscTaken;                                                                        // SQL=bit, Delphi=Boolean
    thAmountSettledParam.Value := Settled;                                                                            // SQL=float, Delphi=Real
    thAutoIncrementParam.Value := AutoInc;                                                                            // SQL=int, Delphi=SmallInt
    thUntilYearParam.Value := UnYr;                                                                                   // SQL=int, Delphi=Byte
    thUntilPeriodParam.Value := UnPr;                                                                                 // SQL=int, Delphi=Byte
    thTransportNatureParam.Value := TransNat;                                                                         // SQL=int, Delphi=Byte
    thTransportModeParam.Value := TransMode;                                                                          // SQL=int, Delphi=Byte
    thRemitNoParam.Value := RemitNo;                                                                                  // SQL=varchar, Delphi=String[10]
    thAutoIncrementTypeParam.Value := ConvertCharToSQLEmulatorVarChar(AutoIncBy);                                     // SQL=varchar, Delphi=Char
    thHoldFlagParam.Value := HoldFlg;                                                                                 // SQL=int, Delphi=Byte
    thAuditFlagParam.Value := AuditFlg;                                                                               // SQL=bit, Delphi=Boolean
    thTotalWeightParam.Value := TotalWeight;                                                                          // SQL=float, Delphi=Real
    thDeliveryAddr1Param.Value := DAddr[1];                                                                           // SQL=varchar, Delphi=String[30]
    thDeliveryAddr2Param.Value := DAddr[2];                                                                           // SQL=varchar, Delphi=String[30]
    thDeliveryAddr3Param.Value := DAddr[3];                                                                           // SQL=varchar, Delphi=String[30]
    thDeliveryAddr4Param.Value := DAddr[4];                                                                           // SQL=varchar, Delphi=String[30]
    thDeliveryAddr5Param.Value := DAddr[5];                                                                           // SQL=varchar, Delphi=String[30]
    thVarianceParam.Value := Variance;                                                                                // SQL=float, Delphi=Real
    thTotalOrderedParam.Value := TotalOrdered;                                                                        // SQL=float, Delphi=Real
    thTotalReservedParam.Value := TotalReserved;                                                                      // SQL=float, Delphi=Real
    thTotalCostParam.Value := TotalCost;                                                                              // SQL=float, Delphi=Real
    thTotalInvoicedParam.Value := TotalInvoiced;                                                                      // SQL=float, Delphi=Real
    // *** BINARY ***
    thLongYourRefParam.Value := CreateVariantArray (@TransDesc, SizeOf(TransDesc));                    // SQL=varbinary, Delphi=String[20]
    thUntilDateParam.Value := UntilDate;                                                                              // SQL=varchar, Delphi=LongDate
    thNOMVATIOParam.Value := ConvertCharToSQLEmulatorVarChar(NOMVATIO);                                               // SQL=varchar, Delphi=Char
    thExternalParam.Value := ExternalDoc;                                                                             // SQL=bit, Delphi=Boolean
    thPrintedParam.Value := PrintedDoc;                                                                               // SQL=bit, Delphi=Boolean
    thRevalueAdjParam.Value := ReValueAdj;                                                                            // SQL=float, Delphi=Real
    thCurrSettledParam.Value := CurrSettled;                                                                          // SQL=float, Delphi=Real
    thSettledVATParam.Value := SettledVAT;                                                                            // SQL=float, Delphi=Real
    thVATClaimedParam.Value := VATClaimed;                                                                            // SQL=float, Delphi=Real
    thBatchGLParam.Value := BatchNom;                                                                                 // SQL=int, Delphi=LongInt
    thAutoPostParam.Value := AutoPost;                                                                                // SQL=bit, Delphi=Boolean
    thManualVATParam.Value := ManVAT;                                                                                 // SQL=bit, Delphi=Boolean
    thDeliveryTermsParam.Value := DelTerms;                                                                           // SQL=varchar, Delphi=String[3]
    thIncludeInPickingRunParam.Value := OnPickRun;                                                                    // SQL=bit, Delphi=Boolean
    thOperatorParam.Value := OpName;                                                                                  // SQL=varchar, Delphi=String[10]
    thNoLabelsParam.Value := NoLabels;                                                                                // SQL=int, Delphi=SmallInt
    thTaggedParam.Value := Tagged;                                                                                    // SQL=int, Delphi=Byte
    thPickingRunNoParam.Value := PickRunNo;                                                                           // SQL=int, Delphi=LongInt
    thOrdMatchParam.Value := OrdMatch;                                                                                // SQL=bit, Delphi=Boolean
    thDeliveryNoteRefParam.Value := DeliverRef;                                                                       // SQL=varchar, Delphi=String[10]
    thVATCompanyRateParam.Value := VATCRate[False];                                                                   // SQL=float, Delphi=Double
    thVATDailyRateParam.Value := VATCRate[True];                                                                      // SQL=float, Delphi=Double
    thOriginalCompanyRateParam.Value := OrigRates[False];                                                             // SQL=float, Delphi=Double
    thOriginalDailyRateParam.Value := OrigRates[True];                                                                // SQL=float, Delphi=Double
    PostDiscAmParam.Value := PostDiscAm;                                                                              // SQL=float, Delphi=Double
    thSpareNomCodeParam.Value := FRNomCode;                                                                           // SQL=int, Delphi=LongInt
    thPostDiscTakenParam.Value := PDiscTaken;                                                                         // SQL=bit, Delphi=Boolean
    thControlGLParam.Value := CtrlNom;                                                                                // SQL=int, Delphi=Longint
    thJobCodeParam.Value := DJobCode;                                                                                 // SQL=varchar, Delphi=String[10]
    thAnalysisCodeParam.Value := DJobAnal;                                                                            // SQL=varchar, Delphi=String[10]
    thTotalOrderOSParam.Value := TotOrdOS;                                                                            // SQL=float, Delphi=Real
    thAppDepartmentParam.Value := FRCCDep[False];                                                                     // SQL=varchar, Delphi=String[3]
    thAppCostCentreParam.Value := FRCCDep[True];                                                                      // SQL=varchar, Delphi=String[3]
    thUserField1Param.Value := DocUser1;                                                                              // SQL=varchar, Delphi=String[30]
    thUserField2Param.Value := DocUser2;                                                                              // SQL=varchar, Delphi=String[30]
    thLineTypeAnalysis1Param.Value := DocLSplit[1];                                                                   // SQL=float, Delphi=Double
    thLineTypeAnalysis2Param.Value := DocLSplit[2];                                                                   // SQL=float, Delphi=Double
    thLineTypeAnalysis3Param.Value := DocLSplit[3];                                                                   // SQL=float, Delphi=Double
    thLineTypeAnalysis4Param.Value := DocLSplit[4];                                                                   // SQL=float, Delphi=Double
    thLineTypeAnalysis5Param.Value := DocLSplit[5];                                                                   // SQL=float, Delphi=Double
    thLineTypeAnalysis6Param.Value := DocLSplit[6];                                                                   // SQL=float, Delphi=Double
    thLastDebtChaseLetterParam.Value := LastLetter;                                                                   // SQL=int, Delphi=Byte
    thBatchNowParam.Value := BatchNow;                                                                                // SQL=float, Delphi=Double
    thBatchThenParam.Value := BatchThen;                                                                              // SQL=float, Delphi=Double
    thUnTaggedParam.Value := UnTagged;                                                                                // SQL=bit, Delphi=Boolean
    thOriginalBaseValueParam.Value := OBaseEquiv;                                                                     // SQL=float, Delphi=Double
    thUseOriginalRatesParam.Value := UseORate;                                                                        // SQL=int, Delphi=Byte
    thOldCompanyRateParam.Value := OldORates[False];                                                                  // SQL=float, Delphi=Double
    thOldDailyRateParam.Value := OldORates[True];                                                                     // SQL=float, Delphi=Double
    thFixedRateParam.Value := SOPKeepRate;                                                                            // SQL=bit, Delphi=Boolean
    thUserField3Param.Value := DocUser3;                                                                              // SQL=varchar, Delphi=String[30]
    thUserField4Param.Value := DocUser4;                                                                              // SQL=varchar, Delphi=String[30]
    thProcessParam.Value := ConvertCharToSQLEmulatorVarChar(SSDProcess);                                              // SQL=varchar, Delphi=Char
    thSourceParam.Value := ExtSource;                                                                                 // SQL=int, Delphi=Byte
    thCurrencyTriRateParam.Value := CurrTriR.TriRates;                                                                // SQL=float, Delphi=Double
    thCurrencyTriEuroParam.Value := CurrTriR.TriEuro;                                                                 // SQL=int, Delphi=Byte
    thCurrencyTriInvertParam.Value := CurrTriR.TriInvert;                                                             // SQL=bit, Delphi=Boolean
    thCurrencyTriFloatParam.Value := CurrTriR.TriFloat;                                                               // SQL=bit, Delphi=Boolean
    // *** BINARY ***
    thCurrencyTriSpareParam.Value := CreateVariantArray (@CurrTriR.Spare, SizeOf(CurrTriR.Spare));// SQL=varbinary, Delphi=array[1..10] of Byte
    thVATTriRateParam.Value := VATTriR.TriRates;                                                                      // SQL=float, Delphi=Double
    thVATTriEuroParam.Value := VATTriR.TriEuro;                                                                       // SQL=int, Delphi=Byte
    thVATTriInvertParam.Value := VATTriR.TriInvert;                                                                   // SQL=bit, Delphi=Boolean
    thVATTriFloatParam.Value := VATTriR.TriFloat;                                                                     // SQL=bit, Delphi=Boolean
    // *** BINARY ***
    thVATTriSpareParam.Value := CreateVariantArray (@VATTriR.Spare, SizeOf(VATTriR.Spare));      // SQL=varbinary, Delphi=array[1..10] of Byte
    thOriginalTriRateParam.Value := OrigTriR.TriRates;                                                                // SQL=float, Delphi=Double
    thOriginalTriEuroParam.Value := OrigTriR.TriEuro;                                                                 // SQL=int, Delphi=Byte
    thOriginalTriInvertParam.Value := OrigTriR.TriInvert;                                                             // SQL=bit, Delphi=Boolean
    thOriginalTriFloatParam.Value := OrigTriR.TriFloat;                                                               // SQL=bit, Delphi=Boolean
    // *** BINARY ***
    thOriginalTriSpareParam.Value := CreateVariantArray (@OrigTriR.Spare, SizeOf(OrigTriR.Spare));// SQL=varbinary, Delphi=array[1..10] of Byte
    thOldOriginalTriRateParam.Value := OldORTriR.TriRates;                                                            // SQL=float, Delphi=Double
    thOldOriginalTriEuroParam.Value := OldORTriR.TriEuro;                                                             // SQL=int, Delphi=Byte
    thOldOriginalTriInvertParam.Value := OldORTriR.TriInvert;                                                         // SQL=bit, Delphi=Boolean
    thOldOriginalTriFloatParam.Value := OldORTriR.TriFloat;                                                           // SQL=bit, Delphi=Boolean
    // *** BINARY ***
    thOldOriginalTriSpareParam.Value := CreateVariantArray (@OldORTriR.Spare, SizeOf(OldORTriR.Spare));         // SQL=varbinary, Delphi=array[1..10] of Byte
    thPostedDateParam.Value := PostDate;                                                                              // SQL=varchar, Delphi=LongDate
    thPORPickSORParam.Value := PORPickSOR;                                                                            // SQL=bit, Delphi=Boolean
    thBatchDiscAmountParam.Value := BDiscount;                                                                        // SQL=float, Delphi=Double
    thPrePostParam.Value := PrePostFlg;                                                                               // SQL=int, Delphi=Byte
    thAuthorisedAmntParam.Value := AuthAmnt;                                                                          // SQL=float, Delphi=Double
    thTimeChangedParam.Value := TimeChange;                                                                           // SQL=varchar, Delphi=String[6]
    thTimeCreatedParam.Value := TimeCreate;                                                                           // SQL=varchar, Delphi=String[6]
    thCISTaxDueParam.Value := CISTax;                                                                                 // SQL=float, Delphi=Double
    thCISTaxDeclaredParam.Value := CISDeclared;                                                                       // SQL=float, Delphi=Double
    thCISManualTaxParam.Value := CISManualTax;                                                                        // SQL=bit, Delphi=Boolean
    thCISDateParam.Value := CISDate;                                                                                  // SQL=varchar, Delphi=LongDate
    thTotalCostApportionedParam.Value := TotalCost2;                                                                  // SQL=float, Delphi=Double
    thCISEmployeeParam.Value := CISEmpl;                                                                              // SQL=varchar, Delphi=String[10]
    thCISTotalGrossParam.Value := CISGross;                                                                           // SQL=float, Delphi=Double
    thCISSourceParam.Value := CISHolder;                                                                              // SQL=int, Delphi=Byte
    thTimesheetExportedParam.Value := THExportedFlag;                                                                 // SQL=bit, Delphi=Boolean
    thCISExcludedFromGrossParam.Value := CISGExclude;                                                                 // SQL=float, Delphi=Double
    thWeekMonthParam.Value := thWeekMonth;                                                                            // SQL=int, Delphi=SmallInt
    thWorkflowStateParam.Value := thWorkflowState;                                                                    // SQL=int, Delphi=LongInt
    thOverrideLocationParam.Value := thOverrideLocation;                                                              // SQL=varchar, Delphi=String[3]
    // *** BINARY ***
    thSpare5Param.Value := CreateVariantArray (@Spare5, SizeOf(Spare5));                                              // SQL=varbinary, Delphi=Array[1..54] of Byte
    thYourRefParam.Value := YourRef;                                                                                  // SQL=varchar, Delphi=String[20]
    thUserField5Param.Value := DocUser5;                                                                              // SQL=varchar, Delphi=String[30]
    thUserField6Param.Value := DocUser6;                                                                              // SQL=varchar, Delphi=String[30]
    thUserField7Param.Value := DocUser7;                                                                              // SQL=varchar, Delphi=String[30]
    thUserField8Param.Value := DocUser8;                                                                              // SQL=varchar, Delphi=String[30]
    thUserField9Param.Value := DocUser9;                                                                              // SQL=varchar, Delphi=String[30]
    thUserField10Param.Value := DocUser10;                                                                            // SQL=varchar, Delphi=String[30]
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    thDeliveryPostCodeParam.Value := thDeliveryPostCode;
    // MH 16/10/2013 v7.0.7 ABSEXCH-14705: Added support for new Transaction Originator fields
    thOriginatorParam.Value := thOriginator;
    thCreationTimeParam.Value := thCreationTime;
    thCreationDateParam.Value := thCreationDate;
    // MH 24/10/2014: Added support for new Order Payments fields
    thOrderPaymentOrderRefParam.Value := thOrderPaymentOrderRef;
    thOrderPaymentElementParam.Value := thOrderPaymentElement;
    thOrderPaymentFlagsParam.Value := thOrderPaymentFlags;
    thCreditCardTypeParam.Value := thCreditCardType;
    thCreditCardNumberParam.Value := thCreditCardNumber;
    thCreditCardExpiryParam.Value := thCreditCardExpiry;
    thCreditCardAuthorisationNoParam.Value := thCreditCardAuthorisationNo;
    thCreditCardReferenceNoParam.Value := thCreditCardReferenceNo;
    thCustomData1Param.Value := thCustomData1;
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    thDeliveryCountryParam.Value := thDeliveryCountry;
    // MH 25/02/2015 v7.0.14 ABSEXCH-16284: Added support for Prompt Payment Discount fields
    thPPDPercentageParam.Value := thPPDPercentage;
    thPPDDaysParam.Value := thPPDDays;
    thPPDGoodsValueParam.Value := thPPDGoodsValue;
    thPPDVATValueParam.Value := thPPDVATValue;
    thPPDTakenParam.Value := thPPDTaken;
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    thPPDCreditNoteParam.Value := thPPDCreditNote;
    thBatchPayPPDStatusParam.Value := thBatchPayPPDStatus;
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    thIntrastatOutOfPeriodParam.Value := thIntrastatOutOfPeriod;
    // CJS 2016-04-27 - Add support for new Tax fields
    thUserField11Param.Value := thUserField11;
    thUserField12Param.Value := thUserField12;
    thTaxRegionParam.Value := thTaxRegion;
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    thAnonymisedParam.Value := thAnonymised;
    thAnonymisedDateParam.Value := thAnonymisedDate;
    thAnonymisedTimeParam.Value := thAnonymisedTime;
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

