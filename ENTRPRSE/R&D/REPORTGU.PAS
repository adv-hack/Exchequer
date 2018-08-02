unit ReportGU;


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TSShortReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       SCust     :  CustRec;
                       CCPW      :  Array[BOff..BOn] of PassWordRec;
                       SLocTit   :  Str80;

                       CurrMode  :  Byte;


                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintDueTot(Gtot      :  Boolean);

                       Procedure CalcStkTotals(LTot      :  AgedTyp);

                       Function Compare_Dates(ToDate,DlDate  :  LongDate;
                                              DrvMode        :  Byte)  :  LongInt;

                       Procedure Get_StockAged(Var  StockPos  :  AgedTyp;
                                                    Idr       :  IDetail;
                                                    DlDate    :  LongDate;
                                                    DrvMode   :  Byte);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure RepeatReport;



                     public

                       CRepParam  :  ShortRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddSShortRep2Thread(LMode    :  Byte;
                              IRepParam:  ShortRepPtr;
                              AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  RpDefine,
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
  ExThrd2U;


{ ========== TSShortReport methods =========== }

Constructor TSShortReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  CurrMode:=1;

end;


Destructor TSShortReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TSShortReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1,2
          :  Begin
              SetTab (MarginLeft, pjLeft, 33, 4, 0, 0);
              SetTab (NA, pjLeft, 60, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 22, 4, 0, 0);
              SetTab (NA, pjRight, 22, 4, 0, 0);
              SetTab (NA, pjRight, 22, 4, 0, 0);
              SetTab (NA, pjRight, 22, 4, 0, 0);
              SetTab (NA, pjRight, 22, 4, 0, 0);
              SetTab (NA, pjRight, 22, 4, 0, 0);
              SetTab (NA, pjRight, 22, 4, 0, 0);
            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;







Procedure TSShortReport.RepPrintPageHeader;

Const
  AllocDesc  :  Array[1..3] of String[10] = ('Day','Week','Month');

Var
  n      :  Byte;
  DPlu,
  DPlus  :  Str5;

  GenStr :  Str255;


Begin
  DPlu:=' ';

  DPlus:=' ';


  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1,2
          :  Begin
               SendText(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'In',' ','Stk'));

               If (ReportMode=1) and (QuoMode=3) then {We are showing shortages against WOR allocations}
                 SendText(Concat(ConstStr(#9,4),'Alloc WOR'))
               else
                 SendText(Concat(ConstStr(#9,4),'Alloc SOR'));

              For n:=1 to 5 do
              Begin
                If (n>1) then
                  DPlu:='s';

                If (n=5) then
                  DPlus:='+';

                GenStr:=Form_Int(n,0)+' '+AllocDesc[AgeMode]+DPlu+DPlus;

                SendText(Concat(ConstStr(#9,4+n),GenStr));

              end;

              SendLine(Concat(ConstStr(#9,10),'On Order'));
            end;


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TSShortReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);


end;




{ ======================= Calculate Due Totals ==================== }

Procedure TSShortReport.CalcStkTotals(LTot      :  AgedTyp);

Var
  n          :  Byte;

Begin


  With CRepParam^ do
    Case ReportMode of

        1..2
           :  Begin
                For n:=1 to 8 do
                  StkTot[n]:=StkTot[n]+LTot[n];
              end;

    end; {Case..With..}
end;


Procedure TSShortReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      1..2  :  SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,0);

    end; {Case..}
  end; {With..}
end;


{ ======================= Due Sub / Grand Total ================ }

Procedure TSShortReport.PrintDueTot(Gtot      :  Boolean);

Var
  n          :  Byte;
  Rnum       :  Real;
  PostTotMsg :  Str80;

Begin

  PostTotMsg:='';

  With MTExLocal^, CRepParam^, RepFiler1 do
  Case ReportMode of

     1..2
         :  Begin
              If (Not Gtot) then
              Begin

                LGetMainRec(StockF,LastStk);

                {$IFDEF SOP}
                  LStock_LocSubst(LStock,LocFilt);

                {$ENDIF}


                SetReportDrillDown(0);

                StKTot[1]:=LStock.QtyInStock;

                If (ReportMode=1) and (QuoMode=3) then {We are showing shortages against WOR allocations}
                  StKTot[2]:=WOPAllocStock(LStock)
                else
                  StKTot[2]:=AllocStock(LStock);

                StKTot[8]:=LStock.QtyOnOrder;

                SendText(ConCat(#9,LStock.StockCode,
                         #9,LStock.Desc[1],
                         #9,FormatFloat(GenQtyMask,STKTot[1]),
                         #9,FormatFloat(GenQtyMask,STKTot[2])));

              end
              else
              Begin

                SendText(ConstStr(#9,4));


              end;


              For n:=3 to 8 do
                SendText(Concat(ConstStr(#9,n+2),FormatFloat(GenQtyMask,STKTot[n])));

              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;


              Blank(STKTot,Sizeof(StkTot));

            end; {Case..}


    end; {Case..With..}

end;


{ ======= Function to Return Stock Aged ======= }


Function TSShortReport.Compare_Dates(ToDate,DlDate  :  LongDate;
                                     DrvMode        :  Byte)  :  LongInt;


Var
  Res  :  LongInt;


Begin
  Res:=0;

  Case DrvMode of

    1  :  Res:=NoDays(Todate,DlDate);

    2  :  Res:=Round(DivwChk(NoDays(ToDate,DlDate),7));

    else
          Res:=MonthDiff(ToDate,DlDate);

  end;

  If (Res<0) then
    Res:=0;

  Compare_Dates:=Res;

end; {Func..}



{ ======= Proc to Age Stock Anal ====== }

Procedure TSShortReport.Get_StockAged(Var  StockPos  :  AgedTyp;
                                           Idr       :  IDetail;
                                           DlDate    :  LongDate;
                                           DrvMode   :  Byte);

Var
  Anal    :  LongInt;

  TotQty  :  Real;

  ChkDate :  Str8;


Begin

  Blank(StockPos,Sizeof(StockPos));

  With Idr do
  Begin

    ChkDate:=Today;

    Anal:=Compare_Dates(ChkDate,DlDate,DrvMode);

    TotQty:=Qty_OS(Idr);

    If (IdDocHed<>WOR) then
      TotQty:=TotQty*QtyMul;


    If (Anal>=0) and (Anal<=1) then
      StockPos[1]:=TotQty
    else
      If (Anal>=2) and (Anal<=4) then
        StockPos[Anal]:=TotQty
      else
        StockPos[5]:=TotQty;

  end; {with..}

end; {Proc..}



{ ======================= Customer End ======================= }


Procedure TSShortReport.PrintEndPage;
Var

  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  With RepFiler1 do
  Begin

    PrintDueTot(BOff);

  end;

  Inherited PrintEndPage;

  If (((Syss.QUAllocFlg) and (CurrMode<=2)) or ((WOPOn) and (CurrMode<=3))) and (ChkRepAbort) then
  With RepFiler1 do
  Begin
    RepeatReport;

    Begin

      ThrowNewPage(-1);

      RepPrint(Nil);
    end;
  end;
end;



{ ======================= Customer Line ======================= }


Procedure TSShortReport.PrintReportLine;

Var
  Rnum,
  Rnum2      :  Real;

  n          :  Byte;

  LineTot,
  StockPos   :  AgedTyp;

  TBo        :  Boolean;

  DelDate    :  LongDate;


Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Rnum:=0;

    Rnum2:=0;

    Blank(LineTot,Sizeof(LineTot));

    Case ReportMode of


         1..2
                 :  With LId do
                    If (StockCode<>LastStk) then
                    Begin
                      If (LastStk<>'') then
                        PrintDueTot(BOff);

                      LastStk:=StockCode;
                    end;


     end; {Case..}

     With LId do
     Begin

       Case QUOMode of
         1  :  DelDate:=LId.PDate;
         else  DelDate:=LInv.DueDate;
       end; {Case..}

       Get_StockAged(StockPos,LId,DelDate,AgeMode);

       for n:=1 to 5 do
         LineTot[n+2]:=StockPos[n];


     end; {With..}



     CalcStkTotals(LineTot);


  end; {With..}
end;






{ ======================= Customer Include ======================= }


Function TSShortReport.IncludeRecord  :  Boolean;

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


  If (ReportMode In [1..3]) then
  With MTExLocal^, CRepParam^ do
  Begin

    LResetRec(Fnum);

    KeyCS:=FullNomKey(LId.FolioRef);

    If (LId.FolioRef<>0) then
      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyCS);

    LGetMainRec(StockF,LId.StockCode);


    Case ReportMode of

      1..3
           :  With LId  do
              Begin

                TmpInclude:=((Not EmptyKey(LStock.StockCode,StkKeyLen))
                             and ((RCr=Currency) or (RCr=0))
                             and ((LInv.CustCode=CustFilt) or (CustFilt=''))
                             and (Qty_Os(LId)<>0)
                             and ((ReportMode<>1) or (ABSLineNo>1) or (IdDocHed<>WOR)) {Sales mode, we want WOR component lines}
                             and ((ReportMode<>2) or (ABSLineNo=1) or (IdDocHed<>WOR)) {Purch modem we want the WOR build line only}
                             and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)));


                If (TmpInclude) then
                Begin


                  {$IFDEF PF_On}

                    For TBo:=BOff to BOn do
                      TmpInclude:=(TmpInclude
                                   and (CheckKey(RCCDep[TBo],CCDep[TBo],Length(RCCDep[TBo]),BOff)));

                  {$ENDIF}

                end;


              end;

    end; {Case..}
  end; {With..}
  
  Result:=TmpInclude;

end; {Func..}






Function TSShortReport.GetReportInput  :  Boolean;

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

    RFont.Size:=8;
    ROrient:=RPDefine.PoLandscape;


    Case ReportMode of

       1
            :   Begin
                  ThTitle:='Shortages Report';

                  RepTitle:='Stock Shortages Report';


                  {$IFDEF MC_On}

                    PageTitle:=CurrDesc(RCr)+RepTitle;

                  {$ELSE}

                    PageTitle:=RepTitle;

                  {$ENDIF}


                end;
       2
            :   Begin
                  ThTitle:='Stk Delv Report';

                  RepTitle:='Expected Stock Delivery Report';


                  {$IFDEF MC_On}

                    PageTitle:=CurrDesc(RCr)+RepTitle;

                  {$ELSE}

                    PageTitle:=RepTitle;

                  {$ENDIF}


                end;


    end; {Case..}

    If (Not EmptyKey(CustFilt,CustKeyLen)) then
    Begin
      GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOn,-1);
      SCust:=Cust;
    end;

   {$IFDEF PF_On}
     For BoLoop:=BOff to BOn do
       If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
       Begin
         FoundCode:=RCCDep[BoLoop];

         GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

         CCPW[BoLoop]:=PassWord;

       end; {Loop..}


   {$ENDIF}

    {$IFDEF SOP}
      If (Not EmptyKey(LocFilt,LocKeyLen)) then
      Begin
        SLocTit:=MLocRepTitle(LocFilt);
      end;
    {$ENDIF}


  end; {With..}

  Result:=BOn;
end;



Procedure TSShortReport.RepeatReport;

Const
  ModeDoc  :  Array[1..2,1..3] of DocTypes = ((SOR,SQU,WOR),
                                              (POR,PQU,WOR));
Var
  BoLoop  :  Boolean;

Begin
  With CRepParam^ do
  Begin
    If (CurrMode=2) and (Not Syss.QUAllocFlg) then {Jump staright to WOP}
      CurrMode:=3;

    QUOMode:=CurrMode;

    LastStk:='';

    RepTitle2:='';

    If (CustFilt<>'') then
      RepTitle2:='For '+Strip('B',[#32],SCust.Company);


    {$IFDEF PF_On}
     For BoLoop:=BOff to BOn do
       If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
       Begin
         If (RepTitle2<>'') then
           RepTitle2:=RepTitle2+', ';

         RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+CCPW[BoLoop].CostCtrRec.CCDesc;

       end; {Loop..}


   {$ENDIF}

    RepTitle2:='('+DocNames[ModeDoc[ReportMode,CurrMode]]+').'+RepTitle2;

    If (SLocTit<>'') then
      RepTitle2:=RepTitle2+' '+SLocTit+'.';


    ICount:=0;

    RFnum:=IDetailF;

    RKeyPath:=IdAnalK;

    RepKey:=StkLineType[ModeDoc[ReportMode,CurrMode]];

  end;

  Inc(CurrMode);

end;


Procedure TSShortReport.Process;


Begin
  RepeatReport;


  Inherited Process;

end;


Procedure TSShortReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddSShortRep2Thread(LMode    :  Byte;
                              IRepParam:  ShortRepPtr;
                              AOwner   :  TObject);


Var
  EntTest  :  ^TSShortReport;

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