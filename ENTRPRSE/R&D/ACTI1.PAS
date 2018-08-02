{ ============== TACMList Methods =============== }


Function TACMList.SetCheckKey  :  Str255;


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




Function TACMList.SetFilter  :  Str255;

Begin
  Case DisplayMode of
    1,2  :  Result:=MLocCtrl^.RecPFix;
      3  :  Result:=MLocCtrl^.SdbStkRec.sdSuppCode;
  end; {Case..}

end;


Function TACMList.Ok2Del :  Boolean;


Begin
  Result:=BOn;
end;




{ ========== Generic Function to Return Formatted Display for List ======= }


  Function TACMList.OutAltList(Col  :  Byte)  :  Str255;

  Begin
    With MLocCtrl^, sdbStkRec do
    Begin

      Case Col of

         0  :  Result:=sdSuppCode;

         1  :  Result:=sdCode1;

         2  :  Result:=FormatCurFloat(GenUnitMask[BOff],sdROPrice,BOn,sdROCurrency);


         else
               Result:='';
       end; {Case..}
     end; {With..}
  end;



  Function TACMList.OutOpoList(Col  :  Byte)  :  Str255;

  Begin
    With MLocCtrl^, sdbStkRec do
    Begin

      Case Col of

         0  :  Result:=sdCode1;

         1  :  Begin

                 Result:=sdDesc;
               end;

         2  :  Result:=FormatBFloat(GenQtyMask,sdLineQty,BOn);


         else
               Result:='';
       end; {Case..}
     end; {With..}
  end;

{ ========== Generic Function to Return Formatted Display for List ======= }


  Function TACMList.OutLine(Col  :  Byte)  :  Str255;

  Begin
    Begin

      Case DisplayMode of

         0  :  Result:=OutAltList(Col);

         else  Result:=OutOpoList(Col);
       end; {Case..}
     end; {With..}
  end;






{ =================================================================================== }

