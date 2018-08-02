Unit oVRWTreeDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket, BtrvU2;

Type
  TVRWTreeDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    rtnodetypeParam, rtrepnameParam, rtrepdescParam, rtparentnameParam, 
    rtfilenameParam, rtlastrunParam, rtlastrunuserParam, rtpositionnumberParam, 
    rtindexfixParam, rtalloweditParam, rtfileexistsParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TVRWTreeDataWrite

{$I W:\Entrprse\VRW\RepEngine\VRWDataStructures.inc }

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils;

//=========================================================================

Constructor TVRWTreeDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TVRWTreeDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TVRWTreeDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].VRWTree (' + 
                                              'rtnodetype, ' + 
                                              'rtrepname, ' + 
                                              'rtrepdesc, ' + 
                                              'rtparentname, ' + 
                                              'rtfilename, ' + 
                                              'rtlastrun, ' + 
                                              'rtlastrunuser, ' + 
                                              'rtpositionnumber, ' + 
                                              'rtindexfix, ' + 
                                              'rtallowedit, ' + 
                                              'rtfileexists' + 
                                              ') ' + 
              'VALUES (' + 
                       ':rtnodetype, ' + 
                       ':rtrepname, ' + 
                       ':rtrepdesc, ' + 
                       ':rtparentname, ' + 
                       ':rtfilename, ' + 
                       ':rtlastrun, ' + 
                       ':rtlastrunuser, ' +
                       ':rtpositionnumber, ' +
                       ':rtindexfix, ' + 
                       ':rtallowedit, ' + 
                       ':rtfileexists' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    rtnodetypeParam := FindParam('rtnodetype');
    rtrepnameParam := FindParam('rtrepname');
    rtrepdescParam := FindParam('rtrepdesc');
    rtparentnameParam := FindParam('rtparentname');
    rtfilenameParam := FindParam('rtfilename');
    rtlastrunParam := FindParam('rtlastrun');
    rtlastrunuserParam := FindParam('rtlastrunuser');
    rtpositionnumberParam := FindParam('rtpositionnumber');
    rtindexfixParam := FindParam('rtindexfix');
    rtalloweditParam := FindParam('rtallowedit');
    rtfileexistsParam := FindParam('rtfileexists');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TVRWTreeDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TVRWReportDataRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    rtnodetypeParam.Value := ConvertCharToSQLEmulatorVarChar(rtNodeType);         // SQL=varchar, Delphi=char
    rtrepnameParam.Value := rtRepName;                                            // SQL=varchar, Delphi=String[REPORT_NAME_LGTH]
    rtrepdescParam.Value := rtRepDesc;                                            // SQL=varchar, Delphi=String[255]
    rtparentnameParam.Value := rtParentName;                                      // SQL=varchar, Delphi=String[50]
    rtfilenameParam.Value := rtFileName;                                          // SQL=varchar, Delphi=String[80]
    rtlastrunParam.Value := DateTimeToSQLDateTimeOrNull(rtLastRun);               // SQL=datetime, Delphi=TDateTime
    rtlastrunuserParam.Value := rtLastRunUser;                                    // SQL=varchar, Delphi=String[10]
    rtpositionnumberParam.Value := rtPositionNumber;                              // SQL=int, Delphi=LongInt
    rtindexfixParam.Value := Ord(rtIndexFix);                                     // SQL=int, Delphi=char
    rtalloweditParam.Value := rtAllowEdit;                                        // SQL=bit, Delphi=Boolean
    rtfileexistsParam.Value := rtFileExists;                                      // SQL=bit, Delphi=Boolean
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

