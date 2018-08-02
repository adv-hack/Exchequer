unit CheckPervasiveDir;

interface

Uses Dialogs, SysUtils, Windows, GlobVar, BtrvU2, oBtrieveOnlyFile, oCompanyDat, oGenericBtrieveFile;

// Checks the specified directory for a valid Exchequer v6.00 Pervasive
// Edition installation.
//
// Return Values:-
//
//   0     AOK
//   1     Not a valid Directory
//   2     Not a valid v6.00 Pervasive Edition
//   3     The Data is in use
//   255   Unknown Exception
//
Function CheckExch600PervasiveDir (Const ExchDir : ShortString) : Byte; StdCall; Export;


implementation

//=========================================================================

// Checks the specified directory for a valid Exchequer v6.00 Pervasive
// Edition installation.
//
// Return Values:-
//
//   0     AOK
//   1     Not a valid Directory
//   2     Not a valid v6.00 Pervasive Edition
//   3     The Data is in use
//   255   Unknown Exception
//
Function CheckExch600PervasiveDir (Const ExchDir : ShortString) : Byte;
Const
  Optional = True;
Var
  oCompanyFile : TCompanyFile;
  lStatus : LongInt;
  sCompanyDir : ShortString;

  //------------------------------

  // Return values:-
  //
  //   0   AOK
  //   1   File missing
  //   2   Not Exchequer Pervasive v6.00 format file
  //   3   In Use
  //
  Function TestFile (Const FilePath : ShortString; Const v6RecLen : LongInt; Const Optional : Boolean = False) : Byte;
  Var
    oTestFile : TGenericBtrieveFile;
    lStatus : LongInt;
  Begin // TestFile
    Result := 0;

    If FileExists(FilePath) Then
    Begin
      oTestFile := TGenericBtrieveFile.Create;
      Try
        // Open normally
        lStatus := oTestFile.OpenFile (FilePath, False, v600Owner, -4);
        If (lStatus = 0) Then
        Begin
          If (oTestFile.GetRecordLength <> v6RecLen) Then
            Result := 2; // Not a valid v6.00 Pervasive Edition

          oTestFile.CloseFile;
        End // If (lStatus = 0)
        Else
        Begin
          If (lStatus = 51) Then
            Result := 2  // Not Exchequer v6.00 format file
          Else
            Result := 3; // In Use
        End; // Else

        If (Result = 3) Then
          MessageDlg ('The following data file is in use - ' + FilePath + ', all applications, ' +
                      'utilities and services using the Exchequer Database must be closed before ' +
                      'the conversion can be run', mtError, [mbOK, mbHelp], 203);
      Finally
        FreeAndNIL(oTestFile);
      End; // Try..Finally
    End // If FileExists(FilePath)
    Else
      If (Not Optional) Then
        Result := 1; // Not a valid Exchequer directory
  End; // TestFile

  //------------------------------

Begin // CheckExch600PervasiveDir
  If DirectoryExists(ExchDir) Then
  Begin
    If FileExists (ExchDir + 'Enter1.Exe') And
       FileExists (ExchDir + 'Excheqr.Sys') And
       FileExists (ExchDir + 'COMPANY.DAT') And
       FileExists (ExchDir + 'ENTRPRSE.DAT') And
       FileExists (ExchDir + 'EXCHQSS.DAT') And
       FileExists (ExchDir + 'CUST\CUSTSUPP.DAT') And
       FileExists (ExchDir + 'TRANS\DOCUMENT.DAT') Then
    Begin
      // Open various files to check they our Exchequer v6.00 Pervasive Edition and not an
      // earlier version and that they are not in use
                           Result := TestFile (ExchDir + 'COMPANY.DAT', 1536);
      If (Result = 0) Then Result := TestFile (ExchDir + 'EBUS.DAT', 944, Optional);
      If (Result = 0) Then Result := TestFile (ExchDir + 'SCHEDCFG.DAT', 640);
      If (Result = 0) Then Result := TestFile (ExchDir + 'SENTSYS.DAT', 1635, Optional);
      If (Result = 0) Then Result := TestFile (ExchDir + 'FAXSRV\FAXES.DAT', 980, Optional);
      If (Result = 0) Then Result := TestFile (ExchDir + 'REPORTS\DICTNARY.DAT', 256);
      If (Result = 0) Then Result := TestFile (ExchDir + 'TRADE\TILLNAME.DAT', 4097, Optional);

      //------------------------------

      If (Result = 0) Then
      Begin
        // Open Company.Dat and run through all the companies checking files for usage
        oCompanyFile := TCompanyFile.Create;
        Try
          lStatus := oCompanyFile.OpenFile (ExchDir + 'COMPANY.DAT', False, v600Owner, -4);
          If (lStatus = 0) Then
          Begin
            lStatus := oCompanyFile.GetGreaterThanOrEqual(cmCompDet);
            While (Result = 0) And (lStatus = 0) And (oCompanyFile.Company^.RecPFix = cmCompDet) Do
            Begin
              sCompanyDir := IncludeTrailingPathDelimiter(Trim(oCompanyFile.Company^.CompDet.CompPath));
              If DirectoryExists(sCompanyDir) And FileExists(sCompanyDir + 'Company.Sys') Then
              Begin
                // Open various files to check they our Exchequer v6.00 Pervasive Edition and not an
                // earlier version and that they are not in use
                                     Result := TestFile (ExchDir + 'EXCHQSS.DAT', 1787);
                If (Result = 0) Then Result := TestFile (ExchDir + 'CUST\CUSTSUPP.DAT', 2119);
                If (Result = 0) Then Result := TestFile (ExchDir + 'MISC\SETTINGS.DAT', 795);
                If (Result = 0) Then Result := TestFile (ExchDir + 'SMAIL\SENT.DAT', 1634, Optional);
                If (Result = 0) Then Result := TestFile (ExchDir + 'TRADE\LBIN.DAT', 454, Optional);
                If (Result = 0) Then Result := TestFile (ExchDir + 'SCHEDULE\SCHEDULE.DAT', 758, Optional);
              End; // If DirectoryExists(sCompanyDir)

              If (Result = 0) Then
                lStatus := oCompanyFile.GetNext;
            End; // While (lStatus = 0)

            oCompanyFile.CloseFile;
          End // If (lStatus = 0)
          Else
            Result := 3; // The Data is in use
        Finally
          FreeAndNIL(oCompanyFile);
        End; // Try..Finally
      End; // If (Result = 0)
    End // If FileExists (TestDir + 'Enter1.Exe') And ...
    Else
      Result := 2; // Not a valid v6.00 Pervasive Edition
  End // If DirectoryExists(ExchDir)
  Else
    Result := 1; // Not a valid directory
End; // CheckExch600PervasiveDir



end.
