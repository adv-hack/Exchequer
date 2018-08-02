unit ReportFU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU, SCRTCH2U,
  StkWarnU;


type



  TSKitReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       SCust       :  CustRec;
                       SStock      :  StockRec;
                       SLocTit     :  Str80;

                       CurrMode  :  Byte;
                       SetAlFlg  :  Boolean;

                       InBomReport :  Boolean;

                       ThisScrt    :  Scratch2Ptr;

                       StkFuncs    :  tdSOPFuncsPtr;

                       Procedure DueEnd;

                       Function Level_Str(LevelNo  :  LongInt;
                                          StrLen   :  Byte;
                                      Var NoSpc    :  Byte)  :  Str30;

                       Procedure BackLogDetail;

                       Procedure PrintStockTot(GMode     :  Byte);

                       Procedure CalcStkTotals(StkVal     :  Real);

                       Function DueInclude  :  Boolean;

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure Build_BackOrder(Mode     :  Byte;
                                                 DocFilt  :  Char;
                                                 CustFilt,
                                                 LocFilt  :  Str10;
                                                 StkFilt  :  Str20;
                                                 RCr      :  Byte;
                                                 Update   :  LongDate;
                                             Var FoundOk  :  Boolean);

                       Procedure RepeatBackOrd(Var FoundOk  :  Boolean);


                     public

                       CRepParam  :  KitRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       {$IFDEF WOP}
                         Function Match_WORLines(ORef   :  Str20;
                                                 IdR    :  Idetail)  :  Boolean;

                         Function FindMatch_WOR(IdR      :  IDetail;
                                                InvR     :  InvRec;
                                                TKeypath :  Integer;
                                                DocMode  :  Byte)  :  Boolean;
                       {$ENDIF}

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddSKitRep2Thread(LMode    :  Byte;
                            IRepParam:  KitRepPtr;
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
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  SysU1,
  SysU2,
  BTSupU1,
  SOPCT2U,
  RpDefine,

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U;


{ ========== TSKitReport methods =========== }

Constructor TSKitReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  InBOMReport:=BOff;

  CurrMode:=1;
  SetAlFlg:=BOff;
  ThisScrt:=nil;
  StkFuncs:=nil;


end;


Destructor TSKitReport.Destroy;

Begin
  Dispose(CRepParam);

  If (Assigned(ThisScrt)) then
    Dispose(ThisScrt,Done);

  If (Assigned(StkFuncs)) then
    Dispose(StkFuncs,Destroy);

  Inherited Destroy;
end;





Procedure TSKitReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1,2
          :  Begin
              SetTab (MarginLeft, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 15, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
            end;


        3,4
         :  Begin
              SetTab (MarginLeft, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

        5
         :  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 16, 4, 0, 0);
              SetTab (NA, pjLeft, 06, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 25, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;
        6
         :  Begin
              SetTab (MarginLeft, pjLeft, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 39, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 17, 4, 0, 0);
              SetTab (NA, pjRight, 25, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;





Procedure TSKitReport.BackLogDetail;



Const
  Fnum       =  PWrdF;
  

Var
  KeyCS,
  KeyChk     :  Str255;

  NewLine    :  Boolean;

  Rnum       :  Real;

  LocalIBR   :  Boolean;

  Keypath,
  TmpStat    :  Integer;
  TmpRecAddr :  LongInt;



Begin

  Rnum:=0;

  NewLine:=BOn;

  LocalIBR:=InBomReport;

  InBOMReport:=BOn;

  Keypath:=  PWK;

  With MTExLocal^,CRepParam^ do
  Begin
    KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(KitFolio)));

    KeyCS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With CRepParam^ do
    Begin

      TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      If (DueInclude) then
      Begin
        PrintReportLine;
        Inc(ICount);
        NewLine:=BOff;
      end;

      With RepFiler1 do
        If (LinesLeft<5) then
          ThrowNewPage(5);

      TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

    If (Not NewLine) then
      DueEnd;

  end; {With..}

  InBOMReport:=LocalIBR;
end; {Proc..}



Procedure TSKitReport.RepPrintPageHeader;


Var
  ThisRMode  :  Integer;
  StkCap     :  Str20;

Begin
  ThisRMode:=ReportMode;

  If (ReportMode=6) then
    ReportMode:=5;

  
  With RepFiler1,CRepParam^ do
  Begin
    If (UseFree) then
      StkCap:='Free'
    else
      StkCap:='In';

    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1,2
          :  SendLine(ConCat(#9,#9,'Stock',' ','Code',#9,'Description',#9,'Qty',' ','Reqd',#9,
                     'U.O.M.',#9,StkCap,' ','Stk',#9,'Short',#9,'On',' ','Ord',#9,'Qty',' ','Picked',#9,
                     'Qty',' ','Short'));


      3..4
          :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'In',' ','Stk',#9,'Alloc',
                     #9,'Free',#9,'Qty',' ','Req',#9,'Short',#9,'On',' ','Ord',#9,'Unit',' ','Cost',
                     #9,'Shortage',' ','Cost'));

      5,6
          :  Begin

               SendLine(ConCat(#9,'Order',' ','No.',#9,'Date',' ','Due',#9,'AC',' ','No',#9,#9,'Stock',
                    ' ','Code•,Desc',#9,'Req',#9,'InStk',#9,'Alloc',#9,'Free',#9,'Send',#9,
                    'OnOrd',#9,'Short',#9,'Cost',#9,'Sales '));

               ReportMode:=ThisRMode;
             end;
    end; {case..}

    If (InBOMReport) and (ThisRMode=6) then
      RepSetTabs;

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TSKitReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);


end;




{ ======================= Calculate Due Totals ==================== }

Procedure TSKitReport.CalcStkTotals(StkVal     :  Real);

Var
  nBo        :  Boolean;
  Rnum       :  Real;

Begin

  Rnum:=0;

  With CRepParam^ do
    Case ReportMode of

        1..5
           :  Begin

                BSTot:=BSTot+StkVal;

                RepTot:=RepTot+StkVal;

              end;

    end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TSKitReport.PrintStockTot(GMode     :  Byte);

Var
  n          :  Byte;


Begin


  With RepFiler1, CRepParam^ do
  Case ReportMode of
    3,4
       :  Begin
            DefFont(0,[fsBold]);

            Case GMode of
              2  :  DefLine(-2,TabStart(1),TabEnd(10),0);

            end; {Case..}


            SendLine(ConCat(ConstStr(#9,9),'Total :',#9,FormatFloat(GenRealMask,BSTot)));


            DefFont(0,[]);

          end; {Case..}

    5
       :  Begin
            Case GMode of
              1  :  DefLine(-1,TabStart(1),TabEnd(14),0);


              2  :  Begin

                      BSTot:=RepTot;

                      BSTotC:=RepTotC;

                      DefLine(-1,TabStart(1),TabEnd(14),0);

                    end;

            end; {Case..}


            SendLine(ConCat(ConstStr(#9,12),'Totals:',#9,FormatFloat(GenRealMask,BSTotc),#9,
                    FormatFloat(GenRealMask,BSTot)));


            Case GMode of

              1  :  DefLine(-1,TabStart(1),TabEnd(14),0);

            end; {Case..}

            BSTot:=0;

            BSTotC:=0;


          end; {Case..}


  end; {Case..}

end;



{ ====== Function to pad Level Str ======= }

Function TSKitReport.Level_Str(LevelNo  :  LongInt;
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

  Level_Str:=TStr+ConstStr('.',NoDots);

end; {Func..}



{ ======================= Due End ======================= }


Procedure TSKitReport.DueEnd;

Var

  KitEnd     :  Str255;

  n,m        :  Byte;

Begin
  With RepFiler1, MTExLocal^,CRepParam^ do
  Begin

    Case ReportMode of

      1,2,6
           :  Begin

                Begin

                  KitEnd:=FullNomKey(KitFolio);

                  LStatus:=LFind_Rec(B_GetEq,StockF,StkFolioK,KitEnd);

                  KitEnd:='';

                  If (LStatusOk) then
                  With LStock do
                  Begin

                    KitEnd:=Strip('B',[#32],StockCode)+','+Desc[1];


                    If (KitLevel>0) then
                      n:=Round(DivWChk(62-Length(KitEnd),2))
                    else
                      n:=Round(DivWChk(124-Length(KitEnd),2));

                    KitEnd:='<'+ConstStr('-',n)+'(end of '+KitEnd+')'+ConstStr('-',n)+'>';
                  end;

                  DefFont(0,[fsItalic,fsBold]);
                  // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                  Self.PrintCenter(KitEnd,PageWidth/2);
                  Self.CrLF;
                  DefFont(0,[]);

                end;
              end;
    end; {Case..}
  end; {With..}
end;



{ ======================= Due Include ======================= }


Function TSKitReport.DueInclude  :  Boolean;

Const
  Fnum    =  InvF;
  KeyPath =  InvFolioK;

Var
  TmpInclude :  Boolean;
  DayRepInc,
  TBo        :  Boolean;

  ChkRecon   :  Byte;


Begin
  {$B-}
  TmpInclude := False;
  TBo:=BOff;

  With CRepParam^,MTExLocal^ do
  Begin



      Case ReportMode of

        1..6
             :  With LPassword.BillMatRec do
                Begin

                  TmpInclude:=LGetMainRec(StockF,FullStkCode);


                  If (ReportMode In [3,4]) then
                  Begin

                    TmpInclude:=((TmpInclude)
                      and ((SKitQty*QtyUsed)>
                      (LStock.QtyInStock-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn))));

                    If (Not TmpInclude) then
                      StkFuncs^.LPut_LastAlloc(TBo,SKitQty*QtyUsed,AllocSCode,LStock.StockFolio);


                    If (ReportMode=4) and (Not EmptyKey(CustFilt,CustKeyLen)) and (TmpInclude) then
                      TmpInclude:=CheckKey(CustFilt,LStock.Supplier,Length(CustFilt),BOff);


                  end;


                end;


      end; {Case..}

    end; {With..}

    {$B+}

    Result:=TmpInclude;
end; {Func..}



{ ======================= Customer End ======================= }


Procedure TSKitReport.PrintEndPage;
Var

  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  With RepFiler1 do
  Begin

    If (ReportMode In [3..5]) then
      PrintStockTot(2);

  end;

  Inherited PrintEndPage;

  If (ReportMode=5) and (CurrMode<=2) and (ChkRepAbort) then
  With RepFiler1 do
  Begin
    RepeatBackOrd(FoundOk);

    If (FoundOk) then
    Begin
      With MTExLocal^,ThreadRec^ do
        PTotal:=PTotal+Used_RecsCId(LocalF^[RFnum],RFnum,ExCLientId);

      ThrowNewPage(-1);

      RepPrint(Nil);
    end;
  end;
end;

{$IFDEF WOP}
  { == Proc to scan all lines belonging to an ADJ for a match with the original WOR Line == }

  Function TSKitReport.Match_WORLines(ORef   :  Str20;
                                      IdR    :  Idetail)  :  Boolean;

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
      TmpInclude:=((LStatusOk) and (InvDocHed=WOR));
      {$B+}

      If TmpInclude then
      With LInv do
      Begin
        KeyChk:=FullIDKey(FolioNum,1);
        KeyCS:=KeyChk;

        LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyCS);

        {$B-}
        With LId do
          FoundOk:=(LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (SOPLink=IdR.FolioRef) and (SOPLineNo=IdR.AbsLineNo);
        {$B+}


      end;
    end; {With..}

    Result:=FoundOk;
  end;

  {== Proc to Pick up all related ADJ nos from the matching file == }

  Function TSKitReport.FindMatch_WOR(IdR      :  IDetail;
                                     InvR     :  InvRec;
                                     TKeypath :  Integer;
                                     DocMode  :  Byte)  :  Boolean;

  Const
    Fnum  =  PWrdF;

  Var
    FoundOk      :  Boolean;
    Keypath,
    LastKP       :  Integer;
    TmpStat      :  Integer;
    TmpRecAddr,
    TmpRecAddr2  :  LongInt;
    KeyCS,KeyChk,NKey
                 :  Str255;

    LocalInv:  InvRec;
    LocalId :  IDetail;


  Begin
    With MTExLocal^,InvR do
    Begin
      LocalInv:=LInv; LocalId:=LId;

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
          0  :  If (Copy(NKey,1,3)=DocCodes[WOR]) then
                  FoundOk:=Match_WORLines(NKey,IdR);


        end; {Case..}

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

      end;

      TmpStat:=LPresrv_BTPos(Fnum,LastKP,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);

      TmpStat:=LPresrv_BTPos(IdetailF,TKeypath,LocalF^[IdetailF],TmpRecAddr,BOn,BOff);

      LInv:=LocalInv; LId:=LocalId;
    end; {With..}

    Result:=FoundOk;

  end; {Proc..}
{$ENDIF}


Procedure TSKitReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
       1..4,
       6     :  SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

       5     :  Begin
                  SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

                  SendRepDrillDown(5,12,2,FullStockCode(LId.StockCode),StockF,StkCodeK,0);

                  SendRepDrillDown(3,3,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);
                end;

    end; {Case..}
  end; {With..}
end;

{ ======================= Customer Line ======================= }


Procedure TSKitReport.PrintReportLine;

Var
  Rnum,
  Rnum2,
  RnumC,
  OldQty     :  Real;

  UOR,
  n,
  NoSpc      :  Byte;

  LineTot    :  AgedTyp;

  TBo,
  IsShort,
  IsBOM,
  Isok2P
             :  Boolean;

  BMFlg      :  Str5;


  LKitFolio  :  LongInt;
  LKitQty    :  Real;

  LevelStr   :  Str30;

  DocStr     :  Str10;

  GenStr     :  Str255;

  DelDate    :  LongDate;


Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Rnum:=0;

    Rnum2:=0;

    RnumC:=0;

    OldQty:=0;

    GenStr:='';

    BMFlg:=#32;

    Blank(LineTot,Sizeof(LineTot));

    IsBOM:=BOff;

    IsShort:=BOff;

    DelDate:='';

    DocStr:='';

    IsOk2P:=BOff;

    LevelStr:='';

    NoSpc:=0;

    SetReportDrillDown(0);

    Case ReportMode of
      1..2
            : Begin

                With LStock do
                With LPassword.BillMatRec do
                Begin

                  If (InBomReport) then
                  Begin
                    LineTot[1]:=SKitQty*QtyUsed;

                    If (UseFree) then
                      Linetot[2]:=FreeStock(LStock)
                    else
                      Linetot[2]:=QtyInStock;

                    Linetot[2]:=LineTot[2]-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn);


                    LineTot[3]:=Round_Up(LineTot[1]-LineTot[2],Syss.NoQtyDec);

                    IsBOM:=(StockType=StkBillCode);


                    IsShort:=((LineTot[3]>0) and (IsBOM));

                    If (LineTot[3]<0) then
                      LineTot[3]:=0;


                    Linetot[4]:=LStock.QtyOnOrder;
                  end
                  else
                  Begin
                    If (ReportMode=1) then
                      LineTot[1]:=Qty_Os(LId)*LId.QtyMul
                    else
                      LineTot[1]:=SKitQty;

                    If (UseFree) then
                      Linetot[2]:=FreeStock(LStock)
                    else
                      Linetot[2]:=QtyInStock;

                    Linetot[2]:=LineTot[2]-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn);

                    LineTot[3]:=Round_Up(LineTot[1]-LineTot[2],Syss.NoQtyDec);

                    IsShort:=((LineTot[3]>0) and (StockType=StkBillCode) and ((Not ShowasKit) or (ReportMode=2)));

                    If (LineTot[3]<0) then
                      LineTot[3]:=0;


                    Linetot[4]:=LStock.QtyOnOrder;
                  end;



                  If (KitLevel>=0) then
                    LevelStr:=Level_Str(Succ(KitLevel),DocYRef1Len,NoSpc);

                         {* Note -----------v--------v-------v & v BOM specials ------ *}


                  SendLine(ConCat(#9,Spc(NoSpc),LevelStr,
                           #9,LStock.StockCode,
                           #9,LStock.Desc[1],
                           #9,FormatFloat(GenQtyMask,LineTot[1]),
                           #9,UnitS,
                           #9,FormatFloat(GenQtyMask,LineTot[2]),
                           #9,FormatFloat(GenQtyMask,LineTot[3]),
                           #9,FormatFloat(GenQtyMask,LineTot[4])));


                  DefLine(-1,TabStart(9),TabEnd(9),0);
                  DefLine(-1,TabStart(10)+3,TabEnd(10),0);

                  If (IsShort) then
                    DefLine(-1,TabStart(1),TabEnd(8),0);

                  StkFuncs^.LPut_LastAlloc(TBo,LineTot[1],AllocSCode,LStock.StockFolio);

                end; {With..}
              end;

      3,4 : Begin

              With LStock do
              With LPassword.BillMatRec do
              Begin

                If (InBOMReport) then
                Begin
                  Linetot[1]:=QtyInStock-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn);

                  LineTot[2]:=AllocStock(LStock);

                  Linetot[3]:=LineTot[1]-LineTot[2];


                  LineTot[4]:=SKitQty*QtyUsed;


                  LineTot[5]:=Round_Up(LineTot[4]-LineTot[1],Syss.NoQtyDec);

                  IsBOM:=(StockType=StkBillCode);


                  IsShort:=((LineTot[5]>0) and (IsBOM));

                  If (LineTot[5]<0) then
                    LineTot[5]:=0
                  else
                    If (LineTot[5]>LineTot[4]) then  {* Limit shortage amount to that required *}
                      LineTot[5]:=Linetot[4];


                  LineTot[6]:=QtyOnOrder;

                  Linetot[7]:=Calc_StkCP(LStock.CostPrice,LStock.BuyUnit,LStock.CalcPack);  {* Currency of Stock Record *}


                  {$IFDEF MC_On}

                    {* Convert to either Doc Currency, or Base Currency if individual item *}

                    LineTot[7]:=Currency_ConvFT(LineTot[7],LStock.PCurrency,RCr,UseCoDayRate);


                  {$ENDIF}





                  LineTot[8]:=Round_Up((LineTot[5]*LineTot[7]),Syss.NoCosDec);



                  IsOk2P:=((Not IsBOM) or (QtyInStock<>0)); {* Its a kit with no stock, so only show lines *}
                end
                else
                Begin
                  Linetot[1]:=QtyInStock-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn);

                  LineTot[2]:=AllocStock(LStock);

                  Linetot[3]:=FreeStock(LStock);


                  If (ReportMode=3) then
                  Begin
                    LineTot[4]:=Qty_Os(LId)*LId.QtyMul;

                    Linetot[7]:=LId.CostPrice;  {* Currency of Document *}


                  end
                  else
                  Begin

                    LineTot[4]:=SKitQty;

                    Linetot[7]:=Calc_StkCP(LStock.CostPrice,LStock.BuyUnit,LStock.CalcPack);  {* Currency of Stock Record *}


                    {$IFDEF MC_On}

                      LineTot[7]:=Currency_ConvFT(LineTot[7],LStock.PCurrency,RCr,UseCoDayRate);

                    {$ENDIF}

                  end;



                  LineTot[5]:=Round_Up(LineTot[4]-LineTot[1],Syss.NoQtyDec);

                  IsBOM:=(StockType=StkBillCode);


                  IsShort:=((LineTot[5]>0) and (IsBOM) and ((Not ShowasKit)
                          or (ReportMode=4)));

                  If (LineTot[5]<0) then
                    LineTot[5]:=0;


                  LineTot[6]:=QtyOnOrder;


                  LineTot[8]:=Round_Up((LineTot[5]*LineTot[7]),Syss.NoCosDec);



                  IsOk2P:=((Not IsBOM) or (QtyInStock<>0)); {* Its a kit with no stock, so only show lines *}

                end;

                                  {* Note use of BOM undy on / off *}
                If (IsOk2P) then

                  SendLine(ConCat(#9,LStock.StockCode,
                          #9,LStock.Desc[1],
                          #9,FormatFloat(GenQtyMask,LineTot[1]),
                          #9,FormatFloat(GenQtyMask,LineTot[2]),
                          #9,FormatFloat(GenQtyMask,LineTot[3]),
                          #9,FormatFloat(GenQtyMask,LineTot[4]),
                          #9,FormatFloat(GenQtyMask,LineTot[5]),
                          #9,FormatFloat(GenQtyMask,LineTot[6]),
                          #9,FormatFloat(GenUnitMask[BOff],LineTot[7]),
                          #9,FormatFloat(GenRealMask,LineTot[8])));


                If (IsShort) then
                    DefLine(-1,TabStart(1),TabEnd(10),0);

                If (IsOk2P) then
                  CalcStkTotals(LineTot[8]);


                StkFuncs^.LPut_LastAlloc(TBo,LineTot[4],AllocSCode,LStock.StockFolio);

              end;
            end;


      5   : Begin
              With LId do
              Begin
                {$IFDEF SOP}
                    LStock_LocSubst(LStock,LocFilt);
                {$ENDIF}


                LineTot[1]:=Qty_OS(LId)*QtyMul;

                LineTot[2]:=LStock.QtyInStock;

                Linetot[3]:=StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn);

                Linetot[4]:=LineTot[2]-LineTot[3];  {* Free Stock *}

                If (LineTot[4]>=LineTot[1]) then
                  LineTot[5]:=Linetot[1]
                else
                  If (LineTot[4]>0) then
                    LineTot[5]:=Linetot[4];

                Linetot[6]:=LStock.QtyonOrder;

                LineTot[7]:=LineTot[1]-Linetot[5];

                OldQty:=LId.Qty;

                LId.Qty:=Qty_Os(LId);


                Rnum:=DetLTotal(LId,BOn,BOff,0.0)*DocCnst[IdDocHed];

                LId.Qty:=OldQty;

                RnumC:=Round_Up((Qty_Os(LId)*Round_Up(CostPrice,Syss.NoCosDec)*LineCnst(Payment)),2)*
                                DocCnst[IdDocHed];

                If (RCr=0) then
                Begin
                  UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

                  Rnum:=Round_Up(Conv_TCurr(Rnum,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);

                  RnumC:=Round_Up(Conv_TCurr(RnumC,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);

                end;

                IsBOM:=(LStock.StockType=StkBillCode);


                IsShort:=((LineTot[7]>0) and (IsBOM) and (Not LStock.ShowasKit) and (ExpBOM) and (Syss.DeadBOM));


                If (IsBOM) then
                  BMFlg:='*';

                {$IFDEF WOP}
                  {$B-}
                  If (FullWOP) and (IsBOM) and (FindMatch_WOR(LId,LInv,IdFolioK,0)) then
                  {$B+}
                  Begin
                    BMFlg:='W'+BMFlg;

                  end;

                {$ENDIF}

                GenStr:=dbFormatName(LStock.StockCode,LStock.Desc[1]);

                If (IdDocHed In PSOPSet) then
                  DelDate:=LId.PDate
                else
                  DelDate:=LInv.DueDate;
              end;


              {* Note use of   vv DelDate *}

              If (LInv.OurRef<>LastDocNo) then
                DefFont(0,[fsBold])
              else
                DefFont(0,[]);

              SendText(ConCat(#9,LInv.OurRef));

              DefFont(0,[]);

              SendText(ConCat(#9,
                      #9,POutDate(DelDate),
                      #9,LId.CustCode,
                      #9,BMFlg,
                      #9,GenStr));


              LastDocNo:=LInv.OurRef;

              For n:=1 to 7 do
                SendText(Concat(ConstStr(#9,5+n),FormatFloat(GenQtyMask,LineTot[n])));

              SendLine(Concat(ConstStr(#9,13),FormatFloat(GenRealMask,RNumC),
                      #9,FormatFloat(GenRealMask,Rnum)));


              BSTotc:=BSTotc+RnumC;

              RepTotC:=RepTotC+RnumC;

              BSTot:=BSTot+Rnum;

              RepTot:=RepTot+Rnum;


              StkFuncs^.LPut_LastAlloc(TBo,LineTot[1],AllocSCode,LStock.StockFolio);


            end;


      6  :  Begin

              With LPassWord.BillMatRec do
              Begin

                LineTot[1]:=SKitQty*QtyUsed;

                LineTot[2]:=LStock.QtyInStock;

                Linetot[3]:=StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn);

                Linetot[4]:=LineTot[2]-LineTot[3];  {* Free Stock *}

                If (LineTot[4]>=LineTot[1]) then
                  LineTot[5]:=Linetot[1]
                else
                  If (LineTot[4]>0) then
                    LineTot[5]:=Linetot[4];

                Linetot[6]:=LStock.QtyonOrder;

                LineTot[7]:=LineTot[1]-Linetot[5];


              end;

              IsBOM:=(LStock.StockType=StkBillCode);


              IsShort:=((LineTot[7]>0) and (IsBOM));


              LevelStr:=Level_Str(Succ(KitLevel),DocYRef1Len,NoSpc);

              {* Note -----------v--------v-------v & v BOM specials ------ *}


              SendText(ConCat(#9,Spc(NoSpc),LevelStr,
                    #9,LStock.StockCode,#9,LStock.Desc[1]));

              For n:=1 to 7 do
                SendText(ConstStr(#9,3+n)+FormatFloat(GenQtyMask,LineTot[n]));

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;


              StkFuncs^.LPut_LastAlloc(TBo,LineTot[1],AllocSCode,LStock.StockFolio);
            end;

    end; {Case..}


    If (IsShort) then  {* Call routine again *}
    Begin

      LKitFolio:=KitFolio;

      LKitQty:=SKitQty;

      KitFolio:=LStock.StockFolio;

      Case ReportMode of
        1,2  :  SKitQty:=LineTot[3];

        3,4  :  SKitQty:=LineTot[5];

        5,6
             :  Begin
                  SKitQty:=LineTot[7];

                  If (ReportMode=5) then
                  Begin
                    ReportMode:=6;
                    RepSetTabs;
                  end;
                end;
      end;

      Inc(KitLevel);

      BackLogDetail;

      Dec(KitLevel);

      KitFolio:=LKitFolio;

      SKitQty:=LKitQty;

      If (ReportMode=6) and (Not InBOMReport) then
      Begin
        ReportMode:=5;
        RepSetTabs;
      end;

    end;



  end;
end;






{ ======================= Customer Include ======================= }


Function TSKitReport.IncludeRecord  :  Boolean;

Const
  Fnum     =  InvF;
  Keypath  =  InvFolioK;

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
        1,3
           :  With LId do
              Begin

                TmpInclude:=((LineNo>0) and (Not EmptyKey(StockCode,StkKeyLen)));

                If (TmpInclude) then
                Begin

                  TmpInclude:=LGetMainRec(StockF,StockCode);

                  If (ReportMode=3) then
                  Begin

                    TmpInclude:=((TmpInclude)
                    and ((LStock.QtyInStock-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn))
                     <(Qty_Os(LId)*LId.QtyMul)));

                    If (Not TmpInclude) then
                      StkFuncs^.LPut_LastAlloc(TBo,Qty_Os(LId)*LId.QtyMul,AllocSCode,LStock.StockFolio);

                  end;


                end;

              end;

        2,4
           :  Begin

                TmpInclude:=(((LStock.QtyInStock-StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocSCode,LStock.StockFolio),TBo,BOn))
                            <SKitQty) or (ReportMode<>4));

                If (ReportMode=4) and (Not TmpInclude) then
                  StkFuncs^.LPut_LastAlloc(TBo,SKitQty,AllocSCode,LStock.StockFolio);


              end;

        5  :  With LId  do
              Begin

                If (Assigned(ThisScrt)) then {* Get Id Link *}
                  ThisScrt^.Get_Scratch(LRepScr^);


                LResetRec(RFnum);

                KeyCS:=FullNomKey(FolioRef);

                If (FolioRef<>LInv.FolioNum) then
                  LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS);


                LGetMainRec(StockF,LId.StockCode);

                TmpInclude:=BOn;


              end;

      end; {Case..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TSKitReport.GetReportInput  :  Boolean;

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

    KitLevel:=-1;

    Case ReportMode of

       1,3
            :   Begin
                  ThTitle:='Kitting Report';


                  Case ReportMode of
                    1  :  RepTitle:='Kitting Report';

                    3  :  RepTitle:='Kitting Shortages Report';
                  end;

                  PageTitle:=RepTitle;

                  KeyCS:=ROrdNo;

                  Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyCS);


                  If (ROrdNo<>'') then
                    RepTitle2:='Order : '+ROrdNo+', Delivery date : '+POutDate(Inv.DueDate);


                  RFont.Size:=8;
                  ROrient:=RPDefine.PoLandscape;

                  RFnum:=IDetailF;

                  RKeyPath:=IdFolioK;

                  RepKey:=FullNomKey(Inv.FolioNum);
                end;


       2,4
            :   Begin
                  ThTitle:='Kitting Report';


                  Case ReportMode of
                    2  :  RepTitle:='Kitting Report';

                    4  :  RepTitle:='Kitting Shortages Report';
                  end;


                  PageTitle:=RepTitle;

                  If (Not EmptyKey(STCode,StkKeyLen)) then
                    GetStock(Application.MainForm,FullStockCode(STCode),FoundCode,-1);


                  RepTitle2:=Strip('B',[#32],Stock.StockCode)+','
                         +Stock.Desc[1]+': Qty Required : '+Form_Real(SKitQty,0,Syss.NoQtyDec);

                  If (Not EmptyKey(CustFilt,CustKeyLen)) then
                  With Cust do
                  Begin
                    GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOff,-1);

                    RepTitle2:=RepTitle2+'. Supplier Filter : '+dbFormatName(CustCode,Company);
                  end;

                  KitFolio:=Stock.StockFolio;

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoLandscape;

                  RFnum:=StockF;

                  RKeyPath:=StkCodeK;
                  RepKey:=STCode;
                end;


       5
            :   Begin

                  ThTitle:='Back Order Report';


                  RepTitle:='Sales '+ThTitle;

                  PageTitle:=RepTitle;

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

                  {$IFDEF MC_On}

                    PageTitle:=CurrDesc(RCr)+RepTitle;

                  {$ELSE}

                    PageTitle:=RepTitle;

                  {$ENDIF}


                  {$IFDEF SOP}
                     If (Not EmptyKey(LocFilt,LocKeyLen)) then
                     Begin
                       SLocTit:=MLocRepTitle(LocFilt);
                     end;
                  {$ENDIF}

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoLandscape;

                  RFnum:=ReportF;

                  RKeyPath:=RpK;

                end;


    end; {Case..}




  end; {With..}

  Result:=BOn;
end;


{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TSKitReport.Build_BackOrder(Mode     :  Byte;
                                      DocFilt  :  Char;
                                      CustFilt,
                                      LocFilt  :  Str10;
                                      StkFilt  :  Str20;
                                      RCr      :  Byte;
                                      Update   :  LongDate;
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

  TmpInclude
           :  Boolean;



Begin

  With MTExLocal^ do
  Begin

    KeyChk:=DocFilt;
    KeyCS:=KeyChk;

    RecAddr:=0;

    FoundOk:=BOff;
    TmpInclude:=BOff;

    ShowStatus(2,'Please Wait, Building Report');

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LId do
    Begin

      Case Mode of
        1  :  BODate:=PDate;

        2  :  Begin   {* Delivery date is header...}

                If (LInv.FolioNum<>FolioRef) then
                Begin
                  KeyInv:=FullNomKey(FolioRef);

                  LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyInv);

                end;

                BODate:=LInv.DueDate;

              end;


      end; {Case..}


      TmpInclude:=((LineNo>0) and (Qty_OS(LId)<>0)
                     and (Not EmptyKey(StockCode,StkKeyLen))
                     and ((Currency=RCr) or (RCr=0))
                     and (BODate<=UpDate)
                     and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
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

        ThisScrt^.Add_Scratch(Fnum,IdFolioK,RecAddr,BODate+MatchStr+Form_Int(LineNo,6),MatchStr);

        FoundOk:=BOn;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

    If (FoundOk) and ((Mode=1) or (Not SetAlFlg)) then
    Begin
      StkFuncs^.LReset_Alloc(AllocSCode);

      SetAlFlg:=BOn;

    end;

  end; {With..}
end; {Proc..}


Procedure TSKitReport.RepeatBackOrd(Var FoundOk  :  Boolean);

Const
  ModeDoc    :  Array[1..2] of DocTypes = (SOR,SQU);


Begin
  If (ReportMode=5) then
  With CRepParam^ do
  Begin
    If (Assigned(ThisScrt)) then
      Dispose(ThisScrt,Done);

    New(ThisScrt,Init(2+CurrMode,MTExLocal,BOff));

    RepTitle2:='('+DocNames[ModeDoc[CurrMode]]+')';

    If (Not EmptyKey(CustFilt,CustKeyLen)) then
      RepTitle2:=RepTitle2+' For '+Strip('B',[#32],SCust.Company)+'.';

    If (Not EmptyKey(STCode,StkKeyLen)) then
      RepTitle2:=RepTitle2+' Stock Filter: '+Strip('B',[#32],SStock.Desc[1])+'.';

    If (SLocTit<>'') then
      RepTitle2:=RepTitle2+' '+SLocTit+'.';


    BSTot:=0; BSTotc:=0;

    RepTot:=0; RepTotc:=0;

    ICount:=0;

    RepKey:=FullNomKey(ThisScrt^.Process);

    Build_BackOrder(CurrMode,
                    StkLineType[ModeDoc[CurrMode]],
                    CustFilt,
                    LocFilt,
                    STCode,
                    RCr,
                    EDate,
                    FoundOk);

  end;

  Inc(CurrMode);

end;


Procedure TSKitReport.Process;

Var
  FoundOk  :  Boolean;

Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}

  InitStatusMemo(4);

  ShowStatus(0,RepTitle);

  New(StkFuncs,Create(MTExLocal));

  If (ReportMode In [1..4]) then
  Begin
    ShowStatus(2,'Please Wait, Calculating Totals');

    StkFuncs^.LReset_Alloc(AllocSCode);

  end
  else
    RepeatBackOrd(FoundOk);


  Inherited Process;

end;


Procedure TSKitReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddSKitRep2Thread(LMode    :  Byte;
                            IRepParam:  KitRepPtr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TSKitReport;

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





Initialization



Finalization

end.