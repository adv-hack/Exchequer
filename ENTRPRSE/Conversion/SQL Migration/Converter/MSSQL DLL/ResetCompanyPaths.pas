unit ResetCompanyPaths;

interface

Uses oConvertOptions;

// Updates the Company Path's imported from Pervasive to the new SQL database
Function ResetMCMPaths (Const ConversionOptions : IConversionOptions) : Boolean; StdCall; Export;

Var
  iCompany : IConversionCompany;

implementation

Uses Classes, Dialogs, SysUtils, SQLUtils, oBtrieveFile, oCompanyDat;

//=========================================================================

// Updates the Company Path's imported from Pervasive to the new SQL database
Function ResetMCMPaths (Const ConversionOptions : IConversionOptions) : Boolean;
Var
  oCompanyFile : TCompanyFile;
  RecPos, lStatus, iCompanyIdx : LongInt;
Begin // ResetMCMPaths
  Result := True;

  oCompanyFile := TCompanyFile.Create;
  Try
    // Need to bypass the OpenCompany call as the MCM paths are currently wrong and we are accessing a commmon file anyway
    oCompanyFile.BypassOpenCompany := True;

    lStatus := oCompanyFile.OpenFile (ConversionOptions.coSQLDirectory + 'COMPANY.DAT', False, v600Owner);
    If (lStatus = 0) Then
    Begin
      lStatus := oCompanyFile.GetGreaterThanOrEqual(cmCompDet);
      While Result And (lStatus = 0) And (oCompanyFile.Company^.RecPFix = cmCompDet) Do
      Begin
        // find path in conversion options for this company and update company table
        iCompanyIdx := ConversionOptions.IndexOf(oCompanyFile.Company^.CompDet.CompCode);
        If (iCompanyIdx >= 0) Then
        Begin
          // Update path - needs to be in Short Filename format and padded with spaces

          // MH 19/11/2008: Create directory if missing as ExtractShortPathName will fail otherwise
          If (Not DirectoryExists(ConversionOptions.coCompanies[iCompanyIdx].ccSQLCompanyPath)) Then
            ForceDirectories(ConversionOptions.coCompanies[iCompanyIdx].ccSQLCompanyPath);

//ShowMessage ('CompCode: ' + oCompanyFile.Company^.CompDet.CompCode + #13 +
//             'CurrentPath: ' + oCompanyFile.Company^.CompDet.CompPath + #13 +
//             'New Path: ' + ExtractShortPathName(ConversionOptions.coCompanies[iCompanyIdx].ccSQLCompanyPath));

          // MH 17/09/2009: Modified setting of Company Path as due to FullCompPath (BTKeys1U) using Eduardo's
          //                UpcaseStr function the path is being chopped off at 80 chars instead of the 100 chars
          //                we thought it supported.
          //oCompanyFile.Company^.CompDet.CompPath := ExtractShortPathName(ConversionOptions.coCompanies[iCompanyIdx].ccSQLCompanyPath) + StringOfChar(' ', SizeOf(oCompanyFile.Company^.CompDet.CompPath)-1);
          oCompanyFile.Company^.CompDet.CompPath := Copy(ExtractShortPathName(ConversionOptions.coCompanies[iCompanyIdx].ccSQLCompanyPath) + StringOfChar(' ', SizeOf(oCompanyFile.Company^.CompDet.CompPath)-1), 1, 80);
          lStatus := oCompanyFile.Update;
          If (lStatus <> 0) Then
          Begin
            MessageDlg ('ResetMCMPaths - An error ' + IntToStr(lStatus) + ' occurred whilst updating the company path for Company ' + Trim(oCompanyFile.Company^.CompDet.CompCode),
                        mtError, [mbOK], 0);
            Result := False;
          End; // If (lStatus <> 0)
        End // If (iCompanyIdx >= 0)
        Else
        Begin
          MessageDlg ('ResetMCMPaths - Company Details Not Found for Company ' + Trim(oCompanyFile.Company^.CompDet.CompCode),
                      mtError, [mbOK], 0);
          Result := False;
        End; // Else

        If Result Then
          lStatus := oCompanyFile.GetNext;
      End; // While Result And (lStatus = 0) And (oCompanyFile.Company^.RecPFix = cmCompDet)

      oCompanyFile.CloseFile;
    End // If (lStatus = 0)
    Else
    Begin
      MessageDlg ('ResetMCMPaths - An error ' + IntToStr(lStatus) + 'occurred whilst opening the Company Table',
                  mtError, [mbOK], 0);
      Result := False;
    End; // Else
  Finally
    FreeAndNIL(oCompanyFile);
  End; // Try..Finally
End; // ResetMCMPaths

//=========================================================================

end.
