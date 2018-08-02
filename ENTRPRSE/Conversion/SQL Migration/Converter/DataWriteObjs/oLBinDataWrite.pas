Unit oLBinDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket, GlobVar, BtrvU2,
     SQLConvertUtils;

Type
  TLBinDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    lbHeaderNoParam, lbLineNoParam, lbBinCodeParam, lbUsedInBatchParam,
    lbUsedInThisLineParam, lbUsedElsewhereParam, lbDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TLBinDataWrite

{$I w:\entrprse\dlltk\ExchDll.inc}
{$I w:\entrprse\epos\shared\layrec.Pas}

Implementation

Uses Graphics, Variants;

//=========================================================================

Constructor TLBinDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TLBinDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TLBinDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].LBIN (' + 
                                           'lbHeaderNo, ' + 
                                           'lbLineNo, ' + 
                                           'lbBinCode, ' + 
                                           'lbUsedInBatch, ' + 
                                           'lbUsedInThisLine, ' + 
                                           'lbUsedElsewhere, ' + 
                                           'lbDummyChar' + 
                                           ') ' + 
              'VALUES (' + 
                       ':lbHeaderNo, ' +
                       ':lbLineNo, ' + 
                       ':lbBinCode, ' + 
                       ':lbUsedInBatch, ' + 
                       ':lbUsedInThisLine, ' + 
                       ':lbUsedElsewhere, ' + 
                       ':lbDummyChar' + 
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    lbHeaderNoParam := FindParam('lbHeaderNo');
    lbLineNoParam := FindParam('lbLineNo');
    lbBinCodeParam := FindParam('lbBinCode');
    lbUsedInBatchParam := FindParam('lbUsedInBatch');
    lbUsedInThisLineParam := FindParam('lbUsedInThisLine');
    lbUsedElsewhereParam := FindParam('lbUsedElsewhere');
    lbDummyCharParam := FindParam('lbDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TLBinDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TLayBinRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    lbHeaderNoParam.Value := lbHeaderNo;                                            // SQL=int, Delphi=LongInt
    lbLineNoParam.Value := lbLineNo;                                                // SQL=int, Delphi=LongInt
    lbBinCodeParam.Value := lbBinCode;                                              // SQL=varchar, Delphi=String20
    lbUsedInBatchParam.Value := lbUsedInBatch;                                      // SQL=float, Delphi=double
    lbUsedInThisLineParam.Value := lbUsedInThisLine;                                // SQL=float, Delphi=double
    lbUsedElsewhereParam.Value := lbUsedElsewhere;                                  // SQL=float, Delphi=double
    lbDummyCharParam.Value := ConvertCharToSQLEmulatorVarChar(lbDummyChar);         // SQL=varchar, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

