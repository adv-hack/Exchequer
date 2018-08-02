Unit Fifolu_O;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 24/01/94                      }
{                                                              }
{               FIFO List Management Control Unit              }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     VarCnst3;




  Procedure FIFO_Control(Var IdR     :  IDetail;
                         Var StockR  :  StockRec;
                             QtyCr   :  Real;
                             Mode    :  Byte;
                             Deduct  :  Boolean);


  Function FIFO_GetCost(StockR  :  StockRec;
                        FCurr   :  Byte;
                        QtyCr,
                        QtyM    :  Real)  :  Real;

  Function FIFO_GetAVCost(StockR  :  StockRec)  :  Real;

  Procedure FIFO_AvgVal(Var  StockR  :  StockRec;
                             IdR     :  IDetail;
                             QtyUsed :  Real);

  Procedure FIFO_SERUp(Var StockR  :  StockRec);

  Function FIFO_AvSNO(Var StockR  :  StockRec)  :  Real;

  Procedure FIFO_Edit(Var IdR    :  IDetail;
                      Var QtyCr  :  Real;
                          QtyDed :  Real;
                          Fnum,
                          Keypath:  Integer;
                          Mode   :  Byte;
                          GoNeg,
                          DelZero:  Boolean);

  Function FIFO_SetCPrice(IdR  :  IDetail)  :  Real;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
 {$IFDEF WIN32}
   BtrvU2,
   BTSupU1,
   SysU2,
   ComnU2,
   CurrncyU,
   BtKeys1U,
 {$ELSE}
   BtrvU16,
   BtSup1,
   BtSup2,
 {$ENDIF}
   ETStrU,
   ETMiscU;


{ ========= Function to Return Cost valuation ======== }

Function FIFO_SetCPrice(IdR  :  IDetail)  :  Real;

Var
  Rnum  :  Real;

Begin

  If (IdR.IdDocHed In SalesSplit+[ADJ]) then
    FIFO_SetCPrice:=IdR.CostPrice
  else
  With IdR do
  Begin

    Rnum:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);

    FIFO_SetCPrice:=Round_Up(DivWChk(Round_Up((NetValue+CostPrice),Syss.NoCosDec)-Rnum,QtyMul),Syss.NoCosDec);

  end;

end; {Func..}




{ ========= Procedure to Set Id details ========= }


Procedure FIFO_SetId(     IdR   :  IDetail;
                     Var  TMisc :  MiscRec);

Var
  Rnum  :  Real;


Begin

  Rnum:=0;

  With TMisc.FIFORec do
  Begin

    FIFODate:=Idr.PDate;


    FIFOCurr:=IdR.Currency;


    FIFOCost:=FIFO_SetCPrice(IdR);

    FIFOCust:=IdR.CustCode;

    FIFOCode:=MakeFIKey(StkFolio,FIFODate);

  end; {With..}

end; {Proc..}



{ ========= Procedure to Add New FIFO Entry ======== }

Procedure FIFO_Add(IdR     :  IDetail;
                   QtyCr,
                   UCost   :  Real;
                   SFolio  :  LongInt;
                   DocNo   :  Str10;
                   Deduct  :  Boolean;
                   Fnum,
                   Keypath :  Integer;
                   FMode   :  Byte);



Var
  Rnum  :  Real;

Begin

  Rnum:=0;

  ResetRec(Fnum);

  MiscRecs^.RecMfix:=MFIFOCode;
  MiscRecs^.Subtype:=MFIFOSub;

  With MiscRecs^.FIFORec do
  Begin

    StkFolio:=SFolio;

    DocRef:=DocNo;

    DocABSNo:=IdR.ABSLineNo;

    FIFO_SetId(IdR,MiscRecs^);

    If (Not Deduct) then
    Begin

      Case FMode of

        2  :  FIFODate:='800101';

        3  :  FIFODate:='991201';

      end; {Case..}

      FIFOCode:=MakeFIKey(StkFolio,FIFODate);

    end; {Mode..}


    If (FIFOCost=0) and (IdR.LineNo=StkLineNo) then {* if BOM line substitute current cost *}
      FIFOCost:=UCost;

    FIFOQty:=QtyCr;

    QtyLeft:=QtyCr;

    DocFolioK:=MakeFIDocKey(DocRef,SFolio,DocABSNo);

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    {Report_BError(Fnum,Status);}

  end; {With..}

end; {Proc..}




{ ======= Procedure to Edit a FIFO record, with autodelete ====== }


Procedure FIFO_Edit(Var IdR    :  IDetail;
                    Var QtyCr  :  Real;
                        QtyDed :  Real;
                        Fnum,
                        Keypath:  Integer;
                        Mode   :  Byte;
                        GoNeg,
                        DelZero:  Boolean);

Var
  Locked  :  Boolean;
  QtyUsed :  Real;
  KeyF    :  Str255;


Begin

  Locked:=BOff;

  {$IFDEF WIN32}
    If (GetMultiRec(B_GetDirect,B_SingLock,KeyF,KeyPath,Fnum,BOn,Locked)) then
     Status:=0;
  {$ELSE}
    Status:=(GetMultiRec(B_GetDirect,B_SingLock,KeyF,KeyPath,Fnum,BOn,Locked));
  {$ENDIF}

  If (StatusOk) and (GlobLocked) then
  With MiscRecs^.FIFORec do
  Begin

    QtyUsed:=QtyCr;

    QtyLeft:=QtyLeft+QtyCr;

    If (QtyLeft<0) and (Not GoNeg) then
    Begin
      QtyCr:=QtyLeft;
      QtyLeft:=0;
    end
    else
      QtyCr:=0;

    If (QtyLeft<>0) and (Mode=1) then
    Begin
      FIFO_SetId(IdR,MiscRecs^);


    end;

    If ((Mode=1) and (IdR.IdDocHed In StkAdjSplit) and (IdR.LineNo=StkLineNo)) then {* Update Stk deduct from FIFORec *}
      IdR.CostPrice:=FIFOCost;

    FIFOQty:=FIFOQty+QtyDed;


    If (Mode In [0..1]) then
    Begin
      If (Round_Up(QtyLeft,Syss.NoQtyDec)<>0) or (Not DelZero) then
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath)
      else
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);


      {Report_BError(Fnum,Status);}

    end
    else
      Status:=Find_Rec(B_Unlock,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyF);

  end; {If Locked..}

end; {Proc..}


{ ======== Procedure to Scan FIFO and Process / Return Cost Price ======= }

Procedure FIFO_SQL(StockR  :  StockRec;
               Var QtyCr,
                   CPrice  :  Real;
                   Fnum,
                   Keypath :  Integer;
                   Mode,
                   FMode   :  Byte);




Var
  AVQty,
  AVPrice,
  AVCalc,
  TmpQty,
  QtyUsed,
  QtyNeed    :  Real;

  KeyS,
  KeyChk     :  Str255;

  TmpId      :  IDetail;

  B_Start,
  B_Func     :  Integer;


  Begin

    AVQty:=0; AVPrice:=0;  AVCalc:=0;

    QtyUsed:=QtyCr;

    QtyNeed:=QtyCr*DocNotCnst;

    TmpQty:=0;

    Blank(TmpId,Sizeof(TmpId));

    B_Start:=B_GetGEq;

    B_Func:=B_GetNext;

    Case Mode of

      0..2
           :  Begin

                KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockR.StockFolio));

                KeyS:=KeyChk;

                If (FMode=3) then {* Its LIFO *}
                Begin

                  KeyS:=KeyS+NdxWeight;

                  B_Start:=B_GetLessEq;
                  B_Func:=B_GetPrev;

                end;

                Status:=Find_Rec(B_Start,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

                While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (QtyUsed<>0) do
                With MiscRecs^.FIFORec do
                Begin


                  {* Average Calculations... Only use +ve FIFO Lines *}


                  If (Mode=2) then
                    TmpQty:=QtyLeft
                  else
                  Begin
                    If (QtyLeft>0) then
                      TmpQty:=QtyLeft
                    else
                      TmpQty:=0;

                    If (TmpQty>(QtyUsed*DocNotCnst)) then
                      TmpQty:=(QtyLeft-(QtyLeft-(QtyUsed*DocNotCnst)));
                  end;


                  AvQty:=AvQty+TmpQty;

                  {* Convert currency *}

                  AvCalc:=(TmpQty*Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseCoDayRate));

                  AvPrice:=AvPrice+AvCalc;

                  Case Mode of

                    0  :  FIFO_Edit(TmpId,QtyUsed,0,Fnum,Keypath,Mode,BOff,BOn);
                    1  :  Begin

                            QtyUsed:=QtyUsed+QtyLeft;

                            If (QtyUsed>0) then
                              QtyUsed:=0;
                          end;
                  end;

                  If (QtyUsed<>0) then
                    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

                end; {While..}

                Case Mode of

                  2  :  CPrice:=Round_Up(DivWChk(AvPrice,AvQty),Syss.NoCosDec);

                  else  Begin

                          AvCalc:=QtyNeed;

                          If (QtyNeed>AVQty) then
                            AVPrice:=AVPrice+((QtyNeed-AVQty)*CPrice)
                          else
                            If (QtyNeed<AVQty) then
                              AvCalc:=AvQty;

                          CPrice:=Round_Up(DivWChk(AvPrice,AvCalc),Syss.NoCosDec);
                        end;

                end;{case..}
              end;

    end; {Case..}

    QtyCr:=QtyUsed;

  end; {Proc..}


  { ======= Procedure to Control FIFO Update ======= }

  Procedure FIFO_Control(Var IdR     :  IDetail;
                         Var StockR  :  StockRec;
                             QtyCr   :  Real;
                             Mode    :  Byte;
                             Deduct  :  Boolean);





  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;



  Var
    FMode    :  Byte;
    TmpKPath,
    TmpStat  :  Integer;

    RecAddr,
    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;
    TmpInv   :  InvRec;

    DocNo    :  Str10;
    IncFIFO,
    UpdateStk:  Boolean;
    QtyUsed,
    Rnum,
    StkUCost,
    LastCP   :  Real;
    KeyS,
    KeyChk   :  Str255;


  Begin

    DocNo:='';
    TmpMisc:=MiscRecs^;

    IncFIFO:=(QtyCr>=0);

    RecAddr:=0;

    TmpInv:=Inv;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOff,BOff);

    QtyUsed:=0;  Rnum:=0;

    LastCP:=0;

    Status:=GetPos(F[Fnum],Fnum,RecAddr);

    FMode:=FIFO_Mode(StockR.StkValType);

    If (StatusOk) or (RecAddr=0) then
    Begin
      If (Inv.FolioNum<>IdR.FolioRef) then
      Begin
        If (CheckRecExsists(Strip('B',[#0],FullNomKey(IdR.FolioRef)),InvF,InvFolioK)) then
          DocNo:=Inv.OurRef;
      end
      else
        DocNo:=Inv.OurRef;

      QtyUsed:=QtyCr;

      {* Convert current stock price to line currency *}

      StkUCost:=Currency_ConvFT(DivWChk(StockR.CostPrice,StockR.BuyUnit),StockR.PCurrency,IdR.Currency,UseCoDayRate);

      {* Calculate currenct Unit cost *}

      LastCP:=Round_up(DivWChk(StockR.CostPrice,StockR.BuyUnit),Syss.NoCosDec);

      If (IdR.IdDocHed In SalesSplit+StkAdjSplit) and (Not IncFIFO) then
      Begin
        KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],MakeFIDocKey(DocNo,StockR.StockFolio,IdR.ABSLineNo)));
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,MiscNdxK,KeyS);

        Ok:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)));

        If (Ok) then
          FIFO_Edit(IdR,QtyUsed,QtyCr,Fnum,MiscNdxK,Ord(Deduct),BOff,BOn); {* Do not allow negative *}


        Rnum:=LastCP;

        If (QtyUsed<>0) then
        Begin

          FIFO_SQL(StockR,QtyUsed,Rnum,Fnum,Keypath,0,FMode);

          With StockR do
            If (Mode=0) and (Deduct)
              and ((((Not ShowAsKit) or (StockType<>StkBillCode))
              and  (Idr.LineNo<>StkLineNo))
              or ((IdR.IdDocHed In StkAdjSplit) and (IdR.LineNo=StkLineNo))) then
                                                {* Only attribute costprice to Non B/M items,
                                                   & non kit items, and generated lines will never
                                                   have a costprice, as this is accounted for in the B/M
                                                   Header *}
            Begin

              IdR.CostPrice:=Round_up(Currency_ConvFT(Rnum*IdR.QtyMul,PCurrency,Idr.Currency,UseCoDayRate),Syss.NoCosDec);

            end;
        end;

        If (QtyUsed<>0) then
          FIFO_Add(IdR,QtyUsed,StkUCost,StockR.StockFolio,DocNo,Deduct,Fnum,Keypath,FMode);

      end
      else
      Begin

        KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],MakeFIDocKey(DocNo,StockR.StockFolio,IdR.ABSLineNo)));

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,MiscNdxK,KeyS);

        Ok:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)));

        If (Ok) then
          FIFO_Edit(IdR,QtyUsed,QtyCr,Fnum,MiscNdxK,Ord(Deduct),BOn,BOn) {* Use Deduct as last parameter,
                                                                          if you do not want auto delete on 0. *}
        else
          FIFO_Add(IdR,QtyUsed,StkUCost,StockR.StockFolio,DocNo,Deduct,Fnum,Keypath,Fmode);

      end;




      If (Mode=0) and (Deduct) then {==== Update Stock Costprice... ====}
      With StockR do
      Begin

        Rnum:=LastCP;

        {* Get Next Cost Price *}

        StkUCost:=1; {* Temp Var *}

        FIFO_SQL(StockR,StkUCost,Rnum,Fnum,Keypath,1,FMode);

        {If (Rnum<>LastCP) then
          Update_UpChange(On); }


        If (Rnum>0) then
          CostPrice:=Round_Up(Rnum*BuyUnit,Syss.NoCosDec);

      end;



      SetDataRecOfs(Fnum,RecAddr);

      If (RecAddr<>0) then
        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

      MiscRecs^:=TmpMisc;  {ssm}

    end; {If Locked ok..}

    TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOn,BOff);

    Inv:=TmpInv;

  end; {Proc..}




  { ========== Return Cost Price based on averages ========= }


  Function FIFO_GetCost(StockR  :  StockRec;
                        FCurr   :  Byte;
                        QtyCr,
                        QtyM    :  Real)  :  Real;

  Var
    Rnum     :  Real;

    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;


  Begin

    TmpMisc:=MiscRecs^;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOff,BOff);

    Rnum:=DivWChk(StockR.CostPrice,StockR.BuyUnit);

    QtyCr:=QtyCr*DocNotCnst;

    If (Is_FIFO(StockR.StkValType)) then
      FIFO_SQL(StockR,QtyCr,Rnum,MiscF,MIK,1,FIFO_Mode(StockR.StkValType));


    FIFO_GetCost:=Currency_ConvFT(Rnum*QtyM,StockR.PCurrency,FCurr,UseCoDayRate);

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

    MiscRecs^:=TmpMisc;

  end; {Func..}


 { ========== Return Cost Price based on averages of all remaining FIFOS ========= }


  Function FIFO_GetAVCost(StockR  :  StockRec)  :  Real;


  Var
    Rnum,
    Rnum2    :  Real;


    TmpKPath,
    TmpStat  :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMisc  :  MiscRec;


  Begin

    TmpMisc:=MiscRecs^;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOff,BOff);

    Rnum:=0;

    Rnum2:=1;

    If (Is_FIFO(StockR.StkValType)) then
      FIFO_SQL(StockR,Rnum2,Rnum,MiscF,MIK,2,FIFO_Mode(StockR.StkValType));


    FIFO_GetAVCost:=Currency_ConvFT(Rnum,StockR.PCurrency,0,UseCoDayRate);

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

    MiscRecs^:=TmpMisc;

  end; {Func..}


  { =========== Procedure to Re-Evaluate Average Cost Price ========= }

  Procedure FIFO_AvgVal(Var  StockR  :  StockRec;
                             IdR     :  IDetail;
                             QtyUsed :  Real);


  Var
    Rnum,
    TotQ,
    TotA,
    OldQ,
    LastCP  :  Real;


  Begin

    With StockR do
    Begin

      LastCP:=CostPrice;


      Rnum:=Currency_ConvFT(FIFO_SetCPrice(IdR),IdR.Currency,PCurrency,UseCoDayRate);

      TotQ:=QtyInStock; {* Already includes new figure *}

      OldQ:=TotQ-QtyUsed;

      If (TotQ>=0) and (OldQ>=0) then {* Only use weighted average if all qtys are +ve *}
        TotA:=((OldQ*CostPrice)+(QtyUsed*(BuyUnit*Rnum)))
      else  {* Replace latest cost as average cost *}
      Begin
        TotA:=Rnum;
        TotQ:=1;
      end;

      CostPrice:=Round_Up(DivWChk(TotA,TotQ),Syss.NoCosDec);

      {If (LastCP<>CostPrice) then
        Update_UpChange(On);}

    end; {With..}

  end; {Proc..}



    { ========== Return Cost Price based on averages ========= }


    Procedure FIFO_SERUp(Var StockR  :  StockRec);

    Const
      Fnum     =  MiscF;
      Keypath  =  MIK;



    Var
      KeyChk,
      KeyS     :  Str255;

      TmpKPath,
      TmpStat  :  Integer;

      TmpRecAddr
             :  LongInt;

      TmpMisc
             :  MiscRec;


    Begin

      TmpMisc:=MiscRecs^;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


      With StockR do
      Begin

        KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StockFolio)+#0);

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


        If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) then
        With MiscRecs^.SerialRec do
        Begin

          CostPrice:=Round_Up(Currency_ConvFT(SerCost,CurCost,PCurrency,UseCoDayRate)*BuyUnit,Syss.NoCosDec);

        end;

      end; {With..}


      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MiscRecs^:=TmpMisc;

    end; {Proc..}


    { ========== Return Cost Price based on averages ========= }


    Function FIFO_AvSNO(Var StockR  :  StockRec)  :  Real;

    Const
      Fnum     =  MiscF;
      Keypath  =  MIK;



    Var
      KeyChk,
      KeyS     :  Str255;

      TmpKPath,
      TmpStat  :  Integer;

      TmpRecAddr
               :  LongInt;

      Rnum,
      Qty      :  Real;

      TmpMisc  :  MiscRec;


    Begin

      TmpMisc:=MiscRecs^;

      TmpKPath:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      Rnum:=0;

      Qty:=0;

      With StockR do
      Begin

        KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StockFolio)+#0);

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With MiscRecs^.SerialRec do
        Begin

          Qty:=Qty+1;

          Rnum:=Rnum+Round_Up(Currency_ConvFT(SerCost,CurCost,0,UseCoDayRate)*BuyUnit,Syss.NoCosDec);

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        end;

      end; {With..}


      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      MiscRecs^:=TmpMisc;

      FIFO_AvSNO:=Round_Up(DivWChk(Rnum,Qty),Syss.NoCosDec);

    end; {Proc..}








end. {Unit..}
