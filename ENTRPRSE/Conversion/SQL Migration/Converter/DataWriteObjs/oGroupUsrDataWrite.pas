Unit oGroupUsrDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TGroupUsrDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    guGroupCodeParam, guUserCodeParam, guUserNameParam, guPasswordParam, 
    guPermissionsParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TGroupUsrDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, GroupUsersFile;

//=========================================================================

Constructor TGroupUsrDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TGroupUsrDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TGroupUsrDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO Common.GroupUsr (' +
                                                      'guGroupCode, ' +
                                                      'guUserCode, ' +
                                                      'guUserName, ' +
                                                      'guPassword, ' +
                                                      'guPermissions' +
                                                     ') ' +
                        'VALUES (' +
                                 ':guGroupCode, ' +
                                 ':guUserCode, ' +
                                 ':guUserName, ' +
                                 ':guPassword, ' +
                                 ':guPermissions' +
                                 ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    guGroupCodeParam := FindParam('guGroupCode');
    guUserCodeParam := FindParam('guUserCode');
    guUserNameParam := FindParam('guUserName');
    guPasswordParam := FindParam('guPassword');
    guPermissionsParam := FindParam('guPermissions');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TGroupUsrDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^GroupUsersFileRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    guGroupCodeParam.Value := guGroupCode;                                                       // SQL=varchar, Delphi=String[20]
    guUserCodeParam.Value := guUserCode;                                                         // SQL=varchar, Delphi=String[20]
    guUserNameParam.Value := guUserName;                                                         // SQL=varchar, Delphi=String[50]
    guPasswordParam.Value := CreateVariantArray (@guPassword, SizeOf(guPassword));               // SQL=varbinary, Delphi=String[10]
    guPermissionsParam.Value := CreateVariantArray (@guPermissions, SizeOf(guPermissions));      // SQL=varbinary, Delphi=Array [1..100] Of Boolean
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

