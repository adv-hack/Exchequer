Unit oExchqNumDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TExchqNumDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    ssCountTypeParam, ssNextCount_sizeParam, ssNextCountParam, ssLastValueParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TExchqNumDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TExchqNumDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TExchqNumDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TExchqNumDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ExchqNum (' + 
                                               'ssCountType, ' + 
                                               'ssNextCount_size, ' + 
                                               'ssNextCount, ' + 
                                               'ssLastValue' + 
                                               ') ' + 
              'VALUES (' + 
                       ':ssCountType, ' + 
                       ':ssNextCount_size, ' + 
                       ':ssNextCount, ' + 
                       ':ssLastValue' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    ssCountTypeParam := FindParam('ssCountType');
    ssNextCount_sizeParam := FindParam('ssNextCount_size');
    ssNextCountParam := FindParam('ssNextCount');
    ssLastValueParam := FindParam('ssLastValue');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TExchqNumDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^IncrementRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    ssCountTypeParam.Value := CountTyp;                    // SQL=varchar, Delphi=String[4]
    ssNextCount_sizeParam.Value := Length(NextCount);   // SQL=int, Delphi=Length - Byte String[4]
    ssNextCountParam.Value := UnFullNomKey (NextCount);    // SQL=int, Delphi=String[4]
    ssLastValueParam.Value := LastValue;                   // SQL=float, Delphi=Double
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

