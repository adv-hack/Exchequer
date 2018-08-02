Unit SQLRep_FullTrialBalance_CarryFwdManager;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses Classes;

Type
  IFullTrialBalanceCarryForwardDetails = Interface
    ['{39FD057A-FAEB-4861-9CE5-0363B706FA55}']
    // --- Internal Methods to implement Public Properties ---
    Function GetGLCode : LongInt;
    Function GetDescription : ShortString;
    Function GetCarryForwardTo : LongInt;
    Function GetCarryForwardLevel : LongInt;
    Function GetPeriodCreditValue : Double;
    Function GetPeriodDebitValue : Double;
    Function GetPeriodBudget : Double;
    Function GetPeriodVariance : Double;
    Function GetYTDCreditValue : Double;
    Function GetYTDDebitValue : Double;

    // ------------------ Public Properties ------------------
    Property cfdGLCode : LongInt Read GetGLCode;
    Property cfdDescription : ShortString Read GetDescription;
    Property cfdCarryForwardTo : LongInt Read GetCarryForwardTo;
    Property cfdCarryForwardLevel : LongInt Read GetCarryForwardLevel;
    Property cfdPeriodCreditValue : Double Read GetPeriodCreditValue;
    Property cfdPeriodDebitValue : Double Read GetPeriodDebitValue;
    Property cfdPeriodBudget : Double Read GetPeriodBudget;
    Property cfdPeriodVariance : Double Read GetPeriodVariance;
    Property cfdYTDCreditValue : Double Read GetYTDCreditValue;
    Property cfdYTDDebitValue : Double Read GetYTDDebitValue;
  End; // IFullTrialBalanceCarryForwardDetails

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IFullTrialBalanceCarryForwardManager = Interface
    ['{E1F711A7-B9C3-4DE5-804D-CA7AA8B4BB3C}']
    // --- Internal Methods to implement Public Properties ---
    Function GetPeriodValue : Double;
    Procedure SetPeriodValue (Value : Double);
    Function GetPeriodBudget : Double;
    Procedure SetPeriodBudget (Value : Double);
    Function GetYTDValue : Double;
    Procedure SetYTDValue (Value : Double);
    Function GetCarryForwardCount : Integer;
    Function GetCarryForwards (Index : Integer) : IFullTrialBalanceCarryForwardDetails;

    // ------------------ Public Properties ------------------
    Property cfmPeriodValue : Double Read GetPeriodValue Write SetPeriodValue;
    Property cfmPeriodBudget : Double Read GetPeriodBudget Write SetPeriodBudget;
    Property cfmYTDValue : Double Read GetYTDValue Write SetYTDValue;

    Property cfmCarryForwardCount : Integer Read GetCarryForwardCount;
    Property cfmCarryForwards [Index : Integer] : IFullTrialBalanceCarryForwardDetails Read GetCarryForwards;

    // ------------------- Public Methods --------------------
    Procedure AddCarryForward (Const CarryFwdGLCode : LongInt; Const CarryFwdDesc : ShortString; Const CarryForwardTo : LongInt; Const CarryForwardLevel : LongInt; Const IncludeZeroBalances : Boolean);

    // Returns TRUE if there are any Carry Forwards to the supplied GL Code
    Function HasCarryForwards (Const ToGLCode : LongInt) : Boolean;
  End; // IFullTrialBalanceCarryForwardManager


// Returns a new instance of the Full Trial Balance Carry Forward Manager
Function GetCarryForwardManager : IFullTrialBalanceCarryForwardManager;

Implementation

Uses SysUtils, DebitCreditClass;

Type
  TFullTrialBalanceCarryForwardDetails = Class(TInterfacedObject, IFullTrialBalanceCarryForwardDetails)
  Private
    FCarryForwardGLCode : LongInt;
    FDescription : ShortString;
    FCarryForwardTo : LongInt;
    FPeriodBudget : Double;
    FPeriodVariance : Double;
    FCarryForwardLevel : LongInt;

    DCPeriodValue, DCYTDValue : IDebitCredit;

    // IFullTrialBalanceCarryForwardDetails
    Function GetGLCode : LongInt;
    Function GetDescription : ShortString;
    Function GetCarryForwardTo : LongInt;
    Function GetCarryForwardLevel : LongInt;
    Function GetPeriodCreditValue : Double;
    Function GetPeriodDebitValue : Double;
    Function GetPeriodBudget : Double;
    Function GetPeriodVariance : Double;
    Function GetYTDCreditValue : Double;
    Function GetYTDDebitValue : Double;
  Public
    Constructor Create (Const CarryFwdGLCode : LongInt;
                        Const CarryFwdDesc : ShortString;
                        Const CarryForwardTo : LongInt;
                        Const CarryForwardLevel : LongInt;
                        Const CFwdPeriodValue, CFwdPeriodBudget, CFwdYTDValue : Double);
    Destructor Destroy; Override;
  End; // TFullTrialBalanceCarryForwardDetails

  //------------------------------

  TFullTrialBalanceCarryForwardManager = Class(TInterfacedObject, IFullTrialBalanceCarryForwardManager)
  Private
    FCarryForwards : TInterfaceList;
    FPeriodValue : Double;
    FPeriodBudget : Double;
    FYTDValue : Double;

    Procedure InitRunningTotals;

    // IFullTrialBalanceCarryForwardManager
    Function GetPeriodValue : Double;
    Procedure SetPeriodValue (Value : Double);
    Function GetPeriodBudget : Double;
    Procedure SetPeriodBudget (Value : Double);
    Function GetYTDValue : Double;
    Procedure SetYTDValue (Value : Double);

    Function GetCarryForwardCount : Integer;
    Function GetCarryForwards (Index : Integer) : IFullTrialBalanceCarryForwardDetails;

    Procedure AddCarryForward (Const CarryFwdGLCode : LongInt;
                               Const CarryFwdDesc : ShortString;
                               Const CarryForwardTo : LongInt;
                               Const CarryForwardLevel : LongInt;
                               Const IncludeZeroBalances : Boolean);
    // Returns TRUE if there are any Carry Forwards to the supplied GL Code
    Function HasCarryForwards (Const ToGLCode : LongInt) : Boolean;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TFullTrialBalanceCarryForwardManager

//=========================================================================

// Returns a new instance of the Full Trial Balance Carry Forward Manager
Function GetCarryForwardManager : IFullTrialBalanceCarryForwardManager;
Begin // GetCarryForwardManager
  Result := TFullTrialBalanceCarryForwardManager.Create;
End; // GetCarryForwardManager

//=========================================================================

Constructor TFullTrialBalanceCarryForwardManager.Create;
Begin // Create
  Inherited Create;
  FCarryForwards := TInterfaceList.Create;
  InitRunningTotals;
End; // Create

//------------------------------

Destructor TFullTrialBalanceCarryForwardManager.Destroy;
Begin // Destroy
  FCarryForwards.Clear;
  FCarryForwards.Destroy;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TFullTrialBalanceCarryForwardManager.InitRunningTotals;
Begin // InitRunningTotals
  FPeriodValue := 0.0;
  FPeriodBudget := 0.0;
  FYTDValue := 0.0;
End; // InitRunningTotals

//-------------------------------------------------------------------------

Procedure TFullTrialBalanceCarryForwardManager.AddCarryForward (Const CarryFwdGLCode : LongInt;
                                                                Const CarryFwdDesc : ShortString;
                                                                Const CarryForwardTo : LongInt;
                                                                Const CarryForwardLevel : LongInt;
                                                                Const IncludeZeroBalances : Boolean);
Begin // AddCarryForward
  // Add Carry Forward details into list for later reference and reset the running totals
  If (FPeriodValue <> 0.0) Or (FPeriodBudget <> 0.0) Or (FYTDValue <> 0.0) Or IncludeZeroBalances Then
  Begin
    FCarryForwards.Add(TFullTrialBalanceCarryForwardDetails.Create(CarryFwdGLCode, CarryFwdDesc, CarryForwardTo, CarryForwardLevel, FPeriodValue, FPeriodBudget, FYTDValue));
    InitRunningTotals;
  End; // If (FPeriodValue <> 0.0) Or (FPeriodBudget <> 0.0) Or (FYTDValue <> 0.0)
End; // AddCarryForward

//-------------------------------------------------------------------------

// Returns TRUE if there are any Carry Forwards to the supplied GL Code
Function TFullTrialBalanceCarryForwardManager.HasCarryForwards (Const ToGLCode : LongInt) : Boolean;
Var
  I : SmallInt;
Begin // HasCarryForwards
  Result := False;
  For I := 0 To (FCarryForwards.Count - 1) Do
  Begin
    If (GetCarryForwards(I).cfdCarryForwardTo = ToGLCode) Then
    Begin
      Result := True;
      Break;
    End; // If (GetCarryForwards(I).cfdCarryForwardTo = ToGLCode)
  End; // For I
End; // HasCarryForwards

//-------------------------------------------------------------------------

Function TFullTrialBalanceCarryForwardManager.GetCarryForwardCount : Integer;
Begin // GetCarryForwardCount
  Result := FCarryForwards.Count;
End; // GetCarryForwardCount

//------------------------------

Function TFullTrialBalanceCarryForwardManager.GetCarryForwards (Index : Integer) : IFullTrialBalanceCarryForwardDetails;
Begin // GetCarryForwards
  If (Index >= 0) And (Index < FCarryForwards.Count) Then
    Result := FCarryForwards[Index] As IFullTrialBalanceCarryForwardDetails
  Else
    Raise ERangeError.Create ('TFullTrialBalanceCarryForwardManager.GetCarryForwards: Invalid Index (' + IntToStr(Index) + ')');
End; // GetCarryForwards

//------------------------------

Function TFullTrialBalanceCarryForwardManager.GetPeriodValue : Double;
Begin // GetPeriodValue
  Result := FPeriodValue;
End; // GetPeriodValue
Procedure TFullTrialBalanceCarryForwardManager.SetPeriodValue (Value : Double);
Begin // SetPeriodValue
  FPeriodValue := Value;
End; // SetPeriodValue

//------------------------------

Function TFullTrialBalanceCarryForwardManager.GetPeriodBudget : Double;
Begin // GetPeriodBudget
  Result := FPeriodBudget;
End; // GetPeriodBudget
Procedure TFullTrialBalanceCarryForwardManager.SetPeriodBudget (Value : Double);
Begin // SetPeriodBudget
  FPeriodBudget := Value;
End; // SetPeriodBudget

//------------------------------

Function TFullTrialBalanceCarryForwardManager.GetYTDValue : Double;
Begin // GetYTDValue
  Result := FYTDValue;
End; // GetYTDValue
Procedure TFullTrialBalanceCarryForwardManager.SetYTDValue (Value : Double);
Begin // SetYTDValue
  FYTDValue := Value;
End; // SetYTDValue

//=========================================================================

Constructor TFullTrialBalanceCarryForwardDetails.Create (Const CarryFwdGLCode : LongInt;
                                                         Const CarryFwdDesc : ShortString;
                                                         Const CarryForwardTo : LongInt;
                                                         Const CarryForwardLevel : LongInt;
                                                         Const CFwdPeriodValue, CFwdPeriodBudget, CFwdYTDValue : Double);
Begin // Create
  Inherited Create;

  FCarryForwardGLCode := CarryFwdGLCode;
  FDescription := CarryFwdDesc;
  FCarryForwardTo := CarryForwardTo;
  FCarryForwardLevel := CarryForwardLevel;

  FPeriodBudget := CFwdPeriodBudget;

  DCPeriodValue := DebitCredit(CFwdPeriodValue);
  DCYTDValue := DebitCredit(CFwdYTDValue);

  // If the total budget is set then recalculate the vaiance from the totals - otherwise it won't
  // correctly reflect the variance for items with no budget set
  If (FPeriodBudget <> 0.0) Then
    FPeriodVariance := DCPeriodValue.Debits - DCPeriodValue.Credits - FPeriodBudget
  Else
    FPeriodVariance := 0.0;
End; // Create

//------------------------------

Destructor TFullTrialBalanceCarryForwardDetails.Destroy;
Begin // Destroy
  DCPeriodValue := NIL;
  DCYTDValue := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetGLCode : LongInt;
Begin // GetGLCode
  Result := FCarryForwardGLCode;
End; // GetGLCode

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetDescription : ShortString;
Begin // GetDescription
  Result := FDescription;
End; // GetDescription

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetCarryForwardTo : LongInt;
Begin // GetCarryForwardTo
  Result := FCarryForwardTo;
End; // GetCarryForwardTo

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetCarryForwardLevel : LongInt;
Begin // GetCarryForwardLevel
  Result := FCarryForwardLevel;
End; // GetCarryForwardLevel

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetPeriodCreditValue : Double;
Begin // GetPeriodCreditValue
  Result := DCPeriodValue.Credits;
End; // GetPeriodCreditValue

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetPeriodDebitValue : Double;
Begin // GetPeriodDebitValue
  Result := DCPeriodValue.Debits;
End; // GetPeriodDebitValue

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetPeriodBudget : Double;
Begin // GetPeriodBudget
  Result := FPeriodBudget;
End; // GetPeriodBudget

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetPeriodVariance : Double;
Begin // GetPeriodVariance
  Result := FPeriodVariance;
End; // GetPeriodVariance

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetYTDCreditValue : Double;
Begin // GetYTDCreditValue
  Result := DCYTDValue.Credits;
End; // GetYTDCreditValue

//------------------------------

Function TFullTrialBalanceCarryForwardDetails.GetYTDDebitValue : Double;
Begin // GetYTDDebitValue
  Result := DCYTDValue.Debits;
End; // GetYTDDebitValue

//=========================================================================

End.