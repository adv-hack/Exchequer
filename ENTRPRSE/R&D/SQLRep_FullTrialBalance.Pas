Unit SQLRep_FullTrialBalance;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses Dialogs, Windows, DB, Graphics, SysUtils, Contnrs, StrUtils, RpDevice,
     GlobVar, VarConst, SQLCallerU, SQLRep_BaseReport, ReportU, SQLRep_FullTrialBalance_GLHeadingCache,
     SQLRep_FullTrialBalance_CarryFwdManager;

Type
  // This enumeration is used to identify which variant of the report is being printed
  TSQLFullTrialBalanceReportType = (rtFullTrialBalance=1, rtProfitAndLoss=2, rtBalanceSheet=3, rtSimplifiedTB=8);

  // Enumeration used for tracking where we are in relation to a filtered section of the GL Tree
  TFilterSectionStatus = (fsNotFound, fsInSection, fsExitedSection);

  // Enumeration for Simplified TB for printing the P&L section markers
  TPrintProfitAndLossSectionMarkerType = (plmHeader, plmFooter);

  //------------------------------

  TSQLRep_FullTrialBalance = Object(TSQLRep_BaseReport)
    Procedure RepSetTabs; Virtual;
    Procedure RepPrintPageHeader; Virtual;
    Procedure RepPrint(Sender : TObject); Virtual;
  Private
    // The cache stores the GL Heading details for use when printing totals
    FGLHeaderCache : IFullTrialBalanceGLHeaderCache;

    // The Carry Forward Manager accumulates the running totals to be carried forward
    // and stores the list of carry forwards as they are processed
    FCarryForwardManager : IFullTrialBalanceCarryForwardManager;

    // Used to track the GL Hierarchy so blank lines can be inserted between heading groups
    PrevHierarchy : ShortString;

    // Enumeration used for tracking where we are in relation to the P&L section of the GL Tree
    // so that we know whether to print GL Codes or not in the P&L and Balance Sheet reports
    ProfitAndLossSectionStatus : TFilterSectionStatus;
    GLCodeFilterSectionStatus : TFilterSectionStatus;
    CurrentlyPrintingGLCodes : Boolean;

    // Fields for tracking where/if the artificial 91060 line should be printed
    GL91060ParentPrinted : Boolean;
    GL91060Parent : LongInt;
    GL91060ParentTotal : LongInt;

    FReportType : TSQLFullTrialBalanceReportType;
    FIsComparative : Boolean;
    FTrialBalanceDifference : Double;

    // Totals of root GL Codes for Grand Totals
    TotalPeriodDebits : Real48;
    TotalPeriodCredits : Real48;
    TotalYTDDebits : Real48;
    TotalYTDCredits : Real48;
    TotalPeriodBudget : Real48;
    TotalPeriodVariance : Real48;

    // Cached P&L Start (40) totals for use in the fake P&L Bfwd line (91060)
    PandLBfwd_GLPeriodValue : Real48;
    PandLBfwd_GLPeriodBudget : Real48;
    PandLBfwd_GLPeriodVariance : Real48;
    PandLBfwd_GLYTDValue : Real48;

    // Internal flag used by the Simplified TB Report to prevent multiple blank lines being printed between groups
    FPrintedBlankLine : Boolean;

    Function GetReportInput  :  Boolean; Virtual;
    Procedure RepPrintTLines (Const LineWidth : Integer);
    Procedure PrintLine (Const LineGLCode         : LongInt;
                         Const LineGLDesc         : ShortString;
                         Const LineGLType         : Char;
                         Const LineGLCarryFwd     : LongInt;
                         Const LineGLPage         : Boolean;
                         Const LineGLHierarchy    : ShortString;
                               LinePeriodValue, LinePeriodBudget, LinePeriodVariance, LineYTDValue : Real48;
                         Const LineisPanL91060Row : Boolean);
    Procedure PrintGrandTotals;
    Procedure PrintGLHeading (Const LineGLCode : LongInt; Const LineGLDesc : ShortString; Const LineGLLevel : LongInt);
    Procedure PrintGLHeadingTotals(Const HeadingGLCode : LongInt);
    Procedure PrintCarryForward (Const CarryForwardDetails : IFullTrialBalanceCarryForwardDetails; Const CurrentGLLevel : Integer);
    // Creates a 2 character indentation string for each level down in the GL Tree the current GL Code is
    Function GetGLDescIndent (Const GLLevel : LongInt) : ShortString;
    Procedure SetGLCodeDrillDown (Const LineGLCode : LongInt);

    Procedure SetReportType(Value : TSQLFullTrialBalanceReportType);
    Procedure PrintProfitAndLossSectionMarker (Const SectionMarkerType : TPrintProfitAndLossSectionMarkerType);
    Procedure UpdateReportTotals (Const PeriodValue, PeriodBudgetValue, PeriodVarianceValue, YTDValue : Real48);
  Public

    MaxProgress : LongInt;
    ReportParameters : NomRepRec;
    CostCentreDesc : ShortString;
    DepartmentDesc : ShortString;

    // Cached SQL Emulator info to reduce overhead
    CompanyCode : ANSIString;
    ConnectionString : WideString;
    //VA 13/02/2018 2018-R1 ABSEXCH-19762 Getting error 'Login Failed for user 'ADM1118FINA01526'' when generating 'General Ledger Based' reports.
    Password : WideString;
    Property ReportType : TSQLFullTrialBalanceReportType Read FReportType Write SetReportType;
    Property IsComparative : Boolean Read FIsComparative Write FIsComparative;

    Property TrialBalanceDifference : Double Read FTrialBalanceDifference Write FTrialBalanceDifference;

    Constructor Create(AOwner  :  TObject);
    Destructor  Destroy; Virtual;
    Procedure AddParameters;
    Procedure Process; Virtual;
    Function SQLLoggingArea : String; Virtual;
  End; // TSQLRep_FullTrialBalance

Procedure SQLReport_PrintFullTrialBalance (Const ReportType : TSQLFullTrialBalanceReportType;
                                           Const IsComparative : Boolean;
                                           Const Owner : TObject;
                                           Const ReportParameters : NomRepRec);

Implementation

Uses SQLUtils, ADODB, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU, ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, SQLRep_Config, EntLoggerClass,
     SQLCCDeptList, SQLRep_FullTrialBalance_GLHierarchy, SQLRep_FullTrialBalance_GLHistoryStore, DebitCreditClass, IntMU, ComnUnit, BtrvU2, ExWrap1U;

Type
  TTrialBalanceGLDetails = Class(TObject)
  Private
    // Report parameter settings
    FrepComparative : Boolean;
    FrepYear : Byte;
    FrepPeriod : Byte;
    FrepReportForCurrency : Byte;
    FrepTranslateToCurrency : Byte;

    // Details from DB
    FNomRec : NominalRec;
    FGLHierarchy : ShortString;
    FGLPeriodValue,
    FGLPeriodBudget,
    FGLPeriodVariance,
    FGLYTDValue : Real48;  // Real48 used for backward compatibility

    fldGLCode,
    fldGLCarryFwd : TIntegerField;
    fldGLDesc,
    fldGLHierarchy : TMemoField;
    fldGLType : TStringField;
    fldHistIsCommitted,
    fldGLPage : TBooleanField;
    fldHistYear,
    fldHistPeriod : TIntegerField;
    fldHistSales,
    fldHistPurchases,
    fldHistBudget,
    fldHistBudget2 : TFloatField;

    // Used for monitoring whether we are in the P&L section of the GL Tree, this info is needed
    // when we are calculating history values for heading GL Codes
    FPandLSectionStatus : TFilterSectionStatus;

    Function GetGLCode : Integer;
    Function GetGLDescription : ShortString;
    Function GetGLType : Char;
    Function GetGLPageAtEnd : Boolean;
    Function GetGLCarryFwdTo : Integer;
    Function GetGLHierarchy : ShortString;
    Function GetGLPeriodValue : Real48;
    Function GetGLPeriodBudget : Real48;
    Function GetGLPeriodVariance : Real48;
    Function GetGLYTDValue : Real48;

    Procedure ProcessHistoryDetails (iHistoryStore : ITrialBalanceGLHistoryStore);
  Public
    Constructor Create;

    Procedure LinkToDB (Const ADORecords : TADODataset);
    Procedure LoadGLDetails (Const ADORecords : TADODataset; Var RowsProcessed : Integer);

    Property repComparative : Boolean Read FrepComparative Write FrepComparative;
    Property repYear : Byte Read FrepYear Write FrepYear;
    Property repPeriod : Byte Read FrepPeriod Write FrepPeriod;
    Property repReportForCurrency : Byte Read FrepReportForCurrency Write FrepReportForCurrency;
    Property repTranslateToCurrency : Byte Read FrepTranslateToCurrency Write FrepTranslateToCurrency;

    Property GLCode : Integer Read GetGLCode;
    Property GLDescription : ShortString Read GetGLDescription;
    Property GLType : Char Read GetGLType;
    Property GLPageAtEnd : Boolean Read GetGLPageAtEnd;
    Property GLCarryFwdTo : Integer Read GetGLCarryFwdTo;

    Property GLHierarchy : ShortString Read GetGLHierarchy;

    Property GLPeriodValue : Real48 Read GetGLPeriodValue;
    Property GLPeriodBudget : Real48 Read GetGLPeriodBudget;
    Property GLPeriodVariance : Real48 Read GetGLPeriodVariance;
    Property GLYTDValue : Real48 Read GetGLYTDValue;
  End; // TTrialBalanceGLDetails

//=========================================================================

Function GetLoggingArea (Const ReportType : TSQLFullTrialBalanceReportType) : ShortString;
Begin // GetLoggingArea
  Case ReportType Of
    rtFullTrialBalance : Result := 'FullTBReport';
    rtProfitAndLoss    : Result := 'PandLReport';
    rtBalanceSheet     : Result := 'BalanceSheetReport';
    rtSimplifiedTB     : Result := 'SimplifiedTBReport';
  Else
    Raise Exception.Create ('SQLReport_PrintFullTrialBalance: Undefined Report Type');
  End; // Case ReportType
End; // GetLoggingArea

//------------------------------

Procedure SQLReport_PrintFullTrialBalance (Const ReportType : TSQLFullTrialBalanceReportType;
                                           Const IsComparative : Boolean;
//                                           Const Period, Year : Byte;
                                           Const Owner : TObject;
                                           Const ReportParameters : NomRepRec);
Var
  sqlCaller : TSQLCaller;
  CompanyCode, ConnectionString, lPassword : WideString;
  I, NomCount : LongInt;
  CachedDevRec : TSBSPrintSetupInfo;
  CachedFont : TFont;
  CachedOrient : TOrientation;
  oReportLogger : TEntSQLReportLogger;
  CCDeptCombos : ICostCentreDepartmentCombinationList;
  TBDifference : Double;

  //------------------------------

  // Get the number of nominal records to use as the start point for the progress bar
  Function GetNominalCount : LongInt;
  Var
    sQuery: AnsiString;
  Begin // GetNominalCount
    sQuery := 'SELECT Count(glCode) As ''Count'' FROM [COMPANY].NOMINAL';
    sqlCaller.Select(sQuery, CompanyCode);
    Try
      If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0) Then
      Begin
        sqlCaller.Records.First;
        Result := sqlCaller.Records.FieldByName('Count').Value;
      End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
      Else
      Begin
        // Default return value for nominal report in case of SQL failure
        Result := 10000;
        oReportLogger.LogInfo('Retrieve GL Count', sQuery);
        If (sqlCaller.ErrorMsg <> '') Then
          oReportLogger.LogError('Retrieve GL Count', sqlCaller.ErrorMsg);
      End; // Else
    Finally
      sqlCaller.Close;
    End; // Try..Finally
  End; // GetNominalCount

  //------------------------------

  // Ported from TGenReport.Being_Posted - couldn't work out how to replicate the locking test in
  // SQL Server so I duplicated EL's code
  Function Being_Posted : Boolean;
  Var
    MTExLocal : TdMtExLocal;
    n     :  Byte;
    KeyStr:  Str255;
    LAddr :  LongInt;
  Begin // Being_Posted
    Result:=BOff;

    MTExLocal.Create(701);
    Try
      MTExLocal.Open_System (MiscF, MiscF);

      For n := 1 to 30 do
        If (n In [1..4,9,21..24]) Then
        Begin
          KeyStr := FullPLockKey(PostUCode, PostLCode, n);

          MTExLocal.LStatus := MTExLocal.LFind_Rec(B_GetEq + B_MultNWLock, MiscF, MIK, KeyStr);

          Result := (MTExLocal.LStatus = 85) or (MTExLocal.LStatus = 84);

          If MTExLocal.LStatusOK Then
          Begin
            // We need to unlock
            MTExLocal.LGetPos(MiscF, LAddr);
            MTExLocal.LStatus := MTExLocal.UnLockMLock(MiscF, LAddr);

            If (MTExLocal.LStatus <> 81) then
              MTExLocal.LReport_BError(MiscF, MTExLocal.LStatus);
          End; // If MTExLocal.LStatusOK

          If (Result) then
            Break;
        End; // If (n In [1..4,9,21..24])
    Finally
      MTExLocal.Close_Files;
      MTExLocal.Destroy;
    End; // Try..Finally
  End; // Being_Posted

  //------------------------------

  // MH 23/02/2012 v6.9 ABSEXCH-12558: Run through the root GL Codes and sum the history balances for
  // Period 99 in the year 2150 for the TB check in the report
  Function CalculateTBDifference : Double;
  Var
    sQuery: AnsiString;
    fldGLCode : TIntegerField;
    fldGLType : TStringField;
    Purch, Sales, Cleared : Double;
  Begin // CalculateTBDifference
    Result := 0.0;

    // Skip check if posting is in progress as the history numbers wqll be constantly updated so the
    // likelyhood of finding a false positive is significant
    If (Not Being_Posted) Then
    Begin
      sQuery := 'SELECT glCode, glType FROM [COMPANY].Nominal WHERE (glParent = 0)';
      sqlCaller.Select(sQuery, CompanyCode);
      Try
        If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0) Then
        Begin
          fldGLCode := sqlCaller.Records.FieldByName('glCode') As TIntegerField;
          fldGLType := sqlCaller.Records.FieldByName('glType') As TStringField;

          sqlCaller.Records.First;
          While (Not sqlCaller.Records.EOF) Do
          Begin
            Result := Result + Round_Up(Profit_To_Date(fldGLType.Value[1], FullNomKey(fldGLCode.Value), 0, 150, 99, Purch, Sales, Cleared, BOn), 2);

            sqlCaller.Records.Next;
          End; // While (Not sqlCaller.Records.EOF)
        End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
        Else
        Begin
          // Default return value for nominal report in case of SQL failure
          oReportLogger.LogInfo('Retrieve Root GL Codes', sQuery);
          If (sqlCaller.ErrorMsg <> '') Then
            oReportLogger.LogError('Retrieve Root GL Codes', sqlCaller.ErrorMsg);
        End; // Else
      Finally
        sqlCaller.Close;
      End; // Try..Finally
    End; // If (Not Being_Posted)
  End; // CalculateTBDifference

  //------------------------------

  Function PrintReport (Const CostCentreCode, CostCentreDesc, DepartmentCode, DepartmentDesc : ShortString; Const FirstReport : Boolean) : Boolean;
  Var
    SQLRep : ^TSQLRep_FullTrialBalance;
    bContinue : Boolean;
  Begin // PrintReport
    New(SQLRep, Create(Owner));
    Try
      // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
      SQLRep^.UsingEmulatorFiles := False;

      // Copy in cached SQL Emulator info to reduce overhead at print time
      SQLRep^.CompanyCode := CompanyCode;
      SQLRep^.ConnectionString := ConnectionString;
	  //VA 13/02/2018 2018-R1 ABSEXCH-19762 Getting error 'Login Failed for user 'ADM1118FINA01526'' when generating 'General Ledger Based' reports.
      SQLRep^.Password := lPassword;


      // Initialise report properties
      SQLRep^.ReportType := ReportType;
      SQLRep^.IsComparative := (ReportParameters.Mode > 8);
      SQLRep^.TrialBalanceDifference := TBDifference;

      SQLRep^.ReportMode := ReportParameters.Mode;
      SQLRep^.ReportParameters := ReportParameters;
      SQLRep^.ReportParameters.NCCDep[True] := CostCentreCode;
      SQLRep^.ReportParameters.NCCDep[False] := DepartmentCode;
      SQLRep^.CostCentreDesc := CostCentreDesc;
      SQLRep^.DepartmentDesc := DepartmentDesc;
      SQLRep^.MaxProgress := NomCount + 2;

      If ReportParameters.PrintParameters Then
        SQLRep^.AddParameters;

      If FirstReport Then
      Begin
        // Call Start to display the Print To dialog and then cache the details for subsequent reports
        bContinue := SQLRep^.Start;

        CachedDevRec := SQLRep^.RDevRec;
        CachedFont := TFont.Create;
        CachedFont.Assign (SQLRep^.RFont);
        CachedOrient := SQLRep^.ROrient;
      End // If FirstReport
      Else
      Begin
        // Copy in the cached details from the first report printed - don't want to display multiple Print To dialogs
        bContinue := True;

        // Need to create MTExLocal instance as the thread controller uses it to store the handle of the print routine!
        If (Not Assigned(SQLRep^.LPostLocal)) then
        Begin
          SQLRep^.Create_LocalThreadFiles(False);
          SQLRep^.MTExLocal := SQLRep^.LPostLocal;
        End;

        SQLRep^.GetReportInput;
        SQLRep^.RDevRec := CachedDevRec;

        SQLRep^.RFont.Assign(CachedFont);
        SQLRep^.ROrient := CachedOrient;

        // Configure the TReportFiler component
        SQLRep^.InitRep1;
      End; // Else

      // Initialise the report and add it into the Thread Controller
      If bContinue Then
      Begin
        BackThread.AddTask(SQLRep, SQLRep^.ThTitle);
      End // If bContinue
      Else
      Begin
        Set_BackThreadFlip (BOff);
        Dispose (SQLRep, Destroy);
      end;
    Except
      // Stop printing if there was an exception
      bContinue := False;
      Dispose(SQLRep, Destroy);
    End; // Try..Except

    Result := bContinue;
  End; // PrintReport

  //------------------------------

Begin // SQLReport_PrintFullTrialBalance
  // Ensure Thread Controller is up and running
  If Create_BackThread then
  Begin
    // Initialise the SQL Stuff
    CompanyCode := GetCompanyCode(SetDrive);

    // Get Company Admin Connection String - Read-Only doesn't have rights to run this
    //If (GetConnectionString(CompanyCode, False, ConnectionString) = 0) Then
    //VA:29/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    If (GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword) = 0) Then
    Begin
      // Create SQL Query object to use for progress initialisation and CC/Dept enumeration if required
      sqlCaller := TSQLCaller.Create;
      Try
        sqlCaller.ConnectionString := ConnectionString;
        sqlCaller.Connection.Password := lPassword;
        sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;

        // Disable the link to the UI to improve performance when iterating through the dataset
        sqlCaller.Records.DisableControls;
        Try
          // MH 23/02/2012 v6.9 ABSEXCH-12558: Check whether there is an imbalance in the Trial Balance,
          // this is passed through to the reports where a warning is printed if it is > 0.10
          TBDifference := CalculateTBDifference;

          CachedFont := NIL;
          oReportLogger := TEntSQLReportLogger.Create(GetLoggingArea(ReportType));
          Try
            // Get the number of nominal records to use as the basis of the progress bar(s)
            NomCount := GetNominalCount;

            // Check whether we need to get a list of Cost Centres and Departments from SQL Server
            If (Trim(ReportParameters.NCCDep[True]) <> '') Or (Trim(ReportParameters.NCCDep[False]) <> '') Or ReportParameters.CCDpTag Then
            Begin
              CCDeptCombos := GetCCDeptCombinations (ReportParameters.NCCDep[True], ReportParameters.NCCDep[False], ReportParameters.CCDpTag);
              For I := 0 To (CCDeptCombos.CombinationCount - 1) Do
              Begin
                With CCDeptCombos.Combinations[I] Do
                  If Not PrintReport (ccdpCostCentreCode, ccdpCostCentreDesc, ccdpDepartmentCode, ccdpDepartmentDesc, I=0) Then
                    // Report Cancelled
                    Break;
              End; // For I
            End // If (Trim(ReportParameters.NCCDep[True]) <> '') Or (Trim(ReportParameters.NCCDep[False]) <> '') Or ReportParameters.CCDpTag
            Else
              PrintReport ('', '', '', '', True);
          Finally
            If Assigned(CachedFont) Then
              FreeAndNIL(CachedFont);
            FreeAndNIL(oReportLogger);
          End; // Try..Finally
        Finally
          sqlCaller.Records.EnableControls;
        End; // Try..Finally
      Finally
        sqlCaller.Free;
      End; // Try..Finally
    End; // If (GetConnectionString(CompanyCode, False, ConnectionString) = 0)
  End; // If Create_BackThread
End; // SQLReport_PrintFullTrialBalance

//=========================================================================

Constructor TTrialBalanceGLDetails.Create;
Begin // Create
  Inherited Create;

  FPandLSectionStatus := fsNotFound
End; // Create

//-------------------------------------------------------------------------

Procedure TTrialBalanceGLDetails.LinkToDB (Const ADORecords : TADODataset);
Begin // LinkToDB
  // Use typecast references to the fields to avoid variant performance hits
  fldGLCode          := ADORecords.FieldByName('glCode') As TIntegerField;
  fldGLDesc          := ADORecords.FieldByName('glName') As TMemoField;
  fldGLType          := ADORecords.FieldByName('glType') As TStringField;
  fldGLCarryFwd      := ADORecords.FieldByName('glCarryFwd') As TIntegerField;
  fldGLPage          := ADORecords.FieldByName('glPage') As TBooleanField;

  fldGLHierarchy     := ADORecords.FieldByName('GLHierarchy') As TMemoField;

  fldHistIsCommitted := ADORecords.FieldByName('IsCommitted') As TBooleanField;
  fldHistYear        := ADORecords.FieldByName('hiYear') As TIntegerField;
  fldHistPeriod      := ADORecords.FieldByName('hiPeriod') As TIntegerField;
  fldHistSales       := ADORecords.FieldByName('hiSales') As TFloatField;
  fldHistPurchases   := ADORecords.FieldByName('hiPurchases') As TFloatField;
  fldHistBudget      := ADORecords.FieldByName('hiBudget') As TFloatField;
  fldHistBudget2     := ADORecords.FieldByName('hiRevisedBudget1') As TFloatField;
End; // LinkToDB

//-------------------------------------------------------------------------

Procedure TTrialBalanceGLDetails.ProcessHistoryDetails (iHistoryStore : ITrialBalanceGLHistoryStore);
Var
  iThisYearsHistoryStore : ITrialBalanceGLHistoryStore;
  iPrevYearsHistoryStore : ITrialBalanceGLHistoryStore;
  oHD : TTrialBalanceGLHistoryStoreItem;
  GotThisYearsYTD, GotLastYearsYTD : Boolean;
  IsPandLGL : Boolean;
  I : Integer;
Begin // ProcessHistoryDetails
  If (iHistoryStore.Count > 0) Then
  Begin
    GotThisYearsYTD := False;
    GotLastYearsYTD := False;

    // Identifies whether the GL Code is a P&L GL Code or a Heading GL Code in the P&L section of the tree
    IsPandLGL := (FNomRec.NomType = PLNHCode) Or ((FNomRec.NomType = NomHedCode) And (FPandLSectionStatus = fsInSection));

    // In order to find the correct history rows to build the totals we need to work backwards
    // through the supplied history rows, but due to issues with Real48 accuracy we have to add
    // the numbers up in a forward order (e.g. YTD + periods 1..12) in order to get the same
    // total as the legacy Pervasive/SQL Emulator report.  When the numbers are added up in reverse
    // order you get minor differences in the decimal places which then cause numbers to go
    // out by a penny here and there.
    //
    // In order to do this we will go backwards through the supplied history rows (iHistoryStore)
    // and add the rows we identify into the two local objects below so we can then go through them
    // in the forward order so that totals are correct.
    iThisYearsHistoryStore := CreateTBHistoryStore;
    iPrevYearsHistoryStore := CreateTBHistoryStore;
    Try
      // Run backwards through the history from the latest period/year to the earliest period/year to identify
      // which rows need to be included in each balance
      For I := (iHistoryStore.Count - 1) DownTo 0 Do
      Begin
        // Setup a local reference to each object to make the code below easier to read
        oHD := iHistoryStore.HistoryDetails[I];

        If repComparative Then
        Begin
          // Comparative YTD - The 'Period' balances are for the specified year and
          // the 'YTD' balances are for the previous year

          // Check whether it should be included within the totals for the specified year:-
          //
          //   * the periods for the specified year up-to and including the specified period
          //
          //   * for non-P&L GL Codes it includes the previous YTD value
          //
          If (Not GotThisYearsYTD)
             And
             (
               // For non-P&L GL Codes we may need to include period balances from previous years if
               // no YTD was found for the previous year
               ((Not IsPandLGL) And (oHD.Year <= repYear) And (oHD.Period <= repPeriod))
               Or
               // For P&L GL Codes we only include period balances for the specified year
               (IsPandLGL And (oHD.Year = repYear) And (oHD.Period <= repPeriod))
               Or
               // For non-P&L GL Codes we  need to include the YTD entry for the year before the one we are reporting on
               ((Not IsPandLGL) And (oHD.Year < RepYear) And (oHD.Period In [YTD, YTDNCF]))
             ) Then
          Begin
            iThisYearsHistoryStore.AddHistoryRow (oHD);
            // Stop accumulating figures as soon as a valid YTD has been included
            If (oHD.Period In [YTD, YTDNCF]) Then
              GotThisYearsYTD := True;
          End; // If (Not GotThisYearsYTD) And ...

          // Check whether it should be included within the totals for the previous year:-
          //
          //   * the periods for the previous year up-to and including the specified period
          //
          //   * for non-P&L GL Codes it includes the previous YTD value
          //
          If (Not GotLastYearsYTD)
             And
             (
               // For non-P&L GL Codes we may need to include period balances from previous years if
               // no YTD was found for the previous year
               ((Not IsPandLGL) And (oHD.Year <= (repYear - 1)) And (oHD.Period <= repPeriod))
               Or
               // For P&L GL Codes we only include period balances for the specified year
               (IsPandLGL And (oHD.Year = (repYear - 1)) And (oHD.Period <= repPeriod))
               Or
               // For non-P&L GL Codes we  need to include the YTD entry for the year before the one we are reporting on
               ((Not IsPandLGL) And (oHD.Year < (RepYear - 1)) And (oHD.Period In [YTD, YTDNCF]))
             ) Then
          Begin
            iPrevYearsHistoryStore.AddHistoryRow (oHD);
            // Stop accumulating figures as soon as a valid YTD has been included
            If (oHD.Period In [YTD, YTDNCF]) Then
              GotLastYearsYTD := True;
          End; // If (Not GotLastYearsYTD) And ...

          // Drop out of loop as soon as both values have been calculated
          If GotThisYearsYTD And GotLastYearsYTD Then
            Break;
        End // If repComparative
        Else
        Begin
          // Non-Comparitive

          // Check for specific period balance
          If (oHD.Year = RepYear) And (oHD.Period = repPeriod) Then
          Begin
            iThisYearsHistoryStore.AddHistoryRow (oHD);
          End; // If (Year = RepYear) And (Period = repPeriod)

             // For non-P&L GL Codes we may need to include period balances from previous years if
             // no YTD was found for the previous year
          If ((Not IsPandLGL) And (oHD.Year <= repYear) And (oHD.Period <= repPeriod))
             Or
             // For P&L GL Codes we only include period balances for the specified year
             (IsPandLGL And (oHD.Year = repYear) And (oHD.Period <= repPeriod))
             Or
             // For non-P&L GL Codes we  need to include the YTD entry for the year before the one we are reporting on
             ((Not IsPandLGL) And (oHD.Year < RepYear) And (oHD.Period In [YTD, YTDNCF])) Then
          Begin
            iPrevYearsHistoryStore.AddHistoryRow (oHD);
            If (oHD.Period In [YTD, YTDNCF]) Then
              // Hit YTD for previous year so we can drop out - any previous periods should not be included in the values
              Break;
          End; // If ((Year = repYear) And (Period <= repPeriod)) Or ((Year = (RepYear - 1)) And (Period In [TYD, YTDNCF]))
        End; // Else
      End; // For I

      // Now run forwards through the list of discovered history details adding them up - due to Real48 crapness
      // you have to do them in the forward order in order to get the same numbers as the legacy code
      If (iThisYearsHistoryStore.Count > 0) Then
      Begin
        For I := 0 To (iThisYearsHistoryStore.Count - 1) Do
        Begin
          // Setup a local reference to each object to make the code below easier to read
          oHD := iThisYearsHistoryStore.HistoryDetails[I];

          // Accumulate Purchase/Sales figures
          FGLPeriodValue := FGLPeriodValue + (oHD.PurchaseValue - oHD.SalesValue);

          // If calculating the period values
          If (oHD.Budget2Value <> 0.0) then
            FGLPeriodBudget := FGLPeriodBudget + oHD.Budget2Value
          else
            FGLPeriodBudget := FGLPeriodBudget + oHD.BudgetValue;
        End; // For I
      End; // If (iThisYearsHistoryStore.Count > 0)
      If (iPrevYearsHistoryStore.Count > 0) Then
      Begin
        For I := 0 To (iPrevYearsHistoryStore.Count - 1) Do
        Begin
          // Setup a local reference to each object to make the code below easier to read
          oHD := iPrevYearsHistoryStore.HistoryDetails[I];

          // Accumulate Purchase/Sales figures
          FGLYTDValue := FGLYTDValue + (oHD.PurchaseValue - oHD.SalesValue);
        End; // For I
      End; // If (iPrevYearsHistoryStore.Count > 0)
    Finally
      iThisYearsHistoryStore := NIL;
      iPrevYearsHistoryStore := NIL;
    End; // Try..Finally
  End; // If (iHistoryStore.Count > 0)
End; // ProcessHistoryDetails

//------------------------------

// This routine is called whilst positioned on the first row for a GL Code, it reads in
// and caches the GL Header details for later reference and runs through and subsequent
// rows for the same GL Code to calculate the values for the report
Procedure TTrialBalanceGLDetails.LoadGLDetails (Const ADORecords : TADODataset; Var RowsProcessed : Integer);
Var
  iActualsHistoryStore : ITrialBalanceGLHistoryStore;
  iCommittedHistoryStore : ITrialBalanceGLHistoryStore;
Begin // LoadGLDetails
  // Nominal Fields
  FillChar(FNomRec, SizeOf(FNomRec), #0);
  FNomRec.NomCode := fldGLCode.Value;
  FNomRec.Desc := fldGLDesc.Value;
  FNomRec.NomType := fldGLType.Value[1];
  FNomRec.NomPage := fldGLPage.Value;
  FNomRec.CarryF := fldGLCarryFwd.Value;

  FGLHierarchy := fldGLHierarchy.Value;

  // Initialise the history totals
  FGLPeriodValue := 0.0;  // Set to 1 otherwise falls foul of the Print Zero Balances check
  FGLPeriodBudget := 0.0;
  FGLPeriodVariance := 0.0;
  FGLYTDValue := 0.0;

  // Check for changes in position compared to the P&L section of the tree
  If (FNomRec.NomCode = Syss.NomCtrlCodes[PLStart]) Then
    FPandLSectionStatus := fsInSection
  Else If (FNomRec.NomCode = Syss.NomCtrlCodes[PLEnd]) Then
    FPandLSectionStatus := fsExitedSection;

  // Store actuals and committed history separately for processing, so we don't get clashes on Period/Year
  iActualsHistoryStore := CreateTBHistoryStore;
  iCommittedHistoryStore := CreateTBHistoryStore;
  Try
    // Pull the history records for the current GL Code out of the dataset and store them in a sorted list for processing
    While (Not ADORecords.EOF) And (fldGLCode.Value = FNomRec.NomCode) Do
    Begin
       // Check a valid history row was supplied, will be NULL/0 if no history records apply
       If (fldHistYear.Value > 0) Then
       Begin
         If (Not fldHistIsCommitted.Value) Then
           iActualsHistoryStore.AddHistoryRow (fldHistYear.Value,
                                               fldHistPeriod.Value,
                                               fldHistSales.Value,
                                               fldHistPurchases.Value,
                                               fldHistBudget.Value,
                                               fldHistBudget2.Value)
         Else
           iCommittedHistoryStore.AddHistoryRow (fldHistYear.Value,
                                                 fldHistPeriod.Value,
                                                 fldHistSales.Value,
                                                 fldHistPurchases.Value,
                                                 fldHistBudget.Value,
                                                 fldHistBudget2.Value);
       End; // If (fldHistYear.Value > 0)

      // Get the next row
      ADORecords.Next;
      RowsProcessed := RowsProcessed + 1;
    End; // While (Not ADORecords.EOF) And (fldGLCode.Value = FNomRec.NomCode)

    //
    // Process the history records to generate the totals - see the analysis documents for the
    // gruesome detail of how to calculate the balances
    //
    ProcessHistoryDetails (iCommittedHistoryStore);
    ProcessHistoryDetails (iActualsHistoryStore);

    // Recalculate the variance
    If (FGLPeriodBudget <> 0) Then
    Begin
      FGLPeriodVariance := (FGLPeriodValue - FGLPeriodBudget);
    End; // If (FGLPeriodBudget <> 0)

    // Translate to 'Translate To Currency' if required
    If (FrepReportForCurrency <> FrepTranslateToCurrency) Then
    Begin
      FGLPeriodValue := Currency_Txlate (FGLPeriodValue, FrepReportForCurrency, FrepTranslateToCurrency);
      FGLPeriodBudget := Currency_Txlate (FGLPeriodBudget, FrepReportForCurrency, FrepTranslateToCurrency);
      FGLPeriodVariance := Currency_Txlate (FGLPeriodVariance, FrepReportForCurrency, FrepTranslateToCurrency);
      FGLYTDValue := Currency_Txlate (FGLYTDValue, FrepReportForCurrency, FrepTranslateToCurrency);
    End; // If (FrepReportForCurrency <> FrepTranslateToCurrency)
  Finally
    iActualsHistoryStore := NIL;
    iCommittedHistoryStore := NIL;
  End; // Try..Finally
End; // LoadGLDetails

//-------------------------------------------------------------------------

Function TTrialBalanceGLDetails.GetGLCode : Integer;
Begin // GetGLCode
  Result := FNomRec.NomCode;
End; // GetGLCode

Function TTrialBalanceGLDetails.GetGLDescription : ShortString;
Begin // GetGLDescription
  Result := FNomRec.Desc;
End; // GetGLDescription

Function TTrialBalanceGLDetails.GetGLType : Char;
Begin // GetGLType
  Result := FNomRec.NomType;
End; // GetGLType

Function TTrialBalanceGLDetails.GetGLPageAtEnd : Boolean;
Begin // GetGLPageAtEnd
  Result := FNomRec.NomPage;
End; // GetGLPageAtEnd

Function TTrialBalanceGLDetails.GetGLCarryFwdTo : Integer;
Begin // GetGLCarryFwdTo
  Result := FNomRec.CarryF;
End; // GetGLCarryFwdTo

Function TTrialBalanceGLDetails.GetGLHierarchy : ShortString;
Begin // GetGLHierarchy
  Result := FGLHierarchy;
End; // GetGLHierarchy

Function TTrialBalanceGLDetails.GetGLPeriodValue : Real48;
Begin // GetGLPeriodValue
  Result := FGLPeriodValue;
End; // GetGLPeriodValue

Function TTrialBalanceGLDetails.GetGLPeriodBudget : Real48;
Begin // GetGLPeriodBudget
  Result := FGLPeriodBudget;
End; // GetGLPeriodBudget

Function TTrialBalanceGLDetails.GetGLPeriodVariance : Real48;
Begin // GetGLPeriodVariance
  Result := FGLPeriodVariance;
End; // GetGLPeriodVariance

Function TTrialBalanceGLDetails.GetGLYTDValue : Real48;
Begin // GetGLYTDValue
  Result := FGLYTDValue;
End; // GetGLYTDValue

//=========================================================================

Constructor TSQLRep_FullTrialBalance.Create(AOwner : TObject);
Begin // Create
  // Init report parameters to default values
  FReportType := rtFullTrialBalance;  // must be set prior to calling inherited
  FIsComparative := False;

  Inherited;

  // The cache stores the GL Heading details for use when printing totals
  FGLHeaderCache := GetGLHeaderCache;

  // The Carry Forward Manager accumulates the running totals to be carried forward
  // and stores the list of carry forwards as they are processed
  FCarryForwardManager := GetCarryForwardManager;

  // Don't print the bold line across the page under the column titles as this
  // report prints individual underlines under the column titles
  RNoPageLine := True;
End; // Create

//------------------------------

Destructor TSQLRep_FullTrialBalance.Destroy;
Begin // Destroy
  FCarryForwardManager := NIL;
  FGLHeaderCache := NIL;
  Inherited;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.SetReportType(Value : TSQLFullTrialBalanceReportType);
Begin // SetReportType
  If (Value <> FReportType) Then
  Begin
    FReportType := Value;

    // Need to recreate logger in order to change area
    FreeAndNIL(oReportLogger);
    oReportLogger := TEntSQLReportLogger.Create(SQLLoggingArea);
  End; // If (Value <> FReportType)
End; // SetReportType


Function TSQLRep_FullTrialBalance.SQLLoggingArea : String;
Begin // SQLLoggingArea
  Result := GetLoggingArea (FReportType);
End; // SQLLoggingArea

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.AddParameters;
const
  CommitStrings : Array[0..2] of String[27] = ('Show Actuals only', 'Combine Committed & Actuals', 'Show Committed only');
Begin // AddParameters
  if Assigned(oPrintParams) then
  begin
    with oPrintParams.AddParam do
    begin
      Name :=  'Period/Year';
      Value := PPR_OutPr(ReportParameters.RPr, ReportParameters.RYr);
    end;

    with oPrintParams.AddParam do
    begin
      Name := 'Comparative YTD';
      Value := IsComparative;
    end;

    with oPrintParams.AddParam do
    begin
      Name := 'General Ledger Range';
      if (ReportParameters.PALS = 0) and (ReportParameters.PALE = 0) then
        Value := 'All'
      else
      if (ReportParameters.PALE = 0) then
        Value := IntToStr(ReportParameters.PALS) + ' to End'
      else
        Value := Format('%d to %d', [ReportParameters.PALS, ReportParameters.PALE]);
      Value := FormatGLRange(ReportParameters.PALS, ReportParameters.PALE);
    end;

    {$IFDEF MC_ON}
    with oPrintParams.AddParam do
    begin
      Name :=  'Report for Currency';
      Value := TxLatePound(CurrDesc(ReportParameters.FCr), True);
    end;

    with oPrintParams.AddParam do
    begin
      Name :=  'Translate to Currency';
      Value := TxLatePound(CurrDesc(ReportParameters.FTxCr), True);
    end;
    {$ENDIF}

    with oPrintParams.AddParam do
    begin
      Name := 'Report to Level';
      if ReportParameters.RepLimit = 255 then
        Value := 'All'
      else
        Value := IntToStr(ReportParameters.RepLimit);
    end;

    if CommitAct then
      with oPrintParams.AddParam do
      begin
        Name :=  'Committed/Actual';
        Value := CommitStrings[ReportParameters.CommitMode];
      end;

    If Syss.UseCCDep Then
    Begin
      with oPrintParams.AddParam do
      begin
        Name :=  'Cost Centre';
        Value := ReportParameters.NCCDep[True];
      end;

      with oPrintParams.AddParam do
      begin
        Name :=  'Department';
        Value := ReportParameters.NCCDep[False];
      end;

      with oPrintParams.AddParam do
      begin
        Name :=  'Tag';
        Value := ReportParameters.CCDpTag;
      end;
    End; // If Syss.UseCCDep

    with oPrintParams.AddParam do
    begin
      Name :=  'Include Zero Balances';
      Value := ReportParameters.IncludeAll;
    end;

    bPrintParams := True;
  End; // if Assigned(oPrintParams)
End; // AddParameters

//-------------------------------------------------------------------------

// Called by the threading to execute whatever processing is required
Procedure TSQLRep_FullTrialBalance.Process;
Begin // Process
  // Initialise the Progress Bar range
  InitProgress(MaxProgress);
  UpdateProgress(1);

  Inherited Process;
End; // Process

//-------------------------------------------------------------------------

Function TSQLRep_FullTrialBalance.GetReportInput : Boolean;
{$IFDEF SOP}
  Const
    CommitTitle  :  Array[1..2] of Str50 = ('Committed & Actual values.','Committed values only.');
{$ENDIF}
Begin // GetReportInput
  With ReportParameters Do
  Begin
    Mode:=ReportMode;

    Case FReportType Of
      rtFullTrialBalance : Begin
                             ThTitle := 'Trial Balance';
                           End; // rtFullTrialBalance
      rtProfitAndLoss    : Begin
                             ThTitle := 'Profit & Loss';

                             // Disable GL Range - we need the full range to print the P&L Report correctly
                             ReportParameters.PALS := 0;
                             ReportParameters.PALE := 0;
                           End; // rtProfitAndLoss
      rtBalanceSheet     : Begin
                             ThTitle := 'Balance Sheet';

                             // Disable GL Range - we need the full range to print the Balance Sheet Report correctly
                             ReportParameters.PALS := 0;
                             ReportParameters.PALE := 0;
                           End; // rtBalanceSheet
      rtSimplifiedTB     : Begin
                             ThTitle:='Trial Balance';
                           End; // rtSimplifiedTB
    Else
      Raise Exception.Create ('TSQLRep_FullTrialBalance.GetReportInput: Unknown Report Type (' + IntToStr(Ord(FReportType)) + ')');
    End; // Case FReportType

    RepTitle := ThTitle;
    PageTitle := RepTitle;

    NCCMode:=Not EmptyKeyS(NCCDep[BOn],ccKeyLen,BOff);

    {$IFDEF MC_On}
      If (FTxCr<>0) and (FTxCr<>FCr) then
        PageTitle:=CurrDesc(FCr)+'to '+CurrDesc(FTxCr)+PageTitle
      else
        Pagetitle:=CurrDesc(FCr)+PageTitle;
    {$ENDIF}

    // Setup the ranges for retrieving the history values - only used for report & column titles
    If (Not FIsComparative) Then
    Begin
      // Standard report

      {* From this Pr to this Pr *}
      F2YrPr[1,1]:=RYr;
      F2YrPr[1,2]:=RPr;
      F2YrPr[1,3]:=RYr;
      F2YrPr[1,4]:=RPr;

      {* To between last Yr Ytd & Cur Pr & Yr *}
      F2YrPr[2,1]:=AdjYr(RYr,BOff);
      F2YrPr[2,2]:=YTD;
      F2YrPr[2,3]:=RYr;
      F2YrPr[2,4]:=RPr;

      RepTitle2:='For Period '+PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1]);
    End // If (Not FIsComparative)
    Else
    Begin
      // Comparative YTD

      {* From Last Yr Ytd & Cur Pr & Yr *}

      F2YrPr[1,1]:=AdjYr(RYr,BOff);
      F2YrPr[1,2]:=YTD;
      F2YrPr[1,3]:=RYr;
      F2YrPr[1,4]:=RPr;

      {* To between Year Before Last YTD & Last Yr same Pr *}

      F2YrPr[2,1]:=AdjYr(F2YrPr[1,1],BOff);
      F2YrPr[2,2]:=YTD;
      F2YrPr[2,3]:=AdjYr(RYr,BOff);
      F2YrPr[2,4]:=RPr;

      RepTitle2:='Comparative Year to Date. '+FullYear(TxlatePYr(F2YrPr[1,3],BOn))+ ' - '+FullYear(TxlatePYr(F2YrPr[2,3],BOn));
    End; // Else

    // Add CC/Dept details to subtitle
    If (Trim(NCCDep[True]) <> '') And (Trim(NCCDep[False]) <> '') Then
    Begin
      // CC + Dept
      RepTitle2 := RepTitle2 + '. For ' + Show_CCFilt(CalcCCDepKey(True,NCCDep),True);
    End // If (Trim(NCCDep[True]) <> '') And (Trim(NCCDep[False]) <> '')
    Else If (Trim(NCCDep[True]) <> '') Then
    Begin
      // CC only
      RepTitle2 := RepTitle2 + '. For ' + CostCtrRTitle[True] + ' ' + NCCDep[True]+  ',' + CostCentreDesc;
    End // If (Trim(NCCDep[True]) <> '')
    Else If (Trim(NCCDep[False]) <> '') Then
    Begin
      // Dept only
      RepTitle2 := RepTitle2 + '. For ' + CostCtrRTitle[False] + ' ' + NCCDep[False]+  ',' + DepartmentDesc;
    End; // If (Trim(NCCDep[False]) <> '')

    {$IFDEF SOP}
      If (CommitAct) and (CommitMode In [1,2]) then
        RepTitle2:=RepTitle2+'. '+CommitTitle[CommitMode];
    {$ENDIF}

    ROrient:=RPDefine.PoLandscape;
  End; // With ReportParameters

  Result := True;
End; // GetReportInput

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.RepSetTabs;
Begin // RepSetTabs
  With RepFiler1 do
  Begin
    ClearTabs;
    SetTab (MarginLeft, pjRight, 18, 4, 0, 0);
    SetTab (NA, pjLeft, 53, 4, 0, 0);
    SetTab (NA, pjRight,35, 4, 0, 0);
    SetTab (NA, pjRight,35, 4, 0, 0);
    SetTab (NA, pjRight,34, 4, 0, 0);
    SetTab (NA, pjRight,34, 4, 0, 0);
    SetTab (NA, pjRight,35, 4, 0, 0);
    SetTab (NA, pjRight,35, 4, 0, 0);
  end; {With..}

  SetTabCount;
End; // RepSetTabs

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.RepPrintPageHeader;

  //------------------------------

  Procedure BuildBoxes (Const ColNo : Integer);
  Var
    BoxDim   :  TRect;
    clShade  :  TColor;
  Begin // BuildBoxes
    With RepFiler1 do
    Begin
      clShade:=TColor($F5F5F5);
      SetBrush(clShade,bsSolid,nil);

      With BoxDim do
      Begin
        Left:=XU2D(TabStart(ColNo)-1);
        Top:=YU2D(MarginTop+14);
        Right:=XU2D(TabEnd(ColNo)+1);
        Bottom:=YU2D(PageHeight-MarginBottom);

        FillRect(BoxDim);
      end;
      SetBrush(clWhite,bsClear,nil);
    end;
  End; // BuildBoxes

  //------------------------------

  Procedure PrintGBHed (Band1, Band2, Band3 : Str80);
  Begin // PrintGBHed
    SendLine(ConCat(#9,#9,#9,Band1,#9,Band1,#9,Band2,#9,Band2,#9,Band3,#9,Band3));
  End; // PrintGBHed

  //------------------------------

Begin // RepPrintPageHeader
  With RepFiler1, ReportParameters Do
  Begin
    // Print shaded boxes in alternate numerical columns
    BuildBoxes(3);
    BuildBoxes(5);
    BuildBoxes(7);

    DefFont(0,[fsBold]);

    // Subtitle
    If (Not FIsComparative) Then
      // Normal
      PrintGBHed(PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1]),PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1]),FullYear(TxlatePYr(F2YrPr[1,1],BOn))+' YTD')
    Else
      // Comparative YTD
      PrintGBHed(FullYear(TxlatePYr(F2YrPr[1,3],BOn)),FullYear(TxlatePYr(F2YrPr[1,3],BOn)), FullYear(TxlatePYr(F2YrPr[2,3],BOn)));

    SendLine(ConCat(#9,#9,#9,'Debit',#9,'Credit',#9,'Budget',#9,'Variance',#9,'Debit',#9,'Credit'));

    RepPrintTLines(-1);

    DefFont(0,[]);
  End; // With RepFiler1, ReportParameters
End; // RepPrintPageHeader

//-------------------------------------------------------------------------

// Prints hozizontal lines across the numerical columns for headings and totals
Procedure TSQLRep_FullTrialBalance.RepPrintTLines (Const LineWidth : Integer);
Begin // RepPrintTLines
  With RepFiler1 Do
  Begin
    DefLine (LineWidth, TabStart(3) + 1, TabEnd(3), 0);
    DefLine (LineWidth, TabStart(4) + 1, TabEnd(4), 0);
    DefLine (LineWidth, TabStart(5) + 1, TabEnd(5), 0);
    DefLine (LineWidth, TabStart(6) + 1, TabEnd(6), 0);
    DefLine (LineWidth, TabStart(7) + 1, TabEnd(7), 0);
    DefLine (LineWidth, TabStart(8) + 1, TabEnd(8), 0);
  End; // With RepFiler1
End; // RepPrintTLines

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.SetGLCodeDrillDown (Const LineGLCode : LongInt);
Begin // SetGLCodeDrillDown
  SendRepDrillDown(1, TotTabs, 1, FullNomKey(LineGLCode), NomF, NomCodeK, 0);
End; // SetGLCodeDrillDown

//-------------------------------------------------------------------------

// Creates a 2 character indentation string for each level down in the GL Tree the current GL Code is
Function TSQLRep_FullTrialBalance.GetGLDescIndent (Const GLLevel : LongInt) : ShortString;
Begin // GetGLDescIndent
  Result := StringOfChar(' ', (GLLevel + 1) * 2);
End; // GetGLDescIndent

//-------------------------------------------------------------------------

// Prints the GL Heading, returns TRUE if anythign was printed
Procedure TSQLRep_FullTrialBalance.PrintGLHeading (Const LineGLCode : LongInt; Const LineGLDesc : ShortString; Const LineGLLevel : LongInt);
Begin // PrintGLHeading
  // Check the Level filter to see if we should print the totals
  If (LineGLLevel <= ReportParameters.RepLimit) Then
  Begin
    // Check for space on page
    ThrowNewPage(5);

    // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.CRLF;
    SetGLCodeDrillDown (LineGLCode);
    SendLine (#9 + IntToStr(LineGLCode) + #9 + GetGLDescIndent(LineGLLevel) + LineGLDesc);
    DefLine(-1, RepFiler1.MarginLeft, 75, -0.5);

    // Update the printed rows counter
    ICount := ICount + 1;
  End; // If (LineGLLevel <= ReportParameters.RepLimit)
End; // PrintGLHeading

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.PrintGLHeadingTotals(Const HeadingGLCode : LongInt);
Var
  HeadingDetails : IFullTrialBalanceGLHeaderDetails;
  HeadingIdx : Integer;
Begin // PrintGLHeadingTotals
  // Retrieve the GL Heading details from the cache
  HeadingIdx := FGLHeaderCache.IndexOf(HeadingGLCode);
  If (HeadingIdx >= 0) Then
  Begin
    HeadingDetails := FGLHeaderCache.GLHeadings[HeadingIdx];
    Try
      // Check the Level filter to see if we should print the totals
      If (HeadingDetails.hcGLLevel <= ReportParameters.RepLimit) Then
      Begin
        // MH 07/11/2011 v6.9 ABSEXCH-12041: Suppress unwanted totals
        If (HeadingDetails.hcPeriodDebitValue <> 0.0) Or (HeadingDetails.hcPeriodCreditValue <> 0.0) Or
           (HeadingDetails.hcPeriodBudget <> 0.0) Or (HeadingDetails.hcPeriodVariance <> 0.0) Or
           (HeadingDetails.hcYTDDebitValue <> 0.0) Or (HeadingDetails.hcYTDCreditValue <> 0.0) Or
           ReportParameters.IncludeAll Or FCarryForwardManager.HasCarryForwards (HeadingDetails.hcGLCode) Then
        Begin
          // Check for space on page
          ThrowNewPage(5);

          // Print the sub-total lines across the numeric columns
          RepPrintTLines(-1);

          // Print the total description in bold - indent it to line up with the heading
          DefFont(0,[fsbold]);
          SendText(#9 + #9 + GetGLDescIndent (HeadingDetails.hcGLLevel) + 'Total: (' + Trim(HeadingDetails.hcGLDescription) + ')' + StringOfChar('.', NomDesLen - Length(HeadingDetails.hcGLDescription) - 2) + ':');

          // Print the totals in normal
          DefFont(0,[]);

          // Print the GL Code details - print blank for zero values
          SendLine (#9 +
                    #9 +
                    #9 + FormatBFloat(GenRealMask, HeadingDetails.hcPeriodDebitValue, BOn) +
                    #9 + FormatBFloat(GenRealMask, HeadingDetails.hcPeriodCreditValue, BOn) +
                    #9 + FormatBFloat(GenRealMask, HeadingDetails.hcPeriodBudget, BOn) +
                    #9 + FormatBFloat(GenRealMask, HeadingDetails.hcPeriodVariance, BOn) +
                    #9 + FormatBFloat(GenRealMask, HeadingDetails.hcYTDDebitValue, BOn) +
                    #9 + FormatBFloat(GenRealMask, HeadingDetails.hcYTDCreditValue, BOn));

          // Print a bold line at the end of each root GL Heading section
          If (HeadingDetails.hcGLLevel <= 0) then
            RepPrintTLines(-2);

          // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
          Self.CRLF;
          Self.CRLF;
        End; // If (HeadingDetails.hcPeriodDebitValue <> 0.0) Or ...
      End; // If (HeadingDetails.hcGLLevel <= ReportParameters.RepLimit)
    Finally
      HeadingDetails := NIL;
    End; // Try..Finally
  End; // If (HeadingIdx >= 0)
End; // PrintGLHeadingTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.PrintCarryForward (Const CarryForwardDetails : IFullTrialBalanceCarryForwardDetails; Const CurrentGLLevel : Integer);
Begin // PrintCarryForward
  // Check the filters to see if we should print the carried forward
  If CurrentlyPrintingGLCodes And (CarryForwardDetails.cfdCarryForwardLevel <= ReportParameters.RepLimit) Then
  Begin
    // Check for space on page
    ThrowNewPage(5);

    // Print the Carry Forward aka Brought Forward details
    SendLine (#9 +
              #9 + GetGLDescIndent (CurrentGLLevel) + 'B/F - ' + Trim(CarryForwardDetails.cfdDescription) +
              #9 + FormatBFloat(GenRealMask, CarryForwardDetails.cfdPeriodDebitValue, BOn) +
              #9 + FormatBFloat(GenRealMask, CarryForwardDetails.cfdPeriodCreditValue, BOn) +
              #9 + FormatBFloat(GenRealMask, CarryForwardDetails.cfdPeriodBudget, BOn) +
              #9 + FormatBFloat(GenRealMask, CarryForwardDetails.cfdPeriodVariance, BOn) +
              #9 + FormatBFloat(GenRealMask, CarryForwardDetails.cfdYTDDebitValue, BOn) +
              #9 + FormatBFloat(GenRealMask, CarryForwardDetails.cfdYTDCreditValue, BOn));

    // Update the printed rows counter
    ICount := ICount + 1;
  End; // If CurrentlyPrintingGLCodes And (CarryForwardDetails.cfdCarryForwardLevel <= ReportParameters.RepLimit)

  // Update Carry Forward running totals with brought forward amount
  FCarryForwardManager.cfmPeriodValue := FCarryForwardManager.cfmPeriodValue - CarryForwardDetails.cfdPeriodCreditValue + CarryForwardDetails.cfdPeriodDebitValue;
  FCarryForwardManager.cfmPeriodBudget := FCarryForwardManager.cfmPeriodBudget + CarryForwardDetails.cfdPeriodBudget;
  FCarryForwardManager.cfmYTDValue := FCarryForwardManager.cfmYTDValue - CarryForwardDetails.cfdYTDCreditValue + CarryForwardDetails.cfdYTDDebitValue;
End; // PrintCarryForward

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.PrintProfitAndLossSectionMarker (Const SectionMarkerType : TPrintProfitAndLossSectionMarkerType);
Begin // PrintProfitAndLossSectionMarker
  RepFiler1.ClearTabs;
  RepFiler1.SetTab (RepFiler1.MarginRight, pjCenter, 75, 4, 0, 0);

  If (Not FPrintedBlankLine) Then
    // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.CRLF;

  If (SectionMarkerType = plmHeader) Then
  Begin
    SendLine(ConCat(#9,'Profit & Loss'));
    DefLine(-1, RepFiler1.MarginLeft, 65, -0.5);
  End // If (SectionMarkerType = plmHeader)
  Else If (SectionMarkerType = plmFooter) Then
  Begin
    SendLine(ConCat(#9,'End Profit & Loss'));
    DefLine(-1, RepFiler1.MarginLeft, 65, -0.5);
    // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.CRLF;
  End // If (SectionMarkerType = plmFooter)
  Else
    Raise Exception.Create ('TSQLRep_SimplifiedTrialBalance.PrintProfitAndLossSectionMarker: Unsupported SectionMarkerType (' + IntToStr(Ord(SectionMarkerType)) + ')');

  RepSetTabs;
End; // PrintProfitAndLossSectionMarker

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.UpdateReportTotals (Const PeriodValue, PeriodBudgetValue, PeriodVarianceValue, YTDValue : Real48);
Var
  DCPeriod, DCYTD : IDebitCreditReal48;
Begin // UpdateReportTotals
  // Use debit/credit utility objects to handle debitty/creditty type stuff
  DCPeriod := DebitCreditReal48(PeriodValue);
  DCYTD := DebitCreditReal48(YTDValue);
  Try
    TotalPeriodDebits := TotalPeriodDebits + DCPeriod.Debits;
    TotalPeriodCredits := TotalPeriodCredits + DCPeriod.Credits;
    TotalPeriodBudget := TotalPeriodBudget + PeriodBudgetValue;
    TotalPeriodVariance := TotalPeriodVariance + PeriodVarianceValue;
    TotalYTDDebits := TotalYTDDebits + DCYTD.Debits;
    TotalYTDCredits := TotalYTDCredits + DCYTD.Credits;
  Finally
    DCPeriod := NIL;
    DCYTD := NIL;
  End; // Try..Finally
End; // UpdateReportTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.PrintLine (Const LineGLCode         : LongInt;
                                              Const LineGLDesc         : ShortString;
                                              Const LineGLType         : Char;
                                              Const LineGLCarryFwd     : LongInt;
                                              Const LineGLPage         : Boolean;
                                              Const LineGLHierarchy    : ShortString;
                                                    LinePeriodValue, LinePeriodBudget, LinePeriodVariance, LineYTDValue : Real48;
                                              Const LineisPanL91060Row : Boolean);
Var
  iGLHierarchy, iPreviousHierarchy : IFullTrialBalanceGLHierarchyDetails;
  DCPeriod, DCYTD : IDebitCreditReal48;
  HeadingIdx, I : Integer;
Begin // PrintLine
  // Break down the GL Hierarchy into individual GL Codes for reference
  iGLHierarchy := GetGLHierarchyDetails (LineGLHierarchy);

  // Check for changes in heirachy in order to identify what (if any) totals to print
  If CurrentlyPrintingGLCodes And (LineGLHierarchy <> PrevHierarchy) And (PrevHierarchy <> '') Then
  Begin
    If (FReportType <> rtSimplifiedTB) Then
    Begin
      // If the new hierarchy starts with the old hierarchy then we don't need to do
      // anything as we are moving deeper into the tree
      If (Pos(PrevHierarchy, LineGLHierarchy) <> 1) Then
      Begin
        // Run backwards through the Previous Hierarchy checking for items missing in the current hierarchy
        iPreviousHierarchy := GetGLHierarchyDetails (PrevHierarchy);
        For I := (iPreviousHierarchy.HierarchyCount - 1) DownTo 0 Do
        Begin
          If (Not iGLHierarchy.Contains(iPreviousHierarchy.Hierarchy[I])) Then
          Begin
            // GL Heading missing from current hierarchy - print totals using GL Heading cache
            PrintGLHeadingTotals(iPreviousHierarchy.Hierarchy[I]);
          End; // If Not iGLHierarchy.Contains(iPreviousHierarchy.Hierarchy[I])
        End; // For I
      End; // If (Pos(PrevHierarchy, LineGLHierarchy) <> 1)
    End // If (FReportType <> rtSimplifiedTB)
    Else
    Begin
      // Simplified TB - check we haven't just printed a blank line
      If (Not FPrintedBlankLine) Then
      Begin
        // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.CRLF;
        FPrintedBlankLine := True;
      End; // If (Not FPrintedBlankLine)
    End; // Else
  End; // If CurrentlyPrintingGLCodes And (LineGLHierarchy <> PrevHierarchy) And (PrevHierarchy <> '')
  PrevHierarchy := LineGLHierarchy;

  //------------------------------

  // Check the filtering on the GL Code to determine whether we are entering/exiting a printable section
  If (FReportType In [rtProfitAndLoss, rtBalanceSheet]) Then
  Begin
    // Check to see if entering the P&L section
    If (LineGLCode = Syss.NomCtrlCodes[PLStart]) Then
      ProfitAndLossSectionStatus := fsInSection
    Else If (LineGLCode = Syss.NomCtrlCodes[PLEnd]) Then
      ProfitAndLossSectionStatus := fsExitedSection;

    // Filter out sections we don't print for the P&L and Balance Sheet reports
    If (FReportType = rtProfitAndLoss) Then
      CurrentlyPrintingGLCodes := (ProfitAndLossSectionStatus = fsInSection)
    Else
      CurrentlyPrintingGLCodes := (ProfitAndLossSectionStatus <> fsInSection)
  End // If (FReportType In [rtProfitAndLoss, rtBalanceSheet])
  Else If (FReportType = rtFullTrialBalance) Then
  Begin
    // Full Trial Balance - Check for GL Code Filtering
    If (ReportParameters.PALS <> 0) And (ReportParameters.PALE <> 0) Then
    Begin
      If (LineGLCode = ReportParameters.PALS) Then
        GLCodeFilterSectionStatus := fsInSection
      Else If (LineGLCode = ReportParameters.PALE) Then
        GLCodeFilterSectionStatus := fsExitedSection;

      CurrentlyPrintingGLCodes := (GLCodeFilterSectionStatus = fsInSection)
    End // If (ReportParameters.PALS <> 0) And (ReportParameters.PALE <> 0)
    Else
      // No filtering - always show items
      CurrentlyPrintingGLCodes := True;
  End // If (FReportType = rtFullTrialBalance)
  Else If (FReportType = rtSimplifiedTB) Then
  Begin
    // Simplified Trial Balance - Check for GL Code Filtering
    If (ReportParameters.PALS <> 0) And (ReportParameters.PALE <> 0) Then
    Begin
      If (LineGLCode = ReportParameters.PALS) Then
        GLCodeFilterSectionStatus := fsInSection
      Else If (LineGLCode = ReportParameters.PALE) Then
        GLCodeFilterSectionStatus := fsExitedSection;

      CurrentlyPrintingGLCodes := (GLCodeFilterSectionStatus = fsInSection)
    End // If (ReportParameters.PALS <> 0) And (ReportParameters.PALE <> 0)
    Else
      // No filtering - always show items
      CurrentlyPrintingGLCodes := True;

    // If we are on the Profit & Loss A/C Start GL Code then we need to stash its details for
    // the fake P&L Bfwd GL Code line
    If (LineGLCode = Syss.NomCtrlCodes[PLStart]) Then
    Begin
      // Entering P&L Section
      PrintProfitAndLossSectionMarker(plmHeader);
    End // If (LineGLCode = Syss.NomCtrlCodes[PLStart])
    Else If (LineGLCode = Syss.NomCtrlCodes[PLEnd]) Then
    Begin
      // Leaving P&L Section
      PrintProfitAndLossSectionMarker(plmFooter);
    End; // If (LineGLCode = Syss.NomCtrlCodes[PLStart])
  End; // If (FReportType = rtSimplifiedTB)

  //------------------------------

  // If we are on the Profit & Loss A/C Start GL Code then we need to stash its details for
  // the fake P&L Bfwd GL Code line
  If (LineGLCode = Syss.NomCtrlCodes[PLStart]) Then
  Begin
    PandLBfwd_GLPeriodValue := LinePeriodValue;
    PandLBfwd_GLPeriodBudget := LinePeriodBudget;
    PandLBfwd_GLPeriodVariance := LinePeriodVariance;
    PandLBfwd_GLYTDValue := LineYTDValue;
  End; // If (LineGLCode = Syss.NomCtrlCodes[PLStart])

  //------------------------------

  // For non-Simplified TB check the Carry Forwards list to see if any should be printed
  If (FCarryForwardManager.cfmCarryForwardCount > 0) And (FReportType <> rtSimplifiedTB) Then
  Begin
    For I := 0 To (FCarryForwardManager.cfmCarryForwardCount - 1) Do
    Begin
      If (FCarryForwardManager.cfmCarryForwards[I].cfdCarryForwardTo = LineGLCode) Then
      Begin
        PrintCarryForward (FCarryForwardManager.cfmCarryForwards[I], iGLHierarchy.HierarchyCount);
      End; // If (FCarryForwardManager.cfmCarryForwards[I].cfdCarryForwardTo = LineGLCode)
    End; // For I
  End; // If (FCarryForwardManager.cfmCarryForwardCount > 0) And (FReportType <> rtSimplifiedTB)

  //------------------------------

  // Processing differs depending on the type of the GL Code
  If (LineGLType = NomHedCode) Then
  Begin
    // Simplified TB Report doesn't print the Headings
    If (FReportType <> rtSimplifiedTB) Then
    Begin
      // Suppress headings with no values and no Carry Forwards - these should be an artifact of the processing required to print brought forwards correctly in SQL
      If CurrentlyPrintingGLCodes And
         ((LinePeriodValue <> 0.0) Or (LinePeriodBudget <> 0.0) Or (LinePeriodVariance <> 0.0) Or (LineYTDValue <> 0.0) Or
           FCarryForwardManager.HasCarryForwards (LineGLCode) Or
           ReportParameters.IncludeAll) Then
      Begin
        // Heading type GL Code - print heading line
        PrintGLHeading (LineGLCode, LineGLDesc, iGLHierarchy.HierarchyCount);

        // If this is the parent GL Code for the artificial 91060 line then set the printed status
        If (LineGLCode = GL91060Parent) Then
          GL91060ParentPrinted := True;
      End; // If CurrentlyPrintingGLCodes And ...

      // Stash details for later use when printing the totals
      FGLHeaderCache.AddToCache(LineGLCode, LineGLDesc, LinePeriodValue, LinePeriodBudget, LinePeriodVariance, LineYTDValue, iGLHierarchy.HierarchyCount);

      // Root GL Codes are also accumulated for the grand totals on Full Trial Balance and Balance Sheet Reports
      If (FReportType <> rtProfitAndLoss) And (iGLHierarchy.HierarchyCount = 0) Then
      Begin
        UpdateReportTotals (LinePeriodValue, 0, 0, LineYTDValue);
      End; // If (FReportType <> rtProfitAndLoss) And (iGLHierarchy.HierarchyCount = 0)
    End; // If (FReportType <> rtSimplifiedTB)
  End // If (LineGLType = NomHedCode)

  //------------------------------

  Else If (LineGLType = CarryFlg) Then
  Begin
    // Simplified TB Report doesn't use the Carry Forwards
    If (FReportType <> rtSimplifiedTB) Then
    Begin
      // Carry Forward type GL Code - stash details for later
      FCarryForwardManager.AddCarryForward (LineGLCode, LineGLDesc, LineGLCarryFwd, iGLHierarchy.HierarchyCount, ReportParameters.IncludeAll);
    End; // If (FReportType <> rtSimplifiedTB)
  End // If (LineGLType = NomHedCode)

  //------------------------------

  Else
  Begin
    // P&L/Balance Sheet/Control type GL Code - print values
    If CurrentlyPrintingGLCodes Then
    Begin
      // Check the Level filter to see if we should print the totals - for unknown reasons we always seem to print the P&L Row
      If (iGLHierarchy.HierarchyCount <= ReportParameters.RepLimit) Or LineisPanL91060Row Then
      Begin
        // Filter out Zero Value lines unless Include Zero Balances is selected
        If (ReportParameters.IncludeAll Or ((Round_Up(LinePeriodValue,2) <> 0) Or (Round_Up(LinePeriodBudget,2) <> 0.0) Or
                                            (Round_Up(LinePeriodVariance,2) <> 0.0) Or (Round_Up(LineYTDValue,2) <> 0.0))) Then
        Begin
          // Throw new page if NOM set to throw page
          If (LineGLPage) Then
            ThrowNewPage(-1)
          Else
            // Check space left on page
            ThrowNewPage(5);

          // Add the Print Preview Drill-Down information
          SetGLCodeDrillDown (LineGLCode);

          // Use debit/credit utility objects to handle debitty/creditty type stuff
          DCPeriod := DebitCreditReal48(LinePeriodValue);
          DCYTD := DebitCreditReal48(LineYTDValue);
          Try
            // Print the GL Code details - print blank for zero values
            SendLine (#9 + IntToStr(LineGLCode) +
                      #9 + GetGLDescIndent(iGLHierarchy.HierarchyCount) + LineGLDesc +
                      #9 + FormatBFloat(GenRealMask, DCPeriod.Debits, BOn) +
                      #9 + FormatBFloat(GenRealMask, DCPeriod.Credits, BOn) +
                      #9 + FormatBFloat(GenRealMask, LinePeriodBudget, BOn) +
                      #9 + FormatBFloat(GenRealMask, LinePeriodVariance, BOn) +
                      #9 + FormatBFloat(GenRealMask, DCYTD.Debits, BOn) +
                      #9 + FormatBFloat(GenRealMask, DCYTD.Credits, BOn));

            // Update the totals for the Simplified TB - this report actually adds up the values printed (excluding the 91060 line) whereas
            // the Full TB report adds up the totals of the root GL codes
            // MH 21/02/2012 v6.9 ABSEXCH-12552: Added actual exclusion of 91060 line
            If (FReportType = rtSimplifiedTB) And (Not LineisPanL91060Row) Then
            Begin
              UpdateReportTotals (LinePeriodValue, LinePeriodBudget, LinePeriodVariance, LineYTDValue);
            End; // If (FReportType = rtSimplifiedTB) And (Not LineisPanL91060Row)

            FPrintedBlankLine := False;

            // If this is the parent GL Code for the artificial 91060 line then set the printed status
            If (LineGLCode = GL91060Parent) Then
              GL91060ParentPrinted := True;

            // Update the printed rows counter
            ICount := ICount + 1;
          Finally
            DCPeriod := NIL;
            DCYTD := NIL;
          End; // Try..Finally
        End; // If (ReportParameters.IncludeAll Or ((
      End; // If (iGLHierarchy.HierarchyCount <= ReportParameters.RepLimit) Or LineisPanL91060Row

      If LineisPanL91060Row Then
      Begin
        // Add the artificial P&L A/C (Curr Year) line into the totals for the specfied parent only
        HeadingIdx := FGLHeaderCache.IndexOf(GL91060ParentTotal);
        If (HeadingIdx >= 0) Then
        Begin
          FGLHeaderCache.GLHeadings[HeadingIdx].IncludePandLACCurrYearValues (LinePeriodValue, LinePeriodBudget, LinePeriodVariance, LineYTDValue);
        End; // If (HeadingIdx >= 0)
      End; // If LineisPanL91060Row
    End; // If CurrentlyPrintingGLCodes

    // Update the Carry Forward Running Totals for the next Carry Forward found
    FCarryForwardManager.cfmPeriodValue := FCarryForwardManager.cfmPeriodValue + LinePeriodValue;
    FCarryForwardManager.cfmPeriodBudget := FCarryForwardManager.cfmPeriodBudget + LinePeriodBudget;
    FCarryForwardManager.cfmYTDValue := FCarryForwardManager.cfmYTDValue + LineYTDValue;
  End; // Else
End; // PrintLine

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.PrintGrandTotals;
Begin // PrintGrandTotals
  If (FReportType = rtSimplifiedTB) Then
  Begin
    DefLine(-2, RepFiler1.MarginLeft,RepFiler1.PageWidth-RepFiler1.MarginRight-1,0);
    SendLine (#9 +
              #9 + 'Column Totals' +
              #9 + FormatBFloat(GenRealMask, TotalPeriodDebits, BOn) +
              #9 + FormatBFloat(GenRealMask, TotalPeriodCredits, BOn) +
              #9 + FormatBFloat(GenRealMask, TotalPeriodBudget, BOn) +
              #9 + FormatBFloat(GenRealMask, TotalPeriodVariance, BOn) +
              #9 + FormatBFloat(GenRealMask, TotalYTDDebits, BOn) +
              #9 + FormatBFloat(GenRealMask, TotalYTDCredits, BOn));
  End // If (FReportType = rtSimplifiedTB)
  Else
  Begin
    SendLine (#9 +
              #9 + 'Grand Totals' +
              #9 + FormatBFloat(GenRealMask, TotalPeriodDebits, BOn) +
              #9 + FormatBFloat(GenRealMask, TotalPeriodCredits, BOn) +
              #9 + // This column intentionally left blank
              #9 + // This column intentionally left blank
              #9 + FormatBFloat(GenRealMask, TotalYTDDebits, BOn) +
              #9 + FormatBFloat(GenRealMask, TotalYTDCredits, BOn));

    // MH 23/02/2012 v6.9 ABSEXCH-12558: Report the Trial Balance Difference calculated at the start if
    // the difference is more than 0.10 (presumably for rounding errors?)
    If (ABS(FTrialBalanceDifference) > 0.10) Then 
    Begin
      ThrowNewPage(5);

      DefFont (6,[fsBold,fsUnderLine]);
      // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CRLF;
      Self.PrintCenter ('WARNING!', Round(RepFiler1.PageWidth / 2));
      Self.CRLF;
      DefFont (3,[fsBold]);
      // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter('The Trial Balance has an imbalance of ' + FormatFloat(GenRealMask, FTrialBalanceDifference), Round(RepFiler1.PageWidth / 2));
      Self.CRLF;
      Self.PrintCenter('Please contact your Helpdesk for advice on correcting this problem.', Round(RepFiler1.PageWidth / 2));
      Self.CRLF;
      Self.CRLF;
      DefFont (0,[]);
    End; // If (ABS(FTrialBalanceDifference) > 0.10)
  End; // Else
End; // PrintGrandTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_FullTrialBalance.RepPrint(Sender : TObject);
Var
  sqlCaller : TSQLCaller;
  sqlQuery: AnsiString;
  oTBGLDetails : TTrialBalanceGLDetails;
  iPreviousHierarchy : IFullTrialBalanceGLHierarchyDetails;
  I, RowCount : Integer;
Begin // RepPrint
  ShowStatus(2,'Processing Report.');

  oReportLogger.StartReport;

  // Create SQL Query object to use for executing the stored procedure
  sqlCaller := TSQLCaller.Create;
  Try
    sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;
    sqlCaller.ConnectionString := ConnectionString;
    //VA 13/02/2018 2018-R1 ABSEXCH-19762 Getting error 'Login Failed for user 'ADM1118FINA01526'' when generating 'General Ledger Based' reports.
    sqlCaller.Connection.Password := Password ;

    sqlQuery := '[COMPANY].isp_Report_TrialBalanceData ' +
                              '@intExchYear=' + IntToStr(ReportParameters.RYr) + ', ' +
                              '@intPeriod=' + IntToStr(ReportParameters.RPr) + ', ' +
                              '@bitIncludeActuals=' + IfThen (ReportParameters.CommitMode In [0, 1], '1', '0') + ', ' +
                              '@bitIncludeCommitted=' + IfThen (ReportParameters.CommitMode In [1, 2], '1', '0') + ', ' +
                              '@bitIncludeComparative=' + IfThen (FIsComparative, '1', '0') + ', ' +
                              '@intCurrency=' + IntToStr(ReportParameters.FCr) + ', ' +
                              '@strCostCentre=' + QuotedStr(Trim(ReportParameters.NCCDep[True])) + ', ' +
                              '@strDepartment=' + QuotedStr(Trim(ReportParameters.NCCDep[False]));
    oReportLogger.StartQuery(sqlQuery);
    sqlCaller.Select(sqlQuery, CompanyCode);
    oReportLogger.FinishQuery;
    Try
      If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0) Then
      Begin
        oReportLogger.QueryRowCount(sqlCaller.Records.RecordCount);

        // Update the line count and progress
        If Assigned(ThreadRec) then
          UpDateProgress(2);

        // Initialise reporting variables
        PrevHierarchy := '';
        ProfitAndLossSectionStatus := fsNotFound;
        GLCodeFilterSectionStatus := fsNotFound;
        CurrentlyPrintingGLCodes := False;
        TotalPeriodDebits := 0.0;
        TotalPeriodCredits := 0.0;
        TotalYTDDebits := 0.0;
        TotalYTDCredits := 0.0;
        PandLBfwd_GLPeriodValue := 0.0;
        PandLBfwd_GLPeriodBudget := 0.0;
        PandLBfwd_GLPeriodVariance := 0.0;
        PandLBfwd_GLYTDValue := 0.0;
        FPrintedBlankLine := False;

        // Disable the link to the UI to improve performance when iterating through the dataset
        sqlCaller.Records.DisableControls;
        Try
          GL91060ParentPrinted := False;
          GL91060Parent := Syss.NomCtrlCodes[ProfitBF];
          GL91060ParentTotal := 0;
          If sqlCaller.Records.Locate('glCode', Syss.NomCtrlCodes[ProfitBF], []) Then
          Begin
            iPreviousHierarchy := GetGLHierarchyDetails ((sqlCaller.Records.FieldByName('GLHierarchy') As TMemoField).Value);
            Try
              // Identify the GL Code which we will use to trigger the printing of the artificial 91060 line
              If (ReportParameters.RepLimit < iPreviousHierarchy.HierarchyCount) Then
                GL91060Parent := iPreviousHierarchy.Hierarchy[ReportParameters.RepLimit];

              // Identify the GL Heading which we will update with the 91060 totals
              If (iPreviousHierarchy.HierarchyCount > 1) Then
                GL91060ParentTotal := iPreviousHierarchy.Hierarchy[iPreviousHierarchy.HierarchyCount - 1];
            Finally
              iPreviousHierarchy := NIL;
            End; // Try..Finally
          End; // If sqlCaller.Records.Locate('glCode', 91060)

          // Run through the results printing the report
          sqlCaller.Records.First;
          RowCount := 1;

          oTBGLDetails := TTrialBalanceGLDetails.Create;
          Try
            // setup options
            oTBGLDetails.repComparative := FIsComparative;
            oTBGLDetails.repYear := ReportParameters.RYr;
            oTBGLDetails.repPeriod := ReportParameters.RPr;
            oTBGLDetails.repReportForCurrency := ReportParameters.FCr;
            oTBGLDetails.repTranslateToCurrency := ReportParameters.FTxCr;

            // Link the ADODataset to the GL/History object for data access
            oTBGLDetails.LinkToDB (sqlCaller.Records);

            While (Not sqlCaller.Records.EOF) Do
            Begin
              // Process the current SQL row and any subsequent GL History rows to get the GL Code details and its
              // associated balances for the report.  This process will leave the dataset on the next GL Code so
              // it is not necessary to code any calls to Next
              oTBGLDetails.LoadGLDetails (sqlCaller.Records, RowCount);

              // Print this line
              PrintLine (oTBGLDetails.GLCode,
                         oTBGLDetails.GLDescription,
                         oTBGLDetails.GLType,
                         oTBGLDetails.GLCarryFwdTo,
                         oTBGLDetails.GLPageAtEnd,
                         oTBGLDetails.GLHierarchy,
                         oTBGLDetails.GLPeriodValue,
                         oTBGLDetails.GLPeriodBudget,
                         oTBGLDetails.GLPeriodVariance,
                         oTBGLDetails.GLYTDValue,
                         False);

              // If we are on the 91060 parent line then print the fake 91060 line as well
              If (oTBGLDetails.GLCode = GL91060Parent) And GL91060ParentPrinted Then
              Begin
                PrintLine (Syss.NomCtrlCodes[ProfitBF],
                           GetIntMsg(48),
                           PLNHCode,
                           0,
                           oTBGLDetails.GLPageAtEnd,
                           oTBGLDetails.GLHierarchy,
                           PandLBfwd_GLPeriodValue,
                           PandLBfwd_GLPeriodBudget,
                           PandLBfwd_GLPeriodVariance,
                           PandLBfwd_GLYTDValue,
                           True);
              End; // If (oTBGLDetails.GLCode = GL91060Parent) And GL91060ParentPrinted


              // Update the thread progress
              If Assigned(ThreadRec) then
                UpDateProgress(2 + RowCount);
            End; // While (Not sqlCCDeptList.Records.EOF)

            //------------------------------

            If CurrentlyPrintingGLCodes Then
            Begin
              // Run through the hierarchy for the last row and print the oustanding totals
              iPreviousHierarchy := GetGLHierarchyDetails (PrevHierarchy);
              If (iPreviousHierarchy.HierarchyCount > 0) Then
              Begin
                For I := (iPreviousHierarchy.HierarchyCount - 1) DownTo 0 Do
                Begin
                  PrintGLHeadingTotals(iPreviousHierarchy.Hierarchy[I]);
                End; // For I
              End // If (iPreviousHierarchy.HierarchyCount > 0)
              Else If (oTBGLDetails.GLType = NomHedCode) Then
              Begin
                // Ended on a root level header - print totals
                PrintGLHeadingTotals(oTBGLDetails.GLCode);
              End; // If (oTBGLDetails.GLType = NomHedCode)

              iPreviousHierarchy := NIL;
            End; // If CurrentlyPrintingGLCodes

            //------------------------------

            // P&L Report doesn't print totals at the end
            If (FReportType <> rtProfitAndLoss) Then
            Begin
              // Print grand totals
              PrintGrandTotals;
            End; // If (FReportType <> rtProfitAndLoss)
          Finally
            oTBGLDetails.Free;
          End; // Try..Finally
        Finally
          sqlCaller.Records.EnableControls;
        End; // Try..Finally
      End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
      Else If (sqlCaller.ErrorMsg <> '') Then
        WriteSQLErrorMsg (sqlCaller.ErrorMsg);
    Finally
      sqlCaller.Close;
    End; // Try..Finally
  Finally
    sqlCaller.Free;
  End; // Try..Finally

(*
// test code for 9999 page issue to be fixed in v6.10
For I := 1 To 20000 Do
Begin
  RepFiler1.CRLF;
  SendLine (#9 + IntToStr(I));
  //If (I < 9999) Then
    RepFiler1.NewPage;
End; // For I
*)

  // Print footer
  PrintEndPage;

  oReportLogger.FinishReport;
End; // RepPrint

End.