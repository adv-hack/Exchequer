Unit SQLRep_FullTrialBalance_GLHistoryStore;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Type
  TTrialBalanceGLHistoryStoreItem = Class(TObject)
  Private
    FYear, FPeriod : Integer;
    FSalesValue, FPurchaseValue, FBudgetValue, FBudget2Value : Double;
  Public
    Property Year : Integer Read FYear;
    Property Period : Integer Read FPeriod;
    Property SalesValue : Double Read FSalesValue;
    Property PurchaseValue : Double Read FPurchaseValue;
    Property BudgetValue : Double Read FBudgetValue;
    Property Budget2Value : Double Read FBudget2Value;

    Constructor Create (Const Year, Period : Integer; Const SalesValue, PurchaseValue, BudgetValue, Budget2Value : Double);
    Class Function SortString (Const Year, Period : Integer) : ShortString;
  End; // TTrialBalanceGLHistoryStoreItem

  //------------------------------

  ITrialBalanceGLHistoryStore = Interface
    ['{8732BF09-5C17-4ECA-A9A8-990EC936FA3F}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCount : Integer;
    Function GetHistoryDetails (Index : Integer) : TTrialBalanceGLHistoryStoreItem;

    // ------------------ Public Properties ------------------
    Property Count : Integer Read GetCount;
    Property HistoryDetails [Index : Integer] : TTrialBalanceGLHistoryStoreItem Read GetHistoryDetails;

    // ------------------- Public Methods --------------------
    // Adds the specified history details into the store
    Procedure AddHistoryRow (Const Year, Period : Integer; Const SalesValue, PurchaseValue, BudgetValue, Budget2Value : Double); Overload;
    Procedure AddHistoryRow (Const HistoryDetails : TTrialBalanceGLHistoryStoreItem); Overload;
  End; // ITrialBalanceGLHistoryStore


//
Function CreateTBHistoryStore : ITrialBalanceGLHistoryStore;

Implementation

Uses Classes, SysUtils;

Type
  TTrialBalanceGLHistoryStore = Class(TInterfacedObject, ITrialBalanceGLHistoryStore)
  Private
    FHistoryStore : TStringList;

    // ITrialBalanceGLHistoryStore
    Function GetCount : Integer;
    Function GetHistoryDetails (Index : Integer) : TTrialBalanceGLHistoryStoreItem;

    // Adds the specified history details into the store
    Procedure AddHistoryRow (Const Year, Period : Integer; Const SalesValue, PurchaseValue, BudgetValue, Budget2Value : Double); Overload;
    Procedure AddHistoryRow (Const HistoryDetails : TTrialBalanceGLHistoryStoreItem); Overload;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TTrialBalanceGLHistoryStore

//=========================================================================

Function CreateTBHistoryStore : ITrialBalanceGLHistoryStore;
Begin // CreateTBHistoryStore
  Result := TTrialBalanceGLHistoryStore.Create;
End; // CreateTBHistoryStore

//=========================================================================

Constructor TTrialBalanceGLHistoryStoreItem.Create (Const Year, Period : Integer; Const SalesValue, PurchaseValue, BudgetValue, Budget2Value : Double);
Begin // Create
  Inherited Create;

  FYear := Year;
  FPeriod := Period;
  FSalesValue := SalesValue;
  FPurchaseValue := PurchaseValue;
  FBudgetValue := BudgetValue;
  FBudget2Value := Budget2Value;
End; // Create

//-------------------------------------------------------------------------

Class Function TTrialBalanceGLHistoryStoreItem.SortString (Const Year, Period : Integer) : ShortString;
Begin // SortString
  Result := Format ('%4.4d%4.4d', [Year, Period]);
End; // SortString

//=========================================================================

Constructor TTrialBalanceGLHistoryStore.Create;
Begin // Create
  Inherited Create;

  // History details will be stored in an object/interface stored in the Objects property
  // of a string list sorted by year and period (YYYYPPP)
  FHistoryStore := TStringList.Create;
  FHistoryStore.Sorted := True;
End; // Create

//------------------------------

Destructor TTrialBalanceGLHistoryStore.Destroy;
Begin // Destroy
  // Run through store freeing any stored objects
  While (FHistoryStore.Count > 0) Do
  Begin
    TTrialBalanceGLHistoryStoreItem(FHistoryStore.Objects[0]).Free;
    FHistoryStore.Delete(0);
  End; // While (FHistoryStore.Count > 0)

  FHistoryStore.Free;
End; // Destroy

//-------------------------------------------------------------------------

// Adds the specified history details into the store
Procedure TTrialBalanceGLHistoryStore.AddHistoryRow (Const Year, Period : Integer; Const SalesValue, PurchaseValue, BudgetValue, Budget2Value : Double);
Var
  sSort : ShortString;
Begin // AddHistoryRow
  sSort := TTrialBalanceGLHistoryStoreItem.SortString(Year, Period);

  // Check to see whether this item already exists - duplicates can be ignored as they will have the same numbers
  If (FHistoryStore.IndexOf (sSort) = -1) Then
  Begin
    // Doesn't exist - add it in
    FHistoryStore.AddObject (sSort, TTrialBalanceGLHistoryStoreItem.Create (Year, Period, SalesValue, PurchaseValue, BudgetValue, Budget2Value));
  End; // If (FHistoryStore.IndexOf (sSort) = -1)
End; // AddHistoryRow

//------------------------------

Procedure TTrialBalanceGLHistoryStore.AddHistoryRow (Const HistoryDetails : TTrialBalanceGLHistoryStoreItem);
Begin // AddHistoryRow
  With HistoryDetails Do
    AddHistoryRow (Year, Period, SalesValue, PurchaseValue, BudgetValue, Budget2Value);
End; // AddHistoryRow

//-------------------------------------------------------------------------

Function TTrialBalanceGLHistoryStore.GetCount : Integer;
Begin // GetCount
  Result := FHistoryStore.Count;
End; // GetCount

//------------------------------

Function TTrialBalanceGLHistoryStore.GetHistoryDetails (Index : Integer) : TTrialBalanceGLHistoryStoreItem;
Begin // GetHistoryDetails
  If (Index >= 0) And (Index < FHistoryStore.Count) Then
    Result := TTrialBalanceGLHistoryStoreItem(FHistoryStore.Objects[Index])
  Else
    Raise ERangeError.Create ('TTrialBalanceGLHistoryStore.GetHistoryDetails: Invalid Index (' + IntToStr(Index) + ')');
End; // GetHistoryDetails

//=========================================================================

End.