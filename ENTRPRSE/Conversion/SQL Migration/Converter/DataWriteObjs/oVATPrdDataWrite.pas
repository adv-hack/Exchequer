Unit oVATPrdDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TVATPrdDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    YearParam, PeriodParam, EndDateParam, StartDateParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TVATPrdDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

Type
  //
  // Copied from U:\BESPOKE\EXCHEQR\VATPeriod\VatPrVar.Pas
  //
  TVATPeriodRec = Record
    Year          : String[4];
    Period        : String[2];
    EndDate       : String[8];
    StartDate     : String[8];
    Spare         : Array[1..64] of Char;
  end;

//=========================================================================

Constructor TVATPrdDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TVATPrdDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TVATPrdDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].VATPrd (' + 
                                             'Year, ' + 
                                             'Period, ' + 
                                             'EndDate, ' + 
                                             'StartDate' + 
                                             ') ' + 
              'VALUES (' + 
                       ':Year, ' + 
                       ':Period, ' + 
                       ':EndDate, ' + 
                       ':StartDate' + 
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    YearParam := FindParam('Year');
    PeriodParam := FindParam('Period');
    EndDateParam := FindParam('EndDate');
    StartDateParam := FindParam('StartDate');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TVATPrdDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TVATPeriodRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    YearParam.Value := Year;                   // SQL=varchar, Delphi=String[4]
    PeriodParam.Value := Period;               // SQL=varchar, Delphi=String[2]
    EndDateParam.Value := EndDate;             // SQL=varchar, Delphi=String[8]
    StartDateParam.Value := StartDate;         // SQL=varchar, Delphi=String[8]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

