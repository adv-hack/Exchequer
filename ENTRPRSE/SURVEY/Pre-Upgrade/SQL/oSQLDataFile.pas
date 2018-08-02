Unit oSQLDataFile;

Interface

Uses Classes, SysUtils, Dialogs, Forms, StrUtils, ADODB, oBaseDataClasses, DataFileInfo;

Type
  TSQLGenericDataFile = Class(TDataFile)
  Protected
    FSchema : ShortString;
    FIndexSize : Int64;
    Function TableExists (ADOQuery : TADOQuery) : Boolean;
    Procedure GetIndexAnalysis (ADOQuery : TADOQuery);
    Procedure GetSpaceUsed (ADOQuery : TADOQuery);

    // Override the get function to take into account the index size
    Function GetFileSize : Int64; Override;
  Public
    Property Schema : ShortString Read FSchema Write FSchema;

    Constructor Create (Const DataFileInfo : IExchequerDataFileInfo);
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Virtual;
    Procedure WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString); Override;
  End; // TSQLGenericDataFile

  //------------------------------

  TSQLCustSuppDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLCustSuppDataFile

  //------------------------------

  TSQLDocumentDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLDocumentDataFile

  //------------------------------

  TSQLStockDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLStockDataFile

  //------------------------------

  TSQLJobDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLJobDataFile

  //------------------------------

  TSQLNominalDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLNominalDataFile

  //------------------------------

  TSQLExchqChkDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLExchqChkDataFile

  //------------------------------

  TSQLMLocStkDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLMLocStkDataFile

  //------------------------------

  TSQLExchqSSDataFile = Class(TSQLGenericDataFile)
  Public
    Procedure AnalyseDataFile (ADOQuery : TADOQuery); Override;
  End; // TSQLExchqSSDataFile

  //------------------------------


// Factory for creating the correct object for the data file
Function CreateDataFile (Const DataFileInfo : IExchequerDataFileInfo; Const Schema : ShortString) : TSQLGenericDataFile;

Implementation

Uses ConvUtil;

//=========================================================================

// Factory for creating the correct object for the data file
Function CreateDataFile (Const DataFileInfo : IExchequerDataFileInfo; Const Schema : ShortString) : TSQLGenericDataFile;
Begin // CreateDataFile
  Case DataFileInfo.dfiFileType Of
    edfCustSupp  : Result := TSQLCustSuppDataFile.Create(DataFileInfo);
    edfDocument  : Result := TSQLDocumentDataFile.Create(DataFileInfo);
    edfStock     : Result := TSQLStockDataFile.Create(DataFileInfo);
    edfJobHead   : Result := TSQLJobDataFile.Create(DataFileInfo);
    edfNominal   : Result := TSQLNominalDataFile.Create(DataFileInfo);
    edfExchqChk  : Result := TSQLExchqChkDataFile.Create(DataFileInfo);
    edfMLocStk   : Result := TSQLMLocStkDataFile.Create(DataFileInfo);
    edfExchqSS   : Result := TSQLExchqSSDataFile.Create(DataFileInfo);
  Else
    Result := TSQLGenericDataFile.Create(DataFileInfo);
  End; // Case FileType

  Result.Schema := Schema;
End; // CreateDataFile

//=========================================================================

Constructor TSQLGenericDataFile.Create (Const DataFileInfo : IExchequerDataFileInfo);
Begin // Create
  Inherited Create (DataFileInfo);
  FIndexSize := 0;
End; // Create

//-------------------------------------------------------------------------

// Override the get function to take into account the index size
Function TSQLGenericDataFile.GetFileSize : Int64;
Begin // GetFileSize
  Result := FFileSize + FIndexSize;
End; // GetFileSize

//-------------------------------------------------------------------------

Function TSQLGenericDataFile.TableExists (ADOQuery : TADOQuery) : Boolean;
Var
  Res : Integer;
Begin // TableExists
  ADOQuery.SQL.Text := 'Select * ' +
                         'From INFORMATION_SCHEMA.TABLES ' +
                        'Where (TABLE_SCHEMA = ''' + FSchema + ''') ' +
                          'And (TABLE_NAME = ''' + FDataFileInfo.dfiFilename + ''')';
  ADOQuery.Open;
  Try
    Result := (ADOQuery.RecordCount = 1);
  Finally
    ADOQuery.Close;
  End; // Try..Finally
End; // TableExists

//-------------------------------------------------------------------------

Procedure TSQLGenericDataFile.GetSpaceUsed (ADOQuery : TADOQuery);
Var
  Res : Integer;

  //------------------------------

  // Takes string in format "11680 KB" and returns a size in bytes
  Function KbToInt64 (Const SizeKb : ShortString) : Int64;
  Var
    NumStr : ShortString;
    I : Integer;
  Begin // KbToInt64
    // Strip out the number portion
    NumStr := '';
    For I := 1 To Length(SizeKb) Do
      If (SizeKb[I] In ['0'..'9']) Then
        NumStr := NumStr + SizeKb[I];

    Result := StrToInt(NumStr) * 1024;
  End; // KbToInt64

  //------------------------------

Begin // GetSpaceUsed
  ADOQuery.SQL.Text := 'sp_spaceused "[' + FSchema + '].[' + FDataFileInfo.dfiFilename + ']"';
  ADOQuery.Open;
  Try
    If (ADOQuery.RecordCount = 1) Then
    Begin
      ADOQuery.FindFirst;

      // Get number of rows
      FRecordCount := StrToInt(Trim(ADOQuery.FieldByName('rows').Value));

      // Get size of data
      FFileSize := KbToInt64 (ADOQuery.FieldByName('data').Value);

      // Get size of indexes
      FIndexSize := KbToInt64 (ADOQuery.FieldByName('index_size').Value);
    End; // If (ADOQuery.RecordCount = 1)
  Finally
    ADOQuery.Close;
  End; // Try..Finally
End; // GetSpaceUsed

//-------------------------------------------------------------------------

Procedure TSQLGenericDataFile.GetIndexAnalysis (ADOQuery : TADOQuery);
Begin // GetIndexAnalysis
  ADOQuery.SQL.Text := 'SELECT I.[NAME] AS [INDEX NAME], ' +
                              'USER_SEEKS, ' +
                              'USER_SCANS, ' +
                              'USER_LOOKUPS, ' +
                              'SYSTEM_SEEKS, ' +
                              'SYSTEM_SCANS, ' +
                              'SYSTEM_LOOKUPS ' +
                         'FROM SYS.DM_DB_INDEX_USAGE_STATS AS S ';

  ADOQuery.SQL.Text := ADOQuery.SQL.Text +
                        'INNER JOIN SYS.INDEXES AS I ' +
                              'ON I.[OBJECT_ID] = S.[OBJECT_ID] ' +
                              'AND I.INDEX_ID = S.INDEX_ID ' +
                        'Where OBJECTPROPERTY(S.[OBJECT_ID],''IsUserTable'') = 1 ' +
                        '  And (OBJECT_NAME(S.[OBJECT_ID]) NOT IN (''SchemaVersion'',''IRISDatasetConnection'',''IRISXMLSchema'')) ' +
                        '  And (type_desc <> ''HEAP'') ' +
                        '  And (OBJECT_NAME(S.[OBJECT_ID]) = ''' + FDataFileInfo.dfiFilename + ''')';
  ADOQuery.Open;
  Try
    If (ADOQuery.RecordCount > 0) Then
    Begin
      // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
      ADOQuery.First;
      While (Not ADOQuery.EOF) Do
      Begin
        // Extract index info and add into the additional detail list
        FAdditionalXML.Add ('<IndexAnalysis IndexName="' + ADOQuery.FieldByName('INDEX NAME').AsString +
                                         '" UserSeeks="' + ADOQuery.FieldByName('USER_SEEKS').AsString +
                                         '" UserScans="' + ADOQuery.FieldByName('USER_SCANS').AsString +
                                         '" UserLookups="' + ADOQuery.FieldByName('USER_LOOKUPS').AsString +
                                         '" SystemSeeks="' + ADOQuery.FieldByName('SYSTEM_SEEKS').AsString +
                                         '" SystemScans="' + ADOQuery.FieldByName('SYSTEM_SCANS').AsString +
                                         '" SystemLookups="' + ADOQuery.FieldByName('SYSTEM_LOOKUPS').AsString + '" />');
        ADOQuery.Next;
      End; // While (Not ADOQuery.EOF)
    End; // If (ADOQuery.RecordCount = 1)
  Finally
    ADOQuery.Close;
  End; // Try..Finally
End; // GetIndexAnalysis

//-------------------------------------------------------------------------

Procedure TSQLGenericDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Begin // AnalyseDataFile
  // Check for presence of table
  If TableExists (ADOQuery) Then
  Begin
    // Use the sp_spaceused function to get record count and file sizes
    GetSpaceUsed (ADOQuery);

    // Index analysis
    GetIndexAnalysis (ADOQuery);
  End // If TableExists (ADOQuery)
  Else
    FStatus := 'Missing';
End; // AnalyseDataFile

//-------------------------------------------------------------------------

Procedure TSQLGenericDataFile.WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
Var
  I : Integer;
Begin // WriteXML
  With SurveyResults Do
  Begin
    If (FRecordCount <> -1) Then
    Begin
      Add (IndentBy + '<DataFile Name="' + FDataFileInfo.dfiFileName + '" ' +
                                'Status="' + FStatus + '" ' +
                                'Records="' + IntToStr(FRecordCount) + '" ' +
                                'SizeMB="' + IntToStr(ToMb(FFileSize + FIndexSize)) + '" ' +
                                'DataSizeMB="' + IntToStr(ToMb(FFileSize)) + '" ' +
                                'IndexSizeMB="' + IntToStr(ToMb(FIndexSize)) + '" ' +
                                IfThen (FAdditionalXML.Count > 0, '>', ' />'));

      If (FAdditionalXML.Count > 0) Then
      Begin
        For I := 0 To (FAdditionalXML.Count - 1) Do
        Begin
          Add (IndentBy + '  ' + FAdditionalXML.Strings[I]);
        End; // For I

        Add (IndentBy + '</DataFile>');
      End; // If (FAdditionalXML.Count > 0)
    End // If (FRecordCount <> -1)
    Else
    Begin
      Add (IndentBy + '<DataFile name="' + FDataFileInfo.dfiFileName + '" Status="' + FStatus + '" />');
    End; // Else
  End; // With SurveyResults
End; // WriteXML

//=========================================================================

Procedure TSQLCustSuppDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    ADOQuery.SQL.Text := 'Select acCustSupp, COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[CustSupp] ' +
                          'Group By acCustSupp ' +
                          'Order By acCustSupp';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
        ADOQuery.First;
        While (Not ADOQuery.EOF) Do
        Begin
          FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" ' +
                                            'Description="' + IfThen(ADOQuery.FieldByName('acCustSupp').AsString = 'C', 'Customer', 'Supplier') + '" ' +
                                            'Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />');

          ADOQuery.Next;
        End; // While (Not ADOQuery.EOF)
      End; // If (ADOQuery.RecordCount = 1)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================

Procedure TSQLDocumentDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    ADOQuery.SQL.Text := 'Select Distinct SubString(thOurRef, 1, 3) As ''Prefix'', thDocType, COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[Document] ' +
                          'Group By SubString(thOurRef, 1, 3), thDocType ' +
                          'Order By thDocType';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
        ADOQuery.First;
        While (Not ADOQuery.EOF) Do
        Begin
          FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" ' +
                                            'Description="' + ADOQuery.FieldByName('Prefix').AsString + '" ' +
                                            'Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />');
          ADOQuery.Next;
        End; // While (Not ADOQuery.EOF)
      End; // If (ADOQuery.RecordCount = 1)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================

Procedure TSQLStockDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Var
  TypeChar : Char;
Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    // Analyse Stock by type --------------------------------------------
    ADOQuery.SQL.Text := 'Select stType, COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[Stock] ' +
                          'Group By stType ' +
                          'Order By stType';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
        ADOQuery.First;
        While (Not ADOQuery.EOF) Do
        Begin
          TypeChar := ADOQuery.FieldByName('stType').AsString[1];
          If (TypeChar = 'D') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Description" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'G') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Group" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'M') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="BillOfMaterial" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'P') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Product" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Discontinued" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />');

          ADOQuery.Next;
        End; // While (Not ADOQuery.EOF)
      End; // If (ADOQuery.RecordCount = 1)
    Finally
      ADOQuery.Close;
    End; // Try..Finally

    // Analyse Stock by Valuation Method ------------------------------
    ADOQuery.SQL.Text := 'Select stValuationMethod, stSerNoWAvg, COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[Stock] ' +
                          'Group By stValuationMethod, stSerNoWAvg ' +
                          'Order By stValuationMethod, stSerNoWAvg';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
        ADOQuery.First;
        While (Not ADOQuery.EOF) Do
        Begin
          TypeChar := ADOQuery.FieldByName('stValuationMethod').AsString[1];
          If (TypeChar = 'A') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="Average" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'C') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="LastCost" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'F') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="FIFO" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'L') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="LIFO" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'R') Then
          Begin
            // Need to check whether it is Serial/Batch or Serial/Batch Average
            If (ADOQuery.FieldByName('stSerNoWAvg').Value > 0) Then
              FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="SerialAverageCost" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
            Else
              FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="Serial" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />');
          End // If (TypeChar = 'R')
          Else
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="Standard" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />');

          ADOQuery.Next;
        End; // While (Not ADOQuery.EOF)
      End; // If (ADOQuery.RecordCount = 1)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================

Procedure TSQLJobDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    // Analyse jobs by type --------------------------------------------
    ADOQuery.SQL.Text := 'Select JobType, COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[JobHead] ' +
                          'Group By JobType ' +
                          'Order By JobType';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
        ADOQuery.First;
        While (Not ADOQuery.EOF) Do
        Begin
          If (ADOQuery.FieldByName('JobType').AsString[1] = 'K') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Contract" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Job" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />');

          ADOQuery.Next;
        End; // While (Not ADOQuery.EOF)
      End; // If (ADOQuery.RecordCount = 1)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================

Procedure TSQLNominalDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Var
  TypeChar : Char;
Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    // Analyse Stock by type --------------------------------------------
    ADOQuery.SQL.Text := 'Select glType, COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[Nominal] ' +
                          'Group By glType ' +
                          'Order By glType';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
        ADOQuery.First;
        While (Not ADOQuery.EOF) Do
        Begin
          TypeChar := ADOQuery.FieldByName('glType').AsString[1];

          If (TypeChar = 'A') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="ProfitLoss" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'B') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="BalanceSheet" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'C') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Control" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (TypeChar = 'F') Then
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="CarryFwd" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Heading" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />');

          ADOQuery.Next;
        End; // While (Not ADOQuery.EOF)
      End; // If (ADOQuery.RecordCount = 1)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================

Procedure TSQLExchqChkDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Var
  RecPFix : Char;
  SubType : Integer;
  TotCC, TotDept, HideCC, HideDept : Int64;
Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    // Report total Cost Centres + Active Count --------------------------------------------
    ADOQuery.SQL.Text := 'Select RecPfix, SubType, HideAC, COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[ExchqChk] ' +
                          'Where ((RecPfix = ''C'') And (SubType In (67, 68))) ' +  // CC/Dept
                             'Or ((RecPfix = ''P'') And (SubType = 0)) ' +          // Users
                          'Group By RecPfix, SubType, HideAC ' +
                          'Order By RecPfix, SubType, HideAC';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        TotCC := 0;
        TotDept := 0;
        HideCC := 0;
        HideDept := 0;

        // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
        ADOQuery.First;
        While (Not ADOQuery.EOF) Do
        Begin
          RecPFix := ADOQuery.FieldByName('RecPFix').AsString[1];
          SubType := ADOQuery.FieldByName('SubType').Value;

          If (RecPFix = 'P') And (SubType = 0) Then
            // Users
            FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Users" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
          Else If (RecPFix = 'C') Then
          Begin
            // CC/Dept
            If (SubType = 67) Then
            Begin
              // CC
              If (ADOQuery.FieldByName('HideAC').Value > 0) Then
                // Inactive
                HideCC := ADOQuery.FieldByName('RowCount').Value
              Else
                // Active
                TotCC := ADOQuery.FieldByName('RowCount').Value
            End // If (SubType = 67)
            Else
            Begin
              // Dept
              If (ADOQuery.FieldByName('HideAC').Value > 0) Then
                // Inactive
                HideDept:= ADOQuery.FieldByName('RowCount').Value
              Else
                // Active
                TotDept := ADOQuery.FieldByName('RowCount').Value
            End; // Else
          End; // If (RecPFix = 'C')

          ADOQuery.Next;
        End; // While (Not ADOQuery.EOF)

        FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="CostCentre" Count="' + IntToStr(TotCC) + '" />');
        FAdditionalXML.Add ('<DataAnalysis AnalysisType="Active" Description="CostCentre" Count="' + IntToStr(TotCC-HideCC) + '" />');

        FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Department" Count="' + IntToStr(TotDept) + '" />');
        FAdditionalXML.Add ('<DataAnalysis AnalysisType="Active" Description="Department" Count="' + IntToStr(TotDept-HideDept) + '" />');
      End; // If (ADOQuery.RecordCount = 1)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================

Procedure TSQLMLocStkDataFile.AnalyseDataFile (ADOQuery : TADOQuery);
Var
  RecPFix : Char;
  SubType : Integer;
  TotCC, TotDept, HideCC, HideDept : Int64;
Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    // If the Location table doesn't exist then count the number of Location records in MLocStk

    ADOQuery.SQL.Text := 'Select COUNT(*) As ''RowCount'' ' +
                           'From [' + FSchema + '].[MLocStk] ' +
                          'Where (RecPfix = ''C'') And (SubType = ''C'')';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        ADOQuery.First;
        FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Location" Count="' + IntToStr(ADOQuery.FieldByName('RowCount').Value) + '" />')
      End; // If (ADOQuery.RecordCount > 0)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================

Procedure TSQLExchqSSDataFile.AnalyseDataFile (ADOQuery : TADOQuery);

  //------------------------------

  // Translates the character used to store the Default Stock Valuation Method in System Setup - Stock
  // to a description
  function TranslateStockValuationMethod (Const StkValMethod : Char) : ShortString;
  begin
    Case StkValMethod Of
      'C' : Result := 'Last Cost';
      'S' : Result := 'Standard';
      'F' : Result := 'FIFO';
      'L' : Result := 'LIFO';
      'A' : Result := 'Average';
      'R' : Result := 'Serial/Batch';
      'E' : Result := 'Serial/Batch Average Cost';
    Else
      Result := 'Unknown';
    End; { Case }
  end;

  //------------------------------

Begin // AnalyseDataFile
  Inherited AnalyseDataFile(ADOQuery);

  If (FStatus = 'OK') Then
  Begin
    ADOQuery.SQL.Text := 'Select TotalConv, AutoStkVal, AutoValStk ' +
                           'From [' + FSchema + '].[ExchqSS] ' +
                          'Where (IDCode = 0x03535953)';
    ADOQuery.Open;
    Try
      If (ADOQuery.RecordCount > 0) Then
      Begin
        ADOQuery.First;

        If (ADOQuery.FieldByName('TotalConv').AsString = 'V') Then
          FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="CurrencyConsolidationMethod" Value="Daily" />')
        Else
          FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="CurrencyConsolidationMethod" Value="Company" />');

        FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="StockValuationMethod" Value="' + TranslateStockValuationMethod(ADOQuery.FieldByName('AutoStkVal').AsString[1]) + '" />');

        FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="LiveStockCostOfSalesValuation" Value="' + IfThen(ADOQuery.FieldByName('AutoValStk').Value = 1, 'On', 'Off') + '" />');
      End; // If (ADOQuery.RecordCount > 0)
    Finally
      ADOQuery.Close;
    End; // Try..Finally
  End; // If (FStatus = 'OK')
End; // AnalyseDataFile

//=========================================================================


End.
