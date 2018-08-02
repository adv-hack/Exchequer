Unit oHistoryDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket, oConvertOptions;

Type
  THistoryDataWrite = Class(TBaseDataWrite)
  Private
    FForPurge: Boolean;
    FADOQuery : TADOQuery;
    hiCodeParam, hiExCLassParam, hiCurrencyParam, hiYearParam, hiPeriodParam,
    hiSalesParam, hiPurchasesParam, hiBudgetParam, hiClearedParam, hiRevisedBudget1Param,
    hiValue1Param, hiValue2Param, hiValue3Param, hiRevisedBudget2Param, hiRevisedBudget3Param,
    hiRevisedBudget4Param, hiRevisedBudget5Param, hiSpareVParam : TParameter;
    // Creates the HISTPRGE table if it does not exist (the Emulator will not
    // create it automatically, as it knows nothing about it).
    //PR: 07/09/2016 ABSEXCH-15014 Moved create HistPrge table to separate object
    //Procedure CreateHistPrge (Const CompanyCode : ShortString);
  Public
    Constructor Create;
    Constructor CreateForPurge;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // THistoryDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst;

//=========================================================================

Constructor THistoryDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  FForPurge := False;
End; // Create

//------------------------------

constructor THistoryDataWrite.CreateForPurge;
begin
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  FForPurge := True;
end;

//------------------------------
(* PR: 07/09/2016 ABSEXCH-15014 Moved create table to separate object
procedure THistoryDataWrite.CreateHistPrge(const CompanyCode: ShortString);
var
  sqlQuery: ANSIString;
begin
  sqlQuery := 'IF NOT EXISTS (SELECT * FROM sys.objects                                  ' +
              '               WHERE object_id = OBJECT_ID(N''[COMPANY].[HISTPRGE]'') AND ' +
              '                     type in (N''U''))                                    ' +
              'CREATE TABLE [COMPANY].[HISTPRGE](                                        ' +
              '	[hiCode] [varbinary](21) NOT NULL,                                       ' +
              '	[hiExCLass] [int] NOT NULL,                                              ' +
              '	[hiCurrency] [int] NOT NULL,                                             ' +
              '	[hiYear] [int] NOT NULL,                                                 ' +
              '	[hiPeriod] [int] NOT NULL,                                               ' +
              '	[hiSales] [float] NOT NULL,                                              ' +
              '	[hiPurchases] [float] NOT NULL,                                          ' +
              '	[hiBudget] [float] NOT NULL,                                             ' +
              '	[hiCleared] [float] NOT NULL,                                            ' +
              '	[hiRevisedBudget1] [float] NOT NULL,                                     ' +
              '	[hiValue1] [float] NOT NULL,                                             ' +
              '	[hiValue2] [float] NOT NULL,                                             ' +
              '	[hiValue3] [float] NOT NULL,                                             ' +
              '	[hiRevisedBudget2] [float] NOT NULL,                                     ' +
              '	[hiRevisedBudget3] [float] NOT NULL,                                     ' +
              '	[hiRevisedBudget4] [float] NOT NULL,                                     ' +
              '	[hiRevisedBudget5] [float] NOT NULL,                                     ' +
              '	[hiSpareV] [float] NOT NULL,                                             ' +
              '	[PositionId] [int] IDENTITY(1,1) NOT NULL,                               ' +
              '	[hiCodeComputed] AS                                                      ' +
              '   (CONVERT([varbinary](20),substring([hiCode],(2),(20)),0)) PERSISTED    ' +
              ') ON [PRIMARY]';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.ExecSQL;
end;
*)

Destructor THistoryDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure THistoryDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
  FileName: string;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  if FForPurge then
  begin
    FileName := 'HISTPRGE';
//    CreateHistPrge(CompanyCode);
  end
  else
    FileName := 'HISTORY';

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].' + FileName + ' (' +
                                              'hiCode, ' +
                                              'hiExCLass, ' +
                                              'hiCurrency, ' +
                                              'hiYear, ' +
                                              'hiPeriod, ' +
                                              'hiSales, ' +
                                              'hiPurchases, ' +
                                              'hiBudget, ' +
                                              'hiCleared, ' +
                                              'hiRevisedBudget1, ' +
                                              'hiValue1, ' +
                                              'hiValue2, ' +
                                              'hiValue3, ' +
                                              'hiRevisedBudget2, ' +
                                              'hiRevisedBudget3, ' +
                                              'hiRevisedBudget4, ' +
                                              'hiRevisedBudget5, ' +
                                              'hiSpareV' +
                                              ') ' +
              'VALUES (' +
                       ':hiCode, ' +
                       ':hiExCLass, ' +
                       ':hiCurrency, ' +
                       ':hiYear, ' +
                       ':hiPeriod, ' +
                       ':hiSales, ' +
                       ':hiPurchases, ' +
                       ':hiBudget, ' +
                       ':hiCleared, ' +
                       ':hiRevisedBudget1, ' +
                       ':hiValue1, ' +
                       ':hiValue2, ' +
                       ':hiValue3, ' +
                       ':hiRevisedBudget2, ' +
                       ':hiRevisedBudget3, ' +
                       ':hiRevisedBudget4, ' +
                       ':hiRevisedBudget5, ' +
                       ':hiSpareV' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    hiCodeParam := FindParam('hiCode');
    hiExCLassParam := FindParam('hiExCLass');
    hiCurrencyParam := FindParam('hiCurrency');
    hiYearParam := FindParam('hiYear');
    hiPeriodParam := FindParam('hiPeriod');
    hiSalesParam := FindParam('hiSales');
    hiPurchasesParam := FindParam('hiPurchases');
    hiBudgetParam := FindParam('hiBudget');
    hiClearedParam := FindParam('hiCleared');
    hiRevisedBudget1Param := FindParam('hiRevisedBudget1');
    hiValue1Param := FindParam('hiValue1');
    hiValue2Param := FindParam('hiValue2');
    hiValue3Param := FindParam('hiValue3');
    hiRevisedBudget2Param := FindParam('hiRevisedBudget2');
    hiRevisedBudget3Param := FindParam('hiRevisedBudget3');
    hiRevisedBudget4Param := FindParam('hiRevisedBudget4');
    hiRevisedBudget5Param := FindParam('hiRevisedBudget5');
    hiSpareVParam := FindParam('hiSpareV');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure THistoryDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^HistoryRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    hiCodeParam.Value := CreateVariantArray (@Code, SizeOf(Code)); // SQL=varbinary, Delphi=Str20
    hiExCLassParam.Value := Ord(ExCLass);                                  // SQL=int, Delphi=Char
    hiCurrencyParam.Value := Cr;                                           // SQL=int, Delphi=Byte
    hiYearParam.Value := Yr;                                               // SQL=int, Delphi=Byte
    hiPeriodParam.Value := Pr;                                             // SQL=int, Delphi=Byte
    hiSalesParam.Value := Sales;                                           // SQL=float, Delphi=Double
    hiPurchasesParam.Value := Purchases;                                   // SQL=float, Delphi=Double
    hiBudgetParam.Value := Budget;                                         // SQL=float, Delphi=Double
    hiClearedParam.Value := Cleared;                                       // SQL=float, Delphi=Double
    hiRevisedBudget1Param.Value := RevisedBudget1;                         // SQL=float, Delphi=Double
    hiValue1Param.Value := Value1;                                         // SQL=float, Delphi=Double
    hiValue2Param.Value := Value2;                                         // SQL=float, Delphi=Double
    hiValue3Param.Value := Value3;                                         // SQL=float, Delphi=Double
    hiRevisedBudget2Param.Value := RevisedBudget2;                         // SQL=float, Delphi=Double
    hiRevisedBudget3Param.Value := RevisedBudget3;                         // SQL=float, Delphi=Double
    hiRevisedBudget4Param.Value := RevisedBudget4;                         // SQL=float, Delphi=Double
    hiRevisedBudget5Param.Value := RevisedBudget5;                         // SQL=float, Delphi=Double
    hiSpareVParam.Value := SpareV;                                         // SQL=float, Delphi=Double
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================


End.

