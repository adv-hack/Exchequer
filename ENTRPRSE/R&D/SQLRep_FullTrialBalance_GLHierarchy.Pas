Unit SQLRep_FullTrialBalance_GLHierarchy;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Type
  IFullTrialBalanceGLHierarchyDetails = Interface
    ['{2F1B2C6F-9106-484A-B297-B44F6D5B6E16}']
    // --- Internal Methods to implement Public Properties ---
    Function GetHierarchyCount : Integer;
    Function GetHierarchy(Index : Integer) : LongInt;

    // ------------------ Public Properties ------------------
    Property HierarchyCount : Integer Read GetHierarchyCount;
    Property Hierarchy [Index : Integer] : LongInt Read GetHierarchy;

    // ------------------- Public Methods --------------------
    // Returns TRUE if this hierarchy contains the specified GL Code
    Function Contains (Const GLCode : LongInt) : Boolean;
  End; // IFullTrialBalanceGLHierarchyDetails


// Takes the supplied hierarchy in the format ',10,110,11010,' and breaks it down into a list of the individual GL Codes
Function GetGLHierarchyDetails (Const GLHierarchy : ShortString) : IFullTrialBalanceGLHierarchyDetails;

Implementation

Uses SysUtils;

Type
  TFullTrialBalanceGLHierarchyDetails = Class(TInterfacedObject, IFullTrialBalanceGLHierarchyDetails)
  Private
    FHierarchyGLCodes : Array of LongInt;

    // IFullTrialBalanceGLHierarchyDetails
    Function GetHierarchyCount : Integer;
    Function GetHierarchy(Index : Integer) : LongInt;

    // Returns TRUE if this hierarchy contains the specified GL Code
    Function Contains (Const GLCode : LongInt) : Boolean;
  Public
    Constructor Create (Const GLHierarchy : ShortString);
    Destructor Destroy; Override;
  End; // TFullTrialBalanceGLHierarchyDetails

//=========================================================================

// Takes the supplied hierarchy in the format ',10,110,11010,' and breaks it down into a list of the individual GL Codes
Function GetGLHierarchyDetails (Const GLHierarchy : ShortString) : IFullTrialBalanceGLHierarchyDetails;
Begin // GetGLHierarchyDetails
  Result := TFullTrialBalanceGLHierarchyDetails.Create(GLHierarchy);
End; // GetGLHierarchyDetails

//=========================================================================

Constructor TFullTrialBalanceGLHierarchyDetails.Create (Const GLHierarchy : ShortString);
Var
  sNumber : ShortString;
  iNumber, I : LongInt;
  InNumber : Boolean;
Begin // Create
  Inherited Create;

  // Takes the supplied hierarchy in the format ',10,110,11010,' and breaks it down into a list of the individual GL Codes
  FHierarchyGLCodes := NIL;
  If (GLHierarchy <> '') Then
  Begin
    sNumber := '';
    InNumber := False;

    // Run through the string character by character
    For I := 1 To Length(GLHierarchy) Do
    Begin
      // Accumulate numeric chars in a string to be converted once we hit a non-numeric char
      If (GLHierarchy[I] In ['0'..'9']) Then
      Begin
        sNumber := sNumber + GLHierarchy[I];
        InNumber := True;
      End // If (GLHierarchy In ['0'..'9'])
      Else
      Begin
        // If we have been processing a series of numeric chars then convert it to a number and
        // add it into the array
        If InNumber Then
        Begin
          iNumber := StrToIntDef(sNumber, -1);
          If (iNumber <> -1) Then
          Begin
            // Extend the dynamic array and add the new GL Code into the last entry
            SetLength(FHierarchyGLCodes, Length(FHierarchyGLCodes) + 1);
            FHierarchyGLCodes[High(FHierarchyGLCodes)] := iNumber;
          End; // If (iNumber <> -1)

          sNumber := '';
          InNumber := False;
        End; // If InNumber
      End; // Else
    End; // For I
  End; // If (GLHierarchy <> '')
End; // Create

//------------------------------

Destructor TFullTrialBalanceGLHierarchyDetails.Destroy;
Begin // Destroy
  FHierarchyGLCodes := NIL;
End; // Destroy

//-------------------------------------------------------------------------

// Returns TRUE if this hierarchy contains the specified GL Code
Function TFullTrialBalanceGLHierarchyDetails.Contains (Const GLCode : LongInt) : Boolean;
Var
  I : Integer;
Begin // Contains
  Result := False;

  // Check the dynamic array exists and run through the dynamkic array of GL Codes looking for a matching code
  If Assigned(FHierarchyGLCodes) Then
  Begin
    For I := Low(FHierarchyGLCodes) To High(FHierarchyGLCodes) Do
    Begin
      If (FHierarchyGLCodes[I] = GLCode) Then
      Begin
        Result := True;
        Break;
      End; // If (FHierarchyGLCodes[I] = GLCode)
    End; // For I
  End; // If Assigned(FHierarchyGLCodes)
End; // Contains

//-------------------------------------------------------------------------

Function TFullTrialBalanceGLHierarchyDetails.GetHierarchyCount : Integer;
Begin // GetHierarchyCount
  // Check the dynamic array exists
  If Assigned(FHierarchyGLCodes) Then
    Result := Length(FHierarchyGLCodes)
  Else
    Result := 0;
End; // GetHierarchyCount

//------------------------------

Function TFullTrialBalanceGLHierarchyDetails.GetHierarchy(Index : Integer) : LongInt;
Begin // GetHierarchy
  // Check the dynamic array exists and the index is valid
  If Assigned(FHierarchyGLCodes) Then
  Begin
    If (Index >= Low(FHierarchyGLCodes)) And (Index <= High(FHierarchyGLCodes)) Then
      Result := FHierarchyGLCodes[Index]
    Else
      Raise ERangeError.Create ('TFullTrialBalanceGLHierarchyDetails.GetHierarchy: Invalid Index (' + IntToStr(Index) + ')');
  End // If Assigned(FHierarchyGLCodes)
  Else
    Raise ERangeError.Create ('TFullTrialBalanceGLHierarchyDetails.GetHierarchy: Invalid Index (' + IntToStr(Index) + ')');
End; // GetHierarchy

//=========================================================================

End.