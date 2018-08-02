Unit UNCCache;

Interface

Uses Classes, IniFiles, Windows, SysUtils;

Type
  // Callback proc for LoadCompanyUNCFile
  TAddCompanyUNCDetailsProc = Procedure (Const coCode, coName, coDrivePath, coUNCPath : ANSIString; Const FlagFileFound : Boolean) of Object;

  //------------------------------

  // Record structure for WriteCompanyUNCFile
  TCompanyUNCDetailsRecType = Record
    coCode      : ANSIString;
    coName      : ANSIString;
    coDrivePath : ANSIString;
    coUNCPath   : ANSIString;
  End; // TCompanyUNCDetailsRecType

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IUNCCompanyCache = Interface
    ['{8B057769-946B-40F4-947A-74693C9E432C}']
    // --- Internal Methods to implement Public Properties ---

    // ------------------ Public Properties ------------------

    // ------------------- Public Methods --------------------

    // Returns the Company Code for the specified Path, returns empty string if not found
    Function CompanyCodeFromPath (Path : String) : String;
  End; // IUNCCompanyCache


Function UNCCompanyCache : IUNCCompanyCache;

// Returns TRUE if the Company UNC Path Config file exists in the specified directory
Function CompanyUNCFileExists (Const ConfigPath : ShortString) : Boolean;
// Loads the Company UNC Config info and calls the AddCompanyProc callback for each set of company details loaded
Procedure LoadCompanyUNCFile (Const ConfigPath : ShortString; Const AddCompanyProc : TAddCompanyUNCDetailsProc);
// Takes a dynamic array of Company Details in TCompanyUNCDetailsRecType format and writes them to the UNC Cache config file
Procedure WriteCompanyUNCFile (Const ConfigPath : ShortString; Const CompanyDetails : Array Of TCompanyUNCDetailsRecType);

Implementation

Const
  ConfigFileName = 'BtrvSQL.Dat';

Type
  TUNCCompanyCacheCompanyDetails = Class(TObject)
  Private
    FCompanyCode : String;
    FCompanyPath : String;
    FShortCompanyPath : String;
    FUNCPath : String;
    FShortUNCPath : String;

    // Converts a Long Path into the Short Filename equivalent
    function LongPathToShortPath(Const Path : String) : String;
  Public
    Property CompanyCode : String Read FCompanyCode;
    Property CompanyPath : String Read FCompanyPath;
    Property UNCPath : String Read FUNCPath;

    Constructor Create (Const CompanyCode, CompanyPath, UNCPath : String);

    // Returns TRUE if the passed path matches either the CompanyPath or UNCPath
    Function PathMatches (Const Path : String) : Boolean;
  End; // TUNCCompanyCacheCompanyDetails

  //------------------------------

  TUNCCompanyCache = Class(TInterfacedObject, IUNCCompanyCache)
  Private
    FCompanyCache : TList;

    // IUNCCompanyCache
    // Returns the Company Code for the specified Path, returns empty string if not found
    Function CompanyCodeFromPath (Path : String) : String;

    // Callback routine for adding the company details into the cache
    Procedure AddCompanyUNCDetails (Const coCode, coName, coDrivePath, coUNCPath : ANSIString; Const FlagFileFound : Boolean);
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TUNCCompanyCache

Var
  lUNCCompanyCacheObj : TUNCCompanyCache;
  lUNCCompanyCacheIntf : IUNCCompanyCache;

//=========================================================================

// Returns TRUE if the Company UNC Path Config file exists in the specified directory
Function CompanyUNCFileExists (Const ConfigPath : ShortString) : Boolean;
Begin // CompanyUNCFileExists
  Result := FileExists(IncludeTrailingPathDelimiter(ConfigPath) + ConfigFileName);
End; // CompanyUNCFileExists

//-------------------------------------------------------------------------

// Loads the Company UNC Config info and calls the AddCompanyProc callback for each set of company details loaded
Procedure LoadCompanyUNCFile (Const ConfigPath : ShortString; Const AddCompanyProc : TAddCompanyUNCDetailsProc);
Var
  oIni : TIniFile;
  oSections : TStringList;
  iSection : Integer;
  coCode, coName, coDrivePath, coUNCPath : ANSIString;
  coFlagFound : Boolean;
Begin // LoadCompanyUNCFile
  oIni := TIniFile.Create(IncludeTrailingPathDelimiter(ConfigPath) + ConfigFileName);
  oSections := TStringList.Create;
  Try
    // Get a list of the sections - these will be the company codes
    oIni.ReadSections(oSections);
    For iSection := 0 To (oSections.Count - 1) Do
    Begin
      coCode := oSections.Strings[iSection];
      coName := oIni.ReadString(oSections.Strings[iSection], 'CompanyName', '');
      coDrivePath := oIni.ReadString(oSections.Strings[iSection], 'CompanyPath', '');
      coUNCPath := oIni.ReadString(oSections.Strings[iSection], 'CompanyUNCPath', '');

      coFlagFound := FileExists(IncludeTrailingPathDelimiter(coUNCPath) + Trim(coCode) + '.Company');

      AddCompanyProc (coCode, coName, coDrivePath, coUNCPath, coFlagFound);
    End; // For iSection
  Finally
    oIni.Free;
  End; // Try..Finally
End; // LoadCompanyUNCFile

//-------------------------------------------------------------------------

// Takes a dynamic array of Company Details in TCompanyUNCDetailsRecType format and writes them to the UNC Cache config file
Procedure WriteCompanyUNCFile (Const ConfigPath : ShortString; Const CompanyDetails : Array Of TCompanyUNCDetailsRecType);
Var
  oIni : TIniFile;
  I : Integer;
Begin // WriteCompanyUNCFile
  If (Length(CompanyDetails) > 0) Then
  Begin
    // Remove any pre-existing settings for a clean start
    If FileExists(IncludeTrailingPathDelimiter(ConfigPath) + ConfigFileName) Then
      DeleteFile (IncludeTrailingPathDelimiter(ConfigPath) + ConfigFileName);

    oIni := TIniFile.Create(IncludeTrailingPathDelimiter(ConfigPath) + ConfigFileName);
    Try
      For I := Low(CompanyDetails) To High(CompanyDetails) Do
      Begin
        oIni.WriteString (CompanyDetails[I].coCode, 'CompanyName', CompanyDetails[I].coName);
        oIni.WriteString (CompanyDetails[I].coCode, 'CompanyPath', CompanyDetails[I].coDrivePath);
        oIni.WriteString (CompanyDetails[I].coCode, 'CompanyUNCPath', CompanyDetails[I].coUNCPath);
      End; // For I
    Finally
      oIni.Free;
    End; // Try..Finally
  End; // If (Length(CompanyDetails) > 0)
End; // WriteCompanyUNCFile

//=========================================================================

Function UNCCompanyCache : IUNCCompanyCache;
Begin // UNCCompanyCache
  If (Not Assigned(lUNCCompanyCacheIntf)) Then
  Begin
    lUNCCompanyCacheObj := TUNCCompanyCache.Create;
    lUNCCompanyCacheIntf := lUNCCompanyCacheObj;
  End; // If (Not Assigned(lUNCCompanyCacheIntf))

  Result := lUNCCompanyCacheIntf;
End; // UNCCompanyCache

//-------------------------------------------------------------------------

Procedure ResetUNCCompanyCache;
Begin // ResetUNCCompanyCache
  lUNCCompanyCacheObj := NIL;
  lUNCCompanyCacheIntf := NIL;
End; // ResetUNCCompanyCache

//=========================================================================

Constructor TUNCCompanyCacheCompanyDetails.Create (Const CompanyCode, CompanyPath, UNCPath : String);
Begin // Create
  Inherited Create;

  FCompanyCode := CompanyCode;

  FCompanyPath := IncludeTrailingPathDelimiter(UpperCase(Trim(CompanyPath)));
  FShortCompanyPath := LongPathToShortPath(FCompanyPath);

  FUNCPath := IncludeTrailingPathDelimiter(UpperCase(Trim(UNCPath)));
  FShortCompanyPath := LongPathToShortPath(FUNCPath);
End; // Create

//-------------------------------------------------------------------------

// Converts a Long Path into the Short Filename equivalent
function TUNCCompanyCacheCompanyDetails.LongPathToShortPath(Const Path : String) : String;
Var
  LongPath, ShortPath: PChar;
  PLen: SmallInt;
Begin // LongPathToShortPath
  Result := Trim(Path);
  If (Result <> '') Then
  Begin
    LongPath  := StrAlloc(250);
    ShortPath := StrAlloc(250);

    StrPCopy (LongPath, Trim(Path));
    PLen := GetShortPathName(LongPath, ShortPath, StrBufSize(ShortPath));
    If (PLen > 0) Then
      Result := Trim(StrPas(ShortPath));

    StrDispose (LongPath);
    StrDispose (ShortPath);
  End; // If (Result <> '')
End; // LongPathToShortPath

//-------------------------------------------------------------------------

// Returns TRUE if the passed path matches either the CompanyPath or UNCPath
Function TUNCCompanyCacheCompanyDetails.PathMatches (Const Path : String) : Boolean;
Begin // PathMatches
  Result := (Path = FCompanyPath) Or (Path = FShortCompanyPath) Or
            (Path = FUNCPath) Or (Path = FShortCompanyPath);
End; // PathMatches

//=========================================================================

Constructor TUNCCompanyCache.Create;
Var
  sIniPath : ShortString;
  Buffer   : PChar;
  Len      : SmallInt;
Begin // Create
  Inherited Create;

  // Create the company cache
  FCompanyCache := TList.Create;

  // Check for the .ini file in the .DLL's directory
  Buffer := StrAlloc (255);
  Try
    Len := GetModuleFileName(HInstance, Buffer, StrBufSize(Buffer));
    If (Len > 0) Then
    Begin
      sIniPath := ExtractFilePath(Buffer);
      If CompanyUNCFileExists (sIniPath) Then
        LoadCompanyUNCFile (sIniPath, AddCompanyUNCDetails);
    End // If (Len > 0)
    Else
      ; // Didn't get a path somehow - can't do anything constructive about it, so do nothing
  Finally
    StrDispose(Buffer);
  End; // Try..Finally
End; // Create

//------------------------------

Destructor TUNCCompanyCache.Destroy;
Var
  oCompanyDetails : TUNCCompanyCacheCompanyDetails;
Begin // Destroy
  // Remove any cached company details and destroy the list
  While (FCompanyCache.Count > 0) Do
  Begin
    oCompanyDetails := TUNCCompanyCacheCompanyDetails(FCompanyCache.Items[0]);
    oCompanyDetails.Free;
    FCompanyCache.Delete(0);
  End; // While (FCompanyCache.Count > 0)
  FreeAndNIL(FCompanyCache);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TUNCCompanyCache.AddCompanyUNCDetails (Const coCode, coName, coDrivePath, coUNCPath : ANSIString; Const FlagFileFound : Boolean);
Begin // AddCompanyUNCDetails
  // Check the flag file was found before adding it info the list
  If FlagFileFound Then
    FCompanyCache.Add (TUNCCompanyCacheCompanyDetails.Create (coCode, coDrivePath, coUNCPath));
End; // AddCompanyUNCDetails

//-------------------------------------------------------------------------

// Returns the Company Code for the specified Path, returns empty string if not found
Function TUNCCompanyCache.CompanyCodeFromPath (Path : String) : String;
Var
  oCompanyDetails : TUNCCompanyCacheCompanyDetails;
  I : Integer;
Begin // CompanyCodeFromPath
  Result := '';

  // Ensure the trailing backslash is present for the comparisons
  Path := IncludeTrailingPathDelimiter(UpperCase(Trim(Path)));

  For I := 0 To (FCompanyCache.Count - 1) Do
  Begin
    oCompanyDetails := TUNCCompanyCacheCompanyDetails(FCompanyCache.Items[I]);
    If oCompanyDetails.PathMatches(Path) Then
    Begin
      Result := oCompanyDetails.CompanyCode;
      Break;
    End; // If oCompanyDetails.PathMatches (Path)
  End; // For I
End; // CompanyCodeFromPath

//=========================================================================

Initialization
  ResetUNCCompanyCache;
Finalization
  ResetUNCCompanyCache;
End.
