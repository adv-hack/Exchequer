unit MiscFunc;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils, Windows;


Type
  // Miscellaneous Validation Error
  EInvalidMethod = Class(Exception);
  EInvalidProperty = Class(Exception);
  EInvalidIndex = Class(Exception);
  EUnknownValue = Class(Exception);
  EValidation = Class(Exception);
  EMaximumSize = Class(Exception);
  EPrintError = Class(Exception);
  EInvalidForm = Class(Exception);
  ELicenceViolation = Class(Exception);

  TInterfaceMode = (imGeneral, imAdd, imUpdate, imClone);


// Validates the specified path as an Exchequer data directory
Function ValidateDataDirectory (Var DataPath, ErrStr : ShortString) : Boolean;

// Validates the specified path as an Exchequer System directory
Function ValidateEnterpriseDirectory (Var DataPath, ErrStr : ShortString) : Boolean;

// Converts an Exchequer directory into a path to Company.Dat taking into
// account any local program files configuration
Function EntDirToCompDir (EntDir : ShortString) : ShortString;


implementation


Uses FileCtrl
{$IFDEF EXSQL}
     , SQLUtils
{$ENDIF}
     {, GlobVar, VarConst};

Const
  {$I FilePath.Inc}

{-----------------------------------------------------------------------------}

// Validates the specified path as an Exchequer data directory
Function ValidateDataDirectory (Var DataPath, ErrStr : ShortString) : Boolean;
Var
  OrigPath : String;
  // MH 08/06/2015 v7.0.14 ABSEXCH-16490: Added UNC Path support to COM Toolkit / Forms Toolkit
  bIsUNC, bIsDrive : Boolean;
Begin { ValidateDataDirectory }
  ErrStr := '';

  // Strip off crap and make a copy for error messages
  //DataPath := UpperCase(Trim(DataPath));
  DataPath := IncludeTrailingBackslash(UpperCase(Trim(DataPath)));
  OrigPath := DataPath;

  // Check the directory is valid
  Result := DirectoryExists(DataPath);
  If Result Then
  Begin
    // MH 08/06/2015 v7.0.14 ABSEXCH-16490: Added UNC Path support to COM Toolkit / Forms Toolkit
    // Check whether it is a valid UNC Path
    bIsUNC := (Length(DataPath) > 3) And (Copy(DataPath, 1, 2) = '\\');

    // Check whether it is a valid ms-dos format drive and path
    bIsDrive := (Length(DataPath) > 3) And (DataPath[2] = ':');
    If bIsDrive Then
      // Convert to short file name MS-DOS form Drive and Path
      DataPath := ExtractShortPathName(DataPath);

    // OK if it is UNC or Mapped Drive, but not both
    Result := bIsUNC XOr bIsDrive;

    If Result Then
    Begin
      // AOK - Check for data files
{$IFDEF EXSQL}
      Result := SQLUtils.ValidCompany(DataPath);
{$ELSE}
                // ExchQss.Dat + ExchQNum.Dat
      Result := FileExists(DataPath + PathSys) And FileExists(DataPath + NumNam) And
                // Cust\CustSupp.Dat
                FileExists(DataPath + Path1 + CustName) And
                // Jobs\JOBCTRL.DAT + JOBDET.DAT + JOBHEAD.DAT + JOBMISC.DAT
                FileExists(DataPath + Path6 + JobCtrlNam) And
                FileExists(DataPath + Path6 + JobDetNam) And
                FileExists(DataPath + Path6 + JobRecNam) And
                FileExists(DataPath + Path6 + JobMiscNam) And
                // Misc\EXCHQCHK.Dat + EXSTKCHK.Dat
                FileExists(DataPath + Path3 + PassNam) And
                FileExists(DataPath + Path3 + MiscNam) And
                // Stock\MLOCSTK.Dat + STOCK.Dat
                FileExists(DataPath + Path4 + MLocName) And
                FileExists(DataPath + Path4 + StockNam) And
                // Trans\DETAILS.DAT + DOCUMENT.DAT + HISTORY.DAT + NOMINAL.DAT
                FileExists(DataPath + Path2 + DetailName) And
                FileExists(DataPath + Path2 + DocName) And
                FileExists(DataPath + Path2 + HistName) And
                FileExists(DataPath + Path2 + NomNam);
{$ENDIF}

      If Result Then Begin
        // Check for DEFPF044.SYS and DEFMC044.SYS
        Result := (FileExists (DataPath + 'DEFPF044.SYS') And (Not FileExists (DataPath + 'DEFMC044.SYS'))) Or
                  ((Not FileExists (DataPath + 'DEFPF044.SYS')) And FileExists (DataPath + 'DEFMC044.SYS'));

        If (Not Result) Then
          ErrStr := QuotedStr(OrigPath) + ' does not contain valid currency version files';
      End { If Result }
      Else
        ErrStr := QuotedStr(OrigPath) + ' does not contain a full set of company data';
    End { If Result }
    Else
      ErrStr := QuotedStr(OrigPath) + ' is not a valid path';
  End { If Result }
  Else
    ErrStr := QuotedStr(OrigPath) + ' is not a valid directory';
End; { ValidateDataDirectory }

{-----------------------------------------------------------------------------}

// Converts an Exchequer directory into a path to Company.Dat taking into
// account any local program files configuration
Function EntDirToCompDir (EntDir : ShortString) : ShortString;
Var
  WSNetDir : String;
Begin { EntDirToCompDir }
  EntDir := IncludeTrailingBackslash (EntDir);

  If FileExists(Entdir + 'EntWRepl.Ini') Then Begin
    // Check Replication Path is valid
    With TIniFile.Create (EntDir + 'ENTWREPL.INI') Do
      Try
        WSNetDir := ReadString ('UpdateEngine', 'NetworkDir', '');
        If (Length(WSNetDir) > 0) Then Begin
          WSNetDir := IncludeTrailingBackslash (WSNetDir);

          { Check the path is valid }
{$IFDEF EXSQL}
          if SQLUtils.ValidSystem(WSNetDir) then
{$ELSE}
          If DirectoryExists (WSNetDir) And FileExists (WSNetDir + 'COMPANY.DAT') And
             FileExists (WSNetDir + Path1 + CustName) And FileExists (WSNetDir + Path2 + DocName) Then
{$ENDIF}
            // Path in entWRepl.Ini is AOK
            Result := WSNetDir
          Else
            // Path in EntWRepl.Ini is invalid
            Raise Exception.Create (QuotedStr(EntDir) + ' has an invalid network path in EntWRepl.Ini');
        End { If (Length(WSNetDir) > 0) }
        Else
          // No path defined - path is already correct
          Result := EntDir;
      Finally
        Free;
      End;
  End { If }
  Else
    // No local program files - path is already correct
    Result := EntDir;
End; { EntDirToCompDir }

{-----------------------------------------------------------------------------}

// Validates the specified path as an Exchequer System directory
Function ValidateEnterpriseDirectory (Var DataPath, ErrStr : ShortString) : Boolean;
Var
  WSNetDir, OrigPath : ShortString;
Begin { ValidateEnterpriseDirectory }
  ErrStr := '';

  // Strip off crap and make a copy for error messages
  DataPath := IncludeTrailingBackslash(UpperCase(Trim(DataPath)));
  OrigPath := DataPath;

{$IFDEF EXSQL}
  Result := SQLUtils.ValidSystem(DataPath);
{$ELSE}
  // Check it has the required program files
  Result := FileExists(DataPath + 'Entrprse.Exe') And   // Entrprse.Exe - Exchequer Splash Screen
            FileExists(DataPath + 'EntComp.Dll') And    // EntComp.Dll - Multi-Company Manager
            FileExists(DataPath + 'Enter1.Exe') And     // Enter1.Exe - Exchequer
            FileExists(DataPath + 'SbsForm.Dll') And    // SbsForm.Dll - Form Designer Library
            FileExists(DataPath + 'BCFont32.Dll') And   // BCFont32.Dll - Barcode Font library
            FileExists(DataPath + 'BorlndMM.Dll') And   // BorlndMM - Delphi Memory Manager
           (FileExists(DataPath + 'Company.Dat') Or FileExists(DataPath + 'EntWRepl.Ini'));
{$ENDIF}
  If Result Then Begin
    If FileExists(DataPath + 'EntWRepl.Ini') Then Begin
      // Check Replication Path is valid
      With TIniFile.Create (DataPath + 'ENTWREPL.INI') Do
        Try
          WSNetDir := ReadString ('UpdateEngine', 'NetworkDir', '');
          If (Length(WSNetDir) > 0) Then Begin
            WSNetDir := IncludeTrailingBackslash (WSNetDir);

            { Check the path is valid }
{$IFDEF EXSQL}
            Result := SQLUtils.ValidSystem(WSNetDir);
{$ELSE}
            Result := DirectoryExists (WSNetDir) And
                      FileExists (WSNetDir + 'COMPANY.DAT') And
                      FileExists (WSNetDir + Path1 + CustName) And
                      FileExists (WSNetDir + Path2 + DocName);
{$ENDIF}
            If (Not Result) Then
              ErrStr := QuotedStr(OrigPath) + ' has an invalid network path in EntWRepl.Ini';
          End; { If (Length(WSNetDir) > 0) }
        Finally
          Free;
        End;
    End; { If FileExists(DataPath + 'EntWRepl.Ini') }
  End { If Result }
  Else
    ErrStr := QuotedStr(OrigPath) + ' does not contain a full set of program files';
End; { ValidateEnterpriseDirectory }

{-----------------------------------------------------------------------------}

end.
