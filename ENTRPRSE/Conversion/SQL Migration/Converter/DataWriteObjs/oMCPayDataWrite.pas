Unit oMCPayDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TMCPayDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    CoCodeParam, PayIDParam, CoNameParam, FileNameParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TMCPayDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, JcVar;

//=========================================================================

Constructor TMCPayDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TMCPayDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TMCPayDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.MCPay (' +
                                            'CoCode, ' + 
                                            'PayID, ' + 
                                            'CoName, ' + 
                                            'FileName' + 
                                            ') ' + 
              'VALUES (' + 
                       ':CoCode, ' +
                       ':PayID, ' + 
                       ':CoName, ' + 
                       ':FileName' + 
                       ')';




  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    CoCodeParam := FindParam('CoCode');
    PayIDParam := FindParam('PayID');
    CoNameParam := FindParam('CoName');
    FileNameParam := FindParam('FileName');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TMCPayDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^MCMRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    CoCodeParam.Value := CoCode;             // SQL=varchar, Delphi=string[6]
    PayIDParam.Value := PayID;               // SQL=varchar, Delphi=string[3]
    CoNameParam.Value := CoName;             // SQL=varchar, Delphi=string[45]
    FileNameParam.Value := FileName;         // SQL=varchar, Delphi=string[30]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

