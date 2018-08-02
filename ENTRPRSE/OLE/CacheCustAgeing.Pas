Unit CacheCustAgeing;

Interface

Uses Classes, SysUtils, DateUtils;

Type
  TCachedAccountAgeingInfo = Class(TObject)
  Private
    FAgeing : Array [1..5] Of Double;
    FExpiryTime : TDateTime;
    Function GetAgePeriod (Index : Byte) : Double;
    Function GetExpired : Boolean;
  Public
    Property AgePeriod [Index : Byte] : Double Read GetAgePeriod;
    Property Expired : Boolean Read GetExpired;

    Constructor Create (Const AgedCat1, AgedCat2, AgedCat3, AgedCat4, AgedCat5 : Double);
  End; // TCachedAccountAgeingInfo

  //------------------------------

  //
  TAccountAgeingCache = Class(TObject)
  Private
    FCachedItems : TStringList;
    Procedure RemoveCache (Const DeleteIdx : LongInt);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure AddToCache (Const AcType, AcCode, AgePeriod, AgedDate : ShortString;
                          Const AgeInterval : SmallInt;
                          Const AgedCat1, AgedCat2, AgedCat3, AgedCat4, AgedCat5 : Double);
    Function BuildAgeingKey (Const AcType, AcCode, AgePeriod, AgedDate : ShortString; Const AgeInterval : SmallInt) : ShortString;
    Function GetAgeing (Const AcType, AcCode, AgePeriod, AgedDate : ShortString; Const AgeInterval : SmallInt) : TCachedAccountAgeingInfo;
  End; // TAccountAgeingCache


Implementation

Uses BTKeys1U;

//=========================================================================

Constructor TCachedAccountAgeingInfo.Create (Const AgedCat1, AgedCat2, AgedCat3, AgedCat4, AgedCat5 : Double);
Begin // Create
  Inherited Create;

  FAgeing[1] := AgedCat1;
  FAgeing[2] := AgedCat2;
  FAgeing[3] := AgedCat3;
  FAgeing[4] := AgedCat4;
  FAgeing[5] := AgedCat5;
  FExpiryTime := IncSecond(Now, 3600); // 1 hour
  //FExpiryTime := IncSecond(Now, 300);  // 5 minutes
End; // Create

//-------------------------------------------------------------------------

Function TCachedAccountAgeingInfo.GetAgePeriod (Index : Byte) : Double;
Begin // GetAgePeriod
  If (Index >= Low(FAgeing)) And (Index <= High(FAgeing)) Then
    Result := FAgeing[Index]
  Else
    Raise Exception.Create('TCachedAccountAgeingInfo.GetAgePeriod: Invalid Index (' + IntToStr(Index) + ')');
End; // GetAgePeriod

//------------------------------

Function TCachedAccountAgeingInfo.GetExpired : Boolean;
Begin // GetExpired
  Result := (Now > FExpiryTime);
End; // GetExpired

//=========================================================================

Constructor TAccountAgeingCache.Create;
Begin // Create
  Inherited Create;

  FCachedItems := TStringList.Create;
  FCachedItems.CaseSensitive := False;
  FCachedItems.Duplicates := dupIgnore;
  FCachedItems.Sorted := True;
End; // Create

//------------------------------

Destructor TAccountAgeingCache.Destroy;
Begin // Destroy
  // Clear down list of items
  While (FCachedItems.Count > 0) Do
  Begin
    TCachedAccountAgeingInfo(FCachedItems.Objects[0]).Free;
    FCachedItems.Delete(0);
  End; // While (FCachedItems.Count > 0)
  FreeAndNIL(FCachedItems);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TAccountAgeingCache.AddToCache (Const AcType, AcCode, AgePeriod, AgedDate : ShortString;
                                          Const AgeInterval : SmallInt;
                                          Const AgedCat1, AgedCat2, AgedCat3, AgedCat4, AgedCat5 : Double);
Begin // AddToCache
  FCachedItems.AddObject (BuildAgeingKey (AcType, AcCode, AgePeriod, AgedDate, AgeInterval), TCachedAccountAgeingInfo.Create(AgedCat1, AgedCat2, AgedCat3, AgedCat4, AgedCat5));
End; // AddToCache

//-------------------------------------------------------------------------

Function TAccountAgeingCache.BuildAgeingKey (Const AcType, AcCode, AgePeriod, AgedDate : ShortString; Const AgeInterval : SmallInt) : ShortString;
Begin // BuildAgeingKey
  // Build ageing key to include all elements that control the generation of the numbers:-
  //
  //   AcType - Char
  //   AcCode - 6 chars
  //   AgePeriod - 'D'/'M'/'Y'
  //   AgedDate - YYYYMMDD
  //   AgeInterval - 1-255
  //
  // XXXXXX-X-XXXXXXXXXX-XXX

  Result := AcType + FullCustCode(AcCode) + '-' + AgePeriod[1] + '-' + AgedDate + '-' + Format('%3.3d', [AgeInterval]);
End; // BuildAgeingKey

//-------------------------------------------------------------------------

// Separate function so profiling can pick it up
Procedure TAccountAgeingCache.RemoveCache (Const DeleteIdx : LongInt);
Begin // RemoveCache
  FCachedItems.Delete(DeleteIdx);
End; // RemoveCache

//------------------------------

Function TAccountAgeingCache.GetAgeing (Const AcType, AcCode, AgePeriod, AgedDate : ShortString; Const AgeInterval : SmallInt) : TCachedAccountAgeingInfo;
Var
  sAgeingKey : ShortString;
  Idx : LongInt;
Begin // GetAgeing
  // Get formatted ageing key to lookup cached data
  sAgeingKey := BuildAgeingKey (AcType, AcCode, AgePeriod, AgedDate, AgeInterval);

  // Lookup cached data
  Idx := FCachedItems.IndexOf(sAgeingKey);
  If (Idx >= 0) Then
  Begin
    Result := TCachedAccountAgeingInfo(FCachedItems.Objects[Idx]);

    // Check cache expiry
    If Result.Expired Then
    Begin
      RemoveCache(Idx);
      Result := NIL;
    End; // If Result.Expired
  End // If (Idx >= 0)
  Else
    Result := NIL;
End; // GetAgeing

//-------------------------------------------------------------------------


End.