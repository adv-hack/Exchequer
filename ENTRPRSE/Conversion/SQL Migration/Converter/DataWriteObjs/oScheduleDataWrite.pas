Unit oScheduleDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TScheduleDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    sttasktypeParam, sttasknameParam, stnextrundueParam, sttaskidParam, 
    stscheduletypeParam, stdaynumberParam, sttimeofdayParam, stintervalParam, 
    ststarttimeParam, stendtimeParam, ststatusParam, stemailaddressParam, 
    stlastrunParam, stlastupdatedParam, stlastupdatedbyParam, sttimetypeParam, 
    stincludeinPostParam, stpostprotectedParam, stpostseparatedParam, stcustomclassNameParam, 
    stOneTimeOnlyParam, stRestartCountParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TScheduleDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst, SchedVar;

//=========================================================================

Constructor TScheduleDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TScheduleDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TScheduleDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].Schedule (' + 
                                               'sttasktype, ' + 
                                               'sttaskname, ' + 
                                               'stnextrundue, ' + 
                                               'sttaskid, ' + 
                                               'stscheduletype, ' + 
                                               'stdaynumber, ' + 
                                               'sttimeofday, ' +
                                               'stinterval, ' + 
                                               'ststarttime, ' + 
                                               'stendtime, ' + 
                                               'ststatus, ' + 
                                               'stemailaddress, ' + 
                                               'stlastrun, ' + 
                                               'stlastupdated, ' + 
                                               'stlastupdatedby, ' + 
                                               'sttimetype, ' + 
                                               'stincludeinPost, ' + 
                                               'stpostprotected, ' + 
                                               'stpostseparated, ' + 
                                               'stcustomclassName, ' + 
                                               'stOneTimeOnly, ' + 
                                               'stRestartCount' + 
                                               ') ' + 
              'VALUES (' + 
                       ':sttasktype, ' + 
                       ':sttaskname, ' + 
                       ':stnextrundue, ' + 
                       ':sttaskid, ' + 
                       ':stscheduletype, ' + 
                       ':stdaynumber, ' + 
                       ':sttimeofday, ' + 
                       ':stinterval, ' + 
                       ':ststarttime, ' + 
                       ':stendtime, ' + 
                       ':ststatus, ' + 
                       ':stemailaddress, ' + 
                       ':stlastrun, ' + 
                       ':stlastupdated, ' + 
                       ':stlastupdatedby, ' + 
                       ':sttimetype, ' + 
                       ':stincludeinPost, ' + 
                       ':stpostprotected, ' + 
                       ':stpostseparated, ' + 
                       ':stcustomclassName, ' + 
                       ':stOneTimeOnly, ' + 
                       ':stRestartCount' + 
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    sttasktypeParam := FindParam('sttasktype');
    sttasknameParam := FindParam('sttaskname');
    stnextrundueParam := FindParam('stnextrundue');
    sttaskidParam := FindParam('sttaskid');
    stscheduletypeParam := FindParam('stscheduletype');
    stdaynumberParam := FindParam('stdaynumber');
    sttimeofdayParam := FindParam('sttimeofday');
    stintervalParam := FindParam('stinterval');
    ststarttimeParam := FindParam('ststarttime');
    stendtimeParam := FindParam('stendtime');
    ststatusParam := FindParam('ststatus');
    stemailaddressParam := FindParam('stemailaddress');
    stlastrunParam := FindParam('stlastrun');
    stlastupdatedParam := FindParam('stlastupdated');
    stlastupdatedbyParam := FindParam('stlastupdatedby');
    sttimetypeParam := FindParam('sttimetype');
    stincludeinPostParam := FindParam('stincludeinPost');
    stpostprotectedParam := FindParam('stpostprotected');
    stpostseparatedParam := FindParam('stpostseparated');
    stcustomclassNameParam := FindParam('stcustomclassName');
    stOneTimeOnlyParam := FindParam('stOneTimeOnly');
    stRestartCountParam := FindParam('stRestartCount');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TScheduleDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TScheduledTaskRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    sttasktypeParam.Value := ConvertCharToSQLEmulatorVarChar(stTaskType);         // SQL=varchar, Delphi=Char
    sttasknameParam.Value := stTaskName;                                          // SQL=varchar, Delphi=String[50]
    stnextrundueParam.Value := stNextRunDue;                                      // SQL=varchar, Delphi=String[12]
    sttaskidParam.Value := stTaskID;                                              // SQL=varchar, Delphi=String[20]
    stscheduletypeParam.Value := stScheduleType;                                  // SQL=int, Delphi=Byte
    stdaynumberParam.Value := stDayNumber;                                        // SQL=int, Delphi=longint
    sttimeofdayParam.Value := DateTimeToSQLDateTimeOrNull(stTimeOfDay);                                        // SQL=datetime, Delphi=TDateTime
    stintervalParam.Value := stInterval;                                          // SQL=int, Delphi=SmallInt
    ststarttimeParam.Value := DateTimeToSQLDateTimeOrNull(stStartTime);                                        // SQL=datetime, Delphi=TDateTime
    stendtimeParam.Value := DateTimeToSQLDateTimeOrNull(stEndTime);                                            // SQL=datetime, Delphi=TDateTime
    ststatusParam.Value := stStatus;                                              // SQL=int, Delphi=Byte
    stemailaddressParam.Value := stEmailAddress;                                  // SQL=varchar, Delphi=string[100]
    stlastrunParam.Value := DateTimeToSQLDateTimeOrNull(stLastRun);                                            // SQL=datetime, Delphi=TDateTime
    stlastupdatedParam.Value := DateTimeToSQLDateTimeOrNull(stLastUpdated);                                    // SQL=datetime, Delphi=TDateTime
    stlastupdatedbyParam.Value := stLastUpdatedBy;                                // SQL=varchar, Delphi=String[10]
    sttimetypeParam.Value := stTimeType;                                          // SQL=int, Delphi=Byte
    stincludeinPostParam.Value := stIncludeInPost;                                // SQL=bigint, Delphi=Int64
    stpostprotectedParam.Value := stPostProtected;                                // SQL=bit, Delphi=Boolean
    stpostseparatedParam.Value := stPostSeparated;                                // SQL=bit, Delphi=Boolean
    stcustomclassNameParam.Value := stCustomClassName;                            // SQL=varchar, Delphi=string[50]
    stOneTimeOnlyParam.Value := stOneTimeOnly;                                    // SQL=bit, Delphi=Boolean
    stRestartCountParam.Value := stRestartCount;                                  // SQL=int, Delphi=Byte
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

