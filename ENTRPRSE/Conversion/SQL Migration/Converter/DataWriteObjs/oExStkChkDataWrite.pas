Unit oExStkChkDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TExStkChkDataWrite_CustomerDiscountsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Variant specific fields
    CustCodeParam, StockCodeParam, CurrencyParam, DiscountTypeParam, PriceParam,
    BandParam, DiscountPParam, DiscountAParam, MarkupParam, UseDatesParam,
    StartDateParam, EndDateParam, QtyBreakFolioParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_CustomerDiscountsVariant

  //------------------------------

  TExStkChkDataWrite_SupplierDiscountsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    DCCodeParam, CustQBTypeParam, CustQBCurrParam, CustQSPriceParam, CustQBandParam,
    CustQDiscPParam, CustQDiscAParam, CustQMUMGParam, CUseDatesParam, CStartDParam,
    CEndDParam, QtyBreakFolioParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_SupplierDiscountsVariant

  //------------------------------

  TExStkChkDataWrite_JobInvoiceTempRecVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    DCCodeParam, CustQBTypeParam, CustQBCurrParam, CustQSPriceParam, CustQBandParam,
    CustQDiscPParam, CustQDiscAParam, CustQMUMGParam, CUseDatesParam, CStartDParam,
    CEndDParam, QtyBreakFolioParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_SupplierDiscountsVariant

  //------------------------------

  TExStkChkDataWrite_PostingLockVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    LocTagParam, LocFDescParam, LocRunNoParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_PostingLockVariant

  //------------------------------

  TExStkChkDataWrite_BankRecVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    BankRefParam, BankValueParam, MatchDocParam, MatchFolioParam, MatchLineParam,
    BankNomParam, BankCrParam, EntryOpoParam, EntryDateParam, EntryStatParam,
    UsePayInParam, MatchAddrParam, MatchRunNoParam, TaggedParam, MatchDateParam,
    MatchABSLineParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_BankRecVariant

  //------------------------------

  TExStkChkDataWrite_ReturnLineReasonVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    ReasonDescParam, ReasonCountParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_ReturnLineReasonVariant

  //------------------------------

  TExStkChkDataWrite_CustomSettingsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    BkgColorParam, FontNameParam, FontSizeParam, FontColorParam, FontStyleParam,
    FontPitchParam, FontHeightParam, LastColOrderParam, PositionParam, CompNameParam,
    UserNameParam, HighLightParam, HighTextParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_CustomSettingsVariant

  //------------------------------

  TExStkChkDataWrite_LetterLinksVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    AccCodeParam, LetterLinkData1Param, VersionParam, LetterLinkdata2Param,
    LetterLinkSpareParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_LetterLinksVariant

  //------------------------------

  TExStkChkDataWrite_AllocationLineVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    AriCustCodeParam, AriCustSuppParam, AriOurRefParam, AriOldYourRefParam,
    AriDueDateParam, AriTransDateParam, AriOrigValParam, AriOrigCurrParam,
    AriBaseEquivParam, AriOrigSettleParam, AriOrigOCSettleParam, AriSettleParam,
    AriCompanyRateParam, AriDailyRateParam, AriSetDiscParam, AriVarianceParam,
    AriOrigSetDiscParam, AriOutstandingParam, AriCurrOSParam, AriSettleOwnParam,
    AriBaseOSParam, AriDiscORParam, AriOwnDiscORParam, AriDocTypeParam, AriTagModeParam,
    AriReValAdjParam, AriOrigReValAdjParam, Spare3Param, AriYourRefParam : TParameter;
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    AriPPDStatusParam: TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_AllocationLineVariant

  //------------------------------

  TExStkChkDataWrite_BatchPayAccountVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    TagRunNoParam, TagCustCodeParam, TotalOS1Param, TotalOS2Param, TotalOS3Param,
    TotalOS4Param, TotalOS5Param, TotalTagged1Param, TotalTagged2Param,
    TotalTagged3Param, TotalTagged4Param, TotalTagged5Param, HasTagged1Param,
    HasTagged2Param, HasTagged3Param, HasTagged4Param, HasTagged5Param,
    TagBalParam, SalesCustParam, TotalEx1Param, TotalEx2Param, TotalEx3Param,
    TotalEx4Param, TotalEx5Param : TParameter;
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    TraderPPDPercentageParam, TraderPPDDaysParam: TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_BatchPayAccountVariant

  //------------------------------

  TExStkChkDataWrite_B2BInpStuffVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    Spare4Param, MultiModeParam, ExcludeBOMParam, UseOnOrderParam, IncludeLTParam,
    ExcludeLTParam, QtyModeParam, SuppCodeParam, LocORParam, AutoPickParam,
    GenOrderParam, PORBOMModeParam, WORBOMCodeParam, WORRefParam, LocIRParam,
    BuildQtyParam, BWOQtyParam, LessFStkParam, AutoSetChildParam, ShowDocParam,
    CopyStkNoteParam, UseDefLocParam, UseDefCCDepParam, WORTagNoParam,
    DefDepartmentParam, DefCostCentreParam, WCompDateParam, WStartDateParam,
    KeepLDatesParam, CopySORUDFParam, LessA2WORParam, Spare5Param, InpLoadedParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_B2BInpStuffVariant

  //------------------------------

  TExStkChkDataWrite_ABStuffVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecMfixParam, SubTypeParam, exstchkvar1Param, exstchkvar2Param, exstchkvar3Param  : TParameter;

    // Variant specific fields
    IrishSOPDataParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_ABStuffVariant

  //------------------------------

  TExStkChkDataWrite_SerialBatchVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Variant specific fields
    SerialNoParam, BatchNoParam, InDocParam, OutDocParam, SoldParam, DateInParam,
    CostPriceParam, SalePriceParam, StockFolioParam, DateOutParam, SoldLineParam,
    CostCurrencyParam, SaleCurrencyParam, BuyLineParam, BatchRecParam,
    BuyQtyParam, QtyUsedParam, BatchChildParam, InMLocParam, OutMLocParam,
    SerCompanyRateParam, SerDailyRateParam, InOrdDocParam, OutOrdDocParam,
    InOrdLineParam, OutOrdLineParam, NLineCountParam, NoteFolioParam, DateUseXParam,
    SUseORateParam, TriRatesParam, TriEuroParam, TriInvertParam, TriFloatParam,
    Spare2Param, ChildNFolioParam, InBinCodeParam, ReturnSNoParam, BatchRetQtyParam,
    RetDocParam, RetDocLineParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_SerialBatchVariant

  //------------------------------

  TExStkChkDataWrite_FIFOVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Variant specific fields
    FIFOStkFolioParam, FIFODocAbsNoParam, FIFODateParam, FIFOQtyLeftParam,
    FIFODocRefParam, FIFOQtyParam, FIFOCostParam, FIFOCurrParam, FIFOCustParam,
    FIFOMLocParam, FIFOCompanyRateParam, FIFODailyRateParam, FIFOUseORateParam,
    FIFOTriRatesParam, FIFOTriEuroParam, FIFOTriInvertParam, FIFOTriFloatParam,
    FIFOTriSpareParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite_FIFOVariant

  //------------------------------

  TExStkChkDataWrite = Class(TBaseDataWrite)
  Private
    FJobInvoiceTempRecVariant: TExStkChkDataWrite_JobInvoiceTempRecVariant;
    FCustomerDiscountsVariant : TExStkChkDataWrite_CustomerDiscountsVariant;
    FSupplierDiscountsVariant : TExStkChkDataWrite_SupplierDiscountsVariant;
    FPostingLockVariant : TExStkChkDataWrite_PostingLockVariant;
    FBankRecVariant : TExStkChkDataWrite_BankRecVariant;
    FReturnLineReasonVariant : TExStkChkDataWrite_ReturnLineReasonVariant;
    FCustomSettingsVariant : TExStkChkDataWrite_CustomSettingsVariant;
    FLetterLinksVariant : TExStkChkDataWrite_LetterLinksVariant;
    FAllocationLineVariant : TExStkChkDataWrite_AllocationLineVariant;
    FBatchPayAccountVariant : TExStkChkDataWrite_BatchPayAccountVariant;
    FB2BInpStuffVariant : TExStkChkDataWrite_B2BInpStuffVariant;
    FABStuffVariant : TExStkChkDataWrite_ABStuffVariant;
    FSerialBatchVariant : TExStkChkDataWrite_SerialBatchVariant;
    FFIFOVariant : TExStkChkDataWrite_FIFOVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExStkChkDataWrite

  //------------------------------

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TExStkChkDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FJobInvoiceTempRecVariant := TExStkChkDataWrite_JobInvoiceTempRecVariant.Create;
  FCustomerDiscountsVariant := TExStkChkDataWrite_CustomerDiscountsVariant.Create;
  FSupplierDiscountsVariant := TExStkChkDataWrite_SupplierDiscountsVariant.Create;
  FPostingLockVariant := TExStkChkDataWrite_PostingLockVariant.Create;
  FBankRecVariant := TExStkChkDataWrite_BankRecVariant.Create;
  FReturnLineReasonVariant := TExStkChkDataWrite_ReturnLineReasonVariant.Create;
  FCustomSettingsVariant := TExStkChkDataWrite_CustomSettingsVariant.Create;
  FLetterLinksVariant := TExStkChkDataWrite_LetterLinksVariant.Create;
  FAllocationLineVariant := TExStkChkDataWrite_AllocationLineVariant.Create;
  FBatchPayAccountVariant := TExStkChkDataWrite_BatchPayAccountVariant.Create;
  FB2BInpStuffVariant := TExStkChkDataWrite_B2BInpStuffVariant.Create;
  FABStuffVariant := TExStkChkDataWrite_ABStuffVariant.Create;
  FSerialBatchVariant := TExStkChkDataWrite_SerialBatchVariant.Create;
  FFIFOVariant := TExStkChkDataWrite_FIFOVariant.Create;
End; // Create

//------------------------------

Destructor TExStkChkDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FJobInvoiceTempRecVariant);
  FreeAndNIL(FCustomerDiscountsVariant);
  FreeAndNIL(FSupplierDiscountsVariant);
  FreeAndNIL(FPostingLockVariant);
  FreeAndNIL(FBankRecVariant);
  FreeAndNIL(FReturnLineReasonVariant);
  FreeAndNIL(FCustomSettingsVariant);
  FreeAndNIL(FLetterLinksVariant);
  FreeAndNIL(FAllocationLineVariant);
  FreeAndNIL(FBatchPayAccountVariant);
  FreeAndNIL(FB2BInpStuffVariant);
  FreeAndNIL(FABStuffVariant);
  FreeAndNIL(FSerialBatchVariant);
  FreeAndNIL(FFIFOVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FJobInvoiceTempRecVariant.Prepare (ADOConnection, CompanyCode);
  FCustomerDiscountsVariant.Prepare (ADOConnection, CompanyCode);
  FSupplierDiscountsVariant.Prepare (ADOConnection, CompanyCode);
  FPostingLockVariant.Prepare (ADOConnection, CompanyCode);
  FBankRecVariant.Prepare (ADOConnection, CompanyCode);
  FReturnLineReasonVariant.Prepare (ADOConnection, CompanyCode);
  FCustomSettingsVariant.Prepare (ADOConnection, CompanyCode);
  FLetterLinksVariant.Prepare (ADOConnection, CompanyCode);
  FAllocationLineVariant.Prepare (ADOConnection, CompanyCode);
  FBatchPayAccountVariant.Prepare (ADOConnection, CompanyCode);
  FB2BInpStuffVariant.Prepare (ADOConnection, CompanyCode);
  FABStuffVariant.Prepare (ADOConnection, CompanyCode);
  FSerialBatchVariant.Prepare (ADOConnection, CompanyCode);
  FFIFOVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecMFix = 'T') And (DataRec.SubType = 'F') Then
  Begin
    // CustDiscRec: CustDiscType - Used as temporary record in Job Staged Invoicing
    FJobInvoiceTempRecVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End
  Else If (DataRec.RecMFix = 'C') And (DataRec.SubType = 'C') Then
  Begin
    // CustDiscRec : CustDiscType - Customer Discounts - Normalised to CustomerDiscount
    FCustomerDiscountsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'C') And (DataRec.SubType = 'C')
  Else If (DataRec.RecMFix = 'C') And (DataRec.SubType = 'S') Then
  Begin
    // CustDiscRec : CustDiscType - Supplier Discounts - NOT normalised
    FSupplierDiscountsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'C') And (DataRec.SubType = 'C')
  Else If (DataRec.RecMFix = 'D') And (DataRec.SubType In ['C', 'Q', 'S']) Then
  Begin
    // QtyDiscRec : QtyDiscType - Quantity Breaks - Moved to QtyBreak.Dat in v6.10
    //
    //   DC - Customer Quantity Breaks
    //   DQ - Stock Quantity Breaks
    //   DS - Supplier Quantity Breaks
    //
    SkipRecord := True;
  End // If (DataRec.RecMFix = 'C') And (DataRec.SubType = 'C')
  Else If (DataRec.RecMFix = 'P') And (DataRec.SubType = 'L') Or (DataRec.RecMFix = 'L') And (DataRec.SubType = 'K') Then
  Begin
    // MultiLocRec : MultiLocType - Posting Lock Records
    FPostingLockVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'P') And (DataRec.SubType = 'L') Or (DataRec.RecMFix = 'L') And (DataRec.SubType = 'K')
  Else If (DataRec.RecMFix = 'M') And (DataRec.SubType In ['E', 'M']) Then
  Begin
    // BankMRec : BankMType
    //
    //  ME - Auto-Bank Rec Manual Entry Line
    //  MM - Manual Bank Recon Screen
    //
    FBankRecVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'M') And (DataRec.SubType In ['E', 'M'])
  Else If (DataRec.RecMFix = 'R') And (DataRec.SubType = '1') Then
  Begin
    // rtReasonRec : rtLReasonType - Return Line Reasons
    FReturnLineReasonVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'R') And (DataRec.SubType = '1')
  Else If (DataRec.RecMFix = 'U') And (DataRec.SubType = 'C') Then
  Begin
    // btCustomREc : btCustomType - Custom Window Settings
    FCustomSettingsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'R') And (DataRec.SubType = '1')
  Else If (DataRec.RecMFix = 'W') And (DataRec.SubType In ['C', 'J', 'K', 'S', 'T']) Then
  Begin
    // btLetterRec :  btLetterType or btLinkRec : btLinkType - Letters/Links
    //
    //  WC  Customer Letters/Links
    //  WJ  Job Letters/Links
    //  WK  Stock Letters/Links
    //  WS  Supplier Letters/Links
    //  WT  Transaction Letters/Links
    //
    FLetterLinksVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'W') And (DataRec.SubType In ['C', 'J', 'K', 'S', 'T'])
  Else If (DataRec.RecMFix = 'X') And (DataRec.SubType = 'A') Then
  Begin
    // AllocSRec : allocstype - Allocation Wizard Line
    FAllocationLineVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'X') And (DataRec.SubType = 'A')
  Else If (DataRec.RecMFix = 'X') And (DataRec.SubType = 'S') Then
  Begin
    // BacsSRec : BacsStype - Batch Payments Account line record
    FBatchPayAccountVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'X') And (DataRec.SubType = 'S')
  Else If (DataRec.RecMFix = 'A') And (DataRec.SubType = '2') Then
  Begin
    // B2BInpDefRec.B2BInpVal : B2BInpRec - Don't know what data this is
    FB2BInpStuffVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'A') And (DataRec.SubType = '2')
  Else If (DataRec.RecMFix = 'A') And (DataRec.SubType = 'B') Then
  Begin
    // Due to extreme incompetance AB could be either of the two structures below,
    // I'm sure Irfan had a good laugh (NOT!) when he found this.
    //
    //   SOPInpDefRec : SOPInpDefType - Store last values for SPOP ?OR-?DN-?IN conversion
    //   IrishVATRec : IrishVATType - Irish VAT Return Defaults
    //
    FABStuffVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'A') And (DataRec.SubType = '2')
  Else If (DataRec.RecMFix = 'F') And (DataRec.SubType = 'R') Then
  Begin
    // SerialRec : SerialType - Serial/Batch Numbers - Normalised to SerialBatch table in SQL
    FSerialBatchVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'A') And (DataRec.SubType = '2')
  Else If (DataRec.RecMFix = 'F') And (DataRec.SubType = 'S') Then
  Begin
    // FIFORec: FIFOType - FIFO - Normalised to FIFO table in SQL
    FFIFOVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecMFix = 'F') And (DataRec.SubType = 'S')
  Else
  Begin
    // AL - B2BInpDefRec : B2BProcType - Last Back To Back Order setttings - these records as
    // far as I can tell are temporary records created during the Back-to-Back process when
    // using multiple suppliers and should not exist in a system being converted.  As such
    // we aren't going to bother converting them unless it is later found to cause an issue.

    // Unknown Data - Log error and continue conversion
    SkipRecord := True;
    sDumpFile := DataPacket.DumpToFile;
    ConversionWarnings.AddWarning(TSQLUnknownVariantWarning.Create (DataPacket, sDumpFile, ToHexString(@DataRec^.RecMFix, 2 {RecMFix + SubType})));
    Logging.UnknownVariant(Trim(DataPacket.CompanyDetails.ccCompanyPath) + DataPacket.TaskDetails.dctPervasiveFilename, ToHexString(@DataRec^.RecMFix, 2 {RecMFix + SubType}), sDumpFile);
  End; // Else
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_CustomerDiscountsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].CustomerDiscount (' +
                                                       'CustCode, ' +
                                                       'StockCode, ' +
                                                       'Currency, ' +
                                                       'DiscountType, ' +
                                                       'Price, ' +
                                                       'Band, ' +
                                                       'DiscountP, ' +
                                                       'DiscountA, ' +
                                                       'Markup, ' +
                                                       'UseDates, ' +
                                                       'StartDate, ' +
                                                       'EndDate, ' +
                                                       'QtyBreakFolio' +
                                                       ')' +
            'VALUES (' +
                     ':CustCode, ' +
                     ':StockCode, ' +
                     ':Currency, ' +
                     ':DiscountType, ' +
                     ':Price, ' +
                     ':Band, ' +
                     ':DiscountP, ' +
                     ':DiscountA, ' +
                     ':Markup, ' +
                     ':UseDates, ' +
                     ':StartDate, ' +
                     ':EndDate, ' +
                     ':QtyBreakFolio' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    CustCodeParam := FindParam('CustCode');
    StockCodeParam := FindParam('StockCode');
    CurrencyParam := FindParam('Currency');
    DiscountTypeParam := FindParam('DiscountType');
    PriceParam := FindParam('Price');
    BandParam := FindParam('Band');
    DiscountPParam := FindParam('DiscountP');
    DiscountAParam := FindParam('DiscountA');
    MarkupParam := FindParam('Markup');
    UseDatesParam := FindParam('UseDates');
    StartDateParam := FindParam('StartDate');
    EndDateParam := FindParam('EndDate');
    QtyBreakFolioParam := FindParam('QtyBreakFolio');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_CustomerDiscountsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^.CustDiscRec Do
  Begin
    CustCodeParam.Value := Copy(DiscCode, 1, 6); // SQL=varchar, Delphi=
    StockCodeParam.Value := QStkCode;            // SQL=varchar, Delphi=
    CurrencyParam.Value := QBCurr;               // SQL=int, Delphi=
    // MH 06/09/20112 v6.10.1 ABSEXCH-13383: Corrected conversion of Char field
    DiscountTypeParam.Value := ConvertCharToSQLEmulatorVarChar(QBType);           // SQL=varchar, Delphi=
    PriceParam.Value := QSPrice;                 // SQL=float, Delphi=
    // MH 06/09/20112 v6.10.1 ABSEXCH-13383: Corrected conversion of Char field
    BandParam.Value := ConvertCharToSQLEmulatorVarChar(QBand);  // SQL=varchar, Delphi=Cahr
    DiscountPParam.Value := QDiscP;              // SQL=float, Delphi=
    DiscountAParam.Value := QDiscA;              // SQL=float, Delphi=
    MarkupParam.Value := QMUMG;                  // SQL=float, Delphi=
    UseDatesParam.Value := CUseDates;            // SQL=bit, Delphi=
    StartDateParam.Value := CStartD;             // SQL=varchar, Delphi=
    EndDateParam.Value := CEndD;                 // SQL=varchar, Delphi=
    QtyBreakFolioParam.Value := QtyBreakFolio;   // SQL=int, Delphi=
  End; // With DataRec^.CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_SupplierDiscountsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'DCCode, ' +
                                               'CustQBType, ' +
                                               'CustQBCurr, ' +
                                               'CustQSPrice, ' +
                                               'CustQBand, ' +
                                               'CustQDiscP, ' +
                                               'CustQDiscA, ' +
                                               'CustQMUMG, ' +
                                               'CUseDates, ' +
                                               'CStartD, ' +
                                               'CEndD, ' +
                                               'QtyBreakFolio' +
                                               ')' +
            'VALUES (' +
                     ':RecMfix, ' +
                     ':SubType, ' +
                     ':exstchkvar1, ' +
                     ':exstchkvar2, ' +
                     ':exstchkvar3, ' +
                     ':DCCode, ' +
                     ':CustQBType, ' +
                     ':CustQBCurr, ' +
                     ':CustQSPrice, ' +
                     ':CustQBand, ' +
                     ':CustQDiscP, ' +
                     ':CustQDiscA, ' +
                     ':CustQMUMG, ' +
                     ':CUseDates, ' +
                     ':CStartD, ' +
                     ':CEndD, ' +
                     ':QtyBreakFolio' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    DCCodeParam := FindParam('DCCode');
    CustQBTypeParam := FindParam('CustQBType');
    CustQBCurrParam := FindParam('CustQBCurr');
    CustQSPriceParam := FindParam('CustQSPrice');
    CustQBandParam := FindParam('CustQBand');
    CustQDiscPParam := FindParam('CustQDiscP');
    CustQDiscAParam := FindParam('CustQDiscA');
    CustQMUMGParam := FindParam('CustQMUMG');
    CUseDatesParam := FindParam('CUseDates');
    CStartDParam := FindParam('CStartD');
    CEndDParam := FindParam('CEndD');
    QtyBreakFolioParam := FindParam('QtyBreakFolio');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_SupplierDiscountsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, CustDiscRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    exstchkvar1Param.Value := CreateVariantArray (@DiscCode, SizeOf(DiscCode));  // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@QStkCode, SizeOf(QStkCode));  // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                           // SQL=varchar, Delphi=String[10]

    DCCodeParam.Value := DCCode;                                          // SQL=varchar, Delphi=String[10]
    CustQBTypeParam.Value := ConvertCharToSQLEmulatorVarChar(QBType);     // SQL=varchar, Delphi=Char
    CustQBCurrParam.Value := QBCurr;                                      // SQL=int, Delphi=Byte
    CustQSPriceParam.Value := QSPrice;                                    // SQL=float, Delphi=Double
    CustQBandParam.Value := ConvertCharToSQLEmulatorVarChar(QBand);       // SQL=varchar, Delphi=Char
    CustQDiscPParam.Value := QDiscP;                                      // SQL=float, Delphi=Double
    CustQDiscAParam.Value := QDiscA;                                      // SQL=float, Delphi=Double
    CustQMUMGParam.Value := QMUMG;                                        // SQL=float, Delphi=Double
    CUseDatesParam.Value := CUseDates;                                    // SQL=bit, Delphi=Boolean
    CStartDParam.Value := CStartD;                                        // SQL=varchar, Delphi=LongDate
    CEndDParam.Value := CEndD;                                            // SQL=varchar, Delphi=LongDate
    QtyBreakFolioParam.Value := QtyBreakFolio;                            // SQL=int, Delphi=LongInt
  End; // With DataRec^, CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_PostingLockVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'LocTag, ' +
                                               'LocFDesc, ' +
                                               'LocRunNo' +
                                               ')' +
            'VALUES (' +
                     ':RecMfix, ' +
                     ':SubType, ' +
                     ':exstchkvar1, ' +
                     ':exstchkvar2, ' +
                     ':exstchkvar3, ' +
                     ':LocTag, ' +
                     ':LocFDesc, ' +
                     ':LocRunNo' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    LocTagParam := FindParam('LocTag');
    LocFDescParam := FindParam('LocFDesc');
    LocRunNoParam := FindParam('LocRunNo');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_PostingLockVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, MultiLocRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly
    exstchkvar1Param.Value := CreateVariantArray (@MlocC, 27);                  // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@LocDesc, SizeOf(LocDesc));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                          // SQL=varchar, Delphi=String[10]

    LocTagParam.Value := LocTag;                                        // SQL=bit, Delphi=Boolean
    LocFDescParam.Value := LocFDesc;                                    // SQL=varchar, Delphi=String[30]
    LocRunNoParam.Value := LocRunNo;                                    // SQL=int, Delphi=LongInt
  End; // With DataRec^, MultiLocRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_BankRecVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'BankRef, ' +
                                               'BankValue, ' +
                                               'MatchDoc, ' +
                                               'MatchFolio, ' +
                                               'MatchLine, ' +
                                               'BankNom, ' +
                                               'BankCr, ' +
                                               'EntryOpo, ' +
                                               'EntryDate, ' +
                                               'EntryStat, ' +
                                               'UsePayIn, ' +
                                               'MatchAddr, ' +
                                               'MatchRunNo, ' +
                                               'Tagged, ' +
                                               'MatchDate, ' +
                                               'MatchABSLine' +
                                               ')' +
            'VALUES (' +
                     ':RecMfix, ' +
                     ':SubType, ' +
                     ':exstchkvar1, ' +
                     ':exstchkvar2, ' +
                     ':exstchkvar3, ' +
                     ':BankRef, ' +
                     ':BankValue, ' +
                     ':MatchDoc, ' +
                     ':MatchFolio, ' +
                     ':MatchLine, ' +
                     ':BankNom, ' +
                     ':BankCr, ' +
                     ':EntryOpo, ' +
                     ':EntryDate, ' +
                     ':EntryStat, ' +
                     ':UsePayIn, ' +
                     ':MatchAddr, ' +
                     ':MatchRunNo, ' +
                     ':Tagged, ' +
                     ':MatchDate, ' +
                     ':MatchABSLine' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    BankRefParam := FindParam('BankRef');
    BankValueParam := FindParam('BankValue');
    MatchDocParam := FindParam('MatchDoc');
    MatchFolioParam := FindParam('MatchFolio');
    MatchLineParam := FindParam('MatchLine');
    BankNomParam := FindParam('BankNom');
    BankCrParam := FindParam('BankCr');
    EntryOpoParam := FindParam('EntryOpo');
    EntryDateParam := FindParam('EntryDate');
    EntryStatParam := FindParam('EntryStat');
    UsePayInParam := FindParam('UsePayIn');
    MatchAddrParam := FindParam('MatchAddr');
    MatchRunNoParam := FindParam('MatchRunNo');
    TaggedParam := FindParam('Tagged');
    MatchDateParam := FindParam('MatchDate');
    MatchABSLineParam := FindParam('MatchABSLine');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_BankRecVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, BankMRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly
    exstchkvar1Param.Value := CreateVariantArray (@BankMatch, 27);                  // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@Spare2K, SizeOf(Spare2K));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                          // SQL=varchar, Delphi=String[10]

    BankRefParam.Value := BankRef;                                      // SQL=varchar, Delphi=String[40]
    BankValueParam.Value := BankValue;                                  // SQL=float, Delphi=Double
    MatchDocParam.Value := MatchDoc;                                    // SQL=varchar, Delphi=String[10]
    MatchFolioParam.Value := MatchFolio;                                // SQL=int, Delphi=LongInt
    MatchLineParam.Value := MatchLine;                                  // SQL=int, Delphi=LongInt
    BankNomParam.Value := BankNom;                                      // SQL=int, Delphi=LongInt
    BankCrParam.Value := BankCr;                                        // SQL=int, Delphi=Byte
    EntryOpoParam.Value := EntryOpo;                                    // SQL=varchar, Delphi=String[10]
    EntryDateParam.Value := EntryDate;                                  // SQL=varchar, Delphi=LongDate
    EntryStatParam.Value := EntryStat;                                  // SQL=int, Delphi=Byte
    UsePayInParam.Value := UsePayIn;                                    // SQL=bit, Delphi=Boolean
    MatchAddrParam.Value := MatchAddr;                                  // SQL=int, Delphi=LongInt
    MatchRunNoParam.Value := MatchRunNo;                                // SQL=int, Delphi=LongInt
    TaggedParam.Value := Tagged;                                        // SQL=bit, Delphi=Boolean
    MatchDateParam.Value := MatchDate;                                  // SQL=bit, Delphi=Boolean
    MatchABSLineParam.Value := MatchABSLine;                            // SQL=int, Delphi=LongInt
  End; // With DataRec^, BankMRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_ReturnLineReasonVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'ReasonDesc, ' +
                                               'ReasonCount' +
                                               ')' +
            'VALUES (' +
                     ':RecMfix, ' +
                     ':SubType, ' +
                     ':exstchkvar1, ' +
                     ':exstchkvar2, ' +
                     ':exstchkvar3, ' +
                     ':ReasonDesc, ' +
                     ':ReasonCount' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    ReasonDescParam := FindParam('ReasonDesc');
    ReasonCountParam := FindParam('ReasonCount');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_ReturnLineReasonVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, rtReasonRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly
    exstchkvar1Param.Value := CreateVariantArray (@CustomKey, 27);                  // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@UserKey, SizeOf(UserKey));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                          // SQL=varchar, Delphi=String[10]

    ReasonDescParam.Value := ReasonDesc;                                // SQL=varchar, Delphi=String[60]
    ReasonCountParam.Value := ReasonCount;                              // SQL=int, Delphi=LongInt
  End; // With DataRec^, rtReasonRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_CustomSettingsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'BkgColor, ' +
                                               'FontName, ' +
                                               'FontSize, ' +
                                               'FontColor, ' +
                                               'FontStyle, ' +
                                               'FontPitch, ' +
                                               'FontHeight, ' +
                                               'LastColOrder, ' +
                                               'Position, ' +
                                               'CompName, ' +
                                               'UserName, ' +
                                               'HighLight, ' +
                                               'HighText' +
                                               ') ' +
              'VALUES (' +
                       ':RecMfix, ' +
                       ':SubType, ' +
                       ':exstchkvar1, ' +
                       ':exstchkvar2, ' +
                       ':exstchkvar3, ' +
                       ':BkgColor, ' +
                       ':FontName, ' +
                       ':FontSize, ' +
                       ':FontColor, ' +
                       ':FontStyle, ' +
                       ':FontPitch, ' +
                       ':FontHeight, ' +
                       ':LastColOrder, ' +
                       ':Position, ' +
                       ':CompName, ' +
                       ':UserName, ' +
                       ':HighLight, ' +
                       ':HighText' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    BkgColorParam := FindParam('BkgColor');
    FontNameParam := FindParam('FontName');
    FontSizeParam := FindParam('FontSize');
    FontColorParam := FindParam('FontColor');
    FontStyleParam := FindParam('FontStyle');
    FontPitchParam := FindParam('FontPitch');
    FontHeightParam := FindParam('FontHeight');
    LastColOrderParam := FindParam('LastColOrder');
    PositionParam := FindParam('Position');
    CompNameParam := FindParam('CompName');
    UserNameParam := FindParam('UserName');
    HighLightParam := FindParam('HighLight');
    HighTextParam := FindParam('HighText');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_CustomSettingsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, btCustomREc Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly
    exstchkvar1Param.Value := CreateVariantArray (@CustomKey, 27);              // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@UserKey, SizeOf(UserKey));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                          // SQL=varchar, Delphi=String[10]

    BkgColorParam.Value := BkgColor;                                    // SQL=int, Delphi=TColor
    FontNameParam.Value := FontName;                                    // SQL=varchar, Delphi=String[32]
    FontSizeParam.Value := FontSize;                                    // SQL=int, Delphi=Integer
    FontColorParam.Value := FontColor;                                  // SQL=int, Delphi=TColor
    FontStyleParam.Value := BYTE(FontStyle);                             // SQL=int, Delphi=TFontStyles
    FontPitchParam.Value := FontPitch;                                  // SQL=int, Delphi=TFontPitch
    FontHeightParam.Value := FontHeight;                                // SQL=int, Delphi=Integer
    LastColOrderParam.Value := LastColOrder;                            // SQL=int, Delphi=LongInt
    PositionParam.Value := CreateVariantArray (@Position, SizeOf(Position));    // SQL=varbinary, Delphi=TRect
    CompNameParam.Value := CreateVariantArray (@CompName, SizeOf(CompName));    // SQL=varbinary, Delphi=String[63]
    UserNameParam.Value := UserName;                                    // SQL=varchar, Delphi=String[10]
    HighLightParam.Value := HighLight;                                  // SQL=int, Delphi=TColor
    HighTextParam.Value := HighText;                                    // SQL=int, Delphi=TColor
  End; // With DataRec^, btCustomREc
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_LetterLinksVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'AccCode, ' +
                                               'LetterLinkData1, ' +
                                               'Version, ' +
                                               'LetterLinkdata2, ' +
                                               'LetterLinkSpare' +
                                               ') ' +
              'VALUES (' +
                       ':RecMfix, ' +
                       ':SubType, ' +
                       ':exstchkvar1, ' +
                       ':exstchkvar2, ' +
                       ':exstchkvar3, ' +
                       ':AccCode, ' +
                       ':LetterLinkData1, ' +
                       ':Version, ' +
                       ':LetterLinkdata2, ' +
                       ':LetterLinkSpare' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    AccCodeParam := FindParam('AccCode');
    LetterLinkData1Param := FindParam('LetterLinkData1');
    VersionParam := FindParam('Version');
    LetterLinkdata2Param := FindParam('LetterLinkdata2');
    LetterLinkSpareParam := FindParam('LetterLinkSpare');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_LetterLinksVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, btLinkRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly
    exstchkvar1Param.Value := CreateVariantArray (@CustomKey, 27);              // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@UserKey, SizeOf(UserKey));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                          // SQL=varchar, Delphi=String[10]

    // Due to the Letters/Links structures being stored under the same RecMFix/SubType
    // the same SQL columns can contain either structure which makes it very screwy
    AccCodeParam.Value := CreateVariantArray (@AccCode, 11);                    // SQL=varbinary, Delphi=String[10]
    LetterLinkData1Param.Value := CreateVariantArray (@LtrDescr, 146);          // SQL=varbinary, Delphi=String[60]
    VersionParam.Value := Version;                                              // SQL=int, Delphi=btLetterDocType
    LetterLinkdata2Param.Value := CreateVariantArray (@UserCode, 32);           // SQL=varbinary, Delphi=String[10]
    LetterLinkSpareParam.Value := CreateVariantArray (@Spare600, 281);          // SQL=varbinary, Delphi=Array[1..281] of Byt
  End; // With DataRec^, btLinkRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_AllocationLineVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'AriCustCode, ' +
                                               'AriCustSupp, ' +
                                               'AriOurRef, ' +
                                               'AriOldYourRef, ' +
                                               'AriDueDate, ' +
                                               'AriTransDate, ' +
                                               'AriOrigVal, ' +
                                               'AriOrigCurr, ' +
                                               'AriBaseEquiv, ' +
                                               'AriOrigSettle, ' +
                                               'AriOrigOCSettle, ' +
                                               'AriSettle, ' +
                                               'AriCompanyRate, ' +
                                               'AriDailyRate, ' +
                                               'AriSetDisc, ' +
                                               'AriVariance, ' +
                                               'AriOrigSetDisc, ' +
                                               'AriOutstanding, ' +
                                               'AriCurrOS, ' +
                                               'AriSettleOwn, ' +
                                               'AriBaseOS, ' +
                                               'AriDiscOR, ' +
                                               'AriOwnDiscOR, ' +
                                               'AriDocType, ' +
                                               'AriTagMode, ' +
                                               'AriReValAdj, ' +
                                               'AriOrigReValAdj, ' +
                                               'Spare3, ' +
                                               'AriYourRef, ' +
                                               'AriPPDStatus ' +
                                               ') ' +
              'VALUES (' +
                       ':RecMfix, ' +
                       ':SubType, ' +
                       ':exstchkvar1, ' +
                       ':exstchkvar2, ' +
                       ':exstchkvar3, ' +
                       ':AriCustCode, ' +
                       ':AriCustSupp, ' +
                       ':AriOurRef, ' +
                       ':AriOldYourRef, ' +
                       ':AriDueDate, ' +
                       ':AriTransDate, ' +
                       ':AriOrigVal, ' +
                       ':AriOrigCurr, ' +
                       ':AriBaseEquiv, ' +
                       ':AriOrigSettle, ' +
                       ':AriOrigOCSettle, ' +
                       ':AriSettle, ' +
                       ':AriCompanyRate, ' +
                       ':AriDailyRate, ' +
                       ':AriSetDisc, ' +
                       ':AriVariance, ' +
                       ':AriOrigSetDisc, ' +
                       ':AriOutstanding, ' +
                       ':AriCurrOS, ' +
                       ':AriSettleOwn, ' +
                       ':AriBaseOS, ' +
                       ':AriDiscOR, ' +
                       ':AriOwnDiscOR, ' +
                       ':AriDocType, ' +
                       ':AriTagMode, ' +
                       ':AriReValAdj, ' +
                       ':AriOrigReValAdj, ' +
                       ':Spare3, ' +
                       ':AriYourRef, ' +
                       ':AriPPDStatus ' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    AriCustCodeParam := FindParam('AriCustCode');
    AriCustSuppParam := FindParam('AriCustSupp');
    AriOurRefParam := FindParam('AriOurRef');
    AriOldYourRefParam := FindParam('AriOldYourRef');
    AriDueDateParam := FindParam('AriDueDate');
    AriTransDateParam := FindParam('AriTransDate');
    AriOrigValParam := FindParam('AriOrigVal');
    AriOrigCurrParam := FindParam('AriOrigCurr');
    AriBaseEquivParam := FindParam('AriBaseEquiv');
    AriOrigSettleParam := FindParam('AriOrigSettle');
    AriOrigOCSettleParam := FindParam('AriOrigOCSettle');
    AriSettleParam := FindParam('AriSettle');
    AriCompanyRateParam := FindParam('AriCompanyRate');
    AriDailyRateParam := FindParam('AriDailyRate');
    AriSetDiscParam := FindParam('AriSetDisc');
    AriVarianceParam := FindParam('AriVariance');
    AriOrigSetDiscParam := FindParam('AriOrigSetDisc');
    AriOutstandingParam := FindParam('AriOutstanding');
    AriCurrOSParam := FindParam('AriCurrOS');
    AriSettleOwnParam := FindParam('AriSettleOwn');
    AriBaseOSParam := FindParam('AriBaseOS');
    AriDiscORParam := FindParam('AriDiscOR');
    AriOwnDiscORParam := FindParam('AriOwnDiscOR');
    AriDocTypeParam := FindParam('AriDocType');
    AriTagModeParam := FindParam('AriTagMode');
    AriReValAdjParam := FindParam('AriReValAdj');
    AriOrigReValAdjParam := FindParam('AriOrigReValAdj');
    Spare3Param := FindParam('Spare3');
    AriYourRefParam := FindParam('AriYourRef');
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    AriPPDStatusParam := FindParam('AriPPDStatus');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_AllocationLineVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, AllocSRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    exstchkvar1Param.Value := CreateVariantArray (@ariKey, SizeOf(ariKey));           // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@Spare2K, SizeOf(Spare2K));         // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                                // SQL=varchar, Delphi=String[10]

    AriCustCodeParam.Value := ariCustCode;                                            // SQL=varchar, Delphi=String[10]
    AriCustSuppParam.Value := ConvertCharToSQLEmulatorVarChar(ariCustSupp);           // SQL=varchar, Delphi=Char
    AriOurRefParam.Value := ariOurRef;                                                // SQL=varchar, Delphi=String[10]
    AriOldYourRefParam.Value := ariOldYourRef;                                        // SQL=varchar, Delphi=String[10]
    AriDueDateParam.Value := ariDueDate;                                              // SQL=varchar, Delphi=LongDate
    AriTransDateParam.Value := ariTransDate;                                          // SQL=varchar, Delphi=LongDate
    AriOrigValParam.Value := ariOrigVal;                                              // SQL=float, Delphi=Double
    AriOrigCurrParam.Value := ariOrigCurr;                                            // SQL=int, Delphi=Byte
    AriBaseEquivParam.Value := ariBaseEquiv;                                          // SQL=float, Delphi=Double
    AriOrigSettleParam.Value := ariOrigSettle;                                        // SQL=float, Delphi=Double
    AriOrigOCSettleParam.Value := ariOrigOCSettle;                                    // SQL=float, Delphi=Double
    AriSettleParam.Value := ariSettle;                                                // SQL=float, Delphi=Double
    AriCompanyRateParam.Value := ariCXRate[False];                                    // SQL=float, Delphi=Real48
    AriDailyRateParam.Value := ariCXRate[True];                                       // SQL=float, Delphi=Real48
    AriSetDiscParam.Value := ariSetDisc;                                              // SQL=float, Delphi=Double
    AriVarianceParam.Value := ariVariance;                                            // SQL=float, Delphi=Double
    AriOrigSetDiscParam.Value := ariOrigSetDisc;                                      // SQL=float, Delphi=Double
    AriOutstandingParam.Value := ariOutstanding;                                      // SQL=float, Delphi=Double
    AriCurrOSParam.Value := ariCurrOS;                                                // SQL=float, Delphi=Double
    AriSettleOwnParam.Value := ariSettleOwn;                                          // SQL=float, Delphi=Double
    AriBaseOSParam.Value := ariBaseOS;                                                // SQL=float, Delphi=Double
    AriDiscORParam.Value := ariDiscOR;                                                // SQL=float, Delphi=Double
    AriOwnDiscORParam.Value := ariOwnDiscOR;                                          // SQL=float, Delphi=Double
    AriDocTypeParam.Value := ariDocType;                                              // SQL=int, Delphi=DocTypes
    AriTagModeParam.Value := ariTagMode;                                              // SQL=int, Delphi=Byte
    AriReValAdjParam.Value := ariReValAdj;                                            // SQL=float, Delphi=Double
    AriOrigReValAdjParam.Value := ariOrigReValAdj;                                    // SQL=float, Delphi=Double
    Spare3Param.Value := CreateVariantArray (@Spare2, SizeOf(Spare2));                // SQL=varbinary, Delphi=Array[1..98] of Byte
    AriYourRefParam.Value := ariYourRef;                                              // SQL=varchar, Delphi=String[20]
    AriPPDStatusParam.Value := ariPPDStatus;
  End; // With DataRec^, AllocSRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_BatchPayAccountVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'TagRunNo, ' +
                                               'TagCustCode, ' +
                                               'TotalOS1, ' +
                                               'TotalOS2, ' +
                                               'TotalOS3, ' +
                                               'TotalOS4, ' +
                                               'TotalOS5, ' +
                                               'TotalTagged1, ' +
                                               'TotalTagged2, ' +
                                               'TotalTagged3, ' +
                                               'TotalTagged4, ' +
                                               'TotalTagged5, ' +
                                               'HasTagged1, ' +
                                               'HasTagged2, ' +
                                               'HasTagged3, ' +
                                               'HasTagged4, ' +
                                               'HasTagged5, ' +
                                               'TagBal, ' +
                                               'SalesCust, ' +
                                               'TotalEx1, ' +
                                               'TotalEx2, ' +
                                               'TotalEx3, ' +
                                               'TotalEx4, ' +
                                               'TotalEx5,' +
                                               'TraderPPDPercentage, ' +
                                               'TraderPPDDays ' +
                                               ') ' +
              'VALUES (' +
                       ':RecMfix, ' +
                       ':SubType, ' + 
                       ':exstchkvar1, ' + 
                       ':exstchkvar2, ' +
                       ':exstchkvar3, ' + 
                       ':TagRunNo, ' + 
                       ':TagCustCode, ' + 
                       ':TotalOS1, ' + 
                       ':TotalOS2, ' + 
                       ':TotalOS3, ' + 
                       ':TotalOS4, ' + 
                       ':TotalOS5, ' + 
                       ':TotalTagged1, ' + 
                       ':TotalTagged2, ' + 
                       ':TotalTagged3, ' + 
                       ':TotalTagged4, ' + 
                       ':TotalTagged5, ' + 
                       ':HasTagged1, ' + 
                       ':HasTagged2, ' +
                       ':HasTagged3, ' + 
                       ':HasTagged4, ' + 
                       ':HasTagged5, ' + 
                       ':TagBal, ' + 
                       ':SalesCust, ' + 
                       ':TotalEx1, ' + 
                       ':TotalEx2, ' + 
                       ':TotalEx3, ' + 
                       ':TotalEx4, ' +
                       ':TotalEx5, ' +
                       ':TraderPPDPercentage, ' +
                       ':TraderPPDDays ' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    TagRunNoParam := FindParam('TagRunNo');
    TagCustCodeParam := FindParam('TagCustCode');
    TotalOS1Param := FindParam('TotalOS1');
    TotalOS2Param := FindParam('TotalOS2');
    TotalOS3Param := FindParam('TotalOS3');
    TotalOS4Param := FindParam('TotalOS4');
    TotalOS5Param := FindParam('TotalOS5');
    TotalTagged1Param := FindParam('TotalTagged1');
    TotalTagged2Param := FindParam('TotalTagged2');
    TotalTagged3Param := FindParam('TotalTagged3');
    TotalTagged4Param := FindParam('TotalTagged4');
    TotalTagged5Param := FindParam('TotalTagged5');
    HasTagged1Param := FindParam('HasTagged1');
    HasTagged2Param := FindParam('HasTagged2');
    HasTagged3Param := FindParam('HasTagged3');
    HasTagged4Param := FindParam('HasTagged4');
    HasTagged5Param := FindParam('HasTagged5');
    TagBalParam := FindParam('TagBal');
    SalesCustParam := FindParam('SalesCust');
    TotalEx1Param := FindParam('TotalEx1');
    TotalEx2Param := FindParam('TotalEx2');
    TotalEx3Param := FindParam('TotalEx3');
    TotalEx4Param := FindParam('TotalEx4');
    TotalEx5Param := FindParam('TotalEx5');
    TraderPPDPercentageParam := FindParam('TraderPPDPercentage');
    TraderPPDDaysParam := FindParam('TraderPPDDays');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_BatchPayAccountVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, BacsSRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // MH 06/09/2012 v6.10.1 ABSEXCH-13386: Corrected field length from 26 to 27
    exstchkvar1Param.Value := CreateVariantArray (@TagSuppK, 27);               // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@Spare2K, SizeOf(Spare2K));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                          // SQL=varchar, Delphi=String[10]

    TagRunNoParam.Value := TagRunNo;                                            // SQL=int, Delphi=LongInt
    TagCustCodeParam.Value := TagCustCode;                                      // SQL=varchar, Delphi=String[10]
    TotalOS1Param.Value := TotalOS[0];                                          // SQL=float, Delphi=Double
    TotalOS2Param.Value := TotalOS[1];                                          // SQL=float, Delphi=Double
    TotalOS3Param.Value := TotalOS[2];                                          // SQL=float, Delphi=Double
    TotalOS4Param.Value := TotalOS[3];                                          // SQL=float, Delphi=Double
    TotalOS5Param.Value := TotalOS[4];                                          // SQL=float, Delphi=Double
    TotalTagged1Param.Value := TotalTagged[0];                                  // SQL=float, Delphi=Double
    TotalTagged2Param.Value := TotalTagged[1];                                  // SQL=float, Delphi=Double
    TotalTagged3Param.Value := TotalTagged[2];                                  // SQL=float, Delphi=Double
    TotalTagged4Param.Value := TotalTagged[3];                                  // SQL=float, Delphi=Double
    TotalTagged5Param.Value := TotalTagged[4];                                  // SQL=float, Delphi=Double
    HasTagged1Param.Value := HasTagged[0];                                      // SQL=bit, Delphi=Boolean
    HasTagged2Param.Value := HasTagged[1];                                      // SQL=bit, Delphi=Boolean
    HasTagged3Param.Value := HasTagged[2];                                      // SQL=bit, Delphi=Boolean
    HasTagged4Param.Value := HasTagged[3];                                      // SQL=bit, Delphi=Boolean
    HasTagged5Param.Value := HasTagged[4];                                      // SQL=bit, Delphi=Boolean
    TagBalParam.Value := TagBal;                                                // SQL=float, Delphi=Double
    SalesCustParam.Value := SalesCust;                                          // SQL=bit, Delphi=Boolean
    TotalEx1Param.Value := TotalEx[0];                                          // SQL=float, Delphi=Double
    TotalEx2Param.Value := TotalEx[1];                                          // SQL=float, Delphi=Double
    TotalEx3Param.Value := TotalEx[2];                                          // SQL=float, Delphi=Double
    TotalEx4Param.Value := TotalEx[3];                                          // SQL=float, Delphi=Double
    TotalEx5Param.Value := TotalEx[4];                                          // SQL=float, Delphi=Double
    TraderPPDPercentageParam.Value := TraderPPDPercentage;
    TraderPPDDaysParam.Value := TraderPPDDays;
  End; // With DataRec^, BacsSRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_B2BInpStuffVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'Spare4, ' + 
                                               'MultiMode, ' + 
                                               'ExcludeBOM, ' + 
                                               'UseOnOrder, ' + 
                                               'IncludeLT, ' + 
                                               'ExcludeLT, ' + 
                                               'QtyMode, ' + 
                                               'SuppCode, ' + 
                                               'LocOR, ' + 
                                               'AutoPick, ' + 
                                               'GenOrder, ' + 
                                               'PORBOMMode, ' + 
                                               'WORBOMCode, ' +
                                               'WORRef, ' + 
                                               'LocIR, ' + 
                                               'BuildQty, ' + 
                                               'BWOQty, ' + 
                                               'LessFStk, ' + 
                                               'AutoSetChild, ' + 
                                               'ShowDoc, ' + 
                                               'CopyStkNote, ' + 
                                               'UseDefLoc, ' + 
                                               'UseDefCCDep, ' + 
                                               'WORTagNo, ' + 
                                               'DefDepartment, ' + 
                                               'DefCostCentre, ' + 
                                               'WCompDate, ' +
                                               'WStartDate, ' + 
                                               'KeepLDates, ' + 
                                               'CopySORUDF, ' + 
                                               'LessA2WOR, ' + 
                                               'Spare5, ' + 
                                               'InpLoaded' + 
                                               ') ' + 
              'VALUES (' + 
                       ':RecMfix, ' + 
                       ':SubType, ' + 
                       ':exstchkvar1, ' + 
                       ':exstchkvar2, ' + 
                       ':exstchkvar3, ' +
                       ':Spare4, ' + 
                       ':MultiMode, ' + 
                       ':ExcludeBOM, ' + 
                       ':UseOnOrder, ' + 
                       ':IncludeLT, ' + 
                       ':ExcludeLT, ' + 
                       ':QtyMode, ' + 
                       ':SuppCode, ' + 
                       ':LocOR, ' + 
                       ':AutoPick, ' + 
                       ':GenOrder, ' + 
                       ':PORBOMMode, ' + 
                       ':WORBOMCode, ' + 
                       ':WORRef, ' +
                       ':LocIR, ' + 
                       ':BuildQty, ' + 
                       ':BWOQty, ' + 
                       ':LessFStk, ' + 
                       ':AutoSetChild, ' + 
                       ':ShowDoc, ' + 
                       ':CopyStkNote, ' + 
                       ':UseDefLoc, ' + 
                       ':UseDefCCDep, ' + 
                       ':WORTagNo, ' + 
                       ':DefDepartment, ' +
                       ':DefCostCentre, ' + 
                       ':WCompDate, ' +
                       ':WStartDate, ' + 
                       ':KeepLDates, ' + 
                       ':CopySORUDF, ' + 
                       ':LessA2WOR, ' + 
                       ':Spare5, ' + 
                       ':InpLoaded' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    Spare4Param := FindParam('Spare4');
    MultiModeParam := FindParam('MultiMode');
    ExcludeBOMParam := FindParam('ExcludeBOM');
    UseOnOrderParam := FindParam('UseOnOrder');
    IncludeLTParam := FindParam('IncludeLT');
    ExcludeLTParam := FindParam('ExcludeLT');
    QtyModeParam := FindParam('QtyMode');
    SuppCodeParam := FindParam('SuppCode');
    LocORParam := FindParam('LocOR');
    AutoPickParam := FindParam('AutoPick');
    GenOrderParam := FindParam('GenOrder');
    PORBOMModeParam := FindParam('PORBOMMode');
    WORBOMCodeParam := FindParam('WORBOMCode');
    WORRefParam := FindParam('WORRef');
    LocIRParam := FindParam('LocIR');
    BuildQtyParam := FindParam('BuildQty');
    BWOQtyParam := FindParam('BWOQty');
    LessFStkParam := FindParam('LessFStk');
    AutoSetChildParam := FindParam('AutoSetChild');
    ShowDocParam := FindParam('ShowDoc');
    CopyStkNoteParam := FindParam('CopyStkNote');
    UseDefLocParam := FindParam('UseDefLoc');
    UseDefCCDepParam := FindParam('UseDefCCDep');
    WORTagNoParam := FindParam('WORTagNo');
    DefDepartmentParam := FindParam('DefDepartment');
    DefCostCentreParam := FindParam('DefCostCentre');
    WCompDateParam := FindParam('WCompDate');
    WStartDateParam := FindParam('WStartDate');
    KeepLDatesParam := FindParam('KeepLDates');
    CopySORUDFParam := FindParam('CopySORUDF');
    LessA2WORParam := FindParam('LessA2WOR');
    Spare5Param := FindParam('Spare5');
    InpLoadedParam := FindParam('InpLoaded');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_B2BInpStuffVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, B2BInpDefRec.B2BInpVal Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly
    // MH 06/09/2012 v6.10.1 ABSEXCH-13386: Corrected field length from 26 to 27
    exstchkvar1Param.Value := CreateVariantArray (@B2BInpDefRec.B2BInpCode, 27);                              // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@B2BInpDefRec.SecondKey, SizeOf(B2BInpDefRec.SecondKey));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := B2BInpDefRec.ThirdK;                                                            // SQL=varchar, Delphi=String[10]

    Spare4Param.Value := B2BInpDefRec.Spare;                                        // SQL=int, Delphi=Byte
    MultiModeParam.Value := MultiMode;                                              // SQL=bit, Delphi=Boolean
    ExcludeBOMParam.Value := ExcludeBOM;                                            // SQL=bit, Delphi=Boolean
    UseOnOrderParam.Value := UseOnOrder;                                            // SQL=bit, Delphi=Boolean
    IncludeLTParam.Value := IncludeLT;                                              // SQL=int, Delphi=LongInt
    ExcludeLTParam.Value := ExcludeLT;                                              // SQL=int, Delphi=LongInt
    QtyModeParam.Value := QtyMode;                                                  // SQL=int, Delphi=Byte
    SuppCodeParam.Value := SuppCode;                                                // SQL=varchar, Delphi=String[10]
    LocORParam.Value := LocOR;                                                      // SQL=varchar, Delphi=String[10]
    AutoPickParam.Value := AutoPick;                                                // SQL=bit, Delphi=Boolean
    GenOrderParam.Value := GenOrder;                                                // SQL=int, Delphi=Byte
    PORBOMModeParam.Value := PORBOMMode;                                            // SQL=bit, Delphi=Boolean
    WORBOMCodeParam.Value := WORBOMCode;                                            // SQL=varchar, Delphi=String[20]
    WORRefParam.Value := WORRef;                                                    // SQL=varchar, Delphi=String[20]
    LocIRParam.Value := LocIR;                                                      // SQL=varchar, Delphi=String[10]
    BuildQtyParam.Value := BuildQty;                                                // SQL=float, Delphi=Double
    BWOQtyParam.Value := BWOQty;                                                    // SQL=bit, Delphi=Boolean
    LessFStkParam.Value := LessFStk;                                                // SQL=bit, Delphi=Boolean
    AutoSetChildParam.Value := AutoSetChilds;                                       // SQL=int, Delphi=Byte
    ShowDocParam.Value := ShowDoc;                                                  // SQL=bit, Delphi=Boolean
    CopyStkNoteParam.Value := CopyStkNote;                                          // SQL=bit, Delphi=Boolean
    UseDefLocParam.Value := UseDefLoc;                                              // SQL=bit, Delphi=Boolean
    UseDefCCDepParam.Value := UseDefCCDep;                                          // SQL=bit, Delphi=Boolean
    WORTagNoParam.Value := WORTagNo;                                                // SQL=int, Delphi=Byte
    DefDepartmentParam.Value := DefCCDep[False];                                    // SQL=varchar, Delphi=String[3]
    DefCostCentreParam.Value := DefCCDep[True];                                     // SQL=varchar, Delphi=String[3]
    WCompDateParam.Value := WCompDate;                                              // SQL=varchar, Delphi=LongDate
    WStartDateParam.Value := WStartDate;                                            // SQL=varchar, Delphi=LongDate
    KeepLDatesParam.Value := KeepLDates;                                            // SQL=bit, Delphi=Boolean
    CopySORUDFParam.Value := CopySORUDF;                                            // SQL=bit, Delphi=Boolean
    LessA2WORParam.Value := LessA2WOR;                                              // SQL=bit, Delphi=Boolean
    Spare5Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));                // SQL=varbinary, Delphi=Array[1..64] of char
    InpLoadedParam.Value := Loaded;                                                 // SQL=bit, Delphi=Boolean
  End; // With DataRec^, B2BInpDefRec.B2BInpVal
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_ABStuffVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'IrishSOPData' +
                                               ') ' +
              'VALUES (' +
                       ':RecMfix, ' +
                       ':SubType, ' +
                       ':exstchkvar1, ' +
                       ':exstchkvar2, ' +
                       ':exstchkvar3, ' + 
                       ':IrishSOPData' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    IrishSOPDataParam := FindParam('IrishSOPData');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_ABStuffVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, IrishVATRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly and the AB prefix is used by two unrelated records!
    // MH 06/09/2012 v6.10.1 ABSEXCH-13386: Corrected field length from 26 to 27
    exstchkvar1Param.Value := CreateVariantArray (@IRVInpCode, 27);                 // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@SecondKey, SizeOf(SecondKey));   // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := B2BInpDefRec.ThirdK;                                  // SQL=varchar, Delphi=String[10]

    IrishSOPDataParam.Value := CreateVariantArray (@Spare, 148);                   // SQL=varbinary, Delphi=Byte
  End; // With DataRec^, IrishVATRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_SerialBatchVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].SerialBatch (' + 
                                                  'SerialNo, ' + 
                                                  'BatchNo, ' + 
                                                  'InDoc, ' + 
                                                  'OutDoc, ' + 
                                                  'Sold, ' + 
                                                  'DateIn, ' + 
                                                  'CostPrice, ' + 
                                                  'SalePrice, ' + 
                                                  'StockFolio, ' + 
                                                  'DateOut, ' +
                                                  'SoldLine, ' + 
                                                  'CostCurrency, ' + 
                                                  'SaleCurrency, ' + 
                                                  'BuyLine, ' + 
                                                  'BatchRec, ' + 
                                                  'BuyQty, ' + 
                                                  'QtyUsed, ' + 
                                                  'BatchChild, ' + 
                                                  'InMLoc, ' + 
                                                  'OutMLoc, ' + 
                                                  'SerCompanyRate, ' + 
                                                  'SerDailyRate, ' + 
                                                  'InOrdDoc, ' + 
                                                  'OutOrdDoc, ' + 
                                                  'InOrdLine, ' + 
                                                  'OutOrdLine, ' +
                                                  'NLineCount, ' + 
                                                  'NoteFolio, ' + 
                                                  'DateUseX, ' + 
                                                  'SUseORate, ' + 
                                                  'TriRates, ' + 
                                                  'TriEuro, ' + 
                                                  'TriInvert, ' + 
                                                  'TriFloat, ' + 
                                                  'Spare2, ' + 
                                                  'ChildNFolio, ' + 
                                                  'InBinCode, ' + 
                                                  'ReturnSNo, ' + 
                                                  'BatchRetQty, ' + 
                                                  'RetDoc, ' + 
                                                  'RetDocLine' + 
                                                  ') ' + 
              'VALUES (' + 
                       ':SerialNo, ' + 
                       ':BatchNo, ' + 
                       ':InDoc, ' + 
                       ':OutDoc, ' + 
                       ':Sold, ' + 
                       ':DateIn, ' + 
                       ':CostPrice, ' + 
                       ':SalePrice, ' + 
                       ':StockFolio, ' + 
                       ':DateOut, ' + 
                       ':SoldLine, ' +
                       ':CostCurrency, ' + 
                       ':SaleCurrency, ' +
                       ':BuyLine, ' + 
                       ':BatchRec, ' + 
                       ':BuyQty, ' + 
                       ':QtyUsed, ' + 
                       ':BatchChild, ' + 
                       ':InMLoc, ' + 
                       ':OutMLoc, ' + 
                       ':SerCompanyRate, ' + 
                       ':SerDailyRate, ' + 
                       ':InOrdDoc, ' + 
                       ':OutOrdDoc, ' + 
                       ':InOrdLine, ' + 
                       ':OutOrdLine, ' + 
                       ':NLineCount, ' + 
                       ':NoteFolio, ' + 
                       ':DateUseX, ' + 
                       ':SUseORate, ' + 
                       ':TriRates, ' + 
                       ':TriEuro, ' + 
                       ':TriInvert, ' + 
                       ':TriFloat, ' + 
                       ':Spare2, ' + 
                       ':ChildNFolio, ' + 
                       ':InBinCode, ' + 
                       ':ReturnSNo, ' + 
                       ':BatchRetQty, ' + 
                       ':RetDoc, ' + 
                       ':RetDocLine' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    SerialNoParam := FindParam('SerialNo');
    BatchNoParam := FindParam('BatchNo');
    InDocParam := FindParam('InDoc');
    OutDocParam := FindParam('OutDoc');
    SoldParam := FindParam('Sold');
    DateInParam := FindParam('DateIn');
    CostPriceParam := FindParam('CostPrice');
    SalePriceParam := FindParam('SalePrice');
    StockFolioParam := FindParam('StockFolio');
    DateOutParam := FindParam('DateOut');
    SoldLineParam := FindParam('SoldLine');
    CostCurrencyParam := FindParam('CostCurrency');
    SaleCurrencyParam := FindParam('SaleCurrency');
    BuyLineParam := FindParam('BuyLine');
    BatchRecParam := FindParam('BatchRec');
    BuyQtyParam := FindParam('BuyQty');
    QtyUsedParam := FindParam('QtyUsed');
    BatchChildParam := FindParam('BatchChild');
    InMLocParam := FindParam('InMLoc');
    OutMLocParam := FindParam('OutMLoc');
    SerCompanyRateParam := FindParam('SerCompanyRate');
    SerDailyRateParam := FindParam('SerDailyRate');
    InOrdDocParam := FindParam('InOrdDoc');
    OutOrdDocParam := FindParam('OutOrdDoc');
    InOrdLineParam := FindParam('InOrdLine');
    OutOrdLineParam := FindParam('OutOrdLine');
    NLineCountParam := FindParam('NLineCount');
    NoteFolioParam := FindParam('NoteFolio');
    DateUseXParam := FindParam('DateUseX');
    SUseORateParam := FindParam('SUseORate');
    TriRatesParam := FindParam('TriRates');
    TriEuroParam := FindParam('TriEuro');
    TriInvertParam := FindParam('TriInvert');
    TriFloatParam := FindParam('TriFloat');
    Spare2Param := FindParam('Spare2');
    ChildNFolioParam := FindParam('ChildNFolio');
    InBinCodeParam := FindParam('InBinCode');
    ReturnSNoParam := FindParam('ReturnSNo');
    BatchRetQtyParam := FindParam('BatchRetQty');
    RetDocParam := FindParam('RetDoc');
    RetDocLineParam := FindParam('RetDocLine');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_SerialBatchVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^.SerialRec Do
  Begin
    SerialNoParam.Value := SerialNo;                                   // SQL=varchar, Delphi=
    BatchNoParam.Value := BatchNo;                                     // SQL=varchar, Delphi=
    InDocParam.Value := InDoc;                                         // SQL=varchar, Delphi=
    OutDocParam.Value := OutDoc;                                       // SQL=varchar, Delphi=
    SoldParam.Value := Sold;                                           // SQL=bit, Delphi=
    DateInParam.Value := DateIn;                                       // SQL=varchar, Delphi=
    CostPriceParam.Value := SerCost;                                   // SQL=float, Delphi=
    SalePriceParam.Value := SerSell;                                   // SQL=float, Delphi=
    StockFolioParam.Value := StkFolio;                                 // SQL=int, Delphi=
    DateOutParam.Value := DateOut;                                     // SQL=varchar, Delphi=
    SoldLineParam.Value := SoldLine;                                   // SQL=int, Delphi=
    CostCurrencyParam.Value := CurCost;                                // SQL=int, Delphi=
    SaleCurrencyParam.Value := CurSell;                                // SQL=int, Delphi=
    BuyLineParam.Value := BuyLine;                                     // SQL=int, Delphi=
    BatchRecParam.Value := BatchRec;                                   // SQL=bit, Delphi=
    BuyQtyParam.Value := BuyQty;                                       // SQL=float, Delphi=
    QtyUsedParam.Value := QtyUsed;                                     // SQL=float, Delphi=
    BatchChildParam.Value := BatchChild;                               // SQL=bit, Delphi=
    InMLocParam.Value := InMLoc;                                       // SQL=varchar, Delphi=
    OutMLocParam.Value := OutMLoc;                                     // SQL=varchar, Delphi=
    SerCompanyRateParam.Value := SerCRates[False];                     // SQL=float, Delphi=
    SerDailyRateParam.Value := SerCRates[True];                        // SQL=float, Delphi=
    InOrdDocParam.Value := InOrdDoc;                                   // SQL=varchar, Delphi=
    OutOrdDocParam.Value := OutOrdDoc;                                 // SQL=varchar, Delphi=
    InOrdLineParam.Value := InOrdLine;                                 // SQL=int, Delphi=
    OutOrdLineParam.Value := OutOrdLine;                               // SQL=int, Delphi=
    NLineCountParam.Value := NLineCount;                               // SQL=int, Delphi=
    NoteFolioParam.Value := NoteFolio;                                 // SQL=int, Delphi=
    DateUseXParam.Value := DateUseX;                                   // SQL=varchar, Delphi=
    SUseORateParam.Value := SUseORate;                                 // SQL=int, Delphi=
    TriRatesParam.Value := SerTriR.TriRates;                           // SQL=float, Delphi=
    TriEuroParam.Value := SerTriR.TriEuro;                             // SQL=int, Delphi=
    TriInvertParam.Value := SerTriR.TriInvert;                         // SQL=bit, Delphi=
    TriFloatParam.Value := SerTriR.TriFloat;                           // SQL=bit, Delphi=
    Spare2Param.Value := CreateVariantArray (@SerTriR.Spare, SizeOf(SerTriR.Spare));// SQL=varbinary, Delphi=
    ChildNFolioParam.Value := ChildNFolio;                             // SQL=int, Delphi=
    InBinCodeParam.Value := InBinCode;                                 // SQL=varchar, Delphi=
    ReturnSNoParam.Value := ReturnSNo;                                 // SQL=bit, Delphi=
    BatchRetQtyParam.Value := BatchRetQty;                             // SQL=float, Delphi=
    RetDocParam.Value := RetDoc;                                       // SQL=varchar, Delphi=
    RetDocLineParam.Value := RetDocLine;                               // SQL=int, Delphi=
  End; // With DataRec^.SerialRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExStkChkDataWrite_FIFOVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Fifo (' + 
                                           'FIFOStkFolio, ' + 
                                           'FIFODocAbsNo, ' + 
                                           'FIFODate, ' + 
                                           'FIFOQtyLeft, ' + 
                                           'FIFODocRef, ' + 
                                           'FIFOQty, ' + 
                                           'FIFOCost, ' + 
                                           'FIFOCurr, ' + 
                                           'FIFOCust, ' + 
                                           'FIFOMLoc, ' +
                                           'FIFOCompanyRate, ' + 
                                           'FIFODailyRate, ' + 
                                           'FIFOUseORate, ' + 
                                           'FIFOTriRates, ' + 
                                           'FIFOTriEuro, ' + 
                                           'FIFOTriInvert, ' + 
                                           'FIFOTriFloat, ' + 
                                           'FIFOTriSpare' + 
                                           ') ' + 
              'VALUES (' + 
                       ':FIFOStkFolio, ' + 
                       ':FIFODocAbsNo, ' +
                       ':FIFODate, ' + 
                       ':FIFOQtyLeft, ' + 
                       ':FIFODocRef, ' + 
                       ':FIFOQty, ' + 
                       ':FIFOCost, ' + 
                       ':FIFOCurr, ' + 
                       ':FIFOCust, ' +
                       ':FIFOMLoc, ' + 
                       ':FIFOCompanyRate, ' + 
                       ':FIFODailyRate, ' + 
                       ':FIFOUseORate, ' + 
                       ':FIFOTriRates, ' + 
                       ':FIFOTriEuro, ' + 
                       ':FIFOTriInvert, ' + 
                       ':FIFOTriFloat, ' + 
                       ':FIFOTriSpare' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    FIFOStkFolioParam := FindParam('FIFOStkFolio');
    FIFODocAbsNoParam := FindParam('FIFODocAbsNo');
    FIFODateParam := FindParam('FIFODate');
    FIFOQtyLeftParam := FindParam('FIFOQtyLeft');
    FIFODocRefParam := FindParam('FIFODocRef');
    FIFOQtyParam := FindParam('FIFOQty');
    FIFOCostParam := FindParam('FIFOCost');
    FIFOCurrParam := FindParam('FIFOCurr');
    FIFOCustParam := FindParam('FIFOCust');
    FIFOMLocParam := FindParam('FIFOMLoc');
    FIFOCompanyRateParam := FindParam('FIFOCompanyRate');
    FIFODailyRateParam := FindParam('FIFODailyRate');
    FIFOUseORateParam := FindParam('FIFOUseORate');
    FIFOTriRatesParam := FindParam('FIFOTriRates');
    FIFOTriEuroParam := FindParam('FIFOTriEuro');
    FIFOTriInvertParam := FindParam('FIFOTriInvert');
    FIFOTriFloatParam := FindParam('FIFOTriFloat');
    FIFOTriSpareParam := FindParam('FIFOTriSpare');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExStkChkDataWrite_FIFOVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^.FIFORec Do
  Begin
    FIFOStkFolioParam.Value := StkFolio;                                                      // SQL=int, Delphi=LongInt
    FIFODocAbsNoParam.Value := DocABSNo;                                                      // SQL=int, Delphi=LongInt
    FIFODateParam.Value := FIFODate;                                                          // SQL=varchar, Delphi=LongDate
    FIFOQtyLeftParam.Value := QtyLeft;                                                        // SQL=float, Delphi=Double
    FIFODocRefParam.Value := DocRef;                                                          // SQL=varchar, Delphi=String[10]
    FIFOQtyParam.Value := FIFOQty;                                                            // SQL=float, Delphi=Double
    FIFOCostParam.Value := FIFOCost;                                                          // SQL=float, Delphi=Double
    FIFOCurrParam.Value := FIFOCurr;                                                          // SQL=int, Delphi=Byte
    FIFOCustParam.Value := FIFOCust;                                                          // SQL=varchar, Delphi=String[10]
    FIFOMLocParam.Value := FIFOMLoc;                                                          // SQL=varchar, Delphi=String[10]
    FIFOCompanyRateParam.Value := FIFOCRates[False];                                          // SQL=float, Delphi=Real48
    FIFODailyRateParam.Value := FIFOCRates[True];                                             // SQL=float, Delphi=Real48
    FIFOUseORateParam.Value := FUseORate;                                                     // SQL=int, Delphi=Byte
    FIFOTriRatesParam.Value := FIFOTriR.TriRates;                                             // SQL=float, Delphi=Double
    FIFOTriEuroParam.Value := FIFOTriR.TriEuro;                                               // SQL=int, Delphi=Byte
    FIFOTriInvertParam.Value := FIFOTriR.TriInvert;                                           // SQL=bit, Delphi=Boolean
    FIFOTriFloatParam.Value := FIFOTriR.TriFloat;                                             // SQL=bit, Delphi=Boolean
    FIFOTriSpareParam.Value := CreateVariantArray (@FIFOTriR.Spare, SizeOf(FIFOTriR.Spare));  // SQL=varbinary, Delphi=Array[1..10] of Byte
  End; // With DataRec^.FIFORec
End; // SetQueryValues

//=========================================================================

{ TExStkChkDataWrite_JobInvoiceTempRecVariant }

// Called from the SQL Write Threads to provide basic info required for SQL Execution
procedure TExStkChkDataWrite_JobInvoiceTempRecVariant.Prepare(
  const ADOConnection: TADOConnection; const CompanyCode: ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExStkChk (' +
                                               'RecMfix, ' +
                                               'SubType, ' +
                                               'exstchkvar1, ' +
                                               'exstchkvar2, ' +
                                               'exstchkvar3, ' +
                                               'DCCode, ' +
                                               'CustQBType, ' +
                                               'CustQBCurr, ' +
                                               'CustQSPrice, ' +
                                               'CustQBand, ' +
                                               'CustQDiscP, ' +
                                               'CustQDiscA, ' +
                                               'CustQMUMG, ' +
                                               'CUseDates, ' +
                                               'CStartD, ' +
                                               'CEndD, ' +
                                               'QtyBreakFolio' +
                                               ')' +
            'VALUES (' +
                     ':RecMfix, ' +
                     ':SubType, ' +
                     ':exstchkvar1, ' +
                     ':exstchkvar2, ' +
                     ':exstchkvar3, ' +
                     ':DCCode, ' +
                     ':CustQBType, ' +
                     ':CustQBCurr, ' +
                     ':CustQSPrice, ' +
                     ':CustQBand, ' +
                     ':CustQDiscP, ' +
                     ':CustQDiscA, ' +
                     ':CustQMUMG, ' +
                     ':CUseDates, ' +
                     ':CStartD, ' +
                     ':CEndD, ' +
                     ':QtyBreakFolio' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecMfixParam := FindParam('RecMfix');
    SubTypeParam := FindParam('SubType');
    exstchkvar1Param := FindParam('exstchkvar1');
    exstchkvar2Param := FindParam('exstchkvar2');
    exstchkvar3Param := FindParam('exstchkvar3');

    // Variant specific fields
    DCCodeParam := FindParam('DCCode');
    CustQBTypeParam := FindParam('CustQBType');
    CustQBCurrParam := FindParam('CustQBCurr');
    CustQSPriceParam := FindParam('CustQSPrice');
    CustQBandParam := FindParam('CustQBand');
    CustQDiscPParam := FindParam('CustQDiscP');
    CustQDiscAParam := FindParam('CustQDiscA');
    CustQMUMGParam := FindParam('CustQMUMG');
    CUseDatesParam := FindParam('CUseDates');
    CStartDParam := FindParam('CStartD');
    CEndDParam := FindParam('CEndD');
    QtyBreakFolioParam := FindParam('QtyBreakFolio');
  End; // With FADOQuery.Parameters
end;

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
procedure TExStkChkDataWrite_JobInvoiceTempRecVariant.SetQueryValues(
  var ADOQuery: TADOQuery; const DataPacket: TDataPacket;
  var SkipRecord: Boolean);
Var
  DataRec : ^MiscRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, CustDiscRec Do
  Begin
    RecMfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecMfix);       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);       // SQL=varchar, Delphi=Char

    exstchkvar1Param.Value := CreateVariantArray (@DiscCode, SizeOf(DiscCode));  // SQL=varbinary, Delphi=String[26]
    exstchkvar2Param.Value := CreateVariantArray (@QStkCode, SizeOf(QStkCode));  // SQL=varbinary, Delphi=String[20]
    exstchkvar3Param.Value := Spare3K;                                           // SQL=varchar, Delphi=String[10]

    DCCodeParam.Value := DCCode;                                          // SQL=varchar, Delphi=String[10]
    CustQBTypeParam.Value := ConvertCharToSQLEmulatorVarChar(QBType);     // SQL=varchar, Delphi=Char
    CustQBCurrParam.Value := QBCurr;                                      // SQL=int, Delphi=Byte
    CustQSPriceParam.Value := QSPrice;                                    // SQL=float, Delphi=Double
    CustQBandParam.Value := ConvertCharToSQLEmulatorVarChar(QBand);       // SQL=varchar, Delphi=Char
    CustQDiscPParam.Value := QDiscP;                                      // SQL=float, Delphi=Double
    CustQDiscAParam.Value := QDiscA;                                      // SQL=float, Delphi=Double
    CustQMUMGParam.Value := QMUMG;                                        // SQL=float, Delphi=Double
    CUseDatesParam.Value := CUseDates;                                    // SQL=bit, Delphi=Boolean
    CStartDParam.Value := CStartD;                                        // SQL=varchar, Delphi=LongDate
    CEndDParam.Value := CEndD;                                            // SQL=varchar, Delphi=LongDate
    QtyBreakFolioParam.Value := QtyBreakFolio;                            // SQL=int, Delphi=LongInt
  End; // With DataRec^, CustDiscRec
end;

//-------------------------------------------------------------------------

End.


RecMfix   :  Char;         {  Record Prefix }
SubType   :  Char;         {  Subsplit Record Type }
{002}   B2BInpCode+Spare1 :  String[10];      {  AccessKey, SOPFolio+SuppCode }
{029}   SecondKey :  String[20];      {  Not Used}
{050}   ThirdK    :  String[10];
{060}   Spare     :  Byte;

{01} MultiMode  :   Boolean;
{02} ExcludeBOM  :   Boolean;
{03} UseOnOrder  :   Boolean;
{04} IncludeLT   :   LongInt;
{08} ExcludeLT   :   LongInt;
{12} QtyMode     :   Byte;
{13} SuppCode    :   String[10];
{24} LocOR       :   String[10];
{35} AutoPick    :   Boolean;
{36} GenOrder    :   Byte;
{37} PORBOMMode  :   Boolean;
{39} WORBOMCode  :   String[20];
{60} WORRef      :   String[20];
{81} LocIR       :   String[10];
{91} BuildQty    :   Double;
{99} BWOQty  :   Boolean;
{100} LessFStk    :   Boolean;
{101} AutoSetChilds                :   Byte;
{102} ShowDoc  :   Boolean;
{103} CopyStkNote  :   Boolean;
{104} UseDefLoc  :   Boolean;
{105} UseDefCCDep :   Boolean;
{106} WORTagNo    :   Byte;
{108} DefCCDep[False]   :   String[3];
{108} DefCCDep[True]   :   String[3];
{117} WCompDate   :   LongDate;
{125} WStartDate  :   LongDate;
{133} KeepLDates  :   Boolean;
{134} CopySORUDF  :   Boolean;
{135} LessA2WOR   :   Boolean;
{136} Spare       :   Array[1..64] of char;
{200}Loaded      :   Boolean;

