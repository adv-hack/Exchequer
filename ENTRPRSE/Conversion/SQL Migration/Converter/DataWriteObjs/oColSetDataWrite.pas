Unit oColSetDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TColSetDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    csExeNameParam, csUserNameParam, csWindowNameParam, csParentNameParam, 
    csColumnNoParam, DummyCharParam, csOrderParam, csLeftParam, csWidthParam, 
    csTopParam, csHeightParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TColSetDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils;

//=========================================================================

Constructor TColSetDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TColSetDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TColSetDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].ColSet (' + 
                                             'csExeName, ' + 
                                             'csUserName, ' + 
                                             'csWindowName, ' + 
                                             'csParentName, ' + 
                                             'csColumnNo, ' + 
                                             'DummyChar, ' + 
                                             'csOrder, ' + 
                                             'csLeft, ' + 
                                             'csWidth, ' + 
                                             'csTop, ' + 
                                             'csHeight' + 
                                             ') ' + 
              'VALUES (' + 
                       ':csExeName, ' + 
                       ':csUserName, ' + 
                       ':csWindowName, ' + 
                       ':csParentName, ' + 
                       ':csColumnNo, ' + 
                       ':DummyChar, ' + 
                       ':csOrder, ' + 
                       ':csLeft, ' + 
                       ':csWidth, ' + 
                       ':csTop, ' + 
                       ':csHeight' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    csExeNameParam := FindParam('csExeName');
    csUserNameParam := FindParam('csUserName');
    csWindowNameParam := FindParam('csWindowName');
    csParentNameParam := FindParam('csParentName');
    csColumnNoParam := FindParam('csColumnNo');
    DummyCharParam := FindParam('DummyChar');
    csOrderParam := FindParam('csOrder');
    csLeftParam := FindParam('csLeft');
    csWidthParam := FindParam('csWidth');
    csTopParam := FindParam('csTop');
    csHeightParam := FindParam('csHeight');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TColSetDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TColumnSettingsRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    csExeNameParam.Value := csExeName;               // SQL=varchar, Delphi=string[20]
    csUserNameParam.Value := csUserName;             // SQL=varchar, Delphi=string[10]
    csWindowNameParam.Value := csWindowName;         // SQL=varchar, Delphi=string[40]
    csParentNameParam.Value := csParentName;         // SQL=varchar, Delphi=string[40]
    csColumnNoParam.Value := csColumnNo;             // SQL=int, Delphi=LongInt
    DummyCharParam.Value := Ord(DummyChar);          // SQL=int, Delphi=Char
    csOrderParam.Value := csOrder;                   // SQL=int, Delphi=LongInt
    csLeftParam.Value := csLeft;                     // SQL=int, Delphi=LongInt
    csWidthParam.Value := csWidth;                   // SQL=int, Delphi=LongInt
    csTopParam.Value := csTop;                       // SQL=int, Delphi=LongInt
    csHeightParam.Value := csHeight;                 // SQL=int, Delphi=LongInt
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

