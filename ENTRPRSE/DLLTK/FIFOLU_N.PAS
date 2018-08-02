Unit Fifolu_n;

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



(*
  Procedure FIFO_Control(Var IdR     :  IDetail;
                         Var StockR  :  StockRec;
                             QtyCr   :  Real;
                             Mode    :  Byte;
                             Deduct  :  Boolean);

 *)

  Procedure FIFO_Control(Var IdR     :  IDetail;
                         Var StockR  :  StockRec;
                             LInv    :  InvRec;
                             QtyCr   :  Real;
                             Mode    :  Byte;
                             Deduct  :  Boolean);

{
  Function FIFO_GetCost(StockR  :  StockRec;
                        FCurr   :  Byte;
                        QtyCr,
                        QtyM    :  Real)  :  Real;
}

  Function FIFO_GetCost(StockR  :  StockRec;
                        FCurr   :  Byte;
                        QtyCr,
                        QtyM    :  Real;
                        LocFilt :  Str10)  :  Real;

{  Function FIFO_GetAVCost(StockR  :  StockRec)  :  Real;}


  Function FIFO_GetAVCost(StockR  :  StockRec;
                          LocFilt :  Str10)  :  Real;


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

{  Function FIFO_SetCPrice(IdR  :  IDetail)  :  Real;}

  Function FIFO_SetCPrice(IdR    :  IDetail;
                          FMode  :  Byte):  Real;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
 {$IFDEF WIN32}
   BtrvU2,
   BTSupU1,
   SysU2,
   ComnU2,
   ComnUnit,
   CurrncyU,
   BtKeys1U,
 {$ELSE}
   BtrvU16,
   BtSup1,
   BtSup2,
 {$ENDIF}
   ETStrU,
   ETMiscU;

(* Closed on 05.07.99 to use new one...
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

*)

{ ========= Function to Return Cost valuation ======== }
{ ========= Fmode 254 used by average cost when no average calcs are possible due to -ve stock qty's }


Function FIFO_SetCPrice(IdR    :  IDetail;
                        FMode  :  Byte):  Real;

Var
  Rnum  :  Real;
  QtyDiv:  Double;


Begin
  With IdR do
   If (PrxPack) and (ShowCase) and (QtyPack<>0) and (Not (FMode In [2,3])) then
     QtyDiv:=QtyPack
   else
     QtyDiv:=QtyMul;

  If (IdR.IdDocHed In SalesSplit+[ADJ]) then
  Begin
    If (IdR.IdDocHed = ADJ) then
      FIFO_SetCPrice:=IdR.CostPrice
    else
      FIFO_SetCPrice:=Calc_StkCP(IdR.CostPrice,QtyDiv,IdR.UsePack);

  end
  else
  With IdR do
  Begin

    If (Syss.SepDiscounts) then {* Do not include discount, as being posted seperately *}
      Rnum:=0.0
    else
      Rnum:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);

    {*Used to be like this pre b381, but uplift was being divided down again even though it is unit price *}
    If (Not ShowCase) then
      FIFO_SetCPrice:=Round_Up(Calc_StkCP(Round_Up((NetValue+CostPrice),Syss.NoCosDec)-Rnum,QtyDiv,(UsePack or (FMode=254))),
                               Syss.NoCosDec)
    else
      FIFO_SetCPrice:=Round_Up(Calc_StkCP(Round_Up((NetValue),Syss.NoCosDec)-Rnum,QtyDiv,(UsePack or (FMode=254)))+CostPrice,
                               Syss.NoCosDec);

  end;

end; {Func..}




(*
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

*)

Procedure FIFO_SetId(     IdR   :  IDetail;
                     Var  TMisc :  MiscRec;
                          FMode :  Byte);

Var
  Rnum  :  Real;


Begin

  Rnum:=0;

  With TMisc.FIFORec do
  Begin

    FIFODate:=Idr.PDate;


    FIFOCurr:=IdR.Currency;

    FIFOCost:=FIFO_SetCPrice(IdR,FMode);

    FIFOCRates:=IdR.CXRate;

    If (FIFOCRates[BOff]=0.0) then
      FIFOCRates[BOff]:=SyssCurr^.Currencies[FIFOCurr].CRates[BOff];

    FUseORate:=IdR.UseORate;

    FIFOCust:=IdR.CustCode;

    FIFOMLoc:=IdR.MLocStk;

    FIFOCode:=MakeFIKey(StkFolio,FIFODate);

  end; {With..}

end; {Proc..}


(*
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
*)

{ ========= Procedure to Add New FIFO Entry ======== }

Procedure FIFO_Add(IdR     :  IDetail;
                   QtyCr,
                   UCost   :  Real;
                   SFolio  :  LongInt;
                   DocNo   :  Str10;
                   Deduct,
                   ShowQty :  Boolean;
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

    FIFO_SetId(IdR,MiscRecs^,FMode*Ord(ShowQty));

    If (Not Deduct) then
    Begin

      Case FMode of

        2  :  FIFODate:=MinUntilDate;

        3  :  FIFODate:=MaxUntilDate;

      end; {Case..}

      FIFOCode:=MakeFIKey(StkFolio,FIFODate);

    end; {Mode..}


    If (FIFOCost=0) and (IdR.LineNo=StkLineNo) then {* if BOM line substitute current cost *}
      FIFOCost:=UCost;

    FIFOQty:=QtyCr;

    QtyLeft:=QtyCr;

    DocFolioK:=MakeFIDocKey(DocRef,SFolio,DocABSNo);

    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    Report_BError(Fnum,Status);

  end; {With..}

end; {Proc..}




(*
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
*)

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
  OWCost,
  Locked  :  Boolean;
  LastCost,
  QtyUsed :  Real;

  LAddr   :  LongInt;



Begin

  Locked:=BOff;

  OWCost:=BOff;

  Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,Fnum,BOn,Locked,LAddr);

  If (Ok) and (GlobLocked) then
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

    {* This check here is for the edit of the same line, to restore the fifo line back again
       This was causing a problem when temporary lines were created during an edit, as their
       values were being overwritten from the lines value rather then them setting the lines
       value. this was correct for a straight exit, but not for a deduct *}


    {* 05/02/1997. OwCost moved here and extended for LIFO so that when editing the same line,
                   The cost stored with the line originaly is used rather than the current cost which
                   may have been overwritten by the edit of the line *}

    OWCost:=((FIFODate=MinUntilDate) or (FIFODate=MaxUntilDate));

    If (QtyLeft<>0) and (Mode=1) then
    Begin
      LastCost:=FIFOCost;

      FIFO_SetId(IdR,MiscRecs^,0);

      If (OWCost) then
        FIFOCost:=LastCost;

    end;

    {* OWCost checked for here so the temorary lines generated during an edit set the line cost being put back.
       This will work fine for lines which reduce the qty needed, but those lines which have actualy increased, will not be correct becuase
       this part of the cost will not be included within the FIFO_SQL calculation. To do this properly, LastCP needs to be pased in here,
       and if there is any residual qty needed which involces dipping into the FIFO, lastCP will include this cost, so the running average
       is not distorted. I ran out of time to follow this through *}
    {* v4.23, cost price not set on purch transactions, as otherwise, an edit causes an uplift *}

    If ((Mode=1) and ((IdR.IdDocHed In StkAdjSplit) and (IdR.LineNo=StkLineNo)) or
        ((OWCost) and (Not (IdR.IdDocHed In PurchSplit)))) then  {* Update cost price from FIFOCost *}
      IdR.CostPrice:=FIFOCost;

    FIFOQty:=FIFOQty+QtyDed;


    If (Mode In [0..1]) then
    Begin
      If (Round_Up(QtyLeft,Syss.NoQtyDec)<>0) or (Not DelZero) then
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath)
      else
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);


      Report_BError(Fnum,Status);

    end;

    Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

  end; {If Locked..}

end; {Proc..}


(*
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
*)

{ ======== Procedure to Scan FIFO and Process / Return Cost Price ======= }
{ This function is replicated within RevalU2U for thread safe operation  }


Function FIFO_CalcCrCost(StockR  :  StockRec;
                         TMisc   :  MiscRec)  :  Double;


Var
  UseRate  :  Boolean;
  NewAmnt  :  Double;


Begin
  UseRate:=UseCoDayRate;
  NewAmnt:=0.0;

  With TMisc.FIFORec do
  Begin
    {$IFDEF MC_On}
      If (Not RevalueStk(StockR.NomCodes[4])) and (FIFOCRates[UseRate]<>0.0) then
      Begin
        NewAmnt:=Conv_TCurr(FIFOCost,FIFOCRates[UseRate],FIFOCurr,FUseORate,BOff);

        With SyssCurr^.Currencies[StockR.PCurrency] do
          FIFO_CalcCrCost:=Conv_TCurr(NewAmnt,CRates[UseRate],StockR.PCurrency,0,BOn);


      end
      else
    {$ENDIF}

        FIFO_CalcCrCost:=Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseRate);


  end;
end;

Procedure FIFO_SQL(StockR  :  StockRec;
               Var QtyCr,
                   CPrice  :  Real;
                   Fnum,
                   Keypath :  Integer;
                   Mode,
                   FMode   :  Byte;
                   LocFilt :  Str10);




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

  FoundSome  :  Boolean;


  Begin

    AVQty:=0; AVPrice:=0;  AVCalc:=0;

    QtyUsed:=QtyCr;

    QtyNeed:=QtyCr*DocNotCnst;

    TmpQty:=0;

    FoundSome:=BOff;

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

                  {$B-}

                  If (Not Syss.UseMLoc) or (CheckKey(FIFOMLoc,LocFilt,Length(LocFilt),BOff)) then
                  Begin

                  {$B+}

                    If (Not FoundSome) then
                      FoundSome:=BOn;

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

                    {AvCalc:=(TmpQty*Currency_ConvFT(FIFOCost,FIFOCurr,StockR.PCurrency,UseCoDayRate));}

                    AvCalc:=(TmpQty*FIFO_CalcCrCost(StockR,MiscRecs^));

                    AvPrice:=AvPrice+AvCalc;

                    Case Mode of

                      0  :  FIFO_Edit(TmpId,QtyUsed,0,Fnum,Keypath,Mode,BOff,BOn);
                      1  :  Begin

                              QtyUsed:=QtyUsed+QtyLeft;

                              If (QtyUsed>0) then
                                QtyUsed:=0;
                            end;
                    end;
                  end;

                  If (QtyUsed<>0) then
                    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

                end; {While..}

                Case Mode of

                  2  :  If (FoundSome) then
                          CPrice:=Round_Up(DivWChk(AvPrice,AvQty),Syss.NoCosDec);

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


(*
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

*)

  { ======= Procedure to Control FIFO Update ======= }

  Procedure FIFO_Control(Var IdR     :  IDetail;
                         Var StockR  :  StockRec;
                             LInv    :  InvRec;
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
      If (LInv.FolioNum<>IdR.FolioRef) then
      Begin
        If (CheckRecExsists(Strip('B',[#0],FullNomKey(IdR.FolioRef)),InvF,InvFolioK)) then
          DocNo:=Inv.OurRef
        else
          DocNo:=LInv.OurRef;
      end
      else
        DocNo:=LInv.OurRef;

      QtyUsed:=QtyCr;

      {* Convert current stock price to line currency *}

      StkUCost:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack),
                                StockR.PCurrency,IdR.Currency,UseCoDayRate);

      {* Calculate currenct Unit cost *}

      LastCP:=Round_up(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack),Syss.NoCosDec);

      If (IdR.IdDocHed In SalesSplit+StkAdjSplit) and (Not IncFIFO) then
      Begin
        KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],MakeFIDocKey(DocNo,StockR.StockFolio,IdR.ABSLineNo)));
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,MiscNdxK,KeyS);

        Ok:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))
          and ((Not Syss.UseMLoc) or CheckKey(MiscRecs^.FIFORec.FIFOMLoc,IdR.MLocStk,Length(IdR.MLocStk),BOff)));

        If (Ok) then
          FIFO_Edit(IdR,QtyUsed,QtyCr,Fnum,MiscNdxK,Ord(Deduct),BOff,BOn); {* Do not allow negative *}


        Rnum:=LastCP;

        If (QtyUsed<>0) then
        Begin

          FIFO_SQL(StockR,QtyUsed,Rnum,Fnum,Keypath,0,FMode,IdR.MLocStk);

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

              IdR.CostPrice:=Round_up(Currency_ConvFT(Calc_IdQty(Rnum,IdR.QtyMul,Not IdR.UsePack),
                                      PCurrency,Idr.Currency,UseCoDayRate),Syss.NoCosDec);

            end;
        end;

        If (QtyUsed<>0) then
          FIFO_Add(IdR,QtyUsed,StkUCost,StockR.StockFolio,DocNo,Deduct,BOn,Fnum,Keypath,FMode);

      end
      else
      Begin

        KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,Strip('B',[#0],MakeFIDocKey(DocNo,StockR.StockFolio,IdR.ABSLineNo)));

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,MiscNdxK,KeyS);

        Ok:=((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))
            and ((Not Syss.UseMLoc) or CheckKey(MiscRecs^.FIFORec.FIFOMLoc,IdR.MLocStk,Length(IdR.MLocStk),BOff)));

        If (Ok) then
          FIFO_Edit(IdR,QtyUsed,QtyCr,Fnum,MiscNdxK,Ord(Deduct),BOn,BOn) {* Use Deduct as last parameter,
                                                                          if you do not want auto delete on 0. *}
        else
          FIFO_Add(IdR,QtyUsed,StkUCost,StockR.StockFolio,DocNo,Deduct,(IdR.IdDocHed In SalesSplit),Fnum,Keypath,Fmode);

      end;




      If (Mode=0) and (Deduct) then {==== Update Stock Costprice... ====}
      With StockR do
      Begin

        Rnum:=LastCP;

        {* Get Next Cost Price *}

        StkUCost:=1; {* Temp Var *}

        FIFO_SQL(StockR,StkUCost,Rnum,Fnum,Keypath,1,FMode,IdR.MLocStk);

        If (Rnum<>LastCP) then
          Update_UpChange(BOn);


        If (Rnum>0) then
          CostPrice:=Round_Up(Calc_IdQty(Rnum,BuyUnit,Not CalcPack ),Syss.NoCosDec);

      end;



      SetDataRecOfs(Fnum,RecAddr);

      If (RecAddr<>0) then
        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

      MiscRecs^:=TmpMisc;

    end; {If Locked ok..}

    TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOn,BOff);

    Inv:=TmpInv;

  end; {Proc..}


(*
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

*)

  { ========== Return Cost Price based on averages ========= }


  Function FIFO_GetCost(StockR  :  StockRec;
                        FCurr   :  Byte;
                        QtyCr,
                        QtyM    :  Real;
                        LocFilt :  Str10)  :  Real;

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

    Rnum:=Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack);

    QtyCr:=QtyCr*DocNotCnst;

    If (Is_FIFO(StockR.StkValType)) then
      FIFO_SQL(StockR,QtyCr,Rnum,MiscF,MIK,1,FIFO_Mode(StockR.StkValType),LocFilt);


    FIFO_GetCost:=Currency_ConvFT(Calc_IdQty(Rnum,QtyM,Not StockR.CalcPack),StockR.PCurrency,FCurr,UseCoDayRate);

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

    MiscRecs^:=TmpMisc;

  end; {Func..}


(*
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

 *)

  { ========== Return Cost Price based on averages of all remaining FIFOS ========= }
 { This function is replicated within RevalU2U for thread safe operation  }


  Function FIFO_GetAVCost(StockR  :  StockRec;
                          LocFilt :  Str10)  :  Real;


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

    Rnum:=Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,StockR.CalcPack);

    Rnum2:=1;

    If (Is_FIFO(StockR.StkValType)) then
      FIFO_SQL(StockR,Rnum2,Rnum,MiscF,MIK,2,FIFO_Mode(StockR.StkValType),LocFilt);


    FIFO_GetAVCost:=Currency_ConvFT(Rnum,StockR.PCurrency,0,UseCoDayRate);

    TmpStat:=Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);

    MiscRecs^:=TmpMisc;

  end; {Func..}

(*
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
*)


    { =========== Procedure to Re-Evaluate Average Cost Price ========= }

  Procedure FIFO_AvgVal(Var  StockR  :  StockRec;
                             IdR     :  IDetail;
                             QtyUsed :  Real);


  Var
    Rnum,
    TotQ,
    TotA,
    OldQ,
    NegTotA,
    LastCP  :  Real;


  Begin

    With StockR do
    Begin

      LastCP:=CostPrice;


      Rnum:=Currency_ConvFT(FIFO_SetCPrice(IdR,0),IdR.Currency,PCurrency,UseCoDayRate);

      TotQ:=QtyInStock; {* Already includes new figure *}

      OldQ:=TotQ-QtyUsed;

      If (TotQ>=0) and (OldQ>=0) then {* Only use weighted average if all qtys are +ve *}
        {TotA:=((OldQ*CostPrice)+(QtyUsed*Calc_IdQty(Rnum,BuyUnit,Not CalcPack and Not DPackQty)))}
        {* Altered sames as Ex in v4.30b as with split packs kept decreasing *}
        TotA:=((OldQ*CostPrice)+(QtyUsed*Calc_IdQty(Rnum,BuyUnit,(Not CalcPack))))
      else  {* Replace latest cost as average cost *}
      Begin
        If (IdR.IdDocHed=ADJ) then
          NegTotA:=Calc_IdQty(IdR.CostPrice,BuyUnit,(Not CalcPack))
        else
          NegTotA:=FIFO_SetCPrice(IdR,254);

        TotA:=Currency_ConvFT(NegTotA,IdR.Currency,PCurrency,UseCoDayRate);

        TotQ:=1;
      end;

      CostPrice:=Round_Up(DivWChk(TotA,TotQ),Syss.NoCosDec);

      If (LastCP<>CostPrice) then
        Update_UpChange(BOn);

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
