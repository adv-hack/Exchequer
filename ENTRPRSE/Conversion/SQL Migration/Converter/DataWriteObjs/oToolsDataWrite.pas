Unit oToolsDataWrite;

Interface

Uses SysUtils, ADODB, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TToolsDataWrite_MenuItemVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    recordtypeParam, Toolscode1Param, Toolscode2Param, Toolscode3Param,

    // Variant specific columns - Menu Items
    mifolionoParam, miavailabilityParam, micompanyParam, miitemtypeParam,
    midescriptionParam, mifilenameParam, mistartdirParam, miparametersParam,
    mihelptextParam, miallusersParam, miallcompaniesParam, micomponentnameParam,
    miparentcomponentnameParam, mipositionParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TToolsDataWrite_MenuItemVariant

  //------------------------------

  TToolsDataWrite_UserXRefVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    recordtypeParam, Toolscode1Param, Toolscode2Param, Toolscode3Param,

    // Variant specific columns - User Cross Ref
    uxitemfolioParam, uxusernameParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TToolsDataWrite_UserXRefVariant

  //------------------------------

  TToolsDataWrite_SysSetupVariant = Class(TDataWrite_BaseSubVariant)
  Private
    recordtypeParam, Toolscode1Param, Toolscode2Param, Toolscode3Param,

    // Variant specific columns - System Records
    ssusepasswordParam, sspasswordParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TToolsDataWrite_SysSetupVariant

  //------------------------------

  TToolsDataWrite_CompanyXRefVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common columns
    recordtypeParam, Toolscode1Param, Toolscode2Param, Toolscode3Param,

    // Variant specific columns - Company Cross ref Record
    cxitemfolioParam, cxcompanycodeParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TToolsDataWrite_CompanyXRefVariant

  //------------------------------

  TToolsDataWrite = Class(TBaseDataWrite)
  Private
    FMenuItemVariant : TToolsDataWrite_MenuItemVariant;
    FUserXRefVariant : TToolsDataWrite_UserXRefVariant;
    FSysSetupVariant : TToolsDataWrite_SysSetupVariant;
    FCompanyXRefVariant : TToolsDataWrite_CompanyXRefVariant;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TToolsDataWrite

Implementation

Uses GlobVar, BtrvU2, SQLConvertUtils, DataConversionWarnings, LoggingUtils, ToolBTFiles;


//=========================================================================

Constructor TToolsDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FMenuItemVariant := TToolsDataWrite_MenuItemVariant.Create;
  FUserXRefVariant := TToolsDataWrite_UserXRefVariant.Create;
  FSysSetupVariant := TToolsDataWrite_SysSetupVariant.Create;
  FCompanyXRefVariant := TToolsDataWrite_CompanyXRefVariant.Create;
End; // Create

//------------------------------

Destructor TToolsDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FMenuItemVariant);
  FreeAndNIL(FUserXRefVariant);
  FreeAndNIL(FSysSetupVariant);
  FreeAndNIL(FCompanyXRefVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TToolsDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FMenuItemVariant.Prepare (ADOConnection, CompanyCode);
  FUserXRefVariant.Prepare (ADOConnection, CompanyCode);
  FSysSetupVariant.Prepare (ADOConnection, CompanyCode);
  FCompanyXRefVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TToolsDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TToolRec;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  Case DataRec.RecordType Of
    //  - Menu Items
    'M'  : FMenuItemVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    //  - MCM Setup & Licencing
    'U'  : FUserXRefVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    //  - User Cross Ref
    'S'  : FSysSetupVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);

    //  - Company Cross Ref
    'C'  : FCompanyXRefVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  Else
    // Unknown Data - Log error and continue conversion
    SkipRecord := True;
    sDumpFile := DataPacket.DumpToFile;
    ConversionWarnings.AddWarning(TSQLUnknownVariantWarning.Create (DataPacket, sDumpFile, ToHexString(@DataRec^.RecordType, SizeOf(DataRec^.RecordType))));
    Logging.UnknownVariant(Trim(DataPacket.CompanyDetails.ccCompanyPath) + DataPacket.TaskDetails.dctPervasiveFilename, ToHexString(@DataRec^.RecordType, SizeOf(DataRec^.RecordType)), sDumpFile);
  End; // Case DataRec.RecordType
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TToolsDataWrite_MenuItemVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.Tools (' +
                                            'recordtype, ' +
                                            'Toolscode1, ' +
                                            'Toolscode2, ' +
                                            'Toolscode3, ' +
                                            'mifoliono, ' +
                                            'miavailability, ' +
                                            'micompany, ' +
                                            'miitemtype, ' +
                                            'midescription, ' +
                                            'mifilename, ' +
                                            'mistartdir, ' +
                                            'miparameters, ' +
                                            'mihelptext, ' +
                                            'miallusers, ' +
                                            'miallcompanies, ' +
                                            'micomponentname, ' +
                                            'miparentcomponentname, ' +
                                            'miposition' +
                                            ') ' +
              'VALUES (' +
                       ':recordtype, ' +
                       ':Toolscode1, ' +
                       ':Toolscode2, ' +
                       ':Toolscode3, ' +
                       ':mifoliono, ' +
                       ':miavailability, ' +
                       ':micompany, ' +
                       ':miitemtype, ' +
                       ':midescription, ' +
                       ':mifilename, ' +
                       ':mistartdir, ' +
                       ':miparameters, ' +
                       ':mihelptext, ' +
                       ':miallusers, ' +
                       ':miallcompanies, ' +
                       ':micomponentname, ' +
                       ':miparentcomponentname, ' +
                       ':miposition' +
                       ')';

  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    recordtypeParam := FindParam('recordtype');
    Toolscode1Param := FindParam('Toolscode1');
    Toolscode2Param := FindParam('Toolscode2');
    Toolscode3Param := FindParam('Toolscode3');
    mifolionoParam := FindParam('mifoliono');
    miavailabilityParam := FindParam('miavailability');
    micompanyParam := FindParam('micompany');
    miitemtypeParam := FindParam('miitemtype');
    midescriptionParam := FindParam('midescription');
    mifilenameParam := FindParam('mifilename');
    mistartdirParam := FindParam('mistartdir');
    miparametersParam := FindParam('miparameters');
    mihelptextParam := FindParam('mihelptext');
    miallusersParam := FindParam('miallusers');
    miallcompaniesParam := FindParam('miallcompanies');
    micomponentnameParam := FindParam('micomponentname');
    miparentcomponentnameParam := FindParam('miparentcomponentname');
    mipositionParam := FindParam('miposition');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TToolsDataWrite_MenuItemVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TToolRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecordTypeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecordType);           // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec^, MenuItem Do
  Begin
    recordtypeParam.Value := ConvertCharToSQLEmulatorVarChar(RecordType);                 // SQL=varchar, Delphi=Char
    Toolscode1Param.Value := CreateVariantArray (@IndexA10, SizeOf(IndexA10));// SQL=varbinary, Delphi=string[10]
    Toolscode2Param.Value := CreateVariantArray (@IndexB50, SizeOf(IndexB50));// SQL=varbinary, Delphi=string[50]
    Toolscode3Param.Value := CreateVariantArray (@IndexC60, SizeOf(IndexC60));// SQL=varbinary, Delphi=string[60]

    mifolionoParam.Value := miFolioNo;                                                    // SQL=int, Delphi=LongInt
    miavailabilityParam.Value := ConvertCharToSQLEmulatorVarChar(miAvailability);         // SQL=varchar, Delphi=Char
    micompanyParam.Value := miCompany;                                                    // SQL=varchar, Delphi=string[6]
    miitemtypeParam.Value := ConvertCharToSQLEmulatorVarChar(miItemType);                 // SQL=varchar, Delphi=Char
    midescriptionParam.Value := miDescription;                                            // SQL=varchar, Delphi=string[50]
    mifilenameParam.Value := miFilename;                                                  // SQL=varchar, Delphi=string[255]
    mistartdirParam.Value := miStartDir;                                                  // SQL=varchar, Delphi=string[255]
    miparametersParam.Value := miParameters;                                              // SQL=varchar, Delphi=string[255]
    mihelptextParam.Value := miHelpText;                                                  // SQL=varchar, Delphi=string[150]
    miallusersParam.Value := miAllUsers;                                                  // SQL=bit, Delphi=boolean
    miallcompaniesParam.Value := miAllCompanies;                                          // SQL=bit, Delphi=boolean
    micomponentnameParam.Value := miComponentName;                                        // SQL=varchar, Delphi=string[50]
    miparentcomponentnameParam.Value := miParentComponentName;                            // SQL=varchar, Delphi=string[50]
    mipositionParam.Value := miPosition;                                                  // SQL=int, Delphi=LongInt
  End; // With DataRec.CompDet
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TToolsDataWrite_UserXRefVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup and Prepare the Insert statement
  FADOQuery.SQL.Text := 'INSERT INTO common.Tools (' +
                                            'recordtype, ' +
                                            'Toolscode1, ' +
                                            'Toolscode2, ' +
                                            'Toolscode3, ' +
                                            'uxitemfolio, ' +
                                            'uxusername' +
                                            ') ' +
              'VALUES (' +
                       ':recordtype, ' +
                       ':Toolscode1, ' +
                       ':Toolscode2, ' +
                       ':Toolscode3, ' +
                       ':uxitemfolio, ' +
                       ':uxusername' +
                       ')';

  FADOQuery.Prepared := True;

  // Link the local references to the parameter objects in the prepared ADO Query
  With FADOQuery.Parameters Do
  Begin
    recordtypeParam := FindParam('recordtype');
    Toolscode1Param := FindParam('Toolscode1');
    Toolscode2Param := FindParam('Toolscode2');
    Toolscode3Param := FindParam('Toolscode3');

    uxitemfolioParam := FindParam('uxitemfolio');
    uxusernameParam := FindParam('uxusername');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TToolsDataWrite_UserXRefVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TToolRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecordTypeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecordType);        // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec^, UserXRef Do
  Begin
    recordtypeParam.Value := ConvertCharToSQLEmulatorVarChar(RecordType);                 // SQL=varchar, Delphi=Char
    Toolscode1Param.Value := CreateVariantArray (@IndexA10, SizeOf(IndexA10));// SQL=varbinary, Delphi=string[10]
    Toolscode2Param.Value := CreateVariantArray (@IndexB50, SizeOf(IndexB50));// SQL=varbinary, Delphi=string[50]
    Toolscode3Param.Value := CreateVariantArray (@IndexC60, SizeOf(IndexC60));// SQL=varbinary, Delphi=string[60]

    uxitemfolioParam.Value := uxItemFolio;                                                // SQL=int, Delphi=LongInt
    uxusernameParam.Value := uxUserName;                                                  // SQL=varchar, Delphi=string[10]
  End; // With DataRec.CompOpt
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TToolsDataWrite_SysSetupVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup and Prepare the Insert statement
  FADOQuery.SQL.Text := 'INSERT INTO common.Tools (' +
                                            'recordtype, ' +
                                            'Toolscode1, ' +
                                            'Toolscode2, ' +
                                            'Toolscode3, ' +
                                            'ssusepassword, ' +
                                            'sspassword' +
                                            ') ' +
              'VALUES (' +
                       ':recordtype, ' +
                       ':Toolscode1, ' +
                       ':Toolscode2, ' +
                       ':Toolscode3, ' +
                       ':ssusepassword, ' +
                       ':sspassword' +
                       ')';

  FADOQuery.Prepared := True;

  // Link the local references to the parameter objects in the prepared ADO Query
  With FADOQuery.Parameters Do
  Begin
    recordtypeParam := FindParam('recordtype');
    Toolscode1Param := FindParam('Toolscode1');
    Toolscode2Param := FindParam('Toolscode2');
    Toolscode3Param := FindParam('Toolscode3');

    ssusepasswordParam := FindParam('ssusepassword');
    sspasswordParam := FindParam('sspassword');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TToolsDataWrite_SysSetupVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TToolRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecordTypeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecordType);        // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec^, SysSetup Do
  Begin
    // Common indexed columns
    recordtypeParam.Value := ConvertCharToSQLEmulatorVarChar(RecordType);                 // SQL=varchar, Delphi=Char
    Toolscode1Param.Value := CreateVariantArray (@IndexA10, SizeOf(IndexA10));// SQL=varbinary, Delphi=string[10]
    Toolscode2Param.Value := CreateVariantArray (@IndexB50, SizeOf(IndexB50));// SQL=varbinary, Delphi=string[50]
    Toolscode3Param.Value := CreateVariantArray (@IndexC60, SizeOf(IndexC60));// SQL=varbinary, Delphi=string[60]

    ssusepasswordParam.Value := ssUsePassword;                                            // SQL=bit, Delphi=boolean
    sspasswordParam.Value := ssPassword;                                                  // SQL=varchar, Delphi=String50
  End; // With DataRec.UserRef
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TToolsDataWrite_CompanyXRefVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup and Prepare the Insert statement
  FADOQuery.SQL.Text := 'INSERT INTO common.Tools (' +
                                            'recordtype, ' +
                                            'Toolscode1, ' +
                                            'Toolscode2, ' +
                                            'Toolscode3, ' +
                                            'cxitemfolio, ' +
                                            'cxcompanycode' +
                                            ') ' +
              'VALUES (' +
                       ':recordtype, ' +
                       ':Toolscode1, ' +
                       ':Toolscode2, ' +
                       ':Toolscode3, ' +
                       ':cxitemfolio, ' +
                       ':cxcompanycode' +
                       ')';

  FADOQuery.Prepared := True;

  // Link the local references to the parameter objects in the prepared ADO Query
  With FADOQuery.Parameters Do
  Begin
    recordtypeParam := FindParam('recordtype');
    Toolscode1Param := FindParam('Toolscode1');
    Toolscode2Param := FindParam('Toolscode2');
    Toolscode3Param := FindParam('Toolscode3');

    cxitemfolioParam := FindParam('cxitemfolio');
    cxcompanycodeParam := FindParam('cxcompanycode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TToolsDataWrite_CompanyXRefVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TToolRec;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  // Common Fields
  RecordTypeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.RecordType);        // SQL=varchar, Delphi=Char

  // Variant specific fields
  With DataRec^, CompanyXRef Do
  Begin
    // Common indexed columns
    recordtypeParam.Value := ConvertCharToSQLEmulatorVarChar(RecordType);                 // SQL=varchar, Delphi=Char
    Toolscode1Param.Value := CreateVariantArray (@IndexA10, SizeOf(IndexA10));// SQL=varbinary, Delphi=string[10]
    Toolscode2Param.Value := CreateVariantArray (@IndexB50, SizeOf(IndexB50));// SQL=varbinary, Delphi=string[50]
    Toolscode3Param.Value := CreateVariantArray (@IndexC60, SizeOf(IndexC60));// SQL=varbinary, Delphi=string[60]

    cxitemfolioParam.Value := cxItemFolio;                                                // SQL=int, Delphi=LongInt
    cxcompanycodeParam.Value := cxCompanyCode;                                            // SQL=varchar, Delphi=string[6]
  End; // With DataRec.PlugInSec
End; // SetQueryValues

//=========================================================================

End.


