Unit oExchqChkDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TExchqChkDataWrite_UserRecVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPFixParam, SubTypeParam, ExchqChkCode1Param, ExchqChkCode2Param, ExchqChkCode3Param : TParameter;
    // Variant specific fields
    AccessParam, LastPNoParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_UserRecVariant

  //------------------------------

  TExchqChkDataWrite_PermissionsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPFixParam, SubTypeParam, ExchqChkCode1Param, ExchqChkCode2Param, ExchqChkCode3Param : TParameter;
    // Variant specific fields
    PassDescParam, PassPageParam, PassLNoParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_PermissionsVariant

  //------------------------------

  TExchqChkDataWrite_GenericNotesVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPFixParam, SubTypeParam, ExchqChkCode1Param, ExchqChkCode2Param, ExchqChkCode3Param : TParameter;
    // Variant specific fields
    NoteFolioParam, NTypeParam, Spare1Param, LineNumberParam, NoteLineParam,
    NoteUserParam, TmpImpCodeParam, ShowDateParam, RepeatNoParam, NoteForParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_GenericNotesVariant

  //------------------------------

  TExchqChkDataWrite_TransactionNotesVariant = Class(TDataWrite_BaseSubVariant)
  Private
    NoteFolioParam, NoteDateParam, NoteAlarmParam, NoteTypeParam, LineNumberParam,
    NoteLineParam, NoteUserParam, TmpImpCodeParam, ShowDateParam, RepeatNoParam,
    NoteForParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_TransactionNotesVariant

  //------------------------------

  TExchqChkDataWrite_GenericMatchingVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    SettledValParam, OwnCValParam, MCurrencyParam, MatchTypeParam, OldAltRefParam,
    RCurrencyParam, RecOwnCValParam, AltRefParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_GenericMatchingVariant

  //------------------------------

  TExchqChkDataWrite_FinancialSOPMatchingVariant = Class(TDataWrite_BaseSubVariant)
  Private
    DocRefParam, PayRefParam, SettledValParam, OwnCValParam, MCurrencyParam,
    MatchTypeParam, OldAltRefParam, RCurrencyParam, RecOwnCValParam, AltRefParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_FinancialSOPMatchingVariant

  //------------------------------

  TExchqChkDataWrite_BillOfMaterialsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    QtyUsedParam, QtyCostParam, QCurrencyParam, FullStkCodeParam, FreeIssueParam,
    QtyTimeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_BillOfMaterialsVariant

  //------------------------------

  TExchqChkDataWrite_CCDeptVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    CCDescParam, CCTagParam, LastAccessParam, NLineCountParam, HideACParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_CCDeptVariant

  //------------------------------

  TExchqChkDataWrite_AllocVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    AllocSFParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_AllocVariant

  //------------------------------

  TExchqChkDataWrite_BatchPayCtrlVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    BACSTagRunNoParam, PayTypeParam, BACSBankNomParam, PayCurrParam, InvCurrParam,
    CQStartParam, AgeTypeParam, AgeIntParam, TagStatusParam, TotalTag0Param,
    TotalTag1Param, TotalTag2Param, TotalTag3Param, TotalTag4Param, TagAsDateParam,
    TagCountParam, TagDepartmentParam, TagCostCentreParam, TagRunDateParam,
    TagRunYrParam, TagRunPrParam, SalesModeParam, LastInvParam, SRCPIRefParam,
    LastTagRunNoParam, TagCtrlCodeParam, UseAcCCParam, SetCQatPParam, IncSDiscParam,
    SDDaysOverParam, ShowLogParam, UseOsNdxParam, BACSCLIUCountParam, YourRefParam : TParameter;
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    ApplyPPDParam, IntendedPaymentDateParam, PPDExpiryToleranceDaysParam: TParameter;

  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_BatchPayCtrlVariant

  //------------------------------

  TExchqChkDataWrite_OldAutoBankRecVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    TagRunNoParam, BankNomParam, BankCrParam, ReconOpoParam, EntryTotDrParam,
    EntryTotCrParam, EntryDateParam, NomEntTypParam, AllMatchOkParam, MatchCountParam,
    MatchOBalParam, ManTotDrParam, ManTotCrParam, ManRunNoParam, ManChangeParam,
    ManCountParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_OldAutoBankRecVariant

  //------------------------------

  TExchqChkDataWrite_MoveGLStockVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    SCodeOldParam, SCodeNewParam, MoveStageParam, OldNCodeParam, NewNCodeParam,
    NTypOldParam, NTypNewParam, MoveKey1Param, MoveKey2Param, WasModeParam,
    SGrpNewParam, SUserParam, FinStageParam, ProgCounterParam, MIsCustParam,
    MListRecAddrParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_MoveGLStockVariant

  //------------------------------

  TExchqChkDataWrite_GLMoveVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    MoveCodeNomParam, MoveFromNomParam, MoveToNomParam, MoveTypeNomParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_GLMoveVariant

  //------------------------------

  TExchqChkDataWrite_StockMoveVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    MoveCodeStkParam, MoveFromStkParam, MoveToStkParam, NewStkCodeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_StockMoveVariant

  //------------------------------

  TExchqChkDataWrite_BatchPayAccessVariant = Class(TDataWrite_BaseSubVariant)
  Private
    RecPfixParam, SubTypeParam, EXCHQCHKcode1Param, EXCHQCHKcode2Param, EXCHQCHKcode3Param,
    OpoNameParam, StartDateParam, StartTimeParam, WinLogNameParam, WinCPUNameParam,
    BACSULIUCountParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_StockMoveVariant

  //------------------------------

  TExchqChkDataWrite_VSecureVariant = Class(TDataWrite_BaseSubVariant)
  Private
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_VSecureVariant

  //------------------------------

  // MH 24/10/2014: Added support for new Order Payments fields
  TExchqChkDataWrite_OrderPaymentsMatchingVariant = Class(TDataWrite_BaseSubVariant)
  Private
    DocRefParam, PayRefParam, SettledValParam, OwnCValParam, MCurrencyParam,
    MatchTypeParam, OldAltRefParam, RCurrencyParam, RecOwnCValParam, AltRefParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite_OrderPaymentsMatchingVariant

  //------------------------------

  TExchqChkDataWrite = Class(TBaseDataWrite)
  Private
    FUserRecVariant : TExchqChkDataWrite_UserRecVariant;
    FPermissionsVariant : TExchqChkDataWrite_PermissionsVariant;
    FGenericNotesVariant : TExchqChkDataWrite_GenericNotesVariant;
    FTransactionNotesVariant : TExchqChkDataWrite_TransactionNotesVariant;
    FGenericMatchingVariant : TExchqChkDataWrite_GenericMatchingVariant;
    FFinancialSOPMatchingVariant : TExchqChkDataWrite_FinancialSOPMatchingVariant;
    FBillOfMaterialsVariant : TExchqChkDataWrite_BillOfMaterialsVariant;
    FCCDeptVariant : TExchqChkDataWrite_CCDeptVariant;
    FAllocVariant : TExchqChkDataWrite_AllocVariant;
    FBatchPayCtrlVariant : TExchqChkDataWrite_BatchPayCtrlVariant;
    FOldAutoBankRecVariant : TExchqChkDataWrite_OldAutoBankRecVariant;
    FMoveGLStockVariant : TExchqChkDataWrite_MoveGLStockVariant;
    FGLMoveVariant : TExchqChkDataWrite_GLMoveVariant;
    FStockMoveVariant : TExchqChkDataWrite_StockMoveVariant;
    FBatchPayAccessVariant : TExchqChkDataWrite_BatchPayAccessVariant;
    FVSecureVariant : TExchqChkDataWrite_VSecureVariant;
    // MH 24/10/2014: Added support for new Order Payments fields
    FOrderPaymentsMatchingVariant : TExchqChkDataWrite_OrderPaymentsMatchingVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqChkDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TExchqChkDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FUserRecVariant := TExchqChkDataWrite_UserRecVariant.Create;
  FPermissionsVariant := TExchqChkDataWrite_PermissionsVariant.Create;
  FGenericNotesVariant := TExchqChkDataWrite_GenericNotesVariant.Create;
  FTransactionNotesVariant := TExchqChkDataWrite_TransactionNotesVariant.Create;
  FGenericMatchingVariant := TExchqChkDataWrite_GenericMatchingVariant.Create;
  FFinancialSOPMatchingVariant := TExchqChkDataWrite_FinancialSOPMatchingVariant.Create;
  FBillOfMaterialsVariant := TExchqChkDataWrite_BillOfMaterialsVariant.Create;
  FCCDeptVariant := TExchqChkDataWrite_CCDeptVariant.Create;
  FAllocVariant := TExchqChkDataWrite_AllocVariant.Create;
  FBatchPayCtrlVariant := TExchqChkDataWrite_BatchPayCtrlVariant.Create;
  FOldAutoBankRecVariant := TExchqChkDataWrite_OldAutoBankRecVariant.Create;
  FMoveGLStockVariant := TExchqChkDataWrite_MoveGLStockVariant.Create;
  FGLMoveVariant := TExchqChkDataWrite_GLMoveVariant.Create;
  FStockMoveVariant := TExchqChkDataWrite_StockMoveVariant.Create;
  FBatchPayAccessVariant := TExchqChkDataWrite_BatchPayAccessVariant.Create;
  FVSecureVariant := TExchqChkDataWrite_VSecureVariant.Create;
  // MH 24/10/2014: Added support for new Order Payments fields
  FOrderPaymentsMatchingVariant := TExchqChkDataWrite_OrderPaymentsMatchingVariant.Create;
End; // Create


Destructor TExchqChkDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FUserRecVariant);
  FreeAndNIL(FPermissionsVariant);
  FreeAndNIL(FGenericNotesVariant);
  FreeAndNIL(FTransactionNotesVariant);
  FreeAndNIL(FGenericMatchingVariant);
  FreeAndNIL(FFinancialSOPMatchingVariant);
  FreeAndNIL(FBillOfMaterialsVariant);
  FreeAndNIL(FCCDeptVariant);
  FreeAndNIL(FAllocVariant);
  FreeAndNIL(FBatchPayCtrlVariant);
  FreeAndNIL(FOldAutoBankRecVariant);
  FreeAndNIL(FMoveGLStockVariant);
  FreeAndNIL(FGLMoveVariant);
  FreeAndNIL(FStockMoveVariant);
  FreeAndNIL(FBatchPayAccessVariant);
  FreeAndNIL(FVSecureVariant);
  // MH 24/10/2014: Added support for new Order Payments fields
  FreeAndNIL(FOrderPaymentsMatchingVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FUserRecVariant.Prepare (ADOConnection, CompanyCode);
  FPermissionsVariant.Prepare (ADOConnection, CompanyCode);
  FGenericNotesVariant.Prepare (ADOConnection, CompanyCode);
  FTransactionNotesVariant.Prepare (ADOConnection, CompanyCode);
  FGenericMatchingVariant.Prepare (ADOConnection, CompanyCode);
  FFinancialSOPMatchingVariant.Prepare (ADOConnection, CompanyCode);
  FBillOfMaterialsVariant.Prepare (ADOConnection, CompanyCode);
  FCCDeptVariant.Prepare (ADOConnection, CompanyCode);
  FAllocVariant.Prepare (ADOConnection, CompanyCode);
  FBatchPayCtrlVariant.Prepare (ADOConnection, CompanyCode);
  FOldAutoBankRecVariant.Prepare (ADOConnection, CompanyCode);
  FMoveGLStockVariant.Prepare (ADOConnection, CompanyCode);
  FGLMoveVariant.Prepare (ADOConnection, CompanyCode);
  FStockMoveVariant.Prepare (ADOConnection, CompanyCode);
  FBatchPayAccessVariant.Prepare (ADOConnection, CompanyCode);
  FVSecureVariant.Prepare (ADOConnection, CompanyCode);
  // MH 24/10/2014: Added support for new Order Payments fields
  FOrderPaymentsMatchingVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix = 'P') And (DataRec.SubType In [#0..#3]) Then
  Begin
    // PassEntryRec : PassEntryType - User Records
    FUserRecVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'P') And (DataRec.SubType In [#0..#3])
  Else If (DataRec.RecPFix = 'L') And (DataRec.SubType = #0) Then
  Begin
    // PassListRec : PassListType - Permissions List
    FPermissionsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'L') And (DataRec.SubType = #0)
  Else If (DataRec.RecPFix = 'H') Then
  Begin
    // HelpRec : HelpType - DOS Help - don't bother converting
    SkipRecord := True;
  End // If (DataRec.RecPFix = 'L') And (DataRec.SubType = #0)
  Else If (DataRec.RecPFix = 'N') And (DataRec.SubType In [#2, 'A', 'B', 'E', 'J', 'L', 'P', 'R', 'S', 'T']) Then
  Begin
    // NotesRec : NotesType - Notes except for Transaction Notes which have been normalised
    //  #2  - Workflow Diary
    //  'A' - Customer/Supplier
    //  'B' - Alternate Stock Codes
    //  'E' - Employees
    //  'J' - Job
    //  'L' - Location / Stock-Location
    //  'P' - Department
    //  'R' - Serial/Batch
    //  'S' - Stock
    //  'T' - Cost Centre
    FGenericNotesVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'L') And (DataRec.SubType = #0)
  Else If (DataRec.RecPFix = 'N') And (DataRec.SubType = 'D') Then
  Begin
    FTransactionNotesVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'N') And (DataRec.SubType = 'D')
  Else If (DataRec.RecPFix = 'T') And (DataRec.SubType In ['C', '0'..'4']) Then
  Begin
    // MatchPayRec : MatchPayType - Financial/SPOP Matching has been normalised
    //  'C' - CIS Matching
    //  '0' - Cost Allocation Matching
    //  '1' - Custom Matching 1
    //  '2' - Custom Matching 2
    //  '3' - Custom Matching 3
    //  '4' - Custom Matching 4
    FGenericMatchingVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'T') And (DataRec.SubType In ['C', '0'..'4'])
  Else If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'P') Then
  Begin
    // MatchPayRec : MatchPayType - Financial/SPOP Matching has been normalised
    FFinancialSOPMatchingVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'P')
  Else If (DataRec.RecPFix = 'B') And (DataRec.SubType = 'M') Then
  Begin
    // BillMatRec : BillMatType - Bill of Materials
    FBillOfMaterialsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'B') And (DataRec.SubType = 'M')
  Else If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'F') Then
  Begin
    // ExportFileRec : ExportFileType - Obsolete export information
    SkipRecord := True;
  End // If (DataRec.RecPFix = 'E') And (DataRec.SubType = 'F')
  Else If (DataRec.RecPFix = 'C') And ((DataRec.SubType = 'C') Or (DataRec.SubType = 'D')) Then
  Begin
    //  CostCtrRec : CostCtrType - CC Cost Centre and CD Department
    FCCDeptVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'C') And ((DataRec.SubType = 'C') Or (DataRec.SubType = 'D'))
  Else If (DataRec.RecPFix = 'L') And (DataRec.SubType = 'V') Then
  Begin
    // VSecureRec : VSecureType - Licensing Control Record - 1 instance only
    FVSecureVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'L') And (DataRec.SubType = 'V')
  Else If (DataRec.RecPFix = 'A') And (DataRec.SubType In ['B', 'I', 'O', 'P', 'R', 'U', 'W']) Then
  Begin
    // AllocFileRec : AllocFileType - Temp Stock Allocation ??????
    FAllocVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'A') And ((DataRec.SubType In ['B', 'I', 'O', 'P', 'R', 'U', 'W'])
  Else If (DataRec.RecPFix = 'X') And (DataRec.SubType = 'C') Then
  Begin
    // BacsCRec : BacsCtype - Batch Payment Control Records
    FBatchPayCtrlVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'X') And (DataRec.SubType = 'C')
  Else If ((DataRec.RecPFix = 'F') And (DataRec.SubType = 'P')) Or ((DataRec.RecPFix = 'M') And (DataRec.SubType = 'T')) Then
  Begin
    // BankCRec : BankCtype - Old Auto Bank Rec
    FOldAutoBankRecVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If ((DataRec.RecPFix = 'F') And (DataRec.SubType = 'P')) Or ((DataRec.RecPFix = 'M') And (DataRec.SubType = 'T'))
  Else If (DataRec.RecPFix = 'L') And (DataRec.SubType = 'M') Then
  Begin
    // MoveCtrlRec : MoveCtrlType - Control rec for GL/STK Moves
    FMoveGLStockVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'L') And (DataRec.SubType = 'M')
  Else If (DataRec.RecPFix = 'M') And (DataRec.SubType = 'N') Then
  Begin
    // MoveNomRec : MoveNomType - Individual G/L Move Record
    FGLMoveVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'M') And (DataRec.SubType = 'N')
  Else If (DataRec.RecPFix = 'M') And (DataRec.SubType = 'S') Then
  Begin
    // MoveStkRec : MoveStkType - Individual Stock Move Record
    FStockMoveVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'M') And (DataRec.SubType = 'S')
  Else If (DataRec.RecPFix = 'X') And (DataRec.SubType = 'U') Then
  Begin
    // BacsURec : BacsUtype - Batch Payments Access Control
    FBatchPayAccessVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'X') And (DataRec.SubType = 'U')
  // MH 24/10/2014: Added support for new Order Payments fields
  Else If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'R') Then
  Begin
    // MatchPayRec : MatchPayType - Order Payments Matching
    FOrderPaymentsMatchingVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'R')
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
Procedure TExchqChkDataWrite_UserRecVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPFix, ' +
                                               'SubType, ' +
                                               'ExchqChkCode1, ' +
                                               'ExchqChkCode2, ' +
                                               'ExchqChkCode3, ' +
                                               'Access, ' +
                                               'LastPno' +
                                               ')' +
              'VALUES (' +
                       ':RecPFix, ' +
                       ':SubType, ' +
                       ':ExchqChkCode1, ' +
                       ':ExchqChkCode2, ' +
                       ':ExchqChkCode3, ' +
                       ':Access, ' +
                       ':LastPno' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPFixParam := FindParam('RecPFix');
    SubTypeParam := FindParam('SubType');
    ExchqChkCode1Param := FindParam('ExchqChkCode1');
    ExchqChkCode2Param := FindParam('ExchqChkCode2');
    ExchqChkCode3Param := FindParam('ExchqChkCode3');

    AccessParam := FindParam('Access');
    LastPNoParam := FindParam('LastPno');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_UserRecVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, PassEntryRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@Login, SizeOf(Login));
    ExchqChkCode2Param.Value := CreateVariantArray (@Pword, SizeOf(Pword));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly
    ExchqChkCode3Param.Value := CreateVariantArray (@Access, 12);

    // The Access field in the DB needs to skip the portion of the field in the ExchqChkCode3 field
    AccessParam.Value := CreateVariantArray (@Access[12], CalculateBinaryBlockSize (@Access[12], @LastPNo));
    LastPNoParam.Value := LastPNo;
  End; // With DataRec^.PassEntryRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_PermissionsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPFix, ' +
                                               'SubType, ' +
                                               'ExchqChkCode1, ' +
                                               'ExchqChkCode2, ' +
                                               'ExchqChkCode3, ' +
                                               'PassDesc, ' +
                                               'PassPage, ' +
                                               'PassLNo' +
                                               ')' +
              'VALUES (' +
                       ':RecPFix, ' +
                       ':SubType, ' +
                       ':ExchqChkCode1, ' +
                       ':ExchqChkCode2, ' +
                       ':ExchqChkCode3, ' +
                       ':PassDesc, ' +
                       ':PassPage, ' +
                       ':PassLNo' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPFixParam := FindParam('RecPFix');
    SubTypeParam := FindParam('SubType');
    ExchqChkCode1Param := FindParam('ExchqChkCode1');
    ExchqChkCode2Param := FindParam('ExchqChkCode2');
    ExchqChkCode3Param := FindParam('ExchqChkCode3');

    PassDescParam := FindParam('PassDesc');
    PassPageParam := FindParam('PassPage');
    PassLNoParam := FindParam('PassLNo');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_PermissionsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, PassListRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@PassList, SizeOf(PassList));
    ExchqChkCode2Param.Value := CreateVariantArray (@PassGrp, CalculateBinaryBlockSize (@PassGrp, @PassDesc));
    ExchqChkCode3Param.Value := CreateVariantArray (@PassDesc, 12); // Only part of field is indexed

    // The Access field in the DB needs to skip the portion of the field in the ExchqChkCode3 field
    PassDescParam.Value := CreateVariantArray (@PassDesc[12], CalculateBinaryBlockSize (@PassDesc[12], @PassPage));
    PassPageParam.Value := PassPage;
    PassLNoParam.Value := PassLNo;
  End; // With DataRec^, PassEntryRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_GenericNotesVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'NoteFolio, ' +
                                               'NType, ' +
                                               'Spare1, ' +
                                               'LineNumber, ' +
                                               'NoteLine, ' +
                                               'NoteUser, ' +
                                               'TmpImpCode, ' +
                                               'ShowDate, ' +
                                               'RepeatNo, ' +
                                               'NoteFor' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':NoteFolio, ' +
                       ':NType, ' +
                       ':Spare1, ' +
                       ':LineNumber, ' +
                       ':NoteLine, ' +
                       ':NoteUser, ' +
                       ':TmpImpCode, ' +
                       ':ShowDate, ' +
                       ':RepeatNo, ' +
                       ':NoteFor' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPFixParam := FindParam('RecPFix');
    SubTypeParam := FindParam('SubType');
    ExchqChkCode1Param := FindParam('ExchqChkCode1');
    ExchqChkCode2Param := FindParam('ExchqChkCode2');
    ExchqChkCode3Param := FindParam('ExchqChkCode3');

    NoteFolioParam := FindParam('NoteFolio');
    NTypeParam := FindParam('NType');
    Spare1Param := FindParam('Spare1');
    LineNumberParam := FindParam('LineNumber');
    NoteLineParam := FindParam('NoteLine');
    NoteUserParam := FindParam('NoteUser');
    TmpImpCodeParam := FindParam('TmpImpCode');
    ShowDateParam := FindParam('ShowDate');
    RepeatNoParam := FindParam('RepeatNo');
    NoteForParam := FindParam('NoteFor');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_GenericNotesVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, NotesRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@NoteNo, SizeOf(NoteNo));
    ExchqChkCode2Param.Value := CreateVariantArray (@NoteDate, CalculateBinaryBlockSize (@NoteDate, @NoteAlarm));
    ExchqChkCode3Param.Value := CreateVariantArray (@NoteAlarm, CalculateBinaryBlockSize (@NoteAlarm, @NoteFolio));

    NoteFolioParam.Value := CreateVariantArray (@NoteFolio, SizeOf(NoteFolio));  // SQL=varbinary, Delphi=String[10]
    NTypeParam.Value := ConvertCharToSQLEmulatorVarChar(NType);                  // SQL=varchar, Delphi=Char
    Spare1Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));           // SQL=varbinary, Delphi=Array[1..2] of Byte
    LineNumberParam.Value := LineNo;                                    // SQL=int, Delphi=LongInt
    NoteLineParam.Value := NoteLine;                                    // SQL=varchar, Delphi=String[100]
    NoteUserParam.Value := NoteUser;                                    // SQL=varchar, Delphi=String[10]
    TmpImpCodeParam.Value := TmpImpCode;                                // SQL=varchar, Delphi=String[16]
    ShowDateParam.Value := ShowDate;                                    // SQL=bit, Delphi=Boolean
    RepeatNoParam.Value := RepeatNo;                                    // SQL=int, Delphi=SmallInt
    NoteForParam.Value := NoteFor;
  End; // With DataRec^, NotesRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_TransactionNotesVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].TransactionNote (' +
                                                      'NoteFolio, ' +
                                                      'NoteDate, ' +
                                                      'NoteAlarm, ' +
                                                      'NoteType, ' +
                                                      'LineNumber, ' +
                                                      'NoteLine, ' +
                                                      'NoteUser, ' +
                                                      'TmpImpCode, ' +
                                                      'ShowDate, ' +
                                                      'RepeatNo, ' +
                                                      'NoteFor' +
                                                      ') ' +
              'VALUES (' +
                       ':NoteFolio, ' +
                       ':NoteDate, ' +
                       ':NoteAlarm, ' +
                       ':NoteType, ' +
                       ':LineNumber, ' +
                       ':NoteLine, ' +
                       ':NoteUser, ' +
                       ':TmpImpCode, ' +
                       ':ShowDate, ' +
                       ':RepeatNo, ' +
                       ':NoteFor' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    NoteFolioParam := FindParam('NoteFolio');
    NoteDateParam := FindParam('NoteDate');
    NoteAlarmParam := FindParam('NoteAlarm');
    NoteTypeParam := FindParam('NoteType');
    LineNumberParam := FindParam('LineNumber');
    NoteLineParam := FindParam('NoteLine');
    NoteUserParam := FindParam('NoteUser');
    TmpImpCodeParam := FindParam('TmpImpCode');
    ShowDateParam := FindParam('ShowDate');
    RepeatNoParam := FindParam('RepeatNo');
    NoteForParam := FindParam('NoteFor');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_TransactionNotesVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, NotesRec Do
  Begin
    NoteFolioParam.Value := UnFullNomKey (NoteFolio);    // SQL=int, Delphi=
    // If the date is blank the SQL DB contains an 8 character string of character 0's
    If (NoteDate = '') Then
      NoteDateParam.Value := #0#0#0#0#0#0#0#0
    Else
      NoteDateParam.Value := DataRec^.NotesRec.NoteDate;      // SQL=varchar, Delphi=
    NoteAlarmParam.Value := NoteAlarm;    // SQL=varchar, Delphi=
    NoteTypeParam.Value := NType;         // SQL=varchar, Delphi=
    LineNumberParam.Value := LineNo;      // SQL=int, Delphi=
    NoteLineParam.Value := NoteLine;      // SQL=varchar, Delphi=
    NoteUserParam.Value := NoteUser;      // SQL=varchar, Delphi=
    TmpImpCodeParam.Value := TmpImpCode;  // SQL=varchar, Delphi=
    ShowDateParam.Value := ShowDate;      // SQL=bit, Delphi=
    RepeatNoParam.Value := RepeatNo;      // SQL=int, Delphi=
    NoteForParam.Value := NoteFor;        // SQL=varchar, Delphi=
  End; // With DataRec^, NotesRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_GenericMatchingVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'SettledVal, ' +
                                               'OwnCVal, ' +
                                               'MCurrency, ' +
                                               'MatchType, ' +
                                               'OldAltRef, ' +
                                               'RCurrency, ' +
                                               'RecOwnCVal, ' +
                                               'AltRef' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':SettledVal, ' +
                       ':OwnCVal, ' +
                       ':MCurrency, ' +
                       ':MatchType, ' +
                       ':OldAltRef, ' +
                       ':RCurrency, ' +
                       ':RecOwnCVal, ' +
                       ':AltRef' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');
    // Variant specific field
    SettledValParam := FindParam('SettledVal');
    OwnCValParam := FindParam('OwnCVal');
    MCurrencyParam := FindParam('MCurrency');
    MatchTypeParam := FindParam('MatchType');
    OldAltRefParam := FindParam('OldAltRef');
    RCurrencyParam := FindParam('RCurrency');
    RecOwnCValParam := FindParam('RecOwnCVal');
    AltRefParam := FindParam('AltRef');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_GenericMatchingVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, MatchPayRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@DocCode, SizeOf(DocCode));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the SettledVal field!
    ExchqChkCode3Param.Value := CreateVariantArray (@PayRef, SizeOf(PayRef) + 1);

    // Have to start the binary block containing the rest of the details 1 byte into the UsrRelDate field
    BinPtr := Pointer(LongInt(@SettledVal) + 1);
    SettledValParam.Value := CreateVariantArray (BinPtr, CalculateBinaryBlockSize (BinPtr, @OwnCVal));
    OwnCValParam.Value := OwnCVal;                                          // SQL=float, Delphi=Real
    MCurrencyParam.Value := MCurrency;                                      // SQL=int, Delphi=Byte
    MatchTypeParam.Value := ConvertCharToSQLEmulatorVarChar(MatchType);     // SQL=varchar, Delphi=Char
    OldAltRefParam.Value := OldAltRef;                                      // SQL=varchar, Delphi=String[10]
    RCurrencyParam.Value := RCurrency;                                      // SQL=int, Delphi=Byte
    RecOwnCValParam.Value := RecOwnCVal;                                    // SQL=float, Delphi=Double
    AltRefParam.Value := AltRef;
  End; // With DataRec^, MatchPayRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_FinancialSOPMatchingVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].FinancialMatching (' +
                                                        'DocRef, ' +
                                                        'PayRef, ' +
                                                        'SettledVal, ' +
                                                        'OwnCVal, ' +
                                                        'MCurrency, ' +
                                                        'MatchType, ' +
                                                        'OldAltRef, ' +
                                                        'RCurrency, ' +
                                                        'RecOwnCVal, ' +
                                                        'AltRef' +
                                                        ')' +
              'VALUES (' +
                       ':DocRef, ' +
                       ':PayRef, ' +
                       ':SettledVal, ' +
                       ':OwnCVal, ' +
                       ':MCurrency, ' +
                       ':MatchType, ' +
                       ':OldAltRef, ' +
                       ':RCurrency, ' +
                       ':RecOwnCVal, ' +
                       ':AltRef' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    DocRefParam := FindParam('DocRef');
    PayRefParam := FindParam('PayRef');
    SettledValParam := FindParam('SettledVal');
    OwnCValParam := FindParam('OwnCVal');
    MCurrencyParam := FindParam('MCurrency');
    MatchTypeParam := FindParam('MatchType');
    OldAltRefParam := FindParam('OldAltRef');
    RCurrencyParam := FindParam('RCurrency');
    RecOwnCValParam := FindParam('RecOwnCVal');
    AltRefParam := FindParam('AltRef');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_FinancialSOPMatchingVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^.MatchPayRec Do
  Begin
    DocRefParam.Value := DocCode;           // SQL=varchar, Delphi=
    PayRefParam.Value := PayRef;            // SQL=varchar, Delphi=
    SettledValParam.Value := SettledVal;    // SQL=float, Delphi=
    OwnCValParam.Value := OwnCVal;          // SQL=float, Delphi=
    MCurrencyParam.Value := MCurrency;      // SQL=int, Delphi=
    MatchTypeParam.Value := MatchType;      // SQL=varchar, Delphi=
    OldAltRefParam.Value := OldAltRef;      // SQL=varchar, Delphi=
    RCurrencyParam.Value := RCurrency;      // SQL=int, Delphi=
    RecOwnCValParam.Value := RecOwnCVal;    // SQL=float, Delphi=
    AltRefParam.Value := AltRef;            // SQL=varchar, Delphi=
  End; // With DataRec^.MatchPayRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_BillOfMaterialsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'QtyUsed, ' +
                                               'QtyCost, ' +
                                               'QCurrency, ' +
                                               'FullStkCode, ' +
                                               'FreeIssue, ' +
                                               'QtyTime' +
                                               ')' +
            'VALUES (' +
                     ':RecPfix, ' +
                     ':SubType, ' +
                     ':EXCHQCHKcode1, ' +
                     ':EXCHQCHKcode2, ' +
                     ':EXCHQCHKcode3, ' +
                     ':QtyUsed, ' +
                     ':QtyCost, ' +
                     ':QCurrency, ' +
                     ':FullStkCode, ' +
                     ':FreeIssue, ' +
                     ':QtyTime' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    QtyUsedParam := FindParam('QtyUsed');
    QtyCostParam := FindParam('QtyCost');
    QCurrencyParam := FindParam('QCurrency');
    FullStkCodeParam := FindParam('FullStkCode');
    FreeIssueParam := FindParam('FreeIssue');
    QtyTimeParam := FindParam('QtyTime');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_BillOfMaterialsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, BillMatRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@StockLink, SizeOf(StockLink));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the QtyUsed field!
    ExchqChkCode3Param.Value := CreateVariantArray (@BillLink, SizeOf(BillLink) + 1);

    // Have to start the binary block containing the rest of the details 1 byte into the QtyUsed field
    BinPtr := Pointer(LongInt(@QtyUsed) + 1);
    QtyUsedParam.Value := CreateVariantArray (BinPtr, CalculateBinaryBlockSize (BinPtr, @QtyCost));
    QtyCostParam.Value := QtyCost;                                      // SQL=float, Delphi=Real
    QCurrencyParam.Value := QCurrency;                                  // SQL=int, Delphi=Byte
    FullStkCodeParam.Value := FullStkCode;                              // SQL=varchar, Delphi=String[20]
    FreeIssueParam.Value := FreeIssue;                                  // SQL=bit, Delphi=Boolean
    QtyTimeParam.Value := QtyTime;
  End; // With DataRec^, BillMatRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_CCDeptVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'CCDesc, ' +
                                               'CCTag, ' +
                                               'LastAccess, ' +
                                               'NLineCount, ' +
                                               'HideAC' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':CCDesc, ' +
                       ':CCTag, ' +
                       ':LastAccess, ' +
                       ':NLineCount, ' +
                       ':HideAC' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    CCDescParam := FindParam('CCDesc');
    CCTagParam := FindParam('CCTag');
    LastAccessParam := FindParam('LastAccess');
    NLineCountParam := FindParam('NLineCount');
    HideACParam := FindParam('HideAC');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_CCDeptVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, CostCtrRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@PCostC, SizeOf(PCostC));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the following field!
    ExchqChkCode3Param.Value := CreateVariantArray (@CCDesc, 12);

    // Have to start the binary block containing the rest of the CCDesc field in the 13th byte (don't forget length byte!)
    CCDescParam.Value := CreateVariantArray (@CCDesc[12], CalculateBinaryBlockSize (@CCDesc[12], @CCTag));  // SQL=varbinary, Delphi=String[30]
    CCTagParam.Value := CCTag;                                          // SQL=bit, Delphi=Boolean
    LastAccessParam.Value := LastAccess;                                // SQL=varchar, Delphi=LongDate
    NLineCountParam.Value := NLineCount;                                // SQL=int, Delphi=LongInt
    HideACParam.Value := HideAC;                                        // SQL=int, Delphi=Byte
  End; // With DataRec^, CostCtrRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_AllocVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'AllocSF' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':AllocSF' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    AllocSFParam := FindParam('AllocSF');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_AllocVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, AllocFileRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@AllocCode, SizeOf(AllocCode));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the following field!
    ExchqChkCode3Param.Value := CreateVariantArray (@SecondKey, 12);

    // Have to start the binary block containing the rest of the AllocSF field in the 2nd byte
    BinPtr := Pointer(LongInt(@AllocSF) + 1);
    AllocSFParam.Value := CreateVariantArray (BinPtr, SizeOf(AllocSF) - 1);
  End; // With DataRec^, AllocFileRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_BatchPayCtrlVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'BACSTagRunNo, ' +
                                               'PayType, ' +
                                               'BACSBankNom, ' +
                                               'PayCurr, ' +
                                               'InvCurr, ' +
                                               'CQStart, ' +
                                               'AgeType, ' +
                                               'AgeInt, ' +
                                               'TagStatus, ' +
                                               'TotalTag0, ' +
                                               'TotalTag1, ' +
                                               'TotalTag2, ' +
                                               'TotalTag3, ' +
                                               'TotalTag4, ' +
                                               'TagAsDate, ' +
                                               'TagCount, ' +
                                               'TagDepartment, ' +
                                               'TagCostCentre, ' +
                                               'TagRunDate, ' +
                                               'TagRunYr, ' +
                                               'TagRunPr, ' +
                                               'SalesMode, ' +
                                               'LastInv, ' +
                                               'SRCPIRef, ' +
                                               'LastTagRunNo, ' +
                                               'TagCtrlCode, ' +
                                               'UseAcCC, ' +
                                               'SetCQatP, ' +
                                               'IncSDisc, ' +
                                               'SDDaysOver, ' +
                                               'ShowLog, ' +
                                               'UseOsNdx, ' +
                                               'BACSCLIUCount, ' +
                                               'YourRef, ' +
                                               'ApplyPPD, ' +
                                               'IntendedPaymentDate, ' +
                                               'PPDExpiryToleranceDays ' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':BACSTagRunNo, ' +
                       ':PayType, ' +
                       ':BACSBankNom, ' +
                       ':PayCurr, ' +
                       ':InvCurr, ' +
                       ':CQStart, ' +
                       ':AgeType, ' +
                       ':AgeInt, ' +
                       ':TagStatus, ' +
                       ':TotalTag0, ' +
                       ':TotalTag1, ' +
                       ':TotalTag2, ' +
                       ':TotalTag3, ' +
                       ':TotalTag4, ' +
                       ':TagAsDate, ' +
                       ':TagCount, ' +
                       ':TagDepartment, ' +
                       ':TagCostCentre, ' +
                       ':TagRunDate, ' +
                       ':TagRunYr, ' +
                       ':TagRunPr, ' +
                       ':SalesMode, ' +
                       ':LastInv, ' +
                       ':SRCPIRef, ' +
                       ':LastTagRunNo, ' +
                       ':TagCtrlCode, ' +
                       ':UseAcCC, ' +
                       ':SetCQatP, ' +
                       ':IncSDisc, ' +
                       ':SDDaysOver, ' +
                       ':ShowLog, ' +
                       ':UseOsNdx, ' +
                       ':BACSCLIUCount, ' +
                       ':YourRef, ' +
                       ':ApplyPPD, ' +
                       ':IntendedPaymentDate, ' +
                       ':PPDExpiryToleranceDays ' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    BACSTagRunNoParam := FindParam('BACSTagRunNo');
    PayTypeParam := FindParam('PayType');
    BACSBankNomParam := FindParam('BACSBankNom');
    PayCurrParam := FindParam('PayCurr');
    InvCurrParam := FindParam('InvCurr');
    CQStartParam := FindParam('CQStart');
    AgeTypeParam := FindParam('AgeType');
    AgeIntParam := FindParam('AgeInt');
    TagStatusParam := FindParam('TagStatus');
    TotalTag0Param := FindParam('TotalTag0');
    TotalTag1Param := FindParam('TotalTag1');
    TotalTag2Param := FindParam('TotalTag2');
    TotalTag3Param := FindParam('TotalTag3');
    TotalTag4Param := FindParam('TotalTag4');
    TagAsDateParam := FindParam('TagAsDate');
    TagCountParam := FindParam('TagCount');
    TagDepartmentParam := FindParam('TagDepartment');
    TagCostCentreParam := FindParam('TagCostCentre');
    TagRunDateParam := FindParam('TagRunDate');
    TagRunYrParam := FindParam('TagRunYr');
    TagRunPrParam := FindParam('TagRunPr');
    SalesModeParam := FindParam('SalesMode');
    LastInvParam := FindParam('LastInv');
    SRCPIRefParam := FindParam('SRCPIRef');
    LastTagRunNoParam := FindParam('LastTagRunNo');
    TagCtrlCodeParam := FindParam('TagCtrlCode');
    UseAcCCParam := FindParam('UseAcCC');
    SetCQatPParam := FindParam('SetCQatP');
    IncSDiscParam := FindParam('IncSDisc');
    SDDaysOverParam := FindParam('SDDaysOver');
    ShowLogParam := FindParam('ShowLog');
    UseOsNdxParam := FindParam('UseOsNdx');
    BACSCLIUCountParam := FindParam('BACSCLIUCount');
    YourRefParam := FindParam('YourRef');
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    ApplyPPDParam := FindParam('ApplyPPD');
    IntendedPaymentDateParam := FindParam('IntendedPaymentDate');
    PPDExpiryToleranceDaysParam := FindParam('PPDExpiryToleranceDays');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_BatchPayCtrlVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, BacsCRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@TagCode, SizeOf(TagCode));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the following field!
    ExchqChkCode3Param.Value := CreateVariantArray (@Spare3K, 12);

    // Have to start the binary block containing the rest of the TagRunNo field in the 2nd byte
    BinPtr := Pointer(LongInt(@TagRunNo) + 1);
    BACSTagRunNoParam.Value := CreateVariantArray (BinPtr, SizeOf(TagRunNo) - 1);
    PayTypeParam.Value := ConvertCharToSQLEmulatorVarChar(PayType);     // SQL=varchar, Delphi=Char
    BACSBankNomParam.Value := BankNom;                                  // SQL=int, Delphi=LongInt
    PayCurrParam.Value := PayCurr;                                      // SQL=int, Delphi=Byte
    InvCurrParam.Value := InvCurr;                                      // SQL=int, Delphi=Byte
    CQStartParam.Value := CQStart;                                      // SQL=int, Delphi=LongInt
    AgeTypeParam.Value := AgeType;                                      // SQL=int, Delphi=Byte
    AgeIntParam.Value := AgeInt;                                        // SQL=int, Delphi=SmallInt
    TagStatusParam.Value := TagStatus;                                  // SQL=bit, Delphi=Boolean
    TotalTag0Param.Value := TotalTag[0];                                // SQL=float, Delphi=Double
    TotalTag1Param.Value := TotalTag[1];                                // SQL=float, Delphi=Double
    TotalTag2Param.Value := TotalTag[2];                                // SQL=float, Delphi=Double
    TotalTag3Param.Value := TotalTag[3];                                // SQL=float, Delphi=Double
    TotalTag4Param.Value := TotalTag[4];                                // SQL=float, Delphi=Double
    TagAsDateParam.Value := TagAsDate;                                  // SQL=varchar, Delphi=LongDate
    TagCountParam.Value := TagCount;                                    // SQL=int, Delphi=LongInt
    TagDepartmentParam.Value := TagCCDep[False];                        // SQL=varchar, Delphi=String[3]
    TagCostCentreParam.Value := TagCCDep[True];                         // SQL=varchar, Delphi=String[3]
    TagRunDateParam.Value := TagRunDate;                                // SQL=varchar, Delphi=LongDate
    TagRunYrParam.Value := TagRunYr;                                    // SQL=int, Delphi=Byte
    TagRunPrParam.Value := TagRunPr;                                    // SQL=int, Delphi=Byte
    SalesModeParam.Value := SalesMode;                                  // SQL=bit, Delphi=Boolean
    LastInvParam.Value := LastInv;                                      // SQL=int, Delphi=LongInt
    SRCPIRefParam.Value := SRCPIRef;                                    // SQL=varchar, Delphi=Str10
    LastTagRunNoParam.Value := LastTagRunNo;                            // SQL=int, Delphi=LongInt
    TagCtrlCodeParam.Value := TagCtrlCode;                              // SQL=int, Delphi=LongInt
    UseAcCCParam.Value := UseAcCC;                                      // SQL=bit, Delphi=Boolean
    SetCQatPParam.Value := SetCQatP;                                    // SQL=bit, Delphi=Boolean
    IncSDiscParam.Value := IncSDisc;                                    // SQL=bit, Delphi=Boolean
    SDDaysOverParam.Value := SDDaysOver;                                // SQL=int, Delphi=SmallInt
    ShowLogParam.Value := ShowLog;                                      // SQL=bit, Delphi=Boolean
    UseOsNdxParam.Value := UseOsNdx;                                    // SQL=bit, Delphi=Boolean
    BACSCLIUCountParam.Value := LIUCount;                               // SQL=int, Delphi=LongInt
    YourRefParam.Value := YourRef;                                      // SQL=varchar, Delphi=String[20]
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    ApplyPPDParam.Value := ApplyPPD;
    IntendedPaymentDateParam.Value := IntendedPaymentDate;
    PPDExpiryToleranceDaysParam.Value := PPDExpiryToleranceDays;
  End; // With DataRec^, BacsCRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_OldAutoBankRecVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'TagRunNo, ' +
                                               'BankNom, ' +
                                               'BankCr, ' +
                                               'ReconOpo, ' +
                                               'EntryTotDr, ' +
                                               'EntryTotCr, ' +
                                               'EntryDate, ' +
                                               'NomEntTyp, ' +
                                               'AllMatchOk, ' +
                                               'MatchCount, ' +
                                               'MatchOBal, ' +
                                               'ManTotDr, ' +
                                               'ManTotCr, ' +
                                               'ManRunNo, ' +
                                               'ManChange, ' +
                                               'ManCount' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':TagRunNo, ' +
                       ':BankNom, ' +
                       ':BankCr, ' +
                       ':ReconOpo, ' +
                       ':EntryTotDr, ' +
                       ':EntryTotCr, ' +
                       ':EntryDate, ' +
                       ':NomEntTyp, ' +
                       ':AllMatchOk, ' +
                       ':MatchCount, ' +
                       ':MatchOBal, ' +
                       ':ManTotDr, ' +
                       ':ManTotCr, ' +
                       ':ManRunNo, ' +
                       ':ManChange, ' +
                       ':ManCount' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    TagRunNoParam := FindParam('TagRunNo');
    BankNomParam := FindParam('BankNom');
    BankCrParam := FindParam('BankCr');
    ReconOpoParam := FindParam('ReconOpo');
    EntryTotDrParam := FindParam('EntryTotDr');
    EntryTotCrParam := FindParam('EntryTotCr');
    EntryDateParam := FindParam('EntryDate');
    NomEntTypParam := FindParam('NomEntTyp');
    AllMatchOkParam := FindParam('AllMatchOk');
    MatchCountParam := FindParam('MatchCount');
    MatchOBalParam := FindParam('MatchOBal');
    ManTotDrParam := FindParam('ManTotDr');
    ManTotCrParam := FindParam('ManTotCr');
    ManRunNoParam := FindParam('ManRunNo');
    ManChangeParam := FindParam('ManChange');
    ManCountParam := FindParam('ManCount');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_OldAutoBankRecVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;
  
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, BankCRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@BankCode, SizeOf(BankCode));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the following field!
    ExchqChkCode3Param.Value := CreateVariantArray (@Spare3K, 12);

    // Have to start the binary block containing the rest of the TagRunNo field in the 2nd byte
    BinPtr := Pointer(LongInt(@TagRunNo) + 1);
    TagRunNoParam.Value := CreateVariantArray (BinPtr, SizeOf(TagRunNo) - 1);
    BankNomParam.Value := BankNom;                                          // SQL=int, Delphi=LongInt
    BankCrParam.Value := BankCr;                                            // SQL=int, Delphi=Byte
    ReconOpoParam.Value := ReconOpo;                                        // SQL=varchar, Delphi=String[10]
    EntryTotDrParam.Value := EntryTotDr;                                    // SQL=float, Delphi=Double
    EntryTotCrParam.Value := EntryTotCr;                                    // SQL=float, Delphi=Double
    EntryDateParam.Value := EntryDate;                                      // SQL=varchar, Delphi=LongDate
    NomEntTypParam.Value := ConvertCharToSQLEmulatorVarChar(NomEntTyp);     // SQL=varchar, Delphi=Char
    AllMatchOkParam.Value := AllMatchOk;                                    // SQL=bit, Delphi=Boolean
    MatchCountParam.Value := MatchCount;                                    // SQL=int, Delphi=LongInt
    MatchOBalParam.Value := MatchOBal;                                      // SQL=float, Delphi=Double
    ManTotDrParam.Value := ManTotDr;                                        // SQL=float, Delphi=Double
    ManTotCrParam.Value := ManTotCr;                                        // SQL=float, Delphi=Double
    ManRunNoParam.Value := ManRunNo;                                        // SQL=int, Delphi=LongInt
    ManChangeParam.Value := ManChange;                                      // SQL=bit, Delphi=Boolean
    ManCountParam.Value := ManCount;                                        // SQL=int, Delphi=LongInt
  End; // With DataRec^, BankCRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_MoveGLStockVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'SCodeOld, ' +
                                               'SCodeNew, ' +
                                               'MoveStage, ' +
                                               'OldNCode, ' +
                                               'NewNCode, ' +
                                               'NTypOld, ' +
                                               'NTypNew, ' +
                                               'MoveKey1, ' +
                                               'MoveKey2, ' +
                                               'WasMode, ' +
                                               'SGrpNew, ' +
                                               'SUser, ' +
                                               'FinStage, ' +
                                               'ProgCounter, ' +
                                               'MIsCust, ' +
                                               'MListRecAddr' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':SCodeOld, ' +
                       ':SCodeNew, ' +
                       ':MoveStage, ' +
                       ':OldNCode, ' +
                       ':NewNCode, ' +
                       ':NTypOld, ' +
                       ':NTypNew, ' +
                       ':MoveKey1, ' +
                       ':MoveKey2, ' +
                       ':WasMode, ' +
                       ':SGrpNew, ' +
                       ':SUser, ' +
                       ':FinStage, ' +
                       ':ProgCounter, ' +
                       ':MIsCust, ' +
                       ':MListRecAddr' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    SCodeOldParam := FindParam('SCodeOld');
    SCodeNewParam := FindParam('SCodeNew');
    MoveStageParam := FindParam('MoveStage');
    OldNCodeParam := FindParam('OldNCode');
    NewNCodeParam := FindParam('NewNCode');
    NTypOldParam := FindParam('NTypOld');
    NTypNewParam := FindParam('NTypNew');
    MoveKey1Param := FindParam('MoveKey1');
    MoveKey2Param := FindParam('MoveKey2');
    WasModeParam := FindParam('WasMode');
    SGrpNewParam := FindParam('SGrpNew');
    SUserParam := FindParam('SUser');
    FinStageParam := FindParam('FinStage');
    ProgCounterParam := FindParam('ProgCounter');
    MIsCustParam := FindParam('MIsCust');
    MListRecAddrParam := FindParam('MListRecAddr');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_MoveGLStockVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, MoveCtrlRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields - unfortunately due to incompetance by the original author the fields
    // don't map onto the indexes at all!
    ExchqChkCode1Param.Value := CreateVariantArray (@MLocC, 13);         // overlaps 2 bytes into Spare1
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1[3], 10);     // starts at byte 3 of Spare1 for 10 bytes
    ExchqChkCode3Param.Value := CreateVariantArray (@Spare1[13], 12);    // Starts at byte 13 of Spare1 for 12 bytes, includes 8 bytes of SCodeOld

    // First 8 bytes of SCodeOld are actually in the ExchqChkCode3 indexed field
    SCodeOldParam.Value := CreateVariantArray (@SCodeOld[8], 13);       // SQL=varbinary, Delphi=String[20]
    SCodeNewParam.Value := SCodeNew;                                    // SQL=varchar, Delphi=String[20]
    MoveStageParam.Value := MoveStage;                                  // SQL=int, Delphi=Byte
    OldNCodeParam.Value := OldNCode;                                    // SQL=int, Delphi=LongInt
    NewNCodeParam.Value := NewNCode;                                    // SQL=int, Delphi=LongInt
    NTypOldParam.Value := ConvertCharToSQLEmulatorVarChar(NTypOld);     // SQL=varchar, Delphi=Char
    NTypNewParam.Value := ConvertCharToSQLEmulatorVarChar(NTypNew);     // SQL=varchar, Delphi=Char
    MoveKey1Param.Value := MoveKey1;                                    // SQL=varchar, Delphi=String[50]
    MoveKey2Param.Value := MoveKey2;                                    // SQL=varchar, Delphi=String[50]
    WasModeParam.Value := WasMode;                                      // SQL=int, Delphi=Byte
    SGrpNewParam.Value := SGrpNew;                                      // SQL=varchar, Delphi=String[20]
    SUserParam.Value := SUser;                                          // SQL=varchar, Delphi=String[10]
    FinStageParam.Value := FinStage;                                    // SQL=bit, Delphi=Boolean
    ProgCounterParam.Value := ProgCounter;                              // SQL=int, Delphi=LongInt
    MIsCustParam.Value := MIsCust;                                      // SQL=bit, Delphi=Boolean
    MListRecAddrParam.Value := MListRecAddr;                            // SQL=int, Delphi=LongInt
  End; // With DataRec^, MoveCtrlRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_GLMoveVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'MoveCodeNom, ' +
                                               'MoveFromNom, ' +
                                               'MoveToNom, ' +
                                               'MoveTypeNom' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':MoveCodeNom, ' +
                       ':MoveFromNom, ' +
                       ':MoveToNom, ' +
                       ':MoveTypeNom' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    MoveCodeNomParam := FindParam('MoveCodeNom');
    MoveFromNomParam := FindParam('MoveFromNom');
    MoveToNomParam := FindParam('MoveToNom');
    MoveTypeNomParam := FindParam('MoveTypeNom');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_GLMoveVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
  BinPtr : Pointer;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, MoveNomRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@MNomCode, SizeOf(MNomCode));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the following field!
    ExchqChkCode3Param.Value := CreateVariantArray (@SecondKey, 12);

    // First byte of MoveCode is actually in the ExchqChkCode3 indexed field
    BinPtr := Pointer(LongInt(@MoveCode) + 1);
    MoveCodeNomParam.Value := CreateVariantArray (BinPtr, SizeOf(MoveCode) - 1);    // SQL=varbinary, Delphi=LongInt
    MoveFromNomParam.Value := MoveFrom;                                      // SQL=int, Delphi=LongInt
    MoveToNomParam.Value := MoveTo;                                          // SQL=int, Delphi=LongInt
    MoveTypeNomParam.Value := ConvertCharToSQLEmulatorVarChar(MoveType);     // SQL=varchar, Delphi=Char
  End; // With DataRec^, MoveNomRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_StockMoveVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'MoveCodeStk, ' +
                                               'MoveFromStk, ' +
                                               'MoveToStk, ' +
                                               'NewStkCode' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':MoveCodeStk, ' +
                       ':MoveFromStk, ' +
                       ':MoveToStk, ' +
                       ':NewStkCode' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    MoveCodeStkParam := FindParam('MoveCodeStk');
    MoveFromStkParam := FindParam('MoveFromStk');
    MoveToStkParam := FindParam('MoveToStk');
    NewStkCodeParam := FindParam('NewStkCode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_StockMoveVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, MoveStkRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields - unfortunately due to incompetance by the original author the fields
    // don't map onto the indexes at all!
    ExchqChkCode1Param.Value := CreateVariantArray (@MStkCode, 13);
    ExchqChkCode2Param.Value := CreateVariantArray (@MStkCode[13], 10);
    ExchqChkCode3Param.Value := CreateVariantArray (@SecondKey, 12);

    // First byte of MoveCode is actually in the ExchqChkCode3 indexed field
    MoveCodeStkParam.Value := CreateVariantArray (@MoveCode[1], SizeOf(MoveCode) - 1);    // SQL=varbinary, Delphi=String[16]
    MoveFromStkParam.Value := MFromCode;                                // SQL=varchar, Delphi=String[16]
    MoveToStkParam.Value := MToCode;                                    // SQL=varchar, Delphi=String[16]
    NewStkCodeParam.Value := NewStkCode;                                // SQL=varchar, Delphi=String[16]
  End; // With DataRec^, MoveStkRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_BatchPayAccessVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPfix, ' +
                                               'SubType, ' +
                                               'EXCHQCHKcode1, ' +
                                               'EXCHQCHKcode2, ' +
                                               'EXCHQCHKcode3, ' +
                                               'OpoName, ' +
                                               'StartDate, ' +
                                               'StartTime, ' +
                                               'WinLogName, ' +
                                               'WinCPUName, ' +
                                               'BACSULIUCount' +
                                               ')' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':EXCHQCHKcode1, ' +
                       ':EXCHQCHKcode2, ' +
                       ':EXCHQCHKcode3, ' +
                       ':OpoName, ' +
                       ':StartDate, ' +
                       ':StartTime, ' +
                       ':WinLogName, ' +
                       ':WinCPUName, ' +
                       ':BACSULIUCount' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    // Common fields
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    EXCHQCHKcode1Param := FindParam('EXCHQCHKcode1');
    EXCHQCHKcode2Param := FindParam('EXCHQCHKcode2');
    EXCHQCHKcode3Param := FindParam('EXCHQCHKcode3');

    OpoNameParam := FindParam('OpoName');
    StartDateParam := FindParam('StartDate');
    StartTimeParam := FindParam('StartTime');
    WinLogNameParam := FindParam('WinLogName');
    WinCPUNameParam := FindParam('WinCPUName');
    BACSULIUCountParam := FindParam('BACSULIUCount');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_BatchPayAccessVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, BacsURec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@UsrCode, SizeOf(UsrCode));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the following field!
    ExchqChkCode3Param.Value := CreateVariantArray (@Spare3K, 12);

    // First byte of OpoName is actually in the ExchqChkCode3 indexed field
    OpoNameParam.Value := CreateVariantArray (@OpoName[1], SizeOf(OpoName) - 1);    // SQL=varbinary, Delphi=String[10]
    StartDateParam.Value := StartDate;                                  // SQL=varchar, Delphi=LongDate
    StartTimeParam.Value := StartTime;                                  // SQL=varchar, Delphi=String[6]
    WinLogNameParam.Value := WinLogName;                                // SQL=varchar, Delphi=String[50]
    WinCPUNameParam.Value := WinCPUName;                                // SQL=varchar, Delphi=String[50]
    BACSULIUCountParam.Value := LIUCount;                               // SQL=int, Delphi=LongInt
  End; // With DataRec^, BacsURec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_VSecureVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_VSecureVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  RecPFixParam, SubTypeParam, ExchqChkCode1Param, ExchqChkCode2Param, ExchqChkCode3Param, StuffParam : TParameter;
  BinPtr : Pointer;
  sqlQuery : ANSIString;
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqChk (' +
                                               'RecPFix, ' +
                                               'SubType, ' +
                                               'ExchqChkCode1, ' +
                                               'ExchqChkCode2, ' +
                                               'ExchqChkCode3, ' +
                                               'Stuff' +
                                               ')' +
              'VALUES (' +
                       ':RecPFix, ' +
                       ':SubType, ' +
                       ':ExchqChkCode1, ' +
                       ':ExchqChkCode2, ' +
                       ':ExchqChkCode3, ' +
                       ':Stuff' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPFixParam := FindParam('RecPFix');
    SubTypeParam := FindParam('SubType');
    ExchqChkCode1Param := FindParam('ExchqChkCode1');
    ExchqChkCode2Param := FindParam('ExchqChkCode2');
    ExchqChkCode3Param := FindParam('ExchqChkCode3');
    StuffParam := FindParam('Stuff');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, VSecureRec Do
  Begin
    RecPFixParam.Value := RecPFix;
    SubTypeParam.Value := Ord(SubType);   // SubType is an Int in the SQL DB

    // Index fields
    ExchqChkCode1Param.Value := CreateVariantArray (@SecCode, SizeOf(SecCode));
    ExchqChkCode2Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));
    // Unfortunately due to incompetance by the original author the fields don't map onto
    // the indexes properly so the index overflows into the first byte of the UsrRelDate field!
    ExchqChkCode3Param.Value := CreateVariantArray (@ExUsrRel, SizeOf(ExUsrRel) + 1);

    // Have to start the binary block containing the rest of the details 1 byte into the UsrRelDate field
    BinPtr := Pointer(LongInt(@UsrRelDate) + 1);
    StuffParam.Value := CreateVariantArray (BinPtr, CalculateBinaryBlockSize (BinPtr, @Spare2));
  End; // With DataRec^.CIS340
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqChkDataWrite_OrderPaymentsMatchingVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].OrderPaymentsMatching (' +
                                                            'DocRef, ' +
                                                            'PayRef, ' +
                                                            'SettledVal, ' +
                                                            'OwnCVal, ' +
                                                            'MCurrency, ' +
                                                            'MatchType, ' +
                                                            'OldAltRef, ' +
                                                            'RCurrency, ' +
                                                            'RecOwnCVal, ' +
                                                            'AltRef' +
                                                          ') ' +
              'VALUES (' +
                       ':DocRef, ' +
                       ':PayRef, ' +
                       ':SettledVal, ' +
                       ':OwnCVal, ' +
                       ':MCurrency, ' +
                       ':MatchType, ' +
                       ':OldAltRef, ' +
                       ':RCurrency, ' +
                       ':RecOwnCVal, ' +
                       ':AltRef' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    DocRefParam := FindParam('DocRef');
    PayRefParam := FindParam('PayRef');
    SettledValParam := FindParam('SettledVal');
    OwnCValParam := FindParam('OwnCVal');
    MCurrencyParam := FindParam('MCurrency');
    MatchTypeParam := FindParam('MatchType');
    OldAltRefParam := FindParam('OldAltRef');
    RCurrencyParam := FindParam('RCurrency');
    RecOwnCValParam := FindParam('RecOwnCVal');
    AltRefParam := FindParam('AltRef');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqChkDataWrite_OrderPaymentsMatchingVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^.MatchPayRec Do
  Begin
    DocRefParam.Value := DocCode;           // SQL=varchar, Delphi=
    PayRefParam.Value := PayRef;            // SQL=varchar, Delphi=
    SettledValParam.Value := SettledVal;    // SQL=float, Delphi=
    OwnCValParam.Value := OwnCVal;          // SQL=float, Delphi=
    MCurrencyParam.Value := MCurrency;      // SQL=int, Delphi=
    MatchTypeParam.Value := MatchType;      // SQL=varchar, Delphi=
    OldAltRefParam.Value := OldAltRef;      // SQL=varchar, Delphi=
    RCurrencyParam.Value := RCurrency;      // SQL=int, Delphi=
    RecOwnCValParam.Value := RecOwnCVal;    // SQL=float, Delphi=
    AltRefParam.Value := AltRef;            // SQL=varchar, Delphi=
  End; // With DataRec^.MatchPayRec
End; // SetQueryValues

//=========================================================================

End.

