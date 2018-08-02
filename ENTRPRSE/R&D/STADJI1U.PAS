{ ============== TRecepMList Methods =============== }


Function TAdjMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Id do
  Begin

    Case Keypath of

      IdFolioK :  Begin
                    DumStr:=FullIdKey(FolioRef,LineNo);

                    If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                      DumStr:=FullIdKey(FolioRef+1,1);
                  end;

   end; {Case..}

  end;

  SetCheckKey:=DumStr;
end;




Function TAdjMList.SetFilter  :  Str255;

Begin

  Result:=Id.Payment;

end;


Function TAdjMList.Ok2Del :  Boolean;

Begin
  With Id do
    Result:=((PostedRun = 0) or (PostedRun=StkAdjRunNo));

end;


Function TAdjMList.CheckRowEmph :  Byte;

Var
  ChkRecon  :  Byte;

Begin
  With Id do
  Begin
    If (DisplayMode In [17..19]) then
    Begin
      If (Stock.StockCode<>StockCode) then
        Global_GetMainRec(StockF,StockCode);

      Result:=Ord(((SerialQty<>(Qty*QtyMul)) or (DisplayMode=17)) and (Is_SERNo(Stock.StkValType)));

      If (Result=0) then
        Result:=Ord(((BinQty<>(Qty*QtyMul)) or (DisplayMode=17)) and (Stock.MultiBinMode));
    end
    else
      Result:=0;

  end;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TAdjMList.OutLine(Col  :  Byte)  :  Str255;


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
  Result:='';
  
  ExLocal:=ListLocal;

   With ExLocal^,Id do
   Begin
     Case Col of

       0  :  OutLine:=StockCode;

       1  :  Begin
               If (Stock.StockCode<>StockCode) then
                 Global_GetMainRec(StockF,StockCode);

               OutLine:=Stock.Desc[1];
             end;

       2,3
          :  Begin
               GenStr:='';

               ShowDrCr(Qty*QtyMul,CrDr);

               OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,CrDr[(Col=3)]),(CrDr[(Col=3)]=0.0));
             end;

       4  :  Begin
               If (DisplayMode In [17..19]) then
               Begin
                 If (CheckRowEmph=1) then
                 Begin
                   If (Stock.MultiBinMode) then
                     OutLine:='Bin'
                   else
                     OutLine:='SNo.';
                 end;
               end
               else
                 OutLine:=YesNoBo((KitLink=1));
             end;

       5  :  If (DisplayMode In [17..19]) then
               OutLine:=MLocStk
             else
               OutLine:=FormatFloat(GenUnitMask[BOff],CostPrice);


       6  :  If (DisplayMode In [17..19]) then
               OutLine:=FormatFloat(GenUnitMask[BOff],CostPrice)
             else
               OutLine:=MLocStk;

       7  :  OutLine:=Form_Int(NomCode,0);

       8,9
          :  Begin

               {$IFDEF PF_On}

                 If (Syss.UseCCDep) then
                   OutLine:=CCDep[(Col=8)]
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

