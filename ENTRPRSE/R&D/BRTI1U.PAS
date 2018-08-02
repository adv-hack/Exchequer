{ ============== TBRMList Methods =============== }


Function TBRMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With MiscRecs^ do
  Begin
    DumStr:=PartCCKey(RecMfix,SubType)+BankMRec.BankMatch;

    If (UseSet4End) and (CalcEndKey) and (DisplayMode=2) then  {* If A special end key calculation is needed *}
      DumStr:=PartCCKey(RecMFix,SubType)+FullNomKey(LastAddrD);

  end;

  SetCheckKey:=DumStr;
end;




Function TBRMList.SetFilter  :  Str255;

Begin
  Case DisplayMode of
    1  :  Result:=MiscRecs^.RecMFix;
    2  :  Result:=Form_Int(MiscRecs^.BankMRec.EntryStat,0);
  end; {Case..}
end;


Function TBRMList.Ok2Del :  Boolean;

Begin
  Result := False;
  Case DisplayMode of
    1  :  Result:=BOn;
    2  :  Result:=BOff;
  end; {Case..}
end;



Function TBRMList.CheckRowEmph :  Byte;


Begin
  Result := 0;
  With MiscRecs^, BankMRec do
    Case DisplayMode of
      1  :  Result:=Ord(EntryStat=1);

      2  :  Result:=(1*Ord(EntryStat=1))+(2*Ord(Tagged));
    end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TBRMList.OutBMLine(Col  :  Byte)  :  Str255;

Var
  Dnum   :  Double;
  CrDr   :  DrCrType;

Begin

  With MiscRecs^, BankMRec do
  Begin

    Case Col of

       0  :  Result:=BankRef;

       1,2
          :  Begin
               ShowDrCr(BankValue,CrDr);

               Result:=FormatBFloat(GenRealMask,CrDr[Col=2],BOn);
             end;

       3  :  Result:=BankMEStatus(EntryStat,BOff)+FullOurRefKey(MatchDoc);

       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TBRMList.OutBMMLine(Col  :  Byte)  :  Str255;

Var
  Dnum   :  Double;
  CrDr   :  DrCrType;
  GenStr :  Str255;

Begin
  GenStr:='';
              
  With MiscRecs^, BankMRec do
  Begin


    Case Col of

       0  :  Result:=BankRef;

       1,2
          :  Begin
               Blank(CrDr,Sizeof(CrDr));

               CrDr[(EntryStat=2)]:=BankValue;

               Result:=FormatBFloat(GenRealMask,CrDr[Col=2],BOn);
             end;

       3  :  Begin
               GenStr:=PoutDate(EntryDate);

               If (EntryStat=1) then
               Begin
                 GenStr:=GenStr+' '+MatchDoc;
               end
               else
               Begin
                 GenStr:=GenStr+Spc(10);
               end;

               If (Tagged) then
                 GenStr:=GenStr+' *';

               Result:=GenStr;
             end;


       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


Function TBRMList.OutLine(Col  :  Byte)  :  Str255;

Begin
  Case DisplayMode of
    1  :  Result:=OutBMLine(Col);
    2  :  Result:=OutBMMLine(Col);
  end; {Case..}
end;

{ =================================================================================== }

