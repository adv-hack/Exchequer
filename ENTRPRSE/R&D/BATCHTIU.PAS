{ ============== TBatchMList Methods =============== }



Function TBatchMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;

  TmpLNo,
  TmpRunNo,
  TmpFolio  :  LongInt;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Inv do
  Begin
    DumStr:=BatchLink;

  end;

  SetCheckKey:=DumStr;
end;




Function TBatchMList.SetFilter  :  Str255;

Begin
  Result:=DocCodes[Inv.InvDocHed];
end;


Function TBatchMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;




{ ========== Generic Function to Return Formatted Display for List ======= }


Function TBatchMList.OutLine(Col  :  Byte)  :  Str255;


Var

  Dnum   : Double;

  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;

   With ExLocal^,BatchLine do
   Begin
     Doc2Batch(BatchLine,Inv);

     Get_BatchId(BatchLine,Inv);

     Case DayBkListMode of

       0  :  Case Col of
               0  :  Begin
                       OutLine:=SBTRef;
                     end;

               1  :  Begin

                       OutLine:=BCustCode;

                     end;

               2  :  OutLine:=POutDate(BPDate);

               3  :  OutLine:=BYourRef;

               4  :  OutLine:=BDesc;

               5  :  Begin
                       Dnum:=Calc_BatchLine(BatchLine);

                       OutLine:=FormatFloat(GenRealMask,Dnum);
                     end;

               6  :  OutLine:=FormatBChar(VATCode,(BOn));

               else
                     OutLine:='';
             end; {Case..}
       1  :  Case Col of
               0  :  Begin
                       OutLine:=SBTRef;
                     end;

               1  :  Begin
                       OutLine:=BCustCode;

                     end;

               2  :  OutLine:=Form_BInt(BNomCode,0);

               3,4
                  :  OutLine:=BCCDep[Col=3];

               5  :  OutLine:=BJobCode;

               6  :  OutLine:=BJobAnal;

               7  :  OutLine:=FormatBChar(VATCode,(BOn));


               else
                     OutLine:='';
             end; {Case..}
     end; {case..}
   end; {With..}
end;



{ =================================================================================== }



