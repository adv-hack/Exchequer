Unit oJobCtrlDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  //Base budget class - covers Stock and TimeRate budgets which are still in JobCtrl. Analysis and Totals have
  //been moved to normalised files, so are handled by descendants of this class.
  TJobCtrlDataWrite_JobBudgetVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPfixParam, SubTypeParam, var_code1Param, SpareParam, var_code2Param,

    // Variant specific fields
    AnalCodeParam, HistFolioParam, JobCodeParam, StockCodeParam, BTypeParam,
    ReChargeParam, OverCostParam, UnitPriceParam, BoQtyParam, BRQtyParam,
    BoValueParam, BRValueParam, CurrBudgParam, PayRModeParam, CurrPTypeParam,
    AnalHedParam, OrigValuationParam, RevValuationParam, JBUpliftPParam,
    JAPcntAppParam, JABBasisParam, JBudgetCurrParam : TParameter;
  protected
    //Start of the query - different in each of the budget types
    FStartQuery : string;

    //Start of the parameters clause of the query - different in each of the budget types
    FStartParams : string;

    //Procedure to set Prefix, SubType and index parameters - not needed for normalised files,
    //so in the descendant objects we override it to do nothing
    procedure SetBaseParameters(Const DataPacket : TDataPacket); virtual;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;

    constructor Create;
  End; // TJobCtrlDataWrite_JobBudgetVariant

  //------------------------------

  //Analysis Budgets - in a normalised table
  TJobCtrlDataWrite_AnalysisJobBudgetVariant = Class(TJobCtrlDataWrite_JobBudgetVariant)
  protected
    procedure SetBaseParameters(Const DataPacket : TDataPacket); override;
  public
    Constructor Create;
  end;

  //------------------------------

  //Totals Budgets - in a normalised table
  TJobCtrlDataWrite_TotalsJobBudgetVariant = Class(TJobCtrlDataWrite_JobBudgetVariant)
  protected
    procedure SetBaseParameters(Const DataPacket : TDataPacket); override;
  public
    Constructor Create;
  end;


  //------------------------------

  TJobCtrlDataWrite_EmployeeVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common Fields
    RecPfixParam, SubTypeParam, var_code1Param, SpareParam, var_code2Param,
    // Variant specific fields
    EAnalCodeParam, EmpCodeParam, EStockCodeParam, PayRDescParam, CostParam, ChargeOutParam,
    CostCurrParam, ChargeCurrParam, PayRFactParam, PayRRateParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobCtrlDataWrite_EmployeeVariant

  //------------------------------

  TJobCtrlDataWrite = Class(TBaseDataWrite)
  Private
    FJobBudgetVariant : TJobCtrlDataWrite_JobBudgetVariant;
    FAnalysisJobBudgetVariant : TJobCtrlDataWrite_AnalysisJobBudgetVariant;
    FTotalsJobBudgetVariant  : TJobCtrlDataWrite_TotalsJobBudgetVariant;
    FEmployeeVariant : TJobCtrlDataWrite_EmployeeVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobCtrlDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TJobCtrlDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FJobBudgetVariant := TJobCtrlDataWrite_JobBudgetVariant.Create;

  FAnalysisJobBudgetVariant := TJobCtrlDataWrite_AnalysisJobBudgetVariant.Create;
  FTotalsJobBudgetVariant  := TJobCtrlDataWrite_TotalsJobBudgetVariant.Create;

  FEmployeeVariant := TJobCtrlDataWrite_EmployeeVariant.Create;
End; // Create


Destructor TJobCtrlDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FJobBudgetVariant);

  FreeAndNIL(FAnalysisJobBudgetVariant);
  FreeAndNIL(FTotalsJobBudgetVariant);

  FreeAndNIL(FEmployeeVariant);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobCtrlDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FJobBudgetVariant.Prepare (ADOConnection, CompanyCode);

  FAnalysisJobBudgetVariant.Prepare (ADOConnection, CompanyCode);
  FTotalsJobBudgetVariant.Prepare (ADOConnection, CompanyCode);

  FEmployeeVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobCtrlDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobCtrlPtr;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'S') Then
  Begin
    // JobBudg - JobBudgType - Job Budget Records (Stock and Time rate)
    FJobBudgetVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End //If (DataRec.RecPFix = 'J') And (DataRec.SubType In ['B', 'M', 'S'])
  Else If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'B') Then
  Begin
    // JobBudg - JobBudgType - Job Budget Records  (Analysis)
    FAnalysisJobBudgetVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End //If (DataRec.RecPFix = 'J') And (DataRec.SubType In ['B', 'M', 'S'])
  Else If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'M') Then
  Begin
    // JobBudg - JobBudgType - Job Budget Records  (Totals)
    FTotalsJobBudgetVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End //If (DataRec.RecPFix = 'J') And (DataRec.SubType In ['B', 'M', 'S'])
  Else If (DataRec.RecPFix = 'J') And (DataRec.SubType in ['E', 'R']) Then
  Begin
    // EmplPay - EmplPayType - Employee records
    FEmployeeVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'J') And (DataRec.SubType in ['E', 'R'])
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
constructor TJobCtrlDataWrite_JobBudgetVariant.Create;
begin
  inherited;
  FStartQuery := 'INSERT INTO [COMPANY].JobCtrl (' +
                                              'RecPfix, ' +
                                              'SubType, ' +
                                              'var_code1, ' +
                                              'Spare, ' +
                                              'var_code2, ';
  FStartParams :=      ':RecPfix, ' +
                       ':SubType, ' +
                       ':var_code1, ' +
                       ':Spare, ' +
                       ':var_code2, ';

end;

Procedure TJobCtrlDataWrite_JobBudgetVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := FStartQuery +
                                              'AnalCode, ' + 
                                              'HistFolio, ' + 
                                              'JobCode, ' + 
                                              'StockCode, ' + 
                                              'BType, ' + 
                                              'ReCharge, ' + 
                                              'OverCost, ' + 
                                              'UnitPrice, ' +
                                              'BoQty, ' + 
                                              'BRQty, ' + 
                                              'BoValue, ' + 
                                              'BRValue, ' + 
                                              'CurrBudg, ' +
                                              'PayRMode, ' +
                                              'CurrPType, ' + 
                                              'AnalHed, ' + 
                                              'OrigValuation, ' + 
                                              'RevValuation, ' + 
                                              'JBUpliftP, ' + 
                                              'JAPcntApp, ' +
                                              'JABBasis, ' + 
                                              'JBudgetCurr ' +
                                              ') ' +
              'VALUES (' + FStartParams +
                       ':AnalCode, ' +
                       ':HistFolio, ' +
                       ':JobCode, ' +
                       ':StockCode, ' +
                       ':BType, ' +
                       ':ReCharge, ' +
                       ':OverCost, ' +
                       ':UnitPrice, ' +
                       ':BoQty, ' +
                       ':BRQty, ' +
                       ':BoValue, ' +
                       ':BRValue, ' +
                       ':CurrBudg, ' +
                       ':PayRMode, ' +
                       ':CurrPType, ' +
                       ':AnalHed, ' +
                       ':OrigValuation, ' +
                       ':RevValuation, ' +
                       ':JBUpliftP, ' +
                       ':JAPcntApp, ' +
                       ':JABBasis, ' +
                       ':JBudgetCurr ' +
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
    var_code1Param := FindParam('var_code1');
    SpareParam := FindParam('Spare');
    var_code2Param := FindParam('var_code2');

    AnalCodeParam := FindParam('AnalCode');
    HistFolioParam := FindParam('HistFolio');
    JobCodeParam := FindParam('JobCode');
    StockCodeParam := FindParam('StockCode');
    BTypeParam := FindParam('BType');
    ReChargeParam := FindParam('ReCharge');
    OverCostParam := FindParam('OverCost');
    UnitPriceParam := FindParam('UnitPrice');
    BoQtyParam := FindParam('BoQty');
    BRQtyParam := FindParam('BRQty');
    BoValueParam := FindParam('BoValue');
    BRValueParam := FindParam('BRValue');
    CurrBudgParam := FindParam('CurrBudg');
    PayRModeParam := FindParam('PayRMode');
    CurrPTypeParam := FindParam('CurrPType');
    AnalHedParam := FindParam('AnalHed');
    OrigValuationParam := FindParam('OrigValuation');
    RevValuationParam := FindParam('RevValuation');
    JBUpliftPParam := FindParam('JBUpliftP');
    JAPcntAppParam := FindParam('JAPcntApp');
    JABBasisParam := FindParam('JABBasis');
    JBudgetCurrParam := FindParam('JBudgetCurr');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
procedure TJobCtrlDataWrite_JobBudgetVariant.SetBaseParameters(const DataPacket: TDataPacket);
Var
  DataRec : JobCtrlPtr;
Begin // SetQueryValues

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, JobBudg Do
  Begin
    //PFix & SubType - not needed in normalised tables
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                       // SQL=varchar, Delphi=Char

    //Index fields - not needed in normalised tables
    var_code1Param.Value := CreateVariantArray (@BudgetCode, SizeOf(BudgetCode));// SQL=varbinary, Delphi=String[27]
    SpareParam.Value := CreateVariantArray (@Spare, SizeOf(Spare));        // SQL=varbinary, Delphi=Array[1..4] of Byte
    var_code2Param.Value := CreateVariantArray (@Code2Ndx, SizeOf(Code2Ndx));// SQL=varbinary, Delphi=String[21]
  end;
end;

Procedure TJobCtrlDataWrite_JobBudgetVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobCtrlPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  //Set Prefix, SubType and index parameters
  SetBaseParameters(Datapacket);

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, JobBudg Do
  Begin

    //Other fields
    AnalCodeParam.Value := AnalCode;                                                      // SQL=varchar, Delphi=String[10]
    HistFolioParam.Value := HistFolio;                                                    // SQL=int, Delphi=LongInt
    JobCodeParam.Value := JobCode;                                                        // SQL=varchar, Delphi=String[10]
    StockCodeParam.Value := StockCode;                                                    // SQL=varchar, Delphi=String[20]
    BTypeParam.Value := BType;                                                            // SQL=int, Delphi=Byte
    ReChargeParam.Value := ReCharge;                                                      // SQL=bit, Delphi=Boolean
    OverCostParam.Value := OverCost;                                                      // SQL=float, Delphi=Double
    UnitPriceParam.Value := UnitPrice;                                                    // SQL=float, Delphi=Double
    BoQtyParam.Value := BoQty;                                                            // SQL=float, Delphi=Double
    BRQtyParam.Value := BRQty;                                                            // SQL=float, Delphi=Double
    BoValueParam.Value := BoValue;                                                        // SQL=float, Delphi=Double
    BRValueParam.Value := BRValue;                                                        // SQL=float, Delphi=Double
    CurrBudgParam.Value := CurrBudg;                                                      // SQL=int, Delphi=Byte
    PayRModeParam.Value := PayRMode;                                                      // SQL=bit, Delphi=Boolean
    CurrPTypeParam.Value := CurrPType;                                                    // SQL=int, Delphi=Byte
    AnalHedParam.Value := AnalHed;                                                        // SQL=int, Delphi=Byte
    OrigValuationParam.Value := OrigValuation;                                            // SQL=float, Delphi=Double
    RevValuationParam.Value := RevValuation;                                              // SQL=float, Delphi=Double
    JBUpliftPParam.Value := JBUpliftP;                                                    // SQL=float, Delphi=Double
    JAPcntAppParam.Value := JAPcntApp;                                                    // SQL=float, Delphi=Double
    JABBasisParam.Value := JABBasis;                                                      // SQL=int, Delphi=Byte
    JBudgetCurrParam.Value := JBudgetCurr;                                                // SQL=int, Delphi=Byte
  End; // With DataRec^.PassEntryRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobCtrlDataWrite_EmployeeVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JobCtrl (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'var_code1, ' + 
                                              'Spare, ' + 
                                              'var_code2, ' + 
                                              'EAnalCode, ' +
                                              'EmpCode, ' +
                                              'EStockCode, ' +
                                              'PayRDesc, ' +
                                              'Cost, ' +
                                              'ChargeOut, ' +
                                              'CostCurr, ' +
                                              'ChargeCurr, ' +
                                              'PayRFact, ' +
                                              'PayRRate' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':var_code1, ' +
                       ':Spare, ' +
                       ':var_code2, ' +
                       ':EAnalCode, ' +
                       ':EmpCode, ' + 
                       ':EStockCode, ' + 
                       ':PayRDesc, ' + 
                       ':Cost, ' + 
                       ':ChargeOut, ' + 
                       ':CostCurr, ' + 
                       ':ChargeCurr, ' + 
                       ':PayRFact, ' + 
                       ':PayRRate' + 
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
    var_code1Param := FindParam('var_code1');
    SpareParam := FindParam('Spare');
    var_code2Param := FindParam('var_code2');

    EAnalCodeParam := FindParam('EAnalCode');
    EmpCodeParam := FindParam('EmpCode');
    EStockCodeParam := FindParam('EStockCode');
    PayRDescParam := FindParam('PayRDesc');
    CostParam := FindParam('Cost');
    ChargeOutParam := FindParam('ChargeOut');
    CostCurrParam := FindParam('CostCurr');
    ChargeCurrParam := FindParam('ChargeCurr');
    PayRFactParam := FindParam('PayRFact');
    PayRRateParam := FindParam('PayRRate');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobCtrlDataWrite_EmployeeVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobCtrlPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the system setup properties into the parameters for the INSERT
  With DataRec^, EmplPay Do
  Begin
    //PFix & SubType
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                       // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                       // SQL=varchar, Delphi=Char

    //Index fields
    var_code1Param.Value := CreateVariantArray (@EmplCode, SizeOf(EmplCode));// SQL=varbinary, Delphi=String[27]
    SpareParam.Value := CreateVariantArray (@Spare, SizeOf(Spare));        // SQL=varbinary, Delphi=Array[1..4] of Byte
    var_code2Param.Value := CreateVariantArray (@ECodeNdx, SizeOf(ECodeNdx));// SQL=varbinary, Delphi=String[21]


    EAnalCodeParam.Value := EAnalCode;                                                    // SQL=varchar, Delphi=String[10]
    EmpCodeParam.Value := EmpCode;                                                        // SQL=varchar, Delphi=String[10]
    EStockCodeParam.Value := EStockCode;                                                  // SQL=varchar, Delphi=String[20]
    PayRDescParam.Value := PayRDesc;                                                      // SQL=varchar, Delphi=String[30]
    CostParam.Value := Cost;                                                              // SQL=float, Delphi=Double
    ChargeOutParam.Value := ChargeOut;                                                    // SQL=float, Delphi=Double
    CostCurrParam.Value := CostCurr;                                                      // SQL=int, Delphi=Byte
    ChargeCurrParam.Value := ChargeCurr;                                                  // SQL=int, Delphi=Byte
    PayRFactParam.Value := PayRFact;                                                      // SQL=int, Delphi=SmallInt
    PayRRateParam.Value := PayRRate;                                                      // SQL=int, Delphi=SmallInt
  End; // With DataRec^, PassEntryRec
End; // SetQueryValues

//=========================================================================


{ TJobCtrlDataWrite_AnalysisJobBudgetVariant }

constructor TJobCtrlDataWrite_AnalysisJobBudgetVariant.Create;
begin
  inherited;
  FStartQuery := 'INSERT INTO [COMPANY].AnalysisCodeBudget (';
  FStartParams := '';
end;

procedure TJobCtrlDataWrite_AnalysisJobBudgetVariant.SetBaseParameters(const DataPacket: TDataPacket);
begin
  //Do nothing
end;

{ TJobCtrlDataWrite_TotalsJobBudgetVariant }

constructor TJobCtrlDataWrite_TotalsJobBudgetVariant.Create;
begin
  inherited;
  FStartQuery := 'INSERT INTO [COMPANY].JobTotalsBudget (';
  FStartParams := '';
end;

procedure TJobCtrlDataWrite_TotalsJobBudgetVariant.SetBaseParameters(const DataPacket: TDataPacket);
begin
  //Do nothing
end;

End.

               {056}  AnalCode     :  String[10];   {  Link to Anal Record }
               {066}  HistFolio    :  LongInt;      {  Anal Folio Number for History }

               {071}  JobCode      :  String[10];   {  Parent JobCode }
               {082}  StockCode    :  String[20];   {  Optional Stock Code}
               {102}  BType        :  Byte;         {  Relates to R/O/L/M }
               {103}  ReCharge     :  Boolean;      {  Charge Item On }
               {104}  OverCost     :  Double;       {  Overhead on Cost }
               {112}  UnitPrice    :  Double;       {  Charging Price }
               {120}  BoQty        :  Double;       {  Original Qty }
               {128}  BRQty        :  Double;       {  RevisedQty }
               {136}  BoValue      :  Double;       {  Original Value }
               {144}  BRValue      :  Double;       {  Revised Value }
               {152}  CurrBudg     :  Byte;         {  Budget Currency Not used - forms part of index}
               {153}  PayRMode     :  Boolean;      {  PayRate Mode }
               {154}  CurrPType    :  Byte;         {  PayRate Currency }
               {155}  AnalHed      :  Byte;         {  Major Heading Type 1-10 }

                 {156}  OrigValuation :  Double;       {Initial valuation}
                 {164}  RevValuation :  Double;       {Revised valaution}

                 {172}  JBUpliftP:  Double;       {Uplift override}

                 {180}  JAPcntApp:  Double;       {% of budget to be applied for on next valuation}
                 {188}  JABBasis :  Byte;         {Basis of valuation. 0 = incremental. 1 = Gross/YTD}



                   {189}  JBudgetCurr :  Byte;       {  Budget Currency of Original and Revised budgets }

