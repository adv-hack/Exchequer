Unit oSchedCFGDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSchedCFGDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    scidParam, scofflinestartParam, scofflineendParam, scdefaultemailParam, 
    sctimestampParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSchedCFGDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2, AuthVar, SchedVar;

//=========================================================================

Constructor TSchedCFGDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSchedCFGDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSchedCFGDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.SchedCFG (' +
                                               'scid, ' + 
                                               'scofflinestart, ' + 
                                               'scofflineend, ' + 
                                               'scdefaultemail, ' + 
                                               'sctimestamp' + 
                                               ') ' + 
              'VALUES (' + 
                       ':scid, ' + 
                       ':scofflinestart, ' +
                       ':scofflineend, ' +
                       ':scdefaultemail, ' +
                       ':sctimestamp' +
                       ')';



  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    scidParam := FindParam('scid');
    scofflinestartParam := FindParam('scofflinestart');
    scofflineendParam := FindParam('scofflineend');
    scdefaultemailParam := FindParam('scdefaultemail');
    sctimestampParam := FindParam('sctimestamp');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSchedCFGDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^TSchedulerConfigRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    scidParam.Value := scID;                             // SQL=varchar, Delphi=String[10]
    scofflinestartParam.Value := DateTimeToSQLDateTimeOrNull(scOfflineStart);         // SQL=datetime, Delphi=TDateTime
    scofflineendParam.Value := DateTimeToSQLDateTimeOrNull(scOfflineEnd);             // SQL=datetime, Delphi=TDateTime
    scdefaultemailParam.Value := scDefaultEmail;         // SQL=varchar, Delphi=string[100]
    sctimestampParam.Value := DateTimeToSQLDateTimeOrNull(scTimeStamp);               // SQL=datetime, Delphi=TDateTime
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

