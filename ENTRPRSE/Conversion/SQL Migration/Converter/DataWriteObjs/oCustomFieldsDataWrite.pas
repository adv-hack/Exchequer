Unit oCustomFieldsDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TCustomFieldsDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    cfFieldIDParam, cfStopCharParam, cfSupportsEnablementParam, cfEnabledParam,
    cfCaptionParam, cfDescriptionParam : TParameter;
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    cfDisplayPIIOptionParam, cfContainsPIIDataParam : TParameter;

    DeleteExistingRows : Boolean;
    // Need to clear-down the rows automatically inserted by the creation script
    Procedure ClearDownTable (Const DataPacket : TDataPacket);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCustomFieldsDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, CustomFieldsVar, LoggingUtils, DataConversionWarnings;

//=========================================================================

Constructor TCustomFieldsDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TCustomFieldsDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCustomFieldsDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // MH 22/08/2012 ABSEXCH-13334: Need to clear-down the rows automatically inserted by the creation script
  DeleteExistingRows := True;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].CustomFields (' +
                                                   'cfFieldID, ' +
                                                   'cfStopChar, ' +
                                                   'cfSupportsEnablement, ' +
                                                   'cfEnabled, ' +
                                                   'cfCaption, ' +
                                                   'cfDescription, ' +
                                                   // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                                                   'cfDisplayPIIOption, ' +
                                                   'cfContainsPIIData' +
                                                   ') ' +
              'VALUES (' +
                       ':cfFieldID, ' +
                       ':cfStopChar, ' +
                       ':cfSupportsEnablement, ' +
                       ':cfEnabled, ' +
                       ':cfCaption, ' +
                       ':cfDescription, ' +
                       // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                       ':cfDisplayPIIOption, ' +
                       ':cfContainsPIIData' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    cfFieldIDParam := FindParam('cfFieldID');
    cfStopCharParam := FindParam('cfStopChar');
    cfSupportsEnablementParam := FindParam('cfSupportsEnablement');
    cfEnabledParam := FindParam('cfEnabled');
    cfCaptionParam := FindParam('cfCaption');
    cfDescriptionParam := FindParam('cfDescription');
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    cfDisplayPIIOptionParam := FindParam('cfDisplayPIIOption');
    cfContainsPIIDataParam := FindParam('cfContainsPIIData');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Need to clear-down the rows automatically inserted by the creation script
Procedure TCustomFieldsDataWrite.ClearDownTable (Const DataPacket : TDataPacket);
Var
  ADOQuery : TADOQuery;
  Res : Integer;
Begin // ClearDownTable
  // Use a local ADOQuery instance to avoid screwing over the prepared Insert statement
  ADOQuery := TADOQuery.Create(NIL);
  Try
    // Re-use the existing connection
    ADOQuery.Connection := FADOQuery.Connection;

    Try
      ADOQuery.SQL.Text := 'DELETE FROM [' + TRIM(DataPacket.CompanyDetails.ccCompanyCode) + '].CustomFields';
      Res := ADOQuery.ExecSQL;
      If (ADOQuery.Connection.Errors.Count > 0) Then
      Begin
        // Log error and continue conversion
        ConversionWarnings.AddWarning(TSQLExecutionErrorWarning.Create (DataPacket, '', ADOQuery.SQL.Text, Res, ADOQuery.Connection));
        Logging.SQLError ('TCustomFieldsDataWrite.ClearDownTable ' + Logging.ThreadIdString, ADOQuery.SQL.Text, '', Res, ADOQuery.Connection);
      End; // If (ADOQuery.Connection.Errors.Count > 0)
    Except
      On E:Exception Do
      begin
        // Log error and continue conversion
        ConversionWarnings.AddWarning(TSQLExecutionExceptionWarning.Create (DataPacket, '', ADOQuery.SQL.Text, E.Message));
        Logging.SQLException ('TCustomFieldsDataWrite.ClearDownTable ' + Logging.ThreadIdString, ADOQuery.SQL.Text, '', E.Message)
      end;
    End; // Try..Except
  Finally
    ADOQuery.Connection := Nil;
    ADOQuery.Free;
  End; // Try..Finally
End; // ClearDownTable

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TCustomFieldsDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TCustomFieldSettings;
Begin // SetParameterValues
  // MH 22/08/2012 ABSEXCH-13334: Need to clear-down the rows automatically inserted by the creation script - the
  // custom fields table will run sequentially in a single thread so we don't need to worry about this running in
  // multiple threads 
  If DeleteExistingRows Then
  Begin
    ClearDownTable (DataPacket);
    DeleteExistingRows := False;
  End; // If DeleteExistingRows

  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    cfFieldIDParam.Value := cfFieldID;                                            // SQL=int, Delphi=Longint
    cfStopCharParam.Value := ConvertCharToSQLEmulatorVarChar(cfStopChar);         // SQL=varchar, Delphi=Char
    cfSupportsEnablementParam.Value := cfSupportsEnablement;                      // SQL=bit, Delphi=Boolean
    cfEnabledParam.Value := cfEnabled;                                            // SQL=bit, Delphi=Boolean
    cfCaptionParam.Value := cfCaption;                                            // SQL=varchar, Delphi=String[30]
    cfDescriptionParam.Value := cfDescription;                                    // SQL=varchar, Delphi=String[255]

    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    cfDisplayPIIOptionParam.Value := cfDisplayPIIOption;
    cfContainsPIIDataParam.Value := cfContainsPIIData;
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

