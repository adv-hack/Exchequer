unit ChkComp;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

Uses Classes, Dialogs, FileCtrl, Forms, SysUtils, Windows, GlobVar, VarConst;

// Analyses the company data set and sets CompAnal to a status code
Procedure CheckCompanyDir (Var CompDets : CompanyDetRec);

// Returns an error string describing an error returned by CheckCompanyDir
Function GetCompDirError (Const ErrNo : SmallInt) : ShortString;

implementation

Uses BtrvU2, {BTSupU1, }LicRec, EntLic, LicFuncU, ConvData, oExchqSS,
  oBtrieveFile;

Var
  EntLicR : ^EntLicenceRecType;

//----------------------------------------------------------

// Loads the Enterprise licence into a local var for use when checking the company data sets
Procedure LoadEntLic;
Begin { LoadEntLic }
  If (Not Assigned(EntLicR)) Then Begin
    // Allocate Memory for licence record
    New (EntLicR);

    // Load enterprise Licence into pointer
    ReadEntLic (EntLicFName, EntLicR^);
  End; { If (Not Assigned(EntLicR)) }
End; { LoadEntLic }

//----------------------------------------------------------

// Analyses the company data set and sets CompAnal to a status code:-
//
//  1      AOK
//  101    Directory Doesn't Exist
//  102    Company Data Set incomplete
//  103    Invalid Currency Version
//  104    ESN different from SyssCompany^
//  105    Incorrect Company Id
//  106    Error opening Exchqss.Dat
//  107    Invalid Data Type
Procedure CheckCompanyDir (Var CompDets : CompanyDetRec);
Var
  lCompPath : ShortString;
  oExchqSSFile : TExchqSSFile;
  lRes         : LongInt;
  sKey         : ShortString;
Begin { CheckCompanyDir }
  With CompDets Do Begin
    CompAnal := 1;  // AOK
    //Exit;
    CompDemoSys := False;

    lCompPath := IncludeTrailingBackslash(Trim(CompPath));

    // Check Directory
    If DirectoryExists (lCompPath) Then Begin
      // Check for a valid data set
      If IsValidCompany (lCompPath) Then Begin
        // Load Licence so Currency version can be checked }
        LoadEntLic;

        // Set Demo/Reseller flag
        CompDemoSys := (EntLicR^.licLicType = 1);

        If (EntLicR^.licEntCVer = 0) Then Begin
          // Single Currency - Professional
          If (Not FileExists (lCompPath + 'DEFPF044.SYS')) Then
            CompAnal := 103;
        End { If (EntLicR^.licEntCVer = 0) }
        Else
          // Multi-Currency - Euro or Global
          If (Not FileExists (lCompPath + 'DEFMC044.SYS')) Then
            CompAnal := 103;

        If (CompAnal = 1) Then
        Begin
          // AOK so far - check ESN in ExchQss.Dat against that in Company.Dat

          // MH 02/11/07: Rewrote to use Client Id's in order to workaround problems under SQL
          oExchqSSFile := TExchqSSFile.Create;
          Try
            lRes := oExchqSSFile.OpenFile (lCompPath + FileNames[SysF], False);
            If (lRes = 0) Then
            Begin
              // Get SysR
              sKey := SysNames[SysR];
              lRes := oExchqSSFile.GetEqual(sKey);
              If (lRes = 0) Then
              Begin
                Move (oExchqSSFile.RecordPointer^, Syss, SizeOf(Syss));

                // Record ESN for later use
                CompSysESN := Syss.ExISN;
                CompUCount := Syss.EntULogCount;

                // Check ESN
                If licMatchingESN(ESNByteArrayType(Syss.ExISN), ESNByteArrayType(SyssCompany^.CompOpt.optSystemESN)) Then
                Begin
                  // OK - Get ModRR and Check Company Id
                  sKey := SysNames[ModRR];
                  lRes := oExchqSSFile.GetEqual(sKey);
                  If (lRes = 0) Then
                  Begin
                    Move (oExchqSSFile.RecordPointer^, SyssMod^, SizeOf(SyssMod^));

                    // Record CompanyId for later use
                    CompModId     := SyssMod^.ModuleRel.CompanyID;
                    CompModSynch  := SyssMod^.ModuleRel.CompanySynch;
                    CompTKUCount  := SyssMod^.ModuleRel.TKLogUCount;
                    CompTrdUCount := SyssMod^.ModuleRel.TrdLogUCount;

                    // OK - Check Company Id
                    If (CompId = SyssMod^.ModuleRel.CompanyID) Then
                    Begin
                      If (CompDemoData = (SyssMod^.ModuleRel.CompanyDataType = 1)) Then
                        CompAnal := 1 // AOK
                      Else
                        CompAnal := 107;  // Invalid Data Type
                    End // If (CompId = SyssMod^.ModuleRel.CompanyID)
                    Else
                      CompAnal := 105;
                  End // If (lRes = 0)
                  Else
                    CompAnal := 106;
                End { If }
                Else
                  // Invalid ESN
                  CompAnal := 104;
              End { If GetMultiSys }
              Else
                CompAnal := 106;
            End // If (lRes = 0)
            Else
              CompAnal := 106;
          Finally
            oExchqSSFile.Free;
          End; // Try..Finally
        End; { If (CompAnal = 1) }
      End { If IsValidCompany }
      Else
        // Incomplete set of data files
        CompAnal := 102;
    End { If DirectoryExists (lCompPath) }
    Else
      // Invalid Drive or Directory
      CompAnal := 101;
  End; { With CompDets Do Begin}
End; { CheckCompanyDir }

//----------------------------------------------------------

// Returns an error string describing an error returned by CheckCompanyDir
Function GetCompDirError (Const ErrNo : SmallInt) : ShortString;
Begin { GetCompDirError }
  Case ErrNo Of
    101 : Result := 'Invalid Directory';
    102 : Result := 'Incomplete Company Data Set';
    103 : Result := 'Wrong Currency Version';
    104 : Result := 'Invalid Company ESN';
    105 : Result := 'Invalid Company Id';
    106 : Result := 'Error accessing Company Setup Info';
    107 : Result := 'Invalid Company Data Type';
  Else
    Result := 'Unknown Error';
  End; { Case ErrNo }
End; { GetCompDirError }

//----------------------------------------------------------

Initialization
  EntLicR := NIL;
Finalization
  If Assigned(EntLicR) Then Begin
    Dispose(EntLicR);
    EntLicR := NIL;
  End; { If Assigned(EntLicR) }
end.
