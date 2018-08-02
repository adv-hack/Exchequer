unit Report4U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type
  { ======================= Nominal C/F Control ======================= }



  CFCodeTyp     =  Array[1..2] of LongInt;

  CFRecPtr      =  ^CFRecord;

  CFRecord      =  Record
                     CFDesc    :  Str40;
                     CFTotals  :  Totals;
                     CFCode    :  CFCodeTyp;
                   end;


  CarryFPtr     =  ^CarryFObj;

  CarryFObj     =  Object(List)
                     CarryFR   :  CFRecPtr;

                     CurrNode  :  NodePtr;

                     Constructor  Init;

                     Destructor   Done;

                     Procedure AddItem(Var NT,GT     :  Totals;

                                           HedCode,
                                           CarryCode :  LongInt;

                                       Var CarryDesc :  Str40;
                                           Mode      :  Byte);

                     Function Check4CF(NCode  :  LongInt)  :  Boolean;


                   end; {Object..}



  TNOMReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Procedure RepPrint(Sender  :  TObject); Virtual;


                     private

                       Procedure PrintGBHed(Band1,Band2,
                                            Band3      :  Str80);

                       Procedure BuildBoxes(ColNo  :  Integer);

                       Procedure RepPrintTLines(LWidth  :  Integer);



                       Procedure PrintNomGap(CMode      :  Byte);

                       Function Get_CommitValues(PrevNHist  :  HistoryRec;
                                                 NFnum,
                                                 NKeypath   :  Integer)  :  HistoryRec;


                       Procedure GetPR_YTD_Hist(PrMode,
                                                Base     :  Byte);


                       Procedure Calc_ThisYTDProfit(PrMode,
                                                    Base     :  Byte);

                       Procedure Control_ThisYTDPBF;

                       Procedure Set_PBFNCC;

                       Function IsTBPaL(NCode      :  LongInt;
                                    Var PLMode     :  Byte)  :  Boolean;

                       
                       
                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  NomRepRecPtr;
                       CarryFWd   :  CarryFPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Control_YTDHist; Virtual;

                       Function IsOktoNom(NCode      :  LongInt)  :  Boolean; Virtual;

                       Procedure PrintTotals(Ntotals  :  Totals;
                                             RCr,RTxCr,
                                             GMode    :  Byte);

                       Procedure SetReportDrillDown(DDMode  :  Byte);  Virtual;

                       Procedure PrintNomDet(Bot        :  Boolean);

                       Procedure NomDetail(Bot        :  Boolean); Virtual;


                       Procedure Check4PL(NCode      :  LongInt); Virtual;

                       Procedure Check4BF(NCode    :  LongInt;
                                          Total    :  Boolean);

                       Procedure FollowChain(LevelKey  :  Str10); Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}



Var
  YTDOfSet,
  BudgBase  :  Integer;

Const
  HedSpace    =  2;    {   "     Parent Code Indentation }


  Procedure Split_Totals(Var NT  :  Totals;
                             GT  :  Totals;
                             BOrd:  Boolean;
                             Mode:  Byte);


  Procedure AddNomRep2Thread(LMode    :  Byte;
                             IRepParam:  NomRepRecPtr;
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
  SalTxl1U,
  RpDefine,
  IntMU,
  InvListU,

  RepCCShU,


  ExThrd2U;


Const
  PostSpace   =  12;    { Defualt Code Change Indentation }





Procedure Split_Totals(Var NT  :  Totals;
                             GT  :  Totals;
                             BOrd:  Boolean;
                             Mode:  Byte);

  Var
    CrDr1,
    CrDr2,
    CrDr3  :  DrCrType;
    TBo    :  Boolean;

  Begin
    NT:=GT;

    TBo:=BOff;

    ShowDrCr((NT[1]-NT[2]),CrDr1);
    ShowDrCr((NT[YTDOfSet]-NT[Succ(YTDOfSet)]),CrDr2);

    If (Mode In [4,5]) then {* Only Work out swap if Source / Apps mode *}

      ShowDrCr((NT[BudgBase]-NT[Succ(BudgBase)]),CrDr3);


    For TBo:=BOff to BOn do
    Begin
      NT[(1+Ord(TBo))]:=CrDr1[BOrd];
      NT[(YTDOfSet+Ord(TBo))]:=CrDr2[BOrd];

      If (Mode In [4,5]) then {* Only Work out swap if Source / Apps mode *}
        NT[(BudgBase+Ord(TBo))]:=CrDr3[BOrd];

      BOrd:=Not BOrd;
    end;
  end;


  { ---------------------------------------------------------------- }

  {  Carry Fwd Methods }

  { ---------------------------------------------------------------- }




  Constructor CarryFObj.Init;

  Begin
    List.Init;

    CurrNode:=GetFirst;

  end;


  Destructor CarryFObj.Done;


  Var
    N  :  NodePtr;

  Begin
    N:=GetLast;

    {While (N<>Nil) do
    Begin

      CarryFR:=N^.LITem;

      Dispose(CarryFR);

      N:=GetPrev(N);
    end;}

    List.Done;

  end;


  Procedure CarryFObj.AddItem(Var  NT,GT      :  Totals;

                                   HedCode,
                                   CarryCode  :  LongInt;

                              Var  CarryDesc  :  Str40;
                                   Mode       :  Byte);


  Begin

    Add(New(CFRecPtr));

    CurrNode:=GetLast;

    CarryFR:=CurrNode^.LITem;

    FillChar(CarryFR^,Sizeof(CarryFR^),0);

    With CarryFR^ do
    Begin


      CFTotals:=GT;

      {* Calculate budget variance from balance so far *}
      {* This is neccs since otherwise C/F budget varinace does not take into account
         nominal codes with no budget set, but which are contributing to the total
         amount,and thus will affect total variance *}

      If (CFTotals[BudgBase]<>0) and (Not (Mode In [4,5])) then {* Only applied when a budget comparison is made
                                                                   & not Source & apps mode*}

        CFTotals[Succ(BudgBase)]:=((CFTotals[1]-CFTotals[2])-CFTotals[BudgBase]);

      Blank(GT,Sizeof(GT));  {* Reset GT so far *}

      CFCode[1]:=HedCode;

      CFCode[2]:=CarryCode;

      CFDesc:=CarryDesc;

    end; {With..}
  end; {Proc..}



  Function CarryFObj.Check4CF(NCode  :  LongInt)  :  Boolean;

  Var
    Found  :  Boolean;

  Begin

    Found:=BOff;

    CurrNode:=GetFirst;

    While (CurrNode<>NIL) and (Not Found) do
    With CarryFR^ do  {* If you find a bug here, remember, advanced withs do not work
                         well with pointers, as they seem to not get updated, rather they
                         preserve the value they had when the statement was executed.. this has
                         not been corrected here, as it seems to work ok...! *}
    Begin
      CarryFR:=CurrNode^.LITem;

      Found:=(CFCode[2]=NCode);

      CurrNode:=GetNext(CurrNode);

    end; {With..}

    Check4CF:=Found;

  end; {Proc..}





{ ========== TNomReport methods =========== }

Constructor TNomReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  RNoPageLine:=BOn;
  
  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  New(CarryFwd,Init);
end;


Destructor TNomReport.Destroy;

Begin
  Dispose(CarryFwd,Done);

  Dispose(CRepParam);

  Inherited Destroy;
end;




Procedure TNomReport.Process;

Begin
  Inherited Process;
end;



Procedure TNomReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of
        0  :  ;

        else
            Begin
              SetTab (MarginLeft, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 53, 4, 0, 0);
              SetTab (NA, pjRight,35, 4, 0, 0);
              SetTab (NA, pjRight,35, 4, 0, 0);
              SetTab (NA, pjRight,34, 4, 0, 0);
              SetTab (NA, pjRight,34, 4, 0, 0);
              SetTab (NA, pjRight,35, 4, 0, 0);
              SetTab (NA, pjRight,35, 4, 0, 0);

            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;


Procedure TNomReport.PrintGBHed(Band1,Band2,
                                 Band3      :  Str80);

Begin
  With RepFiler1 do
  Begin
    {ClearTabs;
    SetTab (MarginLeft+75, pjCenter, 58, 4, 0, 0);
    SetTab (NA, pjCenter, 58, 4, 0, 0);
    SetTab (NA, pjCenter, 58, 4, 0, 0);}


    SendLine(ConCat(#9,#9,#9,Band1,#9,Band1,#9,Band2,#9,Band2,#9,Band3,#9,Band3));

    {RepSetTabs;}
  end;
end;


Procedure TNomReport.BuildBoxes(ColNo  :  Integer);

Var
  BoxDim   :  TRect;
  clShade  :  TColor;


Begin
  With RepFiler1 do
  Begin
    clShade:=TColor($F5F5F5);
    SetBrush(clShade,bsSolid,nil);

    With BoxDim do
    Begin
      Left:=XU2D(TabStart(ColNo)-1);
      Top:=YU2D(MarginTop+14);
      Right:=XU2D(TabEnd(ColNo)+1);
      Bottom:=YU2D(PageHeight-MarginBottom);

      FillRect(BoxDim);
    end;
    SetBrush(clWhite,bsClear,nil);

  end;
end;


Procedure TNomReport.RepPrintTLines(LWidth  :  Integer);

Begin
  With RepFiler1 do
  Begin
    DefLine(LWidth,TabStart(3)+1,TabEnd(3),0);
    DefLine(LWidth,TabStart(4)+1,TabEnd(4),0);
    DefLine(LWidth,TabStart(5)+1,TabEnd(5),0);
    DefLine(LWidth,TabStart(6)+1,TabEnd(6),0);
    DefLine(LWidth,TabStart(7)+1,TabEnd(7),0);
    DefLine(LWidth,TabStart(8)+1,TabEnd(8),0);
  end;
end;


Procedure TNomReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin

    BuildBoxes(3);
    BuildBoxes(5);
    BuildBoxes(7);


    DefFont(0,[fsBold]);

    Case ReportMode of
      1..3,8
         :  PrintGBHed(PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1]),PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1]),FullYear(TxlatePYr(F2YrPr[1,1],BOn))+' YTD');

      4
         :  PrintGBHed(FullYear(TxlatePYr(F2YrPr[1,3],BOn)),FullYear(TxlatePYr(F2YrPr[2,3],BOn)),'Movement');

      5
         :  Begin

              If (CCRepTit<>'') then
              Begin
                DefFont(0,[fsBold,fsUnderLine]);

                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.PrintLeft(CCRepTit,MArginLeft);
                Self.CRLF;
                Self.CRLF;

                DefFont(0,[fsBold]);
              end;

              PrintGBHed(PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1])+' - '+PPR_OutPr(F2YrPr[1,4],F2YrPr[1,3])+'.',
                         PPR_OutPr(F2YrPr[2,2],F2YrPr[2,1])+' - '+PPR_OutPr(F2YrPr[2,4],F2YrPr[2,3])+'.',
                         'Difference');
            end;

      10,20,30,80
         :  PrintGBHed(FullYear(TxlatePYr(F2YrPr[1,3],BOn)),FullYear(TxlatePYr(F2YrPr[1,3],BOn)),
                       FullYear(TxlatePYr(F2YrPr[2,3],BOn)));
    end; {Case..}




    Case ReportMode of

      4,5
         :  SendLine(ConCat(#9,#9,#9,'Debit',#9,'Credit',#9,'Debit',#9,'Credit',#9,'Debit',#9,'Credit'));

      else  SendLine(ConCat(#9,#9,#9,'Debit',#9,'Credit',#9,'Budget',#9,'Variance',#9,'Debit',#9,'Credit'));
    end; {Case..}

    RepPrintTLines(-1);


    DefFont(0,[]);
  end; {With..}
end; {Proc..}




Procedure TNomReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

end;



{ ============= Print Remaining Common Totals Line ============ }

Procedure TNomReport.PrintTotals(Ntotals  :  Totals;
                                 RCr,RTxCr,
                                 GMode    :  Byte);


Var

  n      :  Byte;

  TotTitle
         :  Str50;

Begin
  With RepFiler1 do
  Begin
    If (GMode=1) and (ReportMode In [8,80]) then
      TotTitle:='Column Totals'
    else
      TotTitle:='Grand Totals';


    For n:=1 to NoTotals do  {* Translate value if required *}
      NTotals[n]:=Currency_Txlate(NTotals[n],RCr,RTxCr);


    Case GMode of
      0  :  Begin
              SendLine(Concat(#9,#9,
                      #9,FormatBFloat(GenRealMask,NTotals[1],BOn),
                      #9,FormatBFloat(GenRealMask,NTotals[2],BOn),
                      #9,FormatBFloat(GenRealMask,NTotals[3],BOn),
                      #9,FormatBFloat(GenRealMask,NTotals[4],BOn),
                      #9,FormatBFloat(GenRealMask,NTotals[5],BOn),
                      #9,FormatBFloat(GenRealMask,NTotals[6],BOn)));
            end;

      1  :  SendLine(Concat(#9,#9,TotTitle,
                     #9,FormatBFloat(GenRealMask,NTotals[1],BOn),
                     #9,FormatBFloat(GenRealMask,NTotals[2],BOn),
                     #9,FormatBFloat(GenRealMask,NTotals[3],BOn),
                     #9,FormatBFloat(GenRealMask,NTotals[4],BOn),
                     #9,FormatBFloat(GenRealMask,NTotals[5],BOn),
                     #9,FormatBFloat(GenRealMask,NTotals[6],BOn)));
    end; {Case..}
  end; {With..}
end;


Procedure TNomReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin

    SendRepDrillDown(1,TotTabs,1,FullNomKey(LNom.NomCode),NomF,NomCodeK,0);
  end; {With..}
end;

{ ============= Print one line of nominal detail ============== }


Procedure TNomReport.PrintNomDet(Bot        :  Boolean);



Var
  SpcC   :  Byte;
  GenStr,
  GenStr2:  Str80;



Begin

  With MTExLocal^,LNom,CRepParam^,RepFiler1 do
  Begin


    SpcC:=(Succ(Level)*HedSpace);

    SetReportDrillDown(0);


    Case NomType of
      NomHedCode
               :  Begin


                    If (Not Bot) then
                    Begin

                      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                      Self.CRLF;

                      GenStr:=Spc(SpcC)+Desc;                                              { ** Nte UsrDef Var SpcC ** }

                      SetReportDrillDown(0);

                      SendLine(ConCat(#9,Form_Int(NomCode,0),
                               #9,GenStr));

                      DefLine(-1,MarginLeft,75,-0.5);

                    end
                    else
                    Begin

                      If (Not NoBotD) then
                        GenStr:='('+Strip('B',[#32],Desc)+')'
                      else
                        GenStr:='';


                      GenStr:=Spc(SpcC)+'Total: '+GenStr+ConstStr('.',(NomDesLen-Length(GenStr)))+':';

                      RepPrintTLines(-1);

                      DefFont(0,[fsbold]);

                      
                      SendText(ConCat(#9,#9,GenStr));

                      DefFont(0,[]);

                      PrintTotals(NTotals,FCr,FTxCr,0);

                      If (Level<=0) then
                        RepPrintTLines(-2);

                      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                      Self.CRLF;
                      Self.CRLF;
                    end;
                  end;
      else
                  Begin

                    Case ReportMode of

                      8,80  :  GenStr:=Desc

                      else     GenStr:=Spc(SpcC)+Desc;

                    end; {Case..}

                    If (NomCode<>0) then
                      GenStr2:=Form_Int(NomCode,0)
                    else
                      GenStr2:='';

                    SendText(ConCat(#9,GenStr2,#9,
                          GenStr));


                    PrintTotals(NTotals,FCr,FTxCr,0);

                  end;

    end; {case..}

  end; {With..}
end; {Proc..}



{ ============= Print one line of nominal detail ============== }


Procedure TNomReport.PrintNomGap(CMode      :  Byte);




Begin
  With RepFiler1,CRepParam^ do
  Begin
    If (CMode In [2,3]) then
    Begin
      ClearTabs;
      SetTab (MarginRight, pjCenter, 75, 4, 0, 0);

    end;


    Case CMode of

      1  :  Begin

              JustNDet:=BOff;

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end;

      2  :  Begin

              SendLine(ConCat(#9,'Profit & Loss'));
              DefLine(-1,MarginLeft,65,-0.5);

              PaLOn:=BOn;
            end;
      3  :  Begin

              SendLine(ConCat(#9,'End Profit & Loss'));
              DefLine(-1,MarginLeft,65,-0.5);

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
              PaLOn:=BOff;
           end;


      9  :  DefLine(-2,MarginLeft,PageWidth-MarginRight-1,0);


    end; {Case..}

    If (CMode In [2,3]) then
      RepSetTabs;

  end; {With..}
end; {Proc..}



Function TNomReport.Get_CommitValues(PrevNHist  :  HistoryRec;
                                     NFnum,
                                     NKeypath   :  Integer)  :  HistoryRec;

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


    With CRepParam^,MTExLocal^ do
    Begin
      If (Not (CommitMode In [1,2])) then
        Result:=LNHist
      else
      Begin
        Result:=PrevNHist;

        With LNHist do
          KeyNH:=FullNHistKey(ExClass,Code,Cr,Yr,Pr);

        With PrevNHist do
          KeyOld:=FullNHistKey(ExClass,Code,Cr,Yr,Pr);

        If (KeyNH<>KeyOld) then {It needs refreshing *}
        Begin
          OldStat:=LStatus;

          Result:=LNHist;

          If (CommitMode=2) then {*We only want comitted values*}
          With Result do
          Begin
            Sales:=0.0;
            Purchases:=0.0;
          end;

          OldNHist:=LNHist;

          TmpKPath:=NKeypath;

          TmpStat:=LPresrv_BTPos(NFnum,TmpKPath,LocalF^[NFnum],TmpRecAddr,BOff,BOff);

          Blank(KeyNH,Sizeof(KeyNH));

          With Result do
            KeyNH:=FullNHistKey(ExClass,CommitKey+Result.Code,Cr,Yr,Pr);

          LStatus:=LFind_Rec(B_GetEq,NFnum,Nkeypath,KeyNH);

          If (LStatusOk) then
          With Result do
          Begin
            Sales:=Sales+LNHist.Sales;
            Purchases:=Purchases+LNHist.Purchases;
          end;

          LNHist:=OldNHist;

          TmpStat:=LPresrv_BTPos(NFnum,TmpKPath,LocalF^[NFnum],TmpRecAddr,BOn,BOff);

          LStatus:=OldStat;
        end;

      end; {For commitment values}
    end; {With..}
  {$ELSE}
      Result:=MTExLocal^.LNHist;

  {$ENDIF}
end;


 { =============== Procedure to Return a given periods Totals, + the YTD =============== }

Procedure TNomReport.GetPR_YTD_Hist(PrMode,
                                     Base     :  Byte);



Const
  NFnum =  NHistF;
  NPath =  NHK;



Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Balance,
  NBudget      :  Real;
  CrDr         :  DrCrType;
  TBo          :  Boolean;

  ViewNHist    :  HistoryRec;


Begin
  TBo:=BOff;

  Balance:=0; NBudget:=0;

  Blank(ViewNHist,Sizeof(ViewNHist));

  With MTExLocal^,LNom,CRepParam^ do
  Begin

    NHChK:=FullNHistKey(NomType,CalcCCKeyHistP(NomCode,NCCMode,CalcCCDepKey(NCCMode,NCCDep)),FCr,F2YrPr[PrMode,3],F2YrPr[PrMode,4]);

    NHKey:=FullNHistKey(NomType,CalcCCKeyHistP(NomCode,NCCMode,CalcCCDepKey(NCCMode,NCCDep)),FCr,F2YrPr[PrMode,1],F2YrPr[PrMode,2]);

    If (NomType In YTDSet+[NomHedCode]) and (NHKey<NHChk) then  {** Get Last Valid YTD **}
    Begin
      NHKey2:=NHKey;
      LStatus:=LFind_Rec(B_GetLessEq,NFnum,NPath,NHKey2);

      If (LStatusOk) and (CheckKey(NHChk,NHKey2,Length(NHChk)-2,BOn)) and (LNHist.Pr=YTD) then
        NHKey:=NHKey2;
    end;


    LStatus:=LFind_Rec(B_GetGEq,NFnum,NPath,NHKey);

    While (LStatusOK) and (NHKey<=NHChk) do
    With ViewNHist do
    Begin

      ViewNHist:=Get_CommitValues(ViewNHist,NFnum,NPath);


      Balance:=Balance+(Purchases-Sales);

      If (Base=1) then
      Begin
        If (RevisedBudget1<>0.0) then
          NBudget:=NBudget+RevisedBudget1
        else
          NBudget:=NBudget+Budget;
      end;

      LStatus:=LFind_Rec(B_GetNext,NFnum,NPath,NHKey);
    end;

    ShowDrCr(Balance,CrDr);

    For TBo:=BOff to BOn do
      NTotals[(Base+Ord(TBo))]:=CrDR[TBo];


    Case ReportMode of
      4  :  If (Base<>1) then
            Begin
              ShowDrCr(((NTotals[1]-NTotals[YTDOfSet])-(NTotals[2]-NTotals[Succ(YTDOfset)])),CrDr);

              NTotals[BudgBase]:=CrDr[BOff];

              NTotals[Succ(BudgBase)]:=CrDr[BOn];
            end;
      else  If (NBudget<>0) then
            Begin
              NTotals[BudgBase]:=NBudget;

              NTotals[Succ(BudgBase)]:=(Balance-NBudget);
            end;
    end; {Case..}

  end; {With..}
end; {Func..}



{ =================== Procedure to Control Corrolation of Yr to Date ============== }

Procedure TNomReport.Control_YTDHist;

Var
  Fini  :  Boolean;
  Base  :  Byte;


Begin
  Base:=1; Fini:=BOn;


  With MTExLocal^,LNom,CRepParam^ do
  Begin

    Blank(NTotals,Sizeof(NTotals));

    Repeat

      GetPr_YTD_Hist((1+Ord(Not Fini)),Base);

      Base:=YTDOfSet;
      Fini:=Not Fini;

    Until (Fini);


    If (NomType<>NomHedCode) or (Level=RepLimit) then
      GrandTotal(Gtotals,NTotals);

    If (NomType=NomHedCode) then
    Begin

      If (Level=0) then
        GrandTotal(BSTotals,NTotals);


      If (NomCode=PBFHedCode) then  {* Add This YTD totals to heading totals, but not to report totals *}
        GrandTotal(NTotals,PBFTotals);


    end;


  end; {With..}
end; {Proc..}



 { =============== Procedure to Return a given periods Totals, + the YTD =============== }

Procedure TNomReport.Calc_ThisYTDProfit(PrMode,
                                         Base     :  Byte);





Const
  NFnum =  NHistF;
  NPath =  NHK;



Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Balance,
  NBudget      :  Real;
  CrDr         :  DrCrType;
  TBo          :  Boolean;

  ProfitCode   :  LongInt;

  ViewNHist    :  HistoryRec;


Begin
  TBo:=BOff;

  Balance:=0; NBudget:=0;

  ProfitCode:=Syss.NomCtrlCodes[PLStart];

  Blank(ViewNHist,Sizeof(ViewNHist));


  With MTExLocal^,LNom,CRepParam^ do
  Begin

    {* Get Current Period Profit *}

    NHChK:=FullNHistKey(NomHedCode,CalcCCKeyHistP(ProfitCode,NCCMode,CalcCCDepKey(NCCMode,NCCDep)),FCr,F2YrPr[PrMode,3],F2YrPr[PrMode,4]);

    NHKey:=FullNHistKey(NomHedCode,CalcCCKeyHistP(ProfitCode,NCCMode,CalcCCDepKey(NCCMode,NCCDep)),FCr,F2YrPr[PrMode,1],F2YrPr[PrMode,2]);

    LStatus:=LFind_Rec(B_GetGEq,NFnum,NPath,NHKey);


    While (LStatusOK) and (NHKey<=NHChk) do
    With ViewNHist do
    Begin

      ViewNHist:=Get_CommitValues(ViewNHist,NFnum,NPath);

      Balance:=Balance+(Purchases-Sales);

      If (Base=1) then
      Begin
        If (RevisedBudget1<>0.0) then
          NBudget:=NBudget+RevisedBudget1
        else
          NBudget:=NBudget+Budget;
      end;
      
      LStatus:=LFind_Rec(B_GetNext,NFnum,NPath,NHKey);
    end;

    ShowDrCr(Balance,CrDr);

    For TBo:=BOff to BOn do
      NTotals[(Base+Ord(TBo))]:=CrDR[TBo];


    If (NBudget<>0) then
    Begin

      NTotals[BudgBase]:=NBudget;

      NTotals[Succ(BudgBase)]:=(Balance-NBudget);

    end; {Case..}

  end; {With..}
end; {Func..}


{ =================== Procedure to Control Corrolation of Yr to Date Profit & Loss ============== }

Procedure TNomReport.Control_ThisYTDPBF;

Var
  Fini  :  Boolean;
  Base  :  Byte;


Begin
  Base:=1; Fini:=BOn;


  With MTExLocal^,LNom, CRepParam^ do
  Begin

    Blank(NTotals,Sizeof(NTotals));

    Repeat

      Calc_ThisYTDProfit((1+Ord(Not Fini)),Base);

      Base:=YTDOfSet;
      Fini:=Not Fini;

    Until (Fini);

    // MH 21/02/2012 v6.10 ABSEXCH-12003: Modified to add totals into the current GL Code if it is a heading
    If (NomType = NomHedCode) Then
      PBFHedCode := NomCode
    Else
      PBFHedCode := Cat;

    PBFTotals:=NTotals;

    Desc:=GetIntMsg(48);


  end; {With..}
end; {Proc..}




{ =================== Function to Check if Ok to Print ================ }

Function TNomReport.IsOktoNom(NCode      :  LongInt)  :  Boolean;



Var
  TBo  :  Boolean;
  LNRR :  NomRepRec;


Begin
  LNRR:=CRepParam^;

  Control_YTDHist;

  With CRepParam^ do
    TBo:=((NTotals[1]<>0) or (NTotals[2]<>0) or (NTotals[3]<>0) or (NTotals[YTDOfSet]<>0) or (NTotals[Succ(YTDOfSet)]<>0));

  If (Not TBo) and (Not (ReportMode In [8,80])) then
    TBo:=CarryFwd^.Check4CF(NCode);


  IsOktoNom:=((TBo) or (CRepParam^.IncludeAll));

  CRepParam^:=LNRR;
end;


{ =================== Function to Check if Ok to Print ================ }

Function TNomReport.IsTBPaL(NCode      :  LongInt;
                         Var PLMode     :  Byte)  :  Boolean;

Var
  TmpBo  :  Boolean;
  LNRR   :  NomRepRec;


Begin
  LNRR:=CRepParam^;

  TmpBo:=BOff;

  With CRepParam^ do
  Begin

    Case PaLOn of

      BOff  :  Begin
                TmpBo:=InPaL;
              end;

      BOn   :  Begin

                 TmpBo:=(Not InPaL);

               end;

    end; {Case..}

    PLMode:=(2+Ord(PaLOn))*Ord(TmpBo);

    IsTBPaL:=TmpBo;

  end; {With..}

  CRepParam^:=LNRR;

end; {Func..}





 { ================== Procedure to control the printing of one line nominal ============= }

 Procedure TNomReport.NomDetail(Bot        :  Boolean);



 Begin
   If (Not Bot) or ((Bot) and (MTExLocal^.LNom.NomType=NomHedCode)) then
   With RepFiler1,CRepParam^,MTExLocal^,LNom do
   Begin

     {If (Ln=0) and (Ok2Print) then
       PrintNomHed;}

     Case ReportMode of
       1..4,8,10,20,30,80
          :  Begin

               If (Not (ReportMode In [8,80])) then
                 Check4BF(NomCode,Bot)
               else
                 JustNDet:=BOn;

               If (NomType<>NomHedCode) or (Bot) then
                 Control_YTDHist;


             end;


     end; {case..}


     If (NomPage) and (Ok2Print) and (Not Bot) then
       ThrowNewPage(-1);

     If (LinesLeft<=5) then
        ThrowNewPage(5);

     // MH 21/02/2012 v6.10 ABSEXCH-11950: Modified so that the fake 91060 line only prints if the section its in is printing
     If (Ok2Print) then
     Begin
       PrintNomDet(Bot);

       If (NomCode=PBFCompCode) and (ReportMode<>4) and (Not TYTDD) then {* Insert special current Profit line *}
       Begin
         Control_ThisYTDPBF;

         If (NomCode<>Syss.NomCtrlCodes[ProfitBF]) then
         With LNom do
         Begin
           Nomcode:=Syss.NomCtrlCodes[ProfitBF];
           NomType:=PLNHCode;
         end;

         PrintNomDet(Bot);

         TYTDD:=BOn;
       end;

     end;




   end; {with..}
 end;



{ ========== Function to return appropriate level code for PF/BF =========== }

Procedure TNomReport.Set_PBFNCC;

Const
  Fnum     =  NomF;
  Keypath  =  NomCodeK;

Var
  KeyCS  :   Str255;
  NMode  :   Byte;

  Result,
  Count,
  This1  :   LongInt;

  FoundOk,
  GotGL  :   Boolean;


Begin
  With CRepParam^, MTExLocal^ do
  Begin
    Result:=Syss.NomCtrlCodes[ProfitBF];

    If (RepLimit<>YTD) and (ReportMode<>4) then
    Begin
      NMode:=1;
      Count:=0;
      GotGL:=BOff;



      Repeat
        FoundOk:=BOff;
        This1:=0;

        KeyCS:=FullNomKey(Result);

        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS);


        If (LStatusOk) and (LNom.Cat<>0) then
        Begin

          While (LStatusOk) and (Not FoundOk) and (ChkRepAbort) do
          With LNom do
          Begin
            Case NMode of
              1  :  Begin
                      Inc(Count);
                    end;

              2  :  Begin
                      Inc(This1);
                      GotGL:=((Count-This1)<=RepLimit);

                      If (GotGL) then
                        Result:=NomCode;


                    end;
            end; {Case..}

            FoundOk:=((Cat=0) or GotGL);

            If (Not FoundOk) then
            Begin
              KeyCS:=FullNomKey(LNom.Cat);

              LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS);

            end;
          end; {While..}

        end
        else
          NMode:=2;


        Inc(NMode);


      Until (NMode>2) or (Not ChkRepAbort);

    end;

    PBFCompCode:=Result;

  end; {With..}
end;



{ ============== Procedure to check if P&L Encountered ================== }

Procedure TNomReport.Check4PL(NCode      :  LongInt);

Begin
  With CRepParam^ do
  Begin
    Case ReportMode of

      8,80
        :  Begin
             If (Not InPaL) then
               InPaL:=(NCode=Syss.NomCtrlCodes[PLStart])
             else
               InPaL:=(NCode<>Syss.NomCtrlCodes[PLEnd]);
           end;

    end;{Case..}

    If (NCode<>0) and ((NCode=PaLS) or (NCode=PaLE)) then
      Ok2Print:=Not Ok2Print;
  end;

end; {PRoc..}



  { ======================= Check for Matching B/F Code ==================== }

  Procedure TNomReport.Check4BF(NCode    :  LongInt;
                                Total    :  Boolean);
  Var
    LNom2  :  NominalRec;

    TNT   :  Totals;

    n     :  Byte;

  Begin
    With MTExLocal^ do
    Begin
      LNom2:=LNom;

      TNT:=CRepParam^.NTotals;

      With CarryFwd^ do
      Begin
        CurrNode:=GetFirst;

        While (CurrNode<>Nil) do
        Begin
          CarryFR:=CurrNode^.LItem;

          For n:=1 to 2 do
          With CarryFR^ do
            If (CFCode[n]=NCode) then
            With CRepParam^ do

            Begin

              If (Total) then
              Begin
                If (n=2) then
                Begin

                  {GrandTotal(NTotals,CFTotals);

                  Split_Totals(NTotals,NTotals,Off);}

                end
              end
              else
              With LNom do
              Begin


                LResetRec(Fnum);

                If (n=2) then
                Begin
                  Desc:='  B/F - '+CFDesc;

                  GrandTotal(GTotals,CFTotals);
                end;

                Split_Totals(NTotals,CFTotals,(n=1),ReportMode);

                If (Ok2Print) then
                  PrintNomDet(BOff);

                With RepFiler1 do
                  If (LinesLeft<=5) then
                    ThrowNewPage(5);
                  {PrintNomPage;}

              end;


          end; {If Match..With..}

          CurrNode:=GetNext(CurrNode);
        end; {While..}
      end; {With..}

      CRepParam^.NTotals:=TNT;

      LNom:=LNom2;
    end;
  end; {Proc..}




{ ============== Recursive routine to follow nominal structure & Print it ================= }


Procedure TNomReport.FollowChain(LevelKey  :  Str10);


Var
  RecAddr
       :  LongInt;
  LNom2 :  NominalRec;
  LKey :  Str255;

  LPLMode
       :  Byte;


Begin

  LPLMode:=0;

  With MTExLocal^,CRepParam^ do
  Begin
    RecAddr:=0;

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

      LStatus:=LGetPos(Fnum,RecAddr);


      Check4PL(NomCode);


      If (NomType=CarryFlg) and (Not (ReportMode In [8,80])) then
        CarryFwd^.AddItem(NTotals,GTotals,Cat,CarryF,Desc,ReportMode);

      {$B-}


      If (NomType<>CarryFlg) and (IsOktoNom(NomCode)) then
      Begin

      {$B+}

        Inc(ICount);

        LNom2:=LNom;


        Case ReportMode of

          8,80  :  Begin
                     If (NomType<>NomHedCode) then
                     Begin

                       If (IsTBPaL(NomCode,LPLMode)) then
                         PrintNomGap(LPLMode);

                       NomDetail(BOff);  { =========== Print Detail =========== }
                     end
                     else
                       If (JustNDet) then
                         PrintNomGap(1);
                   end;

          else     NomDetail(BOff);  { =========== Print Detail =========== }

        end; {Case..}

        If (NomType=NomHedCode) then
          FollowChain(FullNomKey(NomCode));

        LNom:=LNom2;

        If (Not (ReportMode In [8,80])) then
          NomDetail(BOn);   { ============ Print Bottom =========== }

      end; {Profit..}


      LSetDataRecOfs(Fnum,RecAddr);

      LStatus:=LGetDirect(Fnum,Keypth,0); {* Re-Establish Position *}

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPth,LKey);

      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;
    end; {While..}

    Dec(Level);

  end; {with..}
end; {Proc..}


Procedure TNomReport.RepPrint(Sender  :  TObject);

Var
  LevelKey  :  Str10;

Begin
  ShowStatus(2,'Processing Report.');

  LevelKey:=FullNomKey(0);

  With CRepParam^ do
  Begin
    Case ReportMode of
      1..4,8,10,20,30,80
           :  Begin

                Set_PBFNCC;

                If (ReportMode In [1,8,10,80]) and (PaLS<>0) then
                  Ok2Print:=BOff;


                FollowChain(LevelKey);


                Case ReportMode of

                  8,80  :  Begin
                             BSTotals:=GTotals;

                             PrintNomGap(9);

                           end;

                end; {Case..}


                If ((BSTotals[1]+BSTotals[2]+BSTotals[5]+BSTotals[6])<>0) and (ReportMode In [1,3,4,8,10,30,80]) then
                Begin

                  { === Print Grand Balance Sheet Totals Excluding Carry Fwd Items ==== }

                  PrintTotals(BSTotals,FCr,FTxCr,1);


                end;
              end;
    end; {Case..}

  end; {With..}

  Print_WarnDifference(0.0,0,BOff);

  PrintEndPage;
end;


Function TNomReport.GetReportInput  :  Boolean;

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
    YTDOfSet  :=  5;
    BudgBase  :=  3;

    RFnum:=NomF;
    RKeypath:=0;

    Level:=-1;

    Mode:=ReportMode;


    Fnum:=RFnum; KeyPth:=NomCatK;

    Ok2Print:=BOn;

    Case ReportMode of
      1,8,
      10,80 :  ThTitle:='Trial Balance';

      2,20  :  Begin
                 Ok2Print:=BOff;
                 ThTitle:='Profit & Loss';
               end;
      3,30  :  ThTitle:='Balance Sheet';

      4     :  Begin
                 ThTitle:='S+A of Funds';

                 YTDOfSet  :=  3;
                 BudgBase  :=  5;
                 RepTitle:='Source & Application of Funds';
               end;


    end; {Case..}


    If (ReportMode<>4) then
      RepTitle:=ThTitle;

    PageTitle:=RepTitle;

    If (ReportMode In [2,3,4,20,30]) then
    Begin
      PaLS:=Syss.NomCtrlCodes[PLStart];
      PaLE:=Syss.NomCtrlCodes[PLEnd];
    end;

    NCCMode:=Not EmptyKeyS(NCCDep[BOn],ccKeyLen,BOff);

      {$IFDEF MC_On}

        If (FTxCr<>0) and (FTxCr<>FCr) then
          PageTitle:=CurrDesc(FCr)+'to '+CurrDesc(FTxCr)+PageTitle
        else
          Pagetitle:=CurrDesc(FCr)+PageTitle;

      {$ENDIF}


      Case ReportMode of
        1..3,8
           :  Begin

                {* From this Pr to this Pr *}

                F2YrPr[1,1]:=RYr;
                F2YrPr[1,2]:=RPr;
                F2YrPr[1,3]:=RYr;
                F2YrPr[1,4]:=RPr;


                {* To between last Yr Ytd & Cur Pr & Yr *}

                F2YrPr[2,1]:=AdjYr(RYr,BOff);
                F2YrPr[2,2]:=YTD;
                F2YrPr[2,3]:=RYr;
                F2YrPr[2,4]:=RPr;


                RepTitle2:='For Period '+PPR_OutPr(F2YrPr[1,2],F2YrPr[1,1]);


              end;
        4,
        10,20,30,80
           :  Begin

                {* From Last Yr Ytd & Cur Pr & Yr *}

                F2YrPr[1,1]:=AdjYr(RYr,BOff);
                F2YrPr[1,2]:=YTD;
                F2YrPr[1,3]:=RYr;
                F2YrPr[1,4]:=RPr;

                {* To between Year Before Last YTD & Last Yr same Pr *}

                F2YrPr[2,1]:=AdjYr(F2YrPr[1,1],BOff);
                F2YrPr[2,2]:=YTD;
                F2YrPr[2,3]:=AdjYr(RYr,BOff);
                F2YrPr[2,4]:=RPr;

                Case ReportMode of
                  4  :  RepTitle2:=FullYear(TxlatePYr(F2YrPr[1,3],Bon))+' / '+FullYear(TxlatePYr(F2YrPr[2,3],BOn));
                  else  RepTitle2:='Comparative Year to Date. '+FullYear(TxlatePYr(F2YrPr[1,3],BOn))+
                                ' - '+FullYear(TxlatePYr(F2YrPr[2,3],BOn));
                end; {Case..}

              end;

      end; {case..}


    If (Not EmptyKeyS(NCCDep[NCCMode],ccKeyLen,BOff)) then
    Begin
      CCTitle:='** Not Found **';

      If (Not EmptyKeyS(NCCDep[Not NCCMode],ccKeyLen,BOff)) and (Syss.PostCCDCombo) then
      Begin
        RepTitle2:=RepTitle2+'. For '+Show_CCFilt(CalcCCDepKey(NCCMode,NCCDep),NCCMode);
      end
      else
      Begin
        If (Assigned(MTExLocal)) then
        With MTExLocal^ do
        Begin
          If LGetMainRec(PWrdF,FullCCKey(CostCCode,CSubCode[NCCMode],NCCDep[NCCMode])) then
            CCTitle:=LPassword.CostCtrRec.CCDesc;
        end
        else
        Begin
          GetCCDep(Application.MainForm,NCCDep[NCCMode],FoundCode,NCCMode,-1);
          CCTitle:=Password.CostCtrRec.CCDesc;
        end;

        RepTitle2:=RepTitle2+'. For '+CostCtrRTitle[NCCMode]+' '+NCCDep[NCCMode]+','+CCTitle;
      end;
    end;

    {$IFDEF SOP}

      If (CommitAct) and (CommitMode In [1,2]) then
        RepTitle2:=RepTitle2+'. '+CommitTitle[CommitMode];

    {$ENDIF}


    ROrient:=RPDefine.PoLandscape;


  end; {With..}

  Result:=BOn;
end;





Procedure TNomReport.Finish;


Begin
  Inherited Finish;
end;


{ ======== }



Procedure AddNomRep2Thread(LMode    :  Byte;
                           IRepParam:  NomRepRecPtr;
                           AOwner   :  TObject);



  Begin
    AddTBCCDepReportThread(LMode,IRepParam,AOwner);
  end;

{$IFDEF OLDVERSION}{Pre auto report}

Var
  EntTest  :  ^TNomReport;

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
{$ENDIF}




Initialization

  YTDOfSet:=0;
  BudgBase:=0;


Finalization

end.