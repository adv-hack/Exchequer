{ ============== TTransMList Methods =============== }



Function TTransMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;

  TmpLNo,
  TmpRunNo,
  TmpFolio  :  LongInt;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Id do
  Begin

    Case Keypath of

      IdFolioK
               :  Begin
                    If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                    Begin
                      TmpLNo:=MaxLInt;

                    end
                    else
                      TmpLNo:=LineNo;


                    DumStr:=FullIdKey(FolioRef,TmpLNo);

                  end;
   end; {Case..}

  end;

  SetCheckKey:=DumStr;
end;




Function TTransMList.SetFilter  :  Str255;

Begin
  Result:='';

  Case DayBkListMode of

      0..11 :  With Id do
               Begin

                 If (LineNo=RecieptCode) then
                   Result:='1'
                 else
                   Result:='0';

                 
               end;

  end; {Case..}

end;


{$IFDEF STK}
{ ====== Function to Check for Line to be OS of parent ====== }

Function TTransMList.DelSOP_Link(IdR  :  IDetail)  :  Boolean;


Var
  TmpId    :  ^Idetail;
  FoundOk  :  Boolean;


Begin

  New(TmpId);

  TmpId^:=Id;

  FoundOk:=BOn;

  With Idr do
  Begin

    If (SOPLink<>0) then
    Begin

      FoundOk:=(Not CheckRecExsists(FullIdKey(SOPLink,SOPLineNo),IdetailF,IdLinkK));

      If (Not FoundOk) then
        FoundOk:=(Round(Id.QtyDel+Id.QtyWOff)=0);

    end;

  end; {With..}

  Id:=TmpId^;

  Dispose(TmpId);

  DelSOP_Link:=FoundOk;

end; {Func..}

{$ENDIF}


Function TTransMList.Ok2Del :  Boolean;

Begin
  {$IFDEF STK}

    With Id do
    Begin
      Result:=((PostedRun = 0) and (LineNo>0));

      Result:=(Result and (Not (DayBkListMode In [6,8,10,11]))
                 and (Round(QtyDel+QtyWOff)=0) and (LineType=StkLineType[IdDocHed]));

      Result:=(Result and (DelSOP_Link(Id)));

    end;
  {$ELSE}
    With Id do
      Result:=((PostedRun = 0) and (LineNo>0) and (Not (DayBkListMode In [6,8,10,11])));
  {$ENDIF}

end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TTransMList.OutLine(Col  :  Byte)  :  Str255;


Var
  Idx    :  LongInt;
  CrDr   :  DrCrType;
  FoundCode
         :  Str20;
  GenStr :  Str255;

  ViewOnly,
  ShowDet: Boolean;

  ExLocal: ^TdExLocal;


Begin

  ExLocal:=ListLocal;

   With ExLocal^,Id do
   Begin


     {$IFDEF STK}
       If (Is_FullStkCode(StockCode)) and (LStock.StockCode<>StockCode) then
        Begin
          GetStock(Self,StockCode,FoundCode,-1);
          AssignFromGlobal(StockF);
        end;
     {$ENDIF}
     
     Case DayBkListMode of

       0  :  Case Col of

               0  :  Begin
                       OutLine:=StockCode;

                     end;

               1  :  OutLine:=Item;

               2  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,Calc_IdQty(Qty,QtyMul,UsePack)),BOn);

               3  :  OutLine:=Desc;

               4  :  OutLine:=FormatBFloat(GenRealMask,InvLTotal(Id,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken))),(Qty=0.0));

               5  :  Begin
                       If (VATIncFlg In VATSet) and (VATCode In VATEqStd) then
                         GenStr:=VATCode+VATIncFlg
                       else
                         GenStr:=VATCode;

                       //PR: 17/06/2009 Added check for vatcode = #0 to avoid showing dodgy char on MBD Desc Lines.
                       OutLine:=FormatBChar(GenStr,(Qty=0.00) or (VATCode = #0));
                     end;

               6  :  OutLine:=FormatBFloat(GenUnitMask[IdDocHed In SalesSplit],NetValue,(Qty=0.0));


               7  :  {$IFDEF SOP}
                     begin //PR: 06/05/2009 Change to show Advanced Discounts
                       OutLine:= PPR_PamountStr(Discount,DiscountChr) + '/' +
                                 PPR_PamountStr(Discount2,Discount2Chr) + '/' +
                                 PPR_PamountStr(Discount3,Discount3Chr);
                       if Result = '//' then
                         Result := '';
                     end;
                     {$ELSE}
                     OutLine:=PPR_PamountStr(Discount,DiscountChr);
                     {$ENDIF}
               else
                     OutLine:='';
             end; {Case..}

       1  :  Case Col of

               0  :  OutLine:=StockCode;

               1  :  OutLine:=MLocStk;

               2  :  OutLine:=POutDate(PDate);

               3  :  OutLine:=Form_BInt(NomCode,0);

               4,5
                  :  OutLine:=CCDep[(Col=4)];

               6  :  Begin
                       Rnum:=InvLTotal(Id,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));
                       OutLine:=FormatBFloat(GenRealMask,Rnum,(Qty=0.0));
                     end;

               7  :  Begin
                       Rnum2:=InvLCost(Id)+InvLCost2(Id);
                       OutLine:=FormatBFloat(GenRealMask,Rnum2,(Qty=0.0));
                     end;

               8  :  OutLine:=FormatBFloat(GenRealMask,Rnum-Rnum2,(Qty=0.0));


               9  :  OutLine:=FormatBFloat(GenPcntMask,Calc_Pcnt(Rnum,(Rnum-Rnum2)),(Qty=0.0));

              //PR: 19/03/2009 Added functionality for Reconciliation Date
              10  :  if ValidDate(ReconDate) and (ReconDate < MaxUntilDate) then
                       OutLine:= POutDate(ReconDate)
                     else
                       OutLine := '';


               else
                     OutLine:='';
             end; {Case..}

       {$IFDEF STK}
         2  :  Case Col of

                 0  :  OutLine:=dbFormatName(StockCode,Desc);

                 1  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,Calc_IdQty(Qty,QtyMul,UsePack)),BOn);

                 2  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyDel),(Qty=0.0));


                 3  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyWOff),(Qty=0.0));


                 4
                    :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,Qty_OS(Id)),(Qty=0.0));


                 5  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyPick),BOn);

                 6  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyPWOff),BOn);


                 else
                       OutLine:='';
               end; {Case..}
       {$ENDIF}

       3  :  Case Col of

               0  :  OutLine:=StockCode;

               1  :  OutLine:=Desc;

               2  :  OutLine:=JobCode;


               3  :  OutLine:=AnalCode;


               4
                  :  OutLine:=FormatBFloat(GenRealMask,InvLTotal(Id,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken))),(Qty=0.0));


               else
                     OutLine:='';
             end; {Case..}

       else  OutLine:='';

     end; {Case..}
   end;
end;



{ =================================================================================== }


{ =================================================================================== }

