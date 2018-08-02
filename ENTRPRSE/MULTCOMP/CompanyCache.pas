unit CompanyCache;

// Cache of company details used by the company list to store the
// details of checks on the directory

interface

Uses Classes, DateUtils, SysUtils, GlobVar, VarConst, BtrvU2;

type
  TCompanyDetails = Class(TObject)
  Private
    FCacheTime : TDateTime;
    FCompDets  : CompanyDetRec;

    Function GetCompDets : CompanyDetRec;
  Public
    Property CompDets : CompanyDetRec Read GetCompDets;

    Constructor Create;

    // Updates the cached details, analyses the directory, etc...
    Procedure CheckForUpdates (Var CompanyDetails : CompanyDetRec);
  End; // TCompanyDetails

  //------------------------------

  TCompanyInfoCache = Class(TStringList)
  Private
    Function GetCompanyCodeDetailsByCode (Index : ShortString) : TCompanyDetails;
  Public
    // Returns a company details object from the code ordered list with the specified code
    Property CompanyCodeDetailsByCode [Index : ShortString] : TCompanyDetails Read GetCompanyCodeDetailsByCode;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure Clear; Override;

    // Returns TRUE if the company details already exist in the cache
    Function CompanyExists (Index : ShortString) : Boolean;

    // Returns the complete company details if cached, or adds them into the cache
    // if not present.  If the details have been there too long then the details are
    // updated automatically
    Procedure GetCompanyDetails (Var CompanyDetails : CompanyDetRec);
  End; // TCompanyInfoCache

implementation

Uses ChkComp, Dialogs,
     SavePos,         // Object encapsulating the btrieve saveposition/restoreposition functions
     BTKeys1U;

//=========================================================================

Constructor TCompanyDetails.Create;
Begin // Create
  Inherited Create;
  FCacheTime := Now;
End; // Create

//-------------------------------------------------------------------------

Function TCompanyDetails.GetCompDets : CompanyDetRec;
Begin // GetCompDets
  Result := FCompDets;
End; // GetCompDets

//-------------------------------------------------------------------------

// Updates the cached details, analyses the directory, etc...
Procedure TCompanyDetails.CheckForUpdates (Var CompanyDetails : CompanyDetRec);
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // CheckForUpdates
  If (FCacheTime <= Now) Then
  Begin
    // Expired - update details completely
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the group file for the current key
        SaveFilePosition (CompF, GetPosKey);
        SaveDataBlock (Company, SizeOf(Company^));

        //------------------------------

        // Try to read the Company record from the DB to pickup the latest changes
        sKey := FullCompCodeKey (cmCompDet, CompanyDetails.CompCode);
        iStatus := Find_Rec(B_GetEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, sKey);
        If (iStatus = 0) Then
        Begin
          FCompDets := Company^.CompDet;
        End // If (iStatus = 0)
        Else
        Begin
          FCompDets := CompanyDetails;
        End; // Else

        // Analyse the company for problems
        CheckCompanyDir (FCompDets);

        // Record the expiry time for the details we are about to cache
        FCacheTime := IncMinute (Now, 2);

        //------------------------------

        // Restore position in group file
        RestoreSavedPosition;
        RestoreDataBlock (Company);
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create
  End; // If (FCacheTime <= Now)

  // Return an updated CompanyDetails record
  CompanyDetails.CompName := FCompDets.CompName;    // needed for Bureau Module
  CompanyDetails.CompPath := FCompDets.CompPath;    // needed for Bureau Module
  CompanyDetails.CompId := FCompDets.CompId;
  CompanyDetails.CompDemoSys := FCompDets.CompDemoSys;
  CompanyDetails.CompTKUCount := FCompDets.CompTKUCount;
  CompanyDetails.CompTrdUCount := FCompDets.CompTrdUCount;
  CompanyDetails.CompSysESN := FCompDets.CompSysESN;
  CompanyDetails.CompModId := FCompDets.CompModId;
  CompanyDetails.CompModSynch := FCompDets.CompModSynch;
  CompanyDetails.CompUCount := FCompDets.CompUCount;
  CompanyDetails.CompAnal := FCompDets.CompAnal;
End; // CheckForUpdates

//=========================================================================

// Loads the list with the company details
Constructor TCompanyInfoCache.Create;
Begin // Create
  Inherited Create;

End; // Create

//------------------------------

Destructor TCompanyInfoCache.Destroy;
Begin // Destroy
  // Destroy the objects in the list
  Clear;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TCompanyInfoCache.Clear;
Var
  CompObj : TCompanyDetails;
  I       : SmallInt;
Begin // Clear
//ShowMessage ('TCompanyInfoCache.Clear');

  // Run through the sub-items and remove all the objects from them

  (*
  For I := 0 To Count - 1 Do
  Begin
    CompObj := TCompanyDetails(Objects[I]);
    CompObj.Free;
  End; // For I

  Inherited Clear;
  *)

  While (Count > 0) Do
  Begin
    CompObj := TCompanyDetails(Objects[0]);
    CompObj.Free;
    Delete(0);
  End; // While (Strings.Count > 0)

//ShowMessage ('TCompanyInfoCache.Clear.Fini');
End; // Clear

//-------------------------------------------------------------------------

// Returns the complete company details if cached, or adds them into the cache
// if not present.  If the details have been there too long then the details are
// updated automatically
Procedure TCompanyInfoCache.GetCompanyDetails (Var CompanyDetails : CompanyDetRec);
Var
  CompObj : TCompanyDetails;
  CompIdx : SmallInt;
Begin // TCompanyInfoCache
  // Look to see if the details are already cached
  CompIdx := IndexOf (Trim(CompanyDetails.CompCode));
//ShowMessage ('TCompanyInfoCache.GetCompanyDetails(' + CompanyDetails.CompCode + ') : ' + IntToStr(CompIdx));
  If (CompIdx >= 0) And (CompIdx < Count) Then
  Begin
    // Yes - Get the details from the cache
    CompObj := TCompanyDetails(Objects[CompIdx]);
  End //
  Else
  Begin
    // No - Create a new entry in the cache
    CompObj := TCompanyDetails.Create;
    AddObject (Trim(CompanyDetails.CompCode), CompObj);
  End;

  // Check whether the details are up to date
  CompObj.CheckForUpdates (CompanyDetails);
End; // TCompanyInfoCache

//-------------------------------------------------------------------------

// Finds and returns the Company object for the specified Code
Function TCompanyInfoCache.GetCompanyCodeDetailsByCode (Index : ShortString) : TCompanyDetails;
Var
  CompIdx : SmallInt;
Begin // GetCompanyCodeDetailsByCode
  CompIdx := IndexOf (Trim(Index));
  If (CompIdx >= 0) And (CompIdx < Count) Then
  Begin
    Result := TCompanyDetails(Objects[CompIdx]);
  End // If (CompIdx >= 0) And (CompIdx < Count)
  Else
  Begin
     Raise Exception.Create ('TCompanyList.GetCompanyCodeDetailsByCode: Invalid Code (' + Index + ') when reading CompanyDetails array');
  End; // Else
End; // GetCompanyCodeDetailsByCode

//-------------------------------------------------------------------------

// Returns TRUE if the company details already exist in the cache
Function TCompanyInfoCache.CompanyExists (Index : ShortString) : Boolean;
Begin // CompanyExists
  Result := (IndexOf (Trim(Index)) <> -1);
End; // CompanyExists

//=========================================================================

end.
