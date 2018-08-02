{ ============== TAPMList Methods =============== }


Function TAPMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With MiscRecs^ do
  Begin
    DumStr:=PartCCKey(RecMfix,SubType)+AllocSRec.ariKey;
  end;


  SetCheckKey:=DumStr;
end;




Function TAPMList.SetFilter  :  Str255;

Begin
  Result:=Chr(MiscRecs^.AllocSRec.ariOrigCurr);
end;


{$IFDEF MC_On}

  Procedure TAPMList.Set_CurrencyFilt;

  Var
    ThisLine  :  Integer;

  Begin
    Begin
      If (NHCr=0) then
        Filter[1,0]:=''
      else
        Filter[1,0]:=Chr(NHCr);

      PageUpDn(0,BOn);

      If (PageKeys^[0]=0) then
        InitPage;

    end;
  end;

{$ENDIF}


Function TAPMList.Ok2Del :  Boolean;

Begin
  Result:=BOn;
end;



Function TAPMList.CheckRowEmph :  Byte;


Begin
  
  With MiscRecs^, AllocSRec do
  Begin
    Result:=Ord(ariSettle<>0.0);

    If Link2Inv then
      Result:=Result+(2* Ord(SanityCheckAllocS(MiscRecs^,Inv)<>0));
  end;
end;


{ == Proc to pick up parent invoice header == }

Function TAPMList.Link2Inv  :  Boolean;

Var
  KeyS  :  Str255;

Begin
  With MiscRecs^, AllocSRec do
  Begin
    If (Inv.OurRef<>ariOurRef) then
    Begin
      KeyS:=ariOurRef;
      Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);

      Result:=StatusOk;
    end
    else
      Result:=BOn;

  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TAPMList.OutLine(Col  :  Byte)  :  Str255;

Var
  Dnum  :  Double;

  GenStr:  Str255;

  EInv  :  InvRec;

Begin

  With MiscRecs^, AllocSRec, AllocCtrl.AllocCRec do
  Begin
    Link2Inv;

    EInv:=Inv;


    Case Col of

       0  :  Result:=ariOurRef;
       1  :  Result:=ariYourRef;

       2  :  Result:=POutDate(Get_StaChkDate(Inv));

       3
          :  Begin
               Dnum:=ariOutStanding;

               Dnum:=Dnum*DocCnst[Inv.InvDocHed]*DocNotCnst;


               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,arcPayCurr);
             end;

       4
          :  Begin
               Dnum:=ariSettle*DocCnst[Inv.InvDocHed]*DocNotCnst;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,0);
               {Currency foced to 0, as settled is in base*}
             end;

       5
          :  Begin
               Dnum:=ariSettleOwn*DocCnst[Inv.InvDocHed]*DocNotCnst;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,Inv.Currency);
             end;

       6
          :  Begin
               Dnum:=ariVariance;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,0);
               {Currency foced to 0, as any part or tagged amount is always in base 0*}
             end;

       7
          :  Begin
               Dnum:=ariBaseOS*DocCnst[Inv.InvDocHed]*DocNotCnst;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,0);
               {Currency foced to 0, as any part or tagged amount is always in base 0*}
             end;

       8
          :  Begin
               Dnum:=ariCurrOS*DocCnst[Inv.InvDocHed]*DocNotCnst;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,ariOrigCurr);
               {Currency foced to 0, as any part or tagged amount is always in base 0*}
             end;

       9  :  With Inv Do
             Begin

               GenStr:='';

               If (ariOrigSetDisc<>0.0) then
                 GenStr:='Discounted'
               else
                 If (DocNotes(HoldFlg)) then
                   GenStr:='See Notes';

               Result:=GenStr;
             end;


       10 :  Result:=POutDate(Inv.TransDate);

       //PR: 06/05/2015 ABSEXCH-16284 v7.0.15 PPD T2-121

       11  :  with Inv do
              begin
              //PPD value
              DNum := Round_Up(thPPDGoodsValue + thPPDVATValue, 2);
              if DNum = 0.00 then
                Result := ''
              else
                Result := FormatCurFloat(GenRealMask,DNum,BOff,Currency);
              end;
       12  :  with Inv do
              begin
              //O/S total with PPD
              DNum := Round_Up(ariCurrOS*DocCnst[Inv.InvDocHed]*DocNotCnst, 2);

              //PR: ABSEXCH-16550 Remove PPDNotTaken check
              //PR: 09/07/2015 ABSEXCH-16633 Don't subtract ppd if it's already been taken (unless manual)
              if ((Cust.acPPDMode = pmPPDEnabledWithManualCreditNote) and (Abs(DNum) = CurrencyOS(Inv, True, False, False)))
                or (Inv.thPPDTaken = ptPPDNotTaken) then
                DNum := Round_Up(DNum - ((thPPDGoodsValue + thPPDVATValue)), 2);
              if DNum = 0.00 then
                Result := ''
              else
                Result := FormatCurFloat(GenRealMask,DNum,BOff,Currency);
             end;
       13 :  with Inv do
             begin
              //PPD Expiry
              if thPPDDays = 0 then
                Result := ''
              else
                Result := POutDate(CalcDueDate(TransDate, thPPDDays));
             end;
       14 :  with Inv do
             begin
               //PPD Status
               if Inv.thPPDTaken <> ptPPDNotTaken then
                 Result := PPDGiveTakeWord(Inv.CustSupp) + 'n'
               else
               if ariPPDStatus > 0 then
                 Result := PPDGiveTakeWord(Inv.CustSupp)
               else
                 Result := '';
             end;


       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


Function  TAPMList.Link2FindList(Opt       :   Byte)  :  Boolean;
Begin

  If (Opt<35) then {Do not link to invoice record, no need as we will be searchin on local record}
    Result:=Link2Inv
  else
    Result:=BOn;

end;


Procedure TAPMList.Find_OnList(Opt       :   Byte;
                               Value     :   Str30);

Const
  OFnum     =  MiscF;
  OKeypath  =  MiscNDXK;


Var
  OKeyS     :  Str255;
  TMode     :  Byte;

Begin
  Case Opt of
    5  :  TMode:=37;
    6  :  TMode:=36;
    else  TMode:=Opt;
  end; {case..}


  If (Opt=5) then {By pass sequential search for our ref as we can use index}
  Begin
    OKeyS:=KeyRef+Value;

    Status:=Find_Rec(B_GetGEq,F[OFnum],OFnum,RecPtr[OFnum]^,OKeyPath,OKeyS);

    If (Status=0) and (CheckKey(KeyRef,OKeyS,Length(KeyRef),BOff)) and (LineOk(SetCheckKey)) then
    Begin
      Status:=GetPos(F[OFnum],OFnum,PageKeys^[0]);

      MUListBoxes[0].Row:=0;
      PageUpDn(0,BOn);
    end;
  end
  else
    Inherited Find_OnList(TMode,Value);
end;

//PR: 07/05/2015 ABSEXCH-16284 T2-121 Event handler to colour cell for PPD Expiry date
procedure TAPMList.ModifyCell(Col, Row: Integer;
  var CellDetails: TCellDetails);
const
  PPD_EXPIRY_COL = 13;
var
  DaysLeftBeforeExpiry : Integer;
  ExpiryDate : string;
begin
  inherited;

  //Only bother if it's the correct column
  if Col = PPD_EXPIRY_COL then
  begin
    //Check if we've got a date. also need to remove separators in order to use Date2Store function
    ExpiryDate := AnsiReplaceStr(CellDetails.Contents, '/', '');
    if Trim(ExpiryDate) <> '' then
    begin
      //How many days left?
      DaysLeftBeforeExpiry := NoDays(EtDateU.Today, Date2Store(ExpiryDate));

      //Set colours appropriately
      SetPPDColours(DaysLeftBeforeExpiry, CellDetails.TextColour, CellDetails.BackColour, CellDetails.Font);
    end;  //if Trim(ExpiryDate) <> ''
  end;  // if Col = PPD_EXPIRY_COL
end;



{ =================================================================================== }



