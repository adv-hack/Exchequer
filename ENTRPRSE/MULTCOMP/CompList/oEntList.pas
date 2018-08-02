unit oEntList;

interface

Uses Classes, Dialogs, Forms, StdCtrls, SysUtils, Windows, GlobVar, VarRec2U,
     IniFiles, BtrvU2, LicRec;

Type
  TEntVersionType = (verUnknown, verPre430c, ver430c, ver431, ver432, ver500);

Const
  EntVersionString : Array [TEntVersionType] Of String =
                      ('Unknown',
                       'pre-v4.30c',
                       'v4.30c',
                       'v4.31',
                       'v4.32',
                       'v5.00');

  // Set of licenced versions
  EntLicenceSet = [ver430c, ver431, ver432, ver500];

Type
  TEntSurveyInfo = Class;

  TEntDataSet = Class(TObject)
  Private
    FSurvey       : TEntSurveyInfo;

    FCode         : ShortString;
    FCompanyName  : ShortString;
    FPath         : ShortString;

    FFileVersions : Array [0..99] Of Byte;
    function GetFileVersions(Index: Byte): Byte;
    procedure SetFileVersions(Index: Byte; const Value: Byte);
  Protected
  Public
    Property compCode : ShortString Read FCode;
    Property compName : ShortString Read FCompanyName;
    Property compPath : ShortString Read FPath;

    Property FileVersions[Index : Byte] : Byte Read GetFileVersions Write SetFileVersions;

    Constructor Create (Const Parent : TEntSurveyInfo; Const mcmCode, mcmCompany, mcmPath : ShortString);
    Destructor Destroy; Override;

    Procedure AnalyseDir;
    Procedure CheckBtrFiles;
    Function CheckSingleBtrFile (Const FilePath : ShortString; Const DetailList : TStringList) : Byte;
    Function IsValidCompany (CompPath : ShortString) : Boolean;
  End; { TEntDataSet }

  TEntSurveyInfo = Class(TObject)
  Private
    FDataSets : TList;
    FEntPath : ShortString;
    FESN : ISNArrayType;
    FSurveyResults : TStringList;
    FWarningCount : Longint;
    FWarningText : TStringList;
    FDealer: ShortString;
    FDealerTown: ShortString;
    FLicencee: ShortString;
    FVersion : TEntVersionType;
    FContact: ShortString;
    FAddress: Array [1..5] Of ShortString;
    FFaxNumber: ShortString;
    FEmailAddress: ShortString;
    FPhoneNumber: ShortString;
    FPostCode: ShortString;
    FSendCompanies: Boolean;
    FCurrencyVersion : Byte;
    FLicenceType : Byte;

    FPackage, FOtherPackage   : ShortString;
    FPosition, FOtherPosition : ShortString;
    FIndustry, FOtherIndustry : ShortString;
    FTurnover, FTurnoverCcy   : ShortString;
    FEmployees                : ShortString;

    function GetDataSet(Index: Integer): TEntDataSet;
    function GetAddress(Index: Byte): ShortString;
    procedure SetAddress(Index: Byte; const Value: ShortString);
  Protected
    Function GetCount : LongInt;
  Public
    Property Address [Index : Byte] : ShortString Read GetAddress Write SetAddress;
    Property Contact : ShortString Read FContact Write FContact;
    Property Count : LongInt Read GetCount;
    Property CurrencyVersion : Byte Read FCurrencyVersion Write FCurrencyVersion;
    Property DataSets [Index : LongInt] : TEntDataSet Read GetDataSet;
    Property Dealer : ShortString Read FDealer Write FDealer;
    Property DealerTown : ShortString Read FDealerTown Write FDealerTown;
    Property EmailAddress : ShortString Read FEmailAddress Write FEmailAddress;
    Property EntPath : ShortString Read FEntPath Write FEntPath;
    Property ESN : ISNArrayType Read FESN Write FESN;
    Property FaxNumber : ShortString Read FFaxNumber Write FFaxNumber;
    Property Licencee : ShortString Read FLicencee Write FLicencee;
    Property LicenceType : Byte Read FLicenceType Write FLicenceType;
    Property PhoneNumber : ShortString Read FPhoneNumber Write FPhoneNumber;
    Property PostCode : ShortString Read FPostCode Write FPostCode;
    Property SendCompanies : Boolean Read FSendCompanies Write FSendCompanies;
    Property SurveyResults : TStringList Read FSurveyResults Write FSurveyResults;
    Property Version : TEntVersionType Read FVersion Write FVersion;
    Property WarningCount : LongInt Read FWarningCount;

    Property Package : ShortString Read FPackage Write FPackage;
    Property OtherPackage : ShortString Read FOtherPackage Write FOtherPackage;
    Property Position : ShortString Read FPosition Write FPosition;
    Property OtherPosition : ShortString Read FOtherPosition Write FOtherPosition;
    Property Industry : ShortString Read FIndustry Write FIndustry;
    Property OtherIndustry : ShortString Read FOtherIndustry Write FOtherIndustry;
    Property Turnover : ShortString Read FTurnover Write FTurnover;
    Property TurnoverCcy : ShortString Read FTurnoverCcy Write FTurnoverCcy;
    Property Employees : ShortString Read FEmployees Write FEmployees;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure AddDataSet (Const mcmCode, mcmCompany, mcmPath : ShortString);
    procedure AddWarningText(Const WarnText : ANSIString);
    procedure AddWarningStrings(Const WarnText : ANSIString; Const WarnStrs : TStringList);
    Procedure BuildReport;
    Procedure CheckEntLicence;
    Procedure CheckVersion;
    Procedure UpdateSetupUSR;
  End; { TEntSurveyInfo }


Var
  oSurveyInfo : TEntSurveyInfo = NIL;


implementation

Uses EntLic, oSysF,
{$IFDEF EXSQL}
SQLUtils,
{$ENDIF}
LicFuncU;

Const
  {$I FilePath.Inc}

//--------------------------------------------------------------------------

Constructor TEntDataSet.Create (Const Parent : TEntSurveyInfo; Const mcmCode, mcmCompany, mcmPath : ShortString);
Begin { Create }
  Inherited Create;

  FSurvey := Parent;

  // Copy details from MCM into local properties
  FCode := UpperCase(Trim(mcmCode));
  FCompanyName := Trim(mcmCompany);
  FPath := Trim(mcmPath);

  // Analyse the details
  AnalyseDir;
End; { Create }

//---------------------------------------

Destructor TEntDataSet.Destroy;
Begin { Destroy }
  FSurvey := NIL;

  inherited;
End;

//--------------------------------------------------------------------------

function TEntDataSet.GetFileVersions(Index: Byte): Byte;
begin
  Result := FFileVersions[Index];
end;

//---------------------------------------

procedure TEntDataSet.SetFileVersions(Index: Byte; const Value: Byte);
begin
  FFileVersions[Index] := Value;
end;

//--------------------------------------------------------------------------

// Checks for the Enterprise Data Files in the specified path
Function TEntDataSet.IsValidCompany (CompPath : ShortString) : Boolean;
Begin { IsValidCompany }
{$IFDEF EXSQL}
  Result := SQLUtils.ValidCompany(CompPath);
{$ELSE}
  Result := FileExists (CompPath + 'EXCHQSS.DAT') And              // EXCHQSS.Dat
            FileExists (CompPath + NumNam) And                     // EXCHQNUM.Dat

            FileExists (CompPath + Path1 + CustName) And           // Cust\CUSTSUPP.Dat

            FileExists (CompPath + Path6 + JobCtrlNam) And         // Jobs\JOBCTRL.Dat
            FileExists (CompPath + Path6 + JobDetNam) And          // Jobs\JOBDET.Dat
            FileExists (CompPath + Path6 + JobRecNam) And          // Jobs\JOBHEAD.Dat
            FileExists (CompPath + Path6 + JobMiscNam) And         // Jobs\JOBMISC.Dat

            FileExists (CompPath + Path3 + MiscNam) And            // Misc\EXSTKCHK.Dat
            FileExists (CompPath + Path3 + PassNam) And            // Misc\EXCHQCHK.Dat

            FileExists (CompPath + Path4 + MLocName) And           // Stock\MLOCSTK.Dat
            FileExists (CompPath + Path4 + StockNam) And           // Stock\STOCK.Dat

            FileExists (CompPath + Path2 + DetailName) And         // Trans\DETAILS.Dat
            FileExists (CompPath + Path2 + DocName) And            // Trans\DOCUMENT.Dat
            FileExists (CompPath + Path2 + HistName) And           // Trans\HISTORY.Dat
            FileExists (CompPath + Path2 + NomNam);                // Trans\NOMINAL.Dat
{$ENDIF}            
End; { IsValidCompany }

//--------------------------------------------------------------------------

// Analyses the Company Data Path to determine the status
Function TEntDataSet.CheckSingleBtrFile (Const FilePath : ShortString; Const DetailList : TStringList) : Byte;
Type
  BtrFileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..28] of KeySpec;
    AltColt   :  AltColtSeq;
  End;

Var
  FVar    : BtrFileDef;
  FDummy  : Array [1..5000] of Byte;
  lStatus : LongInt;
  FileVer : Integer;
Begin { CheckSingleBtrFile }
  Result := 0;

  // Initialise enough Btrieve details to open the files
  FillChar (FDummy, SizeOf(FDummy), #0);
  FillChar (FVar, SizeOf(FVar), #0);
  With FVar Do Begin
    RecLen    := SizeOf (FDummy);
    PageSize  := DefPageSize;
    NumIndex  := 1;

    AltColt   := UpperALT;
  End; { With FVar }

  FileSpecLen [CustF] := SizeOf(FVar);
  FileRecLen [CustF]  := FVar.RecLen;
  RecPtr[CustF]       := @FDummy;
  FileSpecOfs[CustF]  := @FVar;
  FileNames[CustF]    := FilePath;

  // Open specified file
  lStatus := Open_File(F[CustF], FPath + Filenames[CustF], -2);
  If (lStatus = 0) Then Begin
    // Get the file version
    FileVer := File_VerCID(F[CustF], CustF, nil);

    Close_File(F[CustF]);

    // Version is in Hex - 60 for v6, 50 for v5, etc.
    Result := FileVer div 16;

    DetailList.Add (Format('  %s: v%d.00', [FilePath, Result]));
  End { If (lStatus = 0) }
  Else
    FSurvey.AddWarningText('Warning: 2001 - Btrieve Error ' + IntToStr(lStatus) + ' accessing ' + FilePath + ' in the Data Set for Company ' + FCode);
End; { CheckSingleBtrFile }

//---------------------------------------

// Analyses the Company Data Path to determine the status
Procedure TEntDataSet.CheckBtrFiles;
Var
  DetList                   : TStringList;
  TotAfter6, TotVersions, I : SmallInt;
Begin { CheckBtrFiles }
  // Initialise the File Versioning info
  FillChar (FFileVersions, SizeOf(FFileVersions), #0);

  DetList := TStringList.Create;
  Try
    // Run through the data set and update the array with the file versions
    Inc (FFileVersions [CheckSingleBtrFile(PathSys, DetList)]);               // EXCHQSS.Dat
    Inc (FFileVersions [CheckSingleBtrFile(NumNam, DetList)]);                // EXCHQNUM.Dat

    Inc (FFileVersions [CheckSingleBtrFile(Path1 + CustName, DetList)]);      // Cust\CUSTSUPP.Dat

    Inc (FFileVersions [CheckSingleBtrFile(Path6 + JobCtrlNam, DetList)]);    // Jobs\JOBCTRL.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path6 + JobDetNam, DetList)]);     // Jobs\JOBDET.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path6 + JobRecNam, DetList)]);     // Jobs\JOBHEAD.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path6 + JobMiscNam, DetList)]);    // Jobs\JOBMISC.Dat

    Inc (FFileVersions [CheckSingleBtrFile(Path3 + MiscNam, DetList)]);       // Misc\EXSTKCHK.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path3 + PassNam, DetList)]);       // Misc\EXCHQCHK.Dat

    Inc (FFileVersions [CheckSingleBtrFile(Path4 + MLocName, DetList)]);      // Stock\MLOCSTK.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path4 + StockNam, DetList)]);      // Stock\STOCK.Dat

    Inc (FFileVersions [CheckSingleBtrFile(Path2 + DetailName, DetList)]);    // Trans\DETAILS.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path2 + DocName, DetList)]);       // Trans\DOCUMENT.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path2 + HistName, DetList)]);      // Trans\HISTORY.Dat
    Inc (FFileVersions [CheckSingleBtrFile(Path2 + NomNam, DetList)]);        // Trans\NOMINAL.Dat

    // Add up the instances of files of v7.0 or later
    TotAfter6   := 0;
    TotVersions := 0;
    For I := 1 To High(FFileVersions) Do Begin
      // Calculate the number of file versions we have
      If (FFileVersions[I] > 0) Then Inc(TotVersions);

      // Accumulate the files of v7 or later
      If (I >= 7) Then TotAfter6 := TotAfter6 + FFileVersions[I];
    End; { For I }

    If (FFileVersions[0] > 0) Then
      FSurvey.AddWarningText('Warning: 2002 - ' + IntToStr(FFileVersions[0]) + ' files could not be checked in the Data Set for Company ' + FCode);

    If (TotVersions > 1) Then Begin
      FSurvey.AddWarningStrings('Warning: 2003 - The Data Set for Company ' + FCode + ' contains files of more than one Pervasive version',
                                DetList);
    End; { If (TotVersions > 1) }

    If (TotAfter6 > 0) Then Begin
      FSurvey.AddWarningStrings('Warning: 2004 - The Data Set for Company ' + FCode + ' contains ' + IntToStr(TotAfter6) + ' files of version 7 format or later',
                                DetList);
    End; { If (TotAfter6 > 0) }
  Finally
    FreeAndNIL(DetList);
  End;
End; { CheckBtrFiles }

//--------------------------------------------------------------------------

// Analyses the Company Data Path to determine the status
Procedure TEntDataSet.AnalyseDir;
Var
  lStatus : LongInt;
Begin { AnalyseDir }
  // Check Directory Exists
  If DirectoryExists (FPath) Then Begin
    // Check ALL Data files Exist
    If IsValidCompany (FPath) Then Begin
      // Check its an ESN version
      If (FSurvey.Version In EntLicenceSet) Then Begin
        // Open ExchqSS.Dat in Company Data Set
        With TSystemSetupFile.Create Do
          Try
            // Open ExchqSS.Dat and Check ESN
            lStatus := OpenData (FPath);
            If (lStatus = 0) Then Begin
              // Read SysR record and Check ESN
              lStatus := LoadSyss;
              If (lStatus = 0) Then Begin
                If (ESN[1] <> FSurvey.ESN[1]) Or (ESN[2] <> FSurvey.ESN[2]) Or
                   (ESN[3] <> FSurvey.ESN[3]) Or (ESN[4] <> FSurvey.ESN[4]) Or
                   (ESN[5] <> FSurvey.ESN[5]) Or (ESN[6] <> FSurvey.ESN[6]) Then
                  FSurvey.AddWarningText('Warning: 1005 - Invalid ESN in Company ' + FCode);
              End { If OpenData (FPath) }
              Else
                FSurvey.AddWarningText('Warning: 1004 - Btrieve Error ' + IntToStr(lStatus) + ' accessing Data Set for Company ' + FCode);

              // Close ExchqSS.Dat
              CloseData;
            End { If OpenData (FPath) }
            Else
              FSurvey.AddWarningText('Warning: 1003 - Btrieve Error ' + IntToStr(lStatus) + ' accessing Data Set for Company ' + FCode);
          Finally
            Free;
          End;

        // Check Currency Version files - DEFMC044/DEFPF044
        If (FSurvey.CurrencyVersion = 0) Then Begin
          // Professional - Check DEFPF044 exists and DEFMC044 doesn't
          If Not FileExists (FPath + 'DEFPF044.SYS') Then
            FSurvey.AddWarningText('Warning: 1006 - DEFPF044.SYS is missing from the Data Set for Company ' + FCode);
          If FileExists (FPath + 'DEFMC044.SYS') Then
            FSurvey.AddWarningText('Warning: 1007 - DEFMC044.SYS was found in the Data Set for Company ' + FCode);
        End { If (FSurvey.CurrencyVersion = 0) }
        Else Begin
          // Euro / Global - Check DEFPF044 doesn't exist and DEFMC044 does
          If Not FileExists (FPath + 'DEFMC044.SYS') Then
            FSurvey.AddWarningText('Warning: 1008 - DEFMC044.SYS is missing from the Data Set for Company ' + FCode);
          If FileExists (FPath + 'DEFPF044.SYS') Then
            FSurvey.AddWarningText('Warning: 1009 - DEFPF044.SYS was found in the Data Set for Company ' + FCode);
        End; { Else }
      End { If (FSurvey.Version In EntLicenceSet)  }
      Else Begin
        // pre-v4.30c - check that there is only one SYS file
        If FileExists (FPath + 'DEFPF044.SYS') And FileExists (FPath + 'DEFMC044.SYS') Then
          FSurvey.AddWarningText('Warning: 1010 - DEFPF044.SYS and DEFMC044.SYS were found in the Data Set for Company ' + FCode);

        If (Not FileExists (FPath + 'DEFPF044.SYS')) And (Not FileExists (FPath + 'DEFMC044.SYS')) Then
          FSurvey.AddWarningText('Warning: 1011 - DEFPF044/DEFMC044 are missing from the Data Set for Company ' + FCode);
      End; { Else }

      // Check Btrieve File versions
      CheckBtrFiles;
    End { If DirectoryExists (FPath) }
    Else
      FSurvey.AddWarningText('Warning: 1002 - Incomplete Data Set for Company ' + FCode);
  End { If DirectoryExists (FPath) }
  Else
    FSurvey.AddWarningText('Warning: 1001 - Invalid Path for Company ' + FCode);
End; { AnalyseDir }

//--------------------------------------------------------------------------

Constructor TEntSurveyInfo.Create;
Var
  WSNetDir : ANSIString;
Begin { Create }
  Inherited Create;

  // Set path to Enterprise directory
  FEntPath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));

  // Check for Local Program Files
  If FileExists (FEntPath + 'ENTWREPL.INI') Then
    With TIniFile.Create (FEntPath + 'ENTWREPL.INI') Do
      Try
        // Get Path from .INI file
        WSNetDir := IncludeTrailingPathDelimiter(ReadString ('UpdateEngine', 'NetworkDir', ''));

        // Check the path is valid
{$IFDEF EXSQL}
        if SQLUtils.ValidSystem(WSNetDir) then
{$ELSE}
        If DirectoryExists (WSNetDir) And FileExists (WSNetDir + 'COMPANY.DAT') And
           FileExists (WSNetDir + Path1 + CustName) And FileExists (WSNetDir + Path2 + DocName) Then
{$ENDIF}           
          FEntPath := WSNetDir;
      Finally
        Free;
      End;

  // Create an internal TList to store the data set info in TEntDataSet objects
  FDataSets := TList.Create;

  // Create internal StringLists to store the Warnings and Survey Output
  FSurveyResults := TStringList.Create;
  FWarningText := TStringList.Create;

  // Initialise the Survey Details
  FVersion := verUnknown;
  FLicencee := '';
  FDealer := '';
  FDealerTown := '';
  FContact := '';
  FillChar (FAddress, SizeOf(FAddress), #0);
  FFaxNumber := '';
  FEmailAddress := '';
  FPhoneNumber := '';
  FPostCode := '';
  FSendCompanies := True;
  FWarningCount := 0;

  If FileExists (FEntPath + 'WSTATION\SETUP.USR') Then
    With TInifile.Create (FEntPath + 'WSTATION\SETUP.USR') Do
      Try
        If SectionExists ('CustDets') Then Begin
          FLicencee := ReadString ('CustDets', 'Name', FLicencee);
          FDealer := ReadString ('CustDets', 'Dealer', FDealer);
          FDealerTown := ReadString ('CustDets', 'DealerTown', FDealerTown);
          FContact := ReadString ('CustDets', 'Contact', FContact);
          FAddress[1] := ReadString ('CustDets', 'Addr1', FAddress[1]);
          FAddress[2] := ReadString ('CustDets', 'Addr2', FAddress[2]);
          FAddress[3] := ReadString ('CustDets', 'Addr3', FAddress[3]);
          FAddress[4] := ReadString ('CustDets', 'Addr4', FAddress[4]);
          FAddress[5] := ReadString ('CustDets', 'Addr5', FAddress[5]);
          FPostCode   :=  ReadString ('CustDets', 'PostCode', FPostCode);
          FFaxNumber := ReadString ('CustDets', 'Fax', FFaxNumber);
          FEmailAddress := ReadString ('CustDets', 'Email', FEmailAddress);
          FPhoneNumber := ReadString ('CustDets', 'Phone', FPhoneNumber);

          FPackage := ReadString ('Marketing', 'Package', FPackage);
          FOtherPackage := ReadString ('Marketing', 'OtherPackage', FOtherPackage);
          FPosition := ReadString ('Marketing', 'Position', FPosition);
          FOtherPosition := ReadString ('Marketing', 'OtherPosition', FOtherPosition);
          FIndustry := ReadString ('Marketing', 'Industry', FIndustry);
          FOtherIndustry := ReadString ('Marketing', 'OtherIndustry', FOtherIndustry);
          FTurnover := ReadString ('Marketing', 'Turnover', FTurnover);
          FTurnoverCcy := ReadString ('Marketing', 'TurnoverCcy', FTurnoverCcy);
          FEmployees := ReadString ('Marketing', 'Employees', FEmployees);
        End; { If SectionExists (CustDets) }
      Finally
        Free;
      End;
End; { Create }

//---------------------------------------

Destructor TEntSurveyInfo.Destroy;
Begin { Destroy }
  // Remove any data sets within the list
  If Assigned(FDataSets) Then
    While (FDataSets.Count > 0) Do Begin
      TEntDataSet(FDataSets.Items[0]).Free;
      FDataSets.Delete(0);
    End; { While (FDataSets.Count > 0) }

  // destroy the data set list and the reports
  FreeAndNIL (FDataSets);
  FreeAndNIL (FWarningText);
  FreeAndNIL (FSurveyResults);

  inherited;
End; { Destroy }

//--------------------------------------------------------------------------

// Write info to Setup.USR for future reference
Procedure TEntSurveyInfo.UpdateSetupUSR;
Begin { UpdateSetupUSR }
  If FileExists (FEntPath + 'WSTATION\SETUP.USR') Then
    With TInifile.Create (FEntPath + 'WSTATION\SETUP.USR') Do
      Try
        WriteString ('CustDets', 'Name', FLicencee);
        WriteString ('CustDets', 'Dealer', FDealer);
        WriteString ('CustDets', 'DealerTown', FDealerTown);
        WriteString ('CustDets', 'Contact', FContact);
        WriteString ('CustDets', 'Addr1', FAddress[1]);
        WriteString ('CustDets', 'Addr2', FAddress[2]);
        WriteString ('CustDets', 'Addr3', FAddress[3]);
        WriteString ('CustDets', 'Addr4', FAddress[4]);
        WriteString ('CustDets', 'Addr5', FAddress[5]);
        WriteString ('CustDets', 'PostCode', FPostCode);
        WriteString ('CustDets', 'Fax', FFaxNumber);
        WriteString ('CustDets', 'Email', FEmailAddress);
        WriteString ('CustDets', 'Phone', FPhoneNumber);

        WriteString ('Marketing', 'Package', FPackage);
        WriteString ('Marketing', 'OtherPackage', FOtherPackage);
        WriteString ('Marketing', 'Position', FPosition);
        WriteString ('Marketing', 'OtherPosition', FOtherPosition);
        WriteString ('Marketing', 'Industry', FIndustry);
        WriteString ('Marketing', 'OtherIndustry', FOtherIndustry);
        WriteString ('Marketing', 'Turnover', FTurnover);
        WriteString ('Marketing', 'TurnoverCcy', FTurnoverCcy);
        WriteString ('Marketing', 'Employees', FEmployees);
      Finally
        Free;
      End;
End; { UpdateSetupUSR }

//--------------------------------------------------------------------------

Procedure TEntSurveyInfo.AddDataSet (Const mcmCode, mcmCompany, mcmPath : ShortString);
Var
  oEntDataSet : TEntDataSet;
Begin { AddDataSet }
  // Create an Enterprise Data Set Object
  oEntDataSet := TEntDataSet.Create(Self, mcmCode, mcmCompany, mcmPath);

  // Add it into the Data Sets List
  FDataSets.Add(oEntDataSet);
End; { AddDataSet }

//--------------------------------------------------------------------------

Function TEntSurveyInfo.GetCount : LongInt;
Begin { GetCount }
  Result := FDataSets.Count;
End; { GetCount }

//---------------------------------------

function TEntSurveyInfo.GetDataSet(Index: Integer): TEntDataSet;
begin
  Result := TEntDataSet(FDataSets.Items[Index]);
end;

//--------------------------------------------------------------------------

// Checks the Enterprise directory to guestimate the Enterprise Version
Procedure TEntSurveyInfo.CheckVersion;
Begin { CheckVersion }
  If FileExists(FEntPath + 'ENTSECUR.DLL') Then
    // Enterprise v5.00
    FVersion := ver500
  Else
    If FileExists(FEntPath + EntLicFName) Then Begin
      // v4.30c or v4.31 or v4.32
      If FileExists (FEntPath + 'EntToolK.DLL') Then
        // v4.32 - COM Toolkit Found
        FVersion := ver432
      Else
        If FileExists (FEntPath + 'BorlndMM.DLL') Then
          // v4.31 - BorlandMM.DLL Found
          FVersion := ver431
        Else
          // v4.30c
          FVersion := ver430c;
    End { If FileExists(FEntPath + EntLicFName)  }
    Else
      // Pre-Licence
      FVersion := verPre430c;
End; { CheckVersion }

//--------------------------------------------------------------------------

// Checks the Enterprise directory for the Enterprise Licence File
Procedure TEntSurveyInfo.CheckEntLicence;
Var
  EntLicence : EntLicenceRecType;
Begin { CheckEntLicence }
  CheckVersion;

  If FileExists(FEntPath + EntLicFName) Then Begin
    // Got Licence File - v4.30c -> v5.00

    // Read Licence
    If ReadEntLic (EntPath + EntLicFName, EntLicence) Then Begin
      // Copy Details out of licence into Survey Info
      FLicencee := Trim(EntLicence.licCompany);
      FDealer := Trim(EntLicence.licDealer);
      FESN := ISNArrayType(EntLicence.licISN);
      FCurrencyVersion := EntLicence.licEntCVer;
      FLicenceType := EntLicence.licLicType;
    End; { If ReadEntLic }
  End; { If FileExists }
End; { CheckEntLicence }

//--------------------------------------------------------------------------

Procedure TEntSurveyInfo.BuildReport;
Var
  I : LongInt;
Begin { BuildReport }
  With FSurveyResults Do Begin
    Clear;

    // Version: VerNo, EntVerNo
    Add ('SurveyVersion: 2.00');
    Add ('ExchequerVersion: ' + EntVersionString[FVersion]);

    If (FVersion In [ver430c, ver431, ver432, ver500]) Then
      Add ('ESN: ' + licESN7Str (ESNByteArrayType(FESN), LicenceType))
    Else
      Add ('ESN: Pre-ESN');
    Add ('Licencee: ' + FLicencee);

    Add ('Contact: ' + FContact);
    Add ('Address1: ' + FAddress[1]);
    Add ('Address2: ' + FAddress[2]);
    Add ('Address3: ' + FAddress[3]);
    Add ('Address4: ' + FAddress[4]);
    Add ('Address5: ' + FAddress[5]);
    Add ('PostCode: ' + FPostCode);
    Add ('Telephone: ' + FPhoneNumber);
    Add ('Fax: ' + FFaxNumber);
    Add ('Email: ' + FEmailAddress);

    If (Trim(FOtherPackage) <> '') Then
      Add ('PrevPackage: ' + FPackage + ' - ' + FOtherPackage)
    Else
      Add ('PrevPackage: ' + FPackage);
    If (Trim(FOtherPosition) <> '') Then
      Add ('Position: ' + FPosition + ' - ' + FOtherPosition)
    Else
      Add ('Position: ' + FPosition);
    If (Trim(FOtherIndustry) <> '') Then
      Add ('Industry: ' + FIndustry + ' - ' + FOtherIndustry)
    Else
      Add ('Industry: ' + FIndustry);
    Add ('Turnover: ' + FTurnover + ' ' + FTurnoverCcy);
    Add ('Employees: ' + FEmployees);

    // CompanyCount: CompCount
    Add ('CompanyCount: ' + IntToStr(FDataSets.Count));

    If (FDataSets.Count > 0) And FSendCompanies Then
      For I := 0 To Pred(FDataSets.Count) Do
        // Company: CompName, ...
        With DataSets[I] Do
          Add ('Company(' + Trim(CompCode) + '): ' + Trim(CompName));

    If (FWarningText.Count > 0) Then
      For I := 0 To Pred(FWarningText.Count) Do
          Add (FWarningText[I]);
  End; { With ReportMemo }
End; { BuildReport }

//--------------------------------------------------------------------------

function TEntSurveyInfo.GetAddress(Index: Byte): ShortString;
begin
  Result := FAddress[Index];
end;

procedure TEntSurveyInfo.SetAddress(Index: Byte; const Value: ShortString);
begin
  FAddress[Index] := Value;
end;

//--------------------------------------------------------------------------

procedure TEntSurveyInfo.AddWarningText(Const WarnText : ANSIString);
Begin { AddWarningText }
  FWarningText.Add (WarnText);
  Inc(FWarningCount);
End; { AddWarningText }

procedure TEntSurveyInfo.AddWarningStrings(Const WarnText : ANSIString; Const WarnStrs : TStringList);
Var
  I : SmallInt;
Begin { AddWarningStrings }
  AddWarningText(WarnText);

  If (WarnStrs.Count > 0) Then
    For I := 0 To Pred(WarnStrs.Count) Do
      FWarningText.Add (WarnStrs[I]);
End; { AddWarningStrings }

//--------------------------------------------------------------------------

Initialization
  // Create global object to store survey information
  oSurveyInfo := TEntSurveyInfo.Create;
Finalization
  FreeAndNIL(oSurveyInfo);
end.
