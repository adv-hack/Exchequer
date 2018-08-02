unit SQLRep_GLPrePosting;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

uses Dialogs, Windows, DB, Graphics, SysUtils, Contnrs, StrUtils, RpDevice,
     GlobVar, VarConst, BtSupU3, SQLCallerU, SQLRep_BaseReport, ReportU,  oSystemSetup, BtrvU2;

type
  // Replacement for DrCrDType, for clarity
  TDebitCredit = (dcDebit, dcCredit);
  TMovement = array[dcDebit..dcCredit] of Double;

  // Array of year/period totals for the grand totals
  TPeriodTotals = record
    Year: Integer;
    Period: Integer;
    Totals: TMovement;
  end;
  TPeriodTotalsArray = array of TPeriodTotals;

  // Main report class
  TSQLRep_GLPrePosting = object(TSQLRep_BaseReport)
    procedure RepSetTabs; virtual;
    procedure RepPrintPageHeader; virtual;
    procedure RepPrint(Sender : TObject); virtual;
  private
    // Accumulation variables for totals.
    GLTotals: TMovement;
    GrandTotals: TMovement;
    PeriodTotals: TPeriodTotalsArray;
    CurrentGL: LongInt;
    CurrentGLName: String;

    // Pointers to field objects returned from stored procedure.
    fldGLCode : TIntegerField;
    fldName : TStringField;
    fldOurRef : TStringField;
    fldLineDate : TStringField;
    fldAcCode : TStringField;
    fldPeriod : TIntegerField;
    fldYear : TIntegerField;
    fldDescription : TStringField;
    fldPreviousBalance : TFloatField;
    fldValue : TFloatField;
    fldCostCentre : TStringField;
    fldDepartment : TStringField;
    fldJobCode : TStringField;
    fldAnalysisCode : TStringField;

    // CJS 2011-12-07: ABSEXCH-12155 - GLPrePosting Report rounding error
    fldNetValue: TFloatField;
    fldCompanyRate: TFloatField;
    fldDailyRate: TFloatField;
    fldCurrency: TIntegerField;
    fldUseORates: TIntegerField;
    fldDiscount: TFloatField;
    fldDiscFlag: TStringField;
    fldDiscount2Chr: TStringField;
    fldDiscount2: TFloatField;
    fldDiscount3Chr: TStringField;
    fldDiscount3: TFloatField;
    fldQtyMul: TFloatField;
    fldQty: TFloatField;
    fldUsePack: TBooleanField;
    fldShowCase: TBooleanField;
    fldPrxPack: TBooleanField;
    fldQtyPack: TFloatField;
    fldPriceMultiplier: TFloatField;
    fldPaymentCode: TStringField;
    // PKR. 28/01/2016. ABSEXCH-17160. Intrastat Out-of-Period flag.
    fldVATCode : TStringField;
    fldIsECMember      : TBooleanField;

    // CJS 2011-12-21: ABSEXCH-12305 - Posting Report VAT discrepancy
    fldDocType: TIntegerField;

    // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period flag.
    fHasIntrastatOOP : Boolean; /// True if any row has its Intrastat Out-of-Period flag set.

    procedure ApplyMovement(Amount: Double; var Movement: TMovement);
    procedure UpdateRunningTotals(Year, Period: Integer; Movement: TMovement);
    procedure UpdatePeriodTotals(Year, Period: Integer; Movement: TMovement);
    procedure StartNewSectionIfRequired(Continuation: Boolean = False);

    function GetReportInput: Boolean; virtual;
    procedure PrintGrandTotals;
    procedure PrintGLHeader(Continuation: Boolean);
    procedure PrintGLTotals();
    procedure RepPrint_ProcessDataset(SqlCaller: TSQLCaller);
  public
    MaxProgress : LongInt;
    ReportParameters : PostRepParam;

    // Cached SQL Emulator info to reduce overhead
    CompanyCode : ANSIString;
    ConnectionString : WideString;
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    Password: WideString;

    function SQLLoggingArea : string; virtual;
  End; // TSQLRep_GLPrePosting

procedure SQLReport_PrintGLPrePosting(RunNo: LongInt;
                                      ReportType: Byte;
                                      const Owner : TObject;
                                      const ReportParameters: PostRepParam);

implementation

uses SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
     SysU1, ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, ComnUnit,
     SQLRep_Config, EntLoggerClass;

// =============================================================================

procedure SQLReport_PrintGLPrePosting(RunNo: LongInt;
                                      ReportType: Byte;
                                      const Owner: TObject;
                                      const ReportParameters: PostRepParam);
var
  SQLRep : ^TSQLRep_GLPrePosting;
  SqlCaller : TSQLCaller;
  CompanyCode, ConnectionString, lPassword : WideString;
  oReportLogger : TEntSQLReportLogger;
begin
  // Ensure Thread Controller is up and running
  If Create_BackThread then
  Begin
    // Initialise the SQL Stuff
    CompanyCode := GetCompanyCode(SetDrive);

    // Get Company Admin Connection String - Read-Only doesn't have rights to run this
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    If (GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword) = 0) Then
    Begin
      // Create report object
      New(SQLRep, Create(Owner));
      Try
        // Disable the opening/closing/reopening/reclosing of the Btrieve files via the emulator

        // CJS 2012-01-04: ABSEXCH-12324 - Trial Balance warning
        //                 The Emulator files are needed to do the Trial
        //                 Balance check at the end of printing the report.
//        SQLRep^.UsingEmulatorFiles := False;

        // Copy in cached SQL Emulator info to reduce overhead at print time
        SQLRep^.CompanyCode := CompanyCode;
        SQLRep^.ConnectionString := ConnectionString;
        //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
        SQLRep^.Password := lPassword;
        // Initialise report properties
        // Mode:
        //    0 = Full posting report
        //    1 = Sales
        //    2 = Purchases
        //    3 = Nominal
        //    4 = Stock Adjustments
        SQLRep^.ReportMode := ReportType;
        SQLRep^.ReportParameters := ReportParameters;
        SQLRep^.ReportParameters.LastRunNo := RunNo;
        SQLRep^.MaxProgress := 100;

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
End; // SQLReport_PrintFullTrialBalance

// =============================================================================
// TSQLRep_GLPrePosting
// =============================================================================
procedure TSQLRep_GLPrePosting.ApplyMovement(Amount: Double;
  var Movement: TMovement);
{ Stores Amount in the appropriate element of the Movement array, based on
  its sign (negative = dcCredit, positive = dcDebit). }
begin
  Blank(Movement, SizeOf(Movement));
  Movement[TDebitCredit(Amount < 0)] := Abs(Amount);
end;

// -----------------------------------------------------------------------------

function TSQLRep_GLPrePosting.GetReportInput: Boolean;
begin
  with ReportParameters do
  Begin
    ThTitle := 'Posting Report';
    If (LastRunNo = 0) then
      RepTitle := ThTitle+' - Unposted Items '
    else
      RepTitle := ThTitle+' - Run ' + Form_Int(LastRunNo, 1);
    PageTitle := RepTitle;
    RFont.Size := 7;
    ROrient := RPDefine.PoLandscape;
  end; {With..}
  Result := True;
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.PrintGLHeader(Continuation: Boolean);
var
  ContStr:  Str255;
  GLCode: LongInt;
  GLName: string;
begin
  with RepFiler1 do
  begin
    // If we are continuing a G/L section across a page break, add a label to
    // the report to indicate this.
    If (Continuation) then
    begin
      ContStr := ' (continued...)';
      // Use the G/L Code of the current section, in case we have actually
      // moved to a new G/L Code (the CurrentGL value is not updated until
      // after this routine).
      GLCode := CurrentGL;
      GLName := CurrentGLName;
    end
    else
    begin
      ContStr := '';
      GLCode  := fldGLCode.Value;
      GLName  := fldName.Value;
    end;

    // Set up the drill-down area for the G/L Code header
    SendRepSubHedDrillDown(MarginLeft, PageWidth + MarginLeft, 1, FullNomKey(GLCode), NomF, NomCodeK, 0);

    DefFont(0, [fsBold]);

    // Print the G/L Code and description header
    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft(ConCat(dbFormatName(Form_Int(GLCode, 0), GLName)+ContStr),MarginLeft);
    Self.CrLF;
    DefLine(-1, 1, 104, -0.3);
    DefFont(0,[]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.PrintGLTotals();
begin
  DefFont(0,[]);
  with RepFiler1 do
  begin
    // Print the totals for the current G/L Code
    DefLine(-1, 109, 229, 0);
    // PKR. 28/01/2016. ABSEXCH-17223. Totals out of alignment
    // Added extra tab for the newly added Out-of-period column
    SendLine(ConCat(ConstStr(#9, 8),
                    FormatBFloat(GenRealMask, GLTotals[dcDebit],  BOn), #9,
                    FormatBFloat(GenRealMask, GLTotals[dcCredit], BOn)));
  end;
  // Reset the totals ready for the next G/L Code section
  GLTotals[dcDebit]  := 0.0;
  GLTotals[dcCredit] := 0.0;
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.PrintGrandTotals;
var
  NextYear: Integer;
  Entry: Integer;
  Count: Integer;
begin
  // Print the debit/credit grand totals
  DefFont(0,[]);
  with RepFiler1 do
  begin
    DefLine(-1, 109, 229, 0);
    SendLine(ConCat(ConstStr(#9, 8),
                    FormatBFloat(GenRealMask, GrandTotals[dcDebit],  BOn), #9,
                    FormatBFloat(GenRealMask, GrandTotals[dcCredit], BOn)));
  end;

  // Print the year/period grand totals (one line for each year/period covered
  // by the report).
  with RepFiler1 do
  begin
    Count := Length(PeriodTotals);
    Entry := -1;
    for Entry := 0 to Count - 1 do
    begin
      If (LinesLeft<5) then
        ThrowNewPage(5);

      NextYear := PeriodTotals[Entry].Year + 1901;

      ClearTabs;
      SetTab (MarginLeft, pjLeft, 6, 4, 0, 0); // Intrastat OOP flag
      SetTab (NA, pjLeft, 18, 4, 0, 0);        // OurRef
      SetTab (NA, pjLeft, 17, 4, 0, 0);        // Date
      SetTab (NA, pjLeft, 13, 4, 0, 0);        // Acc No
      // Period and (unused) Description columns merged into one to allow a wider Period summary
      SetTab (NA, pjLeft, 60, 4, 0, 0);        // Period  + Description
      SetTab (NA, pjRight, 29, 4, 0, 0);       // B/Fwrd

      // PKR. 08/01/2016. ABSEXCH-17096. Steal 3mm from each of the Debit and Credit columns to make space for the Intrastat OOP indicator.
      SetTab (NA, pjRight, 26, 4, 0, 0);       // Debit
      SetTab (NA, pjRight, 26, 4, 0, 0);       // Credit

      SetTab (NA, pjRight,29, 4, 0, 0);        // C/Fwrd
      SetTab (NA, pjLeft,9, 4, 0, 0);          // CC
      SetTab (NA, pjLeft,9, 4, 0, 0);          // Dept
      SetTab (NA, pjLeft,20, 4, 0, 0);         // Job Code
      SetTab (NA, pjLeft,20, 4, 0, 0);         // Analysis Code

      SendLine(ConCat(ConstStr(#9,5),
                      PPR_OutPr(PeriodTotals[Entry].Period, PeriodTotals[Entry].Year), '-', IntToStr(NextYear), #9,
                      #9, FormatBFloat(GenRealMask, PeriodTotals[Entry].Totals[dcDebit], False),
                      #9, FormatBFloat(GenRealMask, PeriodTotals[Entry].Totals[dcCredit],  False)));

      ClearTabs;
      RepSetTabs;
    end;
  end;

  if (ReportParameters.LastRunNo > 0) then
    Print_WarnDifference(Round_Up(GrandTotals[dcCredit] - GrandTotals[dcDebit],2),
                         ReportParameters.LastRunNo, False);

  GrandTotals[dcDebit]  := 0.0;
  GrandTotals[dcCredit] := 0.0;

  // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period indicator. Printed only if an entry has its flag set.
  if fHasIntrastatOOP then
  begin
    DefFont(-1,[fsItalic,fsBold]);
    // Clear the tabs to prevent the text being chopped off - this is called at the end of
    // the report so we don't need the tabs anymore anyway
    with RepFiler1 do
    begin
      ClearTabs;
      SetTab (MarginLeft, pjLeft, PageWidth-MarginLeft, 4, 0, 0);
      SendLine(#9'* denotes an Out of Period Intrastat Transaction');
      // PKR. 01/03/2016. ABSEXCH-17342. Report Totals out of alignment or not showing.
      // Clear the tabs and reinstate the ones for the report.
      ClearTabs;
      RepSetTabs;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.RepPrint_ProcessDataset(SqlCaller: TSQLCaller);
var
  DateStr: string;
  Movement: TMovement;
  CFwrd: Double;
  IdR: IDetail;
  Summary: Boolean;
  Value: Double;
  IntrastatOOPFlag : string;
  lCust   : CustRec;
  Res     : integer;

  function IsBlankDate(DateStr: string): Boolean;
  begin
    Result := (EmptyKey(DateStr, LDateKeyLen)) or (Length(Trim(DateStr)) < 8);
  end;

  function SafeCharFromString(Str: string; Position: Integer; DefaultChr: Char = ' '): Char;
  begin
    if (Position > Length(Str)) then
      Result := DefaultChr
    else
      Result := Str[Position];
  end;

begin
  // Clear the flag that shows that we have at least one OOP record.  This controls
  // whether or not an explanatory message is printed in the footer.
  fHasIntrastatOOP := false;

  // Run through the results printing the report
  SqlCaller.Records.First;

  // Use typecast references to the fields to avoid variant performance hits.
  // Note that FieldByName() returns an object which will be updated  as the
  // recordset is traversed, which is why these assignments are outside the
  // main loop.
  fldGLCode :=          SqlCaller.Records.FieldByName('tlGLCode') as TIntegerField;
  fldName :=            SqlCaller.Records.FieldByName('glName') as TStringField;
  fldOurRef :=          SqlCaller.Records.FieldByName('thOurRef') as TStringField;
  fldLineDate :=        SqlCaller.Records.FieldByName('tlLineDate') as TStringField;
  fldAcCode :=          SqlCaller.Records.FieldByName('tlAcCode') as TStringField;
  fldPeriod :=          SqlCaller.Records.FieldByName('tlPeriod') as TIntegerField;
  fldYear :=            SqlCaller.Records.FieldByName('tlYear') as TIntegerField;
  fldDescription :=     SqlCaller.Records.FieldByName('tlDescription') as TStringField;
  fldPreviousBalance := SqlCaller.Records.FieldByName('PreviousBalance') as TFloatField;
  // CJS 2011-12-07: ABSEXCH-12155 - GLPrePosting Report rounding error
//  fldValue :=           SqlCaller.Records.FieldByName('Value') as TFloatField;
  fldCostCentre :=      SqlCaller.Records.FieldByName('tlCostCentre') as TStringField;
  fldDepartment :=      SqlCaller.Records.FieldByName('tlDepartment') as TStringField;
  fldJobCode :=         SqlCaller.Records.FieldByName('tlJobCode') as TStringField;
  fldAnalysisCode :=    SqlCaller.Records.FieldByName('tlAnalysisCode') as TStringField;

  // CJS 2011-12-07: ABSEXCH-12155 - GLPrePosting Report rounding error
  fldNetValue :=        SqlCaller.Records.FieldByName('tlNetValue') as TFloatField;
  fldCompanyRate :=     SqlCaller.Records.FieldByName('tlCompanyRate') as TFloatField;
  fldDailyRate :=       SqlCaller.Records.FieldByName('tlDailyRate') as TFloatField;
  fldCurrency :=        SqlCaller.Records.FieldByName('tlCurrency') as TIntegerField;
  fldUseORates :=       SqlCaller.Records.FieldByName('tlUseOriginalRates') as TIntegerField;
  fldDiscount :=        SqlCaller.Records.FieldByName('tlDiscount') as TFloatField;
  fldDiscFlag :=        SqlCaller.Records.FieldByName('tlDiscFlag') as TStringField;
  fldDiscount2Chr :=    SqlCaller.Records.FieldByName('tlDiscount2Chr') as TStringField;
  fldDiscount2 :=       SqlCaller.Records.FieldByName('tlDiscount2') as TFloatField;
  fldDiscount3Chr :=    SqlCaller.Records.FieldByName('tlDiscount3Chr') as TStringField;
  fldDiscount3 :=       SqlCaller.Records.FieldByName('tlDiscount3') as TFloatField;
  fldQtyMul :=          SqlCaller.Records.FieldByName('tlQtyMul') as TFloatField;
  fldQty :=             SqlCaller.Records.FieldByName('tlQty') as TFloatField;
  fldUsePack :=         SqlCaller.Records.FieldByName('tlUsePack') as TBooleanField;
  fldShowCase :=        SqlCaller.Records.FieldByName('tlShowCase') as TBooleanField;
  fldPrxPack :=         SqlCaller.Records.FieldByName('tlPrxPack') as TBooleanField;
  fldQtyPack :=         SqlCaller.Records.FieldByName('tlQtyPack') as TFloatField;
  fldPriceMultiplier := SqlCaller.Records.FieldByName('tlPriceMultiplier') as TFloatField;
  fldPaymentCode :=     SqlCaller.Records.FieldByName('tlPaymentCode') as TStringField;
  // PKR. 27/01/2016. ABSEXCH-17160. Preposting reports not showing * for Out of Period Intrastat Transactions
  fldVATCode :=         SqlCaller.Records.FieldByName('tlVATCode') as TStringField;
  fldIsECMember :=      SqlCaller.Records.FieldByName('acECMember') as TBooleanField;

  // CJS 2011-12-21: ABSEXCH-12305 - Posting Report VAT discrepancy
  fldDocType :=         SqlCaller.Records.FieldByName('tlDocType') as TIntegerField;

  while (not SqlCaller.Records.EOF) and (not ThreadRec^.ThAbort) do
  begin
    ThrowNewPage(5);

    // CJS 2011-12-07: ABSEXCH-12155 - GLPrePosting Report rounding error.
    // Copy the details into the temporary Detail record and calculate values.
    with Idr do
    begin
      NomCode       := fldGLCode.Value;
      PYr           := fldPeriod.Value;
      PPr           := fldYear.Value;
      CCDep[True]   := fldCostCentre.Value;
      CCDep[False]  := fldDepartment.Value;
      CXRate[False] := fldCompanyRate.Value;
      CXRate[True]  := fldDailyRate.Value;
      Currency      := fldCurrency.Value;
      UseORate      := fldUseORates.Value;
      Qty           := fldQty.Value;
      QtyMul        := fldQtyMul.Value;
      NetValue      := fldNetValue.Value;
      Discount      := fldDiscount.Value;
      Payment       := SafeCharFromString(fldPaymentCode.Value, 1);
      DiscountChr   := SafeCharFromString(fldDiscFlag.Value, 1);
      CustCode      := fldAcCode.Value;
      PDate         := fldLineDate.Value;
      Desc          := fldDescription.Value;
      JobCode       := fldJobCode.Value;
      AnalCode      := fldAnalysisCode.Value;
      UsePack       := fldUsePack.Value;
      DocPRef       := fldOurRef.Value;
      PrxPack       := fldPrxPack.Value;
      QtyPack       := fldQtyPack.Value;
      ShowCase      := fldShowCase.Value;
      PriceMulx     := fldPriceMultiplier.Value;
      Discount2     := fldDiscount2.Value;
      Discount2Chr  := SafeCharFromString(fldDiscount2Chr.Value, 1);
      Discount3     := fldDiscount3.Value;
      Discount3Chr  := SafeCharFromString(fldDiscount3Chr.Value, 1);
      // CJS 2011-12-21: ABSEXCH-12305 - Posting Report VAT discrepancy
      IDDocHed      := DocTypes(fldDocType.Value);
      VATCode       := (fldVATCode.Value + ' ')[1]; // Add a space to avoid null codes.

      // PKR. 08/01/2016. ABSEXCH-17096. Intrastat Out-of-Period indicator.
      // PKR. 27/01/2016. ABSEXCH-17160. Preposting reports not showing * for Out of Period Intrastat Transactions
      // PKR. 29/01/2016. Restructured for efficiency following code review.
      // NOTE: There is similar code to this in Report3U and SQLRep_GLPrePosting
      // and it is based on code in PostingU.
      IntrastatOOPFlag := '';  // Needs to be blank for non-Intrastat OOP records.

      if (Syss.Intrastat) then
      begin
        if (VATCode in ['A', 'D']) then
        begin
          if (fldIsECMember.Value) then
          begin
            // Check for and report on transactions posted into closed Intrastat periods
            if IDDocHed in [PIN, PJI, PCR, PJC, PPI, PRF] then
            begin
              if PDate <= SystemSetup.Intrastat.isLastClosedArrivalsDate then
              begin
                IntrastatOOPFlag := '*';
                fHasIntrastatOOP := true;
              end;
            end
            else
              if IDDocHed in [SIN, SJI, SCR, SJC, SRI, SRF] then
              begin
                if PDate <= SystemSetup.Intrastat.isLastClosedDispatchesDate then
                begin
                  IntrastatOOPFlag := '*';
                  fHasIntrastatOOP := true;
                end;
              end;
          end;
        end; // VAT code for Intrastat Arrivals or Departures
      end; // if Intrastat
    end;

    // CJS 2011-12-07: ABSEXCH-12155 - GLPrePosting Report rounding error
    // CJS 2011-12-21: ABSEXCH-12305 - Posting Report VAT discrepancy
    If (Idr.IDDocHed = RUN) then
      Summary := BOn
    else
      Summary := Not Syss.SepDiscounts;
    Value := Round_Up(Conv_TCurr(DetLTotal(IdR, Summary, BOff, 0.0),
                       XRate(IdR.CXRate, BOff, IdR.Currency),
                       IdR.Currency, IdR.UseORate, BOff),
                       2);

    // If we've moved to another G/L Code, we need to start a new section.
    StartNewSectionIfRequired;

    // Set up the drilldowns for the Transaction and the Customer/Supplier
    SendRepDrillDown(1, TotTabs, 1, fldOurRef.Value, InvF, InvOurRefK, 0);
    SendRepDrillDown(3, 3, 2, FullCustCode(fldAcCode.Value), CustF, CustCodeK, 0);

    // Print Transaction Details

    // Calculate the carried-forward value
    // CJS 2011-12-07: ABSEXCH-12155 - GLPrePosting Report rounding error
    ApplyMovement(Value, Movement);
    CFwrd := Round_Up(Value, 2) + Round_Up(fldPreviousBalance.Value, 2);
    {
    ApplyMovement(fldValue.Value, Movement);
    CFwrd := Round_Up(fldValue.Value, 2) - Round_Up(fldPreviousBalance.Value, 2);
    }

    // Prepare a formatted date string
    if not IsBlankDate(fldLineDate.Value) then
      DateStr := POutDate(fldLineDate.Value)
    else
      DateStr := '';

    // PKR. 08/01/2016. ABSEXCH-17096. Add Intrastat Out-of-Period indicator
    SendLine(ConCat(#9, IntrastatOOPFlag,
                    #9, fldOurRef.Value,
                    #9, DateStr,
                    #9, fldAcCode.Value,
                    #9, PPR_OutPr(fldPeriod.Value, fldYear.Value),
                    #9, fldDescription.Value,
                    #9, FormatBFloat(GenRealMask, fldPreviousBalance.Value, (ReportParameters.LastRunNo = 0)),
                    #9, FormatBFloat(GenRealMask, Movement[dcDebit], BOn),
                    #9, FormatBFloat(GenRealMask, Movement[dcCredit], BOn),
                    #9, FormatBFloat(GenRealMask, CFwrd, (ReportParameters.LastRunNo = 0)),
                    #9, fldCostCentre.Value,
                    #9, fldDepartment.Value,
                    #9, fldJobCode.Value,
                    #9, fldAnalysisCode.Value));

    UpdateRunningTotals(fldYear.Value, fldPeriod.Value, Movement);

    // Update the line count and progress
    ICount := ICount + 1;
    if Assigned(ThreadRec) then
      UpDateProgress(ICount);

    SqlCaller.Records.Next;
  end; // While (Not sqlCaller.Records.EOF) And (Not ThreadRec^.ThAbort)
  ThrowNewPage(5);
  // Print the totals for the last G/L Code...
  PrintGLTotals;
  // ...followed by the grand totals for the report.
  PrintGrandTotals;
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.RepPrint(Sender: TObject);
var
  SqlCaller: TSQLCaller;
  SqlQuery: AnsiString;
begin
  oReportLogger.StartReport;

  // Tell the base report not to print the header line. We are going to print
  // it ourselves, so that it is printed at the right time.
  RNoPageLine := True;

  // Create a SQL Query object to use for executing the stored procedure
  SqlCaller := TSQLCaller.Create;
  try
    SqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;

    SqlCaller.ConnectionString := ConnectionString;
    //RB 09/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
    SqlCaller.Connection.Password := Password;
    // Build the SQL Query for calling the stored procedure
    SqlQuery := '[COMPANY].isp_Report_GLPrePostingRun_Online ' +
                '@intReportMode=' + IntToStr(ReportMode) + ', ' +
                '@intPostingRunNumber=' + IntToStr(ReportParameters.LastRunNo);

    ShowStatus(2, 'Retrieving Data, Please Wait...');
    ShowStatus(3, 'This can take several minutes');
    oReportLogger.StartQuery(SqlQuery);
    SqlCaller.Select(SqlQuery, CompanyCode);
    oReportLogger.FinishQuery;
    ShowStatus(2, 'Processing Report.');
    ShowStatus(3, '');

    try
      if (SqlCaller.ErrorMsg = '') and (SqlCaller.Records.RecordCount > 0) then
      begin
        oReportLogger.QueryRowCount(SqlCaller.Records.RecordCount);
        // Update the line count and progress
        if Assigned(ThreadRec) then
        begin
          InitProgress(SqlCaller.Records.RecordCount);
          UpDateProgress(0);
        end; // If Assigned(ThreadRec)

        // Run the main loop of the report
        try
          RepPrint_ProcessDataset(sqlCaller);
        except
          on E:Exception do
            WriteSQLErrorMsg(E.message);
        end;

      end // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
      else if (sqlCaller.ErrorMsg <> '') then
        WriteSQLErrorMsg (sqlCaller.ErrorMsg);
    finally
      sqlCaller.Close;
    end; // Try..Finally
  finally
    sqlCaller.Free;
  end; // Try..Finally

  // Print footer
  PrintEndPage;

  oReportLogger.FinishReport;
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.RepPrintPageHeader;
var
  CCTitle: Str80;
  DeptTitle: Str80;
  JobCodeTitle: Str80;
  AnalysisCodeTitle: Str80;
begin
  CCTitle := '';
  DeptTitle := '';
  JobCodeTitle := '';
  AnalysisCodeTitle := '';
  // Set up and print the column headers
  with RepFiler1, ReportParameters do
  begin
    DefFont(0, [fsBold]);
    {$IFDEF PF_On}
    if (Syss.UseCCDep) then
    begin
      CCTitle   := 'CC';
      DeptTitle := 'Dept';
    end;
    {$ENDIF}
    if (JBCostOn) then
    begin
      JobCodeTitle      := 'Job Code';
      AnalysisCodeTitle := 'Analysis Code';
    end;
    // PKR. 08/01/2016. ABSEXCH-17096. Add Intrastat Out-of-Period column
    SendLine(ConCat(#9, '',
                    #9, 'Our Ref',
                    #9, 'Date',
                    #9, 'Acc No',
                    #9, 'Period',
                    #9, 'Description',
                    #9, 'B/Fwrd',
                    #9, 'Debit',
                    #9, 'Credit',
                    #9, 'C/Fwrd',
                    #9, CCTitle,
                    #9, DeptTitle,
                    #9, JobCodeTitle,
                    #9, AnalysisCodeTitle));
    DefFont(0,[]);
  end; {With..}
//  If (RepFiler1.CurrentPage > 1 + Ord(NoDeviceP)) then
  with RepFiler1 do
  begin
    SetPen(clBlack,psSolid,-2,pmCopy);

    MoveTo(1,YD2U(CursorYPos)-4.3);
    LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
    MoveTo(1,YD2U(CursorYPos));
  end;
  If (RepFiler1.CurrentPage > 1) then
    PrintGLHeader(True);
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.RepSetTabs;
begin
  With RepFiler1 do
  Begin
    // PKR. 08/01/2016. ABSEXCH-17096. Add new 6mm column for Intrastat Out-of-Period indicator
    SetTab (MarginLeft, pjLeft, 6, 4, 0, 0); // Intrastat Out-of-Period indicator
    SetTab (NA, pjLeft,  18, 4, 0, 0);

    SetTab (NA, pjLeft,  17, 4, 0, 0);
    SetTab (NA, pjLeft,  13, 4, 0, 0);
    SetTab (NA, pjLeft,  15, 4, 0, 0);
    SetTab (NA, pjLeft,  45, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);

    // PKR. 08/01/2016. ABSEXCH-17096. Steal 3mm from each of the Debit and Credit columns to make space for the Intrastat OOP indicator.
    SetTab (NA, pjRight, 26, 4, 0, 0);
    SetTab (NA, pjRight, 26, 4, 0, 0);

    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjLeft,   9, 4, 0, 0);
    SetTab (NA, pjLeft,   9, 4, 0, 0);
    SetTab (NA, pjLeft,  20, 4, 0, 0);
    SetTab (NA, pjLeft,  20, 4, 0, 0);
  end;
  SetTabCount;
end;

// -----------------------------------------------------------------------------

function TSQLRep_GLPrePosting.SQLLoggingArea: string;
begin
  Result := 'GLPrePostingReport';
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.StartNewSectionIfRequired(Continuation: Boolean);
begin
  // Have we moved to another G/L Code?
  if (CurrentGL <> fldGLCode.Value) then
  begin
    // Print the totals of the previous G/L Code, if any.
    if (CurrentGL <> 0) then
    begin
      // Print totals of previous GL Code section
      PrintGLTotals;
    end;
    With RepFiler1 do
      PrintGLHeader(False);
    // Keep a record of the current G/L Code, so we know when move to the
    // next one.
    CurrentGL := fldGLCode.Value;
    CurrentGLName := fldName.Value;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.UpdatePeriodTotals(Year, Period: Integer;
  Movement: TMovement);
var
  Search: Integer;
  Entry: Integer;
  Count: Integer;
begin
  // Search for an existing entry for this year and period.
  Count := Length(PeriodTotals);
  Entry := -1;
  for Search := 0 to Count - 1 do
  begin
    if ((PeriodTotals[Search].Year = Year) and (PeriodTotals[Search].Period = Period)) then
    begin
      Entry := Search;
      break;
    end;
  end;
  // If no entry was found, create a new one.
  if (Entry = -1) then
  begin
    Entry := Count;
    SetLength(PeriodTotals, Count + 1);
    PeriodTotals[Entry].Year := Year;
    PeriodTotals[Entry].Period := Period;
    PeriodTotals[Entry].Totals[dcDebit] := 0;
    PeriodTotals[Entry].Totals[dcCredit] := 0;
  end;
  // Update the totals in the entry
  PeriodTotals[Entry].Totals[dcDebit]  := Round_Up(PeriodTotals[Entry].Totals[dcDebit], 2) +
                                          Round_Up(Movement[dcDebit], 2);
  PeriodTotals[Entry].Totals[dcCredit] := Round_Up(PeriodTotals[Entry].Totals[dcCredit], 2) +
                                          Round_Up(Movement[dcCredit], 2);
end;

// -----------------------------------------------------------------------------

procedure TSQLRep_GLPrePosting.UpdateRunningTotals(Year, Period: Integer;
  Movement: TMovement);
var
  Debit: Double;
  Credit: Double;
begin
  Debit  := Round_Up(Movement[dcDebit], 2);
  Credit := Round_Up(Movement[dcCredit], 2);

  GLTotals[dcDebit]     := Round_Up(GLTotals[dcDebit],     2) + Debit;
  GLTotals[dcCredit]    := Round_Up(GLTotals[dcCredit],    2) + Credit;
  GrandTotals[dcDebit]  := Round_Up(GrandTotals[dcDebit],  2) + Debit;
  GrandTotals[dcCredit] := Round_Up(GrandTotals[dcCredit], 2) + Credit;

  UpdatePeriodTotals(Year, Period, Movement);
end;

// -----------------------------------------------------------------------------

End.

