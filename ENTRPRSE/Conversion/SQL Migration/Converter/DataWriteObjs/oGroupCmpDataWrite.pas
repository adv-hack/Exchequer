Unit oGroupCmpDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TGroupCmpDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    gcGroupCodeParam, gcCompanyCodeParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TGroupCmpDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, GroupCompFile;

//=========================================================================

Constructor TGroupCmpDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TGroupCmpDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TGroupCmpDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO Common.GroupCmp (' +
                                                      'gcGroupCode, ' +
                                                      'gcCompanyCode' +
                                                     ') ' +
                        'VALUES (' +
                                 ':gcGroupCode, ' +
                                 ':gcCompanyCode' +
                                ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    gcGroupCodeParam := FindParam('gcGroupCode');
    gcCompanyCodeParam := FindParam('gcCompanyCode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TGroupCmpDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^GroupCompaniesFileRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    gcGroupCodeParam.Value := gcGroupCode;             // SQL=varchar, Delphi=String[20]
    gcCompanyCodeParam.Value := gcCompanyCode;         // SQL=varchar, Delphi=String[6]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

