Unit oVATOptDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TVATOptDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    YearParam, PeriodParam, EndDateParam, StartDateParam, OptNoOfPeriodsParam, 
    OptUseAutoParam, BackColorParam, TextColorParam, CurrColorParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TVATOptDataWrite

Implementation

Uses Graphics, Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

Type
  //
  // Copied from U:\BESPOKE\EXCHEQR\VATPeriod\VatPrVar.Pas
  //
  TVatPeriodOptRec = Record
    Year          : String[4];
    Period        : String[2];
    EndDate       : String[8];
    StartDate     : String[8];
    OptNoOfPeriods: Byte;  // - number of periods 1-12
    OptUseAuto    : Boolean; // - use auto fill during posting hook
    BackColor,
    TextColor,
    CurrColor     : TColor;
    Spare         : Array[1..52] of Char;
  end;


//=========================================================================

Constructor TVATOptDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TVATOptDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TVATOptDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].VATOpt (' + 
                                             'Year, ' + 
                                             'Period, ' + 
                                             'EndDate, ' + 
                                             'StartDate, ' + 
                                             'OptNoOfPeriods, ' + 
                                             'OptUseAuto, ' + 
                                             'BackColor, ' + 
                                             'TextColor, ' + 
                                             'CurrColor' + 
                                             ') ' + 
              'VALUES (' + 
                       ':Year, ' + 
                       ':Period, ' + 
                       ':EndDate, ' + 
                       ':StartDate, ' + 
                       ':OptNoOfPeriods, ' + 
                       ':OptUseAuto, ' + 
                       ':BackColor, ' + 
                       ':TextColor, ' + 
                       ':CurrColor' + 
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
    OptNoOfPeriodsParam := FindParam('OptNoOfPeriods');
    OptUseAutoParam := FindParam('OptUseAuto');
    BackColorParam := FindParam('BackColor');
    TextColorParam := FindParam('TextColor');
    CurrColorParam := FindParam('CurrColor');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TVATOptDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TVatPeriodOptRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    YearParam.Value := Year;                             // SQL=varchar, Delphi=String[4]
    PeriodParam.Value := Period;                         // SQL=varchar, Delphi=String[2]
    EndDateParam.Value := EndDate;                       // SQL=varchar, Delphi=String[8]
    StartDateParam.Value := StartDate;                   // SQL=varchar, Delphi=String[8]
    OptNoOfPeriodsParam.Value := OptNoOfPeriods;         // SQL=int, Delphi=Byte
    OptUseAutoParam.Value := OptUseAuto;                 // SQL=bit, Delphi=Boolean
    BackColorParam.Value := BackColor;                   // SQL=int, Delphi=TColor
    TextColorParam.Value := TextColor;                   // SQL=int, Delphi=TColor
    CurrColorParam.Value := CurrColor;                   // SQL=int, Delphi=TColor
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

