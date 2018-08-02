unit TTDCalcTCM;

interface

uses
  ComCtrls, TXRecs, Windows, SysUtils, Classes, Contnrs, Dialogs, StrUtils, Math
  , TCMEntFuncs, MathUtil, MiscUtil, EposCnst, EPOSProc, GlobVar, VarConst, VarRec2U
  , CalcPric;

{$I DEFOVR.Inc}

const
  TTDDescHeader = 'Transaction Total Discount of ';
  VBDDescHeader = 'Value Based Discount of ';

type
  pInvRec = ^InvRec;

  //------------------------------

  TCalculatorDiscountMode = (cdmTTD=1, cdmVBD=2);  // ordinal values need to match up to TTD/VBD values in Discount3Type
  TTTDLineTotalsEnum = (ltBeforeNetTotal, ltAfterNetTotal, ltAfterTotalCost, ltBeforeTotalCost);
  TTTDTotalsEnum = (ttBeforeTotalCost, ttBeforeNetTotal, ttBeforeNetLessSettle, ttAfterTotalCost, ttAfterNetTotal, ttAfterNetLessSettle);

  //------------------------------

  TTTDCalculator = Class;

  //------------------------------

  TTTDNotificationLine = Class(TObject)
  Private
    FParentCalculator : TTTDCalculator;
    FParentTXRec : TTXRec;
    FParentListView : TListView;
    FNotifyLine : TTXLineRec;
    FExistingLine : Boolean;
  Public
    Constructor Create (Const ParentCalculator : TTTDCalculator; TheTXRec : TTXRec; TheListView : TListView);
    // Assigned an existing transaction line as the description line
    Procedure Assign (Const DescLine : TTXLineRec);
    // Deletes any pre-existing TTD/VBD Notification Line
//  Procedure Delete;
    // Updates the notification line description and updates the database
    Procedure Update (Const NewDesc : ShortString);
  End; // TTTDNotificationLine

  //------------------------------

  TTTDCalculatorLine = Class(TObject)
  Private
    FParentCalculator : TTTDCalculator;
    FParentTXRec : TTXRec;
    FParentListView : TListView;
    FBeforeLine : TTXLineRec;
    FAfterLine : TTXLineRec;
    FOrigLine : TTXLineRec;

    Function GetLineTotals(Index : TTTDLineTotalsEnum) : Double;

  Public
    Property LineTotals[Index : TTTDLineTotalsEnum] : Double Read GetLineTotals;

    Constructor Create(Const ParentCalculator : TTTDCalculator; ParentTXRec : TTXRec; ParentListView : TListView; Const TXLineRec : TTXLineRec);

    // Applies the specified percentage discount to the line and checks user permissions for
    // selling below Cost Price.  Returns False if that user permission is enabled and the
    // discount would break the rule.
    Function ApplyPercentageDiscount (Const DiscValue : Real48) : Boolean;

    // Applies the specified amount discount to the line and checks user permissions for
    // selling below Cost Price and selling below 0.  Returns the amount that was actually
    // allocated
    Function ApplyAmountDiscount (Const DiscValue : Real48) : Real48;
    procedure RecalcLine(var TheTXLineRec : TTXLineRec);
  End; // TTTDCalculatorLine

  //------------------------------

  TTTDCalculator = Class(TObject)
  Private
    FDiscountMode : TCalculatorDiscountMode;

    FOrigTXRec, FTXRec : TTXRec;
    FActualLines, FListView : TListView;

    FLines : TObjectList;
    FDescLine : TTTDNotificationLine;

    FHideCost : Boolean;
    FIsPurchase : Boolean;
    FAdding : Boolean;

    FTTDExists : Boolean;
    FTTDDiscount : Real48;
    FTTDDiscType : Char;
    FVBDExists : Boolean;

    FAllowSaleBelowCost : Boolean;
    FAllowDiscountToExceedSale : Boolean;

    // Controls whether classes will show error messages
//  FUIMode : Boolean;

    // Total Amount of Discount requested
    FAmountDiscountRequested : Double;
    // Total Amount of Discount applied to lines
    FAmountDiscountApplied : Double;

    // A textual description of the last discount applied to be used on the notification lines
    FDiscountDesc : ShortString;

    // Pointer to commitment account object
    FCommitPtr : Pointer;

    Function GetOurRef : ShortString;
    Function GetTransTotals (Index : TTTDTotalsEnum) : Double;

    // Adds a transaction line into the cache
    Procedure CacheLine (Const TXLineRec : TTXLineRec);

    // Load the transaction lines into cache to work with
    Procedure LoadLines;

  Public
    Property Adding : Boolean Read FAdding;
    Property AllowSaleBelowCost : Boolean Read FAllowSaleBelowCost Write FAllowSaleBelowCost;
    Property AllowDiscountToExceedSale : Boolean Read FAllowDiscountToExceedSale Write FAllowDiscountToExceedSale;
    Property AmountDiscountApplied : Double Read FAmountDiscountApplied;
    Property AmountDiscountRequested : Double Read FAmountDiscountRequested;
    Property CommitPtr : Pointer Read FCommitPtr Write FCommitPtr;
    Property DiscountMode : TCalculatorDiscountMode Read FDiscountMode Write FDiscountMode;
    Property HideCost : Boolean Read FHideCost;
    Property IsPurchase : Boolean Read FIsPurchase;
    Property OurRef : ShortString Read GetOurRef;
    Property TransTotals [Index : TTTDTotalsEnum] : Double Read GetTransTotals;
    Property TTDExists : Boolean Read FTTDExists;
    Property TTDType : Char Read FTTDDiscType Write FTTDDiscType;
    Property TTDValue : Real48 Read FTTDDiscount;
    Property VBDExists : Boolean Read FVBDExists;
    Property TXRec : TTXRec read FTXRec;
    Property ListView : TListView read FListView;

    Constructor Create(Const Adding : Boolean; TheTXRec : TTXRec; TheListView : TListView);
    Destructor Destroy; Override;

    // Applies the specified discount to the cached lines, if the percentage discount
    // cannot be fully applied due to Cost Price rules then it will apply a value
    // based discount instead.  If the full value based discount cannot be applied
    // then a popup notification message will be shown
    Function CalculateAD (DiscValue : Real48; DiscType : Char) : Boolean;

    // Updates the Transaction/Lines with the currently specified discount overwriting any pre-existing TTD/VBD
    Procedure ApplyTTD;

    // Removes and pre-existing TTD/VBD and updates the Transaction/Lines
    Procedure RemoveTTD;

    // Returns True if the specified Percentage Discount is within the valid range
    Function ValidPercentageDiscount (Const PercValue : Double) : Boolean;
    // Returns True if the specified Discount Value is within the valid range
    Function ValidValueDiscount (Const DiscAmount : Double) : Boolean;

    // Updates the Transaction/Lines with the currently specified discount
    Procedure UpdateTransactionDiscounts (Const ApplyDiscounts : Boolean);
  End; // TTTDCalculator

  //------------------------------

implementation
Uses
  BtrvU2, BTKeys1U, BTSupU1, Comnu2, ETMiscU;

//=========================================================================

Constructor TTTDNotificationLine.Create (Const ParentCalculator : TTTDCalculator; TheTXRec : TTXRec; TheListView : TListView);
Begin // Create
  Inherited Create;

  FParentCalculator := ParentCalculator;
  FParentTXRec := TheTXRec;
  FParentListView := TheListView;

  FExistingLine := False;
  FillChar(FNotifyLine, SizeOf(FNotifyLine), #0);

  With FNotifyLine, TKTLRec Do
  Begin
    FolioNum   := FParentTXRec.TKTXHeader.FolioNum;
    Currency   := FParentTXRec.TKTXHeader.Currency;
//    PYr        := FParentTXRec.TKTXHeader.AcYr;
//    PPr        := FParentTXRec.TKTXHeader.AcPr;
//    IDDocHed   := FParentTXRec.TKTXHeader.InvDocHed;
    {$IFDEF STK}
      LineType := StkLineType[SIN];
    {$ENDIF}
    Payment    := FALSE;
    CustCode   := FParentTXRec.TKTXHeader.CustCode;
    LineDate   := FParentTXRec.TKTXHeader.TransDate;
    CoRate     := FParentTXRec.TKTXHeader.CoRate;
    VATRate     := FParentTXRec.TKTXHeader.VATRate;
    MLocStk    := Full_MLocKey('');
    TransRefNo    := FParentTXRec.TKTXHeader.OurRef;
//    CurrTriR   := FParentTXRec.TKTXHeader.CurrTriR;
  End; // With FNotifyLine

End; // Create

//-------------------------------------------------------------------------

// Assigned an existing transaction line as the description line
Procedure TTTDNotificationLine.Assign (Const DescLine : TTXLineRec);
Begin // Assign
  If (Not FExistingLine) Then
  Begin
    FExistingLine := True;
    FNotifyLine := DescLine;
  End // If (Not FExistingLine)
  Else
    // More than one TTD/VBD Notification Line - PANIC!
//  If FParentCalculator.UIMode Then
//  Begin
      MessageDlg ('This transaction has more than one TTD/VBD Notification Line and should be manually corrected',
                  mtWarning, [mbOK], 0);
//  End; // If FParentCalculator.UIMode
End; // Assign

//-------------------------------------------------------------------------

// Updates the notification line description and updates the database
Procedure TTTDNotificationLine.Update (Const NewDesc : ShortString);
Var
  sKey : Str255;
  iStatus : SmallInt;
Begin // Update


  // Add additional TTD description line
  FNotifyLine.sDesc := NewDesc;
  FNotifyLine.TKStockRec.Desc[1] := NewDesc;
  FParentCalculator.CacheLine(FNotifyLine);// Add desc line
End; // Update

//=========================================================================

Constructor TTTDCalculatorLine.Create(Const ParentCalculator : TTTDCalculator; ParentTXRec : TTXRec; ParentListView : TListView; Const TXLineRec : TTXLineRec);
Begin // Create
  Inherited Create;

  FParentCalculator := ParentCalculator;
  FParentTXRec := ParentTXRec;
  FParentListView := ParentListView;

  // FOrigLine is the original line without changes
  FOrigLine := TXLineRec;

  // FBefore line is used for the Before TTD calculations only
  FBeforeLine := TXLineRec;
  FBeforeLine.rDiscount3 := 0;  // Remove Before TTD/VBD so it doesn't affect before figures

  // Recalc VAT to cater for inclusive/manual configurations
//  CalcVAT(FBeforeLine, FParentTrans.DiscSetl); {.299} - apparently not needed for TCM ?

  // FAfterLine is used for the After TTD calculations and contains the modified discount fields
  FAfterLine := TXLineRec;
End; // Create

//-------------------------------------------------------------------------

// Applies the specified percentage discount to the line and checks user permissions for
// selling below Cost Price.  Returns False if that user permission is enabled and the
// discount would break the rule.
Function TTTDCalculatorLine.ApplyPercentageDiscount (Const DiscValue : Real48) : Boolean;
Begin // ApplyPercentageDiscount
  Result := True;

  if FAfterLine.tktlrec.tltransvaluediscounttype = 255 then exit;

  FAfterLine.rDiscount3 := Pcnt(DiscValue);  // 10% = 0.1
  FAfterLine.cDiscount3 := PcntChr;
  if ZeroFloat(FAfterLine.rDiscount3)
  then FAfterLine.iDiscount3Type := 0 // no discount
  else FAfterLine.iDiscount3Type := Ord(FParentCalculator.DiscountMode);
  FParentCalculator.TTDType := PcntChr;

  FAfterLine.TKTLRec.tlTransValueDiscount := FAfterLine.rDiscount3;
  FAfterLine.TKTLRec.tlTransValueDiscountChr := FAfterLine.cDiscount3;
  FAfterLine.TKTLRec.tlTransValueDiscountType := FAfterLine.iDiscount3Type;

  // Recalc VAT to cater for inclusive/manual configurations
//  CalcVAT(FAfterLine, FParentTrans.DiscSetl);
//  RecalcLine(FAfterLine);
End; // ApplyPercentageDiscount

//-------------------------------------------------------------------------

// Applies the specified amount discount to the line and checks user permissions for
// selling below Cost Price and selling below 0.  Returns the amount that was actually
// allocated
Function TTTDCalculatorLine.ApplyAmountDiscount (Const DiscValue : Real48) : Real48;
Var
  DivQty : Double;
Begin // ApplyAmountDiscount
  If FAfterLine.TKTLRec.tlPriceByPack and (FAfterLine.TKTLRec.tlQtyPack <> 0.0) and (FAfterLine.TKTLRec.QtyMul <> 0.0) then
  Begin
    If FAfterLine.TKStockRec.StDPackQty Then
      DivQty := DivWChk(FAfterLine.TKTLRec.Qty, FAfterLine.TKTLRec.tlQtyPack)
    Else
      //DivQty := DivWChk(FAfterLine.TKTLRec.QtyMul, FAfterLine.TKTLRec.tlQtyPack);
      DivQty := Calc_IdQty(FAfterLine.TKTLRec.Qty, FAfterLine.TKTLRec.QtyMul
      , FAfterLine.TKStockRec.PriceByStkUnit);
  End // If FAfterLine.PrxPack and (FAfterLine.QtyPack <> 0.0) and (FAfterLine.QtyMul <> 0.0)
  Else
//    DivQty := FAfterLine.TKTLRec.Qty;
    DivQty := Calc_IdQty(FAfterLine.TKTLRec.Qty, FAfterLine.TKTLRec.QtyMul
    , FAfterLine.TKStockRec.PriceByStkUnit);

  // Need to divide DiscValue by qty to get individual unit discount amount
  FAfterLine.rDiscount3 := Round_Dn(SafeDiv(DiscValue, DivQty), 2);
  FAfterLine.cDiscount3 := #0;
  FAfterLine.iDiscount3Type := Ord(FParentCalculator.DiscountMode);
  FParentCalculator.TTDType := FAfterLine.cDiscount3;

  FAfterLine.TKTLRec.tlTransValueDiscount := FAfterLine.rDiscount3;
  FAfterLine.TKTLRec.tlTransValueDiscountChr := FAfterLine.cDiscount3;
  FAfterLine.TKTLRec.tlTransValueDiscountType := FAfterLine.iDiscount3Type;

  // Recalc VAT to cater for inclusive/manual configurations
//  CalcVAT(FAfterLine, FParentTrans.DiscSetl);
//  RecalcLine(FAfterLine);

  // Need to return total amount of TTD/VBD discount applied on this line
  //Result := Round_Up (FAfterLine.rDiscount3 * FAfterLine.TKTLRec.Qty, 2);
  Result := Round_Up (FAfterLine.rDiscount3 * DivQty, 2);
End; // ApplyAmountDiscount

//-------------------------------------------------------------------------

procedure TTTDCalculatorLine.RecalcLine(var TheTXLineRec : TTXLineRec);
var
  TXLineInfo : TTXLineInfo;
Begin
  TXLineInfo := TTXLineInfo.create(TheTXLineRec);
  TXLineInfo.RecalcLine(FParentTXRec, FALSE);
  TheTXLineRec := TXLineInfo.TXLineRec;
  TXLineInfo.Free;
end;

//-------------------------------------------------------------------------

Function TTTDCalculatorLine.GetLineTotals (Index : TTTDLineTotalsEnum) : Double;
Begin // GetLineTotals
  Case Index Of
//    ltBeforeNetTotal      : Result := Round_Up(InvLTotal (FBeforeLine, True, 0), 2);
//    ltAfterNetTotal       : Result := Round_Up(InvLTotal (FAfterLine, True, 0), 2);
//    ltAfterTotalCost      : Result := InvLCost(FAfterLine);  // Already rounded to cost decs
    ltBeforeNetTotal :
    begin
      CalcStockPrice(TXRec, FBeforeLine, FALSE);
//      Result := Round_Up(FBeforeLine.rLineNetTotal, 2);
      Result := Round_Up(FBeforeLine.rAdvDiscLineNetTotal, 2);
    end;

    ltAfterNetTotal :
    begin
      CalcStockPrice(TXRec, FAfterLine, FALSE);
//      Result := Round_Up(FAfterLine.rLineNetTotal, 2);
      Result := Round_Up(FAfterLine.rAdvDiscLineNetTotal, 2);
    end;

    ltAfterTotalCost :
    begin
      Result := Round_Up(FAfterLine.TKStockRec.CostPrice * WhatIsOne(FAfterLine.TKStockRec)
      * FAfterLine.TKTLRec.Qty, TKSysRec.CostDP)
    end;

    ltBeforeTotalCost :
    begin
      Result := Round_Up(FBeforeLine.TKStockRec.CostPrice * WhatIsOne(FBeforeLine.TKStockRec)
      * FBeforeLine.TKTLRec.Qty, TKSysRec.CostDP)
    end;
  Else
    Raise Exception.Create ('TTTDCalculatorLine.GetLineTotals: Unknown Index (' + IntToStr(Ord(Index)) + ')');
  End; // Case Index
End; // GetLineTotals

//=========================================================================

Constructor TTTDCalculator.Create(Const Adding : Boolean; TheTXRec : TTXRec; TheListView : TListView);

  Function Show_CMG : Boolean;
  Begin
    {* Place check here for show GP password *}
    Result := aAllowedTo[atSeeGP];
  end; {Func..}

Begin // Create
  Inherited Create;

  FDiscountMode := cdmTTD;

  FAdding := Adding;

  FLines := TObjectList.Create;
  FLines.OwnsObjects := True;

//  FTransaction := TTDTrans;
  FOrigTXRec := TheTXRec;
  FTXRec := TheTXRec;

  FListView := TListView.Create(nil);
  FListView.Visible := FALSE;
  FListView.Parent := TheListView.Parent;
  CopyListViewItems(TheListView.Items, FListView.Items);
  FActualLines := TheListView;
//  FListView := TheListView;

  FDescLine := TTTDNotificationLine.Create(Self, FTXRec, FListView);

  FTTDExists := False;
  FTTDDiscount := 0.0;
  FTTDDiscType := #0;

  FVBDExists := False;

  FAmountDiscountRequested := 0.0;
  FAmountDiscountApplied := 0.0;

  FDiscountDesc := '';

//FUIMode := True; // Display error messages as default

  // Check whether cost prices should be shown - depends on user permissions 
  FHideCost := Not Show_CMG;

//  FIsPurchase := (FTransaction.InvDocHed In PurchSplit);
  FIsPurchase := FALSE;

  LoadLines;
End; // Create

//------------------------------

Destructor TTTDCalculator.Destroy;
Begin // Destroy
  FDescLine.Free;
  FLines.Free;   // NOTE: TObjectList automatically destroys objects stored within it

  ClearList(FListView);
  FListView.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Applies the specified discount to the cached lines, if the percentage discount
// cannot be fully applied due to Cost Price rules then it will apply a value
// based discount instead.  Returns False if the discounted transaction breaks
// user permission based rules
Function TTTDCalculator.CalculateAD (DiscValue : Real48; DiscType : Char) : Boolean;
Var
  oLine : TTTDCalculatorLine;
  PcntFailed : Boolean;
  iLine : SmallInt;
  LineTotal, LinePortion, TotalToAllocate : Double;
Begin // CalculateAD
  Result := False;

  If (DiscType = PcntChr) Then
  Begin
    PcntFailed := False;
    FDiscountDesc := Format('%0.2f', [DiscValue]) + '%';

    // Calculate the amount of discount requested by the user at the transaction level
    FAmountDiscountRequested := Round_Up(Calc_PAmount (TransTotals[ttBeforeNetTotal], Pcnt(DiscValue), PcntChr), 2);

    // Percentage Discount - simply need to set the discount fields on the lines
    For iLine := 0 To Pred(FLines.Count) Do
    Begin
      // If the user cannot sell below cost price then it may not be possible to apply the
      // specified percentage discount.
      PcntFailed := Not TTTDCalculatorLine(FLines.Items[iLine]).ApplyPercentageDiscount (DiscValue);

      If PcntFailed Then
        Break;
    End; // For iLine

    If PcntFailed Then
    Begin
      // Percentage failed due to cost price limitations - convert to amount based discount
      DiscValue := Round_Up(Calc_PAmount (TransTotals[ttBeforeNetTotal], Pcnt(DiscValue), PcntChr), 2);
      DiscType := #0;
      FTTDDiscType := DiscType;
    End; // If PcntFailed

    FAmountDiscountApplied := FAmountDiscountRequested;
  End; // If (DiscType = PcntChr)

  If (DiscType = #0) Then
  Begin
    // Amount Discount
    FAmountDiscountRequested := DiscValue;

    // run through the lines to get a total of line values (incl line discount + multi-buy discount - not TTD/VBD)
    LineTotal := 0.0;
    For iLine := 0 To Pred(FLines.Count) Do
      LineTotal := LineTotal + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltBeforeNetTotal];

    // run through lines allocating discount according to proportion of line value to total value - need
    // to check user permission settings as not all of the discount amount may be allocatable to the line
    FAmountDiscountApplied := 0.0;
    TotalToAllocate := DiscValue;
    For iLine := 0 To (FLines.Count - 1) Do
    Begin
      oLine := TTTDCalculatorLine(FLines.Items[iLine]);

      If (iLine < (FLines.Count - 1)) Then
        // Not last line - calculate amount to apportion to this line as a fraction of the
        // original discount value
//        LinePortion := Round_Dn(SafeDiv(oLine.LineTotals[ltBeforeNetTotal], LineTotal) * DiscValue, 2){.301}
        LinePortion := SafeDiv(oLine.LineTotals[ltBeforeNetTotal], LineTotal) * DiscValue {.301}
      Else
        // Last line - allocate remainder
//        LinePortion := Round_Dn(TotalToAllocate, 2);
        LinePortion := TotalToAllocate;{.299}

      // Reduce the TotalToAllocate by the amount we planned to allocate before checks, otherwise
      // the stock items on later lines are unfairly penalised
      TotalToAllocate := TotalToAllocate - LinePortion;

      // Apply the discount amount to the line - the function returns the amount actually applied due
      // to changes due to rounding and user permissions limiting it to >= 0.0 or >= Cost Price
      LinePortion := oLine.ApplyAmountDiscount (LinePortion);

      // Keep track of how much discount was actually applied once limitations were applied
      FAmountDiscountApplied := FAmountDiscountApplied + LinePortion;
    End; // For iLine

    FDiscountDesc := Format('%0.2f', [FAmountDiscountApplied]);
  End; // If (DiscType = #0)

  // Check User Permissions - ignore for VBD as if they defined the discount they get it!
  If TRUE{(FTransaction.InvDocHed In SalesSplit)} And (FDiscountMode <> cdmVBD) Then
  Begin
    Result := True;

    // Check the user permission limiting transactions to >= 0
    // NOTE: Shouldn't ever happen as the TTD dialog should limit it to <= Net Value
    If (Not FAllowDiscountToExceedSale) And (TransTotals[ttAfterNetTotal] < 0) Then
    Begin
      // Transaction Value is negative - i.e. We are paying the customer to have the stuff!
      Result := False;
      MessageDlg ('The Discount Value is larger than the Invoice value', mtError, [mbOK], 0);
    End; // If (Not FParentCalculator.AllowDiscountToExceedSale) And (LineTotals[ltAfterNetTotal] < 0)

    // Check the user permission limiting transactions to >= Cost
    If Result And (Not FAllowSaleBelowCost) And (TransTotals[ttAfterNetTotal] < TransTotals[ttAfterTotalCost]) Then
    Begin
      // Transaction Value is below cost - i.e. We are making a loss
      Result := False;
      MessageDlg ('The Cost of this transaction is larger than the Invoice value', mtError, [mbOK], 0);
    End; // If (Not FParentCalculator.AllowSaleBelowCost)
  End // If (FTransaction.InvDocHed In SalesSplit)
  Else
    Result := True;
End; // CalculateAD

//-------------------------------------------------------------------------

// Updates the Transaction/Lines with the currently specified discount
Procedure TTTDCalculator.UpdateTransactionDiscounts (Const ApplyDiscounts : Boolean);
Var
  iDeleteLine, iInsertIndex, iLine, iStatus : integer;
  DescLineInfo : TTXLineInfo;
Begin // UpdateTransactionDiscounts

  // Run through lines updating them with the after discount lines
  iDeleteLine := -1;
  For iLine := 0 To Pred(FLines.Count) Do
  begin
//    TTTDCalculatorLine(FLines.Items[iLine]).UpdateLine; // should update parent trans

    // update line discount amount
{    TTXLineInfo(FActualLines.Items[iLine].Data).TXLineRec.rLineTransDiscount
    := ABS(Round_Up(TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltBeforeNetTotal]
    - TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltAfterNetTotal], 2));}

    TTXLineInfo(FActualLines.Items[iLine].Data).TXLineRec
    := TTTDCalculatorLine(FLines.Items[iLine]).FAfterLine;

    if TTXLineInfo(FActualLines.Items[iLine].Data).TXLineRec.bDiscountDescLine then iDeleteLine := iLine;
  end;{for}

  // Delete Discount Desc Line
  if iDeleteLine >= 0 then DeleteLines(FActualLines, iDeleteLine);

  // Remove TTD
  If ApplyDiscounts then
  begin
    FTXRec.rTTDAmount := 0;
    FTXRec.rVBDAmount := 0;
  end;{if}

  // Recalc
  RecalcAllTXLines(FTXRec, FActualLines, FALSE);
  case FDiscountMode of
    cdmTTD : FTXRec.rTTDAmount := ABS(Round_Up(TransTotals[ttAfterNetTotal] - TransTotals[ttBeforeNetTotal], 2));
    cdmVBD : FTXRec.rVBDAmount := ABS(Round_Up(TransTotals[ttAfterNetTotal] - TransTotals[ttBeforeNetTotal], 2));
  end;{case}
  if ZeroFloat(FTXRec.rTTDAmount) or (FTTDDiscType <> '%')
  then FTXRec.sTransDiscount := ''
  else FTXRec.sTransDiscount := FDiscountDesc;
//  RecalcTXTotals(FTXRec, FActualLines, TRUE);

  If ApplyDiscounts Then
  Begin
    // Create/Update TTD/VBD Notification line
    If (FDiscountMode = cdmTTD) Then
      FDescLine.Update (TTDDescHeader + FDiscountDesc + ' given')
    Else
      FDescLine.Update (VBDDescHeader + FDiscountDesc + ' given');

    // Add Desc line to listview
    iInsertIndex := FLines.Count-1;
    AddTXLine(FActualLines, TTTDCalculatorLine(FLines.Items[FLines.Count-1]).FAfterLine, FTXRec, iInsertIndex, 0); // Does recalc
    TTXLineInfo(FActualLines.Items[FActualLines.Items.Count-1].Data).TXLineRec.bDiscountDescLine := TRUE;
    TTXLineInfo(FActualLines.Items[FActualLines.Items.Count-1].Data).TXLineRec.TKTLRec.tlTransValueDiscountType := 255; // Denotes this as a TTD/VBD discount line

    FTTDExists := (FDiscountMode = cdmTTD);
    FVBDExists := (FDiscountMode = cdmVBD);
  End // If ApplyDiscounts
  Else
  Begin
    FTTDExists := False;
    FVBDExists := False;
    RecalcTXTotals(FTXRec, FActualLines, TRUE);
  End; // Else
End; // UpdateTransactionDiscounts

//------------------------------

// Updates the Transaction/Lines with the currently specified discount overwriting any pre-existing TTD/VBD
Procedure TTTDCalculator.ApplyTTD;
Begin // ApplyTTD
  UpdateTransactionDiscounts (True);
End; // ApplyTTD

//------------------------------

// Removes and pre-existing TTD/VBD and updates the Transaction/Lines
Procedure TTTDCalculator.RemoveTTD;
Begin // RemoveTTD
  CalculateAD (0.0, PcntChr);
  UpdateTransactionDiscounts (False);
End; // RemoveTTD

//-------------------------------------------------------------------------

// Adds a transaction line into the cache
Procedure TTTDCalculator.CacheLine (Const TXLineRec : TTXLineRec);
Begin // CacheLine
  FLines.Add (TTTDCalculatorLine.Create(Self, FTXRec, FListView, TXLineRec));
End; // CacheLine

//------------------------------

// Load the transaction lines into cache to work with
Procedure TTTDCalculator.LoadLines;
Var
  iLine, iStatus : SmallInt;
  sKey : Str255;
  TXLineRec : TTXLineRec;
  DivQty : Double;
Begin // LoadLines

  For iLine := 0 to FListView.Items.Count-1 do
  begin
    TXLineRec := ttxlineinfo(FListView.items[iLine].data).txlinerec;
    CacheLine(TXLineRec);

    // Check for existing TTD/VBD discounts - 0=Undefined, 1=TTD, 2=VBD, 255=Info Line
    If (TXLineRec.iDiscount3Type = 1) Then
    Begin
      // TTD
      FTTDExists := True;

      // NOTE: working on basis of lines having one disount type or another
      If (TXLineRec.cDiscount3 = PcntChr) Then
      Begin
        // Percentage Discount - record highest offer
        If (TXLineRec.rDiscount3 > FTTDDiscount) Then
        Begin
          FTTDDiscount := TXLineRec.rDiscount3;
          FTTDDiscType := TXLineRec.cDiscount3;
        End; // If (TXLineRec.Discount3 > FTTDDiscount)
      End // If (TXLineRec.Discount3 > FTTDDiscount)
      Else
      Begin
        // Amount Discount - accumulate for a total
        If TXLineRec.TKTLRec.tlPriceByPack and (TXLineRec.TKTLRec.tlQtyPack <> 0.0) and (TXLineRec.TKTLRec.QtyMul <> 0.0) then
        Begin
          If TXLineRec.TKStockRec.StDPackQty Then
            DivQty := DivWChk(TXLineRec.TKTLRec.Qty, TXLineRec.TKTLRec.tlQtyPack)
          Else
            //DivQty := DivWChk(TXLineRec.TKTLRec.QtyMul, TXLineRec.TKTLRec.tlQtyPack);
            DivQty := Calc_IdQty(TXLineRec.TKTLRec.Qty, TXLineRec.TKTLRec.QtyMul
            , TXLineRec.TKStockRec.PriceByStkUnit);
        End // If Id.PrxPack and (Id.QtyPack <> 0.0) and (Id.QtyMul <> 0.0)
        Else
//                DivQty := TXLineRec.TKTLRec.Qty;
          DivQty := Calc_IdQty(TXLineRec.TKTLRec.Qty, TXLineRec.TKTLRec.QtyMul
          , TXLineRec.TKStockRec.PriceByStkUnit);

        FTTDDiscount := FTTDDiscount + (TXLineRec.rDiscount3 * DivQty);
        FTTDDiscType := TXLineRec.cDiscount3;

      End; // Else
    End // If (Not FTTDExists) And (TXLineRec.Discount3Type = 1)
    Else If (TXLineRec.iDiscount3Type = 2) Then
    Begin
      // VBD - no UI so don't bother recording existing discount - new discount automatically
      // applied based on discounts specified against Customer/Supplier
      FVBDExists := True;
    End // If (Not FTTDExists) And (TXLineRec.Discount3Type = 1)
  end;{for}
End; // LoadLines

//-------------------------------------------------------------------------

// Returns True if the specified Percentage Discount is within the valid range
Function TTTDCalculator.ValidPercentageDiscount (Const PercValue : Double) : Boolean;
Begin // ValidPercentageDiscount
  Result := (PercValue >= 0) And (PercValue <= 100);
End; // ValidPercentageDiscount

//------------------------------

// Returns True if the specified Discount Value is within the valid range
{Function TTTDCalculator.ValidValueDiscount (Const DiscAmount : Double) : Boolean;
Begin // ValidValueDiscount
  Result := (DiscAmount >= 0) And (DiscAmount <= TransTotals[ttBeforeNetTotal]);
End; // ValidValueDiscount
}
Function TTTDCalculator.ValidValueDiscount (Const DiscAmount : Double) : Boolean;
Var
  BeforeTot : Double;
Begin // ValidValueDiscount
  // MH 17/06/2009: Modified check to handle -ve SIN's
  //Result := (DiscAmount >= 0) And (DiscAmount <= TransTotals[ttBeforeNetTotal]);

  BeforeTot := TransTotals[ttBeforeNetTotal];
  If (BeforeTot < 0) Then
    Result := (DiscAmount <= 0) And (DiscAmount >= BeforeTot)
  Else
    Result := (DiscAmount >= 0) And (DiscAmount <= BeforeTot);
End; // ValidValueDiscount

//-------------------------------------------------------------------------

Function TTTDCalculator.GetOurRef : ShortString;
Begin // GetOurRef
  Result := FTXRec.TKTXHeader.OurRef;
End; // GetOurRef

//------------------------------

Function TTTDCalculator.GetTransTotals (Index : TTTDTotalsEnum) : Double;
Var
  iLine : integer;
  rLineCost : double;
  TXLineRec : TTXLineRec;
Begin // GetTransTotals
  Case Index Of
//    ttBeforeTotalCost     : Result := FTransaction.TotalCost;
    ttBeforeTotalCost :
    begin
      Result := 0.0;
      For iLine := 0 To Pred(FLines.Count) Do
      Begin
        Result := Result + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltBeforeTotalCost];
      End; // For iLine
    end;

    ttBeforeNetTotal :
    Begin
      Result := 0.0;
      For iLine := 0 To Pred(FLines.Count) Do
      Begin
        Result := Result + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltBeforeNetTotal];
      End; // For iLine
    End; // Begin

    ttBeforeNetLessSettle :
    Begin
      Result := GetTransTotals(ttBeforeNetTotal);
//      Result := Result - Calc_PAmount(Result, FTransaction.DiscSetl, PcntChr);
      Result := Result - Calc_PAmount(Result, TXRec.TKTXHeader.DiscSetl, PcntChr);
    End; // ttBeforeNetLessSettle

    ttAfterTotalCost :
    begin
      Result := GetTransTotals (ttBeforeTotalCost);
    end;

    ttAfterNetTotal :
    Begin
      Result := 0.0;
      For iLine := 0 To Pred(FLines.Count) Do
      Begin
        Result := Result + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltAfterNetTotal];
      End; // For iLine
    End; // Begin

    ttAfterNetLessSettle  :
    Begin
      Result := GetTransTotals (ttAfterNetTotal);
      Result := Result - Calc_PAmount(Result, TXRec.TKTXHeader.DiscSetl, PcntChr);
    End; // ttBeforeNetLessSettle
  Else
    Raise Exception.Create ('TTTDCalculator.GetTransTotals: Unknown Index (' + IntToStr(Ord(Index)) + ')');
  End; // Case Index
End; // GetTransTotals

//=========================================================================

end.

