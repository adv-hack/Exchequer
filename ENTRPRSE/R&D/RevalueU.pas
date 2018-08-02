unit RevalueU;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VarConst,VarRec2U,BtrvU2,ExBtTh1U,
  {$IFDEF Rp}
    RpDefine,RpDevice,
  {$ENDIF}

  ReportRV,

  BTSupU3;



  {$IFDEF MC_On}
type

  DebMDCCFType =  Array[0..CurrencyType] of Boolean;

  TRValueThread =  Object(TThreadQueue)

                     private
                       USyssCurr    :  CurrRec;
                       USyssGCR     :  GCurRec;

                       NoCustomEvents,
                       UReValueBack :  Boolean;

                       DCCount,
                       PCount       :  LongInt;

                       NJCCDep      :  CCDepType;

                       //AP : 22/12/2016 : ABSEXCH-16007 Posting Summary Report - Stored values for Dr/Cr Controls are not updated by currency revaluation
                       DebCredGL       :  DrCrType;

                     public
                       PParam       :  TPrintParamPtr;

                       RevalueLog   :  TRevalueLog;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy;  Virtual;


                       Function FullMDCCAKey(NCode  :  LongInt;
                                             NCr    :  Byte;
                                             FM     :  Boolean)  :  Str255;

                       Procedure Update_MDCCA(NCode  :  LongInt;
                                              NCr    :  Byte;
                                              Value  :  Double);

                       Function IS_MDCCA(NCode  :  LongInt;
                                         NCr    :  Byte;
                                         FullMatch
                                                :  Boolean)  :  Boolean;

                       Procedure Currency_Variance(Cno    :  Byte;
                                                   DiffBy :  Real;
                                                   NCode  :  LongInt;
                                              Var  Abort  :  Boolean);

                       Function IncCodeInVar(Ncode  :  LongInt;
                                             RValue :  Boolean)  :  Boolean;

                       Procedure Swap_SysGC(OldSGC         :  GCurRec;
                                        Var TmpSGC         :  GCurRec;
                                            UseOld         :  Boolean);


                       {$IFDEF LTE}
                         Function LCheckParentRV(GLCat  :  LongInt)  :  Boolean;
                       {$ENDIF}

                       Procedure Fix_NomCodes(OldSyssCurr  :  CurrRec;
                                              OldSGC       :  GCurRec;
                                          Var Abort        :  Boolean);

                       Procedure Adjust_MDCC(Cno    :  Byte;
                                         Var Abort  :  Boolean);

                       Procedure ScanNomCodes(Cno      :  Byte;
                                              OldRate,
                                              NewRate,
                                              DebFig,
                                              CredFig  :  Real;
                                              MDCCAFlg :  Boolean;
                                              OldSGC   :  GCurRec;
                                          Var Abort    :  Boolean);


                       Procedure CalcdebCredVar(CurrInclude  :  CurrChangeSet;
                                            Var DebCredVar   :  DrCrVarType;
                                                OldSyssCurr  :  CurrRec;
                                                OldSGC       :  GCurRec;
                                                ReValueBack  :  Boolean;
                                            Var MDCCAFlg     :  DebMDCCFType);

                       Procedure Currency_ReValue(ReValueBack  :  Boolean;
                                                  OldSyssCurr  :  CurrRec;
                                                  OldSGC       :  GCurRec;
                                              Var Abort,
                                                  OneChange    :  Boolean);

                       Procedure Day_ScanNomCodes(DebFig,
                                                  CredFig      :  Real;
                                                  MDCCAFlg     :  Boolean;
                                              Var Abort        :  Boolean);


                       Procedure Calc_DayDebCredVar(Var DebCredVar   :  DrCrType;
                                                        ReValueBack  :  Boolean;
                                                        OldSGC       :  GCurRec;
                                                    Var MDCCAFlg     :  Boolean);

                       Procedure Day_Currency_ReValue(ReValueBack  :  Boolean;
                                                      OldSyssCurr  :  CurrRec;
                                                      OldSGC       :  GCurRec;
                                                  Var Abort,
                                                      OneChange    :  Boolean);

                       Procedure Remove_AllocWizardRecs;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start(RSyssCurr    :  CurrRec;
                                      RSyssGCR     :  GCurRec)  :  Boolean;


                   end; {Class..}



  Function AddRevalue2Thread(AOwner       :  TObject;
                             RSyssCurr    :  CurrRec;
                             RSyssGCR     :  GCurRec)  : Boolean;

  procedure Revalue_Currency;

{$ENDIF}


{$IFDEF PF_On}

  {$IFDEF JC}
  type
      TJCGrpCertUpdate  =  Object(TThreadQueue)

                          private

                            Procedure  Update_GroupCert;

                          public
                            MasterEmpl  :  EmplType;

                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;

                            Function Start  :  Boolean;

                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                        end; {Class..}

  {$ENDIF}
{$ENDIF}

{$IFDEF STK}

  type

    TRevalueStk      =  Object(TThreadQueue)
                          private
                            RPParam  :  TPrintParamPtr;

                          public
                            LocFilt  :  Str10;

                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;

                            Procedure Reverse_BSValue(BSNCode,
                                                      PLNCode:  LongInt;
                                                 Var  Abort  :  Boolean);

                            Procedure Value_Stock(Var  Abort  :  Boolean);

                            Procedure Control_Stock_ReValue;

                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                            Function Start  :  Boolean;



                        end; {Class..}


  {$IFDEF PF_On}



    TCalcBOMCost      =  Object(TThreadQueue)

                          private
                            {$IFDEF Rp}
                              RDevRec    :  TSBSPrintSetupInfo;
                              RFont      :  TFont;
                              ROrient    :  TOrientation;

                            {$ENDIF}

                            SMemo        :  TStringList;

                            OptDupliList :  TList;

                            Function LGet_StkProdTime(SCode  :  Str10)  :  LongInt;

                            Function CheckedAlready(SFol  :  LongInt)  :  Boolean;

                          public
                            CheckMode  :  Byte; {* EL BoM Check implementation from DOS code *}

                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;

                            Procedure Re_CalcCostPrice(SRecAddr  :  LongInt); {* EL BoM Check implementation from DOS code part II*}


                            Function LBOMWithBOM(BOM2Chk,
                                                 ThisBom  :  StockRec)  :  Boolean;

                            Procedure Update_Kits(StockR  :  StockRec);

                            Procedure Scan_Bill;
                            // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 SQL Update Build Costs from v7.0.11 Post
                            Procedure SQL_Scan_Bill;

                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                            Function Start  :  Boolean;



                        end; {Class..}



    {$IFDEF SOP}

      TStkFreeze     =  Object(TThreadQueue)

                          private
                            RunFreeze,
                            UsePostQty  :  Boolean;
                            StkFilt     :  Str10;
                            InterMode   :  Byte;


                            Procedure  Change_StkVal;

                          public
                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;


                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                            Function Start  :  Boolean;

                        end; {Class..}


      TStkLocOR  =  Object(TStkFreeze)

                          private

                            Procedure  Replace_Inter(lc    :  Str10;
                                                     Mode  :  Byte);

                          public
                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;


                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                        end; {Class..}

      TStkLocFill  =  Object(TStkFreeze)

                          private
                            Procedure  Fill_MStkLoc(StockR  :  StockRec);

                          public
                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;


                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                        end; {Class..}

        TStkBinFill  =  Object(TStkFreeze)

                            private
                              NewLocCode :  Str10;

                              OldStkRec,
                              NewStkRec  :  StockRec;

                              FillMode   :  Byte;

                              Procedure  Copy_SNo_To_Bin;

                              Procedure  Copy_Bin_To_SNo;

                              Procedure  Change_Bin_Loc;

                            public
                              Constructor Create(AOwner  :  TObject);

                              Destructor  Destroy; Virtual;


                              Procedure Process; Virtual;
                              Procedure Finish;  Virtual;

                          end; {Class..}

    {$ENDIF}




  {$ENDIF}


    TSetSValType      =  Object(TThreadQueue)

                          private
                            OldType,
                            NewType    :  Char;

                            Procedure  Change_StkVal;

                          public
                            ChildObj   :  Boolean;

                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;


                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                            Function Start  :  Boolean;

                        end; {Class..}


    {$IFDEF STK}
    TStkQBDel         =  Object(TSetSValType)

                          private
                            CRepParam  :  BinRepPtr;
                            OHandle    :  THandle;

                            Procedure  Delete_QBRecs;

                          public
                            Constructor Create(AOwner  :  TObject);

                            Destructor  Destroy; Virtual;


                            Procedure Process; Virtual;
                            Procedure Finish;  Virtual;

                        end; {Class..}

     Procedure AddDelDiscRec2Thread(AOwner      :  TObject;
                                    FMode       :  Byte;
                                    RRepParam   :  BinRepPtr);

     {$ENDIF}


  procedure Check_StockLevels(AllMode  :  Boolean;
                              fOwner   :  TComponent;
                              Fnum,
                              Keypath  :  Integer);

  Procedure AddStkValue2Thread(AOwner   :  TObject;
                               LFilt    :  Str10);

  {$IFDEF PF_On}

    Procedure AddBOMUpdate2Thread(AOwner   :  TObject;
                                  BCMode   :  Byte);  {* EL BoM Check implementation from DOS code *}

    {$IFDEF SOP}
      Procedure AddStkFreeze2Thread(AOwner     :  TObject;
                                    UsePost    :  Boolean;
                                    UStkFilt   :  Str10);

      Procedure AddStkLocOR2Thread(AOwner     :  TObject;
                                   UStkFilt   :  Str10;
                                   UMode,
                                   TQ         :  Byte);

      Procedure AddStkLocFill2Thread(AOwner     :  TObject;
                                     StockR     :  StockRec);

      Procedure AddStkBinFill2Thread(AOwner      :  TObject;
                                   OStockR,
                                   NStockR     :  StockRec;
                                   NewLoc      :  Str10;
                                   FMode       :  Byte);

    {$ENDIF}

  {$ENDIF}

  Procedure AddStkVal2Thread(AOwner     :  TObject;
                             OTyp,NTyp  :  Char);

{$ENDIF}


{$IFDEF PF_On}
  {$IFDEF JC}
     Procedure AddGrpCertUpdate2Thread(AOwner     :  TObject;
                                       LocalEmpl  :  EmplType);
  {$ENDIF}
{$ENDIF}



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  ETDateU,
  ETStrU,
  ETMiscU,
  BTSFrmU1,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  ExWrap1U,
  ReValU2U,
  ExThrd2U,
  ExThMsgU,
  Excep2U,
  GenWarnU,

  {$IFDEF MC_On}
    //PR: 25/07/2012 ABSEXCH-12956 Change to use new currency list.
    CurrencyListF,
  {$ENDIF}

  {$IFDEF STK}
    StkChkU,

    {$IFDEF SOP}
      InvLst3U,
    {$ENDIF}

  {$ENDIF}

  {$IFDEF PF_On}
    PayF2U,
  {$ENDIF}
  {RPDefine,}

  {$IFDEF Frm}
    PrintFrm,
  {$ENDIF}

  {$IFDEF Rp}
    ReportHU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
    // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 SQL Update Build Costs from v7.0.11 Post
    DB,
    SQLCallerU,
    EntLoggerClass,
  {$ENDIF}

  MCRVCCIU,


  PostingU,
  QtyBreakVar,

  SQL_CheckAllAccounts,
  SQL_CheckAllStock, // PS 09/09/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements 
  SQLRep_Config,

  oProcessLock,

  AdoConnect;




{$IFDEF MC_On}

  { ========== TCheckNom methods =========== }

  Constructor TRValueThread.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOff;

    fPriority:=tpHighest;
    fSetPriority:=BOn;
    fShowModal:=BOn;

    DCCount:=0;

    NoCustomEvents:=BOn;

    Blank(NJCCDep,Sizeof(NJCCDep));

    New(PParam);

    With PParam^ do
    Begin
      FillChar(PParam^,Sizeof(PParam^),0);

      UFont:=TFont.Create;

      try
        UFont.Assign(Application.MainForm.Font);
      except
        UFont.Free;
        UFont:=nil;
      end;

      {$IFDEF Rp}
        Orient:=RPDefine.PoLandscape;
      {$ENDIF}


      With PDevRec do
      Begin
        DevIdx:=-1;
        Preview:=BOn;
        NoCopies:=1;
      end;
    end;

  end;

  Destructor TRValueThread.Destroy;

  Begin
    If (Assigned(PParam)) then
    Begin
      If (Assigned(PParam^.UFont)) then
        PParam^.UFont.Free;

      Dispose(PParam);
    end;

    Inherited Destroy;
  end;


Function TRValueThread.FullMDCCAKey(NCode  :  LongInt;
                                    NCr    :  Byte;
                                    FM     :  Boolean)  :  Str255;

Begin
  Result:=PartCCKey(MFIFOCode,MatchSCode)+FullNomKey(NCode);

  If (FM) then
    Result:=Result+Chr(NCr)+'!';

end;



{ ============ Procedures to Control Multi Dr/Cr revaluation =========== }

Procedure TRValueThread.Update_MDCCA(NCode  :  LongInt;
                                     NCr    :  Byte;
                                     Value  :  Double);

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  FoundRec,
  NewRec   :  Boolean;


Begin
  With MTExLocal^,LPassWord,BankCRec do
  Begin

    FoundRec:=IS_MDCCA(NCode,NCr,BOn);

    NewRec:=(LStatus=4);

    If (NewRec) then
    Begin
      LResetRec(Fnum);

      RecPFix:=MFIFOCode;
      SubType:=MatchSCode;

      BankNom:=NCode;
      BankCr:=NCr;
      BankCode:=FullNomKey(NCode)+Chr(BankCr)+'!';
    end;

    EntryTotDr:=EntryTotDr+Value;

    If (NewRec) then
      LStatus:=LAdd_Rec(Fnum,KeyPath)
    else
      If (FoundRec) then
        LStatus:=LPut_Rec(Fnum,KeyPath);

    LReport_BError(Fnum,LStatus);


  end; {With..}

end; {Proc..}


Function TRValueThread.IS_MDCCA(NCode  :  LongInt;
                                NCr    :  Byte;
                                FullMatch
                                       :  Boolean)  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  KeyChk,
  KeyS     :  Str255;

  B_Func   :  Integer;

Begin

  With MTExLocal^ do
  Begin
    KeyChk:=FullMDCCAKey(NCode,NCr,FullMatch);
    KeyS:=KeyChk;

    If (FullMatch) then
      B_Func:=B_GetEq
    else
      B_Func:=B_GetGEq;

    LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

    IS_MDCCA:=(LStatusOk and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));
  end; {With..}
end;


  { ========================= Store Variance Lines  ===================== }

  Procedure TRValueThread.Currency_Variance(Cno    :  Byte;
                                            DiffBy :  Real;
                                            NCode  :  LongInt;
                                       Var  Abort  :  Boolean);

  Const
    Fnum    =  IDetailF;
    Keypath =  IdFolioK;


  Var
    Done  :  Boolean;

  Begin

    Done:=BOn;

    With MTExLocal^ do
    Begin
      LResetRec(IdetailF); {* Reset here, as otherwise line CC/Dep gets corrupted randomly *}

      Create_NomTxfrLines(LId,MTExLocal);
    end;

    With MTExLocal^,LId do
    Begin

      NetValue:=DiffBy;

      Desc:=SSymb(Cno)+' Re-Valuation';

      NomCode:=NCode;

      CCDep:=NJCCDep;

      Repeat

        LStatus:=LAdd_Rec(Fnum,KeyPath);

        LReport_BError(Fnum,LStatus);

        Abort:=Not LStatusOk;

        Done:=Not Done;

        {$IFDEF CU}
          {$B-}

          If (NoCustomEvents) or (Not LExecuteHookEvent(4000,51,MTExLocal^)) then

          {$B+}
        {$ENDIF}

            NomCode:=Syss.NomCtrlCodes[UnRCurrVar];

        NetValue:=NetValue*DocNotCnst;

      Until (Done) or (Abort);

    end; {With..}
  end; {Proc..}


  { =============== Function to Return if Nominal Code to be included in re-valuation ================ }

  Function TRValueThread.IncCodeInVar(Ncode  :  LongInt;
                                      RValue :  Boolean)  :  Boolean;

  Begin
    IncCodeInVar:=((Ncode<>Syss.NomCtrlCodes[UnRCurrVar]) and (NCode<>Syss.NomCtrlCodes[ProfitBF]) and


                   {* Altered so it gets revalued if non 0 VAT currency *}

                   (((NCode<>Syss.NomCtrlCodes[INVat]) and (NCode<>Syss.NomCtrlCodes[OutVat])) or (Syss.VATCurr<>0)) and

                   (NCode<>Syss.NomCtrlCodes[Debtors]) and (NCode<>Syss.NomCtrlCodes[Creditors]) and (Not Is_MDCCA(NCode,0,BOff))

                   and (RValue));
  end;



  { == Procedure to swap SyssGCur around so that original values will be based on how it was set up initially =}

Procedure TRValueThread.Swap_SysGC(OldSGC         :  GCurRec;
                               Var TmpSGC         :  GCurRec;
                                   UseOld         :  Boolean);


Begin
  If (UseOld) then
  Begin
    TmpSGC:=SyssGCuR^;
    SyssGCuR^:=OldSGC;
  end
  else
  Begin
    SyssGCuR^:=TmpSGC;

  end;

end;


{$IFDEF LTE}

  { ==== Procedure to check if nom's immediate parent is set to revalue  ==== }

  Function TRValueThread.LCheckParentRV(GLCat  :  LongInt)  :  Boolean;

  Const
    Fnum     =  NomF;
    Keypath  =  NomCodeK;

  Var
    KeyS,
    KeyChk   :  Str255;


    IsDRCr,
    FoundOk  :  Boolean;

    TmpKPath,
    TmpStat
             : Integer;

    TmpRecAddr
             :  LongInt;

    TmpNom   :  NominalRec;

  Begin

    With MTExLocal^ do
    Begin
      FoundOk:=BOff;

      TmpNom:=LNom;

      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      IsDrCr:=((LNom.NomCode=Syss.NomCtrlCodes[Debtors]) or (LNom.NomCode=Syss.NomCtrlCodes[Creditors]));

      FoundOK:=(GLCat=0) and (LNom.ReValue) and (Not IsDrCr) ;;

      If (Not FoundOk) and (GLCat<>0) and (Not IsDrCr) then
      Begin
        KeyChk:=FullNomKey(GLCat);

        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

        FoundOk:=(LStatusOk) and (LNom.ReValue);
      end;


      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      LNom:=TmpNom;
    end; {With..}

    Result:=FoundOk;

  end;
{$ENDIF}


  { ============ ********* COMPANY RATE REVALUATION ********* ============ }


  Procedure TRValueThread.Fix_NomCodes(OldSyssCurr  :  CurrRec;
                                       OldSGC       :  GCurRec;
                                   Var Abort        :  Boolean);


  Const
    Fnum    =  NomF;
    Keypath =  NomCodeK;


  Var

    n      :   Byte;

    KeyS   :   Str255;

    RVLogCount
           :   Integer;
           
    CurrBal,

    Purch,
    PSales,
    PCleared,

    OldBal,
    ThisNBal,
    NewBal
           :   Double;

    InitBo :   Boolean;

    TmpSGC :   GCurRec;



  Begin

    n:=0;  RVLogCount:=0;

    InitBo:=BOff;

    KeyS:=FullNomKey(Syss.NomCtrlCodes[UnRCurrVar]);

    With MTExLocal^ do
    Begin
      LResetRec(InvF);

      DCCount:=0;

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

      If (LStatusOk) then
      Begin
        LStatus:=LFind_Rec(B_GetFirst,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not Abort) do
        Begin
          With LNom do
            If (NomType In YTDSet) and (IncCodeInVar(NomCode,{$IFDEF LTE} LCheckParentRV(Cat) {$ELSE} ReValue {$ENDIF})) then
            Begin

              Inc(PCount);

              UpdateProgress(PCount);

              ShowStatus(2,'Checking: ('+Form_Int(NomCode,0)+') '+Desc);

              Purch:=0; PSales:=0; PCleared:=0;

              OldBal:=0; NewBal:=0;


              OldBal:=LProfit_to_Date(NomType,FullNomKey(NomCode),
                                     0,GetLocalPr(0).CYr,99,
                                     Purch,PSales,PCleared,
                                     BOn);


              If (Assigned(RevalueLog)) then
              With RevalueLog do
              Begin
                ResetLine;
                RVFnum:=Fnum; RVKeypath:=Keypath;

                RVMode:=11;

                OldOrigOS:=OldBal;
                OldBaseOS:=OldBal;
                OldXRate:=PreSyssCurr.Currencies[0].CRates[BOff];

                RVCurr:=0;

                AddRevalueRec(RVCurr);

                Inc(RVLogCount);
                Inc(DCCount);
              end;

              {* Subs old triangulation *}

              Swap_SysGC(OldSGC,TmpSGC,BOn);

              For n:=Succ(CurStart) to CurrencyType do
              Begin

                Purch:=0; PSales:=0; PCleared:=0;

                CurrBal:=LProfit_to_Date(NomType,FullNomKey(NomCode),
                                        n,GetLocalPr(0).CYr,99,
                                        Purch,PSales,PCleared,
                                        BOn);


                ThisNBal:=Round_Up(Conv_TCurr(CurrBal,OldSyssCurr.Currencies[n].CRates[BOff],n,0,BOff),2);

                If (Assigned(RevalueLog)) and (CurrBal<>0.0) then
                With RevalueLog do
                Begin
                  ResetLine;

                  OldOrigOS:=CurrBal;
                  {OldBaseOS:=Round_Up(Conv_TCurr(CurrBal,PrevCurr.Currencies[n].CRates[BOff],n,0,BOff),2);}

                  ThisBase:=ThisNBal;
                  {OldXRate:=PreSyssCurr.Currencies[n].CRates[BOff];}
                  ThisXRate:=OldSyssCurr.Currencies[n].CRates[BOff];

                  RVCurr:=n;

                  AddRevalueRec(RVCurr);

                  Inc(RVLogCount);

                  Inc(DCCount);
                end;

                NewBal:=NewBal+ThisNBal;



              end; {Loop..}

              {* Rest new triangulation *}

              Swap_SysGC(OldSGC,TmpSGC,BOff);



              If   (Round_Up(OldBal,2)<>Round_Up(NewBal,2)) then
              Begin
                If (Not InitBo) then
                Begin
                  Create_NTHed(Abort,InitBo,'Auto Bal.',0,MTExLocal);

                  If (Assigned(RevalueLog)) then
                    RevalueLog.SetNomRef(MTExLocal^.LInv.OurRef,0,DCCount);

                end;

                If (Not Abort) then
                  Currency_Variance(0,(NewBal-OldBal),NomCode,Abort);


              end
              else
              Begin
                If (Assigned(RevalueLog)) then
                With RevalueLog do
                Begin {Supress printing as we don't need to fix}
                  SetPrintStatus(Form_Int(NomCode,0),BOff,RVLogCount,11);
                end;


              end;
            end; {If YTD Nominal..}

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
        end; {While..}

      end; {If Variance Nominal Ok..}
    end; {With..}
  end; {Proc..}


    { === Add lines for MDCCA === }

  Procedure TRValueThread.Adjust_MDCC(Cno    :  Byte;
                                  Var Abort  :  Boolean);

  Const
    Fnum     =  PWrdF;
    Keypath  =  PWK;

  Var
    KeyChk,
    KeyS     :  Str255;

  Begin

    KeyChk:=PartCCKey(MFIFOCode,MatchSCode);

    KeyS:=KeyChk;

    With MTExLocal^ do
    Begin
      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Abort) do
      With LPassWord.BankCRec do
      Begin

        If (BankCr=Cno) and (EntryTotDr<>0.0) then
          Currency_Variance(Cno,EntryTotDr,BankNom,Abort);

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end;
    end; {With..}
  end; {Proc..}


  { ========================= Scan through all Nominal Codes, and re-value ==================== }

  Procedure TRValueThread.ScanNomCodes(Cno      :  Byte;
                                       OldRate,
                                       NewRate,
                                       DebFig,
                                       CredFig  :  Real;
                                       MDCCAFlg :  Boolean;
                                       OldSGC   :  GCurRec;
                                   Var Abort    :  Boolean);


  Const
    Fnum    =  NomF;
    Keypath =  NomCodeK;


  Var
    KeyS   :   Str255;

    CurrBal,

    Purch,
    PSales,
    PCleared,

    OldBal,
    NewBal
           :   Double;

    ApplyRVLRef,
    InitBo :   Boolean;

    TmpSGC :   GCurRec;


  Begin

    InitBo:=BOff;

    ApplyRVLRef:=BOn;

    KeyS:=FullNomKey(Syss.NomCtrlCodes[UnRCurrVar]);

    With MTExLocal^ do
    Begin
      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

      If (LStatusOk) then
      Begin
        LStatus:=LFind_Rec(B_GetFirst,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not Abort) do
        Begin
          Inc(PCount);

          UpdateProgress(PCount);


          With LNom do

            If (NomType In YTDSet) and (IncCodeInVar(NomCode,{$IFDEF LTE} LCheckParentRV(Cat) {$ELSE} ReValue {$ENDIF})) then
            Begin
              Purch:=0; PSales:=0; PCleared:=0;  OldBal:=0; NewBal:=0;

              CurrBal:=LProfit_to_Date(NomType,FullNomKey(NomCode),
                                      Cno,GetLocalPr(0).CYr,99,
                                      Purch,PSales,PCleared,
                                      BOn);

              If (CurrBal<>0) then
              Begin
                {* Subs old triangulation *}

                Swap_SysGC(OldSGC,TmpSGC,BOn);

                OldBal:=Round_Up(Conv_TCurr(CurrBal,OldRate,Cno,0,BOff),2);

                {* Rest new triangulation *}

                Swap_SysGC(OldSGC,TmpSGC,BOff);



                NewBal:=Round_Up(Conv_TCurr(CurrBal,NewRate,Cno,0,BOff),2);



                If  (Round_Up(OldBal,2)<>Round_Up(NewBal,2)) then
                Begin
                  If (Not InitBo) then
                    Create_NTHed(Abort,InitBo,'',0,MTExLocal);

                  If (Not Abort) then
                    Currency_Variance(Cno,(NewBal-OldBal),NomCode,Abort);

                  If (Assigned(RevalueLog)) then
                  With RevalueLog do
                  Begin
                    ResetLine;
                    RVFnum:=Fnum; RVKeypath:=Keypath;

                    RVMode:=5;

                    OldOrigOS:=CurrBal;

                    OldBaseOS:=OldBal;

                    ThisBase:=NewBal;

                    ThisXRate:=NewRate;
                    OldXRate:=OldRate;

                    RVCurr:=CNo;

                    AddRevalueRec(RVCurr);

                    SetNomRef(MTExLocal^.LInv.OurRef,CNo,Pred(RevalueLog.Count));

                    ApplyRVLRef:=BOff;
                  end;

                end;
              end;
            end; {If YTD Nominal..}

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
        end; {While..}

        If (DebFig<>0) or (CredFig<>0) or (MDCCAFlg) then
        Begin
          If (Not InitBo) then
            Create_NTHed(Abort,InitBo,'',0,MTExLocal);

          If (ApplyRVLRef) and (Assigned(RevalueLog)) then
          With RevalueLog do
            SetNomRef(MTExLocal^.LInv.OurRef,CNo,Pred(RevalueLog.Count));

          //AP : 23/12/2016 : ABSEXCH-16007 Posting Summary Report - Stored values for Dr/Cr Controls are not updated by currency revaluation
          If (Not Abort) then
          begin
            If (DebFig<>0) then
            begin
              Currency_Variance(Cno,DebFig,Syss.NomCtrlCodes[Debtors],Abort);
              MTExLocal.LGetNextCount(DEB, False, False, 0);
              MTExLocal.LGetNextCount(DEB, False, True, Round_Up(MTExLocal.LCount.LastValue + DebFig, 2));
            end;
            If (DebCredGL[BOff]<>0) then
            begin
              MTExLocal.LGetNextCount(DEB, False, False, 0);
              MTExLocal.LGetNextCount(DEB, False, True, Round_Up(MTExLocal.LCount.LastValue + DebCredGL[BOff], 2));
            end;
          end;

          //AP : 23/12/2016 : ABSEXCH-16007 Posting Summary Report - Stored values for Dr/Cr Controls are not updated by currency revaluation
          If (Not Abort) then
          begin
            If (CredFig<>0) then
            begin
              Currency_Variance(Cno,CredFig,Syss.NomCtrlCodes[Creditors],Abort);
              MTExLocal.LGetNextCount(CRE, False, False, 0);
              MTExLocal.LGetNextCount(CRE, False, True, Round_Up(MTExLocal.LCount.LastValue + CredFig, 2));
            end;
            If (DebCredGL[BOn]<>0) then
            begin
              MTExLocal.LGetNextCount(CRE, False, False, 0);
              MTExLocal.LGetNextCount(CRE, False, True, Round_Up(MTExLocal.LCount.LastValue + DebCredGL[BOn], 2));
            end;
          end;

          If (MDCCAFlg) and (Not Abort) then
            Adjust_MDCC(Cno,Abort);

        end;

      end; {If Variance Nominal Ok..}
    end; {With..}
  end; {Proc..}





  { ================= Re-Calculate Debtors/Creditors from remaining OS Invoices ================== }

  Procedure TRValueThread.CalcdebCredVar(CurrInclude  :  CurrChangeSet;
                                     Var DebCredVar   :  DrCrVarType;
                                         OldSyssCurr  :  CurrRec;
                                         OldSGC       :  GCurRec;
                                         ReValueBack  :  Boolean;
                                     Var MDCCAFlg     :  DebMDCCFType);


  Const
    Fnum    =  InvF;
    Keypath =  InvOurRefK;

    Filt    :  Array[False..True] of Char = ('S','P');

  Var
    OldUOR  :  Byte;
    CrDr,
    OrigOS,
    Ok2Store:  Boolean;
    Key,KeyS:  Str255;

    OItot,
    Itot,
    OConvTot,
    ReValueEquiv
            :  Real;

    OldCXRate
            :  CurrTypes;

    TmpSGC  :   GCurRec;



  Begin
    Blank(DebCredVar,Sizeof(DebCredVar));

    CrDr:=BOn; OITot:=0; ITot:=0; OConvTot:=0;

    ReValueEquiv:=0;  OldUOR:=0; OrigOS:=BOff;

    {* Reset last List *}

    Key:=PartCCKey(MFIFOCode,MatchSCode);

    With MTExLocal^ do
      LDeleteLinks(Key,PWrdF,Length(Key),PWK,BOff);

    FillChar(MDCCAFlg,Sizeof(MDCCAFlg),0);


    With MTExLocal^ do
    Repeat
      Key:=Filt[CrDr];

      KeyS:=Key;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(Key,KeyS,Length(Key),BOff)) do
      Begin

        Inc(PCount);

        UpdateProgress(PCount);

        If (LInv.CtrlNom<>0) then {* Need to build list here for FixNomcodes *}
        Begin
          Update_MDCCA(LInv.CtrlNom,0,0);
        end;

      With LInv do
        If (Currency In CurrInclude) and (RunNo>0) and
           (Pr2Fig(AcYr,AcPr)<=Pr2Fig(GetLocalPr(0).CYr,99))
        and (AfterPurge(AcYr,0)) then {v4.32 stop purged year transactions}
        Begin
          Ok2Store:=BOn;   {* Store any non O/S documents with no CXrate Set *}

          If (CXRate[BOff]=0) then  {* Fix any documents which have actualy been fully allocated, but using
                                      the part allocate button, thus not setting the CxRate[Off] rate *}

            CXRate[BOff]:=OldSyssCurr.Currencies[Currency].CRates[BOff]
          else
            Ok2Store:=BOff;

          {* Subs old triangulation *}

          Swap_SysGC(OldSGC,TmpSGC,BOn);

          OrigOS:=(BaseTotalOs(LInv)<>0);

          If (ORigOS) or (UseORate=1) then  {Altered v4.30a so that triangulation amounts are also revalued *}
          Begin

            Ok2Store:=BOn;

            OldCXRate:=CXRate;

            OItot:=BaseTotalOS(LInv);

            OConvTot:=CurrencyOS(LInv,BOn,BOff,BOff);

            If (Assigned(RevalueLog)) then
            With RevalueLog do
            Begin
              ResetLine;
              RVFnum:=Fnum; RVKeypath:=Keypath;

              RVAdjust:=ReValueAdj;

              RVMode:=0;

              OldOrigOS:=OConvTot;

              OldBaseOS:=OItot;

              ThisXRate:=SyssCurr.Currencies[Currency].CRates[BOff];

              OldXRate:=CXRate[BOff];

              If (OldXRate=0.0) then
                OldXRate:=PreSyssCurr.Currencies[Currency].CRates[BOff];

              RVCurr:=Currency;

              Inc(DCCount);
            end;


            {* There was an error somewhere, as base fully settled, but own not,
               so force own to match base *}

            If ((Not OrigOS) and (OConvTot<>0.0)) and (UseORate=1) then
              CurrSettled:=(ITotal(LInv)*DocCnst[InvDocHed]*DocNotCnst)
            else
              {* Or base fully unallocated, but currency not *}
              If (OrigOS) and (Settled=0.0) and (CurrSettled<>0.0) then
                CurrSettled:=0.0;

            OConvTot:=ConvCurrITotal(LInv,BOff,BOff,BOff);

            If (OrigOS) then {* Only Change rate if originally o/s *}
              CXRate[BOff]:=SyssCurr.Currencies[Currency].CRates[BOff];

            {* Rest new triangulation *}

            Swap_SysGC(OldSGC,TmpSGC,BOff);


            ReValueAdj:=0;

            ReValueEquiv:=BaseTotalOS(LInv);



            If (Not ReValueBack) then
            Begin
              {* New Base Equiv = Whole Amount Converted *}

              If (Not OrigOS) then {* Change rate now so we get a true now equivalent *}
                CXRate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];

              OldUOR:=UseORate;
              UseORate:=0;  {* We have to force this o/s to use full triangulation *}

              Itot:=CurrencyOS(LInv,BOn,BOn,BOff);

              UseORate:=OldUOR;

              {* Ajustment needed to make BaseEquiv = Proper Itot *}

              ReValueAdj:=Round_Up((Itot-ReValueEquiv)*DocCnst[InvDocHed]*DocNotCnst,2);


            end
            else
              Itot:=ReValueEquiv;


            If (Assigned(RevalueLog)) and ((ITot-OITot)<>0.0) then
            With RevalueLog do
            Begin
              ThisBase:=ITot;

              AddRevalueRec(RVCurr);
            end;


            If (OrigOS) then
            Begin
              If (CtrlNom=0) then
                DebCredVar[Currency][CrDr]:=DebCredVar[Currency][CrDr]+(Itot-OItot)
              else
              Begin
                MDCCAFlg[Currency]:=BOn;
                Update_MDCCA(CtrlNom,Currency,(Itot-OItot));
                
                //AP : 22/12/2016 : ABSEXCH-16007 Posting Summary Report - Stored values for Dr/Cr Controls are not updated by currency revaluation
                with MTExLocal^,LPassWord,BankCRec do
                  DebCredGL[CrDr]:=DebCredGL[CrDr]+EntryTotDr;
              end;

              CXRate[BOff]:=0;
            end
            else
              CXRate:=OldCXRate;



            {* If a reciept is revalued, the totalInvoiced must be made up to the same, or
               the required will show a non zero value *}


            {$B-}

            If (InvDocHed In RecieptSet) and ((OConvTot-TotalInvoiced)<>0) then
            Begin

            {$B+}

              TotalInvoiced:=ConvCurrITotal(LInv,BOff,BOff,BOff);

            end;
          end
          else
          Begin
            {* Attempt to correct any currency differences from base *}

            OConvTot:=CurrencyOS(LInv,BOn,BOff,BOff);

            If (OConvTot<>0.0) then
            Begin
              {* There was an error somewhere, as base fully settled, but own not,
                 so force own to match base *}

              Ok2Store:=BOn;

              CurrSettled:=(ITotal(LInv)*DocCnst[InvDocHed]*DocNotCnst);
            end;

            {* Rest new triangulation *}

            Swap_SysGC(OldSGC,TmpSGC,BOff);

          end;


          If (Ok2Store) then
          Begin

            LStatus:=LPut_Rec(Fnum,KeyPath);

            LReport_BError(Fnum,LStatus);

          end;

        end {If Ok to Use..}
        else
        If (Currency In CurrInclude) and (RunNo>0) and
           (Pr2Fig(AcYr,AcPr)<=Pr2Fig(GetLocalPr(0).CYr,99))
        and (Not AfterPurge(AcYr,0)) then {* v4.32 Force purged dated older invoices not to be revalued *}
        Begin
          Ok2Store:=BOn;   {* Store any non O/S documents with no CXrate Set *}

          If (CXRate[BOff]=0) then  {* Force these not to be floating anymore *}

            CXRate[BOff]:=OldSyssCurr.Currencies[Currency].CRates[BOff]
          else
            Ok2Store:=BOff;

          If (Ok2Store) then
          Begin
            LStatus:=LPut_Rec(Fnum,KeyPath);

            LReport_BError(Fnum,LStatus);
          end;

        end;


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}
      CrDr:=Not CrDr;
    Until (CrDr);

    With MTExLocal^ do
      PCount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId);
  end; {Proc..}






  { ================= Re-Value all Nominals ============== }

  Procedure TRValueThread.Currency_ReValue(ReValueBack  :  Boolean;
                                           OldSyssCurr  :  CurrRec;
                                           OldSGC       :  GCurRec;
                                       Var Abort,
                                           OneChange    :  Boolean);

  Var

    n            :  Byte;
    CurrInclude  :  CurrChangeSet;
    DebCredVar   :  DrCrVarType;
    DebMDCCFlgs  :  DebMDCCFType;


  Begin

    ShowStatus(2,'Revaluing Debtors and Creditors');

    SetCurrInclude(CurrInclude,OldSyssCurr);


    { ==== Calculate Debtors & Creditors from OS Invoices ==== }

    CalcDebCredVar(CurrInclude,DebCredVar,OldSyssCurr,OldSGC,ReValueBack,DebMDCCFlgs);


    For n:=CurStart to CurrencyType do
      If (n In CurrInclude) and (Not Abort) then
      Begin


        ShowStatus(2,'Revaluing '+SSymb(n)+' Currency');

        ScanNomCodes(n,
                     OldSyssCurr.Currencies[n].CRates[BOff],SyssCurr.Currencies[n].CRates[BOff],
                     DebCredVar[n][BOff],DebCredVar[n][BOn],
                     DebMDCCFlgs[n],
                     OldSGC,
                     Abort);

        OneChange:=Not Abort;


      end; {If Rates Have Changes..}


    {* Check if any adjustments are required to correct problrms *}

    Fix_NomCodes(OldSyssCurr,OldSGC,Abort);

  end; {Proc..}



  { ============ ********* DAILY RATE REVALUATION ********* ============ }




  { ========================= Scan through all Nominal Codes, and re-value ==================== }

  Procedure TRValueThread.Day_ScanNomCodes(DebFig,
                                           CredFig      :  Real;
                                           MDCCAFlg     :  Boolean;
                                       Var Abort        :  Boolean);


  Const
    Fnum    =  NomF;
    Keypath =  NomCodeK;


  Var

    n      :   Byte;

    KeyS   :   Str255;

    CurrBal,

    Purch,
    PSales,
    PCleared,

    OldBal,
    ThisNBal,
    NewBal
           :   Double;
    RVLogCount
           :   Integer;

    InitBo :   Boolean;


  Begin

    InitBo:=BOff;

    n:=0; RVLogCount:=0;

    KeyS:=FullNomKey(Syss.NomCtrlCodes[UnRCurrVar]);

    With MTExLocal^ do
    Begin
      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

      If (LStatusOk) then
      Begin
        LStatus:=LFind_Rec(B_GetFirst,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not Abort) do
        Begin
          Inc(PCount);

          UpdateProgress(PCount);


          With LNom do
            If (NomType In YTDSet) and (IncCodeInVar(NomCode,{$IFDEF LTE} LCheckParentRV(Cat) {$ELSE} ReValue {$ENDIF})) then
            Begin

              ShowStatus(2,Spc(1)+'Re-Valuing: ('+Form_Int(NomCode,0)+') '+LJVar(Desc,30)+Spc(1));

              Purch:=0; PSales:=0; PCleared:=0;

              OldBal:=0; NewBal:=0;


              OldBal:=LProfit_to_Date(NomType,FullNomKey(NomCode),
                                      0,GetLocalPr(0).CYr,99,
                                      Purch,PSales,PCleared,
                                      BOn);

              If (Assigned(RevalueLog)) then
              With RevalueLog do
              Begin
                ResetLine;
                RVFnum:=Fnum; RVKeypath:=Keypath;

                RVMode:=10;

                OldOrigOS:=OldBal;
                OldBaseOS:=OldBal;
                OldXRate:=PreSyssCurr.Currencies[0].CRates[BOff];

                RVCurr:=0;

                AddRevalueRec(RVCurr);

                Inc(RVLogCount);
              end;

              For n:=Succ(CurStart) to CurrencyType do
              Begin

                Purch:=0; PSales:=0; PCleared:=0;

                CurrBal:=LProfit_to_Date(NomType,FullNomKey(NomCode),
                                         n,GetLocalPr(0).CYr,99,
                                         Purch,PSales,PCleared,
                                         BOn);

                ThisNBal:=Round_Up(Conv_TCurr(CurrBal,SyssCurr.Currencies[n].CRates[BOff],n,0,BOff),2);

                If (Assigned(RevalueLog)) and (CurrBal<>0.0) then
                With RevalueLog do
                Begin
                  ResetLine;

                  OldOrigOS:=CurrBal;
                  {OldBaseOS:=Round_Up(Conv_TCurr(CurrBal,PreSyssCurr.Currencies[n].CRates[BOff],n,0,BOff),2);}

                  ThisBase:=ThisNBal;
                  {OldXRate:=PreSyssCurr.Currencies[n].CRates[BOff];}
                  ThisXRate:=SyssCurr.Currencies[n].CRates[BOff];

                  RVCurr:=n;

                  {If (ThisBase-OldBaseOS<>0.0) then}
                  Begin
                    AddRevalueRec(RVCurr);

                    Inc(RVLogCount);
                  end;
                end;

                NewBal:=NewBal+ThisNBal;


              end; {Loop..}



              If (Round_Up(OldBal,2)<>Round_Up(NewBal,2)) then
              Begin
                If (Not InitBo) then
                  Create_NTHed(Abort,InitBo,'',0,MTExLocal);

                If (Not Abort) then
                  Currency_Variance(0,(NewBal-OldBal),NomCode,Abort);
              end
              else
              Begin
                If (Assigned(RevalueLog)) then
                With RevalueLog do
                Begin {Supress printing as we don't need to fix}
                  SetPrintStatus(Form_Int(NomCode,0),BOff,RVLogCount,10); {Switch on for debug version}
                end;


              end;
            end; {If YTD Nominal..}

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
        end; {While..}


        If (DebFig<>0) or (CredFig<>0) or (MDCCAFlg) then
        Begin
          If (Not InitBo) then
            Create_NTHed(Abort,InitBo,'',0,MTExLocal);

          //AP : 23/12/2016 : ABSEXCH-16007 Posting Summary Report - Stored values for Dr/Cr Controls are not updated by currency revaluation
          If (Not Abort) then
          begin
            If (DebFig<>0) then
            begin
              Currency_Variance(0,DebFig,Syss.NomCtrlCodes[Debtors],Abort);
              MTExLocal.LGetNextCount(DEB, False, False, 0);
              MTExLocal.LGetNextCount(DEB, False, True, Round_Up(MTExLocal.LCount.LastValue + DebFig, 2));
            end;
            If (DebCredGL[BOff]<>0) then
            begin
              MTExLocal.LGetNextCount(DEB, False, False, 0);
              MTExLocal.LGetNextCount(DEB, False, True, Round_Up(MTExLocal.LCount.LastValue + DebCredGL[BOff], 2));
            end;
          end;

          //AP : 23/12/2016 : ABSEXCH-16007 Posting Summary Report - Stored values for Dr/Cr Controls are not updated by currency revaluation
          If (Not Abort) then
          begin
            If (CredFig<>0) then
            begin
              Currency_Variance(0,CredFig,Syss.NomCtrlCodes[Creditors],Abort);
              MTExLocal.LGetNextCount(CRE, False, False, 0);
              MTExLocal.LGetNextCount(CRE, False, True, Round_Up(MTExLocal.LCount.LastValue + CredFig, 2));
            end;
            If (DebCredGL[BOn]<>0) then
            begin
              MTExLocal.LGetNextCount(CRE, False, False, 0);
              MTExLocal.LGetNextCount(CRE, False, True, Round_Up(MTExLocal.LCount.LastValue + DebCredGL[BOn], 2));
            end;
          end;

          If (MDCCAFlg) and (Not Abort) then
            Adjust_MDCC(0,Abort);
        end;

      end; {If Variance Nominal Ok..}
    end; {With..}
  end; {Proc..}





  { ================= Re-Calculate Debtors/Creditors from remaining OS Invoices ================== }

  Procedure TRValueThread.Calc_DayDebCredVar(Var DebCredVar   :  DrCrType;
                                                 ReValueBack  :  Boolean;
                                                 OldSGC       :  GCurRec;
                                             Var MDCCAFlg     :  Boolean);


  Const
    Fnum    =  InvF;
    Keypath =  InvOurRefK;

    Filt    :  Array[False..True] of Char = ('S','P');


  Var
    OldUOR  :  Byte;
    CrDr,
    OrigOS,
    Ok2Store:  Boolean;

    Key,KeyS:  Str255;

    OldCXRate
            :  CurrTypes;

    OItot,
    Itot,
    OConvTot,
    ReValueEquiv
            :  Real;

    TmpSGC  :   GCurRec;



  Begin


    Blank(DebCredVar,Sizeof(DebCredVar));

    Blank(OldCXRate,Sizeof(OldCXRate));


    CrDr:=BOn; OITot:=0; ITot:=0; OConvTot:=0;

    ReValueEquiv:=0; OldUOR:=0; OrigOS:=BOff;

    {* Reset last List *}

    Key:=PartCCKey(MFIFOCode,MatchSCode);

    With MTExLocal^ do
      LDeleteLinks(Key,PWrdF,Length(Key),PWK,BOff);

    MDCCAFlg:=BOff;


    With MTExLocal^ do
    Repeat
      Key:=Filt[CrDr];

      KeyS:=Key;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(Key,KeyS,Length(Key),BOff)) do
      Begin
        Inc(PCount);

        UpdateProgress(PCount);

        If (LInv.CtrlNom<>0) then {* Need to build list here for FixNomcodes *}
        Begin
          Update_MDCCA(LInv.CtrlNom,0,0);
        end;

      With LInv do
        If (Currency >1) and (RunNo>0) and
           (Pr2Fig(AcYr,AcPr)<=Pr2Fig(GetLocalPr(0).CYr,99))
         and (AfterPurge(AcYr,0)){v4.32 stop purged year transactions}

        //PR: 09/02/2015 ABSEXCH-16129 Add condition to exclude OrderPayment SRCs from revaluation
        and ((InvDocHed <> SRC) or (thOrderPaymentElement = opeNA)) then
        Begin
          Ok2Store:=BOff;

          OldCXRate:=CXRate;

          {* Subs old triangulation *}

          Swap_SysGC(OldSGC,TmpSGC,BOn);

          OrigOS:=(BaseTotalOs(LInv)<>0);

          If (OrigOS) or (UseORate=1) then
          Begin
            Ok2Store:=BOn;


            OItot:=BaseTotalOS(LInv);

            OConvTot:=CurrencyOS(LInv,BOn,BOff,BOff);

            If (Assigned(RevalueLog)) then
            With RevalueLog do
            Begin
              ResetLine;
              RVFnum:=Fnum; RVKeypath:=Keypath;

              RVAdjust:=ReValueAdj;

              RVMode:=0;

              OldOrigOS:=OConvTot;

              OldBaseOS:=OItot;

              ThisXRate:=SyssCurr.Currencies[Currency].CRates[BOn];

              OldXRate:=CXRate[BOn];

              RVCurr:=Currency;

              Inc(DCCount);
            end;


            {* There was an error somewhere, as base fully settled, but own not,
               so force own to match base *}

            If ((Not OrigOS) and (OConvTot<>0.0)) and (UseORate=1) then
              CurrSettled:=(ITotal(LInv)*DocCnst[InvDocHed]*DocNotCnst)
            else
              {* Or base fully unallocated, but currency not *}
              If (OrigOS) and (Settled=0.0) and (CurrSettled<>0.0) then
                CurrSettled:=0.0;

            OConvTot:=ConvCurrITotal(LInv,BOff,BOff,BOff);

            {* Rest new triangulation *}

            Swap_SysGC(OldSGC,TmpSGC,BOff);

            ReValueAdj:=0;

            ReValueEquiv:=BaseTotalOS(LInv);


            If (Not ReValueBack) then
            Begin

              {* New Base Equiv = Whole Amount OS Converted *}

              {* Temporary Swap to calculate Currency O/S at the new rate *}

              CXRate[BOn]:=SyssCurr.Currencies[Currency].CRates[BOff];

              OldUOR:=UseORate;
              UseORate:=0;  {* We have to force this o/s to use full triangulation *}

              Itot:=CurrencyOS(LInv,BOn,BOn,BOff);

              UseORate:=OldUOR;

              {* Ajustment needed to make BaseEquiv = Proper Itot *}

              ReValueAdj:=Round_Up((Itot-ReValueEquiv)*DocCnst[InvDocHed]*DocNotCnst,2);

              CXRate:=OldCXRate;

            end
            else
              ITot:=ReValueEquiv;



            If (Assigned(RevalueLog)) and ((ITot-OITot)<>0.0) then
            With RevalueLog do
            Begin
              ThisBase:=ITot;


              AddRevalueRec(RVCurr);
            end;

            If (OrigOS) then
            Begin
              If (CtrlNom=0) then
                DebCredVar[CrDr]:=DebCredVar[CrDr]+(Itot-OItot)
              else
              Begin
                 MDCCAFlg:=BOn;
                Update_MDCCA(CtrlNom,0,(Itot-OItot));
                 
                //AP : 22/12/2016 : ABSEXCH-16007 Posting Summary Report - Stored values for Dr/Cr Controls are not updated by currency revaluation
                with MTExLocal^,LPassWord,BankCRec do
                  DebCredGL[CrDr]:=DebCredGL[CrDr]+EntryTotDr;
              end;
            end;




            {* If a reciept is revalued, the totalInvoiced must be made up to the same, or
               the required will show a non zero value *}


            {$B-}

            If (InvDocHed In RecieptSet) then
            Begin

            {$B+}

              TotalInvoiced:=ConvCurrITotal(LInv,BOff,BOff,BOff);

            end;
          end
          else
          Begin
            {* Attempt to correct any currency differences from base *}

            OConvTot:=CurrencyOS(LInv,BOn,BOff,BOff);

            If (OConvTot<>0.0) then
            Begin
              {* There was an error somewhere, as base fully settled, but own not,
                 so force own to match base *}

              Ok2Store:=BOn;

              CurrSettled:=(ITotal(LInv)*DocCnst[InvDocHed]*DocNotCnst);
            end;

            {* Rest new triangulation *}

            Swap_SysGC(OldSGC,TmpSGC,BOff);

          end;


          If (Ok2Store) then
          Begin
            LStatus:=LPut_Rec(Fnum,KeyPath);

            LReport_BError(Fnum,LStatus);
          end;

        end; {If Ok to Use..}

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}
      CrDr:=Not CrDr;
    Until (CrDr);

    With MTExLocal^ do
      PCount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId);
  end; {Proc..}






  { ================= Re-Value all Nominals ============== }

  Procedure TRValueThread.Day_Currency_ReValue(ReValueBack  :  Boolean;
                                               OldSyssCurr  :  CurrRec;
                                               OldSGC       :  GCurRec;
                                           Var Abort,
                                               OneChange    :  Boolean);



  Var
    MDCCFlg      :  Boolean;
    n            :  Byte;

    DebCredVar   :  DrCrType;


  Begin


    ShowStatus(2,'Revaluing Debtors and Creditors');


    { ==== Calculate Debtors & Creditors from OS Invoices ==== }

    Calc_DayDebCredVar(DebCredVar,ReValueBack,OldSGC,MDCCFlg);


    {* Calculate All currency differences *}

    Day_ScanNomCodes(DebCredVar[BOff],DebCredVar[BOn],MDCCFlg,Abort);

    If (Assigned(RevalueLog)) then
      RevalueLog.SetNomRef(MTExLocal^.LInv.OurRef,0,Pred(RevalueLog.Count));

    OneChange:=Not Abort;

  end; {Proc..}



  Procedure TRValueThread.Remove_AllocWizardRecs;

  Var
    KeyAL  :  Str255;

  Begin
    With MTExLocal^ do
    Begin
      ShowStatus(2,'Removing Allocation Wizard Entries');

      FillChar(KeyAL,Sizeof(KeyAL),#0);

      KeyAL:=PartCCKey(MBACSCode,MBACSALSub);

      LDeleteLinks(KeyAL,MiscF,Length(KeyAL),MIK,BOff);

      FillChar(KeyAL,Sizeof(KeyAL),#0);

      KeyAL:=PartCCKey(MBACSCode,MBACSCTL);

      LDeleteLinks(KeyAL,MLocF,Length(KeyAL),MLK,BOff);

    end;

  end;

  Procedure TRValueThread.Process;


  Var

    n            :  Byte;
    Abort,
    OneChange,
    StartedOk    :  Boolean;
    LPostParam       :  PostRepParam; //PR: 24/05/2016 ABSEXCH-17450


  Begin

    InMainThread:=BOn;  StartedOk:=BOff;

    Inherited Process;

    Abort:=BOff;

    OneChange:=BOff;

    ShowStatus(0,'Multicurrency revaluation.');

    PCount:=0;

    {$IFDEF CU}  {Check once to see if any custom revalaution events exists to save opeing all the files for each check *}
      NoCustomEvents:=Not LHaveHookEvent(4000,51,OneChange);

      OneChange:=BOff;

    {$ENDIF}

    RevalueLog:=TRevalueLog.Create;

    Try
      ReValueLog.MTExLocal:=MTExLocal;
      ReValueLog.InitScratchFile;

      With ReValueLog do
      Begin
        PreSyssCurr:=USyssCurr;
        PreSyssGCR:=USyssGCR;


      end;
    except
      FreeandNil(ReValueLog);

    end; {Try..}

    With MTExLocal^ do
    If (UseCoDayRate) then
    Begin
      InitProgress((Used_RecsCId(LocalF^[NomF],NomF,ExClientId)*2)+Used_RecsCId(LocalF^[InvF],InvF,ExCLientId));

      Day_Currency_ReValue(URevalueBack,USyssCurr,USyssGCR,Abort,OneChange);
    end
    else
    Begin
      InitProgress((Used_RecsCId(LocalF^[NomF],NomF,ExClientId)*CurrencyType)+Used_RecsCId(LocalF^[InvF],InvF,ExCLientId));

      Currency_ReValue(URevalueBack,USyssCurr,USyssGCR,Abort,OneChange);

    end;


    Send_UpdateList(60);

    If (Not Abort) and (OneChange) then
    Begin
      {Remove all allocation wizard entries, as no longer valid}

      Remove_AllocWizardRecs;


      {Print Reconciliation report}

      With MTExLocal^ do {Close file as we are switching threads}
        LStatus:=Close_FileCId(LocalF[ReportF],ExClientId);

      AddRVRep2Thread(1,PParam,RevalueLog,fMyOwner);

      {* Auto add the posting routine to the Thread Queue *}

      With PParam^.PDevRec do
      Begin
        feXMLFileDir:= Continue_ExcelName(feXMLFileDir,fePrintMethod,1,'_Posting Report');
      end;

      //PR: 24/05/2016 ABSEXCH-17450 Need to tell posting object that this is after reval
      FillChar(LPostParam, SizeOf(LPostParam), 0);
      LPostParam.AfterRevaluation := True;

      //NoIdCheck was set to true in Posting Start method when rep control parameter
      //was nil, so need to preserve
      LPostParam.NoIdCheck := True;
      AddPost2Thread(3,fMyOwner,fMyOwner,BOff,PParam,@LPostParam,StartedOk);


      {* Auto add full account post *}

    end;

  end;


  Procedure TRValueThread.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;



  Function TRValueThread.Start(RSyssCurr    :  CurrRec;
                               RSyssGCR     :  GCurRec)  :  Boolean;


  Const
    RateType     :  Array[BOff..BOn] of Str15 = ('Company Rate','Daily Rate');

  Var
    mbRet  :  Word;
    Failed,
    HasUnPd,
    HasCur1,
    C1X,CFloat,
    CTri,
    Locked :  Boolean;

    FutYr  :  Byte;
    FutORef:  Str20;

    KeyS   :  Str255;

    ISCtrl :  TMCRVCCDep;

  Begin
    Result:=BOn;

    USyssCurr:=RSyssCurr; Locked:=BOff;  Failed:=BOn;
    USyssGCR:=RSyssGCR;

    HasUnPd:=BOff; HasCur1:=BOff;  CTri:=BOff; C1X:=BOff; CFloat:=BOff;  FutYr:=0; FutORef:='';

    Try
      Begin
        Set_BackThreadMVisible(BOn);


        {$IFDEF LTE}

          If (Syss.UseCCDep) then
          Begin
        {$ENDIF}
            ISCtrl:=TMCRVCCDep.Create(Application.MainForm);

            try

              With ISCtrl do
              Begin
                mbRet:=InitIS;

                If (mbRet=mrOk) then
                Begin

                  NJCCDep:=BCCDep;

                  UReValueBack:=BRevert;
                end
                else
                  Result:=BOff;
              end;

            finally

              ISCtrl.Free;

            end; {Try..}
        {$IFDEF LTE}
          end
          else
          Begin
            Blank(NJCCDep,Sizeof(NJCCDep));
            URevalueBack:=BOff;
          end;
        {$ENDIF}

        {$IFDEF FRM}
          {$IFDEF Rp}
            If (Result) then {* Get printer details for posting report *}
              With PParam^ do
                Result:=pfSelectPrinter(PDevRec,UFont,Orient);

          {$ENDIF}
        {$ENDIF}


        Set_BackThreadMVisible(BOff);

        If (Result) then {* Check for valid NCC *}
        Begin
          Result:=CheckValidNCC(CommitAct);

          If (Not Result) then
          Begin
            AddErrorLog('Revaluation. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

            CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                           'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                           'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                           'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                           mtError,
                           [mbOk]);


          end
          else
          Begin
            Result:=Not HasUnpAlloc(HasUnPd,HasCur1,FutORef);

            If (Not Result) then
            Begin
              AddErrorLog('Revaluation. One or more of the unposted transactions is allocated.','',4);

              CustomDlg(Application.MainForm,'WARNING!','Allocated Transactions Detected',
                             'One or more of the unposted transactions is allocated. ('+FutORef+')'+#13+
                             'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                             'All unposted tranasactions must be unallocated during a revaluation.',
                             mtError,
                             [mbOk]);


            end
            else
            Begin
              {$B-}

              Result:=(UseCoDayRate) or Not HasFutureTrans(FutYr,FutOref);
              {$B+}

              If (Not Result) then
              Begin
                AddErrorLog('Revaluation. Transactions exist after the current period in '+IntToStr(ConvTxYrVal(FutYr,BOff))+'. ('+FutORef+')'+#13+
                            'Set the current period to '+IntToStr(ConvTxYrVal(FutYr,BOff)),'',4);

                CustomDlg(Application.MainForm,'WARNING!','Future Period Transactions Detected',
                               'Transactions exist after the current period in '+IntToStr(ConvTxYrVal(FutYr,BOff))+'. ('+FutORef+')'+#13+
                               'Set the current period to '+IntToStr(ConvTxYrVal(FutYr,BOff))+'.'+#13+
                               'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                               'All posted tranasactions must be revalued.',
                               mtError,
                               [mbOk]);


              end
              else
              Begin
                CheckCurMethod(USyssGCR,SyssGCuR^,USyssCurr,C1X,CFLoat,CTri);

                If (C1X or CFloat or CTri) and (HasUnPd or Not HasCur1) then
                Begin
                  If (HasUnPd) then
                  Begin
                    AddErrorLog('Revalue Transactions. Unposted transactions are not allowed when triangulation is changed.','',4);

                    CustomDlg(Application.MainForm,'WARNING!','Triangulation Changes Detected.',
                                 'Changes involving triangulation have been detected, when '+
                                  'unposted transactions are present.  These must be posted '+
                                  'before the revaluation may continue.',
                                 mtError,
                                 [mbOk]);

                    Result:=BOff;
                  end
                  else
                    If (Not HasCur1) then
                    Begin
                      AddErrorLog('Revalue Transactions. Special Function 54 has not been run on this data.','',4);

                      mbRet:=CustomDlg(Application.MainForm,'WARNING!','Triangulation Changes Detected.',
                                 'Changes involving triangulation have been detected, when '+
                                 'it appears special function 54 has not been run.'+#13+
                                 'Historical data may be corrupted if you continue.'+#13+#13+
                                 'Please confirm you wish to continue with the revaluation.',
                                 mtConfirmation,
                                 [mbYes,mbNo]);


                      Result:=(mbRet=mrOk);
                    end;
                end;
              end;
            end;
          end;
        end;


        {$IFDEF EXSQL}
        //PR: 20/08/2012 ABSEXCH-13308 Add check for result here, otherwise under SQL it runs the revaluation even if user cancelled.
        if Result and SQLUtils.UsingSQL then
        begin
          // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
          if (not Assigned(LPostLocal)) then
            Result := Create_LocalThreadFiles;

          If (Result) then
          begin
            MTExLocal := LPostLocal;

            Failed := BOff;
          end;
        end
        else
        {$ENDIF}
        begin
          If (Not Assigned(PostExLocal)) and (Result) then { Open up files here }
            Result:=Create_ThreadFiles;

          If (Result) then
          Begin
            MTExLocal:=PostExLocal;

            Failed:=BOff;
          end;
        end;
      end;

      {$IFDEF EXSQL}
      if Result and SQLUtils.UsingSQL then
      begin
        MTExLocal^.Close_Files;
        CloseClientIdSession(MTExLocal^.ExClientID, False);
      end;
      {$ENDIF}

    finally

        If (Failed) then  {* We must restore the currency rates back as we are aborting *}
        Begin
          Locked:=BOn;

          GetMultiSysCur(BOff,Locked); {* Restore values *}

          SyssCurr^:=RSyssCurr;

          Locked:=BOn;

          GetMultiSysGCur(BOff,Locked); {* Restore Triangulation values *}

          SyssGCuR^:=RSyssGCR;

          PutMultiSysGCur(BOn);

          PutMultiSysCur(BOn);



        end;

    end; {Try..}

  end;

  { ============== }


Function AddRevalue2Thread(AOwner       :  TObject;
                           RSyssCurr    :  CurrRec;
                           RSyssGCR     :  GCurRec)  : Boolean;





Var
  LRevalue_Nom :  ^TRValueThread;

Begin
  Result:=BOff;

  If (Create_BackThread) then
  Begin
    New(LRevalue_Nom,Create(AOwner));

    try
      With LRevalue_Nom^ do
      Begin
        If Start(RSyssCurr,RSyssGCR) and (Create_BackThread) then
        Begin
          With BackThread do
          begin
            //PR: 10/03/2016 ABSEXCH-17412 Put all thread processes to thread one until Check All Accounts has finished
            ThreadOneOnly := True;
            AddTask(LRevalue_Nom,'Revalue G/L');
          end;
          Result:=BOn;
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LRevalue_Nom,Destroy);
          Result:=BOff;
          SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plRevaluation), 0);
        end;
      end; {with..}

    except
      Dispose(LRevalue_Nom,Destroy);

      Result:=BOff;
    end; {try..}
  end; {If process got ok..}

end;


 procedure Revalue_Currency;

 Var
   //PR: 25/07/2012 ABSEXCH-12956 Change to use new currency list.
   RevalueCurr  :  TfrmCurrencyList;
   MsgForm      :  TThreadMsg;

   PrevHState   :  Boolean;

   mbRet        :  Word;

 begin
   PrevHState:=BOff;
   mbRet:=mrNone;

   If (Not InCurr) and (Not InMainThread) then
   Begin

     //PR: 25/07/2012 ABSEXCH-12956 Change to use new currency list.
     RevalueCurr := TfrmCurrencyList.CreateWithMode(Application.MainForm, clmRevalue);

     try

       SetAllowHotKey(BOff,PrevHState);

       //Only display form if we can revalue
       mbRet := mrCancel;
       if RevalueCurr.OKToRevalue then
          if RevalueCurr.LoadCurrencies then
             mbRet := RevalueCurr.ShowModal;

     finally
       RevalueCurr.Free;
       ReValueCurr:=nil;


       If (mbRet=mrOk) then {* we have started revaluing!*}
       Begin
         MsgForm:=TThreadMsg.Create(Application.MainForm);

         try
           With MsgForm do
           Begin
             Caption:='Currency Revaluation';
             Label2.Caption:='Please Wait. Revaluing General Ledger.';

             AdjustWidth(1,4);

             ShowModal;
           end;

         finally

           MsgForm.Free;

         end; {try..}

         // MH 04/08/2009 FRv6.01.211: Re-instated the CheckCust call which EL appears to have commented
         // out whilst working on BoM check mods (Entb601001src.zip) in order to reduce the time it took
         // to run
         // CJS 2015-03-31 - ABSEXCH-16163 - Check All Accounts, SQL improvements
         // CJS 2016-04-06 - ABSEXCH-17408 - Currency revaluation fails at Check all Accounts
         // Moved this code from TRValueThread.Process to here, to avoid
         // conflicts with the thread object.

         //PR: 13/05/2016 ABSEXCH-17450 Moved to EParentU so that it can be triggered after Posting has finished
(*         if SQLUtils.UsingSQLAlternateFuncs and SQLReportsConfiguration.UseSQLCheckAllAccounts then
           CheckAllAccounts(Application.MainForm, False)
         else
           AddCheckCust2Thread(Application.MainForm, '', BOn, BOn, BOff); *)

       end;


       SetAllowHotKey(BOn,PrevHState);


     end; {try..}
   end
   else
     ShowMessage('Currency revaluation is unavailable whilst a thread or the currency setup window is active.');
 end;


{$ENDIF}


{$IFDEF PF_On}
  {$IFDEF JC}
          { ========== TStkLocFill methods =========== }
    Constructor TJCGrpCertUpdate.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);

      fTQNo:=3;
      fCanAbort:=BOn;

      fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

      MTExLocal:=nil;

      FillChar(MasterEmpl,Sizeof(MasterEmpl),#0);

    end;


    Destructor TJCGrpCertUpdate.Destroy;

    Begin

      Inherited Destroy;


    end;


    { === Proc to update all related sub contract employees with a Group certificate == }

    Procedure TJCGrpCertUpdate.Update_GroupCert;

    Const
      Fnum     =  JMiscF;
      Keypath  =  JMTrdK;

    Var
      KeyChk,
      KeyS       : Str255;

      TotalCount,
      ItemCount  :  LongInt;

    Begin
      With MTExLocal^ do
      Begin
        ItemCount:=0;

        KeyChk:=PartCCKey(JARCode,JASubAry[3])+FullCustCode(MasterEmpl.Supplier);
        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

        ShowStatus(1,'Processing:-');

        TotalCount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId);

        InitProgress(TotalCount);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
        With LJobMisc^,EmplRec do
        Begin
          Inc(ItemCount);

          UpdateProgress(ItemCount);

          If (EmpCode<>MasterEmpl.EmpCode) then
          Begin
            ShowStatus(2,dbFormatName(EmpCode,EmpName));

            LabPLOnly:=MasterEmpl.LabPLOnly;

            If (GroupCert) then
            Begin
              CertNo:=MasterEmpl.CertNo;
              CertExpiry:=MasterEmpl.CertExpiry;
            end;

            LStatus:=LPut_Rec(Fnum,KeyPath);

            LReport_BError(Fnum,LStatus);

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

        end;

        UpdateProgress(TotalCount);

      end; {With..}
    end;





    Procedure TJCGrpCertUpdate.Process;

    Begin
      InMainThread:=BOn;

      Inherited Process;

      ShowStatus(0,'Updating other employees in the same company.');

      Update_GroupCert;
    end;


    Procedure TJCGrpCertUpdate.Finish;
    Begin
      Inherited Finish;

    end;


    Function TJCGrpCertUpdate.Start  :  Boolean;

    Var
      mbRet  :  Word;
      KeyS   :  Str255;

    Begin
      Result:=BOn;


      If (Result) then
      Begin
        If (Not Assigned(MTExLocal)) then { Open up files here }
        Begin
          {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
          begin
            // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
            if (not Assigned(LPostLocal)) then
              Result := Create_LocalThreadFiles;

            If (Result) then
              MTExLocal := LPostLocal;

          end
          else
          {$ENDIF}
          begin
            New(MTExLocal,Create(32));

            try
              With MTExLocal^ do
                Open_System(JMiscF,JMiscF);

            except
              Dispose(MTExLocal,Destroy);
              MTExLocal:=nil;

            end; {Except}
          end;
          Result:=Assigned(MTExLocal);
        end;
      end;
      {$IFDEF EXSQL}
      if Result and SQLUtils.UsingSQL then
      begin
        MTExLocal^.Close_Files;
        CloseClientIdSession(MTExLocal^.ExClientID, False);
      end;
      {$ENDIF}
    end;




   Procedure AddGrpCertUpdate2Thread(AOwner     :  TObject;
                                     LocalEmpl  :  EmplType);


    Var
      LUpdate_GrpCert :  ^TJCGrpCertUpdate;

    Begin

      If (Create_BackThread) then
      Begin
        New(LUpdate_GrpCert,Create(AOwner));

        try
          With LUpdate_GrpCert^ do
          Begin
            If (Start) and (Create_BackThread) then
            Begin
              MasterEmpl:=LocalEmpl;

              With BackThread do
                AddTask(LUpdate_GrpCert,'Cert Update');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LUpdate_GrpCert,Destroy);
            end;
          end; {with..}

        except
          Dispose(LUpdate_GrpCert,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;



  {$ENDIF}
{$ENDIF}



{$IFDEF STK}


  procedure Check_StockLevels(AllMode  :  Boolean;
                              fOwner   :  TComponent;
                              Fnum,
                              Keypath  :  Integer);

  Const
    StkTit  :  Array[BOff..Bon] of Str5 = ('','all ');


   Var
     NoThreadsR   :  Boolean;

     MsgForm      :  TStkChkFrm;

     CapTit       :  Str255;

     mbRet        :  Word;

   begin

     {$B-}
     NoThreadsR:=(Not Assigned(BackThread)) or (Not Assigned(BackThread.MainThreads[1]));
     {$B+}

     If (NoThreadsR) then {No Job 2 threads running so we can saelfy run}
     Begin

       CapTit:='Recalculate '+StkTit[AllMode]+'stock levels';

       Set_BackThreadMVisible(BOn);

       mbRet:=MessageDlg(Captit+'?',mtConfirmation,[mbYes,mbNo],0);

       //PR: 18/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
       if not GetProcessLock(plCheckStock) then
         EXIT;

       Set_BackThreadMVisible(BOff);

       If (mbRet=mrYes) then
       Begin
         // PS 09/09/2016 - ABSEXCH-17220 - Check All Stock Level, SQL improvements
         {if not CheckOk2SQLVer then  // (Ord(AllMode)=0)
         begin
           // For all Stock Item.
           if (Ord(AllMode)=0) then
             CheckSingleStock (Application.MainForm, Stock.StockCode, False)
           else
             CheckAllStock(Application.MainForm, False) ;
         end
         else }     // SSK 14/06/2018 2018-R1.1 ABSEXCH-20794 : section of code is commented so that the process runs as per pervasive style legacy code
         begin
           Set_BackThreadMVisible(BOn);

           MsgForm:=TStkChkFrm.Create(fOwner);

           try
             With MsgForm do
             Begin
               Caption:=CapTit;

               AdjustWidth(0,Ord(AllMode),Fnum,Keypath);

               ShowModal;
             end;

           finally
             Set_BackThreadMVisible(BOff);

             MsgForm.Free;

           end; {try..}
         end;
       end;   {If (mbRet=mrYes) then}
     end
     else
     Begin
       ShowMessage('Check Stock cannot be run whilst there is a thread running in thread queue 1.');

     end;
   end;


  { ========== TRevalueStk methods =========== }

  Constructor TRevalueStk.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    LocFilt:='';

    New(RPParam);

    Try
      With RPParam^ do
      Begin
        FillChar(RPParam^,Sizeof(RPParam^),0);

        UFont:=TFont.Create;

        try
          UFont.Assign(Application.MainForm.Font);
        except
          UFont.Free;
          UFont:=nil;
        end;

        {$IFDEF Rp}
          Orient:=RPDefine.PoPortrait;
        {$ENDIF}


        With PDevRec do
        Begin
          DevIdx:=-1;
          Preview:=BOn;
          NoCopies:=1;
        end;
      end;

    except
      RPParam:=nil;
    end;

  end;

  Destructor TRevalueStk.Destroy;

  Begin
    If (Assigned(RPParam)) then
    Begin

      RPParam.UFont.Free;

      Dispose(RPParam);
    end;

    Inherited Destroy;
  end;



    { ========================= Store Reversal Lines  ===================== }

    Procedure TRevalueStk.Reverse_BSValue(BSNCode,
                                          PLNCode:  LongInt;
                                     Var  Abort  :  Boolean);

    Const
      Fnum    =  IDetailF;
      Keypath =  IdRunK;

      Fnum2   =  NomF;

      Keypath2=  NomCodeK;


    Var
      Done  :  Boolean;
      Profit,
      Purch,
      Sales,
      Cleared
             :  Double;

      KeyS   :  Str255;


    Begin

      Profit:=0; Purch:=0; Sales:=0;  Cleared:=0;

      Done:=BOn;

      With MTExLocal^ do
      Begin

      KeyS:=FullRunNoKey(StkValRRunNo,BSNCode);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);



      If (Not LStatusOk) then
      Begin

        KeyS:=FullNomKey(BSNCode);

        LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyS);


        If (LStatusOk) then
        Begin

          Profit:=LProfit_To_Date(LNom.NomType,FullNomKey(BSNCode),
                                 0,GetLocalPr(0).CYr,GetLocalPr(0).CPr,
                                 Purch,Sales,Cleared,BOn);


          Create_NomTxfrLines(LId,MTEXLocal);



          With LId do
          Begin

            NomCode:=BSNCode;

            Desc:='Reverse stock value';

            If (LocFilt<>'') then
              Desc:=Desc+'. Location : '+LocFilt;


            PostedRun:=StkValRRunNo;

            NetValue:=Profit*DocNotCnst;

            Repeat

              LStatus:=LAdd_Rec(Fnum,KeyPath);

              LReport_BError(Fnum,LStatus);

              Abort:=Not LStatusOk;

              Done:=Not Done;

              NomCode:=PLNCode;

              NetValue:=NetValue*DocNotCnst;

            Until (Done) or (Abort);

          end; {With..}
        end; {If Ok..}
      end; {If Ok..}
    end; {With..}
  end; {Proc..}



  { ========= Procedure to Scan Stock Records an perform valuation ======== }


  Procedure TRevalueStk.Value_Stock(Var  Abort  :  Boolean);



  Const
    Fnum     =  StockF;
    Keypath  =  StkCodeK;


  Var
    CNomCode,
    ItemTotal,
    ItemCount  :  LongInt;


    Profit,
    Purch,
    Sales,
    Cleared,
    ThisStkVal
               :  Double;


    InitBo     :  Boolean;



    HedDesc,
    KeyS       :  Str255;




  Begin

    InitBo:=BOff;

    With MTExLocal^ do
    Begin
      InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

      ItemCount:=0;

      Profit:=0; Purch:=0; Sales:=0;  Cleared:=0; CNomCode:=0;


      If (LocFilt<>'') then
        HedDesc:=' -'+LocFilt
      else
        HedDesc:='';


      LStatus:=LFind_Rec(B_StepFirst,Fnum,KeyPath,KeyS);



      If (LStatusOk) then
        Create_NTHed(Abort,InitBo,HedDesc,1,MTExLocal);


      While (LStatusOk) and (Not Abort) and (Not ThreadRec^.THAbort) do
      With LStock do
      Begin

        ShowStatus(2,dbFormatName(StockCode,Desc[1]));

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        {$IFDEF SOP}


          {LStock_LocNSubst(LStock,LocFilt);}

          LStock_LocLinkSubst(LStock,LocFilt);

        {$ENDIF}


        If (StockType In StkProdSet) then
        Begin
          {$IFDEF LTE} {* EL: For lite set b/s to be BOM Code, as otherwise if set to normal reversal of main stk b/s will cause a difference between the tb and stock valuation report. *}
            If (StockType=StkBillCode) then
              CNomCode:=NomCodes[5]
            else
          {$ENDIF}
            CNomCode:=NomCodes[4];

          Reverse_BSValue(CNomCode,NomCodeS[3],Abort);

          If (Not Abort) then
          Begin

            {* Get Posted Qty *}

            Profit:=LProfit_To_Date(Calc_AltStkHCode(StockType),CalcKeyHist(StockFolio,LocFilt),
                                   0,GetLocalPr(0).CYr,GetLocalPr(0).CPr,
                                   Purch,Sales,Cleared,BOn);

            ThisStkVal:=Round_Up(StkCalc_AVCost(LStock,LocFilt,MTExLocal)*Cleared,2);

            Add_StockValue(CNomCode,NomCodeS[3],ThisStkVal,'',LInv.OurRef,CCDep,CCDep,BOff,Abort,MTExLocal);

          end;
        end;

        LStatus:=LFind_Rec(B_StepNext,Fnum,KeyPath,KeyS);

      end; {While..}

      If (Not Abort) then
        Reset_NomTxfrLines(LInv,MTExLocal);

    end; {With..}
  end; {Proc..}


  { ========== Main Stock Revaluation Routine ========= }


  Procedure TRevalueStk.Control_Stock_ReValue;


  Var

    StartedOk,
    Abort        :  Boolean;


  Begin
    Abort:=BOff; StartedOk:=BOff;

    With MTExLocal^ do
    Begin


      Value_Stock(Abort);


      If (Not Abort) then
      Begin
        // CJS 2011-08-03 ABSEXCH-11019 - Stock Valuation access violation
        // At this point, fMyOwner references the TRepInpMsgJ dialog, which
        // will have been freed by now, so pass nil instead.
        AddPost2Thread(3, nil, nil, BOff, RPParam, nil, StartedOk);
      end;
    end; {If Not Sure..}
  end; {Proc..}


  Procedure TRevalueStk.Process;



  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Stock Valuation.');

    Control_Stock_ReValue;

  end;


  Procedure TRevalueStk.Finish;
  Begin
    
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;



  Function TRevalueStk.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('Please Confirm you wish to Value the Stock.',mtConfirmation,[mbYes,mbNo],0);

    Result:=(mbRet=mrYes);

    If (Result) then
    With RPParam^ do
    Begin

      {$IFDEF Frm}
        Result:=pfSelectPrinter(PDevRec,UFont,Orient);
      {$ENDIF}

    end;

    Set_BackThreadMVisible(BOff);

    If (Result) then
    Begin
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
      begin
        // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
        if (not Assigned(LPostLocal)) then
          Result := Create_LocalThreadFiles;

        If (Result) then
          MTExLocal := LPostLocal;

      end
      else
      {$ENDIF}
      begin
        If (Not Assigned(PostExLocal)) then { Open up files here }
          Result:=Create_ThreadFiles;

        If (Result) then
          MTExLocal:=PostExLocal;
      end;
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
  end;


  Procedure AddStkValue2Thread(AOwner   :  TObject;
                               LFilt    :  Str10);




  Var
    LCheck_Stk :  ^TRevalueStk;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          If (Start) and (Create_BackThread) then
          Begin
            LocFilt:=LFilt;

            With BackThread do
              AddTask(LCheck_Stk,'Revalue Stock');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  {=====================}




{$IFDEF PF_On}

  { ========== TCalcBOMCost methods =========== }

  Constructor TCalcBOMCost.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    {$IFDEF Rp}
      FillChar(RDevRec,Sizeof(RDevRec),0);

      With RDevRec do
      Begin
        DevIdx:=-1;
        Preview:=BOn;
        NoCopies:=1;
      end;


      RFont:=TFont.Create;

      try
        RFont.Assign(Application.MainForm.Font);
      except
        RFont.Free;
        RFont:=nil;
      end;

      ROrient:=RPDefine.PoPortrait;

    {$ENDIF}

    SMemo:=TStringList.Create;

    OptDupliList:=TList.Create;

    CheckMode:=0; {* EL BoM Check implementation from DOS code *}
  end;

  Destructor TCalcBOMCost.Destroy;

  Begin

    Inherited Destroy;

    {$IFDEF Rp}
      If (Assigned(RFont)) then
        RFont.Free;
    {$ENDIF}

    SMemo.Free;

    OptDupliList.Free;
  end;


{ == Protected function to return production time == }
{ Replicated within PayF2U }


Function TCalcBOMCost.LGet_StkProdTime(SCode  :  Str10)  :  LongInt;

Const
    Fnum     =  StockF;
    Keypath  =  StkFolioK;

Var
  StockR  :  StockRec;
  TmpKPath,
  LocalStat,
  TmpStat :  Integer;

  TmpRecAddr
          :  LongInt;

  KeyS    :  Str255;


Begin
  With MTExLocal^ do
  Begin
    StockR:=LStock;

    TmpKPath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    If (FullNomKey(LStock.StockFolio)<>SCode) then
    Begin
      KeyS:=SCode;

      LocalStat:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyS);

      If (LocalStat<>0) then
        LResetRec(Fnum);

    end;


    Result:=LStock.ProdTime;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


    LStock:=StockR;
  end; {With..}
end;



{*** This routine has been replicated within StockU ***}

{* EL BoM Check implementation from DOS code part II*}

Procedure TCalcBOMCost.Re_CalcCostPrice(SRecAddr  :  LongInt);


  Const
    Fnum      =  PWrdF;
    Keypath   =  PWk;

    Fnum2     =  StockF;
    Keypath2  =  StkFolioK;




  Var

    TmpKPath,
    TmpKPath2,
    TmpStat   :  Integer;

    RecAddr2,
    TmpRecAddr,
    TmpRecAddr2
              :  LongInt;

    BStock    :  StockRec;

    LOk,
    Locked    :  Boolean;

    KeyS,
    KeyChk,
    KeyStk    :  Str255;

    TmpPWrd   :  PassWordRec;



  Begin
    RecAddr2:=0;  TmpKPath2:=0; TmpRecAddr2:=0;

    With MTExLocal^ do
    Begin
      BStock:=LStock;

      If (FIFO_Mode(BStock.StkValType)=4) then
        BStock.ROCPrice:=0
      else
        BStock.CostPrice:=0;

      BStock.BOMProdTime:=0;


      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],TmpRecAddr,BOff,BOff);

      KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(BStock.StockFolio)));


      KeyS:=KeyChk;


      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LPassword.BillMatRec do
      Begin

        KeySTk:=BillLink;

        LStatus:=LFind_Rec(B_GetEq,Fnum2,Keypath2,KeyStk);

        If (LStatusOk) then
        Begin

          If (CheckMode=1) and (LStock.StockType=StkBillCode) and (Not CheckedAlready(LStock.StockFolio)) then {* Keep track of stock records already processed *}
          Begin
            OptDupliList.Add(Pointer(LStock.StockFolio));  {* Add to processed list to avoid duplicate calculations *}

            LStatus:=LGetPos(Fnum2,RecAddr2);

            TmpKPath2:=Keypath;

            TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOff,BOff);

            TmpPWrd:=LPassword;

            Re_CalcCostPrice(RecAddr2); {* Recursively call until all levels of BoM are processed *}

            TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);

            LPassword:=TmpPWrd;

          end;

          QCurrency:=BStock.PCurrency;

          QtyCost:=Round_Up(Calc_StkCP(Currency_ConvFT(LStock.CostPrice,LStock.PCurrency,QCurrency,
                                                  UseCoDayRate),LStock.BuyUnit,LStock.CalcPack),Syss.NoCosDec);


          Calc_BillCost(QtyUsed,QtyCost,BOn,BStock,QtyTime);

          LStatus:=LPut_Rec(Fnum,KeyPath);

          LReport_BError(Fnum,LStatus);

        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);

      end; {While..}


      If (CheckMode=1) and (SRecAddr<>0) then
      Begin
        LSetDataRecOfs(Fnum2,SRecAddr); {* Re-establish stock record *}

        LStatus:=LGetDirect(Fnum2,KeyPath2,0);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyStk,KeyPath2,Fnum2,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LStock:=BStock; {* Overwrite new stock costs and times *}

          LStatus:=LPut_Rec(Fnum2,KeyPath2);

          LReport_BError(Fnum2,LStatus);

          //PR: 09/06/2014 ABSEXCH-15107 Need to unlock the record we've locked - held in SRecAddr
          LStatus:=UnLockMLock(Fnum2, SRecAddr);

        end;

      end;

      LResetRec(Fnum);

      TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],TmpRecAddr,BOn,BOff);

      LStock:=BStock;
    end; {With..}
  end; {Proc..}


  {*** This routine has been replicated within StkBOMIU ***}

  Function TCalcBOMCost.LBOMWithBOM(BOM2Chk,
                                    ThisBom  :  StockRec)  :  Boolean;
  Const
    Fnum      =  PWrdF;
    Keypath   =  HelpNdxK;

    Fnum2     =  StockF;
    Keypath2  =  StkFolioK;




  Var
    FoundOk   :  Boolean;

    TmpKPath,
    TmpKPath2,
    TmpStat   :  Integer;

    TmpRecAddr,
    TmpRecAddr2
              :  LongInt;

    KeyS,
    KeyChk,
    KeyStk    :  Str255;


    TmpPWrd   :  PassWordRec;

    TmpStock  :  StockRec;

  Begin
    With MTExLocal^ do
    Begin
      FoundOk:=BOff;

      TmpStock:=LStock;
      TmpPWrd:=LPassWord;

      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath2,LocalF^[Fnum2],TmpRecAddr2,BOff,BOff);

      KeyChk:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(ThisBom.StockFolio)));

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
      With LPassword.BillMatRec do
      Begin

        KeySTk:=Copy(StockLink,1,Sizeof(TmpRecAddr));

        LStatus:=LFind_Rec(B_GetEq,Fnum2,Keypath2,KeyStk);


        If (LStatusOk) then
        Begin

          FoundOk:=(LStock.StockFolio=BOM2Chk.StockFolio);

          If (Not FoundOk) and (LStock.StockType=StkBillCode) then
            FoundOk:=LBOMWithBOM(BOM2Chk,LStock);

        end;

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);

      end; {While..}


      LStock:=TmpStock;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath2,LocalF^[Fnum2],TmpRecAddr2,BOn,BOff);

      LPassWord:=TmpPWrd;

      LBOMWithBOM:=FoundOk;

    end; {With..}
  end; {Proc..}

{ == Check for duplicate processing to avoid calling check more than once on the same stock item == }

Function TCalcBOMCost.CheckedAlready(SFol  :  LongInt)  :  Boolean;

Var
  n  :  LongInt;


Begin
  Result:=BOff;

  With OptDupliList do
  Begin
    For n:=0 to Pred(Count) do
    Begin
      If (Items[n]=Pointer(SFol)) then
      Begin
        Result:=BOn;
        Break;
      end;
    end;

  end; {With..}
end;


{ ==== Follow Chain and update Cost Prices ==== }



  Procedure TCalcBOMCost.Update_Kits(StockR  :  StockRec);

  Const

    Fnum     =  PWrdF;

    Keypath  =  HelpNdxK;


    Fnum2    =  StockF;
    Keypath2 =  StkFolioK;



  Var
    KeyS,
    KeyChk,
    KeyStk   :  Str255;

    NewCost  :  Real;

    NewTime,
    RecAddr  :  LongInt;

    BOMWith,
    LOk,
    Locked   :  Boolean;



  Begin
    BOMWith:=BOff;

    With StockR do
    Begin

      KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

      KeyChk:=KeyS;

    end;

    With MTExLocal^ do
    Begin

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LPassword.BillMatRec do
      Begin

        Locked:=BOff;

        If (ThreadRec^.THAbort) then
          ShowStatus(3,'Please wait, finishing last record.');



        LStatus:=LGetPos(Fnum,RecAddr);


        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin

          LGetRecAddr(Fnum);

          NewCost:=Round_Up(Calc_StkCP(Currency_ConvFT(StockR.CostPrice,StockR.PCurrency,QCurrency,
                                                UseCoDayRate),StockR.BuyUnit,StockR.CalcPack),Syss.NoCosDec);

          With StockR do
            NewTime:=ProdTime+BOMProdTime;

          If (NewCost<>QtyCost) or (NewTime<>QtyTime) then
          Begin

            KeySTk:=Copy(StockLink,1,Sizeof(RecAddr));

            LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyStk,KeyPath2,Fnum2,BOn,Locked);

            If (LOk) and (Locked) then
            Begin

              LGetRecAddr(Fnum2);

              Calc_BillCost(QtyUsed,QtyCost,BOff,LStock,QtyTime);

              QtyCost:=NewCost;
              QtyTime:=NewTime;

              Calc_BillCost(QtyUsed,QtyCost,BOn,LStock,QtyTime);


              LStatus:=LPut_Rec(Fnum,KeyPath);

              LReport_BError(Fnum,LStatus);

              LStatus:=LUnLockMLock(Fnum);

              If (LStatusOk) and (Not CheckedAlready(LStock.StockFolio)){v5.52. Run check for all valuation methods and (Is_FIFO(LStock.StkValType))} then {* Re Calculate  BOM cost as otherwise it does not add up *}
              Begin
                Re_CalcCostPrice(0); {* EL BoM Check implementation from DOS code part II*}


                OptDupliList.Add(Pointer(LStock.StockFolio));
              end;

              {* Update last edited flag *}

              LStock.LastUsed:=Today;
              LStock.TimeChange:=TimeNowStr;

              LStatus:=LPut_Rec(Fnum2,KeyPath2);

              LReport_BError(Fnum2,LStatus);

              LStatus:=LUnLockMLock(Fnum2);

              If (StockR.StockType=StkBillCode) then
                BOMWith:=LBOMWithBOM(StockR,LStock)
              else
                BOMWith:=BOff;

              If (Not BOMWith) then
                UpDate_Kits(LStock)
              else
              Begin
                SMemo.Add(Trim(LStock.StockCode)+' is already contained in '+Trim(StockR.StockCode));

                AddErrorLog('Stock Update Costing Error',Trim(LStock.StockCode)+' is already contained in '+Trim(StockR.StockCode),2);
              end;

            end;

          end {If Cost Changed..}
          else
            LStatus:=LUnLockMLock(Fnum);

        end; {If Locked Ok..}


        LSetDataRecOfs(Fnum,RecAddr);

        LStatus:=LGetDirect(Fnum,KeyPath,0);


        LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);

      end; {While..}

    end; {With..}

  end; {Proc..}



  { ========= Scan all Cost Prices ======= }

  // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 SQL Update Build Costs from v7.0.11 Post
  Procedure TCalcBOMCost.SQL_Scan_Bill;
  Var
    oLogger : TEntSQLReportLogger;
    sqlCaller : TSQLCaller;
    fldStockFolio : TIntegerField;
    CompanyCode : ANSIString;
    ConnectionString,
    lPassword : WideString;  //VA:31/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    sqlQuery: AnsiString;
    sKey : Str255;
    ItemCount : Integer;
  Begin // SQL_Scan_Bill
    oLogger := TEntSQLReportLogger.Create('UpdateBuildCosts');
    Try
      // Get Company Read-Only Connection String
      CompanyCode := GetCompanyCode(SetDrive);
      //If (GetConnectionString(CompanyCode, True, ConnectionString) = 0) Then
      //VA:27/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
      If (GetConnectionStringWOPass(CompanyCode, True, ConnectionString, lPassword) = 0) Then
      Begin
        // Create SQL Query object to use to pull back a list of BoM Component Stock Codes
        //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
        sqlCaller := TSQLCaller.Create(GlobalAdoConnection);
        Try
          sqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;

          // Pull back a list of the Stock Records which are used as components by Bill of
          // Materials Stock Records.
          // Note: The legacy code being superceded processes the Stock in Folio Number Order - we
          // don't know if there is a reason for that, so we have kept the same order
          sqlQuery := 'Select Distinct Exchqchkcode3Trans2 As ''ComponentFolio'' ' +
                        'From [COMPANY].ExchqChk ' +
                       'Where (RecPfix = ''B'') And (SubType = 77) ' +
                       'Order By Exchqchkcode3Trans2';

          ShowStatus(1,'Processing:-');

          oLogger.StartQuery(sqlQuery);
          sqlCaller.Select(sqlQuery, CompanyCode);
          oLogger.FinishQuery;
          Try
            If (sqlCaller.ErrorMsg = '') Then
            Begin
              oLogger.QueryRowCount(sqlCaller.Records.RecordCount);
              If (sqlCaller.Records.RecordCount > 0) Then
              Begin
                InitProgress(sqlCaller.Records.RecordCount);

                // Disable the link to the UI to improve performance when iterating through the dataset
                sqlCaller.Records.DisableControls;
                Try
                  fldStockFolio := sqlCaller.Records.FieldByName('ComponentFolio') As TIntegerField;

                  ItemCount := 0;
                  sqlCaller.Records.First;
                  While (Not sqlCaller.Records.EOF) Do
                  Begin
                    // Load the Stock Record using the Folio index as per the legacy code
                    sKey := FullNomKey (fldStockFolio.Value);
                    MTExLocal^.LStatus := MTExLocal^.LFind_Rec(B_GetEq, StockF, StkFolioK, sKey);
                    If (MTExLocal^.LStatus = 0) Then
                    Begin
                      ShowStatus(2, dbFormatName(MTExLocal^.LStock.StockCode, MTExLocal^.LStock.Desc[1]));
                      Inc(ItemCount);
                      UpdateProgress(ItemCount);

                      // Call the legacy code to recalulate costs
                      Update_Kits(MTExLocal^.LStock);
                    End // If (MTExLocal^.LStatus = 0)
                    Else
                      ;  // Shouldn't ever happen - also running in thread so displaying an error is dodgy

                    sqlCaller.Records.Next;
                  End; // While (Not sqlCaller.Records.EOF) And (Status = 0) And KeepRun
                Finally
                  sqlCaller.Records.EnableControls;
                End; // Try..Finally
              End; // If (sqlCaller.Records.RecordCount > 0)
            End // If (sqlCaller.ErrorMsg = '') And (sqlCaller.Records.RecordCount > 0)
            Else
              oLogger.LogError('Query Error', sqlCaller.ErrorMsg);
          Finally
            sqlCaller.Close;
          End; // Try..Finally
        Finally
          sqlCaller.Free;
        End; // Try..Finally
      End; // If (GetConnectionString(CompanyCode, False, ConnectionString) = 0)
    Finally
      oLogger.Free;
    End; // Try..Finally
  End; // SQL_Scan_Bill

  //------------------------------

  Procedure TCalcBOMCost.Scan_Bill;
  Const
    Fnum      =  StockF;
    Keypath   =  StkFolioK;
  Var
    KeyS,
    KeyChk,
    KeyStk    :  Str255;

    ContRun   :  Boolean;

    ItemCount,
    ItemTotal,
    RecAddr   :  LongInt;
  Begin
    // MH 23/04/2015 v7.0.14 ABSEXCH-15749: Copied ABSEXCH-15725 SQL Update Build Costs from v7.0.11 Post
    If SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLUpdateBuildCosts And (CheckMode = 0) Then
    Begin
      SQL_Scan_Bill;
    End // If SQLUtils.UsingSQL And (CheckMode = 0)
    Else
  Begin
      With MTExLocal^ do
    Begin
        KeyS:=FullNomKey(1);

        LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

        ContRun:=BOn;

        RecAddr:=0;

        ItemCount:=0;

        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        ShowStatus(1,'Processing:-');


        While (LStatusOk) and (ContRun) and (Not ThreadRec^.THAbort) do
        With LStock do
        Begin

          ShowStatus(2,dbFormatName(StockCode,Desc[1]));

          KeyChk:=FullNomKey(StockFolio);

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          LStatus:=LGetPos(Fnum,RecAddr);

          Case CheckMode of {* EL BoM Check implementation from DOS code part II*}

            1  : If (StockType=StkBillCode) and (Not CheckedAlready(StockFolio)) then
                 Begin
                   Re_CalcCostPrice(RecAddr);
                 end;


            else  Update_Kits(LStock);

          end; {Case..}

          LSetDataRecOfs(Fnum,RecAddr);

          LStatus:=LGetDirect(Fnum,KeyPath,0);

          LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);
        end; {While..}
      end; {With..}
    End; // Else

    Update_UpChange(BOff);

    Send_UpdateList(8);
  end; {Proc..}




  Procedure TCalcBOMCost.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Update Bill of Material Costing.');

    Scan_Bill;

  end;


  Procedure TCalcBOMCost.Finish;
  Begin
    {$IFDEF Rp}
      If (SMemo.Count>0) then
        AddMemoRep2Thread(RDevRec,SMemo,'Update Build Costing Errors',Application.MainForm);
    {$ENDIF}


    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;




  Function TCalcBOMCost.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('Please confirm you wish to update all costings.',mtConfirmation,[mbYes,mbNo],0);

    Result:=(mbRet=mrYes);

    Set_BackThreadMVisible(BOff);

    If (Result) then
    Begin


      If (Not Assigned(MTExLocal)) then { Open up files here }
      Begin
        {$IFDEF EXSQL}
        if SQLUtils.UsingSQL then
        begin
          // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
          if (not Assigned(LPostLocal)) then
            Result := Create_LocalThreadFiles;

          If (Result) then
            MTExLocal := LPostLocal;

        end
        else
        {$ENDIF}
        begin
          New(MTExLocal,Create(11));

          try
            With MTExLocal^ do
              Open_System(StockF,PWrdF);

          except
            Dispose(MTExLocal,Destroy);
            MTExLocal:=nil;

          end; {Except}
        end;
        Result:=Assigned(MTExLocal);
      end;
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
  end;




  Procedure AddBOMUpdate2Thread(AOwner   :  TObject;
                                BCMode   :  Byte); {* EL BoM Check implementation from DOS code *}


  Var
    LCheck_Stk :  ^TCalcBOMCost;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          If (Start) and (Create_BackThread) then
          Begin
            CheckMode:=BCMode; {* EL BoM Check implementation from DOS code *}

            With BackThread do
              AddTask(LCheck_Stk,'Update BOMs');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;



  {$IFDEF SOP}
    { ========== TStkFreeze methods =========== }

    Constructor TStkFreeze.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);

      fTQNo:=3;
      fCanAbort:=BOn;

      fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

      MTExLocal:=nil;

      StkFilt:='';
      RunFreeze:=BOn;

    end;

    Destructor TStkFreeze.Destroy;

    Begin

      Inherited Destroy;


    end;



    { ========= Procedure to Update default Stock Valuation ========= }

    Procedure  TStkFreeze.Change_StkVal;


    Var
      Fnum,
      Keypath  :  Integer;

      KeyS     :  Str255;

      LOk,
      NoLoop,
      Locked   :  Boolean;

      ItemCount:  LongInt;

      Profit,
      Purch,
      Sales,
      Cleared,
      Rnum
                :  Double;

      TmpStk    :  StockRec;


      SQLResult: Integer;

    Begin

      Profit:=0; Purch:=0; Sales:=0;  Cleared:=0;

      Fnum:=StockF;

      Keypath:=StkCodeK;

      ItemCount:=0;

      ShowStatus(1,'Processing:-');

      Locked:=BOff;

      NoLoop:=BOn;

      KeyS:='';

      if SQLUtils.UsingSQL then
      begin
        // CJS 2011-08-04 ABSEXCH-11373 - Added Client ID to call
        SQLResult := SQLUtils.StockFreeze(SetDrive, StkFilt, UsePostQty, GetLocalPr(0).CYr, GetLocalPr(0).CPr, MTExLocal^.ExClientId);
        if (SQLResult = -1) then
          ShowMessage(SQLUtils.LastSQLError);
{
        if (MTExLocal^.LStatus = -1) then
          MTExLocal^.LReport_BError(Fnum, MTExLocal^.LStatus);
}
      end
      else
      With MTExLocal^ do
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (NoLoop) and (Not ThreadRec^.THAbort) do
        With LStock do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Begin

            ShowStatus(2,dbFormatName(StockCode,Desc[1]));

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              If (UsePostQty) then
              Begin

                Profit:=LProfit_To_Date(Calc_AltStkHCode(StockType),
                                       CalcKeyHist(StockFolio,StkFilt),
                                       0,GetLocalPr(0).CYr,GetLocalPr(0).CPr,
                                       Purch,Sales,Cleared,BOn);

                QtyPosted:=Cleared;

                QtyFreeze:=QtyPosted;
              end
              else
              Begin
                TmpStk:=LStock;

                LStock_LocSubst(TmpStk,StkFilt);

                QtyFreeze:=TmpStk.QtyInStock;
              end;

              QtyTake:=QtyFreeze;

              StkFlg:=BOff;


              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              LStatus:=LUnLockMLock(Fnum);

              If (LStatusOk) and (Not EmptyKey(StkFilt,LocKeyLen)) then
                LUpdate_LocROTake(LStock,StkFilt,1);

            end;

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}

      If (fMyOwner is TForm) then
        SendMessage(TForm(fMyOWner).Handle,WM_CustGetRec,302,0);

    end; {Proc..}




    Procedure TStkFreeze.Process;

    Begin
      InMainThread:=BOn;

      Inherited Process;

      If (RunFreeze) then
      Begin
        ShowStatus(0,'Freeze Stock Levels.');

        Change_StkVal;
      end;
    end;


    Procedure TStkFreeze.Finish;
    Begin
      Inherited Finish;

      {Overridable method}

      InMainThread:=BOff;

    end;




    Function TStkFreeze.Start  :  Boolean;

    Var
      mbRet  :  Word;
      KeyS   :  Str255;

    Begin
      Result:=BOn;


      If (Result) then
      Begin
        If (Not Assigned(MTExLocal)) then { Open up files here }
        Begin
          {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
          begin
            // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
            if (not Assigned(LPostLocal)) then
              Result := Create_LocalThreadFiles;

            If (Result) then
              MTExLocal := LPostLocal;

          end
          else
          {$ENDIF}
          begin
            New(MTExLocal,Create(16));

            try
              With MTExLocal^ do
                Open_System(StockF,MLocF);

            except
              Dispose(MTExLocal,Destroy);
              MTExLocal:=nil;

            end; {Except}
          end;
          Result:=Assigned(MTExLocal);

        end;
      end;
      {$IFDEF EXSQL}
      if Result and SQLUtils.UsingSQL then
      begin
        MTExLocal^.Close_Files;
        CloseClientIdSession(MTExLocal^.ExClientID, False);
      end;
      {$ENDIF}
    end;




   Procedure AddStkFreeze2Thread(AOwner     :  TObject;
                                 UsePost    :  Boolean;
                                 UStkFilt   :  Str10);


    Var
      LCheck_Stk :  ^TStkFreeze;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Stk,Create(AOwner));

        try
          With LCheck_Stk^ do
          Begin
            If (Start) and (Create_BackThread) then
            Begin
              UsePostQty:=UsePost;
              StkFilt:=UStkFilt;

              With BackThread do
                AddTask(LCheck_Stk,'Freeze Stk');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LCheck_Stk,Destroy);
            end;
          end; {with..}

        except
          Dispose(LCheck_Stk,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;


   { ========== TStkLocOR methods =========== }
    Constructor TStkLocOR.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);
      RunFreeze:=BOff;

    end;


    Destructor TStkLocOR.Destroy;

    Begin

      Inherited Destroy;


    end;



    { ========= Procedure to Update default Stock Valuation ========= }

    Procedure  TStkLocOR.Replace_Inter(lc    :  Str10;
                                       Mode  :  Byte);



    Var
      Fnum,
      Keypath    :  Integer;

      KeyS       :  Str255;
      LOk,
      Locked     :  Boolean;

      ItemCount  :  LongInt;

      TSL        :  MStkLocType;

      FuncRes: Integer;

    Begin

      Fnum:=StockF;

      Keypath:=StkCodeK;

      ItemCount:=0;

      ShowStatus(1,'Processing:-');

      Locked:=BOff;

      KeyS:='';

      if SQLUtils.UsingSQLAlternateFuncs then
//      if False then // Not available yet.
      begin
        ItemCount := Used_RecsCId(MTExLocal^.LocalF^[Fnum], Fnum, MTExLocal^.ExClientId);
        InitProgress(ItemCount);

        // CJS 2011-08-04 ABSEXCH-11373 - Added Client ID to call
        FuncRes := SQLUtils.StockLocationFilter(SetDrive, lc, Mode, MTExLocal^.ExClientId);

        UpdateProgress(ItemCount);

        if (FuncRes = -1) then
        begin
          if (Assigned(MTExLocal^.LThShowMsg)) then
          begin
            MTExLocal^.LThShowMsg(nil, 2, 'Error applying Stock Location filter: ' + SQLUtils.LastSQLError);
            AddErrorLog('Error applying Stock Location filter: ' + SQLUtils.LastSQLError, '', 3);
          end;

//          else
//            Report_MTBError(Fnum,ErrNo,ExClientId);
        end;
      end
      else with MTExLocal^ do
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        LStatus:=LFind_Rec(B_StepFirst,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not ThreadRec^.THAbort) do
        With LStock do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          If (StockType<>StkGrpCode) then
          Begin

            ShowStatus(2,dbFormatName(StockCode,Desc[1]));

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              If (LLinkMLoc_Stock(lc,StockCode,TSL)) or (Mode In [3,5]) then
              Begin
                Case Mode of
                  0  :  SuppTemp:=FullCustCode(TSL.lsSupplier);
                  2  :  BinLoc:=LJVar(TSL.lsBinLoc,BinLocLen);
                  3  :  SuppTemp:=Supplier;
                  5  :  BinLoc:=TempBLoc;
                end; {Case..}

                LStatus:=LPut_Rec(Fnum,Keypath);

                LReport_BError(Fnum,LStatus);
              end;

              LStatus:=LUnLockMLock(Fnum);
            end;

          end;

          LStatus:=LFind_Rec(B_StepNext,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}

      If (fMyOwner is TForm) then
        SendMessage(TForm(fMyOWner).Handle,WM_CustGetRec,301+Ord(Mode In [2,5]),0);

    end; {Proc..}




    Procedure TStkLocOR.Process;

    Begin
      InMainThread:=BOn;

      Inherited Process;

      ShowStatus(0,'Copy Location Details.');

      Replace_Inter(StkFilt,InterMode);
    end;


    Procedure TStkLocOR.Finish;
    Begin
      Inherited Finish;

    end;


   Procedure AddStkLocOR2Thread(AOwner     :  TObject;
                                UStkFilt   :  Str10;
                                UMode,
                                TQ         :  Byte);


    Var
      LCheck_Stk :  ^TStkLocOR;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Stk,Create(AOwner));

        try
          With LCheck_Stk^ do
          Begin
            fTQNo:=TQ;

            If (Start) and (Create_BackThread) then
            Begin
              InteRMode:=UMode;
              StkFilt:=UStkFilt;

              With BackThread do
                AddTask(LCheck_Stk,'Loc Update');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LCheck_Stk,Destroy);
            end;
          end; {with..}

        except
          Dispose(LCheck_Stk,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;





      { ========== TStkLocFill methods =========== }
    Constructor TStkLocFill.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);
      RunFreeze:=BOff;
    end;


    Destructor TStkLocFill.Destroy;

    Begin

      Inherited Destroy;


    end;



    { ========= Procedure to Update default Stock Valuation ========= }

    Procedure  TStkLocFill.Fill_MStkLoc(StockR  :  StockRec);


    Var
      Fnum,
      Keypath    :  Integer;

      KeyChk,
      KeyS       :  Str255;
      LOk,
      Locked     :  Boolean;

      ItemCount  :  LongInt;

      TmpKPath,
      TmpStat    :  Integer;
      TmpRecAddr :  LongInt;

      TLocLoc    :  MLocLocType;



    Begin

      Fnum:=MLocF;

      Keypath:=MLK;

      ItemCount:=0;

      ShowStatus(1,'Processing:-');

      Locked:=BOff;

      KeyChk:=PartCCKey(CostCCode,CSubCode[BOn]);

      KeyS:=KeyChk;

      With MTExLocal^ do
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With LMLocCtrl^,MStkLoc do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Begin

            TmpKPath:=Keypath;

            TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

            TLocLoc:=MLocLoc;

            With TLocLoc do
              ShowStatus(2,dbFormatName(loCode,loName));

            If (Not LLinkMLoc_Stock(TLocLoc.loCode,StockR.StockCode,MStkLoc)) then
            Begin
              LResetRec(Fnum);

              RecPFix:=CostCCode;

              SubType:=CSubCode[BOff];

              lsLocCode:=TLocLoc.loCode;

              SetROConsts(StockR,MStkLoc,TLocLoc);

              LStatus:=LAdd_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);

            end;

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}

      If (fMyOwner is TForm) then
        SendMessage(TForm(fMyOWner).Handle,WM_CustGetRec,117,0);

    end; {Proc..}




    Procedure TStkLocFill.Process;

    Begin
      InMainThread:=BOn;

      Inherited Process;

      ShowStatus(0,'Generate Stock Location Records.');

      Fill_MStkLoc(MTExLocal^.LStock);
    end;


    Procedure TStkLocFill.Finish;
    Begin
      Inherited Finish;

    end;





   Procedure AddStkLocFill2Thread(AOwner     :  TObject;
                                  StockR     :  StockRec);


    Var
      LCheck_Stk :  ^TStkLocFill;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Stk,Create(AOwner));

        try
          With LCheck_Stk^ do
          Begin
            If (Start) and (Create_BackThread) then
            Begin
              MTExLocal^.LStock:=StockR;

              With BackThread do
                AddTask(LCheck_Stk,'Loc Fill');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LCheck_Stk,Destroy);
            end;
          end; {with..}

        except
          Dispose(LCheck_Stk,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;


   { ========== TStkBinFill methods =========== }
    Constructor TStkBinFill.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);
      RunFreeze:=BOff;
    end;


    Destructor TStkBinFill.Destroy;

    Begin

      Inherited Destroy;


    end;



    { ========= Procedure to Copy Serial Records to New Bin Records ========= }

    Procedure  TStkBinFill.Copy_SNo_To_Bin;

    Const
      Fnum     =  MiscF;
      Keypath  =  MIK;

      Fnum2    =  MLocF;
      Keypath2 =  MLSuppK;

    Var
      NewBC      :  Str10;

      KeyChk,
      KeyS,
      KeyB       :  Str255;
      LOk,
      Locked     :  Boolean;

      ItemCount  :  LongInt;



    Begin

      ItemCount:=0;

      ShowStatus(1,'Processing:-');

      Locked:=BOff;

      KeyChk:=MFIFOCode+MSernSub+FullNomKey(OldStkRec.StockFolio)+Chr(0);

      KeyS:=KeyChk;

      With MTExLocal^ do
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With LMiscRecs^.SerialRec do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Begin
            Case FillMode of
              1  :  If (BatchRec) then
                       NewBC:=BatchNo
                     else
                       NewBC:=Copy(SerialNo,1,BinKeyLen);

              2  :  NewBC:=InBinCode;
            end; {Case..}


            If (Not EmptyKey(NewBC,BinKeyLen)) and (Not Sold) and (Not BatchChild) then
            Begin

              KeyB:=FullQDKey(brRecCode,MSernSub,FullBinCode3(OldStkRec.StockFolio,InMLoc,NewBC));


              LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyB);

              If (Not LStatusOk) then {* Not there already so add in *}
              Begin

                ShowStatus(2,'Adding '+Trim(NewBC));

                With LMLocCtrl^,brBinRec do
                Begin
                  LResetRec(Fnum2);

                  RecPfix:=BRRecCode;
                  SubType:=MSERNSub;

                  brStkFolio:=OldStkRec.StockFolio;
                  brBatchRec:=BOn;
                  brUOM:=NewStkRec.UnitP;

                  brBinCode1:=NewBC;
                  brDateIn:=DateIn;
                  brBinCost:=SerCost;
                  brStkFolio:=OldStkRec.StockFolio;
                  brBuyLine:=BuyLine;

                  If (BatchRec) then
                  Begin
                    brBuyQty:=BuyQty;
                    brQtyUsed:=QtyUsed;
                  end
                  else
                    brBuyQty:=1.0;

                  brInDoc:=InDoc;

                  brInMLoc:=InMLoc;
                  brInOrdDoc:=InOrdDoc;
                  brInOrdLine:=InOrdLine;
                  brCurCost:=CurCost;
                  brSerCRates:=SerCRates;
                  brSUseORate:=SUseORate;
                  brSerTriR:=SerTriR;
                  brDateUseX:=DateUseX;

                  If (brDateIn='') and (brInDoc<>'') then
                  Begin
                    KeyB:=brInDoc;
                    LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyB);

                    If (LStatusOk) then
                      brDateIn:=LInv.TransDate;
                  end;

                  brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

                  brCode3:=FullBinCode3(brStkFolio,brInMLoc,BrBinCode1);

                  LStatus:=LAdd_Rec(Fnum2,Keypath2);

                  LReport_BError(Fnum2,LStatus);
                end; {With..}
              end; {If not there already }
            end;

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}


    end; {Proc..}



    { ========= Procedure to Copy Serial Records to New Bin Records ========= }

    Procedure  TStkBinFill.Copy_Bin_To_SNo;

    Const
      Fnum2     =  MiscF;
      Keypath2  =  MiscBtcK;

      Fnum    =  MLocF;
      Keypath =  MLSecK;

    Var
      NewBC      :  Str10;

      KeyChk,
      KeyS,
      KeyB       :  Str255;
      LOk,
      Locked     :  Boolean;

      ItemCount  :  LongInt;


    Begin

      ItemCount:=0;

      ShowStatus(1,'Processing:-');

      Locked:=BOff;

      KeyChk:=BRRecCode+MSERNSub+FullNomKey(OldStkRec.StockFolio);

      KeyS:=KeyChk;

      With MTExLocal^ do
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With LMLocCtrl^.brBinRec do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Begin
            NewBC:=BrBinCode1;

            If (Not EmptyKey(NewBC,BinKeyLen)) and (Not brSold) and (Not brBatchChild) then
            Begin

              KeyB:=FullQDKey(MFIFOCode,MSernSub,NewBC);


              LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyB);

              If (Not LStatusOk) then {* Not there already so add in *}
              Begin

                ShowStatus(2,'Adding '+Trim(NewBC));

                With LMiscRecs^,SerialRec do
                Begin
                  LResetRec(Fnum2);

                  RecMfix:=MFIFOCode;
                  SubType:=MSERNSub;

                  StkFolio:=OldStkRec.StockFolio;
                  BatchRec:=BOn;

                  SerialNo:=LJVar('',SNoKeyLen);

                  BatchNo:=LJVar(NewBC,BNoKeyLen);

                  NLineCount:=1;

                  DateIn:=brDateIn;
                  SerCost:=brBinCost;
                  StkFolio:=OldStkRec.StockFolio;
                  BuyLine:=brBuyLine;

                  BuyQty:=brBuyQty;
                  QtyUsed:=brQtyUsed;
                  InDoc:=brInDoc;
                  InMLoc:=brInMLoc;
                  InOrdDoc:=brInOrdDoc;
                  InOrdLine:=brInOrdLine;
                  CurCost:=brCurCost;
                  SerCRates:=brSerCRates;
                  SUseORate:=brSUseORate;
                  SerTriR:=brSerTriR;
                  DateUseX:=brDateUseX;


                  If (DateIn='') and (InDoc<>'') then
                  Begin
                    KeyB:=InDoc;
                    LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyB);

                    If (LStatusOk) then
                      DateIn:=LInv.TransDate;
                  end;

                  SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);

                  LStatus:=LAdd_Rec(Fnum2,Keypath2);

                  LReport_BError(Fnum2,LStatus);
                end; {With..}
              end; {If not there already }
            end;

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}


    end; {Proc..}


    { ========= Procedure to Copy alter Loc code on all Bin Records ========= }

    Procedure  TStkBinFill.Change_Bin_Loc;

    Const

      Fnum    =  MLocF;
      Keypath =  MLK;

    Var
      NewBC      :  Str10;

      KeyChk,
      KeyS,
      KeyB       :  Str255;
      LOk,
      Locked     :  Boolean;

      ItemCount  :  LongInt;


    Begin

      ItemCount:=0;

      ShowStatus(1,'Processing:-');

      Locked:=BOff;

      KeyChk:=BRRecCode+MSERNSub;

      KeyS:=KeyChk;

      With MTExLocal^ do
      Begin
        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With LMLocCtrl^,brBinRec do
        Begin

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Begin


            If (brInMLoc<>NewLocCode) then
            Begin
              ShowStatus(2,'Upating '+Trim(brBinCode1));

              brInMLoc:=NewLocCode;

              brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

              brCode3:=FullBinCode3(brStkFolio,brInMLoc,BrBinCode1);

              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);
            end;

          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}

    end; {Proc..}


    Procedure TStkBinFill.Process;

    Begin
      InMainThread:=BOn;

      Inherited Process;


      ShowStatus(0,'Adjust Stock Bin Records.');

      Case FillMode of
        1,2  :  Copy_SNo_To_Bin;
        20   :  Copy_Bin_To_SNo;
        30   :  Change_Bin_Loc;
      end;


    end;


    Procedure TStkBinFill.Finish;
    Begin
      Inherited Finish;

    end;





   Procedure AddStkBinFill2Thread(AOwner      :  TObject;
                                  OStockR,
                                  NStockR     :  StockRec;
                                  NewLoc      :  Str10;
                                  FMode       :  Byte);


    Var
      LCheck_Stk :  ^TStkBinFill;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Stk,Create(AOwner));

        try
          With LCheck_Stk^ do
          Begin
            If (Start) and (Create_BackThread) then
            Begin
              NewStkRec:=NStockR; OldStkRec:=OStockR;
              FillMode:=FMode;

              NewLocCode:=NewLoc;

              MTExLocal^.LStock:=NStockR;

              If (FillMode<>30) then
                MTExLocal^.Open_System(InvF,InvF);

              With BackThread do
                AddTask(LCheck_Stk,'Bin Fill');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LCheck_Stk,Destroy);
            end;
          end; {with..}

        except
          Dispose(LCheck_Stk,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;


  {$ENDIF}

{$ENDIF}



  { ========== TSetSValType methods =========== }

  Constructor TSetSValType.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    ChildObj:=BOff;
  end;

  Destructor TSetSValType.Destroy;

  Begin

    Inherited Destroy;


  end;



  { ========= Procedure to Update default Stock Valuation ========= }

  Procedure  TSetSValType.Change_StkVal;


  Var
    Fnum,
    Keypath  :  Integer;

    KeyS     :  Str255;

    LOk,
    NoLoop,
    Locked   :  Boolean;

    ItemCount:  LongInt;



  Begin

    Fnum:=StockF;

    Keypath:=StkCodeK;


    ShowStatus(1,'Processing:-');

    Locked:=BOff;

    NoLoop:=BOn;

    KeyS:='';

    // MH 03/11/2010 v6.5 ABSEXCH-10436: Added initialisation of progress counter as Jo was getting values of 1,997,715,045 with 11 records!
    ItemCount := 0;

    With MTExLocal^ do
    Begin
      InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (NoLoop) and (Not ThreadRec^.THAbort) do
      With LStock do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);


        If (SetStkVal(StkValType,SerNoWAvg,BOn)=OldType) and (StockType<>StkDescCode) then
        Begin

          ShowStatus(2,dbFormatName(StockCode,Desc[1]));

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            StkValType:=SetStkVal(NewType,SerNoWAvg,BOff);

            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);

            LStatus:=LUnLockMLock(Fnum);
          end;

        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}

    end; {With..}
  end; {Proc..}




  Procedure TSetSValType.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Change default stock valuation method.');

    Change_StkVal;
  end;


  Procedure TSetSValType.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;




  Function TSetSValType.Start  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Set_BackThreadMVisible(BOn);

    Result:=BOn;

    If (Not ChildObj) then
    Begin
      mbRet:=MessageDlg('Do you wish to change all stock records to the new default?.',mtConfirmation,[mbYes,mbNo],0);

      Result:=(mbRet=mrYes);
    end;

    Set_BackThreadMVisible(BOff);

    If (Result) then
    Begin
      If (Not Assigned(MTExLocal)) then { Open up files here }
      Begin
        {$IFDEF EXSQL}
        if SQLUtils.UsingSQL then
        begin
          // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
          if (not Assigned(LPostLocal)) then
            Result := Create_LocalThreadFiles;

          If (Result) then
            MTExLocal := LPostLocal;

        end
        else
        {$ENDIF}
        begin
          New(MTExLocal,Create(16));

          try
            If (Not ChildObj) then
            With MTExLocal^ do
              Open_System(StockF,StockF);

          except
            Dispose(MTExLocal,Destroy);
            MTExLocal:=nil;

          end; {Except}
        end;
        Result:=Assigned(MTExLocal);
      end;
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
  end;




 Procedure AddStkVal2Thread(AOwner     :  TObject;
                            OTyp,NTyp  :  Char);


  Var
    LCheck_Stk :  ^TSetSValType;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          If (Start) and (Create_BackThread) then
          Begin
            OldType:=OTyp;
            NewType:=NTyp;

            With BackThread do
              AddTask(LCheck_Stk,'Default Stk Val');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


     { ========== TStkDelQB methods =========== }
    Constructor TStkQBDel.Create(AOwner  :  TObject);

    Begin
      Inherited Create(AOwner);
      New(CRepParam);

      Blank(CRepParam^,Sizeof(CRepParam^));

      ChildObj:=BOn;
    end;


    Destructor TStkQBDel.Destroy;

    Begin

      Dispose(CRepParam);
      Inherited Destroy;


    end;


   {SS 01/07/2016 2016-R3:
	  ABSEXCH-13487 : When using the QTY Break - Block Discount Deletion option,
    ticking to Delete Expired within Date Range and Delete for All Stock Records,
    the Stock Quantity Breaks are not removed.}

    { ========= Procedure to Delete Discount Records ========= }

    Procedure  TStkQBDel.Delete_QBRecs;

      function CanDeleteThisRec : Boolean;
      begin
        with MTExLocal^.LQtyBreakRec do
        Result :=  //Account check
                  ((CRepParam^.AllAccs) or (Trim(qbAcCode) = Trim(CRepParam^.LocFilt))) and
                   //Stock check
                  (
                    (Trim(CRepParam^.StockFilt) = '') or (CRepParam^.StkFolioFilt = qbStockFolio) or((Trim(CRepParam^.LocFilt) = '') and CRepParam^.AllAccs)
                    ) and
                  //Date check
                  (not CRepParam^.UseDates or
                    (qbUseDates and (qbEndDate >= CRepParam^.SDate) and (qbEndDate <= CRepParam^.EDate))
                  );
      end;

    Const
      Keypath  =  MIK;

    Var
      KeyChk,
      KeyS,
      KeyB       :  Str255;

      LOk,
      Locked,
      SendMsg,
      Ok2Del     :  Boolean;

      B_Func     :  Integer;

      ItemCount  :  LongInt;
      Fnum : Integer;



    Begin

      ItemCount:=0;  Ok2Del:=BOff;  SendMsg:=BOff;

      ShowStatus(1,'Processing:-');

      Locked:=BOff;



      With MTExLocal^,CRepParam^ do
      Begin
        {SS 05/07/2016 2016-R3:
     	  ABSEXCH-13487 : When using the QTY Break - Block Discount Deletion option, ticking to Delete Expired within Date Range and Delete for All Stock Records, the Stock Quantity Breaks are not removed.}
        if (FiltOrd = 0) then  Open_System(QtyBreakF,QtyBreakF);

        If (Not EmptyKey(LocFilt,CustKeyLen)) then
          LGetMainRecPos(CustF,LocFilt);

        Case FiltOrd of
          0  :  Begin
                  Fnum := QtyBreakF;
                  //KeyChk:=PartCCKey(QBDiscCode,QBDiscSub);
                  KeyChk := FullCustCode(LocFilt);

                  If (Not AllAccs) then
                    KeyChk:=KeyChk+FullNomKey(StkFolioFilt);

                end;
          1  :  Begin
                  Fnum := MiscF;
                  KeyChk:=PartCCKey(CDDiscCode,LCust.CustSupp);

                  If (Not AllAccs) then
                  Begin
                    KeyChk:=KeyChk+FullCustCode(LocFilt);

                    If (Not EmptyKey(StockFilt,StkKeyLen)) then
                      KeyChk:=KeyChk+FullStockCode(StockFilt);

                  end
                  else
                    FNum := MiscF; //PR: 06/06/2017 Include to remove warning

                end;

        end; {Case..}
                                                              

        KeyS:=KeyChk;

        InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExClientId));

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With LQtyBreakRec,LMiscRecs^ do
        Begin
          B_Func:=B_GetNext;

          Inc(ItemCount);

          UpdateProgress(ItemCount);

          Begin
            Case FiltOrd of
              0  :
              Begin
                {SS 01/07/2016 2016-R3:
            	  ABSEXCH-13487 : When using the QTY Break - Block Discount Deletion option, ticking to Delete Expired within Date Range and Delete for All Stock Records, the Stock Quantity Breaks are not removed.}
                Ok2Del := CanDeleteThisRec;
              end;
              1  :  With LMiscRecs^.CustDiscRec do
                    Begin
                      Ok2Del:=(EmptyKey(StockFilt,StkKeyLen)) or (CheckKey(StockFilt,QStkCode,Length(StockFilt),BOff));

                      If (Ok2Del) and (UseDates) then
                        Ok2Del:=((CStartD>=SDate) and (CEndD<=EDate));

                    end;
            end; {Case..}

            If (Ok2Del) then
            Begin
              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum);

                SendMsg:=BOn;

                LStatus:=LDelete_Rec(Fnum,KeyPath);

                LReport_BError(Fnum,LStatus);


                If (LStatusOk) and (FiltOrd=1) and (CustDiscRec.QBType='Q') then
                Begin
                  B_Func:=B_GetGEq;

                  If (LStock.StockCode<>CustDiscRec.QStkCode) then
                    LGetMainRec(StockF,CustDiscRec.QStkCode);

                  KeyB:=FullQDKey(QBDiscCode,LCust.CustSupp,FullCDKey(LCust.CustCode,LStock.StockFolio));

                  LDeleteLinks(KeyB,Fnum,Length(KeyB),Keypath,BOff);

                end;
              end;
            end;
          end;

          LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

        end; {While..}

      end; {With..}


      If (SendMsg) and (OHandle<>0) then
        SendMessage(OHandle,WM_CustGetRec,119,0);
    end; {Proc..}



    Procedure TStkQBDel.Process;

    Begin
      InMainThread:=BOn;

      Inherited Process;


      ShowStatus(0,'Delete Discount Records.');

      Case CRepParam^.FiltOrd of
        0,1  :  Delete_QBRecs;
      end;


    end;


    Procedure TStkQBDel.Finish;
    Begin
      Inherited Finish;

    end;





   Procedure AddDelDiscRec2Thread(AOwner      :  TObject;
                                  FMode       :  Byte;
                                  RRepParam   :  BinRepPtr);


    Var
      LCheck_Stk :  ^TStkQBDel;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Stk,Create(AOwner));

        try
          With LCheck_Stk^ do
          Begin
            If (Start) and (Create_BackThread) then
            Begin
              If (AOwner is TForm) then
                OHandle:=TForm(AOWner).Handle
              else
                OHandle:=0;

              CRepParam^:=RRepParam^;

              CRepParam^.FiltOrd:=FMode;

              MTExLocal^.Open_System(CustF,MiscF);

              With BackThread do
                AddTask(LCheck_Stk,'Del Discs');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(LCheck_Stk,Destroy);
            end;
          end; {with..}

        except
          Dispose(LCheck_Stk,Destroy);

        end; {try..}
      end; {If process got ok..}

    end;
  {$ENDIF}



Initialization


Finalization


end.
