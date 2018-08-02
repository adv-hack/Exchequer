Unit SQLRep_ConsolidatedAgedDebtorsCreditors;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses DB, Graphics, SysUtils, Math, StrUtils, GlobVar, VarConst, SQLCallerU, SQLRep_BaseReport, BTSupU3;

Type
  TAgedReportType = (rtAgedDebtors, rtAgedCreditors);

  //-------------------------------------------------------------------------

  TCADTransactionRowType = (rtTransaction, rtPostedBalance, rtMatching);

  TMoveNextEvent = Procedure (sqlCaller : TSQLCaller) of Object;

  TCADTransaction = Class(TObject)
  Private
    FBackdatedReport : Boolean;
    FReportForCurrency : Byte;
    FTranslateToCurrency : Byte;
    FAgeingDate     : LongDate;
    FAgeBy          : Byte;
    FAgeingInterval : Integer;

    FTransaction : InvRec;
    FAcCompany,
    FAcAltCode,
    FAcPhone,
    FDiscountStatus,
    FHoldStatus : ShortString;
    FEuroConversionDetected : Boolean;

    FAgedValues : AgedTyp;

    fldAcCode,
    fldAcCompany,
    fldAltCode,
    fldAcPhone,
    fldTHOurRef,
    fldTHYourRef,
    fldDiscountStatus,
    fldTHRemitNo : TStringField;
    fldIsMatching,
    fldIsPostedBal,
    fldTHSettleDiscTaken,
    fldUnPosted,
    fldEuroConversionRate : TBooleanField;
    fldTHDocType,
    flTHCurrency,
    fldMatchingCurrency,
    fldTHYear,
    fldTHPeriod,
    fldTHUseOriginalRates : TIntegerField;
    // MH 06/10/2014 Order Payments
    fldOrderPaymentElement : TIntegerField;
    fldDisplayDate,
    fldReceiptDate : TDateTimeField;
    fldTHNetValue,
    fldTHTotalVAT,
    fldTHTotalLineDiscount,
    fldTHRevalueADJ,
    fldTHSettleDiscAmount,
    fldTHVariance,
    fldTHPostDiscAm,
    fldTHAmountSettled,
    fldTHCurrSettled,
    fldTHDailyRate,
    fldTHCompanyRate,
    fldTHTotalReserved,
    fldPostedBalance : TFloatField;
    fldHoldStatus : TMemoField;

    Function GetRowType : TCADTransactionRowType;
    Function GetBooleanField (Index : Integer) : Boolean;
    Function GetDoubleField (Index : Integer) : Double;
    Function GetStringField (Index : Integer) : ShortString;
    Function GetAgedOutstandingValues (Index : Integer) : Real48;
    // MH 06/10/2014 Order Payments
    Function GetOrderPaymentElement : enumOrderPaymentElement;
  Public
    Procedure LinkToDB (Const sqlCaller : TSQLCaller);
    Procedure LoadTransactionDetails;
    Function CalcOutstandingAmount (sqlCaller : TSQLCaller; Const MoveNextFunc : TMoveNextEvent) : Double;

    Property BackdatedReport : Boolean Read FBackdatedReport Write FBackdatedReport;
    Property ReportForCurrency : Byte Read FReportForCurrency Write FReportForCurrency;
    Property TranslateToCurrency : Byte Read FTranslateToCurrency Write FTranslateToCurrency;
    Property AgeingDate : LongDate Read FAgeingDate Write FAgeingDate;
    Property AgeBy : Byte Read FAgeBy Write FAgeBy;
    Property AgeingInterval : Integer Read FAgeingInterval Write FAgeingInterval;

    Property acCode : ShortString Index 1 Read GetStringField;
    Property acCompany : ShortString Index 2 Read GetStringField;
    Property acAltCode : ShortString Index 3 Read GetStringField;
    Property acPhone : ShortString Index 4 Read GetStringField;
    Property acPostedBalance : Double Index 1 Read GetDoubleField;

    Property thOurRef : ShortString Index 8 Read GetStringField;
    Property thTransDate : ShortString Index 7 Read GetStringField;
    Property thYourRef : ShortString Index 9 Read GetStringField;
    Property thPosted : Boolean Index 2 Read GetBooleanField;
    Property thDiscountStatus : ShortString Index 5 Read GetStringField;
    Property thHoldStatus : ShortString Index 6 Read GetStringField;
    // MH 06/10/2014 Order Payments
    Property thOrderPaymentElement : enumOrderPaymentElement Read GetOrderPaymentElement;

    Property AgedOutstandingValues [Index : Integer] : Real48 Read GetAgedOutstandingValues;

    Property RowType : TCADTransactionRowType Read GetRowType;
    Property UndergoneEUROConversion : Boolean Index 1 Read GetBooleanField;
  End; // TCADTransaction

   //-------------------------------------------------------------------------

  TSQLRep_ConsolidatedAgedDebtorsCreditors = Object(TSQLRep_BaseReport)
    Procedure RepSetTabs; Virtual;
    Procedure RepPrintPageHeader; Virtual;
    Procedure RepPrintHeader(Sender : TObject); Virtual;
    Procedure RepPrint(Sender : TObject); Virtual;
  Private
    AgedAccountTotals : AgedTyp;
    AgedReportTotals : AgedTyp;
    TotalPostedBalance : Double;
    // LastAcCode stores the last Customer/Supplier Account Code for which a Sub-Title was printed
    LastAcCode,
    // The PrintingAcXXX fields store the Customer/Supplier Account Info for the currently printing customer, if
    // PrintingAcCode is blank then the current customer is not being printed
    PrintingAcCode, PrintingAcCompany, PrintingAcAltCode, PrintingAcPhone : ShortString;
    // The FoundEuroConversion is used to control whether the Euro Conversion warning is displayed in the report footer
    FoundEuroConversion : Boolean;
    // RowCount is used for the Thread Controller Progress and indicates the number of records in the dataset that have been processed so far
    RowCount : Integer;

    Procedure MoveNext (sqlCaller : TSQLCaller);
    Procedure UpdateRunningTotals (Var RunningTotals, LineTotals : AgedTyp);
    Function GetReportInput  :  Boolean; Virtual;
    Procedure RepPrint_ProcessFullDataset (sqlCaller : TSQLCaller);
    //Procedure RepPrint_ProcessSummaryDataset (sqlCaller : TSQLCaller);
    Procedure PrintAccountHeader (Const Continuation : Boolean);
    Procedure PrintTransactionDetails (oCADTransaction : TCADTransaction;
                                       Const TransValue : Double);
    Procedure PrintAccountSummary (Const PostedBalance : Double);
    Procedure PrintAccountTotals (Const PostedBalance : Double);
    Procedure PrintReportTotals;
  Public
    MaxProgress : LongInt;
    ReportType : TAgedReportType;
    ReportParameters : DueRepParam;
    CostCentreDesc : ShortString;
    DepartmentDesc : ShortString;

    // Cached SQL Emulator info to reduce overhead
    CompanyCode : WideString;
    ConnectionString : WideString;
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    Password: WideString;
    Procedure AddParameters;
    Procedure Process; Virtual;
    Function SQLLoggingArea : String; Virtual;
  End; // TSQLRep_ConsolidatedAgedDebtorsCreditors

Procedure SQLReport_PrintConsolidatedAgedDebtorsCreditors (Const Owner : TObject; Const ReportType : TAgedReportType; Const ReportParameters : DueRepParam);

Implementation

Uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU, ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, DocSupU1, SQLRep_Config,
     ComnUnit, VarRec2U;

//=========================================================================

// Links the internal DB Field objects to the ADODataset so the data can be accessed
Procedure TCADTransaction.LinkToDB (Const sqlCaller : TSQLCaller);
Begin // LinkToDB
  // Flag Fields
  fldIsMatching := sqlCaller.Records.FieldByName('IsMatchingDocumentsRow') As TBooleanField;
  fldIsPostedBal := sqlCaller.Records.FieldByName('IsPostedBalanceRow') As TBooleanField;
  fldEuroConversionRate := sqlCaller.Records.FieldByName('HasEuroConversions') As TBooleanField;

  // Customer/Supplier fields
  fldAcCode        := sqlCaller.Records.FieldByName('AccountCode') As TStringField;
  fldAcCompany     := sqlCaller.Records.FieldByName('acCompany') As TStringField;
  fldAltCode       := sqlCaller.Records.FieldByName('acAltCode') As TStringField;
  fldAcPhone       := sqlCaller.Records.FieldByName('acPhone') As TStringField;

  // Calculated Customer/Supplier fields
  fldPostedBalance := sqlCaller.Records.FieldByName('PostedBalance') As TFloatField;

  // Transaction fields
  fldTHOurRef            := sqlCaller.Records.FieldByName('Reference') As TStringField;
  fldTHYourRef           := sqlCaller.Records.FieldByName('YourReference') As TStringField;
  fldTHRemitNo           := sqlCaller.Records.FieldByName('RemitNo') As TStringField;
  fldTHSettleDiscTaken   := sqlCaller.Records.FieldByName('SettleDiscTaken') As TBooleanField;
  fldUnPosted            := sqlCaller.Records.FieldByName('HasUnpostedBalance') As TBooleanField;
  fldTHDocType           := sqlCaller.Records.FieldByName('DocType') As TIntegerField;
  flTHCurrency           := sqlCaller.Records.FieldByName('thCurrency') As TIntegerField;
  fldTHYear              := sqlCaller.Records.FieldByName('TransactionYear') As TIntegerField;
  fldTHPeriod            := sqlCaller.Records.FieldByName('TransactionPeriod') As TIntegerField;
  fldTHUseOriginalRates  := sqlCaller.Records.FieldByName('thUseOriginalRates') As TIntegerField;
  fldDisplayDate         := sqlCaller.Records.FieldByName('DisplayDate') As TDateTimeField;
  fldTHNetValue          := sqlCaller.Records.FieldByName('NetValue') As TFloatField;
  fldTHTotalVAT          := sqlCaller.Records.FieldByName('TotalVAT') As TFloatField;
  fldTHTotalLineDiscount := sqlCaller.Records.FieldByName('TotalLineDiscount') As TFloatField;
  fldTHRevalueADJ        := sqlCaller.Records.FieldByName('RevalueAdj') As TFloatField;
  fldTHSettleDiscAmount  := sqlCaller.Records.FieldByName('SettleDiscAmount') As TFloatField;
  fldTHVariance          := sqlCaller.Records.FieldByName('Variance') As TFloatField;
  fldTHPostDiscAm        := sqlCaller.Records.FieldByName('PostDiscAm') As TFloatField;
  fldTHAmountSettled     := sqlCaller.Records.FieldByName('AmountSettled') As TFloatField;
  fldTHCurrSettled       := sqlCaller.Records.FieldByName('CurrSettled') As TFloatField;
  fldTHDailyRate         := sqlCaller.Records.FieldByName('thDailyRate') As TFloatField;
  fldTHCompanyRate       := sqlCaller.Records.FieldByName('thCompanyRate') As TFloatField;
  fldTHTotalReserved     := sqlCaller.Records.FieldByName('TotalReserved') As TFloatField;
  // MH 06/10/2014 Order Payments
  fldOrderPaymentElement := sqlCaller.Records.FieldByName('OrderPaymentElement') As TIntegerField;

  // Calculated/Composite Transaction fields
  fldDiscountStatus := sqlCaller.Records.FieldByName('DiscountStatus') As TStringField;
  fldHoldStatus := sqlCaller.Records.FieldByName('HoldStatus') As TMemoField;

  // Matching fields
  fldReceiptDate := sqlCaller.Records.FieldByName('ReceiptDate') As TDateTimeField;
  fldMatchingCurrency := sqlCaller.Records.FieldByName('CurrencyId') As TIntegerField;
End; // LinkToDB

//-------------------------------------------------------------------------

Function TCADTransaction.CalcOutstandingAmount (sqlCaller : TSQLCaller; Const MoveNextFunc : TMoveNextEvent) : Double;
Var
  MatchingTransaction : InvRec;
  MatchingRec : MatchPayType;
  DiffCurr, FoundOK, MatchedDoc : Boolean;
  UOR : Byte;
  DNum, VRate, InitValue, AddVar : Double;
Begin // CalcOutstandingAmount
  Result := 0.0;

  If FBackdatedReport Then
  Begin
    // Filter out direct transactions (SRI/PPI) as they should never be outstanding - but may be included in the report if Show O/S Only is unticked
    If (Not (FTransaction.InvDocHed In DirectSet)) Then
    Begin
      // Calculate full transaction value and then run through the Matching to take off
      // any Matching performed after the backdating date

      if (FReportForCurrency = 0) or
         (
          (FReportForCurrency = 1) and
          (FTransaction.InvDocHed In RecieptSet) and
          (Round_Up(FTransaction.TotalReserved,2) = (Round_up(FTransaction.Variance,2) + Round_up(FTransaction.PostDiscAm, 2)))
          //HV 13/04/2017 2017-R1 ABSEXCH-16868: back dated aged report incorrectly shows discount as outstanding
         ) then
        InitValue := ConvCurrITotal(FTransaction, BOff, BOn, BOn)
      else
        InitValue := ITotal(FTransaction);

      InitValue := InitValue * DocCnst[FTransaction.InvDocHed] * DocNotCnst;

      DiffCurr := BOff;

      MatchedDoc := (FTransaction.RemitNo <> '');

      // Look for Matching rows for the backdating
      MoveNextFunc(sqlCaller);
      While (Not sqlCaller.Records.EOF) And (GetRowType = rtMatching) Do
      Begin
        //
        // The following section of code has been ported from TADebReport.Calc_PrevAgedBal in ReportU.Pas, the original
        // structure has been kept largely intact in order to reduce risk, this has also resulted in the creation of fake
        // records to minimise changes.
        //

        // Create fake matching record
        FillChar (MatchingRec, SizeOf(MatchingRec), #0);
        With MatchingRec Do
        Begin
          MCurrency := fldMatchingCurrency.Value;
          SettledVal := fldTHAmountSettled.Value;
          OwnCVal := fldTHCurrSettled.Value;
        End; // With MatchingRec

        // Create fake transaction record to store the details for the transaction identified by the matching record
        FillChar(MatchingTransaction, SizeOf(MatchingTransaction), #0);
        With MatchingTransaction Do
        Begin
          Currency     := flTHCurrency.Value;
          CXrate[BOn]  := fldTHDailyRate.Value;
          CXrate[BOff] := fldTHCompanyRate.Value;
          UseORate     := fldTHUseOriginalRates.Value;
        End; // With MatchingTransaction

        // FoundOK indicates whether the other transaction identified by the Matching record was found
        FoundOK := (fldReceiptDate.Value > 0);

        {*If the other part of the match cannot be found, and it has been purged, assume it was purged *}
        If (Not FoundOK) And (Syss.AuditYr <> 0) Then
        Begin
          If (FReportForCurrency = 0) Then
            Result := Result + MatchingRec.SettledVal
          Else
            Result := Result + MatchingRec.OwnCVal;
        End; // If (Not FoundOK) And (Syss.AuditYr <> 0)

        // Following check not required as being performed within Stored Procedure
        //If (fldReceiptDate.Value <> 0) And (Pr2Fig(LInv.AcYr,LInv.AcPr) <= Pr2Fig(RYr,RPr)) Then
        Begin
          If (Not DiffCurr) then {*v4.31.004 if matched with mixed currency readd in variance on receipts*}
            DiffCurr := MatchingTransaction.Currency <> FTransaction.Currency;

          If (MatchedDoc) Or (FReportForCurrency = 0) Then
          Begin
            If (FReportForCurrency = 0) Then
              Result := Result + MatchingRec.SettledVal
            Else
              Result := Result + MatchingRec.OwnCVal;
          End // If (MatchedDoc) Or (FReportForCurrency = 0)
          Else
          Begin
            If (MatchingTransaction.Currency = MatchingRec.MCurrency) Then {* Go via docs own currency rate *}
            Begin
              If (MatchingRec.MCurrency <> FTransaction.Currency) Then {* Convert via sterling *}
              Begin
                // Convert matched amount from payment transaction to Base Currency
                UOR := fxUseORate(BOff, BOn, MatchingTransaction.CXRate, MatchingTransaction.UseORate, MatchingRec.MCurrency, 0);
                Dnum := Conv_TCurr(MatchingRec.OwnCVal, XRate(MatchingTransaction.CXRate, BOff, MatchingRec.MCurrency), MatchingRec.MCurrency, UOR, BOff);

                // Convert matched amount to Invoice Currency
                UOR := fxUseORate(BOff, BOn, FTransaction.CXRate, FTransaction.UseORate, FTransaction.Currency, 0);
                Result := Result + Conv_TCurr(Dnum, XRate(FTransaction.CXRate, BOff, FTransaction.Currency), FTransaction.Currency,UOR,BOn);
              End // If (MatchingRec.MCurrency <> FTransaction.Currency)
              Else
                Result := Result + MatchingRec.OwnCVal;
            End // If (MatchingTransaction.Currency = MatchingRec.MCurrency)
            Else
            Begin
              If (MatchingRec.MCurrency <> FTransaction.Currency) Then
                Result := Result + Currency_ConvFT(MatchingRec.OwnCVal, MatchingRec.MCurrency, FTransaction.Currency, UseCoDayRate)
              Else
                Result := Result + MatchingRec.OwnCVal;
            End; // Else
          End; // Else
        End;

        // Move to the next dataset row and update the progress
        MoveNextFunc(sqlCaller);
      End; // While (Not sqlCaller.Records.EOF) And (GetRowType = rtMatching)

      {* v4.31.004 add back in variance to receipts matched with mixed currencies as it will be needed*}
      If (FTransaction.InvDocHed In RecieptSet) And DiffCurr And (FReportForCurrency > 1) And (FTransaction.Variance <> 0.0) Then
      Begin
        VRate := XRate(FTransaction.CXRate, BOff, FTransaction.Currency);

        AddVar := Round_Up(Conv_TCurr(FTransaction.Variance, VRate, FTransaction.Currency, FTransaction.UseORate, BOn), 2) * DocCnst[FTransaction.InvDocHed] * DocNotCnst;

        InitValue := InitValue + AddVar;
      End; // If (FTransaction.InvDocHed In RecieptSet) And DiffCurr And (FReportForCurrency > 1) And (FTransaction.Variance <> 0.0)

      If MatchedDoc Then
        Result := Round_Up(InitValue - Result,2)
      else
        Result := Round_Up(InitValue + Result,2);

      {$IFDEF MC_On} {* v4.30 Surpress odd fractions due to rounding because vat element
                        normally is rounded up seperately, and matched amount is one lump *}
        If (ABS(Result) < 0.02) And (Result <> 0.00) And (FReportForCurrency <> 0) then
          Result:=0.0;
      {$ENDIF}
    End // If (Not (FTransaction.InvDocHed In DirectSet))
    Else
    Begin
      // SRI/PPI
      Result := 0;

      // Move to the next dataset row and update the progress
      MoveNextFunc(sqlCaller);
    End; // Else
  End // If FBackdatedReport
  Else
  Begin
    // Not Backdated - just calculate the current outstanding value
    If (FReportForCurrency = 0) Then
      // Report for Consolidated
      Result := BaseTotalOS(FTransaction)
    Else
      // Report for Currency X
      Result := CurrencyOS(FTransaction, BOn, BOff, BOff);

    // Move to the next dataset row and update the progress
    MoveNextFunc(sqlCaller);
  End; // Else

  //------------------------------

  // Convert outstanding amount to Translate To Currency ready for output
  Result := Currency_Txlate (Result, FReportForCurrency, FTranslateToCurrency);

  //------------------------------

  // Age the Outstanding Transaction Value using the specified parameters
  Blank(FAgedValues, SizeOf(FAgedValues));
  MasterAged(FAgedValues, FTransaction.TransDate, FAgeingDate, Result, FAgeBy, FAgeingInterval);
End; // CalcOutstandingAmount

//-------------------------------------------------------------------------

Procedure TCADTransaction.LoadTransactionDetails;
Begin // LoadTransactionDetails
  FillChar(FTransaction, SizeOf(FTransaction), #0);
  With FTransaction Do
  Begin
    NomAuto         := True;               // Filter only allows NomAuto = TRUE through
    RunNo           := IfThen(fldUnPosted.Value, 0, 1);   // best we can fake with info provided
    OurRef          := fldTHOurRef.Value;
    CustCode        := fldAcCode.Value;
    Currency        := flTHCurrency.Value;
    AcYr            := fldTHYear.Value;
    AcPr            := fldTHPeriod.Value;
    TransDate       := FormatDateTime('YYYYMMDD', fldDisplayDate.Value);
    CXrate[BOn]     := fldTHDailyRate.Value;
    CXrate[BOff]    := fldTHCompanyRate.Value;
    InvDocHed       := DocTypes(fldTHDocType.Value);
    InvNetVal       := fldTHNetValue.Value;
    InvVat          := fldTHTotalVAT.Value;
    DiscSetAm       := fldTHSettleDiscAmount.Value;
    DiscAmount      := fldTHTotalLineDiscount.Value;
    DiscTaken       := fldTHSettleDiscTaken.Value;
    Settled         := fldTHAmountSettled.Value;
    RemitNo         := fldTHRemitNo.Value;
    Variance        := fldTHVariance.Value;
    TotalReserved   := fldTHTotalReserved.Value;
    ReValueAdj      := fldTHRevalueADJ.Value;
    CurrSettled     := fldTHCurrSettled.Value;
    PostDiscAm      := fldTHPostDiscAm.Value;
    UseORate        := fldTHUseOriginalRates.Value;
    YourRef         := fldTHYourRef.Value;
    // MH 06/10/2014 Order Payments
    thOrderPaymentElement := enumOrderPaymentElement(fldOrderPaymentElement.Value);
  End; // With FTransaction

  FAcCompany := fldAcCompany.Value;
  FAcAltCode := fldAltCode.Value;
  FAcPhone   := fldAcPhone.Value;

  FDiscountStatus := fldDiscountStatus.Value;
  FHoldStatus := fldHoldStatus.Value;
  FEuroConversionDetected := fldEuroConversionRate.Value;
End; // LoadTransactionDetails

//-------------------------------------------------------------------------

Function TCADTransaction.GetRowType : TCADTransactionRowType;
Begin // GetRowType
  If fldIsMatching.Value Then
    Result := rtMatching
  Else If fldIsPostedBal.Value Then
    Result := rtPostedBalance
  Else
    Result := rtTransaction;
End; // GetRowType

//------------------------------

// MH 06/10/2014 Order Payments
Function TCADTransaction.GetOrderPaymentElement : enumOrderPaymentElement;
Begin // GetOrderPaymentElement
  Result := FTransaction.thOrderPaymentElement;
End; // GetOrderPaymentElement

//------------------------------

Function TCADTransaction.GetAgedOutstandingValues (Index : Integer) : Real48;
Begin // GetAgedOutstandingValues
  If (Index >= Low(FAgedValues)) And (Index <= High(FAgedValues)) Then
    Result := FAgedValues[Index]
  Else
    Raise Exception.Create ('TCADTransaction.GetAgedOutstandingValues: Invalid Index (' + IntToStr(Index) + ')');
End; // GetAgedOutstandingValues

//------------------------------

Function TCADTransaction.GetBooleanField (Index : Integer) : Boolean;
Begin // GetBooleanField
  Case Index Of
    1 : Result := FEuroConversionDetected;
    2 : Result := (FTransaction.RunNo > 0);
  Else
    Result := False;
  End; // Case Index
End; // GetBooleanField

//------------------------------

Function TCADTransaction.GetDoubleField (Index : Integer) : Double;
Begin // GetDoubleField
  Case Index Of
    // Posted Balance - Only used when on Posted Balance row so this can be read direct
    1 : Result := Currency_Txlate (fldPostedBalance.Value, FReportForCurrency, FTranslateToCurrency);
  Else
    Result := 0.0;
  End; // Case Index
End; // GetDoubleField

//------------------------------

Function TCADTransaction.GetStringField (Index : Integer) : ShortString;
Begin // GetStringField
  Case Index Of
    1 : Result := FTransaction.CustCode;
    2 : Result := FAcCompany;
    3 : Result := FAcAltCode;
    4 : Result := FAcPhone;
    5 : Result := FDiscountStatus;
    6 : Result := FHoldStatus;
    7 : Result := FTransaction.TransDate;
    8 : Result := FTransaction.OurRef;
    9 : Result := FTransaction.YourRef;
  Else
    Result := '';
  End; // Case Index
End; // GetStringField

//=========================================================================

Procedure SQLReport_PrintConsolidatedAgedDebtorsCreditors (Const Owner : TObject; Const ReportType : TAgedReportType; Const ReportParameters : DueRepParam);
Var
  SQLRep : ^TSQLRep_ConsolidatedAgedDebtorsCreditors;
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
      //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
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

Begin // SQLReport_PrintConsolidatedAgedDebtorsCreditors
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

        If ReportParameters.PrintParameters Then
          SQLRep^.AddParameters;

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
End; // SQLReport_PrintConsolidatedAgedDebtorsCreditors

//=========================================================================

Function TSQLRep_ConsolidatedAgedDebtorsCreditors.SQLLoggingArea : String;
Begin // SQLLoggingArea
  Result := 'ConsolidatedAgingReport';
End; // SQLLoggingArea

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.UpdateRunningTotals (Var RunningTotals, LineTotals : AgedTyp);
Var
  iTotal : SmallInt;
Begin // UpdateRunningTotals
  For iTotal := Low(AgedTyp) To High(AgedTyp) Do
  Begin
    RunningTotals[iTotal] := RunningTotals[iTotal] + LineTotals[iTotal];
  End; // For iTotal
End; // UpdateRunningTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.AddParameters;
Const
  AgingStrings : Array[1..3] of string[6] = ('Days','Weeks','Months');
Begin // AddParameters
  If Assigned(oPrintParams) Then
  Begin
    With oPrintParams.AddParam Do
    Begin
      Name :=  'Summary Report';
      Value := ReportParameters.Summary;
    End; // With oPrintParams.AddParam

    {$IFDEF MC_ON}
      With oPrintParams.AddParam Do
      Begin
        Name :=  'Report for Currency';
        Value := TxLatePound(CurrDesc(ReportParameters.RCr), True);
      End; // With oPrintParams.AddParam

      With oPrintParams.AddParam Do
      Begin
        Name :=  'Translate to Currency';
        Value := TxLatePound(CurrDesc(ReportParameters.RTxCr), True);
      End; // With oPrintParams.AddParam
    {$ENDIF}

    With oPrintParams.AddParam Do
    Begin
      Name := 'Account';
      Value := ReportParameters.AcFilt;
    End; // With oPrintParams.AddParam

    With oPrintParams.AddParam Do
    Begin
      Name := 'Control GL Code';
      if ReportParameters.CtrlNomFilt = 0 then
        Value := ''
      else
        Value := ReportParameters.CtrlNomFilt;
    End; // With oPrintParams.AddParam

    If Syss.UseCCDep Then
    Begin
      With oPrintParams.AddParam Do
      Begin
        Name :=  'Cost Centre';
        Value := ReportParameters.RCCDep[True];
      End; // With oPrintParams.AddParam

      With oPrintParams.AddParam Do
      Begin
        Name :=  'Department';
        Value := ReportParameters.RCCDep[False];
      End; // With oPrintParams.AddParam
    End; // If Syss.UseCCDep

    With oPrintParams.AddParam Do
    Begin
      Name := 'Age Report by';
      Value := AgingStrings[ReportParameters.RAgeBy];
    End; // With oPrintParams.AddParam

    With oPrintParams.AddParam Do
    Begin
      Name := 'Aging Interval';
      Value := ReportParameters.RAgeInt;
    End; // With oPrintParams.AddParam

    With oPrintParams.AddParam Do
    Begin
      Name := 'O/S Transactions Only';
      Value := ReportParameters.OSOnly;
    End; // With oPrintParams.AddParam

    With oPrintParams.AddParam Do
    Begin
      Name :=  'Posted Balance as at';
      Value := PPR_OutPr(ReportParameters.RPr, ReportParameters.RYr);
    End; // With oPrintParams.AddParam

    With oPrintParams.AddParam Do
    Begin
      Name := 'Backdate to Per/Yr';
      Value := ReportParameters.PrevMode;
    End; // With oPrintParams.AddParam

    bPrintParams := True;
  End; // if Assigned(oPrintParams)
End; // AddParameters

//-------------------------------------------------------------------------

// Called by the threading to execute whatever processing is required
Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.Process;
Begin // Process
  // Initialise the Progress Bar range
  InitProgress(MaxProgress);
  UpdateProgress(1);

  Inherited Process;
End; // Process

//-------------------------------------------------------------------------

Function TSQLRep_ConsolidatedAgedDebtorsCreditors.GetReportInput : Boolean;
Var
  sqlCaller : TSQLCaller;
  sQuery, sQueryResult : ANsIString;
  n : Integer;
Begin // GetReportInput
  With ReportParameters do
  Begin
    //Filt:=TradeCode[IsPay];

    ThTitle := 'Aged ' + IfThen(ReportType = rtAgedDebtors, 'Debtors', 'Creditors') + ' Report';
    RepTitle := ThTitle;
    PageTitle := ThTitle + ' - Posted bal as at ' + PPR_OutPr(RPr, RYr) + ' Aged by ' + AgedHed[RAgeBy];

    If (Trim(RCCDep[True]) <> '') Or (Trim(RCCDep[False]) <> '') Or (Trim(ACFilt) <> '') Or (CtrlNomFilt <> 0)Then
    Begin
      // Create SQL Query object to use for executing the stored procedure
      sqlCaller := TSQLCaller.Create;//(GlobalADOConnection);  // Removed shared connection due to errors when multiple reports running simultaneously
      Try
        sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;
        sqlCaller.ConnectionString := ConnectionString;
        //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
        sqlCaller.Connection.Password := Password;

        Try
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

            RepTitle2 := 'Cost Centre: ' + dbFormatName(Trim(RCCDep[True]), sQueryResult);
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
            RepTitle2 := RepTitle2 + 'Department: ' + dbFormatName(Trim(RCCDep[False]), sQueryResult);
          End; // If (Trim(RCCDep[False]) <> '')

          // Account Filter Company Name
          If (Trim(ACFilt) <> '') Then
          Begin
            sQuery := 'SELECT acCompany FROM [COMPANY].CustSupp WHERE acCode=' + QuotedStr(ACFilt);
            sqlCaller.Select(sQuery, CompanyCode);
            Try
              If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount = 1) Then
              Begin
                sqlCaller.Records.First;
                sQueryResult := Trim(sqlCaller.Records.FieldByName('acCompany').Value);
              End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
              Else
              Begin
                sQueryResult := '';
                oReportLogger.LogInfo('Retrieve Company Name', sQuery);
                If (sqlCaller.ErrorMsg <> '') Then
                  oReportLogger.LogError('Retrieve Company Name', sqlCaller.ErrorMsg);
              End; // Else
            Finally
              sqlCaller.Close;
            End; // Try..Finally

            If (RepTitle2 <> '') then
              RepTitle2 := RepTitle2 + '. ';
            RepTitle2 := RepTitle2 + 'Account Filter : ' + dbFormatName(ACFilt, sQueryResult);
          End; // If (Trim(ACFilt) <> '')

          // GL Control Code Filter
          If (CtrlNomFilt <> 0) Then
          Begin
            sQuery := 'SELECT glName FROM [COMPANY].Nominal WHERE glCode=' + IntToStr(CtrlNomFilt);
            sqlCaller.Select(sQuery, CompanyCode);
            Try
              If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount = 1) Then
              Begin
                sqlCaller.Records.First;
                sQueryResult := Trim(sqlCaller.Records.FieldByName('glName').Value);
              End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
              Else
              Begin
                sQueryResult := '';
                oReportLogger.LogInfo('Retrieve Ctrl GL Desc', sQuery);
                If (sqlCaller.ErrorMsg <> '') Then
                  oReportLogger.LogError('Retrieve Ctrl GL Desc', sqlCaller.ErrorMsg);
              End; // Else
            Finally
              sqlCaller.Close;
            End; // Try..Finally

            If (RepTitle2 <> '') then
              RepTitle2 := RepTitle2 + '. ';
            RepTitle2 := RepTitle2 + 'G/L Ctrl Code Filter : ' + dbFormatName(Form_Int(CtrlNomFilt,0), sQueryResult) + '.';
          End; // If (CtrlNomFilt <> 0)
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
    End; // If (Trim(RCCDep[True]) <> '') Or (Trim(RCCDep[False] <> '') Or (Trim(ACFilt) <> '') Or (CtrlNomFilt <> 0)

    // Column titles
    For n:=1 to 4 do
    Begin
      AgeTit[n]:=Form_Int((RAgeInt*n),0)+' '+AgedHed[RAgeBy];

      If ((n*RAgeInt)>1) then
        AgeTit[n]:=AgeTit[n]+'s';

      If (n=4) then
        AgeTit[n]:=AgeTit[n]+'+';
    end;

    // Ageing Date
    DueLimit := Today;
    If (PrevMode) then
      DueLimit := LPr2Date(RPr,RYr,MTExLocal);

    RFont.Size:=7;
    ROrient:=RPDefine.PoLandscape;

    {$IFDEF MC_On}
      // Report For Currrency
      If (RTxCr<>0) and (RTxCr<>RCr) then
        RepTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+RepTitle
      else
        RepTitle:=CurrDesc(RCr)+RepTitle;

      // Translate To Currency
      If (RTxCr<>0) and (RTxCr<>RCr) then
        PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
      else
        PageTitle:=CurrDesc(RCr)+PageTitle;
    {$ENDIF}
  End; // With ReportParameters

  Result := True;
End; // GetReportInput

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.RepSetTabs;
Begin // RepSetTabs
  With RepFiler1 do
  Begin
    // Tab settings differ between full and summary reports
    If Not ReportParameters.Summary Then
    Begin
      // Full report
      // MH 06/10/2014 Order Payments: Modified column widths to allow for Order Payments flag
      SetTab (MarginLeft,  pjLeft, 18, 4, 0, 0);         // Ourref
      SetTab (NA, pjLeft,  32, 4, 0, 0);                 // YourRef
      SetTab (NA, pjLeft,  15, 4, 0, 0);                 // Date
      SetTab (NA, pjRight, 26, 4, 0, 0);                 // Total OS
      SetTab (NA, pjRight, 26, 4, 0, 0);                 // Not Due
      SetTab (NA, pjRight, 26, 4, 0, 0);                 // Current
      SetTab (NA, pjRight, 26, 4, 0, 0);                 // Age1
      SetTab (NA, pjRight, 26, 4, 0, 0);                 // Age2
      SetTab (NA, pjRight, 25, 4, 0, 0);                 // Age3
      SetTab (NA, pjRight, 26, 4, 0, 0);                 // Age4
      SetTab (NA, pjRight, 26, 4, 0, 0);                 // Total Due
      SetTab (NA, pjLeft,   8, 4, 0, 0);                 // Discount Status / Hold Flag
    End // If Not ReportParameters.Summary
    Else
    Begin
      // Standard report
      SetTab (MarginLeft, pjLeft, 15, 4, 0, 0);
      SetTab (NA, pjLeft, 42, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
      SetTab (NA, pjRight, 28, 4, 0, 0);
    End;
  End; // With RepFiler1

  SetTabCount;
End; // RepSetTabs

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.RepPrintHeader(Sender : TObject);
Begin // RepPrintHeader
  Inherited;

  If (RepFiler1.CurrentPage > 1) And (Not ReportParameters.Summary) Then
    PrintAccountHeader (True);
End; // RepPrintHeader

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.RepPrintPageHeader;
Var
  n       :  Byte;
  GenStrDate, GenStr  :  Str255;
Begin // RepPrintPageHeader
  GenStr:='';
  GenStrDate:='';

  With RepFiler1, ReportParameters Do
  Begin
    DefFont(0,[fsBold]);

    // Header differs between full and summary reports
    If Not ReportParameters.Summary Then
    Begin
      // Full report
      If ((ReportType = rtAgedDebtors) And (Syss.StaUIDate)) Or ((ReportType = rtAgedCreditors) And (Syss.PurchUIDate)) Then
        GenStrDate := 'Trans. Date'
      Else
        GenStrDate := 'Due Date';

      GenStr := ConCat(#9, 'Our Ref', #9, 'Your Ref', #9, GenStrDate, #9, 'Total O/S', #9, 'Not Due', #9, 'Current');

      For n:=1 to 4 do
        GenStr := GenStr+ ConCat(#9, AgeTit[n]);

      GenStr := GenStr+ConCat(#9, 'Total Due', #9, 'SD');
    End // If Not ReportParameters.Summary
    Else
    Begin
      // Summary Report
      GenStr:=ConCat(#9, 'A/C Cde', #9, 'Account Name', #9, 'Posted Bal.', #9, 'Total O/S', #9, 'Not Due', #9, 'Current');

      For n := 1 to 4 do
        GenStr := GenStr+ConCat(#9, AgeTit[n]);
    End; // Else

    SendLine(GenStr);

    DefFont(0,[]);
  End; // With RepFiler1, ReportParameters
End; // RepPrintPageHeader

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.PrintAccountHeader (Const Continuation : Boolean);
Var
  sSubTitle : ShortString;
Begin // PrintAccountHeader
  // Only print sub-title on page change if account code not changed
  If (Not Continuation) Or (Continuation And (LastAcCode = PrintingAcCode)) Then
  Begin
    LastAcCode := PrintingAcCode;

    With RepFiler1 Do
    Begin
      DefFont(0,[fsBold]);

      // Code + Company
      sSubTitle := dbFormatName(PrintingAcCode, PrintingAcCompany);

      // AltCode if set
      If (Trim(PrintingAcAltCode) <> '') Then
        sSubTitle := sSubTitle + ', ' + Trim(PrintingAcAltCode);

      // Phone if set
      If (Trim(PrintingAcPhone) <> '') Then
        sSubTitle := sSubTitle + ', ' + Trim(PrintingAcPhone);

      If Continuation Then
        sSubTitle := sSubTitle + ' (continued...)';

      // Set print preview drill-down information
      SendRepSubHedDrillDown (MarginLeft, PageWidth + MarginLeft, 1, PrintingAcCode, CustF, CustCodeK,0);

      // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintLeft(sSubTitle,MarginLeft);
      Self.CrLF;
      DefLine(-1,1,100,-0.3);
      DefFont(0,[]);
    End; // With RepFiler1
  End; // If (LastAcCode <> CurrentAcCode)
End; // PrintAccountHeader

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.PrintTransactionDetails (oCADTransaction : TCADTransaction;
                                                                            Const TransValue : Double);
Var
  AgedValues : AgedTyp;
  I : Byte;
Begin // PrintTransactionDetails
  // Copy the Aged Outstanding Transaction Value into a local variable for use
  Blank(AgedValues, SizeOf(AgedValues));
  For I := Low(AgedValues) To High(AgedValues) Do
    AgedValues[I] := oCADTransaction.AgedOutstandingValues[I];

    // Don't print the transaction detail in summary mode
  If (Not ReportParameters.Summary) Then
  Begin
    // Add drill-down info for print preview window
    SendRepDrillDown(1, TotTabs, 1, oCADTransaction.thOurRef, InvF, InvOurRefK, 0);

    // Print the transaction details
    // MH 06/10/2014 Order Payments: Added Order Payments flag
    SendLine (#9 + oCADTransaction.thOurRef +
                   IfThen(oCADTransaction.thPosted, '', '*') +
                   IfThen(oCADTransaction.thOrderPaymentElement <> opeNA, '!', '') +
              #9 + oCADTransaction.thYourRef +
              #9 + POutDate(oCADTransaction.thTransDate) +
              #9 + FormatFloat(GenRealMask, AgedValues[7]) +          // Total Outstanding
              #9 + FormatBFloat(GenRealMask, AgedValues[0], BOn) +    // 0 - Not Due
              #9 + FormatBFloat(GenRealMask, AgedValues[1], BOn) +    // 1 - Current
              #9 + FormatBFloat(GenRealMask, AgedValues[2], BOn) +    // 2
              #9 + FormatBFloat(GenRealMask, AgedValues[3], BOn) +    // 3
              #9 + FormatBFloat(GenRealMask, AgedValues[4], BOn) +    // 4
              #9 + FormatBFloat(GenRealMask, AgedValues[5], BOn) +    // 5
              #9 + FormatBFloat(GenRealMask, AgedValues[6], BOn) +    // Total Due
              #9 + oCADTransaction.thDiscountStatus +                 // Settlement Discount Status
                   oCADTransaction.thHoldStatus);                     // Hold Status
  End; // If (Not ReportParameters.Summary)

  // Update Customer Totals and Report Grand Totals
  UpdateRunningTotals (AgedAccountTotals, AgedValues);
  UpdateRunningTotals (AgedReportTotals, AgedValues);
End; // PrintTransactionDetails

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.PrintAccountSummary (Const PostedBalance : Double);
Var
  GenStr : ShortString;
Begin // PrintAccountSummary
  // Add drill-down info for print preview window
  SendRepDrillDown(1, TotTabs, 1, FullCustCode(PrintingAcCode), CustF, CustCodeK, 0);

  // Print the account summary
  GenStr := #9 + PrintingAcCode +
            #9 + PrintingAcCompany +
            #9 + FormatFloat(GenRealMask, PostedBalance) +
            #9 + FormatFloat(GenRealMask, AgedAccountTotals[7]) +
            #9 + FormatFloat(GenRealMask, AgedAccountTotals[0]) +
            #9 + FormatFloat(GenRealMask, AgedAccountTotals[1]) +
            #9 + FormatFloat(GenRealMask, AgedAccountTotals[2]) +
            #9 + FormatFloat(GenRealMask, AgedAccountTotals[3]) +
            #9 + FormatFloat(GenRealMask, AgedAccountTotals[4]) +
            #9 + FormatFloat(GenRealMask, AgedAccountTotals[5]);

  SetReportDrillDown(0);
  SendLine(GenStr);
End; // PrintAccountSummary

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.PrintAccountTotals (Const PostedBalance : Double);
Var
  sSubTotals : ShortString;
Begin // PrintAccountTotals
  With RepFiler1 Do
  Begin
    DefLine(-1.3,1,PageWidth-MarginRight-1,-0.5);

    sSubTotals := #9 + 'Posted Bal:' +
                  #9 + FormatBFloat(GenRealMask, PostedBalance, BOff) +
                  #9 + 'Totals ..:' +
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[7], BOff) +    // Total Outstanding
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[0], BOff) +    // 0 - Not Due
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[1], BOff) +    // 1 - Current
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[2], BOff) +    // 2
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[3], BOff) +    // 3
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[4], BOff) +    // 4
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[5], BOff) +    // 5
                  #9 + FormatBFloat(GenRealMask, AgedAccountTotals[6], BOff);     // Total Due
    SendLine(sSubTotals);
    // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.CRLF;
  End; // With RepFiler1
End; // PrintAccountTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.PrintReportTotals;
Var
  sTotals : ShortString;
   Middle :  Longint;
Begin // PrintReportTotals
  With RepFiler1 Do
  Begin
// MH 06/10/2014 Order Payments: Moved location of explanitory text
//    If (Not ReportParameters.Summary) Then
//    Begin
//      DefFont(-2,[fsItalic,fsBold]);
//      PrintLeft('* denotes unposted transactions',MarginLeft);
//    End; // If (Not ReportParameters.Summary)
    DefLine(-1,1,PageWidth-MarginRight-1,0);

    // Ageing Grand Totals
    DefFont(0,[]);

    sTotals := IfThen (Not ReportParameters.Summary, #9, '') +
               #9 +
               #9 + 'Totals ..:';

    If ReportParameters.Summary Then
      sTotals :=  sTotals +
               #9 + FormatFloat(GenRealMask, TotalPostedBalance);

    sTotals :=  sTotals +
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[7], BOff) +    // Total Outstanding
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[0], BOff) +    // 0 - Not Due
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[1], BOff) +    // 1 - Current
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[2], BOff) +    // 2
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[3], BOff) +    // 3
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[4], BOff) +    // 4
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[5], BOff);     // 5

    If (Not ReportParameters.Summary) Then
      sTotals :=  sTotals +
               #9 + FormatBFloat(GenRealMask, AgedReportTotals[6], BOff);     // Total Due

    SendLine(sTotals);
    DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

    If (Not ReportParameters.Summary) Then
    Begin
      // Posted Balances Grand Totals
      sTotals := #9 + 'Posted Bals:' + #9 + FormatBFloat (GenRealMask, TotalPostedBalance, False);
      SendLine(sTotals);

      // MH 06/10/2014 Order Payments: Moved location of explanatory text
      DefFont(-2,[fsItalic,fsBold]);
      // Clear the tabs to prevent the text being chopped off - this is called at the end of
      // the report so we don't need the tabs anymore anyway
      ClearTabs;
      SetTab (MarginLeft, pjLeft, PageWidth-MarginLeft, 4, 0, 0);
      // MH 08/01/2015 v7.1 ABSEXCH-15970: Suppress message for non-UK companies
      // MH 03/06/2015 2015-R1 ABSEXCH-16376: Remove Order Payments note from non-SPOP systems
      SendLine(#9'* denotes unposted transactions'{$IFDEF SOP}+ IfThen((ReportType = rtAgedDebtors) And (CurrentCountry = UKCCode), ', ! denotes Order Payment transactions', ''){$ENDIF SOP});
      DefFont(0,[]);
    End; // If (Not ReportParameters.Summary)

    If FoundEuroConversion and RepPrintExcelTotals Then
    Begin
      // Euro-Conversion notice
      Middle:=Round(PageWidth / 2);
      If (LinesLeft<5) then
        ThrowNewPage(5);
      // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CRLF;
      DefFont (0,[fsBold,fsUnderLine]);
      // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter ('Note', Middle); Self.CRLF;
      DefFont (0,[fsBold]);
      sTotals:='Base conversion transactions are contained within this report, which may contain small rounding differences that are not considered material.';
      // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter(sTotals, Middle);
      Self.CRLF;
      Self.CRLF;
    End; // If FoundEuroConversion and RepPrintExcelTotals
  End; // With RepFiler1
End; // PrintReportTotals

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.MoveNext (sqlCaller : TSQLCaller);
Begin // MoveNext
  // Update the line count and progress - ignore total lines
  RowCount := RowCount + 1;
  If Assigned(ThreadRec) then
    UpDateProgress(2 + RowCount);

  sqlCaller.Records.Next;
End; // MoveNext

//------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.RepPrint_ProcessFullDataset (sqlCaller : TSQLCaller);
Var
  oCADTransaction : TCADTransaction;
  OutstandingVal : Double;
Begin // RepPrint_ProcessFullDataset
  // Initialise reporting variables
  LastAcCode := '';
  PrintingAcCode := '';
  PrintingAcCompany := '';
  PrintingAcAltCode := '';
  PrintingAcPhone := '';

  FillChar(AgedAccountTotals, SizeOf(AgedAccountTotals), 0);
  FillChar(AgedReportTotals, SizeOf(AgedReportTotals), 0);
  TotalPostedBalance := 0.0;
  RowCount := 0;

  // Create Consolidated Aged Debtors Transaction object to handle retrieval and storage of the data
  // from the dataset as well as performing the calculations of transaction totals and ageing using
  // standard exchequer functions.
  oCADTransaction := TCADTransaction.Create;
  Try
    oCADTransaction.BackdatedReport := ReportParameters.PrevMode;
    oCADTransaction.ReportForCurrency := ReportParameters.RCr;
    oCADTransaction.TranslateToCurrency := ReportParameters.RTxCr;
    oCADTransaction.AgeingDate := ReportParameters.DueLimit;
    oCADTransaction.AgeBy := ReportParameters.RAgeBy;
    oCADTransaction.AgeingInterval := ReportParameters.RAgeInt;

    // Run through the results printing the report
    sqlCaller.Records.First;

    // Link the ADODataset to the transaction object for data access
    oCADTransaction.LinkToDB(sqlCaller);

    While (Not sqlCaller.Records.EOF) And (Not ThreadRec^.ThAbort) Do
    Begin
      // Check space left on page
      ThrowNewPage(5);

      // Check which type of row we are looking at:-
      //
      //   rtTransaction   - A transaction to be checked and printed if outstanding
      //   rtPostedBalance - A Customer/Supplier Posted Balance - this occurs after all the accounts transactions and triggers the footer to print
      //   rtMatching      - A matching row for a transaction - only included in the dataset if we are backdating the transactions
      //
      If (oCADTransaction.RowType = rtPostedBalance) Then
      Begin
        // Print the sub-totals - unless the current account isn't being printed
        If (PrintingAcCode = oCADTransaction.AcCode) Then
        Begin
          If (Not ReportParameters.Summary) Then
            PrintAccountTotals (oCADTransaction.acPostedBalance)
          Else
            PrintAccountSummary (oCADTransaction.acPostedBalance);

          // Update running total for report
          TotalPostedBalance := TotalPostedBalance + oCADTransaction.acPostedBalance;
        End; // If (PrintingAcCode = oCADTransaction.AcCode)

        // Clear down the printing account code as we have now finished the block for this account
        PrintingAcCode := '';

        // Reset account totals
        FillChar(AgedAccountTotals, SizeOf(AgedAccountTotals), 0);

        // Move to the next dataset row and update the progress
        MoveNext (sqlCaller);
      End // If (oCADTransaction.RowType = rtPostedBalance)
      Else If (oCADTransaction.RowType = rtTransaction) Then
      Begin
        // Copy fields into standard transaction record for use with common Exchequer functions, must do this now as
        // the backdating routines need to read the rtMatching rows in order to calculate the outstanding value - causing
        // the transaction fields to be lost
        oCADTransaction.LoadTransactionDetails;

        // Calculates the Outstanding value of the current transaction, including backdating, in Translate To Currency and
        // position on the next transaction as a consequence of reading the matching rows.  An aged version of the outstanding
        // value is stored in the AgedOutstandingValues array for reporting
        OutstandingVal := oCADTransaction.CalcOutstandingAmount (SQLCaller, MoveNext);

        // Only print transactions with an outstanding value unless the user has specified to show everything
        If (OutstandingVal <> 0.0) Or (Not ReportParameters.OSOnly) Then
        Begin
          // Print new subtitle for the first transaction for the account
          If (PrintingAcCode = '') Then
          Begin
            // Use object level variables as data required when reprinting sub-title on page break
            PrintingAcCode := oCADTransaction.acCode;
            PrintingAcCompany := oCADTransaction.acCompany;
            PrintingAcAltCode := oCADTransaction.acAltCode;
            PrintingAcPhone := oCADTransaction.acPhone;

            If (Not ReportParameters.Summary) Then
              PrintAccountHeader (False);
          End; // If (PrintingAcCode = '')

          // Print the transaction details and update totals
          PrintTransactionDetails(oCADTransaction, OutstandingVal);

          // Update the report line count
          ICount := ICount + 1;
        End; // If (OutstandingVal <> 0.0)

        // Check for Euro Conversion rates on transaction
        If (Not FoundEuroConversion) Then
          FoundEuroConversion := oCADTransaction.UndergoneEUROConversion;
      End; // If (oCADTransaction.RowType = rtTransaction) Then
    End; // While (Not sqlCCDeptList.Records.EOF)
  Finally
    FreeAndNIL(oCADTransaction);
  End; // Try..Finally
End; // RepPrint_ProcessFullDataset

//-------------------------------------------------------------------------

Procedure TSQLRep_ConsolidatedAgedDebtorsCreditors.RepPrint(Sender : TObject);
Var
  sqlCaller : TSQLCaller;
  sqlQuery  : AnsiString;
Begin // RepPrint
  oReportLogger.StartReport;

  // Create SQL Query object to use for executing the stored procedure
  sqlCaller := TSQLCaller.Create;//(GlobalADOConnection);  // Removed shared connection due to errors when multiple reports running simultaneously
  Try
    sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;

    // Initialise common variables
    FoundEuroConversion := False;

    sqlCaller.ConnectionString := ConnectionString;
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    sqlCaller.Connection.Password := Password;
    sqlQuery := '[COMPANY].isp_Report_AgedDebtorsDocuments ' +
                              '@strReportType=' + QuotedStr(IfThen(ReportType = rtAgedDebtors, 'C', 'S')) + ', ' +
                              '@intYear=' + IntToStr(ReportParameters.RYr + 1900) + ', ' +     // Expects proper year instead of offset from 1900
                              '@intPeriod=' + IntToStr(ReportParameters.RPr) + ', ' +
                              '@intCurrency=' + IntToStr(ReportParameters.RCr) + ', ' +
                              '@strAccountCode=' + QuotedStr(Trim(ReportParameters.ACFilt)) + ', ' +
                              '@intControlAccount=' + IntToStr(ReportParameters.CtrlNomFilt) + ', ' +
                              '@strCostCentre=' + QuotedStr(Trim(ReportParameters.RCCDep[True])) + ', ' +
                              '@strDepartment=' + QuotedStr(Trim(ReportParameters.RCCDep[False])) + ', ' +
                              '@bitBackdateToYearPeriod=' + IfThen(ReportParameters.PrevMode, '1', '0') + ', ' +
                              {$IFDEF MC_ON}
                              '@bitIsMultiCurrencySetup=1';
                              {$ELSE}
                              '@bitIsMultiCurrencySetup=0';
                              {$ENDIF}


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

        // Call full/summary report specific routines to process the returned datasets due to differences in columns returned and totalling
        sqlCaller.Records.DisableControls;
        Try
          RepPrint_ProcessFullDataset(sqlCaller);
        Finally
          sqlCaller.Records.EnableControls;
        End; // Try..Finally

        // Print report grand totals
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
