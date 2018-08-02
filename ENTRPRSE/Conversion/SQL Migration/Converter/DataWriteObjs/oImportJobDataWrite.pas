Unit oImportJobDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TImportJobDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    f_field_1Param, f_field_2Param : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TImportJobDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2;

//=========================================================================

Constructor TImportJobDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TImportJobDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TImportJobDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.ImportJob (' +
                                                'f_field_1, ' +
                                                'f_field_2' +
                                                ') ' +
              'VALUES (' +
                       ':f_field_1, ' +
                       ':f_field_2' +
                       ')';

  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    f_field_1Param := FindParam('f_field_1');
    f_field_2Param := FindParam('f_field_2');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TImportJobDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

//Have to declare the JobNo record here as it is private in the importer.
type
  TJobNoRecord = record
    Key:   array[1..8] of char;
    JobNo: integer;
  end;
Var
  DataRec : ^TJobNoRecord;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  //As the FaxDetails record is the only variant which corresponds with the SQL key fields, we'll
  //use it for all variants.
  With DataRec^ Do
  Begin
    f_field_1Param.Value := CreateVariantArray (@Key, SizeOf(Key));// SQL=varbinary, Delphi=array[1..8] of char
    f_field_2Param.Value := JobNo;                                          // SQL=int, Delphi=integer
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

