Unit oJobMiscDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TJobMiscDataWrite_EmployeesVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, var_code1Param, var_code2Param, var_code3Param,
    var_code4Param,

    // Variant specific fields
    EmpNameParam, Addr1Param, Addr2Param, Addr3Param, Addr4Param,
    Addr5Param, PhoneParam, FaxParam, Phone2Param, ETypeParam, TimeDR1Param,
    TimeDR2Param, DepartmentParam, CostCentreParam, PayNoParam, CertNoParam,
    CertExpiryParam, JETagParam, UseORateParam, UserDef1Param, UserDef2Param,
    NLineCountParam, GSelfBillParam, GroupCertParam, CISTypeParam, UserDef3Param,
    UserDef4Param, ENINoParam, LabPLOnlyParam, UTRCodeParam, HMRCVerifyNoParam,
    TaggedParam, CISSubTypeParam, EmailAddrParam : TParameter;
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    emStatusParam, emAnonymisationStatusParam, emAnonymisedDateParam,
    emAnonymisedTimeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobMiscDataWrite_EmployeesVariant

  //------------------------------

  TJobMiscDataWrite_JobTypesVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, var_code1Param, var_code2Param, var_code3Param,
    var_code4Param,

    // Variant specific fields
    JTypeNameParam, JTTagParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobMiscDataWrite_JobTypesVariant

  //------------------------------

  TJobMiscDataWrite_AnalysisCodesVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, var_code1Param, var_code2Param, var_code3Param,
    var_code4Param,

    // Variant specific fields
    JANameParam, JATypeParam, WIPNom1Param, WIPNom2Param, AnalHedParam,
    JATagParam, JLinkLTParam, CISTaxRateParam, UpliftPParam, UpliftGLParam,
    RevenueTypeParam, JADetTypeParam, JACalcB4RetParam, JADeductParam,
    JADedApplyParam, JARetTypeParam, JARetValueParam, JARetExpParam, JARetExpIntParam,
    JARetPresParam, JADedCompParam, JAPayCodeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobMiscDataWrite_AnalysisCodesVariant

  TJobMiscDataWrite = Class(TBaseDataWrite)
  Private
    FEmployeesVariant : TJobMiscDataWrite_EmployeesVariant;
    FJobTypesVariant : TJobMiscDataWrite_JobTypesVariant;
    FAnalysisCodesVariant : TJobMiscDataWrite_AnalysisCodesVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TJobMiscDataWrite

  //------------------------------

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TJobMiscDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FEmployeesVariant := TJobMiscDataWrite_EmployeesVariant.Create;
  FJobTypesVariant := TJobMiscDataWrite_JobTypesVariant.Create;
  FAnalysisCodesVariant := TJobMiscDataWrite_AnalysisCodesVariant.Create;
End; // Create

//------------------------------

Destructor TJobMiscDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FEmployeesVariant);
  FreeAndNIL(FJobTypesVariant);
  FreeAndNIL(FAnalysisCodesVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobMiscDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FEmployeesVariant.Prepare (ADOConnection, CompanyCode);
  FJobTypesVariant.Prepare (ADOConnection, CompanyCode);
  FAnalysisCodesVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobMiscDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobDetlPtr;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'E') Then
  Begin
    // EmplRec       :  EmplType - Employee records
    FEmployeesVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End //If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'E')
  Else If ((DataRec.RecPFix = 'J') And (DataRec.SubType = 'T')) or
          ((DataRec.RecPFix = 'L') And (DataRec.SubType = 'K')) Then
  Begin
    // JobTypeRec : JobTypeType - Job Types ('JT') or Lock Records ('LK')
    FJobTypesVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'T')
  Else If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'A') Then
  Begin
    // JobAnalRec    :  JobAnalType - Job Analysis Records
    FAnalysisCodesVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'J') And (DataRec.SubType = 'A')
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
Procedure TJobMiscDataWrite_EmployeesVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JobMisc (' +
                                              'RecPfix, ' +
                                              'SubType, ' +
                                              'var_code1, ' +
                                              'var_code2, ' +
                                              'var_code3, ' +
                                              'var_code4, ' +
                                              'EmpName, ' +
                                              'Addr1, ' +
                                              'Addr2, ' +
                                              'Addr3, ' +
                                              'Addr4, ' +
                                              'Addr5, ' +
                                              'Phone, ' +
                                              'Fax, ' +
                                              'Phone2, ' +
                                              'EType, ' +
                                              'TimeDR1, ' +
                                              'TimeDR2, ' +
                                              'Department, ' +
                                              'CostCentre, ' +
                                              'PayNo, ' +
                                              'CertNo, ' +
                                              'CertExpiry, ' +
                                              'JETag, ' +
                                              'UseORate, ' +
                                              'UserDef1, ' +
                                              'UserDef2, ' +
                                              'NLineCount, ' +
                                              'GSelfBill, ' +
                                              'GroupCert, ' +
                                              'CISType, ' +
                                              'UserDef3, ' +
                                              'UserDef4, ' +
                                              'ENINo, ' +
                                              'LabPLOnly, ' +
                                              'UTRCode, ' +
                                              'HMRCVerifyNo, ' +
                                              'Tagged, ' +
                                              'CISSubType, ' +
                                              'EmailAddr, ' +
                                              // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                                              'emStatus, ' +
                                              'emAnonymisationStatus, ' +
                                              'emAnonymisedDate, ' +
                                              'emAnonymisedTime' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':var_code1, ' +
                       ':var_code2, ' +
                       ':var_code3, ' +
                       ':var_code4, ' +
                       ':EmpName, ' +
                       ':Addr1, ' +
                       ':Addr2, ' +
                       ':Addr3, ' +
                       ':Addr4, ' +
                       ':Addr5, ' +
                       ':Phone, ' +
                       ':Fax, ' +
                       ':Phone2, ' +
                       ':EType, ' +
                       ':TimeDR1, ' +
                       ':TimeDR2, ' +
                       ':Department, ' +
                       ':CostCentre, ' +
                       ':PayNo, ' +
                       ':CertNo, ' +
                       ':CertExpiry, ' +
                       ':JETag, ' +
                       ':UseORate, ' +
                       ':UserDef1, ' +
                       ':UserDef2, ' +
                       ':NLineCount, ' +
                       ':GSelfBill, ' +
                       ':GroupCert, ' +
                       ':CISType, ' +
                       ':UserDef3, ' +
                       ':UserDef4, ' +
                       ':ENINo, ' +
                       ':LabPLOnly, ' +
                       ':UTRCode, ' +
                       ':HMRCVerifyNo, ' +
                       ':Tagged, ' +
                       ':CISSubType, ' +
                       ':EmailAddr, ' +
                       // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                       ':emStatus, ' +
                       ':emAnonymisationStatus, ' +
                       ':emAnonymisedDate, ' +
                       ':emAnonymisedTime' +
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
    EmpNameParam := FindParam('EmpName');
    Addr1Param := FindParam('Addr1');
    Addr2Param := FindParam('Addr2');
    Addr3Param := FindParam('Addr3');
    Addr4Param := FindParam('Addr4');
    Addr5Param := FindParam('Addr5');
    PhoneParam := FindParam('Phone');
    FaxParam := FindParam('Fax');
    Phone2Param := FindParam('Phone2');
    ETypeParam := FindParam('EType');
    TimeDR1Param := FindParam('TimeDR1');
    TimeDR2Param := FindParam('TimeDR2');
    DepartmentParam := FindParam('Department');
    CostCentreParam := FindParam('CostCentre');
    PayNoParam := FindParam('PayNo');
    CertNoParam := FindParam('CertNo');
    CertExpiryParam := FindParam('CertExpiry');
    JETagParam := FindParam('JETag');
    UseORateParam := FindParam('UseORate');
    UserDef1Param := FindParam('UserDef1');
    UserDef2Param := FindParam('UserDef2');
    NLineCountParam := FindParam('NLineCount');
    GSelfBillParam := FindParam('GSelfBill');
    GroupCertParam := FindParam('GroupCert');
    CISTypeParam := FindParam('CISType');
    UserDef3Param := FindParam('UserDef3');
    UserDef4Param := FindParam('UserDef4');
    ENINoParam := FindParam('ENINo');
    LabPLOnlyParam := FindParam('LabPLOnly');
    UTRCodeParam := FindParam('UTRCode');
    HMRCVerifyNoParam := FindParam('HMRCVerifyNo');
    TaggedParam := FindParam('Tagged');
    CISSubTypeParam := FindParam('CISSubType');
    EmailAddrParam := FindParam('EmailAddr');

    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    emStatusParam := FindParam('emStatus');
    emAnonymisationStatusParam := FindParam('emAnonymisationStatus');
    emAnonymisedDateParam := FindParam('emAnonymisedDate');
    emAnonymisedTimeParam := FindParam('emAnonymisedTime');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobMiscDataWrite_EmployeesVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobMiscPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, EmplRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                 // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                 // SQL=varchar, Delphi=Char
    var_code1Param.Value := CreateVariantArray (@EmpCode, SizeOf(EmpCode));// SQL=varbinary, Delphi=String[10]
    var_code2Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));// SQL=varbinary, Delphi=Array[1..4] of Byte
    var_code3Param.Value := Surname;                                                // SQL=varchar, Delphi=String[20]
    var_code4Param.Value := Supplier;                                               // SQL=varchar, Delphi=String[10]

    EmpNameParam.Value := EmpName;                                                  // SQL=varchar, Delphi=String[30]
    Addr1Param.Value := Addr[1];                                                    // SQL=varchar, Delphi=String[30]
    Addr2Param.Value := Addr[2];                                                    // SQL=varchar, Delphi=String[30]
    Addr3Param.Value := Addr[3];                                                    // SQL=varchar, Delphi=String[30]
    Addr4Param.Value := Addr[4];                                                    // SQL=varchar, Delphi=String[30]
    Addr5Param.Value := Addr[5];                                                    // SQL=varchar, Delphi=String[30]
    PhoneParam.Value := Phone;                                                      // SQL=varchar, Delphi=String[20]
    FaxParam.Value := Fax;                                                          // SQL=varchar, Delphi=String[20]
    Phone2Param.Value := Phone2;                                                    // SQL=varchar, Delphi=String[20]
    ETypeParam.Value := EType;                                                      // SQL=int, Delphi=Byte
    TimeDR1Param.Value := TimeDR[False];                                            // SQL=int, Delphi=LongInt
    TimeDR2Param.Value := TimeDR[True];                                             // SQL=int, Delphi=LongInt
    DepartmentParam.Value := CCDep[False];                                          // SQL=varchar, Delphi=String[3]
    CostCentreParam.Value := CCDep[True];                                           // SQL=varchar, Delphi=String[3]
    PayNoParam.Value := PayNo;                                                      // SQL=varchar, Delphi=String[10]
    CertNoParam.Value := CertNo;                                                    // SQL=varchar, Delphi=String[30]
    CertExpiryParam.Value := CertExpiry;                                            // SQL=varchar, Delphi=LongDate
    JETagParam.Value := JETag;                                                      // SQL=bit, Delphi=Boolean
    UseORateParam.Value := UseORate;                                                // SQL=int, Delphi=Byte
    UserDef1Param.Value := UserDef1;                                                // SQL=varchar, Delphi=String[20]
    UserDef2Param.Value := UserDef2;                                                // SQL=varchar, Delphi=String[20]
    NLineCountParam.Value := NLineCount;                                            // SQL=int, Delphi=LongInt
    GSelfBillParam.Value := GSelfBill;                                              // SQL=bit, Delphi=Boolean
    GroupCertParam.Value := GroupCert;                                              // SQL=bit, Delphi=Boolean
    CISTypeParam.Value := CISType;                                                  // SQL=int, Delphi=Byte
    UserDef3Param.Value := UserDef3;                                                // SQL=varchar, Delphi=String[20]
    UserDef4Param.Value := UserDef4;                                                // SQL=varchar, Delphi=String[20]
    ENINoParam.Value := ENINo;                                                      // SQL=varchar, Delphi=String[10]
    LabPLOnlyParam.Value := LabPLOnly;                                              // SQL=bit, Delphi=Boolean
    UTRCodeParam.Value := UTRCode;                                                  // SQL=varchar, Delphi=String[10]
    HMRCVerifyNoParam.Value := VerifyNo;                                            // SQL=varchar, Delphi=String[13]
    TaggedParam.Value := Tagged;                                                    // SQL=int, Delphi=Byte
    CISSubTypeParam.Value := CISSubType;                                            // SQL=int, Delphi=Byte
    EmailAddrParam.Value := emEmailAddr;                                            // SQL=varchar, Delphi=String[100]

    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    emStatusParam.Value := Ord(emStatus);
    emAnonymisationStatusParam.Value := Ord(emAnonymisationStatus);
    emAnonymisedDateParam.Value := emAnonymisedDate;
    emAnonymisedTimeParam.Value := emAnonymisedTime;
  End; // With DataRec^.CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobMiscDataWrite_JobTypesVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JobMisc (' +
                                              'RecPfix, ' +
                                              'SubType, ' +
                                              'var_code1, ' +
                                              'var_code2, ' +
                                              'var_code3, ' +
                                              'var_code4, ' +
                                              'JTypeName, ' +
                                              'JTTag' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':var_code1, ' +
                       ':var_code2, ' +
                       ':var_code3, ' +
                       ':var_code4, ' +
                       ':JTypeName, ' +
                       ':JTTag' +
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

    JTypeNameParam := FindParam('JTypeName');
    JTTagParam := FindParam('JTTag');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobMiscDataWrite_JobTypesVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobMiscPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, JobTypeRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                 // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                 // SQL=varchar, Delphi=Char
    var_code1Param.Value := CreateVariantArray (@JobType, SizeOf(JobType));// SQL=varbinary, Delphi=String[10]
    var_code2Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));// SQL=varbinary, Delphi=Array[1..4] of Byte
    var_code3Param.Value := JTNameCode;                                                // SQL=varchar, Delphi=String[20]
    var_code4Param.Value := Spare3;                                               // SQL=varchar, Delphi=String[10]

    JTypeNameParam.Value := JTypeName;                                              // SQL=varchar, Delphi=String[30]
    JTTagParam.Value := JTTag;                                                      // SQL=bit, Delphi=Boolean
  End; // With DataRec^, CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TJobMiscDataWrite_AnalysisCodesVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].JobMisc (' + 
                                              'RecPfix, ' + 
                                              'SubType, ' + 
                                              'var_code1, ' + 
                                              'var_code2, ' + 
                                              'var_code3, ' + 
                                              'var_code4, ' + 
                                              'JAName, ' +
                                              'JAType, ' +
                                              'WIPNom1, ' +
                                              'WIPNom2, ' +
                                              'AnalHed, ' +
                                              'JATag, ' +
                                              'JLinkLT, ' +
                                              'CISTaxRate, ' +
                                              'UpliftP, ' + 
                                              'UpliftGL, ' + 
                                              'RevenueType, ' + 
                                              'JADetType, ' + 
                                              'JACalcB4Ret, ' + 
                                              'JADeduct, ' + 
                                              'JADedApply, ' +
                                              'JARetType, ' +
                                              'JARetValue, ' +
                                              'JARetExp, ' +
                                              'JARetExpInt, ' +
                                              'JARetPres, ' +
                                              'JADedComp, ' +
                                              'JAPayCode' +
                                              ') ' +
              'VALUES (' +
                       ':RecPfix, ' +
                       ':SubType, ' +
                       ':var_code1, ' +
                       ':var_code2, ' +
                       ':var_code3, ' +
                       ':var_code4, ' +
                       ':JAName, ' +
                       ':JAType, ' +
                       ':WIPNom1, ' +
                       ':WIPNom2, ' +
                       ':AnalHed, ' +
                       ':JATag, ' +
                       ':JLinkLT, ' +
                       ':CISTaxRate, ' +
                       ':UpliftP, ' +
                       ':UpliftGL, ' +
                       ':RevenueType, ' +
                       ':JADetType, ' +
                       ':JACalcB4Ret, ' +
                       ':JADeduct, ' +
                       ':JADedApply, ' +
                       ':JARetType, ' +
                       ':JARetValue, ' +
                       ':JARetExp, ' +
                       ':JARetExpInt, ' +
                       ':JARetPres, ' +
                       ':JADedComp, ' +
                       ':JAPayCode' +
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

    JANameParam := FindParam('JAName');
    JATypeParam := FindParam('JAType');
    WIPNom1Param := FindParam('WIPNom1');
    WIPNom2Param := FindParam('WIPNom2');
    AnalHedParam := FindParam('AnalHed');
    JATagParam := FindParam('JATag');
    JLinkLTParam := FindParam('JLinkLT');
    CISTaxRateParam := FindParam('CISTaxRate');
    UpliftPParam := FindParam('UpliftP');
    UpliftGLParam := FindParam('UpliftGL');
    RevenueTypeParam := FindParam('RevenueType');
    JADetTypeParam := FindParam('JADetType');
    JACalcB4RetParam := FindParam('JACalcB4Ret');
    JADeductParam := FindParam('JADeduct');
    JADedApplyParam := FindParam('JADedApply');
    JARetTypeParam := FindParam('JARetType');
    JARetValueParam := FindParam('JARetValue');
    JARetExpParam := FindParam('JARetExp');
    JARetExpIntParam := FindParam('JARetExpInt');
    JARetPresParam := FindParam('JARetPres');
    JADedCompParam := FindParam('JADedComp');
    JAPayCodeParam := FindParam('JAPayCode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TJobMiscDataWrite_AnalysisCodesVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : JobMiscPtr;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, JobAnalRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                 // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                 // SQL=varchar, Delphi=Char
    var_code1Param.Value := CreateVariantArray (@JAnalCode, SizeOf(JAnalCode));// SQL=varbinary, Delphi=String[10]
    var_code2Param.Value := CreateVariantArray (@Spare, SizeOf(Spare));// SQL=varbinary, Delphi=Array[1..4] of Byte
    var_code3Param.Value := JANameCode;                                                // SQL=varchar, Delphi=String[20]
    var_code4Param.Value := JMNDX3;                                               // SQL=varchar, Delphi=String[10]

    JANameParam.Value := JAnalName;                                                 // SQL=varchar, Delphi=String[30]
    JATypeParam.Value := JAType;                                                    // SQL=int, Delphi=SmallInt
    WIPNom1Param.Value := WIPNom[False];                                            // SQL=int, Delphi=LongInt
    WIPNom2Param.Value := WIPNom[True];                                             // SQL=int, Delphi=LongInt
    AnalHedParam.Value := AnalHed;                                                  // SQL=int, Delphi=SmallInt
    JATagParam.Value := JATag;                                                      // SQL=bit, Delphi=Boolean
    JLinkLTParam.Value := JLinkLT;                                                  // SQL=int, Delphi=Byte
    CISTaxRateParam.Value := ConvertCharToSQLEmulatorVarChar(CISTaxRate);           // SQL=varchar, Delphi=Char
    UpliftPParam.Value := UpliftP;                                                  // SQL=float, Delphi=Double
    UpliftGLParam.Value := UpliftGL;                                                // SQL=int, Delphi=LongInt
    RevenueTypeParam.Value := RevenueType;                                          // SQL=int, Delphi=Byte
    JADetTypeParam.Value := JADetType;                                              // SQL=int, Delphi=Byte
    JACalcB4RetParam.Value := JACalcB4Ret;                                          // SQL=bit, Delphi=Boolean
    JADeductParam.Value := JADeduct;                                                // SQL=float, Delphi=Double
    JADedApplyParam.Value := JADedApply;                                            // SQL=int, Delphi=Byte
    JARetTypeParam.Value := JARetType;                                              // SQL=int, Delphi=Byte
    JARetValueParam.Value := JARetValue;                                            // SQL=float, Delphi=Double
    JARetExpParam.Value := JARetExp;                                                // SQL=int, Delphi=Byte
    JARetExpIntParam.Value := JARetExpInt;                                          // SQL=int, Delphi=Byte
    JARetPresParam.Value := JARetPres;                                              // SQL=bit, Delphi=Boolean
    JADedCompParam.Value := JADedComp;                                              // SQL=int, Delphi=Byte
    JAPayCodeParam.Value := JAPayCode;                                              // SQL=varchar, Delphi=String[5]
  End; // With DataRec^, MultiLocRec
End; // SetQueryValues

//=========================================================================


End.

    EmplType    = Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }

               {002}  EmpCode   :  String[10];   {  Variable Key }

               {012}  Spare     :  Array[1..4] of Byte;

               {017}  Surname   :  String[20];   {  Auto Extracted Surname }
               {038}  Supplier  :  String[10];   {  Link to Supplier Record if Subcontracter.}
               {049}  EmpName   :  String[30];   {  Full Employee Name }

               {080}  Addr[1]      :  String[30];      {  Employee's Address  }
               {080}  Addr[2]      :  String[30];      {  Employee's Address  }
               {080}  Addr[3]      :  String[30];      {  Employee's Address  }
               {080}  Addr[4]      :  String[30];      {  Employee's Address  }
               {080}  Addr[5]      :  String[30];      {  Employee's Address  }

               {235}  Phone     :  String[20];   {  }
               {256}  Fax       :  String[20];   {  }
               {277}  Phone2    :  String[20];   {  Mobile Phone }
               {297}  EType     :  Byte;         {  Employee Type relates to O/P/S }
               {298}  TimeDR[False]    :   LongInt;      {Time Sheet Debit (Off)/Credit (On)}
               {298}  TimeDR[True]    :   LongInt;      {Time Sheet Debit (Off)/Credit (On)}

               {307}  CCDep[False]     :  String[3];    {  Default CC/Dep  }
               {307}  CCDep[True]     :  String[3];    {  Default CC/Dep  }
               {315}  PayNo     :  String[10];   {  External payroll No.}
               {326}  CertNo    :  String[30];   {  714 Cert No.}
               {357}  CertExpiry:  LongDate;     {  715 Cert Expiry }
               {365}  JETag     :  Boolean;      {  Record Tagged }


                 {366}  UseORate  :  Byte;


               {368}  UserDef1  :  String[20];         { User def 1 string }
               {389}  UserDef2  :  String[20];         { User def 2 string }
               {409}  NLineCount:  LongInt;      {  Notepad line count }
               {413}  GSelfBill                                 :  Boolean;      {  }
               {414}  GroupCert :  Boolean;      {  Link Cert to all same suppliers employees}
               {415}  CISType   :  Byte;         {  Link to CIS reporting }
               {417}  UserDef3  :  String[20];         { User def 3 string }
               {438}  UserDef4  :  String[20];         { User def 4 string }

               {459}  ENINo       :  String[10];   {National Ins No. Uk/ Serial No. IRL}

               {469}  LabPLOnly :  Boolean;      {For sub contractors, block time sheets as labour comes from PL}

               {471}  UTRCode   :  String[10];   {Unique Tax Ref}

               {482}  VerifyNo  :  String[13];   {HMRC Verification No.}

               {495}  Tagged    :  Byte;         {Tag for process}

               {496}  CISSubType:  Byte;

                      // MH 01/02/2010 (v6.3): Added new fields for Web Extensions
                      emEmailAddr : String[100];

    { ================ Job Type Record ================ }


               {049}  JTypeName :  String[30];   {  Full Job Type Name }

               {079}  JTTag     :  Boolean;



    { ================ Job Analysis Record ================ }


               {049}  JAnalName :  String[30];   {  Full Job Anal Name }

               {079}  JAType    :  SmallInt;      {  Relates to R/M/O/L }
               {081}  WIPNom[False]    :  LongInt;      {  WIP Nom (Off)/ PLNom (On) }
               {081}  WIPNom[True]    :  LongInt;      {  WIP Nom (Off)/ PLNom (On) }

               {089}  AnalHed   :  SmallInt;      {  Relates to 1-10 Major Anal Headings }

               {091}  JATag     :  Boolean;      {  Tagged Flag }

               {092}  JLinkLT   :  Byte;         { Link to Line Type }

                 {093}  CISTaxRate  :  Char;     {Taxable activity CIS Rate}
                 {094}  UpliftP     :  Double;   {Uplift on cost %}
                 {102}  UpliftGL    :  LongInt;  {Uplift GL Code + reversal}
                 {106}  RevenueType :  Byte;     {Link to Revenue activity for valuation}

                 {107}  JADetType   :  Byte;     {Deduction type, 0=% or 1=value}
                 {108}  JACalcB4Ret :  Boolean;  {Deduction calculated before Retnetion applied}
                 {109}  JADeduct    :  Double;   {Deduction value}
                 {117}  JADedApply  :  Byte;
                 {118}  JARetType   :  Byte;     {Retnetion type. 0=Standrad, 1=Interim, 2=Practical, 3=Final}
                 {119}  JARetValue  :  Double;   {% Value of retnetion}
                 {127}  JARetExp    :  Byte;
                 {128}  JARetExpInt :  Byte;     {Expity inerval 1-12}
                 {129}  JARetPres   :  Boolean;  {Preserve through to retentions}
                 {130}  JADedComp   :  Byte;     {Calculate deduction as 0, Normal, 1 compound deduction, 2 Contra}
                 {132}  JAPayCode   :  String[5]; {Link to payroll deduction code}



