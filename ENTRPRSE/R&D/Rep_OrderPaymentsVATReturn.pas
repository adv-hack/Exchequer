unit Rep_OrderPaymentsVATReturn;

interface

uses Graphics, SysUtils, Windows, Forms, BtSupU1, ReportKU, VATSub, BtSupU3, PrintPreviewWizard,
  GlobVar, ComnU2, OrderPaymentsUnmatchedReceipts, VarConst, RPFiler, RPDefine;

const
  // Constants for Order Payments VAT Return Rate Totals
  rsInPeriod      = False;
  rsOutOfPeriod   = True;
  rsOutputs       = False;
  rsSalesReceipts = True;

  VATRateTotalsSectionTitle: array[rsOutputs..rsSalesReceipts] of Str20 = ('Outputs', 'Sales Receipts');
  VATRateTotalsPeriodTitle: array[rsInPeriod..rsOutOfPeriod] of Str20 = ('Total in-period', 'Out of period');

type
  TVATReturnElement = record
    Net: Double;
    VAT: Double;
  end;

  // Array to hold the Outputs and Sales Receipts total values so that they
  // can be printed to a separate report section.
  TOrderPaymentsVATReturnRateSummary = array[VATType]
                                       of array[rsOutputs..rsSalesReceipts]
                                       of array[rsInPeriod..rsOutOfPeriod]
                                       of TVATReturnElement;

  TOrderPaymentsVATReturn = Object(TVATRReport2)
  private
    FOrderPaymentsUnmatchedReceipts: TOrderPaymentsUnmatchedReceipts;
    FRateSummary: TOrderPaymentsVATReturnRateSummary;

  protected
    // Adds scratch file records for the relevant entries in the Order Payments
    // Sales Receipts cache
    procedure AddOutstandingOrderPaymentReceipts;

    // Adds the current transaction to the scratch file, along with details
    // from the Order Payments Sales Receipts cache. This is only called from
    // AddOutstandingOrderPaymentReceipts() above.
    procedure AddOrderPaymentReceipt(CacheEntry: TOrderPaymentsCacheEntry);

    // Prints the Order Payments Sales Receipts analysis list
    procedure PrintOutstandingOrderPaymentReceipts;

    // Prints the VAT details from a single transaction, taking the figures
    // from the Order Payments Sales Receipt cache. This is only called from
    // PrintOutstandingOrderPaymentReceipts() above.
    procedure PrintSRCLine(VATCode: Char; CacheEntry: TOrderPaymentsCacheEntry);

    // Prints the VAT Rate totals, showing the Output and Sales Receipts totals
    // for each VAT Rate, in-period and out-of-period.
    procedure PrintVATRateTotals;

    // This is the equivalent of Set_VATTotals() in Report8U.pas, except that
    // it takes the values from the Order Payments Sales Receipts cache instead
    // of from the transaction.
    //
    // On return, CRepParam.IPrGoodsAnal and CRepParam.IPrVATAnal will contain
    // the values split by VAT Code
    procedure CalculateVATTotals(CacheEntry: TOrderPaymentsCacheEntry);

    // Called after the VAT Return scratch file has been built.
    procedure AfterBuild; virtual;

    // Called after the main transaction analysis list has been printed.
    procedure AfterTransactionList; virtual;

    // Called at the end of a report section, to allow grand totals to be
    // accumulated.
    procedure OnSectionEnd; virtual;

    // Override of the TVatReport.Out_OfPr method, to catch Order Payments
    // Sales Receipts, as these have no VAT Post Date, but should be treated
    // as in-period.
    function Out_OfPr(InvR: InvRec): Boolean; virtual;

    // Function to allow values from Order Payments Sales Receipts to be
    // included in the Output VAT section of the VAT Summary (see
    // TVATRReport.VAT_Summary in Report8U.pas)
    procedure AdditionalSummaryTotals(ForSales: Boolean; VATCode: char; var Goods, VAT: Double); virtual;

    procedure AfterSummary; virtual;

  public
    constructor Create(AOwner: TObject);

    destructor Destroy; virtual;
    procedure Finish; virtual;
    property OrderPaymentsUnmatchedReceipts: TOrderPaymentsUnmatchedReceipts read FOrderPaymentsUnmatchedReceipts write FOrderPaymentsUnmatchedReceipts;
  end;

  TOrderPaymentsVATReturnPtr = ^TOrderPaymentsVATReturn;

  // Class for handling the printing of page and section headers for the
  // VAT Rate Totals section of the VAT Return
  TOrderPaymentsVATTotalsHeader = class(TObject)
  private
    // Reference to the Report
    FReport: TOrderPaymentsVATReturnPtr;

    // Flag to indicate that we are printing a continuation page
    FContinued: Boolean;

    // The VAT Rate Totals section (Outputs or Sales Receipts) that is about
    // to be printed.
    FSection: Boolean;

    // The VAT Rate that is about to be printed
    FRate: VATType;

    // Prints the main page header
    procedure PrintPageHeader;

    // Prints the section header -- 'Outputs' or 'Sales Receipts'
    procedure PrintSectionHeader;

    // Prints the header for the current VAT rate
    procedure PrintRateHeader;

    // Prints the header for a new page
    procedure PrintHeader(Sender: TObject);

    // Sets up the tabs for the VAT Rate Totals list
    procedure SetTabs;

    procedure SetReport(const Value: TOrderPaymentsVATReturnPtr);
  public
    constructor Create;
    property Section: Boolean read FSection write FSection;
    property Rate: VATType read FRate write FRate;
    property Report: TOrderPaymentsVATReturnPtr read FReport write SetReport;
  end;

implementation

uses Math, BtrvU2, CurrncyU, TEditVal, ETStrU, BtKeys1U, ETDateU,
     AuditNotes, VarRec2U, Saltxl1U, RevChrgU, MiscU, ExWrap1U, ETMiscU,
     DLLInt, APIUtil;

// =============================================================================
// TOrderPaymentsVATReturn
// =============================================================================

procedure TOrderPaymentsVATReturn.AddOrderPaymentReceipt(CacheEntry: TOrderPaymentsCacheEntry);
var
  VATCode: Char;
  VATRate: VATType;
  i: Integer;
begin
  // Retrieve the address of the current transaction record into LastRecAddr[InvF]
  MTExLocal.LGetRecAddr(InvF);
  // Add entries for each VAT Code in the cache for this transaction
  for i := 0 to CacheEntry.Count - 1 do
  begin
    VATCode := CacheEntry.VATByIndex[i].VATCode;
    VATRate := GetVATNo(VATCode, VATCode);
    // CJS 2015-01-05 - ABSEXCH-15965 - Access Violation when running VAT Return under Pervasive
    // Changed keypath to InvOurRefK (the InvVATK index that is used for the
    // main report is a manual index which has null keys against the Sales Order
    // Receipts)
    ThisScrt.Add_Scratch(InvF, InvOurRefK, MTExLocal.LastRecAddr[InvF], 'O' + VATCode + MTExLocal.LInv.OurRef + MTExLocal.LInv.TransDate + 'N', VATCode);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.AddOutstandingOrderPaymentReceipts;
var
  i, j: Integer;
  CacheEntry: TOrderPaymentsCacheEntry;
  FuncRes: Integer;
  Key: Str255;
begin
  if Assigned(FOrderPaymentsUnmatchedReceipts) then
  begin
    // Go through all the unmatched Sales Receipts in the cache
    for i := 0 to FOrderPaymentsUnmatchedReceipts.Count - 1 do
    begin
      CacheEntry := FOrderPaymentsUnmatchedReceipts.Cache.ByIndex[i];
      // If this is a valid Order Payments Sales Receipt...
      if not CacheEntry.IsUnmatchedByOrderPayments then
      begin
        // ...locate the transaction...
        Key := CacheEntry.OurRef;
        FuncRes := MTExLocal.LFind_Rec(B_GetEq, InvF, InvOurRefK, Key);
        // CJS 2015-03-02 - ABSEXCH-16197 - Exclude Order Payments Sales Receipts for EEC Payments
        // CJS 2015-07-02 - ABSEXCH-16526 - Unposted Order Payment SRCs appear on VAT Return
        // Amended to exclude unposted transactions
        if (FuncRes = 0) and (MTExLocal.LInv.RunNo > 0) and not CacheEntry.HasVAT('D') then
          // ...and add it to the report
          AddOrderPaymentReceipt(CacheEntry);
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

constructor TOrderPaymentsVATReturn.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
end;

// -----------------------------------------------------------------------------

destructor TOrderPaymentsVATReturn.Destroy;
begin
  inherited;
  InMainThread := False;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.Finish;
var
  PParam: ^TPrintParam;
  Dlg: TForm_PrintPreviewWizard;
begin
  if RDevRec.Preview = False then
  begin
    // No print preview required -- send the report directly to the selected
    // destination.
    // CJS 2015-01-16 - ABSEXCH-16032 - temporary file error on closing VAT Return
    // MH 11/01/2016 2016-R1 ABASEXCH-10720: .XLSX file already written at this point so we don't
    // need to call PrintFileToEx as that will only overwrite the good .XLSX file with a bad file.
    If (RDevRec.fePrintMethod <> 5) Then
      PrintFileToEx(RDevRec, RepFiler1.FileName, 'VAT Return', False)
    Else
      // MH 11/01/2016 2016-R1 ABSEXCH-10720: Check to see if the .XLSX file should be opened
      If RDevRec.feMiscOptions[1] And FileExists(RDevRec.feXMLFileDir) Then
      Begin
        // ShellExecute crashes with an EEFFACE Error (Unhandled C++ Exception) if it is called
        // too quickly!
        Sleep(1000);
        RunFile(RDevRec.feXMLFileDir);
      End; // If RDevRec.feMiscOptions[1] And FileExists(RDevRec.feXMLFileDir)
    Exit;
  end;

  New(PParam);
  FillChar(PParam^, Sizeof(PParam^), 0);

  ShowStatus(2, 'Printing Report.');

  if fMyOwner is TForm then
    Dlg := TForm_PrintPreviewWizard.Create(TForm(fMyOwner))
  else
    Dlg := TForm_PrintPreviewWizard.Create(nil);
  try

    with PParam^ do
    begin
      // Printer details (TSBSPrintSetupInfo)
      PDevRec := RDevRec;

      FileName   := RepFiler1.FileName;
      RepCaption := RepTitle;

      // Additional report set-up
      PBatch       := RUseForms;
      DelSwapFile  := RDelSwapFile;
      SwapFileName := TmpSwapFileName;
    end; // with PParam^ do...

    Dlg.FilePreview1.FileName := RepFiler1.FileName; //PParam^.FileName;
    Dlg.FilePrinter1.FileName := RepFiler1.FileName;
    Dlg.Caption := RepTitle;
    Dlg.DeletePrintFileOnClose := False;
    RDevRec.fePrintMethod := 0;
    Dlg.SetPrintInfo(RDevRec);
    Dlg.CanContinue := not RepAbort;
    Dlg.Show;
    Dlg.StartPreview;

  except
    Dlg.Free;
  end;
  //InPrint:=BOff;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.PrintOutstandingOrderPaymentReceipts;
var
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;
  CacheEntry : TOrderPaymentsCacheEntry;
  CurrentVATCode : Char;
  CurrentVATType: VATType;
  PreviousVATCode: Char;
  PreviousVATType: VATType;
  StartNewPage: Boolean;
  FoundRecords: Boolean;
  VATInBase: Double;

  // Internal procedure for maintaining the running goods and VAT totals
  procedure UpdateTotalsForRate(VatValue: Double);
  var
    Rate    : VATType;
    IsSales : Boolean;
  begin
    with CRepParam^ do
    begin
      IsSales := MTExLocal.VATSalesMode(SalesorPurch(MTExLocal.LInv.InvDocHed), ThisVRate);

      If (Not Out_OfPr(MTExLocal.LInv)) then
      Begin
        Rate := ThisVRate;

        RepTotals[Rate]   := RepTotals[Rate]   + IPrGoodsAnal[Rate];
        RateTotals[Rate]  := RateTotals[Rate]  + IPrGoodsAnal[Rate];
        SplitTotals[Rate] := SplitTotals[Rate] + IPrGoodsAnal[Rate];

        If (IsSales) then
          Rate := OAdj
        else
          Rate := IAdj;

        RepTotals[Rate]   := RepTotals[Rate]   + Round_Up(VatValue, 2);
        RateTotals[Rate]  := RateTotals[Rate]  + Round_Up(VatValue, 2);
        SplitTotals[Rate] := SplitTotals[Rate] + Round_Up(VatValue, 2);
      end
      else
      Begin

        Rate := ThisVRate;

        OPrAnal[Rate]       := OPrAnal[Rate]       + IPrGoodsAnal[Rate];
        OPRateTotals[Rate]  := OPRateTotals[Rate]  + IPrGoodsAnal[Rate];
        OPSplitTotals[Rate] := OPSplitTotals[Rate] + IPrGoodsAnal[Rate];

        If (IsSales) then
          Rate := OAdj
        else
          Rate := IAdj;

        OPrAnal[Rate]       := OPrAnal[Rate]       + Round_Up(VatValue, 2);
        OPRateTotals[Rate]  := OPRateTotals[Rate]  + Round_Up(VatValue, 2);
        OPSplitTotals[Rate] := OPSplitTotals[Rate] + Round_Up(VatValue, 2);

      end;
    end;
  end;

begin
  PreviousVATCode := #0;
  PreviousVATType := Spare8; // Unused VAT Type
  StartNewPage    := True;
  FoundRecords    := False;

  // Clear the grand totals

  // Totals for the report line, in-period and out-of-period
  Blank(CRepParam.SplitTotals, Sizeof(CRepParam.SplitTotals));
  Blank(CRepParam.OPSplitTotals, Sizeof(CRepParam.OPSplitTotals));

  // Totals for the VAT Rate, in-period and out-of-period
  Blank(CRepParam.RateTotals, Sizeof(CRepParam.RateTotals));
  Blank(CRepParam.OPRateTotals, Sizeof(CRepParam.OPRateTotals));

  // Grand totals, in-period and out-of-period
  Blank(CRepParam.RepTotals, Sizeof(CRepParam.RepTotals));
  Blank(CRepParam.OPrAnal, Sizeof(CRepParam.OPrAnal));

  // Locate the scratch file entries for the Order Payment Receipts (indicated
  // by a type 'O')
  RepKey := FullNomKey(ThisScrt^.Process) + 'O';
  RepLen := Length(RepKey);
  KeyS   := RepKey;

  CRepParam.CurrentSection := 'O';

  If (Assigned(ThreadRec)) then
    RepAbort := ThreadRec^.THAbort;

  // Go through all the scratch file records against section 'O'
  MTExLocal.LStatus := MTExLocal.LFind_Rec(B_Start, RFnum, RKeypath, KeyS);
  While (MTExLocal.LStatusOk) and (CheckKey(RepKey, KeyS, RepLen, BOn)) and (Not RepAbort) do
  Begin
    FoundRecords := True;

    // Save the current position in the scratch file
    TmpStat := MTExLocal.LPresrv_BTPos(RFnum,RKeypath,MTExLocal.LocalF^[RFnum],TmpRecAddr,BOff,BOff);

    // Locate the Sales Receipt transaction
    ThisScrt^.Get_Scratch(MTExLocal.LRepScr^);

    // Read the VAT details from the scratch file
    CRepParam.ThisVRate := GetVATNo(MTExLocal.LRepScr^.KeyStr[1],#0);
    CurrentVATType := CRepParam.ThisVRate;
    CurrentVATCode := MTExLocal.LRepScr^.KeyStr[1];

    // If the is the first page of Sales Receipts, print the correct header
    if StartNewPage then
    begin
      // Force a new page. Suppress the section headers (otherwise the report
      // will print the headers as if we are continuing the Transaction
      // Analysis list pages)
      SuppressSectionHeaders := True;
      ThrowNewPage(-1);
      SuppressSectionHeaders := False;

      // CJS 2015-01-09 - VAT Return section headers
      // Print the 'Order Payments' section header
      PrintIODetail('O', False);
      StartNewPage := False;
    end;

    // If we have moved to another VAT Code, print the totals for the previous
    // VAT Code, and the header for the new VAT Code
    if (CurrentVATCode <> PreviousVATCode) then
    begin
      // PreviousVATCode will be #0 if we haven't printed anything yet,
      // otherwise print the totals for it
      if (PreviousVATCode <> #0) then
      begin
        CRepParam.LastVRate := PreviousVATType;
        // Print the In-Period and Out-of-Period totals
        ReportMode := ReportMode + 20;
        PrintVATTot2(BOff);
        PrintVATTot2(BOn);
        ReportMode := ReportMode - 20;
      end;

      PreviousVATType := CurrentVATType;
      PreviousVATCode := CurrentVATCode;

      // Print the header for the new VAT Code
      PrintVRateDetail(CurrentVATType, False);
    end;

    // Retrieve the Order Payment Receipt details from the cache
    CacheEntry := FOrderPaymentsUnmatchedReceipts.Cache[MTExLocal.LInv.OurRef];

    // Calculate the values
    CalculateVATTotals(CacheEntry);

    // Print the line
    ThrowNewPage(5);
    PrintSRCLine(CurrentVATCode, CacheEntry);

    // Update the totals
    // CJS 2015-04-22 - ABSEXCH-16364 - Order Payments VAT Return for non-Base Currency
    // The cache holds the values in transaction currency. Convert to base.
    VATInBase := Round_Up(Conv_TCurr(CacheEntry.VAT[CurrentVATCode].VAT, MTExLocal.LInv.CXRate[UseCoDayRate], MTExLocal.LInv.Currency, MTExLocal.LInv.UseORate, BOff), 2);

    UpdateTotalsForRate(VATInBase);

    // Update the progress display
    Inc(ICount);
    Inc(RCount);
    If (Assigned(ThreadRec)) then
      UpDateProgress(RCount);

    // Restore the position in the scratch file
    TmpStat := MTExLocal.LPresrv_BTPos(RFnum,RKeypath,MTExLocal.LocalF^[RFnum],TmpRecAddr,BOn,BOff);

    // Find the next scratch file record
    MTExLocal.LStatus := MTExLocal.LFind_Rec(B_Next, RFnum, RKeypath, KeyS);

    If (Assigned(ThreadRec)) then
      RepAbort := ThreadRec^.THAbort;
  end; {While..}

  if FoundRecords then
  begin
    // Print the In-Period and Out-of-Period totals totals for the last VAT rate
    CRepParam.LastVRate := PreviousVATType;
    ReportMode := ReportMode + 20;
    PrintVATTot2(BOff); // In-Period
    PrintVATTot2(BOn);  // Out-of-Period
    ReportMode := ReportMode - 20;

    // Separator line
    DefLine(-1, 1, RepFiler1.PageWidth - RepFiler1.MarginRight - 1, -0.5);

    // Finally print the combined totals for Sales Receipts (ReportMode = 0)
    ThrowNewPage(5);
    PrintVATTot2(BOff); // In-Period
    PrintVATTot2(BOn);  // Out-of-Period
    ThrowNewPage(5);

    // Separator Line
    DefLine(-1, 1, RepFiler1.PageWidth - RepFiler1.MarginRight - 1, -0.5);

    ThrowNewPage(5);
  end;

end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.PrintSRCLine(VATCode: Char; CacheEntry: TOrderPaymentsCacheEntry);
var
  VATEntry : TOrderPaymentsVATEntry;
  GenXRateMask: Str255;
  OriginalValue: Double;
  LineVATRate: Double;
  OutOfPeriodIndicator: char;
  GoodsInBase: Double;
  VATInBase: Double;
  TotalInBase: Double;
begin
  GenXRateMask  := FormatDecStrSD(6, GenRealMask, False);

  // Outstanding Order Payments Receipts are always treated as being in-period
  OutOfPeriodIndicator := ' ';

  If (MTExLocal.LInv.OldORates[BOn]<>0.0) then {* Its been through a conversion *}
    LineVATRate:=MTExLocal.LInv.OldORates[True]
  else
    LineVATRate:=MTExLocal.LInv.OrigRates[True];

  SetReportDrillDown(0);

  VATEntry := CacheEntry.VAT[VATCode];
  OriginalValue := CacheEntry.VAT[VATCode].Goods*DocCnst[MTExLocal.LInv.InvDocHed]*DocNotCnst;

  // Convert the VAT Entry values to the base currency
  GoodsInBase := Round_Up(Conv_TCurr(VATEntry.Goods, MTExLocal.LInv.CXRate[UseCoDayRate], MTExLocal.LInv.Currency, MTExLocal.LInv.UseORate, BOff), 2);
  VATInBase   := Round_Up(Conv_TCurr(VATEntry.VAT, MTExLocal.LInv.CXRate[UseCoDayRate], MTExLocal.LInv.Currency, MTExLocal.LInv.UseORate, BOff), 2);
  TotalInBase := GoodsInBase + VATInBase;

  SendLine(ConCat(#9,OutOfPeriodIndicator,
                  #9,MTExLocal.LInv.OurRef,
                  #9,MTExLocal.LInv.YourRef,
                  #9,PoutDate(MTExLocal.LInv.Transdate),
                  #9,PPR_OutPr(MTExLocal.LInv.ACPr, MTExLocal.LInv.ACYr),
                  #9,MTExLocal.LInv.CustCode,
                  #9,'',
                  #9,'',                                                                     // Reverse Charge Indicator
                  #9,FormatFloat(GenRealMask, GoodsInBase ),                                 // Net
                  #9,FormatFloat(GenRealMask, VATInBase),                                    // VAT
                  #9,FormatFloat(GenRealMask, TotalInBase),                                  // Gross
                  #9,'',                                                                     // Adj (Manual VAT?)
                  #9,FormatCurFloat(GenRealMask,OriginalValue,BOff,MTExLocal.LInv.Currency), // Original Value
                  #9,FormatFloat(GenXRateMask, LineVATRate),                                 // Exch Rate
                  #9,YesNoBo(ReValued(MTExLocal.LInv))));                                    // Revalued

end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.PrintVATRateTotals;
var
  Rate: VATType;
  Section: Boolean;
  Period: Boolean;
  Net: Double;
  VAT: Double;
  Gross: Double;
  TotalNet: Double;
  TotalVAT: Double;
  TotalGross: Double;
  StartNewPage: Boolean;
  Header: TOrderPaymentsVATTotalsHeader;

  // Returns True if the accumulated total against the specified VAT rate is
  // zero.
  function HasValue(Rate: VATType): Boolean;
  var
    Value: Double;
    Period: Boolean;
    Section: Boolean;
  begin
    Value := 0;
    // Total values from Outputs and Sales Receipts...
    for Section := rsOutputs to rsSalesReceipts do
      // ...and both in-period and out-of-period.
      for Period := rsInPeriod to rsOutOfPeriod do
        Value := Value + FRateSummary[Rate][Section][Period].Net + FRateSummary[Rate][Section][Period].VAT;

    Result := not IsZero(Value);
  end;

begin
  // Create an instance of the object for handling the printing of the page
  // and section headers
  Header := TOrderPaymentsVATTotalsHeader.Create;
  Header.Report := @self;

  // Force a new page at the start of this section
  StartNewPage := True;

  for Rate := VStart to VEnd do
  begin
    // Only print the VAT Rate totals if there are non-zero values against
    // this VAT rate.
    if HasValue(Rate) then
    begin
      // Print the descriptive header for this VAT rate
      Header.Rate := Rate;
      if StartNewPage then
      begin
        ThrowNewPage(-1);
        StartNewPage := False;
      end
      else
        Header.PrintRateHeader;

      TotalNet := 0.00;
      TotalVAT := 0.00;
      TotalGross := 0.00;
      for Section := rsOutputs to rsSalesReceipts do
      begin
        Header.Section := Section;
        Header.PrintSectionHeader;

        // Print the in-period totals and the out-of-period totals, on two
        // separate lines
        for Period := rsInPeriod to rsOutOfPeriod do
        begin
          Net := FRateSummary[Rate][Section][Period].Net;
          VAT := FRateSummary[Rate][Section][Period].VAT;
          Gross := Net + VAT;

          SendLine(ConCat(#9,VATRateTotalsPeriodTitle[Period],
                          #9,FormatFloat(GenRealMask, Net),
                          #9,FormatFloat(GenRealMask, VAT),
                          #9,FormatFloat(GenRealMask, Gross)));

          TotalNet := TotalNet + Net;
          TotalVAT := TotalVAT + VAT;
          TotalGross := TotalGross + Net + VAT;
        end;
      end;

      // Print the accumulated totals for this VAT rate
      DefFont(0, [fsBold]);
      SendLine(ConCat(#9,'Totals for ' + SyssVAT^.VATRates.VAT[Rate].Desc,
                      #9,FormatFloat(GenRealMask, TotalNet),
                      #9,FormatFloat(GenRealMask, TotalVAT),
                      #9,FormatFloat(GenRealMask, TotalGross)));
      DefFont(0, []);

      // Check whether a new page is required.
      ThrowNewPage(5);
    end;
  end;
  RepFiler1.OnPrintHeader := RPrintHeader;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.AfterBuild;
begin
  if Assigned(FOrderPaymentsUnmatchedReceipts) then
    AddOutstandingOrderPaymentReceipts;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.AfterTransactionList;
begin
  if Assigned(FOrderPaymentsUnmatchedReceipts) then
  begin
    PrintOutstandingOrderPaymentReceipts;
    PrintVATRateTotals;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.CalculateVATTotals(
  CacheEntry: TOrderPaymentsCacheEntry);
var
  VATEntry : TOrderPaymentsVATEntry;
  i : Integer;
  LineTotal: Double;
  LineVAT: Double;
  VATIndex :  VATType;
  GoodsRate :  CurrTypes;
  GoodsValue: Double;
  VATValue: Double;
Begin
  Blank(CRepParam.IPrGoodsAnal, Sizeof(CRepParam.IPrGoodsAnal));
  Blank(CRepParam.IPrVATAnal, Sizeof(CRepParam.IPrVATAnal));

  GoodsRate := MTExLocal.LInv.OrigRates;
  if (MTExLocal.LInv.OldORates[BOff] <> 0.0) then
    GoodsRate := MTExLocal.LInv.OldORates;

  // For each entry in the cache...
  for i := 0 to CacheEntry.Count - 1 do
  begin
    // ...retrieve the VAT details
    VATEntry := CacheEntry.VATByIndex[i];
    LineTotal := VATEntry.Goods;
    LineVAT   := VATEntry.VAT;
    VATIndex := GetVATNo(VATEntry.VATCode, #0);

    // Convert the Goods value to the VAT currency
    GoodsValue := Conv_VATCurr(LineTotal,
                               MTExLocal.LInv.VATCRate[UseCoDayRate],
                               XRate(GoodsRate, False, MTExLocal.LInv.Currency),
                               MTExLocal.LInv.Currency,
                               MTExLocal.LInv.UseORate);

    // Correct the sign
    GoodsValue := GoodsValue * DocCnst[MTExLocal.LInv.InvDocHed];

    // Assign the Goods value to the matching entry in the Goods Analysis array
    CRepParam.IPrGoodsAnal[VATIndex] := Round_Up(GoodsValue, 2);

    // Convert the VAT Value to the VAT Currency
    VATValue := Conv_VATCurr(LineVAT,
                             MTExLocal.LInv.VATCRate[True],
                             Calc_BConvCXRate(MTExLocal.LInv,
                                              MTExLocal.LInv.CXRate[True],
                                              True),
                             MTExLocal.LInv.Currency,
                             MTExLocal.LInv.UseORate);

    // Adjust the sign (the base VAT Return expects the VAT value to be
    // negative, and will correct it later)
    VATValue := VATValue * DocCnst[MTExLocal.LInv.InvDocHed] * DocNotCnst;

    // Assign the VAT value to the matching entry in the VAT Analysis array
    CRepParam.IPrVATAnal[VATIndex] := Round_Up(VATValue, 2);

    // Accumulate the VAT Total for this transaction
    CRepParam.VATTot := CRepParam.VATTot + VATValue;
  end; // for i:= 0 to CacheEntry.Count - 1 do...

end;

// -----------------------------------------------------------------------------

function TOrderPaymentsVATReturn.Out_OfPr(InvR: InvRec): Boolean;
begin
  if (InvR.thOrderPaymentElement <> opeNA) and
     (InvR.InvDocHed = SRC) and
     // We can't use the inherited Out_OfPr, because it relies on the VATPostDate
     (Trim(InvR.VATPostDate) = '') then
    Result := False
  else
    Result := inherited Out_OfPr(InvR);
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.AdditionalSummaryTotals(
  ForSales: Boolean; VATCode: char; var Goods, VAT: Double);
var
  i: Integer;
  CacheEntry: TOrderPaymentsCacheEntry;
  VATEntry : TOrderPaymentsVATEntry;
begin
  if ForSales and Assigned(FOrderPaymentsUnmatchedReceipts) then
  begin
    // Go through all the unmatched Sales Receipts in the cache
    for i := 0 to FOrderPaymentsUnmatchedReceipts.Count - 1 do
    begin
      CacheEntry := FOrderPaymentsUnmatchedReceipts.Cache.ByIndex[i];
      // If this is a valid Order Payments Sales Receipt...
      if not CacheEntry.IsUnmatchedByOrderPayments then
      begin
        // ...add the Goods and VAT totals from the specified VAT Code

        // CJS 2015-02-17 - ABSEXCH-16162 - drill-down on VAT Report
        // Added the HasVAT call to fix a side-issue where the second run of
        // the report was including **all** VAT Codes, whether or not they were
        // actually in use.
        if CacheEntry.HasVAT(VATCode) then
        begin
          VATEntry := CacheEntry.VAT[VATCode];
          // CJS 2015-04-22 - ABSEXCH-16364 - Order Payments VAT Return for non-Base Currency
          // The cache holds the values in transaction currency. Convert them to base.
          Goods := Goods + Round_Up(Conv_TCurr(VATEntry.Goods, MTExLocal.LInv.CXRate[UseCoDayRate], MTExLocal.LInv.Currency, MTExLocal.LInv.UseORate, BOff), 2);
          VAT   := VAT + Round_Up(Conv_TCurr(VATEntry.VAT, MTExLocal.LInv.CXRate[UseCoDayRate], MTExLocal.LInv.Currency, MTExLocal.LInv.UseORate, BOff), 2);

        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.AfterSummary;
begin
  if not Assigned(FOrderPaymentsUnmatchedReceipts) then
  begin
    DefFont(1, [fsBold]);
    SendLine('');
    SendLine(ConCat(#9,#9,'NOTE: Unmatched Order Payments Sales Receipts are not included.'));
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATReturn.OnSectionEnd;
var
  Rate: VATType;
  InPeriodNet: Double;
  InPeriodVAT: Double;
  OutOfPeriodNet: Double;
  OutOfPeriodVAT: Double;
begin
  if ReportMode in [20, 22] then
  begin
    // Read the current VAT Rate
    Rate := CRepParam.LastVRate;

    InPeriodNet := GoodsFromAry(CRepParam.RateTotals, False, False, Rate);
    InPeriodVAT := GoodsFromAry(CRepParam.RateTotals, True, False, Rate);

    OutOfPeriodNet := GoodsFromAry(CRepParam.OPRateTotals, False, False, Rate);
    OutOfPeriodVAT := GoodsFromAry(CRepParam.OPRateTotals, True, False, Rate);

    if CRepParam.CurrentSection = 'O' then
    begin
      // Sales Receipts, in-period
      FRateSummary[Rate][rsSalesReceipts][rsInPeriod].Net :=
        FRateSummary[Rate][rsSalesReceipts][rsInPeriod].Net + InPeriodNet;

      FRateSummary[Rate][rsSalesReceipts][rsInPeriod].VAT :=
        FRateSummary[Rate][rsSalesReceipts][rsInPeriod].VAT + InPeriodVAT;

      // Sales Receipts, out-of-period
      FRateSummary[Rate][rsSalesReceipts][rsOutOfPeriod].Net :=
        FRateSummary[Rate][rsSalesReceipts][rsOutOfPeriod].Net + OutOfPeriodNet;

      FRateSummary[Rate][rsSalesReceipts][rsOutOfPeriod].VAT :=
        FRateSummary[Rate][rsSalesReceipts][rsOutOfPeriod].VAT + OutOfPeriodVAT;
    end
    else if CRepParam.LastDocType = 'S' then
    begin
      // Outputs, in-period
      FRateSummary[Rate][rsOutputs][rsInPeriod].Net :=
        FRateSummary[Rate][rsOutputs][rsInPeriod].Net + InPeriodNet;

      FRateSummary[Rate][rsOutputs][rsInPeriod].VAT :=
        FRateSummary[Rate][rsOutputs][rsInPeriod].VAT + InPeriodVAT;

      // Outputs, out-of-period
      FRateSummary[Rate][rsOutputs][rsOutOfPeriod].Net :=
        FRateSummary[Rate][rsOutputs][rsOutOfPeriod].Net + OutOfPeriodNet;

      FRateSummary[Rate][rsOutputs][rsOutOfPeriod].VAT :=
        FRateSummary[Rate][rsOutputs][rsOutOfPeriod].VAT + OutOfPeriodVAT;
    end

  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TOrderPaymentsVATTotalsHeader
// =============================================================================

{ NOTE: the constructor originally took a TOrderPaymentsVATReturn parameter,
  which was then assigned to FReport, to ensure that this was set. Unfortunately
  the constructor was triggering an internal compiler error (C1405), so the
  assigning of the report has been removed from here and done via a property
  instead. }
constructor TOrderPaymentsVATTotalsHeader.Create;
begin
  FContinued := False;
  FSection   := rsOutputs;
  FRate      := Standard;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATTotalsHeader.PrintHeader(Sender: TObject);
begin
  if Assigned(FReport) then
  begin
    // Print the standard VAT Return page header
    FReport.PrintHedTit;
    FReport.PrintStdPage;

    // Print the column headers
    FReport.DefFont(0, [fsBold]);
    FReport.SendLine(#9'Rate'#9'Net'#9 + CCVATName^ + #9'Gross');
    FReport.DefFont(0, []);

    // Underline the column headers
    with FReport.RepFiler1 do
    begin
      SetPen(clBlack,psSolid,-2,pmCopy);
      MoveTo(1,YD2U(CursorYPos)-4.3);
      LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
      MoveTo(1,YD2U(CursorYPos));
    end;

    // Print the VAT Rate Totals page and section headers
    PrintPageHeader;
    PrintRateHeader;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATTotalsHeader.PrintPageHeader;
var
  Title: string;
begin
  if Assigned(FReport) then
  begin
    FReport.DefFont(2, [fsBold]);

    Title := 'VAT Rate Totals';
    if FContinued then
      Title := Title + ' (cont.)';

    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    FReport.PrintLeft(Title, FReport.RepFiler1.MarginLeft);
    FReport.CRLF;

    FReport.DefLine(-1, FReport.RepFiler1.MarginLeft, 120, -1.0);

    FReport.DefFont(0, []);

    // As soon as we have printed the page header at least once, any subsequent
    // print will be for a continuation page.
    FContinued := True;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATTotalsHeader.PrintRateHeader;
var
  Title: string;
begin
  if Assigned(FReport) then
  begin
    FReport.DefFont(2, [fsBold]);

    Title :=  SyssVAT^.VATRates.VAT[Rate].Desc + ', ' +
              Form_Real(SyssVAT^.VATRates.VAT[Rate].Rate*100, 0, 2) + '%';

    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    FReport.PrintLeft(Title, FReport.RepFiler1.MarginLeft);
    FReport.CRLF;

    FReport.DefLine(-1, FReport.RepFiler1.MarginLeft, 120, -1.0);

    FReport.DefFont(0, []);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATTotalsHeader.PrintSectionHeader;
var
  Title: string;
begin
  if Assigned(FReport) then
  begin
    FReport.DefFont(0, [fsBold]);

    Title := VATRateTotalsSectionTitle[Section];

    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    FReport.PrintLeft(Title, FReport.RepFiler1.MarginLeft);
    FReport.CRLF;

    FReport.DefLine(-1, FReport.RepFiler1.MarginLeft, 120, -0.2);

    FReport.DefFont(0, []);
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATTotalsHeader.SetReport(
  const Value: TOrderPaymentsVATReturnPtr);
begin
  FReport := Value;
  FReport.RepFiler1.OnPrintHeader := PrintHeader;
  SetTabs;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsVATTotalsHeader.SetTabs;
begin
  FReport.RepFiler1.ClearTabs;
  with FReport.RepFiler1 do
  begin
    SetTab (MarginLeft, pjLeft,  30, 4, 0, 0);  // Section or Rate title
    SetTab (NA,         pjRight, 24, 4, 0, 0);  // Net
    SetTab (NA,         pjRight, 24, 4, 0, 0);  // VAT
    SetTab (NA,         pjRight, 24, 4, 0, 0);  // Gross
  end;
end;

// -----------------------------------------------------------------------------

end.

