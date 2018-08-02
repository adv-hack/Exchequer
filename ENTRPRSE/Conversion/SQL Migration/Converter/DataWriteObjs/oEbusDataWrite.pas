Unit oEbusDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TEbusDataWrite_EBusParamsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,
    // Variant specific fields
    EntDefaultCompanyParam, EntCSVMapFileDirParam, EntTextFileDirParam,
    EntPollFreqParam, EntSetupPasswordParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusParamsVariant

  //------------------------------

  TEbusDataWrite_EBusCompanyVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,
    // Variant specific fields
    // CJS 2013-05-23 - ABSEXCH-11905 - 21.03 - SQL Data Migration Changes -
    //                  added CompDescLinesFromXML
    CompPostingLogDirParam,
    CompDefCostCentreParam, CompDefDeptParam, CompDefLocationParam, CompDefCustomerParam,
    CompDefSupplierParam, CompDefPurchNomParam, CompDefSalesNomParam, CompDefVATcodeParam,
    CompSetPeriodMethodParam, CompPeriodParam, CompYearParam, CompKeepTransNoParam,
    CompPostHoldFlagParam, CompTransTextDirParam, CompOrdOKTextFileParam,
    CompOrdFailTextFileParam, CompInvOKTextFileParam, CompInvFailTextFileParam,
    CompXMLAfterProcessParam, CompCSVDelimiterParam, CompCSVSeparatorParam,
    CompCSVIncHeaderRowParam, CompFreightLineParam, CompMiscLineParam,
    CompDiscountParam, CompCustLockFileParam, CompStockLockFileParam, CompStockGrpLockFileParam,
    CompTransLockFileParam, CompCustLockExtParam, CompStockLockExtParam,
    CompStockGrpLockExtParam, CompTransLockExtParam, CompCustLockMethodParam,
    CompStockLockMethodParam, CompStockGrpMethodParam, CompTransLockMethodParam,
    CompUseStockForChargesParam, CompFreightStockcodeParam, CompMiscStockcodeParam,
    CompDiscStockcodeParam, CompFreightDescParam, CompMiscDescParam, CompDiscDescParam,
    CompReapplyPricingParam, CompYourRefToAltRefParam, CompUseMatchingParam,
    CompSentimailEventParam, CompLocationOriginParam, CompImportUDF1Param,
    CompGeneralNotesParam, CompCCDepFromXMLParam, CompUseBasda309Param,
    CompDescLinesFromXMLParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusCompanyVariant

  //------------------------------                                    m

  TEbusDataWrite_EBusFileCountersVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,
    // Variant specific fields
    stockcounterParam, stockgrpcounterParam, transactioncounterParam, CustomerCounterParam,
    emailcounterParam, exportlogcounterParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusFileCountersVariant

  //------------------------------

  TEbusDataWrite_EBusImportVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,

    ImportSearchDirParam, ImportArchiveDirParam,
    ImportFailDirParam, ImportLogDirParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusImportVariant

  //------------------------------

  TEbusDataWrite_EBusExportVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,

    ExptDescriptionParam, ExptStockParam,
    ExptStockGroupsParam, ExptCustomersParam, ExptIncCurSalesTransParam, 
    ExptIncCurSalesOrdersParam, ExptIncCurPurchTransParam, ExptIncCurPurchOrdersParam, 
    ExptIncCOMPricingParam, ExptIgnoreCustWebIncParam, ExptIgnoreStockWebIncParam, 
    ExptIgnoreStockGrpWebIncParam, ExptCustFileNameParam, ExptStockFileNameParam, 
    ExptStockLocFileNameParam, ExptStockGroupFileNameParam, ExptTransFileNameParam, 
    ExptTransLinesFileNameParam, ExptZipFilesParam, ExptTransportTypeParam, 
    ExptDataTypeParam, ExptActiveParam, ExptTimeTypeParam, ExptFrequencyParam, 
    ExptTime1Param, ExptTime2Param, ExptDaysOfWeekParam, ExptCataloguesParam, 
    ExptCSVCustMAPFileParam, ExptCSVStockMAPFileParam, ExptCSVStockGrpMAPFileParam, 
    ExptCSVTransMAPFileParam, ExptLastExportAtParam, ExptCustLockFileParam, 
    ExptStockLockFileParam, ExptStockGrpLockFileParam, ExptTransLockFileParam, 
    ExptCustLockExtParam, ExptStockLockExtParam, ExptStockGrpLockExtParam, 
    ExptTransLockExtParam, ExptCustLockMethodParam, ExptStockLockMethodParam, 
    ExptStockGrpMethodParam, ExptTransLockMethodParam, ExptStockFilterParam, 
    ExptIgnoreCOMCustIncParam, ExptIgnoreCOMStockIncParam, ExptCommandLineParam, 
    ExptCustAccTypeFilterParam, ExptCustAccTypeFilterFlagParam, ExptStockWebFilterParam, 
    ExptStockWebFilterFlagParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusExportVariant

  //------------------------------

  TEbusDataWrite_EBusCatalogueVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,
    CatTitleParam, CatCreditLimitAppliesParam,
    CatOnHoldAppliesParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusCatalogueVariant

  //------------------------------

  TEbusDataWrite_EBusFTPVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,

    FTPSitePortParam, FTPSiteAddressParam, FTPUserNameParam,
    FTPPasswordParam, FTPRequestTimeOutParam, FTPProxyPortParam, FTPProxyAddressParam,
    FTPPassiveModeParam, FTPRootDirParam, FTPCustomerDirParam, FTPStockDirParam,
    FTPCOMPriceDirParam, FTPTransactionDirParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusFTPVariant

  //------------------------------

  TEbusDataWrite_EBusEmailVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,

    EmailEnabledParam, EmailAdminAddressParam,
    EmailNotifyAdminParam, EmailTypeParam, EmailServerNameParam, EmailAccountNameParam, 
    EmailAccountPasswordParam, EmailNotifySenderParam, EmailConfirmProcessingParam, 
    EmailCustomerAddrParam, EmailStockAddrParam, EmailCOMPriceAddrParam, 
    EmailTransactionAddrParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusEmailVariant

  //------------------------------

  TEbusDataWrite_EBusFileVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,

    FileCustomerDirParam, FileStockDirParam,
    FileStockGroupDirParam, FileTransDirParam, FileCOMPriceDirParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_EBusFileVariant

  //------------------------------

  TEbusDataWrite_PreserveDocFieldsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,

    InvOrderNoParam, InvBuyersOrderParam,
    InvProjectcodeParam, InvAnalysiscodeParam, InvSuppInvoiceParam, InvBuyersDeliveryParam, 
    InvFolioParam, InvPostedParam, InvPostedDateParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_PreserveDocFieldsVariant

  //------------------------------

  TEbusDataWrite_PreserveLineFieldsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, ebuscode1Param, ebuscode2Param,

    IdAbsLineNoParam, IdLineNoParam, IdFolioParam, IdProjectcodeParam, IdAnalysiscodeParam,
    IdBuyersOrderParam, IdBuyersLineRefParam, IdOrderNoParam, IdPDNNoParam, 
    IdPDNLineNoParam, IdValueParam, IDQtyParam, IdOrderLineNoParam, IdStockcodeParam, 
    IdDescriptionParam, IdDiscAmountParam, IdDiscCharParam, IdDisc2AmountParam, 
    IdDisc2CharParam, IdDisc3AmountParam, IdDisc3CharParam, IdDisc3TypeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite_PreserveLineFieldsVariant

  //------------------------------


  TEbusDataWrite = Class(TBaseDataWrite)
  Private
    FEBusParamsVariant : TEbusDataWrite_EBusParamsVariant;
    FEBusCompanyVariant : TEbusDataWrite_EBusCompanyVariant;
    FEBusFileCountersVariant : TEbusDataWrite_EBusFileCountersVariant;
    FEBusImportVariant : TEbusDataWrite_EBusImportVariant;
    FEBusExportVariant : TEbusDataWrite_EBusExportVariant;
    FEBusCatalogueVariant : TEbusDataWrite_EBusCatalogueVariant;
    FEBusFTPVariant : TEbusDataWrite_EBusFTPVariant;
    FEBusEmailVariant : TEbusDataWrite_EBusEmailVariant;
    FEBusFileVariant : TEbusDataWrite_EBusFileVariant;
    FPreserveDocFieldsVariant : TEbusDataWrite_PreserveDocFieldsVariant;
    FPreserveLineFieldsVariant : TEbusDataWrite_PreserveLineFieldsVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils, EbusVar;

//=========================================================================

Constructor TEbusDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FEBusParamsVariant := TEbusDataWrite_EBusParamsVariant.Create;
  FEBusCompanyVariant := TEbusDataWrite_EBusCompanyVariant.Create;
  FEBusFileCountersVariant := TEbusDataWrite_EBusFileCountersVariant.Create;
  FEBusImportVariant := TEbusDataWrite_EBusImportVariant.Create;
  FEBusExportVariant := TEbusDataWrite_EBusExportVariant.Create;
  FEBusCatalogueVariant := TEbusDataWrite_EBusCatalogueVariant.Create;
  FEBusFTPVariant := TEbusDataWrite_EBusFTPVariant.Create;
  FEBusEmailVariant := TEbusDataWrite_EBusEmailVariant.Create;
  FEBusFileVariant := TEbusDataWrite_EBusFileVariant.Create;
  FPreserveDocFieldsVariant := TEbusDataWrite_PreserveDocFieldsVariant.Create;
  FPreserveLineFieldsVariant := TEbusDataWrite_PreserveLineFieldsVariant.Create;
End; // Create


Destructor TEbusDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FEBusParamsVariant);
  FreeAndNIL(FEBusCompanyVariant);
  FreeAndNIL(FEBusFileCountersVariant);
  FreeAndNIL(FEBusImportVariant);
  FreeAndNIL(FEBusExportVariant);
  FreeAndNIL(FEBusCatalogueVariant);
  FreeAndNIL(FEBusFTPVariant);
  FreeAndNIL(FEBusEmailVariant);
  FreeAndNIL(FEBusFileVariant);
  FreeAndNIL(FPreserveDocFieldsVariant);
  FreeAndNIL(FPreserveLineFieldsVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FEBusParamsVariant.Prepare (ADOConnection, CompanyCode);
  FEBusCompanyVariant.Prepare (ADOConnection, CompanyCode);
  FEBusFileCountersVariant.Prepare (ADOConnection, CompanyCode);
  FEBusImportVariant.Prepare (ADOConnection, CompanyCode);
  FEBusExportVariant.Prepare (ADOConnection, CompanyCode);
  FEBusCatalogueVariant.Prepare (ADOConnection, CompanyCode);
  FEBusFTPVariant.Prepare (ADOConnection, CompanyCode);
  FEBusEmailVariant.Prepare (ADOConnection, CompanyCode);
  FEBusFileVariant.Prepare (ADOConnection, CompanyCode);
  FPreserveDocFieldsVariant.Prepare (ADOConnection, CompanyCode);
  FPreserveLineFieldsVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'G') Then
  Begin
    // EBusParams
    FEBusParamsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'G')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'C') Then
  Begin
    // EBusCompany
    FEBusCompanyVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'C')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'N') Then
  Begin
    // File Counters
    FEBusFileCountersVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'N')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'I') Then
  Begin
    // EbusImport
    FEBusImportVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'N')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'X') Then
  Begin
    // EbusExport
    FEBusExportVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'X')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'A') Then
  Begin
    // BillMatRec : BillMatType - Bill of Materials
    FEBusCatalogueVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'B') And (DataRec.SubType = 'M')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'F') Then
  Begin
    //  EbusFTP
    FEBusFTPVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'F')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'E') Then
  Begin
    // EbusEmail
    FEBusEmailVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'E')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'D') Then
  Begin
    // EbusFile
    FEBusFileVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'D')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'P') Then
  Begin
    // PreserveDocFields
    FPreserveDocFieldsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'P')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'Q') Then
  Begin
    // MoveCtrlRec : MoveCtrlType - Control rec for GL/STK Moves
    FPreserveLineFieldsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // (DataRec.RecPFix = 'E') And (DataRec.SubType = 'Q')
  Else
  Begin
    // Unknown Data - Log error and continue conversion
    SkipRecord := True;
    sDumpFile := DataPacket.DumpToFile;
    ConversionWarnings.AddWarning(TSQLUnknownVariantWarning.Create (DataPacket, sDumpFile, ToHexString(@DataRec^.RecPFix, 2 {RecPFix + SubType})));
    Logging.UnknownVariant(Trim(DataPacket.CompanyDetails.ccCompanyPath) + DataPacket.TaskDetails.dctPervasiveFilename, ToHexString(@DataRec^.RecPFix, 2 {RecPFix + SubType}), sDumpFile);
  End; // Else
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusParamsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' + 
                                           'SubType, ' + 
                                           'ebuscode1, ' + 
                                           'ebuscode2, ' + 
                                           'EntDefaultCompany, ' +
                                           'EntCSVMapFileDir, ' +
                                           'EntTextFileDir, ' +
                                           'EntPollFreq, ' +
                                           'EntSetupPassword ' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':EntDefaultCompany, ' +
                       ':EntCSVMapFileDir, ' +
                       ':EntTextFileDir, ' +
                       ':EntPollFreq, ' +
                       ':EntSetupPassword' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');
    EntDefaultCompanyParam := FindParam('EntDefaultCompany');
    EntCSVMapFileDirParam := FindParam('EntCSVMapFileDir');
    EntTextFileDirParam := FindParam('EntTextFileDir');
    EntPollFreqParam := FindParam('EntPollFreq');
    EntSetupPasswordParam := FindParam('EntSetupPassword');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusParamsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EBusParams Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    EntDefaultCompanyParam.Value := EntDefaultCompany;                                          // SQL=varchar, Delphi=string[6]
    EntCSVMapFileDirParam.Value := EntCSVMapFileDir;                                            // SQL=varchar, Delphi=string[50]
    EntTextFileDirParam.Value := EntTextFileDir;                                                // SQL=varchar, Delphi=string[50]
    EntPollFreqParam.Value := EntPollFreq;                                                      // SQL=bigint, Delphi=cardinal
    EntSetupPasswordParam.Value := EntSetupPassword;                                            // SQL=varchar, Delphi=string[12]
  End; // With DataRec^.PassEntryRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusCompanyVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  // CJS 2013-05-23 - ABSEXCH-11905 - 21.03 - SQL Data Migration Changes -
  //                  added CompDescLinesFromXML
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'CompPostingLogDir, ' +
                                           'CompDefCostCentre, ' +
                                           'CompDefDept, ' +
                                           'CompDefLocation, ' +
                                           'CompDefCustomer, ' +
                                           'CompDefSupplier, ' +
                                           'CompDefPurchNom, ' +
                                           'CompDefSalesNom, ' +
                                           'CompDefVATcode, ' +
                                           'CompSetPeriodMethod, ' +
                                           'CompPeriod, ' +
                                           'CompYear, ' +
                                           'CompKeepTransNo, ' +
                                           'CompPostHoldFlag, ' +
                                           'CompTransTextDir, ' +
                                           'CompOrdOKTextFile, ' +
                                           'CompOrdFailTextFile, ' +
                                           'CompInvOKTextFile, ' +
                                           'CompInvFailTextFile, ' +
                                           'CompXMLAfterProcess, ' +
                                           'CompCSVDelimiter, ' +
                                           'CompCSVSeparator, ' +
                                           'CompCSVIncHeaderRow, ' +
                                           'CompFreightLine, ' +
                                           'CompMiscLine, ' +
                                           'CompDiscount, ' +
                                           'CompCustLockFile, ' +
                                           'CompStockLockFile, ' +
                                           'CompStockGrpLockFile, ' +
                                           'CompTransLockFile, ' +
                                           'CompCustLockExt, ' +
                                           'CompStockLockExt, ' +
                                           'CompStockGrpLockExt, ' +
                                           'CompTransLockExt, ' +
                                           'CompCustLockMethod, ' +
                                           'CompStockLockMethod, ' +
                                           'CompStockGrpMethod, ' +
                                           'CompTransLockMethod, ' +
                                           'CompUseStockForCharges, ' +
                                           'CompFreightStockcode, ' +
                                           'CompMiscStockcode, ' +
                                           'CompDiscStockcode, ' +
                                           'CompFreightDesc, ' +
                                           'CompMiscDesc, ' +
                                           'CompDiscDesc, ' +
                                           'CompReapplyPricing, ' +
                                           'CompYourRefToAltRef, ' +
                                           'CompUseMatching, ' +
                                           'CompSentimailEvent, ' +
                                           'CompLocationOrigin, ' +
                                           'CompImportUDF1, ' +
                                           'CompGeneralNotes, ' +
                                           'CompCCDepFromXML, ' +
                                           'CompUseBasda309, ' +
                                           'CompDescLinesFromXML ' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':CompPostingLogDir, ' +
                       ':CompDefCostCentre, ' +
                       ':CompDefDept, ' +
                       ':CompDefLocation, ' +
                       ':CompDefCustomer, ' +
                       ':CompDefSupplier, ' +
                       ':CompDefPurchNom, ' +
                       ':CompDefSalesNom, ' +
                       ':CompDefVATcode, ' +
                       ':CompSetPeriodMethod, ' +
                       ':CompPeriod, ' +
                       ':CompYear, ' +
                       ':CompKeepTransNo, ' +
                       ':CompPostHoldFlag, ' +
                       ':CompTransTextDir, ' +
                       ':CompOrdOKTextFile, ' +
                       ':CompOrdFailTextFile, ' +
                       ':CompInvOKTextFile, ' +
                       ':CompInvFailTextFile, ' +
                       ':CompXMLAfterProcess, ' +
                       ':CompCSVDelimiter, ' +
                       ':CompCSVSeparator, ' +
                       ':CompCSVIncHeaderRow, ' +
                       ':CompFreightLine, ' +
                       ':CompMiscLine, ' +
                       ':CompDiscount, ' +
                       ':CompCustLockFile, ' +
                       ':CompStockLockFile, ' +
                       ':CompStockGrpLockFile, ' +
                       ':CompTransLockFile, ' +
                       ':CompCustLockExt, ' +
                       ':CompStockLockExt, ' +
                       ':CompStockGrpLockExt, ' +
                       ':CompTransLockExt, ' +
                       ':CompCustLockMethod, ' +
                       ':CompStockLockMethod, ' +
                       ':CompStockGrpMethod, ' +
                       ':CompTransLockMethod, ' +
                       ':CompUseStockForCharges, ' +
                       ':CompFreightStockcode, ' +
                       ':CompMiscStockcode, ' +
                       ':CompDiscStockcode, ' +
                       ':CompFreightDesc, ' +
                       ':CompMiscDesc, ' +
                       ':CompDiscDesc, ' +
                       ':CompReapplyPricing, ' +
                       ':CompYourRefToAltRef, ' +
                       ':CompUseMatching, ' +
                       ':CompSentimailEvent, ' +
                       ':CompLocationOrigin, ' +
                       ':CompImportUDF1, ' +
                       ':CompGeneralNotes, ' +
                       ':CompCCDepFromXML, ' +
                       ':CompUseBasda309, ' +
                       ':CompDescLinesFromXML ' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    CompPostingLogDirParam := FindParam('CompPostingLogDir');
    CompDefCostCentreParam := FindParam('CompDefCostCentre');
    CompDefDeptParam := FindParam('CompDefDept');
    CompDefLocationParam := FindParam('CompDefLocation');
    CompDefCustomerParam := FindParam('CompDefCustomer');
    CompDefSupplierParam := FindParam('CompDefSupplier');
    CompDefPurchNomParam := FindParam('CompDefPurchNom');
    CompDefSalesNomParam := FindParam('CompDefSalesNom');
    CompDefVATcodeParam := FindParam('CompDefVATcode');
    CompSetPeriodMethodParam := FindParam('CompSetPeriodMethod');
    CompPeriodParam := FindParam('CompPeriod');
    CompYearParam := FindParam('CompYear');
    CompKeepTransNoParam := FindParam('CompKeepTransNo');
    CompPostHoldFlagParam := FindParam('CompPostHoldFlag');
    CompTransTextDirParam := FindParam('CompTransTextDir');
    CompOrdOKTextFileParam := FindParam('CompOrdOKTextFile');
    CompOrdFailTextFileParam := FindParam('CompOrdFailTextFile');
    CompInvOKTextFileParam := FindParam('CompInvOKTextFile');
    CompInvFailTextFileParam := FindParam('CompInvFailTextFile');
    CompXMLAfterProcessParam := FindParam('CompXMLAfterProcess');
    CompCSVDelimiterParam := FindParam('CompCSVDelimiter');
    CompCSVSeparatorParam := FindParam('CompCSVSeparator');
    CompCSVIncHeaderRowParam := FindParam('CompCSVIncHeaderRow');
    CompFreightLineParam := FindParam('CompFreightLine');
    CompMiscLineParam := FindParam('CompMiscLine');
    CompDiscountParam := FindParam('CompDiscount');
    CompCustLockFileParam := FindParam('CompCustLockFile');
    CompStockLockFileParam := FindParam('CompStockLockFile');
    CompStockGrpLockFileParam := FindParam('CompStockGrpLockFile');
    CompTransLockFileParam := FindParam('CompTransLockFile');
    CompCustLockExtParam := FindParam('CompCustLockExt');
    CompStockLockExtParam := FindParam('CompStockLockExt');
    CompStockGrpLockExtParam := FindParam('CompStockGrpLockExt');
    CompTransLockExtParam := FindParam('CompTransLockExt');
    CompCustLockMethodParam := FindParam('CompCustLockMethod');
    CompStockLockMethodParam := FindParam('CompStockLockMethod');
    CompStockGrpMethodParam := FindParam('CompStockGrpMethod');
    CompTransLockMethodParam := FindParam('CompTransLockMethod');
    CompUseStockForChargesParam := FindParam('CompUseStockForCharges');
    CompFreightStockcodeParam := FindParam('CompFreightStockcode');
    CompMiscStockcodeParam := FindParam('CompMiscStockcode');
    CompDiscStockcodeParam := FindParam('CompDiscStockcode');
    CompFreightDescParam := FindParam('CompFreightDesc');
    CompMiscDescParam := FindParam('CompMiscDesc');
    CompDiscDescParam := FindParam('CompDiscDesc');
    CompReapplyPricingParam := FindParam('CompReapplyPricing');
    CompYourRefToAltRefParam := FindParam('CompYourRefToAltRef');
    CompUseMatchingParam := FindParam('CompUseMatching');
    CompSentimailEventParam := FindParam('CompSentimailEvent');
    CompLocationOriginParam := FindParam('CompLocationOrigin');
    CompImportUDF1Param := FindParam('CompImportUDF1');
    CompGeneralNotesParam := FindParam('CompGeneralNotes');
    CompCCDepFromXMLParam := FindParam('CompCCDepFromXML');
    CompUseBasda309Param := FindParam('CompUseBasda309');
    // CJS 2013-05-23 - ABSEXCH-11905 - 21.03 - SQL Data Migration Changes -
    //                  added CompDescLinesFromXML
    CompDescLinesFromXMLParam := FindParam('CompDescLinesFromXML');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusCompanyVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EBusCompany Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    CompPostingLogDirParam.Value := CompPostingLogDir;                                          // SQL=varchar, Delphi=string[50]
    CompDefCostCentreParam.Value := CompDefCostCentre;                                          // SQL=varchar, Delphi=string[3]
    CompDefDeptParam.Value := CompDefDept;                                                      // SQL=varchar, Delphi=string[3]
    CompDefLocationParam.Value := CompDefLocation;                                              // SQL=varchar, Delphi=string[3]
    CompDefCustomerParam.Value := CompDefCustomer;                                              // SQL=varchar, Delphi=string[10]
    CompDefSupplierParam.Value := CompDefSupplier;                                              // SQL=varchar, Delphi=string[10]
    CompDefPurchNomParam.Value := CompDefPurchNom;                                              // SQL=int, Delphi=longint
    CompDefSalesNomParam.Value := CompDefSalesNom;                                              // SQL=int, Delphi=longint
    CompDefVATcodeParam.Value := ConvertCharToSQLEmulatorVarChar(CompDefVATCode);               // SQL=varchar, Delphi=char
    CompSetPeriodMethodParam.Value := CompSetPeriodMethod;                                      // SQL=int, Delphi=byte
    CompPeriodParam.Value := CompPeriod;                                                        // SQL=int, Delphi=byte
    CompYearParam.Value := CompYear;                                                            // SQL=int, Delphi=byte
    CompKeepTransNoParam.Value := CompKeepTransNo;                                              // SQL=int, Delphi=byte
    CompPostHoldFlagParam.Value := CompPostHoldFlag;                                            // SQL=int, Delphi=byte
    CompTransTextDirParam.Value := CompTransTextDir;                                            // SQL=varchar, Delphi=string[50]
    CompOrdOKTextFileParam.Value := CompOrdOKTextFile;                                          // SQL=varchar, Delphi=string[12]
    CompOrdFailTextFileParam.Value := CompOrdFailTextFile;                                      // SQL=varchar, Delphi=string[12]
    CompInvOKTextFileParam.Value := CompInvOKTextFile;                                          // SQL=varchar, Delphi=string[12]
    CompInvFailTextFileParam.Value := CompInvFailTextFile;                                      // SQL=varchar, Delphi=string[12]
    CompXMLAfterProcessParam.Value := CompXMLAfterProcess;                                      // SQL=int, Delphi=byte
    CompCSVDelimiterParam.Value := ConvertCharToSQLEmulatorVarChar(CompCSVDelimiter);           // SQL=varchar, Delphi=char
    CompCSVSeparatorParam.Value := ConvertCharToSQLEmulatorVarChar(CompCSVSeparator);           // SQL=varchar, Delphi=char
    CompCSVIncHeaderRowParam.Value := CompCSVIncHeaderRow;                                      // SQL=int, Delphi=byte
    CompFreightLineParam.Value := CompFreightLine;                                              // SQL=int, Delphi=byte
    CompMiscLineParam.Value := CompMiscLine;                                                    // SQL=int, Delphi=byte
    CompDiscountParam.Value := CompDiscount;                                                    // SQL=int, Delphi=byte
    CompCustLockFileParam.Value := CompCustLockFile;                                            // SQL=varchar, Delphi=string[12]
    CompStockLockFileParam.Value := CompStockLockFile;                                          // SQL=varchar, Delphi=string[12]
    CompStockGrpLockFileParam.Value := CompStockGrpLockFile;                                    // SQL=varchar, Delphi=string[12]
    CompTransLockFileParam.Value := CompTransLockFile;                                          // SQL=varchar, Delphi=string[12]
    CompCustLockExtParam.Value := CompCustLockExt;                                              // SQL=varchar, Delphi=string[3]
    CompStockLockExtParam.Value := CompStockLockExt;                                            // SQL=varchar, Delphi=string[3]
    CompStockGrpLockExtParam.Value := CompStockGrpLockExt;                                      // SQL=varchar, Delphi=string[3]
    CompTransLockExtParam.Value := CompTransLockExt;                                            // SQL=varchar, Delphi=string[3]
    CompCustLockMethodParam.Value := CompCustLockMethod;                                        // SQL=int, Delphi=byte
    CompStockLockMethodParam.Value := CompStockLockMethod;                                      // SQL=int, Delphi=byte
    CompStockGrpMethodParam.Value := CompStockGrpMethod;                                        // SQL=int, Delphi=byte
    CompTransLockMethodParam.Value := CompTransLockMethod;                                      // SQL=int, Delphi=byte
    CompUseStockForChargesParam.Value := CompUseStockForCharges;                                // SQL=int, Delphi=byte
    CompFreightStockcodeParam.Value := CompFreightStockCode;                                    // SQL=varchar, Delphi=string[16]
    CompMiscStockcodeParam.Value := CompMiscStockCode;                                          // SQL=varchar, Delphi=string[16]
    CompDiscStockcodeParam.Value := CompDiscStockCode;                                          // SQL=varchar, Delphi=string[16]
    CompFreightDescParam.Value := CompFreightDesc;                                              // SQL=varchar, Delphi=string[40]
    CompMiscDescParam.Value := CompMiscDesc;                                                    // SQL=varchar, Delphi=string[40]
    CompDiscDescParam.Value := CompDiscDesc;                                                    // SQL=varchar, Delphi=string[40]
    CompReapplyPricingParam.Value := CompReapplyPricing;                                        // SQL=int, Delphi=byte
    CompYourRefToAltRefParam.Value := CompYourRefToAltRef;                                      // SQL=bit, Delphi=Boolean
    CompUseMatchingParam.Value := CompUseMatching;                                              // SQL=bit, Delphi=Boolean
    CompSentimailEventParam.Value := CompSentimailEvent;                                        // SQL=bit, Delphi=Boolean
    CompLocationOriginParam.Value := CompLocationOrigin;                                        // SQL=int, Delphi=Byte
    CompImportUDF1Param.Value := CompImportUDF1;                                                // SQL=bit, Delphi=Boolean
    CompGeneralNotesParam.Value := CompGeneralNotes;                                            // SQL=bit, Delphi=Boolean
    CompCCDepFromXMLParam.Value := CompCCDepFromXML;                                            // SQL=bit, Delphi=Boolean
    CompUseBasda309Param.Value := CompUseBasda309;                                              // SQL=bit, Delphi=Boolean
    // CJS 2013-05-23 - ABSEXCH-11905 - 21.03 - SQL Data Migration Changes -
    //                  added CompDescLinesFromXML
    CompDescLinesFromXMLParam.Value := CompDescLinesFromXML;                                    // SQL=bit, Delphi=Boolean
  End; // With DataRec^, PassEntryRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusFileCountersVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'stockcounter, ' +
                                           'stockgrpcounter, ' +
                                           'transactioncounter, ' +
                                           'CustomerCounter, ' +
                                           'emailcounter, ' +
                                           'exportlogcounter' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':stockcounter, ' +
                       ':stockgrpcounter, ' +
                       ':transactioncounter, ' +
                       ':CustomerCounter, ' +
                       ':emailcounter, ' +
                       ':exportlogcounter' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    stockcounterParam := FindParam('stockcounter');
    stockgrpcounterParam := FindParam('stockgrpcounter');
    transactioncounterParam := FindParam('transactioncounter');
    CustomerCounterParam := FindParam('CustomerCounter');
    emailcounterParam := FindParam('emailcounter');
    exportlogcounterParam := FindParam('exportlogcounter');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusFileCountersVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;

  //The EbusFileCounters variant isn't actually declared in the TEbusRec structure, so we need to
  //move the data to a local record.
  FileCounters : TEbusFileCounters;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;


  Move(DataRec^.EBusParams, FileCounters, SizeOf(FileCounters));

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, FileCounters Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    stockcounterParam.Value := StockCounter;                                                    // SQL=int, Delphi=longint
    stockgrpcounterParam.Value := StockGrpCounter;                                              // SQL=int, Delphi=longint
    transactioncounterParam.Value := TransactionCounter;                                        // SQL=int, Delphi=longint
    CustomerCounterParam.Value := CustomerCounter;                                              // SQL=int, Delphi=longint
    emailcounterParam.Value := EmailCounter;                                                    // SQL=int, Delphi=longint
    exportlogcounterParam.Value := ExportLogCounter;                                            // SQL=int, Delphi=longint
  End; // With DataRec^, NotesRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusImportVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'ImportSearchDir, ' +
                                           'ImportArchiveDir, ' +
                                           'ImportFailDir, ' +
                                           'ImportLogDir' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':ImportSearchDir, ' +
                       ':ImportArchiveDir, ' +
                       ':ImportFailDir, ' +
                       ':ImportLogDir' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    ImportSearchDirParam := FindParam('ImportSearchDir');
    ImportArchiveDirParam := FindParam('ImportArchiveDir');
    ImportFailDirParam := FindParam('ImportFailDir');
    ImportLogDirParam := FindParam('ImportLogDir');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusImportVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EBusImport Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    ImportSearchDirParam.Value := ImportSearchDir;                                              // SQL=varchar, Delphi=string[50]
    ImportArchiveDirParam.Value := ImportArchiveDir;                                            // SQL=varchar, Delphi=string[50]
    ImportFailDirParam.Value := ImportFailDir;                                                  // SQL=varchar, Delphi=string[50]
    ImportLogDirParam.Value := ImportLogDir;                                                    // SQL=varchar, Delphi=string[50]
  End; // With DataRec^, NotesRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusExportVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'ExptDescription, ' +
                                           'ExptStock, ' +
                                           'ExptStockGroups, ' +
                                           'ExptCustomers, ' +
                                           'ExptIncCurSalesTrans, ' +
                                           'ExptIncCurSalesOrders, ' +
                                           'ExptIncCurPurchTrans, ' +
                                           'ExptIncCurPurchOrders, ' +
                                           'ExptIncCOMPricing, ' +
                                           'ExptIgnoreCustWebInc, ' +
                                           'ExptIgnoreStockWebInc, ' +
                                           'ExptIgnoreStockGrpWebInc, ' +
                                           'ExptCustFileName, ' +
                                           'ExptStockFileName, ' +
                                           'ExptStockLocFileName, ' +
                                           'ExptStockGroupFileName, ' +
                                           'ExptTransFileName, ' +
                                           'ExptTransLinesFileName, ' +
                                           'ExptZipFiles, ' +
                                           'ExptTransportType, ' +
                                           'ExptDataType, ' +
                                           'ExptActive, ' +
                                           'ExptTimeType, ' +
                                           'ExptFrequency, ' +
                                           'ExptTime1, ' +
                                           'ExptTime2, ' +
                                           'ExptDaysOfWeek, ' +
                                           'ExptCatalogues, ' +
                                           'ExptCSVCustMAPFile, ' +
                                           'ExptCSVStockMAPFile, ' +
                                           'ExptCSVStockGrpMAPFile, ' +
                                           'ExptCSVTransMAPFile, ' +
                                           'ExptLastExportAt, ' +
                                           'ExptCustLockFile, ' +
                                           'ExptStockLockFile, ' +
                                           'ExptStockGrpLockFile, ' +
                                           'ExptTransLockFile, ' +
                                           'ExptCustLockExt, ' +
                                           'ExptStockLockExt, ' +
                                           'ExptStockGrpLockExt, ' +
                                           'ExptTransLockExt, ' +
                                           'ExptCustLockMethod, ' +
                                           'ExptStockLockMethod, ' +
                                           'ExptStockGrpMethod, ' +
                                           'ExptTransLockMethod, ' +
                                           'ExptStockFilter, ' +
                                           'ExptIgnoreCOMCustInc, ' +
                                           'ExptIgnoreCOMStockInc, ' +
                                           'ExptCommandLine, ' +
                                           'ExptCustAccTypeFilter, ' +
                                           'ExptCustAccTypeFilterFlag, ' +
                                           'ExptStockWebFilter, ' +
                                           'ExptStockWebFilterFlag' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':ExptDescription, ' +
                       ':ExptStock, ' +
                       ':ExptStockGroups, ' +
                       ':ExptCustomers, ' +
                       ':ExptIncCurSalesTrans, ' +
                       ':ExptIncCurSalesOrders, ' +
                       ':ExptIncCurPurchTrans, ' +
                       ':ExptIncCurPurchOrders, ' +
                       ':ExptIncCOMPricing, ' +
                       ':ExptIgnoreCustWebInc, ' +
                       ':ExptIgnoreStockWebInc, ' +
                       ':ExptIgnoreStockGrpWebInc, ' +
                       ':ExptCustFileName, ' +
                       ':ExptStockFileName, ' +
                       ':ExptStockLocFileName, ' +
                       ':ExptStockGroupFileName, ' +
                       ':ExptTransFileName, ' +
                       ':ExptTransLinesFileName, ' +
                       ':ExptZipFiles, ' +
                       ':ExptTransportType, ' +
                       ':ExptDataType, ' +
                       ':ExptActive, ' +
                       ':ExptTimeType, ' +
                       ':ExptFrequency, ' +
                       ':ExptTime1, ' +
                       ':ExptTime2, ' +
                       ':ExptDaysOfWeek, ' +
                       ':ExptCatalogues, ' +
                       ':ExptCSVCustMAPFile, ' +
                       ':ExptCSVStockMAPFile, ' +
                       ':ExptCSVStockGrpMAPFile, ' +
                       ':ExptCSVTransMAPFile, ' +
                       ':ExptLastExportAt, ' +
                       ':ExptCustLockFile, ' +
                       ':ExptStockLockFile, ' +
                       ':ExptStockGrpLockFile, ' +
                       ':ExptTransLockFile, ' +
                       ':ExptCustLockExt, ' +
                       ':ExptStockLockExt, ' +
                       ':ExptStockGrpLockExt, ' +
                       ':ExptTransLockExt, ' +
                       ':ExptCustLockMethod, ' +
                       ':ExptStockLockMethod, ' +
                       ':ExptStockGrpMethod, ' +
                       ':ExptTransLockMethod, ' +
                       ':ExptStockFilter, ' +
                       ':ExptIgnoreCOMCustInc, ' +
                       ':ExptIgnoreCOMStockInc, ' +
                       ':ExptCommandLine, ' +
                       ':ExptCustAccTypeFilter, ' +
                       ':ExptCustAccTypeFilterFlag, ' +
                       ':ExptStockWebFilter, ' +
                       ':ExptStockWebFilterFlag' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    ExptDescriptionParam := FindParam('ExptDescription');
    ExptStockParam := FindParam('ExptStock');
    ExptStockGroupsParam := FindParam('ExptStockGroups');
    ExptCustomersParam := FindParam('ExptCustomers');
    ExptIncCurSalesTransParam := FindParam('ExptIncCurSalesTrans');
    ExptIncCurSalesOrdersParam := FindParam('ExptIncCurSalesOrders');
    ExptIncCurPurchTransParam := FindParam('ExptIncCurPurchTrans');
    ExptIncCurPurchOrdersParam := FindParam('ExptIncCurPurchOrders');
    ExptIncCOMPricingParam := FindParam('ExptIncCOMPricing');
    ExptIgnoreCustWebIncParam := FindParam('ExptIgnoreCustWebInc');
    ExptIgnoreStockWebIncParam := FindParam('ExptIgnoreStockWebInc');
    ExptIgnoreStockGrpWebIncParam := FindParam('ExptIgnoreStockGrpWebInc');
    ExptCustFileNameParam := FindParam('ExptCustFileName');
    ExptStockFileNameParam := FindParam('ExptStockFileName');
    ExptStockLocFileNameParam := FindParam('ExptStockLocFileName');
    ExptStockGroupFileNameParam := FindParam('ExptStockGroupFileName');
    ExptTransFileNameParam := FindParam('ExptTransFileName');
    ExptTransLinesFileNameParam := FindParam('ExptTransLinesFileName');
    ExptZipFilesParam := FindParam('ExptZipFiles');
    ExptTransportTypeParam := FindParam('ExptTransportType');
    ExptDataTypeParam := FindParam('ExptDataType');
    ExptActiveParam := FindParam('ExptActive');
    ExptTimeTypeParam := FindParam('ExptTimeType');
    ExptFrequencyParam := FindParam('ExptFrequency');
    ExptTime1Param := FindParam('ExptTime1');
    ExptTime2Param := FindParam('ExptTime2');
    ExptDaysOfWeekParam := FindParam('ExptDaysOfWeek');
    ExptCataloguesParam := FindParam('ExptCatalogues');
    ExptCSVCustMAPFileParam := FindParam('ExptCSVCustMAPFile');
    ExptCSVStockMAPFileParam := FindParam('ExptCSVStockMAPFile');
    ExptCSVStockGrpMAPFileParam := FindParam('ExptCSVStockGrpMAPFile');
    ExptCSVTransMAPFileParam := FindParam('ExptCSVTransMAPFile');
    ExptLastExportAtParam := FindParam('ExptLastExportAt');
    ExptCustLockFileParam := FindParam('ExptCustLockFile');
    ExptStockLockFileParam := FindParam('ExptStockLockFile');
    ExptStockGrpLockFileParam := FindParam('ExptStockGrpLockFile');
    ExptTransLockFileParam := FindParam('ExptTransLockFile');
    ExptCustLockExtParam := FindParam('ExptCustLockExt');
    ExptStockLockExtParam := FindParam('ExptStockLockExt');
    ExptStockGrpLockExtParam := FindParam('ExptStockGrpLockExt');
    ExptTransLockExtParam := FindParam('ExptTransLockExt');
    ExptCustLockMethodParam := FindParam('ExptCustLockMethod');
    ExptStockLockMethodParam := FindParam('ExptStockLockMethod');
    ExptStockGrpMethodParam := FindParam('ExptStockGrpMethod');
    ExptTransLockMethodParam := FindParam('ExptTransLockMethod');
    ExptStockFilterParam := FindParam('ExptStockFilter');
    ExptIgnoreCOMCustIncParam := FindParam('ExptIgnoreCOMCustInc');
    ExptIgnoreCOMStockIncParam := FindParam('ExptIgnoreCOMStockInc');
    ExptCommandLineParam := FindParam('ExptCommandLine');
    ExptCustAccTypeFilterParam := FindParam('ExptCustAccTypeFilter');
    ExptCustAccTypeFilterFlagParam := FindParam('ExptCustAccTypeFilterFlag');
    ExptStockWebFilterParam := FindParam('ExptStockWebFilter');
    ExptStockWebFilterFlagParam := FindParam('ExptStockWebFilterFlag');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusExportVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EBusExport Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    ExptDescriptionParam.Value := ExptDescription;                                              // SQL=varchar, Delphi=string[50]
    ExptStockParam.Value := ExptStock;                                                          // SQL=int, Delphi=byte
    ExptStockGroupsParam.Value := ExptStockGroups;                                              // SQL=int, Delphi=byte
    ExptCustomersParam.Value := ExptCustomers;                                                  // SQL=int, Delphi=byte
    ExptIncCurSalesTransParam.Value := ExptIncCurSalesTrans;                                    // SQL=int, Delphi=byte
    ExptIncCurSalesOrdersParam.Value := ExptIncCurSalesOrders;                                  // SQL=int, Delphi=byte
    ExptIncCurPurchTransParam.Value := ExptIncCurPurchTrans;                                    // SQL=int, Delphi=byte
    ExptIncCurPurchOrdersParam.Value := ExptIncCurPurchOrders;                                  // SQL=int, Delphi=byte
    ExptIncCOMPricingParam.Value := ExptIncCOMPricing;                                          // SQL=int, Delphi=byte
    ExptIgnoreCustWebIncParam.Value := ExptIgnoreCustWebInc;                                    // SQL=int, Delphi=byte
    ExptIgnoreStockWebIncParam.Value := ExptIgnoreStockWebInc;                                  // SQL=int, Delphi=byte
    ExptIgnoreStockGrpWebIncParam.Value := ExptIgnoreStockGrpWebInc;                            // SQL=int, Delphi=byte
    ExptCustFileNameParam.Value := ExptCustFileName;                                            // SQL=varchar, Delphi=string[12]
    ExptStockFileNameParam.Value := ExptStockFileName;                                          // SQL=varchar, Delphi=string[12]
    ExptStockLocFileNameParam.Value := ExptStockLocFileName;                                    // SQL=varchar, Delphi=string[12]
    ExptStockGroupFileNameParam.Value := ExptStockGroupFileName;                                // SQL=varchar, Delphi=string[12]
    ExptTransFileNameParam.Value := ExptTransFileName;                                          // SQL=varchar, Delphi=string[12]
    ExptTransLinesFileNameParam.Value := ExptTransLinesFileName;                                // SQL=varchar, Delphi=string[12]
    ExptZipFilesParam.Value := ExptZipFiles;                                                    // SQL=int, Delphi=byte
    ExptTransportTypeParam.Value := ConvertCharToSQLEmulatorVarChar(ExptTransportType);         // SQL=varchar, Delphi=char
    ExptDataTypeParam.Value := ConvertCharToSQLEmulatorVarChar(ExptDataType);                   // SQL=varchar, Delphi=char
    ExptActiveParam.Value := ExptActive;                                                        // SQL=int, Delphi=byte
    ExptTimeTypeParam.Value := ExptTimeType;                                                    // SQL=int, Delphi=byte
    ExptFrequencyParam.Value := ExptFrequency;                                                  // SQL=int, Delphi=smallint
    ExptTime1Param.Value := DateTimeToSQLDateTimeOrNull(ExptTime1);                              // SQL=datetime, Delphi=TDateTime
    ExptTime2Param.Value := DateTimeToSQLDateTimeOrNull(ExptTime2);                              // SQL=datetime, Delphi=TDateTime
    ExptDaysOfWeekParam.Value := ExptDaysOfWeek;                                                // SQL=int, Delphi=byte
    ExptCataloguesParam.Value := ExptCatalogues;                                                // SQL=varchar, Delphi=string[20]
    ExptCSVCustMAPFileParam.Value := ExptCSVCustMAPFile;                                        // SQL=varchar, Delphi=string[12]
    ExptCSVStockMAPFileParam.Value := ExptCSVStockMAPFile;                                      // SQL=varchar, Delphi=string[12]
    ExptCSVStockGrpMAPFileParam.Value := ExptCSVStockGrpMAPFile;                                // SQL=varchar, Delphi=string[12]
    ExptCSVTransMAPFileParam.Value := ExptCSVTransMAPFile;                                      // SQL=varchar, Delphi=string[12]
    ExptLastExportAtParam.Value := DateTimeToSQLDateTimeOrNull(ExptLastExportAt);               // SQL=datetime, Delphi=TDateTime
    ExptCustLockFileParam.Value := ExptCustLockFile;                                            // SQL=varchar, Delphi=string[12]
    ExptStockLockFileParam.Value := ExptStockLockFile;                                          // SQL=varchar, Delphi=string[12]
    ExptStockGrpLockFileParam.Value := ExptStockGrpLockFile;                                    // SQL=varchar, Delphi=string[12]
    ExptTransLockFileParam.Value := ExptTransLockFile;                                          // SQL=varchar, Delphi=string[12]
    ExptCustLockExtParam.Value := ExptCustLockExt;                                              // SQL=varchar, Delphi=string[3]
    ExptStockLockExtParam.Value := ExptStockLockExt;                                            // SQL=varchar, Delphi=string[3]
    ExptStockGrpLockExtParam.Value := ExptStockGrpLockExt;                                      // SQL=varchar, Delphi=string[3]
    ExptTransLockExtParam.Value := ExptTransLockExt;                                            // SQL=varchar, Delphi=string[3]
    ExptCustLockMethodParam.Value := ExptCustLockMethod;                                        // SQL=int, Delphi=byte
    ExptStockLockMethodParam.Value := ExptStockLockMethod;                                      // SQL=int, Delphi=byte
    ExptStockGrpMethodParam.Value := ExptStockGrpMethod;                                        // SQL=int, Delphi=byte
    ExptTransLockMethodParam.Value := ExptTransLockMethod;                                      // SQL=int, Delphi=byte
    ExptStockFilterParam.Value := ExptStockFilter;                                              // SQL=varchar, Delphi=string[16]
    ExptIgnoreCOMCustIncParam.Value := ExptIgnoreCOMCustInc;                                    // SQL=int, Delphi=byte
    ExptIgnoreCOMStockIncParam.Value := ExptIgnoreCOMStockInc;                                  // SQL=int, Delphi=byte
    ExptCommandLineParam.Value := ExptCommandLine;                                              // SQL=varchar, Delphi=string[100]
    ExptCustAccTypeFilterParam.Value := ExptCustAccTypeFilter;                                  // SQL=varchar, Delphi=string[4]
    ExptCustAccTypeFilterFlagParam.Value := ExptCustAccTypeFilterFlag;                          // SQL=int, Delphi=byte
    ExptStockWebFilterParam.Value := ExptStockWebFilter;                                        // SQL=varchar, Delphi=string[20]
    ExptStockWebFilterFlagParam.Value := ExptStockWebFilterFlag;                                // SQL=int, Delphi=byte
  End; // With DataRec^.MatchPayRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusCatalogueVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' + 
                                           'ebuscode1, ' + 
                                           'ebuscode2, ' + 
                                           'CatTitle, ' +
                                           'CatCreditLimitApplies, ' +
                                           'CatOnHoldApplies' +
                                           ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':CatTitle, ' +
                       ':CatCreditLimitApplies, ' +
                       ':CatOnHoldApplies' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    CatTitleParam := FindParam('CatTitle');
    CatCreditLimitAppliesParam := FindParam('CatCreditLimitApplies');
    CatOnHoldAppliesParam := FindParam('CatOnHoldApplies');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusCatalogueVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EBusCatalogue Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    CatTitleParam.Value := CatTitle;                                                            // SQL=varchar, Delphi=string[40]
    CatCreditLimitAppliesParam.Value := CatCreditLimitApplies;                                  // SQL=bit, Delphi=boolean
    CatOnHoldAppliesParam.Value := CatOnHoldApplies;                                            // SQL=bit, Delphi=boolean
  End; // With DataRec^, BillMatRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusFTPVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'FTPSitePort, ' +
                                           'FTPSiteAddress, ' +
                                           'FTPUserName, ' +
                                           'FTPPassword, ' +
                                           'FTPRequestTimeOut, ' +
                                           'FTPProxyPort, ' +
                                           'FTPProxyAddress, ' +
                                           'FTPPassiveMode, ' +
                                           'FTPRootDir, ' +
                                           'FTPCustomerDir, ' +
                                           'FTPStockDir, ' +
                                           'FTPCOMPriceDir, ' +
                                           'FTPTransactionDir' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':FTPSitePort, ' +
                       ':FTPSiteAddress, ' +
                       ':FTPUserName, ' +
                       ':FTPPassword, ' +
                       ':FTPRequestTimeOut, ' +
                       ':FTPProxyPort, ' +
                       ':FTPProxyAddress, ' +
                       ':FTPPassiveMode, ' +
                       ':FTPRootDir, ' +
                       ':FTPCustomerDir, ' +
                       ':FTPStockDir, ' +
                       ':FTPCOMPriceDir, ' +
                       ':FTPTransactionDir' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    FTPSitePortParam := FindParam('FTPSitePort');
    FTPSiteAddressParam := FindParam('FTPSiteAddress');
    FTPUserNameParam := FindParam('FTPUserName');
    FTPPasswordParam := FindParam('FTPPassword');
    FTPRequestTimeOutParam := FindParam('FTPRequestTimeOut');
    FTPProxyPortParam := FindParam('FTPProxyPort');
    FTPProxyAddressParam := FindParam('FTPProxyAddress');
    FTPPassiveModeParam := FindParam('FTPPassiveMode');
    FTPRootDirParam := FindParam('FTPRootDir');
    FTPCustomerDirParam := FindParam('FTPCustomerDir');
    FTPStockDirParam := FindParam('FTPStockDir');
    FTPCOMPriceDirParam := FindParam('FTPCOMPriceDir');
    FTPTransactionDirParam := FindParam('FTPTransactionDir');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusFTPVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EbusFTP Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    FTPSitePortParam.Value := FTPSitePort;                                                      // SQL=int, Delphi=longint
    FTPSiteAddressParam.Value := FTPSiteAddress;                                                // SQL=varchar, Delphi=string[40]
    FTPUserNameParam.Value := FTPUserName;                                                      // SQL=varchar, Delphi=string[20]
    FTPPasswordParam.Value := FTPPassword;                                                      // SQL=varchar, Delphi=string[20]
    FTPRequestTimeOutParam.Value := FTPRequestTimeOut;                                          // SQL=int, Delphi=shortint
    FTPProxyPortParam.Value := FTPProxyPort;                                                    // SQL=int, Delphi=longint
    FTPProxyAddressParam.Value := FTPProxyAddress;                                              // SQL=varchar, Delphi=string[40]
    FTPPassiveModeParam.Value := FTPPassiveMode;                                                // SQL=int, Delphi=shortint
    FTPRootDirParam.Value := FTPRootDir;                                                        // SQL=varchar, Delphi=string[50]
    FTPCustomerDirParam.Value := FTPCustomerDir;                                                // SQL=varchar, Delphi=string[50]
    FTPStockDirParam.Value := FTPStockDir;                                                      // SQL=varchar, Delphi=string[50]
    FTPCOMPriceDirParam.Value := FTPCOMPriceDir;                                                // SQL=varchar, Delphi=string[50]
    FTPTransactionDirParam.Value := FTPTransactionDir;                                          // SQL=varchar, Delphi=string[50]
  End; // With DataRec^, CostCtrRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusEmailVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'EmailEnabled, ' +
                                           'EmailAdminAddress, ' +
                                           'EmailNotifyAdmin, ' +
                                           'EmailType, ' +
                                           'EmailServerName, ' +
                                           'EmailAccountName, ' +
                                           'EmailAccountPassword, ' +
                                           'EmailNotifySender, ' +
                                           'EmailConfirmProcessing, ' +
                                           'EmailCustomerAddr, ' +
                                           'EmailStockAddr, ' +
                                           'EmailCOMPriceAddr, ' +
                                           'EmailTransactionAddr' +
                                           ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':ebuscode1, ' +
                       ':ebuscode2, ' + 
                       ':EmailEnabled, ' +
                       ':EmailAdminAddress, ' + 
                       ':EmailNotifyAdmin, ' + 
                       ':EmailType, ' + 
                       ':EmailServerName, ' +
                       ':EmailAccountName, ' + 
                       ':EmailAccountPassword, ' +
                       ':EmailNotifySender, ' +
                       ':EmailConfirmProcessing, ' +
                       ':EmailCustomerAddr, ' +
                       ':EmailStockAddr, ' +
                       ':EmailCOMPriceAddr, ' +
                       ':EmailTransactionAddr' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    EmailEnabledParam := FindParam('EmailEnabled');
    EmailAdminAddressParam := FindParam('EmailAdminAddress');
    EmailNotifyAdminParam := FindParam('EmailNotifyAdmin');
    EmailTypeParam := FindParam('EmailType');
    EmailServerNameParam := FindParam('EmailServerName');
    EmailAccountNameParam := FindParam('EmailAccountName');
    EmailAccountPasswordParam := FindParam('EmailAccountPassword');
    EmailNotifySenderParam := FindParam('EmailNotifySender');
    EmailConfirmProcessingParam := FindParam('EmailConfirmProcessing');
    EmailCustomerAddrParam := FindParam('EmailCustomerAddr');
    EmailStockAddrParam := FindParam('EmailStockAddr');
    EmailCOMPriceAddrParam := FindParam('EmailCOMPriceAddr');
    EmailTransactionAddrParam := FindParam('EmailTransactionAddr');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusEmailVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EbusEmail Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    EmailEnabledParam.Value := EmailEnabled;                                                    // SQL=bit, Delphi=boolean
    EmailAdminAddressParam.Value := EmailAdminAddress;                                          // SQL=varchar, Delphi=string[100]
    EmailNotifyAdminParam.Value := EmailNotifyAdmin;                                            // SQL=int, Delphi=byte
    EmailTypeParam.Value := EmailType;                                                          // SQL=int, Delphi=byte
    EmailServerNameParam.Value := EmailServerName;                                              // SQL=varchar, Delphi=string[40]
    EmailAccountNameParam.Value := EmailAccountName;                                            // SQL=varchar, Delphi=string[40]
    EmailAccountPasswordParam.Value := EmailAccountPassword;                                    // SQL=varchar, Delphi=string[40]
    EmailNotifySenderParam.Value := EmailNotifySender;                                          // SQL=int, Delphi=byte
    EmailConfirmProcessingParam.Value := EmailConfirmProcessing;                                // SQL=int, Delphi=byte
    EmailCustomerAddrParam.Value := EmailCustomerAddr;                                          // SQL=varchar, Delphi=string[100]
    EmailStockAddrParam.Value := EmailStockAddr;                                                // SQL=varchar, Delphi=string[100]
    EmailCOMPriceAddrParam.Value := EmailCOMPriceAddr;                                          // SQL=varchar, Delphi=string[100]
    EmailTransactionAddrParam.Value := EmailTransactionAddr;                                    // SQL=varchar, Delphi=string[100]
  End; // With DataRec^, AllocFileRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_EBusFileVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'FileCustomerDir, ' +
                                           'FileStockDir, ' +
                                           'FileStockGroupDir, ' +
                                           'FileTransDir, ' +
                                           'FileCOMPriceDir' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':FileCustomerDir, ' +
                       ':FileStockDir, ' +
                       ':FileStockGroupDir, ' +
                       ':FileTransDir, ' +
                       ':FileCOMPriceDir' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    FileCustomerDirParam := FindParam('FileCustomerDir');
    FileStockDirParam := FindParam('FileStockDir');
    FileStockGroupDirParam := FindParam('FileStockGroupDir');
    FileTransDirParam := FindParam('FileTransDir');
    FileCOMPriceDirParam := FindParam('FileCOMPriceDir');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_EBusFileVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EbusFile Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    FileCustomerDirParam.Value := FileCustomerDir;                                              // SQL=varchar, Delphi=string[80]
    FileStockDirParam.Value := FileStockDir;                                                    // SQL=varchar, Delphi=string[80]
    FileStockGroupDirParam.Value := FileStockGroupDir;                                          // SQL=varchar, Delphi=string[80]
    FileTransDirParam.Value := FileTransDir;                                                    // SQL=varchar, Delphi=string[80]
    FileCOMPriceDirParam.Value := FileCOMPriceDir;                                              // SQL=varchar, Delphi=string[80]
  End; // With DataRec^, BacsCRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_PreserveDocFieldsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'InvOrderNo, ' +
                                           'InvBuyersOrder, ' +
                                           'InvProjectcode, ' +
                                           'InvAnalysiscode, ' +
                                           'InvSuppInvoice, ' +
                                           'InvBuyersDelivery, ' +
                                           'InvFolio, ' +
                                           'InvPosted, ' +
                                           'InvPostedDate' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':InvOrderNo, ' +
                       ':InvBuyersOrder, ' +
                       ':InvProjectcode, ' +
                       ':InvAnalysiscode, ' +
                       ':InvSuppInvoice, ' +
                       ':InvBuyersDelivery, ' +
                       ':InvFolio, ' +
                       ':InvPosted, ' +
                       ':InvPostedDate' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    InvOrderNoParam := FindParam('InvOrderNo');
    InvBuyersOrderParam := FindParam('InvBuyersOrder');
    InvProjectcodeParam := FindParam('InvProjectcode');
    InvAnalysiscodeParam := FindParam('InvAnalysiscode');
    InvSuppInvoiceParam := FindParam('InvSuppInvoice');
    InvBuyersDeliveryParam := FindParam('InvBuyersDelivery');
    InvFolioParam := FindParam('InvFolio');
    InvPostedParam := FindParam('InvPosted');
    InvPostedDateParam := FindParam('InvPostedDate');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_PreserveDocFieldsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, PreserveDoc Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    InvOrderNoParam.Value := InvOrderNo;                                                        // SQL=varchar, Delphi=string[10]
    InvBuyersOrderParam.Value := InvBuyersOrder;                                                // SQL=varchar, Delphi=string[20]
    InvProjectcodeParam.Value := InvProjectCode;                                                // SQL=varchar, Delphi=string[20]
    InvAnalysiscodeParam.Value := InvAnalysisCode;                                              // SQL=varchar, Delphi=string[20]
    InvSuppInvoiceParam.Value := InvSuppInvoice;                                                // SQL=varchar, Delphi=string[20]
    InvBuyersDeliveryParam.Value := InvBuyersDelivery;                                          // SQL=varchar, Delphi=string[20]
    InvFolioParam.Value := InvFolio;                                                            // SQL=int, Delphi=longint
    InvPostedParam.Value := InvPosted;                                                          // SQL=bit, Delphi=Boolean
    InvPostedDateParam.Value := InvPostedDate;                                                  // SQL=varchar, Delphi=string[8]
  End; // With DataRec^, BankCRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusDataWrite_PreserveLineFieldsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Ebus (' +
                                           'RecPfix, ' +
                                           'SubType, ' +
                                           'ebuscode1, ' +
                                           'ebuscode2, ' +
                                           'IdAbsLineNo, ' +
                                           'IdLineNo, ' +
                                           'IdFolio, ' +
                                           'IdProjectcode, ' +
                                           'IdAnalysiscode, ' +
                                           'IdBuyersOrder, ' +
                                           'IdBuyersLineRef, ' +
                                           'IdOrderNo, ' +
                                           'IdPDNNo, ' +
                                           'IdPDNLineNo, ' +
                                           'IdValue, ' +
                                           'IDQty, ' +
                                           'IdOrderLineNo, ' +
                                           'IdStockcode, ' +
                                           'IdDescription, ' +
                                           'IdDiscAmount, ' +
                                           'IdDiscChar, ' +
                                           'IdDisc2Amount, ' +
                                           'IdDisc2Char, ' +
                                           'IdDisc3Amount, ' +
                                           'IdDisc3Char, ' +
                                           'IdDisc3Type' +
                                           ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':ebuscode1, ' +
                       ':ebuscode2, ' +
                       ':IdAbsLineNo, ' +
                       ':IdLineNo, ' +
                       ':IdFolio, ' +
                       ':IdProjectcode, ' +
                       ':IdAnalysiscode, ' +
                       ':IdBuyersOrder, ' +
                       ':IdBuyersLineRef, ' +
                       ':IdOrderNo, ' +
                       ':IdPDNNo, ' +
                       ':IdPDNLineNo, ' +
                       ':IdValue, ' +
                       ':IDQty, ' +
                       ':IdOrderLineNo, ' +
                       ':IdStockcode, ' +
                       ':IdDescription, ' +
                       ':IdDiscAmount, ' +
                       ':IdDiscChar, ' +
                       ':IdDisc2Amount, ' +
                       ':IdDisc2Char, ' +
                       ':IdDisc3Amount, ' +
                       ':IdDisc3Char, ' +
                       ':IdDisc3Type' +
                       ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ebuscode1Param := FindParam('ebuscode1');
    ebuscode2Param := FindParam('ebuscode2');

    IdAbsLineNoParam := FindParam('IdAbsLineNo');
    IdLineNoParam := FindParam('IdLineNo');
    IdFolioParam := FindParam('IdFolio');
    IdProjectcodeParam := FindParam('IdProjectcode');
    IdAnalysiscodeParam := FindParam('IdAnalysiscode');
    IdBuyersOrderParam := FindParam('IdBuyersOrder');
    IdBuyersLineRefParam := FindParam('IdBuyersLineRef');
    IdOrderNoParam := FindParam('IdOrderNo');
    IdPDNNoParam := FindParam('IdPDNNo');
    IdPDNLineNoParam := FindParam('IdPDNLineNo');
    IdValueParam := FindParam('IdValue');
    IDQtyParam := FindParam('IDQty');
    IdOrderLineNoParam := FindParam('IdOrderLineNo');
    IdStockcodeParam := FindParam('IdStockcode');
    IdDescriptionParam := FindParam('IdDescription');
    IdDiscAmountParam := FindParam('IdDiscAmount');
    IdDiscCharParam := FindParam('IdDiscChar');
    IdDisc2AmountParam := FindParam('IdDisc2Amount');
    IdDisc2CharParam := FindParam('IdDisc2Char');
    IdDisc3AmountParam := FindParam('IdDisc3Amount');
    IdDisc3CharParam := FindParam('IdDisc3Char');
    IdDisc3TypeParam := FindParam('IdDisc3Type');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusDataWrite_PreserveLineFieldsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEbusRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, PreserveLine Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                             // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                             // SQL=varchar, Delphi=char
    ebuscode1Param.Value := CreateVariantArray (@EBusCode1, SizeOf(EBusCode1));  // SQL=varbinary, Delphi=string[20]
    ebuscode2Param.Value := CreateVariantArray (@EBusCode2, SizeOf(EBusCode2));  // SQL=varbinary, Delphi=string[20]

    IdAbsLineNoParam.Value := IdAbsLineNo;                                                      // SQL=int, Delphi=longint
    IdLineNoParam.Value := IdLineNo;                                                            // SQL=int, Delphi=longint
    IdFolioParam.Value := IdFolio;                                                              // SQL=int, Delphi=longint
    IdProjectcodeParam.Value := IdProjectCode;                                                  // SQL=varchar, Delphi=string[20]
    IdAnalysiscodeParam.Value := IdAnalysisCode;                                                // SQL=varchar, Delphi=string[20]
    IdBuyersOrderParam.Value := IdBuyersOrder;                                                  // SQL=varchar, Delphi=string[20]
    IdBuyersLineRefParam.Value := IdBuyersLineRef;                                              // SQL=varchar, Delphi=string[20]
    IdOrderNoParam.Value := IdOrderNo;                                                          // SQL=varchar, Delphi=string[10]
    IdPDNNoParam.Value := IdPDNNo;                                                              // SQL=varchar, Delphi=string[10]
    IdPDNLineNoParam.Value := IdPDNLineNo;                                                      // SQL=int, Delphi=longint
    IdValueParam.Value := IdValue;                                                              // SQL=float, Delphi=Double
    IDQtyParam.Value := IDQty;                                                                  // SQL=float, Delphi=Double
    IdOrderLineNoParam.Value := IdOrderLineNo;                                                  // SQL=int, Delphi=longint
    IdStockcodeParam.Value := IdStockCode;                                                      // SQL=varchar, Delphi=string[16]
    IdDescriptionParam.Value := IdDescription;                                                  // SQL=varchar, Delphi=string[60]
    IdDiscAmountParam.Value := IdDiscAmount;                                                    // SQL=float, Delphi=Double
    IdDiscCharParam.Value := ConvertCharToSQLEmulatorVarChar(IdDiscChar);                       // SQL=varchar, Delphi=Char
    IdDisc2AmountParam.Value := IdDisc2Amount;                                                  // SQL=float, Delphi=Double
    IdDisc2CharParam.Value := ConvertCharToSQLEmulatorVarChar(IdDisc2Char);                     // SQL=varchar, Delphi=Char
    IdDisc3AmountParam.Value := IdDisc3Amount;                                                  // SQL=float, Delphi=Double
    IdDisc3CharParam.Value := ConvertCharToSQLEmulatorVarChar(IdDisc3Char);                     // SQL=varchar, Delphi=Char
    IdDisc3TypeParam.Value := IdDisc3Type;                                                      // SQL=int, Delphi=Byte
  End; // With DataRec^, MoveCtrlRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution

//=========================================================================

End.

