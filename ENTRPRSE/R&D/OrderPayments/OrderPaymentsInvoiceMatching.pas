unit OrderPaymentsInvoiceMatching;

interface

uses Types, Math, SysUtils, Contnrs,
  BtrvU2,
  GlobVar,
  VarConst,
  ComnUnit,
  ETMiscU,
  MiscU,
  ETStrU,
  BtKeys1U,
  BtSupU1,
  CurrncyU,
  SavePos,
  OrderPaymentsInterfaces,
  oOPVATPayBtrieveFile,
  oOrderPaymentsTransactionPaymentInfo;

type
  { Simple class to hold the details of one Sales Receipt transaction }
  TReceipt = class(TObject)
  private
    FValue: Double;
    FOurRef: string;
  public
    property OurRef: string read FOurRef write FOurRef;
    property Value: Double read FValue write FValue;
  end;

  { Class to hold a list of Sales Receipt transactions and Values, for use in
    adding Financial Matching records from a Sales Order. }
  TReceiptList = class(TObject)
  private
    FList: TObjectList;
    function GetCount: Integer;
    function GetItem(Idx: Integer): TReceipt;
  public
    constructor Create;
    destructor Destroy; override;

    { Clears all the entries }
    procedure Clear;

    { Adds a new entry to the list, or updates an existing entry by adding the
      supplied value if ReceiptRef is already in the list. }
    procedure Update(ReceiptRef: string; Value: Double);

    { Retrieves the Receipt that matches the supplied reference, or creates
      and returns a new TReceipt if one cannot be found. }
    function Retrieve(ReceiptRef: string): TReceipt;

    { Property to return a count of the items in FList }
    property Count: Integer read GetCount;

    { Property to expose the FList as an indexed array }
    property Items[Idx: Integer]: TReceipt read GetItem; default;

  end;

  { Class to handle matching between a newly-created Invoice and the payments
    that it relates to. }
  TOrderPaymentsInvoiceMatching = class(TObject)
  private
    { List of matched Sales Receipts }
    FReceiptList: TReceiptList;

    { Originating Sales Order transaction }
    FSource: InvRec;

    { Newly created SIN (must be supplied by the calling routine) }
    FInvoice: InvRec;

    { Current line number in the originating Sales Order (Source) transaction }
    FSalesOrderLineNo: Integer;

    { Current line number for the OPVATPay records }
    FOPMatchingLineNo: Integer;

    { Access to the OPVATPay file }
    FVATPayFile : TOrderPaymentsVATPayDetailsBtrieveFile;

    { Access to the list of Payments for the original Sales Order }
    FPayments: IOrderPaymentsTransactionPaymentInfo;
    FPaymentHeader: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
    FPaymentLine: IOrderPaymentsTransactionPaymentInfoPaymentLine;

    { Error status -- this defaults to 0, but will be set to one of the
      offset error codes if any errors occur:

            0         : Success
         8001 -  8999 : Error storing Order Payments Matching
         9001 -  9999 : Error storing Financial Matching
        10001 - 10999 : Error locating/updating Sales Order
        11001 - 11999 : Error locating/updating Sales Receipt
        12001 - 12999 : Error locating/updating Sales Invoice
        13001 - 13999 : Error initialising Order Payments Invoice Matching

      See oOrderPaymentsSRC.pas
    }
    FError: Integer;

    { Adds a Financial Matching record matching the supplied Sales Receipt with
      the originating Sales Order }
    function AddFinancialMatching(const SRCRef: string; MatchValue: Double): Integer;

    { Adds an Order Payments Matching record matching the current Payment line
      with the originating Sales Order }
    function AddOrderPaymentsMatching(GoodsValue: Double; VATValue: Double): Integer;

    { Prepares the internal variables for a Match run }
    function Start: LongInt;

    { Scans through the payments lines against the current payment header,
      looking for a match with the original SOP Line Number from the Source
      transaction, and raising appropriate matching records. Returns True if
      the transaction is then fully paid, otherwise returns the remaining
      values in Value and VAT. }
    function MatchPayments(var Value: Double; var VAT: Double): Boolean;

    { Clears data and closes files after a Match run }
    procedure Finish;

  public
    constructor Create;
    destructor Destroy; override;

    { Main entry point for creating matching records }
    function Match(const Source, Invoice: InvRec): LongInt;

  end;

// Given the originating (source) transaction (which should be either an SOR
// or an SDN) and the SIN that is being raised from it, this will create the
// appropriate payment/invoice matching records in the OPVATPay table.
function MatchInvoiceToOrderPayment(const Source, Invoice: InvRec): LongInt;

implementation

uses oBtrieveFile, Classes;

//-------------------------------------------------------------------------
// Utility function for using the TOrderPaymentsInvoiceMatching class. Call
// this with the originating transaction record (either SOR or SDN) in Source,
// and the newly-created Invoice transaction in Invoice. It will create the
// requisite Order Payment Matching records and Financial Matching records.
//
// See FError (in TOrderPaymentsInvoiceMatching above) for details of the
// possible return values.
function MatchInvoiceToOrderPayment(const Source, Invoice: InvRec): LongInt;
var
  oMatching: TOrderPaymentsInvoiceMatching;
begin
  oMatching := TOrderPaymentsInvoiceMatching.Create;
  try
    Result := oMatching.Match(Source, Invoice);
  finally
    oMatching.Free;
  end;
end;

// =============================================================================
// TReceiptList
// =============================================================================

procedure TReceiptList.Clear;
begin
  FList.Clear;
end;

// -----------------------------------------------------------------------------

constructor TReceiptList.Create;
begin
  inherited Create;
  // Create an object list which owns its objects, so that it will free them
  // automatically when the list is freed.
  FList := TObjectList.Create(True);
end;

// -----------------------------------------------------------------------------

destructor TReceiptList.Destroy;
begin
  FList.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function TReceiptList.GetCount: Integer;
begin
  Result := FList.Count;
end;

// -----------------------------------------------------------------------------

function TReceiptList.GetItem(Idx: Integer): TReceipt;
begin
  Result := TReceipt(FList[Idx]);
end;

// -----------------------------------------------------------------------------

function TReceiptList.Retrieve(ReceiptRef: string): TReceipt;
var
  i: Integer;
begin
  Result := nil;
  ReceiptRef := Trim(ReceiptRef);
  // Search for an existing entry
  for i := 0 to FList.Count - 1 do
  begin
    if Trim(TReceipt(FList[i]).OurRef) = ReceiptRef then
    begin
      Result := TReceipt(FList[i]);
      break;
    end;
  end;
  // If no entry was found, create a new one
  if (Result = nil) then
  begin
    Result := TReceipt.Create;
    Result.OurRef := ReceiptRef;
    Result.Value := 0.0;
    FList.Add(Result);
  end;
end;

// -----------------------------------------------------------------------------

procedure TReceiptList.Update(ReceiptRef: string; Value: Double);
var
  Receipt: TReceipt;
begin
  Receipt := Retrieve(ReceiptRef);
  Receipt.Value := Receipt.Value + Value;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TOrderPaymentsInvoiceMatching
// =============================================================================

function TOrderPaymentsInvoiceMatching.AddFinancialMatching(const SRCRef: string; MatchValue: Double): integer;
var
  Key: Str255;
begin
  // The supplied Invoice record is not necessarily the record that we are
  // currently on (it depends on which route we took through the Delivery Run
  // code), so we need to find the correct record, and to restore the position
  // once we have saved the record.
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file
      SaveFilePosition (InvF, GetPosKey);
      SaveDataBlock (@Inv, SizeOf(Inv));

      // Find the Invoice
      Key := FullNomKey(FInvoice.FolioNum);
      Result := Find_Rec(B_GetEq, F[InvF], InvF, FInvoice, InvFolioK, Key);
      if (Result <> 0) then
      begin
        // Couldn't find the new Sales Invoice
        FError := 12000 + Result;
      end;

      if Result = 0 then
      begin

        // Update settled value on transaction we're matching to
        FInvoice.CurrSettled := FInvoice.CurrSettled + MatchValue;
        FInvoice.Settled     := Conv_TCurr(FInvoice.CurrSettled, XRate(FInvoice.CXRate, False, FInvoice.Currency), FInvoice.Currency, 0, False);

        // Set the allocated status
        Set_DocAlcStat(FInvoice, False);

        // Store the new FInvoice
        Result := Put_Rec(F[InvF], InvF, FInvoice, InvFolioK);
        if (Result <> 0) then
          FError := Result + 12000;

        if (Result = 0) then
        begin
          // Now find the matching Sales Receipt
          Key := Trim(SRCRef);
          Result := Find_Rec(B_GetEq, F[InvF], InvF, Inv, InvOurRefK, Key);
          if (Result <> 0) then
          begin
            // Couldn't find the original Sales Receipt.
            FError := 11000 + Result;
          end
          else
          begin
            // Update the settled value on the Sales Receipt
            Inv.CurrSettled := Inv.CurrSettled - MatchValue;
            Inv.Settled     := Conv_TCurr(Inv.CurrSettled, XRate(Inv.CXRate, False, Inv.Currency), Inv.Currency, 0, False);

            // Set the allocated status
            Set_DocAlcStat(Inv, False);

            Result := Put_Rec(F[InvF], InvF, Inv, InvOurRefK);
            if (Result <> 0) then
            begin
              // Failed to store the receipt.
              FError := 11000 + Result;
            end;
          end;
        end; // if (Result = 0)...

      end;

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@Inv);
    Finally
      Free;
    End; // Try...Finally
  End; // With TBtrieveSavePosition.Create...

  if Result = 0 then
  begin
    // Add the matching record
    ResetRec(PWrdF);

    Password.RecPFix := MatchTCode;
    Password.SubType := MatchSCode;

    Password.MatchPayRec.MatchType := 'A';
    Password.MatchPayRec.DocCode   := LJVar(FInvoice.OurRef, DocKeyLen);
    Password.MatchPayRec.PayRef    := LJVar(SRCRef, DocKeyLen);
    Password.MatchPayRec.AltRef    := LJVar(FSource.OurRef, DocKeyLen);

    Password.MatchPayRec.MCurrency := FInvoice.Currency;
    Password.MatchPayRec.RCurrency := FInvoice.Currency;

    Password.MatchPayRec.OwnCVal    := Round_Up(Abs(MatchValue), Syss.NoNetDec);
    Password.MatchPayRec.SettledVal := Round_Up(Conv_TCurr(Abs(Password.MatchPayRec.OwnCVal), XRate(FInvoice.CXRate, False, FInvoice.Currency), FInvoice.Currency, 0, False), Syss.NoNetDec);

    Result := Add_Rec(F[PWrdF], PWrdF, Password, 0);

    if (Result <> 0) then
    begin
      // Failed to add the Financial Matching record.
      FError := Result + 9000;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsInvoiceMatching.AddOrderPaymentsMatching(
  GoodsValue: Double; VATValue: Double): Integer;
var
  MatchValue: Double;
begin
  MatchValue := GoodsValue;
  // Add an OPVATPay record with vpTrans set to the new Invoice,
  // OrderRef set to the original Order, and ReceiptRef set to the
  // payment that we found.
  with FVATPayFile.VATPayDetails do
  begin
    // MH 08/10/2014: Corrected padding on index fields
    vpOrderRef := PadOrderRefKey(FSource.OurRef);
    vpReceiptRef := PadReceiptRefKey(FPaymentLine.opplReceiptReference);
    vpTransRef := PadTransRefKey(FInvoice.OurRef);
    vpDescription := FPaymentLine.opplDescription;
    vpLineOrderNo := FOPMatchingLineNo;
    vpSORABSLineNo := FSalesOrderLineNo;
    vpType := vptMatching;
    vpCurrency := Id.Currency;

    // CJS 2015-01-06 - ABSEXCH-15988 - VAT Code M omitted from Order Payment VAT Returns
    if (Id.VATIncFlg In VATSet) and (Id.VATCode In VATEqStd) then
      vpVATCode := Id.VATIncFlg
    else
      vpVATCode := Id.VATCode;

    vpGoodsValue := Round_Up(GoodsValue, Syss.NoNetDec);
    vpVATValue := Round_Up(VATValue, Syss.NoNetDec);
  end;
  Result := FVATPayFile.Insert;

  // CJS 2015-01-06 - ABSEXCH-15887 - Order Payments matching not set
  if Result = 0 then
  begin
    // Add the matching record
    ResetRec(PWrdF);

    Password.RecPFix := MatchTCode;
    Password.SubType := MatchOrderPaymentCode;

    Password.MatchPayRec.MatchType := MatchOrderPaymentCode;
    Password.MatchPayRec.DocCode   := LJVar(FInvoice.OurRef, DocKeyLen);
    Password.MatchPayRec.PayRef    := LJVar(FSource.OurRef, DocKeyLen);

    Password.MatchPayRec.MCurrency := FInvoice.Currency;
    Password.MatchPayRec.RCurrency := FInvoice.Currency;

    Password.MatchPayRec.OwnCVal    := Round_Up(Abs(MatchValue), Syss.NoNetDec);
    Password.MatchPayRec.SettledVal := Round_Up(Conv_TCurr(Abs(Password.MatchPayRec.OwnCVal), XRate(FInvoice.CXRate, False, FInvoice.Currency), FInvoice.Currency, 0, False), Syss.NoNetDec);

    Result := Add_Rec(F[PWrdF], PWrdF, Password, 0);

    if (Result <> 0) then
    begin
      // Failed to add the Financial Matching record.
      FError := Result + 9000;
    end;
  end;
end;

// -----------------------------------------------------------------------------

constructor TOrderPaymentsInvoiceMatching.Create;
begin
  FReceiptList := TReceiptList.Create;
  FVATPayFile  := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
end;

// -----------------------------------------------------------------------------

destructor TOrderPaymentsInvoiceMatching.Destroy;
begin
  FVATPayFile.CloseFile;
  FreeAndNil(FVATPayFile);
  FreeAndNil(FReceiptList);
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TOrderPaymentsInvoiceMatching.Finish;
begin
  FReceiptList.Clear;
  FVATPayFile.CloseFile;
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsInvoiceMatching.Match(const Source, Invoice: InvRec): LongInt;
var
  FullyPaid: Boolean;
  OrderRef: string;
  DeliveryRef: string;
  i, j: Integer;

  ReceiptList: TReceiptList;

  Key: Str255;
  FuncRes: LongInt;
  IdTotal: Double;
  IdVAT: Double;

  // Returns True if the current Payment Header has a Delivery Note reference
  // as the Payment Transaction reference, and it matches with the source
  // transaction (i.e. this Payment is a payment against the Delivery Note
  // that we are processing).
  function IsMatchingDeliveryNote: Boolean;
  begin
    if (DeliveryRef <> '') then
      Result := (Trim(FPaymentHeader.opphPaymentOurRef) = DeliveryRef)
    else
      Result := False;
  end;

  // Returns True if the current Payment Header has no Payment Transaction
  // Reference recorded.
  function IsUnmatchedPayment: Boolean;
  begin
    Result := (FPaymentHeader.opphPaymentType in [vptSORPayment, vptSDNPayment]) and (Trim(FPaymentHeader.opphPaymentOurRef) = '');
  end;

begin
  Result := 0;

  FSource := Source;
  FInvoice := Invoice;

  FuncRes := Start;
  if (FuncRes <> 0) then
    FError := FuncRes + 13000
  else
  begin
    try
      // Get the Sales Order reference from the original Order or Delivery Note
      OrderRef    := Trim(FInvoice.thOrderPaymentOrderRef);
      DeliveryRef := '';

      // If the Source is the Delivery Note, find the original order instead,
      // and retrieve the details.
      if (FSource.InvDocHed = SDN) then
      begin
        // Keep a record of the Delivery Note reference, because it is needed by
        // the IsMatchingDeliveryNote function
        DeliveryRef := Trim(FSource.OurRef);
        with TBtrieveSavePosition.Create do
        begin
          try
            // Save the current position in the file for the current key
            SaveFilePosition (InvF, GetPosKey);
            SaveDataBlock (@Inv, SizeOf(Inv));

            // Locate the originating Sales Order and copy the record into FSource
            Key := Trim(OrderRef);
            FuncRes := Find_Rec(B_GetGEq, F[InvF], InvF, FSource, InvOurRefK, Key);
            if (FuncRes <> 0) then
            begin
              // Failed to find original Sales Order
              FError := FuncRes + 10000;
            end;

            // Restore position in file
            RestoreSavedPosition;
            RestoreDataBlock (@Inv);
          finally
            Free;
          end; // Try..Finally
        end; // With TBtrieveSavePosition.Create
      end;

      if (FuncRes = 0) then
      begin
        // Load the payment details for the originating Sales Order
        FPayments := OPTransactionPaymentInfo(FSource);

        // Scan through all the lines on the Invoice, looking for matching payment
        // entries against each line
        Key := FullNomKey(FInvoice.FolioNum);
        FuncRes := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, Id, IdFolioK, Key);
        while (FuncRes = 0) and (Id.FolioRef = FInvoice.FolioNum) do
        begin
          FSalesOrderLineNo := Id.SOPLineNo;
          FullyPaid := False;

          // Calculate the starting values for the payment
          IdTotal := Round_Up(InvLTotal(Id, True, (FInvoice.DiscSetl * Ord(FInvoice.DiscTaken))), 2);
          CalcVAT(Id, FInvoice.DiscSetl);
          IdVAT := Round_Up(Id.VAT, 2);

          // Scan through all the payments against the Source transaction, looking
          // for payments that we can match the Invoice against.

          // Check Delivery payments first, if we have a Delivery Note reference
          if (DeliveryRef <> '') then
          begin
            for i := 0 to FPayments.GetPaymentCount - 1 do
            begin
              FPaymentHeader := FPayments.GetPayment(i);
              // Is this payment against the supplied Delivery Note?
              if IsMatchingDeliveryNote then
              begin
                FullyPaid := MatchPayments(IdTotal, IdVAT);
              end; // if IsMatchingDeliveryNote then...
              if FullyPaid then
                break;
            end; // for i := 0 to Payments.GetPaymentCount - 1 do...
          end;

          // If we still have an amount outstanding look for other payments
          if (not FullyPaid) then
          begin
            for i := 0 to FPayments.GetPaymentCount - 1 do
            begin
              FPaymentHeader := FPayments.GetPayment(i);
              // Is this payment currently unmatched?
              if IsUnmatchedPayment then
              begin
                FullyPaid := MatchPayments(IdTotal, IdVAT);
              end; // if IsUnmatchedPayment then...
              if FullyPaid then
                break;
            end; // for i := 0 to Payments.GetPaymentCount - 1 do...
          end;

          FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, Id, IdFolioK, Key);
        end;

        // Add Financial Matching records for each receipt that was found
        for i := 0 to FReceiptList.Count - 1 do
          AddFinancialMatching(FReceiptList[i].OurRef, FReceiptList[i].Value);

      end; // if (FuncRes = 0) then...
    finally
      Finish;
    end;
  end; // if (FuncRes <> 0) then...
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsInvoiceMatching.MatchPayments(var Value,
  VAT: Double): Boolean;
var
  i: Integer;
  FuncRes: LongInt;
  Comparison: TValueRelationship;
begin
  Result := False;
  for i := 0 to FPaymentHeader.opphPaymentLineCount - 1 do
  begin
    FPaymentLine := FPaymentHeader.opphPaymentLines[i];
    //PR: 18/09/2015 ABSEXCH-16880 Need to check SOP line number against AbsLineNo not LineNo
    if (FPaymentLine.opplOrderLine.opolLine.AbsLineNo = FSalesOrderLineNo) then
    begin
      if (FPaymentLine.opplUnmatchedValue <> 0) then
      begin
        // This payment has not been fully matched yet, so we can use it
        // to match with the current Invoice. Compare the value on the
        // payment with the value on the Invoice
        // MH 11/11/2014 ABSEXCH-15802: Modified to include Goods + VAT value in the comparison
        Comparison := CompareValue(FPaymentLine.opplUnmatchedValue, Value + VAT);

        // If the payment value is at least the value of the Invoice,
        // we can part match it, and this will complete the Invoice
        // matching (as we will have matched the complete value of the
        // Invoice).
        if (Comparison in [GreaterThanValue, EqualsValue]) then
        begin
          // Add a matching record. The values will be the total value on
          // the Invoice line.
          FuncRes := AddOrderPaymentsMatching(Value, VAT);
          if (FuncRes <> 0) then
          begin
            // Failed to add OPVATPay record.
            FError := FuncRes + 8000;
          end
          else
          begin
            // Store the receipt details
            FReceiptList.Update(FPaymentLine.opplReceiptReference, Value + VAT);
            Result := True;
            FOPMatchingLineNo := FOPMatchingLineNo + 1;
            break;
          end;
        end
        // If the unmatched payment value is less than the value of the Invoice,
        // we can match with it, which will completely allocate this
        // payment, but we need to continue searching for more payments
        // to match against, reducing the amount we need to allocate by
        // the amount that was paid off against this payment.
        else if (Comparison = LessThanValue) then
        begin
          // Add a matching record. The values will be the unmatched values on
          // the payment, and the values for the Invoice are reduced by
          // the same amount.
          FuncRes := AddOrderPaymentsMatching(FPaymentLine.opplUnmatchedGoods, FPaymentLine.opplUnmatchedVAT);
          if (FuncRes <> 0) then
          begin
            // Failed to add OPVATPay record.
            FError := FuncRes + 8000;
          end
          else
          begin
            // Store the receipt details
            FReceiptList.Update(FPaymentLine.opplReceiptReference, FPaymentLine.opplUnmatchedGoods + FPaymentLine.opplUnmatchedVAT);
            // Reduce the outstanding amounts by the (previously) unmatched amounts
            Value := Value - FPaymentLine.opplUnmatchedGoods;
            VAT := VAT - FPaymentLine.opplUnmatchedVAT;
            if (IsZero(Value) and IsZero(Value)) then
              Result := True;
            FOPMatchingLineNo := FOPMatchingLineNo + 1;
          end; // if (FuncRes...
        end; // if (Comparison...
      end; // if (FPaymentLine.opplUnmatchedValue <> 0)...
    end; // if (PaymentLine.opplOrderLine.opolLine.LineNo = LineNo)...
  end; // for i := 0 to PaymentHeader.opphPaymentLineCount - 1 do...
end;

// -----------------------------------------------------------------------------

function TOrderPaymentsInvoiceMatching.Start: LongInt;
begin
  FError := 0;
  Result := FVATPayFile.OpenFile(SetDrive + OrderPaymentsVATPayDetailsFilePath);

  // Add default values (identical for all rows that we might add): current
  // Exchequer user, date and time are set by InitialiseRecord
  FVATPayFile.InitialiseRecord;
  with FVATPayFile.VATPayDetails do
    vpUserName := EntryRec^.Login;

  FReceiptList.Clear;
  FOPMatchingLineNo := 1;
end;

// -----------------------------------------------------------------------------

end.
