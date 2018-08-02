unit TTDCalc;

{$If not (Defined(SOP) or Defined(COMTK))}
  This unit should not be compiling into this application/dll
{$IfEnd}

interface

uses
  Windows, SysUtils, Classes, Contnrs, Dialogs, StrUtils, Math, GlobVar, VarConst, VarRec2U;

{$I DEFOVR.Inc}

const
  TTDDescHeader = 'Transaction Total Discount of ';
  VBDDescHeader = 'Value Based Discount of ';

type
  pInvRec = ^InvRec;

  //------------------------------

  TCalculatorDiscountMode = (cdmTTD=1, cdmVBD=2);  // ordinal values need to match up to TTD/VBD values in Discount3Type
  TTTDLineTotalsEnum = (ltBeforeNetTotal, ltAfterNetTotal, ltAfterTotalCost, ltBeforeVAT, ltAfterVAT);
  TTTDTotalsEnum = (ttBeforeTotalCost, ttBeforeNetTotal, ttBeforeNetLessSettle, ttAfterTotalCost, ttAfterNetTotal, ttAfterNetLessSettle,
                    ttBeforeVATTotal, ttAfterVATTotal);

  //------------------------------

  TTTDCalculator = Class;

  //------------------------------

  TTTDNotificationLine = Class(TObject)
  Private
    FParentCalculator : TTTDCalculator;
    FParentTrans : pInvRec;
    FNotifyLine : IDetail;
    FExistingLine : Boolean;

    Procedure InitNewLine;
  Public
    Constructor Create (Const ParentCalculator : TTTDCalculator; Const ParentTrans : pInvRec);
    // Assigned an existing transaction line as the description line
    Procedure Assign (Const DescLine : IDetail);
    // Deletes any pre-existing TTD/VBD Notification Line
    Procedure Delete;
    // Updates the notification line description and updates the database
    Procedure Update (Const NewDesc : ShortString);
  End; // TTTDNotificationLine

  //------------------------------

  TTTDCalculatorLine = Class(TObject)
  Private
    FParentCalculator : TTTDCalculator;
    FParentTrans : pInvRec;
    FBeforeLine : IDetail;
    FAfterLine : IDetail;
    FOrigLine : IDetail;

    Function GetLineTotals (Index : TTTDLineTotalsEnum) : Double;

    // Updates the Cost/Sales price on any linked Serial/Batch records
    Procedure UpdateSerialBatch;
    // Updates commitment accounting (or sumfink) - copied from TxLineU
    procedure Update_LiveCommit(IdR : IDetail; DedMode : SmallInt);
    // Update price on linked Multi-Bins
    procedure UpdateMultiBins;
  Public
    Property LineTotals [Index : TTTDLineTotalsEnum] : Double Read GetLineTotals;

    Constructor Create (Const ParentCalculator : TTTDCalculator; Const ParentTrans : pInvRec; Const LineRec : IDetail);

    // Applies the specified percentage discount to the line and checks user permissions for
    // selling below Cost Price.  Returns False if that user permission is enabled and the
    // discount would break the rule.
    Function ApplyPercentageDiscount (Const DiscValue : Real48) : Boolean;

    // Applies the specified amount discount to the line and checks user permissions for
    // selling below Cost Price and selling below 0.  Returns the amount that was actually
    // allocated
    Function ApplyAmountDiscount (Const DiscValue : Real48) : Real48;

    Procedure UpdateLine;
  End; // TTTDCalculatorLine

  //------------------------------

  TTTDCalculator = Class(TObject)
  Private
    FDiscountMode : TCalculatorDiscountMode;

    FTransaction : pInvRec;
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
    FUIMode : Boolean;

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

    // Updates the Transaction/Lines with the currently specified discount
    Procedure UpdateTransactionDiscounts (Const ApplyDiscounts : Boolean);
  Protected
    //PR: 10/07/2009 Moved CacheLine & LoadLines from Private to Protected to allow a descendant to use them (+ made LoadLines virtual)
    // Adds a transaction line into the cache
    Procedure CacheLine (Const TheLine : IDetail);

    // Load the transaction lines into cache to work with
    Procedure LoadLines; virtual;
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
    Property TTDType : Char Read FTTDDiscType;
    Property TTDValue : Real48 Read FTTDDiscount;
    Property UIMode : Boolean Read FUIMode Write FUIMode;
    Property VBDExists : Boolean Read FVBDExists;
    //PR: 10/07/2009 Extended Parameter List under COMTK definition to allow descendant to create without loading list
    Constructor Create (Const Adding : Boolean; Const TTDTrans : pInvRec{$IFDEF COMTK}; DoLoad : Boolean = TRUE{$ENDIF});
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
  End; // TTTDCalculator

  //------------------------------

implementation

Uses BtrvU2, BTKeys1U, BTSupU1, ComnUnit, Comnu2,  MiscU, SavePos, ETMiscU, InvFSu3u
    {$IFNDEF EBAD}
      ,CuStkA3U,
      InvCtSuU
     {$IFDEF POST}
       {$IFNDEF EBAD}
       ,PostingU
       {$ENDIF}
     {$ENDIF}

     ,InvLst2U;
     {$ELSE}
     ;
     {$ENDIF}

//=========================================================================

Constructor TTTDNotificationLine.Create (Const ParentCalculator : TTTDCalculator; Const ParentTrans : pInvRec);
Begin // Create
  Inherited Create;

  FParentCalculator := ParentCalculator;
  FParentTrans := ParentTrans;

  InitNewLine;
End; // Create

//-------------------------------------------------------------------------

Procedure TTTDNotificationLine.InitNewLine;
Begin // InitNewLine
  FExistingLine := False;
  FillChar(FNotifyLine, SizeOf(FNotifyLine), #0);
  With FNotifyLine Do
  Begin
    FolioRef   := FParentTrans.FolioNum;
    //LineNo     := FParentTrans.ILineCount;
    Currency   := FParentTrans.Currency;
    PYr        := FParentTrans.AcYr;
    PPr        := FParentTrans.AcPr;
    //ABSLineNo  := LineNo;
    IDDocHed   := FParentTrans.InvDocHed;
    {$IFDEF STK}
      LineType := StkLineType[IdDocHed];
    {$ENDIF}
    Payment    := DocPayType[IdDocHed];
    CustCode   := FParentTrans.CustCode;
    PDate      := FParentTrans.TransDate;
    //Desc       := TTDDescHeader + {? +} ' given';
    CXRate     := FParentTrans.CXRate;
    MLocStk    := Full_MLocKey('');
    DocPRef    := FParentTrans.OurRef;
    CurrTriR   := FParentTrans.CurrTriR;
  End; // With FNotifyLine
End; // InitNewLine

//-------------------------------------------------------------------------

// Assigned an existing transaction line as the description line
Procedure TTTDNotificationLine.Assign (Const DescLine : IDetail);
Begin // Assign
  If (Not FExistingLine) Then
  Begin
    FExistingLine := True;
    FNotifyLine := DescLine;
  End // If (Not FExistingLine)
  Else
    // More than one TTD/VBD Notification Line - PANIC!
    If FParentCalculator.UIMode Then
    Begin
      MessageDlg ('This transaction has more than one TTD/VBD Notification Line and should be manually corrected',
                  mtWarning, [mbOK], 0);
    End; // If FParentCalculator.UIMode
End; // Assign

//-------------------------------------------------------------------------

// Deletes any pre-existing TTD/VBD Notification Line
Procedure TTTDNotificationLine.Delete;
Var
  sKey : Str255;
  iStatus : SmallInt;
Begin // Delete
  If FExistingLine Then
  Begin
    // Add additional TTD description line
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (IDetailF, GetPosKey);
        SaveDataBlock (@Id, SizeOf(Id));

        //------------------------------

        sKey := FullNomKey (FNotifyLine.FolioRef) + FullNomKey(FNotifyLine.LineNo);
        iStatus := Find_Rec(B_GetEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
        If (iStatus = 0) And (Id.FolioRef = FNotifyLine.FolioRef) And (Id.LineNo = FNotifyLine.LineNo) Then
        Begin
          iStatus := Delete_Rec (F[IDetailF], IDetailF, IdFolioK);
          If (iStatus = 0) Then
            // MH 31/07/2009: Added reset of details after line deletion as if the TTD Calculator is kept
            // in existence then it was causing error 4's when removing TTD to apply VBD after the account
            // code was changed. 
            InitNewLine
          Else
            Report_BError (IDetailF, iStatus);
        End // If (iStatus = 0) And (Id.FolioRef = FNotifyLine.FolioRef) And (Id.LineNo = FNotifyLine.LineNo)
        Else
          If FParentCalculator.UIMode Then
          Begin
            MessageDlg ('The existing TTD/VBD Notification Line could not be loaded - please manually ' +
                        'delete the line', mtWarning, [mbOK], 0);
          End; // If FParentCalculator.UIMode

        //------------------------------

        // Restore position in file
        RestoreDataBlock (@Id);
        RestoreSavedPosition;
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create
  End; // If FExistingLine
End; // Delete

//-------------------------------------------------------------------------

// Updates the notification line description and updates the database
Procedure TTTDNotificationLine.Update (Const NewDesc : ShortString);
Var
  sKey : Str255;
  iStatus : SmallInt;
Begin // Update
  // Add additional TTD description line
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (IDetailF, GetPosKey);
      SaveDataBlock (@Id, SizeOf(Id));

      //------------------------------

      If FExistingLine Then
      Begin
        sKey := FullNomKey (FNotifyLine.FolioRef) + FullNomKey(FNotifyLine.LineNo);
        iStatus := Find_Rec(B_GetEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
        If (iStatus = 0) And (Id.FolioRef = FNotifyLine.FolioRef) And (Id.LineNo = FNotifyLine.LineNo) Then
        Begin
          Id.Desc := NewDesc;
          Id.Discount3Type := 255;  // Advanced Discounts Information Line
          iStatus := Put_Rec (F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);
        End // If (iStatus = 0) And (Id.FolioRef = FNotifyLine.FolioRef) And (Id.LineNo = FNotifyLine.LineNo)
        Else
          If FParentCalculator.UIMode Then
          Begin
            MessageDlg ('The existing TTD/VBD Notification Line could not be loaded - please manually ' +
                        'edit the line and correct the discount value', mtWarning, [mbOK], 0);
          End; // If FParentCalculator.UIMode
      End // If FExistingLine; // If FExistingLine
      Else
      Begin
        Id := FNotifyLine;
        Id.LineNo := FParentTrans.ILineCount;
        Id.ABSLineNo := Id.LineNo;
        Id.Desc := NewDesc;
        Id.Discount3Type := 255;  // Advanced Discounts Information Line
        Inc(FParentTrans.ILineCount);
        iStatus := Add_Rec (F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);
      End; // Else

      If (iStatus <> 0) Then
        Report_BError (IDetailF, iStatus);

      //------------------------------

      // Restore position in file
      RestoreDataBlock (@Id);
      RestoreSavedPosition;
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // Update

//=========================================================================

Constructor TTTDCalculatorLine.Create (Const ParentCalculator : TTTDCalculator; Const ParentTrans : pInvRec; Const LineRec : IDetail);
Begin // Create
  Inherited Create;

  FParentCalculator := ParentCalculator;
  FParentTrans := ParentTrans;

  // FOrigLine is the original line without changes
  FOrigLine := LineRec;

  // FBefore line is used for the Before TTD calculations only
  FBeforeLine := LineRec;
  FBeforeLine.Discount3 := 0;  // Remove Before TTD/VBD so it doesn't affect before figures

  // Recalc VAT to cater for inclusive/manual configurations
  CalcVAT(FBeforeLine, FParentTrans.DiscSetl);

  // FAfterLine is used for the After TTD calculations and contains the modified discount fields
  FAfterLine := LineRec;
End; // Create

//-------------------------------------------------------------------------

// Applies the specified percentage discount to the line and checks user permissions for
// selling below Cost Price.  Returns False if that user permission is enabled and the
// discount would break the rule.
Function TTTDCalculatorLine.ApplyPercentageDiscount (Const DiscValue : Real48) : Boolean;
Begin // ApplyPercentageDiscount
  FAfterLine.Discount3 := Pcnt(DiscValue);  // 10% = 0.1
  FAfterLine.Discount3Chr := PcntChr;

  // Recalc VAT to cater for inclusive/manual configurations
  CalcVAT(FAfterLine, FParentTrans.DiscSetl);

  (**** MH 08/04/2009: Redesigned to check cost at a transaction level
  // For Sales only check the user permission limiting transactions to >= Cost unless the
  // TTD/VBD override is specified in System Setup
  If (FParentTrans.InvDocHed In SalesSplit) And (Not FParentCalculator.AllowSaleBelowCost) Then
  Begin
    // Sales Transaction - check Sales Price >= Cost Price
    Result := (LineTotals[ltAfterNetTotal] >= LineTotals[ltAfterTotalCost]);

    If (Not Result) Then
      // Remove discount
      FAfterLine.Discount3 := 0
  End // If (FParentTrans.InvDocHed In SalesSplit) And (Not FParentCalculator.AllowSaleBelowCost)
  Else
  ****)
    Result := True;
End; // ApplyPercentageDiscount

//-------------------------------------------------------------------------

// Applies the specified amount discount to the line and checks user permissions for
// selling below Cost Price and selling below 0.  Returns the amount that was actually
// allocated
Function TTTDCalculatorLine.ApplyAmountDiscount (Const DiscValue : Real48) : Real48;
Var
  DivQty : Double;
Begin // ApplyAmountDiscount
  If FAfterLine.PrxPack and (FAfterLine.QtyPack <> 0.0) and (FAfterLine.QtyMul <> 0.0) then
  Begin
    If FAfterLine.ShowCase Then
      DivQty := DivWChk(FAfterLine.Qty, FAfterLine.QtyPack)
    Else
      //DivQty := DivWChk(FAfterLine.QtyMul, FAfterLine.QtyPack);
      DivQty := Calc_IdQty(FAfterLine.Qty, FAfterLine.QtyMul, FAfterLine.UsePack);
  End // If FAfterLine.PrxPack and (FAfterLine.QtyPack <> 0.0) and (FAfterLine.QtyMul <> 0.0)
  Else
    //DivQty := FAfterLine.Qty;
    DivQty := Calc_IdQty(FAfterLine.Qty, FAfterLine.QtyMul, FAfterLine.UsePack);

  // Need to divide DiscValue by qty to get individual unit discount amount
  //FAfterLine.Discount3 := Round_Dn(DiscValue / FAfterLine.Qty, 2);
  FAfterLine.Discount3 := Round_Dn(DiscValue / DivQty, 2);
  FAfterLine.Discount3Chr := #0;

  // Recalc VAT to cater for inclusive/manual configurations
  CalcVAT(FAfterLine, FParentTrans.DiscSetl);

  (**** MH 08/04/2009: Redesigned to check cost/negative at a transaction level
  If (FParentTrans.InvDocHed In SalesSplit) Then
  Begin
    // Check the user permission limiting transactions to >= 0 unless the TTD/VBD override
    // is specified in System Setup
    If (Not FParentCalculator.AllowDiscountToExceedSale) And (LineTotals[ltAfterNetTotal] < 0) Then
    Begin
      // Set Discount amount to line total including line discount and multi-buy discount
      FAfterLine.Discount3 := 0;
      FAfterLine.Discount3 := Round_Dn(FAfterLine.NetValue - Calc_PAmountAD(FAfterLine.NetValue,
                                                                            FAfterLine.Discount, FAfterLine.DiscountChr,    // Line Discount
                                                                            FAfterLine.Discount2, FAfterLine.Discount2Chr,  // MultiBuy Discount
                                                                            0, PcntChr), 2);
    End; // If (Not FParentCalculator.AllowDiscountToExceedSale) And (LineTotals[ltAfterNetTotal] < 0)

    // Check the user permission limiting transactions to >= Cost unless the TTD/VBD override
    // is specified in System Setup
    If (Not FParentCalculator.AllowSaleBelowCost) And (LineTotals[ltAfterNetTotal] < LineTotals[ltAfterTotalCost]) Then
    Begin
      // Set discount so that line total = line cost
      FAfterLine.Discount3 := 0;
      FAfterLine.Discount3 := Round_Dn(FAfterLine.NetValue - Calc_PAmountAD(FAfterLine.NetValue,
                                                                            FAfterLine.Discount, FAfterLine.DiscountChr,    // Line Discount
                                                                            FAfterLine.Discount2, FAfterLine.Discount2Chr,  // MultiBuy Discount
                                                                            0, PcntChr)
                                                           - FAfterLine.CostPrice, 2);
    End; // If (Not FParentCalculator.AllowSaleBelowCost)
  End; // If (FParentTrans.InvDocHed In SalesSplit)
  ****)

  // Need to return total amount of TTD/VBD discount applied on this line
  //Result := Round_Up (FAfterLine.Discount3 * FAfterLine.Qty, 2);
  Result := Round_Up (FAfterLine.Discount3 * DivQty, 2);
End; // ApplyAmountDiscount

//-------------------------------------------------------------------------

Procedure TTTDCalculatorLine.UpdateSerialBatch;
Var
  oStockPos, oMiscPos : TBtrieveSavePosition;
  LinePrice, SerCount, DiscP : Double;
  iStatus : SmallInt;
  KeyS, KeyChk : Str255;
  bFound, bFoundAll, bNeedUpdate, bOK, bLocked : Boolean;
  LAddr : LongInt;
Begin // UpdateSerialBatch
  bNeedUpdate := False;
  // Save the current position in the file for the current key
  oStockPos := TBtrieveSavePosition.Create;
  oStockPos.SaveFilePosition (StockF, GetPosKey);
  oStockPos.SaveDataBlock (@Stock, SizeOf(Stock));

  oMiscPos := TBtrieveSavePosition.Create;
  oMiscPos.SaveFilePosition (MiscF, GetPosKey);
  oMiscPos.SaveDataBlock (MiscRecs, SizeOf(MiscRecs^));

  Try
    // Load stock record as we need the folio number
    KeyS := FullStockCode(FAfterLine.StockCode);
    iStatus := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
    If (iStatus = 0) Then
    Begin
      SerCount := 0.0;
      bFoundAll := (SerCount >= Abs(FAfterLine.SerialQty));

      // Determine starting searchkey based on whether we want to include purchase serial numbers
      If (FParentTrans.InvDocHed In PurchSplit) Then
      Begin
        KeyChk := FullQDKey (MFIFOCode, MSERNSub, FullNomKey(Stock.StockFolio));

        With FAfterLine Do
        Begin
          DiscP := Calc_PAmountAD (Round_Up(NetValue,Syss.NoCosDec),
                                   Discount, DiscountChr,
                                   Discount2, Discount2Chr,
                                   Discount3, Discount3Chr);

          // For purchases also include Uplift (CostPrice)
          If (ShowCase) then
            LinePrice := Round_Up(Calc_StkCP((NetValue-DiscP),QtyPack,UsePack)+CostPrice,Syss.NoCosDec)
          else
            LinePrice := Round_Up(Calc_StkCP((NetValue-DiscP+CostPrice),QtyMul,UsePack),Syss.NoCosDec);
        End; // With FAfterLine
      End // If (FParentTrans.InvDocHed In PurchSplit)
      Else
      Begin
        KeyChk := FullQDKey (MFIFOCode, MSERNSub, FullNomKey(Stock.StockFolio)+#1);

        With FAfterLine Do
          LinePrice := Round_Up(NetValue - Calc_PAmountAD(NetValue, Discount, DiscountChr, Discount2, Discount2Chr, Discount3, Discount3Chr),
                                Syss.NoNetDec);
      End; // Else

      KeyS := KeyChk + NdxWeight;

      iStatus := Find_Rec(B_GetLessEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
      While (iStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And (Not bFoundAll) Do
      Begin
        With MiscRecs^.SerialRec Do
        Begin
          If (FParentTrans.InvDocHed In PurchSplit) Then
          Begin
            // Purchase
            bFound := (CheckKey (FParentTrans.OurRef, InDoc, Length(FParentTrans.OurRef), BOff) and (BuyLine = FAfterLine.ABSLineNo))
                      Or
                      (CheckKey (FParentTrans.OurRef, InOrdDoc, Length(FParentTrans.OurRef), BOff) and (InOrdLine = FAfterLine.ABSLineNo));

            If bFound Then
              // Got Serial/Batch relating to this line - only update Serial/Batch that haven't been sold where the price has changed
              bNeedUpdate := ((Not BatchChild) or (Not Sold)) And (SerCost <> LinePrice);
          End // If (FParentTrans.InvDocHed In PurchSplit)
          Else
          Begin
            // Sales
            bFound := (CheckKey (FParentTrans.OurRef, OutDoc, Length(FParentTrans.OurRef), BOff) and (SoldLine = FAfterLine.ABSLineNo))
                      Or
                      (CheckKey (FParentTrans.OurRef, OutOrdDoc, Length(FParentTrans.OurRef), BOff) and (OutOrdLine = FAfterLine.ABSLineNo));

            If bFound Then
              // Got Serial/Batch relating to this line - update everything where the price has changed
              bNeedUpdate := (SerSell <> LinePrice);
          End; // Else

          If bFound Then
          Begin
            // Update SerCount so we can drop out of the search as soon as possible
            If (Not BatchChild) Or (FAfterLine.IdDocHed In SalesSplit) Then
            Begin
              If BatchRec Then
              Begin
                If BatchChild Then
                  SerCount:= SerCount + QtyUsed
                Else
                  SerCount:= SerCount + BuyQty;
              End // If BatchRec
              Else
                SerCount := SerCount + 1.0;
            End; // If (Not BatchChild) Or (FId.IdDocHed In SalesSplit)

            //------------------------------

            If bNeedUpdate Then
            Begin
              // Get & Lock
              GetPos (F[MiscF], MiscF, LAddr);
              bOk := GetMultiRecAddr(B_GetDirect, B_MultLock, KeyS, MIK, MiscF, BOn, bLocked, LAddr);
              If bOk and bLocked then
              Begin
                // Update price
                If (FAfterLine.IdDocHed In SalesSplit) Then
                  MiscRecs^.SerialRec.SerSell := LinePrice
                Else
                  MiscRecs^.SerialRec.SerCost := LinePrice;

                // Update DB
                iStatus := Put_Rec(F[MiscF], MiscF, RecPtr[MiscF]^, MIK);
                Report_BError (MiscF, iStatus);

                // Using Multi-Locks so always need to unlock records
                iStatus := UnLockMultiSing(F[MiscF], MiscF, LAddr);
              End // If bOk and bLocked
              Else If FParentCalculator.UIMode Then
                MessageDlg ('Failed to update price for ' +
                            IfThen (Trim(MiscRecs^.SerialRec.BatchNo) = '', 'Serial Number ' + Trim(MiscRecs^.SerialRec.SerialNo), 'Batch Number ' + Trim(MiscRecs^.SerialRec.BatchNo)),
                            mtError, [mbOK], 0);
            End; // If bNeedUpdate
          End; // If bFound
        End; // With MiscRecs^.SerialRec

        bFoundAll := (SerCount >= Abs(FAfterLine.SerialQty));

        If (Not bFoundAll) then
          iStatus := Find_Rec(B_GetPrev, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
      End; // While (lStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And (Not FoundAll)
    End; // If (iStatus = 0)
  Finally
    // Restore position in file
    oStockPos.RestoreDataBlock (@Stock);
    oStockPos.RestoreSavedPosition;
    oStockPos.Free;

    oMiscPos.RestoreDataBlock (MiscRecs);
    oMiscPos.RestoreSavedPosition;
    oMiscPos.Free;
  End; // Try..Finally
End; // UpdateSerialBatch

//------------------------------

// Update price on linked Multi-Bins
procedure TTTDCalculatorLine.UpdateMultiBins;
Var
  oStockPos, oMLocPos : TBtrieveSavePosition;
  LinePrice, BinCount : Double;
  iStatus : SmallInt;
  KeyS, KeyChk : Str255;
  bFound, bFoundAll, bNeedUpdate, bOK, bLocked : Boolean;
  LAddr : LongInt;
Begin // UpdateMultiBins
   bNeedUpdate := False;
 // Save the current position in the file for the current key
  oStockPos := TBtrieveSavePosition.Create;
  oStockPos.SaveFilePosition (StockF, GetPosKey);
  oStockPos.SaveDataBlock (@Stock, SizeOf(Stock));

  oMLocPos := TBtrieveSavePosition.Create;
  oMLocPos.SaveFilePosition (MLocF, GetPosKey);
  oMLocPos.SaveDataBlock (MLocCtrl, SizeOf(MLocCtrl^));

  Try
    // Load stock record as we need the folio number
    KeyS := FullStockCode(FAfterLine.StockCode);
    iStatus := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
    If (iStatus = 0) Then
    Begin
      BinCount := 0.0;
      bFoundAll := (BinCount >= Abs(FAfterLine.BinQty));

      With FAfterLine Do
        LinePrice := Round_Up(NetValue - Calc_PAmountAD(NetValue, Discount, DiscountChr, Discount2, Discount2Chr, Discount3, Discount3Chr),
                              IfThen(FParentTrans.InvDocHed In PurchSplit, Syss.NoCOSDec, Syss.NoNetDec));

      // Determine starting searchkey based on whether we want to include purchase serial numbers
      If (FParentTrans.InvDocHed In PurchSplit) Then
        KeyChk := FullQDKey (BRRecCode,MSERNSub, FullNomKey(Stock.StockFolio))
      Else
        KeyChk := FullQDKey (BRRecCode,MSERNSub, FullNomKey(Stock.StockFolio)+#1);

      KeyS := KeyChk + NdxWeight;

      iStatus := Find_Rec(B_GetLessEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK, KeyS);
      While (iStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And (Not bFoundAll) Do
      Begin
        With MLocCtrl^.brBinRec Do
        Begin
          If (FParentTrans.InvDocHed In PurchSplit) Then
          Begin
            // Purchase
            bFound := (CheckKey (FParentTrans.OurRef, brInDoc, Length(FParentTrans.OurRef), BOff) and (brBuyLine = FAfterLine.ABSLineNo))
                      Or
                      (CheckKey (FParentTrans.OurRef, brInOrdDoc, Length(FParentTrans.OurRef), BOff) and (brInOrdLine = FAfterLine.ABSLineNo));

            If bFound Then
              // Got Serial/Batch relating to this line - only update Serial/Batch that haven't been sold where the price has changed
              bNeedUpdate := ((Not brBatchChild) or (Not brSold)) And (brBinCost <> LinePrice);
          End // If (FParentTrans.InvDocHed In PurchSplit)
          Else
          Begin
            // Sales
            bFound := (CheckKey (FParentTrans.OurRef, brOutDoc, Length(FParentTrans.OurRef), BOff) and (brSoldLine = FAfterLine.ABSLineNo))
                      Or
                      (CheckKey (FParentTrans.OurRef, brOutOrdDoc, Length(FParentTrans.OurRef), BOff) and (brOutOrdLine = FAfterLine.ABSLineNo));

            If bFound Then
              // Got Serial/Batch relating to this line - update everything where the price has changed
              bNeedUpdate := (brBinSell <> LinePrice);
          End; // Else

          If bFound Then
          Begin
            // Update BinCount so we can drop out of the search as soon as possible
            If (Not brBatchChild) Or (FAfterLine.IdDocHed In SalesSplit) Then
            Begin
              If brBatchRec Then
              Begin
                If brBatchChild Then
                  BinCount:= BinCount + brQtyUsed
                Else
                  BinCount:= BinCount + brBuyQty;
              End // If brBatchRec
              Else
                BinCount := BinCount + 1.0;
            End; // If (Not brBatchChild) Or (FAfterLine.IdDocHed In SalesSplit)

            //------------------------------

            If bNeedUpdate Then
            Begin
              // Get & Lock
              GetPos (F[MLocF], MLocF, LAddr);
              bOk := GetMultiRecAddr(B_GetDirect, B_MultLock, KeyS, MLSecK, MLocF, BOn, bLocked, LAddr);
              If bOk and bLocked then
              Begin
                // Update price
                If (FAfterLine.IdDocHed In SalesSplit) Then
                  MLocCtrl^.brBinRec.brBinSell := LinePrice
                Else
                  MLocCtrl^.brBinRec.brBinCost := LinePrice;

                // Update DB
                iStatus := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK);
                Report_BError (MLocF, iStatus);

                // Using Multi-Locks so always need to unlock records
                iStatus := UnLockMultiSing(F[MLocF], MLocF, LAddr);
              End // If bOk and bLocked
              Else If FParentCalculator.UIMode Then
                MessageDlg ('Failed to update price for Bin ' + Trim(brBinCode1), mtError, [mbOK], 0);
            End; // If bNeedUpdate
          End; // If bFound
        End; // With MLocCtrl^.brBinRec

        bFoundAll := (BinCount >= Abs(FAfterLine.BinQty));

        If (Not bFoundAll) then
          iStatus := Find_Rec(B_GetPrev, F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK, KeyS);
      End; // While (lStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) And (Not FoundAll)
    End; // If (iStatus = 0)
  Finally
    // Restore position in file
    oStockPos.RestoreDataBlock (@Stock);
    oStockPos.RestoreSavedPosition;
    oStockPos.Free;

    oMLocPos.RestoreDataBlock (MLocCtrl);
    oMLocPos.RestoreSavedPosition;
    oMLocPos.Free;
  End; // Try..Finally
End; // UpdateMultiBins

//------------------------------

// Updates commitment accounting (or sumfink) - copied from TxLineU
procedure TTTDCalculatorLine.Update_LiveCommit(IdR : IDetail; DedMode : SmallInt);
{$IFDEF POST}
{$IFNDEF EBAD}
Var
  PostObj  :  ^TEntPost;
{$ENDIF}
{$ENDIF}
Begin // Update_LiveCommit
{$IFDEF POST}
{$IFNDEF EBAD}
  If CommitAct And (IdR.IdDocHed In CommitLSet) And (FParentTrans.NomAuto) Then
  Begin
    If Assigned(FParentCalculator.CommitPtr) Then
    Begin
      PostObj := FParentCalculator.CommitPtr;
      try
        PostObj^.Update_LiveCommit(IdR,DedMode);
      except
        Dispose(PostObj, Destroy);
        FParentCalculator.CommitPtr := nil;
      end;
    End // If Assigned(FParentCalculator.CommitPtr)
    Else
      AddLiveCommit2Thread(IdR, DedMode);
  End; // If CommitAct And (IdR.IdDocHed In CommitLSet) And (FParentTrans.NomAuto)
{$ENDIF}
{$ENDIF}
End; // Update_LiveCommit

//------------------------------

Procedure TTTDCalculatorLine.UpdateLine;
Var
  sKey : Str255;
  iStatus : SmallInt;
  LineTotal : Double;
Begin // UpdateLine
  // Check for changes
  If (FOrigLine.Discount3 <> FAfterLine.Discount3) Or (FOrigLine.Discount3Chr <> FAfterLine.Discount3Chr) Then
  Begin
    With TBtrieveSavePosition.Create Do
    Begin
      Try
        // Save the current position in the file for the current key
        SaveFilePosition (IDetailF, GetPosKey);
        SaveDataBlock (@Id, SizeOf(Id));

        //------------------------------

        sKey := FullNomKey (FOrigLine.FolioRef) + FullNomKey(FOrigLine.LineNo);
        iStatus := Find_Rec(B_GetEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
        If (iStatus = 0) And (Id.FolioRef = FOrigLine.FolioRef) And (Id.LineNo = FOrigLine.LineNo) Then
        Begin
          // Copy discount fields from memory into actual transaction line
          Id.Discount3 := FAfterLine.Discount3;
          Id.Discount3Chr := FAfterLine.Discount3Chr;
          If (Id.Discount3 <> 0.0) Then
            Id.Discount3Type := Ord(FParentCalculator.DiscountMode)  // TTD/VBD
          Else
            Id.Discount3Type := 0; // No TTD/VBD Discount

          // Recalc VAT
          CalcVAT(Id, FParentTrans.DiscSetl);

          // Update Stock
          {$IFNDEF EBAD}
          If (Trim(Id.StockCode) <> '') Then
          Begin
            Stock_Deduct(Id, FParentTrans^, False, True, 0);
            Stock_Deduct(Id, FParentTrans^, True, True, 0);
          End; // If (Trim(Id.StockCode) <> '')
          {$ENDIF}
          iStatus := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);
          If (iStatus = 0) then
          Begin
          {$IFNDEF EBAD}
            // Update Customer Stock Analysis
            If FParentCalculator.Adding Then
            Begin
              Stock_AddCustAnal(FOrigLine, BOn, 1);     // MH 15/10/2009: This may not be necessary as we aren't changing the Account Code or Stock Code
              Stock_AddCustAnal(Id, BOn, 0);
            End; // If FParentCalculator.Adding

            {$IFNDEF COMTK}  //PR: 20/05/2009
            If CommitAct And {(Id.IdDocHed In CommitLSet) And} FParentTrans.NomAuto Then
            Begin
              // Update Committment Accounting
              Update_LiveCommit(FOrigLine, -1);
              Update_LiveCommit(Id, 1);
            End; // If CommitAct And (Id.IdDocHed In CommitLSet) And FParentTrans.NomAuto
            {$ENDIF}

            If JbCostOn And (Trim(Id.JobCode) <> '') And ((InvLLTotal(Id,BOn,0) <> 0) Or
                                                          (InvLLTotal(FOrigLine, BOn, 0) <> 0) Or
                                                          (Id.Qty <> 0.0)
                                                         ) And (Id.KitLink=0) Then
              // Update Job Costing
              Update_JobAct(Id, FParentTrans^);

            // Update totals on parent transaction
            UpdateRecBal(FOrigLine, FParentTrans^, BOn, BOff, 0);
            UpdateRecBal(Id, FParentTrans^, BOff, BOn, 0);
            {$ENDIF EBAD}

            // Update VAT Analysis - VAT Amount will have changed if discount was changed
            FParentTrans.InvVATAnal[GetVATNo(Id.VATCode, Id.VATIncFlg)] := FParentTrans.InvVATAnal[GetVATNo(Id.VATCode, Id.VATIncFlg)]
                                                                           - FOrigLine.VAT
                                                                           + Id.VAT;

            If (Id.DocLTLink > 0) then
              // Update line type analysis
              FParentTrans.DocLSplit[Id.DocLTLink] := FParentTrans.DocLSplit[Id.DocLTLink]
                                                      - Round_Up(InvLTotal(FOrigLine, BOff, 0), 2)
                                                      + Round_Up(InvLTotal(Id, BOff, 0), 2);

            // Update local copy of line
            FAfterLine := Id;

           {$IFNDEF EBAD}
            If (Id.SerialQty <> 0) Then
            Begin
              // Update price on linked Serial/Batch
              UpdateSerialBatch;
            End; // If (Id.SerialQty <> 0)

            // NOTE: Don't bother updated Sales Price on Bins as it doesn't work properly
            // in Exchequer anyway - appears to get set automatically to the default stock
            // price ignoring Line Discount, Multi-Buy Discount and TTD/VBD Discounts
            If (Id.IdDocHed In PurchSplit) And (Id.BinQty <> 0) Then
            Begin
              // Update price on linked Multi-Bins
              UpdateMultiBins;
            End; // If (Id.BinQty <> 0)
            {$ENDIF EBAD}
          End // If (iStatus = 0)
          Else
            Report_BError (IDetailF, iStatus);
        End // If (iStatus = 0) And (Id.FolioRef = FLine.FolioRef) And (Id.LineNo = FLine.LineNo)
        Else
          // Shouldn't happen
          Raise Exception.Create ('TTTDCalculatorLine.UpdateLine: Failed to load transaction line - please notify your technical support');

        //------------------------------

        // Restore position in file
        RestoreDataBlock (@Id);
        RestoreSavedPosition;
      Finally
        Free;
      End; // Try..Finally
    End; // With TBtrieveSavePosition.Create
  End; // If (FOrigLine.Discount3 <> FAfterLine.Discount3) Or (FOrigLine.Discount3Chr <> FAfterLine.Discount3Chr)
End; // UpdateLine

//-------------------------------------------------------------------------

Function TTTDCalculatorLine.GetLineTotals (Index : TTTDLineTotalsEnum) : Double;
Begin // GetLineTotals
  Case Index Of
    ltBeforeNetTotal      : Result := Round_Up(InvLTotal (FBeforeLine, True, 0), 2);

    ltAfterNetTotal       : Result := Round_Up(InvLTotal (FAfterLine, True, 0), 2);
    ltAfterTotalCost      : Result := InvLCost(FAfterLine);  // Already rounded to cost decs
    //PR: 10/07/2009 Added VAT Totals for COM Tk
    ltBeforeVAT           : Result := FBeforeLine.VAT;
    ltAfterVAT            : Result := FAfterLine.VAT;
  Else
    Raise Exception.Create ('TTTDCalculatorLine.GetLineTotals: Unknown Index (' + IntToStr(Ord(Index)) + ')');
  End; // Case Index
End; // GetLineTotals

//=========================================================================
//PR: 10/07/2009 Extended Parameter List under COMTK definition to allow descendant to create without loading list
Constructor TTTDCalculator.Create (Const Adding : Boolean; Const TTDTrans : pInvRec{$IFDEF COMTK}; DoLoad : Boolean = TRUE{$ENDIF});
Begin // Create
  Inherited Create;

  FDiscountMode := cdmTTD;

  FAdding := Adding;

  FLines := TObjectList.Create;
  FLines.OwnsObjects := True;

  FTransaction := TTDTrans;

  FDescLine := TTTDNotificationLine.Create(Self, FTransaction);

  FTTDExists := False;
  FTTDDiscount := 0.0;
  FTTDDiscType := #0;

  FVBDExists := False;

  FAmountDiscountRequested := 0.0;
  FAmountDiscountApplied := 0.0;

  FDiscountDesc := '';

  {$IFNDEF COMTK}
  FUIMode := True; // Display error messages as default
  {$ELSE}
  FUIMode := False; // Don't Display error messages in toolkit
  {$ENDIF}

  // Check whether cost prices should be shown - depends on user permissions and document type
  FHideCost := Not Show_CMG(FTransaction.InvDocHed);

  FIsPurchase := (FTransaction.InvDocHed In PurchSplit);
  {$IFDEF COMTK}
  if DoLoad then
  {$ENDIF}
  LoadLines;
End; // Create

//------------------------------

Destructor TTTDCalculator.Destroy;
Begin // Destroy
  FDescLine.Free;
  FLines.Free;   // NOTE: TObjectList automatically destroys objects stored within it

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
    End; // If PcntFailed
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
        // MH 21/07/2009: Removed rounding
        //LinePortion := Round_Dn((oLine.LineTotals[ltBeforeNetTotal] / LineTotal) * DiscValue, 2)
        LinePortion := (oLine.LineTotals[ltBeforeNetTotal] / LineTotal) * DiscValue
      Else
        // Last line - allocate remainder
        // MH 17/07/2009: Removed rounding
        //LinePortion := Round_Dn(TotalToAllocate, 2);
        LinePortion := TotalToAllocate;

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

  {$IFNDEF EXDLL}  //PR: 09/07/2009 If using the Toolkits then we don't have user permissions
  // Check User Permissions - ignore for VBD as if they defined the discount they get it!
  If (FTransaction.InvDocHed In SalesSplit) And (FDiscountMode <> cdmVBD) Then
  Begin
    Result := True;

    // Check the user permission limiting transactions to >= 0
    // NOTE: Shouldn't ever happen as the TTD dialog should limit it to <= Net Value
    If (Not FAllowDiscountToExceedSale) And (TransTotals[ttAfterNetTotal] < 0) Then
    Begin
      // Transaction Value is negative - i.e. We are paying the customer to have the stuff!
      Result := False;
      {$If not Defined(COMTK) and not Defined(EBAD)}
      MessageDlg ('The Discount Value is larger than the Invoice value', mtError, [mbOK], 0);
      {$IfEnd}
    End; // If (Not FParentCalculator.AllowDiscountToExceedSale) And (LineTotals[ltAfterNetTotal] < 0)

    // Check the user permission limiting transactions to >= Cost
    If Result And (Not FAllowSaleBelowCost) And (TransTotals[ttAfterNetTotal] < TransTotals[ttAfterTotalCost]) Then
    Begin
      // Transaction Value is below cost - i.e. We are making a loss
      Result := False;
      {$If not Defined(COMTK) and not Defined(EBAD)}
      MessageDlg ('The Cost of this transaction is larger than the Invoice value', mtError, [mbOK], 0);
      {$IfEnd}
    End; // If (Not FParentCalculator.AllowSaleBelowCost)
  End // If (FTransaction.InvDocHed In SalesSplit)
  Else
  {$ENDIF}
    Result := True;
End; // CalculateAD

//-------------------------------------------------------------------------

// Updates the Transaction/Lines with the currently specified discount
Procedure TTTDCalculator.UpdateTransactionDiscounts (Const ApplyDiscounts : Boolean);
Var
  iLine, iStatus : SmallInt;
Begin // UpdateTransactionDiscounts
  // Run through lines updating the database - also updates the transaction header in memory
  For iLine := 0 To Pred(FLines.Count) Do
    TTTDCalculatorLine(FLines.Items[iLine]).UpdateLine;

  If ApplyDiscounts Then
  Begin
    // Create/Update TTD/VBD Notification line
    If (FDiscountMode = cdmTTD) Then
      FDescLine.Update (TTDDescHeader + FDiscountDesc + ' given')
    Else
      FDescLine.Update (VBDDescHeader + FDiscountDesc + ' given');

    FTTDExists := (FDiscountMode = cdmTTD);
    FVBDExists := (FDiscountMode = cdmVBD);
  End // If ApplyDiscounts
  Else
  Begin
    // Remove any pre-existing TTD/VBD Notification line
    FDescLine.Delete;
    FTTDExists := False;
    FVBDExists := False;
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
Procedure TTTDCalculator.CacheLine (Const TheLine : IDetail);
Begin // CacheLine
  FLines.Add (TTTDCalculatorLine.Create (Self, FTransaction, TheLine));
End; // CacheLine

//------------------------------

// Load the transaction lines into cache to work with
Procedure TTTDCalculator.LoadLines;
Var
  iStatus : SmallInt;
  sKey : Str255;
  DivQty : Double;
Begin // LoadLines
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (IDetailF, GetPosKey);
      SaveDataBlock (@Id, SizeOf(Id));

      //------------------------------

      sKey := FullNomKey (FTransaction.FolioNum);
      iStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
      While (iStatus = 0) And (Id.FolioRef = FTransaction.FolioNum) Do
      Begin
        // If line has value then stash in cache  (Exclude line discounts otherwise for edits previous TTD/VBD may have zeroed down the line)
        //PR: 03/07/2009 Added check to stop payment lines being cached ((Id.LineNo <> RecieptCode)).
        If ((InvLTotal (Id, False, 0) <> 0) Or (Id.Discount3Type In [1, 2])) and (Id.LineNo <> RecieptCode) Then
        Begin
          CacheLine (Id);

          // Check for existing TTD/VBD discounts - 0=Undefined, 1=TTD, 2=VBD, 255=Info Line
          If (Id.Discount3Type = 1) Then
          Begin
            // TTD
            FTTDExists := True;

            // NOTE: working on basis of lines having one disount type or another
            If (Id.Discount3Chr = PcntChr) Then
            Begin
              // Percentage Discount - record highest offer
              If (Id.Discount3 > FTTDDiscount) Then
              Begin
                FTTDDiscount := Id.Discount3;
                FTTDDiscType := Id.Discount3Chr;
              End; // If (Id.Discount3 > FTTDDiscount)
            End // If (Id.Discount3 > FTTDDiscount)
            Else
            Begin
              // Amount Discount - accumulate for a total
              If Id.PrxPack and (Id.QtyPack <> 0.0) and (Id.QtyMul <> 0.0) then
              Begin
                If Id.ShowCase Then
                  DivQty := DivWChk(Id.Qty, Id.QtyPack)
                Else
                  //DivQty := DivWChk(Id.QtyMul, Id.QtyPack);
                  DivQty := Calc_IdQty(Id.Qty, Id.QtyMul, Id.UsePack);
              End // If Id.PrxPack and (Id.QtyPack <> 0.0) and (Id.QtyMul <> 0.0)
              Else
                //DivQty := Id.Qty;
                DivQty := Calc_IdQty(Id.Qty, Id.QtyMul, Id.UsePack);

              //FTTDDiscount := FTTDDiscount + (Id.Discount3 * Id.Qty);  // will this work with packs?
              FTTDDiscount := FTTDDiscount + (Id.Discount3 * DivQty);  // No, but this will
              FTTDDiscType := Id.Discount3Chr;
            End; // Else
          End // If (Not FTTDExists) And (Id.Discount3Type = 1)
          Else If (Id.Discount3Type = 2) Then
          Begin
            // VBD - no UI so don't bother recording existing discount - new discount automatically
            // applied based on discounts specified against Customer/Supplier
            FVBDExists := True;
          End // If (Not FTTDExists) And (Id.Discount3Type = 1)
        End // If (InvLTotal (Id, False, 0) <> 0) Or (Id.Discount3Type In [1, 2])
        Else If (Pos (TTDDescHeader, Id.Desc) = 1) Or (Pos (VBDDescHeader, Id.Desc) = 1) And (Id.Discount3Type = 255) Then
        Begin
          FDescLine.Assign (Id);
        End; // If (Pos (TTDDescHeader, Id.Desc) = 1) Or (Pos (VBDDescHeader, Id.Desc) = 1) And (Id.Discount3Type = 255)

        iStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
      End; // While (iStatus = 0)

      //------------------------------

      // Restore position in file
      RestoreDataBlock (@Id);
      RestoreSavedPosition;
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // LoadLines

//-------------------------------------------------------------------------

// Returns True if the specified Percentage Discount is within the valid range
Function TTTDCalculator.ValidPercentageDiscount (Const PercValue : Double) : Boolean;
Begin // ValidPercentageDiscount
  Result := (PercValue >= 0) And (PercValue <= 100);
End; // ValidPercentageDiscount

//------------------------------

// Returns True if the specified Discount Value is within the valid range
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
  Result := FTransaction.OurRef;
End; // GetOurRef

//------------------------------

Function TTTDCalculator.GetTransTotals (Index : TTTDTotalsEnum) : Double;
Var
  iLine : SmallInt;
Begin // GetTransTotals
  Case Index Of
    ttBeforeTotalCost     : If (FTransaction.InvDocHed In PurchSplit) Then
                              Result := 0
                            Else
                              Result := FTransaction.TotalCost;

    ttBeforeNetTotal      : Begin
                              Result := 0.0;
                              For iLine := 0 To Pred(FLines.Count) Do
                              Begin
                                Result := Result + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltBeforeNetTotal];
                              End; // For iLine
                            End; // Begin

    ttBeforeNetLessSettle : Begin
                              Result := GetTransTotals (ttBeforeNetTotal);
                              Result := Result - Calc_PAmount(Result, FTransaction.DiscSetl, PcntChr);
                            End; // ttBeforeNetLessSettle


    ttAfterTotalCost      : Result := GetTransTotals (ttBeforeTotalCost);

    ttAfterNetTotal       : Begin
                              Result := 0.0;
                              For iLine := 0 To Pred(FLines.Count) Do
                              Begin
                                Result := Result + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltAfterNetTotal];
                              End; // For iLine
                            End; // Begin

    ttAfterNetLessSettle  : Begin
                              Result := GetTransTotals (ttAfterNetTotal);
                              Result := Result - Calc_PAmount(Result, FTransaction.DiscSetl, PcntChr);
                            End; // ttBeforeNetLessSettle

    ttBeforeVATTotal      : Begin
                              Result := 0.0;
                              For iLine := 0 To Pred(FLines.Count) Do
                              Begin
                                Result := Result + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltBeforeVAT];
                              End; // For iLine
                            End; // Begin
    ttAfterVATTotal       : Begin
                              Result := 0.0;
                              For iLine := 0 To Pred(FLines.Count) Do
                              Begin
                                Result := Result + TTTDCalculatorLine(FLines.Items[iLine]).LineTotals[ltAfterVAT];
                              End; // For iLine
                            End; // Begin

  Else
    Raise Exception.Create ('TTTDCalculator.GetTransTotals: Unknown Index (' + IntToStr(Ord(Index)) + ')');
  End; // Case Index
End; // GetTransTotals

//=========================================================================

end.

