Unit PromptPaymentDiscountFuncs;

Interface

Uses VarConst, Graphics;

Const
  // PPD should only be shown against the following transaction types. Note: it can only be
  // given/taken against Invoices and Journal Invoices
  PPDTransactions : Set of DocTypes = [SQU, SOR, SDN, SIN, SJI,
                                       PQU, POR, PDN, PIN, PJI];

  // The set of Transactions where PPD can be Given/Taken
  PPDTakeTransactions : Set of DocTypes = [SIN, SJI, PIN, PJI];


// Recalculates the PPD Goods and VAT Totals (if not already taken)
Procedure UpdatePPDTotals (Var TransRec : InvRec);

//Returns true if any of the PPD fields are populated
Function PPDFieldsPopulated(const TransRec : InvRec) : Boolean;

//Sets colours appropriately from system setup settings
procedure SetPPDColours(Days : Integer; var TextColour : TColor; var BackColour : TColor; const Font : TFont);

//Returns the appropriate word for giving or taking PPD according to Sales / Purchase
function PPDGiveTakeWord(CustSupp : Char; InitialCap : Boolean = True) : string;

//Returns true if there is unexpired ppd available taking into account payment date and tolerance
function ValidPPDAvailable(InvR : InvRec; PaymentDate : string; DaysTolerance : Integer = 0) : Boolean;

//Returns true if ok to continue with a manual alllocation, either because there is no valid ppd or the user
//has clicked OK on warning message
function ContinueWithManualAllocation(InvR : InvRec) : Boolean;

// CJS 2015-10-20 - ABSEXCH-16891 - Cancel PPD button showing on SCR/PCR
// Clear all the PPD fields in the supplied record
procedure ClearPPDFields(var InvR: InvRec);

Implementation

Uses ComnUnit, Comnu2, ETMiscU, oSystemSetup, SysUtils, EtDateU, ApiUtil, Dialogs, Controls, CurrncyU;

//-------------------------------------------------------------------------

// Recalculates the PPD Goods and VAT Totals (if not already taken)
Procedure UpdatePPDTotals (Var TransRec : InvRec);
Var
  PPDTotal : Double;
Begin // UpdatePPDTotals
  // Don't change the PPD totals if the discount has been taken
  If (TransRec.thPPDTaken = ptPPDNotTaken) Then
  Begin
    // Enforce zero values if the percentage isn't set
    If (TransRec.thPPDPercentage <> 0.0) Then
    Begin
      // Calculate PPD Total as a percentage of the Transaction Total
      PPDTotal := Round_Up(Calc_PAmount(ITotal(TransRec), TransRec.thPPDPercentage, PcntChr), 2);

      // Calculate PPD VAT Value as a percentage of the Total VAT
      TransRec.thPPDVATValue := Round_Up(Calc_PAmount(TransRec.InvVat, TransRec.thPPDPercentage, PcntChr), 2);

      // Subtract the PPD VAT Value from the PPD Discount Total to get the PPD Goods Total
      TransRec.thPPDGoodsValue := Round_Up(PPDTotal - TransRec.thPPDVATValue, 2);
    End // If (InvR.thPPDPercentage <> 0.0)
    Else
    Begin
      TransRec.thPPDGoodsValue := 0.0;
      TransRec.thPPDVATValue   := 0.0;
    End; // Else
  End; // If (TransRec.thPPDTaken = ptPPDNotTaken)
End; // UpdatePPDTotals

//-------------------------------------------------------------------------

//Returns true if any of the PPD fields are populated
Function PPDFieldsPopulated(const TransRec : InvRec) : Boolean;
begin
  Result := (TransRec.thPPDPercentage + TransRec.thPPDDays <> 0.0) or (TransRec.thPPDTaken <> ptPPDNotTaken);
end;

//Sets colours appropriately from system setup settings
procedure SetPPDColours(Days : Integer; var TextColour : TColor; var BackColour : TColor; const Font : TFont);
begin

  with SystemSetup.PPD do
  begin
    if Days > PPDAmberDays then
    begin
      TextColour := PPDGreenColours.poFontColour;
      BackColour := PPDGreenColours.poBackgroundColour;
      Font.Style := PPDGreenColours.poFontStyle;
    end
    else
    if Days > PPDRedDays then
    begin
      TextColour := PPDAmberColours.poFontColour;
      BackColour := PPDAmberColours.poBackgroundColour;
      Font.Style := PPDAmberColours.poFontStyle;
    end
    else
    if Days >= 0 then
    begin
      TextColour := PPDRedColours.poFontColour;
      BackColour := PPDRedColours.poBackgroundColour;
      Font.Style := PPDRedColours.poFontStyle;
    end
    else
    if Days < 0 then
    begin
      TextColour := PPDExpiredColours.poFontColour;
      BackColour := PPDExpiredColours.poBackgroundColour;
      Font.Style := PPDExpiredColours.poFontStyle;
    end;
  end;  //with SystemSetup.PPD
end;

//Returns the appropriate word for giving or taking PPD according to Sales / Purchase
function PPDGiveTakeWord(CustSupp : Char; InitialCap : Boolean = True) : string;
begin
  if CustSupp = TradeCode[True] then
    Result := 'Give'
  else
    Result := 'Take';

  if not InitialCap then
    Result[1] := LowerCase(Result[1])[1];
end;


//Returns true if there is unexpired ppd available taking into account payment date and tolerance
//PR: 10/06/2015 Implemented DaysTolerance parameter; if this is -1 then date is ignored
function ValidPPDAvailable(InvR : InvRec; PaymentDate : string; DaysTolerance : Integer = 0) : Boolean;
begin
  with InvR do
    Result := (Round_Up(thPPDGoodsValue + thPPDVATValue, 2) <> 0.00) and  (thPPDTaken = ptPPDNotTaken) and
                         ((DaysTolerance = -1) or (NoDays(PaymentDate, CalcDueDate(TransDate, thPPDDays)) >= (-1 * Abs(DaysTolerance))));
end;

//Returns true if ok to continue with a manual alllocation, either because there is no valid ppd or the user
//has clicked OK on warning message
function ContinueWithManualAllocation(InvR : InvRec) : Boolean;
begin
  //Only show message if valid transaction type and PPD available
  Result := not (Inv.InvDocHed in PPDTakeTransactions) or not ValidPPDAvailable(InvR, Today);

  if not Result then
  begin //If nothing o/s except for PPD, then allow allocation to go through
    if Abs(CurrencyOS(InvR, True, False, False)) = Round_Up(InvR.thPPDGoodsValue + InvR.thPPDVATValue, 2) then
      Result := True
    else  //PR: 04/08/2015 ABSEXCH-16660 Changed text again as per AP's wishes
      Result := msgBox('This transaction has PPD available.'#10#10'As the amount entered is more than the invoice less the PPD value, ' +
       'it is not possible to account for the PPD.'#10#10 +
       'Are you sure you want to allocate?', mtConfirmation,
             [mbYes, mbNo], mbNo, 'PPD Available') = mrYes;
  end;
end;

// CJS 2015-10-20 - ABSEXCH-16891 - Cancel PPD button showing on SCR/PCR
// Clear all the PPD fields in the supplied record
procedure ClearPPDFields(var InvR: InvRec);
begin
  InvR.thPPDPercentage     := 0.0;
  InvR.thPPDDays           := 0;
  InvR.thPPDGoodsValue     := 0.0;
  InvR.thPPDVATValue       := 0.0;
  InvR.thPPDTaken          := ptPPDNotTaken;
  InvR.thPPDCreditNote     := False;
  InvR.thBatchPayPPDStatus := 0;
end;

End.
