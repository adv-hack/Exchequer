Unit oMLocStkDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TMLocStkDataWrite_LocationVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Variant specific fields
    loCodeParam, loNameParam, LoAddr1Param, LoAddr2Param, LoAddr3Param,
    LoAddr4Param, LoAddr5Param, LoTelParam, LoFaxParam, LoEmailParam, LoModemParam,
    LoContactParam, LoCurrencyParam, LoAreaParam, LoRepParam, LoTagParam,
    LoNominal1Param, LoNominal2Param, LoNominal3Param, LoNominal4Param,
    LoNominal5Param, LoNominal6Param, LoNominal7Param, LoNominal8Param,
    LoNominal9Param, LoNominal10Param, LoDepartmentParam, LoCostCentreParam,
    LoUsePriceParam, LoUseNomParam, LoUseCCDepParam, LoUseSuppParam, LoUseBinLocParam,
    LoNLineCountParam, LoUseCPriceParam, LoUseRPriceParam, LoWOPWIPGLParam,
    LoReturnGLParam, LoPReturnGLParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_LocationVariant

  //------------------------------

  TMLocStkDataWrite_StockLocationVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Variant specific fields
    LsStkCodeParam, LsStkFolioParam, LsLocCodeParam, LsQtyInStockParam,
    LsQtyOnOrderParam, LsQtyAllocParam, LsQtyPickedParam, LsQtyMinParam,
    LsQtyMaxParam, LsQtyFreezeParam, LsRoQtyParam, LsRoDateParam, LsRoDepartmentParam,
    LsRoCostCentreParam, LsDepartmentParam, LsCostCentreParam, LsBinLocParam,
    Currency1Param, SalesPrice1Param, Currency2Param, SalesPrice2Param,
    Currency3Param, SalesPrice3Param, Currency4Param, SalesPrice4Param,
    Currency5Param, SalesPrice5Param, Currency6Param, SalesPrice6Param,
    Currency7Param, SalesPrice7Param, Currency8Param, SalesPrice8Param,
    Currency9Param, SalesPrice9Param, Currency10Param, SalesPrice10Param,
    LsRoPriceParam, LsRoCurrencyParam, LsCostPriceParam, LsPCurrencyParam,
    LsDefNom1Param, LsDefNom2Param, LsDefNom3Param, LsDefNom4Param, LsDefNom5Param,
    LsDefNom6Param, LsDefNom7Param, LsDefNom8Param, LsDefNom9Param, LsDefNom10Param,
    LsStkFlgParam, LsMinFlgParam, LsTempSuppParam, LsSupplierParam, LsLastUsedParam,
    LsQtyPostedParam, LsQtyTakeParam, LsROFlgParam, LsLastTimeParam, LsQtyAllocWORParam,
    LsQtyIssueWORParam, LsQtyPickWORParam, LsWOPWIPGLParam, LsSWarrantyParam,
    LsSWarrantyTypeParam, LsMWarrantyParam, LsMWarrantyTypeParam, LsQtyPReturnParam,
    LsReturnGLParam, LsReStockPcntParam, LsReStockGLParam, LsBOMDedCompParam,
    LsQtyReturnParam, LsPReturnGLParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_StockLocationVariant

  //------------------------------

  TMLocStkDataWrite_BinVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    BrInDocParam, BrOutDocParam, BrSoldParam, BrDateInParam, BrBinCostParam,
    BrBinCapParam, Spare5Param, BrStkFolioParam, BrDateOutParam, BrSoldLineParam,
    BrBuyLineParam, BrBatchRecParam, BrBuyQtyParam, BrQtyUsedParam, BrBatchChildParam,
    BrInMLocParam, BrOutMLocParam, BrOutOrdDocParam, BrInOrdDocParam, BrInOrdLineParam,
    BrOutOrdLineParam, BrCurCostParam, BrPriorityParam, BrBinSellParam,
    brSerCompanyRateParam, brSerDailyRateParam, BrSUseORateParam, brSerTriRatesParam,
    brSerTriEuroParam, brSerTriInvertParam, brSerTriFloatParam, brSerSpareParam,
    BrDateUseXParam, BrCurSellParam, BrUOMParam, BrHoldFlgParam, BrTagNoParam,
    BrReturnBinParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_BinVariant

  //------------------------------

  TMLocStkDataWrite_BankRecHeaderVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    BrStatDateParam, BrStatRefParam, BrBankAccParam, BrBankCurrencyParam,
    BrBankUserIDParam, BrCreateDateParam, BrCreateTimeParam, BrStatBalParam,
    BrOpenBalParam, BrCloseBalParam, BrStatusParam, BrIntRefParam, BrGLCodeParam,
    BrStatFolioParam, BrReconDateParam, BrReconRefParam, BrInitSeqParam,
    BrGroupByParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_BankRecHeaderVariant

  //------------------------------

  TMLocStkDataWrite_BankRecDetailVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    BrPayRefParam, BrLineDateParam, BrMatchRefParam, BrValueParam, BrLineNoParam,
    BrStatIdParam, BrStatLineParam, BrCustCodeParam, BrPeriodParam, BrYearParam,
    brCompanyRateParam, brDailyRateParam, BrLUseORateParam, brCurTriRateParam,
    brCurTriEuroParam, brCurTriInvertParam, brCurTriFloatParam, brCurSpareParam,
    BrOldYourRefParam, BrTransValueParam, BrDepartmentParam, BrCostCentreParam,
    BrNomCodeParam, BrSRINomCodeParam, BrFolioLinkParam, BrVATCodeParam,
    BrVATAmountParam, BrTransDateParam, BrIsNewTransParam, BrLineStatusParam,
    Spare6Param, BrYourRefParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_BankRecDetailVariant

  //------------------------------

  TMLocStkDataWrite_BankAccountVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    BrAccNOMParam, BrBankProdParam, BrPayPathParam, BrPayFileNameParam,
    BrRecFileNameParam, BrStatPathParam, BrSwiftRef1Param, BrSwiftRef2Param,
    BrSwiftRef3Param, BrSwiftBICParam, BrRouteCodeParam, BrChargeInstParam,
    BrRouteMethodParam, BrLastUseDateParam, BrOldSortCodeParam, BrOldAccountCodeParam,
    BrBankRefParam, BrBACSUserIDParam, BrBACSCurrencyParam, BrUserID2Param,
    BrSortCodeExParam, BrAccountCodeExParam, BrBankSortCodeParam,
    BrBankAccountCodeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_BankAccountVariant

  //------------------------------

  TMLocStkDataWrite_BankStatementHeaderVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    EbAccNOMParam, EbStatRefParam, EbStatIndParam, EbSourceFileParam, EbIntRefParam,
    EbStatDateParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_BankStatementHeaderVariant

  //------------------------------

  TMLocStkDataWrite_BankStatementLineVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    EbLineNoParam, EbLineDateParam, EbLineRefParam, EbLineValueParam, EbLineIntRefParam,
    EbMatchStrParam, EbGLCodeParam, EbLineRef2Param, EbLineStatusParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_BankStatementLineVariant

  //------------------------------

  TMLocStkDataWrite_AltStockCodesVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    SdStkFolioParam, SdFolioParam, SdSuppCodeParam, SdAltCodeParam, SdROCurrencyParam,
    SdRoPriceParam, SdNLineCountParam, SdLastUsedParam, SdOverROParam,
    SdDescParam, SdLastTimeParam, SdOverMinEccParam, SdMinEccQtyParam,
    SdOverLineQtyParam, SdLineQtyParam, SdLineNoParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_AltStockCodesVariant

  //------------------------------

  TMLocStkDataWrite_UserProfileVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    PWExpModeParam, PWExPDaysParam, PWExpDateParam, DirCustParam, DirSuppParam,
    MaxSalesAParam, MaxPurchAParam, DepartmentParam, CostCentreParam, LocParam,
    SalesBankParam, PurchBankParam, ReportPrnParam, FormPrnParam, OrPrns1Param,
    OrPrns2Param, CCDepRuleParam, LocRuleParam, EmailAddrParam, PWTimeOutParam,
    LoadedParam, UserNameParam, UCPrParam, UCYrParam, UDispPrMnthParam,
    ShowGLCodesParam, ShowStockCodeParam, ShowProductTypeParam,
    // MH 05/09/2017 2017-R2 ABSEXCH-18855: Updated for new Password Complexity fields in User Profile Record
    UserStatusParam, PasswordSaltParam, PasswordHashParam, WindowUserIdParam,
    SecurityQuestionIdParam, SecurityAnswerParam, ForcePasswordChangeParam,
    LoginFailureCountParam : TParameter;
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    HighlightPIIFieldsParam, HighlightPIIColourParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_UserProfileVariant

  //------------------------------

  TMLocStkDataWrite_TelesalesVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, varCode1Param, varCode2Param, varCode3Param : TParameter;

    // Variant specific fields
    TcCustCodeParam, TcDocTypeParam, TcCurrParam, TcCXCompanyRateParam,
    TcCXDailyRateParam, TcOldYourRefParam, TcLYRefParam, TcDepartmentParam,
    TcCostCentreParam, TcLocCodeParam, TcJobCodeParam, TcJACodeParam, TcDAddr1Param,
    TcDAddr2Param, TcDAddr3Param, TcDAddr4Param, TcDAddr5Param, TcTDateParam,
    TcDelDateParam, TcNetTotalParam, TcVATTotalParam, TcDiscTotalParam,
    TcLastOpoParam, TcInProgParam, TcTransNatParam, TcTransModeParam, TcDelTermsParam,
    TcCtrlCodeParam, TcVATCodeParam, TcOrdModeParam, TcScaleModeParam,
    TcLineCountParam, TcWasNewParam, TcUseORateParam, TcDefNomCodeParam,
    TcVATIncFlgParam, TcSetDiscParam, TcGenModeParam, TcTagNoParam, TcLockAddrParam,
    Spare2Param, TcYourRefParam : TParameter;
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    tcDeliveryPostCodeParam : TParameter;
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    tcDeliveryCountryParam : TParameter;
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    tcSSDProcessParam,
    // CJS 2016-04-27 - Add support for new Tax fields
    tcTaxRegionParam: TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_TelesalesVariant

  //------------------------------

  TMLocStkDataWrite_AccountStockAnalysisVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Variant specific fields
    CsIndexParam, CsCustCodeParam, CsStockCodeParam, CsStkFolioParam, CsSOQtyParam,
    CsLastDateParam, CsLineNoParam, CsLastPriceParam, CsLPCurrParam, CsJobCodeParam,
    CsJACodeParam, CsLocCodeParam, CsNomCodeParam, CsDepartmentParam, CsCostCentreParam,
    CsQtyParam, CsNetValueParam, CsDiscountParam, CsVATCodeParam, CsCostParam,
    CsDesc1Param, CsDesc2Param, CsDesc3Param, CsDesc4Param, CsDesc5Param,
    CsDesc6Param, CsVATParam, CsPrxPackParam, CsQtyPackParam, CsQtyMulParam,
    CsDiscChParam, CsEnteredParam, CsUsePackParam, CsShowCaseParam, CsLineTypeParam,
    CsPriceMulXParam, CsVATIncFlgParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_AccountStockAnalysisVariant

  //------------------------------

  TMLocStkDataWrite_AllocWizardSessionVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Variant specific fields
    ArcCustSuppParam, ArcBankNomParam, ArcCtrlNomParam, ArcPayCurrParam,
    ArcInvCurrParam, ArcDepartmentParam, ArcCostCentreParam, ArcSortByParam,
    ArcAutoTotalParam, ArcSDDaysOverParam, ArcFromTransParam, ArcOldYourRefParam,
    ArcChequeNo2Param, ArcForceNewParam, ArcSort2ByParam, ArcTotalOwnParam,
    ArcTransValueParam, ArcTagCountParam, ArcTagRunDateParam, ArcTagRunYrParam,
    ArcTagRunPrParam, ArcSRCPIRefParam, ArcIncSDiscParam, ArcTotalParam,
    ArcVarianceParam, ArcSettleDParam, ArcTransDateParam, ArcUD1Param,
    ArcUD2Param, ArcUD3Param, ArcUD4Param, ArcJobCodeParam, ArcAnalCodeParam,
    ArcPayDetails1Param, ArcPayDetails2Param, ArcPayDetails3Param, ArcPayDetails4Param,
    ArcPayDetails5Param, ArcIncVarParam, ArcOurRefParam, ArcCompanyRateParam,
    ArcDailyRateParam, ArcOpoNameParam, ArcStartDateParam, ArcStartTimeParam,
    ArcWinLogInParam, ArcLockedParam, ArcSalesModeParam, ArcCustCodeParam,
    ArcUseOSNdxParam, ArcOwnTransValueParam, ArcOwnSettleDParam, ArcFinVarParam,
    ArcFinSetDParam, ArcSortDParam, ArcAllocFullParam, ArcCheckFailParam,
    ArcCharge1GLParam, ArcCharge2GLParam, ArcCharge1AmtParam, ArcCharge2AmtParam,
    ArcYourRefParam, ArcUD5Param, ArcUD6Param, ArcUD7Param, ArcUD8Param,
    ArcUD9Param, ArcUD10Param : TParameter;
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing Allocation Wizard field
    ArcUsePPDParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite_AllocWizardSessionVariant

  //------------------------------

  TMLocStkDataWrite = Class(TBaseDataWrite)
  Private
    FLocationVariant : TMLocStkDataWrite_LocationVariant;
    FStockLocationVariant : TMLocStkDataWrite_StockLocationVariant;
    FBinVariant : TMLocStkDataWrite_BinVariant;
    FBankRecHeaderVariant : TMLocStkDataWrite_BankRecHeaderVariant;
    FBankRecDetailVariant : TMLocStkDataWrite_BankRecDetailVariant;
    FBankAccountVariant : TMLocStkDataWrite_BankAccountVariant;
    FBankStatementHeaderVariant : TMLocStkDataWrite_BankStatementHeaderVariant;
    FBankStatementLineVariant : TMLocStkDataWrite_BankStatementLineVariant;
    FAltStockCodesVariant : TMLocStkDataWrite_AltStockCodesVariant;
    FUserProfileVariant : TMLocStkDataWrite_UserProfileVariant;
    FTelesalesVariant : TMLocStkDataWrite_TelesalesVariant;
    FAccountStockAnalysisVariant : TMLocStkDataWrite_AccountStockAnalysisVariant;
    FAllocWizardSessionVariant : TMLocStkDataWrite_AllocWizardSessionVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMLocStkDataWrite

  //------------------------------

Implementation

Uses Variants, VarRec2U, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TMLocStkDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FLocationVariant := TMLocStkDataWrite_LocationVariant.Create;
  FStockLocationVariant := TMLocStkDataWrite_StockLocationVariant.Create;
  FBinVariant := TMLocStkDataWrite_BinVariant.Create;
  FBankRecHeaderVariant := TMLocStkDataWrite_BankRecHeaderVariant.Create;
  FBankRecDetailVariant := TMLocStkDataWrite_BankRecDetailVariant.Create;
  FBankAccountVariant := TMLocStkDataWrite_BankAccountVariant.Create;
  FBankStatementHeaderVariant := TMLocStkDataWrite_BankStatementHeaderVariant.Create;
  FBankStatementLineVariant := TMLocStkDataWrite_BankStatementLineVariant.Create;
  FAltStockCodesVariant := TMLocStkDataWrite_AltStockCodesVariant.Create;
  FUserProfileVariant := TMLocStkDataWrite_UserProfileVariant.Create;
  FTelesalesVariant := TMLocStkDataWrite_TelesalesVariant.Create;
  FAccountStockAnalysisVariant := TMLocStkDataWrite_AccountStockAnalysisVariant.Create;
  FAllocWizardSessionVariant := TMLocStkDataWrite_AllocWizardSessionVariant.Create;
End; // Create

//------------------------------

Destructor TMLocStkDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FLocationVariant);
  FreeAndNIL(FStockLocationVariant);
  FreeAndNIL(FBinVariant);
  FreeAndNIL(FBankRecHeaderVariant);
  FreeAndNIL(FBankRecDetailVariant);
  FreeAndNIL(FBankAccountVariant);
  FreeAndNIL(FBankStatementHeaderVariant);
  FreeAndNIL(FBankStatementLineVariant);
  FreeAndNIL(FAltStockCodesVariant);
  FreeAndNIL(FUserProfileVariant);
  FreeAndNIL(FTelesalesVariant);
  FreeAndNIL(FAccountStockAnalysisVariant);
  FreeAndNIL(FAllocWizardSessionVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FLocationVariant.Prepare (ADOConnection, CompanyCode);
  FStockLocationVariant.Prepare (ADOConnection, CompanyCode);
  FBinVariant.Prepare (ADOConnection, CompanyCode);
  FBankRecHeaderVariant.Prepare (ADOConnection, CompanyCode);
  FBankRecDetailVariant.Prepare (ADOConnection, CompanyCode);
  FBankAccountVariant.Prepare (ADOConnection, CompanyCode);
  FBankStatementHeaderVariant.Prepare (ADOConnection, CompanyCode);
  FBankStatementLineVariant.Prepare (ADOConnection, CompanyCode);
  FAltStockCodesVariant.Prepare (ADOConnection, CompanyCode);
  FUserProfileVariant.Prepare (ADOConnection, CompanyCode);
  FTelesalesVariant.Prepare (ADOConnection, CompanyCode);
  FAccountStockAnalysisVariant.Prepare (ADOConnection, CompanyCode);
  FAllocWizardSessionVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix = 'C') And (DataRec.SubType = 'C') Then
  Begin
    // MLocLoc : MLocLocType - Locations - Normalised to Location table
    FLocationVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'C') And (DataRec.SubType = 'C')
  Else If (DataRec.RecPFix = 'C') And (DataRec.SubType = 'D') Then
  Begin
    // MStkLoc : MStkLocType - Stock-Locations - Normalised to StockLocation table
    FStockLocationVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'C') And (DataRec.SubType = 'D')
  Else If (DataRec.RecPFix = 'I') And (DataRec.SubType = 'R') Then
  Begin
    // brBinRec : brBinRecType - Multi-Bins
    FBinVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'I') And (DataRec.SubType = 'R')
  Else If (DataRec.RecPFix = 'K') And (DataRec.SubType = '1') Then
  Begin
    // BnkRHRec : BnkRHRecType - Bank Reconciliation header
    FBankRecHeaderVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'K') And (DataRec.SubType = '1')
  Else If (DataRec.RecPFix = 'K') And (DataRec.SubType = '2') Then
  Begin
    // BnkRDRec : BnkRDRecType - Bank Reconciliation detail
    FBankRecDetailVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'K') And (DataRec.SubType = '2')
  Else If (DataRec.RecPFix = 'K') And (DataRec.SubType = '3') Then
  Begin
    // BACSDbRec : BACSDbRecType - Bank Account details
    FBankAccountVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'K') And (DataRec.SubType = '3')
  Else If (DataRec.RecPFix = 'K') And (DataRec.SubType = '4') Then
  Begin
    // eBankHRec : eBankHRecType - Bank Statement header
    FBankStatementHeaderVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'K') And (DataRec.SubType = '4')
  Else If (DataRec.RecPFix = 'K') And (DataRec.SubType = '5') Then
  Begin
    // eBankLRec : eBankLRecType - Bank Statement line
    FBankStatementLineVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'K') And (DataRec.SubType = '5')
  Else If (DataRec.RecPFix = 'N') And (DataRec.SubType In ['A', '1', '2', '3']) Then
  Begin
    // SdbStkRec : sdbStkType - Alternate Stock Codes
    //
    //   NA   Alternate Stock Codes
    //   N1   Equivalent Stock Codes
    //   N2   SupersededBy Stock Codes
    //   N3   Opportunity Stock Codes
    ///
    FAltStockCodesVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'N') And (DataRec.SubType In ['A', '1', '2', '3'])
  Else If (DataRec.RecPFix = 'P') And (DataRec.SubType = 'D') Then
  Begin
    // PassDefRec : tPassDefType - User Profile Defaults
    FUserProfileVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'P') And (DataRec.SubType = 'D')
  Else If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'K') Then
  Begin
    // TeleSRec : TeleCustType - Telesales
    FTelesalesVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'K')
  Else If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'P') Then
  Begin
    // CuStkRec : CuStkType - Customer Stock Analysis - Normalised to CustomerStockAnalysis table
    FAccountStockAnalysisVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'P')
  Else If (DataRec.RecPFix = 'X') And (DataRec.SubType = 'C') Then
  Begin
    // AllocCRec : AllocCType - Allocation Wizard Session Info - Normalised to AllocWizardSession table
    FAllocWizardSessionVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'X') And (DataRec.SubType = 'C')
  Else
  Begin
    // EN/EA     EMUCnvRec : EMUCnvType - DOS Euro Converter Records
    //
    // These records have been deliberately ignored as they should not be required, the record is not
    // referenced in the Entrprse\r&d\ code and I don't have any examples to code/test against

    // Unknown Data - Log error and continue conversion
    SkipRecord := True;
    sDumpFile := DataPacket.DumpToFile;
    ConversionWarnings.AddWarning(TSQLUnknownVariantWarning.Create (DataPacket, sDumpFile, ToHexString(@DataRec^.RecPFix, 2 {RecMFix + SubType})));
    Logging.UnknownVariant(Trim(DataPacket.CompanyDetails.ccCompanyPath) + DataPacket.TaskDetails.dctPervasiveFilename, ToHexString(@DataRec^.RecPFix, 2 {RecMFix + SubType}), sDumpFile);
  End; // Else
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_LocationVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Location (' +
                                               'loCode, ' +
                                               'loName, ' +
                                               'LoAddr1, ' +
                                               'LoAddr2, ' +
                                               'LoAddr3, ' +
                                               'LoAddr4, ' +
                                               'LoAddr5, ' +
                                               'LoTel, ' +
                                               'LoFax, ' +
                                               'LoEmail, ' +
                                               'LoModem, ' + 
                                               'LoContact, ' + 
                                               'LoCurrency, ' + 
                                               'LoArea, ' + 
                                               'LoRep, ' + 
                                               'LoTag, ' + 
                                               'LoNominal1, ' + 
                                               'LoNominal2, ' + 
                                               'LoNominal3, ' + 
                                               'LoNominal4, ' + 
                                               'LoNominal5, ' + 
                                               'LoNominal6, ' + 
                                               'LoNominal7, ' + 
                                               'LoNominal8, ' + 
                                               'LoNominal9, ' + 
                                               'LoNominal10, ' +
                                               'LoDepartment, ' + 
                                               'LoCostCentre, ' +
                                               'LoUsePrice, ' + 
                                               'LoUseNom, ' + 
                                               'LoUseCCDep, ' + 
                                               'LoUseSupp, ' + 
                                               'LoUseBinLoc, ' + 
                                               'LoNLineCount, ' + 
                                               'LoUseCPrice, ' + 
                                               'LoUseRPrice, ' + 
                                               'LoWOPWIPGL, ' + 
                                               'LoReturnGL, ' + 
                                               'LoPReturnGL' + 
                                               ') ' +
              'VALUES (' + 
                       ':loCode, ' + 
                       ':loName, ' + 
                       ':LoAddr1, ' + 
                       ':LoAddr2, ' + 
                       ':LoAddr3, ' +
                       ':LoAddr4, ' + 
                       ':LoAddr5, ' + 
                       ':LoTel, ' + 
                       ':LoFax, ' + 
                       ':LoEmail, ' + 
                       ':LoModem, ' + 
                       ':LoContact, ' + 
                       ':LoCurrency, ' + 
                       ':LoArea, ' +
                       ':LoRep, ' + 
                       ':LoTag, ' + 
                       ':LoNominal1, ' + 
                       ':LoNominal2, ' + 
                       ':LoNominal3, ' + 
                       ':LoNominal4, ' + 
                       ':LoNominal5, ' + 
                       ':LoNominal6, ' + 
                       ':LoNominal7, ' + 
                       ':LoNominal8, ' + 
                       ':LoNominal9, ' + 
                       ':LoNominal10, ' + 
                       ':LoDepartment, ' + 
                       ':LoCostCentre, ' + 
                       ':LoUsePrice, ' +
                       ':LoUseNom, ' + 
                       ':LoUseCCDep, ' + 
                       ':LoUseSupp, ' + 
                       ':LoUseBinLoc, ' + 
                       ':LoNLineCount, ' + 
                       ':LoUseCPrice, ' +
                       ':LoUseRPrice, ' + 
                       ':LoWOPWIPGL, ' +
                       ':LoReturnGL, ' +
                       ':LoPReturnGL' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    loCodeParam := FindParam('loCode');
    loNameParam := FindParam('loName');
    LoAddr1Param := FindParam('LoAddr1');
    LoAddr2Param := FindParam('LoAddr2');
    LoAddr3Param := FindParam('LoAddr3');
    LoAddr4Param := FindParam('LoAddr4');
    LoAddr5Param := FindParam('LoAddr5');
    LoTelParam := FindParam('LoTel');
    LoFaxParam := FindParam('LoFax');
    LoEmailParam := FindParam('LoEmail');
    LoModemParam := FindParam('LoModem');
    LoContactParam := FindParam('LoContact');
    LoCurrencyParam := FindParam('LoCurrency');
    LoAreaParam := FindParam('LoArea');
    LoRepParam := FindParam('LoRep');
    LoTagParam := FindParam('LoTag');
    LoNominal1Param := FindParam('LoNominal1');
    LoNominal2Param := FindParam('LoNominal2');
    LoNominal3Param := FindParam('LoNominal3');
    LoNominal4Param := FindParam('LoNominal4');
    LoNominal5Param := FindParam('LoNominal5');
    LoNominal6Param := FindParam('LoNominal6');
    LoNominal7Param := FindParam('LoNominal7');
    LoNominal8Param := FindParam('LoNominal8');
    LoNominal9Param := FindParam('LoNominal9');
    LoNominal10Param := FindParam('LoNominal10');
    LoDepartmentParam := FindParam('LoDepartment');
    LoCostCentreParam := FindParam('LoCostCentre');
    LoUsePriceParam := FindParam('LoUsePrice');
    LoUseNomParam := FindParam('LoUseNom');
    LoUseCCDepParam := FindParam('LoUseCCDep');
    LoUseSuppParam := FindParam('LoUseSupp');
    LoUseBinLocParam := FindParam('LoUseBinLoc');
    LoNLineCountParam := FindParam('LoNLineCount');
    LoUseCPriceParam := FindParam('LoUseCPrice');
    LoUseRPriceParam := FindParam('LoUseRPrice');
    LoWOPWIPGLParam := FindParam('LoWOPWIPGL');
    LoReturnGLParam := FindParam('LoReturnGL');
    LoPReturnGLParam := FindParam('LoPReturnGL');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_LocationVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^.MLocLoc Do
  Begin
    loCodeParam.Value := loCode;                       // SQL=varchar, Delphi=String[10]
    loNameParam.Value := loName;                       // SQL=varchar, Delphi=String[45]
    LoAddr1Param.Value := loAddr[1];                   // SQL=varchar, Delphi=String[30]
    LoAddr2Param.Value := loAddr[2];                   // SQL=varchar, Delphi=String[30]
    LoAddr3Param.Value := loAddr[3];                   // SQL=varchar, Delphi=String[30]
    LoAddr4Param.Value := loAddr[4];                   // SQL=varchar, Delphi=String[30]
    LoAddr5Param.Value := loAddr[5];                   // SQL=varchar, Delphi=String[30]
    LoTelParam.Value := loTel;                         // SQL=varchar, Delphi=String[25]
    LoFaxParam.Value := loFax;                         // SQL=varchar, Delphi=String[25]
    LoEmailParam.Value := loemail;                     // SQL=varchar, Delphi=String[100]
    LoModemParam.Value := loModem;                     // SQL=varchar, Delphi=String[25]
    LoContactParam.Value := loContact;                 // SQL=varchar, Delphi=String[30]
    LoCurrencyParam.Value := loCurrency;               // SQL=int, Delphi=Byte
    LoAreaParam.Value := loArea;                       // SQL=varchar, Delphi=String[5]
    LoRepParam.Value := loRep;                         // SQL=varchar, Delphi=String[5]
    LoTagParam.Value := loTag;                         // SQL=bit, Delphi=Boolean
    LoNominal1Param.Value := loNominal[1];             // SQL=int, Delphi=LongInt
    LoNominal2Param.Value := loNominal[2];             // SQL=int, Delphi=LongInt
    LoNominal3Param.Value := loNominal[3];             // SQL=int, Delphi=LongInt
    LoNominal4Param.Value := loNominal[4];             // SQL=int, Delphi=LongInt
    LoNominal5Param.Value := loNominal[5];             // SQL=int, Delphi=LongInt
    LoNominal6Param.Value := loNominal[6];             // SQL=int, Delphi=LongInt
    LoNominal7Param.Value := loNominal[7];             // SQL=int, Delphi=LongInt
    LoNominal8Param.Value := loNominal[8];             // SQL=int, Delphi=LongInt
    LoNominal9Param.Value := loNominal[9];             // SQL=int, Delphi=LongInt
    LoNominal10Param.Value := loNominal[10];           // SQL=int, Delphi=LongInt
    LoDepartmentParam.Value := loCCDep[False];         // SQL=varchar, Delphi=String[3]
    LoCostCentreParam.Value := loCCDep[True];          // SQL=varchar, Delphi=String[3]
    LoUsePriceParam.Value := loUsePrice;               // SQL=bit, Delphi=Boolean
    LoUseNomParam.Value := loUseNom;                   // SQL=bit, Delphi=Boolean
    LoUseCCDepParam.Value := loUseCCDep;               // SQL=bit, Delphi=Boolean
    LoUseSuppParam.Value := loUseSupp;                 // SQL=bit, Delphi=Boolean
    LoUseBinLocParam.Value := loUseBinLoc;             // SQL=bit, Delphi=Boolean
    LoNLineCountParam.Value := loNLineCount;           // SQL=int, Delphi=LongInt
    LoUseCPriceParam.Value := loUseCPrice;             // SQL=bit, Delphi=Boolean
    LoUseRPriceParam.Value := loUseRPrice;             // SQL=bit, Delphi=Boolean
    LoWOPWIPGLParam.Value := loWOPWIPGL;               // SQL=int, Delphi=LongInt
    LoReturnGLParam.Value := loReturnGL;               // SQL=int, Delphi=LongInt
    LoPReturnGLParam.Value := loPReturnGL;             // SQL=int, Delphi=LongInt
  End; // With DataRec^.MLocLoc
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_StockLocationVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].StockLocation (' +
                                                    'LsStkCode, ' +
                                                    'LsStkFolio, ' +
                                                    'LsLocCode, ' +
                                                    'LsQtyInStock, ' +
                                                    'LsQtyOnOrder, ' +
                                                    'LsQtyAlloc, ' +
                                                    'LsQtyPicked, ' +
                                                    'LsQtyMin, ' +
                                                    'LsQtyMax, ' +
                                                    'LsQtyFreeze, ' +
                                                    'LsRoQty, ' +
                                                    'LsRoDate, ' +
                                                    'LsRoDepartment, ' +
                                                    'LsRoCostCentre, ' +
                                                    'LsDepartment, ' +
                                                    'LsCostCentre, ' +
                                                    'LsBinLoc, ' +
                                                    'Currency1, ' +
                                                    'SalesPrice1, ' +
                                                    'Currency2, ' +
                                                    'SalesPrice2, ' +
                                                    'Currency3, ' +
                                                    'SalesPrice3, ' +
                                                    'Currency4, ' +
                                                    'SalesPrice4, ' +
                                                    'Currency5, ' +
                                                    'SalesPrice5, ' +
                                                    'Currency6, ' +
                                                    'SalesPrice6, ' +
                                                    'Currency7, ' +
                                                    'SalesPrice7, ' +
                                                    'Currency8, ' +
                                                    'SalesPrice8, ' +
                                                    'Currency9, ' +
                                                    'SalesPrice9, ' +
                                                    'Currency10, ' +
                                                    'SalesPrice10, ' +
                                                    'LsRoPrice, ' +
                                                    'LsRoCurrency, ' +
                                                    'LsCostPrice, ' +
                                                    'LsPCurrency, ' +
                                                    'LsDefNom1, ' +
                                                    'LsDefNom2, ' +
                                                    'LsDefNom3, ' +
                                                    'LsDefNom4, ' +
                                                    'LsDefNom5, ' +
                                                    'LsDefNom6, ' +
                                                    'LsDefNom7, ' +
                                                    'LsDefNom8, ' +
                                                    'LsDefNom9, ' +
                                                    'LsDefNom10, ' +
                                                    'LsStkFlg, ' +
                                                    'LsMinFlg, ' +
                                                    'LsTempSupp, ' +
                                                    'LsSupplier, ' +
                                                    'LsLastUsed, ' +
                                                    'LsQtyPosted, ' +
                                                    'LsQtyTake, ' +
                                                    'LsROFlg, ' +
                                                    'LsLastTime, ' +
                                                    'LsQtyAllocWOR, ' +
                                                    'LsQtyIssueWOR, ' +
                                                    'LsQtyPickWOR, ' +
                                                    'LsWOPWIPGL, ' +
                                                    'LsSWarranty, ' +
                                                    'LsSWarrantyType, ' +
                                                    'LsMWarranty, ' +
                                                    'LsMWarrantyType, ' +
                                                    'LsQtyPReturn, ' +
                                                    'LsReturnGL, ' +
                                                    'LsReStockPcnt, ' +
                                                    'LsReStockGL, ' +
                                                    'LsBOMDedComp, ' +
                                                    'LsQtyReturn, ' +
                                                    'LsPReturnGL' +
                                                    ') ' +
              'VALUES (' +
                       ':LsStkCode, ' +
                       ':LsStkFolio, ' +
                       ':LsLocCode, ' +
                       ':LsQtyInStock, ' +
                       ':LsQtyOnOrder, ' +
                       ':LsQtyAlloc, ' +
                       ':LsQtyPicked, ' +
                       ':LsQtyMin, ' +
                       ':LsQtyMax, ' +
                       ':LsQtyFreeze, ' +
                       ':LsRoQty, ' +
                       ':LsRoDate, ' +
                       ':LsRoDepartment, ' +
                       ':LsRoCostCentre, ' +
                       ':LsDepartment, ' +
                       ':LsCostCentre, ' +
                       ':LsBinLoc, ' +
                       ':Currency1, ' +
                       ':SalesPrice1, ' +
                       ':Currency2, ' +
                       ':SalesPrice2, ' +
                       ':Currency3, ' +
                       ':SalesPrice3, ' +
                       ':Currency4, ' +
                       ':SalesPrice4, ' +
                       ':Currency5, ' +
                       ':SalesPrice5, ' +
                       ':Currency6, ' +
                       ':SalesPrice6, ' +
                       ':Currency7, ' +
                       ':SalesPrice7, ' +
                       ':Currency8, ' +
                       ':SalesPrice8, ' +
                       ':Currency9, ' +
                       ':SalesPrice9, ' +
                       ':Currency10, ' +
                       ':SalesPrice10, ' +
                       ':LsRoPrice, ' +
                       ':LsRoCurrency, ' +
                       ':LsCostPrice, ' +
                       ':LsPCurrency, ' +
                       ':LsDefNom1, ' +
                       ':LsDefNom2, ' +
                       ':LsDefNom3, ' +
                       ':LsDefNom4, ' +
                       ':LsDefNom5, ' +
                       ':LsDefNom6, ' +
                       ':LsDefNom7, ' +
                       ':LsDefNom8, ' +
                       ':LsDefNom9, ' +
                       ':LsDefNom10, ' +
                       ':LsStkFlg, ' +
                       ':LsMinFlg, ' +
                       ':LsTempSupp, ' +
                       ':LsSupplier, ' +
                       ':LsLastUsed, ' +
                       ':LsQtyPosted, ' +
                       ':LsQtyTake, ' +
                       ':LsROFlg, ' +
                       ':LsLastTime, ' +
                       ':LsQtyAllocWOR, ' +
                       ':LsQtyIssueWOR, ' +
                       ':LsQtyPickWOR, ' +
                       ':LsWOPWIPGL, ' +
                       ':LsSWarranty, ' +
                       ':LsSWarrantyType, ' +
                       ':LsMWarranty, ' +
                       ':LsMWarrantyType, ' +
                       ':LsQtyPReturn, ' +
                       ':LsReturnGL, ' +
                       ':LsReStockPcnt, ' +
                       ':LsReStockGL, ' +
                       ':LsBOMDedComp, ' +
                       ':LsQtyReturn, ' +
                       ':LsPReturnGL' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    LsStkCodeParam := FindParam('LsStkCode');
    LsStkFolioParam := FindParam('LsStkFolio');
    LsLocCodeParam := FindParam('LsLocCode');
    LsQtyInStockParam := FindParam('LsQtyInStock');
    LsQtyOnOrderParam := FindParam('LsQtyOnOrder');
    LsQtyAllocParam := FindParam('LsQtyAlloc');
    LsQtyPickedParam := FindParam('LsQtyPicked');
    LsQtyMinParam := FindParam('LsQtyMin');
    LsQtyMaxParam := FindParam('LsQtyMax');
    LsQtyFreezeParam := FindParam('LsQtyFreeze');
    LsRoQtyParam := FindParam('LsRoQty');
    LsRoDateParam := FindParam('LsRoDate');
    LsRoDepartmentParam := FindParam('LsRoDepartment');
    LsRoCostCentreParam := FindParam('LsRoCostCentre');
    LsDepartmentParam := FindParam('LsDepartment');
    LsCostCentreParam := FindParam('LsCostCentre');
    LsBinLocParam := FindParam('LsBinLoc');
    Currency1Param := FindParam('Currency1');
    SalesPrice1Param := FindParam('SalesPrice1');
    Currency2Param := FindParam('Currency2');
    SalesPrice2Param := FindParam('SalesPrice2');
    Currency3Param := FindParam('Currency3');
    SalesPrice3Param := FindParam('SalesPrice3');
    Currency4Param := FindParam('Currency4');
    SalesPrice4Param := FindParam('SalesPrice4');
    Currency5Param := FindParam('Currency5');
    SalesPrice5Param := FindParam('SalesPrice5');
    Currency6Param := FindParam('Currency6');
    SalesPrice6Param := FindParam('SalesPrice6');
    Currency7Param := FindParam('Currency7');
    SalesPrice7Param := FindParam('SalesPrice7');
    Currency8Param := FindParam('Currency8');
    SalesPrice8Param := FindParam('SalesPrice8');
    Currency9Param := FindParam('Currency9');
    SalesPrice9Param := FindParam('SalesPrice9');
    Currency10Param := FindParam('Currency10');
    SalesPrice10Param := FindParam('SalesPrice10');
    LsRoPriceParam := FindParam('LsRoPrice');
    LsRoCurrencyParam := FindParam('LsRoCurrency');
    LsCostPriceParam := FindParam('LsCostPrice');
    LsPCurrencyParam := FindParam('LsPCurrency');
    LsDefNom1Param := FindParam('LsDefNom1');
    LsDefNom2Param := FindParam('LsDefNom2');
    LsDefNom3Param := FindParam('LsDefNom3');
    LsDefNom4Param := FindParam('LsDefNom4');
    LsDefNom5Param := FindParam('LsDefNom5');
    LsDefNom6Param := FindParam('LsDefNom6');
    LsDefNom7Param := FindParam('LsDefNom7');
    LsDefNom8Param := FindParam('LsDefNom8');
    LsDefNom9Param := FindParam('LsDefNom9');
    LsDefNom10Param := FindParam('LsDefNom10');
    LsStkFlgParam := FindParam('LsStkFlg');
    LsMinFlgParam := FindParam('LsMinFlg');
    LsTempSuppParam := FindParam('LsTempSupp');
    LsSupplierParam := FindParam('LsSupplier');
    LsLastUsedParam := FindParam('LsLastUsed');
    LsQtyPostedParam := FindParam('LsQtyPosted');
    LsQtyTakeParam := FindParam('LsQtyTake');
    LsROFlgParam := FindParam('LsROFlg');
    LsLastTimeParam := FindParam('LsLastTime');
    LsQtyAllocWORParam := FindParam('LsQtyAllocWOR');
    LsQtyIssueWORParam := FindParam('LsQtyIssueWOR');
    LsQtyPickWORParam := FindParam('LsQtyPickWOR');
    LsWOPWIPGLParam := FindParam('LsWOPWIPGL');
    LsSWarrantyParam := FindParam('LsSWarranty');
    LsSWarrantyTypeParam := FindParam('LsSWarrantyType');
    LsMWarrantyParam := FindParam('LsMWarranty');
    LsMWarrantyTypeParam := FindParam('LsMWarrantyType');
    LsQtyPReturnParam := FindParam('LsQtyPReturn');
    LsReturnGLParam := FindParam('LsReturnGL');
    LsReStockPcntParam := FindParam('LsReStockPcnt');
    LsReStockGLParam := FindParam('LsReStockGL');
    LsBOMDedCompParam := FindParam('LsBOMDedComp');
    LsQtyReturnParam := FindParam('LsQtyReturn');
    LsPReturnGLParam := FindParam('LsPReturnGL');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_StockLocationVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^.MStkLoc Do
  Begin
    LsStkCodeParam.Value := lsStkCode;                             // SQL=varchar, Delphi=String[20]
    LsStkFolioParam.Value := lsStkFolio;                           // SQL=int, Delphi=LongInt
    LsLocCodeParam.Value := lsLocCode;                             // SQL=varchar, Delphi=String[10]
    LsQtyInStockParam.Value := lsQtyInStock;                       // SQL=float, Delphi=Double
    LsQtyOnOrderParam.Value := lsQtyOnOrder;                       // SQL=float, Delphi=Double
    LsQtyAllocParam.Value := lsQtyAlloc;                           // SQL=float, Delphi=Double
    LsQtyPickedParam.Value := lsQtyPicked;                         // SQL=float, Delphi=Double
    LsQtyMinParam.Value := lsQtyMin;                               // SQL=float, Delphi=Double
    LsQtyMaxParam.Value := lsQtyMax;                               // SQL=float, Delphi=Double
    LsQtyFreezeParam.Value := lsQtyFreeze;                         // SQL=float, Delphi=Double
    LsRoQtyParam.Value := lsRoQty;                                 // SQL=float, Delphi=Double
    LsRoDateParam.Value := lsRoDate;                               // SQL=varchar, Delphi=LongDate
    LsRoDepartmentParam.Value := lsRoCCDep[False];                 // SQL=varchar, Delphi=String[3]
    LsRoCostCentreParam.Value := lsRoCCDep[True];                  // SQL=varchar, Delphi=String[3]
    LsDepartmentParam.Value := lsCCDep[False];                     // SQL=varchar, Delphi=String[3]
    LsCostCentreParam.Value := lsCCDep[True];                      // SQL=varchar, Delphi=String[3]
    LsBinLocParam.Value := lsBinLoc;                               // SQL=varchar, Delphi=String[10]
    Currency1Param.Value := lsSaleBands[1].Currency;               // SQL=int, Delphi=Byte
    SalesPrice1Param.Value := lsSaleBands[1].SalesPrice;           // SQL=float, Delphi=Real
    Currency2Param.Value := lsSaleBands[2].Currency;               // SQL=int, Delphi=Byte
    SalesPrice2Param.Value := lsSaleBands[2].SalesPrice;           // SQL=float, Delphi=Real
    Currency3Param.Value := lsSaleBands[3].Currency;               // SQL=int, Delphi=Byte
    SalesPrice3Param.Value := lsSaleBands[3].SalesPrice;           // SQL=float, Delphi=Real
    Currency4Param.Value := lsSaleBands[4].Currency;               // SQL=int, Delphi=Byte
    SalesPrice4Param.Value := lsSaleBands[4].SalesPrice;           // SQL=float, Delphi=Real
    Currency5Param.Value := lsSaleBands[5].Currency;               // SQL=int, Delphi=Byte
    SalesPrice5Param.Value := lsSaleBands[5].SalesPrice;           // SQL=float, Delphi=Real
    Currency6Param.Value := lsSaleBands[6].Currency;               // SQL=int, Delphi=Byte
    SalesPrice6Param.Value := lsSaleBands[6].SalesPrice;           // SQL=float, Delphi=Real
    Currency7Param.Value := lsSaleBands[7].Currency;               // SQL=int, Delphi=Byte
    SalesPrice7Param.Value := lsSaleBands[7].SalesPrice;           // SQL=float, Delphi=Real
    Currency8Param.Value := lsSaleBands[8].Currency;               // SQL=int, Delphi=Byte
    SalesPrice8Param.Value := lsSaleBands[8].SalesPrice;           // SQL=float, Delphi=Real
    Currency9Param.Value := lsSaleBands[9].Currency;               // SQL=int, Delphi=Byte
    SalesPrice9Param.Value := lsSaleBands[9].SalesPrice;           // SQL=float, Delphi=Real
    Currency10Param.Value := lsSaleBands[10].Currency;             // SQL=int, Delphi=Byte
    SalesPrice10Param.Value := lsSaleBands[10].SalesPrice;         // SQL=float, Delphi=Real
    LsRoPriceParam.Value := lsRoPrice;                             // SQL=float, Delphi=Double
    LsRoCurrencyParam.Value := lsRoCurrency;                       // SQL=int, Delphi=Byte
    LsCostPriceParam.Value := lsCostPrice;                         // SQL=float, Delphi=Double
    LsPCurrencyParam.Value := lsPCurrency;                         // SQL=int, Delphi=Byte
    LsDefNom1Param.Value := lsDefNom[1];                           // SQL=int, Delphi=LongInt
    LsDefNom2Param.Value := lsDefNom[2];                           // SQL=int, Delphi=LongInt
    LsDefNom3Param.Value := lsDefNom[3];                           // SQL=int, Delphi=LongInt
    LsDefNom4Param.Value := lsDefNom[4];                           // SQL=int, Delphi=LongInt
    LsDefNom5Param.Value := lsDefNom[5];                           // SQL=int, Delphi=LongInt
    LsDefNom6Param.Value := lsDefNom[6];                           // SQL=int, Delphi=LongInt
    LsDefNom7Param.Value := lsDefNom[7];                           // SQL=int, Delphi=LongInt
    LsDefNom8Param.Value := lsDefNom[8];                           // SQL=int, Delphi=LongInt
    LsDefNom9Param.Value := lsDefNom[9];                           // SQL=int, Delphi=LongInt
    LsDefNom10Param.Value := lsDefNom[10];                         // SQL=int, Delphi=LongInt
    LsStkFlgParam.Value := lsStkFlg;                               // SQL=bit, Delphi=Boolean
    LsMinFlgParam.Value := lsMinFlg;                               // SQL=bit, Delphi=Boolean
    LsTempSuppParam.Value := lsTempSupp;                           // SQL=varchar, Delphi=String[10]
    LsSupplierParam.Value := lsSupplier;                           // SQL=varchar, Delphi=String[10]
    LsLastUsedParam.Value := lsLastUsed;                           // SQL=varchar, Delphi=LongDate
    LsQtyPostedParam.Value := lsQtyPosted;                         // SQL=float, Delphi=Double
    LsQtyTakeParam.Value := lsQtyTake;                             // SQL=float, Delphi=Double
    LsROFlgParam.Value := lsROFlg;                                 // SQL=bit, Delphi=Boolean
    LsLastTimeParam.Value := lsLastTime;                           // SQL=varchar, Delphi=String[6]
    LsQtyAllocWORParam.Value := lsQtyAllocWOR;                     // SQL=float, Delphi=Double
    LsQtyIssueWORParam.Value := lsQtyIssueWOR;                     // SQL=float, Delphi=Double
    LsQtyPickWORParam.Value := lsQtyPickWOR;                       // SQL=float, Delphi=Double
    LsWOPWIPGLParam.Value := lsWOPWIPGL;                           // SQL=int, Delphi=LongInt
    LsSWarrantyParam.Value := lsSWarranty;                         // SQL=int, Delphi=Byte
    LsSWarrantyTypeParam.Value := lsSWarrantyType;                 // SQL=int, Delphi=Byte
    LsMWarrantyParam.Value := lsMWarranty;                         // SQL=int, Delphi=Byte
    LsMWarrantyTypeParam.Value := lsMWarrantyType;                 // SQL=int, Delphi=Byte
    LsQtyPReturnParam.Value := lsQtyPReturn;                       // SQL=float, Delphi=Double
    LsReturnGLParam.Value := lsReturnGL;                           // SQL=int, Delphi=LongInt
    LsReStockPcntParam.Value := lsReStockPcnt;                     // SQL=float, Delphi=Double
    LsReStockGLParam.Value := lsReStockGL;                         // SQL=int, Delphi=LongInt
    LsBOMDedCompParam.Value := lsBOMDedComp;                       // SQL=bit, Delphi=Boolean
    LsQtyReturnParam.Value := lsQtyReturn;                         // SQL=float, Delphi=Double
    LsPReturnGLParam.Value := lsPReturnGL;                         // SQL=int, Delphi=LongInt
  End; // With DataRec^.MStkLoc
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_BinVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'varCode1, ' + 
                                              'varCode2, ' + 
                                              'varCode3, ' + 
                                              'BrInDoc, ' + 
                                              'BrOutDoc, ' + 
                                              'BrSold, ' + 
                                              'BrDateIn, ' + 
                                              'BrBinCost, ' + 
                                              'BrBinCap, ' + 
                                              'Spare5, ' + 
                                              'BrStkFolio, ' + 
                                              'BrDateOut, ' + 
                                              'BrSoldLine, ' + 
                                              'BrBuyLine, ' + 
                                              'BrBatchRec, ' + 
                                              'BrBuyQty, ' + 
                                              'BrQtyUsed, ' + 
                                              'BrBatchChild, ' + 
                                              'BrInMLoc, ' + 
                                              'BrOutMLoc, ' +
                                              'BrOutOrdDoc, ' + 
                                              'BrInOrdDoc, ' + 
                                              'BrInOrdLine, ' + 
                                              'BrOutOrdLine, ' + 
                                              'BrCurCost, ' + 
                                              'BrPriority, ' + 
                                              'BrBinSell, ' +
                                              'brSerCompanyRate, ' +
                                              'brSerDailyRate, ' + 
                                              'BrSUseORate, ' +
                                              'brSerTriRates, ' + 
                                              'brSerTriEuro, ' + 
                                              'brSerTriInvert, ' + 
                                              'brSerTriFloat, ' + 
                                              'brSerSpare, ' + 
                                              'BrDateUseX, ' + 
                                              'BrCurSell, ' + 
                                              'BrUOM, ' + 
                                              'BrHoldFlg, ' + 
                                              'BrTagNo, ' + 
                                              'BrReturnBin' + 
                                              ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':varCode1, ' + 
                       ':varCode2, ' + 
                       ':varCode3, ' + 
                       ':BrInDoc, ' + 
                       ':BrOutDoc, ' + 
                       ':BrSold, ' + 
                       ':BrDateIn, ' + 
                       ':BrBinCost, ' + 
                       ':BrBinCap, ' + 
                       ':Spare5, ' + 
                       ':BrStkFolio, ' + 
                       ':BrDateOut, ' +
                       ':BrSoldLine, ' +
                       ':BrBuyLine, ' + 
                       ':BrBatchRec, ' +
                       ':BrBuyQty, ' + 
                       ':BrQtyUsed, ' + 
                       ':BrBatchChild, ' + 
                       ':BrInMLoc, ' + 
                       ':BrOutMLoc, ' + 
                       ':BrOutOrdDoc, ' + 
                       ':BrInOrdDoc, ' + 
                       ':BrInOrdLine, ' + 
                       ':BrOutOrdLine, ' + 
                       ':BrCurCost, ' + 
                       ':BrPriority, ' + 
                       ':BrBinSell, ' + 
                       ':brSerCompanyRate, ' + 
                       ':brSerDailyRate, ' + 
                       ':BrSUseORate, ' + 
                       ':brSerTriRates, ' + 
                       ':brSerTriEuro, ' + 
                       ':brSerTriInvert, ' + 
                       ':brSerTriFloat, ' + 
                       ':brSerSpare, ' +
                       ':BrDateUseX, ' + 
                       ':BrCurSell, ' + 
                       ':BrUOM, ' + 
                       ':BrHoldFlg, ' + 
                       ':BrTagNo, ' + 
                       ':BrReturnBin' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');
    BrInDocParam := FindParam('BrInDoc');
    BrOutDocParam := FindParam('BrOutDoc');
    BrSoldParam := FindParam('BrSold');
    BrDateInParam := FindParam('BrDateIn');
    BrBinCostParam := FindParam('BrBinCost');
    BrBinCapParam := FindParam('BrBinCap');
    Spare5Param := FindParam('Spare5');
    BrStkFolioParam := FindParam('BrStkFolio');
    BrDateOutParam := FindParam('BrDateOut');
    BrSoldLineParam := FindParam('BrSoldLine');
    BrBuyLineParam := FindParam('BrBuyLine');
    BrBatchRecParam := FindParam('BrBatchRec');
    BrBuyQtyParam := FindParam('BrBuyQty');
    BrQtyUsedParam := FindParam('BrQtyUsed');
    BrBatchChildParam := FindParam('BrBatchChild');
    BrInMLocParam := FindParam('BrInMLoc');
    BrOutMLocParam := FindParam('BrOutMLoc');
    BrOutOrdDocParam := FindParam('BrOutOrdDoc');
    BrInOrdDocParam := FindParam('BrInOrdDoc');
    BrInOrdLineParam := FindParam('BrInOrdLine');
    BrOutOrdLineParam := FindParam('BrOutOrdLine');
    BrCurCostParam := FindParam('BrCurCost');
    BrPriorityParam := FindParam('BrPriority');
    BrBinSellParam := FindParam('BrBinSell');
    brSerCompanyRateParam := FindParam('brSerCompanyRate');
    brSerDailyRateParam := FindParam('brSerDailyRate');
    BrSUseORateParam := FindParam('BrSUseORate');
    brSerTriRatesParam := FindParam('brSerTriRates');
    brSerTriEuroParam := FindParam('brSerTriEuro');
    brSerTriInvertParam := FindParam('brSerTriInvert');
    brSerTriFloatParam := FindParam('brSerTriFloat');
    brSerSpareParam := FindParam('brSerSpare');
    BrDateUseXParam := FindParam('BrDateUseX');
    BrCurSellParam := FindParam('BrCurSell');
    BrUOMParam := FindParam('BrUOM');
    BrHoldFlgParam := FindParam('BrHoldFlg');
    BrTagNoParam := FindParam('BrTagNo');
    BrReturnBinParam := FindParam('BrReturnBin');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_BinVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, brBinRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                   // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                   // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@brBinCode1, SizeOf(brBinCode1));      // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@brCode2, SizeOf(brCode2));            // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@brCode3, SizeOf(brCode3));            // SQL=varbinary, Delphi=String[31]

    BrInDocParam.Value := brInDoc;                                                              // SQL=varchar, Delphi=String[10]
    BrOutDocParam.Value := brOutDoc;                                                            // SQL=varchar, Delphi=String[10]
    BrSoldParam.Value := brSold;                                                                // SQL=bit, Delphi=Boolean
    BrDateInParam.Value := brDateIn;                                                            // SQL=varchar, Delphi=LongDate
    BrBinCostParam.Value := brBinCost;                                                          // SQL=float, Delphi=Double
    BrBinCapParam.Value := brBinCap;                                                            // SQL=float, Delphi=Double
    Spare5Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));                          // SQL=varbinary, Delphi=Byte
    BrStkFolioParam.Value := brStkFolio;                                                        // SQL=int, Delphi=LongInt
    BrDateOutParam.Value := brDateOut;                                                          // SQL=varchar, Delphi=LongDate
    BrSoldLineParam.Value := brSoldLine;                                                        // SQL=int, Delphi=LongInt
    BrBuyLineParam.Value := brBuyLine;                                                          // SQL=int, Delphi=LongInt
    BrBatchRecParam.Value := brBatchRec;                                                        // SQL=bit, Delphi=Boolean
    BrBuyQtyParam.Value := brBuyQty;                                                            // SQL=float, Delphi=Double
    BrQtyUsedParam.Value := brQtyUsed;                                                          // SQL=float, Delphi=Double
    BrBatchChildParam.Value := brBatchChild;                                                    // SQL=bit, Delphi=Boolean
    BrInMLocParam.Value := brInMLoc;                                                            // SQL=varchar, Delphi=String[10]
    BrOutMLocParam.Value := brOutMLoc;                                                          // SQL=varchar, Delphi=String[10]
    BrOutOrdDocParam.Value := brOutOrdDoc;                                                      // SQL=varchar, Delphi=String[10]
    BrInOrdDocParam.Value := brInOrdDoc;                                                        // SQL=varchar, Delphi=String[10]
    BrInOrdLineParam.Value := brInOrdLine;                                                      // SQL=int, Delphi=LongInt
    BrOutOrdLineParam.Value := brOutOrdLine;                                                    // SQL=int, Delphi=LongInt
    BrCurCostParam.Value := brCurCost;                                                          // SQL=int, Delphi=Byte
    BrPriorityParam.Value := brPriority;                                                        // SQL=varchar, Delphi=String[10]
    BrBinSellParam.Value := brBinSell;                                                          // SQL=float, Delphi=Double
    brSerCompanyRateParam.Value := brSerCRates[False];                                          // SQL=float, Delphi=Real48
    brSerDailyRateParam.Value := brSerCRates[True];                                             // SQL=float, Delphi=Real48
    BrSUseORateParam.Value := brSUseORate;                                                      // SQL=int, Delphi=Byte
    brSerTriRatesParam.Value := brSerTriR.TriRates;                                             // SQL=float, Delphi=Double
    brSerTriEuroParam.Value := brSerTriR.TriEuro;                                               // SQL=int, Delphi=Byte
    brSerTriInvertParam.Value := brSerTriR.TriInvert;                                           // SQL=bit, Delphi=Boolean
    brSerTriFloatParam.Value := brSerTriR.TriFloat;                                             // SQL=bit, Delphi=Boolean
    brSerSpareParam.Value := CreateVariantArray (@brSerTriR.Spare, SizeOf(brSerTriR.Spare));    // SQL=varbinary, Delphi=Array[1..10] of Byte
    BrDateUseXParam.Value := brDateUseX;                                                        // SQL=varchar, Delphi=LongDate
    BrCurSellParam.Value := brCurSell;                                                          // SQL=int, Delphi=Byte
    BrUOMParam.Value := brUOM;                                                                  // SQL=varchar, Delphi=String[10]
    BrHoldFlgParam.Value := brHoldFlg;                                                          // SQL=int, Delphi=Byte
    BrTagNoParam.Value := brTagNo;                                                              // SQL=int, Delphi=Byte
    BrReturnBinParam.Value := brReturnBin;                                                      // SQL=bit, Delphi=Boolean
  End; // With DataRec^, brBinRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_BankRecDetailVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'varCode1, ' + 
                                              'varCode2, ' +
                                              'varCode3, ' + 
                                              'BrPayRef, ' +
                                              'BrLineDate, ' + 
                                              'BrMatchRef, ' + 
                                              'BrValue, ' +
                                              'BrLineNo, ' + 
                                              'BrStatId, ' + 
                                              'BrStatLine, ' + 
                                              'BrCustCode, ' + 
                                              'BrPeriod, ' +
                                              'BrYear, ' + 
                                              'brCompanyRate, ' + 
                                              'brDailyRate, ' + 
                                              'BrLUseORate, ' + 
                                              'brCurTriRate, ' + 
                                              'brCurTriEuro, ' + 
                                              'brCurTriInvert, ' + 
                                              'brCurTriFloat, ' + 
                                              'brCurSpare, ' + 
                                              'BrOldYourRef, ' + 
                                              'BrTransValue, ' + 
                                              'BrDepartment, ' + 
                                              'BrCostCentre, ' + 
                                              'BrNomCode, ' + 
                                              'BrSRINomCode, ' + 
                                              'BrFolioLink, ' + 
                                              'BrVATCode, ' + 
                                              'BrVATAmount, ' + 
                                              'BrTransDate, ' + 
                                              'BrIsNewTrans, ' + 
                                              'BrLineStatus, ' + 
                                              'Spare6, ' +
                                              'BrYourRef' + 
                                              ') ' + 
              'VALUES (' +
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':varCode1, ' + 
                       ':varCode2, ' + 
                       ':varCode3, ' +
                       ':BrPayRef, ' + 
                       ':BrLineDate, ' + 
                       ':BrMatchRef, ' + 
                       ':BrValue, ' + 
                       ':BrLineNo, ' + 
                       ':BrStatId, ' + 
                       ':BrStatLine, ' + 
                       ':BrCustCode, ' + 
                       ':BrPeriod, ' + 
                       ':BrYear, ' + 
                       ':brCompanyRate, ' + 
                       ':brDailyRate, ' + 
                       ':BrLUseORate, ' + 
                       ':brCurTriRate, ' + 
                       ':brCurTriEuro, ' + 
                       ':brCurTriInvert, ' + 
                       ':brCurTriFloat, ' + 
                       ':brCurSpare, ' + 
                       ':BrOldYourRef, ' + 
                       ':BrTransValue, ' +
                       ':BrDepartment, ' + 
                       ':BrCostCentre, ' +
                       ':BrNomCode, ' + 
                       ':BrSRINomCode, ' + 
                       ':BrFolioLink, ' +
                       ':BrVATCode, ' + 
                       ':BrVATAmount, ' + 
                       ':BrTransDate, ' + 
                       ':BrIsNewTrans, ' + 
                       ':BrLineStatus, ' + 
                       ':Spare6, ' + 
                       ':BrYourRef' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    BrPayRefParam := FindParam('BrPayRef');
    BrLineDateParam := FindParam('BrLineDate');
    BrMatchRefParam := FindParam('BrMatchRef');
    BrValueParam := FindParam('BrValue');
    BrLineNoParam := FindParam('BrLineNo');
    BrStatIdParam := FindParam('BrStatId');
    BrStatLineParam := FindParam('BrStatLine');
    BrCustCodeParam := FindParam('BrCustCode');
    BrPeriodParam := FindParam('BrPeriod');
    BrYearParam := FindParam('BrYear');
    brCompanyRateParam := FindParam('brCompanyRate');
    brDailyRateParam := FindParam('brDailyRate');
    BrLUseORateParam := FindParam('BrLUseORate');
    brCurTriRateParam := FindParam('brCurTriRate');
    brCurTriEuroParam := FindParam('brCurTriEuro');
    brCurTriInvertParam := FindParam('brCurTriInvert');
    brCurTriFloatParam := FindParam('brCurTriFloat');
    brCurSpareParam := FindParam('brCurSpare');
    BrOldYourRefParam := FindParam('BrOldYourRef');
    BrTransValueParam := FindParam('BrTransValue');
    BrDepartmentParam := FindParam('BrDepartment');
    BrCostCentreParam := FindParam('BrCostCentre');
    BrNomCodeParam := FindParam('BrNomCode');
    BrSRINomCodeParam := FindParam('BrSRINomCode');
    BrFolioLinkParam := FindParam('BrFolioLink');
    BrVATCodeParam := FindParam('BrVATCode');
    BrVATAmountParam := FindParam('BrVATAmount');
    BrTransDateParam := FindParam('BrTransDate');
    BrIsNewTransParam := FindParam('BrIsNewTrans');
    BrLineStatusParam := FindParam('BrLineStatus');
    Spare6Param := FindParam('Spare6');
    BrYourRefParam := FindParam('BrYourRef');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_BankRecDetailVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, BnkRDRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                   // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                   // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@brBnkDCode1, SizeOf(brBnkDCode1));    // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@brBnkDCode2, SizeOf(brBnkDCode2));    // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@brBnkDCode3, SizeOf(brBnkDCode3));    // SQL=varbinary, Delphi=String[31]

    BrPayRefParam.Value := CreateVariantArray (@brPayRef, SizeOf(brPayRef));                   // SQL=varbinary, Delphi=String[10]
    BrLineDateParam.Value := brLineDate;                                                       // SQL=varchar, Delphi=LongDate
    BrMatchRefParam.Value := brMatchRef;                                                       // SQL=varchar, Delphi=String[16]
    BrValueParam.Value := brValue;                                                             // SQL=float, Delphi=Double
    BrLineNoParam.Value := brLineNo;                                                           // SQL=int, Delphi=LongInt
    BrStatIdParam.Value := brStatId;                                                           // SQL=varchar, Delphi=String[4]
    BrStatLineParam.Value := brStatLine;                                                       // SQL=int, Delphi=LongInt
    BrCustCodeParam.Value := brCustCode;                                                       // SQL=varchar, Delphi=String[10]
    BrPeriodParam.Value := brPeriod;                                                           // SQL=int, Delphi=Byte
    BrYearParam.Value := brYear;                                                               // SQL=int, Delphi=Byte
    brCompanyRateParam.Value := brCXRate[False];                                               // SQL=float, Delphi=Real48
    brDailyRateParam.Value := brCXRate[True];                                                  // SQL=float, Delphi=Real48
    BrLUseORateParam.Value := brLUseORate;                                                     // SQL=int, Delphi=Byte
    brCurTriRateParam.Value := brCurTriR.TriRates;                                             // SQL=float, Delphi=Double
    brCurTriEuroParam.Value := brCurTriR.TriEuro;                                              // SQL=int, Delphi=Byte
    brCurTriInvertParam.Value := brCurTriR.TriInvert;                                          // SQL=bit, Delphi=Boolean
    brCurTriFloatParam.Value := brCurTriR.TriFloat;                                            // SQL=bit, Delphi=Boolean
    brCurSpareParam.Value := CreateVariantArray (@brCurTriR.Spare, SizeOf(brCurTriR.Spare));   // SQL=varbinary, Delphi=Array[1..10] of Byte
    BrOldYourRefParam.Value := brOldYourRef;                                                   // SQL=varchar, Delphi=String[10]
    BrTransValueParam.Value := brTransValue;                                                   // SQL=float, Delphi=Double
    BrDepartmentParam.Value := brCCDep[False];                                                 // SQL=varchar, Delphi=String[3]
    BrCostCentreParam.Value := brCCDep[True];                                                  // SQL=varchar, Delphi=String[3]
    BrNomCodeParam.Value := brNomCode;                                                         // SQL=int, Delphi=LongInt
    BrSRINomCodeParam.Value := brSRINomCode;                                                   // SQL=int, Delphi=LongInt
    BrFolioLinkParam.Value := brFolioLink;                                                     // SQL=int, Delphi=LongInt
    BrVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(brVATCode);                        // SQL=varchar, Delphi=Char
    BrVATAmountParam.Value := brVATAmount;                                                     // SQL=float, Delphi=Double
    BrTransDateParam.Value := brTransDate;                                                     // SQL=varchar, Delphi=LongDate
    BrIsNewTransParam.Value := brIsNewTrans;                                                   // SQL=bit, Delphi=Boolean
    BrLineStatusParam.Value := brLineStatus;                                                   // SQL=int, Delphi=Byte
    Spare6Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));                           // SQL=varbinary, Delphi=Array[1..493] of Byte
    BrYourRefParam.Value := brYourRef;                                                         // SQL=varchar, Delphi=String[20]
  End; // With DataRec^, BnkRDRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_BankRecHeaderVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'varCode1, ' + 
                                              'varCode2, ' + 
                                              'varCode3, ' + 
                                              'BrStatDate, ' + 
                                              'BrStatRef, ' + 
                                              'BrBankAcc, ' + 
                                              'BrBankCurrency, ' +
                                              'BrBankUserID, ' + 
                                              'BrCreateDate, ' + 
                                              'BrCreateTime, ' + 
                                              'BrStatBal, ' + 
                                              'BrOpenBal, ' + 
                                              'BrCloseBal, ' + 
                                              'BrStatus, ' + 
                                              'BrIntRef, ' + 
                                              'BrGLCode, ' + 
                                              'BrStatFolio, ' +
                                              'BrReconDate, ' +
                                              'BrReconRef, ' + 
                                              'BrInitSeq, ' + 
                                              'BrGroupBy' + 
                                              ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':varCode1, ' + 
                       ':varCode2, ' + 
                       ':varCode3, ' + 
                       ':BrStatDate, ' + 
                       ':BrStatRef, ' + 
                       ':BrBankAcc, ' + 
                       ':BrBankCurrency, ' + 
                       ':BrBankUserID, ' + 
                       ':BrCreateDate, ' + 
                       ':BrCreateTime, ' + 
                       ':BrStatBal, ' + 
                       ':BrOpenBal, ' + 
                       ':BrCloseBal, ' + 
                       ':BrStatus, ' + 
                       ':BrIntRef, ' + 
                       ':BrGLCode, ' + 
                       ':BrStatFolio, ' + 
                       ':BrReconDate, ' + 
                       ':BrReconRef, ' + 
                       ':BrInitSeq, ' + 
                       ':BrGroupBy' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    BrStatDateParam := FindParam('BrStatDate');
    BrStatRefParam := FindParam('BrStatRef');
    BrBankAccParam := FindParam('BrBankAcc');
    BrBankCurrencyParam := FindParam('BrBankCurrency');
    BrBankUserIDParam := FindParam('BrBankUserID');
    BrCreateDateParam := FindParam('BrCreateDate');
    BrCreateTimeParam := FindParam('BrCreateTime');
    BrStatBalParam := FindParam('BrStatBal');
    BrOpenBalParam := FindParam('BrOpenBal');
    BrCloseBalParam := FindParam('BrCloseBal');
    BrStatusParam := FindParam('BrStatus');
    BrIntRefParam := FindParam('BrIntRef');
    BrGLCodeParam := FindParam('BrGLCode');
    BrStatFolioParam := FindParam('BrStatFolio');
    BrReconDateParam := FindParam('BrReconDate');
    BrReconRefParam := FindParam('BrReconRef');
    BrInitSeqParam := FindParam('BrInitSeq');
    BrGroupByParam := FindParam('BrGroupBy');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_BankRecHeaderVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, BnkRHRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                   // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                   // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@brBnkCode1, SizeOf(brBnkCode1));      // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@brBnkCode2, SizeOf(brBnkCode2));      // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@brBnkCode3, SizeOf(brBnkCode3));      // SQL=varbinary, Delphi=String[31]

    BrStatDateParam.Value := brStatDate;                          // SQL=varchar, Delphi=LongDate
    BrStatRefParam.Value := brStatRef;                            // SQL=varchar, Delphi=String[20]
    BrBankAccParam.Value := brBankAcc;                            // SQL=varchar, Delphi=String[15]
    BrBankCurrencyParam.Value := brCurrency;                      // SQL=int, Delphi=Byte
    BrBankUserIDParam.Value := brUserId;                          // SQL=varchar, Delphi=String[10]
    BrCreateDateParam.Value := brCreateDate;                      // SQL=varchar, Delphi=LongDate
    BrCreateTimeParam.Value := brCreateTime;                      // SQL=varchar, Delphi=String[6]
    BrStatBalParam.Value := brStatBal;                            // SQL=float, Delphi=Double
    BrOpenBalParam.Value := brOpenBal;                            // SQL=float, Delphi=Double
    BrCloseBalParam.Value := brCloseBal;                          // SQL=float, Delphi=Double
    BrStatusParam.Value := brStatus;                              // SQL=int, Delphi=Byte
    BrIntRefParam.Value := brIntRef;                              // SQL=int, Delphi=LongInt
    BrGLCodeParam.Value := brGLCode;                              // SQL=int, Delphi=longint
    BrStatFolioParam.Value := brStatFolio;                        // SQL=int, Delphi=longint
    BrReconDateParam.Value := brReconDate;                        // SQL=varchar, Delphi=LongDate
    BrReconRefParam.Value := brReconRef;                          // SQL=varchar, Delphi=String[20]
    BrInitSeqParam.Value := brInitSeq;                            // SQL=int, Delphi=Byte
    BrGroupByParam.Value := brGroupBy;                            // SQL=int, Delphi=Byte
  End; // With DataRec^, BnkRHRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_BankAccountVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'varCode1, ' + 
                                              'varCode2, ' + 
                                              'varCode3, ' + 
                                              'BrAccNOM, ' + 
                                              'BrBankProd, ' + 
                                              'BrPayPath, ' + 
                                              'BrPayFileName, ' + 
                                              'BrRecFileName, ' + 
                                              'BrStatPath, ' + 
                                              'BrSwiftRef1, ' + 
                                              'BrSwiftRef2, ' + 
                                              'BrSwiftRef3, ' + 
                                              'BrSwiftBIC, ' + 
                                              'BrRouteCode, ' + 
                                              'BrChargeInst, ' + 
                                              'BrRouteMethod, ' + 
                                              'BrLastUseDate, ' + 
                                              'BrOldSortCode, ' +
                                              'BrOldAccountCode, ' +
                                              'BrBankRef, ' +
                                              'BrBACSUserID, ' +
                                              'BrBACSCurrency, ' +
                                              'BrUserID2, ' +
                                              'BrSortCodeEx, ' +
                                              'BrAccountCodeEx, ' +
                                              'BrBankSortCode, ' +
                                              'BrBankAccountCode ' + 
                                              ') ' +
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':varCode1, ' + 
                       ':varCode2, ' + 
                       ':varCode3, ' + 
                       ':BrAccNOM, ' + 
                       ':BrBankProd, ' + 
                       ':BrPayPath, ' + 
                       ':BrPayFileName, ' + 
                       ':BrRecFileName, ' + 
                       ':BrStatPath, ' + 
                       ':BrSwiftRef1, ' + 
                       ':BrSwiftRef2, ' + 
                       ':BrSwiftRef3, ' + 
                       ':BrSwiftBIC, ' + 
                       ':BrRouteCode, ' + 
                       ':BrChargeInst, ' + 
                       ':BrRouteMethod, ' + 
                       ':BrLastUseDate, ' + 
                       ':BrOldSortCode, ' +
                       ':BrOldAccountCode, ' +
                       ':BrBankRef, ' +
                       ':BrBACSUserID, ' +
                       ':BrBACSCurrency, ' +
                       ':BrUserID2, ' +
                       ':BrSortCodeEx, ' +
                       ':BrAccountCodeEx, ' +
                       ':BrBankSortCode, ' +
                       ':BrBankAccountCode ' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    BrAccNOMParam := FindParam('BrAccNOM');
    BrBankProdParam := FindParam('BrBankProd');
    BrPayPathParam := FindParam('BrPayPath');
    BrPayFileNameParam := FindParam('BrPayFileName');
    BrRecFileNameParam := FindParam('BrRecFileName');
    BrStatPathParam := FindParam('BrStatPath');
    BrSwiftRef1Param := FindParam('BrSwiftRef1');
    BrSwiftRef2Param := FindParam('BrSwiftRef2');
    BrSwiftRef3Param := FindParam('BrSwiftRef3');
    BrSwiftBICParam := FindParam('BrSwiftBIC');
    BrRouteCodeParam := FindParam('BrRouteCode');
    BrChargeInstParam := FindParam('BrChargeInst');
    BrRouteMethodParam := FindParam('BrRouteMethod');
    BrLastUseDateParam := FindParam('BrLastUseDate');
    BrOldSortCodeParam := FindParam('BrOldSortCode');
    BrOldAccountCodeParam := FindParam('BrOldAccountCode');
    BrBankRefParam := FindParam('BrBankRef');
    BrBACSUserIDParam := FindParam('BrBACSUserID');
    BrBACSCurrencyParam := FindParam('BrBACSCurrency');
    BrUserID2Param := FindParam('BrUserID2');
    BrSortCodeExParam := FindParam('BrSortCodeEx');
    BrAccountCodeExParam := FindParam('BrAccountCodeEx');
    BrBankSortCodeParam := FindParam('BrBankSortCode');
    BrBankAccountCodeParam := FindParam('BrBankAccountCode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_BankAccountVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, BACSDbRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                   // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                   // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@brBACSCode1, SizeOf(brBACSCode1));    // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@brBACSCode2, SizeOf(brBACSCode2));    // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@brBACSCode3, SizeOf(brBACSCode3));    // SQL=varbinary, Delphi=String[31]

    BrAccNOMParam.Value := brAccNOM;                                                  // SQL=int, Delphi=LongInt
    BrBankProdParam.Value := brBankProd;                                              // SQL=int, Delphi=Word
    BrPayPathParam.Value := brPayPath;                                                // SQL=varchar, Delphi=String[60]
    BrPayFileNameParam.Value := brPayFileName;                                        // SQL=varchar, Delphi=String[60]
    BrRecFileNameParam.Value := brRecFileName;                                        // SQL=varchar, Delphi=String[60]
    BrStatPathParam.Value := brStatPath;                                              // SQL=varchar, Delphi=String[60]
    BrSwiftRef1Param.Value := brSwiftRef1;                                            // SQL=varchar, Delphi=String[60]
    BrSwiftRef2Param.Value := brSwiftRef2;                                            // SQL=varchar, Delphi=String[60]
    BrSwiftRef3Param.Value := brSwiftRef3;                                            // SQL=varchar, Delphi=String[60]
    BrSwiftBICParam.Value := brSwiftBIC;                                              // SQL=varchar, Delphi=String[11]
    BrRouteCodeParam.Value := brRouteCode;                                            // SQL=varchar, Delphi=String[35]
    BrChargeInstParam.Value := brChargeInst;                                          // SQL=varchar, Delphi=String[5]
    BrRouteMethodParam.Value := ConvertCharToSQLEmulatorVarChar(brRouteMethod);       // SQL=varchar, Delphi=Char
    BrLastUseDateParam.Value := brLastUseDate;                                        // SQL=varchar, Delphi=LongDate
    BrOldSortCodeParam.Value := brOldSortCode;                                        // SQL=varchar, Delphi=string[6]
    BrOldAccountCodeParam.Value := brOldAccountCode;                                  // SQL=varchar, Delphi=string[12]
    BrBankRefParam.Value := brBankRef;                                                // SQL=varchar, Delphi=string[18]
    BrBACSUserIDParam.Value := brUserID;                                              // SQL=varchar, Delphi=string[10]
    BrBACSCurrencyParam.Value := brCurrency;                                          // SQL=int, Delphi=Byte
    BrUserID2Param.Value := brUserId2;                                                // SQL=varchar, Delphi=String[30]
    BrSortCodeExParam.Value := brSortCodeEx;                                          // SQL=varchar, Delphi=String[12]
    BrAccountCodeExParam.Value := brAccountCodeEx;                                    // SQL=varchar, Delphi=String[25]
    BrBankSortCodeParam.Value := CreateVariantArray(@brBankSortCode, SizeOf(brBankSortCode)); // SQL=varbinary, Delphi=String[22]
    BrBankAccountCodeParam.Value := CreateVariantArray(@brBankAccountCode, SizeOf(brBankAccountCode)); // SQL=varbinary, Delphi=String[54]
  End; // With DataRec^, BACSDbRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_BankStatementHeaderVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'varCode1, ' + 
                                              'varCode2, ' + 
                                              'varCode3, ' + 
                                              'EbAccNOM, ' + 
                                              'EbStatRef, ' + 
                                              'EbStatInd, ' + 
                                              'EbSourceFile, ' + 
                                              'EbIntRef, ' + 
                                              'EbStatDate' + 
                                              ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':varCode1, ' + 
                       ':varCode2, ' +
                       ':varCode3, ' + 
                       ':EbAccNOM, ' + 
                       ':EbStatRef, ' + 
                       ':EbStatInd, ' + 
                       ':EbSourceFile, ' + 
                       ':EbIntRef, ' + 
                       ':EbStatDate' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    EbAccNOMParam := FindParam('EbAccNOM');
    EbStatRefParam := FindParam('EbStatRef');
    EbStatIndParam := FindParam('EbStatInd');
    EbSourceFileParam := FindParam('EbSourceFile');
    EbIntRefParam := FindParam('EbIntRef');
    EbStatDateParam := FindParam('EbStatDate');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_BankStatementHeaderVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, eBankHRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);           // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);           // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@ebHCode1, SizeOf(ebHCode1));  // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@ebHCode2, SizeOf(ebHCode2));  // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@ebHCode3, SizeOf(ebHCode3));  // SQL=varbinary, Delphi=String[31]

    EbAccNOMParam.Value := ebAccNOM;                                          // SQL=int, Delphi=LongInt
    EbStatRefParam.Value := ebStatRef;                                        // SQL=varchar, Delphi=String[20]
    EbStatIndParam.Value := ebStatInd;                                        // SQL=int, Delphi=Word
    EbSourceFileParam.Value := ebSourceFile;                                  // SQL=varchar, Delphi=String[100]
    EbIntRefParam.Value := ebIntRef;                                          // SQL=int, Delphi=Longint
    EbStatDateParam.Value := ebStatDate;                                      // SQL=varchar, Delphi=LongDate
  End; // With DataRec^, eBankHRec
End; // SetQueryValues

//=========================================================================

Procedure TMLocStkDataWrite_BankStatementLineVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'varCode1, ' + 
                                              'varCode2, ' + 
                                              'varCode3, ' + 
                                              'EbLineNo, ' + 
                                              'EbLineDate, ' + 
                                              'EbLineRef, ' + 
                                              'EbLineValue, ' + 
                                              'EbLineIntRef, ' + 
                                              'EbMatchStr, ' + 
                                              'EbGLCode, ' + 
                                              'EbLineRef2, ' + 
                                              'EbLineStatus' + 
                                              ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' +
                       ':SubType, ' + 
                       ':varCode1, ' + 
                       ':varCode2, ' + 
                       ':varCode3, ' + 
                       ':EbLineNo, ' + 
                       ':EbLineDate, ' + 
                       ':EbLineRef, ' + 
                       ':EbLineValue, ' + 
                       ':EbLineIntRef, ' + 
                       ':EbMatchStr, ' +
                       ':EbGLCode, ' + 
                       ':EbLineRef2, ' + 
                       ':EbLineStatus' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    EbLineNoParam := FindParam('EbLineNo');
    EbLineDateParam := FindParam('EbLineDate');
    EbLineRefParam := FindParam('EbLineRef');
    EbLineValueParam := FindParam('EbLineValue');
    EbLineIntRefParam := FindParam('EbLineIntRef');
    EbMatchStrParam := FindParam('EbMatchStr');
    EbGLCodeParam := FindParam('EbGLCode');
    EbLineRef2Param := FindParam('EbLineRef2');
    EbLineStatusParam := FindParam('EbLineStatus');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_BankStatementLineVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, eBankLRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                  // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                  // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@ebLCode1, SizeOf(ebLCode1));         // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@ebLCode2, SizeOf(ebLCode2));         // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@ebLCode3, SizeOf(ebLCode3));         // SQL=varbinary, Delphi=String[31]

    EbLineNoParam.Value := ebLineNo;                                                 // SQL=int, Delphi=LongInt
    EbLineDateParam.Value := ebLineDate;                                             // SQL=varchar, Delphi=LongDate
    EbLineRefParam.Value := ebLineRef;                                               // SQL=varchar, Delphi=String[40]
    EbLineValueParam.Value := ebLineValue;                                           // SQL=float, Delphi=Double
    EbLineIntRefParam.Value := ebLineIntRef;                                         // SQL=int, Delphi=Longint
    EbMatchStrParam.Value := ebMatchStr;                                             // SQL=varchar, Delphi=String[30]
    EbGLCodeParam.Value := ebGLCode;                                                 // SQL=int, Delphi=longint
    EbLineRef2Param.Value := ebLineRef2;                                             // SQL=varchar, Delphi=String[40]
    EbLineStatusParam.Value := ebLineStatus;                                         // SQL=int, Delphi=Byte
  End; // With DataRec^, eBankLRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_AltStockCodesVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'varCode1, ' + 
                                              'varCode2, ' + 
                                              'varCode3, ' + 
                                              'SdStkFolio, ' + 
                                              'SdFolio, ' + 
                                              'SdSuppCode, ' + 
                                              'SdAltCode, ' + 
                                              'SdROCurrency, ' + 
                                              'SdRoPrice, ' + 
                                              'SdNLineCount, ' + 
                                              'SdLastUsed, ' + 
                                              'SdOverRO, ' + 
                                              'SdDesc, ' + 
                                              'SdLastTime, ' + 
                                              'SdOverMinEcc, ' + 
                                              'SdMinEccQty, ' + 
                                              'SdOverLineQty, ' + 
                                              'SdLineQty, ' + 
                                              'SdLineNo' + 
                                              ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' +
                       ':SubType, ' + 
                       ':varCode1, ' + 
                       ':varCode2, ' + 
                       ':varCode3, ' + 
                       ':SdStkFolio, ' + 
                       ':SdFolio, ' + 
                       ':SdSuppCode, ' + 
                       ':SdAltCode, ' + 
                       ':SdROCurrency, ' + 
                       ':SdRoPrice, ' +
                       ':SdNLineCount, ' + 
                       ':SdLastUsed, ' + 
                       ':SdOverRO, ' + 
                       ':SdDesc, ' + 
                       ':SdLastTime, ' + 
                       ':SdOverMinEcc, ' + 
                       ':SdMinEccQty, ' + 
                       ':SdOverLineQty, ' + 
                       ':SdLineQty, ' + 
                       ':SdLineNo' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    SdStkFolioParam := FindParam('SdStkFolio');
    SdFolioParam := FindParam('SdFolio');
    SdSuppCodeParam := FindParam('SdSuppCode');
    SdAltCodeParam := FindParam('SdAltCode');
    SdROCurrencyParam := FindParam('SdROCurrency');
    SdRoPriceParam := FindParam('SdRoPrice');
    SdNLineCountParam := FindParam('SdNLineCount');
    SdLastUsedParam := FindParam('SdLastUsed');
    SdOverROParam := FindParam('SdOverRO');
    SdDescParam := FindParam('SdDesc');
    SdLastTimeParam := FindParam('SdLastTime');
    SdOverMinEccParam := FindParam('SdOverMinEcc');
    SdMinEccQtyParam := FindParam('SdMinEccQty');
    SdOverLineQtyParam := FindParam('SdOverLineQty');
    SdLineQtyParam := FindParam('SdLineQty');
    SdLineNoParam := FindParam('SdLineNo');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_AltStockCodesVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, SdbStkRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);         // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);         // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@sdCode1, SizeOf(sdCode1));  // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@sdCode2, SizeOf(sdCode2));  // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@sdCode3, SizeOf(sdCode3));  // SQL=varbinary, Delphi=String[31]

    SdStkFolioParam.Value := sdStkFolio;                                    // SQL=int, Delphi=LongInt
    SdFolioParam.Value := sdFolio;                                          // SQL=int, Delphi=LongInt
    SdSuppCodeParam.Value := sdSuppCode;                                    // SQL=varchar, Delphi=String[10]
    SdAltCodeParam.Value := sdAltCode;                                      // SQL=varchar, Delphi=String[20]
    SdROCurrencyParam.Value := sdROCurrency;                                // SQL=int, Delphi=Byte
    SdRoPriceParam.Value := sdRoPrice;                                      // SQL=float, Delphi=Double
    SdNLineCountParam.Value := sdNLineCount;                                // SQL=int, Delphi=LongInt
    SdLastUsedParam.Value := sdLastUsed;                                    // SQL=varchar, Delphi=LongDate
    SdOverROParam.Value := sdOverRO;                                        // SQL=bit, Delphi=Boolean
    SdDescParam.Value := sdDesc;                                            // SQL=varchar, Delphi=String[35]
    SdLastTimeParam.Value := sdLastTime;                                    // SQL=varchar, Delphi=String[6]
    SdOverMinEccParam.Value := sdOverMinEcc;                                // SQL=bit, Delphi=Boolean
    SdMinEccQtyParam.Value := sdMinEccQty;                                  // SQL=float, Delphi=Double
    SdOverLineQtyParam.Value := sdOverLineQty;                              // SQL=bit, Delphi=Boolean
    SdLineQtyParam.Value := sdLineQty;                                      // SQL=float, Delphi=Double
    SdLineNoParam.Value := sdLineNo;                                        // SQL=int, Delphi=LongInt
  End; // With DataRec^, SdbStkRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_UserProfileVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].MLocStk (' +
                                              'RecPfix, ' +
                                              'SubType, ' +
                                              'varCode1, ' +
                                              'varCode2, ' +
                                              'varCode3, ' +
                                              'PWExpMode, ' +
                                              'PWExPDays, ' +
                                              'PWExpDate, ' +
                                              'DirCust, ' +
                                              'DirSupp, ' +
                                              'MaxSalesA, ' +
                                              'MaxPurchA, ' +
                                              'Department, ' +
                                              'CostCentre, ' +
                                              'Loc, ' +
                                              'SalesBank, ' +
                                              'PurchBank, ' +
                                              'ReportPrn, ' +
                                              'FormPrn, ' +
                                              'OrPrns1, ' +
                                              'OrPrns2, ' +
                                              'CCDepRule, ' +
                                              'LocRule, ' +
                                              'EmailAddr, ' +
                                              'PWTimeOut, ' +
                                              'Loaded, ' +
                                              'UserName, ' +
                                              'UCPr, ' +
                                              'UCYr, ' +
                                              'UDispPrMnth, ' +
                                              'ShowGLCodes, ' +
                                              'ShowStockCode, ' +
                                              'ShowProductType, ' +
                                              // MH 05/09/2017 2017-R2 ABSEXCH-18855: Updated for new Password Complexity fields in User Profile Record
                                              'UserStatus, ' +
                                              'PasswordSalt, ' +
                                              'PasswordHash, ' +
                                              'WindowUserId, ' +
                                              'SecurityQuestionId, ' +
                                              'SecurityAnswer, ' +
                                              'ForcePasswordChange, ' +
                                              'LoginFailureCount, ' +
                                              // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                                              'HighlightPIIFields, ' +
                                              'HighlightPIIColour' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':varCode1, ' +
                       ':varCode2, ' +
                       ':varCode3, ' +
                       ':PWExpMode, ' +
                       ':PWExPDays, ' +
                       ':PWExpDate, ' +
                       ':DirCust, ' +
                       ':DirSupp, ' +
                       ':MaxSalesA, ' +
                       ':MaxPurchA, ' +
                       ':Department, ' +
                       ':CostCentre, ' +
                       ':Loc, ' +
                       ':SalesBank, ' +
                       ':PurchBank, ' +
                       ':ReportPrn, ' +
                       ':FormPrn, ' +
                       ':OrPrns1, ' +
                       ':OrPrns2, ' +
                       ':CCDepRule, ' +
                       ':LocRule, ' +
                       ':EmailAddr, ' +
                       ':PWTimeOut, ' +
                       ':Loaded, ' +
                       ':UserName, ' +
                       ':UCPr, ' +
                       ':UCYr, ' +
                       ':UDispPrMnth, ' +
                       ':ShowGLCodes, ' +
                       ':ShowStockCode, ' +
                       ':ShowProductType, ' +
                       // MH 05/09/2017 2017-R2 ABSEXCH-18855: Updated for new Password Complexity fields in User Profile Record
                       ':UserStatus, ' +
                       ':PasswordSalt, ' +
                       ':PasswordHash, ' +
                       ':WindowUserId, ' +
                       ':SecurityQuestionId, ' +
                       ':SecurityAnswer, ' +
                       ':ForcePasswordChange, ' +
                       ':LoginFailureCount, ' +
                       // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                       ':HighlightPIIFields, ' +
                       ':HighlightPIIColour' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    PWExpModeParam := FindParam('PWExpMode');
    PWExPDaysParam := FindParam('PWExPDays');
    PWExpDateParam := FindParam('PWExpDate');
    DirCustParam := FindParam('DirCust');
    DirSuppParam := FindParam('DirSupp');
    MaxSalesAParam := FindParam('MaxSalesA');
    MaxPurchAParam := FindParam('MaxPurchA');
    DepartmentParam := FindParam('Department');
    CostCentreParam := FindParam('CostCentre');
    LocParam := FindParam('Loc');
    SalesBankParam := FindParam('SalesBank');
    PurchBankParam := FindParam('PurchBank');
    ReportPrnParam := FindParam('ReportPrn');
    FormPrnParam := FindParam('FormPrn');
    OrPrns1Param := FindParam('OrPrns1');
    OrPrns2Param := FindParam('OrPrns2');
    CCDepRuleParam := FindParam('CCDepRule');
    LocRuleParam := FindParam('LocRule');
    EmailAddrParam := FindParam('EmailAddr');
    PWTimeOutParam := FindParam('PWTimeOut');
    LoadedParam := FindParam('Loaded');
    UserNameParam := FindParam('UserName');
    UCPrParam := FindParam('UCPr');
    UCYrParam := FindParam('UCYr');
    UDispPrMnthParam := FindParam('UDispPrMnth');
    ShowGLCodesParam := FindParam('ShowGLCodes');
    ShowStockCodeParam := FindParam('ShowStockCode');
    ShowProductTypeParam := FindParam('ShowProductType');
    // MH 05/09/2017 2017-R2 ABSEXCH-18855: Updated for new Password Complexity fields in User Profile Record
    UserStatusParam := FindParam('UserStatus');
    PasswordSaltParam := FindParam('PasswordSalt');
    PasswordHashParam := FindParam('PasswordHash');
    WindowUserIdParam := FindParam('WindowUserId');
    SecurityQuestionIdParam := FindParam('SecurityQuestionId');
    SecurityAnswerParam := FindParam('SecurityAnswer');
    ForcePasswordChangeParam := FindParam('ForcePasswordChange');
    LoginFailureCountParam := FindParam('LoginFailureCount');

    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    HighlightPIIFieldsParam := FindParam('HighlightPIIFields');
    HighlightPIIColourParam := FindParam('HighlightPIIColour');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_UserProfileVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, PassDefRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);              // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);              // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@Login, SizeOf(Login));           // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));         // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@Ndx2, SizeOf(Ndx2));             // SQL=varbinary, Delphi=String[31]

    PWExpModeParam.Value := PWExpMode;                                           // SQL=int, Delphi=Byte
    PWExPDaysParam.Value := PWExPDays;                                           // SQL=int, Delphi=SmallInt
    PWExpDateParam.Value := PWExpDate;                                           // SQL=varchar, Delphi=LongDate
    DirCustParam.Value := DirCust;                                               // SQL=varchar, Delphi=String[10]
    DirSuppParam.Value := DirSupp;                                               // SQL=varchar, Delphi=String[10]
    MaxSalesAParam.Value := MaxSalesA;                                           // SQL=float, Delphi=Double
    MaxPurchAParam.Value := MaxPurchA;                                           // SQL=float, Delphi=Double
    DepartmentParam.Value := CCDep[False];                                       // SQL=varchar, Delphi=String[3]
    CostCentreParam.Value := CCDep[True];                                        // SQL=varchar, Delphi=String[3]
    LocParam.Value := Loc;                                                       // SQL=varchar, Delphi=String[10]
    SalesBankParam.Value := SalesBank;                                           // SQL=int, Delphi=LongInt
    PurchBankParam.Value := PurchBank;                                           // SQL=int, Delphi=LongInt
    ReportPrnParam.Value := ReportPrn;                                           // SQL=varchar, Delphi=String[50]
    FormPrnParam.Value := FormPrn;                                               // SQL=varchar, Delphi=String[50]
    OrPrns1Param.Value := OrPrns[1];                                             // SQL=bit, Delphi=Boolean
    OrPrns2Param.Value := OrPrns[2];                                             // SQL=bit, Delphi=Boolean
    CCDepRuleParam.Value := CCDepRule;                                           // SQL=int, Delphi=Byte
    LocRuleParam.Value := LocRule;                                               // SQL=int, Delphi=Byte
    EmailAddrParam.Value := emailAddr;                                           // SQL=varchar, Delphi=String[100]
    PWTimeOutParam.Value := PWTimeOut;                                           // SQL=int, Delphi=SmallInt
    LoadedParam.Value := Loaded;                                                 // SQL=bit, Delphi=Boolean
    UserNameParam.Value := UserName;                                             // SQL=varchar, Delphi=String[50]
    UCPrParam.Value := UCPr;                                                     // SQL=int, Delphi=Byte
    UCYrParam.Value := UCYr;                                                     // SQL=int, Delphi=Byte
    UDispPrMnthParam.Value := UDispPrMnth;                                       // SQL=bit, Delphi=Boolean
    ShowGLCodesParam.Value := ShowGLCodes;                                       // SQL=bit, Delphi=Boolean
    ShowStockCodeParam.Value := ShowStockCode;                                   // SQL=bit, Delphi=Boolean
    ShowProductTypeParam.Value := ShowProductType;                               // SQL=bit, Delphi=Boolean

    // MH 05/09/2017 2017-R2 ABSEXCH-18855: Updated for new Password Complexity fields in User Profile Record
    UserStatusParam.Value := UserStatus;
    PasswordSaltParam.Value := PasswordSalt;
    PasswordHashParam.Value := PasswordHash;
    WindowUserIdParam.Value := WindowUserId;
    SecurityQuestionIdParam.Value := SecurityQuestionId;
    SecurityAnswerParam.Value := SecurityAnswer;
    ForcePasswordChangeParam.Value := ForcePasswordChange;
    LoginFailureCountParam.Value := LoginFailureCount;

    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    HighlightPIIFieldsParam.Value := HighlightPIIFields;
    HighlightPIIColourParam.Value := HighlightPIIColour;
  End; // With DataRec^, PassDefRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_TelesalesVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].mlocstk (' +
                                              'RecPfix, ' +
                                              'SubType, ' +
                                              'varCode1, ' +
                                              'varCode2, ' +
                                              'varCode3, ' +
                                              'TcCustCode, ' +
                                              'TcDocType, ' +
                                              'TcCurr, ' +
                                              'TcCXCompanyRate, ' +
                                              'TcCXDailyRate, ' +
                                              'TcOldYourRef, ' +
                                              'TcLYRef, ' +
                                              'TcDepartment, ' +
                                              'TcCostCentre, ' +
                                              'TcLocCode, ' +
                                              'TcJobCode, ' +
                                              'TcJACode, ' +
                                              'TcDAddr1, ' +
                                              'TcDAddr2, ' +
                                              'TcDAddr3, ' +
                                              'TcDAddr4, ' +
                                              'TcDAddr5, ' +
                                              'TcTDate, ' +
                                              'TcDelDate, ' +
                                              'TcNetTotal, ' +
                                              'TcVATTotal, ' +
                                              'TcDiscTotal, ' +
                                              'TcLastOpo, ' +
                                              'TcInProg, ' +
                                              'TcTransNat, ' +
                                              'TcTransMode, ' +
                                              'TcDelTerms, ' +
                                              'TcCtrlCode, ' + 
                                              'TcVATCode, ' + 
                                              'TcOrdMode, ' + 
                                              'TcScaleMode, ' + 
                                              'TcLineCount, ' + 
                                              'TcWasNew, ' + 
                                              'TcUseORate, ' + 
                                              'TcDefNomCode, ' + 
                                              'TcVATIncFlg, ' + 
                                              'TcSetDisc, ' + 
                                              'TcGenMode, ' + 
                                              'TcTagNo, ' + 
                                              'TcLockAddr, ' + 
                                              'Spare2, ' +
                                              'TcYourRef, ' +
                                              // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
                                              'tcDeliveryPostCode, ' +
                                              // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
                                              'tcDeliveryCountry, ' +
                                              // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                                              'tcSSDProcess, ' +
                                              // CJS 2016-04-27 - Add support for new Tax fields
                                              'tcTaxRegion ' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':varCode1, ' +
                       ':varCode2, ' +
                       ':varCode3, ' +
                       ':TcCustCode, ' +
                       ':TcDocType, ' +
                       ':TcCurr, ' +
                       ':TcCXCompanyRate, ' +
                       ':TcCXDailyRate, ' +
                       ':TcOldYourRef, ' +
                       ':TcLYRef, ' +
                       ':TcDepartment, ' +
                       ':TcCostCentre, ' +
                       ':TcLocCode, ' +
                       ':TcJobCode, ' +
                       ':TcJACode, ' +
                       ':TcDAddr1, ' + 
                       ':TcDAddr2, ' + 
                       ':TcDAddr3, ' + 
                       ':TcDAddr4, ' + 
                       ':TcDAddr5, ' +
                       ':TcTDate, ' + 
                       ':TcDelDate, ' + 
                       ':TcNetTotal, ' + 
                       ':TcVATTotal, ' +
                       ':TcDiscTotal, ' + 
                       ':TcLastOpo, ' + 
                       ':TcInProg, ' + 
                       ':TcTransNat, ' + 
                       ':TcTransMode, ' + 
                       ':TcDelTerms, ' +
                       ':TcCtrlCode, ' +
                       ':TcVATCode, ' +
                       ':TcOrdMode, ' +
                       ':TcScaleMode, ' +
                       ':TcLineCount, ' +
                       ':TcWasNew, ' +
                       ':TcUseORate, ' +
                       ':TcDefNomCode, ' +
                       ':TcVATIncFlg, ' +
                       ':TcSetDisc, ' +
                       ':TcGenMode, ' +
                       ':TcTagNo, ' +
                       ':TcLockAddr, ' +
                       ':Spare2, ' +
                       ':TcYourRef, ' +
                       // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
                       ':tcDeliveryPostCode, ' +
                       // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
                       ':tcDeliveryCountry, ' +
                       // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                       ':tcSSDProcess, ' +
                       // CJS 2016-04-27 - Add support for new Tax fields
                       ':tcTaxRegion ' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    varCode1Param := FindParam('varCode1');
    varCode2Param := FindParam('varCode2');
    varCode3Param := FindParam('varCode3');

    TcCustCodeParam := FindParam('TcCustCode');
    TcDocTypeParam := FindParam('TcDocType');
    TcCurrParam := FindParam('TcCurr');
    TcCXCompanyRateParam := FindParam('TcCXCompanyRate');
    TcCXDailyRateParam := FindParam('TcCXDailyRate');
    TcOldYourRefParam := FindParam('TcOldYourRef');
    TcLYRefParam := FindParam('TcLYRef');
    TcDepartmentParam := FindParam('TcDepartment');
    TcCostCentreParam := FindParam('TcCostCentre');
    TcLocCodeParam := FindParam('TcLocCode');
    TcJobCodeParam := FindParam('TcJobCode');
    TcJACodeParam := FindParam('TcJACode');
    TcDAddr1Param := FindParam('TcDAddr1');
    TcDAddr2Param := FindParam('TcDAddr2');
    TcDAddr3Param := FindParam('TcDAddr3');
    TcDAddr4Param := FindParam('TcDAddr4');
    TcDAddr5Param := FindParam('TcDAddr5');
    TcTDateParam := FindParam('TcTDate');
    TcDelDateParam := FindParam('TcDelDate');
    TcNetTotalParam := FindParam('TcNetTotal');
    TcVATTotalParam := FindParam('TcVATTotal');
    TcDiscTotalParam := FindParam('TcDiscTotal');
    TcLastOpoParam := FindParam('TcLastOpo');
    TcInProgParam := FindParam('TcInProg');
    TcTransNatParam := FindParam('TcTransNat');
    TcTransModeParam := FindParam('TcTransMode');
    TcDelTermsParam := FindParam('TcDelTerms');
    TcCtrlCodeParam := FindParam('TcCtrlCode');
    TcVATCodeParam := FindParam('TcVATCode');
    TcOrdModeParam := FindParam('TcOrdMode');
    TcScaleModeParam := FindParam('TcScaleMode');
    TcLineCountParam := FindParam('TcLineCount');
    TcWasNewParam := FindParam('TcWasNew');
    TcUseORateParam := FindParam('TcUseORate');
    TcDefNomCodeParam := FindParam('TcDefNomCode');
    TcVATIncFlgParam := FindParam('TcVATIncFlg');
    TcSetDiscParam := FindParam('TcSetDisc');
    TcGenModeParam := FindParam('TcGenMode');
    TcTagNoParam := FindParam('TcTagNo');
    TcLockAddrParam := FindParam('TcLockAddr');
    Spare2Param := FindParam('Spare2');
    TcYourRefParam := FindParam('TcYourRef');
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    tcDeliveryPostCodeParam := FindParam('tcDeliveryPostCode');
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    tcDeliveryCountryParam := FindParam('tcDeliveryCountry');
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    tcSSDProcessParam := FindParam('tcSSDProcess');
    // CJS 2016-04-27 - Add support for new Tax fields
    tcTaxRegionParam := FindParam('tcTaxRegion');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_TelesalesVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, TeleSRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);           // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);           // SQL=varchar, Delphi=Char

    varCode1Param.Value := CreateVariantArray (@tcCode1, SizeOf(tcCode1));    // SQL=varbinary, Delphi=String[30]
    varCode2Param.Value := CreateVariantArray (@tcCode2, SizeOf(tcCode2));    // SQL=varbinary, Delphi=String[45]
    varCode3Param.Value := CreateVariantArray (@tcCode3, SizeOf(tcCode3));    // SQL=varbinary, Delphi=String[31]

    TcCustCodeParam.Value := tcCustCode;                                      // SQL=varchar, Delphi=String[10]
    TcDocTypeParam.Value := tcDocType;                                        // SQL=int, Delphi=Byte
    TcCurrParam.Value := tcCurr;                                              // SQL=int, Delphi=Byte
    TcCXCompanyRateParam.Value := tcCXrate[False];                            // SQL=float, Delphi=Real
    TcCXDailyRateParam.Value := tcCXrate[True];                               // SQL=float, Delphi=Real
    TcOldYourRefParam.Value := tcOldYourRef;                                  // SQL=varchar, Delphi=String[10]
    TcLYRefParam.Value := tcLYRef;                                            // SQL=varchar, Delphi=String[20]
    TcDepartmentParam.Value := tcCCDep[False];                                // SQL=varchar, Delphi=String[3]
    TcCostCentreParam.Value := tcCCDep[True];                                 // SQL=varchar, Delphi=String[3]
    TcLocCodeParam.Value := tcLocCode;                                        // SQL=varchar, Delphi=String[5]
    TcJobCodeParam.Value := tcJobCode;                                        // SQL=varchar, Delphi=String[10]
    TcJACodeParam.Value := tcJACode;                                          // SQL=varchar, Delphi=String[10]
    TcDAddr1Param.Value := tcDAddr[1];                                        // SQL=varchar, Delphi=String[30]
    TcDAddr2Param.Value := tcDAddr[2];                                        // SQL=varchar, Delphi=String[30]
    TcDAddr3Param.Value := tcDAddr[3];                                        // SQL=varchar, Delphi=String[30]
    TcDAddr4Param.Value := tcDAddr[4];                                        // SQL=varchar, Delphi=String[30]
    TcDAddr5Param.Value := tcDAddr[5];                                        // SQL=varchar, Delphi=String[30]
    TcTDateParam.Value := tcTDate;                                            // SQL=varchar, Delphi=LongDate
    TcDelDateParam.Value := tcDelDate;                                        // SQL=varchar, Delphi=LongDate
    TcNetTotalParam.Value := tcNetTotal;                                      // SQL=float, Delphi=Double
    TcVATTotalParam.Value := tcVATTotal;                                      // SQL=float, Delphi=Double
    TcDiscTotalParam.Value := tcDiscTotal;                                    // SQL=float, Delphi=Double
    TcLastOpoParam.Value := tcLastOpo;                                        // SQL=varchar, Delphi=String[10]
    TcInProgParam.Value := tcInProg;                                          // SQL=bit, Delphi=Boolean
    TcTransNatParam.Value := tcTransNat;                                      // SQL=int, Delphi=Byte
    TcTransModeParam.Value := tcTransMode;                                    // SQL=int, Delphi=Byte
    TcDelTermsParam.Value := tcDelTerms;                                      // SQL=varchar, Delphi=String[3]
    TcCtrlCodeParam.Value := tcCtrlCode;                                      // SQL=int, Delphi=LongInt
    TcVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(tcVATCode);       // SQL=varchar, Delphi=Char
    TcOrdModeParam.Value := tcOrdMode;                                        // SQL=int, Delphi=Byte
    TcScaleModeParam.Value := tcScaleMode;                                    // SQL=int, Delphi=Byte
    TcLineCountParam.Value := tcLineCount;                                    // SQL=int, Delphi=LongInt
    TcWasNewParam.Value := tcWasNew;                                          // SQL=bit, Delphi=Boolean
    TcUseORateParam.Value := tcUseORate;                                      // SQL=int, Delphi=Byte
    TcDefNomCodeParam.Value := tcDefNomCode;                                  // SQL=int, Delphi=LongInt
    TcVATIncFlgParam.Value := ConvertCharToSQLEmulatorVarChar(tcVATIncFlg);   // SQL=varchar, Delphi=Char
    TcSetDiscParam.Value := tcSetDisc;                                        // SQL=float, Delphi=Double
    TcGenModeParam.Value := tcGenMode;                                        // SQL=int, Delphi=Byte
    TcTagNoParam.Value := tcTagNo;                                            // SQL=int, Delphi=Byte
    TcLockAddrParam.Value := tcLockAddr;                                      // SQL=int, Delphi=LongInt
    Spare2Param.Value := CreateVariantArray (@Spare2, SizeOf(Spare2));        // SQL=varbinary, Delphi=Array[1..316] of Byte
    TcYourRefParam.Value := tcYourRef;                                        // SQL=varchar, Delphi=String[20]
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    tcDeliveryPostCodeParam.Value := tcDeliveryPostCode;
    // MH 02/12/2014 ABSEXCH-15836: Updated for Country Code mods
    tcDeliveryCountryParam.Value := tcDeliveryCountry;
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    tcSSDProcessParam.Value := tcSSDProcess;
    // CJS 2016-04-27 - Add support for new Tax fields
    tcTaxRegionParam.Value := tcTaxRegion;
  End; // With DataRec^, TeleSRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_AccountStockAnalysisVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].CustomerStockAnalysis (' +
                                                            'CsIndex, ' + 
                                                            'CsCustCode, ' + 
                                                            'CsStockCode, ' + 
                                                            'CsStkFolio, ' + 
                                                            'CsSOQty, ' + 
                                                            'CsLastDate, ' + 
                                                            'CsLineNo, ' + 
                                                            'CsLastPrice, ' + 
                                                            'CsLPCurr, ' + 
                                                            'CsJobCode, ' + 
                                                            'CsJACode, ' + 
                                                            'CsLocCode, ' + 
                                                            'CsNomCode, ' +
                                                            'CsDepartment, ' +
                                                            'CsCostCentre, ' + 
                                                            'CsQty, ' + 
                                                            'CsNetValue, ' + 
                                                            'CsDiscount, ' + 
                                                            'CsVATCode, ' + 
                                                            'CsCost, ' + 
                                                            'CsDesc1, ' + 
                                                            'CsDesc2, ' + 
                                                            'CsDesc3, ' + 
                                                            'CsDesc4, ' +
                                                            'CsDesc5, ' + 
                                                            'CsDesc6, ' + 
                                                            'CsVAT, ' + 
                                                            'CsPrxPack, ' + 
                                                            'CsQtyPack, ' + 
                                                            'CsQtyMul, ' + 
                                                            'CsDiscCh, ' + 
                                                            'CsEntered, ' + 
                                                            'CsUsePack, ' + 
                                                            'CsShowCase, ' + 
                                                            'CsLineType, ' + 
                                                            'CsPriceMulX, ' + 
                                                            'CsVATIncFlg' + 
                                                            ') ' + 
              'VALUES (' + 
                       ':CsIndex, ' + 
                       ':CsCustCode, ' + 
                       ':CsStockCode, ' + 
                       ':CsStkFolio, ' + 
                       ':CsSOQty, ' + 
                       ':CsLastDate, ' + 
                       ':CsLineNo, ' +
                       ':CsLastPrice, ' + 
                       ':CsLPCurr, ' + 
                       ':CsJobCode, ' + 
                       ':CsJACode, ' + 
                       ':CsLocCode, ' + 
                       ':CsNomCode, ' + 
                       ':CsDepartment, ' + 
                       ':CsCostCentre, ' + 
                       ':CsQty, ' + 
                       ':CsNetValue, ' + 
                       ':CsDiscount, ' + 
                       ':CsVATCode, ' + 
                       ':CsCost, ' + 
                       ':CsDesc1, ' + 
                       ':CsDesc2, ' + 
                       ':CsDesc3, ' + 
                       ':CsDesc4, ' + 
                       ':CsDesc5, ' + 
                       ':CsDesc6, ' + 
                       ':CsVAT, ' + 
                       ':CsPrxPack, ' + 
                       ':CsQtyPack, ' + 
                       ':CsQtyMul, ' + 
                       ':CsDiscCh, ' + 
                       ':CsEntered, ' + 
                       ':CsUsePack, ' + 
                       ':CsShowCase, ' + 
                       ':CsLineType, ' + 
                       ':CsPriceMulX, ' + 
                       ':CsVATIncFlg' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    CsIndexParam := FindParam('CsIndex');
    CsCustCodeParam := FindParam('CsCustCode');
    CsStockCodeParam := FindParam('CsStockCode');
    CsStkFolioParam := FindParam('CsStkFolio');
    CsSOQtyParam := FindParam('CsSOQty');
    CsLastDateParam := FindParam('CsLastDate');
    CsLineNoParam := FindParam('CsLineNo');
    CsLastPriceParam := FindParam('CsLastPrice');
    CsLPCurrParam := FindParam('CsLPCurr');
    CsJobCodeParam := FindParam('CsJobCode');
    CsJACodeParam := FindParam('CsJACode');
    CsLocCodeParam := FindParam('CsLocCode');
    CsNomCodeParam := FindParam('CsNomCode');
    CsDepartmentParam := FindParam('CsDepartment');
    CsCostCentreParam := FindParam('CsCostCentre');
    CsQtyParam := FindParam('CsQty');
    CsNetValueParam := FindParam('CsNetValue');
    CsDiscountParam := FindParam('CsDiscount');
    CsVATCodeParam := FindParam('CsVATCode');
    CsCostParam := FindParam('CsCost');
    CsDesc1Param := FindParam('CsDesc1');
    CsDesc2Param := FindParam('CsDesc2');
    CsDesc3Param := FindParam('CsDesc3');
    CsDesc4Param := FindParam('CsDesc4');
    CsDesc5Param := FindParam('CsDesc5');
    CsDesc6Param := FindParam('CsDesc6');
    CsVATParam := FindParam('CsVAT');
    CsPrxPackParam := FindParam('CsPrxPack');
    CsQtyPackParam := FindParam('CsQtyPack');
    CsQtyMulParam := FindParam('CsQtyMul');
    CsDiscChParam := FindParam('CsDiscCh');
    CsEnteredParam := FindParam('CsEntered');
    CsUsePackParam := FindParam('CsUsePack');
    CsShowCaseParam := FindParam('CsShowCase');
    CsLineTypeParam := FindParam('CsLineType');
    CsPriceMulXParam := FindParam('CsPriceMulX');
    CsVATIncFlgParam := FindParam('CsVATIncFlg');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_AccountStockAnalysisVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
  csIndex : String[26];
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^.CuStkRec Do
  Begin
    // csIndex doesn't map directly onto the original record structures so we need to
    // format a local string correctly in order to get the correct length byte
    csIndex := csCode2;
    CsIndexParam.Value := CreateVariantArray (@csIndex, SizeOF(csIndex));           // SQL=varbinary, Delphi=String[??]

    CsCustCodeParam.Value := csCustCode;                                            // SQL=varchar, Delphi=String[10]
    CsStockCodeParam.Value := csStockCode;                                          // SQL=varchar, Delphi=String[20]
    CsStkFolioParam.Value := csStkFolio;                                            // SQL=int, Delphi=LongInt
    CsSOQtyParam.Value := csSOQty;                                                  // SQL=float, Delphi=Double
    CsLastDateParam.Value := csLastDate;                                            // SQL=varchar, Delphi=LongDate
    CsLineNoParam.Value := csLineNo;                                                // SQL=int, Delphi=LongInt
    CsLastPriceParam.Value := csLastPrice;                                          // SQL=float, Delphi=Double
    CsLPCurrParam.Value := csLPCurr;                                                // SQL=int, Delphi=Byte
    CsJobCodeParam.Value := csJobCode;                                              // SQL=varchar, Delphi=String[10]
    CsJACodeParam.Value := csJACode;                                                // SQL=varchar, Delphi=String[10]
    CsLocCodeParam.Value := csLocCode;                                              // SQL=varchar, Delphi=String[5]
    CsNomCodeParam.Value := csNomCode;                                              // SQL=int, Delphi=LongInt
    CsDepartmentParam.Value := csCCDep[False];                                      // SQL=varchar, Delphi=String[3]
    CsCostCentreParam.Value := csCCDep[True];                                        // SQL=varchar, Delphi=String[3]
    CsQtyParam.Value := csQty;                                                      // SQL=float, Delphi=Double
    CsNetValueParam.Value := csNetValue;                                            // SQL=float, Delphi=Double
    CsDiscountParam.Value := csDiscount;                                            // SQL=float, Delphi=Double
    CsVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(csVATCode);             // SQL=varchar, Delphi=Char
    CsCostParam.Value := csCost;                                                    // SQL=float, Delphi=Double
    CsDesc1Param.Value := csDesc[1];                                                // SQL=varchar, Delphi=String[35]
    CsDesc2Param.Value := csDesc[2];                                               // SQL=varchar, Delphi=String[35]
    CsDesc3Param.Value := csDesc[3];                                               // SQL=varchar, Delphi=String[35]
    CsDesc4Param.Value := csDesc[4];                                               // SQL=varchar, Delphi=String[35]
    CsDesc5Param.Value := csDesc[5];                                               // SQL=varchar, Delphi=String[35]
    CsDesc6Param.Value := csDesc[6];                                               // SQL=varchar, Delphi=String[35]
    CsVATParam.Value := csVAT;                                                      // SQL=float, Delphi=Double
    CsPrxPackParam.Value := csPrxPack;                                              // SQL=bit, Delphi=Boolean
    CsQtyPackParam.Value := csQtyPack;                                              // SQL=float, Delphi=Double
    CsQtyMulParam.Value := csQtyMul;                                                // SQL=float, Delphi=Double
    CsDiscChParam.Value := ConvertCharToSQLEmulatorVarChar(csDiscCh);               // SQL=varchar, Delphi=Char
    CsEnteredParam.Value := csEntered;                                              // SQL=bit, Delphi=Boolean
    CsUsePackParam.Value := csUsePack;                                              // SQL=bit, Delphi=Boolean
    CsShowCaseParam.Value := csShowCase;                                            // SQL=bit, Delphi=Boolean
    CsLineTypeParam.Value := csLineType;                                            // SQL=int, Delphi=Byte
    CsPriceMulXParam.Value := csPriceMulX;                                          // SQL=float, Delphi=Double
    CsVATIncFlgParam.Value := ConvertCharToSQLEmulatorVarChar(csVATIncFlg);         // SQL=varchar, Delphi=Char
  End; // With DataRec^.CuStkRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMLocStkDataWrite_AllocWizardSessionVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].AllocWizardSession (' + 
                                                         'ArcCustSupp, ' + 
                                                         'ArcBankNom, ' + 
                                                         'ArcCtrlNom, ' + 
                                                         'ArcPayCurr, ' + 
                                                         'ArcInvCurr, ' + 
                                                         'ArcDepartment, ' + 
                                                         'ArcCostCentre, ' + 
                                                         'ArcSortBy, ' + 
                                                         'ArcAutoTotal, ' + 
                                                         'ArcSDDaysOver, ' + 
                                                         'ArcFromTrans, ' + 
                                                         'ArcOldYourRef, ' + 
                                                         'ArcChequeNo2, ' + 
                                                         'ArcForceNew, ' + 
                                                         'ArcSort2By, ' + 
                                                         'ArcTotalOwn, ' + 
                                                         'ArcTransValue, ' + 
                                                         'ArcTagCount, ' + 
                                                         'ArcTagRunDate, ' + 
                                                         'ArcTagRunYr, ' + 
                                                         'ArcTagRunPr, ' + 
                                                         'ArcSRCPIRef, ' + 
                                                         'ArcIncSDisc, ' + 
                                                         'ArcTotal, ' + 
                                                         'ArcVariance, ' + 
                                                         'ArcSettleD, ' + 
                                                         'ArcTransDate, ' + 
                                                         'ArcUD1, ' + 
                                                         'ArcUD2, ' + 
                                                         'ArcUD3, ' + 
                                                         'ArcUD4, ' + 
                                                         'ArcJobCode, ' + 
                                                         'ArcAnalCode, ' +
                                                         'ArcPayDetails1, ' + 
                                                         'ArcPayDetails2, ' + 
                                                         'ArcPayDetails3, ' + 
                                                         'ArcPayDetails4, ' + 
                                                         'ArcPayDetails5, ' + 
                                                         'ArcIncVar, ' + 
                                                         'ArcOurRef, ' + 
                                                         'ArcCompanyRate, ' + 
                                                         'ArcDailyRate, ' + 
                                                         'ArcOpoName, ' + 
                                                         'ArcStartDate, ' + 
                                                         'ArcStartTime, ' + 
                                                         'ArcWinLogIn, ' + 
                                                         'ArcLocked, ' + 
                                                         'ArcSalesMode, ' + 
                                                         'ArcCustCode, ' +
                                                         'ArcUseOSNdx, ' +
                                                         'ArcOwnTransValue, ' +
                                                         'ArcOwnSettleD, ' +
                                                         'ArcFinVar, ' +
                                                         'ArcFinSetD, ' +
                                                         'ArcSortD, ' +
                                                         'ArcAllocFull, ' +
                                                         'ArcCheckFail, ' +
                                                         'ArcCharge1GL, ' +
                                                         'ArcCharge2GL, ' +
                                                         'ArcCharge1Amt, ' +
                                                         'ArcCharge2Amt, ' +
                                                         'ArcYourRef, ' +
                                                         'ArcUD5, ' +
                                                         'ArcUD6, ' +
                                                         'ArcUD7, ' +
                                                         'ArcUD8, ' +
                                                         'ArcUD9, ' +
                                                         'ArcUD10, ' +
                                                         // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing Allocation Wizard field
                                                         'ArcUsePPD' +
                                                         ') ' +
              'VALUES (' + 
                       ':ArcCustSupp, ' + 
                       ':ArcBankNom, ' + 
                       ':ArcCtrlNom, ' + 
                       ':ArcPayCurr, ' + 
                       ':ArcInvCurr, ' + 
                       ':ArcDepartment, ' + 
                       ':ArcCostCentre, ' + 
                       ':ArcSortBy, ' + 
                       ':ArcAutoTotal, ' +
                       ':ArcSDDaysOver, ' + 
                       ':ArcFromTrans, ' + 
                       ':ArcOldYourRef, ' + 
                       ':ArcChequeNo2, ' + 
                       ':ArcForceNew, ' + 
                       ':ArcSort2By, ' + 
                       ':ArcTotalOwn, ' + 
                       ':ArcTransValue, ' + 
                       ':ArcTagCount, ' + 
                       ':ArcTagRunDate, ' + 
                       ':ArcTagRunYr, ' + 
                       ':ArcTagRunPr, ' + 
                       ':ArcSRCPIRef, ' + 
                       ':ArcIncSDisc, ' + 
                       ':ArcTotal, ' + 
                       ':ArcVariance, ' + 
                       ':ArcSettleD, ' + 
                       ':ArcTransDate, ' + 
                       ':ArcUD1, ' + 
                       ':ArcUD2, ' + 
                       ':ArcUD3, ' + 
                       ':ArcUD4, ' + 
                       ':ArcJobCode, ' + 
                       ':ArcAnalCode, ' + 
                       ':ArcPayDetails1, ' + 
                       ':ArcPayDetails2, ' + 
                       ':ArcPayDetails3, ' + 
                       ':ArcPayDetails4, ' + 
                       ':ArcPayDetails5, ' + 
                       ':ArcIncVar, ' + 
                       ':ArcOurRef, ' + 
                       ':ArcCompanyRate, ' + 
                       ':ArcDailyRate, ' + 
                       ':ArcOpoName, ' + 
                       ':ArcStartDate, ' + 
                       ':ArcStartTime, ' + 
                       ':ArcWinLogIn, ' + 
                       ':ArcLocked, ' + 
                       ':ArcSalesMode, ' + 
                       ':ArcCustCode, ' + 
                       ':ArcUseOSNdx, ' + 
                       ':ArcOwnTransValue, ' + 
                       ':ArcOwnSettleD, ' + 
                       ':ArcFinVar, ' + 
                       ':ArcFinSetD, ' + 
                       ':ArcSortD, ' +
                       ':ArcAllocFull, ' + 
                       ':ArcCheckFail, ' + 
                       ':ArcCharge1GL, ' + 
                       ':ArcCharge2GL, ' + 
                       ':ArcCharge1Amt, ' + 
                       ':ArcCharge2Amt, ' + 
                       ':ArcYourRef, ' + 
                       ':ArcUD5, ' + 
                       ':ArcUD6, ' + 
                       ':ArcUD7, ' + 
                       ':ArcUD8, ' + 
                       ':ArcUD9, ' + 
                       ':ArcUD10, ' +
                       // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing Allocation Wizard field
                       ':ArcUsePPD' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    ArcCustSuppParam := FindParam('ArcCustSupp');
    ArcBankNomParam := FindParam('ArcBankNom');
    ArcCtrlNomParam := FindParam('ArcCtrlNom');
    ArcPayCurrParam := FindParam('ArcPayCurr');
    ArcInvCurrParam := FindParam('ArcInvCurr');
    ArcDepartmentParam := FindParam('ArcDepartment');
    ArcCostCentreParam := FindParam('ArcCostCentre');
    ArcSortByParam := FindParam('ArcSortBy');
    ArcAutoTotalParam := FindParam('ArcAutoTotal');
    ArcSDDaysOverParam := FindParam('ArcSDDaysOver');
    ArcFromTransParam := FindParam('ArcFromTrans');
    ArcOldYourRefParam := FindParam('ArcOldYourRef');
    ArcChequeNo2Param := FindParam('ArcChequeNo2');
    ArcForceNewParam := FindParam('ArcForceNew');
    ArcSort2ByParam := FindParam('ArcSort2By');
    ArcTotalOwnParam := FindParam('ArcTotalOwn');
    ArcTransValueParam := FindParam('ArcTransValue');
    ArcTagCountParam := FindParam('ArcTagCount');
    ArcTagRunDateParam := FindParam('ArcTagRunDate');
    ArcTagRunYrParam := FindParam('ArcTagRunYr');
    ArcTagRunPrParam := FindParam('ArcTagRunPr');
    ArcSRCPIRefParam := FindParam('ArcSRCPIRef');
    ArcIncSDiscParam := FindParam('ArcIncSDisc');
    ArcTotalParam := FindParam('ArcTotal');
    ArcVarianceParam := FindParam('ArcVariance');
    ArcSettleDParam := FindParam('ArcSettleD');
    ArcTransDateParam := FindParam('ArcTransDate');
    ArcUD1Param := FindParam('ArcUD1');
    ArcUD2Param := FindParam('ArcUD2');
    ArcUD3Param := FindParam('ArcUD3');
    ArcUD4Param := FindParam('ArcUD4');
    ArcJobCodeParam := FindParam('ArcJobCode');
    ArcAnalCodeParam := FindParam('ArcAnalCode');
    ArcPayDetails1Param := FindParam('ArcPayDetails1');
    ArcPayDetails2Param := FindParam('ArcPayDetails2');
    ArcPayDetails3Param := FindParam('ArcPayDetails3');
    ArcPayDetails4Param := FindParam('ArcPayDetails4');
    ArcPayDetails5Param := FindParam('ArcPayDetails5');
    ArcIncVarParam := FindParam('ArcIncVar');
    ArcOurRefParam := FindParam('ArcOurRef');
    ArcCompanyRateParam := FindParam('ArcCompanyRate');
    ArcDailyRateParam := FindParam('ArcDailyRate');
    ArcOpoNameParam := FindParam('ArcOpoName');
    ArcStartDateParam := FindParam('ArcStartDate');
    ArcStartTimeParam := FindParam('ArcStartTime');
    ArcWinLogInParam := FindParam('ArcWinLogIn');
    ArcLockedParam := FindParam('ArcLocked');
    ArcSalesModeParam := FindParam('ArcSalesMode');
    ArcCustCodeParam := FindParam('ArcCustCode');
    ArcUseOSNdxParam := FindParam('ArcUseOSNdx');
    ArcOwnTransValueParam := FindParam('ArcOwnTransValue');
    ArcOwnSettleDParam := FindParam('ArcOwnSettleD');
    ArcFinVarParam := FindParam('ArcFinVar');
    ArcFinSetDParam := FindParam('ArcFinSetD');
    ArcSortDParam := FindParam('ArcSortD');
    ArcAllocFullParam := FindParam('ArcAllocFull');
    ArcCheckFailParam := FindParam('ArcCheckFail');
    ArcCharge1GLParam := FindParam('ArcCharge1GL');
    ArcCharge2GLParam := FindParam('ArcCharge2GL');
    ArcCharge1AmtParam := FindParam('ArcCharge1Amt');
    ArcCharge2AmtParam := FindParam('ArcCharge2Amt');
    ArcYourRefParam := FindParam('ArcYourRef');
    ArcUD5Param := FindParam('ArcUD5');
    ArcUD6Param := FindParam('ArcUD6');
    ArcUD7Param := FindParam('ArcUD7');
    ArcUD8Param := FindParam('ArcUD8');
    ArcUD9Param := FindParam('ArcUD9');
    ArcUD10Param := FindParam('ArcUD10');
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing Allocation Wizard field
    ArcUsePPDParam := FindParam('ArcUsePPD');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TMLocStkDataWrite_AllocWizardSessionVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MLocRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^.AllocCRec Do
  Begin
    ArcCustSuppParam.Value := ConvertCharToSQLEmulatorVarChar(arcCode1[1]);     // SQL=varchar, Delphi=Char
    ArcBankNomParam.Value := arcBankNom;                                        // SQL=int, Delphi=LongInt
    ArcCtrlNomParam.Value := arcCtrlNom;                                        // SQL=int, Delphi=LongInt
    ArcPayCurrParam.Value := arcPayCurr;                                        // SQL=int, Delphi=Byte
    ArcInvCurrParam.Value := arcInvCurr;                                        // SQL=int, Delphi=Byte
    ArcDepartmentParam.Value := arcCCDep[False];                                // SQL=varchar, Delphi=String[3]
    ArcCostCentreParam.Value := arcCCDep[True];                                 // SQL=varchar, Delphi=String[3]
    ArcSortByParam.Value := arcSortBy;                                          // SQL=int, Delphi=Byte
    ArcAutoTotalParam.Value := arcAutoTotal;                                    // SQL=bit, Delphi=Boolean
    ArcSDDaysOverParam.Value := arcSDDaysOver;                                  // SQL=int, Delphi=SmallInt
    ArcFromTransParam.Value := arcFromTrans;                                    // SQL=bit, Delphi=Boolean
    ArcOldYourRefParam.Value := arcOldYourRef;                                  // SQL=varchar, Delphi=String[10]
    ArcChequeNo2Param.Value := arcChequeNo2;                                    // SQL=varchar, Delphi=String[10]
    ArcForceNewParam.Value := arcForceNew;                                      // SQL=bit, Delphi=Boolean
    ArcSort2ByParam.Value := arcSort2By;                                        // SQL=int, Delphi=Byte
    ArcTotalOwnParam.Value := arcTotalOwn;                                      // SQL=float, Delphi=Double
    ArcTransValueParam.Value := arcTransValue;                                  // SQL=float, Delphi=Double
    ArcTagCountParam.Value := arcTagCount;                                      // SQL=int, Delphi=LongInt
    ArcTagRunDateParam.Value := arcTagRunDate;                                  // SQL=varchar, Delphi=LongDate
    ArcTagRunYrParam.Value := arcTagRunYr;                                      // SQL=int, Delphi=Byte
    ArcTagRunPrParam.Value := arcTagRunPr;                                      // SQL=int, Delphi=Byte
    ArcSRCPIRefParam.Value := arcSRCPIRef;                                      // SQL=varchar, Delphi=String[10]
    ArcIncSDiscParam.Value := arcIncSDisc;                                      // SQL=bit, Delphi=Boolean
    ArcTotalParam.Value := arcTotal;                                            // SQL=float, Delphi=Double
    ArcVarianceParam.Value := arcVariance;                                      // SQL=float, Delphi=Double
    ArcSettleDParam.Value := arcSettleD;                                        // SQL=float, Delphi=Double
    ArcTransDateParam.Value := arcTransDate;                                    // SQL=varchar, Delphi=LongDate
    ArcUD1Param.Value := arcUD1;                                                // SQL=varchar, Delphi=String[30]
    ArcUD2Param.Value := arcUD2;                                                // SQL=varchar, Delphi=String[30]
    ArcUD3Param.Value := arcUD3;                                                // SQL=varchar, Delphi=String[30]
    ArcUD4Param.Value := arcUD4;                                                // SQL=varchar, Delphi=String[30]
    ArcJobCodeParam.Value := arcJobCode;                                        // SQL=varchar, Delphi=String[10]
    ArcAnalCodeParam.Value := arcAnalCode;                                      // SQL=varchar, Delphi=String[10]
    ArcPayDetails1Param.Value := arcDelAddr[1];                                 // SQL=varchar, Delphi=String[30]
    ArcPayDetails2Param.Value := arcDelAddr[2];                                 // SQL=varchar, Delphi=String[30]
    ArcPayDetails3Param.Value := arcDelAddr[3];                                 // SQL=varchar, Delphi=String[30]
    ArcPayDetails4Param.Value := arcDelAddr[4];                                 // SQL=varchar, Delphi=String[30]
    ArcPayDetails5Param.Value := arcDelAddr[5];                                 // SQL=varchar, Delphi=String[30]
    ArcIncVarParam.Value := arcIncVar;                                          // SQL=bit, Delphi=Boolean
    ArcOurRefParam.Value := arcOurRef;                                          // SQL=varchar, Delphi=String[10]
    ArcCompanyRateParam.Value := arcCxRate[False];                              // SQL=float, Delphi=Real
    ArcDailyRateParam.Value := arcCxRate[True];                                 // SQL=float, Delphi=Real
    ArcOpoNameParam.Value := arcOpoName;                                        // SQL=varchar, Delphi=String[10]
    ArcStartDateParam.Value := arcStartDate;                                    // SQL=varchar, Delphi=LongDate
    ArcStartTimeParam.Value := arcStartTime;                                    // SQL=varchar, Delphi=String[6]
    ArcWinLogInParam.Value := arcWinLogIn;                                      // SQL=varchar, Delphi=String[50]
    ArcLockedParam.Value := arcLocked;                                          // SQL=int, Delphi=Byte
    ArcSalesModeParam.Value := arcSalesMode;                                    // SQL=bit, Delphi=Boolean
    ArcCustCodeParam.Value := arcCustCode;                                      // SQL=varchar, Delphi=String[10]
    ArcUseOSNdxParam.Value := arcUseOSNdx;                                      // SQL=bit, Delphi=Boolean
    ArcOwnTransValueParam.Value := arcOwnTransValue;                            // SQL=float, Delphi=Double
    ArcOwnSettleDParam.Value := arcOwnSettleD;                                  // SQL=float, Delphi=Double
    ArcFinVarParam.Value := arcFinVar;                                          // SQL=bit, Delphi=Boolean
    ArcFinSetDParam.Value := arcFinSetD;                                        // SQL=bit, Delphi=Boolean
    ArcSortDParam.Value := arcSortD;                                            // SQL=bit, Delphi=Boolean
    ArcAllocFullParam.Value := arcAllocFull;                                    // SQL=bit, Delphi=Boolean
    ArcCheckFailParam.Value := arcCheckFail;                                    // SQL=bit, Delphi=Boolean
    ArcCharge1GLParam.Value := arcCharge1GL;                                    // SQL=int, Delphi=LongInt
    ArcCharge2GLParam.Value := arcCharge2GL;                                    // SQL=int, Delphi=LongInt
    ArcCharge1AmtParam.Value := arcCharge1Amt;                                  // SQL=float, Delphi=Double
    ArcCharge2AmtParam.Value := arcCharge2Amt;                                  // SQL=float, Delphi=Double
    ArcYourRefParam.Value := arcYourRef;                                        // SQL=varchar, Delphi=String[20]
    ArcUD5Param.Value := arcUD5;                                                // SQL=varchar, Delphi=String[30]
    ArcUD6Param.Value := arcUD6;                                                // SQL=varchar, Delphi=String[30]
    ArcUD7Param.Value := arcUD7;                                                // SQL=varchar, Delphi=String[30]
    ArcUD8Param.Value := arcUD8;                                                // SQL=varchar, Delphi=String[30]
    ArcUD9Param.Value := arcUD9;                                                // SQL=varchar, Delphi=String[30]
    ArcUD10Param.Value := arcUD10;                                              // SQL=varchar, Delphi=String[30]
    // MH 25/08/2015 2015-R1 ABSEXCH-16788: Added missing Allocation Wizard field
    ArcUsePPDParam.Value := ArcUsePPD;
  End; // With DataRec^.AllocCRec
End; // SetQueryValues

//=========================================================================

End.

