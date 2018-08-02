Unit oUDItemDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TUDItemDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    liFieldFolioParam, liLineNoParam, liDescriptionParam, liDummyCharParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TUDItemDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

Type
  // Import the structures for the User Defined Fields Plug-In - have to use short file names
  {$I X:\PlugIns\UserDe~1\COMMON\UDStructures.Inc}

//=========================================================================

Constructor TUDItemDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TUDItemDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TUDItemDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].uditem (' + 
                                             'liFieldFolio, ' + 
                                             'liLineNo, ' + 
                                             'liDescription, ' + 
                                             'liDummyChar' + 
                                             ') ' + 
              'VALUES (' + 
                       ':liFieldFolio, ' + 
                       ':liLineNo, ' + 
                       ':liDescription, ' + 
                       ':liDummyChar' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    liFieldFolioParam := FindParam('liFieldFolio');
    liLineNoParam := FindParam('liLineNo');
    liDescriptionParam := FindParam('liDescription');
    liDummyCharParam := FindParam('liDummyChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TUDItemDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TListItemRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    liFieldFolioParam.Value := liFieldFolio;            // SQL=int, Delphi=LongInt
    liLineNoParam.Value := liLineNo;                    // SQL=int, Delphi=LongInt
    liDescriptionParam.Value := liDescription;          // SQL=varchar, Delphi=string[60]
    liDummyCharParam.Value := Ord(liDummyChar);         // SQL=int, Delphi=char
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

