unit Rep_UnmatchedSalesReceipts;
{
  Unmatched Sales Receipts report for the Order Payments system. This reports
  all unmatched Sales Receipts that were NOT created by Order Payments.
}
interface

uses Windows, SysUtils, Graphics, VarConst, RPDefine, Saltxl1U, BtSupU1, BtSupU3,
  ExBtTh1U, ExThrd2U, ReportU, PrintPreviewWizard, BtrvU2,
  OrderPaymentsUnmatchedReceipts;

type
  // Signature for ShowStatus event-handler.  For consistency with the
  // reporting system this matches the ShowStatus call used by the Object
  // Thread Controller, where Line one of three lines on the window, and Msg
  // is the text to show on this line.
  TStatusProc = procedure(Line: Integer; Msg: ShortString) of object;

  TUnmatchedSalesReceiptsReport = object(TGenReport)
  private
    FOnStatus: TStatusProc;
    FOnProgress: TOnUpdateProgressProc;
    FOrderPaymentsUnmatchedReceipts: TOrderPaymentsUnmatchedReceipts;
    FLineAmount: Double;
  public
    // Pointer to the report parameter structure
    RepParam: VATRepPtr;

    constructor Create(AOwner: TObject);
    destructor Destroy; virtual;

    // Returns True if the current record is to be included on the report
    function IncludeRecord: Boolean; virtual;

    // Sets the parameters for locating the required records for the report
    function GetReportInput: Boolean; virtual;

    // Displays the specified report status message (actually passes the
    // details to any assigned callback routine, or to the inherited ShowStatus
    // from GenReport).
    procedure ShowStatus(Line: Integer; Msg: ShortString);

    // Sets up the tab column positions for the report layout
    procedure RepSetTabs; virtual;

    // Main report routine, scanning through the records and calling the
    // PrintReportLine method for each one which passes the IncludeRecord
    // check
    procedure RepPrint(Sender: TObject); virtual;

    // Outputs the column headers for each page as required
    procedure RepPrintPageHeader; virtual;

    // Outputs all the columns for a single line. Assumes that we are on a
    // valid record for the report.
    procedure PrintReportLine; virtual;

    // Sets up the report, allowing the user to select the printer. This is
    // only overridden so that we can detect a Cancel and post a message back
    // to the VAT Return form.
    function Start: Boolean; virtual;

    // Finalises the report, sending it to the report printing engine to be
    // printed or displayed in the preview window.
    procedure Finish; virtual;

    // Event-handler for reporting the report stage information.
    property OnStatus: TStatusProc read FOnStatus write FOnStatus;

    // Event-handler for displaying report progress
    property OnProgress: TOnUpdateProgressProc read FOnProgress write FOnProgress;

    property OrderPaymentsUnmatchedReceipts: TOrderPaymentsUnmatchedReceipts read FOrderPaymentsUnmatchedReceipts write FOrderPaymentsUnmatchedReceipts;
  end;

implementation

uses Math, DLLInt, CurrncyU;

// =============================================================================
// TUnmatchedSalesReceiptsReport
// =============================================================================

constructor TUnmatchedSalesReceiptsReport.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  New(RepParam);
  FCancelled := False;
end;

// -----------------------------------------------------------------------------

destructor TUnmatchedSalesReceiptsReport.Destroy;
begin
  Dispose(RepParam);
  inherited Destroy;
  InMainThread := False;
end;

// -----------------------------------------------------------------------------

procedure TUnmatchedSalesReceiptsReport.Finish;
var
  Dlg: TForm_PrintPreviewWizard;
Begin
  // Don't print anything if the report has been cancelled before we get here
  if FCancelled then
    Exit;

  if RDevRec.Preview = False then
  begin
    // No print preview required -- send the report directly to the selected
    // destination.
    PrintFileTo(RDevRec, RepFiler1.FileName, 'Unmatched Sales Receipts');
    if (fOwnHandle <> 0) then
      PostMessage(fOwnHandle, WM_CONTINUEVATRETURN, 0, 0);
    Exit;
  end;

  ShowStatus(2, 'Printing Report.');

  Dlg := TForm_PrintPreviewWizard.Create(nil);
  try
    Dlg.OwnerHandle := fOwnHandle;
    Dlg.FilePreview1.FileName := RepFiler1.FileName;
    Dlg.FilePrinter1.FileName := RepFiler1.FileName;
    Dlg.Caption := RepTitle;
    Dlg.SetPrintInfo(RDevRec);
    Dlg.Show;
    Dlg.StartPreview;
  except
    Dlg.Free;
  end;
end;

// -----------------------------------------------------------------------------

function TUnmatchedSalesReceiptsReport.GetReportInput: Boolean;
begin
  RFNum     := InvF;
  RepTitle  := 'Unmatched Sales Receipts';
  PageTitle := RepTitle;
  RepTitle2 := 'Unmatched Sales Receipts not created by Order Payments';
  Result    := True;
end;

// -----------------------------------------------------------------------------

function TUnmatchedSalesReceiptsReport.IncludeRecord: Boolean;
var
  CacheEntry: TOrderPaymentsCacheEntry;
begin
  Result := False;
  FLineAmount := 0.0;
  // If it is not an Order Payment transaction and it has an outstanding amount,
  // and it is not later than the VAT Period being reported on...
  if (MTExLocal.LInv.thOrderPaymentElement = opeNA) and
     (Trim(MTExLocal.LInv.AllocStat) <> '') and
     (MTExLocal.LInv.TransDate <= RepParam^.VATEndd) and
     // CJS 2015-07-02 - ABSEXCH-16526 - Unposted Order Payment SRCs appear on VAT Return
     // Amended to exclude unposted transactions
     (MTExLocal.LInv.RunNo > 0) then
  begin
    // ...we need to report it
    FLineAmount := CurrencyOS(MTExLocal.LInv, True, False, False);
    Result := not IsZero(FLineAmount);
  end;
  // If we have a cache of unmatched Order Payment Sales Receipts, take these
  // into account
  if (not Result) and (FOrderPaymentsUnmatchedReceipts <> nil) then
  begin
    CacheEntry := FOrderPaymentsUnmatchedReceipts.Cache[Trim(MTExLocal.LInv.OurRef)];
    if (CacheEntry <> nil) then
      // This is an Order Payments Sales Receipt which has been allocated
      // outside of Order Payments, so it should be included in this report.
      Result := CacheEntry.IsUnmatchedByOrderPayments;
  end;
end;

// -----------------------------------------------------------------------------

procedure TUnmatchedSalesReceiptsReport.PrintReportLine;
begin
  SendLine(ConCat(#9, MTExLocal.LInv.OurRef,
                  #9, MTExLocal.LInv.CustCode,
                  #9, FormatBFloat(GenRealMask, FLineAmount, True)));
end;

// -----------------------------------------------------------------------------

procedure TUnmatchedSalesReceiptsReport.RepPrint(Sender: TObject);
var
  TmpStat    : Integer;
  TmpRecAddr : LongInt;
  MaxCount: Integer;
  ProgressUnit: Double;
begin

  ShowStatus(2,'Processing Report.');

  With MTExLocal^,RepFiler1 do
  Begin

    RepKey    := 'SRC';
    RKeyPath  := InvOurRefK;
    RepLen := Length(RepKey);

    MaxCount := Used_Recs(F[RFNum], RFnum);
    if (MaxCount > 0) then
      ProgressUnit := 100 / MaxCount
    else
      ProgressUnit := 1.0;

    // Go through all the SRC transactions
    KeyS    := RepKey;
    LStatus := LFind_Rec(B_Start, RFnum, RKeypath, KeyS);
    While (LStatusOk) and (CheckKey(RepKey, KeyS, RepLen, True)) and not FCancelled do
    Begin
      // Save the current position in the file (in case IncludeRecord or
      // PrintReportLine do look-ups which change the position)
      TmpStat := LPresrv_BTPos(RFnum, RKeypath, LocalF^[RFnum], TmpRecAddr, False, False);

      // Check whether this record should be included on the report
      If (IncludeRecord) then
      Begin
        // If we are close to the bottom of the page, start a new page
        ThrowNewPage(5);

        // Print the current record
        PrintReportLine;

        // Update the count of the number of records actually printed
        Inc(ICount);
      end; // if (IncludeRecord)...

      // Update the count of the number of records scanned
      Inc(RCount);

      // Allow any progress reporting to be updated
      if Assigned(FOnProgress) then
        FOnProgress(Trunc(RCount * ProgressUnit), FCancelled)
      else if Assigned(ThreadRec) then
        UpDateProgress(RCount);

      // Restore the position in the file
      TmpStat := LPresrv_BTPos(RFnum, RKeypath, LocalF^[RFnum], TmpRecAddr, True, False);

      // Get the next record
      LStatus := LFind_Rec(B_Next, RFnum, RKeypath, KeyS);

    end; {While..}

    // If we are close to the bottom of the page, start a new page
    ThrowNewPage(5);

    PrintEndPage;
  end; {With..}
end;

// -----------------------------------------------------------------------------

procedure TUnmatchedSalesReceiptsReport.RepPrintPageHeader;
Begin
  with RepFiler1, RepParam^ do
  begin
    DefFont(0, [fsBold]);

    SendLine(ConCat(#9, 'Our Ref',
                    #9, 'Acct.',
                    #9, 'Outstanding'));

    DefFont(0,[]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TUnmatchedSalesReceiptsReport.RepSetTabs;
begin
  With RepFiler1 do
  Begin
    SetTab (MarginLeft, pjLeft,  20, 4, 0, 0);
    SetTab (NA,         pjLeft,  15, 4, 0, 0);
    SetTab (NA,         pjRight, 20, 4, 0, 0);
  end; {With..}
end;

// -----------------------------------------------------------------------------

procedure TUnmatchedSalesReceiptsReport.ShowStatus(Line: Integer;
  Msg: ShortString);
begin
  if Assigned(FOnStatus) then
    FOnStatus(Line, Msg)
  else
    inherited ShowStatus(Line, Msg);
end;

// -----------------------------------------------------------------------------

function TUnmatchedSalesReceiptsReport.Start: Boolean;
begin
  Result := inherited Start;
  if not Result then
    if (fOwnHandle <> 0) then
      PostMessage(fOwnHandle, WM_CANCELVATRETURN, 0, 0);
end;

end.
