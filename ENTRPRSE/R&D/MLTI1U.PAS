{ ============== TMLMList Methods =============== }


procedure TMLMList.ExtObjCreate;

Begin
  Inherited;


  LAutoMLId:=nil;

end;


Function TMLMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With MLocCtrl^ do
  Begin
    Case Keypath of
      MLK     :  DumStr:=PartCCKey(RecPfix,SubType)+MStkLoc.LsCode1;
      MLSecK  :  DumStr:=PartCCKey(RecPfix,SubType)+MStkLoc.LsCode2;
    end;
  end;

  SetCheckKey:=DumStr;
end;




Function TMLMList.SetFilter  :  Str255;

Begin
  Case DisplayMode of
    1,2  :  Result:=MLocCtrl^.RecPFix;
      3  :  Result:=MLocCtrl^.MLocLoc.loCode;
  end; {Case..}
end;


Function TMLMList.Ok2Del :  Boolean;

Var
  KeyS  :  Str255;

Begin
  Case DisplayMode of
    1,2  :  Begin
              KeyS:=CostCCode+CSubCode[BOff]+Full_MlocKey(MLocCtrl^.MLocLoc.loCode);

              Result:=Not CheckExsists(KeyS,MLocF,MLSecK);
            end;  

    21   :  With MLocCtrl^,MStkLoc do
            Begin
              Result:=(((lsQtyInStock=0.0) and (lsQtyPosted=0.0) and (lsQtyOnOrder=0.0) and
                         (AllocMLocStock(MStkLoc)=0.0)) or SBSIn);

            end;

    else    Result:=BOff;

  end; {Case..}

end;



Function TMLMList.CheckRowEmph :  Byte;


Begin
  With MLocCtrl^, MLocLoc do
  Begin
    Result:=Ord(loTag);
  end;
end;




{ ========== Generic Function to Return Formatted Display for List ======= }


Function TMLMList.OutMLLine(Col  :  Byte)  :  Str255;

Begin
  With MLocCtrl^, MLocLoc do
  Begin

    Case Col of

       0  :  Result:=loCode;

       1  :  Result:=loName;


       else
             Result:='';
     end; {Case..}
   end; {With..}
end;



Function TMLMList.OutLSLine(Col  :  Byte)  :  Str255;

Var
  L        :  Integer;
  TStkLoc  :  MStkLocType;
  Dnum     :  Double;

  ExLocal  : ^TdExLocal;


Begin

  ExLocal:=ListLocal;


  With ExLocal^, MLocCtrl^, MLocLoc, TStkLoc do
  Begin

    Case Col of

       0  :  Result:=loCode;

       1  :  Result:=loName;

       2  :  Begin
               If LinkMLoc_Stock(loCode,LStock.StockCode,TStkLoc) then;

               Dnum:=CaseQty(LStock,FreeMLocStock(TStkLoc));

               Result:=FormatFloat(GenQtyMask,Dnum);
             end;

       3  :  Begin
               If (Assigned(LAutoMLId)) then
                 Dnum:=LAutoMLId^.FindLQty(ExLocal.LId,loCode)
               else
                 Dnum:=0;

               Result:=FormatFloat(GenQtyMask,Dnum);
             end;
       4  :  Begin
               Dnum:=CaseQty(LStock,lsQtyOnOrder);

               Result:=FormatFloat(GenQtyMask,Dnum);
             end;

       else
             Result:='';
     end; {Case..}
   end; {With..}
end;


Function TMLMList.OutSLLine(Col  :  Byte)  :  Str255;

Var
  L        :  Integer;
  TLocLoc  :  MLocLocType;
  Dnum     :  Double;
  ExLocal  : ^TdExLocal;


Begin
  ExLocal:=ListLocal;

  With ExLocal^, MLocCtrl^, MStkLoc, TLocLoc do
  Begin
    

    Case Col of
       0  :  Begin
               If LinkMLoc_Loc(lsLocCode,TLocLoc) then;

               Result:=loCode;
             end;

       1  :  Result:=loName;

       2  :  Begin
               Dnum:=CaseQty(LStock,lsQtyInStock);

               Result:=FormatFloat(GenQtyMask,Dnum);
             end;

       3  :  Begin
               Dnum:=CaseQty(LStock,FreeMLocStock(MStkLoc));

               Result:=FormatFloat(GenQtyMask,Dnum);
             end;
       4  :  Begin
               Dnum:=CaseQty(LStock,lsQtyOnOrder);

               Result:=FormatFloat(GenQtyMask,Dnum);
             end;


       else
             Result:='';
     end; {Case..}


   end; {With..}
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TMLMList.OutLine(Col  :  Byte)  :  Str255;


Begin
  Case DisplayMode of
    1,2  :  Result:=OutMLLine(Col);
      3  :  Result:=OutLSLine(Col);
    21   :  Result:=OutSLLine(Col);
    else    Result:='';

  end; {Case..}
end;



{ =================================================================================== }

