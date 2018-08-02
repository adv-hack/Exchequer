Unit CuStkA5U;

{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 09/02/98                      }
{                                                              }
{                Account/Stock Analysis Support Unit           }
{                                                              }
{               Copyright (C) 1998 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     VarRec2U,
     CuStkA4U;



  {$IFDEF STK}

    Procedure TH2Inv(Var InvR    :  InvRec;
                  Const  TSR     :  TeleCustType;
                  Const  ResetF  :  Boolean);

    Procedure Inv2TH(Const InvR    :  InvRec;
                     Var   TSR     :  TeleCustType);

    Procedure TL2Id(Var IdR    :  Idetail;
                 Const  TSR    :  cuStkType);

    Procedure Id2TL(Const IdR    :  Idetail;
                    Var   TSR    :  cuStkType);


    Function GetAltStkDet(sdMode   :  Byte;
                        SuppFilt :  Str10;
                        LineFolio,
                        StkFolio :  LongInt)  :  Str255;

  {$ENDIF}


  Procedure BackCalcCS(Var CKAnal  :  CKAnalType);

  Procedure BackCalcTS(Var CKAnal  :  CKAnalType);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   ETStrU,
   ETDateU,
   ETMiscU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   CurrncyU,
   MiscU,
   SysU1,
   SysU2,
   BTSupU1,
   BTKeys1U,
   Event1U;
   {InvListU;}





{$IFDEF STK}

  { == Procedure to Output header part of TeleSales == }


  Procedure TH2Inv(Var InvR    :  InvRec;
                Const  TSR     :  TeleCustType;
                Const  ResetF  :  Boolean);

  Begin
    With InvR do
    Begin
      If (ResetF) then
        Blank(InvR,Sizeof(InvR));

      CustCode:=TSR.tcCustCode;
      InvDocHed:=DocTypes(TSR.tcDocType);
      Currency:=TSR.tcCurr;
      CXRate[BOff]:=TSR.tcCXRate[BOff];
      UseORate:=TSR.tcUseORate;
      CXRate[BOn]:=TSR.tcCXRate[BOn];
      YourRef:=TSR.tcYourRef;
      TransDesc:=TSR.tcLYRef;
      TransDate:=TSR.tcTDate;
      DueDate:=TSR.tcDelDate;
      InvNetVal:=TSR.tcNetTotal;
      InvVAT:=TSR.tcVATTotal;
      DiscAmount:=TSR.tcDiscTotal;
      DAddr:=TSR.tcDAddr;
      // MH 14/10/2013 - MRD2.5 - Delivery PostCode
      thDeliveryPostCode := TSR.tcDeliveryPostCode;
      // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
      thDeliveryCountry := TSR.tcDeliveryCountry;
      DJobCode:=TSR.tcJobCode;
      DJobAnal:=TSR.tcJACode;
      TransNat:=TSR.tcTransNat;
      TransMode:=TSR.tcTransMode;
      DelTerms:=TSR.tcDelTerms;
      CtrlNom:=TSR.tcCtrlCode;
      DiscSetl:=TSR.tcSetDisc;

      // CJS 2016-01-19 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
      SSDProcess := TSR.tcSSDProcess;

      {$IFDEF SOP}
        If (TSR.tcGenMode=0) then
          Tagged:=TSR.tcTagNo;
      {$ENDIF}
    end;
  end;



  Procedure Inv2TH(Const InvR    :  InvRec;
                   Var   TSR     :  TeleCustType);

  Begin
    With InvR do
    Begin
      TSR.tcCustCode:=CustCode;
      TSR.tcDocType:=Ord(InvDocHed);
      TSR.tcCurr:=Currency;
      TSR.tcCXRate[BOff]:=CXRate[BOff];
      TSR.tcCXRate[BOn]:=CXRate[BOn];
      TSR.tcUseORate:=UseORate;
      TSR.tcYourRef:=YourRef;
      TSR.tcLYRef:=TransDesc;
      TSR.tcTDate:=TransDate;
      TSR.tcDelDate:=DueDate;
      TSR.tcNetTotal:=InvNetVal;
      TSR.tcVATTotal:=InvVAT;
      TSR.tcDiscTotal:=DiscAmount;
      TSR.tcDAddr:=DAddr;
      TSR.tcJobcode:=DJobCode;
      TSR.tcJACode:=DJobAnal;
      TSR.tcTransNat:=TransNat;
      TSR.tcTransMode:=TransMode;
      TSR.tcDelTerms:=DelTerms;
      TSR.tcCtrlCode:=CtrlNom;


    end;
  end;





  Procedure TL2Id(Var IdR    :  Idetail;
               Const  TSR    :  cuStkType);

  Begin
    With IdR do
    Begin
      Blank(IdR,Sizeof(IdR));

      CustCode:=TSR.csCustCode;
      StockCode:=TSR.csStockCode;
      QtyMul:=TSR.csQtyMul;
      Qty:=TSR.csQty;
      NetValue:=TSR.csNetValue;
      PriceMulX:=TSR.csPriceMulX;
      Discount:=TSR.csDiscount;
      DiscountChr:=TSR.csDiscCh;
      VATCode:=TSR.csVATCode;
      VATIncFlg:=TSR.csVATIncFlg;
      VAT:=TSR.csVAT;
      CCDep:=TSR.csCCDep;
      MLocStk:=TSR.csLocCode;
      JobCode:=TSR.csJobCode;
      AnalCode:=TSR.csJACode;
      Nomcode:=TSR.csNomCode;
      CostPrice:=TSR.csCost;
      PrxPack:=TSR.csPrxPack;
      QtyPack:=TSR.csQtyPack;
      UsePack:=TSR.csUsePack;
      ShowCase:=TSR.csShowCase;
      Desc:=TSR.csDesc[1];
      DocLTLink := TSR.csLineType; //TW: 03/08/2011 ABSEXCH-11383 
    end;
  end;


  Procedure Id2TL(Const IdR    :  Idetail;
                  Var   TSR    :  cuStkType);

  Begin
    With IdR do
    Begin
      TSR.csCustCode:=CustCode;
      TSR.csStockCode:=StockCode;
      TSR.csQty:=Qty;
      TSR.csQtyMul:=QtyMul;
      TSR.csNetValue:=NetValue;
      TSR.csPriceMulX:=PriceMulX;
      TSR.csDiscount:=Discount;
      TSR.csDiscCh:=DiscountChr;
      TSR.csVATCode:=VATCode;
      TSR.csVATIncFlg:=VATIncFlg;

      TSR.csVAT:=VAT;
      TSR.csCCDep:=CCDep;
      TSR.csLocCode:=MLocStk;
      TSR.csJobCode:=JobCode;
      TSR.csJACode:=AnalCode;
      TSR.csNomCode:=Nomcode;
      TSR.csCost:=CostPrice;
      TSR.csPrxPack:=PrxPack;
      TSR.csQtyPack:=QtyPack;
      TSR.csUsePack:=UsePack;
      TSR.csShowCase:=ShowCase;
      TSR.csDesc[1]:=Desc;

    end;
  end;



  { ====== Func to return Alt Code items ====== }

  Function GetAltStkDet(sdMode   :  Byte;
                        SuppFilt :  Str10;
                        LineFolio,
                        StkFolio :  LongInt)  :  Str255;


  Const
    Fnum     =  MLocF;


  Var
    KeyS,
    KeyChk   :  Str255;

    FoundOk  :  Boolean;

    Keypath,
    B_Func,
    TmpKPath,
    TmpStat
             :  Integer;

    TmpRecAddr
             :  LongInt;

    TmpMRec  :  MLocRec;


  Begin
    Result:='';

    FoundOk:=BOff;

    TmpKPath:=GetPosKey;

    TmpMRec:=MLocCtrl^;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    Case sdMode of

      1..10
         :  Begin
              KeyChk:=FullNomKey(StkFolio);
              Keypath:=MLSecK;
            end;
      121..130
         : Begin
             KeyChk:=Strip('R',[#0],FullRunNoKey(LineFolio,StkFolio));
             Keypath:=MLSuppK;
           end;
    end;

    KeyChk:=PartCCKey(NoteTCode,NoteCCode)+KeyChk;


    B_Func:=B_GetGEq;

    KeyS:=KeyChk;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With MLocCtrl^.sdbStkRec do
    Begin

      Case sdmode of
        1..10  :  FoundOk:=(sdSuppCode=SuppFilt);
        else      FoundOk:=BOn;
      end; {Case..}

      If (Not FoundOk) then
      Begin

        B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      end;

    end; {While..}

    If (FoundOk) then
    Begin

      With MLocCtrl^.sdbStkRec do
      Case sdMode of
        1,121
              : Result:=sdCode1;
        2,122 : Result:=sdDesc;
        8,128 : Result:=PSymb(sdROCurrency);
        9,129 : Result:=Form_Real(sdROPrice,0,Syss.NoCosDec);
      end; {Case..}

    end;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

    MLocCtrl^:=TmpMRec;

    GetAltStkDet:=Result;

  end; {Proc..}


{$ENDIF}



   { ======= Display support routines ====== }

   Function SeedMonday  :  LongDate;

   Var
     TDate  :  LongDate;
     DOW    :  Byte;
     Tdd,Tmm,
     Tyy,LMon
            :  Integer;

     Jul1,
     Jul2   :  Real;


   Begin
     TDate:=Today;  LMon:=0;

     DOW:=DayofWeek(TDate);

     If (DOW=0) then
       DOW:=7;

     LMon:=1-DOW;

     SeedMonday:=CalcDueDate(TDate,LMon);
   end;



   { ======= Display support routines ====== }

   Procedure BackDRange(Var  SDate,EDate  :  LongDate;
                             ScaleMode    :  Byte);

   Var
     TDate  :  LongDate;
     Tdd,Tmm,
     Tyy
            :  Word;

     Jul1,
     Jul2   :  Real;


   Begin
     TDate:=Today;

     If (ScaleMode In [0,4]) then {* Convert current period to a date *}
       TDate:=Pr2Date(GetLocalPr(0).CPr,GetLocalPr(0).CYr,nil);

     DateStr(TDate,tdd,tmm,tyy);

     Case ScaleMode of
       0  :  Begin
               SDate:=StrDate(Tyy,Tmm,01);
               Edate:=StrDate(Tyy,Tmm,MonthDays[Tmm]);
             end;

       2  :  Begin
               SDate:=SeedMonday;

               EDate:=CalcDueDate(SDate,7);
             end;

       3  :  Begin
               SDate:=CalcDueDate(SeedMonday,-7);
               EDate:=CalcDueDate(SDate,14);
             end;

       4  :  Begin
               SDate:=Pr2Date(01,GetLocalPr(0).CYr,nil);

               Edate:=Pr2Date(Syss.PrInYr,GetLocalPr(0).CYr,nil);

             end;

       else  Begin
               SDate:=TDate; EDate:=TDate;
             end;
     end; {Case..}

   end; {Proc..}


   { ==== Function to return appropriate key for hist based on filters ==== }

   Function CKHistKey(CKAnal  :  CKAnalType)  :  Str255;

   Var
     NoFilt,
     TmpBo   :  Boolean;


   Begin
     Result:='';  NoFilt:=BOn;

     With CKAnal do
     Begin
       {$IFDEF SOP}
         If (Not EmptyKey(LocFilt,MLocKeyLen)) then
         Begin
           Result:=Full_CuStkHKey3(CCode,SFolio,LocFilt);

           NoFilt:=BOff;
         end
         else
       {$ENDIF}

        If (Syss.UseCCDep) and (Syss.PostCCNom) then
        For TmpBo :=BOff to BOn do
        Begin
          If (Not EmptyKeyS(RCCDep[TmpBo],ccKeyLen,BOff)) then
          Begin
            Result:=Full_CuStkHKey2(CCode,SFolio,PostCCKey(TmpBo,RCCDep[TmpBo]));

            NoFilt:=BOff;

          end;
        end;

        If (NoFilt) then
        Begin
          Result:=Full_CuStkHKey1(CCode,SFolio);
        end;

     end;


     CKHistKey:=Result;
   end;


   { ==== Procedure to Return Values depending on scanmode etc ==== }

   Procedure BackCalcCS(Var CKAnal  :  CKAnalType);

   Const
     Fnum     =  IDetailF;
     Keypath  =  IdCAnalK;

   Var
     KeyHist,
     KeyS,
     KeyChk   :  Str255;

     UOR,
     SetPr    :  Byte;

     TmpInclude,
     TmpBo    :  Boolean;

     PPurch,
     PSales,
     PCleared,

     DNum1,
     DNum2,
     DNum3    :  Double;

     SDate,
     EDate    :  LongDate;


   Begin
     TmpBo:=BOff; TmpInclude:=BOff;

     DNum1:=0; DNum2:=0; DNum3:=0;

     PPurch:=0.0; PSales:=0.0; PCleared:=0.0;

     UOR:=0;

     KeyHist:=CKHistKey(CKAnal);

     With CKAnal do
     Begin
       Blank(DVals,Sizeof(DVals));

       If (ScaleMode In [0,4]) and (OrdMode=0) then {Get period invoice values from history }
       Begin
         If (ScaleMode=4) then
           SetPr:=99
         else
           SetPr:=GetLocalPr(0).CPr;

         Dnum3:=Profit_To_Date(CuStkHistCode,KeyHist,RCr,GetLocalPr(0).CYr,SetPr,
                               PPurch,PSales,PCleared,(ScaleMode=4));

         DVals[1]:=PCleared;

         Dnum2:=Currency_Txlate(PPurch,RCr,RTxCr);

         Dnum3:=Currency_Txlate(PSales,RCr,RTxCr);

         DVals[3]:=Dnum2;
         DVals[2]:=Dnum3;

       end
       else
       Begin
         BackDRange(SDate,EDate,ScaleMode);

         Case OrdMode of
           0  :  Begin
                   If (IsaC) then
                     KeyChk:=StkLineType[SIN]
                   else
                     KeyChk:=StkLineType[PIN];
                 end;


           1  :  Begin
                   If (IsaC) then
                     KeyChk:=StkLineType[SOR]
                   else
                     KeyChk:=StkLineType[POR];

                   {* We need to see all o/s orders *}

                   SDate:='19500101'; EDate:='20501231';
                 end;

           2  :  Begin
                   If (IsaC) then
                     KeyChk:=StkLineType[DocTypes(Ord(SOR)+3)]
                   else
                     KeyChk:=StkLineType[DocTypes(Ord(POR)+3)];

                 end;

         end; {Case..}

         KeyChk:=KeyChk+Full_CuStkIKey(CCode,SCode);

         KeyS:=KeyChk+SDate;

         Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Id.PDate<=EDate) do
         With Id do
         Begin
           Application.ProcessMessages;

           TmpInclude:=(CheckKey(LocFilt,MLocStk,Length(LocFIlt),BOff)) and
              ((Currency=RCr) or (RCr=0)) and (LineNo>0);

           If (TmpInclude) then
           Begin
             For TmpBo:=BOff to BOn do
               TmpInclude:=(TmpInclude
                            and (CheckKey(RCCDep[TmpBo],CCDep[TmpBo],Length(RCCDep[TmpBo]),BOff)));

           end;

           If (TmpInclude) then
           Begin

             Case DispMode of
               1..3
                  :  Begin
                       {* Altered in v4.30b to use deduct qty fpr pack sizes *}
                       If (IdDocHed In OrderSet) or ((Id.DeductQty=0.0) and (Id.Qty<>0.0)) then
                       Begin
                         If (OrdMode<>2) then
                           Dnum1:=Calc_IdQty(Qty_OS(Id),QtyMul,{UsePack} BOn)
                         else
                           Dnum1:=Calc_IdQty(Qty,QtyMul,{UsePack} BOn);
                       end
                       else
                         Dnum1:=Id.DeductQty;

                       {Dnum1:=Calc_IdQty(Qty_OS(Id),QtyMul,UsePack);}

                       {If (Not (IdDocHed In OrderSet)) then
                         Dnum1:=DNum1*StkAdjCnst[IdDocHed]*DocNotCnst;}

                       DVals[1]:=DVals[1]+Dnum1;

                       If (DispMode=1) then
                       Begin
                         Dnum3:=Round_Up(Dnum1*CostPrice,Syss.NoCosDec);

                         If (OrdMode<>1) then
                           Dnum2:=DetLTotal(Id,BOn,BOff,0.0)*DocCnst[IdDocHed]
                         {$IFDEF SOP}
                         else
                           Dnum2:=InvLOOS(Id,BOn,0);
                         {$ELSE}
                           ;
                         {$ENDIF}

                         If (RCr=0) then
                         Begin
                           UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                           Dnum2:=Round_Up(Conv_TCurr(Dnum2,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

                           Dnum3:=Round_Up(Conv_TCurr(Dnum3,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);
                         end;

                         Dnum2:=Currency_Txlate(Dnum2,RCr,RTxCr);

                         Dnum3:=Currency_Txlate(Dnum3,RCr,RTxCr);

                         DVals[2]:=DVals[2]+Dnum2;
                         DVals[3]:=DVals[3]+Dnum3;
                       end;

                     end;

             end; {Case..}

           end;

           Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
         end;


       end;

       Case DispMode of
         2,3
            :  If (OrdMode In [0,2]) then
               Begin {Get YTD figures}
                 Dnum3:=Profit_To_Date(CuStkHistCode,KeyHist,RCr,GetLocalPr(0).CYr,99,
                             PPurch,PSales,PCleared,BOn);

                 DVals[2]:=PCleared;


               end
               else
                 If (OrdMode=1) then
                   DVals[2]:=DVals[1];
       end;

     end; {with..}
   end;




   { ======= Display support routines ====== }

   Procedure BackTSDRange(Var  SDate,EDate  :  LongDate;
                               ScaleMode    :  Byte);

   Var
     TDate,
     ETDate :  LongDate;
     Tdd,Tmm,
     Tyy
            :  Word;

     TPr,TYr,
     n      :  Byte;

     Jul1,
     Jul2   :  Real;


   Begin
     TDate:=SeedMonday;


     If (ScaleMode In [0]) then {* Convert current period to a date *}
     Begin
       TDate:=Pr2Date(GetLocalPr(0).CPr,GetLocalPr(0).CYr,nil);

       TPr:=GetLocalPr(0).CPr; TYr:=GetLocalPr(0).CYr;

       For n:=1 to 3 do
         AdjPr(TYr,TPr,BOff);

       ETDate:=Pr2Date(TPr,TYr,nil);
       DateStr(TDate,tdd,tmm,tyy);

     end;



     Case ScaleMode of
       0  :  Begin

               Edate:=StrDate(Tyy,Tmm,MonthDays[Tmm]);

               DateStr(ETDate,tdd,tmm,tyy);

               SDate:=StrDate(Tyy,Tmm,01);

             end;

       1  :  Begin
               SDate:=CalcDueDate(TDate,-14);

               EDate:=CalcDueDate(TDate,7);
             end;

       2  :  Begin
               SDate:=CalcDueDate(TDate,-35);

               EDate:=CalcDueDate(TDate,7);
             end;

       3  :  Begin
               SDate:=CalcDueDate(TDate,-77);

               EDate:=CalcDueDate(TDate,7);
             end;

       else  Begin
               SDate:=TDate; EDate:=TDate;
             end;
     end; {Case..}

   end; {Proc..}


   Function AgeQAnal(CKAnal  :  CKAnalType;
                     TDate   :  LongDate)   :  Byte;


   Var
     MonW,
     CPDate   :  LongDate;
     Nod      :  LongInt;


   Begin
     Result:=1;

     With CKAnal do
     Begin

       If (ScaleMode>1) then
         MonW:=CalcDueDate(SeedMonday,-(7*Pred(ScaleMode)))
       else
         MonW:=SeedMonday;

       Nod:=NoDays(MonW,TDate);

       Case ScaleMode of
         0  :  Begin {* Convert from calender date range back tp period as looking in period range *}
                 CPDate:=Pr2Date(GetLocalPr(0).CPr,GetLocalPr(0).CYr,nil);

                 Nod:=MonthDiff(TDate,CPDate);

                 If (Nod>=0) and (Nod<3) then
                   Result:=3-Nod;
               end;

         1  :  Case Nod of
                 0..7   :  Result:=3;
               -14..-1
                        :  Result:=2;
                 else      Result:=1;
               end; {case..}

         2  :  Case Nod of
                 0..14   :  Result:=3;
               -28..-1   :  Result:=2;
                 else       Result:=1;
               end; {case..}


         3  :  Case Nod of
                 0..28   :  Result:=3;
               -46..-1   :  Result:=2;
                 else       Result:=1;
               end; {case..}

       end; {case..}

     end;

     AgeQAnal:=Result;
   end;




   { ==== Procedure to Return Values depending on scanmode etc ==== }

   Procedure BackCalcTS(Var CKAnal  :  CKAnalType);

   Const
     Fnum     =  IDetailF;
     Keypath  =  IdCAnalK;

   Var
     KeyHist,
     KeyS,
     KeyChk   :  Str255;

     n,
     SetPr,
     SetYr    :  Byte;

     TmpInclude,
     TmpBo    :  Boolean;

     PPurch,
     PSales,
     PCleared,

     DNum1,
     DNum2,
     DNum3    :  Double;

     SDate,
     EDate    :  LongDate;


   Begin
     TmpBo:=BOff; TmpInclude:=BOff;

     DNum1:=0; DNum2:=0; DNum3:=0;

     PPurch:=0.0; PSales:=0.0; PCleared:=0.0;

     KeyHist:=CKHistKey(CKAnal);

     With CKAnal do
     Begin
       Blank(DVals,Sizeof(DVals));

       If (ScaleMode In [0]) and (OrdMode=0) then {Get period invoice values from history }
       Begin
         SetPr:=GetLocalPr(0).CPr;
         SetYr:=GetLocalPr(0).CYr;

         For n:=1 to 3 do
         Begin

           Dnum3:=Profit_To_Date(CuStkHistCode,KeyHist,RCr,SetYr,SetPr,
                                 PPurch,PSales,PCleared,BOff);

           DVals[4-n]:=PCleared;

           AdjPr(SetYr,SetPr,BOff);
         end;



       end
       else
       Begin

         BackTSDRange(SDate,EDate,ScaleMode);

         Case OrdMode of
           0  :  Begin
                   If (IsaC) then
                     KeyChk:=StkLineType[SIN]
                   else
                     KeyChk:=StkLineType[PIN];
                 end;


           1  :  Begin
                   If (IsaC) then
                     KeyChk:=StkLineType[SOR]
                   else
                     KeyChk:=StkLineType[POR];

                   {* We need to see all o/s orders *}

                   SDate:='19500101'; EDate:='20501231';
                 end;

           2  :  Begin
                   If (IsaC) then
                     KeyChk:=StkLineType[DocTypes(Ord(SOR)+3)]
                   else
                     KeyChk:=StkLineType[DocTypes(Ord(POR)+3)];

                 end;

         end; {Case..}

         KeyChk:=KeyChk+Full_CuStkIKey(CCode,SCode);

         KeyS:=KeyChk+SDate;

         Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Id.PDate<=EDate) do
         With Id do
         Begin
           Application.ProcessMessages;

           TmpInclude:=(CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)) and
              ((Currency=RCr) or (RCr=0))  and (LineNo>0);


           If (TmpInclude) then
           Begin
             {* Altered in v4.30b to use deduct qty fpr pack sizes *}
             If (IdDocHed In OrderSet) then
             Begin
               If (OrdMode<>2) then
                 Dnum1:=Calc_IdQty(Qty_OS(Id),QtyMul,BOn)
               else
                 Dnum1:=Calc_IdQty(Qty,QtyMul,{UsePack} BOn);
             end
             else
               Dnum1:=Id.DeductQty;

             {Dnum1:=Calc_IdQty(Qty_OS(Id),QtyMul,UsePack);}

             n:=AgeQAnal(CKAnal,PDate);

             DVals[n]:=DVals[n]+Dnum1;


           end;

           Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
         end;


       end;


     end; {with..}
   end;





end. {Unit..}
