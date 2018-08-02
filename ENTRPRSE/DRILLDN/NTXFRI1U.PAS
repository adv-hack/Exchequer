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
                      DumStr:=DumStr+NdxWeight;
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

  Function FormatBFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean)  :  Str255;
  Begin
    If (Value<>0.0) or (Not SBlnk) then
      Result:=FormatFloat(Fmask,Value)
    else
      Result:='';
  end;


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

               If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) Then
                 // IFDEF MC_On
                 If (CrDr[(Col=4)]<>0.0) then
                   GenStr:=SSymb(Currency);


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

                 If (Syss.UseCCDep) then
                 //PL 17/01/2017 2017-R1 ABSEXCH-18051 : OLE Drilldown - duplication of Dept code in CC column on NOM Transactions 
                   OutLine:=CCDep[(Col=7)]
                 else
                   OutLine:='';

             end;

       else
             OutLine:='';
     end; {Case..}
   end; {With..}
end;



{ =================================================================================== }


{ =================================================================================== }

