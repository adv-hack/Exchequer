Unit CacheJobCodes;

Interface

Uses Classes, SysUtils, DB, oCacheDataRecord;

Type
  // Cache for Job Code records
  TJobCodeCache = Class(TObject)
  Private
    FCachedItems : TStringList;
    Procedure RemoveCache (Const DeleteIdx : LongInt);
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure SQLPreload (Const CompanyCode : ShortString);

    Procedure AddToCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
    Function BuildCacheKey (Const Code : ShortString) : ShortString;
    Function GetJobCode (Const Code : ShortString) : TCachedDataRecord;
    Procedure UpdateCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
  End; // TJobCodeCache

Implementation

Uses BTKeys1U, SQLUtils, SQLCallerU, SQLRep_Config, EntLoggerClass, GlobVar, VarConst;

//=========================================================================

Constructor TJobCodeCache.Create;
Begin // Create
  Inherited Create;

  FCachedItems := TStringList.Create;
  FCachedItems.CaseSensitive := False;
  FCachedItems.Duplicates := dupIgnore;
  FCachedItems.Sorted := True;
End; // Create

//------------------------------

Destructor TJobCodeCache.Destroy;
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

Procedure TJobCodeCache.SQLPreload (Const CompanyCode : ShortString);
Var
  sqlCaller : TSQLCaller;
  oReportLogger : TEntSQLReportLogger;
  sConnectionString, sQuery, lPassword: WideString;
  JobR : JobRecType;

  fldJobCode, fldJobDesc, fldCustCode, fldJobCat, fldJobAltCode, fldContact, fldJobMan,
  fldStartDate, fldEndDate, fldRevEDate, fldSORRef, fldVATCode, fldDepartment,
  fldCostCentre, fldJobAnal, fldJobType, fldUserDef1, fldUserDef2, fldUserDef3, fldUserDef4,
  fldJPTOurRef, fldJSTOurRef, fldJQSCode, fldUserDef5, fldUserDef6, fldUserDef7, fldUserDef8,
  fldUserDef9, fldUserDef10 : TStringField;
  fldJobFolio, fldCompleted, fldChargeType, fldCurrPrice, fldNLineCount, fldALineCount, fldJobStat, fldDefRetCurr : TIntegerField;
  fldQuotePrice : TFloatField;
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
        // Get the details of the Job Code Records for the cache
        sQuery := 'Select JobCode, JobDesc, JobFolio, CustCode, JobCat, JobAltCode, Completed, ' +
                         'Contact, JobMan, ChargeType, Spare, QuotePrice, CurrPrice, StartDate, ' +
                         'EndDate, RevEDate, SORRef, NLineCount, ALineCount, Spare3, VATCode, ' +
                         'Department, CostCentre, JobAnal, JobType, JobStat, UserDef1, UserDef2, ' +
                         'UserDef3, UserDef4, DefRetCurr, JPTOurRef, JSTOurRef, JQSCode, UserDef5, ' +
                         'UserDef6, UserDef7, UserDef8, UserDef9, UserDef10 ' +
                    'From [COMPANY].JobHead ' +
                  'Order By JobCode';

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
              fldJobCode      := sqlCaller.Records.FieldByName('JobCode') As TStringField;
              fldJobDesc      := sqlCaller.Records.FieldByName('JobDesc') As TStringField;
              fldJobFolio     := sqlCaller.Records.FieldByName('JobFolio') As TIntegerField;
              fldCustCode     := sqlCaller.Records.FieldByName('CustCode') As TStringField;
              fldJobCat       := sqlCaller.Records.FieldByName('JobCat') As TStringField;
              fldJobAltCode   := sqlCaller.Records.FieldByName('JobAltCode') As TStringField;
              fldCompleted    := sqlCaller.Records.FieldByName('Completed') As TIntegerField;
              fldContact      := sqlCaller.Records.FieldByName('Contact') As TStringField;
              fldJobMan       := sqlCaller.Records.FieldByName('JobMan') As TStringField;
              fldChargeType   := sqlCaller.Records.FieldByName('ChargeType') As TIntegerField;
              fldQuotePrice   := sqlCaller.Records.FieldByName('QuotePrice') As TFloatField;
              fldCurrPrice    := sqlCaller.Records.FieldByName('CurrPrice') As TIntegerField;
              fldStartDate    := sqlCaller.Records.FieldByName('StartDate') As TStringField;
              fldEndDate      := sqlCaller.Records.FieldByName('EndDate') As TStringField;
              fldRevEDate     := sqlCaller.Records.FieldByName('RevEDate') As TStringField;
              fldSORRef       := sqlCaller.Records.FieldByName('SORRef') As TStringField;
              fldNLineCount   := sqlCaller.Records.FieldByName('NLineCount') As TIntegerField;
              fldALineCount   := sqlCaller.Records.FieldByName('ALineCount') As TIntegerField;
              fldVATCode      := sqlCaller.Records.FieldByName('VATCode') As TStringField;
              fldDepartment   := sqlCaller.Records.FieldByName('Department') As TStringField;
              fldCostCentre   := sqlCaller.Records.FieldByName('CostCentre') As TStringField;
              fldJobAnal      := sqlCaller.Records.FieldByName('JobAnal') As TStringField;
              fldJobType      := sqlCaller.Records.FieldByName('JobType') As TStringField;
              fldJobStat      := sqlCaller.Records.FieldByName('JobStat') As TIntegerField;
              fldUserDef1     := sqlCaller.Records.FieldByName('UserDef1') As TStringField;
              fldUserDef2     := sqlCaller.Records.FieldByName('UserDef2') As TStringField;
              fldUserDef3     := sqlCaller.Records.FieldByName('UserDef3') As TStringField;
              fldUserDef4     := sqlCaller.Records.FieldByName('UserDef4') As TStringField;
              fldDefRetCurr   := sqlCaller.Records.FieldByName('DefRetCurr') As TIntegerField;
              fldJPTOurRef    := sqlCaller.Records.FieldByName('JPTOurRef') As TStringField;
              fldJSTOurRef    := sqlCaller.Records.FieldByName('JSTOurRef') As TStringField;
              fldJQSCode      := sqlCaller.Records.FieldByName('JQSCode') As TStringField;
              fldUserDef5     := sqlCaller.Records.FieldByName('UserDef5') As TStringField;
              fldUserDef6     := sqlCaller.Records.FieldByName('UserDef6') As TStringField;
              fldUserDef7     := sqlCaller.Records.FieldByName('UserDef7') As TStringField;
              fldUserDef8     := sqlCaller.Records.FieldByName('UserDef8') As TStringField;
              fldUserDef9     := sqlCaller.Records.FieldByName('UserDef9') As TStringField;
              fldUserDef10    := sqlCaller.Records.FieldByName('UserDef10') As TStringField;

              // Disable the sorting on the StringList whilst we are populating it to improve
              // performance, the Order By clause should cause the items to be added in the
              // correct order
              FCachedItems.Sorted := False;
              Try
                While (Not sqlCaller.Records.EOF) Do
                Begin
                  // Extract the data from the dataset and build an Exchequer Nominal record
                  FillChar (JobR, SizeOf(JobR), #0);

                  JobR.JobCode     := fldJobCode.Value;
                  JobR.JobDesc     := fldJobDesc.Value;
                  JobR.JobFolio    := fldJobFolio.Value;
                  JobR.CustCode    := fldCustCode.Value;
                  JobR.JobCat      := fldJobCat.Value;
                  JobR.JobAltCode  := fldJobAltCode.Value;
                  JobR.Completed   := fldCompleted.Value;
                  JobR.Contact     := fldContact.Value;
                  JobR.JobMan      := fldJobMan.Value;
                  JobR.ChargeType  := fldChargeType.Value;
                  JobR.QuotePrice  := fldQuotePrice.Value;
                  JobR.CurrPrice   := fldCurrPrice.Value;
                  JobR.StartDate   := fldStartDate.Value;
                  JobR.EndDate     := fldEndDate.Value;
                  JobR.RevEDate    := fldRevEDate.Value;
                  JobR.SORRef      := fldSORRef.Value;
                  JobR.NLineCount  := fldNLineCount.Value;
                  JobR.ALineCount  := fldALineCount.Value;
                  If (fldVATCode.Value <> '') Then
                    JobR.VATCode     := fldVATCode.Value[1];
                  JobR.CCDep[BOff] := fldDepartment.Value;
                  JobR.CCDep[BOn]  := fldCostCentre.Value;
                  JobR.JobAnal     := fldJobAnal.Value;
                  JobR.JobType     := fldJobType.Value[1];
                  JobR.JobStat     := fldJobStat.Value;
                  JobR.UserDef1    := fldUserDef1.Value;
                  JobR.UserDef2    := fldUserDef2.Value;
                  JobR.UserDef3    := fldUserDef3.Value;
                  JobR.UserDef4    := fldUserDef4.Value;
                  JobR.DefRetCurr  := fldDefRetCurr.Value;
                  JobR.JPTOurRef   := fldJPTOurRef.Value;
                  JobR.JSTOurRef   := fldJSTOurRef.Value;
                  JobR.JQSCode     := fldJQSCode.Value;
                  JobR.UserDef5    := fldUserDef5.Value;
                  JobR.UserDef6    := fldUserDef6.Value;
                  JobR.UserDef7    := fldUserDef7.Value;
                  JobR.UserDef8    := fldUserDef8.Value;
                  JobR.UserDef9    := fldUserDef9.Value;
                  JobR.UserDef10   := fldUserDef10.Value;

                  // Add it into the cache
                  AddToCache (JobR.JobCode, @JobR, SizeOf(JobR));

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

Procedure TJobCodeCache.AddToCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
Begin // AddToCache
  FCachedItems.AddObject (BuildCacheKey (Code), TCachedDataRecord.Create(RecPtr, RecSize));
End; // AddToCache

//-------------------------------------------------------------------------

Procedure TJobCodeCache.UpdateCache (Const Code : ShortString; Const RecPtr : Pointer; Const RecSize : LongInt);
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

Function TJobCodeCache.BuildCacheKey (Const Code : ShortString) : ShortString;
Begin // BuildCacheKey
  Result := FullJobCode(Code);
End; // BuildCacheKey

//-------------------------------------------------------------------------

// Separate function so profiling can pick it up
Procedure TJobCodeCache.RemoveCache (Const DeleteIdx : LongInt);
Begin // RemoveCache
  FCachedItems.Delete(DeleteIdx);
End; // RemoveCache

//------------------------------

Function TJobCodeCache.GetJobCode (Const Code : ShortString) : TCachedDataRecord;
Var
  sCacheKey : ShortString;
  Idx : LongInt;
Begin // GetJobCode
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
End; // GetJobCode

//=========================================================================

End.
