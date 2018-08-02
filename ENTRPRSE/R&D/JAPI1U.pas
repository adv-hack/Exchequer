{ ============== TRecepMList Methods =============== }


procedure TJAPPMList.ExtObjCreate;

Begin
  Inherited;

  sLineType:=TStringList.Create;

  Set_JAPDefaultDocT(sLineType,0);
end;



procedure TJAPPMList.ExtObjDestroy;

Begin
  sLineType.Free;
end;


Function TJAPPMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;

  TmpLNo,
  TmpRunNo,
  TmpFolio  :  LongInt;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With Id do
  Begin

    Case Keypath of

      IdFolioK
               :  Begin
                    If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                    Begin
                      TmpLNo:=MaxLInt;

                    end
                    else
                      TmpLNo:=LineNo;


                    DumStr:=FullIdKey(FolioRef,TmpLNo);

                  end;
   end; {Case..}

  end;

  SetCheckKey:=DumStr;
end;





Function TJAPPMList.SetFilter  :  Str255;

Begin
  If (Id.Reconcile=0) then
    Result:=Id.Payment
  else
    Result:=NdxWeight;

end;


Function TJAPPMList.Ok2Del :  Boolean;

Begin
  With Id do
    Result:=((IdDocHed In JAPJAPSplit) or ((QtyDel+QtyPWoff)=0.0)) and (Not PrxPack) {or (SBSIn)};

end;


Function TJAPPMList.CheckRowEmph :  Byte;

Var
  ChkRecon  :  Byte;

Begin
  With Id do
  Begin
    Begin
      Result:=0;
    end;

  end;
end;

{ CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
function TJAPPMList.CalcApplied: Double;
begin
  if (Id.IdDocHed in JAPJAPSplit) and (Displaymode = 0)  then
  begin
    if (Inv.TransNat = 2) then
      Result := Id.CostPrice + Id.QtyDel
    else
      Result := Id.CostPrice;
  end
  else
    Result := Id.QtyDel;
end;

{ ========== Generic Function to Return Formatted Display for List ======= }


Function TJAPPMList.OutLine(Col  :  Byte)  :  Str255;


Var

  FoundCode
         :  Str20;

  GenStr :  Str255;

  ViewOnly,
  ShowDet: Boolean;

  Dnum   : Double;

  CrDr   : DrCrType;


  ExLocal: ^TdExLocal;

Begin
  ExLocal:=ListLocal;

  Result:='';

   With ExLocal^, Id do
   Begin
     Case Col of

       0  :  OutLine:=JobCode;

       1  :  Begin
               OutLine:=AnalCode;
             end;

       2
          :  Begin

               OutLine:=FormatFloat(GenQtyMask,Qty);
             end;

       3
          :  Begin {Budget}
               Case IdDocHed of
                 JSA,JPA  :  OutLine:=FormatFloat(GenRealMask,Get_JTLink(Id,ScanFileNum,IdLinkK,Keypath).CostPrice);
                 else        OutLine:=FormatFloat(GenRealMask,CostPrice);
               end; {Case..}
             end;

       4
          :  Begin {Applied}
               { CJS 2012-08-17 - ABSEXCH-12317 - JST Delete Check }
               DNum := CalcApplied;
               OutLine:=FormatFloat(GenRealMask,Dnum);

               {
               If (IdDocHed In JAPJAPSplit) and (Displaymode=0)  then
               Begin
                 If (Inv.TransNat=2) then
                   Dnum:=CostPrice+QtyDel
                 else
                   Dnum:=CostPrice;

                 OutLine:=FormatFloat(GenRealMask,Dnum)

               end
               else
                 OutLine:=FormatFloat(GenRealMask,QtyDel);
               }

               if (Dnum <> 0) then
                 AppliedTotalFound := True;
             end;

       5
          :  Begin {Cerified}
               If (IdDocHed In JAPJAPSplit) and (Displaymode=0) then
               Begin
                 If (Inv.TransNat=2) then
                   Dnum:=NetValue+QtyPWOff
                 else
                   Dnum:=NetValue;

                 OutLine:=FormatFloat(GenRealMask,Dnum)

               end
               else
                 OutLine:=FormatFloat(GenRealMask,QtyPWOff);

             end;
       6
          :  Begin

               OutLine:=FormatBFloat(GenRealMask,VAT,(VAT=0.0));
             end;

       7
          :  Begin
               OutLine:=VATCode;
             end;


       8
          :  Begin
               If (DocLTLink>0) then
                 OutLine:=sLineType.Strings[DocLTLink]
               else
                 OutLine:='';
             end;

       9
          :  Begin
               OutLine:='';

             end;

       10 :  OutLine:=Form_Int(NomCode,0);

       11,12
          :  Begin

               {$IFDEF PF_On}

                 If (Syss.UseCCDep) then
                   OutLine:=CCDep[(Col=11)]
                 else
                   OutLine:='';

               {$ELSE}

                 OutLine:='';

               {$ENDIF}

             end;

       else
             OutLine:='';
     end; {Case..}
   end; {With..}
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


procedure TJDedMList.ExtObjCreate;

Begin
  Inherited;

  sDedLineType:=TStringList.Create;
  sRetLineType:=TStringList.Create;

  Set_DefaultJADed(sDedLineType,BOff,BOff);

  Set_DefaultJARet(sRetLineType,BOff,BOff);

end;



procedure TJDedMList.ExtObjDestroy;

Begin
  sDedLineType.Free;
  sRetLineType.Free;
end;


Function TJDedMList.OutLine(Col  :  Byte)  :  Str255;


Var

  FoundCode
         :  Str20;

  GenStr :  Str255;

  ViewOnly,
  ShowDet: Boolean;

  Dnum   : Double;

  CrDr   : DrCrType;


  ExLocal: ^TdExLocal;

Begin
  ExLocal:=ListLocal;

  Result:='';

   With ExLocal^,Id do
   Begin
     Case Col of

       0  :  OutLine:=AnalCode;

       1  :  Begin
               OutLine:=Desc
             end;

       2
          :  Begin
               If (DiscountChr=PcntChr) then
                 OutLine:=FormatFloat(GenPcnt2dMask,Discount)
               else
                 FormatFloat(GenRealMask,Discount);
               
             end;

       3
          :  Begin
               OutLine:=FormatFloat(GenRealMask,NetValue);
             end;
       4
          :  Begin
               Case Reconcile of
                 1  :  If (KitLink>=0) then
                         OutLine:=sDedLineType.Strings[KitLink];
                 else  If (COSNomCode>=0) then
                         OutLine:=sRetLineType.Strings[COSNomCode];
               end;

             end;

       5
          :  Begin

               OutLine:=YesNoBo(ShowCase);
             end;

       6  :  OutLine:=JobCode;


       else
             OutLine:='';
     end; {Case..}
   end; {With..}
end;



{ =================================================================================== }


{ =================================================================================== }
