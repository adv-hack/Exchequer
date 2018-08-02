Unit oJobDetDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TJobDetDataWrite_JobActualsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, var_code1Param, var_code2Param, var_code3Param,
    var_code4Param, var_code5Param, var_code6Param, var_code7Param, var_code8Param,
    var_code9Param, var_code10Param,

    // Variant specific fields
    PostedParam, LineFolioParam, LineNUmberParam,
    LineORefParam, JobCodeParam, StockCodeParam, JDateParam, QtyParam,
    CostParam, ChargeParam, InvoicedParam, InvRefParam, EmplCodeParam,
    JATypeParam, PostedRunParam, ReverseParam, ReconTSParam, ReversedParam,
    JDDTParam, CurrChargeParam, ActCCodeParam, HoldFlgParam, Post2StkParam,
    PCRates1Param, PCRates2Param, TaggedParam, OrigNCodeParam, JUseORateParam,
    PCTriRatesParam, PCTriEuroParam, PCTriInvertParam, PCTriFloatParam,
    PC_tri_SpareParam, JPriceMulXParam, UpliftTotalParam, UpliftGLParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobDetDataWrite_JobActualsVariant

  //------------------------------

  TJobDetDataWrite_JobRetentionsVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, var_code1Param, var_code2Param, var_code3Param,
    var_code4Param, var_code5Param, var_code6Param, var_code7Param, var_code8Param,
    var_code9Param, var_code10Param,

    // Variant specific fields
    PostedParam, JobCodeParam, InvoicedParam,
    RetDiscParam, RetCurrParam, RetValueParam, RetCrDocParam, RetDateParam,
    RetDocParam, RetCustCodeParam, OrigDateParam, RetDepartmentParam, RetCostCentreParam,
    AccTypeParam, DefVATCodeParam, RetCISTaxParam, RetCISGrossParam, RetCISEmplParam,
    RetAppModeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobDetDataWrite_JobRetentionsVariant

  //------------------------------

  TJobDetDataWrite_CISVouchersVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, var_code1Param, var_code2Param, var_code3Param,
    var_code4Param, var_code5Param, var_code6Param, var_code7Param, var_code8Param,
    var_code9Param, var_code10Param,

    // Variant specific fields
    Spare3Param, CISvGrossTotalParam, CISvManualTaxParam,
    CISvAutoTotalTaxParam, CISTaxableTotalParam, CISCTypeParam, CISCurrParam,
    Spare1Param, CISvNlineCountParam, CISAddr1Param, CISAddr2Param, CISAddr3Param,
    CISAddr4Param, CISAddr5Param, CISBehalfParam, CISCorrectParam, CISvTaxDueParam,
    CISVerNoParam, CISHTaxParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobDetDataWrite_CISVouchersVariant

  TJobDetDataWrite = Class(TBaseDataWrite)
  Private
    FJobActualsVariant : TJobDetDataWrite_JobActualsVariant;
    FJobRetentionsVariant : TJobDetDataWrite_JobRetentionsVariant;
    FCISVouchersVariant : TJobDetDataWrite_CISVouchersVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobDetDataWrite

  //------------------------------

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TJobDetDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FJobActualsVariant := TJobDetDataWrite_JobActualsVariant.Create;
  FJobRetentionsVariant := TJobDetDataWrite_JobRetentionsVariant.Create;
  FCISVouchersVariant := TJobDetDataWrite_CISVouchersVariant.Create;
End; // Create

//------------------------------

Destructor TJobDetDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FJobActualsVariant);
  FreeAndNIL(FJobRetentionsVariant);
  FreeAndNIL(FCISVouchersVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobDetDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FJobActualsVariant.Prepare (ADOConnection, CompanyCode);
  FJobRetentionsVariant.Prepare (ADOConnection, CompanyCode);
  FCISVouchersVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobDetDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobDetlPtr;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'E') Then
  Begin
    // JobActual : JobActType - Job Actuals
    FJobActualsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End //If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'E')
  Else If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'R') Then
  Begin
    // JobReten : JobRetType - Job Retentions
    FJobRetentionsVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'R')
  Else If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'S') Then
  Begin
    // JobCISV   :  JobCISType - CIS Vouchers
    FCISVouchersVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'T') And (DataRec.SubType = 'S')
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
Procedure TJobDetDataWrite_JobActualsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JobDet (' +
                                             'RecPfix, ' +
                                             'SubType, ' +
                                             'var_code1, ' +
                                             'var_code2, ' +
                                             'var_code3, ' +
                                             'var_code4, ' +
                                             'var_code5, ' +
                                             'var_code6, ' +
                                             'var_code7, ' +
                                             'var_code8, ' +
                                             'var_code9, ' +
                                             'var_code10, ' +
                                             'Posted, ' +
                                             'LineFolio, ' +
                                             'LineNUmber, ' +
                                             'LineORef, ' +
                                             'JobCode, ' +
                                             'StockCode, ' +
                                             'JDate, ' +
                                             'Qty, ' +
                                             'Cost, ' +
                                             'Charge, ' +
                                             'Invoiced, ' +
                                             'InvRef, ' +
                                             'EmplCode, ' +
                                             'JAType, ' +
                                             'PostedRun, ' +
                                             'Reverse, ' +
                                             'ReconTS, ' +
                                             'Reversed, ' +
                                             'JDDT, ' +
                                             'CurrCharge, ' +
                                             'ActCCode, ' +
                                             'HoldFlg, ' +
                                             'Post2Stk, ' +
                                             'PCRates1, ' +
                                             'PCRates2, ' +
                                             'Tagged, ' +
                                             'OrigNCode, ' +
                                             'JUseORate, ' + 
                                             'PCTriRates, ' + 
                                             'PCTriEuro, ' + 
                                             'PCTriInvert, ' + 
                                             'PCTriFloat, ' + 
                                             'PC_tri_Spare, ' + 
                                             'JPriceMulX, ' + 
                                             'UpliftTotal, ' + 
                                             'UpliftGL' +
                                             ') ' +
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':var_code1, ' + 
                       ':var_code2, ' + 
                       ':var_code3, ' + 
                       ':var_code4, ' + 
                       ':var_code5, ' + 
                       ':var_code6, ' + 
                       ':var_code7, ' + 
                       ':var_code8, ' + 
                       ':var_code9, ' + 
                       ':var_code10, ' + 
                       ':Posted, ' + 
                       ':LineFolio, ' + 
                       ':LineNUmber, ' + 
                       ':LineORef, ' + 
                       ':JobCode, ' + 
                       ':StockCode, ' + 
                       ':JDate, ' + 
                       ':Qty, ' + 
                       ':Cost, ' + 
                       ':Charge, ' + 
                       ':Invoiced, ' + 
                       ':InvRef, ' + 
                       ':EmplCode, ' + 
                       ':JAType, ' + 
                       ':PostedRun, ' + 
                       ':Reverse, ' + 
                       ':ReconTS, ' + 
                       ':Reversed, ' +
                       ':JDDT, ' + 
                       ':CurrCharge, ' + 
                       ':ActCCode, ' + 
                       ':HoldFlg, ' + 
                       ':Post2Stk, ' + 
                       ':PCRates1, ' + 
                       ':PCRates2, ' + 
                       ':Tagged, ' + 
                       ':OrigNCode, ' + 
                       ':JUseORate, ' + 
                       ':PCTriRates, ' + 
                       ':PCTriEuro, ' + 
                       ':PCTriInvert, ' + 
                       ':PCTriFloat, ' + 
                       ':PC_tri_Spare, ' + 
                       ':JPriceMulX, ' + 
                       ':UpliftTotal, ' + 
                       ':UpliftGL' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    var_code1Param := FindParam('var_code1');
    var_code2Param := FindParam('var_code2');
    var_code3Param := FindParam('var_code3');
    var_code4Param := FindParam('var_code4');
    var_code5Param := FindParam('var_code5');
    var_code6Param := FindParam('var_code6');
    var_code7Param := FindParam('var_code7');
    var_code8Param := FindParam('var_code8');
    var_code9Param := FindParam('var_code9');
    var_code10Param := FindParam('var_code10');
    PostedParam := FindParam('Posted');
    LineFolioParam := FindParam('LineFolio');
    LineNUmberParam := FindParam('LineNUmber');
    LineORefParam := FindParam('LineORef');
    JobCodeParam := FindParam('JobCode');
    StockCodeParam := FindParam('StockCode');
    JDateParam := FindParam('JDate');
    QtyParam := FindParam('Qty');
    CostParam := FindParam('Cost');
    ChargeParam := FindParam('Charge');
    InvoicedParam := FindParam('Invoiced');
    InvRefParam := FindParam('InvRef');
    EmplCodeParam := FindParam('EmplCode');
    JATypeParam := FindParam('JAType');
    PostedRunParam := FindParam('PostedRun');
    ReverseParam := FindParam('Reverse');
    ReconTSParam := FindParam('ReconTS');
    ReversedParam := FindParam('Reversed');
    JDDTParam := FindParam('JDDT');
    CurrChargeParam := FindParam('CurrCharge');
    ActCCodeParam := FindParam('ActCCode');
    HoldFlgParam := FindParam('HoldFlg');
    Post2StkParam := FindParam('Post2Stk');
    PCRates1Param := FindParam('PCRates1');
    PCRates2Param := FindParam('PCRates2');
    TaggedParam := FindParam('Tagged');
    OrigNCodeParam := FindParam('OrigNCode');
    JUseORateParam := FindParam('JUseORate');
    PCTriRatesParam := FindParam('PCTriRates');
    PCTriEuroParam := FindParam('PCTriEuro');
    PCTriInvertParam := FindParam('PCTriInvert');
    PCTriFloatParam := FindParam('PCTriFloat');
    PC_tri_SpareParam := FindParam('PC_tri_Spare');
    JPriceMulXParam := FindParam('JPriceMulX');
    UpliftTotalParam := FindParam('UpliftTotal');
    UpliftGLParam := FindParam('UpliftGL');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobDetDataWrite_JobActualsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobDetlPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^,JobActual Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                                    // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                                    // SQL=varchar, Delphi=Char
    var_code1Param.Value := CreateVariantArray (@LedgerCode, SizeOf(LedgerCode));       // SQL=varbinary, Delphi=String[21]
    var_code2Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));                 // SQL=varbinary, Delphi=Array[1..3] of Byte
    var_code3Param.Value := CreateVariantArray (@AnalKey, SizeOf(AnalKey));             // SQL=varbinary, Delphi=String[20]
    var_code4Param.Value := StockKey;                                                                  // SQL=varchar, Delphi=String[26]
    var_code5Param.Value := AnalCode;                                                                  // SQL=varchar, Delphi=String[10]
    var_code6Param.Value := CreateVariantArray (@EmplKey, SizeOf(EmplKey));             // SQL=varbinary, Delphi=String[21]
    var_code7Param.Value := CreateVariantArray (@RunKey, SizeOf(RunKey));               // SQL=varbinary, Delphi=String[22]
    var_code8Param.Value := CreateVariantArray (@LookKey, SizeOf(LookKey));             // SQL=varbinary, Delphi=String[19]
    var_code9Param.Value := CreateVariantArray (@HedKey, SizeOf(HedKey));               // SQL=varbinary, Delphi=String[14]

    //code10 is a 3 byte index containing Currency + Year + Period
    var_code10Param.Value := CreateVariantArray (@ActCurr, 3);                           // SQL=varbinary, Delphi=Array[1..3] of Byte

    PostedParam.Value := Posted;                                                                       // SQL=bit, Delphi=Boolean
    LineFolioParam.Value := LineFolio;                                                                 // SQL=int, Delphi=LongInt
    LineNUmberParam.Value := LineNo;                                                                   // SQL=int, Delphi=LongInt
    LineORefParam.Value := LineORef;                                                                   // SQL=varchar, Delphi=String[10]
    JobCodeParam.Value := JobCode;                                                                     // SQL=varchar, Delphi=String[10]
    StockCodeParam.Value := StockCode;                                                                 // SQL=varchar, Delphi=String[20]
    JDateParam.Value := JDate;                                                                         // SQL=varchar, Delphi=LongDate
    QtyParam.Value := Qty;                                                                             // SQL=float, Delphi=Double
    CostParam.Value := Cost;                                                                           // SQL=float, Delphi=Double
    ChargeParam.Value := Charge;                                                                       // SQL=float, Delphi=Double
    InvoicedParam.Value := Invoiced;                                                                   // SQL=bit, Delphi=Boolean
    InvRefParam.Value := InvRef;                                                                       // SQL=varchar, Delphi=String[10]
    EmplCodeParam.Value := EmplCode;                                                                   // SQL=varchar, Delphi=String[10]
    JATypeParam.Value := JAType;                                                                       // SQL=int, Delphi=Byte
    PostedRunParam.Value := PostedRun;                                                                 // SQL=int, Delphi=LongInt
    ReverseParam.Value := Reverse;                                                                     // SQL=bit, Delphi=Boolean
    ReconTSParam.Value := ReconTS;                                                                     // SQL=bit, Delphi=Boolean
    ReversedParam.Value := Reversed;                                                                   // SQL=bit, Delphi=Boolean
    JDDTParam.Value := JDDT;                                                                           // SQL=int, Delphi=DocTypes
    CurrChargeParam.Value := CurrCharge;                                                               // SQL=int, Delphi=Byte
    ActCCodeParam.Value := ActCCode;                                                                   // SQL=varchar, Delphi=String[10]
    HoldFlgParam.Value := HoldFlg;                                                                     // SQL=int, Delphi=Byte
    Post2StkParam.Value := Post2Stk;                                                                   // SQL=bit, Delphi=Boolean
    PCRates1Param.Value := PCRates[False];                                                             // SQL=float, Delphi=Double
    PCRates2Param.Value := PCRates[True];                                                              // SQL=float, Delphi=Double
    TaggedParam.Value := Tagged;                                                                       // SQL=bit, Delphi=Boolean
    OrigNCodeParam.Value := OrigNCode;                                                                 // SQL=int, Delphi=LongInt
    JUseORateParam.Value := JUseORate;                                                                 // SQL=int, Delphi=Byte
    PCTriRatesParam.Value := PCTriR.TriRates;                                                          // SQL=float, Delphi=Double
    PCTriEuroParam.Value := PCTriR.TriEuro;                                                            // SQL=int, Delphi=Byte
    PCTriInvertParam.Value := PCTriR.TriInvert;                                                        // SQL=bit, Delphi=Boolean
    PCTriFloatParam.Value := PCTriR.TriFloat;                                                          // SQL=bit, Delphi=Boolean
    PC_tri_SpareParam.Value := CreateVariantArray (@PCTriR.Spare, SizeOf(PCTriR.Spare));// SQL=varbinary, Delphi=Array[1..10] of Byte
    JPriceMulXParam.Value := JPriceMulX;                                                               // SQL=float, Delphi=Double
    UpliftTotalParam.Value := UpliftTotal;                                                             // SQL=float, Delphi=Double
    UpliftGLParam.Value := UpliftGL;                                                                   // SQL=int, Delphi=LongInt
  End; // With DataRec^.CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobDetDataWrite_JobRetentionsVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JobDet (' +
                                             'RecPfix, ' +
                                             'SubType, ' +
                                             'var_code1, ' +
                                             'var_code2, ' +
                                             'var_code3, ' +
                                             'var_code4, ' +
                                             'var_code5, ' +
                                             'var_code6, ' +
                                             'var_code7, ' +
                                             'var_code8, ' +
                                             'var_code9, ' +
                                             'var_code10, ' +
                                             'Posted, ' +
                                             'JobCode, ' +
                                             'Invoiced, ' +
                                             'RetDisc, ' +
                                             'RetCurr, ' +
                                             'RetValue, ' +
                                             'RetCrDoc, ' +
                                             'RetDate, ' +
                                             'RetDoc, ' +
                                             'RetCustCode, ' +
                                             'OrigDate, ' +
                                             'RetDepartment, ' +
                                             'RetCostCentre, ' +
                                             'AccType, ' +
                                             'DefVATCode, ' +
                                             'RetCISTax, ' +
                                             'RetCISGross, ' +
                                             'RetCISEmpl, ' +
                                             'RetAppMode' +
                                             ') ' +
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':var_code1, ' + 
                       ':var_code2, ' +
                       ':var_code3, ' +
                       ':var_code4, ' +
                       ':var_code5, ' +
                       ':var_code6, ' +
                       ':var_code7, ' +
                       ':var_code8, ' +
                       ':var_code9, ' +
                       ':var_code10, ' +
                       ':Posted, ' +
                       ':JobCode, ' +
                       ':Invoiced, ' +
                       ':RetDisc, ' +
                       ':RetCurr, ' +
                       ':RetValue, ' +
                       ':RetCrDoc, ' +
                       ':RetDate, ' +
                       ':RetDoc, ' +
                       ':RetCustCode, ' +
                       ':OrigDate, ' +
                       ':RetDepartment, ' +
                       ':RetCostCentre, ' +
                       ':AccType, ' +
                       ':DefVATCode, ' +
                       ':RetCISTax, ' +
                       ':RetCISGross, ' +
                       ':RetCISEmpl, ' +
                       ':RetAppMode' +
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
    var_code2Param := FindParam('var_code2');
    var_code3Param := FindParam('var_code3');
    var_code4Param := FindParam('var_code4');
    var_code5Param := FindParam('var_code5');
    var_code6Param := FindParam('var_code6');
    var_code7Param := FindParam('var_code7');
    var_code8Param := FindParam('var_code8');
    var_code9Param := FindParam('var_code9');
    var_code10Param := FindParam('var_code10');

    // Variant specific fields
    PostedParam := FindParam('Posted');
    JobCodeParam := FindParam('JobCode');
    InvoicedParam := FindParam('Invoiced');
    RetDiscParam := FindParam('RetDisc');
    RetCurrParam := FindParam('RetCurr');
    RetValueParam := FindParam('RetValue');
    RetCrDocParam := FindParam('RetCrDoc');
    RetDateParam := FindParam('RetDate');
    RetDocParam := FindParam('RetDoc');
    RetCustCodeParam := FindParam('RetCustCode');
    OrigDateParam := FindParam('OrigDate');
    RetDepartmentParam := FindParam('RetDepartment');
    RetCostCentreParam := FindParam('RetCostCentre');
    AccTypeParam := FindParam('AccType');
    DefVATCodeParam := FindParam('DefVATCode');
    RetCISTaxParam := FindParam('RetCISTax');
    RetCISGrossParam := FindParam('RetCISGross');
    RetCISEmplParam := FindParam('RetCISEmpl');
    RetAppModeParam := FindParam('RetAppMode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobDetDataWrite_JobRetentionsVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobDetlPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, JobReten Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                                    // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                                    // SQL=varchar, Delphi=Char
    var_code1Param.Value := CreateVariantArray (@RetenCode, SizeOf(RetenCode));       // SQL=varbinary, Delphi=String[21]
    var_code2Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));                 // SQL=varbinary, Delphi=Array[1..3] of Byte
    var_code3Param.Value := CreateVariantArray (@InvoiceKey, SizeOf(InvoiceKey));             // SQL=varbinary, Delphi=String[20]
    var_code4Param.Value := SpareNDX1;                                                                  // SQL=varchar, Delphi=String[26]
    var_code5Param.Value := AnalCode;                                                                  // SQL=varchar, Delphi=String[10]
    var_code6Param.Value := CreateVariantArray (@SpareNDX2, SizeOf(SpareNDX2));             // SQL=varbinary, Delphi=String[21]
    var_code7Param.Value := CreateVariantArray (@SpareNDX3, SizeOf(SpareNDX3));               // SQL=varbinary, Delphi=String[22]
    var_code8Param.Value := CreateVariantArray (@SpareNDX4, SizeOf(SpareNDX4));             // SQL=varbinary, Delphi=String[19]
    var_code9Param.Value := CreateVariantArray (@SpareNDX5, SizeOf(SpareNDX5));               // SQL=varbinary, Delphi=String[14]

    //code10 is a 3 byte index containing Currency + Year + Period
    var_code10Param.Value := CreateVariantArray (@OrgCurr, 3);                           // SQL=varbinary, Delphi=Array[1..3] of Byte

    PostedParam.Value := Posted;                                                                       // SQL=bit, Delphi=Boolean
    JobCodeParam.Value := JobCode;                                                                     // SQL=varchar, Delphi=String[10]
    InvoicedParam.Value := Invoiced;                                                                   // SQL=bit, Delphi=Boolean
    RetDiscParam.Value := RetDisc;                                                                     // SQL=float, Delphi=Double
    RetCurrParam.Value := RetCurr;                                                                     // SQL=int, Delphi=Byte
    RetValueParam.Value := RetValue;                                                                   // SQL=float, Delphi=Double
    RetCrDocParam.Value := RetCrDoc;                                                                   // SQL=varchar, Delphi=String[10]
    RetDateParam.Value := RetDate;                                                                     // SQL=varchar, Delphi=LongDate
    RetDocParam.Value := RetDoc;                                                                       // SQL=varchar, Delphi=String[10]
    RetCustCodeParam.Value := RetCustCode;                                                             // SQL=varchar, Delphi=String[10]
    OrigDateParam.Value := OrigDate;                                                                   // SQL=varchar, Delphi=LongDate
    RetDepartmentParam.Value := RetCCDep[False];                                                       // SQL=varchar, Delphi=String[3]
    RetCostCentreParam.Value := RetCCDep[True];                                                        // SQL=varchar, Delphi=String[3]
    AccTypeParam.Value := ConvertCharToSQLEmulatorVarChar(AccType);                                    // SQL=varchar, Delphi=Char
    DefVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(DefVATCode);                              // SQL=varchar, Delphi=Char
    RetCISTaxParam.Value := RetCISTax;                                                                 // SQL=float, Delphi=Double
    RetCISGrossParam.Value := RetCISGross;                                                             // SQL=float, Delphi=Double
    RetCISEmplParam.Value := RetCISEmpl;                                                               // SQL=varchar, Delphi=String[10]
    RetAppModeParam.Value := RetAppMode;                                                               // SQL=int, Delphi=Byte
  End; // With DataRec^, CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobDetDataWrite_CISVouchersVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JobDet (' + 
                                             'RecPfix, ' +
                                             'SubType, ' + 
                                             'var_code1, ' + 
                                             'var_code2, ' +
                                             'var_code3, ' +
                                             'var_code4, ' +
                                             'var_code5, ' +
                                             'var_code6, ' +
                                             'var_code7, ' +
                                             'var_code8, ' +
                                             'var_code9, ' +
                                             'var_code10, ' +
                                             'Spare3, ' +
                                             'CISvGrossTotal, ' +
                                             'CISvManualTax, ' +
                                             'CISvAutoTotalTax, ' + 
                                             'CISTaxableTotal, ' + 
                                             'CISCType, ' + 
                                             'CISCurr, ' + 
                                             'Spare1, ' + 
                                             'CISvNlineCount, ' + 
                                             'CISAddr1, ' + 
                                             'CISAddr2, ' + 
                                             'CISAddr3, ' + 
                                             'CISAddr4, ' + 
                                             'CISAddr5, ' + 
                                             'CISBehalf, ' + 
                                             'CISCorrect, ' + 
                                             'CISvTaxDue, ' + 
                                             'CISVerNo, ' + 
                                             'CISHTax' + 
                                             ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':var_code1, ' + 
                       ':var_code2, ' +
                       ':var_code3, ' +
                       ':var_code4, ' +
                       ':var_code5, ' +
                       ':var_code6, ' +
                       ':var_code7, ' +
                       ':var_code8, ' +
                       ':var_code9, ' +
                       ':var_code10, ' +
                       ':Spare3, ' +
                       ':CISvGrossTotal, ' +
                       ':CISvManualTax, ' +
                       ':CISvAutoTotalTax, ' +
                       ':CISTaxableTotal, ' +
                       ':CISCType, ' +
                       ':CISCurr, ' +
                       ':Spare1, ' +
                       ':CISvNlineCount, ' +
                       ':CISAddr1, ' +
                       ':CISAddr2, ' +
                       ':CISAddr3, ' +
                       ':CISAddr4, ' +
                       ':CISAddr5, ' +
                       ':CISBehalf, ' +
                       ':CISCorrect, ' +
                       ':CISvTaxDue, ' +
                       ':CISVerNo, ' +
                       ':CISHTax' +
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
    var_code2Param := FindParam('var_code2');
    var_code3Param := FindParam('var_code3');
    var_code4Param := FindParam('var_code4');
    var_code5Param := FindParam('var_code5');
    var_code6Param := FindParam('var_code6');
    var_code7Param := FindParam('var_code7');
    var_code8Param := FindParam('var_code8');
    var_code9Param := FindParam('var_code9');
    var_code10Param := FindParam('var_code10');

    //Variant-specific fields
    Spare3Param := FindParam('Spare3');
    CISvGrossTotalParam := FindParam('CISvGrossTotal');
    CISvManualTaxParam := FindParam('CISvManualTax');
    CISvAutoTotalTaxParam := FindParam('CISvAutoTotalTax');
    CISTaxableTotalParam := FindParam('CISTaxableTotal');
    CISCTypeParam := FindParam('CISCType');
    CISCurrParam := FindParam('CISCurr');
    Spare1Param := FindParam('Spare1');
    CISvNlineCountParam := FindParam('CISvNlineCount');
    CISAddr1Param := FindParam('CISAddr1');
    CISAddr2Param := FindParam('CISAddr2');
    CISAddr3Param := FindParam('CISAddr3');
    CISAddr4Param := FindParam('CISAddr4');
    CISAddr5Param := FindParam('CISAddr5');
    CISBehalfParam := FindParam('CISBehalf');
    CISCorrectParam := FindParam('CISCorrect');
    CISvTaxDueParam := FindParam('CISvTaxDue');
    CISVerNoParam := FindParam('CISVerNo');
    CISHTaxParam := FindParam('CISHTax');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobDetDataWrite_CISVouchersVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobDetlPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, JobCISV Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                                    // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                                    // SQL=varchar, Delphi=Char
    var_code1Param.Value := CreateVariantArray (@CISvCode1, SizeOf(CISvCode1));       // SQL=varbinary, Delphi=String[21]
    var_code2Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));                 // SQL=varbinary, Delphi=Array[1..3] of Byte
    var_code3Param.Value := CreateVariantArray (@CISvCode2, SizeOf(CISvCode2));             // SQL=varbinary, Delphi=String[20]
    var_code4Param.Value := CISCertNo;                                                                  // SQL=varchar, Delphi=String[26]
    var_code5Param.Value := CISVORef;                                                                  // SQL=varchar, Delphi=String[10]
    var_code6Param.Value := CreateVariantArray (@CISvDateS, SizeOf(CISvDateS));             // SQL=varbinary, Delphi=String[21]
    var_code7Param.Value := CreateVariantArray (@CISFolio, SizeOf(CISFolio) + SizeOf(CISVNINo));               // SQL=varbinary, Delphi=String[22]
    var_code8Param.Value := CreateVariantArray (@CISVSDate, SizeOf(CISVSDate));             // SQL=varbinary, Delphi=String[19]
    var_code9Param.Value := CreateVariantArray (@CISVCert, SizeOf(CISVCert));               // SQL=varbinary, Delphi=String[14]

    var_code10Param.Value := CreateVariantArray (@NdxFill1, SizeOf(NdxFill1));                           // SQL=varbinary, Delphi=Array[1..3] of Byte

    Spare3Param.Value := CreateVariantArray (@Spare3, SizeOf(Spare3));                  // SQL=varbinary, Delphi=Array[1..5] of Byte
    CISvGrossTotalParam.Value := CISvGrossTotal;                                                       // SQL=float, Delphi=Double
    CISvManualTaxParam.Value := CISvManualTax;                                                         // SQL=bit, Delphi=Boolean
    CISvAutoTotalTaxParam.Value := CISvAutoTotalTax;                                                   // SQL=float, Delphi=Double
    CISTaxableTotalParam.Value := CISTaxableTotal;                                                     // SQL=float, Delphi=Double
    CISCTypeParam.Value := CISCType;                                                                   // SQL=int, Delphi=Byte
    CISCurrParam.Value := CISCurr;                                                                     // SQL=int, Delphi=Byte
    Spare1Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));                  // SQL=varbinary, Delphi=Array[1..2] of byte
    CISvNlineCountParam.Value := CISvNlineCount;                                                       // SQL=int, Delphi=LongInt
    CISAddr1Param.Value := CISAddr[1];                                                                 // SQL=varchar, Delphi=String[30]
    CISAddr2Param.Value := CISAddr[2];                                                                 // SQL=varchar, Delphi=String[30]
    CISAddr3Param.Value := CISAddr[3];                                                                 // SQL=varchar, Delphi=String[30]
    CISAddr4Param.Value := CISAddr[4];                                                                 // SQL=varchar, Delphi=String[30]
    CISAddr5Param.Value := CISAddr[5];                                                                 // SQL=varchar, Delphi=String[30]
    CISBehalfParam.Value := CISBehalf;                                                                 // SQL=varchar, Delphi=String[80]
    CISCorrectParam.Value := CISCorrect;                                                               // SQL=bit, Delphi=Boolean
    CISvTaxDueParam.Value := CISvTaxDue;                                                               // SQL=float, Delphi=Double
    CISVerNoParam.Value := CISVERNo;                                                                   // SQL=varchar, Delphi=String[13]
    CISHTaxParam.Value := CISHTax;                                                                     // SQL=int, Delphi=Byte
  End; // With DataRec^, MultiLocRec
End; // SetQueryValues

//=========================================================================


End.


