Unit oPPDLedgerTransactions;

Interface

Uses Classes, SysUtils, GlobVar, VarConst, ExWrap1U, Math;

Type
  IPPDLedgerTransactionListIndexEnum = (idxOurRef=0, idxYourRef=1, idxTransDate=2, idxTotalValue=3, IdxOutstandingValue=4);

Const
  PPDLedgerTransactionListIndexDescriptions : Array [IPPDLedgerTransactionListIndexEnum] of String =
    (
      {idxOurRef}             'Sort by OurRef',
      {idxYourRef}            'Sort by YourRef',
      {idxTransDate}          'Sort by Transaction Date, Total Value, OurRef',
      {idxTotalValue}         'Sort by Total Value, OurRef',
      {IdxOutstandingValue}   'Sort by Outstanding Value, OurRef'
    );

  //------------------------------

Type
  // Generic interface for objects which implement a specific import type
  IPPDLedgerTransactionDetails = Interface
    ['{23B3C821-3798-4980-A713-3FDEE493070A}']
    // --- Internal Methods to implement Public Properties ---
    Function GetTransaction : InvRec;
    Function GetCurrency : Byte;
    Function GetOurRef : String;
    Function GetTransactionDate : String;
    Function GetSettledValueInBase : Double;
    Function GetOutstandingValueInBase : Double;
    Function GetTotalValueInBase : Double;
    Function GetOriginalValueInCcy : Double;
    Function GetYourRef : String;
    Function GetDateDue : String;
    Function GetStatus : String;
    Function GetPPDValueInCcy : Double;
    Function GetPPDExpiry : String;
    Function GetSelected : Boolean;
    Procedure SetSelected (Value : Boolean);

    // ------------------ Public Properties ------------------
    Property tdTransaction : InvRec Read GetTransaction;
    Property tdCurrency : Byte Read GetCurrency;
    Property tdOurRef : String Read GetOurRef;
    Property tdTransactionDate : String Read GetTransactionDate;
    Property tdSettledValueInBase : Double Read GetSettledValueInBase;
    Property tdOutstandingValueInBase : Double Read GetOutstandingValueInBase;
    Property tdTotalValueInBase : Double Read GetTotalValueInBase;
    Property tdOriginalValueInCcy : Double Read GetOriginalValueInCcy;
    Property tdYourRef : String Read GetYourRef;
    Property tdDateDue : String Read GetDateDue;
    Property tdStatus : String Read GetStatus;
    Property tdPPDValueInCcy : Double Read GetPPDValueInCcy;
    Property tdPPDExpiry : String Read GetPPDExpiry;

    Property tdSelected : Boolean Read GetSelected Write SetSelected;


    // ------------------- Public Methods --------------------
  End; // IPPDLedgerTransactionDetails

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IPPDLedgerTransactionList = Interface
    ['{497C49B5-92B6-4460-A9CC-B894A9C6AD49}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCount : Integer;
    Function GetIndex : IPPDLedgerTransactionListIndexEnum;
    Procedure SetIndex (Value : IPPDLedgerTransactionListIndexEnum);
    Function GetTransactions (Index : Integer) : IPPDLedgerTransactionDetails;
    //Procedure SetTransactions (Index : Integer; Value : IPPDLedgerTransactionDetails);

    // ------------------ Public Properties ------------------
    Property Count : Integer Read GetCount;
    Property Index : IPPDLedgerTransactionListIndexEnum Read GetIndex Write SetIndex;
    Property Transactions [Index: Integer] : IPPDLedgerTransactionDetails Read GetTransactions; // Write SetTransactions;

    // ------------------- Public Methods --------------------
    Procedure LoadTransactions (Var ExLocal : TdMTExLocal);
  End; // IPPDLedgerTransactionList

Function CreatePPDLedgerTransactionList (Const AccountRec : CustRec) : IPPDLedgerTransactionList;

Implementation

Uses BtrvU2, BTKeys1U, SQLUtils, SQLTransactions, ETStrU, ETDateU, ETMiscU, ComnUnit, CurrncyU, SysU1;

Type
  TTransaction = Class(TInterfacedObject, IPPDLedgerTransactionDetails)
  Private
    // Keep a reference to the interface implemented by the instance of the object to stop the object
    // being destroyed automatically by the reference counting system after the interface is returned
    // by the TPPDLedgerTransactionList.GetTransactions (incrementing the ref count) to the calling
    // code and then the calling code removes the reference (decrimenting the ref count).  The parent
    // object has to call ClearReference top allow the object instance to destroy.
    FSelfIntf : IPPDLedgerTransactionDetails;

    FTransaction : InvRec;
    FSelected : Boolean;

    Function GetIndexString (Index : IPPDLedgerTransactionListIndexEnum) : String;

    // IPPDLedgerTransactionDetails methods
    Function GetTransaction : InvRec;
    Function GetCurrency : Byte;
    Function GetOurRef : String;
    Function GetTransactionDate : String;
    Function GetSettledValueInBase : Double;
    Function GetOutstandingValueInBase : Double;
    Function GetTotalValueInBase : Double;
    Function GetOriginalValueInCcy : Double;
    Function GetYourRef : String;
    Function GetDateDue : String;
    Function GetStatus : String;
    Function GetPPDValueInCcy : Double;
    Function GetPPDExpiry : String;
    Function GetSelected : Boolean;
    Procedure SetSelected (Value : Boolean);
  Public
    Property IndexString [Index : IPPDLedgerTransactionListIndexEnum] : String Read GetIndexString;
    //Property Transaction : InvRec Read GetTransaction;

    Constructor Create (Const Transaction : InvRec);
    Destructor Destroy; Override;
    Procedure ClearReference;
  End; // TTransaction

  //------------------------------

  TPPDLedgerTransactionList = Class(TInterfacedObject, IPPDLedgerTransactionList)
  Private
    FAccountRec : CustRec;

    // Storage for list of TTransaction objects
    FTransactions : TStringList;

    FIndex : IPPDLedgerTransactionListIndexEnum;
  Protected
    // IPPDLedgerTransactionList
    Function GetCount : Integer;
    Function GetIndex : IPPDLedgerTransactionListIndexEnum;
    Procedure SetIndex (Value : IPPDLedgerTransactionListIndexEnum);
    Function GetTransactions (Index : Integer) : IPPDLedgerTransactionDetails;

    // local methods
    Procedure ProcessTransaction (Const Transaction : InvRec);

    //PR: 11/06/2015 ABSEXCH-16525 Function to clear transaction list
    procedure ClearList;
  Public
    Constructor Create (Const AccountRec : CustRec);
    Destructor Destroy; Override;

    Procedure LoadTransactions (Var ExLocal : TdMTExLocal); Virtual; Abstract;
  End; // TPPDLedgerTransactionList

  //------------------------------

  TPPDLedgerTransactionListPerv = Class(TPPDLedgerTransactionList)
  Protected
    Procedure LoadTransactions (Var ExLocal : TdMTExLocal); Override;
  End; // TPPDLedgerTransactionListPerv

  //------------------------------

  TPPDLedgerTransactionListSQL = Class(TPPDLedgerTransactionList)
  Protected
    Procedure LoadTransactions (Var ExLocal : TdMTExLocal); Override;
  End; // TPPDLedgerTransactionListSQL

//=========================================================================

Function CreatePPDLedgerTransactionList (Const AccountRec : CustRec) : IPPDLedgerTransactionList;
Begin // CreatePPDLedgerTransactionList
  // Create the correct version for the data edition
  If SQLUtils.UsingSQL Then
    Result := TPPDLedgerTransactionListSQL.Create(AccountRec)
  Else
    Result := TPPDLedgerTransactionListPerv.Create(AccountRec);
End; // CreatePPDLedgerTransactionList

//=========================================================================

Constructor TTransaction.Create (Const Transaction : InvRec);
Begin // Create
  Inherited Create;

  // Keep a reference to the interface implemented by the instance of the object to stop the object
  // being destroyed automatically by the reference counting system after the interface is returned
  // by the TPPDLedgerTransactionList.GetTransactions (incrementing the ref count) to the calling
  // code and then the calling code removes the reference (decrimenting the ref count).  The parent
  // object has to call ClearReference top allow the object instance to destroy.
  FSelfIntf := Self;

  FTransaction := Transaction;
  FSelected := False;
End; // Create

//------------------------------

Procedure TTransaction.ClearReference;
Begin // ClearReference
  // Remove the reference to the interface which keeps the object alive
  FSelfIntf := NIL;
End; // ClearReference

//------------------------------

Destructor TTransaction.Destroy;
Begin // Destroy
  // Note: This method only exists so I can check the Destroy's are kicking off at the right time
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TTransaction.GetIndexString (Index : IPPDLedgerTransactionListIndexEnum) : String;

  //------------------------------

  Function FormatString(Const TheString : String; Const ToLength : Integer) : String;
  Begin // FormatString
    Result := Copy (TheString + StringOfChar(' ', ToLength), 1, ToLength);
  End; // FormatString

  //------------------------------

  Function FormatDouble(Const TheDouble : Double) : String;
  Begin // FormatDouble
    Result := Format('%20.2f', [TheDouble]);
  End; // FormatDouble

  //------------------------------

Begin // GetIndexString
  Case Index Of
    // OurRef
    idxOurRef           : Result := FormatString(FTransaction.OurRef, 10);
    // YourRef
    idxYourRef          : Result := FormatString(FTransaction.YourRef, 20);
    // Transaction Date + Total Value + OurRef
    idxTransDate        : Result := FormatString(FTransaction.TransDate, 8) + FormatDouble(GetTotalValueInBase) + FormatString(FTransaction.OurRef, 10);
    // Total Value + OurRef
    idxTotalValue       : Result := FormatDouble(GetTotalValueInBase) + FormatString(FTransaction.OurRef, 10);
    // Outstanding Value + OurRef
    IdxOutstandingValue : Result := FormatDouble(GetOutstandingValueInBase) + FormatString(FTransaction.OurRef, 10);
  Else
    Result := '?';
  End; // Case Index
End; // GetIndexString

//-------------------------------------------------------------------------

Function TTransaction.GetTransaction : InvRec;
Begin // GetTransaction
  Result := FTransaction;
End; // GetTransaction

//------------------------------

Function TTransaction.GetCurrency : Byte;
Begin // GetCurrency
  Result := FTransaction.Currency
End; // GetCurrency

//------------------------------

Function TTransaction.GetOurRef : String;
Begin // GetOurRef
  Result := FTransaction.OurRef;
End; // GetOurRef

//------------------------------

Function TTransaction.GetTransactionDate : String;
Begin // GetTransactionDate
  Result := POutDate(FTransaction.TransDate);
End; // GetTransactionDate

//------------------------------

Function TTransaction.GetSettledValueInBase : Double;
Begin // GetSettledValueInBase
  Result := FTransaction.Settled
End; // GetSettledValueInBase

//------------------------------

Function TTransaction.GetOutstandingValueInBase : Double;
Begin // GetOutstandingValueInBase
  Result := BaseTotalOs(FTransaction)
End; // GetOutstandingValueInBase

//------------------------------

Function TTransaction.GetTotalValueInBase : Double;
Begin // GetTotalValueInBase
  Result := ConvCurrItotal(FTransaction, BOff, BOn, BOn) * DocCnst[FTransaction.InvDocHed] * DocNotCnst
End; // GetTotalValueInBase

//------------------------------

Function TTransaction.GetOriginalValueInCcy : Double;
Begin // GetOriginalValueInCcy
  Result := ITotal(FTransaction) * DocCnst[FTransaction.InvDocHed] * DocNotCnst
End; // GetOriginalValueInCcy

//------------------------------

Function TTransaction.GetYourRef : String;
Begin // GetYourRef
  Result := dbFormatSlash(FTransaction.YourRef, FTransaction.TransDesc)
End; // GetYourRef

//------------------------------

Function TTransaction.GetDateDue : String;
Begin // GetDateDue
  Result := POutDate(FTransaction.DueDate);
End; // GetDateDue

//------------------------------

Function TTransaction.GetStatus : String;
Begin // GetStatus
  Result := Disp_HoldPStat(FTransaction.HoldFlg, FTransaction.Tagged, FTransaction.PrintedDoc, BOff, FTransaction.OnPickRun);
End; // GetStatus

//------------------------------

Function TTransaction.GetPPDValueInCcy : Double;
Begin // GetPPDValueInCcy
  Result := Round_Up(FTransaction.thPPDGoodsValue + FTransaction.thPPDVATValue, 2);
End; // GetPPDValueInCcy

//------------------------------

Function TTransaction.GetPPDExpiry : String;
Begin // GetPPDExpiry
  Result := POutDate(CalcDueDate(FTransaction.TransDate, FTransaction.thPPDDays));
End; // GetPPDExpiry

//------------------------------

Function TTransaction.GetSelected : Boolean;
Begin // GetSelected
  Result := FSelected
End; // GetSelected
Procedure TTransaction.SetSelected (Value : Boolean);
Begin // SetSelected
  FSelected := Value;
End; // SetSelected

//=========================================================================

Constructor TPPDLedgerTransactionList.Create (Const AccountRec : CustRec);
Begin // Create
  Inherited Create;

  FAccountRec := AccountRec;

  FTransactions := TStringList.Create;
  FTransactions.Sorted := True;
End; // Create

//------------------------------

Destructor TPPDLedgerTransactionList.Destroy;
Begin // Destroy
  // Destroy transaction sub-objects and destroy list

  //PR: 11/06/2015 ABSEXCH-16525 separated destroying the list objects
  //into its own procedure, to allow this object to be re-used.
  ClearList;

  FTransactions.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TPPDLedgerTransactionList.GetCount : Integer;
Begin // GetCount
  Result := FTransactions.Count;
End; // GetCount

//------------------------------

Function TPPDLedgerTransactionList.GetIndex : IPPDLedgerTransactionListIndexEnum;
Begin // GetIndex
  Result := FIndex
End; // GetIndex
Procedure TPPDLedgerTransactionList.SetIndex (Value : IPPDLedgerTransactionListIndexEnum);
Var
  I : Integer;
Begin // SetIndex
  If (Value <> FIndex) Then
  Begin
    // Index changed
    FIndex := Value;

    // Update the index strings against each transaction and resort the list
    FTransactions.Sorted := False;
    Try
      For I := 0 To (FTransactions.Count - 1) Do
      Begin
        FTransactions.Strings[I] := TTransaction(FTransactions.Objects[I]).IndexString[FIndex];
      End; // For I
    Finally
      FTransactions.Sorted := True;
    End; // Try..Finally
  End; // If (Value <> FIndex)
End; // SetIndex

//------------------------------

Function TPPDLedgerTransactionList.GetTransactions (Index : Integer) : IPPDLedgerTransactionDetails;
Begin // GetTransactions
  If (Index >= 0) And (Index < FTransactions.Count) Then
    Result := TTransaction(FTransactions.Objects[Index])
  Else
    Raise Exception.Create('TPPDLedgerTransactionList.GetTransactions: Invalid Index (' + IntToStr(Index) + ' / ' + IntToStr(FTransactions.Count - 1) + ')');
End; // GetTransactions

//-------------------------------------------------------------------------

Procedure TPPDLedgerTransactionList.ProcessTransaction (Const Transaction : InvRec);
Var
  TransactionObj : TTransaction;
Begin // ProcessTransaction
     // Check it is a qualifying transaction type
  If (Transaction.InvDocHed In [SIN, SJI, PIN, PJI]) And
     // Check the Transaction is Outstanding
     (Transaction.AllocStat = FAccountRec.CustSupp) And
     // Check there is PPD Available on the transaction
     (
       ((Transaction.thPPDGoodsValue <> 0.0) Or (Transaction.thPPDVATValue <> 0.0))
       And
       // Hasn't already been taken
       (Transaction.thPPDTaken = ptPPDNotTaken)
       And
       // Transaction's Oustanding Value equals/exceeds the PPD Value - remove sign for purchases
       (ABS(CurrencyOS(Transaction, True {Round to 2dp}, False {Convert to Base}, False {UseCODay})) >= Round_Up(Transaction.thPPDGoodsValue + Transaction.thPPDVATValue, 2))
     ) Then
  Begin
    // Add the transaction into the list of PPD Qualifying Transactions for the PPD Ledger
    TransactionObj := TTransaction.Create(Transaction);
    FTransactions.AddObject(TransactionObj.IndexString[FIndex], TransactionObj);
  End; // If (Transaction.InvDocHed ...
End; // ProcessTransaction

//=========================================================================

Procedure TPPDLedgerTransactionListPerv.LoadTransactions (Var ExLocal : TdMTExLocal);
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LoadTransactions
  //PR: 11/06/2015 Clear the transaction list before loading/reloading
  ClearList;

  // Run through the account's transactions in the ledger
  sKey := FullCustType(FAccountRec.CustCode, FAccountRec.CustSupp) + Chr(1);
  iStatus := ExLocal.LFind_Rec(B_GetGEq, InvF, InvCustLedgK, sKey);
  While (iStatus = 0) And (ExLocal.LInv.CustCode = FAccountRec.CustCode) Do
  Begin
    // Pass to common ancestor for processing
    ProcessTransaction (ExLocal.LInv);

    iStatus := ExLocal.LFind_Rec(B_GetNext, InvF, InvCustLedgK, sKey);
  End; // While (iStatus = 0) And (ExLocal.LInv.CustCode = FAccountRec.CustCode)
End; // LoadTransactions

//=========================================================================

Procedure TPPDLedgerTransactionListSQL.LoadTransactions (Var ExLocal : TdMTExLocal);
Var
  Headers: TSQLSelectTransactions;
Begin // LoadTransactions
  //PR: 11/06/2015 Clear the transaction list before loading/reloading
  ClearList;

  Headers := TSQLSelectTransactions.Create;
  Try
    Headers.CompanyCode := GetCompanyCode(SetDrive);
    Headers.FromClause  := 'FROM [COMPANY].DOCUMENT';

    // Limit the data coming back as far as possible - too complex to check the outstanding value in the query
    Headers.WhereClause := 'WHERE (thAcCode = ' + QuotedStr(FAccountRec.CustCode) + ') ' +
                             'And (thOutstanding = ' + QuotedStr(FAccountRec.CustSupp) + ') ' +
                             'And (thDocType In (' + IntToStr(IfThen(FAccountRec.CustSupp = 'C', Ord(SIN), Ord(PIN))) + ', ' + IntToStr(IfThen(FAccountRec.CustSupp = 'C', Ord(SJI), Ord(PJI))) + ')) ' +
                             'And ((thPPDGoodsValue <> 0.0) Or (thPPDVATValue <> 0.0)) ' +
                             'And (thPPDTaken = ' + IntToStr(Ord(ptPPDNotTaken)) + ')';

    // Access using SQL navigation
    Headers.OpenFile;
    Headers.First;
    While (Not Headers.Eof) Do
    Begin
      // Pass to common ancestor for processing
      ProcessTransaction (Headers.ReadRecord);

      Headers.Next;
    End; // While (Not Headers.Eof)
  Finally
    Headers.Free;
  End; // Try..Finally
End; // LoadTransactions

//=========================================================================

//PR: 11/06/2015 ABSEXCH-16525 separated destroying the list objects into its own procedure
procedure TPPDLedgerTransactionList.ClearList;
Var
  TransactionObj : TTransaction;
begin
  While (FTransactions.Count > 0) Do
  Begin
    TransactionObj := TTransaction(FTransactions.Objects[0]);
    TransactionObj.ClearReference; // Resets reference to its own interface causing it to self-destruct as the reference count hits zero
    FTransactions.Delete(0);
  End; // While (FTransactions.Count > 0)
end;

End.
