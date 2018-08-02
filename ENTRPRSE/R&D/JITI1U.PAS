{ ============== TJIMList Methods =============== }


Function TJIList.CheckRowEmph :  Byte;


Begin
  Result:=Ord(JobDetl^.JobActual.Tagged);
end;



Function TJIList.Find_ReCharge  :  Boolean;

Var
  KeyChk,
  KeyS      :  Str255;

  FoundOk,
  Loop      :  Boolean;

Begin
  With JobDetl^.JobActual do
  Begin

    KeyChk:=PartCCKey(JBRCode,JBSCode)+FullJDStkKey(JobCode,StockCode);

    Loop:=BOff;

    {* Get Budget matched line *}

    Repeat

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[JCtrlF],JCtrlF,RecPtr[JCtrlF]^,JCK,KeyS);

      FoundOk:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)));

      Loop:=Not Loop;

      KeyChk:=PartCCKey(JBRCode,JBBCode)+FullJDAnalKey(JobCode,AnalCode);

    Until (Not Loop) or (FoundOk);

    If (Not FoundOk) then
      ResetRec(JCtrlF);

    Result:=JobCtrl^.JobBudg.ReCharge;
  end;
end;

{ ========== Generic Function to Return Formatted Display for List ======= }


Function TJIList.OutLine(Col  :  Byte)  :  Str255;


Var

  GenStr :  Str255;

  FoundCode
         :  Str20;
  UOR,
  TCr    :  Byte;

  Rnum   :  Real;
  Dnum   :  Double;

  ExLocal: ^TdExLocal;

  FuncRes: Integer;
  Key: Str255;
Begin

  UOR:=0;

  ExLocal:=ListLocal;


   With ExLocal^,LNHCtrl,JobDetl^.JobActual do
   Begin
     Case Col of

       0  :  Result:=LineORef;
       1  :  Result:=POutDate(JDate);

       2  :  Begin
               GetJobMisc(Self,AnalCode,FoundCode,2,-1);

               Result:=JobXDesc^[JobMisc^.JobAnalRec.JAType];
             end;

       3  :  Result:=YesNoBo(Find_ReCharge);
       4  :  Result:=FormatFloat(GenQtyMask,Qty);

       5  :  Begin
               Dnum:=((Qty*Cost)*DocCnst[JDDT]);

               TCr:=ActCurr;

               {$IFDEF MC_On}

                 If (NHCr<>TCr) then
                 Begin

                   TCr:=0;

                   UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

                   Dnum:=Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff);

                   Dnum:=Currency_ConvFT(Dnum,TCr,NHCr,UseCoDayRate);
                 end;


               {$ENDIF}

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,NHCr);
             end;
       6  :  Begin
               Dnum:=((Qty*UpliftTotal)*DocCnst[JDDT]);

               TCr:=ActCurr;

               {$IFDEF MC_On}

                 If (NHCr<>TCr) then
                 Begin

                   TCr:=0;

                   UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

                   Dnum:=Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff);

                   Dnum:=Currency_ConvFT(Dnum,TCr,NHCr,UseCoDayRate);
                 end;


               {$ENDIF}

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,NHCr);
             end;

       7  :  Result:=FormatFloat(GenPcntMask,JobCtrl^.JobBudg.OverCost);

       8  :  Begin
               Dnum:=Currency_ConvFT(Charge,CurrCharge,NHCr,UseCoDayRate)*DocCnst[JDDT];

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,NHCr);
             end;

       9  :  Result:=YesNoBo(Tagged);

      10  : begin
              Key := FullRunNoKey(LineFolio, LineNo);
              Status := Find_Rec(B_GetEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdLinkK, Key);
              If (StatusOk) then
                Dnum := (Id.NetValue * Id.Discount) * Qty
              else
                Dnum := 0.0;
              TCr:=ActCurr;
              {$IFDEF MC_On}
              If (NHCr<>TCr) then
              Begin
                TCr:=0;
                UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);
                Dnum:=Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff);
                Dnum:=Currency_ConvFT(Dnum,TCr,NHCr,UseCoDayRate);
              end;
              {$ENDIF}
              Result:=FormatCurFloat(GenRealMask,Dnum,BOff,NHCr);
            end;

       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


{ =================================================================================== }

