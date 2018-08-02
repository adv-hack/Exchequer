unit RepJCA2U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU;


type



  TJCApps1Report  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       UseFloatFmt  :  Str255;

                       LastJobCode,
                       LastEmpCode,
                       LastORefCode,
                       LastJCTCode,
                       LastAccCode  :  Str10;

                       DocHed       :  DocTypes;

                       TotBreak     :  Boolean;

                       Function AppsStatus(ORef  :  Str10; FullText  :  Boolean)  :  Str20;

                       Function GetJCTDetails(JCTCode  :  Str10)  :  Str255;

                       Function GetJCTRetDetails(JCTCode  :  Str10)  :  InvRec;

                       Procedure PrintEmplAccount(ECCode  :  Str10;
                                                  ContOn  :  Boolean);

                       Procedure PrintSubHed(SubText  :  Str255;
                                             TabOfSet :  Byte;
                                             ContOn   :  Boolean);

                     protected

                       Procedure Get_JDPos(Var   LineTot    : JCAppsTotals);

                       Procedure PrintDueTot(Gtot      :  Byte); Virtual;

                       Procedure CalcDueTotals(LTot      :  JCAppsTotals);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;


                     public
                       SCrtMode   :  Byte;

                       CRepParam  :  JobCRep4Ptr;

                       ThisScrt   :  Scratch2Ptr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Build_AppsDetail(Mode     :  Byte;
                                              Var AbortPrint
                                                           :  Boolean);

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddJCAppsRep2Thread(LMode    :  Byte;
                              IRepParam:  JobCRep4Ptr;
                              AOwner   :  TObject);

Procedure TESTAppsRep(LMode    :  Byte;
                      AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  VarJCstU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  InvListU,
  RpDefine,
  JobSup1U,
  JobSup2U,
  SalTxl1U,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U;


{ ========== TJHistReport methods =========== }

Constructor TJCApps1Report.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  LastJobCode:='';
  LastAccCode:='';
  LastEmpCode:='';
  LastORefCode:='';
  LastJCTCode:='';

  ScrtMode:=24;

  TotBreak     :=BOff;
end;


Destructor TJCApps1Report.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;







Procedure TJCApps1Report.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        3,4
         :  Begin
              SetTab (MarginLeft, pjLeft, 22, 4, 0, 0);
              SetTab (NA, pjLeft, 10, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjRight, 21, 4, 0, 0);
              SetTab (NA, pjRight, 21, 4, 0, 0);
              SetTab (NA, pjRight, 21, 4, 0, 0);
              SetTab (NA, pjRight, 21, 4, 0, 0);
              SetTab (NA, pjRight, 21, 4, 0, 0);
              SetTab (NA, pjRight, 25, 4, 0, 0);
            end;

        20,21
         :  Begin
              SetTab (MarginLeft, pjLeft, 22, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjRight, 24, 4, 0, 0);
              SetTab (NA, pjLeft, 24, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;





Procedure TJCApps1Report.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of


      3..4
          :  Begin
               SendLine(Concat(ConstStr(#9,3),'Applied',#9,'Certified',#9,'Applied',#9,'Certified'));

               SendLine(ConCat(#9,'Our Ref',#9,'Stat',#9,'Labour',#9,'Labour',#9,'Materials',#9,'Materials',
                               #9,'Deductions',#9,'Retentions',#9,'Comp Ded.',#9,'Contras',#9,CCCISName^,
                               #9,CCVATName^,#9,'Due'));

             end;

      20,21
          :  Begin
               SendLine(Concat(ConstStr(#9,4),'Application',#9,'Certified',#9,'Uncertified',#9,'NETT',#9,'Payment',#9,'Final'));

               SendLine(ConCat(#9,'Our Ref'#9,'Type',#9,'Status',#9,'Date',#9,'NETT',#9,'NETT',#9,'Applied',
                               #9,'Due Date',#9,'Retention',#9,'CC/Dep'));

             end;


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}



Procedure TJCApps1Report.PrintEmplAccount(ECCode  :  Str10;
                                          ContOn  :  Boolean);

Begin
  Case ReportMode of
    3,20  :  PrintEmplLine(ECCode,ContOn);
    4,21  :  PrintCustLine(ECCode,ContOn);
  end; {Case..}

end;


Procedure TJCApps1Report.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1,CRepParam^ do
  Begin

    Case ReportMode of
        3..4,
        20,21
            :  If (CurrentPage>1)  then
               Begin
                 Case SortOrd of
                   0  :  Begin
                           PrintJobLine(LastJob,BOn);

                           PrintEmplAccount(LastCust,BOn);
                         end;
                   1  :  Begin
                           PrintEmplAccount(LastCust,BOn);
                           PrintJobLine(LastJob,BOn);
                         end;
                  end; {Case..}

                 If (ReportMode In [3,4]) and (Not TotBreak) then
                 Begin
                   PrintSubHed(LastJCTCode,2,BOn);

                   If (Not Summary) then
                     PrintSubHed(LastORefCode,3,BOn);
                 end;

               end;

    end; {Case..}
  end; {With..}
end;



{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TJCApps1Report.Build_AppsDetail(Mode     :  Byte;
                                      Var AbortPrint
                                                   :  Boolean);


Const
  Fnum      =  InvF;

  Fnum2     =  IDetailF;
  Keypath2  =  IdFolioK;


Var
  KeyS2,
  KeyChk,
  KeyIChk,
  KeyIS,
  MatchStr :  Str255;

  RecAddr  :  LongInt;

  Keypath,
  B_Func   :  Integer;

  Dnum,
  Dnum2    :  Double;

  InGroup,
  TmpInclude,
  TmpBo,
  DayRepInc,
  ChrgeOn
           :  Boolean;



Begin

  AbortPrint:=BOn;

  If (CRepParam^.ShowOCBal) then
  Begin
    Keypath:=InvRNoK;
    KeyChk:=FullNomKey(Set_JAPRunNo(DocHed,BOff,BOff));
    KeyS2:=KeyChk;

  end
  else
  Begin
    Keypath:=InvDateK;
    Keychk:='';
    KeyS2:=CRepParam^.Sdate;
  end;


  InGroup:=BOn;


  MatchStr:='';

  RecAddr:=0;

  ChrgeOn:=BOff;

  Dnum:=0.0; Dnum2:=0.0;

  TmpInclude:=BOff;
  TmpBo:=BOff;

  B_Func:=B_GetNext;

  With MTExLocal^, CRepParam^ do
  Begin

    ShowStatus(2,'Calculating Totals.');

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and  ((ShowOCBal) or ((KeyS2>=SDate) and (KeyS2<=EDate))) and (ChkRepAbort) do
    With LInv do
    Begin
      {$IFDEF DBD}
        If (Debug) then
        Begin
          If (OurRef='JSA000066') then
            MessageBeep(0);

        end;

      {$ENDIF}

      Case Mode of


        3..4,
        20,21
             :  Begin
                  TmpInclude:=(((CustCode=CustFilt) or (CustFilt=''))
                               and ((CISEmpl=EmpFilt) or (EmpFilt=''))
                               and ((DeliverRef=JCTFilt) or (JCTFilt=''))
                               and ((RCr=Currency) or (RCr=0))
                               and (((PDiscTaken) and (CertMode In [0,2])) or ((Not PDiscTaken) and (CertMode In [1,2])))
                               and (InvDocHed=DocHed));






                end;

      end; {Case..}


      Case Mode of

        3,4  :  Begin
                  If (TmpInclude) then
                  Begin
                    KeyIChk:=FullNomKey(FolioNum);
                    KeyIS:=FullIdKey(FolioNum,JALRetLineNo);

                    LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyIS);

                    While (LStatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (ChkRepAbort) do
                    With LId do
                    Begin
                      If (LJobRec^.JobCode<>JobCode) then
                        LGetMainRec(JobF,JobCode);

                      If (Not SingProd) then
                        InGroup:=LJob_InGroup(JobFilt,LJobRec^)
                      else
                        InGroup:=CheckKey(JobFilt,JobCode,Length(JobFilt),BOff);;

                      TmpInclude:=InGroup and (Not (AutoLineType In [2,3]))
                                  and ((LJobRec^.JobAnal=JobTFilt) or (EmptyKey(JobTFilt,3)))
                                  and ((LJobRec^.JQSCode=QSFilt) or (QSFilt=''));

                      If (TmpInclude) then
                      Begin
                        For DayRepInc:=BOff to BOn do
                                  TmpInclude:=(TmpInclude
                                               and (CheckKey(RCCDep[DayRepInc],CCDep[DayRepInc],Length(RCCDep[DayRepInc]),BOff)));


                      end;


                      If (TmpInclude) then
                      Begin
                        LStatus:=LGetPos(Fnum2,RecAddr);  {* Get Preserve IdPosn *}

                        If EmptyKey(CustCode,CustKeyLen) then
                          CustCode:=LInv.CustCode;

                        Case Mode of

                          3    :  Case SortOrd of
                                    0  :  MatchStr:=FullJobCode(JobCode)+FullEmpCode(CISEmpl)+LJVar(DeliverRef,10)+OurRef;
                                    1  :  MatchStr:=FullEmpCode(CISEmpl)+FullJobCode(JobCode)+LJVar(DeliverRef,10)+OurRef;
                                  end; {Case..}
                          4    :  Case SortOrd of
                                    0  :  MatchStr:=FullJobCode(JobCode)+FullCustCode(CustCode)+LJVar(DeliverRef,10)+OurRef;
                                    1  :  MatchStr:=FullCustCode(CustCode)+FullJobCode(JobCode)+LJVar(DeliverRef,10)+OurRef;
                                  end; {Case..}


                        end; {Case..}

                        ThisScrt^.Add_Scratch(Fnum2,IdFolioK,RecAddr,MatchStr,'');

                        If (AbortPrint) then
                          AbortPrint:=BOff;

                      end;

                      LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyIS);


                    end; {While..}
                  end;
                end; {Mode3,4}

        20,21
             :  Begin
                  If (LJobRec^.JobCode<>DJobCode) then
                    LGetMainRec(JobF,DJobCode);

                  If (Not SingProd) then
                    InGroup:=LJob_InGroup(JobFilt,LJobRec^)
                  else
                    InGroup:=CheckKey(JobFilt,DJobCode,Length(JobFilt),BOff);

                  TmpInclude:=InGroup and ((LJobRec^.JobAnal=JobTFilt) or (EmptyKey(JobTFilt,3))) and ((LJobRec^.JQSCode=QSFilt) or (QSFilt=''));

                  If (TmpInclude) then
                  Begin
                    If (LCust.CustCode<>CustCode) then
                      TmpInclude:=LGetMainRecPos(CustF,CustCode);


                    If (TmpInclude) then
                    With LCust do
                      TmpInclude:=(CheckKey(RCCDep[BOff],CustDep,Length(RCCDep[BOff]),BOff) and
                                   CheckKey(RCCDep[BOn],CustCC,Length(RCCDep[BOn]),BOff));

                  end;


                  If (TmpInclude) then
                  Begin
                    LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

                    Case Mode of

                      20    :  Case SortOrd of
                                0  :  MatchStr:=FullJobCode(DJobCode)+FullEmpCode(CISEmpl)+LJVar(DeliverRef,10)+OurRef;
                                1  :  MatchStr:=FullEmpCode(CISEmpl)+FullJobCode(DJobCode)+LJVar(DeliverRef,10)+OurRef;
                              end; {Case..}
                      21   :  Case SortOrd of
                                0  :  MatchStr:=FullJobCode(DJobCode)+FullCustCode(CustCode)+LJVar(DeliverRef,10)+OurRef;
                                1  :  MatchStr:=FullCustCode(CustCode)+FullJobCode(DJobCode)+LJVar(DeliverRef,10)+OurRef;
                              end; {Case..}


                    end; {Case..}

                    ThisScrt^.Add_Scratch(Fnum,InvOurRefK,RecAddr,MatchStr,'');

                    If (AbortPrint) then
                      AbortPrint:=BOff;

                  end;

                end;

      end; {Case..}
      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

    end; {While..}
  end;

end; {Proc..}






Procedure TJCApps1Report.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      3..4,
      20,21 :  Begin
                 Case DDMode of
                    0  :  SendRepDrillDown(1,TotTabs,1,FullJobCode(LJobRec^.JobCode),JobF,JobCodeK,0);

                    1  :  With LJobMisc^.EmplRec do
                            SendRepDrillDown(1,TotTabs,1,PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmpCode),JMiscF,JMK,0);

                    2  :  SendRepDrillDown(1,TotTabs,1,CRepParam^.LastCust,CustF,CustCodeK,0);
                   10  :  SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);
                   11  :  SendRepDrillDown(1,TotTabs,1,LastJCTCode,InvF,InvOurRefK,0);
                   12  :  SendRepDrillDown(1,TotTabs,1,LastORefCode,InvF,InvOurRefK,0);
                   13  :  SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
                 end; {Case..}
               end;
    end; {Case..}
  end; {With..}
end;


{ ======================= Print App status  ================ }

Function TJCApps1Report.AppsStatus(ORef  :  Str10; FullText  :  Boolean)  :  Str20;

Const
  StatStr  :  Array[1..3,BOff..BOn] of Str80 = (('C','Certified'),('P','Practical'),('F','Final'));

Var
  TmpInv  :  InvRec;
  KeyI    :  Str255;

Begin
  With MTExLocal^, LInv do
  Begin
    TmpInv:=LInv;

    If (ORef<>'') and (ORef<>OurRef) then
    Begin
      KeyI:=ORef;

      LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyI);
    end;


    If (PDiscTaken) then
      Result:=StatStr[1,FullText]
    else
      Result:=' ';

    If (InvDocHed In JAPJAPSplit) then
    Begin
      If (Trim(Result)<>'') and (FullText) then
        Result:=Result+', ';

      Case TransMode of
        2  :  Result:=Result+StatStr[2,FullText];
        3  :  Result:=Result+StatStr[3,FullText];
      end; {Case..}
    end;

    LInv:=TmpInv;
  end;
end;

Function TJCApps1Report.GetJCTDetails(JCTCode  :  Str10)  :  Str255;

Var
  TmpInv  :  InvRec;
  KeyI    :  Str255;

Begin
  Result:=JCTCode;

  With MTExLocal^, LInv do
  Begin
    TmpInv:=LInv;

    KeyI:=JCTCode;

    LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyI);

    If (LStatusOk) then
    Begin
      Result:=Result+'. '+JAGiStatus(LInv);
    end;

    LInv:=TmpInv;
  end;{With..}
end;

Function TJCApps1Report.GetJCTRetDetails(JCTCode  :  Str10)  :  InvRec;

Var
  TmpInv  :  InvRec;
  KeyI    :  Str255;

Begin
  Blank(Result,Sizeof(Result));

  With MTExLocal^, LInv do
  Begin
    TmpInv:=LInv;

    KeyI:=JCTCode;

    LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyI);

    If (LStatusOk) then
    Begin
      Result:=LInv;
    end;

    LInv:=TmpInv;
  end;{With..}
end;


{ ======================= Due Sub / Grand Total ================ }

Procedure TJCApps1Report.PrintDueTot(Gtot      :  Byte);

Var
  n,m        :  Byte;
  Rnum       :  Real;
  PostTotMsg :  Str80;
  KeyI       :  Str255;
  LineTot    :  JCAppsTotals;
  TmpInv     :  InvRec;

  CalcOnly   :  Boolean;


Begin

  PostTotMsg:=''; Blank(LineTot,Sizeof(LineTot));  CalcOnly:=BOff;

  With MTExLocal^, RepFiler1, CRepParam^ do
  Case ReportMode of

   3..4,
   20,21
       :  Begin
            DefFont(0,[fsBold]);

            Case Gtot of
              0  :  Begin

                      SendText(ConCat(#9,'Report Total'));

                    end;

              1  :  Begin
                      DefLine(-1,TabStart(2),TabEnd(TotTabs),0);

                      Case SortOrd of
                        0  :  Begin
                                LGetMainRec(JobF,LastJob);

                                SetReportDrillDown(0);

                                SendText(ConCat(#9,LJobRec^.JobCode));
                              end;

                        1  :  Begin
                                LRepGetJobMisc(FullEmpCode(LastCust),3);

                                SetReportDrillDown(1+Ord(ReportMode=4));

                                SendText(ConCat(#9,LastCust));
                              end;

                      end; {Case..}


                    end;
              2  :  Begin
                      DefLine(-1,TabStart(2),TabEnd(TotTabs),0);


                      Case SortOrd of
                        0  :  Begin
                                LRepGetJobMisc(FullEmpCode(LastCust),3);

                                SetReportDrillDown(1+Ord(ReportMode=4));

                                SendText(ConCat(#9,LastCust));
                              end;

                        1  :  Begin
                                LGetMainRec(JobF,LastJob);

                                SetReportDrillDown(0);

                                SendText(ConCat(#9,LJobRec^.JobCode));
                              end;

                      end; {Case..}


                    end;

              3  :  Begin
                      IF (ReportMode In [3,4]) then
                      Begin
                        DefLine(-1,TabStart(2),TabEnd(TotTabs),0);

                        SetReportDrillDown(11);

                        SendText(ConCat(#9,LastJCTCode));
                      end
                      else
                      Begin
                        LineTot[4]:=GetJCTRetDetails(LastJCTCode).TotOrdOS;
                        CalcDueTotals(LineTot);
                        CalcOnly:=BOn;
                      end;
                    end;

              4  :  Begin
                      TmpInv:=LInv;

                      KeyI:=LastORefCode;

                      LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyI);

                      If (LStatusOk) then
                      With LInv, JARepTotal[4] do
                      Begin

                        If (PDiscTaken) then
                           LineTot[11]:=RepTotal[2]+RepTotal[4]
                         else
                           LineTot[11]:=RepTotal[1]+RepTotal[3];

                         LineTot[9]:=CISTax;
                         LineTot[10]:=InvVAT;

                         LineTot[11]:=LineTot[11]-(RepTotal[5]+RepTotal[6]+RepTotal[7]+RepTotal[8]+LineTot[9])+LineTot[10];


                         CalcDueTotals(LineTot);
                      end;

                      LInv:=TmpInv;

                      If (Not Summary) then
                        DefLine(-1,TabStart(2),TabEnd(TotTabs),0)
                      else
                        DefFont(0,[]);


                      SetReportDrillDown(12);

                      SendText(ConCat(#9,LastORefCode,#9,AppsStatus(LastORefCode,BOff)));

                    end;
             end; {Case..}


            Case ReportMode of
              3,4  :  Begin

                        For n:=1 to 11 do
                          SendText(ConCat(ConstStr(#9,2+n),FormatBFloat(GenRealMask,JARepTotal[Gtot].RepTotal[n],BOff)));

                        SendLine('');
                      end;
              20,21: If (Not CalcOnly) then
                     Begin

                        SendText(ConCat(ConstStr(#9,5),FormatBFloat(GenRealMask,JARepTotal[Gtot].RepTotal[1],BOff),
                                 #9,FormatBFloat(GenRealMask,JARepTotal[Gtot].RepTotal[2],BOff),
                                 #9,FormatBFloat(GenRealMask,JARepTotal[Gtot].RepTotal[3],BOff),
                                 #9,#9,FormatBFloat(GenRealMask,JARepTotal[Gtot].RepTotal[4],BOff)));

                        SendLine('');
                      end;
            end; {Case.}

            If (Gtot<>0) then
            Begin
              Blank(JARepTotal[Gtot].RepTotal,Sizeof(JARepTotal[Gtot].RepTotal));

              If (Gtot<>4) or (Not Summary) then
                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;
            end;

            DefFont(0,[]);


            If (LinesLeft<5) then
            Begin
              TotBreak:=BOn;

              ThrowNewPage(5);

              TotBreak:=BOff;
            end;

          end; {Case..}



  end; {Case..With..}

end;


{ ======================= Calculate Due Totals ==================== }

Procedure TJCApps1Report.CalcDueTotals(LTot      :  JCAppsTotals);

Var
  NBo        :  Boolean;
  n,m          :  Byte;

Begin

  With CRepParam^ do
  Case ReportMode of
    3..4,
    20,21 :  Begin
                

                For m:=Low(JARepTotal) to High(JARepTotal) do
                  For n:=Low(JCAppsTotals) to High(JCAppsTotals) do
                    JARepTotal[m].RepTotal[n]:=JARepTotal[m].RepTotal[n]+LTot[n];

              end;

      end; {Case..With..}
end;





{ ======= Calculate & Return Value of Col ======== }

Procedure TJCApps1Report.Get_JDPos(Var   LineTot    : JCAppsTotals);


Var
  n,
  UOR   :  Byte;

  Dnum2,

  Dnum  :  Double;



Begin

  With MTExLocal^, LId, LInv, CRepParam^ do
  Begin
    Case Reconcile of
      0  :  Begin
              If (LJobMisc^.JobAnalRec.JAnalCode<>AnalCode) then
                LRepGetJobMisc(AnalCode,2);

              If (LJobMisc^.JobAnalRec.JAType=JobXLab) then
              Begin
                LineTot[1]:=CostPrice;
                LineTot[2]:=NetValue;
              end
              else
              Begin
                LineTot[3]:=CostPrice;
                LineTot[4]:=NetValue;
              end;

              
            end;

      1  :  Begin
              Case JAPDedType of
                0  :  LineTot[5]:=NetValue;
                1  :  LineTot[7]:=NetValue;
                2  :  LineTot[8]:=NetValue;
              end; {Case..}
            end;

      2  :  Begin
              LineTot[6]:=NetValue;
            end;
    end; {Case..}

    {$IFDEF MC_On}
      For n:=Low(LineTot) to High(LineTot) do
      Begin
        Dnum:=LineTot[n];

        If (RCr=0) then
        Begin

          UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

          Dnum:=Round_Up(Conv_TCurr(Dnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);
        end;

        Dnum:=Currency_Txlate(Dnum,RCr,RTXCr);

      end; {Loop..}
    {$ENDIF}

  end; {With..}

end; {Proc..}


Procedure TJCApps1Report.PrintSubHed(SubText  :  Str255;
                                     TabOfSet :  Byte;
                                     ContOn   :  Boolean);

Var
  ContText  :  Str255;

Begin
  With RepFiler1 do
  Begin
    DefFont(0,[fsBold,fsUnderline]);

    If (ContOn) then
      ContText:='(continued)'
    else
      ContText:='';

    SetReportDrillDown(9+TabOfSet);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft(ConCat(ConstStr(#9,1),Spc(TabOfset*2),SubText,#9,ContText),MarginLeft);
    Self.CRLF;

    DefFont(0,[]);

  end; {With..}
end;


{ ======================= Customer Line ======================= }


Procedure TJCApps1Report.PrintReportLine;

Var
  n,UOR
             :  Byte;
  LineTot    :  JCAppsTotals;

  Dnum       :  Double;
  Rnum       :  Real;

  EmpAcc,
  GenStr     :  Str255;

  TBo        :  Boolean;
  Level      :  Array[1..4] of Boolean;

Begin

  Blank(LineTot,Sizeof(LineTot));
  Blank(Level,Sizeof(Level));

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    With LInv do
    Case ReportMode of
      3,20  :  EmpAcc:=CISEmpl;
      4,21  :  EmpAcc:=CustCode
    end; {Case..}

    Case ReportMode of
      20,21  :  LId.JobCode:=LInv.DJobCode;
    end; {Case..}

    Case ReportMode of
      3..4,
      20,21   :  With LId,LInv do
                 If (JobCode<>LastJob) or (EmpAcc<>LastCust) or (DeliverRef<>LastJCTCode) or ((OurRef<>LastORefCode) and (ReportMode<=4)) then
                 Begin
                   If ((LastORefCode<>OurRef) or (JobCode<>LAstJob) or (DeliverRef<>LastJCTCode)) and (ReportMode<=4) then
                   Begin
                     If (LastORefCode<>'') then

                     Begin


                       PrintDueTot(4);


                     end;

                     Level[4]:=BOn;

                   end;


                   If ((LastJCTCode<>DeliverRef) or (JobCode<>LastJob) or (EmpAcc<>LastCust))  then
                   Begin
                     If (LastJCTCode<>'') then
                       PrintDueTot(3);

                     Level[3]:=BOn;
                   end;


                   Case SortOrd of
                     0  :  Begin
                             If (EmpAcc<>LastCust) or (JobCode<>LastJob) then
                             Begin
                                If (LastCust<>'') then
                                  PrintDueTot(2);

                                Level[2]:=BOn;
                              end;

                              If (LastJob<>JobCode) then
                              Begin
                                If (LastJob<>'') then
                                  PrintDueTot(1);

                                Level[1]:=BOn;
                              end;


                              If (Level[1]) then
                              Begin
                                LGetMainRecPos(JobF,JobCode);

                                PrintJobLine(JobCode,BOff);

                                LastJob:=JobCode;

                              end;


                              If (Level[2]) then
                              Begin
                                LastCust:=EmpAcc;

                                PrintEmplAccount(LastCust,BOff);

                              end;

                           end;

                     1  :  Begin
                             If (EmpAcc<>LastCust) or (JobCode<>LastJob) then
                             Begin
                                If (LastJob<>'') then
                                  PrintDueTot(2);


                                Level[2]:=BOn;
                              end;

                              If (EmpAcc<>LastCust) then
                              Begin
                                Level[1]:=BOn;

                                If (LastCust<>'') then
                                  PrintDueTot(1);

                              end;

                              If (Level[1]) then
                              Begin
                                LastCust:=EmpAcc;

                                PrintEmplAccount(LastCust,BOff);

                              end;

                              If (Level[2]) then
                              Begin
                                LGetMainRecPos(JobF,JobCode);

                                PrintJobLine(JobCode,BOff);

                                LastJob:=JobCode;

                              end;



                           end;

                   end; {Case..}


                   If (Level[3]) then
                   Begin
                     LastJCTCode:=DeliverRef;

                     If (ReportMode In [3,4]) then
                       PrintSubHed(GetJCTDetails(LastJCTCode),2,BOff);
                   end;

                   If (Level[4]) then
                   Begin

                     LastORefCode:=OurRef;

                     If (Not Summary) then
                       PrintSubHed(LastORefCode+'. '+AppsStatus(LastORefCode,BOn),3,BOff);

                   end;


                 end;


    end; {Case..}


    Case ReportMode of

      3..4
          :
            With LId,LInv do
            Begin
              Get_JDPos(LineTot);

              {* Note Use of PPr_Pr/Yr *}


              If (Not Summary) then
              Begin
                SetReportDrillDown(10);


                SendText(ConCat(#9,OurRef,#9,AppsStatus('',BOff)));

                For n:=Succ(Low(LineTot)) to 11 do
                  SendText(ConCat(ConstStr(#9,2+n),FormatBFloat(GenRealMask,LineTot[n],BOn)));

                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;
              end;
            end;
      20,21
          :
            With LInv do
            Begin

              {* Note Use of PPr_Pr/Yr *}

              If (PDiscTaken) then
                LineTot[1]:=Calc_JAPDocTotal(LInv,PDiscTaken,0)
              else
              Begin
                LineTot[2]:=Calc_JAPDocTotal(LInv,BOn,0);

                LineTot[3]:=Calc_JAPDocTotal(LInv,BOff,0);
              end;

              If (DeliverRef='') then
                LineTot[4]:=DiscSetAm;

              {$IFDEF MC_On}
                For n:=Low(LineTot) to High(LineTot) do
                Begin
                  Dnum:=LineTot[n];

                  If (RCr=0) then
                  Begin

                    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                    Dnum:=Round_Up(Conv_TCurr(Dnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);
                  end;

                  LineTot[n]:=Currency_Txlate(Dnum,RCr,RTXCr);

                end; {Loop..}
              {$ENDIF}

              If (Not Summary) then
              Begin
                SetReportDrillDown(13);


                SendLine(ConCat(#9,OurRef,#9,JAGiStatus(LInv),#9,AppsStatus('',BOn),#9,POutDate(TransDate),
                                #9,FormatBFloat(GenRealMask,LineTot[1],BOn),
                                #9,FormatBFloat(GenRealMask,LineTot[2],BOn),
                                #9,FormatBFloat(GenRealMask,LineTot[3],BOn),
                                #9,POutDate(DueDate),
                                #9,FormatBFloat(GenRealMask,LineTot[4],BOn),
                                #9,LCust.CustCC+'/'+LCust.CustDep));
              end;
            end;

    end; {Case..}


    CalcDueTotals(LineTot);
  end; {With..}
end;


{ ======================= Customer End ======================= }


Procedure TJCApps1Report.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1,CRepParam^ do
  If (ReportMode In [3..4,20,21]) then
  Begin
    For n:=High(JARepTotal) downto Low(JARepTotal) do
    Begin
      If ((RepPrintExcelTotals) or (n=1)) and ((n<>4) or (ReportMode<=4)) then
      Begin
        PrintDueTot(n);

        If (n=1) then
          DefLine(-2,MarginLeft,PageWidth-MarginRight-1,0);
      end;
    end;

  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJCApps1Report.IncludeRecord  :  Boolean;


Const
  Fnum    =  InvF;
  KeyPath =  InvFolioK;

Var
  TmpInclude :  Boolean;

  KeyS2      :  Str255;

Begin
  TmpInclude := False;

  {$B-}

  With MTExLocal^,CRepParam^,LId,LInv do
  Begin

    If (ReportMode In [3..4,20,21]) then
    Begin
      If (ThisScrt<>NIL) then {* Get Id Link *}
        ThisScrt^.Get_Scratch(LRepScr^);


      If (ReportMode In [3,4]) then
      Begin
        LResetRec(Fnum);

        KeyS2:=FullNomKey(FolioRef);

        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS2);
      end;
      
      If (LJobRec^.JobCode<>JobCode) then
        LGetMainRec(JobF,JobCode);

      If (CISEmpl<>LJobMisc^.EmplRec.EmpCode) then
        LRepGetJobMisc(FullEmpCode(LJobMisc^.EmplRec.EmpCode),3);


    end;


    Case ReportMode of

      3..4,
      20,21
           :
              Begin

                TmpInclude:=BOn;

                {LastJobCode:=JobCode;

                LastAccCode:=LJobRec^.CustCode;}


              end;

    end; {Case..}

  end; {With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJCApps1Report.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin
    If (ReportMode In [3,20]) then
       DocHed:=JPA
     else
       DocHed:=JSA;


    ThTitle:='Job Apps Rep';
    RepTitle:='Job Costing. ';

    Case ReportMode of
      3,4  :  RepTitle:=RepTitle+DocNames[DocHed]+'s  Report';
      20,21:  RepTitle:=RepTitle+DocNames[DocHed]+'s  Due Report';
    end; {Case..}

    PageTitle:=RepTitle;

    If (ReportMode In [20,21]) then
      ScrtMode:=25;

    ROrient:=RPDefine.PoLandscape;

    RFont.Size:=8;

    RFnum:=ReportF;

    RKeyPath:=RpK;

    If (Debug) then
    Begin

      {RPr:=1; RPr2:=12;

      RYr:=95; RYr2:=96;

      Reportmode:=1;}

    end;


    PageTitle:=RepTitle;


    {$IFDEF MC_On}

      If (RTxCr<>0) and (RTxCr<>RCr) then
         PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
      else
        PageTitle:=CurrDesc(RCr)+PageTitle;

    {$ENDIF}



     If (CustFilt<>'') then
     Begin
       GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOn,-1);


       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'For '+Strip('B',[#32],Cust.Company);
     end;

     If (EmpFilt<>'') then
     Begin
       GetJobMisc(Application.MainForm,FullEmpCode(EmpFilt),FoundCode,3,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'For Sub Contractor'+dbFormatName(JobMisc^.EmplRec.EmpCode,JobMisc^.EmplRec.EmpName);
     end;

     If (Not EmptyKey(JobFilt,JobKeyLen)) then
     Begin
       GetJob(Application.MainForm,JobFilt,FoundCode,-1);

       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Job Filter : '+dbFormatName(JobFilt,JobRec^.JobDesc);

       SingProd:=(JobRec^.JobType<>JobGrpCode);
     end;

     If (JCTFilt<>'') then
     Begin
       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'Terms Filter '+Trim(JCTFilt);
     end;

     If (QSFilt<>'') then
     Begin
       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       RepTitle2:=RepTitle2+'QS Filter '+Trim(QSFilt);
     end;

     If (CertMode<>2) then
     Begin
       If (RepTitle2<>'') then
         RepTitle2:=RepTitle2+', ';

       Case CertMode of
         0  :  RepTitle2:=RepTitle2+'Certified Applications';
         1  :  RepTitle2:=RepTitle2+'Uncertified Applications';
       end; {Case..}
     end;


      {$IFDEF PF_On}
       For BoLoop:=BOff to BOn do
         If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
         Begin
           FoundCode:=RCCDep[BoLoop];

           GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

           If (RepTitle2<>'') then
             RepTitle2:=RepTitle2+', ';

           RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

         end; {Loop..}


     {$ENDIF}

     

  end; {With..}

  Result:=BOn;
end;




Procedure TJCApps1Report.Process;

Var
  AbortPrint   :  Boolean;

Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}
  AbortPrint:=BOff;


  New(ThisScrt,Init(ScrtMode,MTExLocal,BOff));

  Try
    RepKey:=FullNomKey(ThisScrt^.Process);

    InitStatusMemo(4);

    ShowStatus(0,RepTitle);


    With CRepParam^ do
      Build_AppsDetail(ReportMode,AbortPrint);


    Inherited Process;

  Finally
    Dispose(ThisScrt,Done);
    ThisScrt:=nil;
  end;

end;


Procedure TJCApps1Report.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddJCAppsRep2Thread(LMode    :  Byte;
                              IRepParam:  JobCRep4Ptr;
                              AOwner   :  TObject);


Var
  EntTest  :  ^TJCApps1Report;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
          CRepParam^:=IRepParam^;


        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;


{Test BIN Report, Mode 1}

Procedure TESTAppsRep(LMode    :  Byte;
                      AOwner   :  TObject);


Var
  IRepParam:  JobCRep4Ptr;

Begin
  New(IRepParam);

  FillChar(IRepParam^,Sizeof(IRepParam^),#0);

  With IRepParam^ do
  Begin
    SDate:='20030101'; EDate:='20041231';

    ShowOCbal:=BOn; Summary:=BOn;

    AddJCAppsRep2Thread(LMode,IRepParam,AOwner);
  end;

  Dispose(IRepParam);
end;




Initialization



Finalization

end.