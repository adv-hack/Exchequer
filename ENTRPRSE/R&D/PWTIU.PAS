{ ============== TPWMList Methods =============== }


Function TPWMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Password do
  Begin
    DumStr:=FullPWordKey(RecPfix,SubType,PassEntryRec.Login);
  end; {With..}


  SetCheckKey:=DumStr;
end;




Function TPWMList.SetFilter  :  Str255;

Begin
  Result:=PassWord.SubType;
end;


Function TPWMList.Ok2Del :  Boolean;

Begin
  Result:=BOn;
end;



Function TPWMList.CheckRowEmph :  Byte;


Begin
  With Password.PassEntryRec do
  Begin
    Result:=Ord(CUser=Login);
  end;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TPWMList.OutLine(Col  :  Byte)  :  Str255;


Begin

  With Password.PassEntryRec do
  Begin

    Case Col of

       0  :  Result:=Login;

       else
             Result:='';
     end; {Case..}


   end; {With..}
end;



{ =================================================================================== }


{ ============== TPLMList Methods =============== }


Function TPLMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;





{ ========== Generic Function to Return Formatted Display for List ======= }


Function TPLMList.OutLine(Col  :  Byte)  :  Str255;

Var
  Tbo  :  Boolean;

Begin

  With Password.PassListRec do
  Begin

    Case Col of

       0  :  Begin
               Tbo:=(EntryRec2.Access[PassLNo]>0);

               Result:=YesNoBo(Tbo);
             end;

       1  :  Begin
               Result:=PassDesc;

               {$IFDEF DBD}
                 {If (Debug) then
                   Result:=Result+'. PGrp '+Form_Int(PassGrp,0)+'. LNo '+Form_Int(PassNo,0)+'. P1Lno '+Form_Int(PassLNo,0);}

               {$ENDIF}
             end;

       else
             Result:='';
     end; {Case..}


   end; {With..}
end;



{ =================================================================================== }

