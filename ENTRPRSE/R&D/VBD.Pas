Unit VBD;

{$If not (Defined(SOP) or Defined(COMTK))}
  This unit should not be compiling into this application/dll
{$IfEnd}

Interface

Uses Classes, Controls, Contnrs, Dialogs, Forms, StrUtils, SysUtils, Windows, GlobVar, VarConst, BtrvU2;

Type
  pInvRec = ^InvRec;

  //------------------------------

  TVBDListItem = Class(TObject)
  Private
    FTransaction : pInvRec;

    FThreshold : Double;
    FDiscPerc : Double;
    FDiscAmount : Double;

    FDescription : ShortString;

    Function GetDiscountVal : Double;
    Function GetDiscountType : Char;
    Function GetSortString : ShortString;
    Function ToTransCurrency (Const ConsAmount : Double) : Double;
  Public
    Constructor Create (Const ADTrans : pInvRec; Const VBDRec : CustDiscType);
    Destructor Destroy; Override;

    Property Description : ShortString Read FDescription;
    Property DiscountVal : Double Read GetDiscountVal;
    Property DiscountType : Char Read GetDiscountType;
    Property SortString : ShortString Read GetSortString;
    Property Threshold : Double Read FThreshold;
  End; // TVBDListItem

  //------------------------------

  TVBDList = Class(TObject)
  Private
    FTransaction : pInvRec;
    FDiscounts : TStringList;

    Function GetDiscountCount : LongInt;
    Procedure SearchForDiscounts;
    Procedure ClearList (Const DiscountList : TStringList);
  Public
    Constructor Create (Const ADTrans : pInvRec);
    Destructor Destroy; Override;

    Property DiscountCount : LongInt Read GetDiscountCount;

    // Returns a VBD Discount applicable for the specified value, returns NIL if none found
    Function GetOffer (Const TransactionValue : Double) : TVBDListItem;
  End; // TVBDList

  //------------------------------

Implementation

Uses BTSupU1, BTKeys1U, SavePos, ETMiscU, {$IFDEF COMTK}BTSupU2,{$ENDIF}CurrncyU;

//=========================================================================

Constructor TVBDListItem.Create (Const ADTrans : pInvRec; Const VBDRec : CustDiscType);
Begin // Create
  Inherited Create;

  FTransaction := ADTrans;

  // Check to see if the discount needs to be translated to transaction currency - discount
  // can only be in transaction currency or Consolidated unless it has all gone pete tong!
  If (VBDRec.QBCurr = 0) And (FTransaction.Currency <> 0) Then
  Begin
    FThreshold := ToTransCurrency(VBDRec.QSPrice);
    FDiscAmount := ToTransCurrency(VBDRec.QDiscA);
  End // If (VBDRec.QBCurr = 0) And (FTransaction.Currency <> 0)
  Else
  Begin
    // Already in transaction currency
    FThreshold := VBDRec.QSPrice;
    FDiscAmount := VBDRec.QDiscA;
  End; // Else

  FDiscPerc := VBDRec.QDiscP;

  If (FDiscPerc <> 0.0) Then
    FDescription := FloatToStr(FDiscPerc) + '%'
  Else
  Begin
    //FDescription := Format('%0.2f', [FDiscAmount]);
    //PR: 10/07/2009 SSymb can't be used in Toolkit.
    {$IFNDEF COMTK}
    FDescription := {$IFDEF MC_On}SSymb(FTransaction.Currency) + {$ENDIF} FormatFloat(GenRealMask, FDiscAmount);
    {$ELSE}
    FDescription :=  TxLatePound(Trim(SyssCurr.Currencies[FTransaction.Currency].SSymb), True) + FormatFloat(GenRealMask, FDiscAmount);
    {$ENDIF}
  End; // Else
End; // Create

//------------------------------

Destructor TVBDListItem.Destroy;
Begin // Destroy
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TVBDListItem.ToTransCurrency (Const ConsAmount : Double) : Double;
Var
  UOR : Byte;
Begin // ToTransCurrency
  UOR := fxUseORate (BOff, BOn, FTransaction.CXRate, FTransaction.UseORate, FTransaction.Currency, 0);
  Result := Round_Up(Conv_TCurr(ConsAmount, FTransaction.CXrate[(Syss.TotalConv=XDayCode)], FTransaction.Currency, UOR, True), 2);
End; // ToTransCurrency

//-------------------------------------------------------------------------

Function TVBDListItem.GetDiscountVal : Double;
Begin // GetDiscountVal
  If (FDiscPerc <> 0.0) Then
    Result := FDiscPerc
  Else
    Result := FDiscAmount;
End; // GetDiscountVal

//------------------------------

Function TVBDListItem.GetDiscountType : Char;
Begin // GetDiscountType
  If (FDiscPerc <> 0.0) Then
    Result := '%'
  Else
    Result := C0;
End; // GetDiscountType

//-------------------------------------------------------------------------

// The sort string consists of the threshold amount (in transaction currency) in the format
// 000000000000.00   (max 999 billion!)
Function TVBDListItem.GetSortString : ShortString;
Begin // GetSortString
  Result := FormatFloat('000000000000.000000', Abs(FThreshold));
End; // GetSortString

//=========================================================================

Constructor TVBDList.Create (Const ADTrans : pInvRec);
Begin // Create
  Inherited Create;

  FTransaction := ADTrans;
  FDiscounts := NIL;

  If Syss.EnableVBDDiscounts Then
    // Load the discounts for the customer/supplier
    SearchForDiscounts;
End; // Create

//------------------------------

Destructor TVBDList.Destroy;
Begin // Destroy
  If Assigned(FDiscounts) Then
    ClearList (FDiscounts);
  FreeAndNIL(FDiscounts);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TVBDList.ClearList (Const DiscountList : TStringList);
Begin // ClearList
  While (DiscountList.Count > 0) Do
  Begin
    TVBDListItem(DiscountList.Objects[0]).Free;
    DiscountList.Delete(0);
  End; // While (DiscountList.Count > 0)
End; // ClearList

//-------------------------------------------------------------------------

// Loads any discounts
Procedure TVBDList.SearchForDiscounts;
Var
  oGlobalDiscounts : TStringList;
  oDatedDiscounts : TStringList;
  oMiscPos : TBtrieveSavePosition;

  //------------------------------

  Procedure SearchForCurrencyDiscounts (Const SearchCurrency : Byte);
  Var
    oDiscount : TVBDListItem;
    KeyS, KeyChk : Str255;
    iStatus : SmallInt;
  Begin // SearchForCurrencyDiscounts
    KeyS := CDDiscCode + IfThen (FTransaction.InvDocHed In SalesSplit, 'C', 'S') +
            MakeCDKey(FTransaction.CustCode ,'', SearchCurrency) + HelpKStop;
    KeyChk := KeyS;

    // NOTE: Need to read ALL discounts matching key as the threshold amount isn't an
    // indexed field so they could be in any order (probably the order they were added)
    iStatus := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
    While (iStatus = 0) And CheckKey(KeyChk, KeyS, Length(KeyChk), BOn) Do
    Begin
      If MiscRecs.CustDiscRec.CUseDates Then
      Begin
        // Check effective date range
        If (FTransaction.TransDate >= MiscRecs.CustDiscRec.CStartD) and (FTransaction.TransDate <= MiscRecs.CustDiscRec.CEndD) Then
        Begin
          oDiscount := TVBDListItem.Create (FTransaction, MiscRecs.CustDiscRec);
          oDatedDiscounts.AddObject(oDiscount.SortString, oDiscount);
        End; // If (FTransaction.TransDate >= MiscRecs.CustDiscRec.CStartD) and (FTransaction.TransDate <= MiscRecs.CustDiscRec.CEndD)
      End // If MiscRecs.CustDiscRec.CUseDates
      Else
      Begin
        oDiscount := TVBDListItem.Create (FTransaction, MiscRecs.CustDiscRec);
        oGlobalDiscounts.AddObject(oDiscount.SortString, oDiscount);
      End; // Else

      iStatus := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
    End; // While (iStatus = 0) And CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)
  End; // SearchForCurrencyDiscounts

  //------------------------------

Begin // SearchForDiscounts
  // Look for discounts in transaction currency, if not found then check for consolidated
  oMiscPos := TBtrieveSavePosition.Create;
  oMiscPos.SaveFilePosition (MiscF, GetPosKey);
  oMiscPos.SaveDataBlock (MiscRecs, SizeOf(MiscRecs^));
  Try
    // use two local lists to store the global and dated discounts, one of these will then be
    // kept as the discounts list on the object the other being destroyed.
    oGlobalDiscounts := TStringList.Create;
    oGlobalDiscounts.Sorted := True;
    oDatedDiscounts := TStringList.Create;
    oDatedDiscounts.Sorted := True;

    // Check for discounts against the transaction currency
    SearchForCurrencyDiscounts (FTransaction.Currency);
    If (oGlobalDiscounts.Count = 0) And (oDatedDiscounts.Count = 0) And (FTransaction.Currency <> 0) Then
      // No discounts in transaction currency so try consolidated
      SearchForCurrencyDiscounts (0);

    // If dated discounts are available then use them first
    If (oDatedDiscounts.Count > 0) Then
    Begin
      // Allocate dated discounts to public list
      FDiscounts := oDatedDiscounts;
      ClearList (oGlobalDiscounts);
      FreeAndNIL(oGlobalDiscounts);
    End // If (oDatedDiscounts.Count > 0)
    Else
    Begin
      // Allocate global discounts to public list
      FDiscounts := oGlobalDiscounts;
      ClearList (oDatedDiscounts);
      FreeAndNIL(oDatedDiscounts);
    End; // Else
  Finally
    // Restore position in file
    oMiscPos.RestoreDataBlock (MiscRecs);
    oMiscPos.RestoreSavedPosition;
    oMiscPos.Free;
  End; // Try..Finally
End; // SearchForDiscounts

//-------------------------------------------------------------------------

// Returns a VBD Discount applicable for the specified value, returns NIL if none found
Function TVBDList.GetOffer (Const TransactionValue : Double) : TVBDListItem;
Var
  oDiscount : TVBDListItem;
  iDiscount : LongInt;
Begin // GetOffer
  Result := NIL;

  If Assigned(FDiscounts) And (FDiscounts.Count > 0) Then
  Begin
    // Find highest threshold discount that applies
    For iDiscount := (FDiscounts.Count - 1) DownTo 0 Do
    Begin
      oDiscount := TVBDListItem(FDiscounts.Objects[iDiscount]);
      If (oDiscount.Threshold <= TransactionValue) Then
      Begin
        Result := oDiscount;
        Break;
      End; // If (oDiscount.Threshold <= TransactionValue)
    End; // For iDiscount
  End; // If Assigned(FDiscounts) And (FDiscounts.Count > 0)
End; // GetOffer

//-------------------------------------------------------------------------

Function TVBDList.GetDiscountCount : LongInt;
Begin // GetDiscountCount
  If Assigned(FDiscounts) Then
    Result := FDiscounts.Count
  Else
    Result := 0;
End; // GetDiscountCount

//-------------------------------------------------------------------------

End.