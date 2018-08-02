Unit SQLRep_FullTrialBalance_GLHeadingCache;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses Classes;

Type
  IFullTrialBalanceGLHeaderDetails = Interface
    ['{BDA3413A-0269-42F1-B6E9-6AC8A4D7AC7A}']
    // --- Internal Methods to implement Public Properties ---
    Function GetGLCode : LongInt;
    Function GetGLDescription : ShortString;
    Function GetPeriodCreditValue : Real48;
    Function GetPeriodDebitValue : Real48;
    Function GetPeriodBudget : Real48;
    Function GetPeriodVariance : Real48;
    Function GetYTDCreditValue : Real48;
    Function GetYTDDebitValue : Real48;
    Function GetGLLevel : LongInt;

    // ------------------ Public Properties ------------------
    Property hcGLCode : LongInt Read GetGLCode;
    Property hcGLDescription : ShortString Read GetGLDescription;
    Property hcPeriodCreditValue : Real48 Read GetPeriodCreditValue;
    Property hcPeriodDebitValue : Real48 Read GetPeriodDebitValue;
    Property hcPeriodBudget : Real48 Read GetPeriodBudget;
    Property hcPeriodVariance : Real48 Read GetPeriodVariance;
    Property hcYTDCreditValue : Real48 Read GetYTDCreditValue;
    Property hcYTDDebitValue : Real48 Read GetYTDDebitValue;
    Property hcGLLevel : LongInt Read GetGLLevel;

    // ------------------- Public Methods --------------------
    // Called to include the values from the artificial P&L A/C (Curr Year) line within the heading totals
    Procedure IncludePandLACCurrYearValues (Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48);
  End; // IFullTrialBalanceGLHeaderDetails

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IFullTrialBalanceGLHeaderCache = Interface
    ['{308597A3-51A2-4809-8744-D79463DFF20D}']
    // --- Internal Methods to implement Public Properties ---
    Function GetGLHeadings (Index : Integer) : IFullTrialBalanceGLHeaderDetails;

    // ------------------ Public Properties ------------------
    Property GLHeadings [Index : Integer] : IFullTrialBalanceGLHeaderDetails Read GetGLHeadings;

    // ------------------- Public Methods --------------------
    Procedure AddToCache (Const GLCode : LongInt;
                          Const GLDesc : ShortString;
                          Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48;
                          Const GLLevel : LongInt);

    // Returns the index of the specified GL Code in the cache, returns -1 if not found
    Function IndexOf (Const GLCode : LongInt) : LongInt;
  End; // IFullTrialBalanceGLHeaderCache


// Returns a new instance of the Full Trial Balance Report GL Header Cache
Function GetGLHeaderCache : IFullTrialBalanceGLHeaderCache;

Implementation

Uses SysUtils, DebitCreditClass;

Type
  TFullTrialBalanceGLHeaderDetails = Class(TInterfacedObject, IFullTrialBalanceGLHeaderDetails)
  Private
    FGLCode : LongInt;
    FGLDesc : ShortString;
    FGLPeriodBudget : Double;
    FGLPeriodVariance : Double;
    FGLLevel : LongInt;

    DCPeriodValue, DCYTDValue : IDebitCredit;

    // IFullTrialBalanceGLHeaderDetails
    Function GetGLCode : LongInt;
    Function GetGLDescription : ShortString;
    Function GetPeriodCreditValue : Real48;
    Function GetPeriodDebitValue : Real48;
    Function GetPeriodBudget : Real48;
    Function GetPeriodVariance : Real48;
    Function GetYTDCreditValue : Real48;
    Function GetYTDDebitValue : Real48;
    Function GetGLLevel : LongInt;

    // Called to include the values from the artificial P&L A/C (Curr Year) line within the heading totals
    Procedure IncludePandLACCurrYearValues (Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48);
  Public
    Constructor Create (Const GLCode : LongInt;
                        Const GLDesc : ShortString;
                        Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48;
                        Const GLLevel : LongInt);
    Destructor Destroy; Override;
  End; // TFullTrialBalanceGLHeaderDetails

  //------------------------------

  TFullTrialBalanceGLHeaderCache = Class(TInterfacedObject, IFullTrialBalanceGLHeaderCache)
  Private
    FGLCodes : TInterfaceList;

    // IFullTrialBalanceGLHeaderCache
    Function GetGLHeadings (Index : Integer) : IFullTrialBalanceGLHeaderDetails;

    Procedure AddToCache (Const GLCode : LongInt;
                          Const GLDesc : ShortString;
                          Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48;
                          Const GLLevel : LongInt);

    // Returns the index of the specified GL Code in the cache, returns -1 if not found
    Function IndexOf (Const GLCode : LongInt) : LongInt;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TFullTrialBalanceGLHeaderCache

//=========================================================================

// Returns a new instance of the Full Trial Balance Report GL Header Cache
Function GetGLHeaderCache : IFullTrialBalanceGLHeaderCache;
Begin // GetGLHeaderCache
  Result := TFullTrialBalanceGLHeaderCache.Create;
End; // GetGLHeaderCache

//=========================================================================

Constructor TFullTrialBalanceGLHeaderCache.Create;
Begin // Create
  Inherited Create;
  FGLCodes := TInterfaceList.Create;
End; // Create

//------------------------------

Destructor TFullTrialBalanceGLHeaderCache.Destroy;
Begin // Destroy
  FGLCodes.Clear;
  FGLCodes.Destroy;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TFullTrialBalanceGLHeaderCache.AddToCache (Const GLCode : LongInt;
                                                     Const GLDesc : ShortString;
                                                     Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48;
                                                     Const GLLevel : LongInt);
Begin // AddToCache
  FGLCodes.Add (TFullTrialBalanceGLHeaderDetails.Create (GLCode, GLDesc, GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue, GLLevel));
End; // AddToCache

//-------------------------------------------------------------------------

// Returns the index of the specified GL Code in the cache, returns -1 if not found
Function TFullTrialBalanceGLHeaderCache.IndexOf (Const GLCode : LongInt) : LongInt;
Var
  I : Integer;
Begin // IndexOf
  Result := -1;
  For I := 0 To (FGLCodes.Count - 1) Do
  Begin
    If ((FGLCodes[I] As IFullTrialBalanceGLHeaderDetails).hcGLCode = GLCode) Then
    Begin
      Result := I;
      Break;
    End; // If ((FGLCodes[I] As IFullTrialBalanceGLHeaderDetails).hcGLCode = GLCode)
  End; // For I
End; // IndexOf

//-------------------------------------------------------------------------

Function TFullTrialBalanceGLHeaderCache.GetGLHeadings (Index : Integer) : IFullTrialBalanceGLHeaderDetails;
Begin // GetGLHeadings
  If (Index >= 0) And (Index < FGLCodes.Count) Then
    Result := FGLCodes[Index] As IFullTrialBalanceGLHeaderDetails
  Else
    Raise ERangeError.Create ('TFullTrialBalanceGLHeaderCache.GetGLHeadings: Invalid Index (' + IntToStr(Index) + ')');
End; // GetGLHeadings

//=========================================================================

Constructor TFullTrialBalanceGLHeaderDetails.Create (Const GLCode : LongInt;
                                                     Const GLDesc : ShortString;
                                                     Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48;
                                                     Const GLLevel : LongInt);
Begin // Create
  Inherited Create;

  FGLCode := GLCode;
  FGLDesc := GLDesc;
  FGLPeriodBudget := GLPeriodBudget;
  FGLPeriodVariance := GLPeriodVariance;
  FGLLevel := GLLevel;

  DCPeriodValue := DebitCredit(GLPeriodValue);
  DCYTDValue := DebitCredit(GLYTDValue);
End; // Create

//------------------------------

Destructor TFullTrialBalanceGLHeaderDetails.Destroy;
Begin // Destroy
  DCPeriodValue := NIL;
  DCYTDValue := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called to include the values from the artificial P&L A/C (Curr Year) line within the heading totals
Procedure TFullTrialBalanceGLHeaderDetails.IncludePandLACCurrYearValues (Const GLPeriodValue, GLPeriodBudget, GLPeriodVariance, GLYTDValue : Real48);
Begin // IncludePandLACCurrYearValues
  DCPeriodValue.Value := DCPeriodValue.Value + GLPeriodValue;
  FGLPeriodBudget := FGLPeriodBudget + GLPeriodBudget;
  FGLPeriodVariance := FGLPeriodVariance + GLPeriodVariance;
  DCYTDValue.Value := DCYTDValue.Value + GLYTDValue;
End; // IncludePandLACCurrYearValues

//-------------------------------------------------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetGLCode : LongInt;
Begin // GetGLCode
  Result := FGLCode;
End; // GetGLCode

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetGLDescription : ShortString;
Begin // GetGLDescription
  Result := FGLDesc;
End; // GetGLDescription

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetPeriodCreditValue : Real48;
Begin // GetPeriodCreditValue
  Result := DCPeriodValue.Credits;
End; // GetPeriodCreditValue

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetPeriodDebitValue : Real48;
Begin // GetPeriodDebitValue
  Result := DCPeriodValue.Debits;
End; // GetPeriodDebitValue

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetPeriodBudget : Real48;
Begin // GetPeriodBudget
  Result := FGLPeriodBudget;
End; // GetPeriodBudget

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetPeriodVariance : Real48;
Begin // GetPeriodVariance
  Result := FGLPeriodVariance;
End; // GetPeriodVariance

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetYTDCreditValue : Real48;
Begin // GetYTDCreditValue
  Result := DCYTDValue.Credits;
End; // GetYTDCreditValue

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetYTDDebitValue : Real48;
Begin // GetYTDDebitValue
  Result := DCYTDValue.Debits;
End; // GetYTDDebitValue

//------------------------------

Function TFullTrialBalanceGLHeaderDetails.GetGLLevel : LongInt;
Begin // GetGLLevel
  Result := FGLLevel;
End; // GetGLLevel

//=========================================================================

End.