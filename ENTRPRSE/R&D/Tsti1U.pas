{ ============== TBRMList Methods =============== }


procedure TTSList.ExtObjCreate;

Begin
  Inherited;

  tMargin:=0.0;
end;



procedure TTSList.ExtObjDestroy;

Begin
  
  Inherited;


end;



Function TTSList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case ScanFileNum of


    MLocF :  With MLocCtrl^ do
               Begin
                 Case Keypath of
                   MLK     :  DumStr:=PartCCKey(RecPfix,SubType)+MStkLoc.LsCode1;
                   MLSecK  :  DumStr:=PartCCKey(RecPfix,SubType)+MStkLoc.LsCode2;
                 end;
               end;
    StockF:  DumStr:=Stock.StockCode;

  end;

  SetCheckKey:=DumStr;
end;




Function TTSList.SetFilter  :  Str255;

Begin
  Case ScanFileNum of

    MLocF :  Case DisplayMode of
               1..3,20..23
                     :  With ListCSAnal^ do
                        Begin
                          {$B-}
                          {$IFDEF DBD}
                            If (Debug) and (Copy(MLocCtrl^.cuStkRec.csStockCode,1,4)='DESC') then
                              MessageBeep(0);
                          {$ENDIF}

                          If (OrdMode=1) and (Not Chk_OSLines(ListCSAnal^,MLocCtrl^.CuStkRec)) then
                            Result:=NdxWeight
                          else
                            If (OrdMode=3) and (MLocCtrl^.CuStkRec.csQty=0.0) then
                              Result:=NdxWeight
                            else
                              Result:=MLocCtrl^.RecPFix;

                          If (IsTeleS) and (Result<>NdxWeight) then {Check it stock discontinued}
                          Begin
                            If (Stock.StockCode<>MLocCtrl^.CuStkRec.csStockCode) then
                            Begin
                              Global_GetMainRec(StockF,MLocCtrl^.CuStkRec.csStockCode);

                            end;

                            If (Stock.StockType=StkDListcode) then
                              Result:=NdxWeight;

                          end;


                          {$B+}
                        end;
               else     Result:='';
             end; {Case..}

    StockF:  Result:=Stock.StockType;
  end; {Case..}


end;


Function TTSList.Ok2Del :  Boolean;

Begin
  Case DisplayMode of
    1,3  :  Result:=BOn;
    else    Result:=BOff;

  end; {Case..}
end;


Function TTSList.LinktoCuRec:  Boolean;

Const
  Fnum      =  MLocF;
  Keypath2  =  MLSecK;

Var
  KeyChk    :  Str255;

Begin
  If (ScanFileNum=StockF) then
  With MLocCtrl^.cuStkRec, ListCSAnal^ do
  Begin
    KeyChk:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(CCode,Stock.StockCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyChk);

    If (Not StatusOk) then
    Begin
      ResetRec(Fnum);

      csStockCode:=Stock.StockCode;
      csStkFolio:=Stock.StockFolio;
    end;

    Result:=StatusOk;
  end
  else
    Result:=BOn;
end;


Function TTSList.CheckRowEmph :  Byte;


Begin
  LinktoCuRec;

  With MLocCtrl^.cuStkRec, ListCSAnal^ do
    If Not IsTeleS then
      Result:=Ord(csLastDate<>'')
    else
      Result:=(2*Ord(csLastDate=''))+(1*Ord(csEntered));
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TTSList.OutTSLine(Col  :  Byte)  :  Str255;

  Const
    Fnum      =  MLocF;
    Keypath2  =  MLSecK;


  Var
    TCh       :  Char;

    Bnum      :  Byte;

    TmpBo     :  Boolean;

    Idx       :  Integer;

    GenStr    :  Str80;

    KeyChk,
    FmtQty    :  Str255;

    PSales,
    PDisc     :  Real;
    DNum      :  Double;

    IdR       :  IDetail;

Begin
  With MLocCtrl^, CuStkRec do
  Begin
    DNum:=0.0; TCh:=#0; TmpBo:=BOff; PSales:=0.0;

    PDisc:=0.0; BNum:=0;  FmtQty:='';


    Case Col of

       0  :  Begin
               With ListCSAnal^ do
               Begin

                 If (ScanFileNum=StockF) then
                 Begin
                   LinktoCuRec;

                 end
                 else
                 Begin
                   If (Stock.StockCode<>csStockCode) then
                     Global_GetMainRec(StockF,csStockCode);

                 end;


                 SetCsAnal(BOff);
               end;


               If (DisplayMode=2) then
                 BackCalcTS(ListCSAnal^);

               With ListCSAnal^ do
               Begin

                 {$IFDEF SOP}
                     If (OwnPNo) then
                     Begin
                       GenStr:=GetAltStkDet(1,CCode,0,SFolio);

                       If (GenStr='') then
                         GenStr:=csStockCode;
                     end

                     else
                 {$ENDIF}

                   GenStr:=csStockCode;
               end;

               Result:=dbFormatName(GenStr,Stock.Desc[1]);
               
             end;

       1  :  Begin
               // MH 27/05/2010 v6.4 ABSEXCH-2633: Modified to display last price to 2dp
               //If (DisplayMode=2) then
               //  FmtQty:=GenQtyMask
               //else
               //  FmtQty:=GenUnitMask[BOn];

               Case DisplayMode of {* Needs Converting *}

                 2  :  With ListCSAnal^ do
                       Begin
                         FmtQty:=GenQtyMask;
                         Dnum:=CaseQty(Stock,DVals[1]);
                       End; // With ListCSAnal^

                 3  :  Begin
                         FmtQty:=GenRealMask;

                         Dnum:=csLastPrice;

                         Dnum:=Currency_Txlate(Dnum,csLPCurr,TeleSHed^.TeleSRec.tcCurr);
                       end;


               end; {Case..}


               Result:=FormatBFloat(FmtQty,Dnum,DisplayMode=3);
             end;

       2
          :  Begin
               Case DisplayMode of {* Needs Converting *}

                  2  :  With ListCSAnal^ do
                          Dnum:=CaseQty(Stock,DVals[2]);

                  3  :  Begin
                          {$IFDEF SOP}

                            Stock_LocSubst(Stock,ListCSAnal^.LocFilt);

                          {$ENDIF}


                          Dnum:=CaseQty(Stock,FreeStock(Stock));
                        end;



               end; {Case..}

               Result:=FormatBFloat(GenQtyMask,Dnum,BOff);
             end;

       3
          :  Begin
               Case DisplayMode of {* Needs Converting *}

                 2  :  With ListCSAnal^ do
                         Dnum:=CaseQty(Stock,DVals[3]);

                 3  :  Dnum:=CaseQty(Stock,csSOQty);


               end; {Case..}

               Result:=FormatBFloat(GenQtyMask,Dnum,BOff);
             end;

       4  :    Begin
                 Dnum:=CaseQty(Stock,csQty);

                 Result:=FormatBFloat(GenQtyMask,Dnum,BOff);
               end;


       6
          :  Begin
              // Only update the unit price column if this is not a SQL
              // compile, or if SQL is not being used (in the SQL version the
              // unit price will be displayed in a separate panel).
{$IFDEF EXSQL}
               if not SQLUtils.UsingSQL then
               begin
{$ENDIF}
                 If (CsQty=0) and (Not csEntered) then
                 With ListCSAnal^ do
                 Begin
                   TmpBo:=BOn;

                   If (csLastPrice=0) or (Not csEntered) then
                   Begin
                     Calc_StockPrice(Stock,Cust,TeleSHed^.TeleSRec.tcCurr,csSOQty,TeleSHed^.TeleSRec.tcTDate,
                     PSales,PDisc,TCh,LocFilt,TmpBo,0);

                     Dnum:=Round_Up(PSales-Calc_PAmount(Round_Up(PSales,Syss.NoNetDec),PDisc,TCh),
                                   Syss.NoNetDec);
                   end
                   else
                   Begin
                     Dnum:=csLastPrice;
                     Dnum:=Currency_Txlate(Dnum,csLPCurr,TeleSHed^.TeleSRec.tcCurr);
                   end;

                 end
                 else
                 Begin

                   Dnum:=Round_Up(csNetValue-Calc_PAmount(Round_Up(csNetValue,Syss.NoNetDec),csDiscount,csDiscCh),
                                       Syss.NoNetDec);

                 end;
{$IFDEF EXSQL}
               end;
{$ENDIF}

               Result:=FormatBFloat(GenRealMask,Dnum,BOff);
             end;

       5  :  Begin
               TL2Id(IdR,CuStkRec);

               Dnum:=InvLTotal(IdR,BOn,0);

               Result:=FormatBFloat(GenRealMask,Dnum,BOff);
             end;

       9: begin
            Result := Stock.UnitS;
          end;
       else
             Result:='';
     end; {Case..}


   end; {With..}
end;


{ ========== Generic Function to Return Formatted Display for List ======= }

Function TTSList.SetCSAnal(GetRec  :  Boolean)  :  Boolean;

Begin
  If (GetRec) then
    Result:=ValidLine
  else
    Result:=BOn;

  If (Result) then
    With MLocCtrl^.cuStkRec,ListCSAnal^ do
    Begin
      If (ScanFileNum=MLocF) then
      Begin
        SCode:=csStockCode;
        SFolio:=csStkFolio
      end
      else
      Begin
        SCode:=Stock.StockCode;
        SFolio:=Stock.StockFolio;
      end;
    end;

end;

Function TTSList.OutSLLine(Col  :  Byte)  :  Str255;

Const
  Fnum      =  MLocF;
  Keypath2  =  MLSecK;


Var
  TCh       :  Char;

  NoDecs,
  Bnum      :  Byte;

  TmpBo     :  Boolean;

  Idx       :  Integer;

  GenStr    :  Str80;

  FmtQty,
  KeyChk    :  Str255;

  PSales,
  PDisc     :  Real;
  DNum      :  Double;


Begin
  Result:='';
  NoDecs:=Syss.NoNetDec;
  
  With MLocCtrl^, CuStkRec do
  Begin
    DNum:=0.0; TCh:=#0; TmpBo:=BOff; PSales:=0.0;

    PDisc:=0.0; BNum:=0;

    Case Col of

       0  :  Begin
               With ListCSAnal^ do
               Begin

                 If (ScanFileNum=StockF) then
                 Begin
                   LinktoCuRec;

                 end
                 else
                 Begin
                   If (Stock.StockCode<>csStockCode) then
                     Global_GetMainRec(StockF,csStockCode);

                 end;


                 SetCsAnal(BOff);
               end; {With..}

               BackCalcCS(ListCSAnal^);


               With ListCSAnal^ do
               Begin
                 {$IFDEF SOP}
                     If (OwnPNo) then
                     Begin
                       GenStr:=GetAltStkDet(1,CCode,0,SFolio);

                       If (GenStr='') then
                         GenStr:=csStockCode;
                     end

                     else
                 {$ENDIF}

                 GenStr:=csStockCode;
               end;

               Result:=dbFormatName(GenStr,Stock.Desc[1]);
               
             end;

       1,2
          :  Begin
               If (Col=1) or (DisplayMode<>1) then
                 FmtQty:=GenQtyMask
               else
                 FmtQty:=GenRealMask;

               If (Col=1) or (DisplayMode<>1) then
                 Dnum:=CaseQty(Stock,ListCSAnal^.Dvals[Col])
               else
                 Dnum:=ListCSAnal^.Dvals[Col];

               Result:=FormatBFloat(FmtQty,Dnum,BOff);
             end;

       3  :  Begin
               If (DisplayMode=1) then
               Begin
                 FmtQty:=GenRealMask;
               end
               else
               With ListCsAnal^ do
               Begin
                 FmtQty:=GenUnitMask[ListCSAnal^.IsaC];

                 If (IsAC) then
                   NoDecs:=Syss.NoNetDec
                 else
                   NoDecs:=Syss.NoCosDec;
               end;

               Case DisplayMode of {* Needs Converting *}

                  1  :  With ListCSAnal^ do
                          If (IsaC) then
                            Dnum:=DVals[2]-DVals[3]
                          else
                            Dnum:=0.0;

                  2  :  Dnum:=csLastPrice;

                  3  :  With ListCSAnal^ do
                        Begin
                          TmpBo:=BOn;

                          Calc_StockPrice(Stock,Cust,RCr,csSOQty,Today,PSales,PDisc,TCh,LocFilt,TmpBo,0);

                          Dnum:=Round_Up(PSales-Calc_PAmount(Round_Up(PSales,NoDecs),PDisc,TCh),
                                        NoDecs);

                        end;

               end; {Case..}

               tMargin:=Dnum;

               Result:=FormatBFloat(FmtQty,Dnum,BOff);
             end;

       4  :
             If (DisplayMode<>2) then
             Begin
               // MH 27/05/2010 v6.4 ABSEXCH-2633: Modified to display last price to 2dp
               //FmtQty:=GenUnitMask[ListCSAnal^.IsaC];
               FmtQty:=GenRealMask;

               Result:=FormatBFloat(FmtQty,csLastPrice,BOff);
             end;

       7  :  If (DisplayMode<>3) then
               Result:=POutDateB(csLastDate);

       8  :  If (DisplayMode=1) then
             Begin
               Result:=FormatBFloat(GenPcntMask,Calc_Pcnt(ListCSAnal^.DVals[2],tMargin),BOff);
             end;


    end; {Case..}
  end; {With..}
end;


Function TTSList.OutLine(Col  :  Byte)  :  Str255;

Begin
  Case ListCSAnal^.isTeleS of
    BOff  :  Result:=OutSLLine(Col);
    BOn   :  Result:=OutTSLine(Col);
  end; {Case..}
end;


procedure TTSList.Find_Now(Cu   :   Str10;
                           St   :   Str20);

Var
  KeyChk,
  KeyFind  :  Str255;
  POk      :  Boolean;

Begin
  POk:=BOff;

  Case ListCSAnal^.ScanMode of
    1  :  Begin
            KeyFind:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(Cu,St);
            KeyChk:=Trim(KeyFind);

            Status:=Find_Rec(B_GetGEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyFind);

            POk:=(StatusOk and (CheckKey(KeyChk,KeyFind,Length(KeyChk),BOff)));
          end;

    2  :  Begin
            POk:=BOn;
          end;
  end; {Case..}

  If (POk) then
  Begin
    Status:=GetPos(F[ScanFileNum],ScanFileNum,PageKeys^[0]);
    KeyAry^[0]:=SetCheckKey;

    MUListBoxes[0].Row:=0;

    PageUpDn(0,BOn);

    If (Owner is TForm) and (ValidLine) then
    Begin
      PostMessage(TForm(Owner).Handle,WM_FormCloseMsg,1,0);
    end;
  end
  else
    ShowMessage('The stock item '+Trim(St)+' could not be found on this list.');

end;

function TTSList.UnitPrice: double;
var
  TCh     : Char;
  TmpBo   : Boolean;
  PSales,
  PDisc   : Real;
  DNum    : Double;
begin
  Result := 0.0;
  PSales := 0.0;
  DNum   := 0.0;
  TCh    := #0;
  TmpBo  := BOff;
  PDisc  := 0.0;
  with MLocCtrl^, CuStkRec do
  begin
    if (CsQty = 0) and (not csEntered) then
    with ListCSAnal^ do
    begin
     TmpBo := BOn;

     if (csLastPrice = 0) or (not csEntered) then
     begin
       Calc_StockPrice(Stock, Cust, TeleSHed^.TeleSRec.tcCurr, csSOQty,
                       TeleSHed^.TeleSRec.tcTDate, PSales, PDisc, TCh, LocFilt,
                       TmpBo, 0);

       Dnum := Round_Up(PSales - Calc_PAmount(Round_Up(PSales, Syss.NoNetDec),
                        PDisc, TCh), Syss.NoNetDec);
     end
     else
     begin
       Dnum := csLastPrice;
       Dnum := Currency_Txlate(Dnum, csLPCurr, TeleSHed^.TeleSRec.tcCurr);
     end;
    end
    else
    begin
      Dnum := Round_Up(csNetValue -
                       Calc_PAmount(Round_Up(csNetValue, Syss.NoNetDec),
                                    csDiscount, csDiscCh),
                       Syss.NoNetDec);
    end;
    Result := Dnum;
    //Result := FormatBFloat(GenRealMask, Dnum, BOff);
  end;
end;

{ =================================================================================== }

