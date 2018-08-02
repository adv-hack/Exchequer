unit LoadCompanies;

interface

Uses oConvertOptions;

Function LoadCompaniesList (Const ExchDir : ShortString; Const ConversionOptions : IConversionOptions) : LongInt; StdCall; Export;

implementation

Uses Dialogs, SysUtils, Windows, oBtrieveOnlyFile, oCompanyDat, oDataConversionTask;

//=========================================================================

// Return Values:-
//
//   0       AOK
//   1000    Unknown Exception
//   10000+  Error opening Company.Dat
Function LoadCompaniesList (Const ExchDir : ShortString; Const ConversionOptions : IConversionOptions) : LongInt;
Var
  oCompanyFile : TCompanyFile;
  lStatus : LongInt;
  sCompanyDir : ShortString;
Begin // LoadCompaniesList
  Result := 0;
  Try
    // Open Company.Dat and load the company details into the ConversionOptions object (interface)
    oCompanyFile := TCompanyFile.Create;
    Try
      lStatus := oCompanyFile.OpenFile (ExchDir + 'COMPANY.DAT', False, v600Owner);
      If (lStatus = 0) Then
      Begin
        lStatus := oCompanyFile.GetGreaterThanOrEqual(cmCompDet);
        While (Result = 0) And (lStatus = 0) And (oCompanyFile.Company^.RecPFix = cmCompDet) Do
        Begin
          With oCompanyFile.Company^.CompDet Do
          Begin
            sCompanyDir := IncludeTrailingPathDelimiter(Trim(oCompanyFile.Company^.CompDet.CompPath));
            If DirectoryExists(sCompanyDir) And FileExists(sCompanyDir + 'Company.Sys') And
               FileExists (sCompanyDir + 'Exchqss.Dat') Then
            Begin
              ConversionOptions.AddCompany(CompCode, Trim(CompName), sCompanyDir);
            End; // If DirectoryExists(sCompanyDir) And ...
          End; // With oCompanyFile.Company^.CompDet

          lStatus := oCompanyFile.GetNext;
        End; // While (lStatus = 0)

        oCompanyFile.CloseFile;
      End // If (lStatus = 0)
      Else
        Result := 10000 + lStatus;
    Finally
      FreeAndNIL(oCompanyFile);
    End; // Try..Finally
  Except
    On E:Exception Do
      Result := 1000;
  End; // Try..Except
End; // LoadCompaniesList

//=========================================================================

end.
