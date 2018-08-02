unit Report5U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,Report4U;




Type

  TCCDepReport  =  Object(TNomReport)


                       Procedure RepPrint(Sender  :  TObject); Virtual;


                     private

                       Function FilterMode  :  Byte;

                       Function CalcCol(Col,IPr,IYr  :  Byte)  :  Byte;

                       Function Check_HasValue(NTotals  :  Totals)  :  Boolean;

                       Procedure GetCCPR_YTD_Hist(PrMode,
                                                  Base     :  Byte);

                       Procedure Forward_Check(LevelKey  :  Str255;
                                           Var FoundOk   :  Boolean);

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Control_YTDHist; Virtual;

                       Function IsOktoNom(NCode      :  LongInt)  :  Boolean; Virtual;

                       Procedure NomDetail(Bot        :  Boolean); Virtual;


                       Procedure Check4PL(NCode      :  LongInt); Virtual;

                       Procedure FollowCCChain(LevelKey  :  Str10;
                                          Var  LevelTotal:  Totals);

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}



Procedure AddCCDepRep2Thread(IRepParam:  NomRepRecPtr;
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
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  {DocSupU1,}
  InvListU,
  SalTxl1U,
  Rep5SupU,
  RpDefine,

  {$IFDEF REPPFC}
    SQLUtils,
    SQLFuncs,
  {$ENDIF}

  RepCCShU,
  ExThrd2U;


{ ========== TCCDepReport methods =========== }

Constructor TCCDepReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);


end;


Destructor TCCDepReport.Destroy;

Begin
  Inherited Destroy;
end;




Procedure TCCDepReport.Process;

Begin
  Inherited Process;
end;




{ =============== Procedure to Return a Filter Mode ============== }

Function TCCDepReport.FilterMode  :  Byte;


Const
  QuoteFilter  =  4;

Var
  TMode  :  Byte;
  TBo    :  Boolean;


Begin
  With CRepParam^ do
  Begin
    TMode:=1+(QuoteFilter*Ord(QuoteMode));

    For TBo:=BOff to BOn do
      If (Not EmptyKeyS(NCCDep[TBo],CCKeyLen,BOff)) then
        TMode:=TMode+1+Ord(Not TBo);

  end; {With..}

  FilterMode:=TMode;
end; {Func..}



{ ================ Function to Return Col Value belongs in ============== }

Function TCCDepReport.CalcCol(Col,IPr,IYr  :  Byte)  :  Byte;

Var
  TCalcCol  :  Byte;
  N,Ns,Ne   :  Byte;


Begin
  TCalcCol:=0;

  If (Col=0) then
  Begin
    Ns:=1;
    Ne:=NRanges;
  end
  else
  Begin
    Ns:=Col;
    Ne:=Ns;
  end;

  For N:=Ns to Ne do
  With CRepParam^ do
    If (Pr2Fig(IYr,IPr)>=Pr2Fig(F2YrPr[N,1],F2YrPr[N,2])) and (Pr2Fig(IYr,IPr)<=Pr2Fig(F2YrPr[N,3],F2YrPr[N,4])) then
      TCalcCol:=N;

  CalcCol:=TCalcCol;

end; {Func..}


{ ============== Check If Total Conatains anything ============= }

Function TCCDepReport.Check_HasValue(NTotals  :  Totals)  :  Boolean;

Var
  TBo  :  Boolean;
  n    :  Byte;


Begin
  TBo:=BOff;

  For n:=1 to 6 do
    If (Not Tbo) then
      Tbo:=(NTotals[n]<>0);

  Check_HasValue:=TBo;

end; {Func..}


 { =============== Procedure to Return a given periods Totals, + the YTD =============== }

Procedure TCCDepReport.GetCCPR_YTD_Hist(PrMode,
                                        Base     :  Byte);



Const
  NFnum =  IDetailF;
  NPath1=  IdNomK;
  NPath2=  IdRunK;
  IFnum =  InvF;
  IPath1=  InvFolioK;



Var
  NHKey,NHChk,
  KeyI         :  Str255;

  Balance,
  NBudget      :  Real;

  CrDr         :  DrCrType;

  TInclude,
  TBo,
  HuntOk       :  Boolean;

  NPath        :  Integer;

  FindxFilt    :  GetIdMode;

  N,Ns,FiltMode,
  UOR
               :  Byte;

  ColRnum      :  Array[1..2] of Real;

  {$IFDEF REPPFC}
    lUseSQLPrefillCache : Boolean;
    lSQLPrefillCacheID : LongInt;
    lSQLWhereClause : ANSIString;
    lSQLColumns : ANSIString;
    lSQLPFCRes : LongInt;
  {$ENDIF}

  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'Details.Dat') : ShortString;
  Begin // ColName
    Result := GetDBColumnName(FileName, ColumnName, '')
  End; // ColName
  {$ENDIF}

Begin
  TBo:=BOff; UOR:=0;

  Balance:=0; NBudget:=0;

  Blank(ColRnum,Sizeof(ColRnum));

  FiltMode:=FilterMode;

  HuntOk:=BOn;

  New(FindxFilt,Init);

  FindxFilt.MTExLocal:=MTExLocal;

  With MTExLocal^,CRepParam^ do
  With LNom do
  Begin

    If (QuoteMode) then
    Begin
      NPath:=NPath2;

      NHChK:=Strip('R',[#0],FullRunNoKey(0,NomCode));
    end
    else
    Begin
      NPath:=NPath1;

      NHChk:=FullNomKey(NomCode);
    end;

    NHKey:=NHChk;

    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      // Index / Keystring
      If QuoteMode Then
        lSQLWhereClause :=                   '(' + ColName('f_posted_run') + ' = 0) ' +
                                             'And '
      Else
        lSQLWhereClause :=                   '';

      lSQLWhereClause := lSQLWhereClause +   '(' + ColName('f_nom_code') + ' = ' + IntToStr(LNom.NomCode) + ') ' +
                                             'And ' +
                                             '(' +

      // (CalcCol(0,PPr,PYr)<>0) - checks line is within one of the two date ranges
                                             '(' +
                                               '(' +
                                                 // >= Primary From
                                                 '(((' + ColName('f_p_yr') + ' = ' + IntToStr(F2YrPr[1,1]) + ') And (' + ColName('f_p_pr') + ' >= ' + IntToStr(F2YrPr[1,2]) + ')) Or (' + ColName('f_p_yr') + ' > ' + IntToStr(F2YrPr[1,1]) + ')) ' +
                                                 'And ' +
                                                 // <= Primary To
                                                 '(((' + ColName('f_p_yr') + ' = ' + IntToStr(F2YrPr[1,3]) + ') And (' + ColName('f_p_pr') + ' <= ' + IntToStr(F2YrPr[1,4]) + ')) Or (' + ColName('f_p_yr') + ' < ' + IntToStr(F2YrPr[1,3]) + '))' +
                                               ') ' +
                                               'Or ' +
                                               '(' +
                                                 // >= Comparative From
                                                 '(((' + ColName('f_p_yr') + ' = ' + IntToStr(F2YrPr[2,1]) + ') And (' + ColName('f_p_pr') + ' >= ' + IntToStr(F2YrPr[2,2]) + ')) Or (' + ColName('f_p_yr') + ' > ' + IntToStr(F2YrPr[2,1]) + ')) ' +
                                                 'And ' +
                                                 // <= Comparative To
                                                 '(((' + ColName('f_p_yr') + ' = ' + IntToStr(F2YrPr[2,3]) + ') And (' + ColName('f_p_pr') + ' <= ' + IntToStr(F2YrPr[2,4]) + ')) Or (' + ColName('f_p_yr') + ' < ' + IntToStr(F2YrPr[2,3]) + '))' +
                                               ')' +
                                             ') ' +
                                             'And ' +


      // (
      //   (PostedRun>0) or ((QuoteMode) and (FolioRef<0))
      // {$IFDEF SOP}
      //   or
      //   (
      //     (PostedRun=CommitOrdRunNo)
      //     and
      //     (CommitAct)
      //     and (COmmitMode In [1,2])
      //   )
      // {$ENDIF}
      // )
                                             '(' +
                                               '(' + ColName('f_posted_run') + ' > 0)';
      If QuoteMode Then
      Begin
        lSQLWhereClause := lSQLWhereClause +  ' Or ' +
                                               '(' + ColName('f_folio_ref') + ' < 0)';
      End; // If QuoteMode

      {$IFDEF SOP}
      If CommitAct And (CommitMode In [1, 2]) Then
      Begin
        lSQLWhereClause := lSQLWhereClause +  ' Or ' +
                                               '(' + ColName('f_posted_run') + ' = ' + IntToStr(CommitOrdRunNo) + ')';
      End; // If CommitAct And (CommitMode In [1, 2])
      {$ENDIF}

      lSQLWhereClause := lSQLWhereClause +   ') ' +

      // ((Currency=FCr) or ((FCr=0) and ((IdDocHed<>Run) or (PostedRun=CommitOrdRunNo)))) and
                                             'And ' +
                                             '(' +
                                               '(' + ColName('f_currency') + ' = ' + IntToStr(FCr) + ')';
      If (FCr = 0) Then
      Begin
        lSQLWhereClause := lSQLWhereClause +  ' Or ' +
                                               '(' +
                                                 '(' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) + ') ' +
                                                 'Or ' +
                                                 '(' + ColName('f_posted_run') + ' = ' + IntToStr(CommitOrdRunNo) + ')' +
                                               ')';
      End; // If (FCr = 0)

      lSQLWhereClause := lSQLWhereClause +   ')';

      {$IFDEF SOP}
//      (
//        (Not CommitAct)
//        or
//        (
//          (IdDocHed<>RUN) and (CommitMode In [0,1])
//        )
//        or
//        (
//          (PostedRun<>CommitOrdRunNo) and (CommitMode In [0,1])
//        )
//        or
//        (
//          (PostedRun=CommitOrdRunNo) and (CommitMode In [1,2])
//        )
//      )
      // MH 31/07/08: Remove 1 as it should bypass these checks as (PostedRun<>CommitOrdRunNo) Or (PostedRun=CommitOrdRunNo) will always pass!
      If CommitAct And (CommitMode In [0, {1,} 2]) Then
      Begin
        lSQLWhereClause := lSQLWhereClause +    ' Or ' +
                                                 '(';

        Case CommitMode Of
          0 : lSQLWhereClause := lSQLWhereClause + '(' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) + ') ' +
                                                   'Or ' +
                                                   '(' + ColName('f_posted_run') + ' <> ' + IntToStr(CommitOrdRunNo) + ')';


          //1 : lSQLWhereClause := lSQLWhereClause + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN));


          2 : lSQLWhereClause := lSQLWhereClause + ColName('f_posted_run') + ' = ' + IntToStr(CommitOrdRunNo);
        End; // If (CommitMode In [1, 2])

        lSQLWhereClause := lSQLWhereClause + ')';
      End; // If CommitAct And (CommitMode In [0, 1, 2])
      {$ENDIF}

      // CheckKey(DocWant,DocCodes[IdDocHed],Length(DocWant),BOff)
      If (Trim(DocWant) <> '') Then
      Begin
        lSQLWhereClause := lSQLWhereClause +' And (' + ColName('f_folio_ref') + ' In (Select Distinct ' + ColName('f_folio_num', 'Document.Dat') + ' ' +
                                                                                    'From ' + GetCompanyCode(SetDrive) + '.Document ' +
                                                                                    'Where (' + ColName('f_our_ref', 'Document.Dat') + ' LIKE ' + QuotedStr(Trim(DocWant) + '%') + ')))';
      End; // If (Trim(DocWanted) <> '')

      lSQLWhereClause := lSQLWhereClause + ')';

      lSQLColumns := '';
      lSQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[IDetailF], lSQLWhereClause, lSQLColumns, lSQLPrefillCacheID, MTExLocal^.ExClientId);
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
    Begin
      lSQLPFCRes := -1;
    End; // Else
    {$ENDIF}

    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs And (lSQLPFCRes = 0) Then
      UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
    LStatus:=LFind_Rec(B_GetGEq,NFnum,NPath,NHKey);

    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (LStatusOk) and (CheckKey(NHChk,NHKey,Length(NHChk),BOn)) and (HuntOk) and (Not RepAbort) do
    With LId do
    Begin
      {* Filter out Auto Daybook Items by checking for -ve folio as Auto Lines kept
         with RunNo 0 to stop them appearing on the Nominal
         Note: FolioRef check in Quote Mode is not conclusive as this applies
               to Auto items as well. Additional check is made on Header as well *}

      TInclude:=(CalcCol(0,PPr,PYr)<>0) and
                ((PostedRun>0) or ((QuoteMode) and (FolioRef<0))
                {$IFDEF SOP}
                  or ((PostedRun=CommitOrdRunNo) and (CommitAct) and (COmmitMode In [1,2]))
                {$ENDIF}
                  ) and
                ((Currency=FCr) or ((FCr=0) and ((IdDocHed<>Run) or (PostedRun=CommitOrdRunNo)))) and

                {$IFDEF SOP}
                  ((Not CommitAct)
                   or ((IdDocHed<>RUN) and (CommitMode In [0,1]))
                   or ((PostedRun<>CommitOrdRunNo) and (CommitMode In [0,1]))

                   or ((PostedRun=CommitOrdRunNo) and (CommitMode In [1,2]))) and
                {$ENDIF}

                (CheckKey(DocWant,DocCodes[IdDocHed],Length(DocWant),BOff));

      If (TInclude) then  {* Check CC/Dep Filter *}
        For TBo:=BOff to BOn do
          TInclude:=((TInclude) and CheckKey(NCCDep[TBo],CCDep[TBo],Length(NCCDep[Tbo]),BOff));


      If (TInclude) and (QuoteMode) then  {* Check for Deleted Quote  and Not Auto Item *}
      Begin
        LResetRec(IFnum);

        Blank(KeyI,SizeOf(KeyI));

        KeyI:=FullNomKey(LId.FolioRef);

        If (LId.FolioRef>0) then
          LStatus:=LFind_Rec(B_GetEq,IFnum,IPath1,KeyI);

        TInclude:=((LInv.FolioNum<>0) and (LInv.NomAuto));  {* Check for Deleted Quote and Auto Item
                                                             as FolioRef<0 applies to folio ref and Auto Items *}
      end;

      If (TInclude) then
      Begin
        If (IDDocHed=RUN) then
        Begin
          TBo:=BOn;
        end
        else
          TBo:=Not Syss.SepDiscounts;

        Balance:=DetLTotal(LId,TBo,BOff,0.0);

        If (FCr=0) then
        Begin
          UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

          Balance:=Round_Up(Conv_TCurr(Balance,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

        end;

        For N:=1 to NRanges do
          If (CalcCol(N,PPr,PYr)=N) then
            ColRnum[N]:=ColRnum[N]+Balance;

        HuntOk:=((Balance=0) or (PrMode<>2));

      end; {Tinclude..}


      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;

      If (HuntOk) and (Not RepAbort) then
      Begin
        {* Don't search again if aborting here *}
        {$IFDEF REPPFC}
        If SQLUtils.UsingSQLAlternateFuncs And (lSQLPFCRes = 0) Then
        Begin
          UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
          LStatus:=LFind_Rec(B_GetNext,NFnum,NPath,NHKey);
        End // If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0)
        Else
        {$ENDIF}
        //PR: 29/05/2012 ABSEXCH-12718 v6.10.1 Change from using Extended Btrieve as in some cases it was reaching the
        // unfound record limit and finishing before it got to the next required record.
        LStatus:=LFind_Rec(B_GetNext,NFnum,NPath,NHKey);
      End; // If (HuntOk) and (Not RepAbort)
    end; // while..with

    Ns:=1;

    HasValue:=BOff; {* Reset Print Line.. *}

    For N:=1 to NRanges do
    Begin

      If (Not HasValue) then
        HasValue:=(ColRnum[N]<>0);

      ShowDrCr(ColRnum[N],CrDr);

      For TBo:=BOff to BOn do
        NTotals[(Ns+Ord(TBo))]:=CrDR[TBo];

      Ns:=Ns+2;
    end;


    Case ReportMode of
      5  :  Begin
              ShowDrCr(((NTotals[1]-NTotals[YTDOfSet])-(NTotals[2]-NTotals[Succ(YTDOfset)])),CrDr);

              NTotals[BudgBase]:=CrDr[BOff];

              NTotals[Succ(BudgBase)]:=CrDr[BOn];
            end;
    end; {Case..}

    {$IFDEF REPPFC}
      If SQLUtils.UsingSQLAlternateFuncs And (lSQLPFCRes = 0) Then
        DropCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
  end; {With..}

  Dispose(FindxFilt,Done);
end; {Func..}


{ ========= Procedure to Hunt in advance and check for values ======== }


Procedure TCCDepReport.Forward_Check(LevelKey  :  Str255;
                                 Var FoundOk   :  Boolean);


Var

  TmpKPath,
  TmpKPath2,
  TmpStat
        :  Integer;

  TmpRecAddr2,
  TmpRecAddr
        :  LongInt;

  LNom2 :  NominalRec;

  LNRR  :  NomRepRec;

  LKey  :  Str255;


Begin
  LNRR:=CRepParam^;

  With MTExLocal^ do
  Begin
    LNom2:=LNom;

    With CRepParam^ do
    Begin

      LKey:=LevelKey;


      TmpKPath2:=KeyPth;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOff,BOff);

      Inc(Level);

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPth,LKey);



      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;

      While (LStatusOk) and (Not RepAbort) and (CheckKey(LevelKey,LKey,Length(LevelKey),BOn))
           and (Level<=RepLimit) and (Not FoundOk) do

      With LNom do
      Begin

        TmpKPath:=KeyPth;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        If (NomType=NomHedCode) then
          Forward_Check(FullNomKey(NomCode),FoundOk);

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

        If (Assigned(ThreadRec)) then
          RepAbort:=ThreadRec^.THAbort;
      end; {While..}
    end; {With..}

    LNom:=LNom2;

    CRepParam^:=LNRR;

    With CrepParam^ do
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);

  end; {with..}
end; {Proc..}





{ =================== Procedure to Control Corrolation of Yr to Date ============== }

Procedure TCCDepReport.Control_YTDHist;

Var
  Fini  :  Boolean;
  Base  :  Byte;


Begin
  Base:=1; Fini:=BOn;


  With MTExLocal^,LNom,CRepParam^ do
  Begin


    If (NomType<>NomHedCode) then
    Begin
      Blank(NTotals,Sizeof(NTotals));


      GetCCPr_YTD_Hist(0,Base);

      GrandTotal(Gtotals,NTotals);

      If ((Ok2Print) or ((PALS=0) and (PALE=0))) then {* Only total up Visible totals if a range selected *}
        GrandTotal(BSTotals,NTotals);

    end;



  end; {With..}
end; {Proc..}



{ =================== Function to Check if Ok to Print ================ }

Function TCCDepReport.IsOktoNom(NCode      :  LongInt)  :  Boolean;



Var
  TBo  :  Boolean;
  LNRR :  NomRepRec;


Begin

  LNRR:=CRepParam^;

  TBo:=BOff;

  With MTExLocal^,CRepParam^ do
  Begin

    Case LNom.NomType of

      NomHedcode  :  Begin

                       TBo:=CarryFwd^.Check4CF(NCode);

                       If (Not TBo) then
                         Forward_Check(FullNomKey(NCode),TBo);

                     end;

      else           TBo:=BOn;

    end; {Case..}

  end;


  CRepParam^:=LNRR;

  IsOktoNom:=(TBo);
end;


 { ================== Procedure to control the printing of one line nominal ============= }

 Procedure TCCDepReport.NomDetail(Bot        :  Boolean);


 Begin
   With MTExLocal^ do
   Begin

     If (Not Bot) or ((Bot) and (LNom.NomType=NomHedCode)) then
     With RepFiler1,CRepParam^ do
     With LNom do
     Begin


       {If (Ln=0) and (Ok2Print) then
         PrintNomHed(NomReport);}

       Case Mode of
         1..5,10,20,30
            :  Begin
                 Check4BF(NomCode,Bot);

                 Control_YTDHist;

               end;


       end; {case..}


       If (NomPage) and (Ok2Print) and (HasValue) and (Not Bot) then
         ThrowNewPage(-1);

       If (LinesLeft<=5) then
         ThrowNewPage(5);


       If (Ok2Print) and (HasValue) then
         PrintNomDet(Bot);

       HasValue:=BOn;

     end; {with..}
   end;
 end;



{ ============== Procedure to check if P&L Encountered ================== }

Procedure TCCDepReport.Check4PL(NCode      :  LongInt);

Begin
  With CRepParam^ do
    If (NCode<>0) and ((NCode=PaLS) or (NCode=PaLE)) then
      Ok2Print:=Not Ok2Print;


end; {PRoc..}

{ ============== Recursive routine to follow nominal structure & Print it ================= }


Procedure TCCDepReport.FollowCCChain(LevelKey  :  Str10;
                                Var  LevelTotal:  Totals);


Var
  TmpKPath,
  TmpStat :  Integer;
  TmpRecAddr
          :  LongInt;

  LNom2   :  NominalRec;
  FoundCode
          :  Str20;
          
  LKey    :  Str255;
  HedTotal:  Totals;


Begin
  Blank(HedTotal,Sizeof(HedTotal));

  With MTExLocal^,CRepParam^ do
  Begin
    Inc(Level);

    LKey:=LevelKey;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPth,LKey);


    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (LStatusOk) and (Not RepAbort) and (CheckKey(LevelKey,LKey,Length(LevelKey),BOn)) and (Level<=RepLimit) do

    With LNom do
    Begin

      Inc(RCount);

      If (Assigned(ThreadRec)) then
        UpDateProgress(RCount);

      TmpKPath:=KeyPth;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);


      Check4PL(NomCode);


      If (NomType=CarryFlg) then
        CarryFwd^.AddItem(NTotals,GTotals,Cat,CarryF,Desc,Mode);


      {$B-}


      If (NomType<>CarryFlg) and (IsOktoNom(NomCode)) then
      Begin

      {$B+}

        Inc(ICount);

        LNom2:=LNom;

        NomDetail(BOff);  { =========== Print Detail =========== }

        HedTotal:=NTotals;

        If (NomType=NomHedCode) then
        Begin

          Blank(HedTotal,Sizeof(HedTotal));

          FollowCCChain(FullNomKey(NomCode),HedTotal);

          Split_Totals(NTotals,HedTotal,BOff,4);
        end;


        GrandTotal(LevelTotal,HedTotal);


        LNom:=LNom2;

        If Check_HasValue(NTotals) then
          NomDetail(BOn);   { ============ Print Bottom =========== }

      end; {Profit..}

      If (Level=0) then
        Blank(LevelTotal,Sizeof(LevelTotal));

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPth,LKey);

      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;
    end; {While..}

    Dec(Level);

  end; {with..}
end; {Proc..}






Procedure TCCDepReport.RepPrint(Sender  :  TObject);

Var
  LevelKey  :  Str10;
  LevelTotal:  Totals;

Begin
  ShowStatus(2,'Processing Report.');

  LevelKey:=FullNomKey(0);

  Blank(LevelTotal,Sizeof(LevelTotal));

  With CRepParam^ do
  Begin
    Case ReportMode of
      5
           :  Begin

                If (PaLS<>0) then
                  Ok2Print:=BOff;

                FollowCCChain(LevelKey,LevelTotal);


                If (Check_HasValue(BSTotals)) and (ReportMode In [5]) then
                Begin

                  { === Print Grand Balance Sheet Totals Excluding Carry Fwd Items ==== }

                  PrintTotals(BSTotals,FCr,FTxCr,1);


                end;

              end;
    end; {Case..}

  end; {With..}

  PrintEndPage;
end;


Function TCCDepReport.GetReportInput  :  Boolean;

{$IFDEF SOP}
  Const
    CommitTitle  :  Array[1..2] of Str50 = ('Committed & Actual values.','Committed values only.');

{$ENDIF}

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;

  CCTitle
     :  Str50;



Begin
  With CRepParam^ do
  Begin
    YTDOfSet  :=  3;
    BudgBase  :=  5;

    RFnum:=NomF;
    RKeypath:=0;

    Level:=-1;

    Mode:=ReportMode;

    HasValue:=BOn;

    Ok2Print:=BOn;

    RepLimit:=YTD;

    Fnum:=RFnum; KeyPth:=NomCatK;


    Case ReportMode of

      5     :  Begin
                 ThTitle:='CC/Dep Report';

                 RepTitle:='Cost Centre and Department Analysis';

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
        5
           :  Begin

                RepTitle2:=' for '+PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1])+'-'+PPR_OutPr(F2YrPr[1,4],F2YrPr[1,3]);


                If (Not EmptyKeyS(DocWant,ccKeyLen,BOff)) then
                  RepTitle2:=RepTitle2+'.Document Filter : '+DocWant;

                {$IFDEF SOP}

                  If (CommitAct) and (CommitMode In [1,2]) then
                    RepTitle2:=RepTitle2+'. '+CommitTitle[CommitMode];

                {$ENDIF}


                For BoLoop:=BOff to BOn do

                  If (Not EmptyKeyS(NCCDep[BoLoop],ccKeyLen,BOff)) then
                  Begin
                    FoundCode:=NCCDep[BoLoop];

                    CCTitle:='';

                    If (Assigned(MTExLocal)) then
                    With MTExLocal^ do
                    Begin
                      If LGetMainRec(PWrdF,FullCCKey(CostCCode,CSubCode[boLoop],FoundCode)) then
                        CCTitle:=LPassword.CostCtrRec.CCDesc;
                    end
                    else
                    Begin
                      GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

                      CCTitle:=Password.CostCtrRec.CCDesc;
                    end;


                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+NccDep[BoLoop]+'-'+CCTitle;

                  end; {Loop..}


              end;

      end; {case..}


    ROrient:=RPDefine.PoLandscape;


  end; {With..}

  Result:=BOn;
end;





Procedure TCCDepReport.Finish;


Begin
  Inherited Finish;
end;


{ ======== }



Procedure AddCCDepRep2Thread(IRepParam:  NomRepRecPtr;
                             AOwner   :  TObject);


  Begin
    AddCDCCDepReportThread(5,IRepParam,AOwner);
  end;

{$IFDEF OLDVERSION}{Pre auto report}

Var
  EntTest  :  ^TCCDepReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=5;

        If (Assigned(IRepParam)) then
        Begin
          CRepParam^:=IRepParam^;

        end;

        If (Start) and (Create_BackThread)  then
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

{$ENDIF}

end.


