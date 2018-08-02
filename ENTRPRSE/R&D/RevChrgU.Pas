Unit RevChrgU;

Interface

Uses GlobVar, VarConst;

//
// Reverse Charge Utility Functions
//

Const
  RevChargeDocSet = [PPI, PIN, PCR, PJI, PJC, PRF, PQU, POR, PDN];

Type
  TRCServicesVATCode = Class(TObject)
  Private
    FVATCode : Char;
    FUsed : Boolean;
    FServices : Boolean;
    FServicesValue : Double;
    FServicesTax : Double;
  Public
    Constructor Create (Const VATCode : Char);

    Procedure ProcessServiceLine (Const RCTrans : InvRec; Const RCLine : IDetail; Const LineTotal : Double);

    Property rcvVATCode : Char Read FVATCode;
    Property rcvUsed : Boolean Read FUsed;
    Property rcvServices : Boolean Read FServices;
    Property rcvServicesValue : Double Read FServicesValue;
    Property rcvServicesTax : Double Read FServicesTax;
  End; // TRCServicesVATCode

  //------------------------------

  TRCServicesHelper = Class(TObject)
  Private
    FRCTrans : InvRec;
    FVatDetails : Array [VATType] Of TRCServicesVATCode;
    Function GetVATDetails (Index : Char) : TRCServicesVATCode;
  Public
    Constructor Create (Const RCTrans : InvRec);
    Destructor Destroy; Override;

    Procedure ProcessServiceLine (Const RCLine : IDetail; Const LineTotal : Double);

    Property VATDetails [Index : Char] : TRCServicesVATCode Read GetVATDetails;
  End; // TRCServicesHelper


// Returns True if the Purchase Reverse Charge process should be performed
Function DoReverseCharge : Boolean; Overload;

// Returns True if the Purchase Reverse Charge process should be performed for this transaction
Function DoReverseCharge (Const RCTrans : InvRec) : Boolean; Overload;

// Returns True if the Purchase Reverse Charge process should be performed for this transaction
Function DoReverseCharge (Const RCTrans : InvRec; Const RCLine : IDetail) : Boolean; Overload;


Implementation

Uses ComnUnit, SysUtils, ETMiscU, CurrncyU, VarRec2U;

//=========================================================================

// Returns True if the Purchase Reverse Charge process should be performed
Function DoReverseCharge : Boolean;
Begin // DoReverseCharge
  // CJS 2014-09-10 - ABSEXCH-15516 - include EC Services in notional VAT -
  // for Ireland only, Goods and Services are now treated the same, so remove
  // Ireland from the Reverse Charge check.

  // CJS 2014-03-04 - ABSEXCH-15109 - Reverse Charge on Irish VAT Return
  // Conditions:-
  //   (1) UK or Irish Company
  //   (2) Invoice Accounting
  //   (3) EC Services enabled
  Result := (CurrentCountry = UKCcode) And
            (Not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) And
            SyssVAT.VATRates.EnableECServices;
End; // DoReverseCharge

//-------------------------------------------------------------------------

// Returns True if the Purchase Reverse Charge process should be performed for this transaction
Function DoReverseCharge (Const RCTrans : InvRec) : Boolean;
Begin // DoReverseCharge
  Result := DoReverseCharge;
  If Result Then
  Begin
    Result := (RCTrans.InvDocHed In RevChargeDocSet) And
              // MH 04/01/2010: Modified to handle systems with Intrastat turned off
              ((RCTrans.SSDProcess = ' ') Or ((Not Syss.IntraStat) And (RCTrans.SSDProcess = #0)));
  End; // If Result
End; // DoReverseCharge

//-------------------------------------------------------------------------

// Returns True if the Purchase Reverse Charge process should be performed for this transaction
Function DoReverseCharge (Const RCTrans : InvRec; Const RCLine : IDetail) : Boolean;
Begin // DoReverseCharge
  Result := DoReverseCharge(RCTrans);
  If Result Then
  Begin
    Result := RCLine.ECService;
  End; // If Result
End; // DoReverseCharge

//=========================================================================

Constructor TRCServicesVATCode.Create;
Begin // Create
  Inherited Create;

  FVATCode := VATCode;
  FUsed := False;
  FServices := False;
  FServicesValue := 0.0;
  FServicesTax := 0.0;
End; // Create

//-------------------------------------------------------------------------

Procedure TRCServicesVATCode.ProcessServiceLine (Const RCTrans : InvRec; Const RCLine : IDetail; Const LineTotal : Double);
Var
  GoodsRate : CurrTypes;
Begin // ProcessServiceLine
  If (RCLine.VATCode = FVATCode) Then
  Begin
    FUsed := True;

    If RCLine.ECService Then
    Begin
      FServices := True;

      With RCTrans Do
      Begin
        // Values must be converted to VAT Currency for reporting
        GoodsRate := OrigRates;
        If (OldORates[BOff]<>0.0) then {* We have been through a conversion, and this needs to be stated in original currency*}
          GoodsRate := OldORates;

        FServicesValue := FServicesValue + Round_Up((Conv_VATCurr(LineTotal, VATCRate[UseCoDayRate], XRate(GoodsRate,BOff,Currency), Currency,UseORate) * DocCnst[InvDocHed]) * DocNotCnst, 2);

        FServicesTax := FServicesTax + Round_Up(Conv_VATCurr(RCLine.PurchaseServiceTax, VATCRate[BOn], Calc_BConvCXRate(RCTrans,CXRate[BOn],BOn),Currency,UseORate)* DocCnst[InvDocHed]*DocNotCnst,2);
      End; // With RCTrans
    End; // If RCLine.ECService
  End // If (RCLine.VATCode = FVATCode)
  Else
    Raise Exception.Create ('TRCServicesVATCode.ProcessServiceLine: Invalid VAT Code, ''' + RCLine.VATCode +  ''' received, ''' + FVATCode + ''' expected');
End; // ProcessServiceLine

//=========================================================================

Constructor TRCServicesHelper.Create (Const RCTrans : InvRec);
Var
  VType : VATType;
Begin // Create
  Inherited Create;

  FRCTrans := RCTrans;

  // Create the individual VAT Code Detail objects
  For VType := Low(VATType) To High(VATType) Do
    FVatDetails[VType] := TRCServicesVATCode.Create(SyssVat^.VATRates.VAT[VType].Code);
End; // Create

//------------------------------

Destructor TRCServicesHelper.Destroy;
Var
  VType : VATType;
Begin // Destroy
  For VType := Low(VATType) To High(VATType) Do
    FreeAndNIL(FVatDetails[VType]);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TRCServicesHelper.ProcessServiceLine (Const RCLine : IDetail; Const LineTotal : Double);
Var
  oVATCode : TRCServicesVATCode;
Begin // ProcessServiceLine
  oVATCode := GetVATDetails (RCLine.VATCode);
  oVATCode.ProcessServiceLine (FRCTrans, RCLine, LineTotal);
End; // ProcessServiceLine

//-------------------------------------------------------------------------

Function TRCServicesHelper.GetVATDetails (Index : Char) : TRCServicesVATCode;
Var
  VType : VATType;
Begin // GetVATDetails
  Result := NIL;

  // Run through the VAT Codes Setup to match up the specified VAT Code with the enumeration
  For VType := Low(VATType) To High(VATType) Do
  Begin
    If (SyssVat^.VATRates.VAT[VType].Code = Index) Then
    Begin
      Result := FVatDetails[VType];
      Break;
    End; // If (SyssVat^.VATRates.VAT[VType].Code = Index)
  End; // For VType

  If (Not Assigned(Result)) Then
    Raise Exception.Create ('TRCServicesHelper.GetVATDetails: Invalid Index ''' + Index + '''');
End; // GetVATDetails

//=========================================================================

End.