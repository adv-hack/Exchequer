unit oAppVals;

interface

Uses Classes, Dialogs, SysUtils, GlobVar, VarConst, VarJCstU;

Type
  pInvRec = ^InvRec;

  //------------------------------

  TAppValTotals = Class(TObject)
  Private
    FApplied : Double;                         // Total Applied For amount
    FAppliedYTD : Double;                      // Total Applied For amount YTD
    FCachedFolio : LongInt;                    // Folio Number of last transaction processed
    FCITBPercentage : Double;                  // Percentage of last CITB Line processed
    FCITBPrevious : Double;                    // Previous CITB total to date
    FContras : Double;                         // Total of Contra Lines
    FDiscountCertified : Double;               // Total of Certified Discount Lines
    FDiscountCertifiedYTD : Double;            // YTD Total of Certified Discount Lines
    FDiscountPercentage : Double;              // Percentage of last discount line processed
    FRetentionCertified : Double;              // Total of Certified Retention Lines
    FRetentionPercentage : Double;             // Percentage of last retention line processed
    FRetentionRelease : Double;                // Total of Retention Release Lines
    FRetentionReleaseYTD : Double;             // YTD Total of Retention Release Lines

    FLineTypeTotals : tJALLTTypes;             // Extended Line Type Totals for Apps/Vals

    // HM 23/09/04: Added additional fields to remove direct transaction
    // access from data dictionary fields
    FJxACertifiedTotalYTD : Double;
    FJxACertifiedAmount : Double;
    FJxAContrasTotal : Double;
    FJxTBasis : Byte;
    FJxTATR : Boolean;
    FJxTDeferVAT : Boolean;
    FJxAAppliedDeductions : Double;
    FJxAAppliedRetentions : Double;
    FJxTStage : Byte;
    FJxTCumulativeTotal : Double;

    // Property Get method for avtLineTypeTotal
    Function GetLineTypeTotal (Index : Byte) : Double;

    // Run through the matching for the Transaction and load any JxA transactions
    // and pass them into ProcessFolioLines to be totalled.
    Procedure FindApplications (Const InvR : InvRec);

    // Run through the lines for the specified Folio Number updated the
    // Apps & Vals totals
    Procedure ProcessFolioLines (Const InvR : InvRec);
  Public
    // Total Applied For amount
    Property avtApplied : Double Read FApplied;
    // Total Applied For amount YTD
    Property avtAppliedYTD : Double Read FAppliedYTD;
    // Percentage of last CITB Line processed
    Property avtCITBPercentage : Double Read FCITBPercentage;
    // Previous CITB total to date
    Property avtCITBPrevious : Double Read FCITBPrevious;
    // Total of Contra Lines
    Property avtContras : Double Read FContras;
    // Total of Certified Discount Lines
    Property avtDiscountCertified : Double Read FDiscountCertified;
    // YTD Total of Certified Discount Lines
    Property avtDiscountCertifiedYTD : Double Read FDiscountCertifiedYTD;
    // Percentage of last discount line processed
    Property avtDiscountPercentage : Double Read FDiscountPercentage;
    // Extended Line Type Totals for Apps/Vals
    Property avtLineTypeTotal [Index : Byte] : Double Read GetLineTypeTotal;
    // Total of Certified Retention Lines
    Property avtRetentionCertified : Double Read FRetentionCertified;
    // Percentage of last retention line processed
    Property avtRetentionPercentage : Double Read FRetentionPercentage;
    // Total of Retention Release Lines
    Property avtRetentionRelease : Double Read FRetentionRelease;
    // YTD Total of Retention Release Lines
    Property avtRetentionReleaseYTD : Double Read FRetentionReleaseYTD;

    // HM 23/09/04: Added additional fields to remove direct transaction
    // access from data dictionary fields
    // JxA Certified Total YTD
    Property avtJxACertifiedTotalYTD : Double Read FJxACertifiedTotalYTD;
    // JxA Certified Amount
    Property avtJxACertifiedAmount : Double Read FJxACertifiedAmount;
    // JxA Contras Total
    Property avtJxAContrasTotal : Double Read FJxAContrasTotal;
    // JxT Basis
    Property avtJxTBasis : Byte Read FJxTBasis;
    // JxT ATR
    Property avtJxTATR : Boolean Read FJxTATR;
    // JxT Defer VAT
    Property avtJxTDeferVAT : Boolean Read FJxTDeferVAT;
    // JxA Applied Deductions YTD
    Property avtJxAAppliedDeductions : Double Read FJxAAppliedDeductions;
    // JxA Applied Retentions YTD
    Property avtJxAAppliedRetentions : Double Read FJxAAppliedRetentions;
    // JxT Stage
    Property avtJxTStage : Byte Read FJxTStage;
    // JxT Cumulative Total
    Property avtJxTCumulativeTotal : Double Read FJxTCumulativeTotal;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure CalcTotals (Const InvR : InvRec);
    Procedure ClearCache;
  End; // TAppValTotals


// Singleton function which returns the single instance of the Form
// Designers Apps & Vals transaction totalling object
Function AppValTotals : TAppValTotals; Overload;
Function AppValTotals (InvR : pInvRec) : TAppValTotals; Overload;


  Function Calc_JAPDocTotal(InvR     :  InvRec;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;



implementation

Uses BtrvU2, BTSupU1, BTKeys1U, ComnU2,
     MiscU,
     SavePos;    // Generic object to wrap the Save Position / Restore Position process

Var
  lAppValTotals : TAppValTotals;

//=========================================================================

  { == Calculate App Net total == }
  { UseCert   = Use certified values as basis for calcualtion }
  { tmode : 0 = Transaction total
            1 = YTD total
  }

  Function Calc_JAPAppTotal(InvR     :  InvRec;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;

  Var
    Basis  :  Double;

  Begin
    With InvR do
    Begin
      Case tMode of
        1  :  Begin
                If (UseCert) then
                  Basis:=TotalOrdered
                else
                  Basis:=TotalReserved;

                Result:=Basis;
              end;
        else  Begin
                If (UseCert) then
                  Basis:=InvNetVal
                else
                  Basis:=TotalCost;

                Result:=Basis;
              end;
      end; {Case..}
    end; {With..}
  end; {Func..}



  { == Calculate App total == }
  { UseCert   = Use certified values as basis for calcualtion }
  { tmode : 0 = Transaction total
            1 = YTD total
            2 = Transaction total without VAT
  }

  Function Calc_JAPDocTotal(InvR     :  InvRec;
                            UseCert  :  Boolean;
                            tMode    :  Byte)  :  Double;

  Var
    Basis  :  Double;

  Begin
    With InvR do
    Begin
      Case tMode of
        1  :  Begin
                Basis:=Calc_JAPAppTotal(InvR,UseCert,tMode);

                Result:=Basis-PostDiscAm-TotOrdOS;
              end;
        else  Begin
                Basis:=Calc_JAPAppTotal(InvR,UseCert,tMode);

                Result:=Basis-DiscSetAm-DiscAmount-CISTax-BDiscount+(InvVAT*Ord(tMode<>2));
              end;
      end; {Case..}
    end; {With..}
  end; {Func..}


//=========================================================================

// Singleton function which returns the single instance of the Form
// Designers Apps & Vals transaction totalling object
Function AppValTotals (InvR : pInvRec) : TAppValTotals;
Begin // AppValTotals
  // Check to see if the object needs to be created
  If (Not Assigned(lAppValTotals)) Then
  Begin
    lAppValTotals := TAppValTotals.Create;
  End; // If (Not Assigned(lAppValTotals))

  If Assigned(InvR) Then
  Begin
    lAppValTotals.CalcTotals(InvR^);
  End; // If (Trim(OurRef) <> '')

  // return the object
  Result := lAppValTotals;
End; // AppValTotals

//------------------------------

Function AppValTotals : TAppValTotals;
Begin
  Result := AppValTotals(NIL);
End;

//=========================================================================

Constructor TAppValTotals.Create;
Begin // Create
  Inherited Create;

  ClearCache;
End; // Create

//------------------------------

Destructor TAppValTotals.Destroy;
Begin // Destroy
  lAppValTotals := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TAppValTotals.ClearCache;
Begin // ClearCache
  // Folio Number of last transaction processed
  FCachedFolio := 0;
End; // ClearCache

//-------------------------------------------------------------------------

// Run through the lines for the specified Folio Number updated the
// Apps & Vals totals
Procedure TAppValTotals.ProcessFolioLines (Const InvR : InvRec);
var
  sKey           : Str255;
  iStatus, LCnst : SmallInt;
  LineTotal      : Double;
  LineVATType    : VATType;
Begin // ProcessFolioLines
  // HM 23/09/04: Added additional fields to remove direct transaction
  // access from data dictionary fields
  FJxACertifiedTotalYTD := FJxACertifiedTotalYTD + InvR.TotalOrdered;
  FJxACertifiedAmount := FJxACertifiedAmount + InvR.InvNetVal;
  FJxAContrasTotal := FJxAContrasTotal + InvR.BDiscount;
  FJxTBasis := InvR.TransMode;
  FJxTATR := InvR.OnPickRun;
  FJxTDeferVAT := InvR.AutoPost;
  FJxAAppliedDeductions := FJxAAppliedDeductions + InvR.BatchNow;
  FJxAAppliedRetentions := FJxAAppliedRetentions + InvR.BatchThen;
  FJxTStage := InvR.TransNat;
  FJxTCumulativeTotal := FJxTCumulativeTotal + Calc_JAPDocTotal(InvR, (InvR.TotalOrdered<>0.0), 1);

  // Run through the transaction lines from -3 through to the normal lines
  sKey := FullNomKey(InvR.FolioNum) + FullNomKey(JALRetLineNo);
  iStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
  While (iStatus = 0) And (ID.FolioRef = InvR.FolioNum) Do
  Begin
    LCnst := ComnU2.LineCnst(Id.Payment);

    If (InvR.PDiscTaken) then
      LineTotal := Id.NetValue
    else
      LineTotal := Id.CostPrice;

    // Update the global VAT Goods totals and flags in MiscU
    LineVATType := GetVAtNo(Id.VATcode,Id.VATIncFlg);
    InvNetAnal[LineVATType] := InvNetAnal[LineVATType] + (LineTotal*LCnst);
    InvNetTrig[LineVATType] := BOn; {* Show Rate is being used, Value independant *}

    // Update the extended line type totals
    If (Id.DocLTLink <= High(FLineTypeTotals)) Then
    Begin
      FLineTypeTotals[Id.DocLTLink] := FLineTypeTotals[Id.DocLTLink] + LineTotal;
    End; // If (Id.DocLTLink >= Low(FLineTypeTotals)) and (Id.DocLTLink <= High(FLineTypeTotals))

    If (Id.LineNo = JALRetLineNo) Then
    Begin
      If (Not Id.PrxPack) Then
      Begin
        // Retention - record % and update running totals on retention lines
        FRetentionPercentage := Id.Discount;
        FRetentionCertified := FRetentionCertified + Id.NetValue;
      End //
      Else
      Begin
        // Retention Release - update running totals on retention release lines
        FRetentionRelease := FRetentionRelease + ABS(Id.NetValue);
        FRetentionReleaseYTD := FRetentionReleaseYTD + ABS(Id.QtyPWOff);
      End; // Else
    End; // If (Id.LineNo = JALRetLineNo) And (Not Id.PrxPack)
    If (Id.LineNo = JALDedLineNo) Then
    Begin
      // Discount - record % and update running totals on discount lines
      FDiscountPercentage := Id.Discount;
      If (Id.JAPDedType = 0) And (Id.AutoLineType <> 2) Then
      Begin
        // Discount Line - not CIS generated
        FDiscountCertified := FDiscountCertified + Id.NetValue;
        FDiscountCertifiedYTD := FDiscountCertifiedYTD + Id.QtyPWOff;
      End; // If (Id.JAPDedType = 0) And (Id.AutoLineType <> 2)
      If (Id.JAPDedType = 2) Then
      Begin
        // Contra Line
        FContras := FContras + Id.NetValue;
      End; // If (Id.JAPDedType = 0) And (Id.AutoLineType <> 2)
    End; // If (Id.LineNo = JALDedLineNo) And (Not Id.PrxPack)
    If (Id.LineNo > 0) Then
    Begin
      // Normal Line - update running totals on normal lines
      FApplied := FApplied + Id.CostPrice;
      FAppliedYTD := FAppliedYTD + Id.QtyDel;
    End; // If (Id.LineNo > 0)
    If (Id.DocLTLink = 14) Then
    Begin
      // CITB Levy - record % and Current-to-date total
      FCITBPercentage := Id.Discount;
      FCITBPrevious := FCITBPrevious + Id.QtyDel;
    End; // If (Id.DocLTLink = 14)

    iStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
  End; // While (iStatus = 0) And (ID.FolioRef = TheFolio)
End; // ProcessFolioLines

//------------------------------

// Run through the matching for the Transaction and load any JxA transactions
// and pass them into ProcessFolioLines to be totalled.
Procedure TAppValTotals.FindApplications (Const InvR : InvRec);
Var
  PwrdPos      : TBtrieveSavePosition;
  sKey, sCheck : Str255;
  iStatus      : SmallInt;
Begin // FindApplications
  PwrdPos := TBtrieveSavePosition.Create;
  Try
    // Save the current record and position in the file for the current key
    PwrdPos.SaveFilePosition (PwrdF, GetPosKey);
    PwrdPos.SaveDataBlock (@Password, SizeOf(Password));

    sKey := MatchTCode + MatchSCode + InvR.OurRef;
    sCheck := sKey;

    iStatus := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, sKey);
    While (iStatus = 0) And (CheckKey (sCheck, sKey, Length(sCheck), BOn)) Do
    Begin
      If ((InvR.InvDocHed = PIN) And (Copy (Password.MatchPayRec.PayRef, 1, 3) = 'JPA')) Or
         ((InvR.InvDocHed = SIN) And (Copy (Password.MatchPayRec.PayRef, 1, 3) = 'JSA')) Then
      Begin
        // PIN matched to JPA or SIN matched to JSA
        sKey := Password.MatchPayRec.PayRef;
        iStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, sKey);
        If (iStatus = 0) Then
        Begin
          ProcessFolioLines (Inv);
        End; // If (iStatus = 0)
      End; // If (InvR.InvDocHed = PIN) And (Copy (Password.MatchPayRec.PayRef, 1, 3) = 'JPA')

      iStatus := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK, sKey);
    End; // While (iStatus = 0) And (CheckKey (sCheck, sKey, Length(sCheck), BOn))

    // Restore record and position in file
    PwrdPos.RestoreSavedPosition;
    PwrdPos.RestoreDataBlock (@Password);
  Finally
    FreeAndNIL(PwrdPos);
  End; // Try..Finally
End; // FindApplications

//------------------------------

// runs through the transaction calculating the Apps & Vals Totals
Procedure TAppValTotals.CalcTotals (Const InvR : InvRec);
Var
  THPos, TLPos   : TBtrieveSavePosition;
//  sKey           : Str255;
//  iStatus, LCnst : SmallInt;
//  LineTotal      : Double;
//  LineVATType    : VATType;
Begin // CalcTotals
  // Check whether the transaction has already been processed
  If (FCachedFolio <> InvR.FolioNum) Then
  Begin
    // No - setup flag so we only process the lines once for performance reasons
    FCachedFolio := InvR.FolioNum;

    THPos := TBtrieveSavePosition.Create;
    Try
      // Save the current record and position in the file for the current key
      THPos.SaveFilePosition (InvF, GetPosKey);
      THPos.SaveDataBlock (@Inv, SizeOf(Inv));

      TLPos := TBtrieveSavePosition.Create;
      Try
        // Save the current record and position in the file for the current key
        TLPos.SaveFilePosition (IdetailF, GetPosKey);
        TLPos.SaveDataBlock (@Id, SizeOf(Id));

        //------------------------------

        // Initialise global totals in miscU
        FillChar (InvNetAnal, SizeOf(InvNetAnal), #0);    // Running total of goods by VAT Type
        FillChar (InvNetTrig, SizeOf(InvNetTrig), #0);    // Flags to indicate usage of VAT Rate

        // Initialise local totals within object
        FApplied := 0.0;                                           // Total Applied For amount
        FAppliedYTD := 0.0;                                        // Total Applied For amount YTD
        FCITBPercentage := 0.0;                                    // Percentage of last CITB Line processed
        FCITBPrevious := 0.0;                                      // Previous CITB total to date
        FContras := 0.0;                                           // Total of Contra Lines
        FDiscountCertified := 0.0;                                 // Total of Certified Discount Lines
        FDiscountCertifiedYTD := 0.0;                              // YTD Total of Certified Discount Lines
        FDiscountPercentage := 0.0;                                // Percentage of last discount line processed
        FRetentionCertified := 0.0;                                // Total of Certified Retention Lines
        FRetentionPercentage := 0.0;                               // Percentage of last retention line processed
        FRetentionRelease := 0.0;                                  // Total of Retention Release Lines
        FRetentionReleaseYTD := 0.0;                               // YTD Total of Retention Release Lines
        FillChar (FLineTypeTotals, SizeOf(FLineTypeTotals), #0);   // Extended Line Type Totals for Apps/Vals

        // HM 23/09/04: Added additional fields to remove direct transaction
        // access from data dictionary fields
        FJxACertifiedTotalYTD := 0.0;
        FJxACertifiedAmount := 0.0;
        FJxAContrasTotal := 0.0;
        FJxTBasis := 0;
        FJxTATR := False;
        FJxTDeferVAT := False;
        FJxAAppliedDeductions := 0.0;
        FJxAAppliedRetentions := 0.0;
        FJxTStage := 0;
        FJxTCumulativeTotal := 0.0;

        If (InvR.InvDocHed In JAPSplit) Then
        Begin
          // Application - total lines
          ProcessFolioLines (InvR);
        End // If (InvR.InvDocHed In JAPSplit)
        Else
        Begin
          If (InvR.InvDocHed In [SIN, PIN]) Then
          Begin
            // Invoice - check for applications which generated invoice
            FindApplications (InvR);
          End // If (InvR.InvDocHed In [SIN, PIN])
        End; // Else

// HM 22/09/04: Split out line processing to a separate func to allow the
// applications to be processed for a PIN/SIN
(****
        If (Inv.InvDocHed In JAPSplit) Then
        Begin
          // Run through the transaction lines from -3 through to the normal lines
          sKey := FullNomKey(InvR.FolioNum) + FullNomKey(JALRetLineNo);
          iStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
          While (iStatus = 0) And (ID.FolioRef = InvR.FolioNum) Do
          Begin
            LCnst := ComnU2.LineCnst(Id.Payment);

            If (InvR.PDiscTaken) then
              LineTotal := Id.NetValue
            else
              LineTotal := Id.CostPrice;

            // Update the global VAT Goods totals and flags in MiscU
            LineVATType := GetVAtNo(Id.VATcode,Id.VATIncFlg);
            InvNetAnal[LineVATType] := InvNetAnal[LineVATType] + (LineTotal*LCnst);
            InvNetTrig[LineVATType] := BOn; {* Show Rate is being used, Value independant *}

            // Update the extended line type totals
            If (Id.DocLTLink >= Low(FLineTypeTotals)) and (Id.DocLTLink <= High(FLineTypeTotals)) Then
            Begin
              FLineTypeTotals[Id.DocLTLink] := FLineTypeTotals[Id.DocLTLink] + LineTotal;
            End; // If (Id.DocLTLink >= Low(FLineTypeTotals)) and (Id.DocLTLink <= High(FLineTypeTotals))

            If (Id.LineNo = JALRetLineNo) Then
            Begin
              If (Not Id.PrxPack) Then
              Begin
                // Retention - record % and update running totals on retention lines
                FRetentionPercentage := Id.Discount;
                FRetentionCertified := FRetentionCertified + Id.NetValue;
              End //
              Else
              Begin
                // Retention Release - update running totals on retention release lines
                FRetentionRelease := FRetentionRelease + ABS(Id.NetValue);
                FRetentionReleaseYTD := FRetentionReleaseYTD + ABS(Id.QtyPWOff);
              End; // Else
            End; // If (Id.LineNo = JALRetLineNo) And (Not Id.PrxPack)
            If (Id.LineNo = JALDedLineNo) Then
            Begin
              // Discount - record % and update running totals on discount lines
              FDiscountPercentage := Id.Discount;
              If (Id.JAPDedType = 0) And (Id.AutoLineType <> 2) Then
              Begin
                // Discount Line - not CIS generated
                FDiscountCertified := FDiscountCertified + Id.NetValue;
                FDiscountCertifiedYTD := FDiscountCertifiedYTD + Id.QtyPWOff;
              End; // If (Id.JAPDedType = 0) And (Id.AutoLineType <> 2)
              If (Id.JAPDedType = 2) Then
              Begin
                // Contra Line
                FContras := FContras + Id.NetValue;
              End; // If (Id.JAPDedType = 0) And (Id.AutoLineType <> 2)
            End; // If (Id.LineNo = JALDedLineNo) And (Not Id.PrxPack)
            If (Id.LineNo > 0) Then
            Begin
              // Normal Line - update running totals on normal lines
              FApplied := FApplied + Id.CostPrice;
              FAppliedYTD := FAppliedYTD + Id.QtyDel;
            End; // If (Id.LineNo > 0)
            If (Id.DocLTLink = 14) Then
            Begin
              // CITB Levy - record % and Current-to-date total
              FCITBPercentage := Id.Discount;
              FCITBPrevious := FCITBPrevious + Id.QtyDel;
            End; // If (Id.DocLTLink = 14)

            iStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
          End; // While (iStatus = 0) And (ID.FolioRef = InvR.FolioNum)
        End; // If (Inv.InvDocHed In JAPSplit)
****)
        //------------------------------

        // Restore record and position in file
        TLPos.RestoreSavedPosition;
        TLPos.RestoreDataBlock (@Id);
      Finally
        FreeAndNIL(TLPos);
      End; // Try..Finally

      // Restore record and position in file
      THPos.RestoreSavedPosition;
      THPos.RestoreDataBlock (@Inv);
    Finally
      FreeAndNIL(THPos);
    End; // Try..Finally
  End; // If (FCachedFolio <> InvR.FolioNum)
End; // CalcTotals

//-------------------------------------------------------------------------

// Property Get method for avtLineTypeTotal
Function TAppValTotals.GetLineTypeTotal (Index : Byte) : Double;
Begin // GetLineTypeTotal
  If (Index <= High(FLineTypeTotals)) Then
  Begin
    Result := FLineTypeTotals[Index];
  End // If (Index >= Low(FLineTypeTotals)) And (Index <= High(FLineTypeTotals))
  Else
  Begin
    Raise Exception.Create ('AppValTotals.avtLineTypeTotal: Invalid array index (' + IntToStr(Index) + ')');
  End; // Else
End; // GetLineTypeTotal

//-------------------------------------------------------------------------



Initialization
  lAppValTotals := NIL;
Finalization
  FreeAndNIL(lAppValTotals);
end.
