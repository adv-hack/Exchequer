{ ============== TBPMList Methods =============== }


Function TBPMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With MiscRecs^ do
  Begin
    DumStr:=PartCCKey(RecMfix,SubType)+FIFORec.FIFOCode;
  end;


  SetCheckKey:=DumStr;
end;




Function TBPMList.SetFilter  :  Str255;

Begin
  Result:=MiscRecs^.RecMFix;
end;


Function TBPMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;



Function TBPMList.CheckRowEmph :  Byte;


Begin
  With MiscRecs^, BACSSRec do
  Begin
    Result:=Ord(HasTagged[0]);
  end;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TBPMList.OutLine(Col  :  Byte)  :  Str255;

Var
  Dnum  :  Double;

Begin

  With MiscRecs^, BACSSRec do
  Begin

    Case Col of

       0  :  Result:=TagCustCode;

       1
          :  Begin

               Result:=FormatCurFloat(GenRealMask,BatchDocSign(SalesCust,TotalTagged[0]),BOff,BatchCtrl.PayCurr);
             end;

       2..5
          :    Result:=FormatCurFloat(GenRealMask,BatchDocSign(SalesCust,TotalOS[Col-1]),BOff,BatchCtrl.PayCurr);


       // CJS 2015-05-08 - v7.0.14 - PPD - T2-157 - PPD Column
       6 :  begin
              if (MiscRecs.BACSSRec.TraderPPDPercentage <> 0) then
                Result := FormatFloat('0.00', MiscRecs.BACSSRec.TraderPPDPercentage) + '% / ' + IntToStr(MiscRecs.BACSSRec.TraderPPDDays)
              else
                Result := '';

            end;
       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


Procedure TBPMList.Find_CustOnList(RecMainKey  :  Str255);
Var
  KeyS,
  KeyChk  :  Str255;


Begin

  KeyChk:=KeyRef+RecMainKey;
  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);

  If (Not StatusOk) or (Not CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
    ShowMessage('Unable to find any batch entries for account '+Strip('B',[#32],RecMainKey));

  If (StatusOk) then
  Begin
    Status:=GetPos(F[ScanFileNum],ScanFileNum,PageKeys^[0]);


    PageUpDn(0,BOn);

    Send_ListRecMsg(0,1,0,0);
  end;

end;




{ =================================================================================== }

