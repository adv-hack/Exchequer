Unit CacheNomCodes;

Interface

Uses Classes, SysUtils, DB, oCacheDataRecord;

Type
  // Cache for Nominal Code records
  TNominalCodeCache = Class(TObject)
  Private
    FCachedItems : TStringList;
    Procedure RemoveCache (Const DeleteIdx : LongInt);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure AddToCache (Const Code : LongInt; Const RecPtr : Pointer; Const RecSize : LongInt);
    Function BuildCacheKey (Const Code : LongInt) : ShortString;
    Function GetNominalCode (Const Code : LongInt) : TCachedDataRecord;

    // MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
    Procedure SQLPreload (Const CompanyCode : ShortString);
  End; // TNominalCodeCache


Implementation

Uses BTKeys1U, SQLUtils, SQLCallerU, SQLRep_Config, EntLoggerClass, GlobVar, VarConst;

//=========================================================================

Constructor TNominalCodeCache.Create;
Begin // Create
  Inherited Create;

  FCachedItems := TStringList.Create;
  FCachedItems.CaseSensitive := False;
  FCachedItems.Duplicates := dupIgnore;
  FCachedItems.Sorted := True;
End; // Create

//------------------------------

Destructor TNominalCodeCache.Destroy;
Begin // Destroy
  // Clear down list of items
  While (FCachedItems.Count > 0) Do
  Begin
    TCachedDataRecord(FCachedItems.Objects[0]).Free;
    FCachedItems.Delete(0);
  End; // While (FCachedItems.Count > 0)
  FreeAndNIL(FCachedItems);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// MH 19/08/2013 v7.0.6 ABSEXCH-14534: Added pre-load to OLE Server's Internal GL/CC/Dept Caching
Procedure TNominalCodeCache.SQLPreload (Const CompanyCode : ShortString);
Var
  sqlCaller : TSQLCaller;
  oReportLogger : TEntSQLReportLogger;
  sConnectionString, sQuery, lPassword: WideString;
  NomR : NominalRec;

  fldGLCode, fldGLParent, fldGLCarryFwd, fldGLPrivateRec, fldGLCurrency, fldGLInactive, fldGLClass : TIntegerField;
  fldGLName, fldGLType, fldGLAltCode, fldGLNomStrParam : TStringField;
  fldGLPage, fldGLSubtotal, fldGLTotal, fldGLRevalue, fldGLForceJobCode : TBooleanField;
Begin // SQLPreload
  // Get Company Admin Connection String
  //If (GetConnectionString(CompanyCode, False, sConnectionString) = 0) Then
  //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords	
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
        sQuery := 'Select glCode, glName, glParent, glType, glPage, glSubtotal, glTotal, ' +
                         'glCarryFwd, glRevalue, glAltCode, glPrivateRec, glCurrency, ' +
                         'glForceJobCode, glInactive, glClass, glNomStr ' +
                  '  From [COMPANY].Nominal ' +
                  'Order By glNomStr';
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
              fldGLCode         := sqlCaller.Records.FieldByName('glCode') As TIntegerField;
              fldGLName         := sqlCaller.Records.FieldByName('glName') As TStringField;
              fldGLParent       := sqlCaller.Records.FieldByName('glParent') As TIntegerField;
              fldGLType         := sqlCaller.Records.FieldByName('glType') As TStringField;
              fldGLPage         := sqlCaller.Records.FieldByName('glPage') As TBooleanField;
              fldGLSubtotal     := sqlCaller.Records.FieldByName('glSubtotal') As TBooleanField;
              fldGLTotal        := sqlCaller.Records.FieldByName('glTotal') As TBooleanField;
              fldGLCarryFwd     := sqlCaller.Records.FieldByName('glCarryFwd') As TIntegerField;
              fldGLRevalue      := sqlCaller.Records.FieldByName('glRevalue') As TBooleanField;
              fldGLAltCode      := sqlCaller.Records.FieldByName('glAltCode') As TStringField;
              fldGLPrivateRec   := sqlCaller.Records.FieldByName('glPrivateRec') As TIntegerField;
              fldGLCurrency     := sqlCaller.Records.FieldByName('glCurrency') As TIntegerField;
              fldGLForceJobCode := sqlCaller.Records.FieldByName('glForceJobCode') As TBooleanField;
              fldGLInactive     := sqlCaller.Records.FieldByName('glInactive') As TIntegerField;
              fldGLClass        := sqlCaller.Records.FieldByName('glClass') As TIntegerField;
              fldGLNomStrParam  := sqlCaller.Records.FieldByName('glNomStr') As TStringField;

              // Disable the sorting on the StringList whilst we are populating it to improve
              // performance, the Order By clause should cause the items to be added in the
              // correct order
              FCachedItems.Sorted := False;
              Try
                While (Not sqlCaller.Records.EOF) Do
                Begin
                  // Extract the data from the dataset and build an Exchequer Nominal record
                  FillChar (NomR, SizeOf(NomR), #0);
                  NomR.NomCode    := fldGLCode.Value;
                  NomR.Desc       := fldGLName.Value;
                  NomR.Cat        := fldGLParent.Value;
                  NomR.NomType    := fldGLType.Value[1];
                  NomR.NomPage    := fldGLPage.Value;
                  NomR.SubType    := fldGLSubtotal.Value;
                  NomR.Total      := fldGLTotal.Value;
                  NomR.CarryF     := fldGLCarryFwd.Value;
                  NomR.ReValue    := fldGLRevalue.Value;
                  NomR.AltCode    := fldGLAltCode.Value;
                  NomR.PrivateRec := fldGLPrivateRec.Value;
                  NomR.DefCurr    := fldGLCurrency.Value;
                  NomR.ForceJC    := fldGLForceJobCode.Value;
                  NomR.HideAC     := fldGLInactive.Value;
                  NomR.NomClass   := fldGLClass.Value;
                  NomR.NomCodeStr := fldGLNomStrParam.Value;

                  // Add it into the cache
                  AddToCache (NomR.NomCode, @NomR, SizeOf(NomR));

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

Procedure TNominalCodeCache.AddToCache (Const Code : LongInt; Const RecPtr : Pointer; Const RecSize : LongInt);
Begin // AddToCache
  FCachedItems.AddObject (BuildCacheKey (Code), TCachedDataRecord.Create(RecPtr, RecSize));
End; // AddToCache

//-------------------------------------------------------------------------

Function TNominalCodeCache.BuildCacheKey (Const Code : LongInt) : ShortString;
Begin // BuildAgeingKey
  Result := IntToStr(Code);
End; // BuildAgeingKey

//-------------------------------------------------------------------------

// Separate function so profiling can pick it up
Procedure TNominalCodeCache.RemoveCache (Const DeleteIdx : LongInt);
Begin // RemoveCache
  FCachedItems.Delete(DeleteIdx);
End; // RemoveCache

//------------------------------

Function TNominalCodeCache.GetNominalCode (Const Code : LongInt) : TCachedDataRecord;
Var
  sCacheKey : ShortString;
  Idx : LongInt;
Begin // GetNominalCode
  // Get formatted key to lookup cached data
  sCacheKey := BuildCacheKey (Code);

  // Lookup cached data
  Idx := FCachedItems.IndexOf(sCacheKey);
  If (Idx >= 0) Then
  Begin
    Result := TCachedDataRecord(FCachedItems.Objects[Idx]);

    // Check cache expiry
    If Result.Expired Then
    Begin
      RemoveCache(Idx);
      Result := NIL;
    End; // If Result.Expired
  End // If (Idx >= 0)
  Else
    Result := NIL;
End; // GetNominalCode

//-------------------------------------------------------------------------


End.