Unit oExchqSSDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TExchqSSDataWrite_SysRVariant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_SysRVariant

  //------------------------------

  TExchqSSDataWrite_VATVariant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_VATVariant

  //------------------------------

  TExchqSSDataWrite_MainCurrencyVariant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_MainCurrencyVariant

  //------------------------------

  TExchqSSDataWrite_DefVariant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_DefVariant

  //------------------------------

  TExchqSSDataWrite_JobVariant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_JobVariant

  //------------------------------

  TExchqSSDataWrite_FormDefVariant = Class(TDataWrite_BaseSubVariant)
  Private
    IDCodeParam, PrimaryForm001Param, PrimaryForm002Param, PrimaryForm003Param,
    PrimaryForm004Param, PrimaryForm005Param, PrimaryForm006Param, PrimaryForm007Param,
    PrimaryForm008Param, PrimaryForm009Param, PrimaryForm010Param, PrimaryForm011Param,
    PrimaryForm012Param, PrimaryForm013Param, PrimaryForm014Param, PrimaryForm015Param,
    PrimaryForm016Param, PrimaryForm017Param, PrimaryForm018Param, PrimaryForm019Param,
    PrimaryForm020Param, PrimaryForm021Param, PrimaryForm022Param, PrimaryForm023Param,
    PrimaryForm024Param, PrimaryForm025Param, PrimaryForm026Param, PrimaryForm027Param,
    PrimaryForm028Param, PrimaryForm029Param, PrimaryForm030Param, PrimaryForm031Param,
    PrimaryForm032Param, PrimaryForm033Param, PrimaryForm034Param, PrimaryForm035Param,
    PrimaryForm036Param, PrimaryForm037Param, PrimaryForm038Param, PrimaryForm039Param,
    PrimaryForm040Param, PrimaryForm041Param, PrimaryForm042Param, PrimaryForm043Param,
    PrimaryForm044Param, PrimaryForm045Param, PrimaryForm046Param, PrimaryForm047Param,
    PrimaryForm048Param, PrimaryForm049Param, PrimaryForm050Param, PrimaryForm051Param,
    PrimaryForm052Param, PrimaryForm053Param, PrimaryForm054Param, PrimaryForm055Param,
    PrimaryForm056Param, PrimaryForm057Param, PrimaryForm058Param, PrimaryForm059Param,
    PrimaryForm060Param, PrimaryForm061Param, PrimaryForm062Param, PrimaryForm063Param,
    PrimaryForm064Param, PrimaryForm065Param, PrimaryForm066Param, PrimaryForm067Param,
    PrimaryForm068Param, PrimaryForm069Param, PrimaryForm070Param, PrimaryForm071Param,
    PrimaryForm072Param, PrimaryForm073Param, PrimaryForm074Param, PrimaryForm075Param,
    PrimaryForm076Param, PrimaryForm077Param, PrimaryForm078Param, PrimaryForm079Param,
    PrimaryForm080Param, PrimaryForm081Param, PrimaryForm082Param, PrimaryForm083Param,
    PrimaryForm084Param, PrimaryForm085Param, PrimaryForm086Param, PrimaryForm087Param,
    PrimaryForm088Param, PrimaryForm089Param, PrimaryForm090Param, PrimaryForm091Param,
    PrimaryForm092Param, PrimaryForm093Param, PrimaryForm094Param, PrimaryForm095Param,
    PrimaryForm096Param, PrimaryForm097Param, PrimaryForm098Param, PrimaryForm099Param,
    PrimaryForm100Param, PrimaryForm101Param, PrimaryForm102Param, PrimaryForm103Param,
    PrimaryForm104Param, PrimaryForm105Param, PrimaryForm106Param, PrimaryForm107Param,
    PrimaryForm108Param, PrimaryForm109Param, PrimaryForm110Param, PrimaryForm111Param,
    PrimaryForm112Param, PrimaryForm113Param, PrimaryForm114Param, PrimaryForm115Param,
    PrimaryForm116Param, PrimaryForm117Param, PrimaryForm118Param, PrimaryForm119Param,
    PrimaryForm120Param, DescrParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_FormDefVariant

  //------------------------------

  TExchqSSDataWrite_ModVariant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_ModVariant

  //------------------------------

  TExchqSSDataWrite_EuroCurrencyVariant = Class(TDataWrite_BaseSubVariant)
  Private
    IDCodeParam, GCR_triRatesParam, GCR_triEuroParam, GCR_triInvertParam, GCR_triFloatParam: TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_EuroCurrencyVariant

  //------------------------------

  TExchqSSDataWrite_EDI1Variant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_EDI1Variant

  //------------------------------

  TExchqSSDataWrite_EDI2Variant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_EDI2Variant

  //------------------------------

  TExchqSSDataWrite_EDI3Variant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_EDI3Variant

  //------------------------------

  TExchqSSDataWrite_CustomFieldsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    IDCodeParam, FCaptionsParam, FHideParam: TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_CustomFieldsVariant

  //------------------------------

  TExchqSSDataWrite_CISVariant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_CISVariant

  //------------------------------

  TExchqSSDataWrite_CIS340Variant = Class(TDataWrite_BaseSubVariant)
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite_CIS340Variant

  //------------------------------

  TExchqSSDataWrite = Class(TBaseDataWrite)
  Private
    FSysRVariant : TExchqSSDataWrite_SysRVariant;
    FVATVariant : TExchqSSDataWrite_VATVariant;
    FCurrencyVariant : TExchqSSDataWrite_MainCurrencyVariant;
    FDefVariant : TExchqSSDataWrite_DefVariant;
    FJobVariant : TExchqSSDataWrite_JobVariant;
    FFormDefVariant : TExchqSSDataWrite_FormDefVariant;
    FModVariant : TExchqSSDataWrite_ModVariant;
    FEuroCurrencyVariant : TExchqSSDataWrite_EuroCurrencyVariant;
    FEDI1Variant : TExchqSSDataWrite_EDI1Variant;
    EDI2Variant : TExchqSSDataWrite_EDI2Variant;
    EDI3Variant : TExchqSSDataWrite_EDI3Variant;
    FCustomFieldsVariant : TExchqSSDataWrite_CustomFieldsVariant;
    CISVariant : TExchqSSDataWrite_CISVariant;
    CIS340Variant : TExchqSSDataWrite_CIS340Variant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;
    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqSSDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TExchqSSDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FSysRVariant := TExchqSSDataWrite_SysRVariant.Create;
  FVATVariant := TExchqSSDataWrite_VATVariant.Create;
  FCurrencyVariant := TExchqSSDataWrite_MainCurrencyVariant.Create;
  FDefVariant := TExchqSSDataWrite_DefVariant.Create;
  FJobVariant := TExchqSSDataWrite_JobVariant.Create;
  FFormDefVariant := TExchqSSDataWrite_FormDefVariant.Create;
  FModVariant := TExchqSSDataWrite_ModVariant.Create;
  FEuroCurrencyVariant := TExchqSSDataWrite_EuroCurrencyVariant.Create;
  FEDI1Variant := TExchqSSDataWrite_EDI1Variant.Create;
  EDI2Variant := TExchqSSDataWrite_EDI2Variant.Create;
  EDI3Variant := TExchqSSDataWrite_EDI3Variant.Create;
  FCustomFieldsVariant := TExchqSSDataWrite_CustomFieldsVariant.Create;
  CISVariant := TExchqSSDataWrite_CISVariant.Create;
  CIS340Variant := TExchqSSDataWrite_CIS340Variant.Create;
End; // Create

//------------------------------

Destructor TExchqSSDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FSysRVariant);
  FreeAndNIL(FVATVariant);
  FreeAndNIL(FCurrencyVariant);
  FreeAndNIL(FDefVariant);
  FreeAndNIL(FJobVariant);
  FreeAndNIL(FFormDefVariant);
  FreeAndNIL(FModVariant);
  FreeAndNIL(FEuroCurrencyVariant);
  FreeAndNIL(FEDI1Variant);
  FreeAndNIL(EDI2Variant);
  FreeAndNIL(EDI3Variant);
  FreeAndNIL(FCustomFieldsVariant);
  FreeAndNIL(CISVariant);
  FreeAndNIL(CIS340Variant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FSysRVariant.Prepare (ADOConnection, CompanyCode);
  FVATVariant.Prepare (ADOConnection, CompanyCode);
  FCurrencyVariant.Prepare (ADOConnection, CompanyCode);
  FDefVariant.Prepare (ADOConnection, CompanyCode);
  FJobVariant.Prepare (ADOConnection, CompanyCode);
  FFormDefVariant.Prepare (ADOConnection, CompanyCode);
  FModVariant.Prepare (ADOConnection, CompanyCode);
  FEuroCurrencyVariant.Prepare (ADOConnection, CompanyCode);
  FEDI1Variant.Prepare (ADOConnection, CompanyCode);
  EDI2Variant.Prepare (ADOConnection, CompanyCode);
  EDI3Variant.Prepare (ADOConnection, CompanyCode);
  FCustomFieldsVariant.Prepare (ADOConnection, CompanyCode);
  CISVariant.Prepare (ADOConnection, CompanyCode);
  CIS340Variant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^SysRec;
  sDumpFile : ShortString;
Begin // SetParameterValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  If (DataRec^.IDCode = SysNames[SysR]) Then
  Begin
    // SYS - Main System Setup Record
    FSysRVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[SysR])
  Else If (DataRec^.IDCode = SysNames[VATR]) Then
  Begin
    // VAT - VAT Settings Record + misc cruft
    FVATVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[VATR])
  Else If (DataRec^.IDCode = SysNames[CurR]) Or (DataRec^.IDCode = SysNames[CuR2]) Or (DataRec^.IDCode = SysNames[CuR3]) Then
  Begin
    // Currency Array Records - 3 instances
    FCurrencyVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[CurR]) Or (DataRec^.IDCode = SysNames[CuR2]) Or (DataRec^.IDCode = SysNames[CuR3])
  Else If (DataRec^.IDCode = SysNames[DefR]) Then
  Begin
    // Def - DOS Form Definitions - not sure why this is still in the database!
    FDefVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[DefR])
  Else If (DataRec^.IDCode = SysNames[JobSR]) Then
  Begin
    // JOB - Job Costing settings
    FJobVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[JobSR])
  Else If (Copy(DataRec^.IDCode, 1, 2) = Copy (SysNames[FormR], 1, 2)) Then
  Begin
    // FRM + FR* - Form Definition Sets
    FFormDefVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (Copy(DataRec^.IDCode, 1, 2) = Copy (SysNames[FormR], 1, 2))
  Else If (DataRec^.IDCode = SysNames[ModRR]) Then
  Begin
    // MOD - Module Release Codes
    FModVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[ModRR])
  Else If (DataRec^.IDCode = SysNames[GCUR]) Or (DataRec^.IDCode = SysNames[GCU2]) Or (DataRec^.IDCode = SysNames[GCU3]) Then
  Begin
    // Euro Triangulation Currency Array Records
    FEuroCurrencyVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[GCUR]) Or (DataRec^.IDCode = SysNames[GCU2]) Or (DataRec^.IDCode = SysNames[GCU3])
  Else If (DataRec^.IDCode = SysNames[EDI1R]) Then
  Begin
    // ED1 - EDI Settings
    FEDI1Variant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[EDI1R])
  Else If (DataRec^.IDCode = SysNames[EDI2R]) Then
  Begin
    // ED2 - Fax/Email
    EDI2Variant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[EDI2R])
  Else If (DataRec^.IDCode = SysNames[EDI3R]) Then
  Begin
    // ED3 - Spare fields only!
    EDI3Variant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[EDI2R])
  Else If (DataRec^.IDCode = SysNames[CstmFR]) Or (DataRec^.IDCode = SysNames[CstmFR2]) Then
  Begin
    // Custom Fields Records
    FCustomFieldsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[CstmFR]) Or (DataRec^.IDCode = SysNames[CstmFR2])
  Else If (DataRec^.IDCode = SysNames[CISR]) Then
  Begin
    // CIS - CIS Settings
    CISVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[CISR])
  Else If (DataRec^.IDCode = SysNames[CIS340R]) Then
  Begin
    // CI2 - CIS 340 Settings
    CIS340Variant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec^.IDCode = SysNames[CIS340R])
  Else
  Begin
    // Unknown Data - Log error and continue conversion
    SkipRecord := True;
    sDumpFile := DataPacket.DumpToFile;
    ConversionWarnings.AddWarning(TSQLUnknownVariantWarning.Create (DataPacket, sDumpFile, ToHexString(@DataRec^.IDCode, SizeOf(DataRec^.IDCode))));
    Logging.UnknownVariant(Trim(DataPacket.CompanyDetails.ccCompanyPath) + DataPacket.TaskDetails.dctPervasiveFilename, ToHexString(@DataRec^.IDCode, SizeOf(DataRec^.IDCode)), sDumpFile);
  End; // Else
End; // SetParameterValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_SysRVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_SysRVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, OptParam, OMonWk1Param, PrinYrParam, FiltSNoBinLocParam, KeepBinHistParam,
  UseBKThemeParam, UserNameParam, AuditYrParam, AuditPrParam, Spare6Param,
  ManROCPParam, VATCurrParam, NoCosDecParam, CurrBaseParam, MuteBeepParam,
  ShowStkGPParam, AutoValStkParam, DelPickOnlyParam, UseMLocParam, EditSinSerParam,
  WarnYRefParam, UseLocDelParam, PostCCNomParam, AlTolValParam, AlTolModeParam,
  DebtLModeParam, AutoGenVarParam, AutoGenDiscParam, UseModuleSecParam, ProtectPostParam,
  UsePick4AllParam, BigStkTreeParam, BigJobTreeParam, ShowQtySTreeParam,
  ProtectYRefParam, PurchUIDateParam, UseUpliftNCParam, UseWIss4AllParam,
  UseSTDWOPParam, UseSalesAnalParam, PostCCDComboParam, UseClassToolBParam,
  WOPStkCopModeParam, USRCntryCodeParam, NoNetDecParam, DebTrigParam, BKThemeNoParam,
  UseGLClassParam, Spare4Param, NoInvLinesParam, WksODueParam, CPrParam,
  CYrParam, OAuditDateParam, TradeTermParam, StaSepCrParam, StaAgeMthdParam,
  StaUIDateParam, SepRunPostParam, QUAllocFlgParam, DeadBOMParam, AuthModeParam,
  IntraStatParam, AnalStkDescParam, AutoStkValParam, AutoBillUpParam, AutoCQNoParam,
  IncNotDueParam, UseBatchTotParam, UseStockParam, AutoNotesParam, HideMenuOptParam,
  UseCCDepParam, NoHoldDiscParam, AutoPrCalcParam, StopBadDrParam, UsePayInParam,
  UsePasswordsParam, PrintRecieptParam, ExternCustParam, NoQtyDecParam, ExternSINParam,
  PrevPrOffParam, DefPcDiscParam, TradCodeNumParam, UpBalOnPostParam, ShowInvDiscParam,
  SepDiscountsParam, UseCreditChkParam, UseCRLimitChkParam, AutoClearPayParam,
  TotalConvParam, DispPrAsMonthsParam, NomCtrlInVATParam, NomCtrlOutVATParam,
  NomCtrlDebtorsParam, NomCtrlCreditorsParam, NomCtrlDiscountGivenParam,
  NomCtrlDiscountTakenParam, NomCtrlLDiscGivenParam, NomCtrlLDiscTakenParam,
  NomCtrlProfitBFParam, NomCtrlCurrVarParam, NomCtrlUnRCurrVarParam, NomCtrlPLStartParam,
  NomCtrlPLEndParam, NomCtrlFreightNCParam, NomCtrlSalesCommParam, NomCtrlPurchCommParam,
  NomCtrlRetSurchargeParam, NomCtrlSpare8Param, NomCtrlSpare9Param, NomCtrlSpare10Param,
  NomCtrlSpare11Param, NomCtrlSpare12Param, NomCtrlSpare13Param, NomCtrlSpare14Param,
  DetailAddr1Param, DetailAddr2Param, DetailAddr3Param, DetailAddr4Param,
  DetailAddr5Param, DirectCustParam, DirectSuppParam, TermsofTrade1Param,
  TermsofTrade2Param, NomPayFromParam, NomPayTooParam, SettleDiscParam, SettleDaysParam,
  NeedBMUpParam, IgnoreBDPWParam, InpPackParam, Spare32Param, VATCodeParam,
  PayTermsParam, OTrigDateParam, StaAgeIntParam, QuoOwnDateParam, FreeExAllParam,
  DirOwnCountParam, StaShowOSParam, LiveCredSParam, BatchPPYParam, WarnJCParam,
  TxLateCRParam, ConsvMemParam, DefBankNomParam, UseDefBankParam, HideExLogoParam,
  AMMThreadParam, AMMPreview1Param, AMMPreview2Param, EntULogCountParam,
  DefSRCBankNomParam, SDNOwnDateParam, EXISNParam, ExDemoVerParam, DupliVSecParam,
  LastDailyParam, OldUserSortParam, OldUserAccParam, UserRefParam, SpareBitsParam,
  GracePeriodParam, MonWk1Param, AuditDateParam, TrigDateParam, ExUsrSecParam,
  UsrLogCountParam, BinMaskParam, Spare5aParam, Spare6aParam, UserBankParam,
  ExSecParam, LastExpFolioParam, DetailTelParam, DetailFaxParam, UserVATRegParam,
  EnableTTDDiscountsParam, EnableVBDDiscountsParam, EnableOverrideLocationsParam,
  IncludeVATInCommittedBalanceParam, ssBankSortCodeParam,
  ssBankAccountCodeParam : TParameter;
  // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
  ssConsumersEnabledParam : TParameter;
  // MH 24/10/2014: Added support for new Order Payments fields
  ssEnableOrderPaymentsParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'Opt, ' +
                                              'OMonWk1, ' +
                                              'PrinYr, ' +
                                              'FiltSNoBinLoc, ' +
                                              'KeepBinHist, ' +
                                              'UseBKTheme, ' +
                                              'UserName, ' +
                                              'AuditYr, ' +
                                              'AuditPr, ' +
                                              'Spare6, ' +
                                              'ManROCP, ' +
                                              'VATCurr, ' +
                                              'NoCosDec, ' +
                                              'CurrBase, ' +
                                              'MuteBeep, ' +
                                              'ShowStkGP, ' +
                                              'AutoValStk, ' +
                                              'DelPickOnly, ' +
                                              'UseMLoc, ' +
                                              'EditSinSer, ' +
                                              'WarnYRef, ' +
                                              'UseLocDel, ' +
                                              'PostCCNom, ' +
                                              'AlTolVal, ' +
                                              'AlTolMode, ' +
                                              'DebtLMode, ' + 
                                              'AutoGenVar, ' + 
                                              'AutoGenDisc, ' +
                                              'UseModuleSec, ' + 
                                              'ProtectPost, ' + 
                                              'UsePick4All, ' + 
                                              'BigStkTree, ' +
                                              'BigJobTree, ' +
                                              'ShowQtySTree, ' +
                                              'ProtectYRef, ' +
                                              'PurchUIDate, ' +
                                              'UseUpliftNC, ' +
                                              'UseWIss4All, ' + 
                                              'UseSTDWOP, ' +
                                              'UseSalesAnal, ' + 
                                              'PostCCDCombo, ' +
                                              'UseClassToolB, ' + 
                                              'WOPStkCopMode, ' + 
                                              'USRCntryCode, ' + 
                                              'NoNetDec, ' +
                                              'DebTrig, ' + 
                                              'BKThemeNo, ' + 
                                              'UseGLClass, ' + 
                                              'Spare4, ' + 
                                              'NoInvLines, ' + 
                                              'WksODue, ' +
                                              'CPr, ' +
                                              'CYr, ' +
                                              'OAuditDate, ' + 
                                              'TradeTerm, ' +
                                              'StaSepCr, ' + 
                                              'StaAgeMthd, ' + 
                                              'StaUIDate, ' + 
                                              'SepRunPost, ' + 
                                              'QUAllocFlg, ' +
                                              'DeadBOM, ' + 
                                              'AuthMode, ' + 
                                              'IntraStat, ' +
                                              'AnalStkDesc, ' +
                                              'AutoStkVal, ' + 
                                              'AutoBillUp, ' + 
                                              'AutoCQNo, ' +
                                              'IncNotDue, ' + 
                                              'UseBatchTot, ' +
                                              'UseStock, ' + 
                                              'AutoNotes, ' + 
                                              'HideMenuOpt, ' +
                                              'UseCCDep, ' +
                                              'NoHoldDisc, ' +
                                              'AutoPrCalc, ' +
                                              'StopBadDr, ' + 
                                              'UsePayIn, ' + 
                                              'UsePasswords, ' +
                                              'PrintReciept, ' + 
                                              'ExternCust, ' +
                                              'NoQtyDec, ' + 
                                              'ExternSIN, ' + 
                                              'PrevPrOff, ' + 
                                              'DefPcDisc, ' + 
                                              'TradCodeNum, ' + 
                                              'UpBalOnPost, ' + 
                                              'ShowInvDisc, ' + 
                                              'SepDiscounts, ' + 
                                              'UseCreditChk, ' + 
                                              'UseCRLimitChk, ' +
                                              'AutoClearPay, ' +
                                              'TotalConv, ' + 
                                              'DispPrAsMonths, ' + 
                                              'NomCtrlInVAT, ' +
                                              'NomCtrlOutVAT, ' + 
                                              'NomCtrlDebtors, ' + 
                                              'NomCtrlCreditors, ' + 
                                              'NomCtrlDiscountGiven, ' + 
                                              'NomCtrlDiscountTaken, ' +
                                              'NomCtrlLDiscGiven, ' + 
                                              'NomCtrlLDiscTaken, ' + 
                                              'NomCtrlProfitBF, ' +
                                              'NomCtrlCurrVar, ' +
                                              'NomCtrlUnRCurrVar, ' + 
                                              'NomCtrlPLStart, ' + 
                                              'NomCtrlPLEnd, ' +
                                              'NomCtrlFreightNC, ' + 
                                              'NomCtrlSalesComm, ' + 
                                              'NomCtrlPurchComm, ' +
                                              'NomCtrlRetSurcharge, ' +
                                              'NomCtrlSpare8, ' +
                                              'NomCtrlSpare9, ' +
                                              'NomCtrlSpare10, ' + 
                                              'NomCtrlSpare11, ' +
                                              'NomCtrlSpare12, ' + 
                                              'NomCtrlSpare13, ' + 
                                              'NomCtrlSpare14, ' +
                                              'DetailAddr1, ' + 
                                              'DetailAddr2, ' +
                                              'DetailAddr3, ' + 
                                              'DetailAddr4, ' + 
                                              'DetailAddr5, ' + 
                                              'DirectCust, ' + 
                                              'DirectSupp, ' + 
                                              'TermsofTrade1, ' + 
                                              'TermsofTrade2, ' + 
                                              'NomPayFrom, ' +
                                              'NomPayToo, ' + 
                                              'SettleDisc, ' +
                                              'SettleDays, ' +
                                              'NeedBMUp, ' + 
                                              'IgnoreBDPW, ' + 
                                              'InpPack, ' +
                                              'Spare32, ' + 
                                              'VATCode, ' + 
                                              'PayTerms, ' + 
                                              'OTrigDate, ' +
                                              'StaAgeInt, ' +
                                              'QuoOwnDate, ' + 
                                              'FreeExAll, ' + 
                                              'DirOwnCount, ' +
                                              'StaShowOS, ' +
                                              'LiveCredS, ' +
                                              'BatchPPY, ' + 
                                              'WarnJC, ' +
                                              'TxLateCR, ' +
                                              'ConsvMem, ' +
                                              'DefBankNom, ' +
                                              'UseDefBank, ' + 
                                              'HideExLogo, ' + 
                                              'AMMThread, ' +
                                              'AMMPreview1, ' + 
                                              'AMMPreview2, ' +
                                              'EntULogCount, ' + 
                                              'DefSRCBankNom, ' + 
                                              'SDNOwnDate, ' +
                                              'EXISN, ' + 
                                              'ExDemoVer, ' +
                                              'DupliVSec, ' +
                                              'LastDaily, ' +
                                              'OldUserSort, ' +
                                              'OldUserAcc, ' +
                                              'UserRef, ' +
                                              'SpareBits, ' +
                                              'GracePeriod, ' +
                                              'MonWk1, ' +
                                              'AuditDate, ' +
                                              'TrigDate, ' +
                                              'ExUsrSec, ' +
                                              'UsrLogCount, ' +
                                              'BinMask, ' +
                                              'Spare5a, ' +
                                              'Spare6a, ' +
                                              'UserBank, ' +
                                              'ExSec, ' +
                                              'LastExpFolio, ' +
                                              'DetailTel, ' +
                                              'DetailFax, ' +
                                              'UserVATReg, ' +
                                              'EnableTTDDiscounts, ' +
                                              'EnableVBDDiscounts, ' +
                                              'EnableOverrideLocations, ' +
                                              'IncludeVATInCommittedBalance, ' +
                                              'ssBankSortCode, ' +
                                              'ssBankAccountCode, ' +
                                              // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
                                              'ssConsumersEnabled, ' +
                                              // MH 24/10/2014: Added support for new Order Payments fields
                                              'ssEnableOrderPayments' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':Opt, ' +
                     ':OMonWk1, ' +
                     ':PrinYr, ' +
                     ':FiltSNoBinLoc, ' +
                     ':KeepBinHist, ' +
                     ':UseBKTheme, ' +
                     ':UserName, ' +
                     ':AuditYr, ' +
                     ':AuditPr, ' +
                     ':Spare6, ' +
                     ':ManROCP, ' +
                     ':VATCurr, ' +
                     ':NoCosDec, ' +
                     ':CurrBase, ' +
                     ':MuteBeep, ' +
                     ':ShowStkGP, ' +
                     ':AutoValStk, ' +
                     ':DelPickOnly, ' +
                     ':UseMLoc, ' +
                     ':EditSinSer, ' +
                     ':WarnYRef, ' +
                     ':UseLocDel, ' +
                     ':PostCCNom, ' +
                     ':AlTolVal, ' +
                     ':AlTolMode, ' +
                     ':DebtLMode, ' +
                     ':AutoGenVar, ' +
                     ':AutoGenDisc, ' +
                     ':UseModuleSec, ' +
                     ':ProtectPost, ' +
                     ':UsePick4All, ' +
                     ':BigStkTree, ' +
                     ':BigJobTree, ' +
                     ':ShowQtySTree, ' +
                     ':ProtectYRef, ' +
                     ':PurchUIDate, ' +
                     ':UseUpliftNC, ' +
                     ':UseWIss4All, ' +
                     ':UseSTDWOP, ' +
                     ':UseSalesAnal, ' +
                     ':PostCCDCombo, ' +
                     ':UseClassToolB, ' +
                     ':WOPStkCopMode, ' +
                     ':USRCntryCode, ' +
                     ':NoNetDec, ' +
                     ':DebTrig, ' +
                     ':BKThemeNo, ' +
                     ':UseGLClass, ' +
                     ':Spare4, ' +
                     ':NoInvLines, ' +
                     ':WksODue, ' +
                     ':CPr, ' +
                     ':CYr, ' +
                     ':OAuditDate, ' +
                     ':TradeTerm, ' +
                     ':StaSepCr, ' +
                     ':StaAgeMthd, ' +
                     ':StaUIDate, ' +
                     ':SepRunPost, ' +
                     ':QUAllocFlg, ' +
                     ':DeadBOM, ' +
                     ':AuthMode, ' +
                     ':IntraStat, ' +
                     ':AnalStkDesc, ' +
                     ':AutoStkVal, ' +
                     ':AutoBillUp, ' +
                     ':AutoCQNo, ' +
                     ':IncNotDue, ' +
                     ':UseBatchTot, ' +
                     ':UseStock, ' +
                     ':AutoNotes, ' +
                     ':HideMenuOpt, ' +
                     ':UseCCDep, ' +
                     ':NoHoldDisc, ' +
                     ':AutoPrCalc, ' +
                     ':StopBadDr, ' +
                     ':UsePayIn, ' +
                     ':UsePasswords, ' +
                     ':PrintReciept, ' +
                     ':ExternCust, ' +
                     ':NoQtyDec, ' +
                     ':ExternSIN, ' +
                     ':PrevPrOff, ' +
                     ':DefPcDisc, ' +
                     ':TradCodeNum, ' +
                     ':UpBalOnPost, ' +
                     ':ShowInvDisc, ' +
                     ':SepDiscounts, ' +
                     ':UseCreditChk, ' +
                     ':UseCRLimitChk, ' +
                     ':AutoClearPay, ' +
                     ':TotalConv, ' +
                     ':DispPrAsMonths, ' +
                     ':NomCtrlInVAT, ' +
                     ':NomCtrlOutVAT, ' +
                     ':NomCtrlDebtors, ' +
                     ':NomCtrlCreditors, ' +
                     ':NomCtrlDiscountGiven, ' +
                     ':NomCtrlDiscountTaken, ' +
                     ':NomCtrlLDiscGiven, ' +
                     ':NomCtrlLDiscTaken, ' +
                     ':NomCtrlProfitBF, ' +
                     ':NomCtrlCurrVar, ' +
                     ':NomCtrlUnRCurrVar, ' +
                     ':NomCtrlPLStart, ' +
                     ':NomCtrlPLEnd, ' +
                     ':NomCtrlFreightNC, ' +
                     ':NomCtrlSalesComm, ' +
                     ':NomCtrlPurchComm, ' +
                     ':NomCtrlRetSurcharge, ' +
                     ':NomCtrlSpare8, ' +
                     ':NomCtrlSpare9, ' +
                     ':NomCtrlSpare10, ' +
                     ':NomCtrlSpare11, ' +
                     ':NomCtrlSpare12, ' +
                     ':NomCtrlSpare13, ' +
                     ':NomCtrlSpare14, ' +
                     ':DetailAddr1, ' +
                     ':DetailAddr2, ' +
                     ':DetailAddr3, ' +
                     ':DetailAddr4, ' +
                     ':DetailAddr5, ' +
                     ':DirectCust, ' +
                     ':DirectSupp, ' +
                     ':TermsofTrade1, ' +
                     ':TermsofTrade2, ' +
                     ':NomPayFrom, ' +
                     ':NomPayToo, ' +
                     ':SettleDisc, ' +
                     ':SettleDays, ' +
                     ':NeedBMUp, ' +
                     ':IgnoreBDPW, ' +
                     ':InpPack, ' +
                     ':Spare32, ' +
                     ':VATCode, ' +
                     ':PayTerms, ' +
                     ':OTrigDate, ' +
                     ':StaAgeInt, ' +
                     ':QuoOwnDate, ' +
                     ':FreeExAll, ' +
                     ':DirOwnCount, ' +
                     ':StaShowOS, ' +
                     ':LiveCredS, ' +
                     ':BatchPPY, ' +
                     ':WarnJC, ' +
                     ':TxLateCR, ' +
                     ':ConsvMem, ' +
                     ':DefBankNom, ' +
                     ':UseDefBank, ' +
                     ':HideExLogo, ' +
                     ':AMMThread, ' +
                     ':AMMPreview1, ' +
                     ':AMMPreview2, ' +
                     ':EntULogCount, ' +
                     ':DefSRCBankNom, ' +
                     ':SDNOwnDate, ' +
                     ':EXISN, ' +
                     ':ExDemoVer, ' +
                     ':DupliVSec, ' +
                     ':LastDaily, ' +
                     ':OldUserSort, ' +
                     ':OldUserAcc, ' +
                     ':UserRef, ' +
                     ':SpareBits, ' +
                     ':GracePeriod, ' +
                     ':MonWk1, ' +
                     ':AuditDate, ' +
                     ':TrigDate, ' +
                     ':ExUsrSec, ' +
                     ':UsrLogCount, ' +
                     ':BinMask, ' +
                     ':Spare5a, ' +
                     ':Spare6a, ' +
                     ':UserBank, ' +
                     ':ExSec, ' +
                     ':LastExpFolio, ' +
                     ':DetailTel, ' +
                     ':DetailFax, ' +
                     ':UserVATReg, ' +
                     ':EnableTTDDiscounts, ' +
                     ':EnableVBDDiscounts, ' +
                     ':EnableOverrideLocations, ' +
                     ':IncludeVATInCommittedBalance, ' +
                     ':ssBankSortCode, ' +
                     ':ssBankAccountCode, ' +
                     // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
                     ':ssConsumersEnabled, ' +
                     // MH 24/10/2014: Added support for new Order Payments fields
                     ':ssEnableOrderPayments' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    OptParam := FindParam('Opt');
    OMonWk1Param := FindParam('OMonWk1');
    PrinYrParam := FindParam('PrinYr');
    FiltSNoBinLocParam := FindParam('FiltSNoBinLoc');
    KeepBinHistParam := FindParam('KeepBinHist');
    UseBKThemeParam := FindParam('UseBKTheme');
    UserNameParam := FindParam('UserName');
    AuditYrParam := FindParam('AuditYr');
    AuditPrParam := FindParam('AuditPr');
    Spare6Param := FindParam('Spare6');
    ManROCPParam := FindParam('ManROCP');
    VATCurrParam := FindParam('VATCurr');
    NoCosDecParam := FindParam('NoCosDec');
    CurrBaseParam := FindParam('CurrBase');
    MuteBeepParam := FindParam('MuteBeep');
    ShowStkGPParam := FindParam('ShowStkGP');
    AutoValStkParam := FindParam('AutoValStk');
    DelPickOnlyParam := FindParam('DelPickOnly');
    UseMLocParam := FindParam('UseMLoc');
    EditSinSerParam := FindParam('EditSinSer');
    WarnYRefParam := FindParam('WarnYRef');
    UseLocDelParam := FindParam('UseLocDel');
    PostCCNomParam := FindParam('PostCCNom');
    AlTolValParam := FindParam('AlTolVal');
    AlTolModeParam := FindParam('AlTolMode');
    DebtLModeParam := FindParam('DebtLMode');
    AutoGenVarParam := FindParam('AutoGenVar');
    AutoGenDiscParam := FindParam('AutoGenDisc');
    UseModuleSecParam := FindParam('UseModuleSec');
    ProtectPostParam := FindParam('ProtectPost');
    UsePick4AllParam := FindParam('UsePick4All');
    BigStkTreeParam := FindParam('BigStkTree');
    BigJobTreeParam := FindParam('BigJobTree');
    ShowQtySTreeParam := FindParam('ShowQtySTree');
    ProtectYRefParam := FindParam('ProtectYRef');
    PurchUIDateParam := FindParam('PurchUIDate');
    UseUpliftNCParam := FindParam('UseUpliftNC');
    UseWIss4AllParam := FindParam('UseWIss4All');
    UseSTDWOPParam := FindParam('UseSTDWOP');
    UseSalesAnalParam := FindParam('UseSalesAnal');
    PostCCDComboParam := FindParam('PostCCDCombo');
    UseClassToolBParam := FindParam('UseClassToolB');
    WOPStkCopModeParam := FindParam('WOPStkCopMode');
    USRCntryCodeParam := FindParam('USRCntryCode');
    NoNetDecParam := FindParam('NoNetDec');
    DebTrigParam := FindParam('DebTrig');
    BKThemeNoParam := FindParam('BKThemeNo');
    UseGLClassParam := FindParam('UseGLClass');
    Spare4Param := FindParam('Spare4');
    NoInvLinesParam := FindParam('NoInvLines');
    WksODueParam := FindParam('WksODue');
    CPrParam := FindParam('CPr');
    CYrParam := FindParam('CYr');
    OAuditDateParam := FindParam('OAuditDate');
    TradeTermParam := FindParam('TradeTerm');
    StaSepCrParam := FindParam('StaSepCr');
    StaAgeMthdParam := FindParam('StaAgeMthd');
    StaUIDateParam := FindParam('StaUIDate');
    SepRunPostParam := FindParam('SepRunPost');
    QUAllocFlgParam := FindParam('QUAllocFlg');
    DeadBOMParam := FindParam('DeadBOM');
    AuthModeParam := FindParam('AuthMode');
    IntraStatParam := FindParam('IntraStat');
    AnalStkDescParam := FindParam('AnalStkDesc');
    AutoStkValParam := FindParam('AutoStkVal');
    AutoBillUpParam := FindParam('AutoBillUp');
    AutoCQNoParam := FindParam('AutoCQNo');
    IncNotDueParam := FindParam('IncNotDue');
    UseBatchTotParam := FindParam('UseBatchTot');
    UseStockParam := FindParam('UseStock');
    AutoNotesParam := FindParam('AutoNotes');
    HideMenuOptParam := FindParam('HideMenuOpt');
    UseCCDepParam := FindParam('UseCCDep');
    NoHoldDiscParam := FindParam('NoHoldDisc');
    AutoPrCalcParam := FindParam('AutoPrCalc');
    StopBadDrParam := FindParam('StopBadDr');
    UsePayInParam := FindParam('UsePayIn');
    UsePasswordsParam := FindParam('UsePasswords');
    PrintRecieptParam := FindParam('PrintReciept');
    ExternCustParam := FindParam('ExternCust');
    NoQtyDecParam := FindParam('NoQtyDec');
    ExternSINParam := FindParam('ExternSIN');
    PrevPrOffParam := FindParam('PrevPrOff');
    DefPcDiscParam := FindParam('DefPcDisc');
    TradCodeNumParam := FindParam('TradCodeNum');
    UpBalOnPostParam := FindParam('UpBalOnPost');
    ShowInvDiscParam := FindParam('ShowInvDisc');
    SepDiscountsParam := FindParam('SepDiscounts');
    UseCreditChkParam := FindParam('UseCreditChk');
    UseCRLimitChkParam := FindParam('UseCRLimitChk');
    AutoClearPayParam := FindParam('AutoClearPay');
    TotalConvParam := FindParam('TotalConv');
    DispPrAsMonthsParam := FindParam('DispPrAsMonths');
    NomCtrlInVATParam := FindParam('NomCtrlInVAT');
    NomCtrlOutVATParam := FindParam('NomCtrlOutVAT');
    NomCtrlDebtorsParam := FindParam('NomCtrlDebtors');
    NomCtrlCreditorsParam := FindParam('NomCtrlCreditors');
    NomCtrlDiscountGivenParam := FindParam('NomCtrlDiscountGiven');
    NomCtrlDiscountTakenParam := FindParam('NomCtrlDiscountTaken');
    NomCtrlLDiscGivenParam := FindParam('NomCtrlLDiscGiven');
    NomCtrlLDiscTakenParam := FindParam('NomCtrlLDiscTaken');
    NomCtrlProfitBFParam := FindParam('NomCtrlProfitBF');
    NomCtrlCurrVarParam := FindParam('NomCtrlCurrVar');
    NomCtrlUnRCurrVarParam := FindParam('NomCtrlUnRCurrVar');
    NomCtrlPLStartParam := FindParam('NomCtrlPLStart');
    NomCtrlPLEndParam := FindParam('NomCtrlPLEnd');
    NomCtrlFreightNCParam := FindParam('NomCtrlFreightNC');
    NomCtrlSalesCommParam := FindParam('NomCtrlSalesComm');
    NomCtrlPurchCommParam := FindParam('NomCtrlPurchComm');
    NomCtrlRetSurchargeParam := FindParam('NomCtrlRetSurcharge');
    NomCtrlSpare8Param := FindParam('NomCtrlSpare8');
    NomCtrlSpare9Param := FindParam('NomCtrlSpare9');
    NomCtrlSpare10Param := FindParam('NomCtrlSpare10');
    NomCtrlSpare11Param := FindParam('NomCtrlSpare11');
    NomCtrlSpare12Param := FindParam('NomCtrlSpare12');
    NomCtrlSpare13Param := FindParam('NomCtrlSpare13');
    NomCtrlSpare14Param := FindParam('NomCtrlSpare14');
    DetailAddr1Param := FindParam('DetailAddr1');
    DetailAddr2Param := FindParam('DetailAddr2');
    DetailAddr3Param := FindParam('DetailAddr3');
    DetailAddr4Param := FindParam('DetailAddr4');
    DetailAddr5Param := FindParam('DetailAddr5');
    DirectCustParam := FindParam('DirectCust');
    DirectSuppParam := FindParam('DirectSupp');
    TermsofTrade1Param := FindParam('TermsofTrade1');
    TermsofTrade2Param := FindParam('TermsofTrade2');
    NomPayFromParam := FindParam('NomPayFrom');
    NomPayTooParam := FindParam('NomPayToo');
    SettleDiscParam := FindParam('SettleDisc');
    SettleDaysParam := FindParam('SettleDays');
    NeedBMUpParam := FindParam('NeedBMUp');
    IgnoreBDPWParam := FindParam('IgnoreBDPW');
    InpPackParam := FindParam('InpPack');
    Spare32Param := FindParam('Spare32');
    VATCodeParam := FindParam('VATCode');
    PayTermsParam := FindParam('PayTerms');
    OTrigDateParam := FindParam('OTrigDate');
    StaAgeIntParam := FindParam('StaAgeInt');
    QuoOwnDateParam := FindParam('QuoOwnDate');
    FreeExAllParam := FindParam('FreeExAll');
    DirOwnCountParam := FindParam('DirOwnCount');
    StaShowOSParam := FindParam('StaShowOS');
    LiveCredSParam := FindParam('LiveCredS');
    BatchPPYParam := FindParam('BatchPPY');
    WarnJCParam := FindParam('WarnJC');
    TxLateCRParam := FindParam('TxLateCR');
    ConsvMemParam := FindParam('ConsvMem');
    DefBankNomParam := FindParam('DefBankNom');
    UseDefBankParam := FindParam('UseDefBank');
    HideExLogoParam := FindParam('HideExLogo');
    AMMThreadParam := FindParam('AMMThread');
    AMMPreview1Param := FindParam('AMMPreview1');
    AMMPreview2Param := FindParam('AMMPreview2');
    EntULogCountParam := FindParam('EntULogCount');
    DefSRCBankNomParam := FindParam('DefSRCBankNom');
    SDNOwnDateParam := FindParam('SDNOwnDate');
    EXISNParam := FindParam('EXISN');
    ExDemoVerParam := FindParam('ExDemoVer');
    DupliVSecParam := FindParam('DupliVSec');
    LastDailyParam := FindParam('LastDaily');
    OldUserSortParam := FindParam('OldUserSort');
    OldUserAccParam := FindParam('OldUserAcc');
    UserRefParam := FindParam('UserRef');
    SpareBitsParam := FindParam('SpareBits');
    GracePeriodParam := FindParam('GracePeriod');
    MonWk1Param := FindParam('MonWk1');
    AuditDateParam := FindParam('AuditDate');
    TrigDateParam := FindParam('TrigDate');
    ExUsrSecParam := FindParam('ExUsrSec');
    UsrLogCountParam := FindParam('UsrLogCount');
    BinMaskParam := FindParam('BinMask');
    Spare5aParam := FindParam('Spare5a');
    Spare6aParam := FindParam('Spare6a');
    UserBankParam := FindParam('UserBank');
    ExSecParam := FindParam('ExSec');
    LastExpFolioParam := FindParam('LastExpFolio');
    DetailTelParam := FindParam('DetailTel');
    DetailFaxParam := FindParam('DetailFax');
    UserVATRegParam := FindParam('UserVATReg');
    EnableTTDDiscountsParam := FindParam('EnableTTDDiscounts');
    EnableVBDDiscountsParam := FindParam('EnableVBDDiscounts');
    EnableOverrideLocationsParam := FindParam('EnableOverrideLocations');
    IncludeVATInCommittedBalanceParam := FindParam('IncludeVATInCommittedBalance');
    ssBankSortCodeParam := FindParam('ssBankSortCode');
    ssBankAccountCodeParam := FindParam('ssBankAccountCode');
    // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
    ssConsumersEnabledParam := FindParam('ssConsumersEnabled');
    // MH 24/10/2014: Added support for new Order Payments fields
    ssEnableOrderPaymentsParam := FindParam('ssEnableOrderPayments');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));     // SQL=varbinary, Delphi=String[3]
  OptParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.Opt);                         // SQL=varchar, Delphi=Char
  OMonWk1Param.Value := CreateVariantArray (@DataRec^.OMonWk1, SizeOf(DataRec^.OMonWk1));  // SQL=varbinary, Delphi=Date
  PrinYrParam.Value := DataRec^.PrinYr;                                                 // SQL=int, Delphi=Byte
  FiltSNoBinLocParam.Value := DataRec^.FiltSNoBinLoc;                                   // SQL=bit, Delphi=Boolean
  KeepBinHistParam.Value := DataRec^.KeepBinHist;                                       // SQL=bit, Delphi=Boolean
  UseBKThemeParam.Value := DataRec^.UseBKTheme;                                         // SQL=bit, Delphi=Boolean
  UserNameParam.Value := DataRec^.UserName;                                             // SQL=varchar, Delphi=String[45]
  AuditYrParam.Value := DataRec^.AuditYr;                                               // SQL=int, Delphi=Byte
  AuditPrParam.Value := DataRec^.AuditPr;                                               // SQL=int, Delphi=Byte
  Spare6Param.Value := DataRec^.Spare6;                                                 // SQL=int, Delphi=Byte
  ManROCPParam.Value := DataRec^.ManROCP;                                               // SQL=bit, Delphi=Boolean
  VATCurrParam.Value := DataRec^.VATCurr;                                               // SQL=int, Delphi=Byte
  NoCosDecParam.Value := DataRec^.NoCosDec;                                             // SQL=int, Delphi=Byte
  CurrBaseParam.Value := DataRec^.CurrBase;                                             // SQL=int, Delphi=Byte
  MuteBeepParam.Value := DataRec^.MuteBeep;                                             // SQL=bit, Delphi=Boolean
  ShowStkGPParam.Value := DataRec^.ShowStkGP;                                           // SQL=bit, Delphi=Boolean
  AutoValStkParam.Value := DataRec^.AutoValStk;                                         // SQL=bit, Delphi=Boolean
  DelPickOnlyParam.Value := DataRec^.DelPickOnly;                                       // SQL=bit, Delphi=Boolean
  UseMLocParam.Value := DataRec^.UseMLoc;                                               // SQL=bit, Delphi=Boolean
  EditSinSerParam.Value := DataRec^.EditSinSer;                                         // SQL=bit, Delphi=Boolean
  WarnYRefParam.Value := DataRec^.WarnYRef;                                             // SQL=bit, Delphi=Boolean
  UseLocDelParam.Value := DataRec^.UseLocDel;                                           // SQL=bit, Delphi=Boolean
  PostCCNomParam.Value := DataRec^.PostCCNom;                                           // SQL=bit, Delphi=Boolean
  AlTolValParam.Value := DataRec^.AlTolVal;                                             // SQL=float, Delphi=Double
  AlTolModeParam.Value := DataRec^.AlTolMode;                                           // SQL=int, Delphi=Byte
  DebtLModeParam.Value := DataRec^.DebtLMode;                                           // SQL=int, Delphi=Byte
  AutoGenVarParam.Value := DataRec^.AutoGenVar;                                         // SQL=bit, Delphi=Boolean
  AutoGenDiscParam.Value := DataRec^.AutoGenDisc;                                       // SQL=bit, Delphi=Boolean
  UseModuleSecParam.Value := DataRec^.UseModuleSec;                                     // SQL=bit, Delphi=Boolean
  ProtectPostParam.Value := DataRec^.ProtectPost;                                       // SQL=bit, Delphi=Boolean
  UsePick4AllParam.Value := DataRec^.UsePick4All;                                       // SQL=bit, Delphi=Boolean
  BigStkTreeParam.Value := DataRec^.BigStkTree;                                         // SQL=bit, Delphi=Boolean
  BigJobTreeParam.Value := DataRec^.BigJobTree;                                         // SQL=bit, Delphi=Boolean
  ShowQtySTreeParam.Value := DataRec^.ShowQtySTree;                                     // SQL=bit, Delphi=Boolean
  ProtectYRefParam.Value := DataRec^.ProtectYRef;                                       // SQL=bit, Delphi=Boolean
  PurchUIDateParam.Value := DataRec^.PurchUIDate;                                       // SQL=bit, Delphi=Boolean
  UseUpliftNCParam.Value := DataRec^.UseUpliftNC;                                       // SQL=bit, Delphi=Boolean
  UseWIss4AllParam.Value := DataRec^.UseWIss4All;                                       // SQL=bit, Delphi=Boolean
  UseSTDWOPParam.Value := DataRec^.UseSTDWOP;                                           // SQL=bit, Delphi=Boolean
  UseSalesAnalParam.Value := DataRec^.UseSalesAnal;                                     // SQL=bit, Delphi=Boolean
  PostCCDComboParam.Value := DataRec^.PostCCDCombo;                                     // SQL=bit, Delphi=Boolean
  UseClassToolBParam.Value := DataRec^.UseClassToolB;                                   // SQL=bit, Delphi=Boolean
  WOPStkCopModeParam.Value := DataRec^.WOPStkCopMode;                                   // SQL=int, Delphi=Byte
  USRCntryCodeParam.Value := DataRec^.USRCntryCode;                                     // SQL=varchar, Delphi=String[3]
  NoNetDecParam.Value := DataRec^.NoNetDec;                                             // SQL=int, Delphi=Byte
  DebTrigParam.Value := CreateVariantArray (@DataRec^.DebTrig, SizeOF(DataRec^.DebTrig));  // SQL=varbinary, Delphi=Array[1..3] of Byte
  BKThemeNoParam.Value := DataRec^.BKThemeNo;                                           // SQL=int, Delphi=Byte
  UseGLClassParam.Value := DataRec^.UseGLClass;                                         // SQL=bit, Delphi=Boolean
  Spare4Param.Value := CreateVariantArray (@DataRec^.Spare4, SizeOf(DataRec^.Spare4));     // SQL=varbinary, Delphi=Array[1..1] of Byte
  NoInvLinesParam.Value := DataRec^.NoInvLines;                                         // SQL=int, Delphi=Byte
  WksODueParam.Value := DataRec^.WksODue;                                               // SQL=int, Delphi=Byte
  CPrParam.Value := DataRec^.CPr;                                                       // SQL=int, Delphi=Byte
  CYrParam.Value := DataRec^.CYr;                                                       // SQL=int, Delphi=Byte
  OAuditDateParam.Value := DataRec^.OAuditDate;                                         // SQL=varchar, Delphi=Date
  TradeTermParam.Value := DataRec^.TradeTerm;                                           // SQL=bit, Delphi=Boolean
  StaSepCrParam.Value := DataRec^.StaSepCr;                                             // SQL=bit, Delphi=Boolean
  StaAgeMthdParam.Value := DataRec^.StaAgeMthd;                                         // SQL=int, Delphi=Byte
  StaUIDateParam.Value := DataRec^.StaUIDate;                                           // SQL=bit, Delphi=Boolean
  SepRunPostParam.Value := DataRec^.SepRunPost;                                         // SQL=bit, Delphi=Boolean
  QUAllocFlgParam.Value := DataRec^.QUAllocFlg;                                         // SQL=bit, Delphi=Boolean
  DeadBOMParam.Value := DataRec^.DeadBOM;                                               // SQL=bit, Delphi=Boolean
  AuthModeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.AuthMode);            // SQL=varchar, Delphi=Char
  IntraStatParam.Value := DataRec^.IntraStat;                                           // SQL=bit, Delphi=Boolean
  AnalStkDescParam.Value := DataRec^.AnalStkDesc;                                       // SQL=bit, Delphi=Boolean
  AutoStkValParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.AutoStkVal);        // SQL=varchar, Delphi=Char
  AutoBillUpParam.Value := DataRec^.AutoBillUp;                                         // SQL=bit, Delphi=Boolean
  AutoCQNoParam.Value := DataRec^.AutoCQNo;                                             // SQL=bit, Delphi=Boolean
  IncNotDueParam.Value := DataRec^.IncNotDue;                                           // SQL=bit, Delphi=Boolean
  UseBatchTotParam.Value := DataRec^.UseBatchTot;                                       // SQL=bit, Delphi=Boolean
  UseStockParam.Value := DataRec^.UseStock;                                             // SQL=bit, Delphi=Boolean
  AutoNotesParam.Value := DataRec^.AutoNotes;                                           // SQL=bit, Delphi=Boolean
  HideMenuOptParam.Value := DataRec^.HideMenuOpt;                                       // SQL=bit, Delphi=Boolean
  UseCCDepParam.Value := DataRec^.UseCCDep;                                             // SQL=bit, Delphi=Boolean
  NoHoldDiscParam.Value := DataRec^.NoHoldDisc;                                         // SQL=bit, Delphi=Boolean
  AutoPrCalcParam.Value := DataRec^.AutoPrCalc;                                         // SQL=bit, Delphi=Boolean
  StopBadDrParam.Value := DataRec^.StopBadDr;                                           // SQL=bit, Delphi=Boolean
  UsePayInParam.Value := DataRec^.UsePayIn;                                             // SQL=bit, Delphi=Boolean
  UsePasswordsParam.Value := DataRec^.UsePasswords;                                     // SQL=bit, Delphi=Boolean
  PrintRecieptParam.Value := DataRec^.PrintReciept;                                     // SQL=bit, Delphi=Boolean
  ExternCustParam.Value := DataRec^.ExternCust;                                         // SQL=bit, Delphi=Boolean
  NoQtyDecParam.Value := DataRec^.NoQtyDec;                                             // SQL=int, Delphi=Byte
  ExternSINParam.Value := DataRec^.ExternSIN;                                           // SQL=bit, Delphi=Boolean
  PrevPrOffParam.Value := DataRec^.PrevPrOff;                                           // SQL=bit, Delphi=Boolean
  DefPcDiscParam.Value := DataRec^.DefPcDisc;                                           // SQL=bit, Delphi=Boolean
  TradCodeNumParam.Value := DataRec^.TradCodeNum;                                       // SQL=bit, Delphi=Boolean
  UpBalOnPostParam.Value := DataRec^.UpBalOnPost;                                       // SQL=bit, Delphi=Boolean
  ShowInvDiscParam.Value := DataRec^.ShowInvDisc;                                       // SQL=bit, Delphi=Boolean
  SepDiscountsParam.Value := DataRec^.SepDiscounts;                                     // SQL=bit, Delphi=Boolean
  UseCreditChkParam.Value := DataRec^.UseCreditChk;                                     // SQL=bit, Delphi=Boolean
  UseCRLimitChkParam.Value := DataRec^.UseCRLimitChk;                                   // SQL=bit, Delphi=Boolean
  AutoClearPayParam.Value := DataRec^.AutoClearPay;                                     // SQL=bit, Delphi=Boolean
  TotalConvParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.TotalConv);          // SQL=varchar, Delphi=Char
  DispPrAsMonthsParam.Value := DataRec^.DispPrAsMonths;                                 // SQL=bit, Delphi=Boolean
  NomCtrlInVATParam.Value := DataRec^.NomCtrlCodes[InVAT];                              // SQL=int, Delphi=LongInt
  NomCtrlOutVATParam.Value := DataRec^.NomCtrlCodes[OutVAT];                            // SQL=int, Delphi=LongInt
  NomCtrlDebtorsParam.Value := DataRec^.NomCtrlCodes[Debtors];                          // SQL=int, Delphi=LongInt
  NomCtrlCreditorsParam.Value := DataRec^.NomCtrlCodes[Creditors];                      // SQL=int, Delphi=LongInt
  NomCtrlDiscountGivenParam.Value := DataRec^.NomCtrlCodes[DiscountGiven];              // SQL=int, Delphi=LongInt
  NomCtrlDiscountTakenParam.Value := DataRec^.NomCtrlCodes[DiscountTaken];              // SQL=int, Delphi=LongInt
  NomCtrlLDiscGivenParam.Value := DataRec^.NomCtrlCodes[LDiscGiven];                    // SQL=int, Delphi=LongInt
  NomCtrlLDiscTakenParam.Value := DataRec^.NomCtrlCodes[LDiscTaken];                    // SQL=int, Delphi=LongInt
  NomCtrlProfitBFParam.Value := DataRec^.NomCtrlCodes[ProfitBF];                        // SQL=int, Delphi=LongInt
  NomCtrlCurrVarParam.Value := DataRec^.NomCtrlCodes[CurrVar];                          // SQL=int, Delphi=LongInt
  NomCtrlUnRCurrVarParam.Value := DataRec^.NomCtrlCodes[UnRCurrVar];                    // SQL=int, Delphi=LongInt
  NomCtrlPLStartParam.Value := DataRec^.NomCtrlCodes[PLStart];                          // SQL=int, Delphi=LongInt
  NomCtrlPLEndParam.Value := DataRec^.NomCtrlCodes[PLEnd];                              // SQL=int, Delphi=LongInt
  NomCtrlFreightNCParam.Value := DataRec^.NomCtrlCodes[FreightNC];                      // SQL=int, Delphi=LongInt
  NomCtrlSalesCommParam.Value := DataRec^.NomCtrlCodes[SalesComm];                      // SQL=int, Delphi=LongInt
  NomCtrlPurchCommParam.Value := DataRec^.NomCtrlCodes[PurchComm];                      // SQL=int, Delphi=LongInt
  NomCtrlRetSurchargeParam.Value := DataRec^.NomCtrlCodes[RetSurcharge];                // SQL=int, Delphi=LongInt
  NomCtrlSpare8Param.Value := DataRec^.NomCtrlCodes[NSpare8];                           // SQL=int, Delphi=LongInt
  NomCtrlSpare9Param.Value := DataRec^.NomCtrlCodes[NSpare9];                           // SQL=int, Delphi=LongInt
  NomCtrlSpare10Param.Value := DataRec^.NomCtrlCodes[NSpare10];                         // SQL=int, Delphi=LongInt
  NomCtrlSpare11Param.Value := DataRec^.NomCtrlCodes[NSpare11];                         // SQL=int, Delphi=LongInt
  NomCtrlSpare12Param.Value := DataRec^.NomCtrlCodes[NSpare12];                         // SQL=int, Delphi=LongInt
  NomCtrlSpare13Param.Value := DataRec^.NomCtrlCodes[NSpare13];                         // SQL=int, Delphi=LongInt
  NomCtrlSpare14Param.Value := DataRec^.NomCtrlCodes[NSpare14];                         // SQL=int, Delphi=LongInt
  DetailAddr1Param.Value := DataRec^.DetailAddr[1];                                     // SQL=varchar, Delphi=String[30]
  DetailAddr2Param.Value := DataRec^.DetailAddr[2];                                     // SQL=varchar, Delphi=String[30]
  DetailAddr3Param.Value := DataRec^.DetailAddr[3];                                     // SQL=varchar, Delphi=String[30]
  DetailAddr4Param.Value := DataRec^.DetailAddr[4];                                     // SQL=varchar, Delphi=String[30]
  DetailAddr5Param.Value := DataRec^.DetailAddr[5];                                     // SQL=varchar, Delphi=String[30]
  DirectCustParam.Value := DataRec^.DirectCust;                                         // SQL=varchar, Delphi=String[10]
  DirectSuppParam.Value := DataRec^.DirectSupp;                                         // SQL=varchar, Delphi=String[10]
  TermsofTrade1Param.Value := DataRec^.TermsofTrade[1];                                 // SQL=varchar, Delphi=String[80]
  TermsofTrade2Param.Value := DataRec^.TermsofTrade[2];                                 // SQL=varchar, Delphi=String[80]
  NomPayFromParam.Value := DataRec^.NomPayFrom;                                         // SQL=int, Delphi=LongInt
  NomPayTooParam.Value := DataRec^.NomPayToo;                                           // SQL=int, Delphi=LongInt
  // MH 19/06/2015 v7.0.14: Removed obsolete fields
  SettleDiscParam.Value := 0.0; //DataRec^.SettleDisc;                                  // SQL=float, Delphi=Real
  SettleDaysParam.Value := 0; //DataRec^.SettleDays;                                    // SQL=int, Delphi=SmallInt
  NeedBMUpParam.Value := DataRec^.NeedBMUp;                                             // SQL=bit, Delphi=Boolean
  IgnoreBDPWParam.Value := DataRec^.IgnoreBDPW;                                         // SQL=bit, Delphi=Boolean
  InpPackParam.Value := DataRec^.InpPack;                                               // SQL=bit, Delphi=Boolean
  Spare32Param.Value := DataRec^.Spare32;                                               // SQL=bit, Delphi=Boolean
  VATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.VATCode);              // SQL=varchar, Delphi=Char
  PayTermsParam.Value := DataRec^.PayTerms;                                             // SQL=int, Delphi=SmallInt
  OTrigDateParam.Value := DataRec^.OTrigDate;                                           // SQL=varchar, Delphi=Date
  StaAgeIntParam.Value := DataRec^.StaAgeInt;                                           // SQL=int, Delphi=SmallInt
  QuoOwnDateParam.Value := DataRec^.QuoOwnDate;                                         // SQL=bit, Delphi=Boolean
  FreeExAllParam.Value := DataRec^.FreeExAll;                                           // SQL=bit, Delphi=Boolean
  DirOwnCountParam.Value := DataRec^.DirOwnCount;                                       // SQL=bit, Delphi=Boolean
  StaShowOSParam.Value := DataRec^.StaShowOS;                                           // SQL=bit, Delphi=Boolean
  LiveCredSParam.Value := DataRec^.LiveCredS;                                           // SQL=bit, Delphi=Boolean
  BatchPPYParam.Value := DataRec^.BatchPPY;                                             // SQL=bit, Delphi=Boolean
  WarnJCParam.Value := DataRec^.WarnJC;                                                 // SQL=bit, Delphi=Boolean
  TxLateCRParam.Value := DataRec^.TxLateCR;                                             // SQL=bit, Delphi=Boolean
  ConsvMemParam.Value := DataRec^.ConsvMem;                                             // SQL=bit, Delphi=Boolean
  DefBankNomParam.Value := DataRec^.DefBankNom;                                         // SQL=int, Delphi=LongInt
  UseDefBankParam.Value := DataRec^.UseDefBank;                                         // SQL=bit, Delphi=Boolean
  HideExLogoParam.Value := DataRec^.HideExLogo;                                         // SQL=bit, Delphi=Boolean
  AMMThreadParam.Value := DataRec^.AMMThread;                                           // SQL=bit, Delphi=Boolean
  AMMPreview1Param.Value := DataRec^.AMMPreview[False];                                  // SQL=bit, Delphi=Boolean
  AMMPreview2Param.Value := DataRec^.AMMPreview[True];                                   // SQL=bit, Delphi=Boolean
  EntULogCountParam.Value := DataRec^.EntULogCount;                                     // SQL=int, Delphi=LongInt
  DefSRCBankNomParam.Value := DataRec^.DefSRCBankNom;                                   // SQL=int, Delphi=LongInt
  SDNOwnDateParam.Value := DataRec^.SDNOwnDate;                                         // SQL=bit, Delphi=Boolean
  EXISNParam.Value := CreateVariantArray (@DataRec^.EXISN, SizeOf(DataRec^.EXISN));               // SQL=varbinary, Delphi=ISNArrayType
  ExDemoVerParam.Value := DataRec^.ExDemoVer;                                           // SQL=bit, Delphi=Boolean
  DupliVSecParam.Value := DataRec^.DupliVSec;                                           // SQL=bit, Delphi=Boolean
  LastDailyParam.Value := DataRec^.LastDaily;                                           // SQL=int, Delphi=LongInt
  OldUserSortParam.Value := DataRec^.OldUserSort;                                       // SQL=varchar, Delphi=String[15]
  OldUserAccParam.Value := DataRec^.OldUserAcc;                                         // SQL=varchar, Delphi=String[20]
  UserRefParam.Value := DataRec^.UserRef;                                               // SQL=varchar, Delphi=String[28]
  SpareBitsParam.Value := CreateVariantArray (@DataRec^.SpareBits, SizeOf(DataRec^.SpareBits));   // SQL=varbinary, Delphi=array[1..31] of Byte
  GracePeriodParam.Value := DataRec^.GracePeriod;                                       // SQL=int, Delphi=Byte
  MonWk1Param.Value := DataRec^.MonWk1;                                                 // SQL=varchar, Delphi=LongDate
  AuditDateParam.Value := DataRec^.AuditDate;                                           // SQL=varchar, Delphi=LongDate
  TrigDateParam.Value := DataRec^.TrigDate;                                             // SQL=varchar, Delphi=LongDate
  // Binary block covering ExUsrSec : String[10] / ExUsrRel : String[10] / UsrRelDate : Real
  ExUsrSecParam.Value := CreateVariantArray (@DataRec^.ExUsrSec, CalculateBinaryBlockSize (@DataRec^.ExUsrSec, @DataRec^.UsrLogCount));
  UsrLogCountParam.Value := DataRec^.UsrLogCount;                                       // SQL=int, Delphi=LongInt
  BinMaskParam.Value := DataRec^.BinMask;                                               // SQL=varchar, Delphi=String[10]
  Spare5aParam.Value := DataRec^.Spare5a;                                               // SQL=varchar, Delphi=String[4]
  Spare6aParam.Value := DataRec^.Spare6a;                                               // SQL=varchar, Delphi=String[18]
  UserBankParam.Value := DataRec^.UserBank;                                             // SQL=varchar, Delphi=String[25]
  // Binary block covering ExSecurity : String[10] / ExRelease : String[10] / RelDate : Real
  ExSecParam.Value := CreateVariantArray (@DataRec^.ExSecurity, CalculateBinaryBlockSize (@DataRec^.ExSecurity, @DataRec^.LastExpFolio));
  LastExpFolioParam.Value := DataRec^.LastExpFolio;                                     // SQL=int, Delphi=LongInt
  DetailTelParam.Value := DataRec^.DetailTel;                                           // SQL=varchar, Delphi=String[15]
  DetailFaxParam.Value := DataRec^.DetailFax;                                           // SQL=varchar, Delphi=String[15]
  UserVATRegParam.Value := DataRec^.UserVATReg;                                         // SQL=varchar, Delphi=String[30]
  EnableTTDDiscountsParam.Value := DataRec^.EnableTTDDiscounts;                         // SQL=bit, Delphi=Boolean
  EnableVBDDiscountsParam.Value := DataRec^.EnableVBDDiscounts;                         // SQL=bit, Delphi=Boolean
  EnableOverrideLocationsParam.Value := DataRec^.EnableOverrideLocations;               // SQL=bit, Delphi=Boolean
  IncludeVATInCommittedBalanceParam.Value := DataRec^.IncludeVATInCommittedBalance;     // SQL=bit, Delphi=Boolean
  ssBankSortCodeParam.Value := CreateVariantArray(@DataRec^.ssBankSortCode, SizeOf(DataRec^.ssBankSortCode)); // SQL=varbinary, Delphi=String[22]
  ssBankAccountCodeParam.Value := CreateVariantArray(@DataRec^.ssBankAccountCode, SizeOf(DataRec^.ssBankAccountCode)); // SQL=varbinary, Delphi=String[54]
  // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
  ssConsumersEnabledParam.Value := DataRec^.ssConsumersEnabled;
  // MH 24/10/2014: Added support for new Order Payments fields
  ssEnableOrderPaymentsParam.Value := DataRec^.ssEnableOrderPayments;
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_VATVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_VATVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, VATStandardCodeParam, VATStandardDescParam, VATStandardRateParam,
  VATStandardSpareParam, VATStandardIncludeParam, VATStandardSpare2Param,
  VATExemptCodeParam, VATExemptDescParam, VATExemptRateParam, VATExemptSpareParam,
  VATExemptIncludeParam, VATExemptSpare2Param, VATZeroCodeParam, VATZeroDescParam,
  VATZeroRateParam, VATZeroSpareParam, VATZeroIncludeParam, VATZeroSpare2Param,
  VATRate1CodeParam, VATRate1DescParam, VATRate1RateParam, VATRate1SpareParam,
  VATRate1IncludeParam, VATRate1Spare2Param, VATRate2CodeParam, VATRate2DescParam,
  VATRate2RateParam, VATRate2SpareParam, VATRate2IncludeParam, VATRate2Spare2Param,
  VATRate3CodeParam, VATRate3DescParam, VATRate3RateParam, VATRate3SpareParam,
  VATRate3IncludeParam, VATRate3Spare2Param, VATRate4CodeParam, VATRate4DescParam,
  VATRate4RateParam, VATRate4SpareParam, VATRate4IncludeParam, VATRate4Spare2Param,
  VATRate5CodeParam, VATRate5DescParam, VATRate5RateParam, VATRate5SpareParam,
  VATRate5IncludeParam, VATRate5Spare2Param, VATRate6CodeParam, VATRate6DescParam,
  VATRate6RateParam, VATRate6SpareParam, VATRate6IncludeParam, VATRate6Spare2Param,
  VATRate7CodeParam, VATRate7DescParam, VATRate7RateParam, VATRate7SpareParam,
  VATRate7IncludeParam, VATRate7Spare2Param, VATRate8CodeParam, VATRate8DescParam,
  VATRate8RateParam, VATRate8SpareParam, VATRate8IncludeParam, VATRate8Spare2Param,
  VATRate9CodeParam, VATRate9DescParam, VATRate9RateParam, VATRate9SpareParam,
  VATRate9IncludeParam, VATRate9Spare2Param, VATRate10CodeParam, VATRate10DescParam,
  VATRate10RateParam, VATRate10SpareParam, VATRate10IncludeParam, VATRate10Spare2Param,
  VATRate11CodeParam, VATRate11DescParam, VATRate11RateParam, VATRate11SpareParam,
  VATRate11IncludeParam, VATRate11Spare2Param, VATRate12CodeParam, VATRate12DescParam,
  VATRate12RateParam, VATRate12SpareParam, VATRate12IncludeParam, VATRate12Spare2Param,
  VATRate13CodeParam, VATRate13DescParam, VATRate13RateParam, VATRate13SpareParam,
  VATRate13IncludeParam, VATRate13Spare2Param, VATRate14CodeParam, VATRate14DescParam,
  VATRate14RateParam, VATRate14SpareParam, VATRate14IncludeParam, VATRate14Spare2Param,
  VATRate15CodeParam, VATRate15DescParam, VATRate15RateParam, VATRate15SpareParam,
  VATRate15IncludeParam, VATRate15Spare2Param, VATRate16CodeParam, VATRate16DescParam,
  VATRate16RateParam, VATRate16SpareParam, VATRate16IncludeParam, VATRate16Spare2Param,
  VATRate17CodeParam, VATRate17DescParam, VATRate17RateParam, VATRate17SpareParam,
  VATRate17IncludeParam, VATRate17Spare2Param, VATRate18CodeParam, VATRate18DescParam,
  VATRate18RateParam, VATRate18SpareParam, VATRate18IncludeParam, VATRate18Spare2Param,
  VATIAdjCodeParam, VATIAdjDescParam, VATIAdjRateParam, VATIAdjSpareParam,
  VATIAdjIncludeParam, VATIAdjSpare2Param, VATOAdjCodeParam, VATOAdjDescParam,
  VATOAdjRateParam, VATOAdjSpareParam, VATOAdjIncludeParam, VATOAdjSpare2Param,
  VATSpare8CodeParam, VATSpare8DescParam, VATSpare8RateParam, VATSpare8SpareParam,
  VATSpare8IncludeParam, VATSpare8Spare2Param, HideUDF7Param, HideUDF8Param,
  HideUDF9Param, HideUDF10Param, HideUDF11Param, Spare2Param, VATIntervalParam,
  Spare3Param, VATSchemeParam, OLastECSalesDateParam, VATReturnDateParam,
  LastECSalesDateParam, CurrPeriodParam, UDFCaption1Param, UDFCaption2Param,
  UDFCaption3Param, UDFCaption4Param, UDFCaption5Param, UDFCaption6Param,
  UDFCaption7Param, UDFCaption8Param, UDFCaption9Param, UDFCaption10Param,
  UDFCaption11Param, UDFCaption12Param, UDFCaption13Param, UDFCaption14Param,
  UDFCaption15Param, UDFCaption16Param, UDFCaption17Param, UDFCaption18Param,
  UDFCaption19Param, UDFCaption20Param, UDFCaption21Param, UDFCaption22Param,
  HideLType0Param, HideLType1Param, HideLType2Param, HideLType3Param, HideLType4Param,
  HideLType5Param, HideLType6Param, ReportPrnNParam, FormsPrnNParam, EnableECServicesParam,
  ECSalesThresholdParam,
  // MH 13/05/2013 v7.0.4 ABSEXCH-13793: Added support for new VAT100 XML fields
  VAT100UserIDParam, VAT100UserPasswordParam, VAT100SenderTypeParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'VATStandardCode, ' +
                                              'VATStandardDesc, ' +
                                              'VATStandardRate, ' + 
                                              'VATStandardSpare, ' + 
                                              'VATStandardInclude, ' + 
                                              'VATStandardSpare2, ' + 
                                              'VATExemptCode, ' + 
                                              'VATExemptDesc, ' + 
                                              'VATExemptRate, ' +
                                              'VATExemptSpare, ' +
                                              'VATExemptInclude, ' + 
                                              'VATExemptSpare2, ' + 
                                              'VATZeroCode, ' + 
                                              'VATZeroDesc, ' + 
                                              'VATZeroRate, ' +
                                              'VATZeroSpare, ' +
                                              'VATZeroInclude, ' + 
                                              'VATZeroSpare2, ' + 
                                              'VATRate1Code, ' + 
                                              'VATRate1Desc, ' + 
                                              'VATRate1Rate, ' + 
                                              'VATRate1Spare, ' + 
                                              'VATRate1Include, ' + 
                                              'VATRate1Spare2, ' + 
                                              'VATRate2Code, ' + 
                                              'VATRate2Desc, ' +
                                              'VATRate2Rate, ' +
                                              'VATRate2Spare, ' + 
                                              'VATRate2Include, ' + 
                                              'VATRate2Spare2, ' + 
                                              'VATRate3Code, ' +
                                              'VATRate3Desc, ' + 
                                              'VATRate3Rate, ' + 
                                              'VATRate3Spare, ' +
                                              'VATRate3Include, ' +
                                              'VATRate3Spare2, ' + 
                                              'VATRate4Code, ' +
                                              'VATRate4Desc, ' + 
                                              'VATRate4Rate, ' +
                                              'VATRate4Spare, ' + 
                                              'VATRate4Include, ' +
                                              'VATRate4Spare2, ' + 
                                              'VATRate5Code, ' + 
                                              'VATRate5Desc, ' + 
                                              'VATRate5Rate, ' + 
                                              'VATRate5Spare, ' + 
                                              'VATRate5Include, ' + 
                                              'VATRate5Spare2, ' +
                                              'VATRate6Code, ' + 
                                              'VATRate6Desc, ' + 
                                              'VATRate6Rate, ' + 
                                              'VATRate6Spare, ' +
                                              'VATRate6Include, ' +
                                              'VATRate6Spare2, ' + 
                                              'VATRate7Code, ' + 
                                              'VATRate7Desc, ' + 
                                              'VATRate7Rate, ' + 
                                              'VATRate7Spare, ' + 
                                              'VATRate7Include, ' + 
                                              'VATRate7Spare2, ' + 
                                              'VATRate8Code, ' + 
                                              'VATRate8Desc, ' + 
                                              'VATRate8Rate, ' + 
                                              'VATRate8Spare, ' +
                                              'VATRate8Include, ' + 
                                              'VATRate8Spare2, ' + 
                                              'VATRate9Code, ' + 
                                              'VATRate9Desc, ' +
                                              'VATRate9Rate, ' +
                                              'VATRate9Spare, ' + 
                                              'VATRate9Include, ' + 
                                              'VATRate9Spare2, ' + 
                                              'VATRate10Code, ' +
                                              'VATRate10Desc, ' +
                                              'VATRate10Rate, ' + 
                                              'VATRate10Spare, ' + 
                                              'VATRate10Include, ' +
                                              'VATRate10Spare2, ' +
                                              'VATRate11Code, ' + 
                                              'VATRate11Desc, ' +
                                              'VATRate11Rate, ' + 
                                              'VATRate11Spare, ' + 
                                              'VATRate11Include, ' + 
                                              'VATRate11Spare2, ' + 
                                              'VATRate12Code, ' + 
                                              'VATRate12Desc, ' + 
                                              'VATRate12Rate, ' +
                                              'VATRate12Spare, ' + 
                                              'VATRate12Include, ' +
                                              'VATRate12Spare2, ' +
                                              'VATRate13Code, ' + 
                                              'VATRate13Desc, ' + 
                                              'VATRate13Rate, ' + 
                                              'VATRate13Spare, ' +
                                              'VATRate13Include, ' + 
                                              'VATRate13Spare2, ' + 
                                              'VATRate14Code, ' + 
                                              'VATRate14Desc, ' + 
                                              'VATRate14Rate, ' + 
                                              'VATRate14Spare, ' + 
                                              'VATRate14Include, ' +
                                              'VATRate14Spare2, ' + 
                                              'VATRate15Code, ' + 
                                              'VATRate15Desc, ' +
                                              'VATRate15Rate, ' +
                                              'VATRate15Spare, ' +
                                              'VATRate15Include, ' +
                                              'VATRate15Spare2, ' +
                                              'VATRate16Code, ' +
                                              'VATRate16Desc, ' +
                                              'VATRate16Rate, ' +
                                              'VATRate16Spare, ' +
                                              'VATRate16Include, ' +
                                              'VATRate16Spare2, ' +
                                              'VATRate17Code, ' +
                                              'VATRate17Desc, ' +
                                              'VATRate17Rate, ' +
                                              'VATRate17Spare, ' +
                                              'VATRate17Include, ' +
                                              'VATRate17Spare2, ' +
                                              'VATRate18Code, ' +
                                              'VATRate18Desc, ' +
                                              'VATRate18Rate, ' +
                                              'VATRate18Spare, ' +
                                              'VATRate18Include, ' +
                                              'VATRate18Spare2, ' +
                                              'VATIAdjCode, ' +
                                              'VATIAdjDesc, ' +
                                              'VATIAdjRate, ' +
                                              'VATIAdjSpare, ' +
                                              'VATIAdjInclude, ' +
                                              'VATIAdjSpare2, ' +
                                              'VATOAdjCode, ' +
                                              'VATOAdjDesc, ' +
                                              'VATOAdjRate, ' +
                                              'VATOAdjSpare, ' +
                                              'VATOAdjInclude, ' +
                                              'VATOAdjSpare2, ' +
                                              'VATSpare8Code, ' +
                                              'VATSpare8Desc, ' +
                                              'VATSpare8Rate, ' +
                                              'VATSpare8Spare, ' +
                                              'VATSpare8Include, ' +
                                              'VATSpare8Spare2, ' +
                                              'HideUDF7, ' +
                                              'HideUDF8, ' +
                                              'HideUDF9, ' +
                                              'HideUDF10, ' +
                                              'HideUDF11, ' +
                                              'Spare2, ' +
                                              'VATInterval, ' +
                                              'Spare3, ' +
                                              'VATScheme, ' +
                                              'OLastECSalesDate, ' +
                                              'VATReturnDate, ' +
                                              'LastECSalesDate, ' +
                                              'CurrPeriod, ' +
                                              'UDFCaption1, ' +
                                              'UDFCaption2, ' +
                                              'UDFCaption3, ' +
                                              'UDFCaption4, ' +
                                              'UDFCaption5, ' +
                                              'UDFCaption6, ' +
                                              'UDFCaption7, ' +
                                              'UDFCaption8, ' +
                                              'UDFCaption9, ' +
                                              'UDFCaption10, ' +
                                              'UDFCaption11, ' +
                                              'UDFCaption12, ' +
                                              'UDFCaption13, ' +
                                              'UDFCaption14, ' +
                                              'UDFCaption15, ' +
                                              'UDFCaption16, ' +
                                              'UDFCaption17, ' +
                                              'UDFCaption18, ' +
                                              'UDFCaption19, ' +
                                              'UDFCaption20, ' +
                                              'UDFCaption21, ' +
                                              'UDFCaption22, ' +
                                              'HideLType0, ' +
                                              'HideLType1, ' +
                                              'HideLType2, ' +
                                              'HideLType3, ' +
                                              'HideLType4, ' +
                                              'HideLType5, ' +
                                              'HideLType6, ' +
                                              'ReportPrnN, ' +
                                              'FormsPrnN, ' +
                                              'EnableECServices, ' +
                                              'ECSalesThreshold, ' +
                                              // MH 13/05/2013 v7.0.4 ABSEXCH-13793: Added support for new VAT100 XML fields
                                              'VAT100UserID, ' +
                                              'VAT100UserPassword, ' +
                                              'VAT100SenderType' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':VATStandardCode, ' +
                     ':VATStandardDesc, ' +
                     ':VATStandardRate, ' +
                     ':VATStandardSpare, ' +
                     ':VATStandardInclude, ' +
                     ':VATStandardSpare2, ' +
                     ':VATExemptCode, ' +
                     ':VATExemptDesc, ' +
                     ':VATExemptRate, ' +
                     ':VATExemptSpare, ' +
                     ':VATExemptInclude, ' +
                     ':VATExemptSpare2, ' +
                     ':VATZeroCode, ' + 
                     ':VATZeroDesc, ' + 
                     ':VATZeroRate, ' + 
                     ':VATZeroSpare, ' + 
                     ':VATZeroInclude, ' + 
                     ':VATZeroSpare2, ' + 
                     ':VATRate1Code, ' +
                     ':VATRate1Desc, ' + 
                     ':VATRate1Rate, ' + 
                     ':VATRate1Spare, ' + 
                     ':VATRate1Include, ' +
                     ':VATRate1Spare2, ' +
                     ':VATRate2Code, ' + 
                     ':VATRate2Desc, ' + 
                     ':VATRate2Rate, ' +
                     ':VATRate2Spare, ' +
                     ':VATRate2Include, ' +
                     ':VATRate2Spare2, ' + 
                     ':VATRate3Code, ' + 
                     ':VATRate3Desc, ' + 
                     ':VATRate3Rate, ' + 
                     ':VATRate3Spare, ' + 
                     ':VATRate3Include, ' + 
                     ':VATRate3Spare2, ' +
                     ':VATRate4Code, ' +
                     ':VATRate4Desc, ' + 
                     ':VATRate4Rate, ' + 
                     ':VATRate4Spare, ' + 
                     ':VATRate4Include, ' +
                     ':VATRate4Spare2, ' +
                     ':VATRate5Code, ' +
                     ':VATRate5Desc, ' +
                     ':VATRate5Rate, ' +
                     ':VATRate5Spare, ' + 
                     ':VATRate5Include, ' + 
                     ':VATRate5Spare2, ' + 
                     ':VATRate6Code, ' + 
                     ':VATRate6Desc, ' +
                     ':VATRate6Rate, ' +
                     ':VATRate6Spare, ' + 
                     ':VATRate6Include, ' + 
                     ':VATRate6Spare2, ' + 
                     ':VATRate7Code, ' + 
                     ':VATRate7Desc, ' +
                     ':VATRate7Rate, ' + 
                     ':VATRate7Spare, ' +
                     ':VATRate7Include, ' + 
                     ':VATRate7Spare2, ' +
                     ':VATRate8Code, ' + 
                     ':VATRate8Desc, ' + 
                     ':VATRate8Rate, ' + 
                     ':VATRate8Spare, ' + 
                     ':VATRate8Include, ' + 
                     ':VATRate8Spare2, ' +
                     ':VATRate9Code, ' +
                     ':VATRate9Desc, ' + 
                     ':VATRate9Rate, ' +
                     ':VATRate9Spare, ' + 
                     ':VATRate9Include, ' + 
                     ':VATRate9Spare2, ' + 
                     ':VATRate10Code, ' + 
                     ':VATRate10Desc, ' + 
                     ':VATRate10Rate, ' +
                     ':VATRate10Spare, ' + 
                     ':VATRate10Include, ' + 
                     ':VATRate10Spare2, ' +
                     ':VATRate11Code, ' + 
                     ':VATRate11Desc, ' +
                     ':VATRate11Rate, ' +
                     ':VATRate11Spare, ' +
                     ':VATRate11Include, ' +
                     ':VATRate11Spare2, ' + 
                     ':VATRate12Code, ' +
                     ':VATRate12Desc, ' +
                     ':VATRate12Rate, ' + 
                     ':VATRate12Spare, ' +
                     ':VATRate12Include, ' +
                     ':VATRate12Spare2, ' + 
                     ':VATRate13Code, ' + 
                     ':VATRate13Desc, ' + 
                     ':VATRate13Rate, ' +
                     ':VATRate13Spare, ' + 
                     ':VATRate13Include, ' + 
                     ':VATRate13Spare2, ' + 
                     ':VATRate14Code, ' +
                     ':VATRate14Desc, ' + 
                     ':VATRate14Rate, ' + 
                     ':VATRate14Spare, ' + 
                     ':VATRate14Include, ' + 
                     ':VATRate14Spare2, ' + 
                     ':VATRate15Code, ' +
                     ':VATRate15Desc, ' + 
                     ':VATRate15Rate, ' +
                     ':VATRate15Spare, ' + 
                     ':VATRate15Include, ' + 
                     ':VATRate15Spare2, ' + 
                     ':VATRate16Code, ' + 
                     ':VATRate16Desc, ' + 
                     ':VATRate16Rate, ' +
                     ':VATRate16Spare, ' + 
                     ':VATRate16Include, ' + 
                     ':VATRate16Spare2, ' +
                     ':VATRate17Code, ' + 
                     ':VATRate17Desc, ' + 
                     ':VATRate17Rate, ' + 
                     ':VATRate17Spare, ' +
                     ':VATRate17Include, ' +
                     ':VATRate17Spare2, ' +
                     ':VATRate18Code, ' +
                     ':VATRate18Desc, ' + 
                     ':VATRate18Rate, ' + 
                     ':VATRate18Spare, ' + 
                     ':VATRate18Include, ' +
                     ':VATRate18Spare2, ' + 
                     ':VATIAdjCode, ' +
                     ':VATIAdjDesc, ' +
                     ':VATIAdjRate, ' + 
                     ':VATIAdjSpare, ' +
                     ':VATIAdjInclude, ' + 
                     ':VATIAdjSpare2, ' +
                     ':VATOAdjCode, ' + 
                     ':VATOAdjDesc, ' +
                     ':VATOAdjRate, ' + 
                     ':VATOAdjSpare, ' + 
                     ':VATOAdjInclude, ' + 
                     ':VATOAdjSpare2, ' + 
                     ':VATSpare8Code, ' + 
                     ':VATSpare8Desc, ' +
                     ':VATSpare8Rate, ' + 
                     ':VATSpare8Spare, ' + 
                     ':VATSpare8Include, ' + 
                     ':VATSpare8Spare2, ' + 
                     ':HideUDF7, ' + 
                     ':HideUDF8, ' + 
                     ':HideUDF9, ' + 
                     ':HideUDF10, ' +
                     ':HideUDF11, ' + 
                     ':Spare2, ' +
                     ':VATInterval, ' + 
                     ':Spare3, ' + 
                     ':VATScheme, ' +
                     ':OLastECSalesDate, ' +
                     ':VATReturnDate, ' +
                     ':LastECSalesDate, ' +
                     ':CurrPeriod, ' +
                     ':UDFCaption1, ' +
                     ':UDFCaption2, ' +
                     ':UDFCaption3, ' +
                     ':UDFCaption4, ' + 
                     ':UDFCaption5, ' + 
                     ':UDFCaption6, ' + 
                     ':UDFCaption7, ' + 
                     ':UDFCaption8, ' + 
                     ':UDFCaption9, ' + 
                     ':UDFCaption10, ' +
                     ':UDFCaption11, ' + 
                     ':UDFCaption12, ' +
                     ':UDFCaption13, ' +
                     ':UDFCaption14, ' +
                     ':UDFCaption15, ' +
                     ':UDFCaption16, ' + 
                     ':UDFCaption17, ' + 
                     ':UDFCaption18, ' + 
                     ':UDFCaption19, ' + 
                     ':UDFCaption20, ' +
                     ':UDFCaption21, ' +
                     ':UDFCaption22, ' +
                     ':HideLType0, ' +
                     ':HideLType1, ' +
                     ':HideLType2, ' +
                     ':HideLType3, ' +
                     ':HideLType4, ' +
                     ':HideLType5, ' +
                     ':HideLType6, ' +
                     ':ReportPrnN, ' +
                     ':FormsPrnN, ' +
                     ':EnableECServices, ' +
                     ':ECSalesThreshold, ' +
                     // MH 13/05/2013 v7.0.4 ABSEXCH-13793: Added support for new VAT100 XML fields
                     ':VAT100UserID, ' +
                     ':VAT100UserPassword, ' +
                     ':VAT100SenderType' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    VATStandardCodeParam := FindParam('VATStandardCode');
    VATStandardDescParam := FindParam('VATStandardDesc');
    VATStandardRateParam := FindParam('VATStandardRate');
    VATStandardSpareParam := FindParam('VATStandardSpare');
    VATStandardIncludeParam := FindParam('VATStandardInclude');
    VATStandardSpare2Param := FindParam('VATStandardSpare2');
    VATExemptCodeParam := FindParam('VATExemptCode');
    VATExemptDescParam := FindParam('VATExemptDesc');
    VATExemptRateParam := FindParam('VATExemptRate');
    VATExemptSpareParam := FindParam('VATExemptSpare');
    VATExemptIncludeParam := FindParam('VATExemptInclude');
    VATExemptSpare2Param := FindParam('VATExemptSpare2');
    VATZeroCodeParam := FindParam('VATZeroCode');
    VATZeroDescParam := FindParam('VATZeroDesc');
    VATZeroRateParam := FindParam('VATZeroRate');
    VATZeroSpareParam := FindParam('VATZeroSpare');
    VATZeroIncludeParam := FindParam('VATZeroInclude');
    VATZeroSpare2Param := FindParam('VATZeroSpare2');
    VATRate1CodeParam := FindParam('VATRate1Code');
    VATRate1DescParam := FindParam('VATRate1Desc');
    VATRate1RateParam := FindParam('VATRate1Rate');
    VATRate1SpareParam := FindParam('VATRate1Spare');
    VATRate1IncludeParam := FindParam('VATRate1Include');
    VATRate1Spare2Param := FindParam('VATRate1Spare2');
    VATRate2CodeParam := FindParam('VATRate2Code');
    VATRate2DescParam := FindParam('VATRate2Desc');
    VATRate2RateParam := FindParam('VATRate2Rate');
    VATRate2SpareParam := FindParam('VATRate2Spare');
    VATRate2IncludeParam := FindParam('VATRate2Include');
    VATRate2Spare2Param := FindParam('VATRate2Spare2');
    VATRate3CodeParam := FindParam('VATRate3Code');
    VATRate3DescParam := FindParam('VATRate3Desc');
    VATRate3RateParam := FindParam('VATRate3Rate');
    VATRate3SpareParam := FindParam('VATRate3Spare');
    VATRate3IncludeParam := FindParam('VATRate3Include');
    VATRate3Spare2Param := FindParam('VATRate3Spare2');
    VATRate4CodeParam := FindParam('VATRate4Code');
    VATRate4DescParam := FindParam('VATRate4Desc');
    VATRate4RateParam := FindParam('VATRate4Rate');
    VATRate4SpareParam := FindParam('VATRate4Spare');
    VATRate4IncludeParam := FindParam('VATRate4Include');
    VATRate4Spare2Param := FindParam('VATRate4Spare2');
    VATRate5CodeParam := FindParam('VATRate5Code');
    VATRate5DescParam := FindParam('VATRate5Desc');
    VATRate5RateParam := FindParam('VATRate5Rate');
    VATRate5SpareParam := FindParam('VATRate5Spare');
    VATRate5IncludeParam := FindParam('VATRate5Include');
    VATRate5Spare2Param := FindParam('VATRate5Spare2');
    VATRate6CodeParam := FindParam('VATRate6Code');
    VATRate6DescParam := FindParam('VATRate6Desc');
    VATRate6RateParam := FindParam('VATRate6Rate');
    VATRate6SpareParam := FindParam('VATRate6Spare');
    VATRate6IncludeParam := FindParam('VATRate6Include');
    VATRate6Spare2Param := FindParam('VATRate6Spare2');
    VATRate7CodeParam := FindParam('VATRate7Code');
    VATRate7DescParam := FindParam('VATRate7Desc');
    VATRate7RateParam := FindParam('VATRate7Rate');
    VATRate7SpareParam := FindParam('VATRate7Spare');
    VATRate7IncludeParam := FindParam('VATRate7Include');
    VATRate7Spare2Param := FindParam('VATRate7Spare2');
    VATRate8CodeParam := FindParam('VATRate8Code');
    VATRate8DescParam := FindParam('VATRate8Desc');
    VATRate8RateParam := FindParam('VATRate8Rate');
    VATRate8SpareParam := FindParam('VATRate8Spare');
    VATRate8IncludeParam := FindParam('VATRate8Include');
    VATRate8Spare2Param := FindParam('VATRate8Spare2');
    VATRate9CodeParam := FindParam('VATRate9Code');
    VATRate9DescParam := FindParam('VATRate9Desc');
    VATRate9RateParam := FindParam('VATRate9Rate');
    VATRate9SpareParam := FindParam('VATRate9Spare');
    VATRate9IncludeParam := FindParam('VATRate9Include');
    VATRate9Spare2Param := FindParam('VATRate9Spare2');
    VATRate10CodeParam := FindParam('VATRate10Code');
    VATRate10DescParam := FindParam('VATRate10Desc');
    VATRate10RateParam := FindParam('VATRate10Rate');
    VATRate10SpareParam := FindParam('VATRate10Spare');
    VATRate10IncludeParam := FindParam('VATRate10Include');
    VATRate10Spare2Param := FindParam('VATRate10Spare2');
    VATRate11CodeParam := FindParam('VATRate11Code');
    VATRate11DescParam := FindParam('VATRate11Desc');
    VATRate11RateParam := FindParam('VATRate11Rate');
    VATRate11SpareParam := FindParam('VATRate11Spare');
    VATRate11IncludeParam := FindParam('VATRate11Include');
    VATRate11Spare2Param := FindParam('VATRate11Spare2');
    VATRate12CodeParam := FindParam('VATRate12Code');
    VATRate12DescParam := FindParam('VATRate12Desc');
    VATRate12RateParam := FindParam('VATRate12Rate');
    VATRate12SpareParam := FindParam('VATRate12Spare');
    VATRate12IncludeParam := FindParam('VATRate12Include');
    VATRate12Spare2Param := FindParam('VATRate12Spare2');
    VATRate13CodeParam := FindParam('VATRate13Code');
    VATRate13DescParam := FindParam('VATRate13Desc');
    VATRate13RateParam := FindParam('VATRate13Rate');
    VATRate13SpareParam := FindParam('VATRate13Spare');
    VATRate13IncludeParam := FindParam('VATRate13Include');
    VATRate13Spare2Param := FindParam('VATRate13Spare2');
    VATRate14CodeParam := FindParam('VATRate14Code');
    VATRate14DescParam := FindParam('VATRate14Desc');
    VATRate14RateParam := FindParam('VATRate14Rate');
    VATRate14SpareParam := FindParam('VATRate14Spare');
    VATRate14IncludeParam := FindParam('VATRate14Include');
    VATRate14Spare2Param := FindParam('VATRate14Spare2');
    VATRate15CodeParam := FindParam('VATRate15Code');
    VATRate15DescParam := FindParam('VATRate15Desc');
    VATRate15RateParam := FindParam('VATRate15Rate');
    VATRate15SpareParam := FindParam('VATRate15Spare');
    VATRate15IncludeParam := FindParam('VATRate15Include');
    VATRate15Spare2Param := FindParam('VATRate15Spare2');
    VATRate16CodeParam := FindParam('VATRate16Code');
    VATRate16DescParam := FindParam('VATRate16Desc');
    VATRate16RateParam := FindParam('VATRate16Rate');
    VATRate16SpareParam := FindParam('VATRate16Spare');
    VATRate16IncludeParam := FindParam('VATRate16Include');
    VATRate16Spare2Param := FindParam('VATRate16Spare2');
    VATRate17CodeParam := FindParam('VATRate17Code');
    VATRate17DescParam := FindParam('VATRate17Desc');
    VATRate17RateParam := FindParam('VATRate17Rate');
    VATRate17SpareParam := FindParam('VATRate17Spare');
    VATRate17IncludeParam := FindParam('VATRate17Include');
    VATRate17Spare2Param := FindParam('VATRate17Spare2');
    VATRate18CodeParam := FindParam('VATRate18Code');
    VATRate18DescParam := FindParam('VATRate18Desc');
    VATRate18RateParam := FindParam('VATRate18Rate');
    VATRate18SpareParam := FindParam('VATRate18Spare');
    VATRate18IncludeParam := FindParam('VATRate18Include');
    VATRate18Spare2Param := FindParam('VATRate18Spare2');
    VATIAdjCodeParam := FindParam('VATIAdjCode');
    VATIAdjDescParam := FindParam('VATIAdjDesc');
    VATIAdjRateParam := FindParam('VATIAdjRate');
    VATIAdjSpareParam := FindParam('VATIAdjSpare');
    VATIAdjIncludeParam := FindParam('VATIAdjInclude');
    VATIAdjSpare2Param := FindParam('VATIAdjSpare2');
    VATOAdjCodeParam := FindParam('VATOAdjCode');
    VATOAdjDescParam := FindParam('VATOAdjDesc');
    VATOAdjRateParam := FindParam('VATOAdjRate');
    VATOAdjSpareParam := FindParam('VATOAdjSpare');
    VATOAdjIncludeParam := FindParam('VATOAdjInclude');
    VATOAdjSpare2Param := FindParam('VATOAdjSpare2');
    VATSpare8CodeParam := FindParam('VATSpare8Code');
    VATSpare8DescParam := FindParam('VATSpare8Desc');
    VATSpare8RateParam := FindParam('VATSpare8Rate');
    VATSpare8SpareParam := FindParam('VATSpare8Spare');
    VATSpare8IncludeParam := FindParam('VATSpare8Include');
    VATSpare8Spare2Param := FindParam('VATSpare8Spare2');
    HideUDF7Param := FindParam('HideUDF7');
    HideUDF8Param := FindParam('HideUDF8');
    HideUDF9Param := FindParam('HideUDF9');
    HideUDF10Param := FindParam('HideUDF10');
    HideUDF11Param := FindParam('HideUDF11');
    Spare2Param := FindParam('Spare2');
    VATIntervalParam := FindParam('VATInterval');
    Spare3Param := FindParam('Spare3');
    VATSchemeParam := FindParam('VATScheme');
    OLastECSalesDateParam := FindParam('OLastECSalesDate');
    VATReturnDateParam := FindParam('VATReturnDate');
    LastECSalesDateParam := FindParam('LastECSalesDate');
    CurrPeriodParam := FindParam('CurrPeriod');
    UDFCaption1Param := FindParam('UDFCaption1');
    UDFCaption2Param := FindParam('UDFCaption2');
    UDFCaption3Param := FindParam('UDFCaption3');
    UDFCaption4Param := FindParam('UDFCaption4');
    UDFCaption5Param := FindParam('UDFCaption5');
    UDFCaption6Param := FindParam('UDFCaption6');
    UDFCaption7Param := FindParam('UDFCaption7');
    UDFCaption8Param := FindParam('UDFCaption8');
    UDFCaption9Param := FindParam('UDFCaption9');
    UDFCaption10Param := FindParam('UDFCaption10');
    UDFCaption11Param := FindParam('UDFCaption11');
    UDFCaption12Param := FindParam('UDFCaption12');
    UDFCaption13Param := FindParam('UDFCaption13');
    UDFCaption14Param := FindParam('UDFCaption14');
    UDFCaption15Param := FindParam('UDFCaption15');
    UDFCaption16Param := FindParam('UDFCaption16');
    UDFCaption17Param := FindParam('UDFCaption17');
    UDFCaption18Param := FindParam('UDFCaption18');
    UDFCaption19Param := FindParam('UDFCaption19');
    UDFCaption20Param := FindParam('UDFCaption20');
    UDFCaption21Param := FindParam('UDFCaption21');
    UDFCaption22Param := FindParam('UDFCaption22');
    HideLType0Param := FindParam('HideLType0');
    HideLType1Param := FindParam('HideLType1');
    HideLType2Param := FindParam('HideLType2');
    HideLType3Param := FindParam('HideLType3');
    HideLType4Param := FindParam('HideLType4');
    HideLType5Param := FindParam('HideLType5');
    HideLType6Param := FindParam('HideLType6');
    ReportPrnNParam := FindParam('ReportPrnN');
    FormsPrnNParam := FindParam('FormsPrnN');
    EnableECServicesParam := FindParam('EnableECServices');
    ECSalesThresholdParam := FindParam('ECSalesThreshold');
    // MH 13/05/2013 v7.0.4 ABSEXCH-13793: Added support for new VAT100 XML fields
    VAT100UserIDParam := FindParam('VAT100UserID');
    VAT100UserPasswordParam := FindParam('VAT100UserPassword');
    VAT100SenderTypeParam :=  FindParam('VAT100SenderType');
  End; // With ADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.VATRates Do
  Begin
    VATStandardCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Standard].Code);     // SQL=varchar, Delphi=Char
    VATStandardDescParam.Value := VAT[Standard].Desc;                                      // SQL=varchar, Delphi=String[10]
    VATStandardRateParam.Value := VAT[Standard].Rate;                                      // SQL=float, Delphi=Real
    VATStandardSpareParam.Value := CreateVariantArray (@VAT[Standard].Spare, SizeOf(VAT[Standard].Spare));   // SQL=varbinary, Delphi=Byte
    VATStandardIncludeParam.Value := VAT[Standard].Include;                                // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATStandardSpare2Param.Value := CreateVariantArray (@VAT[Standard].Spare2, CalculateBinaryBlockSize (@VAT[Standard].Spare2, @VAT[Exempt].Code));

    VATExemptCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Exempt].Code);         // SQL=varchar, Delphi=Char
    VATExemptDescParam.Value := VAT[Exempt].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATExemptRateParam.Value := VAT[Exempt].Rate;                                          // SQL=float, Delphi=Real
    VATExemptSpareParam.Value := CreateVariantArray (@VAT[Exempt].Spare, SizeOf(VAT[Exempt].Spare));         // SQL=varbinary, Delphi=Byte
    VATExemptIncludeParam.Value := VAT[Exempt].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATExemptSpare2Param.Value := CreateVariantArray (@VAT[Exempt].Spare2, CalculateBinaryBlockSize (@VAT[Exempt].Spare2, @VAT[Zero].Code));

    VATZeroCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Zero].Code);             // SQL=varchar, Delphi=Char
    VATZeroDescParam.Value := VAT[Zero].Desc;                                              // SQL=varchar, Delphi=String[10]
    VATZeroRateParam.Value := VAT[Zero].Rate;                                              // SQL=float, Delphi=Real
    VATZeroSpareParam.Value := CreateVariantArray (@VAT[Zero].Spare, SizeOf(VAT[Zero].Spare));               // SQL=varbinary, Delphi=Byte
    VATZeroIncludeParam.Value := VAT[Zero].Include;                                        // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATZeroSpare2Param.Value := CreateVariantArray (@VAT[Zero].Spare2, CalculateBinaryBlockSize (@VAT[Zero].Spare2, @VAT[Rate1].Code));

    VATRate1CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate1].Code);           // SQL=varchar, Delphi=Char
    VATRate1DescParam.Value := VAT[Rate1].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate1RateParam.Value := VAT[Rate1].Rate;                                            // SQL=float, Delphi=Real
    VATRate1SpareParam.Value := CreateVariantArray (@VAT[Rate1].Spare, SizeOf(VAT[Rate1].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate1IncludeParam.Value := VAT[Rate1].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate1Spare2Param.Value := CreateVariantArray (@VAT[Rate1].Spare2, CalculateBinaryBlockSize (@VAT[Rate1].Spare2, @VAT[Rate2].Code));

    VATRate2CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate2].Code);           // SQL=varchar, Delphi=Char
    VATRate2DescParam.Value := VAT[Rate2].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate2RateParam.Value := VAT[Rate2].Rate;                                            // SQL=float, Delphi=Real
    VATRate2SpareParam.Value := CreateVariantArray (@VAT[Rate2].Spare, SizeOf(VAT[Rate2].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate2IncludeParam.Value := VAT[Rate2].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate2Spare2Param.Value := CreateVariantArray (@VAT[Rate2].Spare2, CalculateBinaryBlockSize (@VAT[Rate2].Spare2, @VAT[Rate3].Code));

    VATRate3CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate3].Code);           // SQL=varchar, Delphi=Char
    VATRate3DescParam.Value := VAT[Rate3].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate3RateParam.Value := VAT[Rate3].Rate;                                            // SQL=float, Delphi=Real
    VATRate3SpareParam.Value := CreateVariantArray (@VAT[Rate3].Spare, SizeOf(VAT[Rate3].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate3IncludeParam.Value := VAT[Rate3].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate3Spare2Param.Value := CreateVariantArray (@VAT[Rate3].Spare2, CalculateBinaryBlockSize (@VAT[Rate3].Spare2, @VAT[Rate4].Code));

    VATRate4CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate4].Code);           // SQL=varchar, Delphi=Char
    VATRate4DescParam.Value := VAT[Rate4].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate4RateParam.Value := VAT[Rate4].Rate;                                            // SQL=float, Delphi=Real
    VATRate4SpareParam.Value := CreateVariantArray (@VAT[Rate4].Spare, SizeOf(VAT[Rate4].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate4IncludeParam.Value := VAT[Rate4].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate4Spare2Param.Value := CreateVariantArray (@VAT[Rate4].Spare2, CalculateBinaryBlockSize (@VAT[Rate4].Spare2, @VAT[Rate5].Code));

    VATRate5CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate5].Code);           // SQL=varchar, Delphi=Char
    VATRate5DescParam.Value := VAT[Rate5].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate5RateParam.Value := VAT[Rate5].Rate;                                            // SQL=float, Delphi=Real
    VATRate5SpareParam.Value := CreateVariantArray (@VAT[Rate5].Spare, SizeOf(VAT[Rate5].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate5IncludeParam.Value := VAT[Rate5].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate5Spare2Param.Value := CreateVariantArray (@VAT[Rate5].Spare2, CalculateBinaryBlockSize (@VAT[Rate5].Spare2, @VAT[Rate6].Code));

    VATRate6CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate6].Code);           // SQL=varchar, Delphi=Char
    VATRate6DescParam.Value := VAT[Rate6].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate6RateParam.Value := VAT[Rate6].Rate;                                            // SQL=float, Delphi=Real
    VATRate6SpareParam.Value := CreateVariantArray (@VAT[Rate6].Spare, SizeOf(VAT[Rate6].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate6IncludeParam.Value := VAT[Rate6].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate6Spare2Param.Value := CreateVariantArray (@VAT[Rate6].Spare2, CalculateBinaryBlockSize (@VAT[Rate6].Spare2, @VAT[Rate7].Code));

    VATRate7CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate7].Code);           // SQL=varchar, Delphi=Char
    VATRate7DescParam.Value := VAT[Rate7].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate7RateParam.Value := VAT[Rate7].Rate;                                            // SQL=float, Delphi=Real
    VATRate7SpareParam.Value := CreateVariantArray (@VAT[Rate7].Spare, SizeOf(VAT[Rate7].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate7IncludeParam.Value := VAT[Rate7].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate7Spare2Param.Value := CreateVariantArray (@VAT[Rate7].Spare2, CalculateBinaryBlockSize (@VAT[Rate7].Spare2, @VAT[Rate8].Code));

    VATRate8CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate8].Code);           // SQL=varchar, Delphi=Char
    VATRate8DescParam.Value := VAT[Rate8].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate8RateParam.Value := VAT[Rate8].Rate;                                            // SQL=float, Delphi=Real
    VATRate8SpareParam.Value := CreateVariantArray (@VAT[Rate8].Spare, SizeOf(VAT[Rate8].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate8IncludeParam.Value := VAT[Rate8].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate8Spare2Param.Value := CreateVariantArray (@VAT[Rate8].Spare2, CalculateBinaryBlockSize (@VAT[Rate8].Spare2, @VAT[Rate9].Code));

    VATRate9CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate9].Code);           // SQL=varchar, Delphi=Char
    VATRate9DescParam.Value := VAT[Rate9].Desc;                                            // SQL=varchar, Delphi=String[10]
    VATRate9RateParam.Value := VAT[Rate9].Rate;                                            // SQL=float, Delphi=Real
    VATRate9SpareParam.Value := CreateVariantArray (@VAT[Rate9].Spare, SizeOf(VAT[Rate9].Spare));            // SQL=varbinary, Delphi=Byte
    VATRate9IncludeParam.Value := VAT[Rate9].Include;                                      // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate9Spare2Param.Value := CreateVariantArray (@VAT[Rate9].Spare2, CalculateBinaryBlockSize (@VAT[Rate9].Spare2, @VAT[Rate10].Code));

    VATRate10CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate10].Code);         // SQL=varchar, Delphi=Char
    VATRate10DescParam.Value := VAT[Rate10].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate10RateParam.Value := VAT[Rate10].Rate;                                          // SQL=float, Delphi=Real
    VATRate10SpareParam.Value := CreateVariantArray (@VAT[Rate10].Spare, SizeOf(VAT[Rate10].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate10IncludeParam.Value := VAT[Rate10].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate10Spare2Param.Value := CreateVariantArray (@VAT[Rate10].Spare2, CalculateBinaryBlockSize (@VAT[Rate10].Spare2, @VAT[Rate11].Code));

    VATRate11CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate11].Code);         // SQL=varchar, Delphi=Char
    VATRate11DescParam.Value := VAT[Rate11].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate11RateParam.Value := VAT[Rate11].Rate;                                          // SQL=float, Delphi=Real
    VATRate11SpareParam.Value := CreateVariantArray (@VAT[Rate11].Spare, SizeOf(VAT[Rate11].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate11IncludeParam.Value := VAT[Rate11].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate11Spare2Param.Value := CreateVariantArray (@VAT[Rate11].Spare2, CalculateBinaryBlockSize (@VAT[Rate11].Spare2, @VAT[Rate12].Code));

    VATRate12CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate12].Code);         // SQL=varchar, Delphi=Char
    VATRate12DescParam.Value := VAT[Rate12].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate12RateParam.Value := VAT[Rate12].Rate;                                          // SQL=float, Delphi=Real
    VATRate12SpareParam.Value := CreateVariantArray (@VAT[Rate12].Spare, SizeOf(VAT[Rate12].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate12IncludeParam.Value := VAT[Rate12].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate12Spare2Param.Value := CreateVariantArray (@VAT[Rate12].Spare2, CalculateBinaryBlockSize (@VAT[Rate12].Spare2, @VAT[Rate13].Code));

    VATRate13CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate13].Code);         // SQL=varchar, Delphi=Char
    VATRate13DescParam.Value := VAT[Rate13].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate13RateParam.Value := VAT[Rate13].Rate;                                          // SQL=float, Delphi=Real
    VATRate13SpareParam.Value := CreateVariantArray (@VAT[Rate13].Spare, SizeOf(VAT[Rate13].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate13IncludeParam.Value := VAT[Rate13].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate13Spare2Param.Value := CreateVariantArray (@VAT[Rate13].Spare2, CalculateBinaryBlockSize (@VAT[Rate13].Spare2, @VAT[Rate14].Code));

    VATRate14CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate14].Code);         // SQL=varchar, Delphi=Char
    VATRate14DescParam.Value := VAT[Rate14].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate14RateParam.Value := VAT[Rate14].Rate;                                          // SQL=float, Delphi=Real
    VATRate14SpareParam.Value := CreateVariantArray (@VAT[Rate14].Spare, SizeOf(VAT[Rate14].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate14IncludeParam.Value := VAT[Rate14].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate14Spare2Param.Value := CreateVariantArray (@VAT[Rate14].Spare2, CalculateBinaryBlockSize (@VAT[Rate14].Spare2, @VAT[Rate15].Code));

    VATRate15CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate15].Code);         // SQL=varchar, Delphi=Char
    VATRate15DescParam.Value := VAT[Rate15].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate15RateParam.Value := VAT[Rate15].Rate;                                          // SQL=float, Delphi=Real
    VATRate15SpareParam.Value := CreateVariantArray (@VAT[Rate15].Spare, SizeOf(VAT[Rate15].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate15IncludeParam.Value := VAT[Rate15].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate15Spare2Param.Value := CreateVariantArray (@VAT[Rate15].Spare2, CalculateBinaryBlockSize (@VAT[Rate15].Spare2, @VAT[Rate16].Code));

    VATRate16CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate16].Code);         // SQL=varchar, Delphi=Char
    VATRate16DescParam.Value := VAT[Rate16].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate16RateParam.Value := VAT[Rate16].Rate;                                          // SQL=float, Delphi=Real
    VATRate16SpareParam.Value := CreateVariantArray (@VAT[Rate16].Spare, SizeOf(VAT[Rate16].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate16IncludeParam.Value := VAT[Rate16].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate16Spare2Param.Value := CreateVariantArray (@VAT[Rate16].Spare2, CalculateBinaryBlockSize (@VAT[Rate16].Spare2, @VAT[Rate17].Code));

    VATRate17CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate17].Code);         // SQL=varchar, Delphi=Char
    VATRate17DescParam.Value := VAT[Rate17].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate17RateParam.Value := VAT[Rate17].Rate;                                          // SQL=float, Delphi=Real
    VATRate17SpareParam.Value := CreateVariantArray (@VAT[Rate17].Spare, SizeOf(VAT[Rate17].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate17IncludeParam.Value := VAT[Rate17].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate17Spare2Param.Value := CreateVariantArray (@VAT[Rate17].Spare2, CalculateBinaryBlockSize (@VAT[Rate17].Spare2, @VAT[Rate18].Code));

    VATRate18CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Rate18].Code);         // SQL=varchar, Delphi=Char
    VATRate18DescParam.Value := VAT[Rate18].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATRate18RateParam.Value := VAT[Rate18].Rate;                                          // SQL=float, Delphi=Real
    VATRate18SpareParam.Value := CreateVariantArray (@VAT[Rate18].Spare, SizeOf(VAT[Rate18].Spare));         // SQL=varbinary, Delphi=Byte
    VATRate18IncludeParam.Value := VAT[Rate18].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATRate18Spare2Param.Value := CreateVariantArray (@VAT[Rate18].Spare2, CalculateBinaryBlockSize (@VAT[Rate18].Spare2, @VAT[IAdj].Code));

    VATIAdjCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[IAdj].Code);             // SQL=varchar, Delphi=Char
    VATIAdjDescParam.Value := VAT[IAdj].Desc;                                              // SQL=varchar, Delphi=String[10]
    VATIAdjRateParam.Value := VAT[IAdj].Rate;                                              // SQL=float, Delphi=Real
    VATIAdjSpareParam.Value := CreateVariantArray (@VAT[IAdj].Spare, SizeOf(VAT[IAdj].Spare));               // SQL=varbinary, Delphi=Byte
    VATIAdjIncludeParam.Value := VAT[IAdj].Include;                                        // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATIAdjSpare2Param.Value := CreateVariantArray (@VAT[IAdj].Spare2, CalculateBinaryBlockSize (@VAT[IAdj].Spare2, @VAT[OAdj].Code));

    VATOAdjCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[OAdj].Code);             // SQL=varchar, Delphi=Char
    VATOAdjDescParam.Value := VAT[OAdj].Desc;                                              // SQL=varchar, Delphi=String[10]
    VATOAdjRateParam.Value := VAT[OAdj].Rate;                                              // SQL=float, Delphi=Real
    VATOAdjSpareParam.Value := CreateVariantArray (@VAT[OAdj].Spare, SizeOf(VAT[OAdj].Spare));               // SQL=varbinary, Delphi=Byte
    VATOAdjIncludeParam.Value := VAT[OAdj].Include;                                        // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATOAdjSpare2Param.Value := CreateVariantArray (@VAT[OAdj].Spare2, CalculateBinaryBlockSize (@VAT[OAdj].Spare2, @VAT[Spare8].Code));

    VATSpare8CodeParam.Value := ConvertCharToSQLEmulatorVarChar(VAT[Spare8].Code);         // SQL=varchar, Delphi=Char
    VATSpare8DescParam.Value := VAT[Spare8].Desc;                                          // SQL=varchar, Delphi=String[10]
    VATSpare8RateParam.Value := VAT[Spare8].Rate;                                          // SQL=float, Delphi=Real
    VATSpare8SpareParam.Value := CreateVariantArray (@VAT[Spare8].Spare, SizeOf(VAT[Spare8].Spare));         // SQL=varbinary, Delphi=Byte
    VATSpare8IncludeParam.Value := VAT[Spare8].Include;                                    // SQL=bit, Delphi=Boolean
    // Binary block covering Spare2 : Byte / Spare3 : Byte
    VATSpare8Spare2Param.Value := CreateVariantArray (@VAT[Spare8].Spare2, CalculateBinaryBlockSize (@VAT[Spare8].Spare2, @_HideUDF[7]));

    HideUDF7Param.Value := _HideUDF[7];                                                    // SQL=bit, Delphi=Boolean
    HideUDF8Param.Value := _HideUDF[8];                                                    // SQL=bit, Delphi=Boolean
    HideUDF9Param.Value := _HideUDF[9];                                                    // SQL=bit, Delphi=Boolean
    HideUDF10Param.Value := _HideUDF[10];                                                  // SQL=bit, Delphi=Boolean
    HideUDF11Param.Value := _HideUDF[11];                                                  // SQL=bit, Delphi=Boolean
    Spare2Param.Value := CreateVariantArray (@Spare2, SizeOf(Spare2));                     // SQL=varbinary, Delphi=Array[0..1] of Byte
    VATIntervalParam.Value := VATInterval;                                                 // SQL=int, Delphi=Byte
    Spare3Param.Value := CreateVariantArray (@Spare3, SizeOf(Spare3));                     // SQL=varbinary, Delphi=Array[0..6] of Byte
    VATSchemeParam.Value := ConvertCharToSQLEmulatorVarChar(VATScheme);                    // SQL=varchar, Delphi=Char
    OLastECSalesDateParam.Value := OLastECSalesDate;                                       // SQL=varchar, Delphi=Date
    VATReturnDateParam.Value := VATReturnDate;                                             // SQL=varchar, Delphi=LongDate
    LastECSalesDateParam.Value := LastECSalesDate;                                         // SQL=varchar, Delphi=LongDate
    CurrPeriodParam.Value := CurrPeriod;                                                   // SQL=varchar, Delphi=LongDate
    UDFCaption1Param.Value := _UDFCaption[1];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption2Param.Value := _UDFCaption[2];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption3Param.Value := _UDFCaption[3];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption4Param.Value := _UDFCaption[4];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption5Param.Value := _UDFCaption[5];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption6Param.Value := _UDFCaption[6];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption7Param.Value := _UDFCaption[7];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption8Param.Value := _UDFCaption[8];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption9Param.Value := _UDFCaption[9];                                              // SQL=varchar, Delphi=String[15]
    UDFCaption10Param.Value := _UDFCaption[10];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption11Param.Value := _UDFCaption[11];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption12Param.Value := _UDFCaption[12];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption13Param.Value := _UDFCaption[13];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption14Param.Value := _UDFCaption[14];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption15Param.Value := _UDFCaption[15];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption16Param.Value := _UDFCaption[16];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption17Param.Value := _UDFCaption[17];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption18Param.Value := _UDFCaption[18];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption19Param.Value := _UDFCaption[19];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption20Param.Value := _UDFCaption[20];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption21Param.Value := _UDFCaption[21];                                            // SQL=varchar, Delphi=String[15]
    UDFCaption22Param.Value := _UDFCaption[22];                                            // SQL=varchar, Delphi=String[15]
    HideLType0Param.Value := _HideLType[0];                                                // SQL=bit, Delphi=Boolean
    HideLType1Param.Value := _HideLType[1];                                                // SQL=bit, Delphi=Boolean
    HideLType2Param.Value := _HideLType[2];                                                // SQL=bit, Delphi=Boolean
    HideLType3Param.Value := _HideLType[3];                                                // SQL=bit, Delphi=Boolean
    HideLType4Param.Value := _HideLType[4];                                                // SQL=bit, Delphi=Boolean
    HideLType5Param.Value := _HideLType[5];                                                // SQL=bit, Delphi=Boolean
    HideLType6Param.Value := _HideLType[6];                                                // SQL=bit, Delphi=Boolean
    ReportPrnNParam.Value := ReportPrnN;                                                   // SQL=varchar, Delphi=String[50]
    FormsPrnNParam.Value := FormsPrnN;                                                     // SQL=varchar, Delphi=String[50]
    EnableECServicesParam.Value := EnableECServices;                                       // SQL=bit, Delphi=Boolean
    ECSalesThresholdParam.Value := ECSalesThreshold;

    // MH 13/05/2013 v7.0.4 ABSEXCH-13793: Added support for new VAT100 XML fields
    VAT100UserIDParam.Value := CreateVariantArray (@VAT100UserID, SizeOf(VAT100UserID));
    VAT100UserPasswordParam.Value := CreateVariantArray (@VAT100Password, SizeOf(VAT100Password));
    VAT100SenderTypeParam.Value := VAT100SenderType;
  End; // With DataRec^.VATRates
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_MainCurrencyVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_MainCurrencyVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, MainCurrency00ScreenSymbolParam, MainCurrency00DescParam,
  MainCurrency00CompanyRateParam, MainCurrency00DailyRateParam, MainCurrency00PrintSymbolParam,
  MainCurrency01ScreenSymbolParam, MainCurrency01DescParam, MainCurrency01CompanyRateParam,
  MainCurrency01DailyRateParam, MainCurrency01PrintSymbolParam, MainCurrency02ScreenSymbolParam,
  MainCurrency02DescParam, MainCurrency02CompanyRateParam, MainCurrency02DailyRateParam,
  MainCurrency02PrintSymbolParam, MainCurrency03ScreenSymbolParam, MainCurrency03DescParam,
  MainCurrency03CompanyRateParam, MainCurrency03DailyRateParam, MainCurrency03PrintSymbolParam,
  MainCurrency04ScreenSymbolParam, MainCurrency04DescParam, MainCurrency04CompanyRateParam,
  MainCurrency04DailyRateParam, MainCurrency04PrintSymbolParam, MainCurrency05ScreenSymbolParam,
  MainCurrency05DescParam, MainCurrency05CompanyRateParam, MainCurrency05DailyRateParam,
  MainCurrency05PrintSymbolParam, MainCurrency06ScreenSymbolParam, MainCurrency06DescParam,
  MainCurrency06CompanyRateParam, MainCurrency06DailyRateParam, MainCurrency06PrintSymbolParam,
  MainCurrency07ScreenSymbolParam, MainCurrency07DescParam, MainCurrency07CompanyRateParam,
  MainCurrency07DailyRateParam, MainCurrency07PrintSymbolParam, MainCurrency08ScreenSymbolParam,
  MainCurrency08DescParam, MainCurrency08CompanyRateParam, MainCurrency08DailyRateParam,
  MainCurrency08PrintSymbolParam, MainCurrency09ScreenSymbolParam, MainCurrency09DescParam,
  MainCurrency09CompanyRateParam, MainCurrency09DailyRateParam, MainCurrency09PrintSymbolParam,
  MainCurrency10ScreenSymbolParam, MainCurrency10DescParam, MainCurrency10CompanyRateParam,
  MainCurrency10DailyRateParam, MainCurrency10PrintSymbolParam, MainCurrency11ScreenSymbolParam,
  MainCurrency11DescParam, MainCurrency11CompanyRateParam, MainCurrency11DailyRateParam,
  MainCurrency11PrintSymbolParam, MainCurrency12ScreenSymbolParam, MainCurrency12DescParam,
  MainCurrency12CompanyRateParam, MainCurrency12DailyRateParam, MainCurrency12PrintSymbolParam,
  MainCurrency13ScreenSymbolParam, MainCurrency13DescParam, MainCurrency13CompanyRateParam,
  MainCurrency13DailyRateParam, MainCurrency13PrintSymbolParam, MainCurrency14ScreenSymbolParam,
  MainCurrency14DescParam, MainCurrency14CompanyRateParam, MainCurrency14DailyRateParam,
  MainCurrency14PrintSymbolParam, MainCurrency15ScreenSymbolParam, MainCurrency15DescParam,
  MainCurrency15CompanyRateParam, MainCurrency15DailyRateParam, MainCurrency15PrintSymbolParam,
  MainCurrency16ScreenSymbolParam, MainCurrency16DescParam, MainCurrency16CompanyRateParam,
  MainCurrency16DailyRateParam, MainCurrency16PrintSymbolParam, MainCurrency17ScreenSymbolParam,
  MainCurrency17DescParam, MainCurrency17CompanyRateParam, MainCurrency17DailyRateParam,
  MainCurrency17PrintSymbolParam, MainCurrency18ScreenSymbolParam, MainCurrency18DescParam,
  MainCurrency18CompanyRateParam, MainCurrency18DailyRateParam, MainCurrency18PrintSymbolParam,
  MainCurrency19ScreenSymbolParam, MainCurrency19DescParam, MainCurrency19CompanyRateParam,
  MainCurrency19DailyRateParam, MainCurrency19PrintSymbolParam, MainCurrency20ScreenSymbolParam,
  MainCurrency20DescParam, MainCurrency20CompanyRateParam, MainCurrency20DailyRateParam,
  MainCurrency20PrintSymbolParam, MainCurrency21ScreenSymbolParam, MainCurrency21DescParam,
  MainCurrency21CompanyRateParam, MainCurrency21DailyRateParam, MainCurrency21PrintSymbolParam,
  MainCurrency22ScreenSymbolParam, MainCurrency22DescParam, MainCurrency22CompanyRateParam,
  MainCurrency22DailyRateParam, MainCurrency22PrintSymbolParam, MainCurrency23ScreenSymbolParam,
  MainCurrency23DescParam, MainCurrency23CompanyRateParam, MainCurrency23DailyRateParam,
  MainCurrency23PrintSymbolParam, MainCurrency24ScreenSymbolParam, MainCurrency24DescParam,
  MainCurrency24CompanyRateParam, MainCurrency24DailyRateParam, MainCurrency24PrintSymbolParam,
  MainCurrency25ScreenSymbolParam, MainCurrency25DescParam, MainCurrency25CompanyRateParam,
  MainCurrency25DailyRateParam, MainCurrency25PrintSymbolParam, MainCurrency26ScreenSymbolParam,
  MainCurrency26DescParam, MainCurrency26CompanyRateParam, MainCurrency26DailyRateParam,
  MainCurrency26PrintSymbolParam, MainCurrency27ScreenSymbolParam, MainCurrency27DescParam,
  MainCurrency27CompanyRateParam, MainCurrency27DailyRateParam, MainCurrency27PrintSymbolParam,
  MainCurrency28ScreenSymbolParam, MainCurrency28DescParam, MainCurrency28CompanyRateParam,
  MainCurrency28DailyRateParam, MainCurrency28PrintSymbolParam, MainCurrency29ScreenSymbolParam,
  MainCurrency29DescParam, MainCurrency29CompanyRateParam, MainCurrency29DailyRateParam,
  MainCurrency29PrintSymbolParam, MainCurrency30ScreenSymbolParam, MainCurrency30DescParam,
  MainCurrency30CompanyRateParam, MainCurrency30DailyRateParam, MainCurrency30PrintSymbolParam : TParameter;
  FieldPrefix, sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Work out which set of columns we need to address
  If (DataRec^.IDCode = SysNames[CurR]) Then
    FieldPrefix := 'MainCurrency'
  Else
    FieldPrefix := 'ExtCurrency';

  // Build the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              FieldPrefix + '00ScreenSymbol, ' +
                                              FieldPrefix + '00Desc, ' +
                                              FieldPrefix + '00CompanyRate, ' +
                                              FieldPrefix + '00DailyRate, ' +
                                              FieldPrefix + '00PrintSymbol, ' +
                                              FieldPrefix + '01ScreenSymbol, ' +
                                              FieldPrefix + '01Desc, ' +
                                              FieldPrefix + '01CompanyRate, ' +
                                              FieldPrefix + '01DailyRate, ' +
                                              FieldPrefix + '01PrintSymbol, ' +
                                              FieldPrefix + '02ScreenSymbol, ' +
                                              FieldPrefix + '02Desc, ' +
                                              FieldPrefix + '02CompanyRate, ' +
                                              FieldPrefix + '02DailyRate, ' +
                                              FieldPrefix + '02PrintSymbol, ' +
                                              FieldPrefix + '03ScreenSymbol, ' +
                                              FieldPrefix + '03Desc, ' + 
                                              FieldPrefix + '03CompanyRate, ' +
                                              FieldPrefix + '03DailyRate, ' + 
                                              FieldPrefix + '03PrintSymbol, ' + 
                                              FieldPrefix + '04ScreenSymbol, ' + 
                                              FieldPrefix + '04Desc, ' + 
                                              FieldPrefix + '04CompanyRate, ' +
                                              FieldPrefix + '04DailyRate, ' + 
                                              FieldPrefix + '04PrintSymbol, ' + 
                                              FieldPrefix + '05ScreenSymbol, ' + 
                                              FieldPrefix + '05Desc, ' + 
                                              FieldPrefix + '05CompanyRate, ' + 
                                              FieldPrefix + '05DailyRate, ' + 
                                              FieldPrefix + '05PrintSymbol, ' +
                                              FieldPrefix + '06ScreenSymbol, ' + 
                                              FieldPrefix + '06Desc, ' + 
                                              FieldPrefix + '06CompanyRate, ' + 
                                              FieldPrefix + '06DailyRate, ' +
                                              FieldPrefix + '06PrintSymbol, ' +
                                              FieldPrefix + '07ScreenSymbol, ' + 
                                              FieldPrefix + '07Desc, ' + 
                                              FieldPrefix + '07CompanyRate, ' + 
                                              FieldPrefix + '07DailyRate, ' + 
                                              FieldPrefix + '07PrintSymbol, ' +
                                              FieldPrefix + '08ScreenSymbol, ' + 
                                              FieldPrefix + '08Desc, ' + 
                                              FieldPrefix + '08CompanyRate, ' + 
                                              FieldPrefix + '08DailyRate, ' +
                                              FieldPrefix + '08PrintSymbol, ' + 
                                              FieldPrefix + '09ScreenSymbol, ' + 
                                              FieldPrefix + '09Desc, ' + 
                                              FieldPrefix + '09CompanyRate, ' + 
                                              FieldPrefix + '09DailyRate, ' + 
                                              FieldPrefix + '09PrintSymbol, ' + 
                                              FieldPrefix + '10ScreenSymbol, ' + 
                                              FieldPrefix + '10Desc, ' + 
                                              FieldPrefix + '10CompanyRate, ' + 
                                              FieldPrefix + '10DailyRate, ' + 
                                              FieldPrefix + '10PrintSymbol, ' +
                                              FieldPrefix + '11ScreenSymbol, ' + 
                                              FieldPrefix + '11Desc, ' + 
                                              FieldPrefix + '11CompanyRate, ' +
                                              FieldPrefix + '11DailyRate, ' + 
                                              FieldPrefix + '11PrintSymbol, ' +
                                              FieldPrefix + '12ScreenSymbol, ' + 
                                              FieldPrefix + '12Desc, ' + 
                                              FieldPrefix + '12CompanyRate, ' + 
                                              FieldPrefix + '12DailyRate, ' + 
                                              FieldPrefix + '12PrintSymbol, ' + 
                                              FieldPrefix + '13ScreenSymbol, ' + 
                                              FieldPrefix + '13Desc, ' +
                                              FieldPrefix + '13CompanyRate, ' + 
                                              FieldPrefix + '13DailyRate, ' +
                                              FieldPrefix + '13PrintSymbol, ' + 
                                              FieldPrefix + '14ScreenSymbol, ' + 
                                              FieldPrefix + '14Desc, ' +
                                              FieldPrefix + '14CompanyRate, ' +
                                              FieldPrefix + '14DailyRate, ' + 
                                              FieldPrefix + '14PrintSymbol, ' + 
                                              FieldPrefix + '15ScreenSymbol, ' + 
                                              FieldPrefix + '15Desc, ' + 
                                              FieldPrefix + '15CompanyRate, ' + 
                                              FieldPrefix + '15DailyRate, ' +
                                              FieldPrefix + '15PrintSymbol, ' + 
                                              FieldPrefix + '16ScreenSymbol, ' + 
                                              FieldPrefix + '16Desc, ' +
                                              FieldPrefix + '16CompanyRate, ' +
                                              FieldPrefix + '16DailyRate, ' + 
                                              FieldPrefix + '16PrintSymbol, ' + 
                                              FieldPrefix + '17ScreenSymbol, ' + 
                                              FieldPrefix + '17Desc, ' + 
                                              FieldPrefix + '17CompanyRate, ' + 
                                              FieldPrefix + '17DailyRate, ' + 
                                              FieldPrefix + '17PrintSymbol, ' + 
                                              FieldPrefix + '18ScreenSymbol, ' + 
                                              FieldPrefix + '18Desc, ' +
                                              FieldPrefix + '18CompanyRate, ' + 
                                              FieldPrefix + '18DailyRate, ' + 
                                              FieldPrefix + '18PrintSymbol, ' + 
                                              FieldPrefix + '19ScreenSymbol, ' + 
                                              FieldPrefix + '19Desc, ' +
                                              FieldPrefix + '19CompanyRate, ' + 
                                              FieldPrefix + '19DailyRate, ' + 
                                              FieldPrefix + '19PrintSymbol, ' +
                                              FieldPrefix + '20ScreenSymbol, ' + 
                                              FieldPrefix + '20Desc, ' + 
                                              FieldPrefix + '20CompanyRate, ' + 
                                              FieldPrefix + '20DailyRate, ' + 
                                              FieldPrefix + '20PrintSymbol, ' +
                                              FieldPrefix + '21ScreenSymbol, ' +
                                              FieldPrefix + '21Desc, ' + 
                                              FieldPrefix + '21CompanyRate, ' +
                                              FieldPrefix + '21DailyRate, ' +
                                              FieldPrefix + '21PrintSymbol, ' + 
                                              FieldPrefix + '22ScreenSymbol, ' + 
                                              FieldPrefix + '22Desc, ' +
                                              FieldPrefix + '22CompanyRate, ' + 
                                              FieldPrefix + '22DailyRate, ' + 
                                              FieldPrefix + '22PrintSymbol, ' + 
                                              FieldPrefix + '23ScreenSymbol, ' + 
                                              FieldPrefix + '23Desc, ' + 
                                              FieldPrefix + '23CompanyRate, ' +
                                              FieldPrefix + '23DailyRate, ' +
                                              FieldPrefix + '23PrintSymbol, ' + 
                                              FieldPrefix + '24ScreenSymbol, ' + 
                                              FieldPrefix + '24Desc, ' +
                                              FieldPrefix + '24CompanyRate, ' + 
                                              FieldPrefix + '24DailyRate, ' +
                                              FieldPrefix + '24PrintSymbol, ' + 
                                              FieldPrefix + '25ScreenSymbol, ' + 
                                              FieldPrefix + '25Desc, ' + 
                                              FieldPrefix + '25CompanyRate, ' + 
                                              FieldPrefix + '25DailyRate, ' +
                                              FieldPrefix + '25PrintSymbol, ' + 
                                              FieldPrefix + '26ScreenSymbol, ' + 
                                              FieldPrefix + '26Desc, ' + 
                                              FieldPrefix + '26CompanyRate, ' + 
                                              FieldPrefix + '26DailyRate, ' +
                                              FieldPrefix + '26PrintSymbol, ' + 
                                              FieldPrefix + '27ScreenSymbol, ' + 
                                              FieldPrefix + '27Desc, ' + 
                                              FieldPrefix + '27CompanyRate, ' + 
                                              FieldPrefix + '27DailyRate, ' + 
                                              FieldPrefix + '27PrintSymbol, ' + 
                                              FieldPrefix + '28ScreenSymbol, ' + 
                                              FieldPrefix + '28Desc, ' +
                                              FieldPrefix + '28CompanyRate, ' + 
                                              FieldPrefix + '28DailyRate, ' + 
                                              FieldPrefix + '28PrintSymbol, ' +
                                              FieldPrefix + '29ScreenSymbol, ' +
                                              FieldPrefix + '29Desc, ' +
                                              FieldPrefix + '29CompanyRate, ' +
                                              FieldPrefix + '29DailyRate, ' +
                                              FieldPrefix + '29PrintSymbol, ' +
                                              FieldPrefix + '30ScreenSymbol, ' +
                                              FieldPrefix + '30Desc, ' +
                                              FieldPrefix + '30CompanyRate, ' +
                                              FieldPrefix + '30DailyRate, ' +
                                              FieldPrefix + '30PrintSymbol' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':' + FieldPrefix + '00ScreenSymbol, ' +
                     ':' + FieldPrefix + '00Desc, ' +
                     ':' + FieldPrefix + '00CompanyRate, ' +
                     ':' + FieldPrefix + '00DailyRate, ' +
                     ':' + FieldPrefix + '00PrintSymbol, ' +
                     ':' + FieldPrefix + '01ScreenSymbol, ' +
                     ':' + FieldPrefix + '01Desc, ' +
                     ':' + FieldPrefix + '01CompanyRate, ' +
                     ':' + FieldPrefix + '01DailyRate, ' +
                     ':' + FieldPrefix + '01PrintSymbol, ' +
                     ':' + FieldPrefix + '02ScreenSymbol, ' +
                     ':' + FieldPrefix + '02Desc, ' +
                     ':' + FieldPrefix + '02CompanyRate, ' +
                     ':' + FieldPrefix + '02DailyRate, ' +
                     ':' + FieldPrefix + '02PrintSymbol, ' +
                     ':' + FieldPrefix + '03ScreenSymbol, ' +
                     ':' + FieldPrefix + '03Desc, ' +
                     ':' + FieldPrefix + '03CompanyRate, ' +
                     ':' + FieldPrefix + '03DailyRate, ' +
                     ':' + FieldPrefix + '03PrintSymbol, ' +
                     ':' + FieldPrefix + '04ScreenSymbol, ' +
                     ':' + FieldPrefix + '04Desc, ' +
                     ':' + FieldPrefix + '04CompanyRate, ' +
                     ':' + FieldPrefix + '04DailyRate, ' +
                     ':' + FieldPrefix + '04PrintSymbol, ' +
                     ':' + FieldPrefix + '05ScreenSymbol, ' +
                     ':' + FieldPrefix + '05Desc, ' + 
                     ':' + FieldPrefix + '05CompanyRate, ' +
                     ':' + FieldPrefix + '05DailyRate, ' +
                     ':' + FieldPrefix + '05PrintSymbol, ' + 
                     ':' + FieldPrefix + '06ScreenSymbol, ' +
                     ':' + FieldPrefix + '06Desc, ' +
                     ':' + FieldPrefix + '06CompanyRate, ' + 
                     ':' + FieldPrefix + '06DailyRate, ' + 
                     ':' + FieldPrefix + '06PrintSymbol, ' + 
                     ':' + FieldPrefix + '07ScreenSymbol, ' + 
                     ':' + FieldPrefix + '07Desc, ' + 
                     ':' + FieldPrefix + '07CompanyRate, ' +
                     ':' + FieldPrefix + '07DailyRate, ' +
                     ':' + FieldPrefix + '07PrintSymbol, ' + 
                     ':' + FieldPrefix + '08ScreenSymbol, ' + 
                     ':' + FieldPrefix + '08Desc, ' +
                     ':' + FieldPrefix + '08CompanyRate, ' + 
                     ':' + FieldPrefix + '08DailyRate, ' + 
                     ':' + FieldPrefix + '08PrintSymbol, ' +
                     ':' + FieldPrefix + '09ScreenSymbol, ' + 
                     ':' + FieldPrefix + '09Desc, ' + 
                     ':' + FieldPrefix + '09CompanyRate, ' + 
                     ':' + FieldPrefix + '09DailyRate, ' + 
                     ':' + FieldPrefix + '09PrintSymbol, ' +
                     ':' + FieldPrefix + '10ScreenSymbol, ' + 
                     ':' + FieldPrefix + '10Desc, ' + 
                     ':' + FieldPrefix + '10CompanyRate, ' + 
                     ':' + FieldPrefix + '10DailyRate, ' + 
                     ':' + FieldPrefix + '10PrintSymbol, ' + 
                     ':' + FieldPrefix + '11ScreenSymbol, ' + 
                     ':' + FieldPrefix + '11Desc, ' + 
                     ':' + FieldPrefix + '11CompanyRate, ' + 
                     ':' + FieldPrefix + '11DailyRate, ' + 
                     ':' + FieldPrefix + '11PrintSymbol, ' + 
                     ':' + FieldPrefix + '12ScreenSymbol, ' + 
                     ':' + FieldPrefix + '12Desc, ' +
                     ':' + FieldPrefix + '12CompanyRate, ' + 
                     ':' + FieldPrefix + '12DailyRate, ' + 
                     ':' + FieldPrefix + '12PrintSymbol, ' +
                     ':' + FieldPrefix + '13ScreenSymbol, ' + 
                     ':' + FieldPrefix + '13Desc, ' +
                     ':' + FieldPrefix + '13CompanyRate, ' +
                     ':' + FieldPrefix + '13DailyRate, ' + 
                     ':' + FieldPrefix + '13PrintSymbol, ' +
                     ':' + FieldPrefix + '14ScreenSymbol, ' +
                     ':' + FieldPrefix + '14Desc, ' + 
                     ':' + FieldPrefix + '14CompanyRate, ' +
                     ':' + FieldPrefix + '14DailyRate, ' + 
                     ':' + FieldPrefix + '14PrintSymbol, ' + 
                     ':' + FieldPrefix + '15ScreenSymbol, ' + 
                     ':' + FieldPrefix + '15Desc, ' +
                     ':' + FieldPrefix + '15CompanyRate, ' +
                     ':' + FieldPrefix + '15DailyRate, ' + 
                     ':' + FieldPrefix + '15PrintSymbol, ' + 
                     ':' + FieldPrefix + '16ScreenSymbol, ' +
                     ':' + FieldPrefix + '16Desc, ' +
                     ':' + FieldPrefix + '16CompanyRate, ' + 
                     ':' + FieldPrefix + '16DailyRate, ' + 
                     ':' + FieldPrefix + '16PrintSymbol, ' + 
                     ':' + FieldPrefix + '17ScreenSymbol, ' + 
                     ':' + FieldPrefix + '17Desc, ' +
                     ':' + FieldPrefix + '17CompanyRate, ' + 
                     ':' + FieldPrefix + '17DailyRate, ' + 
                     ':' + FieldPrefix + '17PrintSymbol, ' + 
                     ':' + FieldPrefix + '18ScreenSymbol, ' + 
                     ':' + FieldPrefix + '18Desc, ' +
                     ':' + FieldPrefix + '18CompanyRate, ' + 
                     ':' + FieldPrefix + '18DailyRate, ' + 
                     ':' + FieldPrefix + '18PrintSymbol, ' + 
                     ':' + FieldPrefix + '19ScreenSymbol, ' + 
                     ':' + FieldPrefix + '19Desc, ' + 
                     ':' + FieldPrefix + '19CompanyRate, ' + 
                     ':' + FieldPrefix + '19DailyRate, ' +
                     ':' + FieldPrefix + '19PrintSymbol, ' + 
                     ':' + FieldPrefix + '20ScreenSymbol, ' + 
                     ':' + FieldPrefix + '20Desc, ' + 
                     ':' + FieldPrefix + '20CompanyRate, ' + 
                     ':' + FieldPrefix + '20DailyRate, ' +
                     ':' + FieldPrefix + '20PrintSymbol, ' + 
                     ':' + FieldPrefix + '21ScreenSymbol, ' +
                     ':' + FieldPrefix + '21Desc, ' + 
                     ':' + FieldPrefix + '21CompanyRate, ' +
                     ':' + FieldPrefix + '21DailyRate, ' +
                     ':' + FieldPrefix + '21PrintSymbol, ' +
                     ':' + FieldPrefix + '22ScreenSymbol, ' + 
                     ':' + FieldPrefix + '22Desc, ' + 
                     ':' + FieldPrefix + '22CompanyRate, ' +
                     ':' + FieldPrefix + '22DailyRate, ' + 
                     ':' + FieldPrefix + '22PrintSymbol, ' +
                     ':' + FieldPrefix + '23ScreenSymbol, ' +
                     ':' + FieldPrefix + '23Desc, ' +
                     ':' + FieldPrefix + '23CompanyRate, ' + 
                     ':' + FieldPrefix + '23DailyRate, ' +
                     ':' + FieldPrefix + '23PrintSymbol, ' +
                     ':' + FieldPrefix + '24ScreenSymbol, ' + 
                     ':' + FieldPrefix + '24Desc, ' + 
                     ':' + FieldPrefix + '24CompanyRate, ' + 
                     ':' + FieldPrefix + '24DailyRate, ' +
                     ':' + FieldPrefix + '24PrintSymbol, ' + 
                     ':' + FieldPrefix + '25ScreenSymbol, ' + 
                     ':' + FieldPrefix + '25Desc, ' + 
                     ':' + FieldPrefix + '25CompanyRate, ' + 
                     ':' + FieldPrefix + '25DailyRate, ' + 
                     ':' + FieldPrefix + '25PrintSymbol, ' +
                     ':' + FieldPrefix + '26ScreenSymbol, ' +
                     ':' + FieldPrefix + '26Desc, ' +
                     ':' + FieldPrefix + '26CompanyRate, ' +
                     ':' + FieldPrefix + '26DailyRate, ' +
                     ':' + FieldPrefix + '26PrintSymbol, ' +
                     ':' + FieldPrefix + '27ScreenSymbol, ' +
                     ':' + FieldPrefix + '27Desc, ' +
                     ':' + FieldPrefix + '27CompanyRate, ' +
                     ':' + FieldPrefix + '27DailyRate, ' +
                     ':' + FieldPrefix + '27PrintSymbol, ' +
                     ':' + FieldPrefix + '28ScreenSymbol, ' +
                     ':' + FieldPrefix + '28Desc, ' +
                     ':' + FieldPrefix + '28CompanyRate, ' +
                     ':' + FieldPrefix + '28DailyRate, ' +
                     ':' + FieldPrefix + '28PrintSymbol, ' +
                     ':' + FieldPrefix + '29ScreenSymbol, ' +
                     ':' + FieldPrefix + '29Desc, ' +
                     ':' + FieldPrefix + '29CompanyRate, ' +
                     ':' + FieldPrefix + '29DailyRate, ' +
                     ':' + FieldPrefix + '29PrintSymbol, ' +
                     ':' + FieldPrefix + '30ScreenSymbol, ' +
                     ':' + FieldPrefix + '30Desc, ' +
                     ':' + FieldPrefix + '30CompanyRate, ' +
                     ':' + FieldPrefix + '30DailyRate, ' +
                     ':' + FieldPrefix + '30PrintSymbol' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Although there are multiple rows they address 2 sets of columns an there is no advantage in preparing it

  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    MainCurrency00ScreenSymbolParam := FindParam(FieldPrefix + '00ScreenSymbol');
    MainCurrency00DescParam := FindParam(FieldPrefix + '00Desc');
    MainCurrency00CompanyRateParam := FindParam(FieldPrefix + '00CompanyRate');
    MainCurrency00DailyRateParam := FindParam(FieldPrefix + '00DailyRate');
    MainCurrency00PrintSymbolParam := FindParam(FieldPrefix + '00PrintSymbol');
    MainCurrency01ScreenSymbolParam := FindParam(FieldPrefix + '01ScreenSymbol');
    MainCurrency01DescParam := FindParam(FieldPrefix + '01Desc');
    MainCurrency01CompanyRateParam := FindParam(FieldPrefix + '01CompanyRate');
    MainCurrency01DailyRateParam := FindParam(FieldPrefix + '01DailyRate');
    MainCurrency01PrintSymbolParam := FindParam(FieldPrefix + '01PrintSymbol');
    MainCurrency02ScreenSymbolParam := FindParam(FieldPrefix + '02ScreenSymbol');
    MainCurrency02DescParam := FindParam(FieldPrefix + '02Desc');
    MainCurrency02CompanyRateParam := FindParam(FieldPrefix + '02CompanyRate');
    MainCurrency02DailyRateParam := FindParam(FieldPrefix + '02DailyRate');
    MainCurrency02PrintSymbolParam := FindParam(FieldPrefix + '02PrintSymbol');
    MainCurrency03ScreenSymbolParam := FindParam(FieldPrefix + '03ScreenSymbol');
    MainCurrency03DescParam := FindParam(FieldPrefix + '03Desc');
    MainCurrency03CompanyRateParam := FindParam(FieldPrefix + '03CompanyRate');
    MainCurrency03DailyRateParam := FindParam(FieldPrefix + '03DailyRate');
    MainCurrency03PrintSymbolParam := FindParam(FieldPrefix + '03PrintSymbol');
    MainCurrency04ScreenSymbolParam := FindParam(FieldPrefix + '04ScreenSymbol');
    MainCurrency04DescParam := FindParam(FieldPrefix + '04Desc');
    MainCurrency04CompanyRateParam := FindParam(FieldPrefix + '04CompanyRate');
    MainCurrency04DailyRateParam := FindParam(FieldPrefix + '04DailyRate');
    MainCurrency04PrintSymbolParam := FindParam(FieldPrefix + '04PrintSymbol');
    MainCurrency05ScreenSymbolParam := FindParam(FieldPrefix + '05ScreenSymbol');
    MainCurrency05DescParam := FindParam(FieldPrefix + '05Desc');
    MainCurrency05CompanyRateParam := FindParam(FieldPrefix + '05CompanyRate');
    MainCurrency05DailyRateParam := FindParam(FieldPrefix + '05DailyRate');
    MainCurrency05PrintSymbolParam := FindParam(FieldPrefix + '05PrintSymbol');
    MainCurrency06ScreenSymbolParam := FindParam(FieldPrefix + '06ScreenSymbol');
    MainCurrency06DescParam := FindParam(FieldPrefix + '06Desc');
    MainCurrency06CompanyRateParam := FindParam(FieldPrefix + '06CompanyRate');
    MainCurrency06DailyRateParam := FindParam(FieldPrefix + '06DailyRate');
    MainCurrency06PrintSymbolParam := FindParam(FieldPrefix + '06PrintSymbol');
    MainCurrency07ScreenSymbolParam := FindParam(FieldPrefix + '07ScreenSymbol');
    MainCurrency07DescParam := FindParam(FieldPrefix + '07Desc');
    MainCurrency07CompanyRateParam := FindParam(FieldPrefix + '07CompanyRate');
    MainCurrency07DailyRateParam := FindParam(FieldPrefix + '07DailyRate');
    MainCurrency07PrintSymbolParam := FindParam(FieldPrefix + '07PrintSymbol');
    MainCurrency08ScreenSymbolParam := FindParam(FieldPrefix + '08ScreenSymbol');
    MainCurrency08DescParam := FindParam(FieldPrefix + '08Desc');
    MainCurrency08CompanyRateParam := FindParam(FieldPrefix + '08CompanyRate');
    MainCurrency08DailyRateParam := FindParam(FieldPrefix + '08DailyRate');
    MainCurrency08PrintSymbolParam := FindParam(FieldPrefix + '08PrintSymbol');
    MainCurrency09ScreenSymbolParam := FindParam(FieldPrefix + '09ScreenSymbol');
    MainCurrency09DescParam := FindParam(FieldPrefix + '09Desc');
    MainCurrency09CompanyRateParam := FindParam(FieldPrefix + '09CompanyRate');
    MainCurrency09DailyRateParam := FindParam(FieldPrefix + '09DailyRate');
    MainCurrency09PrintSymbolParam := FindParam(FieldPrefix + '09PrintSymbol');
    MainCurrency10ScreenSymbolParam := FindParam(FieldPrefix + '10ScreenSymbol');
    MainCurrency10DescParam := FindParam(FieldPrefix + '10Desc');
    MainCurrency10CompanyRateParam := FindParam(FieldPrefix + '10CompanyRate');
    MainCurrency10DailyRateParam := FindParam(FieldPrefix + '10DailyRate');
    MainCurrency10PrintSymbolParam := FindParam(FieldPrefix + '10PrintSymbol');
    MainCurrency11ScreenSymbolParam := FindParam(FieldPrefix + '11ScreenSymbol');
    MainCurrency11DescParam := FindParam(FieldPrefix + '11Desc');
    MainCurrency11CompanyRateParam := FindParam(FieldPrefix + '11CompanyRate');
    MainCurrency11DailyRateParam := FindParam(FieldPrefix + '11DailyRate');
    MainCurrency11PrintSymbolParam := FindParam(FieldPrefix + '11PrintSymbol');
    MainCurrency12ScreenSymbolParam := FindParam(FieldPrefix + '12ScreenSymbol');
    MainCurrency12DescParam := FindParam(FieldPrefix + '12Desc');
    MainCurrency12CompanyRateParam := FindParam(FieldPrefix + '12CompanyRate');
    MainCurrency12DailyRateParam := FindParam(FieldPrefix + '12DailyRate');
    MainCurrency12PrintSymbolParam := FindParam(FieldPrefix + '12PrintSymbol');
    MainCurrency13ScreenSymbolParam := FindParam(FieldPrefix + '13ScreenSymbol');
    MainCurrency13DescParam := FindParam(FieldPrefix + '13Desc');
    MainCurrency13CompanyRateParam := FindParam(FieldPrefix + '13CompanyRate');
    MainCurrency13DailyRateParam := FindParam(FieldPrefix + '13DailyRate');
    MainCurrency13PrintSymbolParam := FindParam(FieldPrefix + '13PrintSymbol');
    MainCurrency14ScreenSymbolParam := FindParam(FieldPrefix + '14ScreenSymbol');
    MainCurrency14DescParam := FindParam(FieldPrefix + '14Desc');
    MainCurrency14CompanyRateParam := FindParam(FieldPrefix + '14CompanyRate');
    MainCurrency14DailyRateParam := FindParam(FieldPrefix + '14DailyRate');
    MainCurrency14PrintSymbolParam := FindParam(FieldPrefix + '14PrintSymbol');
    MainCurrency15ScreenSymbolParam := FindParam(FieldPrefix + '15ScreenSymbol');
    MainCurrency15DescParam := FindParam(FieldPrefix + '15Desc');
    MainCurrency15CompanyRateParam := FindParam(FieldPrefix + '15CompanyRate');
    MainCurrency15DailyRateParam := FindParam(FieldPrefix + '15DailyRate');
    MainCurrency15PrintSymbolParam := FindParam(FieldPrefix + '15PrintSymbol');
    MainCurrency16ScreenSymbolParam := FindParam(FieldPrefix + '16ScreenSymbol');
    MainCurrency16DescParam := FindParam(FieldPrefix + '16Desc');
    MainCurrency16CompanyRateParam := FindParam(FieldPrefix + '16CompanyRate');
    MainCurrency16DailyRateParam := FindParam(FieldPrefix + '16DailyRate');
    MainCurrency16PrintSymbolParam := FindParam(FieldPrefix + '16PrintSymbol');
    MainCurrency17ScreenSymbolParam := FindParam(FieldPrefix + '17ScreenSymbol');
    MainCurrency17DescParam := FindParam(FieldPrefix + '17Desc');
    MainCurrency17CompanyRateParam := FindParam(FieldPrefix + '17CompanyRate');
    MainCurrency17DailyRateParam := FindParam(FieldPrefix + '17DailyRate');
    MainCurrency17PrintSymbolParam := FindParam(FieldPrefix + '17PrintSymbol');
    MainCurrency18ScreenSymbolParam := FindParam(FieldPrefix + '18ScreenSymbol');
    MainCurrency18DescParam := FindParam(FieldPrefix + '18Desc');
    MainCurrency18CompanyRateParam := FindParam(FieldPrefix + '18CompanyRate');
    MainCurrency18DailyRateParam := FindParam(FieldPrefix + '18DailyRate');
    MainCurrency18PrintSymbolParam := FindParam(FieldPrefix + '18PrintSymbol');
    MainCurrency19ScreenSymbolParam := FindParam(FieldPrefix + '19ScreenSymbol');
    MainCurrency19DescParam := FindParam(FieldPrefix + '19Desc');
    MainCurrency19CompanyRateParam := FindParam(FieldPrefix + '19CompanyRate');
    MainCurrency19DailyRateParam := FindParam(FieldPrefix + '19DailyRate');
    MainCurrency19PrintSymbolParam := FindParam(FieldPrefix + '19PrintSymbol');
    MainCurrency20ScreenSymbolParam := FindParam(FieldPrefix + '20ScreenSymbol');
    MainCurrency20DescParam := FindParam(FieldPrefix + '20Desc');
    MainCurrency20CompanyRateParam := FindParam(FieldPrefix + '20CompanyRate');
    MainCurrency20DailyRateParam := FindParam(FieldPrefix + '20DailyRate');
    MainCurrency20PrintSymbolParam := FindParam(FieldPrefix + '20PrintSymbol');
    MainCurrency21ScreenSymbolParam := FindParam(FieldPrefix + '21ScreenSymbol');
    MainCurrency21DescParam := FindParam(FieldPrefix + '21Desc');
    MainCurrency21CompanyRateParam := FindParam(FieldPrefix + '21CompanyRate');
    MainCurrency21DailyRateParam := FindParam(FieldPrefix + '21DailyRate');
    MainCurrency21PrintSymbolParam := FindParam(FieldPrefix + '21PrintSymbol');
    MainCurrency22ScreenSymbolParam := FindParam(FieldPrefix + '22ScreenSymbol');
    MainCurrency22DescParam := FindParam(FieldPrefix + '22Desc');
    MainCurrency22CompanyRateParam := FindParam(FieldPrefix + '22CompanyRate');
    MainCurrency22DailyRateParam := FindParam(FieldPrefix + '22DailyRate');
    MainCurrency22PrintSymbolParam := FindParam(FieldPrefix + '22PrintSymbol');
    MainCurrency23ScreenSymbolParam := FindParam(FieldPrefix + '23ScreenSymbol');
    MainCurrency23DescParam := FindParam(FieldPrefix + '23Desc');
    MainCurrency23CompanyRateParam := FindParam(FieldPrefix + '23CompanyRate');
    MainCurrency23DailyRateParam := FindParam(FieldPrefix + '23DailyRate');
    MainCurrency23PrintSymbolParam := FindParam(FieldPrefix + '23PrintSymbol');
    MainCurrency24ScreenSymbolParam := FindParam(FieldPrefix + '24ScreenSymbol');
    MainCurrency24DescParam := FindParam(FieldPrefix + '24Desc');
    MainCurrency24CompanyRateParam := FindParam(FieldPrefix + '24CompanyRate');
    MainCurrency24DailyRateParam := FindParam(FieldPrefix + '24DailyRate');
    MainCurrency24PrintSymbolParam := FindParam(FieldPrefix + '24PrintSymbol');
    MainCurrency25ScreenSymbolParam := FindParam(FieldPrefix + '25ScreenSymbol');
    MainCurrency25DescParam := FindParam(FieldPrefix + '25Desc');
    MainCurrency25CompanyRateParam := FindParam(FieldPrefix + '25CompanyRate');
    MainCurrency25DailyRateParam := FindParam(FieldPrefix + '25DailyRate');
    MainCurrency25PrintSymbolParam := FindParam(FieldPrefix + '25PrintSymbol');
    MainCurrency26ScreenSymbolParam := FindParam(FieldPrefix + '26ScreenSymbol');
    MainCurrency26DescParam := FindParam(FieldPrefix + '26Desc');
    MainCurrency26CompanyRateParam := FindParam(FieldPrefix + '26CompanyRate');
    MainCurrency26DailyRateParam := FindParam(FieldPrefix + '26DailyRate');
    MainCurrency26PrintSymbolParam := FindParam(FieldPrefix + '26PrintSymbol');
    MainCurrency27ScreenSymbolParam := FindParam(FieldPrefix + '27ScreenSymbol');
    MainCurrency27DescParam := FindParam(FieldPrefix + '27Desc');
    MainCurrency27CompanyRateParam := FindParam(FieldPrefix + '27CompanyRate');
    MainCurrency27DailyRateParam := FindParam(FieldPrefix + '27DailyRate');
    MainCurrency27PrintSymbolParam := FindParam(FieldPrefix + '27PrintSymbol');
    MainCurrency28ScreenSymbolParam := FindParam(FieldPrefix + '28ScreenSymbol');
    MainCurrency28DescParam := FindParam(FieldPrefix + '28Desc');
    MainCurrency28CompanyRateParam := FindParam(FieldPrefix + '28CompanyRate');
    MainCurrency28DailyRateParam := FindParam(FieldPrefix + '28DailyRate');
    MainCurrency28PrintSymbolParam := FindParam(FieldPrefix + '28PrintSymbol');
    MainCurrency29ScreenSymbolParam := FindParam(FieldPrefix + '29ScreenSymbol');
    MainCurrency29DescParam := FindParam(FieldPrefix + '29Desc');
    MainCurrency29CompanyRateParam := FindParam(FieldPrefix + '29CompanyRate');
    MainCurrency29DailyRateParam := FindParam(FieldPrefix + '29DailyRate');
    MainCurrency29PrintSymbolParam := FindParam(FieldPrefix + '29PrintSymbol');
    MainCurrency30ScreenSymbolParam := FindParam(FieldPrefix + '30ScreenSymbol');
    MainCurrency30DescParam := FindParam(FieldPrefix + '30Desc');
    MainCurrency30CompanyRateParam := FindParam(FieldPrefix + '30CompanyRate');
    MainCurrency30DailyRateParam := FindParam(FieldPrefix + '30DailyRate');
    MainCurrency30PrintSymbolParam := FindParam(FieldPrefix + '30PrintSymbol');
  End; // With FADOQuery.Parameters

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^ Do
  Begin
    MainCurrency00ScreenSymbolParam.Value := Currencies[0].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency00DescParam.Value := Currencies[0].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency00CompanyRateParam.Value := Currencies[0].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency00DailyRateParam.Value := Currencies[0].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency00PrintSymbolParam.Value := Currencies[0].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency01ScreenSymbolParam.Value := Currencies[1].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency01DescParam.Value := Currencies[1].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency01CompanyRateParam.Value := Currencies[1].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency01DailyRateParam.Value := Currencies[1].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency01PrintSymbolParam.Value := Currencies[1].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency02ScreenSymbolParam.Value := Currencies[2].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency02DescParam.Value := Currencies[2].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency02CompanyRateParam.Value := Currencies[2].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency02DailyRateParam.Value := Currencies[2].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency02PrintSymbolParam.Value := Currencies[2].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency03ScreenSymbolParam.Value := Currencies[3].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency03DescParam.Value := Currencies[3].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency03CompanyRateParam.Value := Currencies[3].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency03DailyRateParam.Value := Currencies[3].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency03PrintSymbolParam.Value := Currencies[3].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency04ScreenSymbolParam.Value := Currencies[4].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency04DescParam.Value := Currencies[4].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency04CompanyRateParam.Value := Currencies[4].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency04DailyRateParam.Value := Currencies[4].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency04PrintSymbolParam.Value := Currencies[4].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency05ScreenSymbolParam.Value := Currencies[5].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency05DescParam.Value := Currencies[5].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency05CompanyRateParam.Value := Currencies[5].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency05DailyRateParam.Value := Currencies[5].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency05PrintSymbolParam.Value := Currencies[5].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency06ScreenSymbolParam.Value := Currencies[6].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency06DescParam.Value := Currencies[6].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency06CompanyRateParam.Value := Currencies[6].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency06DailyRateParam.Value := Currencies[6].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency06PrintSymbolParam.Value := Currencies[6].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency07ScreenSymbolParam.Value := Currencies[7].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency07DescParam.Value := Currencies[7].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency07CompanyRateParam.Value := Currencies[7].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency07DailyRateParam.Value := Currencies[7].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency07PrintSymbolParam.Value := Currencies[7].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency08ScreenSymbolParam.Value := Currencies[8].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency08DescParam.Value := Currencies[8].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency08CompanyRateParam.Value := Currencies[8].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency08DailyRateParam.Value := Currencies[8].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency08PrintSymbolParam.Value := Currencies[8].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency09ScreenSymbolParam.Value := Currencies[9].SSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency09DescParam.Value := Currencies[9].Desc;                      // SQL=varchar, Delphi=String[11]
    MainCurrency09CompanyRateParam.Value := Currencies[9].CRates[False];      // SQL=float, Delphi=Real
    MainCurrency09DailyRateParam.Value := Currencies[9].CRates[True];         // SQL=float, Delphi=Real
    MainCurrency09PrintSymbolParam.Value := Currencies[9].PSymb;              // SQL=varchar, Delphi=String[3]
    MainCurrency10ScreenSymbolParam.Value := Currencies[10].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency10DescParam.Value := Currencies[10].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency10CompanyRateParam.Value := Currencies[10].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency10DailyRateParam.Value := Currencies[10].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency10PrintSymbolParam.Value := Currencies[10].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency11ScreenSymbolParam.Value := Currencies[11].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency11DescParam.Value := Currencies[11].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency11CompanyRateParam.Value := Currencies[11].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency11DailyRateParam.Value := Currencies[11].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency11PrintSymbolParam.Value := Currencies[11].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency12ScreenSymbolParam.Value := Currencies[12].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency12DescParam.Value := Currencies[12].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency12CompanyRateParam.Value := Currencies[12].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency12DailyRateParam.Value := Currencies[12].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency12PrintSymbolParam.Value := Currencies[12].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency13ScreenSymbolParam.Value := Currencies[13].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency13DescParam.Value := Currencies[13].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency13CompanyRateParam.Value := Currencies[13].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency13DailyRateParam.Value := Currencies[13].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency13PrintSymbolParam.Value := Currencies[13].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency14ScreenSymbolParam.Value := Currencies[14].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency14DescParam.Value := Currencies[14].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency14CompanyRateParam.Value := Currencies[14].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency14DailyRateParam.Value := Currencies[14].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency14PrintSymbolParam.Value := Currencies[14].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency15ScreenSymbolParam.Value := Currencies[15].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency15DescParam.Value := Currencies[15].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency15CompanyRateParam.Value := Currencies[15].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency15DailyRateParam.Value := Currencies[15].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency15PrintSymbolParam.Value := Currencies[15].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency16ScreenSymbolParam.Value := Currencies[16].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency16DescParam.Value := Currencies[16].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency16CompanyRateParam.Value := Currencies[16].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency16DailyRateParam.Value := Currencies[16].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency16PrintSymbolParam.Value := Currencies[16].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency17ScreenSymbolParam.Value := Currencies[17].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency17DescParam.Value := Currencies[17].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency17CompanyRateParam.Value := Currencies[17].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency17DailyRateParam.Value := Currencies[17].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency17PrintSymbolParam.Value := Currencies[17].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency18ScreenSymbolParam.Value := Currencies[18].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency18DescParam.Value := Currencies[18].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency18CompanyRateParam.Value := Currencies[18].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency18DailyRateParam.Value := Currencies[18].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency18PrintSymbolParam.Value := Currencies[18].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency19ScreenSymbolParam.Value := Currencies[19].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency19DescParam.Value := Currencies[19].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency19CompanyRateParam.Value := Currencies[19].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency19DailyRateParam.Value := Currencies[19].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency19PrintSymbolParam.Value := Currencies[19].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency20ScreenSymbolParam.Value := Currencies[20].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency20DescParam.Value := Currencies[20].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency20CompanyRateParam.Value := Currencies[20].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency20DailyRateParam.Value := Currencies[20].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency20PrintSymbolParam.Value := Currencies[20].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency21ScreenSymbolParam.Value := Currencies[21].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency21DescParam.Value := Currencies[21].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency21CompanyRateParam.Value := Currencies[21].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency21DailyRateParam.Value := Currencies[21].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency21PrintSymbolParam.Value := Currencies[21].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency22ScreenSymbolParam.Value := Currencies[22].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency22DescParam.Value := Currencies[22].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency22CompanyRateParam.Value := Currencies[22].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency22DailyRateParam.Value := Currencies[22].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency22PrintSymbolParam.Value := Currencies[22].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency23ScreenSymbolParam.Value := Currencies[23].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency23DescParam.Value := Currencies[23].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency23CompanyRateParam.Value := Currencies[23].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency23DailyRateParam.Value := Currencies[23].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency23PrintSymbolParam.Value := Currencies[23].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency24ScreenSymbolParam.Value := Currencies[24].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency24DescParam.Value := Currencies[24].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency24CompanyRateParam.Value := Currencies[24].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency24DailyRateParam.Value := Currencies[24].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency24PrintSymbolParam.Value := Currencies[24].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency25ScreenSymbolParam.Value := Currencies[25].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency25DescParam.Value := Currencies[25].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency25CompanyRateParam.Value := Currencies[25].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency25DailyRateParam.Value := Currencies[25].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency25PrintSymbolParam.Value := Currencies[25].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency26ScreenSymbolParam.Value := Currencies[26].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency26DescParam.Value := Currencies[26].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency26CompanyRateParam.Value := Currencies[26].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency26DailyRateParam.Value := Currencies[26].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency26PrintSymbolParam.Value := Currencies[26].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency27ScreenSymbolParam.Value := Currencies[27].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency27DescParam.Value := Currencies[27].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency27CompanyRateParam.Value := Currencies[27].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency27DailyRateParam.Value := Currencies[27].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency27PrintSymbolParam.Value := Currencies[27].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency28ScreenSymbolParam.Value := Currencies[28].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency28DescParam.Value := Currencies[28].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency28CompanyRateParam.Value := Currencies[28].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency28DailyRateParam.Value := Currencies[28].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency28PrintSymbolParam.Value := Currencies[28].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency29ScreenSymbolParam.Value := Currencies[29].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency29DescParam.Value := Currencies[29].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency29CompanyRateParam.Value := Currencies[29].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency29DailyRateParam.Value := Currencies[29].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency29PrintSymbolParam.Value := Currencies[29].PSymb;             // SQL=varchar, Delphi=String[3]
    MainCurrency30ScreenSymbolParam.Value := Currencies[30].SSymb;            // SQL=varchar, Delphi=String[3]
    MainCurrency30DescParam.Value := Currencies[30].Desc;                     // SQL=varchar, Delphi=String[11]
    MainCurrency30CompanyRateParam.Value := Currencies[30].CRates[False];     // SQL=float, Delphi=Real
    MainCurrency30DailyRateParam.Value := Currencies[30].CRates[True];        // SQL=float, Delphi=Real
    MainCurrency30PrintSymbolParam.Value := Currencies[30].PSymb;             // SQL=varchar, Delphi=String[3]
  End; // With DataRec^.VATRates
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_DefVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_DefVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, NamesParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'Names' +
                                              ') ' +
              'VALUES (' +
                       ':IDCode, ' +
                       ':Names' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    NamesParam := FindParam('Names');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.DefFile Do
  Begin
    // Entire array is encapsulated as a binary field
    NamesParam.Value := CreateVariantArray (@Names, SizeOf(Names));
  End; // With DataRec^.VATRates
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_JobVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_JobVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, OverheadGLParam, OverheadSpareParam, ProductionGLParam, ProductionSpareParam,
  SubContractGLParam, SubContractSpareParam, SpareGL1aParam, SpareGL1bParam,
  SpareGL2aParam, SpareGL2bParam, SpareGL3aParam, SpareGL3bParam, GenPPIParam,
  PPIAcCodeParam, SummDesc00Param, SummDesc01Param, SummDesc02Param, SummDesc03Param,
  SummDesc04Param, SummDesc05Param, SummDesc06Param, SummDesc07Param, SummDesc08Param,
  SummDesc09Param, SummDesc10Param, SummDesc11Param, SummDesc12Param, SummDesc13Param,
  SummDesc14Param, SummDesc15Param, SummDesc16Param, SummDesc17Param, SummDesc18Param,
  SummDesc19Param, SummDesc20Param, PeriodBudParam, JCChkACode1Param, JCChkACode2Param,
  JCChkACode3Param, JCChkACode4Param, JCChkACode5Param, JWKMthNoParam, JTSHNoFParam,
  JTSHNoTParam, JFNameParam, JCCommitPinParam, JAInvDateParam, JADelayCertParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'OverheadGL, ' +
                                              'OverheadSpare, ' +
                                              'ProductionGL, ' +
                                              'ProductionSpare, ' +
                                              'SubContractGL, ' +
                                              'SubContractSpare, ' +
                                              'SpareGL1a, ' +
                                              'SpareGL1b, ' +
                                              'SpareGL2a, ' +
                                              'SpareGL2b, ' +
                                              'SpareGL3a, ' +
                                              'SpareGL3b, ' +
                                              'GenPPI, ' +
                                              'PPIAcCode, ' +
                                              'SummDesc00, ' +
                                              'SummDesc01, ' +
                                              'SummDesc02, ' +
                                              'SummDesc03, ' +
                                              'SummDesc04, ' +
                                              'SummDesc05, ' +
                                              'SummDesc06, ' +
                                              'SummDesc07, ' +
                                              'SummDesc08, ' +
                                              'SummDesc09, ' +
                                              'SummDesc10, ' +
                                              'SummDesc11, ' +
                                              'SummDesc12, ' +
                                              'SummDesc13, ' +
                                              'SummDesc14, ' +
                                              'SummDesc15, ' +
                                              'SummDesc16, ' +
                                              'SummDesc17, ' +
                                              'SummDesc18, ' +
                                              'SummDesc19, ' +
                                              'SummDesc20, ' +
                                              'PeriodBud, ' +
                                              'JCChkACode1, ' +
                                              'JCChkACode2, ' +
                                              'JCChkACode3, ' +
                                              'JCChkACode4, ' +
                                              'JCChkACode5, ' +
                                              'JWKMthNo, ' +
                                              'JTSHNoF, ' +
                                              'JTSHNoT, ' +
                                              'JFName, ' +
                                              'JCCommitPin, ' +
                                              'JAInvDate, ' +
                                              'JADelayCert' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':OverheadGL, ' +
                     ':OverheadSpare, ' +
                     ':ProductionGL, ' +
                     ':ProductionSpare, ' +
                     ':SubContractGL, ' +
                     ':SubContractSpare, ' +
                     ':SpareGL1a, ' +
                     ':SpareGL1b, ' +
                     ':SpareGL2a, ' +
                     ':SpareGL2b, ' +
                     ':SpareGL3a, ' +
                     ':SpareGL3b, ' +
                     ':GenPPI, ' +
                     ':PPIAcCode, ' +
                     ':SummDesc00, ' +
                     ':SummDesc01, ' +
                     ':SummDesc02, ' +
                     ':SummDesc03, ' +
                     ':SummDesc04, ' +
                     ':SummDesc05, ' +
                     ':SummDesc06, ' +
                     ':SummDesc07, ' +
                     ':SummDesc08, ' +
                     ':SummDesc09, ' +
                     ':SummDesc10, ' +
                     ':SummDesc11, ' +
                     ':SummDesc12, ' +
                     ':SummDesc13, ' +
                     ':SummDesc14, ' +
                     ':SummDesc15, ' +
                     ':SummDesc16, ' +
                     ':SummDesc17, ' +
                     ':SummDesc18, ' +
                     ':SummDesc19, ' +
                     ':SummDesc20, ' +
                     ':PeriodBud, ' +
                     ':JCChkACode1, ' +
                     ':JCChkACode2, ' +
                     ':JCChkACode3, ' +
                     ':JCChkACode4, ' +
                     ':JCChkACode5, ' +
                     ':JWKMthNo, ' +
                     ':JTSHNoF, ' +
                     ':JTSHNoT, ' +
                     ':JFName, ' +
                     ':JCCommitPin, ' +
                     ':JAInvDate, ' +
                     ':JADelayCert' +
                     ')';
  ADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    OverheadGLParam := FindParam('OverheadGL');
    OverheadSpareParam := FindParam('OverheadSpare');
    ProductionGLParam := FindParam('ProductionGL');
    ProductionSpareParam := FindParam('ProductionSpare');
    SubContractGLParam := FindParam('SubContractGL');
    SubContractSpareParam := FindParam('SubContractSpare');
    SpareGL1aParam := FindParam('SpareGL1a');
    SpareGL1bParam := FindParam('SpareGL1b');
    SpareGL2aParam := FindParam('SpareGL2a');
    SpareGL2bParam := FindParam('SpareGL2b');
    SpareGL3aParam := FindParam('SpareGL3a');
    SpareGL3bParam := FindParam('SpareGL3b');
    GenPPIParam := FindParam('GenPPI');
    PPIAcCodeParam := FindParam('PPIAcCode');
    SummDesc00Param := FindParam('SummDesc00');
    SummDesc01Param := FindParam('SummDesc01');
    SummDesc02Param := FindParam('SummDesc02');
    SummDesc03Param := FindParam('SummDesc03');
    SummDesc04Param := FindParam('SummDesc04');
    SummDesc05Param := FindParam('SummDesc05');
    SummDesc06Param := FindParam('SummDesc06');
    SummDesc07Param := FindParam('SummDesc07');
    SummDesc08Param := FindParam('SummDesc08');
    SummDesc09Param := FindParam('SummDesc09');
    SummDesc10Param := FindParam('SummDesc10');
    SummDesc11Param := FindParam('SummDesc11');
    SummDesc12Param := FindParam('SummDesc12');
    SummDesc13Param := FindParam('SummDesc13');
    SummDesc14Param := FindParam('SummDesc14');
    SummDesc15Param := FindParam('SummDesc15');
    SummDesc16Param := FindParam('SummDesc16');
    SummDesc17Param := FindParam('SummDesc17');
    SummDesc18Param := FindParam('SummDesc18');
    SummDesc19Param := FindParam('SummDesc19');
    SummDesc20Param := FindParam('SummDesc20');
    PeriodBudParam := FindParam('PeriodBud');
    JCChkACode1Param := FindParam('JCChkACode1');
    JCChkACode2Param := FindParam('JCChkACode2');
    JCChkACode3Param := FindParam('JCChkACode3');
    JCChkACode4Param := FindParam('JCChkACode4');
    JCChkACode5Param := FindParam('JCChkACode5');
    JWKMthNoParam := FindParam('JWKMthNo');
    JTSHNoFParam := FindParam('JTSHNoF');
    JTSHNoTParam := FindParam('JTSHNoT');
    JFNameParam := FindParam('JFName');
    JCCommitPinParam := FindParam('JCCommitPin');
    JAInvDateParam := FindParam('JAInvDate');
    JADelayCertParam := FindParam('JADelayCert');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.JobSet Do
  Begin
    OverheadGLParam.Value := EmployeeNom [1, False];          // SQL=int, Delphi=LongInt
    OverheadSpareParam.Value := EmployeeNom [1, True];        // SQL=int, Delphi=LongInt
    ProductionGLParam.Value := EmployeeNom [2, False];        // SQL=int, Delphi=LongInt
    ProductionSpareParam.Value := EmployeeNom [2, True];      // SQL=int, Delphi=LongInt
    SubContractGLParam.Value := EmployeeNom [3, False];       // SQL=int, Delphi=LongInt
    SubContractSpareParam.Value := EmployeeNom [3, True];     // SQL=int, Delphi=LongInt
    SpareGL1aParam.Value := EmployeeNom [4, False];           // SQL=int, Delphi=LongInt
    SpareGL1bParam.Value := EmployeeNom [4, True];            // SQL=int, Delphi=LongInt
    SpareGL2aParam.Value := EmployeeNom [5, False];           // SQL=int, Delphi=LongInt
    SpareGL2bParam.Value := EmployeeNom [5, True];            // SQL=int, Delphi=LongInt
    SpareGL3aParam.Value := EmployeeNom [6, False];           // SQL=int, Delphi=LongInt
    SpareGL3bParam.Value := EmployeeNom [6, True];            // SQL=int, Delphi=LongInt
    GenPPIParam.Value := GenPPI;                              // SQL=bit, Delphi=Boolean
    PPIAcCodeParam.Value := PPIAcCode;                        // SQL=varchar, Delphi=String[10]
    SummDesc00Param.Value := SummDesc[0];                     // SQL=varchar, Delphi=String[20]
    SummDesc01Param.Value := SummDesc[1];                     // SQL=varchar, Delphi=String[20]
    SummDesc02Param.Value := SummDesc[2];                     // SQL=varchar, Delphi=String[20]
    SummDesc03Param.Value := SummDesc[3];                     // SQL=varchar, Delphi=String[20]
    SummDesc04Param.Value := SummDesc[4];                     // SQL=varchar, Delphi=String[20]
    SummDesc05Param.Value := SummDesc[5];                     // SQL=varchar, Delphi=String[20]
    SummDesc06Param.Value := SummDesc[6];                     // SQL=varchar, Delphi=String[20]
    SummDesc07Param.Value := SummDesc[7];                     // SQL=varchar, Delphi=String[20]
    SummDesc08Param.Value := SummDesc[8];                     // SQL=varchar, Delphi=String[20]
    SummDesc09Param.Value := SummDesc[9];                     // SQL=varchar, Delphi=String[20]
    SummDesc10Param.Value := SummDesc[10];                    // SQL=varchar, Delphi=String[20]
    SummDesc11Param.Value := SummDesc[11];                    // SQL=varchar, Delphi=String[20]
    SummDesc12Param.Value := SummDesc[12];                    // SQL=varchar, Delphi=String[20]
    SummDesc13Param.Value := SummDesc[13];                    // SQL=varchar, Delphi=String[20]
    SummDesc14Param.Value := SummDesc[14];                    // SQL=varchar, Delphi=String[20]
    SummDesc15Param.Value := SummDesc[15];                    // SQL=varchar, Delphi=String[20]
    SummDesc16Param.Value := SummDesc[16];                    // SQL=varchar, Delphi=String[20]
    SummDesc17Param.Value := SummDesc[17];                    // SQL=varchar, Delphi=String[20]
    SummDesc18Param.Value := SummDesc[18];                    // SQL=varchar, Delphi=String[20]
    SummDesc19Param.Value := SummDesc[19];                    // SQL=varchar, Delphi=String[20]
    SummDesc20Param.Value := SummDesc[20];                    // SQL=varchar, Delphi=String[20]
    PeriodBudParam.Value := PeriodBud;                        // SQL=bit, Delphi=Boolean
    JCChkACode1Param.Value := JCChkACode[1];                  // SQL=varchar, Delphi=String[10]
    JCChkACode2Param.Value := JCChkACode[2];                  // SQL=varchar, Delphi=String[10]
    JCChkACode3Param.Value := JCChkACode[3];                  // SQL=varchar, Delphi=String[10]
    JCChkACode4Param.Value := JCChkACode[4];                  // SQL=varchar, Delphi=String[10]
    JCChkACode5Param.Value := JCChkACode[5];                  // SQL=varchar, Delphi=String[10]
    JWKMthNoParam.Value := JWKMthNo;                          // SQL=int, Delphi=SmallInt
    JTSHNoFParam.Value := JTSHNoF;                            // SQL=varchar, Delphi=String[9]
    JTSHNoTParam.Value := JTSHNoT;                            // SQL=varchar, Delphi=String[9]
    JFNameParam.Value := JFName;                              // SQL=varchar, Delphi=String[30]
    JCCommitPinParam.Value := JCCommitPin;                    // SQL=bit, Delphi=Boolean
    JAInvDateParam.Value := JAInvDate;                        // SQL=bit, Delphi=Boolean
    JADelayCertParam.Value := JADelayCert;                    // SQL=bit, Delphi=Boolean
  End; // With DataRec^
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_FormDefVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'PrimaryForm001, ' +
                                              'PrimaryForm002, ' +
                                              'PrimaryForm003, ' +
                                              'PrimaryForm004, ' +
                                              'PrimaryForm005, ' +
                                              'PrimaryForm006, ' +
                                              'PrimaryForm007, ' +
                                              'PrimaryForm008, ' +
                                              'PrimaryForm009, ' +
                                              'PrimaryForm010, ' +
                                              'PrimaryForm011, ' +
                                              'PrimaryForm012, ' +
                                              'PrimaryForm013, ' +
                                              'PrimaryForm014, ' +
                                              'PrimaryForm015, ' +
                                              'PrimaryForm016, ' +
                                              'PrimaryForm017, ' +
                                              'PrimaryForm018, ' +
                                              'PrimaryForm019, ' +
                                              'PrimaryForm020, ' +
                                              'PrimaryForm021, ' +
                                              'PrimaryForm022, ' +
                                              'PrimaryForm023, ' +
                                              'PrimaryForm024, ' +
                                              'PrimaryForm025, ' +
                                              'PrimaryForm026, ' +
                                              'PrimaryForm027, ' +
                                              'PrimaryForm028, ' +
                                              'PrimaryForm029, ' +
                                              'PrimaryForm030, ' +
                                              'PrimaryForm031, ' +
                                              'PrimaryForm032, ' +
                                              'PrimaryForm033, ' +
                                              'PrimaryForm034, ' +
                                              'PrimaryForm035, ' +
                                              'PrimaryForm036, ' +
                                              'PrimaryForm037, ' +
                                              'PrimaryForm038, ' +
                                              'PrimaryForm039, ' +
                                              'PrimaryForm040, ' +
                                              'PrimaryForm041, ' +
                                              'PrimaryForm042, ' +
                                              'PrimaryForm043, ' +
                                              'PrimaryForm044, ' +
                                              'PrimaryForm045, ' +
                                              'PrimaryForm046, ' +
                                              'PrimaryForm047, ' +
                                              'PrimaryForm048, ' +
                                              'PrimaryForm049, ' +
                                              'PrimaryForm050, ' +
                                              'PrimaryForm051, ' +
                                              'PrimaryForm052, ' +
                                              'PrimaryForm053, ' +
                                              'PrimaryForm054, ' +
                                              'PrimaryForm055, ' +
                                              'PrimaryForm056, ' +
                                              'PrimaryForm057, ' +
                                              'PrimaryForm058, ' +
                                              'PrimaryForm059, ' +
                                              'PrimaryForm060, ' +
                                              'PrimaryForm061, ' +
                                              'PrimaryForm062, ' +
                                              'PrimaryForm063, ' +
                                              'PrimaryForm064, ' +
                                              'PrimaryForm065, ' +
                                              'PrimaryForm066, ' +
                                              'PrimaryForm067, ' +
                                              'PrimaryForm068, ' +
                                              'PrimaryForm069, ' +
                                              'PrimaryForm070, ' +
                                              'PrimaryForm071, ' +
                                              'PrimaryForm072, ' +
                                              'PrimaryForm073, ' +
                                              'PrimaryForm074, ' +
                                              'PrimaryForm075, ' +
                                              'PrimaryForm076, ' +
                                              'PrimaryForm077, ' +
                                              'PrimaryForm078, ' +
                                              'PrimaryForm079, ' +
                                              'PrimaryForm080, ' +
                                              'PrimaryForm081, ' +
                                              'PrimaryForm082, ' +
                                              'PrimaryForm083, ' +
                                              'PrimaryForm084, ' +
                                              'PrimaryForm085, ' +
                                              'PrimaryForm086, ' +
                                              'PrimaryForm087, ' +
                                              'PrimaryForm088, ' +
                                              'PrimaryForm089, ' +
                                              'PrimaryForm090, ' +
                                              'PrimaryForm091, ' +
                                              'PrimaryForm092, ' +
                                              'PrimaryForm093, ' +
                                              'PrimaryForm094, ' +
                                              'PrimaryForm095, ' +
                                              'PrimaryForm096, ' +
                                              'PrimaryForm097, ' +
                                              'PrimaryForm098, ' +
                                              'PrimaryForm099, ' +
                                              'PrimaryForm100, ' +
                                              'PrimaryForm101, ' +
                                              'PrimaryForm102, ' +
                                              'PrimaryForm103, ' +
                                              'PrimaryForm104, ' +
                                              'PrimaryForm105, ' +
                                              'PrimaryForm106, ' +
                                              'PrimaryForm107, ' +
                                              'PrimaryForm108, ' +
                                              'PrimaryForm109, ' +
                                              'PrimaryForm110, ' +
                                              'PrimaryForm111, ' +
                                              'PrimaryForm112, ' +
                                              'PrimaryForm113, ' +
                                              'PrimaryForm114, ' +
                                              'PrimaryForm115, ' +
                                              'PrimaryForm116, ' +
                                              'PrimaryForm117, ' +
                                              'PrimaryForm118, ' +
                                              'PrimaryForm119, ' +
                                              'PrimaryForm120, ' +
                                              'Descr' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':PrimaryForm001, ' +
                     ':PrimaryForm002, ' +
                     ':PrimaryForm003, ' +
                     ':PrimaryForm004, ' +
                     ':PrimaryForm005, ' +
                     ':PrimaryForm006, ' +
                     ':PrimaryForm007, ' +
                     ':PrimaryForm008, ' +
                     ':PrimaryForm009, ' +
                     ':PrimaryForm010, ' +
                     ':PrimaryForm011, ' +
                     ':PrimaryForm012, ' +
                     ':PrimaryForm013, ' +
                     ':PrimaryForm014, ' +
                     ':PrimaryForm015, ' +
                     ':PrimaryForm016, ' +
                     ':PrimaryForm017, ' +
                     ':PrimaryForm018, ' +
                     ':PrimaryForm019, ' +
                     ':PrimaryForm020, ' +
                     ':PrimaryForm021, ' +
                     ':PrimaryForm022, ' +
                     ':PrimaryForm023, ' +
                     ':PrimaryForm024, ' +
                     ':PrimaryForm025, ' +
                     ':PrimaryForm026, ' +
                     ':PrimaryForm027, ' +
                     ':PrimaryForm028, ' +
                     ':PrimaryForm029, ' +
                     ':PrimaryForm030, ' +
                     ':PrimaryForm031, ' +
                     ':PrimaryForm032, ' +
                     ':PrimaryForm033, ' +
                     ':PrimaryForm034, ' +
                     ':PrimaryForm035, ' +
                     ':PrimaryForm036, ' +
                     ':PrimaryForm037, ' +
                     ':PrimaryForm038, ' +
                     ':PrimaryForm039, ' +
                     ':PrimaryForm040, ' +
                     ':PrimaryForm041, ' +
                     ':PrimaryForm042, ' +
                     ':PrimaryForm043, ' +
                     ':PrimaryForm044, ' +
                     ':PrimaryForm045, ' +
                     ':PrimaryForm046, ' +
                     ':PrimaryForm047, ' +
                     ':PrimaryForm048, ' +
                     ':PrimaryForm049, ' +
                     ':PrimaryForm050, ' +
                     ':PrimaryForm051, ' +
                     ':PrimaryForm052, ' +
                     ':PrimaryForm053, ' +
                     ':PrimaryForm054, ' +
                     ':PrimaryForm055, ' +
                     ':PrimaryForm056, ' +
                     ':PrimaryForm057, ' +
                     ':PrimaryForm058, ' +
                     ':PrimaryForm059, ' +
                     ':PrimaryForm060, ' +
                     ':PrimaryForm061, ' +
                     ':PrimaryForm062, ' +
                     ':PrimaryForm063, ' +
                     ':PrimaryForm064, ' +
                     ':PrimaryForm065, ' +
                     ':PrimaryForm066, ' +
                     ':PrimaryForm067, ' +
                     ':PrimaryForm068, ' +
                     ':PrimaryForm069, ' +
                     ':PrimaryForm070, ' +
                     ':PrimaryForm071, ' +
                     ':PrimaryForm072, ' +
                     ':PrimaryForm073, ' +
                     ':PrimaryForm074, ' +
                     ':PrimaryForm075, ' +
                     ':PrimaryForm076, ' +
                     ':PrimaryForm077, ' +
                     ':PrimaryForm078, ' +
                     ':PrimaryForm079, ' +
                     ':PrimaryForm080, ' +
                     ':PrimaryForm081, ' +
                     ':PrimaryForm082, ' +
                     ':PrimaryForm083, ' +
                     ':PrimaryForm084, ' +
                     ':PrimaryForm085, ' +
                     ':PrimaryForm086, ' +
                     ':PrimaryForm087, ' +
                     ':PrimaryForm088, ' +
                     ':PrimaryForm089, ' +
                     ':PrimaryForm090, ' +
                     ':PrimaryForm091, ' +
                     ':PrimaryForm092, ' +
                     ':PrimaryForm093, ' +
                     ':PrimaryForm094, ' +
                     ':PrimaryForm095, ' +
                     ':PrimaryForm096, ' +
                     ':PrimaryForm097, ' +
                     ':PrimaryForm098, ' +
                     ':PrimaryForm099, ' +
                     ':PrimaryForm100, ' +
                     ':PrimaryForm101, ' +
                     ':PrimaryForm102, ' +
                     ':PrimaryForm103, ' +
                     ':PrimaryForm104, ' +
                     ':PrimaryForm105, ' +
                     ':PrimaryForm106, ' +
                     ':PrimaryForm107, ' +
                     ':PrimaryForm108, ' +
                     ':PrimaryForm109, ' +
                     ':PrimaryForm110, ' +
                     ':PrimaryForm111, ' +
                     ':PrimaryForm112, ' +
                     ':PrimaryForm113, ' +
                     ':PrimaryForm114, ' +
                     ':PrimaryForm115, ' +
                     ':PrimaryForm116, ' +
                     ':PrimaryForm117, ' +
                     ':PrimaryForm118, ' +
                     ':PrimaryForm119, ' +
                     ':PrimaryForm120, ' +
                     ':Descr' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    PrimaryForm001Param := FindParam('PrimaryForm001');
    PrimaryForm002Param := FindParam('PrimaryForm002');
    PrimaryForm003Param := FindParam('PrimaryForm003');
    PrimaryForm004Param := FindParam('PrimaryForm004');
    PrimaryForm005Param := FindParam('PrimaryForm005');
    PrimaryForm006Param := FindParam('PrimaryForm006');
    PrimaryForm007Param := FindParam('PrimaryForm007');
    PrimaryForm008Param := FindParam('PrimaryForm008');
    PrimaryForm009Param := FindParam('PrimaryForm009');
    PrimaryForm010Param := FindParam('PrimaryForm010');
    PrimaryForm011Param := FindParam('PrimaryForm011');
    PrimaryForm012Param := FindParam('PrimaryForm012');
    PrimaryForm013Param := FindParam('PrimaryForm013');
    PrimaryForm014Param := FindParam('PrimaryForm014');
    PrimaryForm015Param := FindParam('PrimaryForm015');
    PrimaryForm016Param := FindParam('PrimaryForm016');
    PrimaryForm017Param := FindParam('PrimaryForm017');
    PrimaryForm018Param := FindParam('PrimaryForm018');
    PrimaryForm019Param := FindParam('PrimaryForm019');
    PrimaryForm020Param := FindParam('PrimaryForm020');
    PrimaryForm021Param := FindParam('PrimaryForm021');
    PrimaryForm022Param := FindParam('PrimaryForm022');
    PrimaryForm023Param := FindParam('PrimaryForm023');
    PrimaryForm024Param := FindParam('PrimaryForm024');
    PrimaryForm025Param := FindParam('PrimaryForm025');
    PrimaryForm026Param := FindParam('PrimaryForm026');
    PrimaryForm027Param := FindParam('PrimaryForm027');
    PrimaryForm028Param := FindParam('PrimaryForm028');
    PrimaryForm029Param := FindParam('PrimaryForm029');
    PrimaryForm030Param := FindParam('PrimaryForm030');
    PrimaryForm031Param := FindParam('PrimaryForm031');
    PrimaryForm032Param := FindParam('PrimaryForm032');
    PrimaryForm033Param := FindParam('PrimaryForm033');
    PrimaryForm034Param := FindParam('PrimaryForm034');
    PrimaryForm035Param := FindParam('PrimaryForm035');
    PrimaryForm036Param := FindParam('PrimaryForm036');
    PrimaryForm037Param := FindParam('PrimaryForm037');
    PrimaryForm038Param := FindParam('PrimaryForm038');
    PrimaryForm039Param := FindParam('PrimaryForm039');
    PrimaryForm040Param := FindParam('PrimaryForm040');
    PrimaryForm041Param := FindParam('PrimaryForm041');
    PrimaryForm042Param := FindParam('PrimaryForm042');
    PrimaryForm043Param := FindParam('PrimaryForm043');
    PrimaryForm044Param := FindParam('PrimaryForm044');
    PrimaryForm045Param := FindParam('PrimaryForm045');
    PrimaryForm046Param := FindParam('PrimaryForm046');
    PrimaryForm047Param := FindParam('PrimaryForm047');
    PrimaryForm048Param := FindParam('PrimaryForm048');
    PrimaryForm049Param := FindParam('PrimaryForm049');
    PrimaryForm050Param := FindParam('PrimaryForm050');
    PrimaryForm051Param := FindParam('PrimaryForm051');
    PrimaryForm052Param := FindParam('PrimaryForm052');
    PrimaryForm053Param := FindParam('PrimaryForm053');
    PrimaryForm054Param := FindParam('PrimaryForm054');
    PrimaryForm055Param := FindParam('PrimaryForm055');
    PrimaryForm056Param := FindParam('PrimaryForm056');
    PrimaryForm057Param := FindParam('PrimaryForm057');
    PrimaryForm058Param := FindParam('PrimaryForm058');
    PrimaryForm059Param := FindParam('PrimaryForm059');
    PrimaryForm060Param := FindParam('PrimaryForm060');
    PrimaryForm061Param := FindParam('PrimaryForm061');
    PrimaryForm062Param := FindParam('PrimaryForm062');
    PrimaryForm063Param := FindParam('PrimaryForm063');
    PrimaryForm064Param := FindParam('PrimaryForm064');
    PrimaryForm065Param := FindParam('PrimaryForm065');
    PrimaryForm066Param := FindParam('PrimaryForm066');
    PrimaryForm067Param := FindParam('PrimaryForm067');
    PrimaryForm068Param := FindParam('PrimaryForm068');
    PrimaryForm069Param := FindParam('PrimaryForm069');
    PrimaryForm070Param := FindParam('PrimaryForm070');
    PrimaryForm071Param := FindParam('PrimaryForm071');
    PrimaryForm072Param := FindParam('PrimaryForm072');
    PrimaryForm073Param := FindParam('PrimaryForm073');
    PrimaryForm074Param := FindParam('PrimaryForm074');
    PrimaryForm075Param := FindParam('PrimaryForm075');
    PrimaryForm076Param := FindParam('PrimaryForm076');
    PrimaryForm077Param := FindParam('PrimaryForm077');
    PrimaryForm078Param := FindParam('PrimaryForm078');
    PrimaryForm079Param := FindParam('PrimaryForm079');
    PrimaryForm080Param := FindParam('PrimaryForm080');
    PrimaryForm081Param := FindParam('PrimaryForm081');
    PrimaryForm082Param := FindParam('PrimaryForm082');
    PrimaryForm083Param := FindParam('PrimaryForm083');
    PrimaryForm084Param := FindParam('PrimaryForm084');
    PrimaryForm085Param := FindParam('PrimaryForm085');
    PrimaryForm086Param := FindParam('PrimaryForm086');
    PrimaryForm087Param := FindParam('PrimaryForm087');
    PrimaryForm088Param := FindParam('PrimaryForm088');
    PrimaryForm089Param := FindParam('PrimaryForm089');
    PrimaryForm090Param := FindParam('PrimaryForm090');
    PrimaryForm091Param := FindParam('PrimaryForm091');
    PrimaryForm092Param := FindParam('PrimaryForm092');
    PrimaryForm093Param := FindParam('PrimaryForm093');
    PrimaryForm094Param := FindParam('PrimaryForm094');
    PrimaryForm095Param := FindParam('PrimaryForm095');
    PrimaryForm096Param := FindParam('PrimaryForm096');
    PrimaryForm097Param := FindParam('PrimaryForm097');
    PrimaryForm098Param := FindParam('PrimaryForm098');
    PrimaryForm099Param := FindParam('PrimaryForm099');
    PrimaryForm100Param := FindParam('PrimaryForm100');
    PrimaryForm101Param := FindParam('PrimaryForm101');
    PrimaryForm102Param := FindParam('PrimaryForm102');
    PrimaryForm103Param := FindParam('PrimaryForm103');
    PrimaryForm104Param := FindParam('PrimaryForm104');
    PrimaryForm105Param := FindParam('PrimaryForm105');
    PrimaryForm106Param := FindParam('PrimaryForm106');
    PrimaryForm107Param := FindParam('PrimaryForm107');
    PrimaryForm108Param := FindParam('PrimaryForm108');
    PrimaryForm109Param := FindParam('PrimaryForm109');
    PrimaryForm110Param := FindParam('PrimaryForm110');
    PrimaryForm111Param := FindParam('PrimaryForm111');
    PrimaryForm112Param := FindParam('PrimaryForm112');
    PrimaryForm113Param := FindParam('PrimaryForm113');
    PrimaryForm114Param := FindParam('PrimaryForm114');
    PrimaryForm115Param := FindParam('PrimaryForm115');
    PrimaryForm116Param := FindParam('PrimaryForm116');
    PrimaryForm117Param := FindParam('PrimaryForm117');
    PrimaryForm118Param := FindParam('PrimaryForm118');
    PrimaryForm119Param := FindParam('PrimaryForm119');
    PrimaryForm120Param := FindParam('PrimaryForm120');
    DescrParam := FindParam('Descr');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_FormDefVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.FormDefs Do
  Begin
    PrimaryForm001Param.Value := PrimaryForm[1];       // SQL=varchar, Delphi=String[8]
    PrimaryForm002Param.Value := PrimaryForm[2];       // SQL=varchar, Delphi=String[8]
    PrimaryForm003Param.Value := PrimaryForm[3];       // SQL=varchar, Delphi=String[8]
    PrimaryForm004Param.Value := PrimaryForm[4];       // SQL=varchar, Delphi=String[8]
    PrimaryForm005Param.Value := PrimaryForm[5];       // SQL=varchar, Delphi=String[8]
    PrimaryForm006Param.Value := PrimaryForm[6];       // SQL=varchar, Delphi=String[8]
    PrimaryForm007Param.Value := PrimaryForm[7];       // SQL=varchar, Delphi=String[8]
    PrimaryForm008Param.Value := PrimaryForm[8];       // SQL=varchar, Delphi=String[8]
    PrimaryForm009Param.Value := PrimaryForm[9];       // SQL=varchar, Delphi=String[8]
    PrimaryForm010Param.Value := PrimaryForm[10];      // SQL=varchar, Delphi=String[8]
    PrimaryForm011Param.Value := PrimaryForm[11];      // SQL=varchar, Delphi=String[8]
    PrimaryForm012Param.Value := PrimaryForm[12];      // SQL=varchar, Delphi=String[8]
    PrimaryForm013Param.Value := PrimaryForm[13];      // SQL=varchar, Delphi=String[8]
    PrimaryForm014Param.Value := PrimaryForm[14];      // SQL=varchar, Delphi=String[8]
    PrimaryForm015Param.Value := PrimaryForm[15];      // SQL=varchar, Delphi=String[8]
    PrimaryForm016Param.Value := PrimaryForm[16];      // SQL=varchar, Delphi=String[8]
    PrimaryForm017Param.Value := PrimaryForm[17];      // SQL=varchar, Delphi=String[8]
    PrimaryForm018Param.Value := PrimaryForm[18];      // SQL=varchar, Delphi=String[8]
    PrimaryForm019Param.Value := PrimaryForm[19];      // SQL=varchar, Delphi=String[8]
    PrimaryForm020Param.Value := PrimaryForm[20];      // SQL=varchar, Delphi=String[8]
    PrimaryForm021Param.Value := PrimaryForm[21];      // SQL=varchar, Delphi=String[8]
    PrimaryForm022Param.Value := PrimaryForm[22];      // SQL=varchar, Delphi=String[8]
    PrimaryForm023Param.Value := PrimaryForm[23];      // SQL=varchar, Delphi=String[8]
    PrimaryForm024Param.Value := PrimaryForm[24];      // SQL=varchar, Delphi=String[8]
    PrimaryForm025Param.Value := PrimaryForm[25];      // SQL=varchar, Delphi=String[8]
    PrimaryForm026Param.Value := PrimaryForm[26];      // SQL=varchar, Delphi=String[8]
    PrimaryForm027Param.Value := PrimaryForm[27];      // SQL=varchar, Delphi=String[8]
    PrimaryForm028Param.Value := PrimaryForm[28];      // SQL=varchar, Delphi=String[8]
    PrimaryForm029Param.Value := PrimaryForm[29];      // SQL=varchar, Delphi=String[8]
    PrimaryForm030Param.Value := PrimaryForm[30];      // SQL=varchar, Delphi=String[8]
    PrimaryForm031Param.Value := PrimaryForm[31];      // SQL=varchar, Delphi=String[8]
    PrimaryForm032Param.Value := PrimaryForm[32];      // SQL=varchar, Delphi=String[8]
    PrimaryForm033Param.Value := PrimaryForm[33];      // SQL=varchar, Delphi=String[8]
    PrimaryForm034Param.Value := PrimaryForm[34];      // SQL=varchar, Delphi=String[8]
    PrimaryForm035Param.Value := PrimaryForm[35];      // SQL=varchar, Delphi=String[8]
    PrimaryForm036Param.Value := PrimaryForm[36];      // SQL=varchar, Delphi=String[8]
    PrimaryForm037Param.Value := PrimaryForm[37];      // SQL=varchar, Delphi=String[8]
    PrimaryForm038Param.Value := PrimaryForm[38];      // SQL=varchar, Delphi=String[8]
    PrimaryForm039Param.Value := PrimaryForm[39];      // SQL=varchar, Delphi=String[8]
    PrimaryForm040Param.Value := PrimaryForm[40];      // SQL=varchar, Delphi=String[8]
    PrimaryForm041Param.Value := PrimaryForm[41];      // SQL=varchar, Delphi=String[8]
    PrimaryForm042Param.Value := PrimaryForm[42];      // SQL=varchar, Delphi=String[8]
    PrimaryForm043Param.Value := PrimaryForm[43];      // SQL=varchar, Delphi=String[8]
    PrimaryForm044Param.Value := PrimaryForm[44];      // SQL=varchar, Delphi=String[8]
    PrimaryForm045Param.Value := PrimaryForm[45];      // SQL=varchar, Delphi=String[8]
    PrimaryForm046Param.Value := PrimaryForm[46];      // SQL=varchar, Delphi=String[8]
    PrimaryForm047Param.Value := PrimaryForm[47];      // SQL=varchar, Delphi=String[8]
    PrimaryForm048Param.Value := PrimaryForm[48];      // SQL=varchar, Delphi=String[8]
    PrimaryForm049Param.Value := PrimaryForm[49];      // SQL=varchar, Delphi=String[8]
    PrimaryForm050Param.Value := PrimaryForm[50];      // SQL=varchar, Delphi=String[8]
    PrimaryForm051Param.Value := PrimaryForm[51];      // SQL=varchar, Delphi=String[8]
    PrimaryForm052Param.Value := PrimaryForm[52];      // SQL=varchar, Delphi=String[8]
    PrimaryForm053Param.Value := PrimaryForm[53];      // SQL=varchar, Delphi=String[8]
    PrimaryForm054Param.Value := PrimaryForm[54];      // SQL=varchar, Delphi=String[8]
    PrimaryForm055Param.Value := PrimaryForm[55];      // SQL=varchar, Delphi=String[8]
    PrimaryForm056Param.Value := PrimaryForm[56];      // SQL=varchar, Delphi=String[8]
    PrimaryForm057Param.Value := PrimaryForm[57];      // SQL=varchar, Delphi=String[8]
    PrimaryForm058Param.Value := PrimaryForm[58];      // SQL=varchar, Delphi=String[8]
    PrimaryForm059Param.Value := PrimaryForm[59];      // SQL=varchar, Delphi=String[8]
    PrimaryForm060Param.Value := PrimaryForm[60];      // SQL=varchar, Delphi=String[8]
    PrimaryForm061Param.Value := PrimaryForm[61];      // SQL=varchar, Delphi=String[8]
    PrimaryForm062Param.Value := PrimaryForm[62];      // SQL=varchar, Delphi=String[8]
    PrimaryForm063Param.Value := PrimaryForm[63];      // SQL=varchar, Delphi=String[8]
    PrimaryForm064Param.Value := PrimaryForm[64];      // SQL=varchar, Delphi=String[8]
    PrimaryForm065Param.Value := PrimaryForm[65];      // SQL=varchar, Delphi=String[8]
    PrimaryForm066Param.Value := PrimaryForm[66];      // SQL=varchar, Delphi=String[8]
    PrimaryForm067Param.Value := PrimaryForm[67];      // SQL=varchar, Delphi=String[8]
    PrimaryForm068Param.Value := PrimaryForm[68];      // SQL=varchar, Delphi=String[8]
    PrimaryForm069Param.Value := PrimaryForm[69];      // SQL=varchar, Delphi=String[8]
    PrimaryForm070Param.Value := PrimaryForm[70];      // SQL=varchar, Delphi=String[8]
    PrimaryForm071Param.Value := PrimaryForm[71];      // SQL=varchar, Delphi=String[8]
    PrimaryForm072Param.Value := PrimaryForm[72];      // SQL=varchar, Delphi=String[8]
    PrimaryForm073Param.Value := PrimaryForm[73];      // SQL=varchar, Delphi=String[8]
    PrimaryForm074Param.Value := PrimaryForm[74];      // SQL=varchar, Delphi=String[8]
    PrimaryForm075Param.Value := PrimaryForm[75];      // SQL=varchar, Delphi=String[8]
    PrimaryForm076Param.Value := PrimaryForm[76];      // SQL=varchar, Delphi=String[8]
    PrimaryForm077Param.Value := PrimaryForm[77];      // SQL=varchar, Delphi=String[8]
    PrimaryForm078Param.Value := PrimaryForm[78];      // SQL=varchar, Delphi=String[8]
    PrimaryForm079Param.Value := PrimaryForm[79];      // SQL=varchar, Delphi=String[8]
    PrimaryForm080Param.Value := PrimaryForm[80];      // SQL=varchar, Delphi=String[8]
    PrimaryForm081Param.Value := PrimaryForm[81];      // SQL=varchar, Delphi=String[8]
    PrimaryForm082Param.Value := PrimaryForm[82];      // SQL=varchar, Delphi=String[8]
    PrimaryForm083Param.Value := PrimaryForm[83];      // SQL=varchar, Delphi=String[8]
    PrimaryForm084Param.Value := PrimaryForm[84];      // SQL=varchar, Delphi=String[8]
    PrimaryForm085Param.Value := PrimaryForm[85];      // SQL=varchar, Delphi=String[8]
    PrimaryForm086Param.Value := PrimaryForm[86];      // SQL=varchar, Delphi=String[8]
    PrimaryForm087Param.Value := PrimaryForm[87];      // SQL=varchar, Delphi=String[8]
    PrimaryForm088Param.Value := PrimaryForm[88];      // SQL=varchar, Delphi=String[8]
    PrimaryForm089Param.Value := PrimaryForm[89];      // SQL=varchar, Delphi=String[8]
    PrimaryForm090Param.Value := PrimaryForm[90];      // SQL=varchar, Delphi=String[8]
    PrimaryForm091Param.Value := PrimaryForm[91];      // SQL=varchar, Delphi=String[8]
    PrimaryForm092Param.Value := PrimaryForm[92];      // SQL=varchar, Delphi=String[8]
    PrimaryForm093Param.Value := PrimaryForm[93];      // SQL=varchar, Delphi=String[8]
    PrimaryForm094Param.Value := PrimaryForm[94];      // SQL=varchar, Delphi=String[8]
    PrimaryForm095Param.Value := PrimaryForm[95];      // SQL=varchar, Delphi=String[8]
    PrimaryForm096Param.Value := PrimaryForm[96];      // SQL=varchar, Delphi=String[8]
    PrimaryForm097Param.Value := PrimaryForm[97];      // SQL=varchar, Delphi=String[8]
    PrimaryForm098Param.Value := PrimaryForm[98];      // SQL=varchar, Delphi=String[8]
    PrimaryForm099Param.Value := PrimaryForm[99];      // SQL=varchar, Delphi=String[8]
    PrimaryForm100Param.Value := PrimaryForm[100];     // SQL=varchar, Delphi=String[8]
    PrimaryForm101Param.Value := PrimaryForm[101];     // SQL=varchar, Delphi=String[8]
    PrimaryForm102Param.Value := PrimaryForm[102];     // SQL=varchar, Delphi=String[8]
    PrimaryForm103Param.Value := PrimaryForm[103];     // SQL=varchar, Delphi=String[8]
    PrimaryForm104Param.Value := PrimaryForm[104];     // SQL=varchar, Delphi=String[8]
    PrimaryForm105Param.Value := PrimaryForm[105];     // SQL=varchar, Delphi=String[8]
    PrimaryForm106Param.Value := PrimaryForm[106];     // SQL=varchar, Delphi=String[8]
    PrimaryForm107Param.Value := PrimaryForm[107];     // SQL=varchar, Delphi=String[8]
    PrimaryForm108Param.Value := PrimaryForm[108];     // SQL=varchar, Delphi=String[8]
    PrimaryForm109Param.Value := PrimaryForm[109];     // SQL=varchar, Delphi=String[8]
    PrimaryForm110Param.Value := PrimaryForm[110];     // SQL=varchar, Delphi=String[8]
    PrimaryForm111Param.Value := PrimaryForm[111];     // SQL=varchar, Delphi=String[8]
    PrimaryForm112Param.Value := PrimaryForm[112];     // SQL=varchar, Delphi=String[8]
    PrimaryForm113Param.Value := PrimaryForm[113];     // SQL=varchar, Delphi=String[8]
    PrimaryForm114Param.Value := PrimaryForm[114];     // SQL=varchar, Delphi=String[8]
    PrimaryForm115Param.Value := PrimaryForm[115];     // SQL=varchar, Delphi=String[8]
    PrimaryForm116Param.Value := PrimaryForm[116];     // SQL=varchar, Delphi=String[8]
    PrimaryForm117Param.Value := PrimaryForm[117];     // SQL=varchar, Delphi=String[8]
    PrimaryForm118Param.Value := PrimaryForm[118];     // SQL=varchar, Delphi=String[8]
    PrimaryForm119Param.Value := PrimaryForm[119];     // SQL=varchar, Delphi=String[8]
    PrimaryForm120Param.Value := PrimaryForm[120];     // SQL=varchar, Delphi=String[8]
    DescrParam.Value := Descr;                         // SQL=varchar, Delphi=Str30
  End; // With With DataRec^.FormDefs
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_ModVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_ModVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, ModuleSecParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'ModuleSec' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':ModuleSec' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    ModuleSecParam := FindParam('ModuleSec');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  // Entire array is encapsulated as a binary field
  ModuleSecParam.Value := CreateVariantArray (@DataRec^.Modules.ModuleSec, CalculateBinaryBlockSize (@DataRec^.Modules.ModuleSec, @DataRec^.Modules.Spare));
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_EuroCurrencyVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'GCR_triRates, ' +
                                              'GCR_triEuro, ' +
                                              'GCR_triInvert, ' +
                                              'GCR_triFloat' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':GCR_triRates, ' +
                     ':GCR_triEuro, ' +
                     ':GCR_triInvert, ' +
                     ':GCR_triFloat' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    GCR_triRatesParam := FindParam('GCR_triRates');
    GCR_triEuroParam := FindParam('GCR_triEuro');
    GCR_triInvertParam := FindParam('GCR_triInvert');
    GCR_triFloatParam := FindParam('GCR_triFloat');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_EuroCurrencyVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.GhostEuro Do
  Begin
    GCR_triRatesParam.Value := CreateVariantArray (@TriRates, SizeOf(TriRates));
    GCR_triEuroParam.Value := CreateVariantArray (@TriEuro, SizeOf(TriEuro));
    GCR_triInvertParam.Value := CreateVariantArray (@TriInvert, SizeOf(TriInvert));
    GCR_triFloatParam.Value := CreateVariantArray (@TriFloat, SizeOf(TriFloat));
  End; // With DataRec^.GhostEuro
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_EDI1Variant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_EDI1Variant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, VEDIMethodParam, VVanModeParam, VEDIFACTParam, VVANCEIdParam,
  VVANUIdParam, VUseCRLFParam, VTestModeParam, VDirPAthParam, VCompressParam,
  VCEEmailParam, VUEmailParam, VEPriorityParam, VESubjectParam, VSendEmailParam,
  VIEECSLPParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'VEDIMethod, ' +
                                              'VVanMode, ' +
                                              'VEDIFACT, ' +
                                              'VVANCEId, ' +
                                              'VVANUId, ' +
                                              'VUseCRLF, ' +
                                              'VTestMode, ' +
                                              'VDirPAth, ' +
                                              'VCompress, ' +
                                              'VCEEmail, ' +
                                              'VUEmail, ' +
                                              'VEPriority, ' +
                                              'VESubject, ' +
                                              'VSendEmail, ' +
                                              'VIEECSLP' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':VEDIMethod, ' +
                     ':VVanMode, ' +
                     ':VEDIFACT, ' +
                     ':VVANCEId, ' +
                     ':VVANUId, ' +
                     ':VUseCRLF, ' +
                     ':VTestMode, ' +
                     ':VDirPAth, ' +
                     ':VCompress, ' +
                     ':VCEEmail, ' +
                     ':VUEmail, ' +
                     ':VEPriority, ' +
                     ':VESubject, ' +
                     ':VSendEmail, ' +
                     ':VIEECSLP' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    VEDIMethodParam := FindParam('VEDIMethod');
    VVanModeParam := FindParam('VVanMode');
    VEDIFACTParam := FindParam('VEDIFACT');
    VVANCEIdParam := FindParam('VVANCEId');
    VVANUIdParam := FindParam('VVANUId');
    VUseCRLFParam := FindParam('VUseCRLF');
    VTestModeParam := FindParam('VTestMode');
    VDirPAthParam := FindParam('VDirPAth');
    VCompressParam := FindParam('VCompress');
    VCEEmailParam := FindParam('VCEEmail');
    VUEmailParam := FindParam('VUEmail');
    VEPriorityParam := FindParam('VEPriority');
    VESubjectParam := FindParam('VESubject');
    VSendEmailParam := FindParam('VSendEmail');
    VIEECSLPParam := FindParam('VIEECSLP');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.EDI1Defs Do
  Begin
    VEDIMethodParam.Value := VEDIMethod;            // SQL=int, Delphi=Byte
    VVanModeParam.Value := VVanMode;                // SQL=int, Delphi=Byte
    VEDIFACTParam.Value := VEDIFACT;                // SQL=int, Delphi=Byte
    VVANCEIdParam.Value := VVANCEId;                // SQL=varchar, Delphi=Str50
    VVANUIdParam.Value := VVANUId;                  // SQL=varchar, Delphi=Str50
    VUseCRLFParam.Value := VUseCRLF;                // SQL=bit, Delphi=Boolean
    VTestModeParam.Value := VTestMode;              // SQL=bit, Delphi=Boolean
    VDirPAthParam.Value := VDirPAth;                // SQL=varchar, Delphi=String[150]
    VCompressParam.Value := VCompress;              // SQL=bit, Delphi=Boolean
    VCEEmailParam.Value := VCEEmail;                // SQL=varchar, Delphi=Str255
    VUEmailParam.Value := VUEmail;                  // SQL=varchar, Delphi=Str255
    VEPriorityParam.Value := VEPriority;            // SQL=int, Delphi=Byte
    VESubjectParam.Value := VESubject;              // SQL=varchar, Delphi=Str100
    VSendEmailParam.Value := VSendEmail;            // SQL=bit, Delphi=Boolean
    VIEECSLPParam.Value := VIEECSLP;                // SQL=varchar, Delphi=String[2]
  End; // With DataRec^.EDI1Defs
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_EDI2Variant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_EDI2Variant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, EmNameParam, EmAddressParam, EmSMTPParam, EmPriorityParam,
  EmUseMAPIParam, FxUseMAPIParam, FaxPrnNParam, EmailPrnNParam, FxNameParam,
  FxPhoneParam, EmAttchModeParam, FaxDLLPathParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'EmName, ' +
                                              'EmAddress, ' +
                                              'EmSMTP, ' +
                                              'EmPriority, ' +
                                              'EmUseMAPI, ' +
                                              'FxUseMAPI, ' +
                                              'FaxPrnN, ' +
                                              'EmailPrnN, ' +
                                              'FxName, ' +
                                              'FxPhone, ' +
                                              'EmAttchMode, ' +
                                              'FaxDLLPath' +
                                              ') ' +
              'VALUES (' +
                       ':IDCode, ' +
                       ':EmName, ' +
                       ':EmAddress, ' +
                       ':EmSMTP, ' +
                       ':EmPriority, ' +
                       ':EmUseMAPI, ' +
                       ':FxUseMAPI, ' +
                       ':FaxPrnN, ' +
                       ':EmailPrnN, ' +
                       ':FxName, ' +
                       ':FxPhone, ' +
                       ':EmAttchMode, ' +
                       ':FaxDLLPath' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    EmNameParam := FindParam('EmName');
    EmAddressParam := FindParam('EmAddress');
    EmSMTPParam := FindParam('EmSMTP');
    EmPriorityParam := FindParam('EmPriority');
    EmUseMAPIParam := FindParam('EmUseMAPI');
    FxUseMAPIParam := FindParam('FxUseMAPI');
    FaxPrnNParam := FindParam('FaxPrnN');
    EmailPrnNParam := FindParam('EmailPrnN');
    FxNameParam := FindParam('FxName');
    FxPhoneParam := FindParam('FxPhone');
    EmAttchModeParam := FindParam('EmAttchMode');
    FaxDLLPathParam := FindParam('FaxDLLPath');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.EDI2Defs Do
  Begin
    EmNameParam.Value := EmName;                    // SQL=varchar, Delphi=Str255
    EmAddressParam.Value := EmAddress;              // SQL=varchar, Delphi=Str255
    EmSMTPParam.Value := EmSMTP;                    // SQL=varchar, Delphi=Str255
    EmPriorityParam.Value := EmPriority;            // SQL=int, Delphi=Byte
    EmUseMAPIParam.Value := EmUseMAPI;              // SQL=bit, Delphi=Boolean
    FxUseMAPIParam.Value := FxUseMAPI;              // SQL=int, Delphi=Byte
    FaxPrnNParam.Value := FaxPrnN;                  // SQL=varchar, Delphi=Str50
    EmailPrnNParam.Value := EmailPrnN;              // SQL=varchar, Delphi=Str50
    FxNameParam.Value := FxName;                    // SQL=varchar, Delphi=Str40
    FxPhoneParam.Value := FxPhone;                  // SQL=varchar, Delphi=Str25
    EmAttchModeParam.Value := emAttchMode;          // SQL=int, Delphi=Byte
    FaxDLLPathParam.Value := FaxDLLPath;            // SQL=varchar, Delphi=String[60]
  End; // With DataRec^.EDI2Defs
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_EDI3Variant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_EDI3Variant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); 
Var
  IDCodeParam, SpareParam : TParameter;
  DataRec : ^SysRec;
  sqlQuery : ANSIString;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'Spare' +
                                              ') ' +
              'VALUES (' +
                       ':IDCode, ' +
                       ':Spare' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    SpareParam := FindParam('Spare');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  SpareParam.Value := CreateVariantArray (@DataRec^.EDI3Defs.Spare, SizeOf(DataRec^.EDI3Defs.Spare));
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_CustomFieldsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'FCaptions, ' +
                                              'FHide' +
                                              ') ' +
              'VALUES (' +
                       ':IDCode, ' +
                       ':FCaptions, ' +
                       ':FHide' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    FCaptionsParam := FindParam('FCaptions');
    FHideParam := FindParam('FHide');
  End; // With FADOQuery.Parameters
End; // Prepare

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_CustomFieldsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.CustomFDefs Do
  Begin
    FCaptionsParam.Value := CreateVariantArray (@_fCaptions, SizeOf(_fCaptions));  // SQL=varbinary
    FHideParam.Value := CreateVariantArray (@_fHide, SizeOf(_fHide));                   // SQL=varbinary
  End; // With DataRec^.CustomFDefs
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_CISVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_CISVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, CISConstructCodeParam, CISConstructDescParam, CISConstructRateParam,
  CISConstructGLCodeParam, CISConstructDepartmentParam, CISConstructCostCentreParam,
  CISConstructSpareParam, CISTechnicalCodeParam, CISTechnicalDescParam, CISTechnicalRateParam,
  CISTechnicalGLCodeParam, CISTechnicalDepartmentParam, CISTechnicalCostCentreParam,
  CISTechnicalSpareParam, CISRate1CodeParam, CISRate1DescParam, CISRate1RateParam,
  CISRate1GLCodeParam, CISRate1DepartmentParam, CISRate1CostCentreParam,
  CISRate1SpareParam, CISRate2CodeParam, CISRate2DescParam, CISRate2RateParam,
  CISRate2GLCodeParam, CISRate2DepartmentParam, CISRate2CostCentreParam,
  CISRate2SpareParam, CISRate3CodeParam, CISRate3DescParam, CISRate3RateParam,
  CISRate3GLCodeParam, CISRate3DepartmentParam, CISRate3CostCentreParam,
  CISRate3SpareParam, CISRate4CodeParam, CISRate4DescParam, CISRate4RateParam,
  CISRate4GLCodeParam, CISRate4DepartmentParam, CISRate4CostCentreParam,
  CISRate4SpareParam, CISRate5CodeParam, CISRate5DescParam, CISRate5RateParam,
  CISRate5GLCodeParam, CISRate5DepartmentParam, CISRate5CostCentreParam,
  CISRate5SpareParam, CISRate6CodeParam, CISRate6DescParam, CISRate6RateParam,
  CISRate6GLCodeParam, CISRate6DepartmentParam, CISRate6CostCentreParam,
  CISRate6SpareParam, CISRate7CodeParam, CISRate7DescParam, CISRate7RateParam,
  CISRate7GLCodeParam, CISRate7DepartmentParam, CISRate7CostCentreParam,
  CISRate7SpareParam, CISRate8CodeParam, CISRate8DescParam, CISRate8RateParam,
  CISRate8GLCodeParam, CISRate8DepartmentParam, CISRate8CostCentreParam,
  CISRate8SpareParam, CISRate9CodeParam, CISRate9DescParam, CISRate9RateParam,
  CISRate9GLCodeParam, CISRate9DepartmentParam, CISRate9CostCentreParam,
  CISRate9SpareParam, CISIntervalParam, CISAutoSetPrParam, CISVATCodeParam,
  CISSpare3Param, CISSchemeParam, CISReturnDateParam, CISCurrPeriodParam,
  CISLoadedParam, CISTaxRefParam, CISAggModeParam, CISSortModeParam, CISVFolioParam,
  CISVouchersParam, IVANModeParam, IVANIRIdParam, IVANUIdParam, IVANPwParam,
  IIREDIRefParam, IUseCRLFParam, ITestModeParam, IDirPathParam, IEDIMethodParam,
  ISendEmailParam, IEPriorityParam, JCertNoParam, JCertExpiryParam, JCISTypeParam : TParameter;
  // MH 19/03/2014 v7.0.9 ABSEXCH-15114: Added missing CIS field
  CalcCISOnGrossParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'CISConstructCode, ' +
                                              'CISConstructDesc, ' +
                                              'CISConstructRate, ' +
                                              'CISConstructGLCode, ' +
                                              'CISConstructDepartment, ' +
                                              'CISConstructCostCentre, ' +
                                              'CISConstructSpare, ' +
                                              'CISTechnicalCode, ' +
                                              'CISTechnicalDesc, ' +
                                              'CISTechnicalRate, ' +
                                              'CISTechnicalGLCode, ' +
                                              'CISTechnicalDepartment, ' +
                                              'CISTechnicalCostCentre, ' +
                                              'CISTechnicalSpare, ' +
                                              'CISRate1Code, ' +
                                              'CISRate1Desc, ' +
                                              'CISRate1Rate, ' +
                                              'CISRate1GLCode, ' +
                                              'CISRate1Department, ' +
                                              'CISRate1CostCentre, ' +
                                              'CISRate1Spare, ' +
                                              'CISRate2Code, ' +
                                              'CISRate2Desc, ' +
                                              'CISRate2Rate, ' +
                                              'CISRate2GLCode, ' +
                                              'CISRate2Department, ' +
                                              'CISRate2CostCentre, ' +
                                              'CISRate2Spare, ' +
                                              'CISRate3Code, ' +
                                              'CISRate3Desc, ' +
                                              'CISRate3Rate, ' +
                                              'CISRate3GLCode, ' +
                                              'CISRate3Department, ' +
                                              'CISRate3CostCentre, ' +
                                              'CISRate3Spare, ' +
                                              'CISRate4Code, ' +
                                              'CISRate4Desc, ' +
                                              'CISRate4Rate, ' +
                                              'CISRate4GLCode, ' +
                                              'CISRate4Department, ' +
                                              'CISRate4CostCentre, ' +
                                              'CISRate4Spare, ' +
                                              'CISRate5Code, ' +
                                              'CISRate5Desc, ' +
                                              'CISRate5Rate, ' +
                                              'CISRate5GLCode, ' +
                                              'CISRate5Department, ' +
                                              'CISRate5CostCentre, ' +
                                              'CISRate5Spare, ' +
                                              'CISRate6Code, ' +
                                              'CISRate6Desc, ' +
                                              'CISRate6Rate, ' +
                                              'CISRate6GLCode, ' +
                                              'CISRate6Department, ' +
                                              'CISRate6CostCentre, ' +
                                              'CISRate6Spare, ' +
                                              'CISRate7Code, ' +
                                              'CISRate7Desc, ' +
                                              'CISRate7Rate, ' +
                                              'CISRate7GLCode, ' +
                                              'CISRate7Department, ' +
                                              'CISRate7CostCentre, ' +
                                              'CISRate7Spare, ' +
                                              'CISRate8Code, ' +
                                              'CISRate8Desc, ' +
                                              'CISRate8Rate, ' +
                                              'CISRate8GLCode, ' +
                                              'CISRate8Department, ' +
                                              'CISRate8CostCentre, ' +
                                              'CISRate8Spare, ' +
                                              'CISRate9Code, ' +
                                              'CISRate9Desc, ' +
                                              'CISRate9Rate, ' +
                                              'CISRate9GLCode, ' +
                                              'CISRate9Department, ' +
                                              'CISRate9CostCentre, ' +
                                              'CISRate9Spare, ' +
                                              'CISInterval, ' +
                                              'CISAutoSetPr, ' +
                                              'CISVATCode, ' +
                                              // MH 19/03/2014 v7.0.9 ABSEXCH-15114: Added missing CIS field
                                              'CalcCISOnGross, ' +
                                              'CISSpare3, ' +
                                              'CISScheme, ' +
                                              'CISReturnDate, ' +
                                              'CISCurrPeriod, ' +
                                              'CISLoaded, ' +
                                              'CISTaxRef, ' +
                                              'CISAggMode, ' +
                                              'CISSortMode, ' +
                                              'CISVFolio, ' +
                                              'CISVouchers, ' +
                                              'IVANMode, ' +
                                              'IVANIRId, ' +
                                              'IVANUId, ' +
                                              'IVANPw, ' +
                                              'IIREDIRef, ' +
                                              'IUseCRLF, ' +
                                              'ITestMode, ' +
                                              'IDirPath, ' +
                                              'IEDIMethod, ' +
                                              'ISendEmail, ' +
                                              'IEPriority, ' +
                                              'JCertNo, ' +
                                              'JCertExpiry, ' +
                                              'JCISType' +
                                              ') ' +
            'VALUES (' +
                     ':IDCode, ' +
                     ':CISConstructCode, ' +
                     ':CISConstructDesc, ' +
                     ':CISConstructRate, ' +
                     ':CISConstructGLCode, ' +
                     ':CISConstructDepartment, ' +
                     ':CISConstructCostCentre, ' +
                     ':CISConstructSpare, ' +
                     ':CISTechnicalCode, ' +
                     ':CISTechnicalDesc, ' +
                     ':CISTechnicalRate, ' +
                     ':CISTechnicalGLCode, ' +
                     ':CISTechnicalDepartment, ' +
                     ':CISTechnicalCostCentre, ' +
                     ':CISTechnicalSpare, ' +
                     ':CISRate1Code, ' +
                     ':CISRate1Desc, ' +
                     ':CISRate1Rate, ' +
                     ':CISRate1GLCode, ' +
                     ':CISRate1Department, ' +
                     ':CISRate1CostCentre, ' +
                     ':CISRate1Spare, ' +
                     ':CISRate2Code, ' +
                     ':CISRate2Desc, ' +
                     ':CISRate2Rate, ' +
                     ':CISRate2GLCode, ' +
                     ':CISRate2Department, ' +
                     ':CISRate2CostCentre, ' +
                     ':CISRate2Spare, ' +
                     ':CISRate3Code, ' +
                     ':CISRate3Desc, ' +
                     ':CISRate3Rate, ' +
                     ':CISRate3GLCode, ' +
                     ':CISRate3Department, ' +
                     ':CISRate3CostCentre, ' +
                     ':CISRate3Spare, ' +
                     ':CISRate4Code, ' +
                     ':CISRate4Desc, ' +
                     ':CISRate4Rate, ' +
                     ':CISRate4GLCode, ' +
                     ':CISRate4Department, ' +
                     ':CISRate4CostCentre, ' +
                     ':CISRate4Spare, ' +
                     ':CISRate5Code, ' +
                     ':CISRate5Desc, ' +
                     ':CISRate5Rate, ' +
                     ':CISRate5GLCode, ' +
                     ':CISRate5Department, ' +
                     ':CISRate5CostCentre, ' +
                     ':CISRate5Spare, ' +
                     ':CISRate6Code, ' +
                     ':CISRate6Desc, ' +
                     ':CISRate6Rate, ' +
                     ':CISRate6GLCode, ' +
                     ':CISRate6Department, ' +
                     ':CISRate6CostCentre, ' +
                     ':CISRate6Spare, ' +
                     ':CISRate7Code, ' +
                     ':CISRate7Desc, ' +
                     ':CISRate7Rate, ' +
                     ':CISRate7GLCode, ' +
                     ':CISRate7Department, ' +
                     ':CISRate7CostCentre, ' +
                     ':CISRate7Spare, ' +
                     ':CISRate8Code, ' +
                     ':CISRate8Desc, ' +
                     ':CISRate8Rate, ' +
                     ':CISRate8GLCode, ' +
                     ':CISRate8Department, ' +
                     ':CISRate8CostCentre, ' +
                     ':CISRate8Spare, ' +
                     ':CISRate9Code, ' +
                     ':CISRate9Desc, ' +
                     ':CISRate9Rate, ' +
                     ':CISRate9GLCode, ' +
                     ':CISRate9Department, ' +
                     ':CISRate9CostCentre, ' +
                     ':CISRate9Spare, ' +
                     ':CISInterval, ' +
                     ':CISAutoSetPr, ' +
                     ':CISVATCode, ' +
                     // MH 19/03/2014 v7.0.9 ABSEXCH-15114: Added missing CIS field
                     ':CalcCISOnGross, ' +
                     ':CISSpare3, ' +
                     ':CISScheme, ' +
                     ':CISReturnDate, ' +
                     ':CISCurrPeriod, ' +
                     ':CISLoaded, ' +
                     ':CISTaxRef, ' +
                     ':CISAggMode, ' +
                     ':CISSortMode, ' +
                     ':CISVFolio, ' +
                     ':CISVouchers, ' +
                     ':IVANMode, ' +
                     ':IVANIRId, ' +
                     ':IVANUId, ' +
                     ':IVANPw, ' +
                     ':IIREDIRef, ' +
                     ':IUseCRLF, ' +
                     ':ITestMode, ' +
                     ':IDirPath, ' +
                     ':IEDIMethod, ' +
                     ':ISendEmail, ' +
                     ':IEPriority, ' +
                     ':JCertNo, ' +
                     ':JCertExpiry, ' +
                     ':JCISType' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    CISConstructCodeParam := FindParam('CISConstructCode');
    CISConstructDescParam := FindParam('CISConstructDesc');
    CISConstructRateParam := FindParam('CISConstructRate');
    CISConstructGLCodeParam := FindParam('CISConstructGLCode');
    CISConstructDepartmentParam := FindParam('CISConstructDepartment');
    CISConstructCostCentreParam := FindParam('CISConstructCostCentre');
    CISConstructSpareParam := FindParam('CISConstructSpare');
    CISTechnicalCodeParam := FindParam('CISTechnicalCode');
    CISTechnicalDescParam := FindParam('CISTechnicalDesc');
    CISTechnicalRateParam := FindParam('CISTechnicalRate');
    CISTechnicalGLCodeParam := FindParam('CISTechnicalGLCode');
    CISTechnicalDepartmentParam := FindParam('CISTechnicalDepartment');
    CISTechnicalCostCentreParam := FindParam('CISTechnicalCostCentre');
    CISTechnicalSpareParam := FindParam('CISTechnicalSpare');
    CISRate1CodeParam := FindParam('CISRate1Code');
    CISRate1DescParam := FindParam('CISRate1Desc');
    CISRate1RateParam := FindParam('CISRate1Rate');
    CISRate1GLCodeParam := FindParam('CISRate1GLCode');
    CISRate1DepartmentParam := FindParam('CISRate1Department');
    CISRate1CostCentreParam := FindParam('CISRate1CostCentre');
    CISRate1SpareParam := FindParam('CISRate1Spare');
    CISRate2CodeParam := FindParam('CISRate2Code');
    CISRate2DescParam := FindParam('CISRate2Desc');
    CISRate2RateParam := FindParam('CISRate2Rate');
    CISRate2GLCodeParam := FindParam('CISRate2GLCode');
    CISRate2DepartmentParam := FindParam('CISRate2Department');
    CISRate2CostCentreParam := FindParam('CISRate2CostCentre');
    CISRate2SpareParam := FindParam('CISRate2Spare');
    CISRate3CodeParam := FindParam('CISRate3Code');
    CISRate3DescParam := FindParam('CISRate3Desc');
    CISRate3RateParam := FindParam('CISRate3Rate');
    CISRate3GLCodeParam := FindParam('CISRate3GLCode');
    CISRate3DepartmentParam := FindParam('CISRate3Department');
    CISRate3CostCentreParam := FindParam('CISRate3CostCentre');
    CISRate3SpareParam := FindParam('CISRate3Spare');
    CISRate4CodeParam := FindParam('CISRate4Code');
    CISRate4DescParam := FindParam('CISRate4Desc');
    CISRate4RateParam := FindParam('CISRate4Rate');
    CISRate4GLCodeParam := FindParam('CISRate4GLCode');
    CISRate4DepartmentParam := FindParam('CISRate4Department');
    CISRate4CostCentreParam := FindParam('CISRate4CostCentre');
    CISRate4SpareParam := FindParam('CISRate4Spare');
    CISRate5CodeParam := FindParam('CISRate5Code');
    CISRate5DescParam := FindParam('CISRate5Desc');
    CISRate5RateParam := FindParam('CISRate5Rate');
    CISRate5GLCodeParam := FindParam('CISRate5GLCode');
    CISRate5DepartmentParam := FindParam('CISRate5Department');
    CISRate5CostCentreParam := FindParam('CISRate5CostCentre');
    CISRate5SpareParam := FindParam('CISRate5Spare');
    CISRate6CodeParam := FindParam('CISRate6Code');
    CISRate6DescParam := FindParam('CISRate6Desc');
    CISRate6RateParam := FindParam('CISRate6Rate');
    CISRate6GLCodeParam := FindParam('CISRate6GLCode');
    CISRate6DepartmentParam := FindParam('CISRate6Department');
    CISRate6CostCentreParam := FindParam('CISRate6CostCentre');
    CISRate6SpareParam := FindParam('CISRate6Spare');
    CISRate7CodeParam := FindParam('CISRate7Code');
    CISRate7DescParam := FindParam('CISRate7Desc');
    CISRate7RateParam := FindParam('CISRate7Rate');
    CISRate7GLCodeParam := FindParam('CISRate7GLCode');
    CISRate7DepartmentParam := FindParam('CISRate7Department');
    CISRate7CostCentreParam := FindParam('CISRate7CostCentre');
    CISRate7SpareParam := FindParam('CISRate7Spare');
    CISRate8CodeParam := FindParam('CISRate8Code');
    CISRate8DescParam := FindParam('CISRate8Desc');
    CISRate8RateParam := FindParam('CISRate8Rate');
    CISRate8GLCodeParam := FindParam('CISRate8GLCode');
    CISRate8DepartmentParam := FindParam('CISRate8Department');
    CISRate8CostCentreParam := FindParam('CISRate8CostCentre');
    CISRate8SpareParam := FindParam('CISRate8Spare');
    CISRate9CodeParam := FindParam('CISRate9Code');
    CISRate9DescParam := FindParam('CISRate9Desc');
    CISRate9RateParam := FindParam('CISRate9Rate');
    CISRate9GLCodeParam := FindParam('CISRate9GLCode');
    CISRate9DepartmentParam := FindParam('CISRate9Department');
    CISRate9CostCentreParam := FindParam('CISRate9CostCentre');
    CISRate9SpareParam := FindParam('CISRate9Spare');
    CISIntervalParam := FindParam('CISInterval');
    CISAutoSetPrParam := FindParam('CISAutoSetPr');
    CISVATCodeParam := FindParam('CISVATCode');
    // MH 19/03/2014 v7.0.9 ABSEXCH-15114: Added missing CIS field
    CalcCISOnGrossParam := FindParam('CalcCISOnGross');
    CISSpare3Param := FindParam('CISSpare3');
    CISSchemeParam := FindParam('CISScheme');
    CISReturnDateParam := FindParam('CISReturnDate');
    CISCurrPeriodParam := FindParam('CISCurrPeriod');
    CISLoadedParam := FindParam('CISLoaded');
    CISTaxRefParam := FindParam('CISTaxRef');
    CISAggModeParam := FindParam('CISAggMode');
    CISSortModeParam := FindParam('CISSortMode');
    CISVFolioParam := FindParam('CISVFolio');
    CISVouchersParam := FindParam('CISVouchers');
    IVANModeParam := FindParam('IVANMode');
    IVANIRIdParam := FindParam('IVANIRId');
    IVANUIdParam := FindParam('IVANUId');
    IVANPwParam := FindParam('IVANPw');
    IIREDIRefParam := FindParam('IIREDIRef');
    IUseCRLFParam := FindParam('IUseCRLF');
    ITestModeParam := FindParam('ITestMode');
    IDirPathParam := FindParam('IDirPath');
    IEDIMethodParam := FindParam('IEDIMethod');
    ISendEmailParam := FindParam('ISendEmail');
    IEPriorityParam := FindParam('IEPriority');
    JCertNoParam := FindParam('JCertNo');
    JCertExpiryParam := FindParam('JCertExpiry');
    JCISTypeParam := FindParam('JCISType');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.CISRates Do
  Begin
    CISConstructCodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[Construct].Code);     // SQL=varchar, Delphi=Char
    CISConstructDescParam.Value := CISRate[Construct].Desc;                                      // SQL=varchar, Delphi=String[10]
    CISConstructRateParam.Value := CISRate[Construct].Rate;                                      // SQL=float, Delphi=Double
    CISConstructGLCodeParam.Value := CISRate[Construct].GLCode;                                  // SQL=int, Delphi=LongInt
    CISConstructDepartmentParam.Value := CISRate[Construct].RCCDep[False];                       // SQL=varchar, Delphi=String[3]
    CISConstructCostCentreParam.Value := CISRate[Construct].RCCDep[True];                        // SQL=varchar, Delphi=String[3]
    CISConstructSpareParam.Value := CreateVariantArray (@CISRate[Construct].Spare, SizeOf(CISRate[Construct].Spare));                     // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISTechnicalCodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[Technical].Code);     // SQL=varchar, Delphi=Char
    CISTechnicalDescParam.Value := CISRate[Technical].Desc;                                      // SQL=varchar, Delphi=String[10]
    CISTechnicalRateParam.Value := CISRate[Technical].Rate;                                      // SQL=float, Delphi=Double
    CISTechnicalGLCodeParam.Value := CISRate[Technical].GLCode;                                  // SQL=int, Delphi=LongInt
    CISTechnicalDepartmentParam.Value := CISRate[Technical].RCCDep[False];                       // SQL=varchar, Delphi=String[3]
    CISTechnicalCostCentreParam.Value := CISRate[Technical].RCCDep[True];                        // SQL=varchar, Delphi=String[3]
    CISTechnicalSpareParam.Value := CreateVariantArray (@CISRate[Technical].Spare, SizeOf(CISRate[Technical].Spare));                     // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate1CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate1].Code);          // SQL=varchar, Delphi=Char
    CISRate1DescParam.Value := CISRate[CISRate1].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate1RateParam.Value := CISRate[CISRate1].Rate;                                           // SQL=float, Delphi=Double
    CISRate1GLCodeParam.Value := CISRate[CISRate1].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate1DepartmentParam.Value := CISRate[CISRate1].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate1CostCentreParam.Value := CISRate[CISRate1].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate1SpareParam.Value := CreateVariantArray (@CISRate[CISRate1].Spare, SizeOf(CISRate[CISRate1].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate2CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate2].Code);          // SQL=varchar, Delphi=Char
    CISRate2DescParam.Value := CISRate[CISRate2].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate2RateParam.Value := CISRate[CISRate2].Rate;                                           // SQL=float, Delphi=Double
    CISRate2GLCodeParam.Value := CISRate[CISRate2].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate2DepartmentParam.Value := CISRate[CISRate2].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate2CostCentreParam.Value := CISRate[CISRate2].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate2SpareParam.Value := CreateVariantArray (@CISRate[CISRate2].Spare, SizeOf(CISRate[CISRate2].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate3CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate3].Code);          // SQL=varchar, Delphi=Char
    CISRate3DescParam.Value := CISRate[CISRate3].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate3RateParam.Value := CISRate[CISRate3].Rate;                                           // SQL=float, Delphi=Double
    CISRate3GLCodeParam.Value := CISRate[CISRate3].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate3DepartmentParam.Value := CISRate[CISRate3].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate3CostCentreParam.Value := CISRate[CISRate3].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate3SpareParam.Value := CreateVariantArray (@CISRate[CISRate3].Spare, SizeOf(CISRate[CISRate3].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate4CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate4].Code);          // SQL=varchar, Delphi=Char
    CISRate4DescParam.Value := CISRate[CISRate4].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate4RateParam.Value := CISRate[CISRate4].Rate;                                           // SQL=float, Delphi=Double
    CISRate4GLCodeParam.Value := CISRate[CISRate4].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate4DepartmentParam.Value := CISRate[CISRate4].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate4CostCentreParam.Value := CISRate[CISRate4].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate4SpareParam.Value := CreateVariantArray (@CISRate[CISRate4].Spare, SizeOf(CISRate[CISRate4].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate5CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate5].Code);          // SQL=varchar, Delphi=Char
    CISRate5DescParam.Value := CISRate[CISRate5].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate5RateParam.Value := CISRate[CISRate5].Rate;                                           // SQL=float, Delphi=Double
    CISRate5GLCodeParam.Value := CISRate[CISRate5].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate5DepartmentParam.Value := CISRate[CISRate5].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate5CostCentreParam.Value := CISRate[CISRate5].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate5SpareParam.Value := CreateVariantArray (@CISRate[CISRate5].Spare, SizeOf(CISRate[CISRate5].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate6CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate6].Code);          // SQL=varchar, Delphi=Char
    CISRate6DescParam.Value := CISRate[CISRate6].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate6RateParam.Value := CISRate[CISRate6].Rate;                                           // SQL=float, Delphi=Double
    CISRate6GLCodeParam.Value := CISRate[CISRate6].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate6DepartmentParam.Value := CISRate[CISRate6].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate6CostCentreParam.Value := CISRate[CISRate6].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate6SpareParam.Value := CreateVariantArray (@CISRate[CISRate6].Spare, SizeOf(CISRate[CISRate6].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate7CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate7].Code);          // SQL=varchar, Delphi=Char
    CISRate7DescParam.Value := CISRate[CISRate7].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate7RateParam.Value := CISRate[CISRate7].Rate;                                           // SQL=float, Delphi=Double
    CISRate7GLCodeParam.Value := CISRate[CISRate7].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate7DepartmentParam.Value := CISRate[CISRate7].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate7CostCentreParam.Value := CISRate[CISRate7].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate7SpareParam.Value := CreateVariantArray (@CISRate[CISRate7].Spare, SizeOf(CISRate[CISRate7].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate8CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate8].Code);          // SQL=varchar, Delphi=Char
    CISRate8DescParam.Value := CISRate[CISRate8].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate8RateParam.Value := CISRate[CISRate8].Rate;                                           // SQL=float, Delphi=Double
    CISRate8GLCodeParam.Value := CISRate[CISRate8].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate8DepartmentParam.Value := CISRate[CISRate8].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate8CostCentreParam.Value := CISRate[CISRate8].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate8SpareParam.Value := CreateVariantArray (@CISRate[CISRate8].Spare, SizeOf(CISRate[CISRate8].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISRate9CodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRate[CISRate9].Code);          // SQL=varchar, Delphi=Char
    CISRate9DescParam.Value := CISRate[CISRate9].Desc;                                           // SQL=varchar, Delphi=String[10]
    CISRate9RateParam.Value := CISRate[CISRate9].Rate;                                           // SQL=float, Delphi=Double
    CISRate9GLCodeParam.Value := CISRate[CISRate9].GLCode;                                       // SQL=int, Delphi=LongInt
    CISRate9DepartmentParam.Value := CISRate[CISRate9].RCCDep[False];                            // SQL=varchar, Delphi=String[3]
    CISRate9CostCentreParam.Value := CISRate[CISRate9].RCCDep[True];                             // SQL=varchar, Delphi=String[3]
    CISRate9SpareParam.Value := CreateVariantArray (@CISRate[CISRate9].Spare, SizeOf(CISRate[CISRate9].Spare));                          // SQL=varbinary, Delphi=Array[1..10] of Byte
    CISIntervalParam.Value := CISInterval;                                                       // SQL=int, Delphi=Byte
    CISAutoSetPrParam.Value := CISAutoSetPr;                                                     // SQL=bit, Delphi=Boolean
    CISVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISVATCode);                        // SQL=varchar, Delphi=Char
    // MH 19/03/2014 v7.0.9 ABSEXCH-15114: Added missing CIS field
    CalcCISOnGrossParam.Value := CalcCISOnGross;
    CISSpare3Param.Value := CreateVariantArray (@Spare3, SizeOf(Spare3));                        // SQL=varbinary, Delphi=Array[0..4] of Byte
    CISSchemeParam.Value := ConvertCharToSQLEmulatorVarChar(CISScheme);                          // SQL=varchar, Delphi=Char
    CISReturnDateParam.Value := CISReturnDate;                                                   // SQL=varchar, Delphi=LongDate
    CISCurrPeriodParam.Value := CurrPeriod;                                                      // SQL=varchar, Delphi=LongDate
    CISLoadedParam.Value := CISLoaded;                                                           // SQL=bit, Delphi=Boolean
    CISTaxRefParam.Value := CISTaxRef;                                                           // SQL=varchar, Delphi=String[20]
    CISAggModeParam.Value := CISAggMode;                                                         // SQL=int, Delphi=Byte
    CISSortModeParam.Value := CISSortMode;                                                       // SQL=int, Delphi=Byte
    CISVFolioParam.Value := CISVFolio;                                                           // SQL=int, Delphi=LongInt
    CISVouchersParam.Value := CreateVariantArray (@CISVouchers, SizeOf(CISVouchers));            // SQL=varbinary, Delphi=Binary[72]
    IVANModeParam.Value := IVANMode;                                                             // SQL=int, Delphi=Byte
    IVANIRIdParam.Value := IVANIRId;                                                             // SQL=varchar, Delphi=Str50
    IVANUIdParam.Value := IVANUId;                                                               // SQL=varchar, Delphi=Str50
    IVANPwParam.Value := IVANPw;                                                                 // SQL=varchar, Delphi=Str15
    IIREDIRefParam.Value := IIREDIRef;                                                           // SQL=varchar, Delphi=String[35]
    IUseCRLFParam.Value := IUseCRLF;                                                             // SQL=bit, Delphi=Boolean
    ITestModeParam.Value := ITestMode;                                                           // SQL=bit, Delphi=Boolean
    IDirPathParam.Value := IDirPath;                                                             // SQL=varchar, Delphi=String[150]
    IEDIMethodParam.Value := IEDIMethod;                                                         // SQL=int, Delphi=Byte
    ISendEmailParam.Value := ISendEmail;                                                         // SQL=bit, Delphi=Boolean
    IEPriorityParam.Value := IEPriority;                                                         // SQL=int, Delphi=Byte
    JCertNoParam.Value := JCertNo;                                                               // SQL=varchar, Delphi=String[20]
    JCertExpiryParam.Value := JCertExpiry;                                                       // SQL=varchar, Delphi=LongDate
    JCISTypeParam.Value := JCISType;                                                             // SQL=int, Delphi=Byte
  End; // With DataRec^.CISRates
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqSSDataWrite_CIS340Variant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TExchqSSDataWrite_CIS340Variant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  IDCodeParam, CISCNINOParam, CISCUTRParam, CISACCONoParam, IGWIRIdParam,
  IGWUIdParam, IGWTOParam, IGWIRefParam, IXMLDirPathParam, IXTestModeParam,
  IXConfEmpParam, IXVerSubParam, IXNoPayParam, IGWTRParam, IGSubTypeParam : TParameter;
  sqlQuery : ANSIString;
  DataRec : ^SysRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Setup the SQL Query
  sqlQuery := 'INSERT INTO [COMPANY].ExchqSS (' +
                                              'IDCode, ' +
                                              'CISCNINO, ' +
                                              'CISCUTR, ' +
                                              'CISACCONo, ' +
                                              'IGWIRId, ' +
                                              'IGWUId, ' +
                                              'IGWTO, ' +
                                              'IGWIRef, ' +
                                              'IXMLDirPath, ' +
                                              'IXTestMode, ' +
                                              'IXConfEmp, ' +
                                              'IXVerSub, ' +
                                              'IXNoPay, ' +
                                              'IGWTR, ' +
                                              'IGSubType' +
                                              ') ' +
              'VALUES (' +
                       ':IDCode, ' +
                       ':CISCNINO, ' +
                       ':CISCUTR, ' +
                       ':CISACCONo, ' +
                       ':IGWIRId, ' +
                       ':IGWUId, ' +
                       ':IGWTO, ' +
                       ':IGWIRef, ' +
                       ':IXMLDirPath, ' +
                       ':IXTestMode, ' +
                       ':IXConfEmp, ' +
                       ':IXVerSub, ' +
                       ':IXNoPay, ' +
                       ':IGWTR, ' +
                       ':IGSubType' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(DataPacket.CompanyDetails.ccCompanyCode) + ']', [rfReplaceAll]);

  // Note: Only 1 row so no point in preparing it

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    IDCodeParam := FindParam('IDCode');
    CISCNINOParam := FindParam('CISCNINO');
    CISCUTRParam := FindParam('CISCUTR');
    CISACCONoParam := FindParam('CISACCONo');
    IGWIRIdParam := FindParam('IGWIRId');
    IGWUIdParam := FindParam('IGWUId');
    IGWTOParam := FindParam('IGWTO');
    IGWIRefParam := FindParam('IGWIRef');
    IXMLDirPathParam := FindParam('IXMLDirPath');
    IXTestModeParam := FindParam('IXTestMode');
    IXConfEmpParam := FindParam('IXConfEmp');
    IXVerSubParam := FindParam('IXVerSub');
    IXNoPayParam := FindParam('IXNoPay');
    IGWTRParam := FindParam('IGWTR');
    IGSubTypeParam := FindParam('IGSubType');
  End; // With FADOQuery.Parameters

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  IDCodeParam.Value := CreateVariantArray (@DataRec^.IDCode, SizeOf(DataRec^.IDCode));            // SQL=varbinary, Delphi=String[3]
  With DataRec^.CIS340 Do
  Begin
    CISCNINOParam.Value := CISCNINO;                // SQL=varchar, Delphi=String[20]
    CISCUTRParam.Value := CISCUTR;                  // SQL=varchar, Delphi=String[20]
    CISACCONoParam.Value := CISACCONo;              // SQL=varchar, Delphi=String[20]
    IGWIRIdParam.Value := IGWIRId;                  // SQL=varchar, Delphi=Str50
    IGWUIdParam.Value := IGWUId;                    // SQL=varchar, Delphi=Str50
    IGWTOParam.Value := IGWTO;                      // SQL=varchar, Delphi=Str15
    IGWIRefParam.Value := IGWIRef;                  // SQL=varchar, Delphi=String[35]
    IXMLDirPathParam.Value := IXMLDirPath;          // SQL=varchar, Delphi=String[150]
    IXTestModeParam.Value := IXTestMode;            // SQL=bit, Delphi=Boolean
    IXConfEmpParam.Value := IXConfEmp;              // SQL=bit, Delphi=Boolean
    IXVerSubParam.Value := IXVerSub;                // SQL=bit, Delphi=Boolean
    IXNoPayParam.Value := IXNoPay;                  // SQL=bit, Delphi=Boolean
    IGWTRParam.Value := IGWTR;                      // SQL=varchar, Delphi=Str10
    IGSubTypeParam.Value := IGSubType;              // SQL=int, Delphi=Byte
  End; // With DataRec^.CIS340
End; // SetQueryValues

//=========================================================================

End.


