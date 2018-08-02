{ ============== TRecepMList Methods =============== }


Function TWORMList.SetCheckKey  :  Str255;


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





Function TWORMList.SetFilter  :  Str255;

Begin

  Result:=Id.Payment;

end;


Function TWORMList.Ok2Del :  Boolean;

Begin
  With Id do
    Result:=(QtyDel=0.0);

end;


Function TWORMList.CheckRowEmph :  Byte;

Var
  ChkRecon  :  Byte;

Begin
  With Id do
  Begin
    Begin
      If (Stock.StockCode<>StockCode) then
        Global_GetMainRec(StockF,StockCode);

      Result:=Ord(Stock.StockType=StkBillCode);

      If (Result=1) then
        Result:=Result+Ord(LineNo=1);
    end;

  end;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TWORMList.OutLine(Col  :  Byte)  :  Str255;


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

       0  :  OutLine:=StockCode;

       1  :  Begin
               If (Stock.StockCode<>StockCode) then
                 Global_GetMainRec(StockF,StockCode);

               If (LineNo=1) then
                 OutLine:=Desc
               else
                 OutLine:=Stock.Desc[1];
             end;

       2
          :  Begin

               OutLine:=FormatFloat(GenQtyMask,QtyMul);
             end;

       3
          :  Begin

               OutLine:=FormatFloat(GenQtyMask,WORReqQty(Id));
             end;

       4
          :  Begin

               OutLine:=FormatBFloat(GenQtyMask,QtyPWOff,(QtyPWOff=0.0));
             end;
       5
          :  Begin

               OutLine:=FormatBFloat(GenQtyMask,QtyDel,(QtyDel=0.0) and (LineNo<>1));
             end;

       6
          :  Begin
               If (LineNo=1) then
                 OutLine:=FormatBFloat(GenQtyMask,BuildQty_OS(Id),(BuildQty_OS(Id)=0.0))
               else
                 OutLine:=FormatBFloat(GenQtyMask,Qty_OS(Id),(Qty_OS(Id)=0.0));
             end;


       7
          :  Begin

               OutLine:=FormatBFloat(GenQtyMask,QtyPick,(QtyPick=0.0));
             end;

       8
          :  Begin
               If (CtrlBOM.QtyWOff<>0) or (LineNo=1) then
                 OutLine:=FormatBFloat(GenQtyMask,QtyWOff,(QtyWOff=0.0))
               else
               Begin
                 Dnum:=FreeStock(Stock);

                 If (Not Syss.UseWIss4All) then
                   Dnum:=Dnum+Qty_OS(Id)
                 else
                   Dnum:=Dnum+QtyPick;

                 OutLine:=FormatBFloat(GenQtyMask,Dnum,(Qty_OS(Id)=0.0))
               end;
             end;

       9  :  OutLine:=FormatFloat(GenUnitMask[BOff],CostPrice);

       10  :  OutLine:=MLocStk;

       11  :  OutLine:=Form_Int(NomCode,0);

       12,13
          :  Begin

               {$IFDEF PF_On}

                 If (Syss.UseCCDep) then
                   OutLine:=CCDep[(Col=12)]
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
