Unit oEmpPayDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TEmpPayDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    CoCodeParam, EmpCodeParam, AcGroupParam, EmpNameParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEmpPayDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, JcVar;

//=========================================================================

Constructor TEmpPayDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TEmpPayDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEmpPayDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.EmpPay (' +
                                             'CoCode, ' + 
                                             'EmpCode, ' + 
                                             'AcGroup, ' + 
                                             'EmpName' + 
                                             ') ' + 
              'VALUES (' + 
                       ':CoCode, ' + 
                       ':EmpCode, ' + 
                       ':AcGroup, ' + 
                       ':EmpName' + 
                       ')';


  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    CoCodeParam := FindParam('CoCode');
    EmpCodeParam := FindParam('EmpCode');
    AcGroupParam := FindParam('AcGroup');
    EmpNameParam := FindParam('EmpName');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TEmpPayDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^EmpRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    CoCodeParam.Value := CoCode;           // SQL=varchar, Delphi=string[6]
    EmpCodeParam.Value := EmpCode;         // SQL=varchar, Delphi=string[6]
    AcGroupParam.Value := AcGroup;         // SQL=varchar, Delphi=string[25]
    EmpNameParam.Value := EmpName;         // SQL=varchar, Delphi=string[30]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

