Unit oWinSetDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TWinSetDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    wpExeNameParam, wpUserNameParam, wpWindowNameParam, wpLeftParam, wpTopParam, 
    wpWidthParam, wpHeightParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TWinSetDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils;

//=========================================================================

Constructor TWinSetDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TWinSetDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TWinSetDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].WinSet (' + 
                                             'wpExeName, ' + 
                                             'wpUserName, ' + 
                                             'wpWindowName, ' + 
                                             'wpLeft, ' + 
                                             'wpTop, ' + 
                                             'wpWidth, ' + 
                                             'wpHeight' + 
                                             ') ' + 
              'VALUES (' + 
                       ':wpExeName, ' + 
                       ':wpUserName, ' + 
                       ':wpWindowName, ' + 
                       ':wpLeft, ' + 
                       ':wpTop, ' + 
                       ':wpWidth, ' + 
                       ':wpHeight' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    wpExeNameParam := FindParam('wpExeName');
    wpUserNameParam := FindParam('wpUserName');
    wpWindowNameParam := FindParam('wpWindowName');
    wpLeftParam := FindParam('wpLeft');
    wpTopParam := FindParam('wpTop');
    wpWidthParam := FindParam('wpWidth');
    wpHeightParam := FindParam('wpHeight');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TWinSetDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TWindowPositionRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    wpExeNameParam.Value := wpExeName;               // SQL=varchar, Delphi=string[20]
    wpUserNameParam.Value := wpUserName;             // SQL=varchar, Delphi=string[10]
    wpWindowNameParam.Value := wpWindowName;         // SQL=varchar, Delphi=string[40]
    wpLeftParam.Value := wpLeft;                     // SQL=int, Delphi=LongInt
    wpTopParam.Value := wpTop;                       // SQL=int, Delphi=LongInt
    wpWidthParam.Value := wpWidth;                   // SQL=int, Delphi=LongInt
    wpHeightParam.Value := wpHeight;                 // SQL=int, Delphi=LongInt
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

