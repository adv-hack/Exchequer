{ ============== TRecepMList Methods =============== }


Function TNTxfrMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Id do
  Begin

    Case Keypath of

      IdFolioK :  Begin
                    DumStr:=FullIdKey(FolioRef,LineNo);

                    If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                      DumStr:=FullIdKey(FolioRef+1,1);
                  end;

   end; {Case..}

  end;

  SetCheckKey:=DumStr;
end;




Function TNTxfrMList.SetFilter  :  Str255;

Begin

  Result:=Id.Payment;

end;


Function TNTxfrMList.Ok2Del :  Boolean;

Begin
  With Id do
    Result:=((PostedRun = 0) or (PostedRun=StkAdjRunNo));

end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TNTxfrMList.OutLine(Col  :  Byte)  :  Str255;


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

       0  :  OutLine:=Desc;

       1  :  Begin
               OutLine:=Form_Int(NomCode,0);

               If (Nom.NomCode<>NomCode) then
                 GetNom(Self,Form_Int(NomCode,0),FoundLong,-1);
             end;

       2  :  OutLine:=Nom.Desc;


       3,4
          :  Begin
               GenStr:='';

               ShowDrCr(NetValue,CrDr);

               {$IFDEF MC_On}

                 If (CrDr[(Col=4)]<>0.0) then
                   GenStr:=SSymb(Currency);

               {$ENDIF}


               OutLine:=GenStr+FormatBFloat(GenRealMask,CrDr[(Col=4)],(CrDr[(Col=4)]=0.0));

             end;
       5  :  Begin
               If (NOMIOFlg<>0) then
                 OutLine:=VATCode
               else
                 OutLine:=#32;
             end;
       6
          :  Begin
               OutLine:=FormatBFloat(GenRealMask,VAT,(NOMIOFlg=0));
             end;

       7,8
          :  Begin

               {$IFDEF PF_On}

                 If (Syss.UseCCDep) then
                   OutLine:=CCDep[(Col=7)]
                 else
                   OutLine:='';

               {$ELSE}

                 OutLine:='';

               {$ENDIF}

             end;

          //PR: 19/03/2009 Added functionality for Reconciliation Date
       9  :  if ValidDate(ReconDate) and (ReconDate < MaxUntilDate) then
               Outline := POutDate(Id.ReconDate)
             else
               Outline := '';

       else
             OutLine:='';
     end; {Case..}
   end; {With..}
end;



{ =================================================================================== }


{ =================================================================================== }

