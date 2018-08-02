Unit DebitCreditClass;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Type
  // Generic interface for objects which implement a specific import type
  IDebitCredit = Interface
    ['{5873289B-7423-47CA-9186-275FCFF0DA2C}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCredits : Double;
    Function GetDebits : Double;
    Function GetValue : Double;
    Procedure SetValue (Value : Double);

    // ------------------ Public Properties ------------------
    Property Credits : Double Read GetCredits;
    Property Debits : Double Read GetDebits;
    Property Value : Double Read GetValue Write SetValue;
  End; // IDebitCredit

  //------------------------------

  // Debit/Credit interface using Real48 data types for legacy calculations
  IDebitCreditReal48 = Interface
    ['{5873289B-7423-47CA-9186-275FCFF0DA2C}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCredits : Real48;
    Function GetDebits : Real48;
    Function GetValue : Real48;
    Procedure SetValue (Value : Real48);

    // ------------------ Public Properties ------------------
    Property Credits : Real48 Read GetCredits;
    Property Debits : Real48 Read GetDebits;
    Property Value : Real48 Read GetValue Write SetValue;
  End; // IDebitCreditReal48

// Returns a new instance of the Debit/Credit utility object
Function DebitCredit (Const Value : Double) : IDebitCredit;

// Returns a new instance of the Debit/Credit utility object using legacy Real48 data types
Function DebitCreditReal48 (Const Value : Real48) : IDebitCreditReal48;

Implementation

Type
  TDebitCredit = Class(TInterfacedObject, IDebitCredit)
  Private
    FValue : Double;

    // IDebitCredit
    Function GetCredits : Double;
    Function GetDebits : Double;
    Function GetValue : Double;
    Procedure SetValue (Value : Double);
  Public
    Constructor Create (Const Value : Double);
  End; // TDebitCredit

  //------------------------------

  TDebitCreditReal48 = Class(TInterfacedObject, IDebitCreditReal48)
  Private
    FValue : Real48;

    // IDebitCredit
    Function GetCredits : Real48;
    Function GetDebits : Real48;
    Function GetValue : Real48;
    Procedure SetValue (Value : Real48);
  Public
    Constructor Create (Const Value : Real48);
  End; // TDebitCreditReal48

//=========================================================================

// Returns a new instance of the Debit/Credit utility object
Function DebitCredit (Const Value : Double) : IDebitCredit;
Begin // GetCarryForwardManager
  Result := TDebitCredit.Create(Value);
End; // GetCarryForwardManager

//=========================================================================

Constructor TDebitCredit.Create (Const Value : Double);
Begin // Create
  Inherited Create;
  FValue := Value;
End; // Create

//-------------------------------------------------------------------------

Function TDebitCredit.GetCredits : Double;
Begin // GetCredits
  If (FValue < 0) Then
    Result := ABS(FValue)
  Else
    Result := 0.0;
End; // GetCredits

//------------------------------

Function TDebitCredit.GetDebits : Double;
Begin // GetDebits
  If (FValue > 0) Then
    Result := ABS(FValue)
  Else
    Result := 0.0;
End; // GetDebits

//------------------------------

Function TDebitCredit.GetValue : Double;
Begin // GetValue
  Result := FValue;
End; // GetValue
Procedure TDebitCredit.SetValue (Value : Double);
Begin // SetValue
  FValue := Value;
End; // SetValue

//=========================================================================

// Returns a new instance of the Debit/Credit utility object using legacy Real48 data types
Function DebitCreditReal48 (Const Value : Real48) : IDebitCreditReal48;
Begin // DebitCreditReal48
  Result := TDebitCreditReal48.Create(Value);
End; // DebitCreditReal48

//=========================================================================

Constructor TDebitCreditReal48.Create (Const Value : Real48);
Begin // Create
  Inherited Create;
  FValue := Value;
End; // Create

//-------------------------------------------------------------------------

Function TDebitCreditReal48.GetCredits : Real48;
Begin // GetCredits
  If (FValue < 0) Then
    Result := ABS(FValue)
  Else
    Result := 0.0;
End; // GetCredits

//------------------------------

Function TDebitCreditReal48.GetDebits : Real48;
Begin // GetDebits
  If (FValue > 0) Then
    Result := ABS(FValue)
  Else
    Result := 0.0;
End; // GetDebits

//------------------------------

Function TDebitCreditReal48.GetValue : Real48;
Begin // GetValue
  Result := FValue;
End; // GetValue
Procedure TDebitCreditReal48.SetValue (Value : Real48);
Begin // SetValue
  FValue := Value;
End; // SetValue

//=========================================================================

End.