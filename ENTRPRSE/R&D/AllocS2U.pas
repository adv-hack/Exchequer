unit AllocS2U;

interface

{$I DefOvr.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1,

  {$IFDEF POST}
    Recon3U,
    PostingU,

  {$ENDIF}


  ExWrap1U;

Type
   //PR: 26/05/2015 v7.0.14
   TAllocPPDMode = (apDontTake, apTakeWithinTerms, apTakeAlways);

  {$IFDEF POST}

    TScanAlloc      =  Object(TEntPost)

                       private

                         CustAlObj  :  GetExNObjCid;
                         ExtCustRec :  ExtCusRecPtr;
                         PostOPtr   :  Pointer;
                         CallBackH  :  THandle;

                         Function LCert_Expired(EmplCode  :  Str20;
                                                ViaSupp,
                                                ShowErr   :  Boolean)  :  Boolean;

                         Procedure Alloc_CalcDoc(BFnum,BKeypath  :  Integer);

                         Procedure Alloc_Scan(BFnum,BKeypath  :  Integer);


                         // CJS 2015-07-07 - ABSEXCH-16578 - PPD Write-Off uses wrong Control Code
                         Procedure Generate_AutoPPY(PayOwnVal,
                                                    PayBase,
                                                    PayIBase,
                                                    PaySDOV    :  Real;
                                                    PayRef     :  Str10;
                                                    Fnum,
                                                    Keypath    :  Integer;
                                                    UseSettlementDiscount: Boolean = False);

                         Procedure BATCH_PayProcess(Fnum,
                                                    Keypath  :  Integer);

                         Procedure Check_PayProcess(Fnum,
                                                    Keypath  :  Integer);

                         Procedure Settle_Alloc(Fnum,Keypath  :  Integer);


                       public
                         AllocCtrl  :  MLocRec;
                         FuncMode   :  Byte;

                         //PR: 26/05/2015 v7.0.14
                         AllocPPDMode : TAllocPPDMode;

                         HasPPD : Boolean;

                         Constructor Create(AOwner  :  TObject);

                         Destructor  Destroy; Virtual;

                         Procedure Gen_PayHed(TDate  :  LongDate;
                                              TYr,
                                              TPr,
                                              RCr    :  Byte;
                                              PayOVal,
                                              PayBase,
                                              PayVar,
                                              PaySDisc,
                                              PaySDOV:  Real;
                                              PayRef :  Str10;
                                              CtrlCode
                                                     :  LongInt;
                                              SPMode :  Boolean;
                                              Mode   :  Byte);

                         Procedure Gen_AutoPPYLine(BNomCode:  LongInt;
                                                   BAmount :  Real;
                                                   BCr     :  Byte;
                                                   CQNo    :  Str30;
                                                   PayRef  :  Str20;
                                                   Fnum,
                                                   Keypath :  Integer);


                         Procedure Process; Virtual;
                         Procedure Finish;  Virtual;

                         Function Start(BCtrl    :  MLocRec;
                                        InpWinH  :  THandle)  :  Boolean;

                     end; {Class..}

  {$ELSE}
    TScanAlloc = Class

                 end;

  {$ENDIF}

  //PR: 26/05/2015 v7.0.14 Added new parameter so we can tell the process whether and how to take PPD
  Procedure AddAllocScan2Thread(AOwner   :  TObject;
                                BCtrl    :  MLocRec;
                                MyHandle :  THandle;
                                fMode    :  Byte;
                                PPDMode  :  TAllocPPDMode = apDontTake;
                                AHasPPD  :  Boolean = False);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarJCstU,
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  BTSFrmU1,
  ComnUnit,
  ComnU2,
  CurrncyU,

  ExThrd2U,

  {$IFDEF POST}
    ExBtTh1U,

    {$IFDEF JC}
      JobPst2U,
    {$ENDIF}

  {$ENDIF}

  {$IFDEF PF_On}

     InvLSt2U,

   {$ENDIF}

   {$IFDEF JC}
     JChkUseU,

     JobSup1U,

   {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  SalTxl1U,
  LedgSupU,
  LedgSu2U,
  Event1U,
  SysU1,
  SysU2,
  AllocS1U,
  BPyItemU,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  AuditNotes,

  oTakePPD,

  // CJS 2015-07-07 - ABSEXCH-16578 - PPD Write-Off uses wrong Control Code
  TransactionHelperU,
  oSystemSetup
  ;



{$IFDEF POST}

  { ========== TScanAlloc methods =========== }

  Constructor TScanAlloc.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpHigher;
    fSetPriority:=BOn;

    IsParentTo:=BOn;

    MTExLocal:=nil;
    PostOPtr:=nil;

    New(CustAlObj,Init);
    New(ExtCustRec);

    FillChar(ExtCustRec^,Sizeof(ExtCustRec^),0);

    HasPPD := False;

  end;

  Destructor TScanAlloc.Destroy;

  Begin
    Dispose(CustAlObj,Done);
    Dispose(ExtCustRec);


    Inherited Destroy;


  end;



Procedure TScanAlloc.Alloc_CalcDoc(BFnum,BKeypath  :  Integer);
Const
  Fnum     =  InvF;
Var
  KeyS2,
  KeyChk      :  Str255;

  LOk,
  UseOsKey,
  Locked      :  Boolean;

  DocThen     :  Real;

  TransCnst,
  KeyPath     :  Integer;

  EInv        :  InvRec;

  ItemCount   :  LongInt;

  GenStr      :  String;

  {$IFDEF EXSQL}
    lSQLPrefillCacheID : LongInt;
    lSQLWhereClause : ANSIString;
    lSQLColumns : ANSIString;
    lSQLPFCRes : LongInt;
  {$ENDIF}

  //------------------------------

  Function SortNumber(DValue  :  Double;
                      Decend  :  Boolean;
                      NoDecs  :  Byte)  :  Str80;
  Const
    ForceD  :  Array[0..1] of Char = (#255,#254);
  Var
    TStr  :  Str80;
  Begin
    If (Decend) then
    Begin
      If (DValue<0) then
        TStr:=Form_Real((DValue*DocNotCnst),0,10)
      else
        If (DValue>1) then
          TStr:=Form_Real(DivWChk(1,DValue),0,10)
        else
          TStr:=ConstStr(ForceD[Round(DValue)],30);
    end
    else
    Begin
      If (DValue<0) then
        TStr:=Form_Real(DivWChk(1,DValue*DocNotCnst),0,10)
      else
        TStr:=Form_Real(DValue,0,2);
    end;

    SortNumber:=SetPadNo(TStr,10);
  end; {Func..}

  //------------------------------

  Function DescendStr(SStr    :  Str80;
                      Decend  :  Boolean)  :  Str80;
  Var
    n     :  Byte;
    TStr  :  Str80;
  Begin
    TStr:='';

    If (Decend) then
    Begin
      For n:=1 to Length(SStr) do
        TStr:=TStr+Chr(255-Ord(SStr[n]));
    end
    else
      TStr:=SStr;

    DescendStr:=TStr;
  end; {Func..}

  //------------------------------

  Function arcSortKey(SInv    :  InvRec;
                      OValue  :  Double;
                      Decend  :  Boolean)  :  Str20;

    Function SortStr(SMode   :  Byte;
                     Decend  :  Boolean ) :  Str20;
    Begin
      With SInv do
      Begin
        Case SMode of
          0  :  Result:=DescendStr(TransDate,Decend);
          1  :  Result:=DescendStr(DueDate,Decend);
          2  :  Result:=SortNumber(OValue,Decend,2);
          3  :  Result:=DescendStr(YourRef,Decend);
          4  :  Result:=DescendStr(Chr(Succ(Currency)),Decend);
          else  Result:=DescendStr(OurRef,Decend);
        end; {case..}
      end; {With..}
    end;

  Begin
    With AllocCtrl.AllocCRec do
    Begin
      Result:=SortStr(arcSortBy,Decend);

      If (arcSortBy<>arcSort2By) then
        Result:=Result+SortStr(arcSort2By,Decend);
    end; {With..}
  end;

  //------------------------------

Begin

  DocThen:=0;  TransCnst:=1;  GenStr:='';

  Locked:=BOff;

  ItemCount:=0;

  EInv:=Inv;

  UseOSKey:=AllocCtrl.AllocCRec.arcUseOsNdx;

  If (UseOSKey) then
    KeyPath:=InvOSK
  else
  Begin
    KeyPath:=InvCustK;

    Write_PostLog('The Transaction outstanding index is missing in this data resulting in slower access speeds when searching for outstanding transactions.',BOn);
    Write_PostLog('Rebuild Document.dat to rectify this situation.',BOn);
    Write_PostLog('',BOn);

  end;

  FillChar(KeyChk,Sizeof(KeyChk),#0);
  FillChar(KeyS2,Sizeof(KeyS2),#0);


  With MTExLocal^ do
  Begin
    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));


    With LCust do
    Begin

      If (UseOSKey) then
        KeyChk:=TradeCode[AllocCtrl.AllocCRec.arcSalesMode]+FullCustCode(CustCode)
      else
        KeyChk:=FullCustType(CustCode,CustSupp)+#1;  {* Ignore Nom Ledger Items *}

    end;

    KeyS2:=KeyChk;

    {$IFDEF EXSQL}
    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      lSQLWhereClause :=                          '(thOutstanding=' + QuotedStr(ExtCustRec^.FAlCode) + ') ' +
                                              'And (thAcCodeComputed=' + QuotedStr(ExtCustRec^.FCusCode) + ')';

      If (ExtCustRec^.FCr <> 0) Then
        lSQLWhereClause := lSQLWhereClause + ' And (thCurrency=' + IntToStr(ExtCustRec^.FCr) + ')';

      lSQLColumns := '';
      lSQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[Fnum], lSQLWhereClause, lSQLColumns, lSQLPrefillCacheID, MTExLocal^.ExClientId);

      If (lSQLPFCRes = 0) Then
        UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2)
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
    {$ENDIF}
    Begin
      lSQLPFCRes := -1;
      LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetGEq,1,KeyS2);  // Effectively a GetGEq
    End;


    While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
    With LInv do
    Begin

      If (ExtCusFiltCid(0,ExtCustRec,CustAlObj)) and (Not SettledFull(LInv)) and
      ((Not (InvDocHed In RecieptSet)) or (Not PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)))
      and (OurRef<>AllocCtrl.AllocCRec.arcOurRef) then
      Begin

        With LMiscRecs^ do
        Begin

          LResetRec(BFnum);

          LMiscRecs^.RecMfix:=MBACSCode;
          LMiscRecs^.Subtype:=MBACSALSub;

          With LMiscRecs^.AllocSRec, AllocCtrl.AllocCRec do
          Begin
            ariCustCode:=LCust.CustCode;
            ariCustSupp:=LCust.CustSupp;

            {* Work these out prior to applying any discount *}

            ariOrigVal:=(Itotal(LInv)*DocCnst[InvDocHed]*DocNotCnst);
            ariOrigCurr:=Currency;
            ariBaseEquiv:=ConvCurrItotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst;

            AllocForceInvSDisc(LInv,EInv,AllocCtrl,0);

            {$IFDEF FRM}
              If (arcFromTrans) and (Not DiscTaken) and (DiscSetAm<>0) and (Assigned(PostLog)) then
              Begin
                If (RunNo=0) then
                  GenStr:='When allocating an existing credit, you must take the settlement discount of an unposted transaction manualy before allocating it.'
                else
                  GenStr:='It is not possible to take any settlement discount when allocating an existing credit. '+
                          'Create a new allocation if you wish to take this discount.';

                Write_PostLogDD(OurRef+' has '+FormatCurFloat(GenRealMask,DiscSetAm,BOff,Currency)+' of settlement discount available.',BOn,OurRef,0);

                Write_PostLogDD(GenStr,BOn,OurRef,0);


              end;

            {$ENDIF}

            ariBaseOS:=BasetotalOS(EInv);

            {$IFDEF MC_On}
              ariCurrOS:=CurrencyOS(EInv,BOff,BOff,BOff);


              If (arcPayCurr=ariOrigCurr) then
                ariOutStanding:=ariCurrOS
              else
                ariOutStanding:=Currency_ConvFT(ariBaseOS,0,arcPayCurr,UseCoDayRate);


              If (Currency=arcPayCurr) then {* We are paying off the own currency equivalent *}
                DocThen:=ariCurrOS
              else
                DocThen:=ariOutStanding;

              ariOrigReValAdj:=ReValueAdj*DocCnst[InvDocHed]*DocNotCnst;

            {$ELSE}
                ariOutStanding:=ariBaseOS;

                DocThen:=ariOutStanding;

            {$ENDIF}

            If ((InvDocHed In RecieptSet+CreditSet) and (ITotal(LInv)<0)) or ((PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)) and (ITotal(LInv)>=0)) then
              TransCnst:=-1
            else
              TransCnst:=1;


            ariKey:=ariCustSupp+FullCustCode(ariCustCode)+LJVar(arcSortKey(LInv,DocThen*DocCnst[InvDocHed]*DocNotCnst,arcSortD),19);

            Spare2K:=ariCustSupp+FullCustCode(ariCustCode)+OurRef;

            ariOurRef:=OurRef;
            ariYourRef:=YourRef;
            ariDueDate:=DueDate;
            ariTransDate:=TransDate;
            ariOrigSettle:=Settled;
            ariOrigOCSettle:=CurrSettled;
            ariCXRate:=CXRate;
            ariOrigSetDisc:=EInv.BDiscount*TransCnst;
            ariDocType:=InvDocHed;


            ariOutStanding:=ariOutStanding*TransCnst;
            ariBaseOS:=ariBaseOS*TransCnst;
            ariCurrOS:=ariCurrOs*TransCnst;


            LStatus:=LAdd_Rec(BFnum,BKeyPath);

            LReport_BError(BFnum,LStatus);

            Inc(ArcTagCount);
          end;
        end;
      end; {If Doc Ok..}

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      If (Not ThreadRec^.THAbort) then
        {$IFDEF EXSQL}
        If SQLUtils.UsingSQLAlternateFuncs Then
        Begin
          If (lSQLPFCRes = 0) Then
            UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2)
        End // If SQLUtils.UsingSQLAlternateFuncs
        Else
        {$ENDIF}
          LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetNext,1,KeyS2);
    end; {While..}

    {$IFDEF REPPFC}
      If (lSQLPFCRes = 0) Then
        DropCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
  end; {With..}

end; {Proc..}


{ == Function to determine if a supplier has any expired cert ==}

{!!!! Note this routine is replicated for non thread safe operation within JChkUseU & Replicated in BPayLstU !!!!}

Function TScanAlloc.LCert_Expired(EmplCode  :  Str20;
                                  ViaSupp,
                                  ShowErr   :  Boolean)  :  Boolean;


Const
  Fnum     =  JMiscF;
  Keypath  =  JMTrdK;

Var
  KeyChk,
  KeyS       : Str255;

  LOk        : Boolean;


Begin
  Result:=BOff;  LOk:=BOff;

  KeyS:=''; KeyChk:='';

  With MTExLocal^ do
  Begin
    If (ViaSupp) then
    Begin
      KeyChk:=PartCCKey(JARCode,JASubAry[3])+FullCustCode(EmplCode);
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not Result) and (Not ThreadRec^.THAbort) do
      With LJobMisc^,EmplRec do
      Begin
        Result:=LCert_Expired(EmpCode,BOff,ShowErr);

        If (Not Result) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

      end;

    end
    else
    With LJobMisc^,EmplRec do
    Begin
      KeyS:=PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmplCode);

      If (EmplCode<>EmpCode) then
        LOk:=LCheckRecExsists(KeyS,Fnum,JMK)
      else
        LOk:=BOn;

      If (LOk) then
      Begin
        Result:=(CertExpiry<Today) and (Trim(CertExpiry)<>'') and (Etype=EmplSubCode) and (CISType<>4) and (Not CIS340) ;
      end;

    end;

  end; {With..}
end;



{ ======== Procedure to Scan All Accounts and Re-Calc Payment Screen ======= }


Procedure TScanAlloc.Alloc_Scan(BFnum,
                                BKeypath  :  Integer);


Const
  Fnum     =  CustF;
  KeyPath  =  CustCodeK;



Var
  BadEmpl     :  Boolean;
  KeyS,
  KeyChk      :  Str255;

  Sales,
  Purch,
  Cleared     :  Double;

  {$IFDEF EXSQL}
  // CJS 2015-10-19 - ABSEXCH-16279 - allocations performance issue
  // Delete existing allocation records
  procedure DeleteExistingEntries(const TradeCode: Char; const AccountCode: ShortString);
  var
    Company : ShortString;
    Where : ANSIString;
  begin
    Company := GetCompanyCode(SetDrive);
    Where := '(RecMFix=''X'') And (SubType=''A'') And ' +
             '(SubString(ExStChkVar1, 2, 7) = ' + StringToHex(TradeCode + AccountCode) + ')';

    DeleteRows(Company, 'ExStkChk.Dat', Where, MTExLocal^.ExClientID);
  end;
  {$ENDIF}

Begin


  BadEmpl:=BOff;

  Sales:=0;
  Purch:=0;
  Cleared:=0;

  With MTExLocal^ do
  Begin


    With AllocCtrl.AllocCRec do
    Begin

      arcTagCount:=0;
      arcTagRunDate:=Today;
      arcTotal:=0.0;
      arcTotalOwn:=0.0;
      arcVariance:=0.0;
      arcSettleD:=0.0;
      arcOwnSettleD:=0.0;
      arcAllocFull:=BOff;

    end;


    With ExtCustRec^ do
    Begin

      FCr:=AllocCtrl.AllocCRec.arcInvCurr;

      FNomAuto:=BOn;

      FMode:=3;

      FAlCode:=TradeCode[AllocCtrl.AllocCRec.arcSalesMode];

      FCtrlNom:=AllocCtrl.AllocCRec.arcCtrlNom;


      FDirec:=BOn;

      FB_Func[BOff]:=B_GetPrev;
      FB_Func[BOn]:=B_GetNext;

      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          FLogPtr:=PostLog
        else
          FLogPtr:=nil;
      {$ELSE}
        FLogPtr:=nil;
      {$ENDIF}
    end;


    KeyS:=FullCustCode(AllocCtrl.AllocCRec.arcCustCode);

    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

    If (LStatusOk) and (Not ThreadRec^.THAbort) then
    With LCust do
    Begin
      KeyS:=PartCCKey(MBACSCode,MBACSALSub)+CustSupp+FullCustCode(AllocCtrl.AllocCRec.arcCustCode);

      // CJS 2015-10-19 - ABSEXCH-16279 - allocations performance issue
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQLAlternateFuncs then
      begin
        DeleteExistingEntries(CustSupp, FullCustCode(AllocCtrl.AllocCRec.arcCustCode));
      end
      else
      {$ENDIF}
      LDeleteLinks(KeyS,BFnum,Length(KeyS),BKeyPath,BOff);

      {$IFDEF PF_On}
        {$B-}
           BadEmpl:=((JBCostOn) and (Not AllocCtrl.AllocCRec.arcSalesMode) and (LCert_Expired(CustCode,BOn,BOff)));
        {$B+}

      {$ENDIF}


      If (Not BadEmpl) then
      Begin
        ShowStatus(1,'Processing '+dbFormatName(CustCode,Company));


        With AllocCtrl.AllocCRec do
          Begin

            With ExtCustRec^ do
            Begin

              FCusCode:=CustCode;
              FCSCode:=CustSupp;

            end;

            Alloc_CalcDoc(BFnum,BKeypath);

          end; {* If Amount OS..}


      end {If Supplier & Right Type}
      else
      Begin
        {$IFDEF FRM}
            If (BadEmpl) and (Assigned(PostLog)) then
            Begin
              Write_PostLogDD('Supplier '+dbFormatName(CustCode,Company)+' excluded as one of the employee sub contract certificates has expired.',BOn,CustCode,1);


            end;

        {$ENDIF}

      end;


      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

    end; {While..}


    {unLock Totals}

    {* Inform input window batch To Un lock *}

    SendMessage(CallBackH,WM_CustGetRec,65,0);

    Alloc_CtrlPut(MLocF,MLK,AllocCtrl,MTExLocal,0);

    {* Inform input window batch To lock *}

    SendMessage(CallBackH,WM_CustGetRec,66,0);


  end; {With..}
end; {Proc..}


  { ========= Procedure to Generate a Document Header ======= }

  Procedure TScanAlloc.Gen_PayHed(TDate  :  LongDate;
                                  TYr,
                                  TPr,
                                  RCr    :  Byte;
                                  PayOVal,
                                  PayBase,
                                  PayVar,
                                  PaySDisc,
                                  PaySDOV:  Real;
                                  PayRef :  Str10;
                                  CtrlCode
                                         :  LongInt;
                                  SPMode :  Boolean;
                                  Mode   :  Byte);





  Begin

    With MTExLocal^,LInv, AllocCtrl.AllocCRec do
    Begin

      LResetRec(InvF);

      OurRef:=PayRef;

      NomAuto:=BOn;

      TransDate:=TDate; AcPr:=TPr; AcYr:=TYr;

      DueDate:=TransDate;

      ILineCount:=1;

      NLineCount:=1;

      If (CtrlCode<>0) then
      Begin
        With Syss do
          If (CtrlCode<>NomCtrlCodes[Debtors]) and (CtrlCode<>NomCtrlCodes[Creditors]) then
            CtrlNom:=CtrlCode; {leave blank if it is a main ctrl code in use}
      end
      else
        CtrlNom:=LCust.DefCtrlNom;

    {$IFDEF MC_On}

      Currency:=RCr;

      CXrate:=arcCXRate;

    {$ELSE}

      Currency:=0;

      CXrate:=arcCXRate;


    {$ENDIF}

      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);

      SetTriRec(Syss.VATCurr,UseORate,VATTriR);

      OpName:=arcOpoName;

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(LInv);

      DAddr:=arcDelAddr;

      DJobCode:=arcJobCode;
      DJobAnal:=arcAnalCode;

      DocUser1:=arcUD1;
      DocUser2:=arcUD2;
      DocUser3:=arcUD3;
      DocUser4:=arcUD4;
      //GS 11/11/2011 ABSEXCH-12124: populate the new UDFs on the SRC that is created by the SRC wizard
      DocUser5:=arcUD5;
      DocUser6:=arcUD6;
      DocUser7:=arcUD7;
      DocUser8:=arcUD8;
      DocUser9:=arcUD9;
      DocUser10:=arcUD10;
      // PKR. 24/03/2016. ABSEXCH-17383. Support for RCT.
      thUserField11 := arcUD11;
      thUserField12 := arcUD12;

      YourRef:=arcYourRef;
      {TransDesc:=arcLYourRef;}

      Case Mode of
        0  :  Begin
                InvDocHed:=BatchDocHed(SPMode);

                CustCode:=LCust.CustCode;

                CustSupp:=LCust.CustSupp;

                {$IFDEF MC_On}
                  InvNetVal:=arcOwnTransValue;
                {$ELSE}
                  InvNetVal:=arcTransValue;
                {$ENDIF}

                TotalReserved:=PayVar+PaySDisc;

                Variance:=PayVar;

                PostDiscAm:=PaySDisc;

                DiscSetl:=PaySDisc;

                BDiscount:=PaySDOV;

                TotalInvoiced:=ConvCurrITotal(LInv,BOff,BOff,BOn);

                FolioNum:=GetNextCount(FOL,BOn,BOff,0);

                If (arcAllocFull) then
                Begin  
                  Settled:=Round_Up(BasetotalOS(LInv),2);

                  CurrSettled:=CurrencyOS(LInv,BOn,BOff,BOff);
                end
                else
                Begin
                  Settled:=Round_Up(PayBase*DocCnst[InvDocHed]*DocNotCnst,2);

                  CurrSettled:=Round_up(PayOVal*DocCnst[InvDocHed]*DocNotCnst,2);

                  If (Round_Up(BasetotalOS(LInv),2)<>0.0) and (Not UseCoDayRate) then
                    CXRate[BOff]:=0.0; {Leave floating for revalution}
                end;

                //PR: 29/06/2015 ABSEXCH-16547 Can't use Set_DocAlcStat function as that uses BaseTotalOS
                if SettledFullCurr(LInv) and (BasetotalOS(LInv) = 0.0) then
                  LInv.AllocStat := #0
                else //PR: 03/09/2015 2015 R1 ABSEXCH-16820 Need to set to custsupp char if not fully allocated
                  LInv.AllocStat := TradeCode[CustSupp = 'C'];

                //Set_DocAlcStat(LInv);  {* Set Allocation Status *}

                If (Autho_Need(Syss.AuthMode)) then
                  HoldFlg:=HoldP;

                If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* ENv4.22 Cash Accounting set VATdate to Current VAT Period *}
                Begin

                  // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                  VATPostDate:=CalcVATDate(TransDate); {v5.71. CA Allows jump to future period}

                end;

                If (AllocStat=#0) then {* Only set date if fully allocated *}
                  UntilDate:=Today;



              end;


      end; {Case..}


    end; {With..}

  end; {Proc..}

  { ===== Procedure to Automaticly Generate PPY Line ====== }



  Procedure TScanAlloc.Gen_AutoPPYLine(BNomCode:  LongInt;
                                       BAmount :  Real;
                                       BCr     :  Byte;
                                       CQNo    :  Str30;
                                       PayRef  :  Str20;
                                       Fnum,
                                       Keypath :  Integer);


  Var
    {$IFDEF JC}
      PostJobObj  :  ^TPostJobObj;
    {$ELSE}
      PostJobObj  :  Pointer;
    {$ENDIF}


  Begin


    With MTExLocal^,LId, AllocCtrl.AllocCRec do
    Begin

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      IdDocHed:=LInv.InvDocHed;

      PDate:=LInv.TransDate;

      CustCode:=LInv.CustCode;
      
      PYr:=LInv.ACYr;
      PPr:=LInv.ACPr;

      QtyMul:=1;

      Qty:=1;

      QtyPack:=QtyMul;

      PriceMulX:=1.0;

      If (PayRef<>'') then
        StockCode:=Pre_PostPayInKey(PayInCode,PayRef);

      Desc:=CQNo;

      LineNo:=RecieptCode;
      ABSLineNo:=LInv.ILineCount;

      Inc(LInv.ILineCount);

      NetValue:=BAmount;

      Currency:=BCr;

      If (Currency=arcPayCurr) then
      Begin
        CXRate:=LInv.CXRate;

        {If (CXRate[BOff]=0.0) then v5.50.001. Need to keep in synch with header as if part/fully unallocated, it needs to float
          CXRate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];}
      end
      else
        CXRate:=SyssCurr^.Currencies[Currency].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);

      NomCode:=BNomCode;

      CCDep:=arcCCDep;

      Payment:=SetRPayment(LInv.InvDocHed);

      {$IFDEF PF_On}

        If (JBCostOn) and (ABSLineNo=1) and (arcSalesMode) then
        Begin
          JobCode:=arcJobCode;
          AnalCode:=arcAnalCode;
        end;

      {$ENDIF}

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;

      LStatus:=LAdd_Rec(Fnum,KeyPath);


      LReport_BError(Fnum,LStatus);

      {$IFDEF PF_On}  {Add to JC Line}

        {$IFDEF JC}
          If (JBCostOn) and (BAmount<>0.0) then
          Begin
            If (Not Assigned(PostOPtr)) then {* Create obj to give access to Job_UpdateActual..}
            Begin
              New(PostJobObj,Create(Self.fMyOwner));

              PostOPtr:=PostJobObj;

              try
                If (Assigned(PostJobObj)) then
                  PostJobObj^.MTExLocal:=Self.MTExLocal;
              except
                PostJobObj:=nil;
                PostOPtr:=nil;
              end;

            end
            else
              PostJobObj:=PostOPtr;

            try

              PostJobObj^.LUpdate_JobAct(LId,LInv);

            except
              PostOPtr:=nil;
              Dispose(PostJobObj,Destroy);
            end; {try..}



          end;

        {$ELSE}
          PostJobObj:=nil;
        {$ENDIF}


      {$ENDIF}


    end; {With..}

  end; {Proc..}


  { ========== Procedure to Generate an automatich Payment ========= }

  Procedure TScanAlloc.Generate_AutoPPY(PayOwnVal,
                                        PayBase,
                                        PayIBase,
                                        PaySDOV    :  Real;
                                        PayRef     :  Str10;
                                        Fnum,
                                        Keypath    :  Integer;
                                        UseSettlementDiscount: Boolean);



  Var
    PDiscAm,
    VarAm     :  Real;

    RefUsed   :  Boolean;

    MainVal,
    UseTransValue,
    VarOwn    :  Double;

    Ref1,Ref2,
    NextCQNo  :  Str80;

    PayMatch  :  Str20;

    ChkCQNoCode
              :  Integer;
    ChkCQNo,
    PDiscGL   :  LongInt;

    {$IFDEF JC}
      PostJobObj  :  ^TPostJobObj;
    {$ELSE}
      PostJobObj  :  Pointer;
    {$ENDIF}


  Begin

    ShowStatus(2,'Generating '+PayRef);

    MainVal:=0.0;  RefUsed:=BOff; VarAm:=0.0; PDiscAm:=0.0; ChkCQNo:=0; ChkCQNoCode:=0;

    PostJobObj:=nil;

    

    With MTExLocal^, AllocCtrl.AllocCRec do
    Begin
      NextCQNo:=arcChequeNo2;

      // CJS 2015-07-07 - ABSEXCH-16578 - PPD Write-Off uses wrong Control Code
      if UseSettlementDiscount then
      begin
        // Pre-April 2015 - Settlement Discount
        If (arcSalesMode) then
          PDiscGL:=Syss.NomCtrlCodes[DiscountGiven]
        else
          PDiscGL:=Syss.NomCtrlCodes[DiscountTaken];
      end
      else
        // Post-April 2015 - Prompt Payment Discount
        PDiscGL := SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL;

      If (arcAllocFull) then {Take own currency amount as basis for variance rather then calculated totals}
      {$IFDEF MC_On}

        VarOwn:=arcOwnTransValue
      {$ELSE}
        VarOwn:=arcTransValue
      {$ENDIF}
      else
        VarOwn:=PayOwnVal;

        {Pre v5.51}
       {VarAm:=Round_Up(PayBase-Conv_TCurr(VarOwn,XRate(arcCXRate,BOff,arcPAyCurr),arcPayCurr,0,BOff),2);}

                              {* v5.51. Round up added to conversion element as small rounding errors were being lost. eg.
                              Company rate system. Daily and company Euro rate set to 1.6 (or 0.625 inverted).-
                              Enter SIN for EUR 1391.10 (vat exempt) Enter SIN for EUR 512.18 (same customer, vat exempt)
                              Enter SCR for EUR 98.28  Add SRC for EUR 1805.00 and allocate above 3 transactions Customer ledger,
                              everything shows as settled. Run back dated aged debtor report and the SRC shows as having -0.01 outstanding.
                              Using Receipt wizard shows .01 CV in variance, but not on receipt. *}

      If (VarOwn>0) then
      Begin
        if not HasPPD then
          VarAm:=Round_Up(PayBase-Round_up(Conv_TCurr(VarOwn,XRate(arcCXRate,BOff,arcPAyCurr),arcPayCurr,0,BOff),2),2);

        PDiscAm:=Round_up(PayIBase-PayBase,2);
      end;

      If ({$IFDEF MC_On} arcOwnTransValue {$ELSE} arcTransValue {$ENDIF}>0) then {* Only attribute a cq no. to a +ve payment with no cheque number *}
      Begin
        If (Not arcSalesMode) {and (Trim(arcChequeNo2)='') v5.52 assume auto inc} and (Syss.AutoCQNo) then
        Begin
          Val(Trim(arcChequeNo2),ChkCQNo,ChkCQNoCode);

          If (Trim(arcChequeNo2)='') and (ChkCQNoCode<>0) then
            ChkCQNoCode:=0;

          If (ChkCQNoCode=0) and (ChkCQNo=0) then
            NextCQNo:=Get_NextChequeNo(BOn);
        end;
      end;

      Gen_PayHed(arcTransDate,arcTagRunYr,arcTagRunPr,arcPayCurr,PayOwnVal,PayIBase,VarAm,PDiscAm,PaySDOV,PayRef,arcCtrlNom,arcSalesMode,0);

      If (Not arcSalesMode) then
        PayMatch:=PayRef {* Do not set CQ PPY's under one setting, as otherwise they will not
                            be seperated out *}
      else
        PayMatch:=arcSRCPIRef;


      If (Not arcAllocFull) and (arcFinVar or arcFinSetD) then {* Redo header based on a writing off diff to settlement or Variance*}
      Begin
        If (arcFinVar) then 
          VarAm:=VarAm+(Round_Up(BasetotalOS(LInv)*DocCnst[LInv.InvDocHed],2))
        else
          PDiscAm:=PDiscAm+(Round_Up(BasetotalOS(LInv)*DocCnst[LInv.InvDocHed],2));

        arcAllocFull:=BOn;

        Gen_PayHed(arcTransDate,arcTagRunYr,arcTagRunPr,arcPayCurr,PayOwnVal,PayIBase,VarAm,PDiscAm,PaySDOV,PayRef,arcCtrlNom,arcSalesMode,0);
      end;

      {$IFDEF MC_On}
        MainVal:=arcOwnTransValue;
      {$ELSE}
        MainVal:=arcTransValue;
      {$ENDIF}

      If (arcCharge1GL<>0) then
        MainVal:=MainVal-arcCharge1Amt;

      If (arcCharge2GL<>0) then
        MainVal:=MainVal-arcCharge2Amt;

      If (MainVal<>0.0) then
      Begin
        Gen_AutoPPYLine(arcBankNom,MainVal,arcPayCurr,NextCQNo,PayMatch,IDetailF,IDFolioK);

        If (Not arcSalesMode) and (Syss.AutoCQNo) and (ChkCQNoCode=0) then
          Put_NextChequeNo(NextCQNo,BOn);

        RefUsed:=BOn;
      end;

      Ref1:=NextCQNo;

      If (Not RefUsed) then
      Begin
        Ref2:=PayMatch;

      end
      else
      Begin
        Ref2:='';

      end;

      If (arcCharge1Amt<>0.0) and (arcCharge1GL<>0) then
      Begin
        Gen_AutoPPYLine(arcCharge1GL,arcCharge1Amt,arcPayCurr,Ref1,Ref2,IDetailF,IDFolioK);

        RefUsed:=BOn;
      end;

      If (Not RefUsed) then
      Begin
        Ref2:=PayMatch;

      end
      else
      Begin
        Ref2:='';

      end;

      If (arcCharge2Amt<>0.0) and (arcCharge2GL<>0) then
        Gen_AutoPPYLine(arcCharge2GL,arcCharge2Amt,arcPayCurr,Ref1,Ref2,IDetailF,IDFolioK);


      If (VarAm<>0) then
        Gen_AutoPPYLine(Syss.NomCtrlCodes[CurrVar],VarAm,1,'','',IDetailF,IDFolioK);

      If (PDiscAm<>0) then
        Gen_AutoPPYLine(PDiscGL,PDiscAm,1,'','',IDetailF,IDFolioK);

      LStatus:=LAdd_Rec(Fnum,KeyPath);
      
      //GS 02/11/2011 add an audit note to the created transaction header
      if LStatus = 0 then
      begin
        TAuditNote.WriteAuditNote(anTransaction, anCreate, MtExLocal^);
      end;

      LReport_BError(Fnum,LStatus);

      If (Not Syss.UpBalOnPost) then
        LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOff,2);


    end; {With..}

    {$IFDEF JC}
      If (JBCostOn) and (Assigned (PostOPtr)) then {* Destroy obj that gave access to Job_UpdateActual..}
      Begin
        try
          PostJobObj:=PostOPtr;

          If (Assigned(PostJobObj)) then
            Dispose(PostJobObj,Destroy);
        finally
          PostOPtr:=nil;
        end;
      end;
    {$ENDIF}


  end; {Proc..}


  { ========= Allocation Processing Routine ======= }


  Procedure TScanAlloc.BATCH_PayProcess(Fnum,
                                        Keypath  :  Integer);



  Const
    IFnum      =  InvF;
    IKeypath   =  InvOurRefK;


  Var
    KeyS,
    KeyChk,
    KeyIS,
    KeyIChk    :  Str255;

    PayRef     :  Str10;

    SetDTaken,
    LOk,
    NeedHed,
    WasFromTrans,
    SRCFail,
    SRCLocked,
    GeneratePPY,
    NewObject,
    Locked     :  Boolean;

    DiscSign   :  Integer;

    SRCAddr,
    ShowTrans,
    ItemCount   :  LongInt;

    B_Func      :  Integer;

    SanityResult,
    BHoldMode,
    UOR         :  Byte;



    PayOwnVal,
    PaySDOwnVal,
    PayBase,
    PayIBase,
    DocINow,
    DocIThen,
    DocNow,
    DocThen     :  Real;

    DocBDicsount:  Double;

    SRCInv,
    EInv        :  InvRec;

    {$IFDEF EXSQL}
    // MH 03/12/2009: To speed up processing in the SQL Edition delete any non-allocated rows
    // at the start so the emulator doesn't even see them
    Procedure DeleteUnallocatedEntries (Const TradeCode : Char; Const AccountCode : ShortString);
    Var
      sCompany : ShortString;
      sWhere : ANSIString;
    Begin // DeleteUnallocatedEntries
      sCompany := GetCompanyCode(SetDrive);
      sWhere := '(RecMFix=''X'') And (SubType=''A'') And ' +
                '(SubString(ExStChkVar1, 2, 7) = ' + StringToHex(TradeCode + AccountCode) + ') And ' +
                '(ariTagMode = 0)';

      // CJS 2011-10-19: ABSEXCH-11513 - discarding cached data is now handled
      //                 automatically by DeleteRows().
      DeleteRows(sCompany, 'ExStkChk.Dat', sWhere, MTExLocal^.ExClientID);

      // Dump cache to ensure no emulator issues
      // DiscardCachedData('ExStkChk.Dat', MTExLocal^.ExClientID);
    End; // DeleteUnallocatedEntries
    {$ENDIF}

  Begin

    NeedHed:=BOn;
    Locked:=BOff;

    PayOwnVal:=0;
    PaySDOwnVal:=0;
    PayBase:=0;
    DocNow:=0;
    DocThen:=0;
    DocIThen:=0.0;
    DocINow:=0.0;
    PayIBase:=0.0;
    Discsign:=1;


    ShowTrans:=0;

    UOR:=0; BHoldMode:=0;

    PayRef:='';  GeneratePPY:=BOff;  WasFromTrans:=BOff;

    SRCFail:=BOff; SRCAddr:=0;  SRCLocked:=BOff;

    NewObject:=BOff;

    B_Func:=B_GetNext;

    ItemCount:=0; SanityResult:=0;

    KeyIS:=AllocCtrl.AllocCRec.arcCustCode;

    LOk:=MTExLocal^.LGetMainRec(CustF,KeyIS);

    If (LOk) then
    With MTExLocal^, AllocCtrl.AllocCRec do
    Begin

      InitProgress(arcTagCount);

      ShowStatus(1,'Generating '+DocNames[DocSplit[arcSalesMode,2]]);


      KeyChk:=PartCCKey(MBACSCode,MBACSALSub)+Tradecode[arcSalesMode]+FullCustCode(arcCustCode);

      KeyS:=KeyChk;

      NeedHed:=Not arcFromTrans;

      FillChar(SRCInv,Sizeof(SRCInv),#0);

      If (arcFromTrans) then
      Begin
        PayRef:=arcOurRef;

        KeyIS:=arcOurRef;

        {* Lock SRC so no one can alter it during this process *}

        LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyIS,IKeyPath,IFnum,BOn,Locked);

        SRCLocked:=Locked;

        If (LStatusOk) and (Locked) then
        Begin
          SRCInv:=LInv;

          SRCFail:=Round_Up(ABS(arcTransValue),2)<>Round_Up(ABS(BasetotalOS(SRCInv)),2);

          LGetRecAddr(IFnum);

          SRCAddr:=LastRecAddr[IFnum];
        end
        else
          SRCFail:=BOn;

        SRCInv:=LInv
      end;


      With LCust do
        ShowStatus(2,'Processing '+dbFormatName(CustCode,Company));

      PayOwnVal:=0;
      PayBase:=0;
      PayIBase:=0.0;

      {$IFDEF EXSQL}
        // MH 03/12/2009: To speed up processing in the SQL Edition delete any non-allocated rows
        // at the start so the emulator doesn't even see them
        If SQLUtils.UsingSQLAlternateFuncs Then
        Begin
          DeleteUnallocatedEntries(Tradecode[arcSalesMode], FullCustCode(arcCustCode));
        End; // If SQLUtils.UsingSQLAlternateFuncs
      {$ENDIF}


      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
      With LMiscRecs^.AllocSRec do
      Begin
        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          If (ariTagMode<>0) then
          Begin

            KeyIChk:=ariOurRef;

            KeyIS:=KeyIChk;


            LStatus:=LFind_Rec(B_GetEq,IFnum,IKeyPath,KeyIS);


            If (LStatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (Not ThreadRec^.THAbort) then
            With LInv do
            Begin
              EInv:=LInv;

              SanityResult:=SanityCheckAllocS(LMiscRecs^,EInv);

              If (SanityResult=0) and (Not SRCFail) then
              Begin
                LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyIS,IKeyPath,IFnum,BOn,Locked);

                If (LOk) and (Locked) then
                Begin
                  LGetRecAddr(IFnum);

                  If (NeedHed) then
                  Begin

                    PayRef:=FullDocNum(BatchDocHed(arcSalesMode),BOn);

                    NeedHed:=BOff;

                  end;

                  {DocI* = Value including discount added back in}


                  {$B-}
                  If (DiscSetAm<>0.0) and (ariOrigSetDisc=DiscSetAm) and (RunNo=0) and (Settled=0.0) then
                  {$B+}

                  {* Lets set settlement discount by taking it *}
                  Begin

                    If (Not Syss.UpBalOnPost) then {* We will be reducing value, so have to reduce balance *}
                      LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOn,2);

                    DiscTaken:=BOn;
                    ariOrigSetDisc:=0.0;
                    SetDTaken:=BOn;

                  end
                  else
                    SetDTaken:=BOff;

                  If (ariTagMode=2) then {Part allocated}
                  Begin
                    DocThen:=ariSettle;

                    DocNow:=ariSettleOwn;

                    If ((InvDocHed In RecieptSet+CreditSet) and (ITotal(LInv)<0)) or ((PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)) and (ITotal(LInv)>=0)) then
                    {If (PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)) then}
                    Begin
                      DocThen:=DocThen*DocNotCnst;
                      DocNow:=DocNow*DocNotCnst;
                    end;

                    DiscSign:=DocCnst[InvDocHed]*DocNotCnst;

                    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                    DocIThen:=DocThen+(Round_Up(Conv_TCurr(ariOrigSetDisc,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                                       *DiscSign);

                    DocINow:=DocNow+(Round_Up(ariOrigSetDisc,2)*DiscSign);
                  end
                  else
                  Begin
                    DocBDicsount:=BDiscount;

                    BDiscount:=ariOrigSetDisc;

                    {* Allow for any settlement discount we be putting back *}
                    {If (PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)) then}
                    If ((InvDocHed In RecieptSet+CreditSet) and (ITotal(LInv)<0)) or ((PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)) and (ITotal(LInv)>=0)) then
                      BDiscount:=BDiscount*DocNotCnst;

                    AllocForceInvSDisc(LInv,EInv,AllocCtrl,1);

                    BDiscount:=DocBDicsount;

                    DocThen:=BasetotalOS(EInv);

                    DocNow:=CurrencyOS(EInv,BOn,BOff,BOff);

                    DocIThen:=BasetotalOS(LInv);

                    DocINow:=CurrencyOS(LInv,BOn,BOff,BOff);
                  end;

                  If (Not Syss.UpBalOnPost) and (SetDTaken) then
                    LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOff,2);


                  {$IFDEF MC_On}

                    If (arcPayCurr=Currency) then
                    Begin
                      PayOwnVal:=PayOwnVal+DocNow;

                      PaySDOwnVal:=PaySDOwnVal+DocINow;
                    end
                    else
                    Begin
                      PayOwnVal:=PayOwnVal+Conv_TCurr(DocThen,XRate(arcCXRate,BOff,arcPAyCurr),arcPayCurr,0,BOn);
                      PaySDOwnVal:=PaySDOwnVal+Conv_TCurr(DocIThen,XRate(arcCXRate,BOff,arcPAyCurr),arcPayCurr,0,BOn)
                    end;

                  {$ELSE}

                    PayOwnVal:=PayOwnVal+DocThen;
                    PaySDOwnVal:=PaySDOwnVal+DocIThen;

                  {$ENDIF}


                  PayBase:=PayBase+DocThen;

                  PayIBase:=PayIBase+DocIThen;

                  {* Update invoice *}

                  Settled:=Settled+DocIThen;

                  CurrSettled:=CurrSettled+DocINow;

                  //PR: 29/06/2015 ABSEXCH-16547 Can't use Set_DocAlcStat function as that uses BaseTotalOS
                  if SettledFullCurr(LInv) and (BasetotalOS(LInv) = 0.0) then
                    LInv.AllocStat := #0
                  else //PR: 03/09/2015 2015 R1 ABSEXCH-16820 Need to set to custsupp char if not fully allocated
                    LInv.AllocStat := TradeCode[CustSupp = 'C'];
//                  Set_DocAlcStat(LInv);

                  RemitNo:=PayRef;

                  If (GetHoldType(HoldFlg)=HoldA) then
                    BHoldMode:=HoldDel
                  else
                    BHoldMode:=0;

                  SetHold(BHoldMode,IFnum,IKeyPAth,BOff,LInv);


                  If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* ENv4.22 Cash Accounting set VATdate to Current VAT Period *}
                  Begin

                    // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                    If (arcFromTrans) and (Not SRCFail) then
                      VATPostDate:=CalcVATDate(SRCInv.TransDate)  {v5.71. CA Allows jump to future period, set from period of allocating invoice}
                    else
                      VATPostDate:=CalcVATDate(arcTransDate);  {v5.71. CA Allows jump to future period, set from period of receipt date}

                  end;


                  If (AllocStat=#0) then {* Only set date if fully allocated *}
                    UntilDate:=Today;

                  {$IFDEF JC}
                    Set_DocCISDate(LInv,BOff);
                  {$ENDIF}


                  GeneratePPY:=BOn;

                  LStatus:=LPut_Rec(IFnum,IKeyPath);

                  LReport_BError(IFnum,LStatus);

                  LStatus:=LUnLockMLock(IFnum);

                  {$IFDEF MC_On}

                    LMatch_Payment(LInv,DocIThen,DocINow,3);

                  {$ELSE}  {* Just in case AddNow causes problems on SC *}

                    LMatch_Payment(LInv,DocIThen,DocIThen,3);

                  {$ENDIF}


                end; {If Locked..}


              end {If Passes Filter}
              else
              Begin
                arcAllocFull:=BOff; {* If we fail one, we cannot fully allocate, just allocate what we can *}

                {$IFDEF FRM}
                   If (Assigned(PostLog)) then
                   Begin
                     If (SanityResult<>0) then
                       Write_PostLogDD('It was not possible to allocate '+DocNames[InvDocHed]+' '+OurRef+' because '+Sanity_Reason(SanityResult)+'.',BOn,OurRef,0)
                     else
                       Write_PostLogDD('It was not possible to allocate '+DocNames[SRCInv.InvDocHed]+' '+arcOurRef+' because '+Sanity_Reason(7)+'.',BOn,SRCInv.OurRef,0);

                   end;

               {$ENDIF}


              end;


            end; {If..}



          end; {* If None Tagged *}


          {* Remove Misc Ref *}

          LStatus:=LDelete_Rec(Fnum,KeyPath);

          LReport_BError(Fnum,LStatus);


          If (LStatusOk) then
            B_Func:=B_GetGEq
          else
            B_Func:=B_GetNext;

        end; {If Locked Ok..}

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

      end; {While..}

      If (Not ThreadRec^.THAbort) then
      Begin

        If (GeneratePPY) then
        Begin
          If (Not NeedHed) and (Not arcFromTrans) then {* Generate PPY Hed *}
          Begin

            PayOwnVal:=PayOwnVal*DocCnst[BatchDocHed(arcSalesMode)];

            PaySDOwnVal:=PaySDOwnVal*DocCnst[BatchDocHed(arcSalesMode)];

            PayBase:=PayBase*DocCnst[BatchDocHed(arcSalesMode)];

            PayIBase:=PayIBase*DocCnst[BatchDocHed(arcSalesMode)];

            // CJS 2015-07-07 - ABSEXCH-16578 - PPD Write-Off uses wrong Control Code
            Generate_AutoPPY(PayOwnVal, PayBase, PayIBase, PaySDOwnVal,
                             PayRef, IFnum, IKeypath,
                             TransactionHelper(@LInv).SettlementDiscountSupported);

          end
          else
          If (Not SRCFail) then
          Begin
            KeyIS:=arcOurRef;

            LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyIS,IKeyPath,IFnum,BOn,Locked);

            If (LOk) and (Locked) then
            With LInv do
            Begin
              LGetRecAddr(IFnum);

              If (arcAllocFull) then
              Begin
                Settled:=0.0;

                Settled:=Round_Up(BasetotalOS(LInv),2);

                CurrSettled:=0.0;

                CurrSettled:=CurrencyOS(LInv,BOn,BOff,BOff);
              end
              else
              Begin
                If (Not RightSignDoc(LInv)) then {* v5.52 Its a negative transaction *}
                Begin
                  PayBase:=PayBase*DocNotCnst;
                  PayOwnVal:=PayOwnVal*DocNotCnst;
                end;

                Settled:=Settled+Round_Up(PayBase*DocCnst[BatchDocHed(arcSalesMode)]*DocCnst[InvDocHed]*DocNotCnst,2);

                If ((PayOwnVal*DocCnst[BatchDocHed(arcSalesMode)])>arcOwnTransValue) then {We are trying to allocate too much
                                                                                          own currency owing to a non correlation
                                                                                          between base and own, poss due to exsiting variance}
                  CurrSettled:=CurrSettled+Round_up(arcOwnTransValue*DocCnst[InvDocHed]*DocNotCnst,2)
                else
                  CurrSettled:=CurrSettled+Round_up(PayOwnVal*DocCnst[BatchDocHed(arcSalesMode)]*DocCnst[InvDocHed]*DocNotCnst,2)
              end;


              Set_DocAlcStat(LInv);  {* Set Allocation Status *}

              If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* ENv4.22 Cash Accounting set VATdate to Current VAT Period *}
              Begin

                //VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                VATPostDate:=CalcVATDate(TransDate); {v5.71. CA Allows jump to future period}
                
              end;

              If (AllocStat=#0) then {* Only set date if fully allocated *}
                UntilDate:=Today;

              Blank(RemitNo,Sizeof(RemitNo));

              {$IFDEF JC}
                Set_DocCISDate(LInv,BOff);
              {$ENDIF}

              LStatus:=LPut_Rec(IFnum,IKeyPath);

              LReport_BError(IFnum,LStatus);


              LStatus:=LUnLockMLock(IFnum);

              SRCLocked:=Not LStatusOk;

            end;
          end;
        end
        else
          If (Not GeneratePPY) and (Not arcFromTrans) and (arcOwnTransValue<>0.0) then
          {* Generate an unallocated PPY *}
          Begin
            PayRef:=FullDocNum(BatchDocHed(arcSalesMode),BOn);

            // CJS 2015-07-07 - ABSEXCH-16578 - PPD Write-Off uses wrong Control Code
            Generate_AutoPPY(0.0, 0.0, 0.0, 0.0, PayRef, IFnum, IKeypath,
                            TransactionHelper(@LInv).SettlementDiscountSupported);

            GeneratePPY:=BOn;
          end;


        WasFromTrans:=arcFromTrans;

        {* Inform input window batch To Un lock *}

        SendMessage(CallBackH,WM_CustGetRec,65,0);

        arcLocked:=0;  arcForceNew:=BOn;  arcTotal:=0.0;  arcFromTrans:=BOff;
        Blank(arcOurRef,sizeof(arcOurRef));

        Alloc_CtrlPut(MLocF,MLK,AllocCtrl,MTExLocal,0);


        If (GeneratePPY) and (Not wasFromTrans) then {If it was created from new, show it}
        Begin
          AssignToGlobal(InvF);
          ShowTrans:=1;
        end;

         {$IFDEF CU} {* Call any post store hooks here *}

         If (LHaveHookEvent(2000,170,NewObject)) then
           LExecuteHookEvent(2000,170,MTExLocal^);

         {$ENDIF}

        //PR: 09/07/2015 Send message to Allocation Wizard to Create PPD journeal credit
        SendMessage(CallBackH,WM_CustGetRec,201,0);

        {* Inform input window To close *}
        SendMessage(CallBackH,WM_CustGetRec,67,ShowTrans);

      end;

      If (SRCLocked) and (SRCAddr<>0) then {* We never got as far as processing it, so unlock original SRC *}
      Begin
        LastRecAddr[IFnum]:=SRCAddr;

        LStatus:=LUnLockMLock(IFnum);
      end;
    end; {With..}

  end; {Proc..}



  { ========= Check Routine ======= }


  Procedure TScanAlloc.Check_PayProcess(Fnum,
                                        Keypath  :  Integer);



  Const
    IFnum      =  InvF;
    IKeypath   =  InvOurRefK;


  Var
    LOk,
    Locked     :  Boolean;

    KeyS,
    KeyChk,
    KeyIS,
    KeyIChk    :  Str255;

    SanityResult
               :  Byte;

    ItemCount   :  LongInt;


    OriginalValue
               :  Double;

    TmpMisc    :  MiscRec;

    EInv       :  InvRec;


  { == Restate the amount outstanding based on settlement discount == }
  {Replicated in ALCItemU}

  Procedure ReStateOS;

  Begin
    With MTExLocal^, AllocCtrl.AllocCRec, LMiscRecs^.AllocSRec do
    Begin

      ariBaseOS:=BasetotalOS(EInv);
      {$IFDEF MC_On}

        ariCurrOS:=CurrencyOS(EInv,BOff,BOff,BOff);

        If (arcPayCurr=ariOrigCurr) then
          ariOutStanding:=ariCurrOS
        else
          ariOutStanding:=Currency_ConvFT(ariBaseOS,0,arcPayCurr,UseCoDayRate);

      {$ELSE}

        ariOutStanding:=ariBaseOS;

        ariCurrOS:=ariBaseOS;
      {$ENDIF}



    end; {With..}
  end;

  {Replicated in ALCItemU}
  Procedure  ReapplySDisc;

  Begin
    With MTExLocal^, LMiscRecs^.AllocSRec do
    Begin

      ariOrigSetDisc:=ariOrigSetDisc-ariOwnDiscOR;

      LInv.BDiscount:=ariOrigSetDisc;

      AllocForceInvSDisc(LInv,EInv,AllocCtrl,1);

      ReStateOS;
    end; {With..}


  end;

  Function Calc_CheckSum  :  Double;

  Begin
    With AllocCtrl.AllocCRec do
      Result:=Round_Up(arcTransValue+arcTotal+arcVariance+arcSettleD,2);

  end;

  Begin

    ItemCount:=0; SanityResult:=0;

    FillChar(TmpMisc,Sizeof(TmpMisc),#0);

    With MTExLocal^, AllocCtrl.AllocCRec do
    Begin

      InitProgress(arcTagCount);

      ShowStatus(1,'Checking Allocations');


      KeyChk:=PartCCKey(MBACSCode,MBACSALSub)+Tradecode[arcSalesMode]+FullCustCode(arcCustCode);

      KeyS:=KeyChk;

      OriginalValue:=Calc_CheckSum;

      arcCheckFail:=BOff;

      arcTotal:=0.0;
      arcTotalOwn:=0.0;
      arcVariance:=0.0;
      arcSettleD:=0.0;
      arcOwnSettleD:=0.0;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
      With LMiscRecs^.AllocSRec do
      Begin

        If (ariTagMode<>0) then
        Begin

          KeyIChk:=ariOurRef;

          KeyIS:=KeyIChk;


          LStatus:=LFind_Rec(B_GetEq,IFnum,IKeyPath,KeyIS);


          If (LStatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (Not ThreadRec^.THAbort) then
          With LInv do
          Begin
            SanityResult:=SanityCheckAllocS(LMiscRecs^,LInv);

            If (SanityResult=0) then {Re calc totals}
            Begin
              UpdateAllocCRec(TmpMisc,LMiscRecs^,AllocCtrl,MTExLocal);
            end {If Passes Filter}
            else
            Begin
              arcAllocFull:=BOff; {* If we fail one, we cannot fully allocate, just allocate what we can *}

              arcCheckFail:=BOn;

              {$IFDEF FRM}
                 If (Assigned(PostLog)) then
                 Begin
                   Write_PostLogDD(DocNames[InvDocHed]+' '+OurRef+' has been unallocated because '+Sanity_Reason(SanityResult)+'.',BOn,OurRef,0);

                 end;

              {$ENDIF}

              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum);

                ariTagMode:=0;

                ariSettle:=0.0;
                ariSettleOwn:=0.0;
                ariVariance:=0.0;

                ariReValAdj:=0.0;

                ariSetDisc:=0.0;

                If (ariOwnDiscOR<>0) then
                Begin
                  ariOwnDiscOR:=ariOwnDiscOR*DocNotCnst;

                  ReApplySDisc;

                  ariDiscOR:=0.0; ariOwnDiscOR:=0.0;
                end;

                LStatus:=LPut_Rec(Fnum,KeyPath);

                LReport_BError(Fnum,LStatus);

                LStatus:=LUnLockMLock(Fnum);

              end;
            end;


          end; {If..}



        end; {* If None Tagged *}



        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}


      {* Inform input window batch To Un lock *}

      SendMessage(CallBackH,WM_CustGetRec,65,0);

      If (Not arcCheckFail) then {Check totals still agree}
        arcCheckFail:=(OriginalValue<>Calc_CheckSum);

      Alloc_CtrlPut(MLocF,MLK,AllocCtrl,MTExLocal,0);

      {* Inform input window To re-lock record *}

      SendMessage(CallBackH,WM_CustGetRec,66,0);

      If (Not arcCheckFail) and (FuncMode=3) and (Not ThreadRec^.THAbort) then {Start up process}
        {SendMessage(CallBackH,WM_CustGetRec,88,0);}
      Begin
        BATCH_PayProcess(MiscF,MIK);

      end
      else
        SendMessage(CallBackH,WM_CustGetRec,88,0);


    end; {With..}

  end; {Proc..}



  { ========= Check Routine ======= }


  Procedure TScanAlloc.Settle_Alloc(Fnum,
                                    Keypath  :  Integer);



  Const
    IFnum      =  InvF;
    IKeypath   =  InvOurRefK;


  Var
    LOk,
    Locked     :  Boolean;

    KeyS,
    KeyChk,
    KeyIS,
    KeyIChk    :  Str255;

    UOR,
    SanityResult
               :  Byte;

    TransCnst  :  Integer;

    ItemCount  :  LongInt;

    NewBase    :  Double;

    TmpMisc    :  MiscRec;

    EInv       :  InvRec;

    //PR: 26/05/2015 v7.0.14 PPD variables
    PPDValue : Double;
    PPDValueInBase : Double;

    UsePPD : Boolean;
    AmountUnallocated : Double;


  Begin
    UsePPD := False;
    ItemCount:=0; SanityResult:=0;  NewBase:=0.0; UOR:=0; TransCnst:=0;

    FillChar(TmpMisc,Sizeof(TmpMisc),#0);

    With MTExLocal^, AllocCtrl.AllocCRec do
    If (Round_Up(Calc_arcUnallocated(AllocCtrl,BOff),2)>0.0) then
    Begin

      InitProgress(arcTagCount);

      ShowStatus(1,'Settling Allocations');


      KeyChk:=PartCCKey(MBACSCode,MBACSALSub)+Tradecode[arcSalesMode]+FullCustCode(arcCustCode);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) and (Round_Up(Calc_arcUnallocated(AllocCtrl,BOff),2)>0.0) do
      With LMiscRecs^.AllocSRec do
      Begin

        If (ariTagMode=0) then {Ignore anything already tagged}
        Begin

          KeyIChk:=ariOurRef;

          KeyIS:=KeyIChk;


          LStatus:=LFind_Rec(B_GetEq,IFnum,IKeyPath,KeyIS);


          If (LStatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (Not ThreadRec^.THAbort) then
          With LInv do
          Begin
            SanityResult:=SanityCheckAllocS(LMiscRecs^,LInv);

            If (SanityResult=0) then {Re calc totals}
            Begin
              TmpMisc:=LMiscRecs^;

              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum);


                //PR: 26/05/2015 v7.0.14 Calculate PPD value in base as we'll need it to decide whether we can apply it on a partial allocate
                PPDValue := Round_Up(LInv.thPPDGoodsValue + LInv.thPPDVATValue, 2)* DocCnst[Inv.InvDocHed ]* DocNotCnst;
              {$IFDEF MC_On}
                UOR:=fxUseORate(BOff,BOn,arcCXRate,0,arcPayCurr,0);

                PPDValueInBase := Round_Up(Conv_TCurr(PPDValue,XRate(arcCXRate,BOff,arcPayCurr),arcPayCurr,UOR,BOff), 2);
               {$ELSE}
                PPDValueInBase := PPDValue;
               {$ENDIF}

                //Is PPD already taken on the this transaction?
                //PR: 25/08/2015 ABSEXCH-16754 Changed from LInv.thPPDTaken <> thPPDTaken which was never going to be true
                UsePPD :=  LInv.thPPDTaken = ptPPDNotTaken;

                //If not, can we take it?
                UsePPD := UsePPD and (AllocPPDMode = apTakeAlways) or
                                     ((AllocPPDMOde = apTakeWithinTerms)
                                      and (CalcDueDate(LInv.TransDate, LInv.thPPDDays) > AllocCtrl.AllocCRec.arcTransDate));

                AmountUnallocated := Calc_arcUnallocated(AllocCtrl,BOff);

                //PR: 26/05/2015 v7.0.14Check if the remaining amount on the allocation can fully allocate this transaction or,
                //if PPD can be used, can it fully allocate the o/s inc ppd.
                If (AmountUnallocated > (ariBaseOS*DocCnst[InvDocHed]*DocNotCnst)) or
                   (UsePPD and //PR: 26/08/2015 ABSEXCH-16754 Need to remove sign from PPDValueInBase before subtracting
                   (Round_Up(AmountUnallocated, 2) >= Round_Up((ariBaseOS*DocCnst[InvDocHed]*DocNotCnst) - Abs(PPDValueInBase), 2))) then
                Begin
                  if not UsePPD then
                  begin //If don't take, or take within terms and this transaction is outside terms, continue with original behaviour
                    ariSettle:=ariBaseOS;

                    ariSettleOwn:=ariCurrOs;

                    //PR: 26/08/2015 ABSEXCH-16798 Moved from below as should be 2 if ppd
                    ariTagMode:=1;
                  end
                  else
                  begin
                    //Subtract PPD from settled amounts

                    ariSettle := Round_Up(ariBaseOS - PPDValueInBase, 2);
                    ariSettleOwn := Round_Up(ariCurrOs - PPDValue, 2);
                    ariPPDStatus := 1;

                    //PR: 26/08/2015 ABSEXCH-16798 Need to set ariTagMode to 2 for part allocation
                    ariTagMode:=2;
                  end;


                  TransCnst:=DocCnst[InvDocHed]*DocNotCnst;

                  {$IFDEF MC_On}
                    If (arcPayCurr=ariOrigCurr) and (arcPayCurr<>0) and (Not arcFromTrans) then
                    Begin
                      UOR:=fxUseORate(BOff,BOn,arcCXRate,0,arcPayCurr,0);

                      NewBase:=Conv_TCurr(ariSettleOwn*TransCnst,XRate(arcCXRate,BOff,arcPayCurr),arcPayCurr,UOR,BOff);

                      ariVariance:=Round_Up(NewBase-ariSettle*TransCnst,2);
                    end;

                    ariReValAdj:=ariOrigReValAdj;
                  {$ENDIF}
                end
                else
                Begin
                  ariSettle:=Calc_arcUnallocated(AllocCtrl,BOff)*DocCnst[InvdocHed]*DocNotCnst;

                  If (ariSettle=ariBaseOS) then {v5.50 it is fully allocated in base, so force own to be too}
                    ariSettleOwn:=ariCurrOs
                  else
                    ariSettleOwn:=Currency_ConvFT(Conv_TCurr(Calc_arcUnallocated(AllocCtrl,BOn),XRate(arcCXRate,BOff,arcPAyCurr),arcPayCurr,0,BOff),0,ariOrigCurr,UseCoDayRate)*DocCnst[InvdocHed]*DocNotCnst;


                  ariTagMode:=2;
                end;

                ariSetDisc:=ariOrigSetDisc;

                UpdateAllocCRec(TmpMisc,LMiscRecs^,AllocCtrl,MTExLocal);

                LStatus:=LPut_Rec(Fnum,KeyPath);

                LReport_BError(Fnum,LStatus);

                LStatus:=LUnLockMLock(Fnum);

              end;
            end {If Passes Filter}
            else
            Begin
              {$IFDEF FRM}
                 If (Assigned(PostLog)) then
                 Begin
                   Write_PostLogDD('It was not possible to allocate '+DocNames[InvDocHed]+' '+OurRef+' because '+Sanity_Reason(SanityResult)+'.',BOn,OurRef,0);

                 end;

              {$ENDIF}


            end;


          end; {If..}



        end; {* If None Tagged *}



        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}


      {* Inform input window batch To Un lock *}

      SendMessage(CallBackH,WM_CustGetRec,65,0);

      Alloc_CtrlPut(MLocF,MLK,AllocCtrl,MTExLocal,0);

      {* Inform input window To re-lock record *}

      SendMessage(CallBackH,WM_CustGetRec,66,0);

    end; {With..}

  end; {Proc..}




  Procedure TScanAlloc.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Allocation Update');

    With MTExLocal^ do
    Begin
      Write_PostLog('',BOff); {Initialise the exceptions log}

      CustAlObj.MTExLocal:=MTExLocal;

      Try
        Case FuncMode of
          1  :  If (Not AllocCtrl.AllocCRec.arcCheckFail) then
                  BATCH_PayProcess(MiscF,MIK);

          2,3:  Check_PayProcess(MiscF,MIK);

          30 :  Settle_Alloc(MiscF,MIK);

          else  Begin

                  Alloc_Scan(MiscF,MIK);
                end;


        end; {Case..}
      except;

      end; {Try..}
    end;

  end;


  Procedure TScanAlloc.Finish;
  Begin
    Inherited Finish;

    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          PostLog.PrintLog(PostRepCtrl,'Allocation omissions and exception log.');

      {$ENDIF}
    {$ENDIF}


    {Overridable method}

    InMainThread:=BOff;

    {* Inform input window batch has been calculated *}

    If (FuncMode In [0,2,30]) or ((FuncMode=3) and (AllocCtrl.AllocCRec.arcCheckFail)) then
      SendMessage(CallBackH,WM_CustGetRec,55,0);

  end;



  Function TScanAlloc.Start(BCtrl    :  MLocRec;
                            InpWinH  :  THandle)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOn;


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


        If (Result) then { Open up files here }
        Begin
          MTExLocal:=PostExLocal;


          Result:=Assigned(MTExLocal);
        end;
      end;
      If (Result) then
      Begin
        AllocCtrl:=BCtrl;
        CallBackH:=InpWinH;
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

{ ============== }


Procedure AddAllocScan2Thread(AOwner   :  TObject;
                              BCtrl    :  MLocRec;
                              MyHandle :  THandle;
                              fMode    :  Byte;
                              PPDMode  :  TAllocPPDMode = apDontTake;
                              AHasPPD  :  Boolean = False);


  Var
    LCheck_Batch :  ^TScanAlloc;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          FuncMode:=fMode;
          AllocPPDMode := PPDMode;
          HasPPD := AHasPPD;

          If (Start(BCtrl,MyHandle)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,'Allocate PPY/SRC');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;

{$ELSE}

Procedure AddAllocScan2Thread(AOwner   :  TObject;
                                BCtrl    :  MLocRec;
                                MyHandle :  THandle;
                                fMode    :  Byte);
Begin



end;


{$ENDIF}



end.