Unit oCurrencyHistoryDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TCurrencyHistoryDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    chDateChangedParam, chTimeChangedParam, chCurrNumberParam, chStopKeyParam, 
    chDailyRateParam, chCompanyRateParam, chInvertParam, chFloatParam, 
    chTriangulationNumberParam, chTriangulationRateParam, chDescriptionParam, 
    chSymbolScreenParam, chSymbolPrintParam, chUserParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCurrencyHistoryDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils, CurrencyHistoryVar;

//=========================================================================

Constructor TCurrencyHistoryDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TCurrencyHistoryDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCurrencyHistoryDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].CurrencyHistory (' + 
                                                      'chDateChanged, ' + 
                                                      'chTimeChanged, ' + 
                                                      'chCurrNumber, ' + 
                                                      'chStopKey, ' + 
                                                      'chDailyRate, ' + 
                                                      'chCompanyRate, ' + 
                                                      'chInvert, ' + 
                                                      'chFloat, ' + 
                                                      'chTriangulationNumber, ' + 
                                                      'chTriangulationRate, ' + 
                                                      'chDescription, ' + 
                                                      'chSymbolScreen, ' + 
                                                      'chSymbolPrint, ' + 
                                                      'chUser' +
                                                      ') ' +
              'VALUES (' +
                       ':chDateChanged, ' +
                       ':chTimeChanged, ' +
                       ':chCurrNumber, ' +
                       ':chStopKey, ' +
                       ':chDailyRate, ' +
                       ':chCompanyRate, ' +
                       ':chInvert, ' +
                       ':chFloat, ' +
                       ':chTriangulationNumber, ' +
                       ':chTriangulationRate, ' +
                       ':chDescription, ' +
                       ':chSymbolScreen, ' +
                       ':chSymbolPrint, ' +
                       ':chUser' +
                       ')';


  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    chDateChangedParam := FindParam('chDateChanged');
    chTimeChangedParam := FindParam('chTimeChanged');
    chCurrNumberParam := FindParam('chCurrNumber');
    chStopKeyParam := FindParam('chStopKey');
    chDailyRateParam := FindParam('chDailyRate');
    chCompanyRateParam := FindParam('chCompanyRate');
    chInvertParam := FindParam('chInvert');
    chFloatParam := FindParam('chFloat');
    chTriangulationNumberParam := FindParam('chTriangulationNumber');
    chTriangulationRateParam := FindParam('chTriangulationRate');
    chDescriptionParam := FindParam('chDescription');
    chSymbolScreenParam := FindParam('chSymbolScreen');
    chSymbolPrintParam := FindParam('chSymbolPrint');
    chUserParam := FindParam('chUser');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TCurrencyHistoryDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TCurrencyHistoryRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    chDateChangedParam.Value := chDateChanged;                                  // SQL=varchar, Delphi=string[8]
    chTimeChangedParam.Value := chTimeChanged;                                  // SQL=varchar, Delphi=string[6]
    chCurrNumberParam.Value := chCurrNumber;                                    // SQL=int, Delphi=SmallInt
    chStopKeyParam.Value := ConvertCharToSQLEmulatorVarChar(chStopKey);         // SQL=varchar, Delphi=char
    chDailyRateParam.Value := chDailyRate;                                      // SQL=float, Delphi=Double
    chCompanyRateParam.Value := chCompanyRate;                                  // SQL=float, Delphi=Double
    chInvertParam.Value := chInvert;                                            // SQL=bit, Delphi=Boolean
    chFloatParam.Value := chFloat;                                              // SQL=bit, Delphi=Boolean
    chTriangulationNumberParam.Value := chTriangulationNumber;                  // SQL=int, Delphi=Smallint
    chTriangulationRateParam.Value := chTriangulationRate;                      // SQL=float, Delphi=Double
    chDescriptionParam.Value := chDescription;                                  // SQL=varchar, Delphi=string[11]
    chSymbolScreenParam.Value := chSymbolScreen;                                // SQL=varchar, Delphi=string[3]
    chSymbolPrintParam.Value := chSymbolPrint;                                  // SQL=varchar, Delphi=string[3]
    chUserParam.Value := chUser;                                                // SQL=varchar, Delphi=string[10]
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

