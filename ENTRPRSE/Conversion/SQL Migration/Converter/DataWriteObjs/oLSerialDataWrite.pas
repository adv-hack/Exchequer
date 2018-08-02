Unit oLSerialDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket, SQLConvertUtils, GlobVar,
  BtrvU2;

Type
  TLSerialDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    lsHeaderNoParam, lsLineNoParam, lsBatchParam, lsSerialNoParam, lsBatchNoParam,
    XlsUsedInBatchParam, XlsUsedInThisLineParam, XlsUsedElsewhereParam,
    lsDummyCharParam, lsUsedInBatchParam, lsUsedInThisLineParam, lsUsedElsewhereParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TLSerialDataWrite

{$I w:\entrprse\dlltk\ExchDll.inc}
{$I w:\entrprse\epos\shared\layrec.Pas}

Implementation

Uses Graphics, Variants;

//=========================================================================

Constructor TLSerialDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TLSerialDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TLSerialDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].LSerial (' + 
                                              'lsHeaderNo, ' + 
                                              'lsLineNo, ' + 
                                              'lsBatch, ' + 
                                              'lsSerialNo, ' + 
                                              'lsBatchNo, ' + 
                                              'XlsUsedInBatch, ' + 
                                              'XlsUsedInThisLine, ' + 
                                              'XlsUsedElsewhere, ' + 
                                              'lsDummyChar, ' + 
                                              'lsUsedInBatch, ' + 
                                              'lsUsedInThisLine, ' + 
                                              'lsUsedElsewhere' + 
                                              ') ' + 
              'VALUES (' + 
                       ':lsHeaderNo, ' + 
                       ':lsLineNo, ' + 
                       ':lsBatch, ' + 
                       ':lsSerialNo, ' + 
                       ':lsBatchNo, ' + 
                       ':XlsUsedInBatch, ' + 
                       ':XlsUsedInThisLine, ' +
                       ':XlsUsedElsewhere, ' + 
                       ':lsDummyChar, ' +
                       ':lsUsedInBatch, ' + 
                       ':lsUsedInThisLine, ' + 
                       ':lsUsedElsewhere' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    lsHeaderNoParam := FindParam('lsHeaderNo');
    lsLineNoParam := FindParam('lsLineNo');
    lsBatchParam := FindParam('lsBatch');
    lsSerialNoParam := FindParam('lsSerialNo');
    lsBatchNoParam := FindParam('lsBatchNo');
    XlsUsedInBatchParam := FindParam('XlsUsedInBatch');
    XlsUsedInThisLineParam := FindParam('XlsUsedInThisLine');
    XlsUsedElsewhereParam := FindParam('XlsUsedElsewhere');
    lsDummyCharParam := FindParam('lsDummyChar');
    lsUsedInBatchParam := FindParam('lsUsedInBatch');
    lsUsedInThisLineParam := FindParam('lsUsedInThisLine');
    lsUsedElsewhereParam := FindParam('lsUsedElsewhere');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TLSerialDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TLaySerialRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    lsHeaderNoParam.Value := lsHeaderNo;                                            // SQL=int, Delphi=LongInt
    lsLineNoParam.Value := lsLineNo;                                                // SQL=int, Delphi=LongInt
    lsBatchParam.Value := lsBatch;                                                  // SQL=bit, Delphi=boolean
    lsSerialNoParam.Value := lsSerialNo;                                            // SQL=varchar, Delphi=String20
    lsBatchNoParam.Value := lsBatchNo;                                              // SQL=varchar, Delphi=String10
    XlsUsedInBatchParam.Value := XlsUsedInBatch;                                    // SQL=int, Delphi=LongInt
    XlsUsedInThisLineParam.Value := XlsUsedInThisLine;                              // SQL=int, Delphi=LongInt
    XlsUsedElsewhereParam.Value := XlsUsedElsewhere;                                // SQL=int, Delphi=LongInt
    lsDummyCharParam.Value := ConvertCharToSQLEmulatorVarChar(lsDummyChar);         // SQL=varchar, Delphi=char
    lsUsedInBatchParam.Value := lsUsedInBatch;                                      // SQL=float, Delphi=double
    lsUsedInThisLineParam.Value := lsUsedInThisLine;                                // SQL=float, Delphi=double
    lsUsedElsewhereParam.Value := lsUsedElsewhere;                                  // SQL=float, Delphi=double
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

