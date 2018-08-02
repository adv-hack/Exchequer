unit ReportWU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, SCRTCH2U,
  StkWarnU;


type

  TGLList      =  Class(TList)

                  Public
                    Function HaveCode(GLCode  :  Integer)  :  Boolean;
                  end;

  TWOR1Report  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       SCust       :  CustRec;
                       SStock      :  StockRec;
                       WIPId       :  IDetail;
                       LastWIPDoc,
                       SLocTit     :  Str80;
                       OWIPBal     :  Double;

                       CurrMode    :  Byte;

                       IndentLevel :  LongInt;
                       
                       LinkedWOR,
                       NomPosted   :  Boolean;

                       ThisScrt    :  Scratch2Ptr;

                       StkFuncs    :  tdSOPFuncsPtr;

                       GLList      :  TGLList;

                       Function BuildSortKey  :  Str255;

                       Function Level_Str(LevelNo  :  LongInt;
                                          StrLen   :  Byte;
                                      Var NoSpc    :  Byte)  :  Str30;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintWORLine(GMode    :  Byte;
                                              ContMode :  Boolean);

                       Procedure PrintWORTot(GMode     :  Byte);

                       Procedure CalcStkTotals(StkVal     :  Double);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure CalcPOStatus(Var POStatus  :  Str255;
                                              Var DelDate   :  LongDate;
                                                  QtyShort  :  Double);

                       Function Could_AllocIssue(InvR       :  InvRec;
                                                 IdR        :  IDetail;
                                                 Mode       :  Byte)  :  Double;


                       Procedure Build_BackOrder(Mode     :  Byte;
                                                 DocFilt  :  Char;
                                                 CustFilt,
                                                 LocFilt  :  Str10;
                                                 StkFilt  :  Str20;
                                             Var FoundOk  :  Boolean);

                       Procedure Build_OrderStatus(Mode     :  Byte;
                                                   CustFilt,
                                                   LocFilt  :  Str10;
                                                   StkFilt  :  Str20;
                                               Var FoundOk  :  Boolean);

                       Function Find_WORLink(ORef  :  Str20) :  Boolean;

                       Function Check_NomPosting(ORef  :  Str20;
                                             Var NInv  :  InvRec)  :  Boolean;


                       Procedure Match_AdjLines(ORef   :  Str20;
                                                IdR    :  Idetail);

                       Procedure FindMatch_ADJ(IdR      :  IDetail;
                                               InvR     :  InvRec;
                                               TKeypath :  Integer;
                                               DocMode  :  Byte;
                                               Level    :  Integer);


                       Function Make_NomIdKey(NmCode  :  LongInt;
                                              RCr,
                                              RYr,
                                              RPr     :  Byte)  :  Str20;

                       Procedure Build_MiscWIP(Mode     :  Byte;
                                               GLCode   :  LongInt;
                                           Var FoundOk  :  Boolean);

                       Procedure Build_WIP(Mode     :  Byte;
                                       Var FoundOk  :  Boolean);

                       Function BuildRefKey(IsBuildLine  :  Boolean;
                                            BuildFolio   :  LongInt)  :  Str20;

                       Function  Build_WORExp(DocNo    :  Str10;
                                              Level    :  Integer;
                                          Var FirstFind:  Boolean)  :  Boolean;


                     public

                       CRepParam  :  WOPRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure RepeatBackOrd(Var FoundOk  :  Boolean);

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddWOP1Rep2Thread(LMode    :  Byte;
                            IRepParam:  WOPRepPtr;
                            AOwner   :  TObject);

Procedure TESTWOR1Rep(LMode    :  Byte;
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
  VarRec2U,
  MiscU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  SysU1,
  SalTxl1U,
  SysU2,
  PWarnU,
  BTSupU1,
  SOPCT2U,
  RpDefine,
  WOPCT1U,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  
  ExThrd2U;

{ ========== TGLList. methods =========== }

  Function TGLList.HaveCode(GLCode  :  Integer)  :  Boolean;
  Var
    n  :  Integer;

  Begin
    Result:=BOff;

    For n:=0 to Pred(Count) do
    Begin
      Result:=(Items[n]=Pointer(GLCode));

      If (Result) then
        Break;
    end;
  end;

{ ========== TWOR1Report. methods =========== }

Constructor TWOR1Report.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  CurrMode:=1;

  ThisScrt:=nil;
  StkFuncs:=nil;
  OWIPBal:=0.0;
  LastWIPDoc:='';
  NomPosted:=BOff;
  LinkedWOR:=BOff;
  GLList:=Nil;

end;


Destructor TWOR1Report.Destroy;

Begin
  Dispose(CRepParam);

  If (Assigned(ThisScrt)) then
    Dispose(ThisScrt,Done);

  If (Assigned(StkFuncs)) then
    Dispose(StkFuncs,Destroy);

  Inherited Destroy;
end;





Procedure TWOR1Report.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1,11
         :  With CRepParam^ do
            Begin
              SetTab (MarginLeft, pjLeft, 5, 4, 0, 0);
              SetTab (NA, pjLeft, 53, 4, 0, 0);
              SetTab (NA, pjLeft, 10, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              
              Case AnalOrd of
                0  :  Begin
                        SetTab (NA, pjRight, 20, 4, 0, 0);

                        SetTab (NA, pjRight, 29, 4, 0, 0);
                        SetTab (NA, pjRight, 29, 4, 0, 0);
                      end;
                1  :  Begin
                        SetTab (NA, pjRight, 25, 4, 0, 0);
                        SetTab (NA, pjLeft, 35, 4, 0, 0);
                        SetTab (NA, pjLeft, 25, 4, 0, 0);
                      end;
              end; {case..}
            end;
        2
         :  Begin
              SetTab (MarginLeft, pjLeft, 21, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjLeft, 21, 4, 0, 0);
              SetTab (NA, pjLeft, 10, 4, 0, 0);
              SetTab (NA, pjRight, 12, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 53, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 15, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 15, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
            end;
        3
         :  Begin
              SetTab (MarginLeft, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 50, 4, 0, 0);
              SetTab (NA, pjRight, 25, 4, 0, 0);
              SetTab (NA, pjLeft, 21, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjLeft, 41, 4, 0, 0);
            end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;






Procedure TWOR1Report.RepPrintPageHeader;


Var
  ThisRMode  :  Integer;
  LocStr     :  Str10;

Begin
  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    LocStr:='';

    {$IFDEF SOP}
      If (Syss.UseMLoc) then
        LocStr:='Loc ';

    {$ENDIF}

    DefFont(0,[fsBold]);

    Case ReportMode of


      1,11
          :  Begin
               SendText(ConCat(#9,#9,'Stock Code•,Description',#9,'Loc',#9,'Qty',' ','Req',#9,'Global In Stk',#9,LocStr+'In',' ','Stk',#9,'Alloc',
                     #9,'Free',#9,'Short',#9,'Global On',' ','Ord'));

               Case AnalOrd of
                0  :  Begin
                        SendLine(ConCat(ConstStr(#9,11),'Unit',' ','Cost',#9,'Shortage',' ','Cost'));
                      end;
                1  :  Begin
                        SendLine(ConCat(ConstStr(#9,11),'On Order Status',#9,'Order Del Date'));
                      end;
              end; {case..}

             end;
      2
          :  SendLine(ConCat(#9,'Order No.',#9,'Comp Date',#9,'A/C',#9,'Ref',#9,'Loc',#9,'Tag No',#9,
                             'Build Qty',#9,'Stock Code•, Description',#9,'Issued Qty',#9,'% Issued',#9,
                             'Qty Built',#9,'% Built',#9,'Could Issue',#9,'Could Build'));
      3
          :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'Qty Issued/Built',#9,'ADJ Ref',#9,'Unit',' ','Cost',
                     #9,'WIP',' ','Cost',#9,'Status'));


    end; {case..}

    DefFont(0,[]);


  end; {With..}
end; {Proc..}





Procedure TWOR1Report.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With RepFiler1 do
  Case ReportMode of
    1,11
       :  If (CurrentPage>1) then
            PrintWORLine(0,BOn);
    3  :  If (CurrentPage>1) then
            PrintWORLine(1,BOn);
  end; {Case..}

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TWOR1Report.CalcStkTotals(StkVal     :  Double);


Begin


  With CRepParam^ do
    Case ReportMode of

        1,3,11
           :  Begin

                BSTot:=BSTot+StkVal;

                RepTot:=RepTot+StkVal;

                RepTotC:=RepTotC+StkVal;

              end;

    end; {Case..With..}
end;


Function TWOR1Report.Level_Str(LevelNo  :  LongInt;
                               StrLen   :  Byte;
                           Var NoSpc    :  Byte)  :  Str30;

Var

  NoDots,
  LevLen  :  Byte;
  TStr    :  Str30;


Begin

  TStr:=Form_Int(LevelNo,0);

  LevLen:=Length(TStr);

  NoDots:=0; NoSpc:=0;


  If (LevelNo<StrLen) then
  Begin

    NoDots:=StrLen-LevelNo;

    NoSpc:=Pred(LevelNo);

  end
  else
    If (LevLen<StrLen) then
    Begin

      NoDots:=1;
      NoSpc:=StrLen-(LevLen+NoDots);

    end;

  Level_Str:=ConstStr('.',NoSpc)+TStr+ConstStr('.',NoDots);

end; {Func..}



Procedure TWOR1Report.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      1,3,11  :  Begin
                   SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

                   If (ReportMode=3) then
                     SendRepDrillDown(4,4,2,LId.DocPRef,InvF,InvOurRefK,0);
                 end;

      2       :  Begin
                   SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

                   SendRepDrillDown(8,8,2,FullStockCode(LId.StockCode),StockF,StkCodeK,0);

                   SendRepDrillDown(3,3,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);
                 end;
    end; {Case..}
  end; {With..}
end;

Procedure TWOR1Report.PrintWORLine(GMode    :  Byte;
                                   ContMode :  Boolean);

Const
  Fnum1     =  InvF;
  Keypath1  =  InvFolioK;
  Fnum2     =  IdetailF;
  Keypath2  =  IdLinkK;

Var
  FoundOk   :  Boolean;

  NoSpc     :  Byte;

  KeyI,
  KeyChkI   :  Str255;
  LocalInv  :  InvRec;

  LocalId   :  Idetail;

  LocalStk  :  StockRec;

  LevelStr,
  SubHead   :  String;


Begin
  With MTExLocal^,RepFiler1, CRepParam^ do
  Begin
    LocalId:=LId;
    LocalInv:=LInv;
    LocalStk:=LStock;

    NoSpc:=0; LevelStr:='';

    SubHead:='Works Order '+LId.DocPRef+', not found!';

    DefFont(0,[fsUnderline,fsBold]);

    Case GMode of
      0  :  Begin
              FoundOk:=(LInv.FolioNum=LId.FolioRef);

              If (Not FoundOk) then
              Begin
                KeyI:=FullNOmKey(LId.FolioRef);

                FoundOk:=(LFind_Rec(B_GetEq,Fnum1,KeyPath1,KeyI)=0);

              end;

              If (FoundOk) then
              Begin
                LocalInv:=LInv;

                SubHead:=LInv.OurRef;

                KeyI:=FullIdKey(LId.FolioRef,1);

                FoundOk:=(LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyI)=0);

                If (FoundOk) then
                With LId,LStock do
                Begin
                  WIPId:=LId;
                  
                  HaveIssue:=SSDUplift-QtyWOff;

                  If LGetMainRec(StockF,LId.StockCode) then
                    SubHead:=SubHead+'. '+FormatFloat(GenQtyMask,Qty_OS(LId))+'(/'+FormatFloat(GenQtyMask,Qty)+') x '+dbFormatName(LId.StockCode,Desc[1]);

                  {$IFDEF SOP}
                    If (Syss.UseMLoc) then
                      SubHead:=SubHead+'. Into Loc: '+MLocStk;
                  {$ENDIF}

                  If (SOPLink<>0) and (SOPLineNo<>0) then
                  Begin
                    KeyI:=FullIdKey(SOPLink,SOPLineNo);

                    FoundOk:=(LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyI)=0);

                    If (FoundOk) then
                      SubHead:=SubHead+'. Linked to '+DocPRef+' (Line '+Form_Int(ABSLineNo,0)+')';

                  end;
                end;

                SubHead:=SubHead+'. Est. completion date : '+PoutDate(LInv.DueDate);

                If (ReportMode=11) then
                Begin
                  LevelStr:=Level_Str(Succ(IndentLevel),10,NoSpc);

                  SubHead:=LevelStr+SubHead;
                end;

                {$B-}
                With LInv,LCust do
                Begin
                  If (Trim(CustCode)<>'') and LGetMainRecPos(CustF,LInv.CustCode) then
                {$B+}
                    SubHead:=SubHead+'. A/C : '+dbFormatName(CustCode,Company);

                  If (Tagged<>0) then
                    SubHead:=SubHead+'. Tag No. '+SetN(Tagged);
                end;



              end;
            end;
      1  :  Begin
              With WIPId do
              Begin
                DefFont(0,[fsUnderline]);


                If (IdDocHed=WOR) then
                Begin
                  SubHead:=DocPRef+'. ';

                  If (ABSLineNo=1) then
                    SubHead:=SubHead+'Built'
                  else
                    SubHead:=SubHead+'Issued';
                end
                else
                  SubHead:='Misc Postings';
              end;
            end;
      2  :  Begin
              DefFont(1,[fsUnderline,fsBold]);

              KeyI:=FullNomKey(LId.NomCode);

              If (LGetMainRec(NomF,KeyI)) then
              With LNom do
              Begin
                If (LastGL<>0) then
                  // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                  Self.CRLF;

                SubHead:='WIP G/L : '+dbFormatName(Form_Int(NomCode,0),Desc);

                If (Not UseSalesOB) then
                Begin
                  OWIPBal:=Get_OCBal(NomType,FullNomKey(NomCode),0,RYr,RPr,0,BOff);

                  SubHead:=SubHead+'. Opening Balance '+FormatFloat(GenRealMask,OWIPBal);
                end;
              end;
            end;

    end; {Case..}

    If (ContMode) then
      SubHead:=SubHead+'./Cont...';

    Case GMode of
      0    :  SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
      1    :  SendRepDrillDown(1,TotTabs,1,WIPId.DocPRef,InvF,InvOurRefK,0);
      2    :  SendRepDrillDown(1,TotTabs,1,FullNOmKey(LNom.NomCode),NomF,NomCodeK,0);
    end; {Case..}

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft(SubHead,MarginLeft);
    Self.CRLF;

    If (GMode=0) then
    Begin
      DefFont(-4,[]);

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
    end;

    DefFont(0,[]);

    LInv:=LocalInv;
    LId:=LocalId;
    LStock:=LocalStk;
  end; {With..}
end;



{ ======================= Due Sub / Grand Total ================ }

Procedure TWOR1Report.PrintWORTot(GMode     :  Byte);

Var
  n          :  Byte;
  Dnum       :  Double;
  GenStr     :  Str255;


Begin
  With RepFiler1, CRepParam^ do
  Case ReportMode of
    1,11
       :  Begin
            DefFont(0,[fsBold]);

            Case GMode of
              0,2  :  DefLine(-2,TabStart(4-(2*Ord((AnalOrd=1) and (GMode=2)))),TabEnd(12),0);

            end; {Case..}

            If (CouldIssue<0) then
              CouldIssue:=0;

            CouldBuild:=HaveIssue+CouldIssue;

            Case GMode of
              0  :  BSTot:=RepTot;
              2  :  Begin
                      If (AnalOrd=1) then
                        SendText(ConCat(ConstStr(#9,10),'Worst',#9,'Case Completion Date : ',#9,POutDate(EstCompDate)));


                      SendText(ConCat(ConstStr(#9,4),'Issued: ',#9,FormatFloat(GenQtyMask,HaveIssue),#9,
                                      'Could Issue: ',#9,FormatFloat(GenQtyMask,CouldIssue),#9,
                                      'Could Build: ',#9,FormatFloat(GenQtyMask,CouldBuild)));

                    end;
            end; {Case..}

            If (AnalOrd=0) then
              SendLine(ConCat(ConstStr(#9,11),'Total :',#9,FormatFloat(GenRealMask,BSTot)))
            else
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;

            If (GMode=2) then
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;

            BSTot:=0.0;  CouldIssue:=-1.0; CouldBuild:=0;

            DefFont(0,[]);

          end; {Case..}

    3
       :  Begin
            DefFont(0,[]);

            Case GMode of
              0..2  :  DefLine(-2,TabStart(3-(2*Ord(GMode=0))),TabEnd(6),0);

            end; {Case..}

            Case GMode of
              0  :  Begin
                      BSTot:=RepTotC;

                      GenStr:='Report';

                      DefFont(1,[fsBold]);

                    end;

              1  :  With MTExLocal^.LNom do
                    Begin
                      BSTot:=RepTot;
                      GenStr:=dbFormatName(Form_Int(NomCode,0),Desc);

                      DefFont(0,[fsBold]);

                      SendRepDrillDown(1,TotTabs,1,FullNOmKey(NomCode),NomF,NomCodeK,0);

                    end;

              2  :  GenStr:=LastWIPDoc;

            end; {Case..}


            SendLine(ConCat(ConstStr(#9,3),GenStr,#9,' Total : ',ConstStr(#9,2),FormatFloat(GenRealMask,BSTot)));


            If (GMode=1) and (Not UseSalesOB) then
            With MTExLocal^.LNom do
            Begin
              DefFont(0,[fsBold]);

              Dnum:=Get_OCBal(NomType,FullNomKey(NomCode),0,RYr2,RPr2,0,BOn);

              Begin
                DefLine(-2,TabStart(1),TabEnd(6),0);

                SendLine(ConCat(#9,'G/L '+Form_Int(NomCode,0),#9,'Opening Balance + Report',#9,FormatFloat(GenRealMask,OWIPBal+RepTot),ConstStr(#9,2),'Difference : ',ConstStr(#9,1),FormatFloat(GenRealMask,OWIPBal+RepTot-Dnum)));
              end;
            end;

            Case GMode of
              0  :  RepTotC:=0;
              1  :  RepTot:=0;

            end; {Case..}

            BSTot:=0.0;

            DefFont(0,[]);

          end; {Case..}


  end; {Case..}

end;





{ ======================= Customer End ======================= }


Procedure TWOR1Report.PrintEndPage;
Var

  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  With RepFiler1 do
  Begin

    If (ReportMode In [1,3,11]) then
    Begin
      PrintWORTot(2);

      If (RepPrintExcelTotals) then
      Begin

        If (ReportMode=3) then
          PrintWORTot(1);

        PrintWORTot(0);
      end;
    end;

  end;

  Inherited PrintEndPage;


end;


{ == Proc to check how much stock on order == }

Procedure TWOR1Report.CalcPOStatus(Var POStatus  :  Str255;
                                   Var DelDate   :  LongDate;
                                       QtyShort  :  Double);

Const
  Fnum2    =  IdetailF;

  Keypath2 =  IdAnalK;

  


Var
  LoopKey  :  Array[BOff..BOn] of Char;
  KeySI,
  KeyChkI :  Str255;

  TBo,
  LoopCtrl,
  FoundOk :  Boolean;

  QtyNeed,
  QtyFound
          :  Double;

  SDays,SHrs,SMins
          :  Extended;

  LastStk :  StockRec;

  LastId,
  BOMId   :  IDetail;


Begin
  With MTExLocal^,CRepParam^ do
  Begin
    POStatus:='';
    DelDate:=LInv.DueDate;

    TBo:=BOff; LoopCtrl:=BOff; FoundOk:=BOff;

    LoopKey[BOff]:=StkLineType[POR];

    LoopKey[BOn]:=StkLineType[WOR];


    SDays:=0.0; SHrs:=0.0; SMins:=0.0;

    LastId:=LId;  LastStk:=LStock;

    QtyNeed:=QtyShort+StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocWPCode,LStock.StockFolio),TBo,BOn);

    QtyFound:=0.0;

    If (QtyShort>0.0) then
    Begin
      Repeat
        KeyChkI:=LoopKey[LoopCtrl]+FullStockCode(LastId.StockCode);

        KeySI:=KeyChkI;

        LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeySI);

        While (LStatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (Not FoundOk) and (ChkRepAbort)  do
        With LId do
        Begin
          QtyFound:=QtyFound+Qty_OS(LId);

          FoundOk:=(QtyFound>=QtyNeed);

          If (FoundOk) then
            DelDate:=PDate
          else
            LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeySI);

        end; {While..}

        LoopCtrl:=Not LoopCtrl;

      Until (LoopCtrl) or (FoundOk) or (Not ChkRepAbort) or (LStock.StockType<>StkBillCode);

      If (FoundOk) then
      Begin
        If (LStock.StockType<>StkBillCode) then
          POStatus:='Awaiting Purchase Order'
        else
          POStatus:='Awaiting Works Order';

        StkFuncs^.LPut_LastAlloc(TBo,QtyShort,AllocWPCode,LStock.StockFolio);

      end
      else
      Begin
        If (LStock.StockType<>StkBillCode) then
          POStatus:='Purchase Order Required'
        else
          POStatus:='Works Order Required';

        DelDate:=CalcDueDate(Today,LStock.LeadTime);
      end;

      {*Add in time to make*}

      If (Not LGetMainRec(StockF,WIPId.StockCode)) then
        LResetRec(StockF);

      Time2Mins(LStock.ProdTime,SDays,SHrs,SMins,0);

      DelDate:=CalcDueDate(DelDate,Round(SDays));
    end;

    If (DelDate>EstCompDate) then
      EstCompDate:=DelDate;

    LId:=LastId;
    LStock:=LastStk;
  end; {With..}

end;



{ == Function to check How much stock is available for issue == }

Function TWOR1Report.Could_AllocIssue(InvR       :  InvRec;
                                      IdR        :  IDetail;
                                      Mode       :  Byte)  :  Double;


Const
  Fnum2    =  IdetailF;

  Keypath2 =  IdFolioK;



Var
  KeySI,
  KeyChkI,
  GenStr  :  Str255;

  mbRet   :  Word;

  TBo,
  FoundOk :  Boolean;

  CouldBuild,
  QtyAvail,
  LineBuild
          :  Double;

  LastStk :  StockRec;

  LastId,
  BOMId   :  IDetail;


Begin
  With MTExLocal^,CRepParam^ do
  Begin
    Result:=0.0;

    KeyChkI:=FullNomKey(InvR.FolioNum);

    LastId:=LId;  LastStk:=LStock;

    CouldBuild:=-1.0;  LineBuild:=0.0; QtyAvail:=0.0;

    Begin
      BOMId:=IdR;

      KeySI:=FullIdKey(InvR.FolioNum,2);

      LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeySI);

      While (LStatusOk) and (CheckKey(KeyChkI,KeySI,Length(KeyChkI),BOn)) and (ChkRepAbort) do
      With LId do
      Begin

        If (LStock.StockCode<>StockCode) then
          If (Not LGetMainRec(StockF,StockCode)) then
            LResetRec(StockF);

        {$IFDEF SOP}
          LStock_LocSubst(LStock,MLocStk);
        {$ENDIF}

        If (UseSalesOB) then
        Begin
          StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocW2Code,LStock.StockFolio),TBo,BOn);

          If (Not TBo) then {Not found so must be first one}
            StkFuncs^.LPut_LastAlloc(TBo,AllocStock(LStock),AllocW2Code,LStock.StockFolio);

        end;

        QtyAvail:=(LStock.QtyInStock-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocW2Code,LStock.StockFolio),TBo,BOn));


        StkFuncs^.LPut_LastAlloc(TBo,Qty_OS(LId),AllocW2Code,LStock.StockFolio);

        If (Mode=1) then {Add whats already been picked back in}
          QtyAvail:=QtyAvail+QtyPick;

        LineBuild:=Round_Up(DivWChk(QtyAvail,QtyMul),Syss.NoQtyDec);


        If ((LineBuild<CouldBuild) or (CouldBuild=-1.0)) and (Qty_Os(LId)<>0.0) and (LStock.StockType<>StkDescCode) then
        Begin
          CouldBuild:=LineBuild;

          If (CouldBuild>Round_Up(DivWChk(Qty_OS(LId),QtyMul),Syss.NoQtyDec)) then
            CouldBuild:=Round_Up(DivWChk(Qty_OS(LId),QtyMul),Syss.NoQtyDec);
        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeySI);

      end; {While..}


      If (CouldBuild>0.0) then
        Result:=CouldBuild;


    end;

    LId:=LastId;
    LStock:=LastStk;
  end; {With..}

end;


Function TWOR1Report.BuildRefKey(IsBuildLine  :  Boolean;
                                 BuildFolio   :  LongInt)  :  Str20;

Begin
  Result:=FullNomKey(BuildFolio)+SetN(Ord(IsBuildLine));
end;

{ ======================= WOP Line ======================= }


Procedure TWOR1Report.PrintReportLine;

Var
  Rnum,
  Rnum2,
  RnumC,
  OldQty     :  Real;

  Dnum       :  Double;

  UOR,
  n          :  Byte;

  LineTot    :  AgedTyp;

  TBo
             :  Boolean;

  BMFlg      :  Char;


  LKitFolio  :  LongInt;
  LKitQty    :  Real;


  GenStr     :  Str255;

  DelDate    :  LongDate;

  LocalInv   :  InvRec;


Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Rnum:=0;

    Rnum2:=0;

    RnumC:=0;  Dnum:=0.0;

    OldQty:=0;

    GenStr:='';

    BMFlg:=#32;

    Blank(LineTot,Sizeof(LineTot));

    LKitFolio:=1;

    DelDate:='';

    Case ReportMode of
      1,11
            :  With LId do
               If (FolioRef<>LastFolio) then
               Begin
                 If (LastFolio<>0) then
                   PrintWORTot(2);

                 LastFolio:=FolioRef;

                 EstCompDate:=LInv.DueDate; {Prime worst case completion date as manual completion date}

                 PrintWORLine(0,BOff);

               end;

      3     :  With LId do
               Begin

                 If (BuildRefKey((SOPLineNo=1),SOPLink)<>LastFolioStr) or (NomCode<>LastGL) then
                 Begin
                   If (LastFolioStr<>'') then
                     PrintWORTot(2);

                   LastFolioStr:=BuildRefKey((SOPLineNo=1),SOPLink);

                   If (NomCode<>LastGL) then
                   Begin
                     If (LastGL<>0) then
                       PrintWORTot(1);

                     PrintWORLine(2,BOff);

                     LastGL:=NomCode;
                   end;

                   PrintWORLine(1,BOff);

                 end;
               end;
    end; {Case..}


    SetReportDrillDown(0);

    Case ReportMode of

      1,11
         : Begin

              With LStock do
              Begin
                Linetot[1]:=QtyInStock;

                LineTot[2]:=StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocWCode,LStock.StockFolio),TBo,BOn);

                Linetot[3]:=LineTot[1]-LineTot[2];


                LineTot[4]:=Qty_Os(LId);

                If PChkAllowed_In(143) then
                  Linetot[7]:=LId.CostPrice;  {* Currency of Document *}


                LineTot[5]:=Round_Up(LineTot[4]-LineTot[3],Syss.NoQtyDec);


                If (LineTot[5]<0) then
                  LineTot[5]:=0;


                LineTot[6]:=SStock.QtyOnOrder;

                If (AnalOrd=1) then
                  LineTot[6]:=LineTot[6]-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocWPCode,LStock.StockFolio),TBo,BOn);

                If (LineTot[6]<0) then
                  LineTot[6]:=0;

                If (StockType=StkBillCode) then
                  GenStr:='*'
                else
                  GenStr:=#32;

                LineTot[8]:=Round_Up((LineTot[5]*LineTot[7]),Syss.NoCosDec);

                SendText(ConCat(#9,GenStr,#9,dbFormatName(LStock.StockCode,LStock.Desc[1]),
                        #9,LId.MLocStk,
                        #9,FormatFloat(GenQtyMask,LineTot[4]),
                        #9,FormatFloat(GenQtyMask,SStock.QtyInStock),
                        #9,FormatFloat(GenQtyMask,LineTot[1]),
                        #9,FormatFloat(GenQtyMask,LineTot[2]),
                        #9,FormatFloat(GenQtyMask,LineTot[3]),
                        #9,FormatBFloat(GenQtyMask,LineTot[5],LineTot[5]=0.0),
                        #9,FormatBFloat(GenQtyMask,LineTot[6],LIneTot[6]=0.0)));

                Case AnalOrd of
                  0  :  Begin
                          SendLine(ConCat(ConstStr(#9,11),FormatBFloat(GenUnitMask[BOff],LineTot[7],Linetot[7]=0.0),
                          #9,FormatBFloat(GenRealMask,LineTot[8],LineTot[8]=0.0)));
                        end;
                  1  :  Begin
                          CalcPOStatus(GenStr,DelDate,LineTot[5]);

                          SendLine(ConCat(ConstStr(#9,11),GenStr,#9,POutDate(DelDate)));
                        end;

                end; {Case..}

                CalcStkTotals(LineTot[8]);

                With LId do
                Begin
                  If (DivWChk(LineTot[3],QtyMul)<CouldIssue) or (CouldIssue=-1) then
                  Begin
                    CouldIssue:=Round_Up(DivWChk(LineTot[3],QtyMul),Syss.NoQtyDec);

                    If (CouldIssue>DivWChk(LineTot[4],QtyMul)) then
                      CouldIssue:=Round_Up(DivWChk(LineTot[4],QtyMul),Syss.NoQtyDec);

                    If (CouldIssue<0) then
                      CouldIssue:=0.0;
                  end;
                end;

                StkFuncs^.LPut_LastAlloc(TBo,LineTot[4],AllocWCode,LStock.StockFolio);

              end;
            end;

      2   : Begin

              With LInv,LId do
              Begin
                Linetot[1]:=Could_AllocIssue(LInv,LId,0);

                SendLine(ConCat(#9,OurRef,
                        #9,POutDate(DueDate),
                        #9,CustCode,
                        #9,YourRef,
                        #9,MLocStk,
                        #9,SetN(Tagged),
                        #9,FormatFloat(GenQtyMask,Qty),
                        #9,dbFormatName(LStock.StockCode,LStock.Desc[1]),
                        #9,FormatFloat(GenQtyMask,SSDUplift),
                        #9,FormatFloat(GenPcntMask,(DivWChk(TotalInvoiced,TotalCost)*100)),
                        #9,FormatFloat(GenQtyMask,QtyWOff),
                        #9,FormatFloat(GenPcntMask,(DivWChk(QtyWOff,Qty)*100)),
                        #9,FormatFloat(GenQtyMask,LineTot[1]),
                        #9,FormatFloat(GenQtyMask,SSDUplift+LineTot[1]-QtyWOff)));



              end;
            end;


      3   : Begin

              With LInv,LId,LStock do
              Begin
                If (IdDocHed=ADJ) then
                Begin
                  If (Check_NomPosting(DocPRef,LocalInv)) then
                    FindMatch_ADJ(LId,LocalInv,IdFolioK,1,0)
                  else
                    NomPosted:=BOff;

                  Dnum:=InvLCost(LId)*DocNotCnst;
                  Rnum:=CostPrice;
                end
                else
                With LId do
                Begin
                  NomPosted:=BOff;

                  Dnum:=InvLTotal(LId,BOff,0);

                  UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

                  Dnum:=Round_Up(Conv_TCurr(InvLTotal(LId,BOff,0),XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);


                  Rnum:=Round_Up(Conv_TCurr(NetValue,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),Syss.NoCosDec);

                end;

                If ((RunNo=StkAdjRunNo) and (NomPosted)) or (IdDocHed<>ADJ) then
                  GenStr:='Posted'
                else
                  GenStr:='Unposted';

                SendLine(ConCat(#9,LStock.StockCode,
                        #9,LStock.Desc[1],
                        #9,FormatFloat(GenQtyMask,Qty*DocNotCnst),
                        #9,DocPRef,
                        #9,FormatFloat(GenUnitMask[BOff],Rnum),
                        #9,FormatFloat(GenRealMask,Dnum),
                        #9,GenStr));


                CalcStkTotals(Dnum);

              end;
            end;



    end; {Case..}


  end;
end;






{ ======================= Customer Include ======================= }


Function TWOR1Report.IncludeRecord  :  Boolean;

Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;

  Fnum2     =  IdetailF;
  Keypath2  =  IdLinkK;


Var
  TmpInclude,
  TBo        :  Boolean;
  KeyCS      :  Str255;


Begin
  TmpInclude:=BOff;

  TBo:=BOff;


  {$B-}

  With MTExLocal^, CRepParam^ do
  Case ReportMode of
        1,11
           :  With LId do
              Begin
                If (Assigned(ThisScrt)) then {* Get Id Link *}
                  ThisScrt^.Get_Scratch(LRepScr^);

                If (ReportMode=11) then
                  IndentLevel:=IntStr(Trim(LRepScr^.KeyStr));

                LResetRec(RFnum);

                TmpInclude:=((ABSLineNo>1) and (Not EmptyKey(StockCode,StkKeyLen)));

                If (TmpInclude) then
                Begin

                  TmpInclude:=LGetMainRec(StockF,StockCode);

                  SStock:=LStock;
                  {$IFDEF SOP}
                    LStock_LocSubst(LStock,MLocStk);
                  {$ENDIF}

                  If (ReportMode=1) then
                  Begin
                    TmpInclude:=((TmpInclude)
                    and ((LStock.QtyInStock-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocWCode,LStock.StockFolio),TBo,BOn))
                     <Qty_Os(LId)));

                    If (Not TmpInclude) then
                      StkFuncs^.LPut_LastAlloc(TBo,Qty_Os(LId),AllocWCode,LStock.StockFolio);
                  end;


                end;

              end;
        2
           :  With LInv do
              Begin
                If (Assigned(ThisScrt)) then {* Get Id Link *}
                  ThisScrt^.Get_Scratch(LRepScr^);

                LResetRec(RFnum);

                KeyCS:=FullIdKey(FolioNum,1);

                TmpInclude:=(LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyCS)=0);

                If (TmpInclude) then
                  With LId do
                    TmpInclude:=((ABSLineNo=1) and (Not EmptyKey(StockCode,StkKeyLen)));

                If (TmpInclude) then
                Begin

                  TmpInclude:=LGetMainRec(StockF,LId.StockCode);

                end;

              end;

        3
           :  With LId do
              Begin
                If (Assigned(ThisScrt)) then {* Get Id Link *}
                  ThisScrt^.Get_Scratch(LRepScr^);

                LResetRec(RFnum);


                KeyCS:=FullNomKey(FolioRef); {Get parent Header}

                TmpInclude:=(LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS)=0);

                LastId:=LId;

                If (IdDocHed=ADJ) then
                Begin
                  TmpInclude:=LGetMainRec(StockF,StockCode);

                  KeyCS:=FullIdKey(SOPLink,SOPLineNo);

                  TmpInclude:=(LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyCS)=0);

                  If (WIPId.IdDocHed=WOR) then
                  Begin
                    If (LastWIPDoc<>'') then
                      LastWIPDoc:=WIPId.DocPRef
                    else
                      LastWIPDoc:=LId.DocPRef;
                  end
                  else
                    LastWIPDoc:='Misc Postings';

                  If (TmpInclude) then
                    WIPId:=LId
                  else
                    FillChar(WIPId,Sizeof(WIPId),#0);
                end
                else
                With LStock do
                Begin
                  If (WIPId.IdDocHed<>WOR) then
                    LastWIPDoc:='Misc Postings';

                  WIPId:=LId;
                  LResetRec(StockF);

                  StockCode:='Non WOR G/L Postings';
                  Desc[1]:=LId.Desc;
                end;


                LId:=LastId;
              end;


      end; {Case..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TWOR1Report.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;

  KeyCS
     :  Str255;


Begin
  With CRepParam^ do
  Begin
    SLocTit:='';

    Case ReportMode of

       1..3,11
            :   Begin
                  ThTitle:='WOR Report';


                  Case ReportMode of
                    1
                       :  Begin
                            RepTitle:='Works Order Fulfilment Report';
                            ROrient:=RPDefine.PoLandscape;
                          end;
                    2  :  Begin
                            RepTitle:='Works Order Status Report';
                            ROrient:=RPDefine.PoLandscape;
                          end;
                    3  :  Begin
                            RepTitle:='Work In Progress Reconciliation Report';
                            ROrient:=RPDefine.PoPortrait;
                          end;
                    11
                       :  Begin
                            RepTitle:='Works Order Explosion Report';
                            ROrient:=RPDefine.PoLandscape;
                          end;
                  end;

                  PageTitle:=RepTitle;


                  RFont.Size:=8;
                  
                  RFnum:=ReportF;

                  RKeyPath:=RpK;

                  If (Not EmptyKey(STCode,StkKeyLen)) then
                  Begin
                    GetStock(Application.MainForm,FullStockCode(STCode),FoundCode,-1);
                    SStock:=Stock;
                  end;


                  If (Not EmptyKey(CustFilt,CustKeyLen)) then
                  Begin
                    GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOn,-1);
                    SCust:=Cust;
                  end;

                  {$IFDEF SOP}
                     If (Not EmptyKey(LocFilt,LocKeyLen)) then
                     Begin
                       SLocTit:=MLocRepTitle(LocFilt);
                     end;
                  {$ENDIF}

                  CouldIssue:=-1.0;

                end;


    end; {Case..}




  end; {With..}

  Result:=BOn;
end;

{ =========== Func to Build WOR Sort Key ========= }

Function TWOR1Report.BuildSortKey  :  Str255;

  Function BuildReverseORefK(ORef  :  Str20)  :  Str20;

  Var
    LenPrefix,
    NCount  :  LongInt;
  Begin
    LenPrefix:=Length(DocCodes[SIN]);

    Result:=Copy(ORef,1,LenPrefix);

    NCount:=IntStr(Trim(Copy(ORef,Succ(LenPrefix),Length(ORef)-LenPrefix)));

    Result:=Result+SetPadNo(Form_Int(Round(9E6-NCount),0),Length(ORef)-LenPrefix);

  end;

Begin
  FillChar(Result,Sizeof(Result),#0);

  With MTExLocal^,LInv,CRepParam^ do
  Begin
    Case SortOrd of
      0  :  Result:=DueDate;
      1  :  Result:=SetN(Tagged)+DueDate;
      2  :  Result:=FullCustCode(CustCode)+DueDate;
      3  :  Result:=OurRef;
      4  :  Result:=BuildReverseORefK(OurRef);
    end; {Case..}

    Result:=Result+FullNomKey(FolioNum);

    Case ReportMode of
      1  :  Result:=Result+Form_Int(LId.LineNo,6);
      {2  :  Result:=SetN(Ord(TotalInvoiced>0.0))+Result;}
    end;
  end;

end;

{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TWOR1Report.Build_BackOrder(Mode     :  Byte;
                                      DocFilt  :  Char;
                                      CustFilt,
                                      LocFilt  :  Str10;
                                      StkFilt  :  Str20;
                                  Var FoundOk  :  Boolean);


Const
  Fnum      =  IDetailF;
  Keypath   =  IdAnalK;

  Fnum2     =  InvF;
  Keypath2  =  InvFolioK;



Var
  KeyCS,
  KeyChk,
  KeyInv   :  Str255;

  RecAddr  :  LongInt;

  MatchStr :  Str255;
  BODate   :  LongDate;

  TmpInclude,
  TBo,
  FirstFind
           :  Boolean;



Begin

  With MTExLocal^,CRepParam^ do
  Begin

    KeyChk:=DocFilt;
    KeyCS:=KeyChk;

    RecAddr:=0;  FirstFind:=BOn;  TBo:=Boff;

    FoundOk:=BOff;
    TmpInclude:=BOff;

    ShowStatus(2,'Please Wait, Building Report');

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LInv,LId do
    Begin

      Case Mode of
        1 :  Begin   {* Delivery date is header...}

                If (LInv.FolioNum<>FolioRef) then
                Begin
                  KeyInv:=FullNomKey(FolioRef);

                  LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

                end;

                BODate:=LInv.DueDate;

              end;


      end; {Case..}


      TmpInclude:=((LineNo>1) and (Qty_OS(LId)<>0)
                     and (Not EmptyKey(StockCode,StkKeyLen))
                     and (((BODate>=SDate) and (BODate<=EDate)) or (EDate=''))
                     and (((OurRef>=StartDocNo) and (OurRef<=EndDocNo)) or (EndDocNo=''))
                     and ((Tagged=TagFilt) or (TagFilt=0))
                     and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                     and (GetHoldType(HoldFlg)<>HoldQ)
                     and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)));

      If (TmpInclude) then
      Begin

        LGetMainRec(StockF,StockCode);

        {$B-}

          TmpInclude:=(CheckKey(StkFilt,StockCode,Length(StkFilt),BOff) or Stk_InGroup(StkFilt,LStock));

        {$B+}
      end;


      If (TmpInclude) then
      Begin
        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        MatchStr:=FullNomKey(FolioRef);

        ThisScrt^.Add_Scratch(Fnum,IdFolioK,RecAddr,BuildSortKey,MatchStr);

        FoundOk:=BOn;

        If (FirstFind) then
        Begin
          FirstFind:=BOff;
          StkFuncs^.LReset_Alloc(AllocWCode);

          If (AnalOrd=1) then {Reset Future Purchase Order Usage}
            StkFuncs^.LReset_Alloc(AllocWPCode);

        end;

        If (UseSalesOB) then
        Begin
          StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocWCode,LStock.StockFolio),TBo,BOn);

          If (Not TBo) then {Not found so must be first one}
            StkFuncs^.LPut_LastAlloc(TBo,AllocStock(LStock),AllocWCode,LStock.StockFolio);

        end;

      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}


  end; {With..}
end; {Proc..}


{ =========== Proc to Scan and Build Order Status Report ========= }

Procedure TWOR1Report.Build_OrderStatus(Mode     :  Byte;
                                        CustFilt,
                                        LocFilt  :  Str10;
                                        StkFilt  :  Str20;
                                    Var FoundOk  :  Boolean);


Const
  Fnum      =  InvF;
  Keypath   =  InvRNoK;

  Fnum2     =  IdetailF;
  Keypath2  =  IdLinkK;



Var
  KeyCS,
  KeyChk,
  KeyInv   :  Str255;

  RecAddr  :  LongInt;

  MatchStr :  Str255;
  BODate   :  LongDate;

  TmpInclude,
  TBo,
  FirstFind
           :  Boolean;



Begin

  With MTExLocal^,CRepParam^ do
  Begin

    KeyChk:=FullDayBkKey(WORUPRunNo,FirstAddrd,DocCodes[WOR]);
    KeyCS:=KeyChk;

    RecAddr:=0;  FirstFind:=BOn;  TBo:=Boff;

    FoundOk:=BOff;
    TmpInclude:=BOff;

    ShowStatus(2,'Please Wait, Building Report');

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyCS,5,BOn)) and (ChkRepAbort) do
    With LInv,LId do
    Begin

      Case Mode of
        2 :   Begin   {* Delivery date is header...}


                BODate:=LInv.DueDate;

              end;


      end; {Case..}

      KeyInv:=FullIdKey(FolioNum,1);

      TmpInclude:=(LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv)=0);

      If (TmpInclude) then
        TmpInclude:=((LineNo=1) and (Qty_OS(LId)<>0)
                     and (Not EmptyKey(StockCode,StkKeyLen))
                     and (((BODate>=SDate) and (BODate<=EDate)) or (EDate=''))
                     and (((OurRef>=StartDocNo) and (OurRef<=EndDocNo)) or (EndDocNo=''))
                     and ((Tagged=TagFilt) or (TagFilt=0))
                     and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                     and (GetHoldType(HoldFlg)<>HoldQ)
                     and ((TotalInvoiced>0.0) or (FiltOrd<>2))
                     and ((TotalInvoiced=0.0) or (FiltOrd<>1))
                     and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)));

      If (TmpInclude) then
      Begin

        LGetMainRec(StockF,StockCode);

        {$B-}

          TmpInclude:=(CheckKey(StkFilt,StockCode,Length(StkFilt),BOff) or Stk_InGroup(StkFilt,LStock));

        {$B+}
      end;


      If (TmpInclude) then
      Begin
        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        MatchStr:=FullNomKey(FolioNum);

        ThisScrt^.Add_Scratch(Fnum,InvFolioK,RecAddr,BuildSortKey,MatchStr);

        FoundOk:=BOn;

        If (FirstFind) then
        Begin
          FirstFind:=BOff;
          StkFuncs^.LReset_Alloc(AllocW2Code);
        end;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}


  end; {With..}
end; {Proc..}


{ == Proc to scan all lines belonging to an ADJ for a match with the original WOR Line == }

Function TWOR1Report.Check_NomPosting(ORef  :  Str20;
                                  Var NInv  :  InvRec)  :  Boolean;



Var
  FoundOk :  Boolean;
  KeyCS   :  Str255;

  RecAddr :  LongInt;

  LocalInv:  InvRec;

Begin
  With MTExLocal^,CRepParam^ do
  Begin
    LocalInv:=LInv;

    KeyCS:=ORef;
    LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyCS);

    FoundOk:=LStatusOk;

    With LInv do
      NOMPosted:=(FoundOk) and (RunNo>0);

    NInv:=LInv;

    LInv:=LocalInv;
  end; {With..}

  Result:=FoundOk;
end;

{ == Proc to scan matches belonging to a NOM for a match with the original WOR == }

Function TWOR1Report.Find_WORLink(ORef  :  Str20) :  Boolean;


Var
  FoundOk :  Boolean;
  KeyCS   :  Str255;

  LocalInv:  InvRec;

Begin
  With MTExLocal^,CRepParam^ do
  Begin
    LocalInv:=LInv;

    KeyCS:=ORef;
    LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyCS);

    FoundOk:=LStatusOk;

    If (LStatusOk) then {* Search for a link from Adj back to WOR, if found this Nom line is already accounted for *}
      FindMatch_ADJ(LId,LInv,IdNOMK,3,0);


    LInv:=LocalInv;
  end; {With..}

  Result:=LinkedWOR;
end;



{ == Proc to scan all lines belonging to an ADJ for a match with the original WOR Line == }

Procedure TWOR1Report.Match_AdjLines(ORef   :  Str20;
                                     IdR    :  Idetail);

Const
  Fnum    = IdetailF;
  Keypath = IdFolioK;


Var
  TmpInclude,
  FoundOk :  Boolean;
  MatchStr,
  KeyCS,
  KeyChk  :  Str255;

  RecAddr :  LongInt;

  

Begin
  With MTExLocal^,CRepParam^ do
  Begin
    KeyCS:=ORef; FoundOk:=BOff; TmpInclude:=BOff;

    LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyCS);

    With LInv do

    {$B-}
    TmpInclude:=((LStatusOk) and ((Pr2Fig(AcPr,AcYr)>=Pr2Fig(RPr,RYr)) and (Pr2Fig(AcPr,AcYr)<=Pr2Fig(RPr2,RYr2)))
                     and ((RunNo=StkAdjRunNo) or (UseSalesOB)));

    If (TmpInclude) and (Not UseSalesOB) then {Perform additional check to see if NOM is posted as well}
    Begin
      FindMatch_ADJ(LId,LInv,Keypath,1,0);

      TmpInclude:=NOMPosted;
    end;

    {$B+}

    If TmpInclude then
    With LInv do
    Begin
      KeyChk:=FullNomKey(FolioNum);
      KeyCS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyCS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) and (Not FoundOk) do
      With LId do
      Begin
        If (SOPLink=IdR.FolioRef) and (SOPLineNo=IdR.AbsLineNo) then {Add to scratch file}
        Begin
          FoundOk:=BOn;

          If ((NomCode=GLFilt) or (GLFilt=0)) then
          Begin
            LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

            MatchStr:=FullIdKey(FolioRef,ABSLineNo);

            ThisScrt^.Add_Scratch(Fnum,IdLinkK,RecAddr,FullNomKey(NomCode)+FullNomKey(SOPLink)+SetN(Ord(Idr.ABSLineNo=1))+FullStockCode(StockCode),MatchStr);

            If Assigned(GLList) and (Not UseSalesOB) then {Keep track of all the unique WIP G/L codes processed so far if we are trying to reconcile to G/L}
            With GLList do
            Begin
              If (Not HaveCode(NomCode)) then
                Add(Pointer(NomCode));
            end;
          end;
        end;

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyCS);

      end;

    end;
  end; {With..}
end;

{== Proc to Pick up all related ADJ nos from the matching file == }

Procedure TWOR1Report.FindMatch_ADJ(IdR      :  IDetail;
                                    InvR     :  InvRec;
                                    TKeypath :  Integer;
                                    DocMode  :  Byte;
                                    Level    :  Integer);

Const
  Fnum  =  PWrdF;

Var
  FoundOk      :  Boolean;
  Keypath,
  LastKP       :  Integer;
  TmpStat      :  Integer;
  RecAddr,
  TmpRecAddr,
  TmpRecAddr2  :  LongInt;
  KeyCS,KeyChk,NKey
               :  Str255;

  LocalInv:  InvRec;


Begin
  With MTExLocal^,InvR do
  Begin
    TmpStat:=LPresrv_BTPos(IdetailF,TKeypath,LocalF^[IdetailF],TmpRecAddr,BOff,BOff);

    If ((RemitNo<>'') or (OrdMatch)) then
      Keypath:=PWK
    else
      Keypath:=HelpNDXK;

    LastKP:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum,LastKP,LocalF^[Fnum],TmpRecAddr2,BOff,BOff);

    FoundOk:=BOff;

    KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);
    KeyCS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);


    While (LStatusOK) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOff)) and (Not FoundOk) and (ChkRepAbort) do
    With LPassword.MatchPayRec do
    Begin
      Case Keypath of
        PWK       :  Begin
                       NKey:=PayRef;
                     end;
        HelpNdxK  :  Begin
                       NKey:=DocCode;
                     end;
      end; {Case..}

      Case DocMode of
        0  :  If (Copy(NKey,1,3)=DocCodes[ADJ]) then
                Match_AdjLines(NKey,IdR);

        1  :  If (Copy(NKey,1,3)=DocCodes[NMT]) then
                FoundOk:=Check_NomPosting(NKey,LocalInv);

        2  :  If (Copy(NKey,1,3)=DocCodes[ADJ]) then
                FoundOk:=Find_WORLink(NKey);

        3  :  Begin
                FoundOk:=(Copy(NKey,1,3)=DocCodes[WOR]);
                LinkedWOR:=FoundOk;
              end;

        30 :  Begin
                If (Copy(NKey,1,3)=DocCodes[WOR]) then
                Begin
                  LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

                  If Build_WORExp(NKey,Level,LinkedWOR) then
                  Begin
                    InvR.OurRef:=NKey;


                    {Go find sub matches for this transaction}
                    FindMatch_ADJ(IdR,InvR,TKeypath,DocMode,Level+1);

                    LSetDataRecOfs(Fnum,RecAddr);

                    LStatus:=LGetDirect(Fnum,KeyPath,0);
                  end;
                end;
              end;



      end; {Case..}

      If (Not FoundOk) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end;

    TmpStat:=LPresrv_BTPos(Fnum,LastKP,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);

    TmpStat:=LPresrv_BTPos(IdetailF,TKeypath,LocalF^[IdetailF],TmpRecAddr,BOn,BOff);
  end; {With..}

end; {Proc..}

{ ==== Make Nominal Id Key ==== }

Function TWOR1Report.Make_NomIdKey(NmCode  :  LongInt;
                                   RCr,
                                   RYr,
                                   RPr     :  Byte)  :  Str20;


Begin

  Make_NomIdKey:=FullNomKey(NmCode)+Chr(0)+Chr(RCr)+Chr(RYr)+Chr(RPr);

end;


{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TWOR1Report.Build_MiscWIP(Mode     :  Byte;
                                    GLCode   :  LongInt;
                                Var FoundOk  :  Boolean);


Const
  Fnum      =  IDetailF;
  Keypath   =  IdNOMK;

  Fnum2     =  InvF;
  Keypath2  =  InvFolioK;



Var
  UseCr    :  Byte;

  KeyCS,
  KeyChk,
  KeyInv   :  Str255;

  RecAddr  :  LongInt;

  B_Func   :  Integer;

  MatchStr :  Str255;
  BODate   :  LongDate;

  TmpInclude
           :  Boolean;



Begin

  With MTExLocal^,CRepParam^ do
  Begin

    KeyChk:=FullNomKey(GLCode)+#0;
    KeyCS:=KeyChk;

    RecAddr:=0;  UseCr:=0;

    FoundOk:=BOff;
    TmpInclude:=BOff;


    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LInv,LId do
    Begin
      B_Func:=B_GetNext;

      If (LInv.FolioNum<>FolioRef) then
      Begin
        KeyInv:=FullNomKey(FolioRef);

        LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

      end;
      LinkedWOR:=BOff;

      TmpInclude:=((LStatusOk) and ((Pr2Fig(AcPr,AcYr)>=Pr2Fig(RPr,RYr)) and (Pr2Fig(AcPr,AcYr)<=Pr2Fig(RPr2,RYr2)))
                     and (RunNo>0) and ((NomCode=GLFilt) or (GLFilt=0)));


      If (TmpInclude) then
      Begin
        FindMatch_ADJ(LId,LInv,Keypath,2,0);

        FoundOk:=LinkedWOR;

        If (Not LinkedWOR) then {Its an independant posting to this G/L code}
        Begin
          LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

          MatchStr:=FullIdKey(FolioRef,ABSLineNo);

          ThisScrt^.Add_Scratch(Fnum,IdLinkK,RecAddr,FullNomKey(NomCode)+FullNomKey(SOPLink)+SetN(0),MatchStr);
        end;
      end
      else
      Begin
        B_Func:=B_GetGEq;

        If (Pr2Fig(PYr,PPr)<Pr2Fig(RYr,RPr)) then
          KeyCS:=Make_NomIdKey(NomCode,Currency,RYr,RPr)
        else
          If (Pr2Fig(PYr,PPr)>Pr2Fig(RYr2,RPr2)) then
          Begin
            {$IFDEF MC_On}
              If (UseCr<CurrencyType) then
              Begin
                If (UseCr<Currency) then
                  UseCr:=Currency;

                Inc(UseCr);

                KeyCS:=Make_NomIdKey(NomCode,UseCr,RYr,RPr);
              end
              else
            {$ENDIF}

            KeyCS:=Make_NomIdKey(FirstAddrD,UseCr,RYr,RPr);

          end
          else
            B_Func:=B_GetNext;
      end;


      LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyCS);

    end; {While..}


  end; {With..}
end; {Proc..}


{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TWOR1Report.Build_WIP(Mode     :  Byte;
                            Var FoundOk  :  Boolean);


Const
  Fnum      =  IDetailF;
  Keypath   =  IdAnalK;

  Fnum2     =  InvF;
  Keypath2  =  InvFolioK;



Var
  KeyCS,
  KeyChk,
  KeyInv   :  Str255;

  n        :  Integer;

  RecAddr  :  LongInt;

  MatchStr :  Str255;
  BODate   :  LongDate;

  TmpInclude
           :  Boolean;



Begin
  GLList:=TGLList.Create;

  Try
    With MTExLocal^,CRepParam^ do
    Begin

      KeyChk:=StkLineType[WOR];
      KeyCS:=KeyChk;

      RecAddr:=0;

      FoundOk:=BOff;
      TmpInclude:=BOff;

      ShowStatus(2,'Please Wait, Building Report');

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
      With LInv,LId do
      Begin
        If (LInv.FolioNum<>FolioRef) then
        Begin
          KeyInv:=FullNomKey(FolioRef);

          LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

        end;


        TmpInclude:=(((QtyDel<>0.0) or (QtyWOff<>0.0))
                       and (Not EmptyKey(StockCode,StkKeyLen)));

        If (TmpInclude) then
        Begin

          LGetMainRec(StockF,StockCode);

          {$B-}

            TmpInclude:=(CheckKey(StockFilt,StockCode,Length(StockFilt),BOff) or Stk_InGroup(StockFilt,LStock));

          {$B+}
        end;


        If (TmpInclude) then
        Begin
          NOMPosted:=BOff;

          FindMatch_ADJ(LId,LInv,Keypath,0,0);

          FoundOk:=BOn;
        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

      end; {While..}

      {$B-}
      If (Assigned(GLList)) and (GLList.Count>=0) then
      With GLList do
      Begin
        For n:=0 to Pred(Count) do
          Build_MiscWIP(0,Integer(Items[n]),FoundOk);
      end;
      {$B+}

    end; {With..}
  Finally
    FreeAndNil(GLList);
  end; {try..}
end; {Proc..}


{ =========== Proc to Scan and Build WOR Explosion ========= }

Function TWOR1Report.Build_WORExp(DocNo    :  Str10;
                                   Level    :  Integer;
                               Var FirstFind:  Boolean)  :  Boolean;


Const
  Fnum      =  IDetailF;
  Keypath   =  IdFolioK;

  Fnum2     =  InvF;
  Keypath2  =  InvOurRefK;



Var
  KeyCS,
  KeyChk,
  KeyInv   :  Str255;

  RecAddr  :  LongInt;

  MatchStr :  Str255;
  BODate   :  LongDate;

  TmpInclude,
  TBo
           :  Boolean;



Begin

  Try
    With MTExLocal^,CRepParam^ do
    Begin
      Result:=BOn;

      KeyInv:=DocNo;

      LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

      {$B-}
      If (LStatusOk) and (Assigned(GLList)) and (Not GLList.HaveCode(LInv.FolioNum)) then
      {$B+}
      With LInv do
      Begin
        If Assigned(GLList) then {Keep track of all the unique WIP G/L codes processed so far if we are trying to reconcile to G/L}
        With GLList do
        Begin
          If (Not HaveCode(FolioNum)) then
            Add(Pointer(FolioNum));
        end;

        KeyChk:=FullNomKey(FolioNum);
        KeyCS:=FullIdKey(FolioNum,2);

        RecAddr:=0;  TBo:=Boff;

        TmpInclude:=BOff;

        ShowStatus(2,'Please Wait, Building Report');

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
        With LId do
        Begin


          TmpInclude:=((LineNo>1) and (Qty_OS(LId)<>0)
                         and (Not EmptyKey(StockCode,StkKeyLen))
                         and ((Tagged=TagFilt) or (TagFilt=0))
                         and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                         and (GetHoldType(HoldFlg)<>HoldQ)
                         and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)));

          If (TmpInclude) then
          Begin

            LGetMainRec(StockF,StockCode);

            {$B-}

              TmpInclude:=(CheckKey(StockFilt,StockCode,Length(StockFilt),BOff) or Stk_InGroup(StockFilt,LStock));

            {$B+}
          end;


          If (TmpInclude) then
          Begin
            LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

            MatchStr:=Form_Int(Level,0);

            ThisScrt^.Add_Scratch(Fnum,IdFolioK,RecAddr,FullNomKey(FolioRef)+SetN(Ord(LStock.StockType=StkBillCode))+Form_Int(LineNo,6),MatchStr);

            If (FirstFind) then
            Begin
              FirstFind:=BOff;
              StkFuncs^.LReset_Alloc(AllocWCode);
            end;

            If (UseSalesOB) then
            Begin
              StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocWCode,LStock.StockFolio),TBo,BOn);

              If (Not TBo) then {Not found so must be first one}
                StkFuncs^.LPut_LastAlloc(TBo,AllocStock(LStock),AllocWCode,LStock.StockFolio);

            end;

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

        end; {While..}
      end
      else
        Result:=BOff;

    end; {With..}
  Finally

  end; {try..}

end; {Proc..}



Procedure TWOR1Report.RepeatBackOrd(Var FoundOk  :  Boolean);

Const
  ModeDoc    :  Array[1..1] of DocTypes = (WOR);

Var
  ScrMode  :  Byte;

  LocalInv :  InvRec;
  LocalId  :  IDetail;

Begin
  If (ReportMode In [1..3,11]) then
  With CRepParam^ do
  Begin
    FillChar(LocalInv,Sizeof(LocalInv),#0);
    FillChar(LocalId,Sizeof(LocalId),#0);


    If (Assigned(ThisScrt)) then
      Dispose(ThisScrt,Done);

    If (ReportMode<>11) then
      ScrMode:=16+ReportMode
    else
      ScrMode:=17;

    New(ThisScrt,Init(ScrMode,MTExLocal,BOff));

    RepTitle2:='';

    If (Not EmptyKey(CustFilt,CustKeyLen)) and (ReportMode<>11) then
      RepTitle2:=RepTitle2+' For '+Strip('B',[#32],SCust.Company)+'.';

    If (Not EmptyKey(STCode,StkKeyLen)) then
      RepTitle2:=RepTitle2+' Stock Filter: '+Strip('B',[#32],SStock.Desc[1])+'.';

    If (SLocTit<>'') then
      RepTitle2:=RepTitle2+' '+SLocTit+'.';

    If (ReportMode<>11) then
    Begin
      If (EDate<>'') and (SDate<>'')  then
        RepTitle2:=RepTitle2+' For Completion : '+POutDate(SDate)+' - '+POutDate(EDate)+'.'
      else
        If (EDate<>'') then
          RepTitle2:=RepTitle2+' For Completion up to: '+POutDate(EDate)+'.';
    end;

    If (EndDocNo<>'') and (StartDocNo<>'')  and (ReportMode<>11) then
      RepTitle2:=RepTitle2+' Doc Range : '+StartDocNo+' - '+EndDocNo+'.'
    else
      If (EndDocNo<>'') then
        RepTitle2:=RepTitle2+' Doc Range up to: '+EndDocNo+'.';

    If (TagFilt<>0) then
      RepTitle2:=RepTitle2+' Tag Filter : '+SetN(TagFilt)+'.';

    If (ReportMode=3) then
    Begin
      If (UseSalesOB) then
        PageTitle:=PageTitle+': Posted & Unposted Adjustments.';

      RepTitle2:=RepTitle2+PPR_OutPr(RPr,RYr)+' - '+PPR_OutPr(RPr2,RYr2);
    end;

    If (ReportMode=2) then
    Begin
      Case FiltOrd of
        0  :  PageTitle:=PageTitle+': Started & Unstarted Orders.';
        1  :  PageTitle:=PageTitle+': Unstarted Orders only.';
        2  :  PageTitle:=PageTitle+': Started Orders only.';
      end; {case..}

    end;

    If (ReportMode=11) then
      PageTitle:=PageTitle+' for '+LinkDocNo;

    If (ReportMode In [1,11]) and (AnalOrd=1) then
      PageTitle:=PageTitle+'. Worst case completion date forecast based on re-order lead times & BOM production times';


    BSTot:=0; BSTotc:=0;

    RepTot:=0; RepTotc:=0;

    ICount:=0;

    RepKey:=FullNomKey(ThisScrt^.Process);


    Case ReportMode of
      1  :  Build_BackOrder(CurrMode,
                            StkLineType[ModeDoc[CurrMode]],
                            CustFilt,
                            LocFilt,
                            STCode,
                            FoundOk);

      2  :  Build_OrderStatus(ReportMode,
                              CustFilt,
                              LocFilt,
                              STCode,
                              FoundOk);

      3  :  Build_WIP(ReportMode,FoundOk);

      11 :  Begin
              GLList:=TGLList.Create;

              Try
                LinkedWOR:=BOn;

                If (Copy(LinkDocNo,1,3)=DocCodes[WOR]) then
                  ScrMode:=1
                else
                  ScrMode:=0;

                If (ScrMode=1) then
                  Build_WORExp(LinkDocNo,0,LinkedWOR);

                LocalInv.OurRef:=LinkDocNo;

                FindMatch_ADJ(LocalId,LocalInv,IdFolioK,30,ScrMode);
              Finally
                FreeAndNil(GLList);
              end; {try..}

            end;


    end; {Case..}

  end;

  Inc(CurrMode);

end;


Procedure TWOR1Report.Process;

Var
  FoundOk  :  Boolean;

Begin
  InitStatusMemo(4);

{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}

  ShowStatus(0,RepTitle);

  New(StkFuncs,Create(MTExLocal));

  If (ReportMode In [1..3,11]) then
  Begin
    RepeatBackOrd(FoundOk);

  end;

  Inherited Process;

end;


Procedure TWOR1Report.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddWOP1Rep2Thread(LMode    :  Byte;
                            IRepParam:  WOPRepPtr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TWOR1Report;

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

{Test WOR Report, Mode 1}

Procedure TESTWOR1Rep(LMode    :  Byte;
                      AOwner   :  TObject);


Var
  IRepParam:  WOPRepPtr;

Begin
  New(IRepParam);

  FillChar(IRepParam^,Sizeof(IRepParam^),#0);

  With IRepParam^ do
  Begin
    SDate:=''; EDate:='';  FiltOrd:=0;
    RPr:=01; RYr:=99; RPr2:=12; RYr2:=109;  UseSalesOB:=BOff;

    LinkDocNo:='SOR000163';

    AddWOP1Rep2Thread(LMode,IRepParam,AOwner);
  end;

  Dispose(IRepParam);
end;


Initialization



Finalization

end.