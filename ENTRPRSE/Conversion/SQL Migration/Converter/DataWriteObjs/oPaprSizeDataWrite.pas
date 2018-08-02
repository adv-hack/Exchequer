Unit oPaprSizeDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPaprSizeDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    psUserParam, psDescrParam, psHeightParam, psWidthParam, psTopWasteParam, 
    psBottomWasteParam, psLeftWasteParam, psRightWasteParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPaprSizeDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, GlobType;

//=========================================================================

Constructor TPaprSizeDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPaprSizeDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPaprSizeDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].PaprSize (' + 
                                               'psUser, ' + 
                                               'psDescr, ' + 
                                               'psHeight, ' + 
                                               'psWidth, ' + 
                                               'psTopWaste, ' + 
                                               'psBottomWaste, ' + 
                                               'psLeftWaste, ' + 
                                               'psRightWaste' + 
                                               ') ' + 
              'VALUES (' + 
                       ':psUser, ' + 
                       ':psDescr, ' + 
                       ':psHeight, ' + 
                       ':psWidth, ' + 
                       ':psTopWaste, ' + 
                       ':psBottomWaste, ' + 
                       ':psLeftWaste, ' + 
                       ':psRightWaste' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    psUserParam := FindParam('psUser');
    psDescrParam := FindParam('psDescr');
    psHeightParam := FindParam('psHeight');
    psWidthParam := FindParam('psWidth');
    psTopWasteParam := FindParam('psTopWaste');
    psBottomWasteParam := FindParam('psBottomWaste');
    psLeftWasteParam := FindParam('psLeftWaste');
    psRightWasteParam := FindParam('psRightWaste');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPaprSizeDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PaperSizeType;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    psUserParam.Value := psUser;                       // SQL=bit, Delphi=Boolean
    psDescrParam.Value := psDescr;                     // SQL=varchar, Delphi=String[30]
    psHeightParam.Value := psHeight;                   // SQL=int, Delphi=Word
    psWidthParam.Value := psWidth;                     // SQL=int, Delphi=Word
    psTopWasteParam.Value := psTopWaste;               // SQL=int, Delphi=Word
    psBottomWasteParam.Value := psBottomWaste;         // SQL=int, Delphi=Word
    psLeftWasteParam.Value := psLeftWaste;             // SQL=int, Delphi=Word
    psRightWasteParam.Value := psRightWaste;           // SQL=int, Delphi=Word
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

