{ ============== TRecepMList Methods =============== }


Function TSheetMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Id do
  Begin

    Case Keypath of

      IdFolioK :  DumStr:=FullIdKey(FolioRef,LineNo);

   end; {Case..}

  end;

  SetCheckKey:=DumStr;
end;




Function TSheetMList.SetFilter  :  Str255;

Begin

  Result:=Id.Payment;

end;


Function TSheetMList.Ok2Del :  Boolean;

Begin
  With Id do
    Result:=((PostedRun = 0) or (PostedRun=StkAdjRunNo));

end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TSheetMList.OutLine(Col  :  Byte)  :  Str255;


Var

  FoundLong
         :  LongInt;

  GenStr :  Str255;

  ViewOnly,
  ShowDet: Boolean;

  Dnum   : Double;

  CrDr   : DrCrType;


  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;

   With ExLocal^,Id do
   Begin
     Case Col of

       0  :  OutLine:=JobCode;

       1  :  Begin
               OutLine:=StockCode;
             end;

       2  :  OutLine:=AnalCode;

       3,4
          :  Begin

               {$IFDEF PF_On}

                 If (Syss.UseCCDep) then
                   OutLine:=CCDep[(Col=3)]
                 else
                   OutLine:='';

               {$ELSE}

                 OutLine:='';

               {$ENDIF}

             end;

       5
          :  Begin
               Result:=FormatBFloat(GenQtyMask,Qty,BOff);

             end;

       6  :  Begin
               Result:=FormatCurFloat(GenUnitMask[BOff],NetValue,BOff,Currency);

             end;


       7  :  Begin
               Dnum:=DetLTotal(Id,BOn,BOff,0.0);

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,Currency);

             end;

       else
             OutLine:='';
     end; {Case..}
   end; {With..}
end;



{ =================================================================================== }

