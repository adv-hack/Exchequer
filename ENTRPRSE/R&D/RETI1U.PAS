{ ============== TRecepMList Methods =============== }


Function TRetMList.SetCheckKey  :  Str255;


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





Function TRetMList.SetFilter  :  Str255;

Begin

  Result:=Id.Payment;

end;


Function TRetMList.Ok2Del :  Boolean;

Begin
  With Id do
    Result:=(Round_Up({Qty+}QtyDel,Syss.NoQtyDec)=0.0);

end;


Function TRetMList.CheckRowEmph :  Byte;

Var
  ChkRecon  :  Byte;

Begin
  With Id do
  Begin
    Begin
      If (Stock.StockCode<>StockCode) then
        Global_GetMainRec(StockF,StockCode);

      Result:=Ord(Qty_OS(Id)<>0.0);

      Result:=Result+(2*Ord(NomIOFlg));

      {If (Result=1) then
        Result:=Result+Ord(LineNo=1);}
    end;

  end;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TRetMList.OutLine(Col  :  Byte)  :  Str255;


Var

  FoundCode
         :  Str20;

  GenStr :  Str255;

  ViewOnly,
  ShowDet: Boolean;

  Dnum   : Double;

  CrDr   : DrCrType;


  ExLocal: ^TdExLocal;

Begin
  ExLocal:=ListLocal;

  Result:='';

   With ExLocal^,Id do
   Begin
     Case Col of

       0  :  Begin
               If (Stock.StockCode<>StockCode) then
                 Global_GetMainRec(StockF,StockCode);

               Result:=dbFormatName(StockCode,Desc);

             end;

       1
          :  Begin

               OutLine:=FormatBFloat(GenQtyMask,QtyPick,EmptyKey(StockCode,StkKeyLen));
             end;

       2
          :  Begin

               OutLine:=FormatBFloat(GenQtyMask,Qty,(Qty=0.0));
             end;

       3
          :  Begin

               OutLine:=FormatBFloat(GenQtyMask,QtyDel+QtyPWOff,(QtyDel+QtyPWOff=0.0));
             end;
       4
          :  Begin
               If (DisplayMode<>0) then
                 OutLine:=FormatBFloat(GenQtyMask,QtyWOff+SSDUplift,(QtyWOff+SSDUplift=0.0))
               else
                 OutLine:=FormatBFloat(GenQtyMask,Qty_Os(Id),(Qty_Os(Id)=0.0));
             end;

       5   :  OutLine:=Get_RetLineStat(DocLTLink);

       6
          :  Begin
               If (DisplayMode<>1) then
                 OutLine:=FormatBFloat(GenRealMask,InvLTotal(Id,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken))),(Qty=0.0))
               else
                 OutLine:=FormatBFloat(GenUnitMask[BOff],CostPrice,BOff);
             end;
       7
          :  Begin
               OutLine:=FormatBFloat(GenUnitMask[IdDocHed In STKRetSalesSplit],NetValue,(Qty=0.0));
             end;

       8
          :  Begin
               If (VATCode In VATSet) then
                 OutLine:=VATCode
               else
                 OutLine:='';
             end;

       09  :  OutLine:=MLocStk;

       10  :  OutLine:=Form_BInt(NomCode,0);

       11,12
          :  Begin

               {$IFDEF PF_On}

                 If (Syss.UseCCDep) then
                   OutLine:=CCDep[(Col=11)]
                 else
                   OutLine:='';

               {$ELSE}

                 OutLine:='';

               {$ENDIF}

             end;

       else
             OutLine:='';
     end; {Case..}
   end; {With..}
end;



{ =================================================================================== }


{ =================================================================================== }
