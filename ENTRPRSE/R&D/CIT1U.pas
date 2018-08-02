{ ============== TAPMList Methods =============== }


Function TCPMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With JobDetl^ do
  Begin
    Case Keypath of
      JDAnalK    :  DumStr:=PartCCKey(RecPfix,SubType)+JobCISV.CISVCode2;
      JDEmpK     :  DumStr:=PartCCKey(RecPfix,SubType)+JobCISV.CISVDateS;
      JDLedgerK  :  DumStr:=PartCCKey(RecPfix,SubType)+JobCISV.CISVCode1;
      JDLookK    :  DumStr:=PartCCKey(RecPfix,SubType)+JobCISV.CISvSDate;
      JDStkK     :  DumStr:=PartCCKey(RecPfix,SubType)+JobCISV.CISCertNo;
    end; {Case..}
  end;


  SetCheckKey:=DumStr;
end;




Function TCPMList.SetFilter  :  Str255;

Begin
  //AP 12/10/2017 ABSEXCH-18533:CIS ledger	
  Result:=Chr(JobDetl^.JobCISv.CISHTax);
end;




Function TCPMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;



Function TCPMList.CheckRowEmph :  Byte;


Begin

  With JobDetl^.JobCISV do
  Begin
    Result:=Ord(Copy(CISVCode2,1,LDateKeyLen)=SyssCIS^.CISRates.CurrPeriod);

  end;
end;


{ == Proc to pick up parent invoice header == }

Function TCPMList.Link2Inv  :  Boolean;

Var
  KeyS  :  Str255;

Begin
  With JobDetl^.JobCISV do
  Begin
    If (Inv.OurRef<>CISVORef) and (CISVOref<>'') then
    Begin
      KeyS:=CISVORef;
      Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);

      Result:=StatusOk;
    end
    else
      Result:=BOn;

  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TCPMList.OutLine(Col  :  Byte)  :  Str255;

Var
  Dnum  :  Double;

  KeyJF,
  GenStr:  Str255;

  EInv  :  InvRec;

Begin

  With JobDetl^.JobCISV do
  Begin
    Link2Inv;

    EInv:=Inv;


    Case Col of

       0  : If (CIS340) then
              Result:=CIS340VTypeName(CISHTax)
            else
              Result:=CISVTypeName(CISCType);


       1  :  Begin
               KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)));


               If (Global_GetMainRec(JMiscF,KeyJF)) then
               With JobMisc^,EmplRec do
                 Result:=dbFormatName(EmpCode,EmpName)
               else
                 Result:='';
             end;

       2  :  Result:=CISCertNo;

       3  :  Result:=POutDate(Copy(CISVCode2,1,LDateKeyLen));

       4
          :  Begin
               Dnum:=CISvGrossTotal;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,CISCurr);
             end;

       5
          :  Begin
               Dnum:=CalcCISJDMaterial(JobDetl^);

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,CISCurr);
             end;

       6
          :  Begin
               Dnum:=CISTaxableTotal;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,CISCurr);
             end;

       7
          :  Begin
               Dnum:=CISvTaxDue;

               Result:=FormatCurFloat(GenRealMask,Dnum,BOff,CISCurr);
             end;

       8
          :  Begin
               Result:=CISVOref;
             end;

       9
          :  Begin
               KeyJF:=FullCustCode(Copy(CISvSDate,1,CustKeyLen));

               If (Global_GetMainRec(CustF,KeyJF)) then
               With Cust do
                 Result:=dbFormatName(CustCode,Company)
               else
                 Result:='';
             end;



       else
             Result:='';
     end; {Case..}


   end; {With..}
end;






{ =================================================================================== }



