{ ============== TCCMList Methods =============== }


Function TCCMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Password do
  Begin
    DumStr:=FullCCKey(RecPfix,SubType,CostCtrRec.PCostC);
  end; {With..}


  SetCheckKey:=DumStr;
end;




Function TCCMList.SetFilter  :  Str255;

Begin
  Result:=PassWord.RecPFix;
end;


Function TCCMList.Ok2Del :  Boolean;

Begin
  Result:=BOn;
end;



Function TCCMList.CheckRowEmph :  Byte;


Begin
  With Password.CostCtrRec do
  Begin
    Result:=(1*Ord(CCTag))+(2*HideAc);
  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TCCMList.OutLine(Col  :  Byte)  :  Str255;


Begin

  With Password.CostCtrRec do
  Begin

    Case Col of

       0  :  Result:=PCostC;

       1  :  Result:=CCDesc;


       else
             Result:='';
     end; {Case..}


   end; {With..}
end;



{ =================================================================================== }


{ =================================================================================== }

