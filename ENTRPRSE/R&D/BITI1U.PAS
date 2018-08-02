{ ============== TBIMList Methods =============== }

Function TBIMList.AmountOutstanding(ForcePPD: Boolean): Double;
var
  PPDAvailable: Double;
  EInv     :  InvRec;
  ExLocal  :  ^TdExLocal;
  HasPPD: Boolean;
begin
  ExLocal := ListLocal;

  ForceInvSDisc(Inv,EInv,BatchCtrl,1);

  {$IFDEF MC_On}

  If (BatchCtrl.BACSCRec.PayCurr = Inv.Currency) then
     Result := CurrencyOS(EInv, BOff, BOff, BOff)
  else
     Result := Currency_ConvFT(BaseTotalOS(EInv), 0, BatchCtrl.BACSCRec.PayCurr, UseCoDayRate);
  {$ELSE}

   Result := BaseTotalOS(EInv);

  {$ENDIF}

  // CJS 2015-05-21 - T2-160 - Set/Unset PPD
  // CJS 2015-06-23 - ABSEXCH-16519 - Batch Payments after taking PPD via ledger
  // CJS 2015-06-29 - ABSEXCH-16603 - Batch Payments list does not display expired PPD
  // HasPPD := PPDFieldsPopulated(Inv);
  HasPPD := ValidPPDAvailable(Inv,
                              BatchCtrl.BACSCRec.IntendedPaymentDate,
                              -1);
  if HasPPD and ((Inv.thBatchPayPPDStatus = PPD_BATCHPAY_SET) or ForcePPD) then
  begin
   // Transaction flagged for taking Batch Payment, so reduce
   // the amount outstanding
   PPDAvailable := Inv.thPPDGoodsValue + Inv.thPPDVATValue;
   if BatchCtrl.BACSCRec.PayCurr <> Inv.Currency then
   begin
     // CJS 2015-08-25 - ABSEXCH-16782 - Batch Payments does not convert currency
     PPDAvailable := Conv_TCurr(PPDAvailable, XRate(Inv.CXRate, BOff, Inv.Currency), Inv.Currency, 0, BOff);
     PPDAvailable := Conv_TCurr(PPDAvailable, SyssCurr^.Currencies[BatchCtrl.BACSCRec.PayCurr].CRates[UseCoDayRate], BatchCtrl.BACSCRec.PayCurr, 0, BOn);
   end;

   Result := Result - (PPDAvailable*DocCnst[Inv.InvDocHed]*DocNotCnst);

  end;

  Result := Result*DocCnst[Inv.InvDocHed]*DocNotCnst;
end;

Function TBIMList.SetFilter  :  Str255;

Var
  LChk     :  Integer;

Begin
  With Inv do
  With BatchCtrl.BACSCRec do
  Begin

    LChk:=AgedPos(Get_StaChkDate(Inv),TagAsDate,AgeType,AgeInt)+2;

    // CJS 2015-05-26 - v7.0.14 - PPD - T2-157 - Trader PPD Column (6)
    If ((LChk=CurrCol) or (CurrCol In [0,1,6])) then
      Result:='1'
    else
      Result:=NdxWeight;

    If (Result='1') then
    Begin
      {$IFDEF CU}
        If (RunCEvent) then
        With CustomEvent do
        Begin
          {* Refresh both header and lines *}

          TInvoice(EntSysObj.Transaction).ResetTransandLines(CWId,CWEvent, Inv);

          Execute;

          If (Not EntSysObj.BoResult) then
            Result:=NDxWeight;
        end;
      {$ENDIF}

    end;

  end;

end;



Function TBIMList.CheckRowEmph :  Byte;


Begin
  With Inv do
  Begin
    Result:=Ord(Tagged);
  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TBIMList.OutLine(Col  :  Byte)  :  Str255;
// CJS 2015-05-13 - v7.0.14 - PPD - T2-159 - PPD Columns
const
  BLANK_IF_ZERO = True;
Var
  AgingColumn   :  SmallInt;
  Rnum,
  Dnum     :  Double;
  GenStr   :  Str10;

  IsTagged :  Boolean;

  ExLocal  :  ^TdExLocal;

  EInv     :  InvRec;

  // CJS 2015-05-13 - v7.0.14 - PPD - T2-159 - PPD Columns
  AdjustedPaymentDate: LongDate;
  PPDExpiryDate: LongDate;
  HasPPD: Boolean;
  IsSales: Boolean;

Begin
  ExLocal:=ListLocal;

  With ExLocal^,LMiscRecs^.BACSSRec,BatchCtrl,BACSCRec, Inv do
  Begin
    // CJS 2015-06-10 - ABSEXCH-16516 - Batch Payment Items - value in PPD Expiry
    // CJS 2015-06-29 - ABSEXCH-16603 - Batch Payments list does not display expired PPD
    HasPPD  := PPDFieldsPopulated(Inv);

    LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

    If (Get_StaChkDate(Inv)<>'') then
      AgingColumn:=Succ(AgedPos(Get_StaChkDate(Inv),TagAsDate,AgeType,AgeInt))
    else
      AgingColumn:=0;

    IsTagged:=((Tagged<>0) or (HasTagged[AgingColumn]));

    Result := '';
    Case Col of

       0  :  Result:=OurRef;
       1  :  Result:=YourRef;
       2  :  Result:=POutDate(Get_StaChkDate(Inv));

       3
          :  Begin
               Rnum := AmountOutstanding;
               Result:=FormatCurFloat(GenRealMask,Rnum,BOff,PayCurr);
             end;

       4
          :  Begin
               Dnum:=BatchThen*DocCnst[InvDocHed]*DocNotCnst;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,0);
               {Currency foced to 0, as any part or tagged amount is always in base 0*}
             end;

       5  :  Begin

               GenStr:='';

               If (UnTagged) and (Tagged=0) then
                 GenStr:='Exclude'
               else
                 If (IsTagged) then
                   GenStr:='Tagged'
                 else
                   If (BDiscount<>0.0) then
                     GenStr:='Discounted'
                   else
                     If (DocNotes(HoldFlg)) then
                       GenStr:='See Notes';

               Result:=GenStr;
             end;


       6  :  Result:=POutDate(TransDate);

       // CJS 2015-05-13 - v7.0.14 - PPD - T2-159 - PPD Columns
       // CJS 2015-06-10 - ABSEXCH-16516 - Batch Payment Items - value in PPD Expiry
       // Suppressed display of any values in the PPD columns if there is no PPD
       BIM_PPD_AVAILABLE_COL :
            if HasPPD then
            begin
              RNum := Round_Up(Inv.thPPDGoodsValue + Inv.thPPDVatValue, 2);
              if BatchCtrl.BACSCRec.PayCurr <> Inv.Currency then
                // CJS 2015-08-24 - ABSEXCH-16782 - Batch Payments does not convert currency
                RNum := Round_Up(Currency_ConvFT(RNum, Inv.Currency, BatchCtrl.BACSCRec.PayCurr, UseCoDayRate), 2);
              Result := FormatCurFloat(GenRealMask, Rnum, BLANK_IF_ZERO, PayCurr);
            end;

       BIM_TOTAL_AFTER_PPD_COL :
            if HasPPD then
            begin
              Rnum := AmountOutstanding(True);
              Result := FormatCurFloat(GenRealMask, Rnum, BLANK_IF_ZERO, PayCurr);
            end;

       BIM_PPD_EXPIRY_COL :
            if HasPPD and (Inv.thPPDDays > 0) then
            begin
              PPDExpiryDate := CalcDueDate(Inv.TransDate, Inv.thPPDDays);
              Result := POutDate(PPDExpiryDate);
            end;

      BIM_PPD_STATUS_COL :
            begin
              // CJS 2015-07-07 - ABSEXCH-16642 - PPD shows as expired when taken
              IsSales := Inv.InvDocHed in SalesSplit;
              if Inv.thPPDTaken <> ptPPDNotTaken then
              begin
                // PPD already taken outside Batch Payments
                if IsSales then
                  Result := 'Given'
                else
                  Result := 'Taken';
              end
              else if HasPPD and
                 (Inv.thBatchPayPPDStatus = PPD_BATCHPAY_SET) and
                 ValidPPDAvailable(Inv,
                                   BatchCtrl.BACSCRec.IntendedPaymentDate,
                                   BatchCtrl.BACSCRec.PPDExpiryToleranceDays) then
              begin
                // PPD marked for taking by Batch Payments
                if IsSales then
                  Result := 'Give'
                else
                  Result := 'Take';
              end
              else if HasPPD and
                   (Inv.thBatchPayPPDStatus = PPD_BATCHPAY_SET) and
                   not ValidPPDAvailable(Inv,
                                         BatchCtrl.BACSCRec.IntendedPaymentDate,
                                         BatchCtrl.BACSCRec.PPDExpiryToleranceDays) then
              begin
                // Expired PPD marked for taking by Batch Payments
                if IsSales then
                  Result := 'Expired/Give'
                else
                  Result := 'Expired/Take';
              end
              else if HasPPD and
                   not ValidPPDAvailable(Inv,
                                         BatchCtrl.BACSCRec.IntendedPaymentDate,
                                         BatchCtrl.BACSCRec.PPDExpiryToleranceDays) then
                // Expired PPD, not marked for taking by Batch Payments
                Result := 'Expired';
            end;

     end; {Case..}


   end; {With..}
end;

// CJS 2015-05-13 - v7.0.14 - PPD - T2-159 - PPD Columns - override method
// to apply RAG colours to PPD Expiry column
procedure TBIMList.ModifyCell(Col, Row: Integer; var CellDetails: TCellDetails);
var
  DaysLeftBeforeExpiry : Integer;
  ExpiryDate : string;
  AdjustedPaymentDate: string;
begin
  inherited;

  // Only bother if it's the correct column
  if Col = BIM_PPD_EXPIRY_COL then
  begin
    AdjustedPaymentDate := CalcDueDate(BatchCtrl.BACSCRec.IntendedPaymentDate,
                                       -BatchCtrl.BACSCRec.PPDExpiryToleranceDays);
    // Check if we've got a date. also need to remove separators in order to use Date2Store function
    ExpiryDate := AnsiReplaceStr(CellDetails.Contents, '/', '');
    if Trim(ExpiryDate) <> '' then
    begin
      // How many days left?
      DaysLeftBeforeExpiry := NoDays(AdjustedPaymentDate, Date2Store(ExpiryDate));

      // Set colours appropriately
      SetPPDColours(DaysLeftBeforeExpiry, CellDetails.TextColour, CellDetails.BackColour, CellDetails.Font);
    end;  //if Trim(ExpiryDate) <> ''
  end;  // if Col = BIM_PPD_EXPIRY_COL
end;


{ =================================================================================== }



