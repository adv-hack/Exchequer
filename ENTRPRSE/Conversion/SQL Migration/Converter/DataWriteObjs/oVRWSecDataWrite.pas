Unit oVRWSecDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket, BtrvU2;

Type
  TVRWSecDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    rtstreecodeParam, rtsusercodeParam, rtssecurityParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TVRWSecDataWrite

{$I W:\Entrprse\VRW\RepEngine\VRWDataStructures.inc }

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils;

//=========================================================================

Constructor TVRWSecDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TVRWSecDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TVRWSecDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].VRWSec (' + 
                                             'rtstreecode, ' + 
                                             'rtsusercode, ' + 
                                             'rtssecurity' +
                                             ') ' +
              'VALUES (' +
                       ':rtstreecode, ' +
                       ':rtsusercode, ' +
                       ':rtssecurity' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    rtstreecodeParam := FindParam('rtstreecode');
    rtsusercodeParam := FindParam('rtsusercode');
    rtssecurityParam := FindParam('rtssecurity');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TVRWSecDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TReportTreeSecurityRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    rtstreecodeParam.Value := rtsTreeCode;         // SQL=varchar, Delphi=String[REPORT_NAME_LGTH]
    rtsusercodeParam.Value := rtsUserCode;         // SQL=varchar, Delphi=String[10]
    rtssecurityParam.Value := rtsSecurity;         // SQL=int, Delphi=TReportPermissionType
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

