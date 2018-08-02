{ ============== TMAMList Methods =============== }


Function TMAMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Password do
  With MatchPayRec do
  Begin
    Case DisplayMode of
      3  :  DumStr:=FullMatchKey(RecPFix,SubType,DocCode);
      4  :  DumStr:=FullMatchKey(RecPFix,SubType,PayRef);
    end; {Case..}
  end; {With..}


  SetCheckKey:=DumStr;
end;




Function TMAMList.SetFilter  :  Str255;

Begin

  Result:=PassWord.RecPFix+Password.SubType;


end;


Function TMAMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;


{ ========== find Inv link ======== }


Function TMAMList.Link2Inv  :  Boolean;


Const
  Fnum     =  InvF;
  KeyPath2 =  InvOurRefK;



Var
  KeyS   :  Str255;

  ACnst  :  Integer;


Begin
  Result:=BOff;

  With Password.MatchPayRec do
  Begin

    Blank(KeyS,Sizeof(KeyS));

    Case DisplayMode of

      3  :  Begin

              KeyS:=PayRef;

            end;

      4  :  Begin

              KeyS:=DocCode;

            end;


    end; {Case..}

    If (Inv.OurRef<>KeyS) then
    Begin
      ResetRec(Fnum);

      If (KeyS<>'') then
      Begin

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);
        Result:=StatusOk;
      end;
    end
    else
      Result:=BOn;
  end; {With..}
end;

{ ========== Generic Function to Return Formatted Display for List ======= }


Function TMAMList.OutLine(Col  :  Byte)  :  Str255;



Var
  Idx,
  TCurr  :  Byte;

  GenStr :  Str80;
  DrCr   :  DrCrType;
  Rnum   :  Real;

  ACnst  :  Integer;

    ExLocal: ^TdExLocal;

Begin
  ExLocal:=ListLocal;

  With LNHCtrl,Inv do
  With Password.MatchPayRec do
  Begin

    TCurr:=0;

    ACnst:=1;

    Case DisplayMode of

      3  :  Begin

              ACnst:=-1;

            end;

      4  :  Begin

              ACnst:=1;

            end;


    end; {Case..}

    Link2Inv;

    Case Col of

       0  :  Case DisplayMode of

               3  :  Begin

                       OutLine:=PayRef;

                     end;

               4  :  Begin

                       OutLine:=DocCode;

                     end;
             end; {Case..}

       1  :  OutLine:=YourRef;

       2  :  OutLine:=POutDate(TransDate);

       3  :  Begin
               If (NHCr=0) and ((Copy(DocCode,1,3)<>DocCodes[POR]) or (Copy(PayRef,1,3)<>DocCodes[SOR])) then
               Begin
                 If (DisplayMode=4) and (Copy(DocCode,1,3)=DocCodes[SOR]) then
                   Rnum:=ITotal(Inv)-Inv.InvVat
                 else
                   Rnum:=SettledVal*ACnst;
                 TCurr:=NHCr;
               end
               else
               Begin
                 

                 Rnum:=OwnCVal*ACnst;
                 TCurr:=MCurrency;
               end;


               OutLine:=FormatCurFloat(GenRealMask,Rnum,BOff,TCurr);
             end;


       else
             OutLine:='';
     end; {Case..}


   end; {With..}
end;



{ =================================================================================== }


{ =================================================================================== }

