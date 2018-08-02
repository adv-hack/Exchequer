unit OrderPaymentsUnmatchedReceipts;
{
  System for locating and caching the details of any Sales Receipts that have
  not been fully paid by Order Payments, or have been allocated outside the
  Order Payments system.

  See the TOrderPaymentsUnmatchedReceipts class for the entry-point to this
  system.
}
interface

uses
  SysUtils,
  Contnrs,
  Math,
  DB,
  GlobVar,
  BtrvU2,
  VarConst,
  ExBtTh1U,
  CurrncyU,
  oBtrieveFile,
  oOPVATPayBtrieveFile,
  ExWrap1U,
  SQLUtils,
  SQLCallerU,BtSupU3;

type
  // Exception class for errors in this system
  EOrderPaymentsUnmatchedReceiptsError = class(Exception);

  // Class to hold totals for one VAT code (this will be the totals from a
  // single Sales Receipt).
  TOrderPaymentsVATEntry = class(TObject)
  public
    VATCode: Char;
    Goods: Double;
    VAT: Double;
    constructor Create(ForVATCode: Char);
  end;

  // Class to hold totals for one Sales Receipt.
  TOrderPaymentsCacheEntry = class(TObject)
  private
    // Internal list of TOrderPaymentsVATEntry objects.
    FVAT: TObjectList;

    // The OurRef of the Sales Receipt that the instance relates to.
    FOurRef: string;

    // Returns the VAT Array entry that matches the supplied VAT Code. This
    // will create a new entry if one does not already exists against this
    // VAT Code.
    function GetVAT(VATCode: Char): TOrderPaymentsVATEntry;
    function GetVATByIndex(Idx: Integer): TOrderPaymentsVATEntry;
    function GetCount: Integer;
    function GetTotalVAT: Double;

  public
    // Set to True if the Sales Receipt is not completely matched by Order
    // Payments (i.e. it was partly or completely raised or amended externally
    // to the Order Payments system).
    IsUnmatchedByOrderPayments: Boolean;

    constructor Create(ForOurRef: string);
    destructor Destroy; override;

    // CJS 2015-02-17 - ABSEXCH-16162 - drill-down on VAT Report
    // Fixes a side-issue where the second run of the report was including
    // **all** VAT Codes, whether or not they were actually in use.

    // Returns True if there is an entry against the supplied VAT Code.
    function HasVAT(VATCode: Char): Boolean;

    // Property returning the number of VAT Array entries
    property Count: Integer read GetCount;

    // Property for accessing the VAT Array entries.
    property VAT[VATCode: Char]: TOrderPaymentsVATEntry read GetVAT;

    // Property for accessing the VAT Array entries by position
    property VATByIndex[Idx: Integer]: TOrderPaymentsVATEntry read GetVATByIndex;

    // Property for read-only access to the OurRef
    property OurRef: string read FOurRef;

    // Returns the total VAT (adds up all the entries in the VAT array)
    property TotalVAT: Double read GetTotalVAT;
  end;

  // Cache of the details and totals for all unmatched Sales Receipts that need
  // to be reported on by the VAT Return.
  TOrderPaymentsCache = class(TObject)
  private
    // Internal list of TOrderPaymentsCacheEntry objects.
    FCache: TObjectList;

    // Returns the cache entry that matches the supplied string (which is
    // assumed to be an OurRef for a Sales Receipt).
    function GetEntry(OurRef: string): TOrderPaymentsCacheEntry;
    function GetCount: Integer;
    function GetByIndex(Idx: Integer): TOrderPaymentsCacheEntry;
    function GetTotalVAT(VATCode: char): Double;

  public
    constructor Create;
    destructor Destroy; override;

    // Adds a new cache entry to the internal list and returns it.
    function AddEntry(OurRef: string): TOrderPaymentsCacheEntry;

    // Clears all the entries from the cache
    procedure Clear;

    // Deletes the matching cache entry from the internal list. Does nothing if
    // a matching entry cannot be found.
    procedure DeleteEntry(OurRef: string);

    // Finds and returns the index of the matching cache entry. Returns -1 if a
    // matching entry cannot be found.
    function FindEntry(OurRef: string): Integer;

    // Returns the total Goods and VAT value for the specified VAT Code;
    procedure TotalGoodsAndVAT(VATCode: char; var Goods: Double; var VAT: Double);

    // Property for accessing the cache entries. This is default so that this
    // class can be referenced using array syntax:
    //
    //    var Entry: TOrderPaymentsCacheEntry;
    //    Entry := OrderPaymentsCache['SRC000651'];
    //
    property Entry[OurRef: string]: TOrderPaymentsCacheEntry read GetEntry; default;

    // Returns a count of the number of entries in the cache
    property Count: Integer read GetCount;

    // Returns the cache entry identified by position
    property ByIndex[Idx: Integer]: TOrderPaymentsCacheEntry read GetByIndex;

    // Returns the VAT total for all the entries in the cache against the
    // specified VAT Code
    property TotalVAT[VATCode: char]: Double read GetTotalVAT;

  end;

  // Class to scan the Order Payments VAT Pay table to calculate any
  // outstanding amounts for a specified SRC. Caches the values (split by
  // OurRef and VAT Code) for subsequent output to the VAT Return.
  TOrderPaymentsUnmatchedReceipts = class(TObject)
  private
    // MTExLocal object for access to Btrieve files.
    FExLocal: TdMTExLocalPtr;

    // Reference to report parameters object (passed by the VAT Return Wizard)
    FRepParam: VATRepPtr;

    FCancelled: Boolean;

    // Instance for accessing the OPVATPay table
    FOPVATPayScanner: TOrderPaymentsVATPayDetailsBtrieveFile;

    // Internal cache of the located Sales Receipt details.
    FCache: TOrderPaymentsCache;

    // Current cache entry being processed.
    FCacheEntry: TOrderPaymentsCacheEntry;

    // Total value (goods + VAT) of Order Payments found against the current
    // Sales Receipt. Calculated by CalculateTotalPayments.
    FOrderPaymentsTotal: Double;

    // Total outstanding value remaining against the Sales Receipt. Calculated
    // by CalculateOutstandingSRCTotal.
    FOutstandingSRCTotal: Double;

    // The OurRef of the current Sales Receipt
    FOurRef: string;

    // The OurRef of the Sales Order matching the current Sales Receipt
    FSORRef: string;

    // Progress event-handler
    FOnUpdateProgress: TOnUpdateProgressProc;

    // Central method for handling errors. Raises an exception with the
    // supplied error message.
    procedure HandleError(Msg: string);

    // Ensures that the database access objects are created and initialised.
    procedure PrepareDatabase;

    // Checks whether the current Sales Receipt (in FExLocal.LInv) is within
    // the period range being reported on. Sales Receipts which are later than
    // this period are always excluded.
    function IncludeSalesReceipt: Boolean;

    // Locates the Sales Receipt record in Document. Raises an exception if
    // the record cannot be found or if FOurRef has not been set yet (both of
    // which conditions suggest a programming error).
    procedure LocateSalesReceipt;

    // Calculates and returns any unallocated amount found against the
    // current Sales Receipt. Assumes that we are already on the correct
    // transaction record in Document.
    function CalculateOutstandingSRCTotal: Double;

    // Scans all the Order Payments VAT Pay records to find any payments that
    // apply to the current receipt, and adds these to the current cache
    // entry. Returns the total (Goods + VAT totals) amount found.
    function CalculateTotalPayments: Double;

    // Adds a new cache entry, for the current Sales Receipt. A reference to
    // this new entry will also be stored in FCacheEntry.
    function AddCacheEntry: TOrderPaymentsCacheEntry;

    // Deletes the current cache entry (when we find that the current Sales
    // Receipt has been fully allocated by Order Payments).
    procedure DeleteCacheEntry;

    // Scans the Order Payments VAT table for refunds against the current Sales
    // Receipt, and adjusts the values in the current cache entry, and the
    // total Order Payments value in FOrderPaymentsTotal.
    procedure ScanForRefunds;

    // Scans the Order Payments VAT table for matching payments against the
    // current Sales Receipt, and adjusts the values in the current cache entry,
    // and the total Order Payments value in FOrderPaymentsTotal.
    procedure FindMatchingPayments;

    // Handles the processing for the Btrieve version (this is called from
    // the Process method.
    function ProcessForBtrv: Boolean;

    // Handles the processing for the SQL version (this is called from the
    // Process method.
    function ProcessForSQL: Boolean;

  public
    constructor Create;
    destructor Destroy; override;

    // Main entry point to scan all the Sales Receipts in the Order Payments
    // VAT table, and to store the details of unmatched receipts in a cache.
    // Returns True if details were stored, and False if no receipts were found
    // with outstanding amounts.
    function Process(RepParam: VATRepPtr): Boolean;

    // Clears down the cache and any other stored values.
    procedure Reset;

    // Scans the supplied Sales Receipt stores the details in the cache.
    // Returns True if details were stored, and False if there were no
    // outstanding amounts found for this Sales Receipt.
    function Scan(OurRef: string): Boolean;

    // Returns the number of entries currently in the cache
    function Count: Integer;

    // Property for read-only access to the cache. Once Scan has completed for
    // all the required Sales Receipts, the details can read via this
    // property.
    //
    //  E.g:
    //
    //    TotalVAT := OrderPaymentsUnmatchedReceipts.Cache['SRC000651'].VAT['S']
    //
    property Cache: TOrderPaymentsCache read FCache;

    // Event-handler for updating a progress-bar while running Process
    property OnUpdateProgress: TOnUpdateProgressProc read FOnUpdateProgress write FOnUpdateProgress;

  end;

implementation

uses Classes, ADODB;

const
  TPaymentTypes = [vptSORPayment, vptSDNPayment, vptSINPayment];
  TRefundTypes = [vptSORValueRefund, vptSINValueRefund, vptSINStockRefund];

// =============================================================================
// TOrderPaymentsVATEntry
// =============================================================================

constructor TOrderPaymentsVATEntry.Create(ForVATCode: Char);
begin
  VATCode := ForVATCode;
  Goods   := 0.0;
  VAT     := 0.0;
end;

// =============================================================================
// TOrderPaymentsCacheEntry
// =============================================================================

constructor TOrderPaymentsCacheEntry.Create(ForOurRef: string);
begin
  FOurRef := ForOurRef;
  FVAT := TObjectList.Create;
  FVAT.OwnsObjects := True;
end;

// -----------------------------------------------------------------------------

destructor TOrderPaymentsCacheEntry.Destroy;
begin
  FVAT.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCacheEntry.GetCount: Integer;
begin
  Result := FVAT.Count;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCacheEntry.GetTotalVAT: Double;
var
  i: Integer;
begin
  Result := 0.0;
  for i := 0 to FVAT.Count - 1 do
    Result := Result + TOrderPaymentsVATEntry(FVAT[i]).VAT;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCacheEntry.GetVAT(VATCode: Char): TOrderPaymentsVATEntry;
var
  i: Integer;
  Idx: Integer;
begin
  Result := nil;
  Idx := -1;
  // Search the FVAT list for an entry matching with the supplied VAT Code
  for i := 0 to FVAT.Count - 1 do
  begin
    if TOrderPaymentsVATEntry(FVAT[i]).VATCode = VATCode then
    begin
      Idx := i;
      break;
    end;
  end;
  // If we didn't find an entry against this VAT Code create a new one and
  // return it.
  if Idx = -1 then
    Idx := FVAT.Add(TOrderPaymentsVATEntry.Create(VATCode));

  Result := TOrderPaymentsVATEntry(FVAT[Idx]);
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCacheEntry.GetVATByIndex(
  Idx: Integer): TOrderPaymentsVATEntry;
begin
  if (Idx > -1) and (Idx <> FVAT.Count) then
    Result := TOrderPaymentsVATEntry(FVAT[Idx])
  else
    Result := nil;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCacheEntry.HasVAT(VATCode: Char): Boolean;
var
  i: Integer;
  Idx: Integer;
begin
  Result := False;
  // Search the FVAT list for an entry matching with the supplied VAT Code
  for i := 0 to FVAT.Count - 1 do
  begin
    if TOrderPaymentsVATEntry(FVAT[i]).VATCode = VATCode then
    begin
      Result := True;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TOrderPaymentsCache
// =============================================================================

function TOrderPaymentsCache.AddEntry(OurRef: string): TOrderPaymentsCacheEntry;
begin
  Result := TOrderPaymentsCacheEntry.Create(OurRef);
  FCache.Add(Result);
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsCache.Clear;
begin
  FCache.Clear;
end;

// -----------------------------------------------------------------------------

constructor TOrderPaymentsCache.Create;
begin
  FCache := TObjectList.Create;
  FCache.OwnsObjects := True;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsCache.DeleteEntry(OurRef: string);
var
  Idx: Integer;
begin
  Idx := FindEntry(OurRef);
  if (Idx > -1) then
    FCache.Delete(Idx);
end;

// -----------------------------------------------------------------------------

destructor TOrderPaymentsCache.Destroy;
begin
  FCache.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCache.FindEntry(OurRef: string): Integer;
var
  i: Integer;
begin
  // Default to 'not found'
  Result := -1;
  // Scan through the entries for a match with OurRef
  for i := 0 to FCache.Count - 1 do
  begin
    if TOrderPaymentsCacheEntry(FCache[i]).OurRef = OurRef then
    begin
      Result := i;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCache.GetByIndex(
  Idx: Integer): TOrderPaymentsCacheEntry;
begin
  if (Idx > -1) and (Idx < Count) then
  begin
    Result := TOrderPaymentsCacheEntry(FCache[Idx]);
  end
  else
    Result := nil;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCache.GetCount: Integer;
begin
  Result := FCache.Count;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCache.GetEntry(OurRef: string): TOrderPaymentsCacheEntry;
var
  Idx: Integer;
begin
  Idx := FindEntry(OurRef);
  if (Idx = -1) then
    Result := nil
  else
    Result := TOrderPaymentsCacheEntry(FCache[Idx]);
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsCache.GetTotalVAT(VATCode: char): Double;
var
  i: Integer;
  Entry: TOrderPaymentsCacheEntry;
  VATEntry: TOrderPaymentsVATEntry;
begin
  Result := 0.0;
  // Scan through the entries
  for i := 0 to FCache.Count - 1 do
  begin
    Entry := TOrderPaymentsCacheEntry(FCache[i]);
    if Entry.HasVAT(VATCode) then
    begin
      VATEntry := Entry.VAT[VATCode];
      if Assigned(VATEntry) then
        Result := Result + VATEntry.VAT;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsCache.TotalGoodsAndVAT(VATCode: char; var Goods,
  VAT: Double);
var
  i: Integer;
  Entry: TOrderPaymentsCacheEntry;
  VATEntry: TOrderPaymentsVATEntry;
begin
  Goods := 0.0;
  VAT   := 0.0;
  // Scan through the entries
  for i := 0 to FCache.Count - 1 do
  begin
    Entry := TOrderPaymentsCacheEntry(FCache[i]);
    if Entry.HasVAT(VATCode) then
    begin
      VATEntry := Entry.VAT[VATCode];
      if Assigned(VATEntry) then
      begin
        Goods := Goods + VATEntry.Goods;
        VAT := VAT + VATEntry.VAT;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TOrderPaymentsUnmatchedReceipts
// =============================================================================

function TOrderPaymentsUnmatchedReceipts.AddCacheEntry: TOrderPaymentsCacheEntry;
begin
  Result := FCache.AddEntry(FOurRef);
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.CalculateOutstandingSRCTotal: Double;
begin
  Result := CurrencyOS(FExLocal.LInv, True, False, False);
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.CalculateTotalPayments: Double;
var
  FuncRes: Integer;
  RecAddr: LongInt;
  Key: Str255;
  VATCode: char;
  Goods: Double;
  VAT: Double;

  // Internal function to check whether the current record in OPVATPay is
  // an actual payment line for the current Sales Receipt
  function IsValidPaymentRecord: Boolean;
  begin
    // Does the Receipt reference match?
    Result := (Trim(FOPVATPayScanner.VATPayDetails.vpReceiptRef) = FOurRef);

    if Result then
      // Is this a payment record?
      Result := FOPVATPayScanner.VATPayDetails.vpType in TPaymentTypes;

    if Result then
      // Is this an actual payment line?
      Result := (FOPVATPayScanner.VATPayDetails.vpSORABSLineNo > 0);
  end;

begin
  Result := 0.0;

  // Store the current position
  FuncRes := FOPVATPayScanner.GetPosition(RecAddr);
  if (FuncRes <> 0) then
    HandleError('Failed to save position in OPVATPay table, error ' + IntToStr(FuncRes));

  // Locate all the original payment lines in OPVATPay against the current SRC
  Key := '';
  FuncRes := FOPVATPayScanner.GetFirst;
  while (FuncRes = 0) do
  begin
    // Store the Sales Order reference
    if (Trim(FOPVATPayScanner.VATPayDetails.vpReceiptRef) = FOurRef) and (FSORRef = '') then
      FSORRef := Trim(FOPVATPayScanner.VATPayDetails.vpOrderRef);

    if IsValidPaymentRecord then
    begin
      // Retrieve the details from the record
      Goods   := FOPVATPayScanner.VATPayDetails.vpGoodsValue;
      VAT     := FOPVATPayScanner.VATPayDetails.vpVATValue;
      VATCode := FOPVATPayScanner.VATPayDetails.vpVATCode;
      // Update the totals for this Sales Receipt
      Result := Result + (Goods + VAT);
      // Update the VAT split totals for this Sales Receipt
      FCacheEntry.VAT[VATCode].Goods := FCacheEntry.VAT[VATCode].Goods + Goods;
      FCacheEntry.VAT[VATCode].VAT   := FCacheEntry.VAT[VATCode].VAT + VAT;
    end;
    FuncRes := FOPVATPayScanner.GetNext;
  end;

  if not (FuncRes in [0, 4, 9]) then
    HandleError('Error scanning OPVATPay table, error ' + IntToStr(FuncRes));

  // Restore the original position
  FuncRes := FOPVATPayScanner.RestorePosition(RecAddr);
  if (FuncRes <> 0) then
    HandleError('Failed to restore position in OPVATPay table, error ' + IntToStr(FuncRes));

end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.Count: Integer;
begin
  Result := FCache.Count;
end;

// -----------------------------------------------------------------------------

constructor TOrderPaymentsUnmatchedReceipts.Create;
begin
  FCache := TOrderPaymentsCache.Create;
  FCancelled := False;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsUnmatchedReceipts.DeleteCacheEntry;
begin
  FCacheEntry := nil;
  FCache.DeleteEntry(FOurRef);
end;

// -----------------------------------------------------------------------------

destructor TOrderPaymentsUnmatchedReceipts.Destroy;
begin
  if Assigned(FOPVATPayScanner) then
    FOPVATPayScanner.Free;

  if Assigned(FExLocal) then
    Dispose(FExLocal);

  FCacheEntry := nil;
  FCache.Free;

  inherited;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsUnmatchedReceipts.FindMatchingPayments;
var
  FuncRes: Integer;
  RecAddr: LongInt;
  Key: Str255;
  VATCode: char;
  Goods: Double;
  VAT: Double;

  // Internal function to check whether the current record in OPVATPay is
  // an actual refund line for the current Sales Receipt
  function IsValidMatchingRecord: Boolean;
  begin
    // Does the Receipt reference match?
    Result := (Trim(FOPVATPayScanner.VATPayDetails.vpReceiptRef) = Trim(Inv.OurRef));

    if Result then
      // Is this a matching payment record?
      Result := FOPVATPayScanner.VATPayDetails.vpType = vptMatching;

    if Result then
      // Is this an actual payment line?
      Result := (FOPVATPayScanner.VATPayDetails.vpSORABSLineNo > 0);
  end;

begin
  // Store the current position
  FuncRes := FOPVATPayScanner.GetPosition(RecAddr);
  if (FuncRes <> 0) then
    HandleError('Failed to save position in OPVATPay table, error ' + IntToStr(FuncRes));

  // Locate all the matching payment lines in OPVATPay against the current SRC
  Key := '';
  FuncRes := FOPVATPayScanner.GetFirst;
  while (FuncRes = 0) do
  begin
    if IsValidMatchingRecord then
    begin
      // Retrieve the details from the record
      Goods   := FOPVATPayScanner.VATPayDetails.vpGoodsValue;
      VAT     := FOPVATPayScanner.VATPayDetails.vpVATValue;
      VATCode := FOPVATPayScanner.VATPayDetails.vpVATCode;
      // Update the Order Payment totals for this Sales Receipt
      FOrderPaymentsTotal := FOrderPaymentsTotal - (Goods + VAT);
      // Update the VAT split totals for this Sales Receipt
      FCacheEntry.VAT[VATCode].Goods := FCacheEntry.VAT[VATCode].Goods - Goods;
      FCacheEntry.VAT[VATCode].VAT   := FCacheEntry.VAT[VATCode].VAT - VAT;
    end;
    FuncRes := FOPVATPayScanner.GetNext;
  end;

  if not (FuncRes in [0, 4, 9]) then
    HandleError('Error scanning OPVATPay table, error ' + IntToStr(FuncRes));

  // Restore the original position
  FuncRes := FOPVATPayScanner.RestorePosition(RecAddr);
  if (FuncRes <> 0) then
    HandleError('Failed to restore position in OPVATPay table, error ' + IntToStr(FuncRes));

end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsUnmatchedReceipts.HandleError(Msg: string);
begin
  raise EOrderPaymentsUnmatchedReceiptsError.Create(Msg);
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.IncludeSalesReceipt: Boolean;
begin
  Result := (FExLocal.LInv.TransDate <= FRepParam^.VATEndd);
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsUnmatchedReceipts.LocateSalesReceipt;
var
  FuncRes: Integer;
  Key: Str255;
begin
  if (Trim(FOurRef) <> '') then
  begin
    Key := FOurRef;
    FuncRes := FExLocal.LFind_Rec(B_GetEq, InvF, InvOurRefK, Key);
    if (FuncRes <> 0) then
      HandleError('Could not locate Sales Receipt ' + FOurRef + ', error ' + IntToStr(FuncRes));
  end
  else
    HandleError('No OurRef assigned');
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsUnmatchedReceipts.PrepareDatabase;
var
  FuncRes: Integer;
begin
  if not Assigned(FExLocal) then
  begin
    New(FExLocal);
    FExLocal.Create(93);
    FExLocal.Open_System(InvF, InvF);
  end;
  if not Assigned(FOPVATPayScanner) then
  begin
    FOPVATPayScanner := TOrderPaymentsVATPayDetailsBtrieveFile.CreateWithClientID(oBtrieveFile.ClientIdType(FExLocal.ExClientID^));
    FuncRes   := FOPVATPayScanner.OpenFile(SetDrive + OrderPaymentsVATPayDetailsFilePath);
    if (FuncRes <> 0) then
      HandleError('Failed to open OPVATPay table, error ' + IntToStr(FuncRes));
  end;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.Process(RepParam: VATRepPtr): Boolean;
begin
//  if SQLUtils.UsingSQLAlternateFuncs then
//    Result := ProcessForSQL
//  else
  FRepParam := RepParam;
  Result := ProcessForBtrv;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.ProcessForBtrv: Boolean;
var
  FuncRes: Integer;
  Key: Str255;
  RecAddr: LongInt;
  MaxCount: Integer;
  RecordCount: Integer;
  ProgressUnit: Double;
begin
  Result := False;

  // Clear down all the details (in case Process is called more than once
  // against the same instance).
  Reset;

  // Set up the Btrieve database connections
  PrepareDatabase;

  // Prepare the progress update variables
  RecordCount := 0;
  MaxCount := FOPVATPayScanner.GetRecordCount;
  if (MaxCount > 0) then
    ProgressUnit := 100 / MaxCount
  else
    ProgressUnit := 1.0;

  // Find the first Order Payments record
  Key := '';
  FuncRes := FOPVATPayScanner.GetFirst;

  // While we have more Order Payments...
  while (FuncRes = 0) and not FCancelled do
  begin
    // If this is a payment entry...
    if (FOPVATPayScanner.VATPayDetails.vpType in TPaymentTypes) then
    begin
      // Save the current position
      FuncRes := FOPVATPayScanner.GetPosition(RecAddr);
      if FuncRes <> 0 then
        HandleError('Could not save position in OPVATPay table, error ' + IntToStr(FuncRes));

      // Process the Sales Receipt
      if Scan(FOPVATPayScanner.VATPayDetails.vpReceiptRef) then
        // We have found at least one unallocated Sales Receipt
        Result := True;

      // Allow any progress reporting to be updated
      if Assigned(FOnUpdateProgress) then
      begin
        RecordCount := RecordCount + 1;
        FOnUpdateProgress(Trunc(RecordCount * ProgressUnit), FCancelled)
      end;

      // Restore the record position
      FuncRes := FOPVATPayScanner.RestorePosition(RecAddr);
      if FuncRes <> 0 then
        HandleError('Could not restore position in OPVATPay table, error ' + IntToStr(FuncRes));

    end;
    // Build a key to find the next receipt
    // CJS 2015-08-19 - ABSEXCH-16723 - VAT Return with Order Payments hangs
    // Amended to use MaxInt as the Line Number value, to avoid problem with
    // Btrieve truncating character zeros in FullNomKey strings.
    Key := FOPVATPayScanner.BuildReceiptRefKey(FOPVATPayScanner.VATPayDetails.vpOrderRef,
                                        FOPVATPayScanner.VATPayDetails.vpReceiptRef,
                                        MaxInt);
    FuncRes := FOPVATPayScanner.GetGreaterThan(Key);
  end;

  if not (FuncRes in [0, 4, 9]) then
    HandleError('Error scanning OPVATPay table, error ' + IntToStr(FuncRes));

end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.ProcessForSQL: Boolean;
begin
  { TODO: SQL version }
  Result := True;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsUnmatchedReceipts.Reset;
begin
  FOurRef := '';
  FCacheEntry := nil;
  FOrderPaymentsTotal := 0.0;
  FOutstandingSRCTotal := 0.0;
  FCache.Clear;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsUnmatchedReceipts.Scan(OurRef: string): Boolean;
begin
  Result := True;

  FOurRef := Trim(OurRef);
  FSORRef := '';

  // Set up the Btrieve database connections
  PrepareDatabase;

  // Locate the Sales Receipt
  LocateSalesReceipt;

  // Exit straight-away if the transaction is outside the period range
  if not IncludeSalesReceipt then
  begin
    Result := False;
    exit;
  end;

  // Get the outstanding total from the Sales Receipt
  FOutstandingSRCTotal := CalculateOutstandingSRCTotal * -1.0;

  // If there is no outstanding amount, there is nothing to do and we can
  // exit straight away
  if IsZero(FOutstandingSRCTotal) then
  begin
    Result := False;
    exit;
  end;

  // Add a new blank entry to the cache, for the Sales Receipt
  FCacheEntry := AddCacheEntry;

  // Locate and record the details of any Order Payments for this receipt
  FOrderPaymentsTotal := CalculateTotalPayments;

  // If the Order Payments match the unallocated total on the Sales Receipt,
  // the receipt is fully matched against the payments and there is nothing
  // more to do, so we can exit.
  if SameValue(FOutstandingSRCTotal, FOrderPaymentsTotal) then
  begin
    Result := False;
    exit;
  end;

  // Locate and apply any Order Payments refunds for this receipt
  ScanForRefunds;

  // If we have now accounted for the full Sales Receipt outstanding amount,
  // the receipt is full matched and we can exit.
  if SameValue(FOutstandingSRCTotal, FOrderPaymentsTotal) then
  begin
    Result := False;
    exit;
  end;

  // Locate and apply any matching payments in Order Payments for this receipt
  FindMatchingPayments;

  // If we still haven't accounted for the unallocated amount against the
  // Sales Receipt, mark the cache accordingly, so that it is included in the
  // main transaction section of the VAT Return (rather than in the Order
  // Payments section)
  if not SameValue(FOutstandingSRCTotal, FOrderPaymentsTotal) then
  begin
    FCacheEntry.IsUnmatchedByOrderPayments := (Inv.thOrderPaymentElement <> opeNA);
  end;

end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsUnmatchedReceipts.ScanForRefunds;
var
  FuncRes: Integer;
  RecAddr: LongInt;
  Key: Str255;
  VATCode: char;
  Goods: Double;
  VAT: Double;

  // Internal function to check whether the current record in OPVATPay is
  // an actual refund line for the current Sales Receipt
  function IsValidRefundRecord: Boolean;
  begin
    // Does the Receipt reference match?
    Result := (Trim(FOPVATPayScanner.VATPayDetails.vpOrderRef) = FSORRef);

    if Result then
      // Is this a refund record?
      Result := FOPVATPayScanner.VATPayDetails.vpType in TRefundTypes;

    if Result then
      // Is this an actual refund line?
      Result := (FOPVATPayScanner.VATPayDetails.vpSORABSLineNo > 0);
  end;

begin
  // Store the current position
  FuncRes := FOPVATPayScanner.GetPosition(RecAddr);
  if (FuncRes <> 0) then
    HandleError('Failed to save position in OPVATPay table, error ' + IntToStr(FuncRes));

  // Locate all the refund lines in OPVATPay against the current SRC
  Key := '';
  FuncRes := FOPVATPayScanner.GetFirst;
  while (FuncRes = 0) and not FCancelled do
  begin
    if IsValidRefundRecord then
    begin
      // Retrieve the details from the record
      Goods   := FOPVATPayScanner.VATPayDetails.vpGoodsValue;
      VAT     := FOPVATPayScanner.VATPayDetails.vpVATValue;
      VATCode := FOPVATPayScanner.VATPayDetails.vpVATCode;
      // Update the Order Payment totals for this Sales Receipt
      FOrderPaymentsTotal := FOrderPaymentsTotal - (Goods + VAT);
      // Update the VAT split totals for this Sales Receipt
      FCacheEntry.VAT[VATCode].Goods := FCacheEntry.VAT[VATCode].Goods - Goods;
      FCacheEntry.VAT[VATCode].VAT   := FCacheEntry.VAT[VATCode].VAT - VAT;
    end;
    FuncRes := FOPVATPayScanner.GetNext;
  end;

  if not (FuncRes in [0, 4, 9]) then
    HandleError('Error scanning OPVATPay table, error ' + IntToStr(FuncRes));

  // Restore the original position
  FuncRes := FOPVATPayScanner.RestorePosition(RecAddr);
  if (FuncRes <> 0) then
    HandleError('Failed to restore position in OPVATPay table, error ' + IntToStr(FuncRes));

end;

// -----------------------------------------------------------------------------

end.

