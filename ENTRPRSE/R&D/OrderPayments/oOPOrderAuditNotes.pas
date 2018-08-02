Unit oOPOrderAuditNotes;

Interface

Uses SysUtils, GlobVar, VarConst, ExBtTH1U;

Type
  TOrderAuditNoteType = (antAuthorisation, antPayment, antRefund);

  //------------------------------

  // Class for writing Audit Notes back to Parent SOR when Payments and Refunds
  // are made through Order Payments
  IOPOrderAuditNotes = Interface
    ['{63D40204-3855-4B26-8328-E1AC7AD50E88}']
    // --- Internal Methods to implement Public Properties ---
    Function GetOperation : TOrderAuditNoteType;
    Procedure SetOperation (Value : TOrderAuditNoteType);
    Function GetOrderFolio : Integer;
    Procedure SetOrderFolio (Value : Integer);
    Function GetOrderOurRef : String;
    Procedure SetOrderOurRef (Value : String);
    Function GetTransactionOurRef : String;
    Procedure SetTransactionOurRef (Value : String);
    Function GetReceiptOurRef : String;
    Procedure SetReceiptOurRef (Value : String);
    Function GetReceiptValue : Double;
    Procedure SetReceiptValue (Value : Double);
    Function GetReceiptCurrency : Integer;
    Procedure SetReceiptCurrency (Value : Integer);
    Function GetCardAuthNo : String;
    Procedure SetCardAuthNo (Value : String);

    // ------------------ Public Properties ------------------
    // Type of operation causing the Audit Note
    Property anOperation : TOrderAuditNoteType Read GetOperation Write SetOperation;
    Property anOrderFolio : Integer Read GetOrderFolio Write SetOrderFolio;
    Property anOrderOurRef : String Read GetOrderOurRef Write SetOrderOurRef;
    Property anTransactionOurRef : String Read GetTransactionOurRef Write SetTransactionOurRef;
    Property anReceiptOurRef : String Read GetReceiptOurRef Write SetReceiptOurRef;
    Property anReceiptValue : Double Read GetReceiptValue Write SetReceiptValue;
    Property anReceiptCurrency : Integer Read GetReceiptCurrency Write SetReceiptCurrency;
    Property anCardAuthNo : String Read GetCardAuthNo Write SetCardAuthNo;

    // ------------------- Public Methods --------------------
    Function WriteAudit (Const ExLocal : TdPostExLocalPtr) : Integer;
  End; // IOPOrderAuditNotes

  //------------------------------

  Function NewOPOrderAuditNotes : IOPOrderAuditNotes;

Implementation

Uses AuditNotes,
     BTSupU1,           // GenRealMask
     FormatFloatFuncs;  // FormatCurFloat

Type
  TOPOrderAuditNotes = Class(TInterfacedObject, IOPOrderAuditNotes)
  Private
    FOperation : TOrderAuditNoteType;
    FOrderFolio : Integer;
    FOrderOurRef : String;
    FTransactionOurRef : String;
    FReceiptOurRef : String;
    FReceiptValue : Double;
    FReceiptCurrency : Integer;
    FCardAuthNo : String;
  Protected
    // IOPOrderAuditNotes
    Function GetOperation : TOrderAuditNoteType;
    Procedure SetOperation (Value : TOrderAuditNoteType);
    Function GetOrderFolio : Integer;
    Procedure SetOrderFolio (Value : Integer);
    Function GetOrderOurRef : String;
    Procedure SetOrderOurRef (Value : String);
    Function GetTransactionOurRef : String;
    Procedure SetTransactionOurRef (Value : String);
    Function GetReceiptOurRef : String;
    Procedure SetReceiptOurRef (Value : String);
    Function GetReceiptValue : Double;
    Procedure SetReceiptValue (Value : Double);
    Function GetReceiptCurrency : Integer;
    Procedure SetReceiptCurrency (Value : Integer);
    Function GetCardAuthNo : String;
    Procedure SetCardAuthNo (Value : String);

    Function WriteAudit (Const ExLocal : TdPostExLocalPtr) : Integer;
  Public
    Constructor Create;
  End; // TOPOrderAuditNotes

//=========================================================================

Function NewOPOrderAuditNotes : IOPOrderAuditNotes;
Begin // NewOPOrderAuditNotes
  Result := TOPOrderAuditNotes.Create;
End; // NewOPOrderAuditNotes

//=========================================================================

Constructor TOPOrderAuditNotes.Create;
Begin // Create
  Inherited Create;

  FOperation := antPayment;
  FOrderFolio := 0;
  FOrderOurRef := '';
  FTransactionOurRef := '';
  FReceiptOurRef := '';
  FReceiptValue := 0.0;
  FReceiptCurrency := 0;
  FCardAuthNo := '';
End; // Create

//-------------------------------------------------------------------------

Function TOPOrderAuditNotes.WriteAudit (Const ExLocal : TdPostExLocalPtr) : Integer;
Var
  oAuditNote : TAuditNote;

  //------------------------------

  Procedure AddNote (Const Text : String);
  Begin // AddNote
    If (Result = 0) Then
      Result := oAuditNote.AddCustomAuditNote(anTransaction, FOrderFolio, Text);
  End; // AddNote

  //------------------------------

Begin // WriteAudit
  Result := 0;

  oAuditNote := TAuditNote.Create(EntryRec.Login, @ExLocal.LocalF[PWrdF], ExLocal.ExClientId);
  Try
    Case FOperation Of
      // Card Authorisation by <..USER..> at HH:MM DD/MM/YYYY
      // Transaction: SORXXXXXX £12,345.67
      antAuthorisation : Begin
                           AddNote (Format('Card Authorisation by %s at %s', [Trim(EntryRec.Login), FormatDateTime('HH:MM DD/MM/YYYY', Now)]));
                           AddNote (Format('Transaction: %s %s', [FOrderOurRef, FormatCurFloat(GenRealMask, FReceiptValue, BOff, FReceiptCurrency)]));
                         End; // antAuthorisation

      // Payment against SORXXXXXX by <..USER..> at HH:MM DD/MM/YYYY
      // Payment: SRCXXXXXX £12,345.67
      // Card Auth No: 12345678901234567890
      antPayment       : Begin
                           AddNote (Format('Payment against %s by %s at %s', [FTransactionOurRef, Trim(EntryRec.Login), FormatDateTime('HH:MM DD/MM/YYYY', Now)]));
                           AddNote (Format('Payment: %s %s', [FReceiptOurRef, FormatCurFloat(GenRealMask, FReceiptValue, BOff, FReceiptCurrency)]));
                           If (FCardAuthNo <> '') Then
                             AddNote (Format('Card Auth No: %s', [FCardAuthNo]));
                         End; // antPayment

      //Refund against SRCXXXXXX by <..USER..> at HH:MM DD/MM/YYYY
      //Refund: SRCXXXXXX £12,345.67
      //Card Auth No: 12345678901234567890
      antRefund        : Begin
                           AddNote (Format('Refund against %s by %s at %s', [FTransactionOurRef, Trim(EntryRec.Login), FormatDateTime('HH:MM DD/MM/YYYY', Now)]));
                           AddNote (Format('Refund: %s %s', [FReceiptOurRef, FormatCurFloat(GenRealMask, FReceiptValue, BOff, FReceiptCurrency)]));
                           If (FCardAuthNo <> '') Then
                             AddNote (Format('Card Auth No: %s', [FCardAuthNo]));
                         End; // antRefund
    End; // Case FOperation
  Finally
    oAuditNote.Free;
  End; // Try..Finally
End; // WriteAudit

//-------------------------------------------------------------------------

Function TOPOrderAuditNotes.GetOperation : TOrderAuditNoteType;
Begin // GetOperation
  Result := FOperation;
End; // GetOperation
Procedure TOPOrderAuditNotes.SetOperation (Value : TOrderAuditNoteType);
Begin // SetOperation
  FOperation := Value;
End; // SetOperation

//------------------------------

Function TOPOrderAuditNotes.GetOrderFolio : Integer;
Begin // GetOrderFolio
  Result := FOrderFolio;
End; // GetOrderFolio
Procedure TOPOrderAuditNotes.SetOrderFolio (Value : Integer);
Begin // SetOrderFolio
  FOrderFolio := Value;
End; // SetOrderFolio

//------------------------------

Function TOPOrderAuditNotes.GetOrderOurRef : String;
Begin // GetOrderOurRef
  Result := FOrderOurRef;
End; // GetOrderOurRef
Procedure TOPOrderAuditNotes.SetOrderOurRef (Value : String);
Begin // SetOrderOurRef
  FOrderOurRef := Trim(Value);
End; // SetOrderOurRef

//------------------------------

Function TOPOrderAuditNotes.GetTransactionOurRef : String;
Begin // GetTransactionOurRef
  Result := FTransactionOurRef;
End; // GetTransactionOurRef
Procedure TOPOrderAuditNotes.SetTransactionOurRef (Value : String);
Begin // SetTransactionOurRef
  FTransactionOurRef := Trim(Value);
End; // SetTransactionOurRef

//------------------------------

Function TOPOrderAuditNotes.GetReceiptOurRef : String;
Begin // GetReceiptOurRef
  Result := FReceiptOurRef;
End; // GetReceiptOurRef
Procedure TOPOrderAuditNotes.SetReceiptOurRef (Value : String);
Begin // SetReceiptOurRef
  FReceiptOurRef := Trim(Value);
End; // SetReceiptOurRef

//------------------------------

Function TOPOrderAuditNotes.GetReceiptValue : Double;
Begin // GetReceiptValue
  Result := FReceiptValue;
End; // GetReceiptValue
Procedure TOPOrderAuditNotes.SetReceiptValue (Value : Double);
Begin // SetReceiptValue
  FReceiptValue := Value;
End; // SetReceiptValue

//------------------------------

Function TOPOrderAuditNotes.GetReceiptCurrency : Integer;
Begin // GetReceiptCurrency
  Result := FReceiptCurrency;
End; // GetReceiptCurrency
Procedure TOPOrderAuditNotes.SetReceiptCurrency (Value : Integer);
Begin // SetReceiptCurrency
  FReceiptCurrency := Value;
End; // SetReceiptCurrency

//------------------------------

Function TOPOrderAuditNotes.GetCardAuthNo : String;
Begin // GetCardAuthNo
  Result := FCardAuthNo;
End; // GetCardAuthNo
Procedure TOPOrderAuditNotes.SetCardAuthNo (Value : String);
Begin // SetCardAuthNo
  FCardAuthNo := Trim(Value);
End; // SetCardAuthNo

//=========================================================================

End.
