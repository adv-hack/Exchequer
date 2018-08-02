{ ============== TRNMList Methods =============== }


Function TRNMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With MiscRecs^ do
  Begin
    DumStr:=RecMFix+SubType;
  end; {With..}


  SetCheckKey:=DumStr;
end;




Function TRNMList.SetFilter  :  Str255;

Var
  LChk  :  LongInt;

Begin

  Result:=FullNomKey(0);
end;


Function TRNMList.Ok2Del :  Boolean;

Begin
  Result:=BOn;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TRNMList.OutLine(Col  :  Byte)  :  Str255;

Var
  NextNo :  LongInt;
  DocHed :  DocTypes;
  GenStr :  Str255;

Begin

  With MiscRecs^.rtReasonRec do
  Begin

    Case Col of

       0  :  Begin
               Result:=Form_Int(ReasonCount,0);
             end;
       1  :  Begin
               Result:=ReasonDesc;

             end;

       
       else
             Result:='';
     end; {Case..}


   end; {With..}
end;




