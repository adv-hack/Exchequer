unit oAccountContactRoleDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TAccountContactRoleDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    FTableName: string;
    acrContactIdParam,
    acrRoleIdParam: TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Method to
    //  (a) populate the ADO Query with the data from the DataPacket
    //  (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TAccountContactRoleDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, oAccountContactRoleBtrieveFile;

// -----------------------------------------------------------------------------

Constructor TAccountContactRoleDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  FTableName := 'AccountContactRole';
End; // Create

// -----------------------------------------------------------------------------

Destructor TAccountContactRoleDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

// -----------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TAccountContactRoleDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].' + FTableName + ' (' +
                                               'acrContactId, ' +
                                               'acrRoleId ' +
                                               ') ' +
              'VALUES (' +
                       ':acrContactId, ' +
                       ':acrRoleId ' +
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    acrContactIdParam := FindParam('acrContactId');
    acrRoleIdParam    := FindParam('acrRoleId');
  End; // With FADOQuery.Parameters
End; // Prepare

// -----------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TAccountContactRoleDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^AccountContactRoleRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    acrContactIdParam.Value := acrContactId; // SQL=int, Delphi=Longint
    acrRoleIdParam.Value    := acrRoleId;    // SQL=int, Delphi=Longint
  End; // With DataRec^
End; // SetParameterValues

// -----------------------------------------------------------------------------

End.

