Unit SQLRep_TransactionDaybooks;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses DB, Graphics, SysUtils, Math, StrUtils, GlobVar, VarConst, SQLCallerU, SQLRep_BaseReport, BTSupU3;

Type
  TTransactionDaybookReportType = (tdrDocumentAnalysis=0, tdrSales=10, tdrPurchase=20, tdrReceipts=30, tdrPayments=40, tdrSalesOrder=50, tdrPurchaseOrder=60, tdrNominal=70);

  TSQLRep_TransactionDaybookReports = Object(TSQLRep_BaseReport)
    Procedure RepSetTabs; Virtual;
    Procedure RepPrintPageHeader; Virtual;
    Procedure RepPrintHeader(Sender : TObject); Virtual;
    Procedure RepPrint(Sender : TObject); Virtual;
  Private
    LastDocType,
    CurrentDocType : DocTypes;

    FTransType_TotalSubTotal,
    FTransType_TotalVAT,
    FTransType_TotalTotal : Double;
    FReport_TotalSubTotal,
    FReport_TotalVAT,
    FReport_TotalTotal : Double;

    Function GetReportInput  :  Boolean; Virtual;
    Procedure RepPrint_ProcessFullDataset (sqlCaller : TSQLCaller);
    Procedure PrintTransactionTypeHeader (Const Continuation : Boolean);
    Procedure PrintTransactionDetails (Const OurRef : ShortString;
                                       Const AcCode : ShortString;
                                       Const Company : ShortString;
                                       Const YourRef : ShortString;
                                       Const PeriodYear : ShortString;
                                       Const Date : ShortString;
                                       Const DueDate : ShortString;
                                       Const SubTotal : Double;
                                       Const VAT : Double;
                                       Const Total : Double);
    Procedure PrintTransactionTypeTotals;
    Procedure PrintReportTotals;
  Public
    MaxProgress : LongInt;
    ReportType : TTransactionDaybookReportType;
    ReportParameters : DocRepParam;
    CostCentreDesc : ShortString;
    DepartmentDesc : ShortString;

    // Cached SQL Emulator info to reduce overhead
    CompanyCode : WideString;
    ConnectionString : WideString;
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    Password: WideString;

    Procedure Process; Virtual;
    Function SQLLoggingArea : String; Virtual;
  End; // TSQLRep_TransactionDaybookReports

Procedure SQLReport_PrintTransactionDaybookReports (Const Owner : TObject; Const ReportType : TTransactionDaybookReportType; Const ReportParameters : DocRepParam);

Implementation

Uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU, ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, DocSupU1, SQLRep_Config,
     ComnUnit, VarRec2U;

Type
  TDaybookTransaction = Class(TObject)
  Private
    FTransaction : InvRec;
    FReportType : TTransactionDaybookReportType;
    FReportForCurrency : Byte;
    FAcCompany : ShortString;
    FSubTotal,
    FVAT,
    FTotal : Double;

    // DB Fields
    fldthAcCode,
    fldAcCompany,
    fldTHOurRef,
    fldTHYourRef,
    fldTHTransDate,
    fldTHDueDate : TStringField;
    fldTHSettleDiscTaken : TBooleanField;
    fldTHDocType,
    flTHCurrency,
    fldTHYear,
    fldTHPeriod,
    fldTHUseOriginalRates : TIntegerField;

    fldTHNetValue,
    fldTHTotalVAT,
    fldTHTotalLineDiscount,
    fldTHRevalueADJ,
    fldTHSettleDiscAmount,
    fldTHVariance,
    fldTHPostDiscAm,
    fldTHDailyRate,
    fldTHCompanyRate,
    fldTHOriginalCompanyRate,
    fldTHOriginalDailyRate,
    fldTHTotalOrderOS,
    fldTHTotalReserved : TFloatField;

    Function GetDocType : DocTypes;
    Function GetStringField (Index : Integer) : ShortString;
    Function GetIntegerField (Index : Integer) : Integer;
  Public
    Procedure LinkToDB (Const sqlCaller : TSQLCaller);
    Procedure LoadTransactionDetails;

    Property ReportType : TTransactionDaybookReportType Read FReportType Write FReportType;
    Property ReportForCurrency : Byte Read FReportForCurrency Write FReportForCurrency;

    Property thOurRef : ShortString Index 1 Read GetStringField;
    Property thAcCode : ShortString Index 2 Read GetStringField;
    Property acCompany : ShortString Index 3 Read GetStringField;
    Property thYourRef : ShortString Index 4 Read GetStringField;
    Property thYear : Integer Index 1 Read GetIntegerField;
    Property thPeriod : Integer Index 2 Read GetIntegerField;
    Property thTransDate : ShortString Index 5 Read GetStringField;
    Property thDueDate : ShortString Index 6 Read GetStringField;
    Property thDocType : DocTypes Read GetDocType;

    Property thSubTotal : Double Read FSubTotal;
    Property thVAT  : Double Read FVAT;
    Property thTotal  : Double Read FTotal;

  End; // TDaybookTransaction

//=========================================================================

// Links the internal DB Field objects to the ADODataset so the data can be accessed
Procedure TDaybookTransaction.LinkToDB (Const sqlCaller : TSQLCaller);
Begin // LinkToDB
  fldTHOurRef              := sqlCaller.Records.FieldByName('thOurRef') As TStringField;
  fldTHAcCode              := sqlCaller.Records.FieldByName('thAcCode') As TStringField;
  fldAcCompany             := sqlCaller.Records.FieldByName('acCompany') As TStringField;
  fldTHYourRef             := sqlCaller.Records.FieldByName('thYourRef') As TStringField;
  fldTHYear                := sqlCaller.Records.FieldByName('thYear') As TIntegerField;
  fldTHPeriod              := sqlCaller.Records.FieldByName('thPeriod') As TIntegerField;
  fldTHTransDate           := sqlCaller.Records.FieldByName('thTransDate') As TStringField;
  fldTHDueDate             := sqlCaller.Records.FieldByName('thDueDate') As TStringField;
  fldTHDocType             := sqlCaller.Records.FieldByName('thDocType') As TIntegerField;
  fldTHNetValue            := sqlCaller.Records.FieldByName('thNetValue') As TFloatField;
  fldTHTotalVAT            := sqlCaller.Records.FieldByName('thTotalVAT') As TFloatField;
  fldTHTotalLineDiscount   := sqlCaller.Records.FieldByName('thTotalLineDiscount') As TFloatField;
  fldTHRevalueADJ          := sqlCaller.Records.FieldByName('thRevalueAdj') As TFloatField;
  fldTHTotalReserved       := sqlCaller.Records.FieldByName('thTotalReserved') As TFloatField;
  fldTHSettleDiscAmount    := sqlCaller.Records.FieldByName('thSettleDiscAmount') As TFloatField;
  fldTHSettleDiscTaken     := sqlCaller.Records.FieldByName('thSettleDiscTaken') As TBooleanField;
  fldTHVariance            := sqlCaller.Records.FieldByName('thVariance') As TFloatField;
  fldTHPostDiscAm          := sqlCaller.Records.FieldByName('PostDiscAm') As TFloatField;
  fldTHTotalOrderOS        := sqlCaller.Records.FieldByName('thTotalOrderOS') As TFloatField;
  flTHCurrency             := sqlCaller.Records.FieldByName('thCurrency') As TIntegerField;
  fldTHDailyRate           := sqlCaller.Records.FieldByName('thDailyRate') As TFloatField;
  fldTHCompanyRate         := sqlCaller.Records.FieldByName('thCompanyRate') As TFloatField;
  fldTHOriginalCompanyRate := sqlCaller.Records.FieldByName('thOriginalCompanyRate') As TFloatField;
  fldTHOriginalDailyRate   := sqlCaller.Records.FieldByName('thOriginalDailyRate') As TFloatField;
  fldTHUseOriginalRates    := sqlCaller.Records.FieldByName('thUseOriginalRates') As TIntegerField;
End; // TDaybookTransaction

//-------------------------------------------------------------------------

Procedure TDaybookTransaction.LoadTransactionDetails;
Var
  CrDr : DrCrDType;
  UOR  : Byte;
Begin // LoadTransactionDetails
  FillChar(FTransaction, SizeOf(FTransaction), #0);
  With FTransaction Do
  Begin
    OurRef          := fldTHOurRef.Value;
    CustCode        := fldTHAcCode.Value;
    Currency        := flTHCurrency.Value;
    AcYr            := fldTHYear.Value;
    AcPr            := fldTHPeriod.Value;
    TransDate       := fldTHTransDate.Value;
    DueDate         := fldTHDueDate.Value;
    CXrate[BOn]     := fldTHDailyRate.Value;
    CXrate[BOff]    := fldTHCompanyRate.Value;
    InvDocHed       := DocTypes(fldTHDocType.Value);
    InvNetVal       := fldTHNetValue.Value;
    InvVat          := fldTHTotalVAT.Value;
    DiscSetAm       := fldTHSettleDiscAmount.Value;
    DiscAmount      := fldTHTotalLineDiscount.Value;
    DiscTaken       := fldTHSettleDiscTaken.Value;
    Variance        := fldTHVariance.Value;
    TotalReserved   := fldTHTotalReserved.Value;
    ReValueAdj      := fldTHRevalueADJ.Value;
    OrigRates[BOn]  := fldTHOriginalDailyRate.Value;
    OrigRates[BOff] := fldTHOriginalCompanyRate.Value;
    PostDiscAm      := fldTHPostDiscAm.Value;
    TotOrdOS        := fldTHTotalOrderOS.Value;
    UseORate        := fldTHUseOriginalRates.Value;
    YourRef         := fldTHYourRef.Value;
  End; // With FTransaction

  FAcCompany := fldAcCompany.Value;

  // Calculate transaction values for report

  //
  // Note: The following section of code was ported from TDocReport.PrintReportLine in Report3U.Pas
  //
  If (FReportType In [tdrSalesOrder, tdrPurchaseOrder]) Then {* Show O/S order value *}
  Begin
    If (FReportForCurrency = 0) Then
    Begin
      UOR := fxUseORate(UseCODayRate, BOn, FTransaction.CXRate, FTransaction.UseORate, FTransaction.Currency, 0);
      CrDr[BOff] := Round_Up(Conv_TCurr(FTransaction.TotOrdOS,
                                        XRate(FTransaction.CXRate, UseCoDayRate, FTransaction.Currency),
                                        FTransaction.Currency,
                                        UOR, BOff), 2);
      CrDr[BOn]  := 0;
    End // If (FReportForCurrency = 0)
    Else
    Begin
      CrDr[BOff] := FTransaction.TotOrdOS;
      CrDr[BOn]  := 0;
    End; // Else
  End // If (FReportType In [tdrSalesOrder, tdrPurchaseOrder])
  Else
  Begin
    If (FReportForCurrency = 0) Then
    Begin
      CrDr[BOff] := ConvCurrItotOrg(FTransaction, BOff, BOn, BOn);
      CrDr[BOn]  := Round_Up(Conv_TCurr(FTransaction.InvVat, FTransaction.CXRate[BOn], FTransaction.Currency, FTransaction.UseORate, BOff), 2);
    End // If (FReportForCurrency = 0)
    Else
    Begin
      CrDr[BOff] := Itotal(FTransaction);
      CrDr[BOn]  := FTransaction.InvVat;
    End; // Else
  end;

  CrDr[BOff] := CrDr[BOff] * DocCnst[FTransaction.InvDocHed] * DocNotCnst;
  CrDr[BOn] := CrDr[BOn] * DocCnst[FTransaction.InvDocHed] * DocNotCnst;

  If (FReportType In [tdrReceipts, tdrPayments]) And (FTransaction.InvDocHed In DirectSet) Then
  Begin
    CrDr[BOff] := CrDr[BOff] * DocNotCnst;
    CrDr[BOn]  := 0;
  End; // If (FReportType In [tdrReceipts, tdrPayments]) And (FTransaction.InvDocHed In DirectSet)

  FSubTotal := CrDr[BOff] - CrDr[BOn];
  FVAT := CrDr[BOn];
  FTotal := CrDr[BOff];
End; // LoadTransactionDetails

//-------------------------------------------------------------------------

Function TDaybookTransaction.GetDocType : DocTypes;
Begin // GetDocType
  Result := FTransaction.InvDocHed;
End; // GetDocType

//------------------------------

Function TDaybookTransaction.GetStringField (Index : Integer) : ShortString;
Begin // GetStringField
  Case Index Of
    1 : Result := FTransaction.OurRef;
    2 : Result := FTransaction.CustCode;
    3 : Result := FAcCompany;
    4 : Result := FTransaction.YourRef;
    5 : Result := FTransaction.TransDate;
    6 : Result := FTransaction.DueDate;
  Else
    Result := '';
  End; // Case Index
End; // GetStringField

//------------------------------

Function TDaybookTransaction.GetIntegerField (Index : Integer) : Integer;
Begin // GetIntegerField
  Case Index Of
    1 : Result := FTransaction.AcYr;
    2 : Result := FTransaction.AcPr;
  Else
    Result := 0;
  End; // Case Index
End; // GetIntegerField

//=========================================================================

Procedure SQLReport_PrintTransactionDaybookReports (Const Owner : TObject; Const ReportType : TTransactionDaybookReportType; Const ReportParameters : DocRepParam);
Var
  SQLRep : ^TSQLRep_TransactionDaybookReports;
  CompanyCode, ConnectionString, lPassword : WideString;
  TransCount : LongInt;

  //------------------------------

  // Get the number of Transaction Header records to use as the start point for the progress bar
  Function GetTransactionCount : LongInt;
  Var
    sqlCaller : TSQLCaller;
    sQuery: AnsiString;
  Begin // GetTransactionCount
    // Create SQL Query object to use for progress initialisation
    sqlCaller := TSQLCaller.Create;//(GlobalADOConnection);  // Removed shared connection due to errors when multiple reports running simultaneously
    Try
      sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;
      sqlCaller.ConnectionString := ConnectionString;
      sqlCaller.Connection.Password := lPassword;

      sQuery := 'SELECT Count(PositionId) As ''Count'' FROM [COMPANY].DOCUMENT';
      sqlCaller.Select(sQuery, CompanyCode);
      Try
        If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0) Then
        Begin
          sqlCaller.Records.First;
          Result := sqlCaller.Records.FieldByName('Count').Value;
        End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
        Else
          // Default return value for nominal report in case of SQL failure
          Result := 1000000;
      Finally
        sqlCaller.Close;
      End; // Try..Finally
    Finally
      sqlCaller.Free;
    End; // Try..Finally
  End; // GetTransactionCount

  //------------------------------

Begin // SQLReport_PrintTransactionDaybookReports
  // Ensure Thread Controller is up and running
  If Create_BackThread then
  Begin
    // Initialise the SQL Stuff
    CompanyCode := GetCompanyCode(SetDrive);

    // Get Company Admin Connection String - Read-Only doesn't have rights to run this
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    If (GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword) = 0) Then
    Begin
      // Get the number of nominal records to use as the basis of the progress bar(s)
      TransCount := GetTransactionCount;

      // Create report object
      New(SQLRep, Create(Owner));
      Try
        // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator
        SQLRep^.UsingEmulatorFiles := False;

        // Copy in cached SQL Emulator info to reduce overhead at print time
        SQLRep^.CompanyCode := CompanyCode;
        SQLRep^.ConnectionString := ConnectionString;
        //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
        SQLRep^.Password := lPassword;

        // Initialise report properties
        SQLRep^.ReportType := ReportType;
        SQLRep^.ReportParameters := ReportParameters;
        SQLRep^.MaxProgress := TransCount + 2;

        // Call Start to display the Print To dialog and then cache the details for subsequent reports
        If SQLRep^.Start Then
        Begin
          // Initialise the report and add it into the Thread Controller
          BackThread.AddTask(SQLRep, SQLRep^.ThTitle);
        End // If bContinue
        Else
        Begin
          Set_BackThreadFlip (BOff);
          Dispose (SQLRep, Destroy);
        end;
      Except
        // Stop printing if there was an exception
        Dispose(SQLRep, Destroy);
      End; // Try..Except
    End; // If (GetConnectionString(CompanyCode, False, ConnectionString) = 0)
  End; // If Create_BackThread
End; // SQLReport_PrintTransactionDaybookReports

//=========================================================================

Function TSQLRep_TransactionDaybookReports.SQLLoggingArea : String;
Begin // SQLLoggingArea
  Result := 'TransactionDaybookReport';
End; // SQLLoggingArea

//-------------------------------------------------------------------------

// Called by the threading to execute whatever processing is required
Procedure TSQLRep_TransactionDaybookReports.Process;
Begin // Process
  // Initialise the Progress Bar range
  InitProgress(MaxProgress);
  UpdateProgress(1);

  Inherited Process;
End; // Process

//-------------------------------------------------------------------------

Function TSQLRep_TransactionDaybookReports.GetReportInput : Boolean;
Var
  sqlCaller : TSQLCaller;
  sQuery, sQueryResult : ANsIString;
  n : Integer;
Begin // GetReportInput
  With ReportParameters do
  Begin
    Case ReportType Of
      tdrDocumentAnalysis : thTitle := 'Document Analysis Report';
      tdrSales            : thTitle := 'Sales Daybook Report';
      tdrPurchase         : thTitle := 'Purchase Daybook Report';
      tdrReceipts         : thTitle := 'Sales Receipts - Daybook Report';
      tdrPayments         : thTitle := 'Purchase Payments - Daybook Report';
      tdrSalesOrder       : thTitle := 'Sales Order Daybook Report';
      tdrPurchaseOrder    : thTitle := 'Purchase Order Daybook Report';
      tdrNominal          : thTitle := 'Nominal Transfer - Daybook Report';
    Else
      thTitle := 'Unknown Report';
    End; // Case ReportType
    RepTitle := ThTitle;

    {$IFDEF MC_On}
      RepTitle := CurrDesc(RCr) + RepTitle;
    {$ENDIF}

    If (Trim(CustFilt) <> '') Or (Trim(RCCDep[False]) <> '') Or (Trim(RCCDep[True]) <> '') Then
    Begin
      // Create SQL Query object to use for executing the stored procedure
      sqlCaller := TSQLCaller.Create;//(GlobalADOConnection);  // Removed shared connection due to errors when multiple reports running simultaneously
      Try
        Try
          sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;
          sqlCaller.ConnectionString := ConnectionString;
          //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
          sqlCaller.Connection.Password := Password;

          // Account Filter Company Name
          If (Trim(CustFilt) <> '') Then
          Begin
            sQuery := 'SELECT acCompany FROM [COMPANY].CustSupp WHERE acCode=' + QuotedStr(CustFilt);
            sqlCaller.Select(sQuery, CompanyCode);
            Try
              If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount = 1) Then
              Begin
                sqlCaller.Records.First;
                sQueryResult := Trim(sqlCaller.Records.FieldByName('acCompany').Value);
              End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount = 1)
              Else
              Begin
                sQueryResult := '';
                oReportLogger.LogInfo('Retrieve Company Name', sQuery);
                If (sqlCaller.ErrorMsg <> '') Then
                  oReportLogger.LogError('Retrieve Trader Company Name', sqlCaller.ErrorMsg);
              End; // Else
            Finally
              sqlCaller.Close;
            End; // Try..Finally

            RepTitle2 := RepTitle2 + 'For ' + Strip('B', [#32], sQueryResult);
          End; // If (Trim(CustFilt) <> '')

          // Cost Centre description
          If (Trim(RCCDep[True]) <> '') Then
          Begin
            sQuery := 'SELECT CCDescTrans FROM [COMPANY].ExchqChk WHERE (RecPfix = ''C'') AND (SubType = 67) AND (EXCHQCHKcode1Trans1=' + QuotedStr(RCCDep[True]) + ')';
            sqlCaller.Select(sQuery, CompanyCode);
            Try
              If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount = 1) Then
              Begin
                sqlCaller.Records.First;
                sQueryResult := Trim(sqlCaller.Records.FieldByName('CCDescTrans').Value);
              End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
              Else
              Begin
                sQueryResult := '';
                oReportLogger.LogInfo('Retrieve CC Desc', sQuery);
                If (sqlCaller.ErrorMsg <> '') Then
                  oReportLogger.LogError('Retrieve CC Desc', sqlCaller.ErrorMsg);
              End; // Else
            Finally
              sqlCaller.Close;
            End; // Try..Finally

            If (RepTitle2 <> '') then
              RepTitle2 := RepTitle2 + ', ';
            RepTitle2 := RepTitle2 + CostCtrRTitle[True] + ' ' + RccDep[True] + '-' + sQueryResult;
          End; // If (Trim(RCCDep[True]) <> '')

          // Department description
          If (Trim(RCCDep[False]) <> '') Then
          Begin
            sQuery := 'SELECT CCDescTrans FROM [COMPANY].ExchqChk WHERE (RecPfix = ''C'') AND (SubType = 68) AND (EXCHQCHKcode1Trans1=' + QuotedStr(RCCDep[False]) + ')';
            sqlCaller.Select(sQuery, CompanyCode);
            Try
              If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount = 1) Then
              Begin
                sqlCaller.Records.First;
                sQueryResult := Trim(sqlCaller.Records.FieldByName('CCDescTrans').Value);
              End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
              Else
              Begin
                sQueryResult := '';
                oReportLogger.LogInfo('Retrieve Dept Desc', sQuery);
                If (sqlCaller.ErrorMsg <> '') Then
                  oReportLogger.LogError('Retrieve Dept Desc', sqlCaller.ErrorMsg);
              End; // Else
            Finally
              sqlCaller.Close;
            End; // Try..Finally

            If (RepTitle2 <> '') then
              RepTitle2 := RepTitle2 + '. ';
            RepTitle2 := RepTitle2 + CostCtrRTitle[False] + ' ' + RccDep[False] + '-' + sQueryResult;
          End; // If (Trim(RCCDep[False]) <> '')
        Finally
          sqlCaller.Free;
        End; // Try..Finally
      Except
        On E:Exception Do
        Begin
          RepTitle2 := 'ERROR: ' + E.Message;
          oReportLogger.LogError('Retrieve Static Data',E.Message);
        End; // On E:Exception
      End; // Try..Except
    End; // If (Trim(CustFilt) <> '') Or (Trim(RCCDep[False]) <> '') Or (Trim(RCCDep[True]) <> '')

    If (DocWanted <> '') Then
    Begin
      If (RepTitle2 <> '') then
        RepTitle2 := RepTitle2 + ', ';

      RepTitle2 := RepTitle2 + 'Document Filter : ' + DocWanted;
    End; // If (DocWanted <> '')

    PageTitle := RepTitle + ' (' + PPR_OutPr(RPr, RYr) + ' - ' + PPR_OutPr(RPr2, RYr2) + ')';

    // Bodge to correct pagination issues when comparing new and old reports
    If (ReportType <> tdrDocumentAnalysis) And (RepTitle2 = '') Then
      RepTitle2 := ' ';

    RFont.Size:=7;
    ROrient:=RPDefine.PoLandscape;
  End; // With ReportParameters

  Result := True;
End; // GetReportInput

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.RepSetTabs;
Begin // RepSetTabs
  With RepFiler1 do
  Begin
    ClearTabs;

    SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
    SetTab (NA, pjLeft, 20, 4, 0, 0);
    SetTab (NA, pjLeft, 45, 4, 0, 0);
    SetTab (NA, pjLeft, 50{22}, 4, 0, 0);  // MHYR
    SetTab (NA, pjLeft, 15, 4, 0, 0);
    SetTab (NA, pjLeft, 17, 4, 0, 0);
    SetTab (NA, pjLeft, 17, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight,29, 4, 0, 0);
  End; // With RepFiler1

  SetTabCount;
End; // RepSetTabs

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.RepPrintHeader(Sender : TObject);
Begin // RepPrintHeader
  Inherited;

  If (RepFiler1.CurrentPage > 1) Then
    PrintTransactionTypeHeader (True);
End; // RepPrintHeader

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.RepPrintPageHeader;
Begin // RepPrintPageHeader
  With RepFiler1 Do
  Begin
    DefFont(0,[fsBold]);

    SendLine (ConCat (#9, 'Our Ref',
                      #9, 'Acc No',
                      #9, 'Company',
                      #9, 'Your Ref',
                      #9, 'Pr Yr',
                      #9, 'Date',
                      #9, 'Date Due',
                      #9, 'Sub-Total',
                      #9, CCVATName^,
                      #9,'Total'));

    DefFont(0,[]);
  End; // With RepFiler1
End; // RepPrintPageHeader

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.PrintTransactionTypeHeader (Const Continuation : Boolean);
Var
  sSubTitle : ShortString;
Begin // PrintTransactionTypeHeader
  // Only print sub-title on page change if account code not changed
  If (Not Continuation) Or (Continuation And (LastDocType = CurrentDocType)) Then
  Begin
    LastDocType := CurrentDocType;

    With RepFiler1 Do
    Begin
      DefFont(0,[fsBold]);

      sSubTitle := DocNames[CurrentDocType];

      If Continuation Then
        sSubTitle := sSubTitle + ' (continued...)';

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft(sSubTitle,MarginLeft);
      Self.CrLF;
      DefLine(-1,1,100,-0.3);
      DefFont(0,[]);
    End; // With RepFiler1
  End; // If (Not Continuation) Or (Continuation And (LastDocType = CurrentDocType))
End; // PrintTransactionTypeHeader

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.PrintTransactionDetails (Const OurRef : ShortString;
                                                                     Const AcCode : ShortString;
                                                                     Const Company : ShortString;
                                                                     Const YourRef : ShortString;
                                                                     Const PeriodYear : ShortString;
                                                                     Const Date : ShortString;
                                                                     Const DueDate : ShortString;
                                                                     Const SubTotal : Double;
                                                                     Const VAT : Double;
                                                                     Const Total : Double);
Begin // PrintTransactionDetails
  // Put drill-down box across entire line for Transaction Header
  SendRepDrillDown(1, TotTabs, 1, OurRef, InvF, InvOurRefK, 0);
  // Overwrite Account details portion of line with drill-down box for Account
  SendRepDrillDown(2, 3, 2, AcCode, CustF, CustCodeK, 0);

  SendLine (#9 + OurRef +
            #9 + AcCode +
            #9 + Company +
            #9 + YourRef +
            #9 + PeriodYear +
            #9 + POutDateB(Date) +
            #9 + POutDateB(DueDate) +
            #9 + FormatFloat(GenRealMask, SubTotal) +
            #9 + FormatFloat(GenRealMask, VAT) +
            #9 + FormatFloat(GenRealMask, Total));
End; // PrintTransactionDetails

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.PrintTransactionTypeTotals;
Begin // PrintTransactionTypeTotals
  DefFont(0,[]);
  DefLine(-1,140,250,0);

  SendLine (#9#9#9#9#9#9 +
            #9 + 'Totals.:' +
            #9 + FormatFloat(GenRealMask, FTransType_TotalSubTotal) +
            #9 + FormatFloat(GenRealMask, FTransType_TotalVAT) +
            #9 + FormatFloat(GenRealMask, FTransType_TotalTotal));

  DefLine(-1,140,250,0);
End; // PrintTransactionTypeTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.PrintReportTotals;
Begin // PrintReportTotals
  DefFont(0,[]);
  DefLine(-1, 1, RepFiler1.PageWidth - RepFiler1.MarginRight - 1, 0);

  SendLine (#9#9#9#9#9#9 +
            #9 + 'Totals.:' +
            #9 + FormatFloat(GenRealMask, FReport_TotalSubTotal) +
            #9 + FormatFloat(GenRealMask, FReport_TotalVAT) +
            #9 + FormatFloat(GenRealMask, FReport_TotalTotal));
End; // PrintReportTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.RepPrint_ProcessFullDataset (sqlCaller : TSQLCaller);
Var
  oDBTransaction : TDaybookTransaction;
Begin // RepPrint_ProcessFullDataset
  LastDocType := WIN;     // Not used as a transaction type so should always cause the break to happen for the first transaction
  CurrentDocType := RUN;  // Must be different to LastDocType and must also not be used as a transaction type

  FTransType_TotalSubTotal := 0.0;
  FTransType_TotalVAT := 0.0;
  FTransType_TotalTotal := 0.0;
  FReport_TotalSubTotal := 0.0;
  FReport_TotalVAT := 0.0;
  FReport_TotalTotal := 0.0;

  // Create Daybook Transaction object to handle retrieval and storage of the data
  // from the dataset as well as performing the calculations of transaction totals
  // standard exchequer functions.
  oDBTransaction := TDaybookTransaction.Create;
  Try
    oDBTransaction.ReportType := ReportType;
    oDBTransaction.ReportForCurrency := ReportParameters.RCr;

    // Run through the results printing the report
    sqlCaller.Records.First;

    // Link the ADODataset to the transaction object for data access
    oDBTransaction.LinkToDB(sqlCaller);

    While (Not sqlCaller.Records.EOF) And (Not ThreadRec^.ThAbort) Do
    Begin
      // Check space left on page
      ThrowNewPage(5);

      // Process the transaction details from the current dataset row
      oDBTransaction.LoadTransactionDetails;

      // Check for change of Document Type
      If (oDBTransaction.thDocType <> CurrentDocType) Then
      Begin
        If (CurrentDocType <> RUN) Then
        Begin
          // Print transaction type totals for previous transaction type
          PrintTransactionTypeTotals;
        End; // If (CurrentDocType <> RUN)

        CurrentDocType := oDBTransaction.thDocType;

        // Print sub-title for new transaction type
        PrintTransactionTypeHeader (False);

        // Zero down transaction type totals
        FTransType_TotalSubTotal := 0.0;
        FTransType_TotalVAT := 0.0;
        FTransType_TotalTotal := 0.0;
      End; // If (oDBTransaction.thDocType <> CurrentDocType)

      PrintTransactionDetails (oDBTransaction.thOurRef,
                               oDBTransaction.thAcCode,
                               oDBTransaction.acCompany,
                               oDBTransaction.thYourRef,
                               PPR_OutPr(oDBTransaction.thPeriod, oDBTransaction.thYear),
                               oDBTransaction.thTransDate,
                               oDBTransaction.thDueDate,
                               oDBTransaction.thSubTotal,
                               oDBTransaction.thVAT,
                               oDBTransaction.thTotal);

      // Update running totals
      FTransType_TotalSubTotal := FTransType_TotalSubTotal + oDBTransaction.thSubTotal;
      FTransType_TotalVAT := FTransType_TotalVAT + oDBTransaction.thVAT;
      FTransType_TotalTotal := FTransType_TotalTotal + oDBTransaction.thTotal;
      FReport_TotalSubTotal := FReport_TotalSubTotal + oDBTransaction.thSubTotal;
      FReport_TotalVAT := FReport_TotalVAT + oDBTransaction.thVAT;
      FReport_TotalTotal := FReport_TotalTotal + oDBTransaction.thTotal;

      // Update the line count and progress - ignore total lines
      ICount := ICount + 1;
      If Assigned(ThreadRec) then
        UpDateProgress(2 + ICount);

      sqlCaller.Records.Next;
    End; // While (Not sqlCCDeptList.Records.EOF)

    // Print transaction type totals for last transaction type
    PrintTransactionTypeTotals;
  Finally
    FreeAndNIL(oDBTransaction);
  End; // Try..Finally
End; // RepPrint_ProcessFullDataset

//-------------------------------------------------------------------------

Procedure TSQLRep_TransactionDaybookReports.RepPrint(Sender : TObject);
Var
  sqlCaller : TSQLCaller;
  sqlQuery  : AnsiString;
Begin // RepPrint
  oReportLogger.StartReport;

  // Create SQL Query object to use for executing the stored procedure
  sqlCaller := TSQLCaller.Create;
  Try
    sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;
    sqlCaller.ConnectionString := ConnectionString;
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    sqlCaller.Connection.Password := Password;
    sqlQuery := '[COMPANY].isp_Report_Daybook ' +
                              '@intReportMode=' + IntToStr(Ord(ReportType)) + ', ' +
                              '@intExchYearFrom=' + IntToStr(ReportParameters.RYr) + ', ' +
                              '@intPeriodFrom=' + IntToStr(ReportParameters.RPr) + ', ' +
                              '@intExchYearTo=' + IntToStr(ReportParameters.RYr2) + ', ' +
                              '@intPeriodTo=' + IntToStr(ReportParameters.RPr2) + ', ' +
                              {$IFDEF MC_ON}
                              '@intCurrency=' + IntToStr(ReportParameters.RCr) + ', ' +
                              {$ELSE}
                              '@intCurrency=0, ' +
                              {$ENDIF}
                              '@strCostCentre=' + QuotedStr(ReportParameters.RCCDep[BOn]) + ', ' +
                              '@strDepartment=' + QuotedStr(ReportParameters.RCCDep[BOff]) + ', ' +
                              '@strAccountCode=' + QuotedStr(ReportParameters.CustFilt) + ', ' +
                              '@strFilter=' + QuotedStr(ReportParameters.DocWanted);

    ShowStatus(2,'Retrieving Data, Please Wait...');
    ShowStatus(3,'This can take several minutes');
    oReportLogger.StartQuery(sqlQuery);
    sqlCaller.Select(sqlQuery, CompanyCode);
    oReportLogger.FinishQuery;
    ShowStatus(2,'Processing Report.');
    ShowStatus(3,'');

    Try
      If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0) Then
      Begin
        oReportLogger.QueryRowCount(sqlCaller.Records.RecordCount);

        // Update the line count and progress
        If Assigned(ThreadRec) Then
        Begin
          InitProgress(sqlCaller.Records.RecordCount + 2);
          UpDateProgress(2);
        End; // If Assigned(ThreadRec)

        sqlCaller.Records.DisableControls;
        Try
          RepPrint_ProcessFullDataset(sqlCaller);
        Finally
          sqlCaller.Records.EnableControls;
        End; // Try..Finally

        // Print report grand totals
        If RepPrintExcelTotals then
          PrintReportTotals;
      End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
      Else If (sqlCaller.ErrorMsg <> '') Then
        WriteSQLErrorMsg (sqlCaller.ErrorMsg);
    Finally
      sqlCaller.Close;
    End; // Try..Finally
  Finally
    sqlCaller.Free;
  End; // Try..Finally

  // Print footer
  PrintEndPage;

  oReportLogger.FinishReport;
End; // RepPrint

//=========================================================================


End.
