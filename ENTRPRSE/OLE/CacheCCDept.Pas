Unit CacheCCDept;

Interface

Uses Classes, Math, SysUtils, DateUtils, DB;

Type
  TCachedCostCentreDepartmentInfo = Class(TObject)
  Private
    FCode : ShortString;
    FExpiryTime : TDateTime;
    Function GetExpired : Boolean;
  Public
    Property Code : ShortString Read FCode;
    Property Expired : Boolean Read GetExpired;

    Constructor Create (Const Code : ShortString);
  End; // TCachedCostCentreDepartmentInfo

  //------------------------------

  TCostCentreDepartmentCacheType = (ccdCostCentre, ccdDepartment);

  //
  TCostCentreDepartmentCache = Class(TObject)
  Private
    FCachedItems : TStringList;
    FCacheType : TCostCentreDepartmentCacheType;
    Procedure RemoveCache (Const DeleteIdx : LongInt);
  Public
    Constructor Create (Const CacheType : TCostCentreDepartmentCacheType);
    Destructor Destroy; Override;

    Procedure AddToCache (Const Code : ShortString);
    Function BuildCacheKey (Const Code : ShortString) : ShortString;
    Function GetCCDept (Const Code : ShortString) : TCachedCostCentreDepartmentInfo;

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    Procedure SQLPreload (Const CompanyCode : ShortString);
  End; // TCostCentreDepartmentCache


Implementation

Uses BTKeys1U, SQLUtils, SQLCallerU, SQLRep_Config, EntLoggerClass;

//=========================================================================

Constructor TCachedCostCentreDepartmentInfo.Create (Const Code : ShortString);
Begin // Create
  Inherited Create;

  FCode := Code;
  FExpiryTime := IncSecond(Now, 3600); // 1 hour
  //FExpiryTime := IncSecond(Now, 300);  // 5 minutes
End; // Create

//-------------------------------------------------------------------------

Function TCachedCostCentreDepartmentInfo.GetExpired : Boolean;
Begin // GetExpired
  Result := (Now > FExpiryTime);
End; // GetExpired

//=========================================================================

Constructor TCostCentreDepartmentCache.Create (Const CacheType : TCostCentreDepartmentCacheType);
Begin // Create
  Inherited Create;

  FCacheType := CacheType;

  FCachedItems := TStringList.Create;
  FCachedItems.CaseSensitive := False;
  FCachedItems.Duplicates := dupIgnore;
  FCachedItems.Sorted := True;
End; // Create

//------------------------------

Destructor TCostCentreDepartmentCache.Destroy;
Begin // Destroy
  // Clear down list of items
  While (FCachedItems.Count > 0) Do
  Begin
    TCachedCostCentreDepartmentInfo(FCachedItems.Objects[0]).Free;
    FCachedItems.Delete(0);
  End; // While (FCachedItems.Count > 0)
  FreeAndNIL(FCachedItems);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
Procedure TCostCentreDepartmentCache.SQLPreload (Const CompanyCode : ShortString);
Var
  sqlCaller : TSQLCaller;
  oReportLogger : TEntSQLReportLogger;
  sConnectionString, sQuery, lPassword: WideString;
  // MH 10/06/2014 v7.0.11 ABSEXCH-15424: Changed type to TMemoField due to DB change
  fldCode : TMemoField;
Begin // SQLPreload
  // Get Company Admin Connection String
  //If (GetConnectionString(CompanyCode, False, sConnectionString) = 0) Then

  //VA:29/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords	
  If (GetConnectionStringWOPass(CompanyCode, False, sConnectionString, lPassword) = 0) Then
  Begin
    // Create SQL Query object to use for query
    sqlCaller := TSQLCaller.Create;
    Try
      sqlCaller.ConnectionString := sConnectionString;
      sqlCaller.Connection.Password := lPassword;
      sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;

      oReportLogger := TEntSQLReportLogger.Create('OLEPreload');
      Try
        // Get the details of the Nominal Code Records for the cache
        sQuery := 'Select EXCHQCHKcode1Trans1 AS ''Code'' ' +
                  '  From [COMPANY].ExchqChk ' +
                  ' Where (RecPfix = ''C'') AND (SubType = ' + IntToStr(IfThen(FCacheType=ccdCostCentre, 67, 68)) + ') ' +
                  'Order By [Code]';
        oReportLogger.StartQuery(sQuery);
        sqlCaller.Select(sQuery, CompanyCode);
        oReportLogger.FinishQuery;
        If (sqlCaller.ErrorMsg = '') Then
        Begin
          If (sqlCaller.Records.RecordCount > 0) Then
          Begin
            // Disable the link to the UI to improve performance when iterating through the dataset
            sqlCaller.Records.DisableControls;
            Try
              oReportLogger.QueryRowCount(sqlCaller.Records.RecordCount);

              // Get the first row so we can setup the fields
              sqlCaller.Records.First;

              // Use typecast references to the fields to avoid variant performance hits
              // MH 10/06/2014 v7.0.11 ABSEXCH-15424: Changed type to TMemoField due to DB change
              //fldCode := sqlCaller.Records.FieldByName('Code') As TStringField;
              fldCode := sqlCaller.Records.FieldByName('Code') As TMemoField;

              // Disable the sorting on the StringList whilst we are populating it to improve
              // performance, the Order By clause should cause the items to be added in the
              // correct order
              FCachedItems.Sorted := False;
              Try
                While (Not sqlCaller.Records.EOF) Do
                Begin
                  // Add it into the cache
                  AddToCache (fldCode.Value);

                  sqlCaller.Records.Next;
                End; // While (Not sqlCaller.Records.EOF)
              Finally
                FCachedItems.Sorted := True;
              End; // Try..Finally
            Finally
              sqlCaller.Records.EnableControls;
            End; // Try..Finally
          End; // If (sqlCaller.Records.RecordCount > 0)
        End // If (sqlCaller.ErrorMsg = '')
        Else
        Begin
          oReportLogger.LogError('Query Error', sqlCaller.ErrorMsg);
        End; // Else
      Finally
        FreeAndNIL(oReportLogger);
      End; // Try..Finally
    Finally
      sqlCaller.Free;
    End; // Try..Finally
  End; // If (GetConnectionString(CompanyCode, False, ConnectionString) = 0)
End; // SQLPreload

//-------------------------------------------------------------------------

Procedure TCostCentreDepartmentCache.AddToCache (Const Code : ShortString);
Begin // AddToCache
  FCachedItems.AddObject (BuildCacheKey (Code), TCachedCostCentreDepartmentInfo.Create(Code));
End; // AddToCache

//-------------------------------------------------------------------------

Function TCostCentreDepartmentCache.BuildCacheKey (Const Code : ShortString) : ShortString;
Begin // BuildAgeingKey
  Result := FullCCDepKey(UpperCase(Code));  // NOTE: FullCCDepKey doesn't convert to upper case
End; // BuildAgeingKey

//-------------------------------------------------------------------------

// Separate function so profiling can pick it up
Procedure TCostCentreDepartmentCache.RemoveCache (Const DeleteIdx : LongInt);
Begin // RemoveCache
  FCachedItems.Delete(DeleteIdx);
End; // RemoveCache

//------------------------------

Function TCostCentreDepartmentCache.GetCCDept (Const Code : ShortString) : TCachedCostCentreDepartmentInfo;
Var
  sCacheKey : ShortString;
  Idx : LongInt;
Begin // GetCCDept
  // Get formatted key to lookup cached data
  sCacheKey := BuildCacheKey (Code);

  // Lookup cached data
  Idx := FCachedItems.IndexOf(sCacheKey);
  If (Idx >= 0) Then
  Begin
    Result := TCachedCostCentreDepartmentInfo(FCachedItems.Objects[Idx]);

    // Check cache expiry
    If Result.Expired Then
    Begin
      RemoveCache(Idx);
      Result := NIL;
    End; // If Result.Expired
  End // If (Idx >= 0)
  Else
    Result := NIL;
End; // GetCCDept

//-------------------------------------------------------------------------


End.