{ ============== TRecepMList Methods =============== }


{*

   Please note: - Most of the Budget update routines have been duplicated into a thread safe object
                  in PayF2U. Any changes must be made in both places *}


Function TNHMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  With NHist do
  Begin
    If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
      TmpYr:=YTD
    else
      TmpYr:=Yr;

      DumStr:=FullNHistKey(ExClass,Code,Cr,TmpYr,Pr);
  end;

  SetCheckKey:=DumStr;
end;




Function TNHMList.SetFilter  :  Str255;

Begin

  Result:=NHist.ExClass;

end;


Function TNHMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;

Function TNHMList.CheckRowEmph :  Byte;
Begin
  Result:=Ord(NHist.Pr In [YTD,YTDNCF]);
end;



{ ========= Function to Return TYD for Budgets ======== }


Function TNHMList.Get_BudgetYTD(TCode      :  Char;
                                Per        :  Byte;
                            Var Bud2,
                                Bud3,
                                Bud4       :  Double)  :  Double;



Var

  TmpKPath,
  TmpStat
             :  Integer;

  TmpRecAddr :  LongInt;

  Sales,
  Purch,
  Cleared,
  Rnum,
  TmpBudget,
  TBudget2   :  Double;


  TmpNHist   :  HistoryRec;

  OldStat    :  Integer;


Begin
  TmpBudget:=0;

  Begin
    TmpNHist:=NHist;

    OldStat:=Status;

    TmpKPath:=Keypath;

    TmpStat:=Presrv_BTPos(ScanFilenum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

    With NHist do
      Rnum:=Total_Profit_to_Date(TCode,Code,Cr,Yr,Per,Purch,Sales,Cleared,TmpBudget,TBudget2,Bud3,Bud4,(Per=YTD));

    Get_BudgetYTD:=TmpBudget;

    Bud2:=TBudget2;

    NHist:=TmpNHist;

    TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOn,BOff);

    Status:=OldStat;

  end; {With..}

end; {Func..}



Function TNHMList.Get_CommitValues(PrevNHist  :  HistoryRec)  :  HistoryRec;

Var
  OldNHist  :  HistoryRec;
  TmpKPath,
  TmpStat,
  OldStat
            :  Integer;

  TmpRecAddr:  LongInt;

  KeyNH,
  KeyOld     :  Str255;

Begin
  {$IFDEF SOP}


    With LNHCtrl do
    Begin
      If (Not (NHCommitView In [1,2])) then
        Result:=NHist
      else
      Begin
        Result:=PrevNHist;

        With NHist do
          KeyNH:=FullNHistKey(ExClass,Code,Cr,Yr,Pr);

        With PrevNHist do
          KeyOld:=FullNHistKey(ExClass,Code,Cr,Yr,Pr);

        If (KeyNH<>KeyOld) then {It needs refreshing *}
        Begin
          OldStat:=Status;

          Result:=NHist;

          If (NHCommitView=2) then {*We only want comitted values*}
          With Result do
          Begin
            Sales:=0.0;
            Purchases:=0.0;
          end;

          OldNHist:=NHist;

          TmpKPath:=Keypath;

          TmpStat:=Presrv_BTPos(ScanFilenum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

          Blank(KeyNH,Sizeof(KeyNH));

          With Result do
            KeyNH:=FullNHistKey(ExClass,CommitKey+Code,Cr,Yr,Pr);

          Status:=Find_Rec(B_GetEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,keypath,KeyNH);

          If (StatusOk) then
          With Result do
          Begin
            Sales:=Sales+NHist.Sales;
            Purchases:=Purchases+NHist.Purchases;
          end;

          NHist:=OldNHist;

          TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOn,BOff);

          Status:=OldStat;
        end;

      end; {For commitment values}
    end; {With..}
  {$ELSE}
      Result:=NHist;

  {$ENDIF}
end;


{$IFDEF STK}
  Function TNHMList.Get_QtyUsed(PrevNHist  :  HistoryRec)  :  HistoryRec;

  Var
    OldNHist  :  HistoryRec;
    TmpKPath,
    TmpStat,
    OldStat
              :  Integer;

    TmpRecAddr:  LongInt;

    KeyNH,
    KeyOld     :  Str255;

  Begin
    With LNHCtrl do
    Begin
      Result:=PrevNHist;
      OldNHist:=NHist;
      OldStat:=Status;

      Blank(KeyNH,Sizeof(KeyNH));

      If (NHist.Pr=YTDNCF) then {Because this total piggy backs off the posted total, the ytd is a rolling one and so we have to force the
                                 period to be YTD as the visual record being used is a sales qty which is a YTDNCF type.
                                 The advantage of doing this is that a check can recalculate this ...}
        NHist.Pr:=YTD;

      With NHist do
        KeyNH:=FullNHistKey(Calc_AltStkHCode(ExClass),Code,Cr,Yr,Pr);

      TmpKPath:=Keypath;

      TmpStat:=Presrv_BTPos(ScanFilenum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

      Status:=Find_Rec(B_GetEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,keypath,KeyNH);


      If (StatusOk) then
      Begin
        Result:=NHist;
      end;

      NHist:=OldNHist;

      TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOn,BOff);

      Status:=OldStat;
    end; {With..}
  end;
{$ENDIF}


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TNHMList.OutLine(Col  :  Byte)  :  Str255;


Var

  FoundLong
         :  LongInt;

  GenStr :  Str255;

  AutoBlank,
  ShowAsQty,
  ViewOnly,
  ShowDet: Boolean;

  TCr    : Byte;

  Profit,
  Bud2,
  Bud3,
  Bud4,
  Dnum   : Double;

  FormatStr
         : Str255;


  ExLocal: ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  FormatStr:=GenRealMask;

  AutoBlank:=BOff;

  Dnum:=0;  ShowAsQty:=BOff;

  ViewNHist:=Get_CommitValues(ViewNHist);
  
   With ExLocal^,LNHCtrl,ViewNHist do
   Begin
     Case Col of

       0  :  Begin
               If (NHMode=4) then
                 OutLine:=SOutPeriod(Pr,Yr)
               else
                 OutLine:=PPr_OutPr(Pr,Yr);


             end;

       1..4
          :  Begin
               Case NHMode of


                 9,88
                     :  Begin
                         {$IFDEF STK}

                           Case Col  of

                             1   :  Begin
                                      Dnum:=Cleared;
                                      FormatStr:=GenQtyMask;
                                      ShowAsQty:=BOn;
                                    end;

                             2   :  Begin

                                       Dnum:=Currency_Txlate(Sales,NHCr,NHTxCr);

                                     end;

                             3   :  Begin
                                      Profit:=Calc_Pcnt(Sales,(Sales-Purchases));

                                      If (PChkAllowed_In(143)) then
                                        Dnum:=Profit
                                      else
                                        Dnum:=0.0;

                                      FormatStr:=GenPcntMask;

                                    end;

                             4   :  
                                    Begin
                                      If (LStock.StockType<>StkGrpCode) then
                                        Dnum:=Get_QtyUsed(LNHist).Value1
                                      else
                                        Dnum:=0.0;

                                      FormatStr:=GenQtyMask;
                                      ShowAsQty:=BOn;
                                    end;

                           end; {Case..}

                         {$ENDIF}

                       end;

                10  :  Begin
                         {$IFDEF PF_On}

                            Case Col of

                              1
                                     :  Begin

                                          Profit:=Get_BudgetYTD(Rev_AltStkHCode(ExClass),Pr,Bud2,Bud3,Bud4);

                                          Profit:=Currency_Txlate(Profit,NHCr,NHTxCr);

                                          Dnum:=Profit;

                                        end;

                              2      :  Begin

                                          Profit:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4);

                                          Profit:=Calc_Pcnt(Profit,Budget);

                                          Dnum:=Profit;

                                          FormatStr:=GenPcntMask;
                                        end;

                              4      :  Begin
                                          Dnum:=Currency_Txlate(Budget,NHCr,NHTxCr);
                                          FormatStr:=GenProfileMask;
                                        end;

                            end; {Case..}

                          {$ENDIF}

                       end;

                11,91
                   :  Begin {* Budget view for normal view *}

                         Case Col of

                           1
                                  :  Begin
                                       Profit:=Purchases-Sales;

                                       Dnum:=Currency_Txlate(Profit,NHCr,NHTxCr);

                                     end;

                           2      :  Begin

                                       If (Pr In [YTD,YTDNCF]) then
                                         Dnum:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4)
                                       else
                                         Dnum:=Budget;

                                       Dnum:=Currency_Txlate(Dnum,NHCr,NHTxCr);

                                     end;
                           3      :  Begin
                                       If (Pr In [YTD,YTDNCF]) then
                                       Begin
                                         BudgetTot:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4);

                                         If (Bud2<>0.0) then
                                           BudgetTot:=Bud2;

                                         Dnum:=Bud2;
                                       end
                                       else
                                       Begin
                                         BudgetTot:=RevisedBudget1;

                                         If (BudgetTot=0.0) then
                                           BudgetTot:=Budget;

                                         Dnum:=RevisedBudget1;
                                       end;

                                       Dnum:=Currency_Txlate(Dnum,NHCr,NHTxCr);

                                     end;

                           4      :  Begin
                                       Profit:=(BudgetTot-(Purchases-Sales));

                                       Dnum:=Currency_Txlate(Profit,NHCr,NHTxCr);

                                     end;
                         end; {Case..}
                       end;
                12,92
                    :  Begin {* Budget view for Stock view *}

                         Case Col of

                           1
                                  :  Begin

                                       Dnum:=Cleared;

                                       FormatStr:=GenQtyMask;

                                       ShowAsQty:=BOn;
                                     end;

                           2      :  Begin
                                       If (NHMode=92) then
                                       Begin
                                         If (Pr In [YTD,YTDNCF]) then
                                         Begin
                                           BudgetTot:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4);

                                           BudgetTot:=Bud3;

                                         end
                                         else
                                         Begin
                                           BudgetTot:=Value1;

                                         end;
                                       end
                                       else
                                       Begin

                                         If (Pr In [YTD,YTDNCF]) then
                                           BudgetTot:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4)
                                         else
                                           BudgetTot:=Budget;


                                       end;

                                       Dnum:=BudgetTot;

                                       FormatStr:=GenQtyMask;

                                       ShowAsQty:=BOn;
                                     end;
                           3      :  Begin
                                       If (NHMode=92) then
                                       Begin
                                         If (Pr In [YTD,YTDNCF]) then
                                         Begin
                                           BudgetTot:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4);

                                           BudgetTot:=Bud3;


                                           Dnum:=Bud4;

                                           
                                         end
                                         else
                                         Begin
                                           Dnum:=Value2;

                                           BudgetTot:=Value1;

                                           If (Dnum=0.0) then
                                             BudgetTot:=Value1;

                                         end;
                                       end
                                       else
                                       Begin

                                         If (Pr In [YTD,YTDNCF]) then
                                         Begin
                                           BudgetTot:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4);

                                           Dnum:=Bud2;
                                         end
                                         else
                                         Begin
                                           BudgetTot:=Budget;
                                           Dnum:=RevisedBudget1;
                                         end;
                                       end;

                                       If (Dnum<>0.0) then
                                         BudgetTot:=Dnum;

                                       FormatStr:=GenQtyMask;

                                       ShowAsQty:=BOn;
                                     end;

                           4      :  Begin
                                       Dnum:=(BudgetTot-Cleared);

                                       FormatStr:=GenQtyMask;

                                       ShowAsQty:=BOn;
                                     end;
                         end; {Case..}
                       end;

                19  :  Begin

                         Case Col  of

                           1   :  Begin

                                     Dnum:=Currency_Txlate(Purchases,NHCr,NHTxCr);

                                   end;


                           2   :  Begin
                                    If (PChkAllowed_In(143)) then
                                      Profit:=Purchases-Sales
                                    else
                                      Profit:=0.0;

                                    Dnum:=Currency_Txlate(Profit,NHCr,NHTxCr);

                                  end;


                           3   :  Begin
                                    If (PChkAllowed_In(143)) then
                                      Profit:=Calc_Pcnt(Purchases,(Purchases-Sales))
                                    else
                                      Profit:=0.0;

                                    Dnum:=Profit;

                                    FormatStr:=GenPcntMask;

                                  end;
                         end; {Case..}


                       end;

                {$IFDEF JC}
                  21,22,
                  25..27
                      :  Begin

                           Case Col  of

                             1   :  Begin
                                       Profit:=Purchases-Sales;

                                       Dnum:=Currency_Txlate(Profit,NHCr,NHTxCr);

                                     end;


                             2   :  Begin
                                      If (Pr In [YTD,YTDNCF]) then
                                      Begin
                                        Budget:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4);

                                        RevisedBudget1:=Bud2;
                                        BudgetTot:=Bud2;

                                        Value1:=Bud3;
                                        Value2:=Bud4;

                                      end;



                                      Dnum:=Currency_Txlate(Budget,NHCr,NHTxCr);

                                    end;


                             3   :  Begin
                                      If (Pr In [YTD,YTDNCF]) then
                                      Begin
                                        RevisedBudget1:=BudgetTot;
                                      end;

                                      Dnum:=Currency_Txlate(RevisedBudget1,NHCr,NHTxCr);

                                    end;
                           end; {Case..}
                         end;

                  31,32,
                  35..37
                      :  Begin

                           Case Col  of

                             1   :  Begin
                                       Dnum:=Cleared;
                                       FormatStr:=GenQtyMask;
                                       ShowAsQty:=BOn;
                                     end;


                             2   :  Begin
                                      If (Pr In [YTD,YTDNCF]) then
                                      Begin
                                        Budget:=Get_BudgetYTD(ExClass,YTD,Bud2,Bud3,Bud4);

                                        RevisedBudget1:=Bud2;

                                        Value1:=Bud3;
                                        Value2:=Bud4;

                                      end;


                                      FormatStr:=GenQtyMask;
                                      ShowAsQty:=BOn;
                                      Dnum:=Value1;

                                    end;


                             3   :  Begin
                                      FormatStr:=GenQtyMask;
                                      ShowAsQty:=BOn;

                                      Dnum:=Value2

                                    end;
                           end; {Case..}
                         end;

                {$ENDIF}
                else   Begin
                         Case Col of


                                1   :     Begin
                                            Dnum:=Currency_Txlate(Purchases,NHCr,NHTxCr);

                                          end;

                                2   :    Begin

                                            Dnum:=Currency_Txlate(Sales,NHCr,NHTxCr);

                                          end;

                                3   :     If (NHMode In [1,8,29,50]) then
                                          Begin
                                            Profit:=Purchases-Sales;

                                            Dnum:=Currency_Txlate(Profit,NHCr,NHTxCr);

                                          end
                                          else
                                            AutoBlank:=(NHMode=4);
                         end; {Case..}

                       end;

               end; {case..}

              TCr:=0;

               {$IFDEF MC_On}

                 If (NHTxCr<>0) then
                   TCr:=NHTxCr
                 else
                 Begin
                   If (NHMode=4) then
                     TCr:=Syss.VATCurr
                   else
                     TCr:=NHCr;

                 end;

               {$ENDIF}


               If (FormatStr=GenRealMask) and (Not ShowAsQty) then
                 OutLine:=FormatCurFloat(FormatStr,Dnum,AutoBlank,TCr)
               else
                 OutLine:=FormatFloat(FormatStr,Dnum);
          end;



       else
             OutLine:='';
     end; {Case..}


   end; {With..}
end;


{ ================ Procedure to input a seperate budget ===================== }

Procedure TNHMList.EditBudget(PColor  :  TColor;
                              PFont   :  TFont;
                              ORMode  :  Byte);
Const
  ORTit  :  Array[1..2] of Str10 = ('Original','Revised');

Var
  ISCtrl  :  TCLPal;
  ExLocal :  ^TdExLocal;
  KeyS    :  Str255;
  mrResult:  Word;

  FuncRes: LongInt;
  RecAddr: LongInt;

  //PR: 27/06/2012 ABSEXCH-12957 Variable to store existing revised budget
  PreviousRevisedVal : Double;
Begin
  ExLocal:=ListLocal;

  KeyS:='';

  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
  PreviousRevisedVal := 0;

  If (ValidLine) then
  With ExLocal^,LNHist do
  Begin
    GetSelRec(BOff);

    AssignFromGlobal(ScanFileNum);

    If (Not (Pr In [YTD,YTDNCF])) then
    Begin

// CJS: 18/04/2011 ABSEXCH-11249 - Modified to locate the non-cached record
// and edit that instead of editing the cached record, because unlocking a
// cached record appears not to work, leaving the record locked.
{$IFDEF EXSQL}
      If SQLUtils.UsingSQLAlternateFuncs Then
      begin
        UseCustomPrefillCache(SQLCacheID);
        FuncRes := GetPos(F[ScanFileNum], ScanFileNum, RecAddr);
        if (FuncRes <> 0) then
          MessageDlg('Failed to get record address, error #' + IntToStr(FuncRes),
                     mtError, [mbOk], 0)
        else
        begin
          Move(RecAddr, ExLocal.LRecPtr[ScanFileNum]^, SizeOf(RecAddr));
          FuncRes := GetDirect(F[ScanFileNum], ScanFileNum, ExLocal.LRecPtr[ScanFileNum]^, 0, 0);
          if (FuncRes <> 0) then
            MessageDlg('Failed to set record address, error #' + IntToStr(FuncRes),
                       mtError, [mbOk], 0)
        end;
      end;
{$ENDIF}
      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFileNum,BOff,GlobLocked);

      If (Ok) and (GlobLocked) then
      Begin
        LGetRecAddr(ScanFileNum);  {* Refresh record address *}

        ISCtrl:=TCLPAL.Create(Owner);

        try

          With ISCtrl do
          Begin
            BudgetMode:=BOn;

            Case ORMode of
              1  :  Case LNHCtrl.NHMode of
                      31,32,35..37,92
                          :  PAValue:=Value1;
                      else   PAValue:=Budget;
                    end;
              2  :  Case LNHCtrl.NHMode of
                      31,32,35..37,92
                          :  PAValue:=Value2;
                      11  :  begin
                               //PR: 27/06/2012 ABSEXCH-12957 Store existing revised budget
                               PAValue:=RevisedBudget1;

                               //If the existing revised value is zero then we should give the change between the
                               //new revised value and the original budget.
                               if PAValue <> 0.00 then
                                 PreviousRevisedVal := PAValue
                               else
                                 PreviousRevisedVal := Budget;
                             end;
                      else   PAValue:=RevisedBudget1;
                    end;
            end;

            Case LNHCtrl.NHMode of
              10  :  Begin
                       PALab.Caption:='Profile value';
                       Caption:='Set '+ORTit[ORMode]+' Budget Profile.';
                     end;
              else   Begin
                       PALab.Caption:=ORTit[ORMode]+' Budget';
                       Caption:='Set '+ORTit[ORMode]+' Budget.';
                     end;

            end; {Case..}

            mrResult:=InitIS(BOff,PColor,PFont);

            If (mrResult=mrOk) then
            Begin
              Case ORMode of
                1  :  Case LNHCtrl.NHMode of
                        31,32,35..37,92
                            :  Value1:=PAValue;
                        else   Budget:=PAValue;
                      end; {Case..}

                2  :  Case LNHCtrl.NHMode of
                        31,32,35..37,92
                            :  Value2:=PAValue;
                        else   RevisedBudget1:=PAValue;
                      end; {case..}
              end;

              Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPAth);

              Report_BError(ScanFileNum,Status);

              LGetRecAddr(ScanFileNum);  {* Refresh record address *}
              PageUpDn(0,BOn);

              //PR: 27/06/2012 ABSEXCH-12957 If we've changed the revised budget then add a record to the budget history file.
              if (ORMode = 2) and (LNHCtrl.NHMode = 11) then
              with TGLBudgetHistory.Create do
              begin
                bhGLCode      := LNHCtrl.NHNomCode;
                bhPeriod      := ExLocal.LNHist.Pr;
                bhYear        := ExLocal.LNHist.Yr;
                bhCurrency    := ExLocal.LNHist.Cr;
                bhValue       := RevisedBudget1;
                bhChange      := RevisedBudget1 - PreviousRevisedVal;

                Status_Means(Save);
              end;

            end;
          end;

        finally

          ISCtrl.Free;

          UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

        end; {Try..}
      end; {If locked ok..}

// CJS: 18/04/2011 ABSEXCH-11249
{$IFDEF EXSQL}
      if SQLUtils.UsingSQLAlternateFuncs then
        RefreshCache;
{$ENDIF}
      RefreshLine(MUListBoxes[0].Row,BOn);
    end; {If not ytd lines }
  end; {If valid line..}
end; {Proc..}


Function TNHMList.PartHistMKey(HType  :  Char;
                               NCode  :  LongInt)  :  Str10;

Begin

  PartHistMKey:=HType+FullNomKey(NCode);

end; {Func..}

{ ======== Proc to determine what type of YTD (if any) a heading type contains ===== }

Procedure TNHMList.Hed_YTDType(MoveCode  :  LongInt;
                               NTyp      :  Char;
                               Fnum,
                               Keypath   :  Integer;
                           Var YTDOk,
                               YTDNCFOk  :  Boolean);



Var
  FoundOk  :  Boolean;
  KeyS,
  KeyChk   :  Str255;



Begin

  YTDOk:=BOff;
  YTDNCFOk:=BOff;

  FoundOk:=BOff;

  KeyChk:=PartHistMKey(NTyp,MoveCode);

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
  With NHist do
  Begin

    FoundOk:=(Pr In [YTD,YTDNCF]);

    If (Not FoundOk) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  If (FoundOk) then
  With NHist do
  Begin

    YTDOk:=(Pr=YTD);
    YTDNCFOk:=(Pr=YTDNCF);

  end;

end; {Proc..}

{ ============ Procedure to Create any Blank history records ============ }

Procedure TNHMList.FillBudget(NKey  :  Str255);

Var
  n,
  NeedYTD  :  Byte;

  HedYTD,
  HedYTDNCF,
  LOk, Locked
           :  Boolean;

  TSales,
  TPurch,
  TCleared,
  Rnum,
  TmpBudget,
  TBudget2,

  BV1,BV2    :  Double; 

  Tries,TryMax,
  MoveCode,
  RecAddr
              :  LongInt;

  GStr        :  Str5;

  LocalNHist  :  HistoryRec;

Begin
  NeedYTD:=0;  HedYTD:=BOff; HedYTDNCF:=BOff;

  LOk:=BOff; Locked:=BOff;

  Tries:=0; TryMax:=1000;


  If (Displaymode<>2) then
  Begin

    ResetRec(ScanFileNum);

    Extract_NHistfromNKey(NKey,NHist);

    With NHist do
    For n:=1 to Syss.PrinYr do
      If (Not CheckExsists(FullNHistKey(ExClass,Code,Cr,GetLocalPr(0).CYr,n),ScanFileNum,KeyPath)) then
        Add_NHist(ExClass,Code,Cr,GetLocalPr(0).CYr,n,ScanFileNum,KeyPAth);

    With NHist do
    Begin
      If (ExClass=NomHedCode) then
      Begin
        MoveCode:=0;

        GStr:=Copy(Code,1,4);

        Move(GStr[1],MoveCode,4);

        LocalNHist:=NHist;

        Hed_YTDType(MoveCode,ExClass,ScanFilenum,Keypath,HedYTD,HedYTDNCF);

        NHist:=LocalNHist;

      end;

      If ((ExClass In YTDSet+[CustHistCde]) and (Not LNHCtrl.NHForceYTDNCF)) or (HedYTD) then
        NeedYTD:=YTD
      else
        If (ExClass In YTDNCFSet) or (HedYTDNCF) then
          NeedYTD:=YTDNCF;
    end;

    If (NeedYTD>0) then {Set YTD if Necessary}
    With NHist do
    Begin
      If (Not CheckExsists(FullNHistKey(ExClass,Code,Cr,GetLocalPr(0).CYr,NeedYTD),ScanFileNum,KeyPath)) then
      Begin
        LocalNHist:=NHist;

        Set_ACHistYTDBudget(BOn); {Force Total_Profit_to_Date to return Purch & Sales Balances}

        Rnum:=Total_Profit_to_Date(ExClass,Code,Cr,GetLocalPr(0).CYr,Pr,TPurch,TSales,TCleared,TmpBudget,TBudget2,BV1,BV2,BOn);

        Set_ACHistYTDBudget(BOff);

        NHist:=LocalNHist;

        Add_NHist(ExClass,Code,Cr,GetLocalPr(0).CYr,NeedYTD,ScanFileNum,KeyPAth);

        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,NKey,KeyPath,ScanFilenum,BOn,Locked,RecAddr);

        If (LOk) and (Locked) then
        Begin
          Sales:=TSales; Purchases:=TPurch; Cleared:=TCleared;

          Repeat

            Status:=Put_Rec(F[ScanFilenum],ScanFilenum,RecPtr[ScanFilenum]^,Keypath);

            Inc(Tries);

          Until (Not (Status In [84,85])) or (Tries>TryMax);

          Report_Berror(ScanFileNum,Status);

          Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,RecAddr);

        end;

      end;

    end;


{$IFDEF EXSQL}
    if SQLUtils.UsingSQLAlternateFuncs then
      RefreshCache;
{$ENDIF}

    If (PageKeys^[1]<>0) then
      PageUpDn(0,BOn)
    else
      InitPage;
  end;

end; {Proc..}



{$IFDEF PF_On}


  { ======= Return appropriate Type Code ======= }

  {Function TNHMList.HeadCode(NRec  :  NominalRec;
                             SRec  :  StockRec;
                             Mode  :  Boolean)  :  Char;

  Moved to a global routine inside PayF2U...

  Begin

    Case Mode of

      BOff  :  HeadCode:=SRec.StockType;
      BOn   :  HeadCode:=NRec.NomType;

    end; {Case..

  end; {Func.. }


  { =============== Procedure to Input Search Value ============ }

Function TNHMList.Input_ABValue(Mode    :    Byte;
                            Var Value   :    Real)  :  Boolean;


Const

  Search4Tit  :  Array[1..2] of Str30  = (('the Yearly Total'),
                                          ('any % increase/decrease'));


Var
  ISCtrl  :  TCLPal;
  ExLocal :  ^TdExLocal;
  KeyS    :  Str255;
  mrResult:  Word;

Begin


  ISCtrl:=TCLPAL.Create(Owner);

  try

    With ISCtrl do
    Begin
      PAValue:=Value;

      BudgetMode:=BOn;

      PALab.Caption:='Enter '+Search4Tit[Mode]+'.';

      Caption:='Set Budget.';

      With VisiList do
        mrResult:=InitIS(BOff,IdPanel(0,BOff).Color,IdPanel(0,BOff).Font);

      If (mrResult=mrOk) then
      Begin
        Value:=PAValue;
        Result:=BOn;
      end
      else
        Result:=BOff;
    end; {With..}

    finally

      ISCtrl.Free;

    end; {Try..}

end;

  { === Function to Return equivalent profile if present === }


  Function TNHMList.Get_Profile(NKey  :  Str255)  :  Real;

  Const
    Fnum1    =  NomF;
    Keypath1 =  NomCodeK;

    Fnum2    =  StockF;
    Keypath2 =  StkCodeK;


  Var
    KeyS,
    KeyChk   :  Str255;

    TmpHist,
    CtrlHist :  HistoryRec;

    ProMode,
    DefaultOn
             :  Boolean;

    Rnum     :  Real;

    Bud2,
    Bud3,
    Bud4     :  Double;

    ProCode  :  Char;

    Fnum,
    Keypath,
    TmpKPath,
    TmpKPath2,
    TmpStat
             :  Integer;

    TmpRecAddr,
    TmpRecAddr2
             :  LongInt;

    ExLocal  :  ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    TmpHist:=NHist;

    Extract_NHistfromNKey(NKey,CtrlHist);

    //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
    FNum := FNum1;
    KeyPath := NomCodeK;
    RNum := 0;

    DefaultOn:=BOff;

    ProCode:=ResetKey;

    With ExLocal^ do
    Begin
      If (CtrlHist.ExClass In AdvBudgetSet) then
      Begin

        ProMode:=(CtrlHist.ExClass In AdvBudgetNSet);

        Case ProMode of

          BOff  :  Begin

                    Fnum:=Fnum2;

                    Keypath:=Keypath2;

                    {$IFDEF STK}

                      KeyS:=FullStockCode(LStock.StockCat);

                    {$ENDIF}

                  end;

          BOn   :  Begin

                    Fnum:=Fnum1;

                    Keypath:=Keypath1;

                    KeyS:=FullNomKey(LNom.CAT);

                  end;

        end; {Case..}

        TmpKPath:=GetPosKey;

        TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

        TmpKPath2:=GetPosKey;

        TmpStat:=Presrv_BTPos(Fnum,TmpKPath2,F[Fnum],TmpRecAddr2,BOff,BOff);

        Rnum:=0;

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

        If (StatusOk) then
        Begin

          Case ProMode of
            BOff  :  KeyChk:=FullNomKey(Stock.StockFolio);
            BOn   :  KeyChk:=FullNomKey(Nom.Nomcode);
          end;

          ProCode:=Calc_AltStkHCode(HeadCode(Nom,LStock,ProMode));

          With CtrlHist do
            KeyS:=FullNHistKey(ProCode,KeyChk,Cr,Yr,Pr);


          Status:=Find_Rec(B_GetEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Self.keypath,KeyS);

          If (StatusOk) then
            Rnum:=DivWChk(NHist.Budget,Get_BudgetYTD(ProCode,YTD,Bud2,Bud3,Bud4))
          else
            DefaultOn:=BOn;


        end {If Profile found..}
        else
          DefaultOn:=BOn;

        TmpStat:=Presrv_BTPos(Fnum,TmpKPath2,F[Fnum],TmpRecAddr2,BOn,BOff);

        TmpStat:=Presrv_BTPos(ScanFileNum,TmpKPath,F[ScanFileNum],TmpRecAddr,BOn,BOff);

      end
      else
        DefaultOn:=BOn;

      NHist:=TmpHist;

      If (DefaultOn) then
        Rnum:=DivWChk(1,Syss.PrinYr);  {* Default to an equal part of the period *}

      Get_Profile:=Rnum;
    end; {with..}

  end;


  { ============ Procedure to Split a total across all history records ============ }

  Procedure TNHMList.YTD_SplitBudget(AutoValue  :  Real;
                                     AutoOn     :  Boolean;
                                     NKey       :  Str255);

  Var
    n      :  Byte;

    PerPr  :  Real;
    PrBudget
           :  Double;

    KeyChk,
    KeyS   :  Str255;

    GotValue,
    Locked :  Boolean;

    LastStatus
           :  Integer;

    LAddr  :  LongInt;

    RunTot :  Double;


  Begin

    LastStatus:=0;

    RunTot:=0;

    Locked:=BOff;

    GotValue:=BOn;

    If (Not AutoOn) then
      GotValue:=Input_ABValue(1,AutoValue);


    If (GotValue) then
    Begin

      FillBudget(NKey);

      PerPr:=AutoValue;
      PrBudget:=0.0;

      Extract_NHistfromNKey(Nkey,NHist);

      With NHist do
      For n:=1 to Syss.PrinYr do
      Begin

        KeyS:=FullNHistKey(ExClass,Code,Cr,GetLocalPr(0).CYr,n);

        Ok:=GetMultiRecAddr(B_GetEQ,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          With NHist do
            KeyS:=FullNHistKey(ExClass,Code,Cr,Yr,Pr);

          If (n=Syss.PrInYr) then
            PrBudget:=Round_Up(AutoValue-RunTot,2)
          else
            PrBudget:=Round_Up(PerPr*(Get_Profile(KeyS)),2);

          RunTot:=RunTot+PrBudget;

          If (LNHCtrl.NHMode In [92]) then {* We are dealing with JC Qty *}
          Begin
            Value1:=PrBudget;
            Value2:=PrBudget;
          end
          else
            Begin
              Budget:=PrBudget;
              RevisedBudget1:=PrBudget;

              //PR: 09/05/2016 ABSEXCH-17353 Fill Revised Budgets 2-5 with value.
              RevisedBudget2:=PrBudget;
              RevisedBudget3:=PrBudget;
              RevisedBudget4:=PrBudget;
              RevisedBudget5:=PrBudget;
            end;

          Status:=Put_Rec(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath);

          If (LastStatus=0) then
            LastStatus:=Status;

          Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);

        end; {If Ok..}
      end; {Loop..}

      Report_BError(ScanFileNum,LastStatus);

{$IFDEF EXSQL}
      if SQLUtils.UsingSQLAlternateFuncs then
        RefreshCache;
{$ENDIF}
      PageUpDn(0,BOn);

    end; {If Not Abort..}
  end; {Proc..}




  { ============ Procedure to Copy total across all history records  ============ }

  Procedure TNHMList.Copy_Budget(NKey       :  Str255;
                                 Actuals    :  Boolean);

  Var
    n      :  Byte;

    Tc     :  Char;

    //PR: 10/05/2016 ABSEXCH-17353 Variable for extra revised budgets
    Revised  :  Array[2..5] of Real;

    PerPr,
    NewPr,
    AutoValue
           :  Real;

    KeyS   :  Str255;

    Locked :  Boolean;

    LastStatus
           :  Integer;

    LAddr  :  LongInt;


  Begin

    LastStatus:=0;


    Tc:=ResetKey;

    Locked:=BOff;

    AutoValue:=0;



    If Input_ABValue(2,AutoValue) then
    Begin

      FillBudget(NKey);

      Extract_NHistfromNKey(Nkey,NHist);

      With NHist do
      For n:=1 to Syss.PrinYr do
      Begin

        KeyS:=FullNHistKey(ExClass,Code,Cr,AdjYr(GetLocalPr(0).CYr,BOff),n);

        Status:=Find_Rec(B_GetEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,keypath,KeyS);

        If (StatusOk) then
        Begin
          If (Not Actuals) then
          Begin
            If (LNHCtrl.NHMode In [92]) then
            Begin
              PerPr:=Value1;
              NewPr:=Value2;


            end
            else
            Begin
              PerPr:=Budget;
              NewPr:=RevisedBudget1;

              //PR: 10/05/2016 ABSEXCH-17353 Include extra revised budgets
              Revised[2] := RevisedBudget2;
              Revised[3] := RevisedBudget3;
              Revised[4] := RevisedBudget4;
              Revised[5] := RevisedBudget5;
            end;

          end
          else
          Begin
            If (ExClass In AdvBudgetNSet) then {* Set to Balance *}
              PerPr:=(Purchases-Sales)
            else                             {* Set To Qty Sold *}
              PerPr:=Cleared;

            NewPr:=PerPr;

            //PR: 10/05/2016 ABSEXCH-17353 Include extra revised budgets
            Revised[2] := PerPr;
            Revised[3] := PerPr;
            Revised[4] := PerPr;
            Revised[5] := PerPr;
          end;
        end
        else
        Begin
          PerPr:=0;
          NewPr:=0.0;
          FillChar(Revised, SizeOf(Revised), 0);
        end;

        KeyS:=FullNHistKey(ExClass,Code,Cr,GetLocalPr(0).CYr,n);

        Ok:=GetMultiRecAddr(B_GetEQ,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          If (LNHCtrl.NHMode In [92]) then
          Begin
            Value1:=Round_Up(PerPr*(1+Pcnt(AutoValue)),2);
            Value2:=Round_Up(NewPr*(1+Pcnt(AutoValue)),2);
          end
          else
            Begin
              Budget:=Round_Up(PerPr*(1+Pcnt(AutoValue)),2);
              RevisedBudget1:=Round_Up(NewPr*(1+Pcnt(AutoValue)),2);

              //PR: 10/05/2016 ABSEXCH-17353 Include extra revised budgets
              RevisedBudget2 := Round_Up(Revised[2] * (1+Pcnt(AutoValue)), 2);
              RevisedBudget3 := Round_Up(Revised[3] * (1+Pcnt(AutoValue)), 2);
              RevisedBudget4 := Round_Up(Revised[4] * (1+Pcnt(AutoValue)), 2);
              RevisedBudget5 := Round_Up(Revised[5] * (1+Pcnt(AutoValue)), 2);
            end;

          Status:=Put_Rec(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath);

          If (LastStatus=0) then
            LastStatus:=Status;

          Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);

        end; {If Ok..}
      end; {Loop..}

      Report_BError(ScanFileNum,LastStatus);

{$IFDEF EXSQL}
      if SQLUtils.UsingSQLAlternateFuncs then
        RefreshCache;
{$ENDIF}
      PageUpDn(0,BOn);

    end; {If Not Abort..}
  end; {Proc..}





{$ENDIF}
{ =================================================================================== }


{ =================================================================================== }

