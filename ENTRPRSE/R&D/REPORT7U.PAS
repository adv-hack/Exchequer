unit Report7U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,Report6U;


type

  TCCStkReport  =  Object(TStkReport)

                       Procedure RepPrint(Sender  :  TObject); Virtual;


                     private
                       {$IFDEF REPPFC}
                         lUseSQLPrefillCache : Boolean;
                         lSQLPrefillCacheID : LongInt;
                         lSQLWhereClause : ANSIString;
                         lSQLColumns : ANSIString;
                         lSQLPFCRes : LongInt;
                       {$ENDIF}


                       Function FilterMode  :  Byte;

                       Function CalcCol(Col,IPr,IYr  :  Byte)  :  Byte;

                       Function Check_HasValue(NTotals  :  StkRepAry)  :  Boolean;

                       Procedure GetCCPR_YTD_Hist(PrMode,
                                                  Base     :  Byte);

                       Procedure Forward_Check(LevelKey  :  Str255;
                                           Var FoundOk   :  Boolean);

                       Procedure StkDetail(Bot        :  Boolean); Virtual;

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Control_YTDHist; Virtual;

                       Function IsOktoNom(NCode      :  Str20)  :  Boolean; Virtual;


                       Procedure FollowCCChain(LevelKey  :  Str20;
                                          Var  LevelTotal:  StkRepAry);

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddCCStkRep2Thread(LMode    :  Byte;
                             IRepParam:  StkRepRecPtr;
                             AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  ETDateU,
  ETStrU,
  VarRec2U,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  SalTxl1U,
  InvListU,
  Rep5SupU,
  RpDefine,
  {$IFDEF REPPFC}
    SQLUtils,
    SQLFuncs,
  {$ENDIF}
  ExThrd2U;


{ ========== TCCStkReport methods =========== }

Constructor TCCStkReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

end;


Destructor TCCStkReport.Destroy;

Begin

  Inherited Destroy;
end;




Procedure TCCStkReport.Process;

Begin
  Inherited Process;
end;




{ =============== Procedure to Return a Filter Mode ============== }

Function TCCStkReport.FilterMode  :  Byte;


Const
  CustFilter  =  4;

Var
  TMode  :  Byte;
  TBo    :  Boolean;


Begin
  With CRepParam^ do
  Begin
    TMode:=1+(CustFilter*Ord(CustMode));

    For TBo:=BOff to BOn do
      If (Not EmptyKeyS(NCCDep[TBo],ccKeyLen,BOff)) then
        TMode:=TMode+1+Ord(Not TBo);

  end; {With..}

  FilterMode:=TMode;
end; {Func..}



{ ================ Function to Return Col Value belongs in ============== }

Function TCCStkReport.CalcCol(Col,IPr,IYr  :  Byte)  :  Byte;

Var
  TCalcCol  :  Byte;
  N,Ns,Ne   :  Byte;


Begin
  TCalcCol:=0;

  With CRepParam^ do
  Begin
    If (Col=0) then
    Begin
      Ns:=PrS;
      Ne:=PrE;
    end
    else
    Begin
      Ns:=PrS+Pred(Col);
      Ne:=Ns;
    end;

    For N:=Ns to Ne do
    With CRepParam^ do
      If (Pr2Fig(IYr,IPr)=Pr2Fig(RYr,N)) then
        TCalcCol:=N-Pred(Ns);

  end; {With..}

  CalcCol:=TCalcCol;

end; {Func..}


{ ============== Check If Total Conatains anything ============= }

Function TCCStkReport.Check_HasValue(NTotals  :  StkRepAry)  :  Boolean;

Var
  TBo  :  Boolean;
  n    :  Byte;


Begin

  TBo:=BOff;

  For n:=1 to MaxNoStkTots do
    If (Not Tbo) then
      Tbo:=(NTotals[n]<>0);

  Check_HasValue:=TBo;

end; {Func..}


 { =============== Procedure to Return a given periods Totals, + the YTD =============== }

Procedure TCCStkReport.GetCCPR_YTD_Hist(PrMode,
                                        Base     :  Byte);



Const
  NFnum =  IDetailF;
  NPath1=  IdStkK;
  NFNum2=  InvF;
  NPath2=  InvFolioK;



Var
  NHKey,NHChk,NIKey,
  KeyI         :  Str255;

  Balance,
  Rnum2,
  RCost        :  Real;

  CrDr         :  DrCrType;

  TInclude,
  TBo,
  HuntOk       :  Boolean;

  NPath        :  Integer;

  FindxFilt    :  GetStkMode;

  N,Ns,FiltMode,
  UOR

               :  Byte;

  ColRnum      :  StkRepAry;

  CostRates    :  CurrTypes;

Begin
  TBo:=BOff;

  Balance:=0; Rnum2:=0; RCost:=0;

  HuntOk:=BOn; UOR:=0;

  Blank(ColRnum,Sizeof(ColRnum));

  Blank(CostRates,Sizeof(CostRates));


  FiltMode:=FilterMode;

  New(FindxFilt,Init);

  FindxFilt.MTExLocal:=MTExLocal;

  With MTExLocal^,CRepParam^ do
  With LStock do
  Begin

    NPath:=NPath1;

    NHChk:=StockCode;

    NHKey:=NHChk;

    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs And (lSQLPFCRes = 0) Then
      UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
    LStatus:=LFind_Rec(B_GetGEq,NFnum,NPath,NHKey);

    While (LStatusOk) and (CheckKey(NHChk,NHKey,Length(NHChk),BOn)) and (HuntOk) and (ChkRepAbort) do
    Begin

      With LId do
      Begin
        If (LInv.FolioNum<>FolioRef) then
        Begin
          NIKey:=FullNomKey(FolioRef);

          LStatus:=LFind_Rec(B_GetEq,NFnum2,NPath2,NIKey);

          If (Not LStatusOk) then
            LInv.RunNo:=0;
        end;

        TInclude:=(CalcCol(0,PPr,PYr)<>0) and
                  (LInv.RunNo>0) and
                  ((Currency=FCr) or ((FCr=0) and (IdDocHed<>Run))) and
                  (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff) and
                  CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff) and
                  (IdDocHed In SalesSplit));


        If (TInclude) then  {* Check CC/Dep Filter *}
          For TBo:=BOff to BOn do
            TInclude:=((TInclude) and CheckKey(NCCDep[TBo],CCDep[TBo],Length(NCCDep[Tbo]),BOff));

        If (TInclude) then
        Begin
          TBo:=Not Syss.SepDiscounts;

          Balance:=DetLTotal(LId,BOn,BOff,0.0)*DocNotCnst;

          Rnum2:=(Qty*QtyMul)*StkAdjCnst[IdDocHed]*DocNotCnst;

          RCost:=Rnum2*CostPrice;

          CostRates:=CXRate;

          If (FCr=0) then
          Begin
            UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

            Balance:=Round_Up(Conv_TCurr(Balance,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

            If (COSConvRate<>0.0) then {* We have original rate *}
              CostRates[UseCoDayRate]:=COSConvRate;

            RCost:=Round_Up(Conv_TCurr(RCost,XRate(CostRates,BOff,Currency),Currency,UOR,BOff),2);
          end;


          N:=CalcCol(0,PPr,PYr);

          ColRnum[N]:=ColRnum[N]+Rnum2;

          ColRnum[QtyTofSet]:=ColRnum[QtyTofSet]+CaseQty(LStock,Rnum2);

          ColRnum[TOofSet]:=ColRnum[TOofSet]+Balance;

          ColRnum[COofSet]:=ColRnum[COofSet]+RCost;


          HuntOk:=((Not Check_HasValue(ColRnum)) or (PrMode<>2));


        end; {Tinclude..}


        If (HuntOk) then {* Don't search again if aborting here *}
        Begin
          {$IFDEF REPPFC}
          If SQLUtils.UsingSQLAlternateFuncs And (lSQLPFCRes = 0) Then
          Begin
            UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
            LStatus:=LFind_Rec(B_GetNext,NFnum,NPath,NHKey);
          End // If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0)
          Else
          {$ENDIF}
            LStatus:=FindxFilt^.GetSearchRec(NFnum,NPath,NHKey,LStock.StockCode,CustFilt,NCCDep,FiltMode);
        End; // If (HuntOk)
      End; // With LId
    End; // While (LStatusOk) and (CheckKey(NHChk,NHKey,Length(NHChk),BOn)) and (HuntOk) and (ChkRepAbort)

    Ns:=1;

    HasValue:=BOff; {* Reset Print Line.. *}

    NTotals:=ColRnum;

    HasValue:=Check_HasValue(NTotals);

  end; {With..}

  Dispose(FindxFilt,Done);

end; {Func..}






{ =================== Procedure to Control Corrolation of Yr to Date ============== }

Procedure TCCStkReport.Control_YTDHist;

Var
  Fini  :  Boolean;
  Base  :  Byte;


Begin
  Base:=1; Fini:=BOn;


  With MTExLocal^,LStock do
  With CRepParam^ do
  Begin

    If (StockType<>StkGrpCode) then
    Begin

      Blank(NTotals,Sizeof(NTotals));

      Blank(BTotals,Sizeof(BTotals));

      GetCCPr_YTD_Hist(1,Base);

      GrandStkTotals(BSTotals,NTotals,1,COOfset,BOff);

    end;

  end; {With..}
end; {Proc..}


{ ========= Procedure to Hunt in advance and check for values ======== }


Procedure TCCStkReport.Forward_Check(LevelKey  :  Str255;
                                 Var FoundOk   :  Boolean);


Var

  TmpKPath,
  TmpKPath2,
  TmpStat
        :  Integer;

  TmpRecAddr2,
  TmpRecAddr
        :  LongInt;

  LStk  :  StockRec;

  LNRR  :  StkRepRec;

  LKey  :  Str255;


Begin

  LNRR:=CRepParam^;

  With MTExLocal^ do
  Begin
    LStk:=LStock;

    With CRepParam^ do
    Begin

      LKey:=LevelKey;


      TmpKPath2:=KeyPth;

      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOff,BOff)
      else
      {$ENDIF}
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOff,BOff);

      Inc(Level);

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPth,LKey);



      While (LStatusOk) and (ChkRepAbort) and (CheckKey(LevelKey,LKey,Length(LevelKey),BOn))
           and (Level<=RepLimit) and (Not FoundOk) do

      With LStock do
      Begin

        TmpKPath:=KeyPth;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        If (StockType=StkGrpCode) then
          Forward_Check(StockCode,FoundOk);

        If (Not FoundOk) then
        Begin

          Blank(NTotals,Sizeof(NTotals));

          GetCCPr_YTD_Hist(2,1);

          FoundOk:=(Check_HasValue(NTotals));

        end;

        If (Not FoundOk) then
        Begin

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPth,LKey);
        end;

      end; {While..}
    end; {With..}

    LStock:=LStk;

    CRepParam^:=LNRR;
   {$IFDEF EXSQL}
   if SQLUtils.UsingSQL then
    With CrepParam^ do
      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOn,BOff)
   else
   {$ENDIF}
    With CrepParam^ do
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);


  end; {with..}

end; {Proc..}






{ =================== Function to Check if Ok to Print ================ }

Function TCCStkReport.IsOktoNom(NCode      :  Str20)  :  Boolean;



Var
  TBo,
  TmpInclude
       :  Boolean;

  n    :  Byte;

  LNRR :  StkRepRec;


Begin

  TmpInclude:=BOff;

  LNRR:=CRepParam^;

  With MTExLocal^,CRepParam^ do
  Begin

    Case ReportMode of
      1..4  :  Begin


                 Case LStock.StockType of

                   StkGrpCode  :  Forward_Check(NCode,TmpInclude);

                   else           TmpInclude:=BOn;

                 end; {Case..}


               end;


    end; {Case..}

  end; {With..}

  CRepParam^:=LNRR;

  IsOktoNom:=TmpInclude;

end;



 { ================== Procedure to control the printing of one line nominal ============= }

 Procedure TCCStkReport.StkDetail(Bot        :  Boolean);


 Begin
   With MTExLocal^ do
   If (Not Bot) or ((Bot) and (LStock.StockType=StkGrpCode)) then
   With RepFiler1,CRepParam^,LStock do
   Begin

     Case ReportMode of
       1..4
          :  Begin

               Control_YTDHist;


             end;


     end; {case..}


     If (LinesLeft<=5) then
       ThrowNewPage(5);


     If (Ok2Print) and (HasValue) then
       PrintStkDet(Bot);

     HasValue:=BOn;


   end; {with..}
 end;




{ ============== Recursive routine to follow nominal structure & Print it ================= }


Procedure TCCStkReport.FollowCCChain(LevelKey  :  Str20;
                                Var  LevelTotal:  StkRepAry);


Var
  TmpKPath,
  TmpStat
       :  Integer;

  TmpRecAddr
       :  LongInt;

  LStk :  StockRec;
  LKey :  Str255;
  HedTotal
       :  StkRepAry;


Begin

  Blank(HedTotal,Sizeof(HedTotal));

  With MTExLocal^,CRepParam^ do
  Begin
    Inc(Level);

    LKey:=LevelKey;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPth,LKey);



    While (LStatusOk) and (ChkRepAbort) and (CheckKey(LevelKey,LKey,Length(LevelKey),BOn)) and (Level<=RepLimit) do
    With LStock do
    Begin
      Inc(RCount);

      If (Assigned(ThreadRec)) then
        UpDateProgress(RCount);

      TmpKPath:=KeyPth;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      Case ReportMode of

        1..4  :  Check4Range(StockCode);

      end; {Case..}


      {$B-}


      If (IsOktoNom(StockCode)) then
      Begin

      {$B+}

        Inc(ICount);


        LStk:=LStock;


        StkDetail(BOff);  { =========== Print Detail =========== }


        HedTotal:=NTotals;

        If (StockType=StkGrpCode) then
        Begin

          Blank(HedTotal,Sizeof(HedTotal));


          Parnt:=LStk.StockCode;  {* Set Last Parent *}

          FollowCCChain(StockCode,HedTotal);

          Parnt:=LStk.StockCat;  {* Set Last Parent *}

          NTotals:=HedTotal;
        end;

        GrandStkTotals(LevelTotal,HedTotal,1,COOfset,BOff);


        LStock:=LStk;

        If (Check_HasValue(NTotals)) then
          Case ReportMode of

            1..4  :  StkDetail(BOn);   { ============ Print Bottom =========== }

          end; {Case..}

      end; {Profit..}

      If (Level=0) then
        Blank(LevelTotal,Sizeof(LevelTotal));


      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPth,LKey);

    end; {While..}

    Dec(Level);

  end; {with..}
end; {Proc..}



Procedure TCCStkReport.RepPrint(Sender  :  TObject);

Var
  LevelKey  :  Str10;
  LevelTotal:  StkRepAry;

  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'Details.Dat') : ShortString;
  Begin // ColName
    Result := GetDBColumnName(FileName, ColumnName, '')
  End; // ColName
  {$ENDIF}

Begin
  ShowStatus(2,'Processing Report.');

  Blank(LevelTotal,Sizeof(LevelTotal));

  With CRepParam^ do
  Begin
    LevelKey:=LevKey;

    Case ReportMode of
      1..10
           :  Begin
                {$IFDEF REPPFC}
                If SQLUtils.UsingSQLAlternateFuncs Then
                Begin
                  lSQLWhereClause :=                     'Cast (SubString(' + ColName('f_stock_code') + ', 2, 16) As VarChar(16)) In (Select Distinct ' + ColName('f_stock_code', 'Stock.Dat') + ' ' +
                                                                                                                                     'From ' + GetCompanyCode(SetDrive) + '.Stock)' +
                                                         'And ' +

                                                         // (CalcCol(0,PPr,PYr)<>0)
                                                         '((' + ColName('f_p_yr') + ' = ' + IntToStr(RYr) + ') And ' +
                                                          '(' + ColName('f_p_pr') + ' >= ' + IntToStr(PrS) + ') And ' +
                                                          '(' + ColName('f_p_pr') + ' <= ' + IntToStr(PrE) + ')) ' +

                                                         // (IdDocHed In SalesSplit)
                                                         'And ' +
                                                         '(' + ColName('f_id_doc_hed') + ' In (' + IntToStr(Ord(SIN)) + ', ' +
                                                                                                   IntToStr(Ord(SRC)) + ', '+
                                                                                                   IntToStr(Ord(SCR)) + ', '+
                                                                                                   IntToStr(Ord(SJI)) + ', '+
                                                                                                   IntToStr(Ord(SJC)) + ', '+
                                                                                                   IntToStr(Ord(SRF)) + ', '+
                                                                                                   IntToStr(Ord(SRI)) + ', '+
                                                                                                   IntToStr(Ord(SQU)) + ', '+
                                                                                                   IntToStr(Ord(SOR)) + ', '+
                                                                                                   IntToStr(Ord(SDN)) + ', '+
                                                                                                   IntToStr(Ord(SBT)) +
                                                                                             ')' +
                                                         ') ' +

                                                         // (LInv.RunNo>0)
                                                         'And ' +
                                                         '(' + ColName('f_folio_ref') + ' In (Select Distinct ' + ColName('f_folio_num', 'Document.Dat') + ' ' +
                                                                                             'From ' + GetCompanyCode(SetDrive) + '.Document ' +
                                                                                             'Where (' +
                                                                                                     '(' + ColName('f_run_no', 'Document.Dat') + ' > 0)';

                                                         // CheckKey(CustFilt,CustCode,Length(CustFilt),BOff)
                  If (Trim(CustFilt) <> '') Then
                  Begin
                    lSQLWhereClause := lSQLWhereClause +                                             'And ' +
                                                                                                     '(' + ColName('f_cust_code', 'Document.Dat') + ' = ' + QuotedStr(CustFilt) + ')';
                  End; // If (Trim(CustFilt) <> '')

                  lSQLWhereClause := lSQLWhereClause +                                             ')' +
                                                                                            ')' +
                                                         ') ' +

                                                         // (
                                                         //   (Currency=FCr)
                                                         //   or
                                                         //   (
                                                         //     (FCr=0)
                                                         //     and
                                                         //     (IdDocHed<>Run)
                                                         //   )
                                                         // )
                                                         'And ' +
                                                         '(' +
                                                           '(' + ColName('f_currency') + ' = ' + IntToStr(FCr) + ')';
                  If (FCr = 0) Then
                  Begin
                    lSQLWhereClause := lSQLWhereClause +  ' Or ' +
                                                           '(' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) + ')';
                  End; // If (FCr = 0)
                  lSQLWhereClause := lSQLWhereClause +   ')';

                                                         // CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)
                  If (Trim(LocFilt) <> '') Then
                  Begin
                    lSQLWhereClause := lSQLWhereClause +' And ' +
                                                         '(' + ColName('f_m_loc_stk') + ' = ' + QuotedStr(LocFilt) + ')';
                  End; // If (Trim(LocFilt) <> '')

                  lSQLColumns := '';
                  lSQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[IDetailF], lSQLWhereClause, lSQLColumns, lSQLPrefillCacheID, MTExLocal^.ExClientId);
                End // If SQLUtils.UsingSQLAlternateFuncs
                Else
                  lSQLPFCRes := -1;
                {$ENDIF}

                FollowCCChain(LevelKey,LevelTotal);


                If (Check_HasValue(BsTotals)) then
                Begin

                  { === Print Grand Stock Totals ==== }

                  PrintStkTotals(BSTotals,FCr,FTxCr,4);


                end;

                {$IFDEF REPPFC}
                  If SQLUtils.UsingSQLAlternateFuncs And (lSQLPFCRes = 0) Then
                    DropCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
                {$ENDIF}
              end;
    end; {Case..}

  end; {With..}

  PrintEndPage;
end;


Function TCCStkReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin

    NoAnals    :=  12;
    QtyTOfSet  :=  NoAnals+1;
    TOOfset    :=  NoAnals+2;
    COOfset    :=  NoAnals+3;

    RFnum:=StockF;
    RKeypath:=0;

    Level:=-1;

    Mode:=ReportMode;


    Fnum:=RFnum; KeyPth:=StkCatK;

    Ok2Print:=BOn;

    
    If (RepLimit=0) then
      RepLimit:=YTD;

    Case ReportMode of
      1      :  Begin
                  ThTitle:='CC/Dep Sales Rep';

                  RepTitle:='Cost Centre/Department Sales Analysis';

                end;

    end; {Case..}


    PageTitle:=RepTitle;


      {$IFDEF MC_On}

        If (FTxCr<>0) and (FTxCr<>FCr) then
          PageTitle:=CurrDesc(FCr)+'to '+CurrDesc(FTxCr)+PageTitle
        else
          Pagetitle:=CurrDesc(FCr)+PageTitle;

      {$ENDIF}


      Case ReportMode of
        1
           :  Begin

                Ok2Print:=(EmptyKey(PaLS,StkKeyLen));

                If (Not EmptyKey(CustFilt,CustKeyLen)) then
                 Begin
                   GetCust(Application.MainForm,CustFilt,FoundCode,BOn,-1);

                   RepTitle2:='For '+Strip('B',[#32],Cust.Company)+'. ';
                 end;

                 {$IFDEF SOP}
                   If (Not EmptyKey(LocFilt,LocKeyLen)) then
                   Begin
                     If (RepTitle2<>'') then
                       RepTitle2:=RepTitle2+', ';

                     RepTitle2:=RepTitle2+MLocRepTitle(LocFilt)+'. ';
                   end;
                 {$ENDIF}

                 RepTitle2:=RepTitle2+'For Period '+PPR_OutPr(PrS,RYr)+'-'+PPR_OutPr(PrE,RYr);


                For BoLoop:=BOff to BOn do

                  If (Not EmptyKeyS(NCCDep[BoLoop],ccKeyLen,BOff)) then
                  Begin
                    GetCCDep(Application.MainForm,NCCDep[BoLoop],FoundCode,BoLoop,-1);

                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+NCCDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

                  end; {Loop..}

                LevKey:=FullStockCode('');


              end;


      end; {case..}




    ROrient:=RPDefine.PoLandscape;


  end; {With..}

  Result:=BOn;
end;





Procedure TCCStkReport.Finish;


Begin
  Inherited Finish;
end;


{ ======== }



Procedure AddCCStkRep2Thread(LMode    :  Byte;
                             IRepParam:  StkRepRecPtr;
                             AOwner   :  TObject);


Var
  EntTest  :  ^TCCStkReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
        Begin
          CRepParam^:=IRepParam^;

        end;

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


end.
