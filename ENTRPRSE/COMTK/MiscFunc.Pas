unit MiscFunc;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils, Windows,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF};

Const
  // This array cross-references the TLB Document Type constants with the
  // Enterprise DocTypes constants.  -1 indicates that the COM Toolkit does
  // not support the transaction type
  TKDocTypeVal : Array[DocTypes] of SmallInt =
               //  SIN,   SRC,   SCR,   SJI    SJC,   SRF,   SRI,   SQU,
                  (dtSIN, dtSRC, dtSCR, dtSJI, dtSJC, dtSRF, dtSRI, dtSQU,
               //  SOR    SDN,   SBT    SDG    NDG    OVT    DEB    PIN,
                   dtSOR, dtSDN, dtSBT, -1,    -1,    -1,    -1,    dtPIN,
               // PPY     PCR    PJI    PJC    PRF    PPI    PQU,   POR,
                  dtPPY,  dtPCR, dtPJI, dtPJC, dtPRF, dtPPI, dtPQU, dtPOR,
               // PDN,    PBT,   SDT,   NDT,   IVT,   CRE,   NOM,   RUN,
                  dtPDN,  dtPBT, -1,    -1,    -1,    -1,    dtNMT, -1,
               // FOL,    AFL,   ADC,   ADJ,   ACQ,   API,   SKF,   JBF,
                  -1,     -1,    -1,    dtADJ, -1,    -1,     -1,    -1,
               // WOR,    TSH,   JRN,   WIN,   SRN,   PRN
                  dtWOR,  dtTSH, -1,    -1,    dtSRN, dtPRN,
               // JCT,    JST,   JPT,   JSA,   JPA
                  dtJCT,  dtJST, dtJPT, dtJSA, dtJPA
                  );

Type
  //PR: 19/08/2011 Added EToolkitException class to allow information about validation exceptions to be
  //passed back to the user under .NET applications. All validation exceptions we raise internally will
  //be descendants. The AfterConstruction procedure will put the exception message into the 
  //LastErrorString property of the Toolkit. ABSEXCH-11317
  EToolkitException = Class(Exception)
    procedure AfterConstruction; override;
  end;


  // Miscellaneous Validation Error
  EInvalidMethod = Class(EToolkitException);
  EInvalidProperty = Class(EToolkitException);
  EInvalidIndex = Class(EToolkitException);
  EUnknownValue = Class(EToolkitException);
  EValidation = Class(EToolkitException);
  EMaximumSize = Class(EToolkitException);
  EPrintError = Class(EToolkitException);
  ENotSupported = Class(EToolkitException);
  EInvalidUpdate = Class(EToolkitException);

  TInterfaceMode = (imGeneral, imAdd, imUpdate, imClone, imCopy, imUpdateEx, imUpdateEx2, imMasterTerms, imAV);

// Extracts a single character from a COM WideString, Returns specified character if ''
Function ExtractChar(Const Value : WideString; Const ReturnChar : Char) : Char;

// Validates and Returns a Currency Number - raises exception if invalid
Function ValidateCurrencyNo (Const CcyNo : Integer) : Integer;


// Converts an Toolkit DocType String to an Enterprise DocTypes value
Function TKDocTypeToEntDocType (TKDocType : ShortString) : DocTypes;

// Converts an Toolkit DocType String to an TLB DocType constant
Function TKDocTypeToTLBDocType (TKDocType : ShortString) : TDocTypes;

// Converts an Type Library DocType constant into a Toolkit DocType string
Function TLBDocTypeToTKDocType (Const TLBDocType : TDocTypes) : ShortString;

// Validates the specified path as an Enterprise data directory
Function ValidateDataDirectory (Var DataPath : String; Var ErrStr : ShortString) : Boolean;

// Validates the specified path as an Enterprise System directory
Function ValidateEnterpriseDirectory (Var DataPath, ErrStr : ShortString) : Boolean;

// Converts an Enterprise directory into a path to Company.Dat taking into
// account any local program files configuration
Function EntDirToCompDir (EntDir : ShortString) : ShortString;

//Functions to validate year and period
function ValidateYear(AYear : SmallInt) : Byte;
function ValidatePeriod(APeriod : SmallInt) : Byte;



implementation


Uses FileCtrl, VarCnst3,
{$IFDEF EXSQL}
{ ** Amendments for SQL ****************************************************** }
SQLUtils,
{ **************************************************************************** }
{$ENDIF}
oSetup;

Const
  {$I FilePath.Inc}

{-----------------------------------------------------------------------------}

// Extracts a single character from a COM WideString, Returns specified character if ''
Function ExtractChar(Const Value : WideString; Const ReturnChar : Char) : Char;
Var
  S : String[1];
Begin { ExtractChar }
  S := Copy (Value, 1, 1) + ReturnChar;
  Result := S[1];
End; { ExtractChar }

{-----------------------------------------------------------------------------}

// Validates and Returns a Currency Number - raises exception if invalid
Function ValidateCurrencyNo (Const CcyNo : Integer) : Integer;
Var
  MaxCcy : Byte;
Begin { ValidateCurrencyNo }
  If ExSyss.MCMode Then Begin
    // Multi Currency - Euro/Global

    // Check Multi-Currency release code to distinguish Euro from Global
    If (CalcRelCode (1) <> rcDisabled) Then
      MaxCcy := CurrencyType
    Else
      MaxCcy := 2;

    If (CcyNo >= 0) And (CcyNo <= MaxCcy) Then
      Result := CcyNo
    Else
      Raise EValidation.Create ('Invalid Currency Number (' + IntToStr(CcyNo) + ')');
  End { If ExSyss.MCMode }
  Else Begin
    // Single Currency - Professional
    If (CcyNo = 0) Then
      Result := CcyNo
    Else
      Raise EValidation.Create ('Invalid Currency Number (' + IntToStr(CcyNo) + ')');
  End; { Else }
End; { ValidateCurrencyNo }

{-----------------------------------------------------------------------------}

// Converts an Toolkit DocType String to an Enterprise DocTypes value
Function TKDocTypeToEntDocType (TKDocType : ShortString) : DocTypes;
Var
  Found : Boolean;
  I     : DocTypes;
Begin { TKDocTypeToEntDocType }
  Result := SIN;
  Found := False;

  // Convert to uppercase, etc... to give comparison best chance
  TKDocType := UpperCase(Trim(TKDocType));

  // Run through Enterprise DocCodes list looking for matching code
  For I := Low(DocCodes) To High(DocCodes) Do
    If (DocCodes[I] = TKDocType) Then Begin
      // Return Enterprise DocType
      Result := I;
      Found := True;
      Break;
    End; { If (DocCodes[I] = TKDocType) }

  If (Not Found) Then
    // No TLB Code found
    Raise EUnknownValue.Create ('Invalid Document Type (' + TKDocType + ')');
End; { TKDocTypeToEntDocType }

// Converts an Toolkit DocType String to an TLB DocType constant
Function TKDocTypeToTLBDocType (TKDocType : ShortString) : TDocTypes;
{Var
  I : DocTypes;}
Begin { TKDocTypeToTLBDocType }
  (*
  Result := -1;

  // Convert to uppercase, etc... to give comparison best chance
  TKDocType := UpperCase(Trim(TKDocType));

  // Run through Enterprise DocCodes list looking for matching code
  For I := Low(DocCodes) To High(DocCodes) Do
    If (DocCodes[I] = TKDocType) Then Begin
      // Return TLB equivalent of Enterprise DocType
      Result := TKDocTypeVal[I];
      Break;
    End; { If (DocCodes[I] = TKDocType) }

  If (Result = -1) Then
    // No TLB Code found
    Raise EUnknownValue.Create ('Invalid Document Type (' + TKDocType + ')');
  *)
  Result := TKDocTypeVal[TKDocTypeToEntDocType (TKDocType)];
End; { TKDocTypeToTLBDocType }

// Converts an Type Library DocType constant into a Toolkit DocType string
Function TLBDocTypeToTKDocType (Const TLBDocType : TDocTypes) : ShortString;
Var
  I : DocTypes;
Begin { TLBDocTypeToTKDocType }
  Result := '';

  // Run through Enterprise DocCodes list looking for matching TLB DocType
  For I := Low(TKDocTypeVal) To High(TKDocTypeVal) Do
    If (LongWord(TKDocTypeVal[I]) = TLBDocType) Then Begin
      Result := DocCodes[I];
      Break;
    End; { If (TKDocTypeVal[I] = TLBDocType) }

  If (Result = '') Then
    // No TLB Code found
    Raise EUnknownValue.Create ('Invalid Document Type (' + IntToStr(Ord(TLBDocType)) + ')');
End; { TLBDocTypeToTKDocType }

{-----------------------------------------------------------------------------}

// Validates the specified path as an Enterprise data directory
Function ValidateDataDirectory (Var DataPath : String; Var ErrStr : ShortString) : Boolean;
Var
  OrigPath : String;
  // MH 04/06/2015 v7.0.14 ABSEXCH-16490: Added UNC Path support to COM Toolkit / Forms Toolkit
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
    // MH 04/06/2015 v7.0.14 ABSEXCH-16490: Added UNC Path support to COM Toolkit / Forms Toolkit
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
                // ExchQss.Dat + ExchQNum.Dat
{$IFDEF EXSQL}
      Result := SQLUtils.ValidCompany(DataPath);
{$ELSE}
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

// Converts an Enterprise directory into a path to Company.Dat taking into
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

// Validates the specified path as an Enterprise System directory
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
  Result := FileExists(DataPath + 'Entrprse.Exe') And   // Entrprse.Exe - Enterprise Splash Screen
            FileExists(DataPath + 'EntComp.Dll') And    // EntComp.Dll - Multi-Company Manager
            FileExists(DataPath + 'Enter1.Exe') And     // Enter1.Exe - Enterprise
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

(*
  If Result Then Begin
    // Check to see if a kosher Ent dir or a local program files
    If FileExists (DataPath + 'EntWRepl.Ini') Then Begin
      // Workstation Replication file - Check configuration

ShowMessage ('Local Program Files');

    End; { If FileExists (DataPath + 'EntWRepl.Ini') }
*)

(*
  // Check its a valid data directory first
  Result := ValidateDataDirectory (DataPath, ErrStr);
  If Result Then Begin
    // Its an OK Data directory - check for main Company data files
              // Company.Dat - Multi-Company Manager database
    Result := FileExists(DataPath + MultCompNam) And
              // Entrprse.Dat - Enterprise Licence File
              FileExists(DataPath + 'Entrprse.Dat');

    If Result Then Begin
      // Check for main Company program files
                // EntComp.Dll - Multi-Company Manager
      Result := FileExists(DataPath + 'EntComp.Dll') And
                // SbsForm.Dll - Form Designer Library
                FileExists(DataPath + 'SbsForm.Dll') And
                // Enter1.Exe - Enterprise
                FileExists(DataPath + 'Enter1.Exe');

      If (Not Result) Then
        ErrStr := QuotedStr(OrigPath) + ' does not contain a full set of program files';
    End { If Result }
    Else
      ErrStr := QuotedStr(OrigPath) + ' is not a valid Enterprise Main Company directory';
  End; { If ValidateDataDirectory (... }
*)
End; { ValidateEnterpriseDirectory }

{-----------------------------------------------------------------------------}

function ValidateYear(AYear : SmallInt) : Byte;
var
  TempYear : SmallInt;
begin
  TempYear := AYear;

  if TempYear > 1900 then
    TempYear := TempYear - 1900;

  if (TempYear >= 1) and (TempYear < 256) then
    Result := TempYear
  else
    raise EValidation.Create('Invalid Year (' + IntToStr(AYear) + ')');

end;

function ValidatePeriod(APeriod : SmallInt) : Byte;
begin
  if (APeriod > 0) and (APeriod <= Syss.PrinYr) and (APeriod < 256) then
    Result := APeriod
  else
    raise EValidation.Create('Invalid Period (' + IntToStr(APeriod) + ')');
end;



{ EToolkitException }
//PR: 19/08/2011 ABSEXCH-11317
procedure EToolkitException.AfterConstruction;
begin
  inherited;
  LastErDesc := Message;
end;

end.
