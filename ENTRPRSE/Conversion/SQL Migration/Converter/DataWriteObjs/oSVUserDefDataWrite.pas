Unit oSVUserDefDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSVUserDefDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    svuUserIdParam, svuListTypeParam, svuDefaultViewParam, svuSpareParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSVUserDefDataWrite

Implementation

Uses Graphics, Variants, SQLConvertUtils, VarSortV;

//=========================================================================

Constructor TSVUserDefDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSVUserDefDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSVUserDefDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].SVUSRDEF (' +
                                               'svuUserId, ' +
                                               'svuListType, ' +
                                               'svuDefaultView, ' +
                                               'svuSpare' +
                                               ') ' +
              'VALUES (' +
                       ':svuUserId, ' +
                       ':svuListType, ' +
                       ':svuDefaultView, ' +
                       ':svuSpare' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    svuUserIdParam := FindParam('svuUserId');
    svuListTypeParam := FindParam('svuListType');
    svuDefaultViewParam := FindParam('svuDefaultView');
    svuSpareParam := FindParam('svuSpare');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSVUserDefDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TSortViewUserInfoRecType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    svuUserIdParam.Value := svuUserId;                                               // SQL=varchar, Delphi=String[30]
    svuListTypeParam.Value := svuListType;                                           // SQL=int, Delphi=TSortViewListType
    svuDefaultViewParam.Value := svuDefaultView;                                     // SQL=int, Delphi=LongInt
    svuSpareParam.Value := CreateVariantArray (@svuSpare, SizeOf(svuSpare));// SQL=varbinary, Delphi=Array [1..900] Of Byte
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

