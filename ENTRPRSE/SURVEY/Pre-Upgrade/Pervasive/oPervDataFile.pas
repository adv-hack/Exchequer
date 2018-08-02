Unit oPervDataFile;

Interface

Uses Classes, SysUtils, Dialogs, Forms, StrUtils, oBaseDataClasses, DataFileInfo, Enterprise01_TLB;

Type
  TPervasiveGenericDataFile = Class(TDataFile)
  Protected
    // Full path to btrieve file
    FFilePath : ShortString;

    // extension of last extension file - dat if none present
    FLastExtension : ShortString;

    // Btrieve File Format Version
    FFileFormat : ShortString;

    // Btrieve DB Engine Version
    FDBEngine : ShortString;
  Public
    Procedure AnalyseDataFile (Const DataPath : ShortString);
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Virtual;
    Procedure WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString); Override;
  End; // TPervasiveGenericDataFile

  //------------------------------

  TPervasiveCustSuppDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveCustSuppDataFile

  //------------------------------

  TPervasiveDocumentDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveDocumentDataFile

  //------------------------------

  TPervasiveStockDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveStockDataFile

  //------------------------------

  TPervasiveJobDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveJobDataFile

  //------------------------------

  TPervasiveNominalDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveNominalDataFile

  //------------------------------

  TPervasiveExchqChkDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveExchqChkDataFile

  //------------------------------

  TPervasiveMLocStkDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveMLocStkDataFile

  //------------------------------

  TPervasiveExchqSSDataFile = Class(TPervasiveGenericDataFile)
  Public
    Procedure AnalyseFileContents (Const COMToolkit : IToolkit); Override;
  End; // TPervasiveExchqSSDataFile

  //------------------------------

// Factory for creating the correct object for the data file
Function CreateDataFile (Const DataFileInfo : IExchequerDataFileInfo) : TPervasiveGenericDataFile;

Implementation

Uses oBtrieveFile, oGenericBtrieveFile, ConvUtil;

//=========================================================================

// Factory for creating the correct object for the data file
Function CreateDataFile (Const DataFileInfo : IExchequerDataFileInfo) : TPervasiveGenericDataFile;
Begin // CreateDataFile
  Case DataFileInfo.dfiFileType Of
    edfCustSupp  : Result := TPervasiveCustSuppDataFile.Create(DataFileInfo);
    edfDocument  : Result := TPervasiveDocumentDataFile.Create(DataFileInfo);
    edfStock     : Result := TPervasiveStockDataFile.Create(DataFileInfo);
    edfJobHead   : Result := TPervasiveJobDataFile.Create(DataFileInfo);
    edfNominal   : Result := TPervasiveNominalDataFile.Create(DataFileInfo);
    edfExchqChk  : Result := TPervasiveExchqChkDataFile.Create(DataFileInfo);
    edfMLocStk   : Result := TPervasiveMLocStkDataFile.Create(DataFileInfo);
    edfExchqSS   : Result := TPervasiveExchqSSDataFile.Create(DataFileInfo);
  Else
    Result := TPervasiveGenericDataFile.Create(DataFileInfo);
  End; // Case FileType
End; // CreateDataFile

//=========================================================================

Procedure TPervasiveGenericDataFile.AnalyseDataFile (Const DataPath : ShortString);
Var
  oBtrFile : TGenericBtrieveFile;
  lRes : LongInt;
  Version, SubVersion : SmallInt;
  EngineType : Char;
Begin // AnalyseDataFile
  // Calculate the location of the file
  FFilePath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(DataPath) + FDataFileInfo.dfiSubDirectory) + FDataFileInfo.dfiFileName + '.Dat';
//ShowMessage ('TPervasiveGenericDataFile.AnalyseDataFile: ' + FFilePath);

  If FileExists(FFilePath) Then
  Begin
    // Calculate the size of the specified btrieve file and any extension files in bytes
    FFileSize := TBtrieveFileUtilities.Size(FFilePath);

    // Get the extension of the last extension file
    FLastExtension := TBtrieveFileUtilities.LastExtensionFile(FFilePath);

    // Open the data file and get the file stats
    oBtrFile := TGenericBtrieveFile.Create;
    Try
      lRes := oBtrFile.OpenFile (FFilePath, False, v600Owner);
      If (lRes = 0) Then
      Begin
        FRecordCount := oBtrFile.GetRecordCount;
        FFileFormat := 'v' + IntToStr(oBtrFile.FileVersion);
        If (oBtrFile.FileVersion < 6) Then
          FStatus := 'Rebuild';

        // CJS: 26/11/2007: The EngineType was sometimes #0, resulting in the
        // string being truncated.
        oBtrFile.GetEngineVersion (Version, SubVersion, EngineType, 1);
        FDBEngine := IntToStr(Version) + '.' + IntToStr(SubVersion) + Trim(EngineType) + '/';
        oBtrFile.GetEngineVersion (Version, SubVersion, EngineType, 2);
        FDBEngine := FDBEngine + IntToStr(Version) + '.' + IntToStr(SubVersion) + Trim(EngineType) + '/';
        oBtrFile.GetEngineVersion (Version, SubVersion, EngineType, 3);
        FDBEngine := FDBEngine + IntToStr(Version) + '.' + IntToStr(SubVersion) + Trim(EngineType);

        oBtrFile.CloseFile;
      End // If (lRes = 0)
      Else
        FStatus := 'Error ' + IntToStr(lRes) + ' opening file';
    Finally
      FreeAndNIL(oBtrFile);
    End; // Try..Finally
  End // If FileExists(sPath)
  Else
    FStatus := 'Missing';
End; // AnalyseDataFile

//-------------------------------------------------------------------------

Procedure TPervasiveGenericDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);
Begin // AnalyseFileContents

  // Do nothing in base class

End; // AnalyseFileContents

//-------------------------------------------------------------------------

Procedure TPervasiveGenericDataFile.WriteXML (SurveyResults : TStringList; Const IndentBy : ShortString);
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
                                'SizeMB="' + IntToStr(ToMb(FFileSize)) + '" ' +
                                'FileFormat="' + FFileFormat + '" ' +
                                'DBEngine="' + FixDodgyChars(FDBEngine) + '" ' +
                                IfThen (UpperCase(FLastExtension) <> 'DAT', 'LastExtension="' + FLastExtension + '"', '') +
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

Procedure TPervasiveCustSuppDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);

  //------------------------------

  // Runs through and counts the Customers/Suppliers in the supplied IAccount instance
  Function CountAccounts (Account : IAccount) : Integer;
  Var
    Res : Integer;
  Begin // CountAccounts
    Result := 0;

    Account.Index := acIdxCode;
    Res := Account.GetFirst;
    While (Res = 0) Do
    Begin
      Result := Result + 1;
      Res := Account.GetNext;

      Application.ProcessMessages;
    End; // While (Res = 0)
  End; // CountAccounts

  //------------------------------

Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  // Count Customers and Suppliers
  FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Customer" Count="' + IntToStr(CountAccounts (COMToolkit.Customer)) + '" />');
  FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Supplier" Count="' + IntToStr(CountAccounts (COMToolkit.Supplier)) + '" />');
End; // AnalyseFileContents

//=========================================================================

Procedure TPervasiveDocumentDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);
Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  // Report next Document No's as that is a lot quicker than counting individual transaction types in Document.Dat
  With COMToolkit.SystemSetup Do
  Begin
    If ((ssDocumentNumbers['SIN'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SIN" Count="' + IntToStr((ssDocumentNumbers['SIN'] - 1)) + '" />');
    If ((ssDocumentNumbers['SRC'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SRC" Count="' + IntToStr((ssDocumentNumbers['SRC'] - 1)) + '" />');
    If ((ssDocumentNumbers['SCR'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SCR" Count="' + IntToStr((ssDocumentNumbers['SCR'] - 1)) + '" />');
    If ((ssDocumentNumbers['SJI'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SJI" Count="' + IntToStr((ssDocumentNumbers['SJI'] - 1)) + '" />');
    If ((ssDocumentNumbers['SJC'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SJC" Count="' + IntToStr((ssDocumentNumbers['SJC'] - 1)) + '" />');
    If ((ssDocumentNumbers['SRF'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SRF" Count="' + IntToStr((ssDocumentNumbers['SRF'] - 1)) + '" />');
    If ((ssDocumentNumbers['SRI'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SRI" Count="' + IntToStr((ssDocumentNumbers['SRI'] - 1)) + '" />');
    If ((ssDocumentNumbers['SQU'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SQU" Count="' + IntToStr((ssDocumentNumbers['SQU'] - 1)) + '" />');
    If ((ssDocumentNumbers['SOR'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SOR" Count="' + IntToStr((ssDocumentNumbers['SOR'] - 1)) + '" />');
    If ((ssDocumentNumbers['SDN'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SDN" Count="' + IntToStr((ssDocumentNumbers['SDN'] - 1)) + '" />');
    If ((ssDocumentNumbers['SBT'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SBT" Count="' + IntToStr((ssDocumentNumbers['SBT'] - 1)) + '" />');
    If ((ssDocumentNumbers['PIN'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PIN" Count="' + IntToStr((ssDocumentNumbers['PIN'] - 1)) + '" />');
    If ((ssDocumentNumbers['PPY'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PPY" Count="' + IntToStr((ssDocumentNumbers['PPY'] - 1)) + '" />');
    If ((ssDocumentNumbers['PCR'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PCR" Count="' + IntToStr((ssDocumentNumbers['PCR'] - 1)) + '" />');
    If ((ssDocumentNumbers['PJI'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PJI" Count="' + IntToStr((ssDocumentNumbers['PJI'] - 1)) + '" />');
    If ((ssDocumentNumbers['PJC'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PJC" Count="' + IntToStr((ssDocumentNumbers['PJC'] - 1)) + '" />');
    If ((ssDocumentNumbers['PRF'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PRF" Count="' + IntToStr((ssDocumentNumbers['PRF'] - 1)) + '" />');
    If ((ssDocumentNumbers['PPI'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PPI" Count="' + IntToStr((ssDocumentNumbers['PPI'] - 1)) + '" />');
    If ((ssDocumentNumbers['PQU'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PQU" Count="' + IntToStr((ssDocumentNumbers['PQU'] - 1)) + '" />');
    If ((ssDocumentNumbers['POR'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="POR" Count="' + IntToStr((ssDocumentNumbers['POR'] - 1)) + '" />');
    If ((ssDocumentNumbers['PDN'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PDN" Count="' + IntToStr((ssDocumentNumbers['PDN'] - 1)) + '" />');
    If ((ssDocumentNumbers['PBT'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PBT" Count="' + IntToStr((ssDocumentNumbers['PBT'] - 1)) + '" />');
    If ((ssDocumentNumbers['NOM'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="NOM" Count="' + IntToStr((ssDocumentNumbers['NOM'] - 1)) + '" />');
    If ((ssDocumentNumbers['ADJ'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="ADJ" Count="' + IntToStr((ssDocumentNumbers['ADJ'] - 1)) + '" />');
    If ((ssDocumentNumbers['TSH'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="TSH" Count="' + IntToStr((ssDocumentNumbers['TSH'] - 1)) + '" />');
    If ((ssDocumentNumbers['WOR'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="WOR" Count="' + IntToStr((ssDocumentNumbers['WOR'] - 1)) + '" />');
    If ((ssDocumentNumbers['JCT'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="JCT" Count="' + IntToStr((ssDocumentNumbers['JCT'] - 1)) + '" />');
    If ((ssDocumentNumbers['JST'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="JST" Count="' + IntToStr((ssDocumentNumbers['JST'] - 1)) + '" />');
    If ((ssDocumentNumbers['JPT'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="JPT" Count="' + IntToStr((ssDocumentNumbers['JPT'] - 1)) + '" />');
    If ((ssDocumentNumbers['JSA'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="JSA" Count="' + IntToStr((ssDocumentNumbers['JSA'] - 1)) + '" />');
    If ((ssDocumentNumbers['JPA'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="JPA" Count="' + IntToStr((ssDocumentNumbers['JPA'] - 1)) + '" />');
    If ((ssDocumentNumbers['SRN'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="SRN" Count="' + IntToStr((ssDocumentNumbers['SRN'] - 1)) + '" />');
    If ((ssDocumentNumbers['PRN'] - 1) <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="PRN" Count="' + IntToStr((ssDocumentNumbers['PRN'] - 1)) + '" />');
  End; // With COMToolkit.SystemSetup
End; // AnalyseFileContents

//=========================================================================

Procedure TPervasiveStockDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);
Var
  Res : Integer;
  TotalType_Group, TotalType_Product, TotalType_Description, TotalType_BoM, TotalType_Discontinued : Integer;
  TotalVal_Standard, TotalVal_LastCost, TotalVal_FIFO, TotalVal_LIFO, TotalVal_Average, TotalVal_Serial, TotalVal_SerialAvgCost : Integer;
Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  TotalType_Group := 0;
  TotalType_Product := 0;
  TotalType_Description := 0;
  TotalType_BoM := 0;
  TotalType_Discontinued := 0;

  TotalVal_Standard := 0;
  TotalVal_LastCost := 0;
  TotalVal_FIFO := 0;
  TotalVal_LIFO := 0;
  TotalVal_Average := 0;
  TotalVal_Serial := 0;
  TotalVal_SerialAvgCost := 0;

  // MH 02/01/13 ABSEXCH-13869: Added licensing checks during analysis to prevent COM Toolkit displaying error messages
  If (COMToolkit.Enterprise.enModuleVersion > 0) Then  // Stock
  Begin
    // Report on Stock by Stock Type and Valuation Method
    With COMToolkit.Stock Do
    Begin
      Index := stIdxCode;

      // Note: Use Step functions as it should give slightly superior performance in Stock.Dat
      Res := StepFirst;
      While (Res = 0) Do
      Begin
        Try
          // Check Stock Type
          If (stType = stTypeGroup) Then
            TotalType_Group := TotalType_Group + 1
          Else If (stType = stTypeProduct) Then
            TotalType_Product := TotalType_Product + 1
          Else If (stType = stTypeDescription) Then
            TotalType_Description := TotalType_Description + 1
          Else If (stType = stTypeBillOfMaterials) Then
            TotalType_BoM := TotalType_BoM + 1
          Else If (stType = stTypeDiscontinued) Then
            TotalType_Discontinued := TotalType_Discontinued + 1;

          // Check Stock Valuation Method
          If (stValuationMethod = stValStandard) Then
            TotalVal_Standard := TotalVal_Standard + 1
          Else If (stValuationMethod = stValLastCost) Then
            TotalVal_LastCost := TotalVal_LastCost + 1
          Else If (stValuationMethod = stValFIFO) Then
            TotalVal_FIFO := TotalVal_FIFO + 1
          Else If (stValuationMethod = stValLIFO) Then
            TotalVal_LIFO := TotalVal_LIFO + 1
          Else If (stValuationMethod = stValAverage) Then
            TotalVal_Average := TotalVal_Average + 1
          Else If (stValuationMethod = stValSerial) Then
            TotalVal_Serial := TotalVal_Serial + 1
          Else If (stValuationMethod = stValSerialAvgCost) Then
            TotalVal_SerialAvgCost := TotalVal_SerialAvgCost + 1;
        Except
          On E:Exception Do
            MessageDlg ('The following error occurred whilst analysing Stock Item ' + Trim(stCode) + ':-' + #13#13 + E.Message, mtError, [mbOK], 0);
        End; // Try..Except

        Res := StepNext;

        Application.ProcessMessages;
      End; // While (Res = 0)
    End; // With COMToolkit.Stock

    // Report used Stock Types
    If (TotalType_Group <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Group" Count="' + IntToStr(TotalType_Group) + '" />');
    If (TotalType_Product <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Product" Count="' + IntToStr(TotalType_Product) + '" />');
    If (TotalType_Description <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Description" Count="' + IntToStr(TotalType_Description) + '" />');
    If (TotalType_BoM <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="BillOfMaterial" Count="' + IntToStr(TotalType_BoM) + '" />');
    If (TotalType_Discontinued <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Discontinued" Count="' + IntToStr(TotalType_Discontinued) + '" />');

    // Report used Stock Valuation Methods
    If (TotalVal_Standard <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="Standard" Count="' + IntToStr(TotalVal_Standard) + '" />');
    If (TotalVal_LastCost <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="LastCost" Count="' + IntToStr(TotalVal_LastCost) + '" />');
    If (TotalVal_FIFO <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="FIFO" Count="' + IntToStr(TotalVal_FIFO) + '" />');
    If (TotalVal_LIFO <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="LIFO" Count="' + IntToStr(TotalVal_LIFO) + '" />');
    If (TotalVal_Average <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="Average" Count="' + IntToStr(TotalVal_Average) + '" />');
    If (TotalVal_Serial <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="Serial" Count="' + IntToStr(TotalVal_Serial) + '" />');
    If (TotalVal_SerialAvgCost <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="ValuationMethod" Description="SerialAverageCost" Count="' + IntToStr(TotalVal_SerialAvgCost) + '" />');
  End; // If (COMToolkit.Enterprise.enModuleVersion > 0)
End; // AnalyseFileContents

//=========================================================================

Procedure TPervasiveJobDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);
Var
  Res : Integer;
  TotalType_Contract, TotalType_Job : Integer;
Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  TotalType_Contract := 0;
  TotalType_Job := 0;

  // MH 02/01/13 ABSEXCH-13869: Added licensing checks during analysis to prevent COM Toolkit displaying error messages
  If (COMToolkit.SystemSetup.ssReleaseCodes.rcJobCosting <> rcDisabled) Then
  Begin
    // Report Jobs by Type
    With COMToolkit.JobCosting.Job Do
    Begin
      Index := jrIdxCode;

      // Note: Use Step functions as it should give slightly superior performance in JobHead.Dat
      Res := StepFirst;
      While (Res = 0) Do
      Begin
        Try
          // Check Job Type
          If (jrType = JTypeContract) Then
            TotalType_Contract := TotalType_Contract + 1
          Else If (jrType = JTypeJob) Then
            TotalType_Job := TotalType_Job + 1;
        Except
          On E:Exception Do
            MessageDlg ('The following error occurred whilst analysing Job ' + Trim(jrCode) + ':-' + #13#13 + E.Message, mtError, [mbOK], 0);
        End; // Try..Except

        Res := StepNext;

        Application.ProcessMessages;
      End; // While (Res = 0)
    End; // With COMToolkit.JobCosting.Job

    // Report used Stock Types
    If (TotalType_Contract <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Contract" Count="' + IntToStr(TotalType_Contract) + '" />');
    If (TotalType_Job <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Job" Count="' + IntToStr(TotalType_Job) + '" />');
  End; // If (COMToolkit.SystemSetup.ssReleaseCodes.rcJobCosting <> rcDisabled)
End; // AnalyseFileContents

//=========================================================================

Procedure TPervasiveNominalDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);
Var
  Res : Integer;
  TotalType_ProfitLoss, TotalType_BalanceSheet, TotalType_Control, TotalType_CarryFwd, TotalType_Heading : Integer;
Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  TotalType_ProfitLoss := 0;
  TotalType_BalanceSheet := 0;
  TotalType_Control := 0;
  TotalType_CarryFwd := 0;
  TotalType_Heading := 0;

  // Report GL Codes by Type
  With COMToolkit.GeneralLedger Do
  Begin
    Index := glIdxCode;

    // Note: Use Step functions as it should give slightly superior performance in Nominal.Dat
    Res := StepFirst;
    While (Res = 0) Do
    Begin
      Try
        // Check Nominal Type
        If (glType = glTypeProfitLoss) Then
          TotalType_ProfitLoss := TotalType_ProfitLoss + 1
        Else If (glType = glTypeBalanceSheet) Then
          TotalType_BalanceSheet := TotalType_BalanceSheet + 1
        Else If (glType = glTypeControl) Then
          TotalType_Control := TotalType_Control + 1
        Else If (glType = glTypeCarryFwd) Then
          TotalType_CarryFwd := TotalType_CarryFwd + 1
        Else If (glType = glTypeHeading) Then
          TotalType_Heading := TotalType_Heading + 1;
      Except
        On E:Exception Do
          MessageDlg ('The following error occurred whilst analysing GL Code ' + IntToStr(glCode) + ':-' + #13#13 + E.Message, mtError, [mbOK], 0);
      End; // Try..Except

      Res := StepNext;

      Application.ProcessMessages;
    End; // While (Res = 0)
  End; // With COMToolkit.JobCosting.Job

  // Report used Stock Types
  If (TotalType_ProfitLoss <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="ProfitLoss" Count="' + IntToStr(TotalType_ProfitLoss) + '" />');
  If (TotalType_BalanceSheet <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="BalanceSheet" Count="' + IntToStr(TotalType_BalanceSheet) + '" />');
  If (TotalType_Control <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Control" Count="' + IntToStr(TotalType_Control) + '" />');
  If (TotalType_CarryFwd <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="CarryFwd" Count="' + IntToStr(TotalType_CarryFwd) + '" />');
  If (TotalType_Heading <> 0) Then FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Heading" Count="' + IntToStr(TotalType_Heading) + '" />');
End; // AnalyseFileContents

//=========================================================================

Procedure TPervasiveExchqChkDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);

  //------------------------------

  // Runs through and counts the Cost Centres/Departments in the supplied ICCDept instance
  Procedure CountCCDepts (CCDept : ICCDept2; Var TotCount, TotActive : Integer);
  Var
    Res : Integer;
  Begin // CountCCDepts
    TotCount := 0;
    TotActive := 0;

    CCDept.Index := cdIdxCode;
    Res := CCDept.GetFirst;
    While (Res = 0) Do
    Begin
      TotCount := TotCount + 1;
      If (Not CCDept.cdInactive) Then
        TotActive := TotActive + 1;

      Res := CCDept.GetNext;

      Application.ProcessMessages;
    End; // While (Res = 0)
  End; // CountCCDepts

  //------------------------------

  // Runs through and counts the User Profiles
  Function CountUsers (Users : IUserProfile) : Integer;
  Var
    Res : Integer;
  Begin // CountUsers
    Result := 0;

    Users.Index := usIdxLogin;
    Res := Users.GetFirst;
    While (Res = 0) Do
    Begin
      Result := Result + 1;
      Res := Users.GetNext;

      Application.ProcessMessages;
    End; // While (Res = 0)
  End; // CountUsers

  //------------------------------

Var
  TotalCount, TotalActive : Integer;

Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  // Count Customers and Suppliers
  CountCCDepts (COMToolkit.CostCentre As ICCDept2, TotalCount, TotalActive);
  FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="CostCentre" Count="' + IntToStr(TotalCount) + '" />');
  FAdditionalXML.Add ('<DataAnalysis AnalysisType="Active" Description="CostCentre" Count="' + IntToStr(TotalActive) + '" />');

  CountCCDepts (COMToolkit.Department As ICCDept2, TotalCount, TotalActive);
  FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Department" Count="' + IntToStr(TotalCount) + '" />');
  FAdditionalXML.Add ('<DataAnalysis AnalysisType="Active" Description="Department" Count="' + IntToStr(TotalActive) + '" />');

  // Count Users
  FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Users" Count="' + IntToStr(CountUsers((COMToolkit As IToolkit2).UserProfile)) + '" />');
End; // AnalyseFileContents

//=========================================================================

Procedure TPervasiveMLocStkDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);
Var
  Res : Integer;
  TotalType_Location : Integer;
Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  TotalType_Location := 0;

  // MH 02/01/13 ABSEXCH-13869: Added licensing checks during analysis to prevent COM Toolkit displaying error messages
  If (COMToolkit.Enterprise.enModuleVersion > 0) Then  // Stock
  Begin
    With COMToolkit.Location Do
    Begin
      Index := loIdxCode;
      Res := GetFirst;
      While (Res = 0) Do
      Begin
        TotalType_Location := TotalType_Location + 1;

        Res := GetNext;

        Application.ProcessMessages;
      End; // While (Res = 0)
    End; // With COMToolkit.Location

    FAdditionalXML.Add ('<DataAnalysis AnalysisType="Type" Description="Location" Count="' + IntToStr(TotalType_Location) + '" />');
  End; // If (COMToolkit.Enterprise.enModuleVersion > 0)
End; // AnalyseFileContents

//=========================================================================

Procedure TPervasiveExchqSSDataFile.AnalyseFileContents (Const COMToolkit : IToolkit);

  //------------------------------

  // Translates the character used to store the Default Stock Valuation Method in System Setup - Stock
  // to a description
  function TranslateStockValuationMethod (Const StkValMethod : WideChar) : ShortString;
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

Begin // AnalyseFileContents
  Inherited AnalyseFileContents(COMToolkit);

  With COMToolkit.SystemSetup Do
  Begin
    If (ssCurrencyRateType = rtCompany) Then
      FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="CurrencyConsolidationMethod" Value="Company" />')
    Else
      FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="CurrencyConsolidationMethod" Value="Daily" />');

    FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="StockValuationMethod" Value="' + TranslateStockValuationMethod(ssDefaultStockValMethod[1]) + '" />');

    FAdditionalXML.Add ('<DataAnalysis AnalysisType="SystemSettings" Description="LiveStockCostOfSalesValuation" Value="' + IfThen(ssLiveStockCOSVal, 'On', 'Off') + '" />');
  End; // With COMToolkit.SystemSetup
End; // AnalyseFileContents

//=========================================================================

End.
