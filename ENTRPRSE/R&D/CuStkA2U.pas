Unit CuStkA2U;


Interface

Uses GlobVar,
     VarRec2U,
     VarConst;



  Procedure cu_DeleteHistory(CCode   :  Str20;
                             UseReset: Boolean);

  Procedure cu_DeleteCStkHistory(CCode   :  Str20;
                                 SFolio  :  LongInt;
                                 UseReset: Boolean);

  Procedure cuStk_RenCCDep(CCode,OCode,
                           NCode        :  Str20;
                           IsCC         :  Boolean;
                           RMode        :  Byte);


  {$IFDEF SOP}

    Procedure Set_TSFromCust(CustR  :  CustRec;
                         Var TS     :  TeleCustType);

    Procedure LinkStk2TS(TeleSHed     :  MLocPtr;
                     Var CuRec        :  CuStkType;
                     Var StockR       :  StockRec;
                         CustR        :  CustRec;
                         Mode         :  Byte);



    Function Add_TSRecord(CCode        :  Str10;
                          TeleSHed     :  MLocPtr)  :  Boolean;


    Function Get_TSRecord(CCode      :  Str10;
                          TeleSHed   :  MLocPtr;
                          FindMode   :  Boolean)  :  Boolean;

    Procedure Unlock_TeleSales(LAddr  :  LongInt;
                               Fnum,
                               Keypath:  Integer);

    Procedure Calc_TeleTots(TeleSHed   :  MLocPtr;
                            CS         :  CuStkType;
                            Rev        :  Integer);

  {$ENDIF}



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   Forms,
   Dialogs,
   ETStrU,
   ETMiscU,
   ETDateU,
   BtrvU2,
   VarFposU,


   ComnU2,
   CurrncyU,
   InvListU,
   BtKeys1U,
   BTSupU1,
   {$IFDEF SOP}
     ComnUnit,
     InvLst3U,
     DiscU3U,
     MiscU,
     {CuStkT3U,
     CuStkT4U,}
   {$ENDIF}

   {InvCT2SU,}
   CuStkA3U,
   CuStkA4U,
   CuStkA5U,
   GenWarnU,
   PassWR2U,
   SysU2,
   // CJS 2016-01-20 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
   oSystemSetup
   ;

  { ================================================}
  {  Replicated in PostingU, TCheckCust }
  { ================================================}


  Procedure cu_DeleteHistory(CCode    :  Str20;
                             UseReset :  Boolean);

  Var
    KeyChk  :  Str255;

  Begin
    Blank(KeyChk,Sizeof(KeyChk));

    KeyChk:=CuStkHistCode+FullCustCode(CCode);

    {* Remove posted history *}

    DeleteAuditHist(KeyChk,Length(KeyChk),UseReset);


    {* Remove CC/Dep history *}

    KeyChk:=CuStkHistCode+#1+FullCustCode(CCode);


    DeleteAuditHist(KeyChk,Length(KeyChk),UseReset);


    {* Remove Loc history *}

    KeyChk:=CuStkHistCode+#2+FullCustCode(CCode);


    DeleteAuditHist(KeyChk,Length(KeyChk),UseReset);


  end;


  Procedure cu_DeleteCStkHistory(CCode   :  Str20;
                                 SFolio  :  LongInt;
                                 UseReset: Boolean);

  Var
    KeyChk  :  Str255;

  Begin
    Blank(KeyChk,Sizeof(KeyChk));

    KeyChk:=CuStkHistCode+Full_CuStkHKey1(CCode,SFolio);

    {* Remove posted history *}

    DeleteAuditHist(KeyChk,Length(KeyChk),UseReset);


    {* Remove CC/Dep history *}

    KeyChk:=CuStkHistCode+#1+Full_CuStkHKey1(CCode,SFolio);


    DeleteAuditHist(KeyChk,Length(KeyChk),UseReset);


    {* Remove Loc history *}

    KeyChk:=CuStkHistCode+#2+Full_CuStkHKey1(CCode,SFolio);


    DeleteAuditHist(KeyChk,Length(KeyChk),UseReset);

  end;




  Procedure cuStk_RenCCDep(CCode,OCode,
                           NCode        :  Str20;
                           IsCC         :  Boolean;
                           RMode        :  Byte);


  Const
    Fnum      =  NHistF;
    Keypath   =  NHK;

    Fnum2     =  MLocF;
    Keypath2  =  MLK;

  Var
    KeyChk,KeyS,
    KeyS2,KeyChk2  :  Str255;

    Locked,
    LOK          :  Boolean;

    NType        :  Char;

    OStat,
    B_Func       :  Integer;

    LAddr        :  LongInt;


  Begin
    KeyChk2:=PartCCKey(MatchTCode,MatchSCode)+CCode;

    KeyS2:=KeyChk2;

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS2);

    While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOff)) do
    With MLocCtrl^,cuStkRec do
    Begin

      Case RMode of
        0  :  KeyChk:=CuStkHistCode+Full_CuStkHKey2(csCustCode,csStkFolio,PostCCKey(IsCC,OCode));
        1  :  KeyChk:=CuStkHistCode+Full_CuStkHKey3(csCustCode,csStkFolio,OCode);
      end; {Case..}

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With NHist do
      Begin
        B_Func:=B_GetNext;

        LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
        Begin
          Case RMode of
            0  :  Code:=FullNHCode(Full_CuStkHKey2(csCustCode,csStkFolio,PostCCKey(IsCC,NCode)));
            1  :  Code:=FullNHCode(Full_CuStkHKey3(csCustCode,csStkFolio,NCode));
          end;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          OStat:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          Report_BError(Fnum,Status);

          B_Func:=B_GetGEq;
        end; {If Locked..}

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}



      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS2);
    end;


  end;


{$IFDEF SOP}
  Procedure Set_TSFromCust(CustR  :  CustRec;
                       Var TS     :  TeleCustType);


  begin

    With TS do
    Begin
      tcCurr:=CustR.Currency;
      tcCXRate[BOn]:=SyssCurr^.Currencies[tcCurr].CRates[BOn];

      {tcCCDep[BOn]:=CustR.CustCC; v4.32 method
      tcCCDep[BOff]:=CustR.CustDep;}

      With CustR do
        tcCCDep:=GetCustProfileCCDep(CustCC,CustDep,tcCCDep,0);

      tcCtrlCode:=CustR.DefCtrlNom;

      tcLocCode:=GetCustProfileMLoc(CustR.DefMLocStk,'',0);


      tcVATCode:=CustR.VATCode;
      tcVATIncFlg:=CustR.CVATIncFlg;

      tcDAddr:=CustR.DAddr;
      { CJS 2013-08-08 - MRD2.5 - Delivery PostCode }
      tcDeliveryPostCode := CustR.acDeliveryPostCode;
      // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code
      tcDeliveryCountry := CustR.acDeliveryCountry;

      // CJS 2016-01-20 - ABSEXCH-17104 - Intrastat - 4.8 - Telesales
      If (CurrentCountry<>IECCode) then
        tcTransNat:=VATInvTTyp
      else
        tcTransNat:=VATIEInvTTyp;

      if SystemSetup.Intrastat.isShowModeOfTransport then
        tcTransMode := CustR.SSDModeTr
      else
        tcTransMode := 0;

      if SystemSetup.Intrastat.isShowDeliveryTerms then
        tcDelTerms := CustR.SSDDelTerms
      else
        tcDelTerms := '';

      // CJS 2016-01-26 - ABSEXCH-17192 - Transaction Type field retains the last value
      tcSSDProcess := ' ';

      tcTagNo:=CustR.DefTagNo;

      If (tcWasNew) then
      Begin
        tcLYRef:='';
        tcYourRef:='';
      end;

      tcWasNew:=BOff;
      tcDefNomCode:=CustR.DefNomCode;

      tcSetDisc:=Pcnt(CustR.DefSetDisc);
    end; {With..}
  end;


  { == Proc to transfer stock defaults == }

  Procedure LinkStk2TS(TeleSHed     :  MLocPtr;
                   Var CuRec        :  CuStkType;
                   Var StockR       :  StockRec;
                       CustR        :  CustRec;
                       Mode         :  Byte);


  Var
    Loop  :  Boolean;

    RNum,
    Rnum2 :  Real;

    TpQty,
    Dnum  :  Double;
    IdR   :  IDetail;

  Begin
    With CuRec do
    Begin
      csLocCode:=GetProfileMLoc(CustR.DefMLocStk,StockR.DefMLoc,csLocCode,Mode);

      TpQty:=0.0;

      If (EmptyKey(csLocCode,MLocKeyLen)) then
        csLocCode:=TeleSHed^.TeleSRec.tcLocCode;


      {$IFDEF SOP}
        Stock_LocLinkSubst(StockR,csLocCode);
      {$ENDIF}


      {For Loop:=BOff to BOn do 4.32 method
        If (EmptyKey(csCCDep[Loop],CCKeyLen)) then
          csCCDep[Loop]:=StockR.CCDep[Loop];}

      With CustR do
        csCCDep:=GetProfileCCDep(CustCC,CustDep,StockR.CCDep,csCCDep,Mode);

      csNomCode:=StockR.NomCodes[1];

      If (TeleSHed^.TeleSRec.tcDefNomCode<>0) then
        csNomCode:=TeleSHed^.TeleSRec.tcDefNomCode;

      For Loop:=BOff to BOn do
        If (EmptyKeyS(csCCDep[Loop],CCKeyLen,BOff)) then
          csCCDep[Loop]:=TeleSHed^.TeleSRec.tcCCdep[Loop];


      csJobCode:=TeleSHed^.TeleSRec.tcJobCode;

      csJACode:=StockR.JAnalCode;
      //HV 02/12/2015, JIRA-15768, Telesales - default line-type set in st. code ignored & overridden by 'normal' on resulting SIN/SOR
      if csStockCode <> StockR.StockCode then
        csLineType:=StockR.StkLinkLT;

      If (EmptyKey(csJACode,AnalKeyLen)) then
        csJACode:=TeleSHed^.TeleSRec.tcJACode;

      If ((Not csEntered) and (csQty=0)) or (csStockCode<>StockR.StockCode) then
      Begin
        csQty:=csSOQty;

        csVATCode:=Correct_PVAT(StockR.VATCode,TeleSHed^.TeleSRec.tcVATCode);

        If (csVATCode=VATICode) then
          csVATIncFlg:=StockR.SVATIncFlg;


        Move(StockR.Desc,csDesc,Sizeof(csDesc));

      end;

      csShowCase:=StockR.DPackQty;

      If (Not csShowCase) then
        csQtyMul:=StockR.SellUnit
      else
        csQtyMul:=1.0;

      csQtyPack:=StockR.SellUnit;

      csUsePack:=StockR.CalcPack;
      csPrxPack:=StockR.PricePack;

      Loop:=BOn;

      Rnum:=csNetValue;
      Rnum2:=csDiscount;

      If (csQty=0.0) then
        TpQty:=1.0
      else
        TpQty:=csQty;


      Calc_StockPrice(StockR,CustR,TeleSHed^.TeleSRec.TcCurr,TpQty,TeleSHed^.TeleSRec.TcTDate, RNum,Rnum2,csDiscCh,csLocCode,Loop,0);

      csNetValue:=Rnum;
      csDiscount:=Rnum2;

      Dnum:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,csUsePack),StockR.PCurrency,
                                TeleSHed^.TeleSRec.TcCurr,UseCoDayRate);


      csCost:=Round_Up(Calc_IdQty(Dnum,csQtyMul,Not csUsePack),Syss.NoCosDec);

      TL2Id(IdR,CuRec);

      CalcVat(IdR,TeleSHed^.TeleSRec.TcSetDisc);

      csVAT:=IdR.VAT;

      csVATCode:=IdR.VATCode;
      csNetValue:=IdR.NetValue;


    end;
  end;

  { =========== Routines to manipulate TeleSales Header Record ========= }

  Function Add_TSRecord(CCode        :  Str10;
                        TeleSHed     :  MLocPtr)  :  Boolean;

  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;

  Var
    KeyChk,
    KeyS      :  Str255;

    LOk,
    Locked    :  Boolean;

    LAddr     :  LongInt;


  Begin
    With MLocCtrl^,TeleSRec do
    Begin
      ResetRec(Fnum);

      RecPFix:=MatchTCode;
      SubType:=PostLCode;

      tcCustcode:=FullCustCode(CCode);
      tcLastOpo:=EntryRec^.Login;

      tcCode1:=tcCustCode+tcLastOpo;
      tcInProg:=BOn;

      tcTDate:=Today; tcDelDate:=Today;

      Set_TSFromCust(Cust,TeleSRec);

      tcWasNew:=BOn;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Result:=StatusOK;
      Report_BError(Fnum,Status);


          {* Reapply lock *}

      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOff,Locked,LAddr);

      tcLockAddr:=LAddr;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      TeleSHed^:=MLocCtrl^;

    end; {With..}
  end; {PRoc..}




  Function Get_TSRecord(CCode      :  Str10;
                        TeleSHed   :  MLocPtr;
                        FindMode   :  Boolean)  :  Boolean;

  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;

  Var
    KeyChk,
    KeyS      :  Str255;

    LOk,
    Locked    :  Boolean;

    mbRet     :  Word;

    LAddr     :  LongInt;


  Procedure Warn_Locked;

  Begin
    With MLocCtrl^,TeleSRec do
      mbRet:=CustomDlg(Application.MainForm,'Information','TeleSales entry in progress!',
                             'A TeleSales entry for this account is in progress already by user '+Trim(tcLastOpo)+#13+#13+
                             'It is not possible for two operators to enter a TeleSales order for the same account simultaneously'+
                             #13+#13+'Please wait for user '+Trim(tcLastOpo)+' to finish.',
                             mtConfirmation,
                             [mbOk]);


  end;


  Begin
    Result:=BOff; LOK:=BOff; Locked:=BOff;

    KeyChk:=PartCCKey(MatchTCode,PostLCode)+FullCustCode(CCode){+EntryRec^.Login};

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Not CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Status=0) then
      Status:=4;

    // MH 22/04/2010 v6.4 ABSEXCH-9842: Added support for error 9 - lack of support caused
    // validation to fail without any message
    If ((Status=4) Or (Status=9)) and (FindMode) then {* It is a new record *}
    Begin
      Result:=Add_TSRecord(CCode,TeleSHed);

    end
    else
    If (StatusOk) then
    Begin
      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOff,Locked,LAddr);


      If (LOK) and (Locked) then
      With MLocCtrl^,TeleSRec do
      Begin
        If (FindMode) then
        Begin
          tcLockAddr:=LAddr;

          Result:=(Not tcInProg) or (tcLastOpo=EntryRec^.Login) or (SBSIn);

          tcWasNew:=Not tcInProg;

          If (Result) then
          Begin
            tcInProg:=BOn;

            tcLastOpo:=EntryRec^.Login;
          end
          else
          Begin
            Warn_Locked;

            Result:=BOff;

          end;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          If (Not Result) then
            UnLockMultiSing(F[Fnum],Fnum,LAddr);

          {Status:=Find_Rec(B_Unlock,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);}
        end
        else
        Begin
          MLocCtrl^:=TeleSHed^;

          {* v5.5x This has delibaretly switched off here so that a simple cancel will not abort the TS trans
                   To cancel, originating opo must use Finish/Cancel all entries *}

          If (tcLineCount=0) then {* If there is nothing to process, clear it open *}
            tcInProg:=BOff;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          UnLockMultiSing(F[Fnum],Fnum,LAddr);

          Result:=StatusOk;
        end;

      end
      else
        Warn_Locked;



    end;

    If (Result) and (FindMode) then
      TeleSHed^:=MLocCtrl^;

    Get_TSRecord:=Result;
  end;

  Procedure Unlock_TeleSales(LAddr  :  LongInt;
                             Fnum,
                             Keypath:  Integer);


  Begin
    SetDataRecOfs(Fnum,LAddr);

    Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

    If (StatusOk) then
    With MLocCtrl^,TeleSRec do
    Begin
      tcInProg:=BOff;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      UnLockMultiSing(F[Fnum],Fnum,LAddr);

    end; {With..}
  end;

  Procedure Calc_TeleTots(TeleSHed   :  MLocPtr;
                          CS         :  CuStkType;
                          Rev        :  Integer);

  Var

    DDisc,
    Dnum :  Double;

    IdR  :  IDetail;


  Begin
    With TeleSHed^.TeleSRec do
    Begin

      TL2ID(IdR,CS);

      Dnum:=InvLTotal(IdR,BOff,{tcSetDisc}0); {Settlement discount not accounted for as not taken yet}
      DDisc:=InvLTotal(IdR,BOn,{tcSetDisc}0);

      tcNetTotal:=tcNetTotal+(Dnum*Rev);
      {tcDiscTotal:=tcDiscTotal+(CS.csQty*Round_Up(Calc_PAmount(Round_Up(CS.csNetValue,Syss.NoNetDec),
                                CS.csDiscount,CS.csDiscCh),
                                Syss.NoNetDec)*Rev);}

      tcDiscTotal:=tcDiscTotal+(Round_Up(Dnum-DDisc,2)*Rev);

      {* Used difference between InvLTotal with/without discount as copes with packs then *}


      tcVATTotal:=tcVATTotal+(CS.csVAT*Rev);

      If (Rev>0) then
        Inc(tcLineCount);
    end;

  end;


{$ENDIF}




end.
