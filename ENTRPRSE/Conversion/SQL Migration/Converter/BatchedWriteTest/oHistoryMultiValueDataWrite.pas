Unit oHistoryMultiValueDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, ADOInt, oBaseDataWrite, oDataPacket;

Type
  THistoryDataWrite = Class(TMultiValueDataWrite)
  Private
    FTableName : ShortString;
    FForPurge: Boolean;

    FADODataset : TADODataset;

    // Creates the HISTPRGE table if it does not exist (the Emulator will not
    // create it automatically, as it knows nothing about it).
    Procedure CreateHistPrge (Const CompanyCode : ShortString);
  Protected
    // Implemented in descendants to setup the basic 'Insert Into ...' part of the query
    Procedure InitialiseInsert; Override;
    // Implemented in descendants to append the data values to the existing Insert statement
    Procedure AppendToInsert (Const DataPacket : TDataPacket; Const FirstPacket : Boolean); Override;
  Public
    Constructor Create;
    Constructor CreateForPurge;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;
  End; // THistoryDataWrite

Implementation

Uses SysUtils, Variants, EntSettings, SQLConvertUtils, VarConst, SQLUtils;

//=========================================================================

Constructor THistoryDataWrite.Create;
Begin // Create
  Inherited Create;

  FForPurge := False;
  FTableName := 'History';
End; // Create

//------------------------------

constructor THistoryDataWrite.CreateForPurge;
begin
  Inherited Create;
  FForPurge := True;
  FTableName := 'HistPrge';
end;

//------------------------------

Destructor THistoryDataWrite.Destroy;
Begin // Destroy
  FreeAndNIL(FADODataset);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

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
              '	[hiBudget2] [float] NOT NULL,                                            ' +
              '	[hiValue1] [float] NOT NULL,                                             ' +
              '	[hiValue2] [float] NOT NULL,                                             ' +
              '	[hiValue3] [float] NOT NULL,                                             ' +
              '	[hiSpareV1] [float] NOT NULL,                                            ' +
              '	[hiSpareV2] [float] NOT NULL,                                            ' +
              '	[hiSpareV3] [float] NOT NULL,                                            ' +
              '	[hiSpareV4] [float] NOT NULL,                                            ' +
              '	[hiSpareV5] [float] NOT NULL,                                            ' +
              '	[PositionId] [int] IDENTITY(1,1) NOT NULL,                               ' +
              '	[hiCodeComputed] AS                                                      ' +
              '   (CONVERT([varbinary](20),substring([hiCode],(2),(20)),0)) PERSISTED    ' +
              ') ON [PRIMARY]';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.ExecSQL;
end;

//------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure THistoryDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  if FForPurge then
  begin
    CreateHistPrge(CompanyCode);
  end;

  (*
  FADODataset := TADODataset.Create(NIL);
  FADODataset.Connection := ADOConnection;
  FADODataset.CursorLocation := clUseClient;
  FADODataset.CursorType := ctStatic;

  FADODataset.CommandText := 'Select * From [ROOT01].History Where hiCode = ''0x20''';

  FADODataset.Open;
  *)

  (*
  FADODataset.Recordset.Fields.Append ('hiCode',      adVarBinary, 21, 0);
  FADODataset.Recordset.Fields.Append ('hiExCLass',   adInteger,    4, 0);
  FADODataset.Recordset.Fields.Append ('hiCurrency',  adInteger,    4, 0);
  FADODataset.Recordset.Fields.Append ('hiYear',      adInteger,    4, 0);
  FADODataset.Recordset.Fields.Append ('hiPeriod',    adInteger,    4, 0);
  FADODataset.Recordset.Fields.Append ('hiSales',     adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiPurchases', adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiBudget',    adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiCleared',   adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiBudget2',   adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiValue1',    adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiValue2',    adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiValue3',    adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiSpareV1',   adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiSpareV2',   adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiSpareV3',   adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiSpareV4',   adDouble,     8, 0);
  FADODataset.Recordset.Fields.Append ('hiSpareV5',   adDouble,     8, 0);
  *)



End; // Prepare

//-------------------------------------------------------------------------

Procedure THistoryDataWrite.InitialiseInsert;
Begin // InitialiseInsert
  // Setup the SQL Query and prepare it
  FsqlQuery := 'INSERT INTO [COMPANY].' + FTableName + ' (' +
                                                          'hiCode, ' +
                                                          'hiExCLass, ' +
                                                          'hiCurrency, ' +
                                                          'hiYear, ' +
                                                          'hiPeriod, ' +
                                                          'hiSales, ' +
                                                          'hiPurchases, ' +
                                                          'hiBudget, ' +
                                                          'hiCleared, ' +
                                                          'hiBudget2, ' +
                                                          'hiValue1, ' +
                                                          'hiValue2, ' +
                                                          'hiValue3, ' +
                                                          'hiSpareV1, ' +
                                                          'hiSpareV2, ' +
                                                          'hiSpareV3, ' +
                                                          'hiSpareV4, ' +
                                                          'hiSpareV5' +
                                                        ') ' +
               'VALUES ';
End; // InitialiseInsert

//-------------------------------------------------------------------------

// Implemented in descendants to append the data values to the existing Insert statement
Procedure THistoryDataWrite.AppendToInsert (Const DataPacket : TDataPacket; Const FirstPacket : Boolean);
Var
  DataRec : ^HistoryRec;
Begin // AppendToInsert
  // For subsequent updates we need to add a comma at the end of the previous block of values
  If (Not FirstPacket) Then
    FsqlQuery := FsqlQuery + ', ';

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;
  With DataRec^ Do
  Begin
    FsqlQuery := FsqlQuery + '(' +
                              StringToHex(Code, 20, True, '20') + ', ' +
                              IntToStr(Ord(ExClass)) + ', ' +
                              IntToStr(Cr) + ', ' +
                              IntToStr(Yr) + ', ' +
                              IntToStr(Pr) + ', ' +
                              FloatToStr(Sales) + ', ' +
                              FloatToStr(Purchases) + ', ' +
                              FloatToStr(Budget) + ', ' +
                              FloatToStr(Cleared) + ', ' +
                              FloatToStr(Budget2) + ', ' +
                              FloatToStr(Value1) + ', ' +
                              FloatToStr(Value2) + ', ' +
                              FloatToStr(Value3) + ', ' +
                              FloatToStr(SpareV[1]) + ', ' +
                              FloatToStr(SpareV[2]) + ', ' +
                              FloatToStr(SpareV[3]) + ', ' +
                              FloatToStr(SpareV[4]) + ', ' +
                              FloatToStr(SpareV[5]) +
                             ')';
  End; // With DataRec^
End; // AppendToInsert

//-------------------------------------------------------------------------

(*
// Sets the values of the private parameters prior to inserting the data
Procedure THistoryDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
//Var
//  DataRec : ^HistoryRec;
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
    hiBudget2Param.Value := Budget2;                                       // SQL=float, Delphi=Double
    hiValue1Param.Value := Value1;                                         // SQL=float, Delphi=Double
    hiValue2Param.Value := Value2;                                         // SQL=float, Delphi=Double
    hiValue3Param.Value := Value3;                                         // SQL=float, Delphi=Double
    hiSpareV1Param.Value := SpareV[1];                                       // SQL=float, Delphi=Double
    hiSpareV2Param.Value := SpareV[2];                                       // SQL=float, Delphi=Double
    hiSpareV3Param.Value := SpareV[3];                                       // SQL=float, Delphi=Double
    hiSpareV4Param.Value := SpareV[4];                                       // SQL=float, Delphi=Double
    hiSpareV5Param.Value := SpareV[5];                                       // SQL=float, Delphi=Double
  End; // With DataRec^
End; // SetParameterValues
*)

//=========================================================================

End.

