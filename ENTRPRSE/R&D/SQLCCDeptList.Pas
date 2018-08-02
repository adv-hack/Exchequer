Unit SQLCCDeptList;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses Classes, SysUtils, Dialogs;

Type
  // Generic interface for objects which implement a specific import type
  ICostCentreDepartmentCombination = Interface
    ['{C5DF0A62-636B-4A37-B549-80E67DFB5E02}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCostCentreCode : ShortString;
    Function GetCostCentreDesc : ShortString;
    Function GetDepartmentCode : ShortString;
    Function GetDepartmentDesc : ShortString;

    // ------------------ Public Properties ------------------
    Property ccdpCostCentreCode : ShortString Read GetCostCentreCode;
    Property ccdpCostCentreDesc : ShortString Read GetCostCentreDesc;
    Property ccdpDepartmentCode : ShortString Read GetDepartmentCode;
    Property ccdpDepartmentDesc : ShortString Read GetDepartmentDesc;
  End; // ICostCentreDepartmentCombination

  //------------------------------

  // Generic interface for objects which implement a specific import type
  ICostCentreDepartmentCombinationList = Interface
    ['{A8BA49CA-DB38-426E-8DE7-A66BD3855211}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCount : LongInt;
    Function GetCombination (Index : Integer) : ICostCentreDepartmentCombination;

    // ------------------ Public Properties ------------------
    Property CombinationCount : LongInt Read GetCount;
    Property Combinations [Index : Integer] : ICostCentreDepartmentCombination Read GetCombination;
  End; // ICostCentreDepartmentCombinationList

  //------------------------------

  // Uses direct SQL to create a list of Cost Centre & Department combinations matching the specified
  // filter strings - see the IEMSIP - Simplified Trial Balance documentation for details
  Function GetCCDeptCombinations (Const CostCentreFilter, DepartmentFilter : ShortString; Const IncludeTaggedOnly : Boolean) : ICostCentreDepartmentCombinationList;

Implementation

Uses DB, SQLUtils, SQLRep_Config, GlobVar, SQLCallerU, EntLoggerClass, AdoConnect;

Type
  TCostCentreDepartmentCombination = Class(TInterfacedObject, ICostCentreDepartmentCombination)
  Private
    FCostCentreCode, FCostCentreDesc, FDepartmentCode, FDepartmentDesc : ShortString;

    // ICostCentreDepartmentCombination
    Function GetCostCentreCode : ShortString;
    Function GetCostCentreDesc : ShortString;
    Function GetDepartmentCode : ShortString;
    Function GetDepartmentDesc : ShortString;
  Public
    Constructor Create (Const CostCentreCode, CostCentreDesc, DepartmentCode, DepartmentDesc : ShortString);
  End; // TCostCentreDepartmentCombination

  //------------------------------

  TCostCentreDepartmentCombinationList = Class(TInterfacedObject, ICostCentreDepartmentCombinationList)
  Private
    FCombinationList : TInterfaceList;
    FCostCentreFilter : ShortString;
    FDepartmentFilter : ShortString;
    FIncludeTaggedOnly : Boolean;

    // ICostCentreDepartmentCombinationList
    Function GetCount : LongInt;
    Function GetCombination (Index : Integer) : ICostCentreDepartmentCombination;

    Procedure LoadCCDeptCombos;
  Public
    Constructor Create (Const CostCentreFilter, DepartmentFilter : ShortString; Const IncludeTaggedOnly : Boolean);
    Destructor Destroy; Override;
  End; // TCostCentreDepartmentCombinationList

//=========================================================================

// Uses direct SQL to create a list of Cost Centre & Department combinations matching the specified
// filter strings - see the IEMSIP - Simplified Trial Balance documentation for details
Function GetCCDeptCombinations (Const CostCentreFilter, DepartmentFilter : ShortString; Const IncludeTaggedOnly : Boolean) : ICostCentreDepartmentCombinationList;
Begin // GetCCDeptCombinations
  Result := TCostCentreDepartmentCombinationList.Create(CostCentreFilter, DepartmentFilter, IncludeTaggedOnly);
End; // GetCCDeptCombinations

//=========================================================================

Constructor TCostCentreDepartmentCombination.Create (Const CostCentreCode, CostCentreDesc, DepartmentCode, DepartmentDesc : ShortString);
Begin // Create
  Inherited Create;

  FCostCentreCode := CostCentreCode;
  FCostCentreDesc := CostCentreDesc;
  FDepartmentCode := DepartmentCode;
  FDepartmentDesc := DepartmentDesc;
End; // Create

//-------------------------------------------------------------------------

Function TCostCentreDepartmentCombination.GetCostCentreCode : ShortString;
Begin // GetCostCentreCode
  Result := FCostCentreCode;
End; // GetCostCentreCode

Function TCostCentreDepartmentCombination.GetCostCentreDesc : ShortString;
Begin // GetCostCentreDesc
  Result := FCostCentreDesc;
End; // GetCostCentreDesc

Function TCostCentreDepartmentCombination.GetDepartmentCode : ShortString;
Begin // GetDepartmentCode
  Result := FDepartmentCode;
End; // GetDepartmentCode

Function TCostCentreDepartmentCombination.GetDepartmentDesc : ShortString;
Begin // GetDepartmentDesc
  Result := FDepartmentDesc;
End; // GetDepartmentDesc

//=========================================================================

Constructor TCostCentreDepartmentCombinationList.Create (Const CostCentreFilter, DepartmentFilter : ShortString; Const IncludeTaggedOnly : Boolean);
Begin // Create
  Inherited Create;
  FCombinationList := TInterfaceList.Create;
  FCostCentreFilter := CostCentreFilter;
  FDepartmentFilter := DepartmentFilter;
  FIncludeTaggedOnly := IncludeTaggedOnly;
  LoadCCDeptCombos;
End; // Create

//------------------------------

Destructor TCostCentreDepartmentCombinationList.Destroy;
Begin // Destroy
  FCombinationList.Clear;
  FCombinationList.Destroy;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TCostCentreDepartmentCombinationList.LoadCCDeptCombos;
Var
  sqlCaller : TSQLCaller;
  oReportLogger : TEntSQLReportLogger;
  // MH 03/02/2014 v7.0.9 ABSEXCH-14846: Modified from TStringField to TMemoField due to changes in the underlying data types by JW
  fldCostCentre, fldCostCentreDesc, fldDepartmentDesc, fldDepartment : TMemoField;
  sCompanyCode, sConnectionString, sQuery, lPassword: WideString;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
Begin // LoadCCDeptCombos
  // Initialise the SQL Stuff
  sCompanyCode := GetCompanyCode(SetDrive);

  // Get Company Admin Connection String - Read-Only doesn't have rights to run this
  //If (GetConnectionString(sCompanyCode, False, sConnectionString) = 0) Then
  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  If (GetConnectionStringWOPass(sCompanyCode, False, sConnectionString, lPassword) = 0) Then
  Begin
    // Create SQL Query object to use for progress initialisation and CC/Dept enumeration if required
    //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
    sqlCaller := TSQLCaller.Create(GlobalAdoConnection);
    Try
      sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;

      oReportLogger := TEntSQLReportLogger.Create('CCDeptCombo');
      Try
        // Use stored procedure to retrieve list of CC/Dept passing user specified filter conditions
        sQuery := '[COMPANY].isp_Report_GetCostCentreDepartments ' +
                    '@strCostCentre=' + QuotedStr(Trim(FCostCentreFilter)) + ', ' +
                    '@strDepartment=' + QuotedStr(Trim(FDepartmentFilter)) + ', ' +
                    '@bitShowTaggedOnly=' + IntToStr(Ord(FIncludeTaggedOnly));

        oReportLogger.StartQuery(sQuery);
        sqlCaller.Select(sQuery, sCompanyCode);
        oReportLogger.FinishQuery;
        If (sqlCaller.ErrorMsg = '') Then
        Begin
          If (sqlCaller.Records.RecordCount > 0) Then
          Begin
            oReportLogger.QueryRowCount(sqlCaller.Records.RecordCount);

            // Run through results for Line Currency and then for Consolidated if nothing found
            sqlCaller.Records.First;

            // Use typecast references to the fields to avoid variant performance hits
            // MH 03/02/2014 v7.0.9 ABSEXCH-14846: Modified from TStringField to TMemoField due to changes in the underlying data types by JW
            fldCostCentre     := sqlCaller.Records.FieldByName('CostCentre') As TMemoField;
            fldCostCentreDesc := sqlCaller.Records.FieldByName('CostCentreDescription') As TMemoField;
            fldDepartment     := sqlCaller.Records.FieldByName('Department') As TMemoField;
            fldDepartmentDesc := sqlCaller.Records.FieldByName('DepartmentDescription') As TMemoField;

            While (Not sqlCaller.Records.EOF) Do
            Begin
              FCombinationList.Add(TCostCentreDepartmentCombination.Create (fldCostCentre.Value, fldCostCentreDesc.Value, fldDepartment.Value, fldDepartmentDesc.Value));
              sqlCaller.Records.Next;
            End; // While (Not sqlCaller.Records.EOF)
          End // If (sqlCaller.Records.RecordCount > 0)
          Else
          Begin
            // No CC/Dept combinations found
            MessageDlg ('No Cost Centre and Department combinations were found that matched the specified filter conditions',
                        mtInformation, [mbOK], 0);
            oReportLogger.LogError('Query Error', 'No Cost Centre and Department combinations were found that matched the specified filter conditions');
          End; // Else
        End // If (sqlCaller.ErrorMsg = '')
        Else
        Begin
          MessageDlg ('The following error occurred whilst retrieving the data - ' + QuotedStr(sqlCaller.ErrorMsg),
                      mtError, [mbOK], 0);
          oReportLogger.LogError('Query Error', sqlCaller.ErrorMsg);
        End; // Else
      Finally
        FreeAndNIL(oReportLogger);
      End; // Try..Finally
    Finally
      sqlCaller.Free;
    End; // Try..Finally
  End; // If (GetConnectionString(CompanyCode, False, ConnectionString) = 0)
End; // LoadCCDeptCombos

//-------------------------------------------------------------------------

Function TCostCentreDepartmentCombinationList.GetCount : LongInt;
Begin // GetCount
  Result := FCombinationList.Count;
End; // GetCount

//------------------------------

Function TCostCentreDepartmentCombinationList.GetCombination (Index : Integer) : ICostCentreDepartmentCombination;
Begin // GetCombination
  If (Index >= 0) And (Index < FCombinationList.Count) Then
    Result := FCombinationList.Items[Index] As ICostCentreDepartmentCombination
  Else
    Raise ERangeError.Create ('TCostCentreDepartmentCombinationList.GetCombination: Invalid Index (' + IntToStr(Index) + ')');
End; // GetCombination


//=========================================================================

End.

