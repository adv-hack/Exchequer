Unit oSQLInstallationData;

Interface

Uses oBaseDataClasses, Classes, Forms, SysUtils, Windows, ADODB,ExchConnect;

Type
  // Function templates for ICoreBtrv API
  TSQLCommonConnectionStringCall = function (
                                              SecuritySignature: PChar;
                                              ClientId: PChar;
                                              ConnectionBuffer: Pointer;
                                              BufferSize: Pointer
                                            ) : Integer; stdcall;

  //------------------------------

  TMSSQLInstallationData = Class(TInstallationData)
  Private
    FCommonConnectionString : ANSIString;

    hICoreBtrvDll : LongWord;
    hGetCommonConnectionStringFunc : TSQLCommonConnectionStringCall;

    Procedure GetDatabaseFileSizes (ADOQuery : TADOQuery);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure ScanInstallation; Override;
  End; // TMSSQLInstallationData

Implementation

Uses oSurveyStore, DataFileInfo, oSQLDataFile, ConvUtil;

//=========================================================================

Constructor TMSSQLInstallationData.Create;
Var
  Buffer: PChar;
  BufferSize: Integer;
  Res : Integer;
Begin // Create
  Inherited Create;

  // Always appears to be ICoreBtrv.~Dll
  // DLLPath + 'icorebtrv.dll

  hICoreBtrvDll := LoadLibrary('icorebtrv.dll'); // Should be in current directory
  If (hICoreBtrvDll <> 0) Then
  Begin
    // Get handles to ICoreBtrv.Dll functions
    @hGetCommonConnectionStringFunc := GetProcAddress(hICoreBtrvDll, 'GetCommonConnectionString');

    // Get Common Connection String - we can also use this for the companies
    BufferSize := 256;
    Buffer := StrAlloc(BufferSize);
    Res := hGetCommonConnectionStringFunc('WMIT_GCC', NIL, @Buffer, @BufferSize);
    If (Res = 0) Then
      FCommonConnectionString := Trim(Buffer)
    Else
      Raise Exception.Create ('TMSSQLInstallationData.Create: Unable to retrieve Database Connection String - please contact your technical support');
  End // If (hICoreBtrvDll <> 0)
  Else
    Raise Exception.Create ('TMSSQLInstallationData.Create: Unable to load ICoreBtrv.Dll - please contact your technical support');
End; // Create

//------------------------------

Destructor TMSSQLInstallationData.Destroy;
Begin // Destroy
  If (hICoreBtrvDll <> 0) Then
    FreeLibrary(hICoreBtrvDll);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TMSSQLInstallationData.GetDatabaseFileSizes (ADOQuery : TADOQuery);
Begin // GetDatabaseFileSizes
  ADOQuery.SQL.Text := 'Select Name, (size*8*1024) As SizeInBytes ' +
                         'From Sys.Database_Files ' +
                        'Where (Name = ''' + 'Exch600' + ''') Or (Name = ''' + 'Exch600' + '_log'')';

  ADOQuery.Open;
  Try
    If (ADOQuery.RecordCount > 0) Then
    Begin
      // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
      ADOQuery.First;
      While (Not ADOQuery.EOF) Do
      Begin
        // Extract index info and add into the additional detail list
        FAdditionalXML.Add ('<DatabaseFile Name="' + ADOQuery.FieldByName('NAME').AsString +
                                         '" SizeMB="' + IntToStr(ToMB(ADOQuery.FieldByName('SizeInBytes').Value)) + '" />');
        ADOQuery.Next;
      End; // While (Not ADOQuery.EOF)
    End; // If (ADOQuery.RecordCount = 1)
  Finally
    ADOQuery.Close;
  End; // Try..Finally
End; // GetDatabaseFileSizes

//-------------------------------------------------------------------------

Procedure TMSSQLInstallationData.ScanInstallation;
Var
  CommonADOConnection : TExchConnection;  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  CommonADOQuery, CompanyADOQuery : TADOQuery;
  oCompanyInfo : TCompanyInfo;
  oDataFile : TSQLGenericDataFile;
  iDataFile : IExchequerDataFileInfo;
  I : TExchequerDataFiles;
Begin // ScanInstallation
  CommonADOConnection := TExchConnection.Create(nil);  //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  Try
    CommonADOConnection.ConnectionString := FCommonConnectionString;
    CommonADOConnection.Open;
    If (CommonADOConnection.Errors.Count > 0) Then
    Begin
      Raise Exception.Create ('TMSSQLInstallationData.ScanInstallation: Failed to create Common ADO Connection');
    End; // If (CommonADOConnection.Errors.Count > 0)

    //------------------------------

    CommonADOQuery := TADOQuery.Create(NIL);
    Try
      CommonADOQuery.Connection := CommonADOConnection;

      //------------------------------

      // SQL Edition - Return total size of database and log files
      GetDatabaseFileSizes (CommonADOQuery);

      //------------------------------

      // Scan Common Tables / Root Company Only
      For I := Low(TExchequerDataFiles) To High(TExchequerDataFiles) Do
      Begin
        // Get interface containing file details
        iDataFile := ExchequerDataFiles(I);
        Try
          // Check it is a common table or root company only data file
          If iDataFile.dfiCommon Then
          Begin
            oDataFile := CreateDataFile (iDataFile, 'Common');

            //working here - need to code scanning of file
            oDataFile.AnalyseDataFile (CommonADOQuery);

            // add data file object into FCommonData object
            FCommonData.Add (oDataFile);
          End; // If iDataFile.dfiCommon

          Application.ProcessMessages;
        Finally
          // Remove reference to interface
          iDataFile := NIL;
        End; // Try..Finally
      End; // For I

      //------------------------------

      // Get a list of companies so we can scan per company tables
      CommonADOQuery.SQL.Text := 'Select CAST(SUBSTRING(CompanyCode1, 2, 6) As VarChar(6)) As CompCode, ' +
                                        'Company_code2 As CompName, ' +
                                        'CAST(SubString(Company_code3, 2, 80) As VarChar(80)) As CompPath ' +
                                   'From Common.COMPANY ' +
                                  'Where (RecPfix = ''C'')';
      CommonADOQuery.Open;
      Try
        If (CommonADOQuery.RecordCount > 0) Then
        Begin
          // Note: Must use First/Next instead of FindFirst/FindNext as EOF doesn't work with the Findxxx functions
          CommonADOQuery.First;
          While (Not CommonADOQuery.EOF) Do
          Begin
            // Extract company details and create a parent company object
            oCompanyInfo := TCompanyInfo.Create (CommonADOQuery.FieldByName('CompCode').AsString,
                                                 CommonADOQuery.FieldByName('CompName').AsString,
                                                 CommonADOQuery.FieldByName('CompPath').AsString);

            // Create a new query for use with the company
            CompanyADOQuery := TADOQuery.Create(NIL);
            Try
              CompanyADOQuery.Connection := CommonADOConnection;

              //------------------------------

              // Scan Per Company Tables / Files only
              For I := Low(TExchequerDataFiles) To High(TExchequerDataFiles) Do
              Begin
                // Get interface containing file details
                iDataFile := ExchequerDataFiles(I);
                Try
                  // Check it is a common table or root company only data file
                  If (Not iDataFile.dfiCommon) Then
                  Begin
                    oDataFile := CreateDataFile (iDataFile, oCompanyInfo.coCode);

{ TODO : Need to suppress files for modules not installed????? }

                      // Open Btrieve file and get statistics
                      oDataFile.AnalyseDataFile (CompanyADOQuery);

//                      // If Toolkit opened OK then perform a detailed analysis of the data
//                      If (Res = 0) Then
//                        TPervasiveGenericDataFile(oDataFile).AnalyseFileContents (oToolkit);

                    // add data file object into FCommonData object
                    oCompanyInfo.Add (oDataFile);
                  End; // If iDataFile.dfiCommon

                  Application.ProcessMessages;
                Finally
                  // Remove reference to interface
                  iDataFile := NIL;
                End; // Try..Finally
              End; // For I

              //------------------------------

            Finally
              CompanyADOQuery.Connection := Nil;
              FreeAndNIL(CompanyADOQuery);
            End; // Try..Finally

            // Register the file size against the drive
            oSurveyInfo.RegisterDrive(ExtractFileDrive(Trim(oCompanyInfo.coPath)), 0);

            // Add company info object into FCompanies list
            FCompanies.Add(oCompanyInfo);

            CommonADOQuery.Next;
          End; // While (Not CommonADOQuery.EOF)
        End; // If (CommonADOQuery.RecordCount > 0)
      Finally
        CommonADOQuery.Close;
      End; // Try..Finally
    Finally
      CommonADOQuery.Connection := Nil;
      CommonADOQuery.Free;
    End; // Try..Finally
  Finally
    If CommonADOConnection.Connected Then
      CommonADOConnection.Close;
    FreeAndNIL(CommonADOConnection);
  End; // Try..Finally
End; // ScanInstallation

//=========================================================================

End.
