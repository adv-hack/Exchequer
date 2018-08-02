

Function TJELMList.SetCheckKey  :  Str255;


Var

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case ScanFileNum of
    JDetlF  :  DumStr:=Inherited SetCheckKey;
    JCtrlF  :  With JobCtrl^,JobBudg do
                 DumStr:=FullJBKey(RecPFix,SubType,BudgetCode);

    InvF    :  DumStr:=Inv.BatchLink;


  end; {Case..}


  SetCheckKey:=DumStr;
end;



Function TJELMList.CheckRowEmph :  Byte;

Var
  ChkRecon  :  Byte;

Begin
  Result:=0;

  If (DisplayMode In [33]) then
  With Inv do
  Begin
    Begin
      Result:=Ord(Not PDiscTaken);
    end;

  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TJELMList.OutJELLine(Col  :  Byte)  :  Str255;

Const
  Fnum     =  IDetailF;
  Keypath  =  IdLinkK;


Var

  GenStr :  Str255;

  FoundCode
         :  Str20;

  UOR,
  TCr    :  Byte;

  Rnum   :  Real;
  Dnum   :  Double;

  ExLocal: ^TdExLocal;

Begin

  UOR:=0;

  ExLocal:=ListLocal;


   With ExLocal^,LNHCtrl,JobDetl^.JobActual do
   Begin

     If (Id.FolioRef<>LineFolio) or (Id.ABSLineNo<>LineNo) then
     Begin
       GenStr:=FullRunNoKey(LineFolio,LineNo);

       Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,GenStr);
     end;

     Case Col of

       0  :  Result:=JobCode;
       1  :  Result:=StockCode;
       2  :  Result:=AnalCode;
       3  :  Result:=FormatFloat(GenQtyMask,Qty);

       4  :  Begin
               Dnum:=((Cost)*DocCnst[JDDT]);

               TCr:=ActCurr;

               {$IFDEF MC_On}

                 If (NHCr=0) then
                 Begin

                   TCr:=NHCr;

                   UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

                   Dnum:=Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff);
                 end;

               {$ENDIF}

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,TCr);
             end;

       5  :  Begin
               Dnum:=((Qty*Cost)*DocCnst[JDDT]);

               TCr:=ActCurr;

               {$IFDEF MC_On}

                 If (NHCr=0) then
                 Begin

                   TCr:=NHCr;

                   UOR:=fxUseORate(BOff,BOn,PCRates,JUseORate,ActCurr,0);

                   Dnum:=Conv_TCurr(Dnum,XRate(PCRates,BOff,ActCurr),ActCurr,UOR,BOff);
                 end;

               {$ENDIF}

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,TCr);
             end;

       6,7
          :  Begin
               Result:=Id.CCDep[col=6];
             end;

       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


Function TJELMList.OutJEPLine(Col  :  Byte)  :  Str255;


Var
  GenStr :  Str255;

  TCr    :  Byte;

  Dnum   :  Double;

  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  With ExLocal^,LNHCtrl,JobCtrl^,EmplPay do
  Begin
    Case Col of

         0  :  Result:=EStockCode;
         1  :  Result:=PayRDesc;
         2  :  Result:=EAnalCode;

         3  :  Begin

                 TCr:=CostCurr;

                 Dnum:=Cost;

                 Result:=FormatCurFloat(GenUnitMask[BOff],Dnum,BOff,TCr);
               end;

         4  :  Begin

                 TCr:=ChargeCurr;

                 Dnum:=ChargeOut;

                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
               end;

         5  :  Result:=Form_BInt(PayRRate,0);

         else
               Result:='';
    end; {Case..}
  end; {With..}
end;


Function TJELMList.OutJEAppLine(Col  :  Byte)  :  Str255;


Var
  GenStr :  Str255;

  TCr    :  Byte;

  Dnum   :  Double;

  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  With ExLocal^,LNHCtrl,Inv do
  Begin
    Case Col of

         0  :  Result:=OurRef;
         1  :  Result:=DJobCode;
         2  :  Result:=POutDate(TransDate);

         3  :  Begin

                 TCr:=Currency;
                 
                 If (InvDocHed In [JSA,JPA]) then
                   Dnum:=GetJAParentTotal(Inv,0)
                 else
                   Dnum:=TotalCost;

                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
               end;

         4  :  Begin

                 TCr:=Currency;

                 If (InvDocHed=JCT) then
                   Dnum:=Calc_JAPAppTotal(Inv,(TotalOrdered<>0),1)
                 else
                   Dnum:=Calc_JAPAppTotal(Inv,PDiscTaken,0);

                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,TCr);
               end;

         5  :  If (HoldFlg<>0) then
                 Result:=DisplayHold(HoldFlg)
               else
                 If (PDiscTaken) then
                   Result:='Certified'
                 else
                   Result:='';


         else
               Result:='';
    end; {Case..}
  end; {With..}
end;


Function TJELMList.OutLine(Col  :  Byte)  :  Str255;


Begin
  Case DisplayMode of
    31..32  :  Result:=OutJELLine(Col);

    33,34   :  Result:=OutJEAppLine(Col);

    else       Result:=OutJEPLine(Col);

  end; {Case..}
end;


{ =================================================================================== }

