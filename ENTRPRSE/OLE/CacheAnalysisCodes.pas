Unit CacheAnalysisCodes;

Interface

Uses Classes, SysUtils, DB, oCacheDataRecord;

Type
  // Cache for Analysis Code records
  TAnalysisCodeCache = Class(TObject)
  Private
    FCachedItems : TStringList;
    Procedure RemoveCache (Const DeleteIdx : LongInt);
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure SQLPreload (Const CompanyCode : ShortString);

    Procedure AddToCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
    Function BuildCacheKey (Const Code : ShortString) : ShortString;
    Function GetAnalysisCode (Const Code : ShortString) : TCachedDataRecord;
    Procedure UpdateCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
  End; // TAnalysisCodeCache

Implementation

Uses BTKeys1U, SQLUtils, SQLCallerU, SQLRep_Config, EntLoggerClass, GlobVar, VarConst;

//=========================================================================

Constructor TAnalysisCodeCache.Create;
Begin // Create
  Inherited Create;

  FCachedItems := TStringList.Create;
  FCachedItems.CaseSensitive := False;
  FCachedItems.Duplicates := dupIgnore;
  FCachedItems.Sorted := True;
End; // Create

//------------------------------

Destructor TAnalysisCodeCache.Destroy;
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

Procedure TAnalysisCodeCache.SQLPreload (Const CompanyCode : ShortString);
Var
  sqlCaller : TSQLCaller;
  oReportLogger : TEntSQLReportLogger;
  sConnectionString, sQuery, lPassword: WideString;  //VA:29/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords	
  AnalR : JobMiscRec;

  fldAnalCode: TMemoField;
  fldAnalName, fldCISTaxRate, fldJAPayCode : TStringField;
  fldJATag, fldJACalcB4Ret, fldJARetPres : TBooleanField;
  fldUpliftP, fldJADeduct, fldJARetValue : TFloatField;
  fldJAType, fldWIPNom1, fldWIPNom2, fldAnalHed, fldJLinkLT : TIntegerField;
  fldUpliftGL, fldRevenueType, fldJADetType, fldJADedApply : TIntegerField;
  fldJARetType, fldJARetExp, fldJARetExpInt, fldJADedComp : TIntegerField;
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
        // Get the details of the Analysis Code Records for the cache
        sQuery := 'Select var_code1Trans1 As ''AnalysisCode'', JAName, JAType, WIPNom1, WIPNom2, ' +
                         'AnalHed, JATag, JLinkLT, CISTaxRate, UpliftP, UpliftGL, RevenueType, ' +
                         'JADetType, JACalcB4Ret, JADeduct, JADedApply, JARetType, JARetValue, ' +
                         'JARetExp, JARetExpInt, JARetPres, JADedComp, JAPayCode ' +
                    'From [COMPANY].JobMisc ' +
                   'Where (RecPfix = ''J'') And (SubType = ''A'') ' +
                  'Order By AnalysisCode';

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
              fldAnalCode     := sqlCaller.Records.FieldByName('AnalysisCode') As TMemoField;
              fldAnalName     := sqlCaller.Records.FieldByName('JAName') As TStringField;
              fldJAType       := sqlCaller.Records.FieldByName('JAType') As TIntegerField;
              fldWIPNom1      := sqlCaller.Records.FieldByName('WIPNom1') As TIntegerField;
              fldWIPNom2      := sqlCaller.Records.FieldByName('WIPNom2') As TIntegerField;
              fldAnalHed      := sqlCaller.Records.FieldByName('AnalHed') As TIntegerField;
              fldJATag        := sqlCaller.Records.FieldByName('JATag') As TBooleanField;
              fldJLinkLT      := sqlCaller.Records.FieldByName('JLinkLT') As TIntegerField;
              fldCISTaxRate   := sqlCaller.Records.FieldByName('CISTaxRate') As TStringField;
              fldUpliftP      := sqlCaller.Records.FieldByName('UpliftP') As TFloatField;
              fldUpliftGL     := sqlCaller.Records.FieldByName('UpliftGL') As TIntegerField;
              fldRevenueType  := sqlCaller.Records.FieldByName('RevenueType') As TIntegerField;
              fldJADetType    := sqlCaller.Records.FieldByName('JADetType') As TIntegerField;
              fldJACalcB4Ret  := sqlCaller.Records.FieldByName('JACalcB4Ret') As TBooleanField;
              fldJADeduct     := sqlCaller.Records.FieldByName('JADeduct') As TFloatField;
              fldJADedApply   := sqlCaller.Records.FieldByName('JADedApply') As TIntegerField;
              fldJARetType    := sqlCaller.Records.FieldByName('JARetType') As TIntegerField;
              fldJARetValue   := sqlCaller.Records.FieldByName('JARetValue') As TFloatField;
              fldJARetExp     := sqlCaller.Records.FieldByName('JARetExp') As TIntegerField;
              fldJARetExpInt  := sqlCaller.Records.FieldByName('JARetExpInt') As TIntegerField;
              fldJARetPres    := sqlCaller.Records.FieldByName('JARetPres') As TBooleanField;
              fldJADedComp    := sqlCaller.Records.FieldByName('JADedComp') As TIntegerField;
              fldJAPayCode    := sqlCaller.Records.FieldByName('JAPayCode') As TStringField;

              // Disable the sorting on the StringList whilst we are populating it to improve
              // performance, the Order By clause should cause the items to be added in the
              // correct order
              FCachedItems.Sorted := False;
              Try
                While (Not sqlCaller.Records.EOF) Do
                Begin
                  // Extract the data from the dataset and build an Exchequer Nominal record
                  FillChar (AnalR, SizeOf(AnalR), #0);
                  AnalR.RecPFix := 'J';
                  AnalR.SubType := 'A';

                  AnalR.JobAnalRec.JAnalCode    := FullJACode(fldAnalCode.Value);
                  AnalR.JobAnalRec.JAnalName    := fldAnalName.Value;
                  AnalR.JobAnalRec.JANameCode   := UpperCase(AnalR.JobAnalRec.JAnalName);
                  AnalR.JobAnalRec.JAType       := fldJAType.Value;
                  AnalR.JobAnalRec.WIPNom[BOff] := fldWIPNom1.Value;
                  AnalR.JobAnalRec.WIPNom[BOn]  := fldWIPNom2.Value;
                  AnalR.JobAnalRec.AnalHed      := fldAnalHed.Value;
                  AnalR.JobAnalRec.JATag        := fldJATag.Value;
                  AnalR.JobAnalRec.JLinkLT      := fldJLinkLT.Value;
                  If (fldCISTaxRate.Value <> '') Then
                    AnalR.JobAnalRec.CISTaxRate   := fldCISTaxRate.Value[1];
                  AnalR.JobAnalRec.UpliftP      := fldUpliftP.Value;
                  AnalR.JobAnalRec.UpliftGL     := fldUpliftGL.Value;
                  AnalR.JobAnalRec.RevenueType  := fldRevenueType.Value;
                  AnalR.JobAnalRec.JADetType    := fldJADetType.Value;
                  AnalR.JobAnalRec.JACalcB4Ret  := fldJACalcB4Ret.Value;
                  AnalR.JobAnalRec.JADeduct     := fldJADeduct.Value;
                  AnalR.JobAnalRec.JADedApply   := fldJADedApply.Value;
                  AnalR.JobAnalRec.JARetType    := fldJARetType.Value;
                  AnalR.JobAnalRec.JARetValue   := fldJARetValue.Value;
                  AnalR.JobAnalRec.JARetExp     := fldJARetExp.Value;
                  AnalR.JobAnalRec.JARetExpInt  := fldJARetExpInt.Value;
                  AnalR.JobAnalRec.JARetPres    := fldJARetPres.Value;
                  AnalR.JobAnalRec.JADedComp    := fldJADedComp.Value;
                  AnalR.JobAnalRec.JAPayCode    := fldJAPayCode.Value;

                  // Add it into the cache
                  AddToCache (AnalR.JobAnalRec.JAnalCode, @AnalR, SizeOf(AnalR));

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

Procedure TAnalysisCodeCache.AddToCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
Begin // AddToCache
  FCachedItems.AddObject (BuildCacheKey (Code), TCachedDataRecord.Create(RecPtr, RecSize));
End; // AddToCache

//-------------------------------------------------------------------------

Procedure TAnalysisCodeCache.UpdateCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
Var
  Idx : LongInt;
Begin // UpdateCache
  // Look for a pre-existing cache object to remove
  Idx := FCachedItems.IndexOf(BuildCacheKey (Code));
  If (Idx >= 0) Then
    RemoveCache(Idx);

  // Add the updated data back into the cache
  AddToCache (Code, RecPtr, RecSize);
End; // UpdateCache

//-------------------------------------------------------------------------

Function TAnalysisCodeCache.BuildCacheKey (Const Code : ShortString) : ShortString;
Begin // BuildCacheKey
  Result := FullJACode(Code);
End; // BuildCacheKey

//-------------------------------------------------------------------------

// Separate function so profiling can pick it up
Procedure TAnalysisCodeCache.RemoveCache (Const DeleteIdx : LongInt);
Begin // RemoveCache
  FCachedItems.Delete(DeleteIdx);
End; // RemoveCache

//------------------------------

Function TAnalysisCodeCache.GetAnalysisCode (Const Code : ShortString) : TCachedDataRecord;
Var
  sCacheKey : ShortString;
  Idx : LongInt;
Begin // GetAnalysisCode
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
End; // GetAnalysisCode

//=========================================================================

End.
