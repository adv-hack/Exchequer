Unit oEbusNoteDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TEbusNoteDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    RecPfixParam, SubTypeParam, NoteNoParam, NoteDateParam, Spare3Param, 
    EbusNote_Code1Param, NoteFolioParam, NTypeParam, Spare1Param, LineNumberParam, 
    NoteLineParam, NoteUserParam, TmpImpCodeParam, ShowDateParam, RepeatNoParam, 
    NoteForParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TEbusNoteDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TEbusNoteDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TEbusNoteDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TEbusNoteDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].EBusNote (' + 
                                               'RecPfix, ' + 
                                               'SubType, ' + 
                                               'NoteNo, ' + 
                                               'NoteDate, ' + 
                                               'Spare3, ' + 
                                               'EbusNote_Code1, ' + 
                                               'NoteFolio, ' + 
                                               'NType, ' + 
                                               'Spare1, ' + 
                                               'LineNumber, ' + 
                                               'NoteLine, ' + 
                                               'NoteUser, ' + 
                                               'TmpImpCode, ' + 
                                               'ShowDate, ' + 
                                               'RepeatNo, ' + 
                                               'NoteFor' + 
                                               ') ' + 
              'VALUES (' + 
                       ':RecPfix, ' + 
                       ':SubType, ' + 
                       ':NoteNo, ' + 
                       ':NoteDate, ' + 
                       ':Spare3, ' + 
                       ':EbusNote_Code1, ' + 
                       ':NoteFolio, ' + 
                       ':NType, ' + 
                       ':Spare1, ' + 
                       ':LineNumber, ' + 
                       ':NoteLine, ' + 
                       ':NoteUser, ' + 
                       ':TmpImpCode, ' + 
                       ':ShowDate, ' + 
                       ':RepeatNo, ' + 
                       ':NoteFor' + 
                       ')';


  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    RecPfixParam := FindParam('RecPfix');
    SubTypeParam := FindParam('SubType');
    NoteNoParam := FindParam('NoteNo');
    NoteDateParam := FindParam('NoteDate');
    Spare3Param := FindParam('Spare3');
    EbusNote_Code1Param := FindParam('EbusNote_Code1');
    NoteFolioParam := FindParam('NoteFolio');
    NTypeParam := FindParam('NType');
    Spare1Param := FindParam('Spare1');
    LineNumberParam := FindParam('LineNumber');
    NoteLineParam := FindParam('NoteLine');
    NoteUserParam := FindParam('NoteUser');
    TmpImpCodeParam := FindParam('TmpImpCode');
    ShowDateParam := FindParam('ShowDate');
    RepeatNoParam := FindParam('RepeatNo');
    NoteForParam := FindParam('NoteFor');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TEbusNoteDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^PassWordRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^, NotesRec Do
  Begin
    RecPfixParam.Value := ConvertCharToSQLEmulatorVarChar(RecPfix);                          // SQL=varchar, Delphi=Char
    SubTypeParam.Value := ConvertCharToSQLEmulatorVarChar(SubType);                          // SQL=varchar, Delphi=Char
    NoteNoParam.Value := CreateVariantArray (@NoteNo, SizeOf(NoteNo));        // SQL=varbinary, Delphi=String[12]
    NoteDateParam.Value := NoteDate;                                                         // SQL=varchar, Delphi=LongDate
    Spare3Param.Value := Spare3;                                                             // SQL=int, Delphi=Byte
    EbusNote_Code1Param.Value :=
          CreateVariantArray (@NoteAlarm, SizeOf(NoteAlarm) + SizeOf(Spare4));  // SQL=varbinary, Delphi=LongDate
    NoteFolioParam.Value := CreateVariantArray (@NoteFolio, SizeOf(NoteFolio));// SQL=varbinary, Delphi=String[10]
    NTypeParam.Value := ConvertCharToSQLEmulatorVarChar(NType);                              // SQL=varchar, Delphi=Char
    Spare1Param.Value := CreateVariantArray (@Spare1, SizeOf(Spare1));        // SQL=varbinary, Delphi=Array[1..2] of Byte
    LineNumberParam.Value := LineNo;                                                         // SQL=int, Delphi=LongInt
    NoteLineParam.Value := NoteLine;                                                         // SQL=varchar, Delphi=String[100]
    NoteUserParam.Value := NoteUser;                                                         // SQL=varchar, Delphi=String[10]
    TmpImpCodeParam.Value := TmpImpCode;                                                     // SQL=varchar, Delphi=String[16]
    ShowDateParam.Value := ShowDate;                                                         // SQL=bit, Delphi=Boolean
    RepeatNoParam.Value := RepeatNo;                                                         // SQL=int, Delphi=SmallInt
    NoteForParam.Value := NoteFor;                                                           // SQL=varchar, Delphi=String[10]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }

              {002}   NoteNo    :  String[12];   { Folio/CustCode + NType + LineNo}

              {015}   NoteDate  :  LongDate;

              {021}   Spare3    :  Byte;

              {025}   NoteAlarm :  LongDate;



              {037}   NoteFolio :  String[10];

              {047}   NType     :  Char;

              {048}   Spare1    :  Array[1..2] of  Byte;

              {050}   LineNo    :  LongInt;

              {055}   NoteLine  :  String[100]; { Note Line }

              {156}   NoteUser  :  String[10];  { Note owner }

              {167}   TmpImpCode:  String[16];  { TmpHolding code for import }

              {182}   ShowDate  :  Boolean;
              {183}   RepeatNo  :  SmallInt;    { Repeat every X days}
              {186}   NoteFor   :  String[10];  { Note For Filter }

