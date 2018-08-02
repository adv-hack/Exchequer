Unit oUDEntityDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TUDEntityDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    etFolioNoParam, etDescriptionParam, etTypeParam, etFormatParam, etDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TUDEntityDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

Type
  // Import the structures for the User Defined Fields Plug-In - have to use short file names
  {$I X:\PlugIns\UserDe~1\COMMON\UDStructures.Inc}

//=========================================================================

Constructor TUDEntityDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TUDEntityDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TUDEntityDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].udentity (' + 
                                               'etFolioNo, ' + 
                                               'etDescription, ' + 
                                               'etType, ' + 
                                               'etFormat, ' + 
                                               'etDummyChar' + 
                                               ') ' + 
              'VALUES (' + 
                       ':etFolioNo, ' + 
                       ':etDescription, ' + 
                       ':etType, ' + 
                       ':etFormat, ' + 
                       ':etDummyChar' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    etFolioNoParam := FindParam('etFolioNo');
    etDescriptionParam := FindParam('etDescription');
    etTypeParam := FindParam('etType');
    etFormatParam := FindParam('etFormat');
    etDummyCharParam := FindParam('etDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TUDEntityDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TEntityRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    etFolioNoParam.Value := etFolioNo;                                    // SQL=int, Delphi=LongInt
    etDescriptionParam.Value := etDescription;                            // SQL=varchar, Delphi=string[60]
    etTypeParam.Value := ConvertCharToSQLEmulatorVarChar(etType);         // SQL=varchar, Delphi=char
    etFormatParam.Value := etFormat;                                      // SQL=varchar, Delphi=string[20]
    etDummyCharParam.Value := Ord(etDummyChar);                           // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

