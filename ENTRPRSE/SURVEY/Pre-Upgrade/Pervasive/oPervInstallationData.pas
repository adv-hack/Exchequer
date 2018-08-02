Unit oPervInstallationData;

Interface

Uses oBaseDataClasses, Classes, Forms, SysUtils;

Type
  TPervasiveInstallationData = Class(TInstallationData)
  Public
    Procedure ScanInstallation; Override;
  End; // TPervasiveInstallationData

Implementation

Uses COMObj, Dialogs, oSurveyStore, DataFileInfo, oPervDataFile, Enterprise01_TLB, CTKUtil;

//=========================================================================

Procedure TPervasiveInstallationData.ScanInstallation;
Var
  oToolkit : IToolkit;
  oDataFile : TPervasiveGenericDataFile;
  iDataFile : IExchequerDataFileInfo;
  oCompanyInfo : TCompanyInfo;
  I : TExchequerDataFiles;
  J, Res : Integer;
Begin // ScanInstallation
//ShowMessage ('TPervasiveInstallationData.ScanInstallation: ' + oSurveyInfo.EntPath);

  // Scan Common Tables / Root Company Only
  For I := Low(TExchequerDataFiles) To High(TExchequerDataFiles) Do
  Begin
    // Get interface containing file details
    iDataFile := ExchequerDataFiles(I);
    Try
      // Check it is a common table or root company only data file
      If iDataFile.dfiCommon Then
      Begin
        oDataFile := CreateDataFile (iDataFile);

        //working here - need to code scanning of file
        oDataFile.AnalyseDataFile (oSurveyInfo.EntPath);

        // add data file object into FCommonData object
        FCommonData.Add (oDataFile);
      End; // If iDataFile.dfiCommon

      Application.ProcessMessages;
    Finally
      // Remove reference to interface
      iDataFile := NIL;
    End; // Try..Finally
  End; // For I

  oSurveyInfo.RegisterDrive(ExtractFileDrive(oSurveyInfo.EntPath), FCommonData.TotalSize);

  // Open Company.Dat and scan each company dataset
  // MH 02/01/2013: Use backdoor otherwise get an error calling OpenCompany
  //oToolkit := CreateComObject(CLASS_Toolkit) as IToolkit;
  oToolkit := CreateToolkitWithBackdoor;
  Try
    With oToolkit.Company Do
    Begin
      For J := 1 to cmCount Do
      Begin
//ShowMessage (cmCompany[J].coCode + ' - ' + Trim(cmCompany[J].coName) + ' - ' + Trim(cmCompany[J].coPath));
        // Create a company object to store the company specific details
        oCompanyInfo := TCompanyInfo.Create (cmCompany[J].coCode, Trim(cmCompany[J].coName), Trim(cmCompany[J].coPath));

        // Open Company in COM Toolkit for detailed analysis
        oToolkit.Configuration.DataDirectory := Trim(cmCompany[J].coPath);
        Res := oToolkit.OpenToolkit;
        Try
          // Scan Per Company Tables / Files only
          For I := Low(TExchequerDataFiles) To High(TExchequerDataFiles) Do
          Begin
            // Get interface containing file details
            iDataFile := ExchequerDataFiles(I);
            Try
              // Check it is a common table or root company only data file
              If (Not iDataFile.dfiCommon) Then
              Begin
                oDataFile := CreateDataFile (iDataFile);

{ TODO : Need to suppress files for modules not installed????? }

                // Open Btrieve file and get statistics
                oDataFile.AnalyseDataFile (oCompanyInfo.coPath);

                // If Toolkit opened OK then perform a detailed analysis of the data
                If (Res = 0) Then
                  TPervasiveGenericDataFile(oDataFile).AnalyseFileContents (oToolkit);

                // add data file object into FCommonData object
                oCompanyInfo.Add (oDataFile);
              End; // If iDataFile.dfiCommon

              Application.ProcessMessages;
            Finally
              // Remove reference to interface
              iDataFile := NIL;
            End; // Try..Finally
          End; // For I

          // Register the file size against the drive
          oSurveyInfo.RegisterDrive(ExtractFileDrive(Trim(cmCompany[J].coPath)), oCompanyInfo.TotalSize);
        Finally
          oToolkit.CloseToolkit;
        End; // Try..Finally

        // Add company info object into FCompanies list
        FCompanies.Add(oCompanyInfo);
      End; // For J
    End; // With oToolkit.Company
  Finally
    oToolkit := NIL;
  End; // Try..Finally
End; // ScanInstallation

//=========================================================================

End.
