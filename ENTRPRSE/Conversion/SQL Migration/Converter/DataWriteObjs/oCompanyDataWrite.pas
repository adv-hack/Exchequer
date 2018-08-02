Unit oCompanyDataWrite;

// MH: Needs these otherwise the imported Company.Dat structures are screwed up
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses SysUtils, ADODB, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TCompanyDataWrite_CompanyVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    RecPfixParam, CompanyCode1Param : TParameter;

    // Variant specific columns - Company Record
    CompIdParam, CompDemoDataParam, CompSpareParam, CompDemoSysParam, CompTKUCountParam,
    CompTrdUCountParam, CompSysESNParam, CompModIdParam, CompModSynchParam,
    CompUCountParam, CompAnalParam : TParameter;
    // MH 22/01/2013 v7.0.2 ABSEXCH-13857: Added export flag for Analytics
    CompExportToAnalyticsParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCompanyDataWrite_CompanyVariant

  //------------------------------

  TCompanyDataWrite_SetupVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    RecPfixParam, CompanyCode1Param, Company_code2Param, Company_code3Param : TParameter;

    // Variant specific columns - MCM System Setup Record
    OptPWordParam, OptBackupParam, OptRestoreParam,
    OptHidePathParam, OptHideBackupParam, OptWin9xCmdParam, OptWinNTCmdParam,
    OptShowCheckUsrParam, optSystemESNParam, OptSecurityParam, OptShowExchParam,
    OptBureauModuleParam, OptBureauAdminPWordParam, OptShowViewCompanyParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCompanyDataWrite_SetupVariant

  //------------------------------

  TCompanyDataWrite_UserCountVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    RecPfixParam, CompanyCode1Param, Company_code2Param, Company_code3Param : TParameter;

    // Variant specific columns - User Count Security Record
    ucCompanyIdParam, ucWStationIdParam, ucUserIdParam, ucRefCountParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCompanyDataWrite_UserCountVariant

  //------------------------------

  TCompanyDataWrite_PlugInSecurityVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    RecPfixParam, CompanyCode1Param, Company_code2Param, Company_code3Param : TParameter;

    // Variant specific columns - Plug-In Security Record
    hkIdParam, hkSecCodeParam, hkDescParam, hkStuffParam, hkMessageParam, hkVersionParam,
    hkEncryptedCodeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCompanyDataWrite_PlugInSecurityVariant

  //------------------------------

  TCompanyDataWrite_AccessControlVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    RecPfixParam, CompanyCode1Param, Company_code2Param, Company_code3Param : TParameter;

    // Variant specific columns - Access Control Record
    acSystemIdParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCompanyDataWrite_AccessControlVariant

  //------------------------------

  TCompanyDataWrite = Class(TBaseDataWrite)
  Private
    FCompanyVariant : TCompanyDataWrite_CompanyVariant;
    FSetupVariant : TCompanyDataWrite_SetupVariant;
    FUserCountVariant : TCompanyDataWrite_UserCountVariant;
    FPlugInSecurityVariant : TCompanyDataWrite_PlugInSecurityVariant;
    FAccessControlVariant : TCompanyDataWrite_AccessControlVariant;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCompanyDataWrite

Implementation

Uses GlobVar, BtrvU2, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

{$I \Entrprse\MultComp\CompVar.Pas}

//=========================================================================

Constructor TCompanyDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FCompanyVariant := TCompanyDataWrite_CompanyVariant.Create;
  FSetupVariant := TCompanyDataWrite_SetupVariant.Create;
  FUserCountVariant := TCompanyDataWrite_UserCountVariant.Create;
  FPlugInSecurityVariant := TCompanyDataWrite_PlugInSecurityVariant.Create;
  FAccessControlVariant := TCompanyDataWrite_AccessControlVariant.Create;
End; // Create

//------------------------------

Destructor TCompanyDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FCompanyVariant);
  FreeAndNIL(FSetupVariant);
  FreeAndNIL(FUserCountVariant);
  FreeAndNIL(FPlugInSecurityVariant);
  FreeAndNIL(FAccessControlVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCompanyDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FCompanyVariant.Prepare (ADOConnection, CompanyCode);
  FSetupVariant.Prepare (ADOConnection, CompanyCode);
  FUserCountVariant.Prepare (ADOConnection, CompanyCode);
  FPlugInSecurityVariant.Prepare (ADOConnection, CompanyCode);
  FAccessControlVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TCompanyDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^CompRec;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

// Exception for testing the Exception Handling and logging in the calling routine
//If (DataRec.RecPFix <> cmCompDet) And (DataRec.RecPFix <> cmSetup) Then
//  Raise Exception.Create ('+++Error At Address: 14, Treacle Mine Road, Ankh-Morpork+++');

  Case DataRec.RecPFix Of
    // 'C' - Company Details
    cmCompDet        : FCompanyVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    // 'S' - MCM Setup & Licencing
    cmSetup          : FSetupVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    // 'U' - Enterprise Global User Count
    cmUserCount,
    // 'T' - Toolkit Global User Count
    cmTKUserCount,
    // 'R' - Trade Counter Global User Count
    cmTradeUserCount : FUserCountVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    // 'H' - Plug-In Security
    cmPlugInSecurity : FPlugInSecurityVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    // 'A' - User Count Access Control Record
    cmAccessControl  : FAccessControlVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  Else
    // Unknown Data - Log error and continue conversion
    SkipRecord := True;
    sDumpFile := DataPacket.DumpToFile;
    ConversionWarnings.AddWarning(TSQLUnknownVariantWarning.Create (DataPacket, sDumpFile, ToHexString(@DataRec^.RecPFix, SizeOf(DataRec^.RecPFix))));
    Logging.UnknownVariant(Trim(DataPacket.CompanyDetails.ccCompanyPath) + DataPacket.TaskDetails.dctPervasiveFilename, ToHexString(@DataRec^.RecPFix, SizeOf(DataRec^.RecPFix)), sDumpFile);
  End; // Case DataRec.RecPFix
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCompanyDataWrite_CompanyVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'UPDATE Common.Company ' +
                           'SET CompId=:CompId, ' +
                               'CompDemoData=:CompDemoData, ' +
                               // MH 22/01/2013 v7.0.2 ABSEXCH-13857: Added export flag for Analytics
                               'CompExportToAnalytics=:CompExportToAnalytics, ' +
                               'CompSpare=:CompSpare, ' +
                               'CompDemoSys=:CompDemoSys, ' +
                               'CompTKUCount=:CompTKUCount, ' +
                               'CompTrdUCount=:CompTrdUCount, ' +
                               'CompSysESN=:CompSysESN, ' +
                               'CompModId=:CompModId, ' +
                               'CompModSynch=:CompModSynch, ' +
                               'CompUCount=:CompUCount, ' +
                               'CompAnal=:CompAnal ' +
                         'WHERE (RecPFix=:RecPFix) ' +
                           'AND (CompanyCode1=:CompanyCode1)';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    CompanyCode1Param := FindParam('CompanyCode1');
    CompIdParam := FindParam('CompId');
    CompDemoDataParam := FindParam('CompDemoData');
    // MH 22/01/2013 v7.0.2 ABSEXCH-13857: Added export flag for Analytics
    CompExportToAnalyticsParam := FindParam('CompExportToAnalytics');
    CompSpareParam := FindParam('CompSpare');
    CompDemoSysParam := FindParam('CompDemoSys');
    CompTKUCountParam := FindParam('CompTKUCount');
    CompTrdUCountParam := FindParam('CompTrdUCount');
    CompSysESNParam := FindParam('CompSysESN');
    CompModIdParam := FindParam('CompModId');
    CompModSynchParam := FindParam('CompModSynch');
    CompUCountParam := FindParam('CompUCount');
    CompAnalParam := FindParam('CompAnal');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TCompanyDataWrite_CompanyVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^CompRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecPFix);           // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec.CompDet Do
  Begin
    CompanyCode1Param.Value := CreateVariantArray (@CompCode, SizeOf(CompCode));        // SQL=varbinary, Delphi=String[CompCodeLen]

    CompIdParam.Value := CompId;                                                        // SQL=int, Delphi=LongInt
    CompDemoDataParam.Value := CompDemoData;                                            // SQL=bit, Delphi=Boolean
    // MH 22/01/2013 v7.0.2 ABSEXCH-13857: Added export flag for Analytics
    CompExportToAnalyticsParam.Value := CompExportToAnalytics;
    CompSpareParam.Value := CreateVariantArray (@CompSpare, SizeOf(CompSpare));         // SQL=varbinary, Delphi=Array [1..1354] Of Char
    CompDemoSysParam.Value := CompDemoSys;                                              // SQL=bit, Delphi=Boolean
    CompTKUCountParam.Value := CompTKUCount;                                            // SQL=int, Delphi=SmallInt
    CompTrdUCountParam.Value := CompTrdUCount;                                          // SQL=int, Delphi=SmallInt
    CompSysESNParam.Value := CreateVariantArray (@CompSysESN, SizeOf(CompSysESN));      // SQL=varbinary, Delphi=ISNArrayType
    CompModIdParam.Value := CompModId;                                                  // SQL=int, Delphi=LongInt
    CompModSynchParam.Value := CompModSynch;                                            // SQL=int, Delphi=Byte
    CompUCountParam.Value := CompUCount;                                                // SQL=int, Delphi=SmallInt
    CompAnalParam.Value := CompAnal;                                                    // SQL=int, Delphi=SmallInt
  End; // With DataRec.CompDet
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCompanyDataWrite_SetupVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup and Prepare the Insert statement
  FADOQuery.SQL.Text := 'INSERT INTO Common.Company (' +
                                                     'RecPfix, ' +
                                                     'CompanyCode1, ' +
                                                     'Company_code2, ' +
                                                     'Company_code3, ' +
                                                     'OptPWord, ' +
                                                     'OptBackup, ' +
                                                     'OptRestore, ' +
                                                     'OptHidePath, ' +
                                                     'OptHideBackup, ' +
                                                     'OptWin9xCmd, ' +
                                                     'OptWinNTCmd, ' +
                                                     'OptShowCheckUsr, ' +
                                                     'optSystemESN, ' +
                                                     'OptSecurity, ' +
                                                     'OptShowExch, ' +
                                                     'OptBureauModule, ' +
                                                     'OptBureauAdminPWord, ' +
                                                     'OptShowViewCompany' +
                                                     ')' +
                        'VALUES (' +
                                 ':RecPfix, ' +
                                 ':CompanyCode1, ' +
                                 ':Company_code2, ' +
                                 ':Company_code3, ' +
                                 ':OptPWord, ' +
                                 ':OptBackup, ' +
                                 ':OptRestore, ' +
                                 ':OptHidePath, ' +
                                 ':OptHideBackup, ' +
                                 ':OptWin9xCmd, ' +
                                 ':OptWinNTCmd, ' +
                                 ':OptShowCheckUsr, ' +
                                 ':optSystemESN, ' +
                                 ':OptSecurity, ' +
                                 ':OptShowExch, ' +
                                 ':OptBureauModule, ' +
                                 ':OptBureauAdminPWord, ' +
                                 ':OptShowViewCompany' +
                                 ')';
  FADOQuery.Prepared := True;

  // Link the local references to the parameter objects in the prepared ADO Query
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    CompanyCode1Param := FindParam('CompanyCode1');
    Company_code2Param := FindParam('Company_code2');
    Company_code3Param := FindParam('Company_code3');
    OptPWordParam := FindParam('OptPWord');
    OptBackupParam := FindParam('OptBackup');
    OptRestoreParam := FindParam('OptRestore');
    OptHidePathParam := FindParam('OptHidePath');
    OptHideBackupParam := FindParam('OptHideBackup');
    OptWin9xCmdParam := FindParam('OptWin9xCmd');
    OptWinNTCmdParam := FindParam('OptWinNTCmd');
    OptShowCheckUsrParam := FindParam('OptShowCheckUsr');
    optSystemESNParam := FindParam('optSystemESN');
    OptSecurityParam := FindParam('OptSecurity');
    OptShowExchParam := FindParam('OptShowExch');
    OptBureauModuleParam := FindParam('OptBureauModule');
    OptBureauAdminPWordParam := FindParam('OptBureauAdminPWord');
    OptShowViewCompanyParam := FindParam('OptShowViewCompany');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TCompanyDataWrite_SetupVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^CompRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecPFix);        // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec.CompOpt Do
  Begin
    // Common indexed columns
    CompanyCode1Param.Value := CreateVariantArray (@OptCode, SizeOf(OptCode));    // SQL=varbinary, Delphi=String[CompCodeLen]
    Company_code2Param.Value := OptName;                                          // SQL=varchar, Delphi=String[CompNameLen]
    Company_code3Param.Value := CreateVariantArray (@OptPath, SizeOf(OptPath));   // SQL=varbinary, Delphi=String[CompPathLen]

    // Variant specific columns
    OptPWordParam.Value := CreateVariantArray (@OptPWord, SizeOf(OptPWord));               // SQL=varbinary, Delphi=String[8]
    OptBackupParam.Value := OptBackup;                                                     // SQL=varchar, Delphi=String[200]
    OptRestoreParam.Value := OptRestore;                                                   // SQL=varchar, Delphi=String[200]
    OptHidePathParam.Value := OptHidePath;                                                 // SQL=bit, Delphi=Boolean
    OptHideBackupParam.Value := OptHideBackup;                                             // SQL=bit, Delphi=Boolean
    OptWin9xCmdParam.Value := OptWin9xCmd;                                                 // SQL=varchar, Delphi=String[8]
    OptWinNTCmdParam.Value := OptWinNTCmd;                                                 // SQL=varchar, Delphi=String[8]
    OptShowCheckUsrParam.Value := OptShowCheckUsr;                                         // SQL=bit, Delphi=Boolean
    optSystemESNParam.Value := CreateVariantArray (@optSystemESN, SizeOf(optSystemESN));   // SQL=varbinary, Delphi=ISNArrayType
    // OptSecurity is Binary block covering numerous release code and user count security fields
    OptSecurityParam.Value := CreateVariantArray (@OptSecurity, CalculateBinaryBlockSize (@OptEntUserSecurity, @OptShowExch));   // SQL=varbinary, Delphi=Binary
    OptShowExchParam.Value := OptShowExch;                                                 // SQL=bit, Delphi=Boolean
    OptBureauModuleParam.Value := OptBureauModule;                                         // SQL=bit, Delphi=Boolean
    OptBureauAdminPWordParam.Value := CreateVariantArray (@OptBureauAdminPWord, SizeOf(OptBureauAdminPWord));  // SQL=varbinary, Delphi=String[10]
    OptShowViewCompanyParam.Value := OptShowViewCompany;                                   // SQL=bit, Delphi=Boolean
  End; // With DataRec.CompOpt
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCompanyDataWrite_UserCountVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup and Prepare the Insert statement
  FADOQuery.SQL.Text := 'INSERT INTO Common.Company (' +
                                                     'RecPfix, ' +
                                                     'CompanyCode1, ' +
                                                     'Company_code2, ' +
                                                     'Company_code3, ' +
                                                     'ucCompanyId, ' +
                                                     'ucWStationId, ' +
                                                     'ucUserId, ' +
                                                     'ucRefCount' +
                                                     ')' +
                        'VALUES (' +
                                 ':RecPfix, ' +
                                 ':CompanyCode1, ' +
                                 ':Company_code2, ' +
                                 ':Company_code3, ' +
                                 ':ucCompanyId, ' +
                                 ':ucWStationId, ' +
                                 ':ucUserId, ' +
                                 ':ucRefCount' +
                                 ')';
  FADOQuery.Prepared := True;

  // Link the local references to the parameter objects in the prepared ADO Query
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    CompanyCode1Param := FindParam('CompanyCode1');
    Company_code2Param := FindParam('Company_code2');
    Company_code3Param := FindParam('Company_code3');

    ucCompanyIdParam := FindParam('ucCompanyId');
    ucWStationIdParam := FindParam('ucWStationId');
    ucUserIdParam := FindParam('ucUserId');
    ucRefCountParam := FindParam('ucRefCount');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TCompanyDataWrite_UserCountVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^CompRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecPFix);        // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec.UserRef Do
  Begin
    // Common indexed columns
    CompanyCode1Param.Value := CreateVariantArray (@ucCode, SizeOf(ucCode));    // SQL=varbinary, Delphi=String[CompCodeLen]
    Company_code2Param.Value := ucName;                                         // SQL=varchar, Delphi=String[CompNameLen]
    Company_code3Param.Value := CreateVariantArray (@ucPath, SizeOf(ucPath));   // SQL=varbinary, Delphi=String[CompPathLen]

    ucCompanyIdParam.Value := ucCompanyId;                                      // SQL=int, Delphi=LongInt
    ucWStationIdParam.Value := ucWStationId;                                    // SQL=varchar, Delphi=String[40]
    ucUserIdParam.Value := ucUserId;                                            // SQL=varchar, Delphi=String[40]
    ucRefCountParam.Value := ucRefCount;                                        // SQL=int, Delphi=SmallInt
  End; // With DataRec.UserRef
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCompanyDataWrite_PlugInSecurityVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup and Prepare the Insert statement
  FADOQuery.SQL.Text := 'INSERT INTO Common.Company (' +
                                                     'RecPfix, ' +
                                                     'CompanyCode1, ' +
                                                     'Company_code2, ' +
                                                     'Company_code3, ' +
                                                     'hkId, ' +
                                                     'hkSecCode, ' +
                                                     'hkDesc, ' +
                                                     'hkStuff, ' +
                                                     'hkMessage, ' +
                                                     'hkVersion, ' +
                                                     'hkEncryptedCode' +
                                                     ')' +
                        'VALUES (' +
                                 ':RecPfix, ' +
                                 ':CompanyCode1, ' +
                                 ':Company_code2, ' +
                                 ':Company_code3, ' +
                                 ':hkId, ' +
                                 ':hkSecCode, ' +
                                 ':hkDesc, ' +
                                 ':hkStuff, ' +
                                 ':hkMessage, ' +
                                 ':hkVersion, ' +
                                 ':hkEncryptedCode' +
                                 ')';
  FADOQuery.Prepared := True;

  // Link the local references to the parameter objects in the prepared ADO Query
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    CompanyCode1Param := FindParam('CompanyCode1');
    Company_code2Param := FindParam('Company_code2');
    Company_code3Param := FindParam('Company_code3');

    hkIdParam := FindParam('hkId');
    hkSecCodeParam := FindParam('hkSecCode');
    hkDescParam := FindParam('hkDesc');
    hkStuffParam := FindParam('hkStuff');
    hkMessageParam := FindParam('hkMessage');
    hkVersionParam := FindParam('hkVersion');
    hkEncryptedCodeParam := FindParam('hkEncryptedCode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TCompanyDataWrite_PlugInSecurityVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^CompRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecPFix);        // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec.PlugInSec Do
  Begin
    // Common indexed columns
    CompanyCode1Param.Value := CreateVariantArray (@hkCode, SizeOf(hkCode));    // SQL=varbinary, Delphi=String[CompCodeLen]
    Company_code2Param.Value := hkName;                                         // SQL=varchar, Delphi=String[CompNameLen]
    Company_code3Param.Value := CreateVariantArray (@hkPath, SizeOf(hkPath));   // SQL=varbinary, Delphi=String[CompPathLen]

    hkIdParam.Value := hkId;                                                  // SQL=varchar, Delphi=String[16]
    hkSecCodeParam.Value := hkSecCode;                                        // SQL=varchar, Delphi=String[16]
    hkDescParam.Value := hkDesc;                                              // SQL=varchar, Delphi=String[100]
    hkStuffParam.Value := CreateVariantArray (@hkSecType, CalculateBinaryBlockSize (@hkSecType, @hkMessage));   // SQL=varbinary, Delphi=Binary
    hkMessageParam.Value := hkMessage;                                        // SQL=varchar, Delphi=String[100]
    hkVersionParam.Value := hkVersion;                                        // SQL=int, Delphi=SmallInt
    hkEncryptedCodeParam.Value := CreateVariantArray (@hkEncryptedCode, SizeOf(hkEncryptedCode));               // SQL=varbinary, Delphi=String[16]
  End; // With DataRec.PlugInSec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCompanyDataWrite_AccessControlVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup and Prepare the Insert statement
  FADOQuery.SQL.Text := 'INSERT INTO Common.Company (' +
                                                     'RecPfix, ' +
                                                     'CompanyCode1, ' +
                                                     'Company_code2, ' +
                                                     'Company_code3, ' +
                                                     'acSystemId' +
                                                     ')' +
                        'VALUES (' +
                                 ':RecPfix, ' +
                                 ':CompanyCode1, ' +
                                 ':Company_code2, ' +
                                 ':Company_code3, ' +
                                 ':acSystemId' +
                                 ')';
  FADOQuery.Prepared := True;

  // Link the local references to the parameter objects in the prepared ADO Query
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    CompanyCode1Param := FindParam('CompanyCode1');
    Company_code2Param := FindParam('Company_code2');
    Company_code3Param := FindParam('Company_code3');

    acSystemIdParam := FindParam('acSystemId');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TCompanyDataWrite_AccessControlVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^CompRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecPFix);      // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec.AccessControl Do
  Begin
    // Common indexed columns
    CompanyCode1Param.Value := CreateVariantArray (@acCode, SizeOf(acCode));    // SQL=varbinary, Delphi=String[CompCodeLen]
    Company_code2Param.Value := acNotUsed;                                      // SQL=varchar, Delphi=String[CompNameLen]
    Company_code3Param.Value := CreateVariantArray (@acPath, SizeOf(acPath));   // SQL=varbinary, Delphi=String[CompPathLen]

    acSystemIdParam.Value := ConvertCharToSQLEmulatorVarChar(acSystemId);       // SQL=varchar, Delphi=Char
  End; // With DataRec.AccessControl
End; // SetQueryValues

//=========================================================================



End.

