Unit InvCt2SU;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 11/01/96                      }
{                                                              }
{           + Invoicing Body Control Support Unit II +         }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface
{$HINTS OFF}

{$I DEFOVR.Inc}

Uses
  GlobVar,
  VARRec2U,
  VarConst,
  MiscU;





Procedure Warn_CostLow(CostP,
                       SellP  :  Real;
                       ProdR  :  StockRec);


Procedure Warn_BadVATCode(VC  :  Char);



{$IFDEF STK}



    Function Get_StkPrice(PBands  :  SaleBandAry;
                          DiscR   :  Real;
                          DiscCh  :  Char;
                          Currency:  Byte;
                          SellU,
                          QtyM    :  Real;
                          UP      :  Boolean)  :  Real;





  Procedure Check_SOPLink(Fnum,
                          KeyPath  :  Integer;
                          FolRef   :  LongInt;
                          DelDate  :  LongDate);

  Procedure Update_SOPOS(Fnum,
                         KeyPath  :  Integer;
                         FolRef   :  LongInt;
                         IdR      :  Idetail;
                         AdjVal   :  Real;
                         UpBal    :  Boolean);

  {$IFNDEF EXDLL}
  Procedure Change_Match(IdR      :  IDetail;
                         Fnum,
                         Keypath  :  Integer;
                         Deduct   :  Boolean);
  {$ENDIF}

  Function Warn_OverDelv(IdR      :  IDetail;
                         SOPFolio :  LongInt;
                         ChkPick,
                         Warn     :  Boolean)  :  Boolean;




  Procedure Check_LowCost(Idr    :  IDetail;
                          InvR   :  InvRec;
                          StockR :  StockRec);



  {$IFNDEF SOP}
  Procedure UpdateCustOrdBal(OI,IR  :  InvRec);
  {$ELSE}
  //PR: 20/06/2012 ABSEXCH-11528 Add extra parameter so that the o/s from the previous transaction can be passed through - can't calculate it
  //here as the lines have already been updated.
  Procedure UpdateCustOrdBal(OI,IR  :  InvRec; PreviousOS : Double = 0);
  {$ENDIF}

{$ENDIF}

  Procedure UpdateOrdBal(UInv   :  InvRec;
                       BalAdj :  Real;
                       CosAdj,
                       NetAdj :  Real;
                       Deduct :  Boolean;
                       Mode   :  Byte);


  {$IFDEF JC}
    {$IFDEF JAP}
      //PR: 21/06/2012 ABSEXCH-11528 Add extra parameter so that the o/s from the previous transaction can be passed through - can't calculate it
      //here as the lines have already been updated.
      Procedure UpdateCustAppBal(OI,IR  :  InvRec; PreviousOS : Double = 0);
    {$ENDIF}
  {$ENDIF}

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Dialogs,
   BTrvU2,
   ETStrU,
   ETMiscU,
   ETDateU,
   BTKeys1U,
   ComnUnit,
   ComnU2,

   InvListU,

   CurrncyU,

   {.$IFDEF SOP}
     {$IFNDEF EXDLL}
     LedgSupU,
     {$ENDIF}

   {.$ENDIF}


   SysU1,
   SysU2,
   BTSupU1,

   {$IFDEF JC}
     {$IFDEF JAP}
       {VarJCstU,}
     {$ENDIF}
     InvLst2U,
   {$ENDIF}

   PWarnU;






{ =================== Message to Warn Reciept Part to be entered manually ============== }

Procedure Warn_CostLow(CostP,
                       SellP  :  Real;
                       ProdR  :  StockRec);

Var
  mbRet  :  Word;

  WMsg   :  String;

Begin
  With ProdR do
  Begin

    WMsg:=' - WARNING! Selling Price too Low! - '+#13+
                      Strip('B',[#32],StockCode)+','+Strip('B',[#32],Desc[1]);

    If (ChkAllowed_In(143)) then
      WMsg:=WMsg+#13+'Cost Price : '+Form_Real(CostP,0,2)+' Sell Price : '+Form_Real(SellP,0,2);

    mbRet:=MessageDlg(WMsg,mtWarning,[mbOk],0);

  end; {With..}

end;


{ =================== Message to Warn Reciept Part to be entered manually ============== }

Procedure Warn_BadVATCode(VC  :  Char);

Var
  mbRet  :  Word;

Begin
  Begin

    mbRet:=MessageDlg(' - WARNING! - '+#13+CCVATName^+' Code '+VC+' is not valid.',mtWarning,[mbOk],0);

  end; {With..}

end;




{$IFDEF STK}


  { ==== Function to Return Correct Stock Selling Price based on band ==== }

  { Note: Duplicated in SalePric.Pas for OLE Server }
  Function Get_StkPrice(PBands  :  SaleBandAry;
                        DiscR   :  Real;
                        DiscCh  :  Char;
                        Currency:  Byte;
                        SellU,
                        QtyM    :  Real;
                        UP      :  Boolean)  :  Real;



  Var
    Rnum  :  Real;
    FCurr :  Byte;


  Begin

    Rnum:=0;

    FCurr:=0;

    If (DiscCh In StkBandSet) then
    With PBands[Succ(Ord(DiscCh)-Ord('A'))] do
    Begin
      Rnum:=SalesPrice;
      FCurr:=Currency;
    end
    else
    Begin
      Rnum:=PBands[1].SalesPrice;
      FCurr:=PBands[1].Currency;
    end;


    Rnum:=Calc_IdQty(Calc_StkCP(Currency_ConvFT(Rnum,FCurr,Currency,UseCoDayRate),SellU,UP),QtyM,Not UP);

    Rnum:=Round_Up(Rnum,Syss.NoNetDec);


    Get_StkPrice:=Rnum;

  end; {Func..}



  { ======== Procedure to Update header part of SOP Link ======= }


  Procedure Check_SOPLink(Fnum,
                          KeyPath  :  Integer;
                          FolRef   :  LongInt;
                          DelDate  :  LongDate);



  Var
    KeyS    :  Str255;
    Locked  :  Boolean;

    LAddr,
    RecAddr :  LongInt;

    TmpInv  :  ^InvRec;



  Begin

    RecAddr:=0;

    New(TmpInv);

    TmpInv^:=Inv;

    Locked:=BOff;

    KeyS:=FullNomKey(FolRef);

    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    With Inv do
    Begin

      If (RunNo=Set_OrdRunNo(InvDocHed,BOff,BOn)) then {* Its posted *}
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin
          RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);

          If (DelDate<DueDate) then
            DueDate:=DelDate;

          BatchLink:=QUO_DelDate(InvDocHed,DueDate);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end; {If Locked..}

      end; {If Order Posted..}

    end; {If Header found..}

    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end; {Proc..}



  { ======== Procedure to Update header part of SOP Link with Order Value ======= }


  Procedure Update_SOPOS(Fnum,
                         KeyPath  :  Integer;
                         FolRef   :  LongInt;
                         IdR      :  Idetail;
                         AdjVal   :  Real;
                         UpBal    :  Boolean);



  Var
    UOR     :  Byte;
    KeyS    :  Str255;
    Locked  :  Boolean;
    LAddr,
    RecAddr :  LongInt;
    TmpInv  :  ^InvRec;



  Begin

    RecAddr:=0; UOR:=0;

    New(TmpInv);

    TmpInv^:=Inv;

    Locked:=BOff;

    KeyS:=FullNomKey(FolRef);

    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve DocPosn *}

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    With Inv do
    Begin

      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

      If (Ok) and (Locked) then
      Begin
        TotOrdOS:=TotOrdOS-Round_Up(AdjVal,2);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        If (StatusOk) then
        Begin
          {$IFDEF JC}

            If (JBCostOn) and (IdR.KitLink=0) then
            Begin
              Update_JobAct(IdR,Inv);

            end;

          {$ENDIF}

          If (UpBal) then
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

            UpdateOrdBal(Inv,(Round_Up(Conv_TCurr(AdjVal,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                         DocCnst[InvDocHed]*DocNotCnst),
                         0,0,
                         BOn,0);
          end;
        end;

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      end; {If Locked..}

    end; {If Header found..}

    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr<>0) then
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end; {Proc..}



  { ======== Procedure to Alter matched value on a SOP Link ======= }
  {$IFNDEF EXDLL}
  Procedure Change_Match(IdR      :  IDetail;
                         Fnum,
                         Keypath  :  Integer;
                         Deduct   :  Boolean);




  Var
    UOR       :  Byte;
    TmpInv    :  ^InvRec;
    MatchVal  :  Real;



  Begin

    New(TmpInv);

    TmpInv^:=Inv;

    MatchVal:=InvLTotal(IdR,BOn,(Inv.DiscSetl*Ord(Inv.DiscTaken)));


    If (CheckRecExsists(FullNomKey(IdR.SOPLInk),Fnum,KeyPath)) then
    Begin
      UOR:=fxUseORate(UseCODayRate,BOn,IdR.CXRate,IdR.UseORate,IdR.Currency,0);

      Update_MatchPay(TmpInv^.OurRef,Inv.OurRef,
                      Round_Up(Conv_TCurr(MatchVal,XRate(IdR.CXRate,BOff,IdR.Currency),IdR.Currency,UOR,BOff),2),
                      MatchVal,Deduct,DocMatchTyp[BOn]);

    end;

    Inv:=TmpInv^;

    Dispose(TmpInv);

  end;
  {$ENDIF}

  { ======== Function to Warn of Over Delivery ======= }

  Function Warn_OverDelv(IdR      :  IDetail;
                         SOPFolio :  LongInt;
                         ChkPick,
                         Warn     :  Boolean)  :  Boolean;


  Const
    Fnum     =  InvF;
    Keypath  =  InvFolioK;

    DelStr   :  Array[BOff..BOn] of Str20 = ('delivered','issued');


  Var
    TmpBO  :  Boolean;
    MesStr :  Str80;

    TmpInv :  ^InvRec;

    mbRet  :  Word;

    Tc     :  Char;

    OverA  :  Real;


  Begin

    Tc:=ResetKey;

    MesStr:='';

    New(TmpInv);

    TmpInv^:=Inv;

    With IdR do
    Begin



      If (ChkPick) then
      Begin
        If (IdDocHed = WOR) then
          OverA:=Round_Up(Qty_Os(IdR)-QtyPick,Syss.NoQtyDec)
        else
          OverA:=Round_Up(Qty_Os(IdR)-(QtyPick+QtyPWOff),Syss.NoQtyDec);
      end
      else
        OverA:=Qty_Os(IdR);


      TmpBo:=(OverA<0);

      If (Warn) and (TmpBo) then
      Begin

        MesStr:='Item : '+StockCode;

        If (SOPFolio<>0) then
        Begin

          If (CheckRecExsists(FullNomKey(SOPFolio),Fnum,KeyPath)) then
            MesStr:='Order : '+Inv.OurRef+', Item : '+StockCode;

        end;


        mbRet:=MessageDlg(' - WARNING! - '+#13+
                          Strip('B',[#32],MesStr)+#13+
                          'has been over '+delStr[IdDoched=WOR]+' by '+Form_Real((OverA*-1),0,Syss.NoQtyDec)
                          ,mtWarning,[mbOk],0);

      end; {If Warn..}

    end; {With..}

    Inv:=TmpInv^;

    Dispose(TmpInv);

    Warn_OverDelv:=TmpBo;

  end; {Func..}








  Procedure Check_LowCost(Idr    :  IDetail;
                          InvR   :  InvRec;
                          StockR :  StockRec);

  Var
    LineSell,
    LineCost  :  Real;

  Begin

    LineSell:=InvLTotal(IdR,BOn,(InvR.DiscSetl*Ord(InvR.DiscTaken)));
    LineCost:=InvLCost(Idr);

    If (LineSell<LineCost) then
      Warn_CostLow(DivWChk(LineCost,Idr.Qty),
                   DivWChk(LineSell,Idr.Qty),
                   StockR);

  end;



  { ============== Procedure to update acc Order balance based on previois invoice ============= }
  {$IFNDEF SOP}
  Procedure UpdateCustOrdBal(OI,IR  :  InvRec);

  Var
    UOR  :  Byte;

  Begin
    With OI do
    Begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      UpdateOrdBal(OI,(Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                       DocCnst[InvDocHed]*DocNotCnst),
                   0,0,
                   BOn,0);
    end;

    With IR do
    Begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      UpdateOrdBal(IR,(Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                   DocCnst[InvDocHed]*DocNotCnst),
                   0,0,
                   BOff,0);
    end;

  end;

  {$ELSE}
  //PR: 20/06/2012 ABSEXCH-11528 Add extra parameter so that the o/s from the previous transaction can be passed through - can't calculate it
  //here as the lines have already been updated.
  Procedure UpdateCustOrdBal(OI,IR  :  InvRec; PreviousOS : Double = 0);

  Var
    UOR  :  Byte;

  Begin
    With OI do
    Begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      //PR: 20/06/2012 ABSEXCH-11528 Changed to use correct o/s depending on system setup flag. Value is passed through from Saletx2U if we're editting
      //overwise OI is blank and PreviousOS is 0 anyway
      UpdateOrdBal(OI, PreviousOS *
                   DocCnst[InvDocHed]*DocNotCnst,
                   0,0,
                   BOn,0);
    end;

    With IR do
    Begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      //PR: 20/06/2012 Changed to use correct o/s depending on system setup flag ABSEXCH-11528
      UpdateOrdBal(IR, TransOSValue(Inv) *
                   DocCnst[InvDocHed]*DocNotCnst,
                   0,0,
                   BOff,0);
    end;

  end;
   {$ENDIF SOP}
{$ENDIF}




    { ======= Procedure to update the Account Balances with Order details =========== }
{ Replicated inside ExbtTh1U for thread safe operation }

Procedure UpdateOrdBal(UInv   :  InvRec;
                       BalAdj :  Real;
                       CosAdj,
                       NetAdj :  Real;
                       Deduct :  Boolean;
                       Mode   :  Byte);

Const
   Fnum   =   CustF;


{*  Mode definitions  *}

{   1 - Update Only     U }

Var
  FCust  :  Str255;
  Cnst   :  Integer;
  PBal   :  Double;
  CrDr   :  DrCrType;
  StartCode
         :  Char;

  LOk,
  LoopComplete,
  Locked :  Boolean;

  TmpKPath,
  TmpStat:  Integer;

  TmpRecAddr,
  LoopCounter
         :  LongInt;
  OrigCCode,
  HOCCode:  Str10;

  LocalCust
         :  CustRec;


Begin
  With UInv do
  If (InvDocHed In PSOPSet+JAPOrdSplit) or (Mode=1) then
  Begin
    LoopCounter:=0; OrigCCode:=FullCustCode(UInv.CustCode); HOCCode:=NdxWeight;

    LocalCust:=Cust;  LOk:=BOff;

    Blank(CrDr,Sizeof(CrDr));  PBal:=0;

    StartCode:=CustHistCde;

    FCust:=FullCustCode(CustCode);

    If (Not EmptyKey(FCust,CustKeyLen)) then
    Begin
      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);



      If (Deduct) then
      Begin
        Cnst:=-1;
        BalAdj:=BalAdj*Cnst;

        CosAdj:=CosAdj*Cnst;

        NetAdj:=NetAdj*Cnst;
      end
      else
        Cnst:=1;

      Repeat
        LoopComplete:=BOn;

        If (LoopCounter=1) then
          HOCCode:=FCust;

        Inc(LoopCounter);



        Post_To_Hist(StartCode,FCust,0,0,BalAdj,0,AcYr,AcPr,PBal);

        Post_To_CYTDHist(StartCode,FCust,0,0,BalAdj,0,AcYr,YTD);

        If (Cust.CustCode<>FCust) then
          LOk:=Global_GetMainRec(CustF,FCust)
        else
          LOK:=BOn;

        If (LOK) and (Not EmptyKey(Cust.SOPInvCode,CustKeyLen)) then
        Begin
          FCust:=FullCustCode(Cust.SOPInvCode);

          LOk:=Global_GetMainRec(CustF,FCust);

          LoopComplete:=(Not LOK) or (Cust.SOPConsHO<>1);

        end;



      Until (LoopComplete) or (FCust=OrigCCode) or (FCust=HOCCode);

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Cust:=LocalCust;


    end; {If Blank Cust..}
  end; {With..}
end;

    {$IFDEF JC}
      {$IFDEF JAP}

        { ============== Procedure to update acc Order balance based on previois invoice ============= }

        Procedure UpdateCustAppBal(OI,IR  :  InvRec; PreviousOS : Double = 0);

        Var
          Dnum :  Double;
          UOR  :  Byte;

        Begin
          With OI do
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

            //Dnum:=TotalCost-TotalOrdered;

            UpdateOrdBal(OI,PreviousOS*
                             DocCnst[InvDocHed]*DocNotCnst,
                         0,0,
                         BOn,0);
          end;

          With IR do
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

//            Dnum:=TotalCost-TotalOrdered;

            UpdateOrdBal(IR,JAPTransOSValue(IR)*
                         DocCnst[InvDocHed]*DocNotCnst,
                         0,0,
                         BOff,0);
          end;

        end;
      {$ENDIF}
    {$ENDIF}

end.