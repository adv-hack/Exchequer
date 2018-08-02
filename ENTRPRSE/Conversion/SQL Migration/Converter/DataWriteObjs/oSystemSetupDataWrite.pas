unit oSystemSetupDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSystemSetupDataWrite = Class(TBaseDataWrite)
  Private
    FTableName: string;
    FADOQuery : TADOQuery;
    sysIdParam: TParameter;
    sysNameParam: TParameter;
    sysDescriptionParam: TParameter;
    sysValueParam: TParameter;
    sysTypeParam: TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Method to
    //  (a) populate the ADO Query with the data from the DataPacket
    //  (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSystemSetupDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst,
  oSystemSetupBtrieveFile;

// ---------------------------------------------------------------------------

Constructor TSystemSetupDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  FTableName := 'SystemSetup';
End; // Create

// ---------------------------------------------------------------------------

Destructor TSystemSetupDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

// ---------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSystemSetupDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].' + FTableName + ' (' +
                                               'sysId, ' +
                                               'sysName, ' +
                                               'sysDescription, ' +
                                               'sysValue, ' +
                                               'sysType ' +
                                               ') ' +
              'VALUES (' +
                       ':sysId, ' +
                       ':sysName, ' +
                       ':sysDescription, ' +
                       ':sysValue, ' +
                       ':sysType ' +
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    sysIdParam := FindParam('sysId');
    sysNameParam := FindParam('sysName');
    sysDescriptionParam := FindParam('sysDescription');
    sysValueParam := FindParam('sysValue');
    sysTypeParam := FindParam('sysType');
  End; // With FADOQuery.Parameters
End; // Prepare

// ---------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSystemSetupDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^SystemSetupRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    sysIdParam.Value := sysId;
    sysNameParam.Value := sysName;
    sysDescriptionParam.Value := sysDescription;
    sysValueParam.Value := sysValue;
    sysTypeParam.Value := sysType;
  End; // With DataRec^
End; // SetParameterValues

// -----------------------------------------------------------------------------

End.

