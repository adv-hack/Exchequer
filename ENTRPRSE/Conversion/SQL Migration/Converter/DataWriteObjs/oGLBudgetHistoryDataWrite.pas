Unit oGLBudgetHistoryDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TGLBudgetHistoryDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    bhGLCodeParam, bhYearParam, bhPeriodParam, bhCurrencyParam, bhDateChangedParam,
    bhTimeChangedParam, bhValueParam, bhChangeParam, bhUserParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TGLBudgetHistoryDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils, BudgetHistoryVar;

//=========================================================================

Constructor TGLBudgetHistoryDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TGLBudgetHistoryDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TGLBudgetHistoryDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].GLBudgetHistory (' + 
                                                      'bhGLCode, ' + 
                                                      'bhYear, ' + 
                                                      'bhPeriod, ' + 
                                                      'bhCurrency, ' +
                                                      'bhDateChanged, ' + 
                                                      'bhTimeChanged, ' + 
                                                      'bhValue, ' + 
                                                      'bhChange, ' + 
                                                      'bhUser' + 
                                                      ') ' + 
              'VALUES (' + 
                       ':bhGLCode, ' + 
                       ':bhYear, ' + 
                       ':bhPeriod, ' + 
                       ':bhCurrency, ' + 
                       ':bhDateChanged, ' + 
                       ':bhTimeChanged, ' + 
                       ':bhValue, ' + 
                       ':bhChange, ' + 
                       ':bhUser' + 
                       ')';

  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    bhGLCodeParam := FindParam('bhGLCode');
    bhYearParam := FindParam('bhYear');
    bhPeriodParam := FindParam('bhPeriod');
    bhCurrencyParam := FindParam('bhCurrency');
    bhDateChangedParam := FindParam('bhDateChanged');
    bhTimeChangedParam := FindParam('bhTimeChanged');
    bhValueParam := FindParam('bhValue');
    bhChangeParam := FindParam('bhChange');
    bhUserParam := FindParam('bhUser');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TGLBudgetHistoryDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TBudgetHistoryRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    bhGLCodeParam.Value := bhGLCode;                   // SQL=int, Delphi=longint
    bhYearParam.Value := bhYear;                       // SQL=int, Delphi=Byte
    bhPeriodParam.Value := bhPeriod;                   // SQL=int, Delphi=Byte
    bhCurrencyParam.Value := bhCurrency;               // SQL=int, Delphi=Byte
    bhDateChangedParam.Value := bhDateChanged;         // SQL=varchar, Delphi=string[8]
    bhTimeChangedParam.Value := bhTimeChanged;         // SQL=varchar, Delphi=string[6]
    bhValueParam.Value := bhValue;                     // SQL=float, Delphi=Double
    bhChangeParam.Value := bhChange;                   // SQL=float, Delphi=Double
    bhUserParam.Value := bhUser;                       // SQL=varchar, Delphi=string[10]
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

