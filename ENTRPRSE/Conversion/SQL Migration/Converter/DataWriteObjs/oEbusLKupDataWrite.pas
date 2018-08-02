Unit oEbusLKUpDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oBaseSubVariantDataWrite, oDataPacket;

Type
  TEbusLKUpDataWrite_LookupGenericVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, ourtradercodeParam, ouritemcodeParam, theiritemcodeParam,

    // Variant specific fields
    descriptionParam, tagParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusLKUpDataWrite_LookupGenericVariant

  //------------------------------

  TEbusLKUpDataWrite_LookupTraderVariant = Class(TDataWrite_BaseSubVariant)
  Private
    // Common fields
    RecPfixParam, SubTypeParam, ourtradercodeParam, ouritemcodeParam, theiritemcodeParam,

    // Variant specific fields
    lookuptraderParam : TParameter;
  Public
    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusLKUpDataWrite_LookupTraderVariant

  //------------------------------


  TEbusLKUpDataWrite = Class(TBaseDataWrite)
  Private
    FLookupGenericVariant : TEbusLKUpDataWrite_LookupGenericVariant;
    FLookupTraderVariant : TEbusLKUpDataWrite_LookupTraderVariant;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusLKUpDataWrite

  //------------------------------

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils, EBusLook;

//=========================================================================

Constructor TEbusLKUpDataWrite.Create;
Begin // Create
  Inherited Create;

  // Create the variant sub-objects now - not as efficient/optimised as creating them on
  // demand but results in simpler code
  FLookupGenericVariant := TEbusLKUpDataWrite_LookupGenericVariant.Create;
  FLookupTraderVariant := TEbusLKUpDataWrite_LookupTraderVariant.Create;
End; // Create

//------------------------------

Destructor TEbusLKUpDataWrite.Destroy;
Begin // Destroy
  // Destroy any sub-objects that were used for the variants
  FreeAndNIL(FLookupGenericVariant);
  FreeAndNIL(FLookupTraderVariant);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusLKUpDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  FLookupGenericVariant.Prepare (ADOConnection, CompanyCode);
  FLookupTraderVariant.Prepare (ADOConnection, CompanyCode);
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusLKUpDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEBusLookups;
  sDumpFile : ShortString;
Begin // SetQueryValues
  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Check the RecPFix/SubType to determine what to do
  If (DataRec.RecPFix in ['C', 'V']) Then
  Begin
    // Generic lookups
    FLookupGenericVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End //(DataRec.RecPFix in ['C', 'V'])
  Else If (DataRec.RecPFix = 'T') Then
  Begin
    // Trader lookup
    FLookupTraderVariant.SetQueryValues (ADOQuery, DataPacket, SkipRecord);
  End // If (DataRec.RecPFix = 'T')
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
Procedure TEbusLKUpDataWrite_LookupGenericVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].EbusLKup (' + 
                                               'RecPfix, ' + 
                                               'SubType, ' + 
                                               'ourtradercode, ' + 
                                               'ouritemcode, ' + 
                                               'theiritemcode, ' + 
                                               'description, ' + 
                                               'tag' +
                                               ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':ourtradercode, ' +
                       ':ouritemcode, ' + 
                       ':theiritemcode, ' + 
                       ':description, ' + 
                       ':tag' +
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    ourtradercodeParam := FindParam('ourtradercode');
    ouritemcodeParam := FindParam('ouritemcode');
    theiritemcodeParam := FindParam('theiritemcode');
    descriptionParam := FindParam('description');
    tagParam := FindParam('tag');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusLKUpDataWrite_LookupGenericVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEBusLookups;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, LookupGeneric Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);         // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);         // SQL=varchar, Delphi=char
    ourtradercodeParam.Value := OurTraderCode;                              // SQL=varchar, Delphi=string[10]
    ouritemcodeParam.Value := OurItemCode;                                  // SQL=varchar, Delphi=string[50]
    theiritemcodeParam.Value := TheirItemCode;                              // SQL=varchar, Delphi=string[50]

    descriptionParam.Value := Description;                                  // SQL=varchar, Delphi=string[100]
    tagParam.Value := Tag;                                                  // SQL=int, Delphi=smallint
  End; // With DataRec^.CustDiscRec
End; // SetQueryValues

//=========================================================================

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusLKUpDataWrite_LookupTraderVariant.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].EbusLKup (' + 
                                               'RecPfix, ' + 
                                               'SubType, ' + 
                                               'ourtradercode, ' + 
                                               'ouritemcode, ' + 
                                               'theiritemcode, ' +
                                               'lookuptrader' +
                                               ') ' +
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':ourtradercode, ' + 
                       ':ouritemcode, ' + 
                       ':theiritemcode, ' +
                       ':lookuptrader' +
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
    ourtradercodeParam := FindParam('ourtradercode');
    ouritemcodeParam := FindParam('ouritemcode');
    theiritemcodeParam := FindParam('theiritemcode');

    lookuptraderParam := FindParam('lookuptrader');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
// (b) return the ADOQuery in use by the descendant
Procedure TEbusLKUpDataWrite_LookupTraderVariant.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEBusLookups;
Begin // SetQueryValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Copy the properties into the parameters for the INSERT
  With DataRec^, LookupGeneric Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);         // SQL=varchar, Delphi=char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);         // SQL=varchar, Delphi=char
    ourtradercodeParam.Value := OurTraderCode;                              // SQL=varchar, Delphi=string[10]
    ouritemcodeParam.Value := OurItemCode;                                  // SQL=varchar, Delphi=string[50]
    theiritemcodeParam.Value := TheirItemCode;                              // SQL=varchar, Delphi=string[50]

    lookuptraderParam.Value := '';                                // SQL=varchar, Delphi=string[10]
  End; // With DataRec^, CustDiscRec
End; // SetQueryValues

//=========================================================================


End.

