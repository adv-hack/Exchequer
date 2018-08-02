{ ============== TJRMList Methods =============== }



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TJRList.OutLine(Col  :  Byte)  :  Str255;


Var

  GenStr :  Str255;

  TCr    :  Byte;

  Rnum   :  Real;

  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;


   With ExLocal^,LNHCtrl,Inv do
   Begin
     Case Col of

       0  :  Result:=OurRef;
       1  :  Result:=POutDate(Get_StaChkDate(Inv));
       2  :  Begin
               Case DisplayMode of
                 0  :  Begin
                         Rnum:=(Itotal(Inv)*DocCnst[InvDocHed]*DocNotCnst);
                         Result:=FormatCurFloat(GenRealMask,Rnum,BOff,Currency);
                       end;

               end; {Case..}

             end;
       3  :  Begin
               TCr:=NHCr;

               Case DisplayMode of
                 0  :  Begin
                         If (NHCr<>0) then
                           TCr:=0;

                         Rnum:=(ConvCurrItotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst);
                       end;

               end; {Case..}

               Result:=FormatCurFloat(GenRealMask,Rnum,BOff,TCr);

             end;

       4  :  Begin
               Case DisplayMode of

                 0  :  Begin

                         If (NHCr=0) then
                           Rnum:=Settled
                         else
                           Rnum:=CurrSettled;


                       end;


               end; {Case..}


               Result:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);
             end;

       5  :  Begin
               Case DisplayMode of
                 0  :  Begin
                         If (NHCr=0) then
                           Rnum:=BaseTotalOs(Inv)
                         else
                           Rnum:=CurrencyOS(Inv,BOn,BOff,BOff);
                       end;


               end; {Case..}

               Result:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);

             end;





       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


{ =================================================================================== }

