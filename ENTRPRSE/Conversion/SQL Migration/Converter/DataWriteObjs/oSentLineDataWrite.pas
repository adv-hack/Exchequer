Unit oSentLineDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TSentLineDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    PrefixParam, UserIdParam, NameParam, InstanceParam, OutputTypeParam, 
    LineNumberParam, DummyLineNumberParam, TermCharParam, IDParam, OutputLinesParam,
    MsgInstanceParam, image_0Param : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TSentLineDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst;


{$I w:\entrprse\sentmail\sentinel\sentstructures.inc}

//=========================================================================

Constructor TSentLineDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TSentLineDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TSentLineDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].SentLine (' + 
                                               'Prefix, ' + 
                                               'UserId, ' + 
                                               'Name, ' + 
                                               'Instance, ' + 
                                               'OutputType, ' + 
                                               'LineNumber, ' + 
                                               'DummyLineNumber, ' + 
                                               'TermChar, ' + 
                                               'ID, ' + 
                                               'OutputLines, ' + 
                                               'MsgInstance, ' + 
                                               'image_0' + 
                                               ') ' + 
              'VALUES (' + 
                       ':Prefix, ' + 
                       ':UserId, ' + 
                       ':Name, ' + 
                       ':Instance, ' + 
                       ':OutputType, ' + 
                       ':LineNumber, ' + 
                       ':DummyLineNumber, ' + 
                       ':TermChar, ' + 
                       ':ID, ' + 
                       ':OutputLines, ' + 
                       ':MsgInstance, ' + 
                       ':image_0' + 
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    PrefixParam := FindParam('Prefix');
    UserIdParam := FindParam('UserId');
    NameParam := FindParam('Name');
    InstanceParam := FindParam('Instance');
    OutputTypeParam := FindParam('OutputType');
    LineNumberParam := FindParam('LineNumber');
    DummyLineNumberParam := FindParam('DummyLineNumber');
    TermCharParam := FindParam('TermChar');
    IDParam := FindParam('ID');
    OutputLinesParam := FindParam('OutputLines');
    MsgInstanceParam := FindParam('MsgInstance');
    image_0Param := FindParam('image_0');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TSentLineDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TElertLineRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^, Output Do
  Begin
    PrefixParam.Value := ConvertCharToSQLEmulatorVarChar(Prefix);                             // SQL=varchar, Delphi=Char
    UserIdParam.Value := eoUserID;                                                            // SQL=varchar, Delphi=String[10]
    NameParam.Value := eoElertName;                                                           // SQL=varchar, Delphi=String[30]
    InstanceParam.Value := eoInstance;                                                        // SQL=int, Delphi=SmallInt
    OutputTypeParam.Value := ConvertCharToSQLEmulatorVarChar(eoOutputType);                   // SQL=varchar, Delphi=Char
    LineNumberParam.Value := eoLineNo;                                                        // SQL=int, Delphi=SmallInt
    DummyLineNumberParam.Value := eoDummyLineNo;                                              // SQL=int, Delphi=longint
    TermCharParam.Value := ConvertCharToSQLEmulatorVarChar(eoTermChar);                       // SQL=varchar, Delphi=Char
    IDParam.Value := eoKey;                                                                   // SQL=varchar, Delphi=String[60]
    OutputLinesParam.Value := CreateVariantArray(@eoParamType, 358);                         // SQL=varbinary, Delphi=Byte
    MsgInstanceParam.Value := eoMsgInstance;                                                  // SQL=int, Delphi=SmallInt
    image_0Param.Value := CreateVariantArray(@eoEmType, 1161);                                                           // SQL=image, Delphi=Byte
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

