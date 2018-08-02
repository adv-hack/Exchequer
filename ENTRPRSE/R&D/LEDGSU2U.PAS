Unit LedgSu2U;



{$F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 22/09/92                      }
{                                                              }
{                 Ledger Controller Support Unit               }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Forms,
     GlobVar,
     VarConst,
     ExWrap1U,
     Recon3U;


  Function PayRight(InvR  :  InvRec;
                    Sign  :  Boolean)  :  Boolean;


  Procedure Auto_Settle(Fnum,
                        Keypath  :  Integer;
                        MainK    :  Str255;
                        PayInv   :  InvRec;
                        Mode     :  Byte;
                        MsgForm  :  TForm);


  Procedure Update_CreditStatus(CCode      :  Str10;
                                Fnum,
                                Keypath,
                                Fnum2,
                                Keypath2   :  Integer;
                                UMode      :  Byte;
                                ExtCustObj :  GetExNObjCid;
                                Const DoAllTrans : Boolean = False);



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Controls,
   ETMiscU,
   ETStrU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,

   {$IFDEF JC}
     JChkUseU,
   {$ENDIF}

   CurrncyU,
   SysU1,
   SysU2,
   LedgSupU,
   BTSupU1,
   BTKeys1U,
   Warn1U;








  { ========== Full Suite of routines to handle automatic allocation ======== }



  { ======== Return True of right sign ======= }

  Function PayRight(InvR  :  InvRec;
                    Sign  :  Boolean)  :  Boolean;


  Var
    SignT  :  Boolean;

    DocThen:  Real;


  Begin

    DocThen:=Round_Up(BaseTotalOS(InvR),2);

    SignT:=(DocThen<0);

    If (DocThen<>0) then
      PayRight:=(Sign=SignT)
    else
      PayRight:=BOff;

  end; {Func..}


  { ====== Proc to Update payment with last allocated value ====== }

  Procedure PayUpdate(Var  InvR     :  InvRec;
                           RecAddr  :  LongInt;
                           KPath2   :  Integer;
                           Addthen,
                           AddNow   :  Real);


  Var
    UOR      :  Byte;

    Fnum,
    Keypath  :  Integer;

    KeyChk,
    KeyS     :  Str255;

    Locked   :  Boolean;

    LRecAddr :  LongInt;



  Begin

    Fnum:=InvF;
    Keypath:=InvOurRefK;

    Locked:=BOff;

    UOR:=0;

    KeyChk:=InvR.OurRef;
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    Ok:=StatusOk;

    If (Ok) then
      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOn,Locked,LRecAddr);

    If (Ok) and (Locked) then
    With Inv do
    Begin

      Settled:=Settled+Round_Up(AddThen,2);

      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      If (BaseTotalOs(Inv)= 0.0) then {Force the own currency to be fuly allocated if base is v5.50}
      Begin
        CurrSettled:=0.0;
        CurrSettled:=CurrencyOs(Inv,BOn,BOff,BOff);
      end
      else
        CurrSettled:=CurrSettled+Round_Up(Conv_TCurr(AddNow,XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOn),2);

      Set_DocAlcStat(Inv);

      If (AllocStat=#0) then {* Only set date if fully allocated *}
        UntilDate:=Today;

      If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* Cash Accounting set VATdate to Current VAT Period *}
      Begin

        // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

        VATPostDate:=CalcVATDate(TransDate)  {v5.71. CA Allows jump to future period, set from period of self as this is payment}
        
      end;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      Status:=UnLockMultiSing(F[Fnum],Fnum,LRecAddr);

      InvR:=Inv;

    end;

    SetDataRecOfs(Fnum,RecAddr);

    If (RecAddr<>0) then {* Reestablish Record & Position *}
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KPath2,0);

  end; {Proc..}





  { ======== Scan Ledger for next payment ======== }


  Function PayGetPayment(MainK  :  Str255;
                         ExtCF,
                         ExtCO  :  Pointer;
                         UnMode :  Boolean;
                         Fnum,
                         Keypath:  Integer;
                     Var PayInv :  InvRec;
                     Var RecAddr:  LongInt)  :  Boolean;



  Var
    ExtCustRec  :  ExtCusRecPtr;
    ExtCustObj  :  GetNomMode;

    KeyS,
    KeyChk      :  Str255;

    GotPay      :  Boolean;

    B_Func      :  Integer;


  Begin

    GotPay:=BOff;

    ExtCustRec:=ExtCF;
    ExtCustObj:=ExtCO;

    KeyS:=MainK;

    KeyChk:=KeyS;


    With ExtCustRec^ do
      If (RecAddr<>0) then
      Begin

        SetDataRecOfs(Fnum,RecAddr);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

        If (StatusOk) then  {* Go back one so we pick up last one still *}
          Status:=Find_Rec(FB_Func[Not FDirec],F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      B_Func:=FB_Func[FDirec];

    end
    else
    Begin
      If (FDirec) then
        B_Func:=B_GetGEq
      else
      Begin

        B_Func:=B_GetLessEq;

        KeyS:=KeyS+NdxWeight;

      end;
    end;


    Status:=GetExtCusAL(ExtCF,ExtCO,Fnum,Keypath,B_Func,1,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not GotPay) do
    With Inv do
    Begin

      // MH 13/01/2015 v7.1 ABSEXCH-16017: Modified to ignore Order Payments transactions
      If (PayRight(Inv,UnMode)) and (ExtCusFilt(0,ExtCF)) And (Inv.thOrderPaymentElement = opeNA) then
      Begin

        PayInv:=Inv;

        GotPay:=BOn;

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

      end;

      If (Not GotPay) then
        With ExtCustRec^ do
          Status:=GetExtCusAL(ExtCF,ExtCO,Fnum,Keypath,FB_Func[FDirec],1,KeyS);

    end; {While..}

    PayGetPayment:=GotPay;

  end; {Func..}



  { ========= Scan Ledger for next matching invoice ========= }

  Function AutoSettleDoc(PayInv  :  InvRec;
                         MainK   :  Str255;
                         ExtCF,
                         ExtCO   :  Pointer;
                         UnMode  :  Boolean;
                         Fnum,
                         Keypath :  Integer;
                         Mode    :  Byte;
                     Var NeedPay :  Boolean;
                     Var RecAddr :  LongInt)  :  Boolean;



  Var
    UOR         :  Byte;

    ExtCustRec  :  ExtCusRecPtr;
    ExtCustObj  :  GetNomMode;

    KeyS,
    KeyChk      :  Str255;

    GotPay,
    PaySign,
    InvSign,
    VarMode     :  Boolean;

    B_Func      :  Integer;

    PayThen,
    PayNow,
    PayOwnC,
    DeductNow,
    DeductThen,
    DeductOwn,
    DocNow,
    DocThen,
    DocOwnC
         :  Real;



  Begin

    GotPay:=BOff;
    PaySign:=BOff;
    InvSign:=BOff;
    VarMode:=BOff;

    UOR:=0;

    ExtCustRec:=ExtCF;
    ExtCustObj:=ExtCO;

    KeyS:=MainK;

    KeyChk:=KeyS;

    With ExtCustRec^ do
      If (RecAddr<>0) then
      Begin

        SetDataRecOfs(Fnum,RecAddr);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

        If (StatusOk) then  {* Go back one so we pick up last one still *}
          Status:=Find_Rec(FB_Func[Not FDirec],F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      B_Func:=FB_Func[FDirec];

    end
    else
    Begin
      If (FDirec) then
        B_Func:=B_GetGEq
      else
      Begin

        B_Func:=B_GetLessEq;

        KeyS:=KeyS+NdxWeight;

      end;
    end;


    PayThen:=0;
    PayNow:=0;
    PayOwnC:=0;
    DeductThen:=0;
    DeductNow:=0;
    DeductOwn:=0;
    DocNow:=0;
    DocThen:=0;
    DocOwnC:=0;


    Status:=GetExtCusAL(ExtCF,ExtCO,Fnum,Keypath,B_Func,1,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not NeedPay) do
    With Inv do
    Begin
      If (PayRight(Inv,Not UnMode)) and (ExtCusFilt(0,ExtCF)) then

      Begin

        If (Mode=2) then
        With GLobalAllocRec^[UnMode] do
        Begin

          PayThen:=LUnAllocated;
          PayNow:=LFullUnAllocated;

          {* Convert to invoice's own currency equivalent *}

          PayOwnC:=LFullOwnUnalloc;

        end
        else
        Begin

          PayThen:=BaseTotalOS(PayInv);

          PayNow:=CurrencyOS(PayInv,BOff,BOn,BOff);

          PayOwnC:=CurrencyOS(PayInv,BOff,BOn,UseCoDayRate{BOff});

        end;

        PaySign:=(PayThen<0);

        DocThen:=BaseTotalOS(Inv);

        DocNow:=CurrencyOS(Inv,BOff,BOn,BOff);

        DocOwnC:=CurrencyOS(Inv,BOff,BOn,UseCoDayRate{BOff});

        DeductThen:=PayThen+DocThen;

        DeductNow:=Round_Up(PayNow+DocNow,2);

        InvSign:=(DeductThen<0);

        VarMode:=((Currency=PayInv.Currency) and (Mode=2));

        If (VarMode) then
          Case UseCoDayRate of

            BOff  :  VarMode:=(DeductNow=0);
            BOn   :  VarMode:=(Round_Up(PayOwnC+DocOwnC,2)=0);

          end; {Case..}


        {* If Payment is > invoice, settled remainder of inv, or if own currency matches
           then assume settled and place remainder as variance *}


        If (PaySign=InvSign) or (VarMode) then
        Begin

          DeductThen:=DocThen;

          DeductNow:=DocNow;

          DeductOwn:=DocOwnC;

          PayThen:=DocThen*DocNotCnst;

          PayNow:=DocNow*DocNotCnst;

          PayOwnC:=DocOwnC*DocNotCnst;

        end
        else  {* Use balance of payment to settle *}
        Begin

          DeductThen:=PayThen*DocNotCnst;

          If (DeductThen=DocThen) then  {* Base equiv matches, so assume document can be settled in full
                                           with its own currency *}
          Begin
            DeductNow:=DocNow;
            DeductOwn:=DocOwnC;
          end
          else
          Begin

            DeductNow:=PayNow*DocNotCnst;

            DeductOwn:=PayOwnC*DocNotCnst;
          end;

        end;


        {* Update invoice *}

        Settled:=Settled+Round_Up(DeductThen,2);

        {* Work out if in Day rate, and currencies match you must take the rate of the payment
           to calculate the own currency equivalent *}

        If (Not UseCoDayRate) then
          DeductOwn:=DeductNow;


        UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

        CurrSettled:=CurrSettled+Round_Up(Conv_TCurr(DeductOwn,XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOn),2);

        Set_DocAlcStat(Inv);

        RemitNo:=PayInv.OurRef;


        If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* Cash Accounting set VATdate to Current VAT Period *}
        Begin

          // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

          VATPostDate:=CalcVATDate(PayInv.TransDate)  {v5.71. CA Allows jump to future period, set from period of allocating receipt}
          
        end;

        If (AllocStat=#0) then {* Only set date if fully allocated *}
          UntilDate:=Today;

        {$IFDEF JC}
          Set_DocCISDate(Inv,BOff);
        {$ENDIF}


        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        GotPay:=BOn;

        Status:=GetPos(F[Fnum],Fnum,RecAddr);

        {$IFDEF MC_On}

          UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

          Match_Payment(Inv,DeductThen,Round_Up(Conv_TCurr(DeductOwn,XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOn),2),3);

        {$ELSE}  {* Just in case AddNow causes problems on SC *}

          Match_Payment(Inv,DeductThen,Round_Up(Conv_TCurr(DeductThen,XRate(CXRate,BOff,Currency),Currency,0,BOn),2),3);

        {$ENDIF}

        {* Update payment side *}

        If (Mode=2) then
        Begin

          UpdateAllBal(DeductThen,DeductNow,DeductOwn,BOn,InvDocHed);
        end
        else
          PayUpdate(PayInv,RecAddr,Keypath,PayThen,PayOwnC);

        With GLobalAllocRec^[UnMode] do
          NeedPay:=((Round_Up(BaseTotalOS(PayInv),2)=0) or ((Round_Up(LUnAllocated,2)=0) and (Mode=2)) or (VarMode));


      end;

      If (Not NeedPay) then
        With ExtCustRec^ do
          Status:=GetExtCusAL(ExtCF,ExtCO,Fnum,Keypath,FB_Func[FDirec],1,KeyS);

    end; {While..}


    AutoSettleDoc:=GotPay;

  end; {Func..}


  { ========== Procedure to Control Auto Allocation of a ledger ========= }


  Procedure Auto_Settle(Fnum,
                        Keypath  :  Integer;
                        MainK    :  Str255;
                        PayInv   :  InvRec;
                        Mode     :  Byte;
                        MsgForm  :  TForm);


  Var

    ExtCustRec  :  ExtCusRecPtr;
    ExtCustObj  :  GetNomMode;

    RecAddr,
    InvAddr,
    PayAddr     :  LongInt;



    UnMode,
    GotPay,
    NeedPay,
    NoAbort     :  Boolean;

    mbRet       :  TModalResult;

  Begin

    RecAddr:=0;
    InvAddr:=0;
    PayAddr:=0;

    GotPay:=BOff;

    NoAbort:=BOn;

    Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Preserve POSN *}

    UnMode:=(Inv.InvDocHed In SalesSplit);

    NeedPay:=(Mode<>2);

    With GLobalAllocRec^[UnMode] do
      GotPay:=((Not NeedPay) and (PayRight(PayInv,UnMode)) and (Round_Up(LFullUnallocated,2)<>0));

    New(ExtCustRec);

    New(ExtCustObj,Init);

    Blank(ExtCustRec^,Sizeof(ExtCustRec^));

    With ExtCustRec^ do
    Begin

      FCusCode:=Inv.CustCode;

      FCr:=0;

      FNomAuto:=BOn;

      FMode:=3;

      FAlCode:=TradeCode[UnMode];

      FDirec:=BOn;

      FB_Func[BOff]:=B_GetPrev;
      FB_Func[BOn]:=B_GetNext;

    end; {With..}

    Repeat

      If (NeedPay) then
      Begin

        GotPay:=PayGetPayment(MainK,ExtCustRec,ExtCustObj,UnMode,Fnum,Keypath,PayInv,PayAddr);

        NeedPay:=Not GotPay;

      end;


      If (GotPay) then
      Begin

        GotPay:=AutoSettleDoc(PayInv,MainK,ExtCustRec,ExtCustObj,UnMode,Fnum,Keypath,Mode,NeedPay,InvAddr);

      end;


      Application.ProcessMessages;


      mbRet:=MsgForm.ModalResult;
      Loop_CheckKey(NoAbort,mbRet);
      MsgForm.ModalResult:=mbRet;



    Until (Not NeedPay) or (Not GotPay) or (Mode=2) or (Not NoAbort);


    Dispose(ExtCustRec);

    Dispose(ExtCustObj,Done);

    If (RecAddr<>0) then
    Begin

      SetDataRecOfs(Fnum,RecAddr);

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

    end;


  end; {Proc..}



  { =========== Proc to update Credit Status automaticly ========= }

  Procedure Update_CreditStatus(CCode      :  Str10;
                                Fnum,
                                Keypath,
                                Fnum2,
                                Keypath2   :  Integer;
                                UMode      :  Byte;
                                ExtCustObj :  GetExNObjCid;
                                Const DoAllTrans : Boolean = False);


  Var
    ExtCustRec  :  ExtCusRecPtr;

    n           :  Byte;

    LOk,
    FoundOk,
    UpCust,
    FirstInv,
    Locked      :  Boolean;

    KeyChk,
    KeyS        :  Str255;

    FirstDate   :  LongDate;

    EquivMode,
    LRecAddr,
    TmpRecAddr  :  LongInt;

    TmpKPath,
    TmpStat     :  Integer;



  Begin
    With ExtCustObj^,MTExLocal^ do
    Begin

      FirstInv:=BOn;
      FirstDate:='';
      EQuivMode:=0;
      UpCust:=BOff;

      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],TmpRecAddr,BOff,BOff);

      If (LCust.CustCode<>CCode) then
        FoundOk:=LGetMainRec(Fnum2,CCode)
      else
        FoundOk:=BOn;

      If (FoundOk) then
      Begin
        New(ExtCustRec);

        Blank(ExtCustRec^,Sizeof(ExtCustRec^));

        With ExtCustRec^ do
        Begin

          FCusCode:=CCode;

          FCr:=0;

          FNomAuto:=BOn;

          FMode:=3;

          FAlCode:=TradeCode[IsACust(LCust.CustSupp)];
          FCSCode:=LCust.CustSupp;

          FDirec:=BOn;

          FB_Func[BOff]:=B_GetPrev;
          FB_Func[BOn]:=B_GetNext;

        end; {With..}

        If (Keypath=InvCDueK) then
          KeyChk:=LCust.CustSupp+CCode
        else
          KeyChk:=CCode+LCust.CustSupp;

        KeyS:=KeyChk;

        Locked:=BOff;

        FoundOk:=BOff;


        LStatus:=GetExtCusALCid(ExtCustRec,ExtCustObj,Fnum,Keypath,B_GetGEq,1,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
        With LInv do
        Begin
          FoundOk:=((InvDocHed In SalesSplit+PurchSplit-RecieptSet-CreditSet) and (ExtCusFiltCid(0,ExtCustRec,ExtCustObj)) and (BaseTotalOs(LInv)*DocCnst[InvDocHed]*DocNotCnst>0));

          If (FoundOk)  then
          Begin
            If (FirstInv) then
            Begin
              FirstDate:=LInv.DueDate;
              FirstInv:=BOff;
              UpCust:=BOn;
            end
            Else
              // MH 18/06/2009: Modified for Debt Chase Letters so that it scans all the transactions
              // to pick up backdated transactions
              If (FirstDate > LInv.DueDate) Then
                FirstDate := LInv.DueDate;

            FoundOk:=(UMode In [0,1]);

            EquivMode:=TrigEquiv(CalcWksODue(LInv.DueDate));

            If (EQuivMode In [1..NofChaseLtrs]) and ((Not (UMode In [2,3])) or (LastLetter<EquivMode)) and
               (Not FoundOk) then
            Begin
              FoundOk:=BOn;

              If (UMode In [2,3]) then
                DebtLetters[Succ(LastLetter)]:=BOn
              else
                DebtLetters[EQuivMode]:=BOn;

              For n:=1 to NofChaseLtrs do {* If we have candidates for all three, then stop loop *}
                If (FoundOk) then
                  FoundOk:=DebtLetters[n];
            end;
          end;

          // MH 18/06/2009: Modified for Debt Chase Letters so that it scans all the transactions
          // to pick up backdated transactions
          If DoAllTrans Then FoundOK := False;

          If (Not FoundOk) then
            LStatus:=GetExtCusALCid(ExtCustRec,ExtCustObj,Fnum,Keypath,B_GetNext,3,KeyS);

        end; {While..}

        Begin

          KeyS:=FullCustCode(CCode);

          LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyS);

          If (LStatusOk) then
          Begin
            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth2,Fnum2,BOn,Locked);

            If (LOk) and (Locked) then
            With LCust do
            Begin
              LGetRecAddr(Fnum2);


              If (UpCust) then
                CreditStatus:=CalcWksODue(FirstDate)
              else
                CreditStatus:=0;

              LStatus:=LPut_Rec(Fnum2,KeyPath2);

              LReport_BError(Fnum2,LStatus);

              LStatus:=LUnLockMLock(Fnum2);

            end;
          end;

        end;


        Dispose(ExtCustRec);

        TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],TmpRecAddr,BOn,BOff);
      end; {If not found..}
    end; {With..}
  end;







end. {Unit..}
