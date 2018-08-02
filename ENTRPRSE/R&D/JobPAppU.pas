unit JobPAppU;

interface

{$I DEFOVR.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VarConst,VarRec2U,BtrvU2,BTSupU1,ExWrap1U, BTSupU3, BorBtns,SupListU,
  JobPostU, JobSup2U;


Type



TPostJobApp   =   Object(TPostJob)

                     private
                        jpAppCtrlRec  :  tJAppWizRec;
                        DeferVAT      :  Boolean;
                        JACumAct      :  Double;
                        JACumCnt      :  LongInt;
                        Function LFind_AppRunHed(KeyChk  :  Str255;
                                                 Fnum,
                                                 Keypath :  Integer;
                                                 TCurr   :  Byte;
                                                 SRunNo  :  LongInt)  :  Boolean;

                        Function Get_AppInvHed(InvR  :  InvRec;
                                               ConsA :  Boolean;
                                               SRunNo:  LongInt;
                                               Fnum,
                                               Keypath
                                                     :  Integer;
                                               Mode  :  Byte;
                                        Var    HedAddr
                                                     :  LongInt)  :  Boolean;

                        Procedure LGenerate_AppRetention(RetMode  :  Byte;
                                                         IdR      :  IDetail;
                                                         InvR,
                                                         JInv     :  InvRec;
                                                         JCode,
                                                         ACode    :  Str10 );

                        Procedure LReveal_JAPIns(MatchK  :  Str255;
                                                 MLen,
                                                 Mode    :  Byte;
                                                 Fnum,
                                                 Keypath :  Integer);

                        Procedure Generate_JSAReceipt(BInv  :  InvRec;
                                                  Var NInv  :  InvRec;
                                                      Fnum,
                                                      Keypath
                                                            :  Integer);

                        Procedure Post_JAPINDetails(BInv          :  InvRec;
                                                Var GotHed,
                                                    RecoverMode   :  Boolean;
                                                Var NInv          :  InvRec;
                                             Const  TTEnabled     :  Boolean);

                        Procedure Post_JAPBatch(Manual    :  Boolean;
                                            Var TTEnabled :  Boolean);


                        Procedure Post_JAPSingle(Manual    :  Boolean;
                                             Var TTEnabled :  Boolean);

                        Procedure Aggregate_JSALines(NInv  :  InvRec;
                                                     LastYTDFolio
                                                           :  LongInt;
                                                 Var Abort,
                                                     TTEnabled
                                                           :  Boolean);

                        Procedure Aggregate_TagJSAs(Var TTEnabled :  Boolean);

                        Function LGetJBudgetBudget(PJBudget  :  JobCtrlRec)  :  Double;

                        Procedure LApply_ValLowerDownBudget(PJBudget  :  JobCtrlRec);

                        Procedure LApply_ValLowerDownHed(PJBudget  :  JobCtrlRec);

                        Procedure LHunt_LowerLevels(JobR      :  JobRecType;
                                                    PJBudget  :  JobCtrlRec;
                                                    Level     :  LongInt);

                        Function LRev_Prorata(PJBudget  :  JobCtrlRec;
                                              RevType   :  Byte)  :  Double;

                        Function NearestValue(Value   :  Double)  :  Double;

                        Procedure LScan_ContractValuation;

                        Procedure LScan_Expenditure(PJBudget  :  JobCtrlRec;
                                                    RevType   :  Byte);

                        Procedure LGet_ValuationxExpenditure;

                        Procedure LHunt_ValuationExpenditure(JobC  :  Str10;
                                                             Level :  LongInt);

                        {$IFDEF DBD}
                          Procedure Check_Run512(Level :  LongInt);
                        {$ENDIF}  

                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;

                       Procedure Finish;  Virtual;


                   end; {Class..}


Procedure AddJobPostApp2Thread(AOwner   :  TObject;
                               SMode    :  Byte;
                               JCRPtr   :  tJAppWizRec;
                               MyHandle :  THandle);

Procedure Post_SingleApp(InvR    :  InvRec;
                         DocHed  :  DocTypes;
                         Owner   :  TWinControl);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  VarJCstU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  NoteSupU,
  SysU1,
  SysU2,
  SysU3,
  JobSup1U,

  {$IFDEF Inv}
    MiscU,

  {$ENDIF}

  {$IFDEF FRM}
    FrmThrdU,
  {$ENDIF}
  BPyItemU,
  JChkUseU,
  LedgSupU,
  GenWarnU,
  ReValU2U,
  AllocS2U,
  ExThrd2U,

  // MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  AuditNotes;







  { ========== TPostJob methods =========== }

  Constructor TPostJobApp.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    Blank(jpAppCtrlRec,Sizeof(jpAppCtrlRec));
    DeferVAT:=BOff;
  end;

  Destructor TPostJobApp.Destroy;

  Begin

    Inherited Destroy;
  end;

{ ========= Find Existing Header ======= }

Function TPostJobApp.LFind_AppRunHed(KeyChk  :  Str255;
                                     Fnum,
                                     Keypath :  Integer;
                                     TCurr   :  Byte;
                                     SRunNo  :  LongInt)  :  Boolean;


Var
  KeyS     :  Str255;
  FoundOk  :  Boolean;




Begin

  FoundOk:=BOff;

  KeyS:=KeyChk;

  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundOk) do
    With LInv do
    Begin
      FoundOk:=((Currency=TCurr) and (((RunNo=JAHideSRunNo) and (InvDocHed In SalesSplit)) or ((RunNo=JAHidePRunNo) and (InvDocHed In PurchSplit))));


      If (Not FoundOk) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

    end; {While..}

    LFind_AppRunHed:=FoundOk;
  end; {With..}

end; {Func..}

  { ========= Auto generation of Doc Header ======== }

Function TPostJobApp.Get_AppInvHed(InvR  :  InvRec;
                                   ConsA :  Boolean;
                                   SRunNo:  LongInt;
                                   Fnum,
                                   Keypath
                                         :  Integer;
                                   Mode  :  Byte;
                            Var    HedAddr
                                         :  LongInt)  :  Boolean;





Var
  KeyChk,
  KeyS     :  Str255;

  Loop, LOK,
  Locked,
  FoundHed :  Boolean;

  n        :  Byte;

  VT       :  VATType;

  FirstCode,
  FoundCode:  Str20;



  DelAddr  :  AddrTyp;

  RecAddr  :  LongInt;


Begin

  With MTExLocal^ do
  Begin
    Loop:=BOn; LOK:=BOff; Locked:=BOff;

    FoundHed:=BOff;

    Blank(DelAddr,Sizeof(DelAddr));

    n:=1;

    RecAddr:=0;

    KeyS:=FullCustCode(InvR.CustCode);

    FirstCode:=InvR.CustCode;

    Repeat  {* Recursivley go and get Head Office account No. Windows uses Invoice To Account. *}



      If (LGetMainRecPos(CustF,KeyS)) then
      Begin


        If (n=1) then
          DelAddr:=LCust.Addr;

        If (Not EmptyKey(LCust.SOPInvCode,CustKeyLen)) and (Mode In [1]) and (LCust.SOPInvCode<>FirstCode) then
        Begin

          KeyS:=FullCustCode(LCust.SOPInvCode);

          Loop:=BOff;

        end;
      end;

      inc(n);

      Loop:=Not Loop;

    Until (Not Loop);


    If (ConsA) then {* Do we have a doc already? of the right currency? *}
    Begin

      KeyChk:=FullCustType(LCust.CustCode,CustHistJPCde);

      FoundHed:=LFind_AppRunHed(KeyChk,Fnum,InvCustK,InvR.Currency,SRunNo);

    end;

    With LInv do
    If (Not FoundHed) then
    Begin

      LInv:=InvR;

      If (InvR.InvDocHed=JSA) then
        InvDocHed:=SIN
      else
      Begin
        With LJobMisc^.EmplRec do
          If (GSelfBill) then
            InvDocHed:=PJI
          else
            InvDocHed:=PIN;
      end;

      ILineCount:=1;
      NLineCount:=1;


      Case Mode of

        1
           :  Begin

                If (Syss.ProtectYRef) then
                Begin
                  TransDesc:=InvR.OurRef;
                end
                else
                Begin
                  YourRef:=InvR.OurRef;

                  TransDesc:=InvR.YourRef;
                end;

                Blank(RemitNo,Sizeof(RemitNo));

                RemitNo:=InvR.OurRef;


                DelTerms:=LCust.SSDDelTerms;
                TransMode:=LCust.SSDModeTr;

                TransNat:=SetTransNat(InvDocHed);

                {If (LCust.DefTagNo>0) then
                  Tagged:=Cust.DefTagNo;}

                If (TransMode=0) then
                  TransMode:=1;

                {*v5.52 Set ctrl nom from supplier record *}
                CtrlNom:=LCust.DefCtrlNom;

                Case Mode of
                  1  :  Begin
                          If (InvDocHed In SalesSplit) then
                            RunNo:=JAHideSRunNo
                          else
                            RunNo:=JAHidePRunNo;

                          If (Not SyssJob^.JobSetUp.JAInvDate) then
                            TransDate:=Today; {v5.60.001 override cert date}

                          DueDate:=CalcDueDate(TransDate,LCust.PayTerms);

                          AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

                          If (Syss.AutoPrCalc) then
                            LDate2Pr(TransDate,AcPr,AcYr,MTExLocal);

                        end;

                end; {Case..}

                // MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
                If TransactionHelper(@LInv).SettlementDiscountSupported Then
                Begin
                  DiscSetl:=Pcnt(LCust.DefSetDisc);
                  DiscDays:=LCust.DefSetDDays;
                End; // If TransactionHelper(@ExLocal.LInv).SettlementDiscountSupported
              end; {With..}
      end; {Case..}




      PrintedDoc:=BOff;

      Tagged:=0;

      CustCode:=LCust.CustCode;


      OpName:=EntryRec^.LogIn;

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(LInv);

      If (DAddr[1]='') and (DAddr[2]='') then
        DAddr:=DelAddr;

      SetNextDocNos(LInv,BOn);

      CustSupp:=CustHistJPCde;


      Re_setDocTots(LInv,((Not LInv.ManVAT) or (ConsA))); {* Don't auto reset vat automaticly,
                                                                              unless a consolidated inv or normal ?IN *}

      PickRunNo:=0; PDiscTaken:=BOff;

      Blank(BatchLink,Sizeof(BatchLink));

      Blank(VATPostDate,Sizeof(VATPostDate));
      FillChar(PostDate,Sizeof(PostDate),0);
      FillChar(OldORates,Sizeof(OldORates),0);


      If (Not SOPKeepRate) then
      Begin
        CXrate:=SyssCurr.Currencies[Currency].CRates;
        SetTriRec(Currency,UseORate,CurrTriR);
      end;

      SOPKeepRate:=BOff;

      {Blank(DJobCode,Sizeof(DJobCode)); b561.004. Preserved so reports on related pins can be generated}

      CXrate[BOff]:=0;

      VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;

      OrigRates:=SyssCurr^.Currencies[Currency].CRates;

      UseORate:=0;

      SetTriRec(Syss.VATCurr,UseORate,VATTriR);

      CISManualTax:=BOn;
      CISHolder:=3;

      If (LJobMisc^.EmplRec.CISType=0) and (InvDocHed In PurchSplit) then {* v5.71 Employee set to N/A CIS, so this document is outside the scope of CIS, remove CISEmpl Link *}
        Blank(CISEmpl,Sizeof(CISEmpl));

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      If (LStatusOk) then
      Begin
        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        LGetRecAddr(Fnum);

        HedAddr:=LastRecAddr[Fnum];
      end;


      FoundHed:=LStatusOk and LOK;


    end {If FoundHed}
    else
      If (ConsA) then
      Begin
        CISTax:=CISTax+InvR.CISTax;
        CISGross:=CISGross+InvR.CISGross;

        If (ManVAT) then
        Begin
          InvVAT:=InvVAT+InvR.InvVAT;

          For VT:=Low(VATType) to High(VATType) do
          Begin
            InvVATAnal[VT]:=InvVATAnal[VT]+InvR.InvVATAnal[VT];
          end;

        end;

      end;
  end; {With..}
  Result:=FoundHed;

end; {Func..}


{ ====== Proc to Generate separate retentions for manual retention lines, and defered Tax applications ====== }

Procedure TPostJobApp.LGenerate_AppRetention(RetMode  :  Byte;
                                             IdR      :  IDetail;
                                             InvR,
                                             JInv     :  InvRec;
                                             JCode,
                                             ACode    :  Str10 );

Const
  Fnum3     =  JDetlF;
  Keypath3  =  JDLedgerK;


Var
  KeyS3     :  Str255;


Begin
  With MTExLocal^,LJobDetl^,JobReten do
  Begin
    LResetRec(Fnum3);

    RecPfix:=JARCode;

    SubType:=JBPCode;

    JobCode:=JCode;
    OrigDate:=InvR.TransDate;

    AccType:=TradeCode[(InvR.InvDocHed In SalesSplit)];

    RetYr:=GetLocalPr(0).CYr;
    RetPr:=GetLocalPr(0).CPr;

    {$IFDEF MC_On}

      RetCurr:=InvR.Currency;

    {$ENDIF}

    Case RetMode of
      1  :  Begin
              RetDate:=IdR.PDate;
              RetValue:=IdR.NetValue;
              AnalCode:=IdR.AnalCode;
              RetCCDep:=IdR.CCDep;
              DefVATCode:=IdR.VATCode;
              RetCrDoc:=InvR.OurRef;
            end;

      2  :  Begin
              RetDate:=MaxUntilDate;
              RetValue:=JInv.InvVAT;
              DefVATCode:=VATSTDCode;
              RetCCDep:=IdR.CCDep;
              AnalCode:=IdR.AnalCode;
            end;
    end; {Case..}

    RetCustCode:=InvR.CustCode;
    RetDoc:=InvR.OurRef;

    RetenCode:=FullJRHedKey(JobCode,AccType,RetCurr,RetDate);
    InvoiceKey:=FullJRDryKey(JobCode,AccType,RetDate);

    RetAppMode:=RetMode;

    If (RetMode=2) then {* Generate and apportion credit *}
    Begin
      LastJobDetl^:=LJobDetl^;
      Gen_RetSCR(LastJobDetl^.JobReten.RetCrDoc);
      LJobDetl^:=LastJobDetl^;
    end;

    LStatus:=LAdd_Rec(Fnum3,KeyPath3);

    LReport_BError(Fnum3,LStatus);




  end; {With..}
end;


{ ====== Proc to Total & workout BOM for a run of Documents ====== }

Procedure TPostJobApp.LReveal_JAPIns(MatchK  :  Str255;
                                      MLen,
                                      Mode    :  Byte;
                                      Fnum,
                                      Keypath :  Integer);



Var
  KeyS,
  KeyChk  :  Str255;

  TmpStat,
  B_Func  :  Integer;

  LAddr   :  LongInt;

  LOk,
  Locked  :  Boolean;

  ExLocal  :  TdExLocal;

Begin

  Locked:=BOff;

  KeyChk:=MatchK;

  KeyS:=KeyChk;

  If (MLen=0) then
    MLen:=Length(MatchK);


  B_Func:=B_GetNext;

  With MTExLocal^ do
  Begin

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,MLen,BOn)) and (Not ThreadRec^.THAbort) do
    With LInv do
    Begin
      Locked:=BOff;

      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOff,Locked);

      If (LOk) and (Locked) then
      Begin
        LGetRecAddr(Fnum);

        RunNo:=0;

        CustSupp:=TradeCode[(InvDocHed In SalesSplit)];

        Set_DocAlcStat(LInv);  {* Set Allocation Status *}

        LStatus:=LPut_Rec(Fnum,KeyPath);

        LReport_BError(Fnum,LStatus);

        If (LStatusOk) then
        Begin
          LStatus:=LUnLockMLock(Fnum);

          B_Func:=B_GetGEq;
        end;

        {* Update Accont Balance *}

        If (LStatusOk) and (Not (LInv.InvDocHed In QuotesSet+PSOPSet)) then
          With LInv do
          Begin
            If (Not Syss.UpBalOnPost) then
              UpdateBal(LInv,(ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                     (ConvCurrICost(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                     (ConvCurrINet(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                     BOff,2);

          end;
      end;

      LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

    end; {While..}
  end; {With..}
end; {Proc..}


 Procedure TPostJobApp.Generate_JSAReceipt(BInv  :  InvRec;
                                       Var NInv  :  InvRec;
                                           Fnum,
                                           Keypath
                                                 :  Integer);

 Var
   PayBase,
   PayOwn     :  Double;

   RInv       :  InvRec;

   GenSRCObj  :  ^TScanAlloc;

 Begin
   PayBase:=0.0;

   New(GenSRCObj,Create(Self.fMyOwner));

   Try
     With GenSRCObj^ do
     Begin
       MTExLocal:=Self.MTExLocal;

       Blank(AllocCtrl,Sizeof(AllocCtrl));

       With AllocCtrl.AllocCRec do
       Begin
         arcSalesMode:=BOn;

         arcOpoName:=NInv.OpName;
         arcJobCode:=NInv.DJobCode;
         arcAnalCode:=BInv.DAddr[3];
         arcUD1:=NInv.DocUser1;
         arcUD2:=NInv.DocUser2;
         arcUD3:=NInv.DocUser3;
         arcUD4:=NInv.DocUser4;
         arcCXrate:=NInv.CXRate;

         arcYourRef:=BInv.OurRef;

         arcOwnTransValue:=BInv.CurrSettled;
         arcTransValue:=arcOwnTransValue;

         arcOurRef:=FullDocNum(BatchDocHed(arcSalesMode),BOn);

         arcCCDep:=BInv.FRCCDep;
         
         With MTExLocal^ do
         Begin
           If (BInv.CurrSettled>Round_Up(CurrencyOS(NInv,BOn,BOff,BOff),2)) then
             PayOwn:=CurrencyOS(NInv,BOn,BOff,BOff)
           else
             PayOwn:=BInv.CurrSettled;

           PayBase:=Round_up(Conv_TCurr(PayOwn,XRate(NInv.CXRate,BOff,NInv.Currency),NInv.Currency,0,BOff),2);

           LGetMainRec(CustF,NInv.CustCode);

           Gen_PayHed(NInv.TransDate,NInv.ACYr,NInv.ACPr,NInv.Currency,PayOwn,PayBase,0.0,0.0,0.0,arcOurRef,LCust.DefCtrlNom,arcSalesMode,0);

           RInv:=LInv;

           Gen_AutoPPYLine(BInv.BatchNom,arcOwnTransValue,NInv.Currency,BInv.DAddr[2],BInv.DAddr[1],IDetailF,IDFolioK);


           LStatus:=LAdd_Rec(Fnum,KeyPath);

           LReport_BError(Fnum,LStatus);

           If (Not Syss.UpBalOnPost) then
             LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOff,2);

           LInv:= NInv;


           If (BInv.CurrSettled=Round_Up(CurrencyOS(NInv,BOn,BOff,BOff),2)) then
           With LInv do
           Begin
             Settled:=0.0;

             Settled:=Round_Up(BaseTotalOS(LInv),2);

             CurrSettled:=0.0;

             CurrSettled:=CurrencyOS(LInv,BOn,BOff,BOff);
           end
           else
           With LInv do
           Begin
             If (Not RightSignDoc(LInv)) then {* v5.52 Its a negative transaction *}
             Begin
               PayBase:=PayBase*DocNotCnst;
               PayOwn:=PayOwn*DocNotCnst;
             end;

             Settled:=Settled+Round_Up(PayBase*DocCnst[BatchDocHed(arcSalesMode)]*DocCnst[InvDocHed]*DocNotCnst,2);

             CurrSettled:=CurrSettled+Round_up(PayOwn*DocCnst[BatchDocHed(arcSalesMode)]*DocCnst[InvDocHed]*DocNotCnst,2)
           end;

           Set_DocAlcStat(LInv);  {* Set Allocation Status *}

           Set_DocCISDate(LInv,BOff); {* Check CIS status *}

           {$IFDEF MC_On}
             LInv.RemitNo:=RInv.OurRef;

             LMatch_Payment(LInv,PayBase,PayOwn,3);

           {$ELSE}  {* Just in case AddNow causes problems on SC *}

             LMatch_Payment(LInv,PayBase,PayBase,3);

           {$ENDIF}

           NInv:=LInv;
         end;

       end;


       MTExLocal:=nil;
     end; {try..}
   Finally;
     Dispose(GenSRCObj,Destroy);
   end;
 end;


  { =========== Procedure to Create Certificed equivalent ?IN ========= }

 Procedure TPostJobApp.Post_JAPINDetails(BInv          :  InvRec;
                                     Var GotHed,
                                         RecoverMode   :  Boolean;
                                     Var NInv          :  InvRec;
                                  Const  TTEnabled     :  Boolean);


 Const
    Fnum     =  IDetailF;

    KeyPath  =  IdFolioK;

    Fnum2    =  InvF;

    LDAry    :  Array[0..2] of Str80 = ('Certificate for Application ','Less Deductions','Less Retentions');


  Var
    LoopCnt,
    UOR      :  Byte;

    LAnalCode:  Str10;

    KeyS,
    KeyI,
    KeyChk   :  Str255;

    JTAddr,
    JTLineNo,
    RecAddr  :  LongInt;

    LOk,
    GotLineAnal,
    SubConFlg,
    Locked,
    TmpBo,
    Abort    :  Boolean;

    UPNom,
    WOFFNom  :  LongInt;

    LineCost :  Real;

    UPVal    :  Double;

    DedCnst  :  Integer;

    RevRate  :  CurrTypes;

    TmpId    :  IDetail;

    LoopDFlg :  Array[0..2] of Boolean;

    { CJS 2013-06-04 - ABSEXCH-14150 - Duplicate line numbers on PINs created from JPAs }
    LineNumber: Integer;

  Procedure AddJAPINLine(LD     :  Str255;
                        DOnly  :  Boolean);
  var
    Key: Str255;
  Begin
    With MTExLocal^,LId do
    Begin
      { CJS 2013-06-04 - ABSEXCH-14150 - Duplicate line numbers on PINs created from JPAs }
      // Get the next line number
      LineNumber := NInv.ILineCount;
      // Check that it does not already exist against the new transaction.
      // (Note: we don't need to preserve/restore the current position in
      // the DETAIL table, because this is already done by the calling
      // routine).
      Key := FullIdKey(NInv.FolioNum, LineNumber);
      while (LFind_Rec(B_GetEq, Fnum, KeyPath, Key) = 0) do
      begin
        // The Line Number already exists, so increment it and try again.
        LineNumber := LineNumber + 2;
        Key        := FullIdKey(NInv.FolioNum, LineNumber);
      end;

      // Create and add a new Transaction Line
      LResetRec(IDetailF);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      IdDocHed:=LInv.InvDocHed;

      PDate:=LInv.TransDate;

      CustCode:=LInv.CustCode;

      { CJS 2013-06-04 - ABSEXCH-14150 - Duplicate line numbers on PINs created from JPAs }
      LineNo := LineNumber;

      ABSLineNo:=LineNo;

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=DocPayType[IdDocHed];

      PriceMulX:=1.0;

      AutoLineType:=TmpId.AutoLineType;

      {$IFDEF STK}

        LineType:=StkLineType[IdDocHed];

      {$ENDIF}


      If (Not DOnly) then
      Begin
        Qty:=1.0; QtyMul:=1.0;


        Desc:=TmpId.Desc;

        NetValue:=TmpId.NetValue*ComnU2.LineCnst(TmpId.Payment);


        VAT:=TmpId.VAT*ComnU2.LineCnst(TmpId.Payment);

        CCDep:=TmpId.CCDep;
        JobCode:=TmpId.JobCode;
        AnalCode:=TmpId.AnalCode;
        VATCode:=TmpId.VATCode;

        If (Not (AutoLineType In [2,3])) and (JobCode<>'') and (AnalCode<>'') then
          NomCode:=LJob_WIPNom(0,JobCode,AnalCode,'','',CustCode)
        else
          NomCode:=TmpId.NomCode;
      end
      else
        Desc:=LD;

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);


      If (LStatusOk) then
      Begin
        { CJS 2013-06-04 - ABSEXCH-14150 - Duplicate line numbers on PINs created from JPAs }
        LineNumber := LineNumber + 2;
        NInv.ILineCount := LineNumber;

        If (Not DOnly) then
          LUpdate_JobAct(LId,NInv);

      end;
    end;
  end;

  Begin {Main}
    With MTExLocal^ do
    Begin

      RecAddr:=0;

      Abort:=BOff;

      WOFFNom:=0;  UPNom:=0; UPVal:=0.0;

      LineCost:=0;  UOR:=0;  LoopCnt:=0;

      DedCnst:=1;  Locked:=BOff;

      JTAddr:=0; JTLineNo:=0;

      GotLineAnal:=BOff; LAnalCode:='';

      Blank(RevRate,Sizeof(RevRate));

      Blank(KeyI,Sizeof(KeyI));

      Blank(LoopDFlg,Sizeof(LoopDFlg));

      { CJS 2013-06-04 - ABSEXCH-14150 - Duplicate line numbers on PINs created from JPAs }
      LineNumber := 1;

      {If (Not jpAppCtrlRec.awConsolidate) then}
      GotHed:=BOff;

      {$B-}
        LOk:=(BInv.InvDocHed=JSA) or (LGetJobMisc(FullEmpCode(BInv.CISEmpl),3));
      {$B+}

      If (Not GotHed) and (LOk) then  {* Generate Nom Txfr Header *}
      Begin
        If (Not ADJPartPosted(BInv,LInv,Fnum,Keypath)) then
        Begin
          {Create hed moved to inside loop, so empty timesheets have no effect}

        end
        else
        Begin
          GotHed:=BOn;
          RecoverMode:=BOn;
        end;

        NInv:=LInv;

      end;



      KeyChk:=FullNomKey(Binv.FolioNum);

      KeyS:=FullIdKey(BInv.FolioNum,1);

      {* Get Employee Record *}



      Repeat

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With LId do
        Begin

          If (ThreadRec^.ThAbort) then
            ShowStatus(3,'Aborting...');

          If (B2BLink=0) or (B2BLink=FolioRef) then {* It has not already been posted, or we are genearting an uplift movement *}
          Begin
            {$B-}
            LOK:=(AutoLineType in [2,3]) or (LGetMainRec(JobF,JobCode));
            {$B+}

            If (Not GotHed) and (LOk) then {Create PIN header}
            Begin
              GotHed:=Get_AppInvHed(BInv,jpAppCtrlRec.awConsolidate,0,InvF,InvOurRefK,1,jpAppCtrlRec.awAddr);

              NInv:=LInv;

            end;


            {* Generate ?IN Lines *}

            If ((GotHed) and (LOk)) then
            Begin

              LStatus:=LGetPos(Fnum,RecAddr);

              If (AnalCode<>LJobMisc^.JobAnalRec.JAnalCode) and (Not (AutoLineType In [2,3])) then
                LGetJobMisc(AnalCode,2) {* Pick up Anal WIP Noms *}
              else
                LOk:=BOn;


              If (LOk) then
              With LId do
              Begin
                TmpId:=LId;

                LInv:=NInv;

                If (Not GotLineAnal) then
                Begin
                  GotLineAnal:=BOn;
                  LAnalCode:=AnalCode;
                end;

                If (Not LoopDFlg[LoopCnt]) then
                Begin
                  LoopDFlg[LoopCnt]:=BOn;

                  If (NInv.ILineCount>1) then
                    AddJAPINLine('',BOn);

                  KeyI:=LDAry[LoopCnt];

                  If (LoopCnt=0) then
                    KeyI:=KeyI+BInv.OurRef;

                  AddJAPINLine(KeyI,BOn);
                  AddJAPINLine(ConstStr('~',Length(KeyI)),BOn);

                end;

                AddJAPINLine('',BOff);


                If (TmpId.Reconcile=2) and (Round(TmpId.SSDSPUnit) In [0,1]) then {* Generate manual retention *}
                  LGenerate_AppRetention(1,TmpId,LInv,BInv,TmpId.JobCode,TmpID.AnalCode);

                If (TmpId.Reconcile=0) and (JTAddr=0) and (TmpId.SOPLink<>0) and (BInv.TransMode>1) then
                Begin
                  JTAddr:=TmpId.SOPLink;
                  JTLineNo:=TmpId.SOPLineNo;
                end;
              end;

              LSetDataRecOfs(Fnum,RecAddr);

              LStatus:=LGetDirect(Fnum,KeyPath,0);

              Begin

                LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyI,KeyPath,Fnum,BOn,Locked);

                If (LOk) and (Locked) then
                Begin
                  LGetRecAddr(Fnum);


                  B2BLink:=NInv.FolioNum;

                  LStatus:=LPut_Rec(Fnum,Keypath);

                  LReport_BError(Fnum,LStatus);

                  LStatus:=LUnLockMLock(Fnum);
                end;
              end;


              LUpdate_JobAct(LId,BInv);
            end;
          end; {If already posted..}

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);


        end; {While..}

        Inc(LoopCnt);

        Case LoopCnt of
          1  :   KeyChk:=FullIdKey(BInv.FolioNum,JALDedLineNo);
          2  :   KeyChk:=FullIdKey(BInv.FolioNum,JALRetLineNo);

        end; {Case..}

        KeyS:=KeyChk;

      Until (LoopCnt>2);



      If (GotHed) then
      With NInv do
      Begin
        RemitNo:=BInv.OurRef;

        MTExLocal^.LMatch_Payment(NInv,NInv.InvNetVal*DocCnst[InvDocHed]*DocNotCnst,NInv.InvNetVal*DocCnst[InvDocHed]*DocNotCnst,20);
        RemitNo:='';


        LSetDataRecOfs(Fnum2,jpAppCtrlRec.awAddr);

        LStatus:=LGetDirect(Fnum2,InvOurRefK,0);

        LGetRecAddr(Fnum2);


        LInv.CISTax:=NInv.CISTax;
        LInv.CISGross:=NInv.CISGross;

        LCalcInvTotals(LInv,MTExLocal,(Not LInv.ManVAT) or (jpAppCtrlRec.awConsolidate),BOn); {* Calculate Invoice Total *}

        If (GotLineAnal) then {* Set up legitamate anal code so header store validation does not complain *}
          LInv.DJobAnal:=LAnalCode;

        { CJS 2013-06-04 - ABSEXCH-14150 - Duplicate line numbers on PINs created from JPAs }
        LInv.ILineCount := LineNumber;

        LStatus:=LPut_Rec(Fnum2,InvOurRefK);

        //GS 23/11/2011 Audit History Notes
        //an audit note is created for the TX if the put_rec is successful
        if LStatus = 0 then
        begin
          TAuditNote.WriteAuditNote(anTransaction, anCreate, TdMTExLocalPtr(MTExLocal)^);
        end;

        LReport_BError(Fnum2,LStatus);

        If (LStatusOk) and (BInv.PORPickSOR) and (BInv.CurrSettled<>0.0) then {* It has a receipt side requiring creation and allocation *}
        Begin
          NInv:=LInv;

          Generate_JSAReceipt(BInv,NInv,Fnum2,InvOurRefK);

          LSetDataRecOfs(Fnum2,jpAppCtrlRec.awAddr);

          LStatus:=LGetDirect(Fnum2,InvOurRefK,0);

          LInv:=NInv;

          LStatus:=LPut_Rec(Fnum2,InvOurRefK);

          LReport_BError(Fnum2,LStatus);

        end;


        LStatus:=LUnLockMLock(Fnum2);

        If (BInv.AutoPost) then {* Defer the VAT *}
        Begin
          LGenerate_AppRetention(2,TmpId,LInv,BInv,BInv.DJobCode,'');
        end;

        If (JTAddr<>0) then {* Reflect the stage we have got to in the temeplete to prevent prior stage generation *}
        With LInv do
        Begin
          KeyI:=FullNomKey(JTAddr);


          Begin
            LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyI,InvFolioK,Fnum2,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum2);

              If (TransNat<BInv.TransMode) then
              Begin
                TransNat:=BInv.TransMode;

                LStatus:=LPut_Rec(Fnum2,InvOurRefK);

                LReport_BError(Fnum2,LStatus);
              end;

              LStatus:=LUnLockMLock(Fnum2);
            end; {If locked ok..}
          end; {If parent requires updating}
        end;
      end;
    end; {With..}

  end; {Proc..}

  Procedure TPostJobApp.Post_JAPBatch(Manual    :  Boolean;
                                  Var TTEnabled :  Boolean);

  Const
    Fnum    =  InvF;
    KeyPath =  InvRnoK;


  Var
    TTMsg    :  Str20;

    DocKey   :  Str255;

    JAPRunNo,
    AutoAddr :  LongInt;

    B_Func   :  Integer;

    NInv,
    SBInv    :  InvRec;

    Abort,
    LOk,
    Locked,
    GotSBill,
    ShouldGH,
    ShouldSB,
    RecoverMode,
    GotHed   :  Boolean;

    {$IFDEF FRM}
      FormRep    :  PFormRepPtr;
    {$ENDIF}




  Begin
    TTMsg:='';

    Abort:=BOff;

    B_Func:=B_GetNext;

    Addch:=ResetKey;

    Fillchar(DocKey,Sizeof(DocKey),0);

    GotHed:=BOff;  TTEnabled:=BOff;

    GotSBill:=BOff; ShouldGH:=BOff; ShouldSB:=BOff;  RecoverMode:=BOff;


    With MTExLocal^ do
    Begin

      ShowStatus(2,'Checking Applications');

      InitProgress(Used_RecsCId(LocalF^[InvF],InvF,ExCLientId));

      ItemCount:=0;  JAPRunNo:=Set_JAPRunNo(jpAppCtrlRec.awDT,BOff,BOff);

      With jpAppCtrlRec do
        If (awDT=JSA) then
          awCertDT:=SIN
        else
          awCertDT:=PIN;

      DocKey:=FullDayBkKey(JAPRunNo,FirstAddrD,DocCodes[jpAppCtrlRec.awDT])+NdxWeight;

      If (SPMode=50) then
        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,DocKey)
      else
      Begin
        DocKey:=jpAppCtrlRec.awDoc.OurRef;
        LStatus:=LFind_Rec(B_GetEq,Fnum,InvOurRefK,DocKey);
      end;

      While (LStatusOk) and (LInv.RunNo=JAPRunNo) and (Not Abort) and (Not ThreadRec^.THAbort) do
      With LInv do
      Begin

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        {$B-}

          With jpAppCtrlRec do
            If (InvDocHed In JAPJAPSplit) and (Include_TimeSheet) and (PDiscTaken)
            and ((Tagged=awTagNo) or (awTagNo=0))
            and (CheckKey(awECode,CISEmpl,Length(awECode),BOff))
            and (CheckKey(awACode,CustCode,Length(awACode),BOff)) then

        {$B+}

        Begin


          If (TranOk2Run) then
          Begin
            LStatus:=LCtrl_BTrans(1);

            TTEnabled:=LStatusOk;

            {* Wait until All clear b4 continuing *}
            If (TTEnabled) then
              WaitForHistLock;

          end;

          If (TTEnabled) then
            TTMsg:='. Protected Mode.';

          ShowStatus(2,'Processing '+OurRef+TTMsg);

          LStatus:=LGetPos(Fnum,AutoAddr);

          If (LStatusOk) then
          Begin

            Post_JAPINDetails(LInv,GotHed,RecoverMode,NInv,TTEnabled);

            If (Not ShouldGH) then
              ShouldGH:=GotHed;

            LSetDataRecOfs(Fnum,AutoAddr);

            LStatus:=LGetDirect(Fnum,KeyPath,0);

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOn,Locked);

            If (LOk) and (Locked) {and (GotHed or GotSBill)} then
            Begin
              LGetRecAddr(Fnum);

              RunNo:=Set_JAPRunNo(jpAppCtrlRec.awDT,BOff,BOn);

              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              If (Not AbortTran) then
                AbortTran:=(Not LStatusOk) and (TTEnabled);

              LStatus:=LUnLockMLock(Fnum);

              B_Func:=B_GetGEq;

            end
            else
              B_Func:=B_GetNext;

          end; {If Address found ok..}

          If (TTEnabled) and (Syss.ProtectPost) then
          With MTExLocal^ do
          Begin
            UnLockHistLock;

            If (Not AbortTran) then
              AbortTran:=((Not GotHed) and ShouldGH) or ((Not GotSBill) and ShouldSB);

            LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

            ThreadRec^.THAbort:=AbortTran;

            LReport_BError(InvF,LStatus);
          end;
        end {If Document ready to post..}
        else
        Begin
          B_Func:=B_GetNext;

          Abort:=(SuspendDoc(HoldFlg)); {*If Suspended, stop here *}
        end;



        If (SPMode=50) then
          LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,DocKey)
        else
          LStatus:=9;

      end; {While..}

      If (TranOk2Run) then
      Begin
        LStatus:=LCtrl_BTrans(1);

        TTEnabled:=LStatusOk;

        {* Wait until All clear b4 continuing *}
        If (TTEnabled) then
          WaitForHistLock;

      end;



      If (TTEnabled) and (Syss.ProtectPost) then
      With MTExLocal^ do
      Begin
        UnLockHistLock;

        LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

        LReport_BError(InvF,LStatus);
      end;

      If (ShouldGH) and (Not AbortTran) then {Calc all totals}
      With jpAppCtrlRec do
      Begin
        If (jpAppCtrlRec.awDT In JAPSalesSplit) then
          awPRun:=JAHideSRunNo
        else
          awPRun:=JAHidePRunNo;

        {$IFDEF FRM}
          New(FormRep);

          Blank(FormRep^,Sizeof(FormRep^));

          With FormRep^,PParam do
          Begin
            RForm:=SyssForms.FormDefs.PrimaryForm[47];

            If (RForm='') then
              RForm:=Self.DefForm;

            PDevRec.feBatch:=BOn;
            PBatch:=BOn;
          end;

          FormRep^.PParam.PDevRec:=Self.PDevRec;

          Start_JCJAThread(Application.MainForm,FormRep,jpAppCtrlRec);

          Dispose(FormRep);

      {$ENDIF}

        {LReveal_JAPIns(FullNomKey(awPRun),4,1,InvF,InvRNoK);}

      end;

      UpdateProgress(ThreadRec^.PTotal)

    end;


  end; {Proc..}


  Procedure TPostJobApp.Aggregate_JSALines(NInv  :  InvRec;
                                           LastYTDFolio
                                                 :  LongInt;
                                       Var Abort,
                                           TTEnabled
                                                 :  Boolean);

  Const
    Fnum     =  IdetailF;
    Keypath  =  IdFolioK;

  Var
    
    LoopCtrl :  Byte;

    B_Func   :  Integer;

    ILineAddr:  LongInt;

    KeyLS,
    KeyLChk  :  Str255;

    NDetail  :  Idetail;


  Function Process_Agg(IdR  :  IDetail)  :  Boolean;

  Var
    fp,lp     :  Byte;

    B_Func2   :  Integer;


    NLineAddr :  LongInt;

    KeyALS,
    KeyALChk  :  Str255;

  Begin
    Result:=BOff; fp:=0; lp:=0;

    With MTExLocal^ do
    Begin
      LStatus:=LGetPos(Fnum,ILineAddr);

      Case LoopCtrl of
        1  :  Begin
                KeyALChk:=FullNomKey(NInv.FolioNum);
                KeyALS:=FullIdKey(NInv.FolioNum,1);

              end;

        else  Begin
                KeyALChk:=FullIdKey(NInv.FolioNum,(LoopCtrl*-1));
                KeyALS:=KeyALChk;
              end;
      end; {Case..}

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyALS);

      While (LStatusOk) and (CheckKey(KeyALChk,KeyALS,Length(KeyALChk),BOn)) and (Not Abort) and (Not ThreadRec^.THAbort) and (Not Result) do
      With LId do
      Begin
        B_Func2:=B_GetNext;

        NDetail:=LId;

        LStatus:=LGetPos(Fnum,NLineAddr);

        If (CheckKey(JobCode,IdR.JobCode,Length(JobCode),BOff)) and (VATCode=IdR.VATCode)
          and (CheckKey(AnalCode,IdR.AnalCode,Length(AnalCode),BOff))
          and (CheckKey(CustCode,IdR.CustCode,Length(CustCode),BOff))
          and (CheckKey(CCDep[BOff],IdR.CCDep[BOff],Length(CCDep[BOff]),BOff))
          and (CheckKey(CCDep[BOn],IdR.CCDep[BOn],Length(CCDep[BOn]),BOff))
          and ((LoopCtrl=1) or ((LoopCtrl>1) and (Discount=IdR.Discount) and (DiscountChr=IdR.DiscountChr) and (JAPDedType=IdR.JAPDedType) and (COSNomCode=IdR.COSNomCode)))
            then

        Begin
          {If (IdR.FolioRef=LastYTDFolio) then {* Transfer the YTD as well *}
          {Begin
            QtyDel:=IdR.QtyDel;
            QtyPWOff:=IdR.QtyPWOff;

          end;}

          If (LoopCtrl=1) then
          Begin
            Qty:=Qty+IdR.Qty;
            CostPrice:=CostPrice+IdR.CostPrice;

          end;

          NetValue:=NetValue+IdR.NetValue;

          If (AutoLineType In [2,3]) then {* Its a CIS Line *}
          Begin
            fp:=pos('from',Desc);
            lp:=pos('liable',Desc);

            If (lp<>0) and (fp<>0) then
            Begin
              {Desc:=Copy(Desc,1,fp+3)+' '+Form_Real(NInv.CISGross,0,2)+' '+Copy(Desc,lp,Length(Desc)-lp);}

              Desc:=CCCISName^+' liability ';

            end;
          end;

          VAT:=VAT+IdR.VAT;

          If (LoopCtrl>1) then
          Begin
            SSDUplift:=SSDUplift+IdR.SSDUpLift;

          end;

          LStatus:=LPut_Rec(Fnum,Keypath);

          LReport_BError(Fnum,LStatus);

          If (LStatusOk) then
          Begin
            LUpdate_JobAct(LId,NInv);

            Result:=BOn;
          end;

        end;

        If (Not Result) then
          LStatus:=LFind_Rec(B_Func2,Fnum,KeyPath,KeyALS)

      end; {While..}


      If (Not Result) then
      Begin
        LId:=IdR;
        LId.FolioRef:=NInv.FolioNum;
        LID.DocPRef:=NInv.OurRef;

        If (LoopCtrl=1) then
        Begin
          LId.LineNo:=NInv.ILineCount;
          LId.ABSLineNo:=NInv.ILineCount;
          Inc(NInv.ILineCount);

        end;

        LStatus:=LAdd_Rec(Fnum,Keypath);

        LReport_BError(Fnum,LStatus);

        If (LStatusOk) then
        Begin
          LUpdate_JobAct(LId,NInv);
          Result:=BOn;
        end;
      end;

    end; {With..}
  end; {Func..}


  Begin {Main..}
    LoopCtrl:=1;

    With MTExLocal^ do
    Begin
      Repeat
        Case LoopCtrl of
          1  :  Begin
                  KeyLChk:=FullNomKey(LInv.FolioNum);
                  KeyLS:=FullIdKey(LInv.FolioNum,1);

                end;

          else  Begin
                  KeyLChk:=FullIdKey(LInv.FolioNum,(LoopCtrl*-1));
                  KeyLS:=KeyLChk;
                end;
        end; {Case..}

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyLS);

        While (LStatusOk) and (CheckKey(KeyLChk,KeyLS,Length(KeyLChk),BOn)) and (Not Abort) and (Not ThreadRec^.THAbort) do
        With LId do
        Begin
          B_Func:=B_GetNext;

          If (TranOk2Run) then
          Begin
            LStatus:=LCtrl_BTrans(1);

            TTEnabled:=LStatusOk;

            {* Wait until All clear b4 continuing *}
            If (TTEnabled) then
              WaitForHistLock;

          end;

          If (Process_Agg(LId)) then
          Begin
            LSetDataRecOfs(Fnum,ILineAddr);

            LStatus:=LGetDirect(Fnum,KeyPath,0);

            LDelete_JobAct(LId);

            LStatus:=LDelete_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);

            B_Func:=B_GetGEq;

          end
          else
            Abort:=BOn;


          If (TTEnabled) and (Syss.ProtectPost) then
          With MTExLocal^ do
          Begin
            UnLockHistLock;

            LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

            ThreadRec^.THAbort:=AbortTran;

            LReport_BError(InvF,LStatus);
          end;

          LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyLS);

        end;


        Inc(LoopCtrl);

      Until (Abort) or (ThreadRec^.THAbort) or (LoopCtrl>3);
    end; {With..}
  end;


  {* Proc to aggregate Tagged JSA's into one JSA *}

  Procedure TPostJobApp.Aggregate_TagJSAs(Var TTEnabled :  Boolean);

  Const
    Fnum    =  InvF;
    KeyPath =  InvRnoK;


  Var
    TTMsg    :  Str20;

    GenStr,
    DocKey   :  Str255;

    JAPRunNo,
    LastYTDFolio,
    NInvAddr,
    AutoAddr :  LongInt;

    B_Func   :  Integer;

    NInv,
    SBInv    :  InvRec;

    Abort,
    LOk,
    Locked,

    GotCtrlDoc,
    AddFirstLine,
    GotHed   :  Boolean;

    BaseCost :  Double;

    VS       :  VATType;

    {$IFDEF FRM}
      FormRep    :  PFormRepPtr;
    {$ENDIF}


   Function Include_Aggregate  :  Boolean;


   Var
     TInc         :  Boolean;


   Begin
     Result:=BOff;

     With MTExLocal^,LInv do
     Begin
       {$B-}

       TInc:=(CheckKey(NInv.DJobCode,DJobCode,Length(NInv.DJobCode),BOff));

       
       Result:=TInc;

       If (Not TInc) then
       Begin
         Write_PostLogDD(OurRef+' not aggregated with '+Trim(NInv.OurRef)+' due to Job Code '+Trim(DJobCode)+' not matching '+Trim(NInv.DJobCode),BOn,OurRef,0);

       end;

       TInc:=(NInv.TransMode=TransMode);

       Result:=(TInc and Result);

       If (Not TInc) then
       Begin
         Write_PostLogDD(OurRef+' not aggregated with '+Trim(NInv.OurRef)+' as it is a Practial or Final Application.',BOn,OurRef,0);


       end;

       TInc:=(CheckKey(NInv.DeliverRef,DeliverRef,Length(NInv.DeliverRef),BOff));

       Result:=(TInc and Result);

       If (Not TInc) then
       Begin
         Write_PostLogDD(OurRef+' not aggregated with '+Trim(NInv.OurRef)+' due to a mismatch of the source JST. '+Trim(DeliverRef)+' / '+Trim(NInv.DeliverRef),BOn,OurRef,0);

       end;

       TInc:=(CheckKey(NInv.CustCode,CustCode,Length(NInv.CustCode),BOff));

       Result:=(TInc and Result);

       If (Not TInc) then
       Begin
         Write_PostLogDD(OurRef+' not aggregated with '+Trim(NInv.OurRef)+' due to a mismatch of the Customer Code. '+Trim(CustCode)+' / '+Trim(NInv.CustCode),BOn,OurRef,0);

       end;


     end; {With..}

     {$B+}
   end;



  Begin
    TTMsg:='';

    Abort:=BOff;  AddFirstLine:=BOff;

    B_Func:=B_GetNext;

    Addch:=ResetKey;  BaseCost:=0.0;

    Fillchar(DocKey,Sizeof(DocKey),0);

    GotHed:=BOff;  TTEnabled:=BOff; GotCtrlDoc:=BOff;

    Fillchar(NInv,Sizeof(NInv),0);

    With MTExLocal^ do
    Begin

      ShowStatus(2,'Checking Applications');

      InitProgress(Used_RecsCId(LocalF^[InvF],InvF,ExCLientId));

      ItemCount:=0;  JAPRunNo:=Set_JAPRunNo(jpAppCtrlRec.awDT,BOff,BOff);

      DocKey:=FullDayBkKey(JAPRunNo,FirstAddrD,DocCodes[jpAppCtrlRec.awDT])+NdxWeight;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,DocKey);

      While (LStatusOk) and (LInv.RunNo=JAPRunNo) and (Not Abort) and (Not ThreadRec^.THAbort) do
      With LInv do
      Begin

        Inc(ItemCount);

        B_Func:=B_GetNext;

        UpdateProgress(ItemCount);

        {$B-}

          With jpAppCtrlRec do
            If (InvDocHed=awDT)
            and ((Tagged=awTagNo) and (awTagNo<>0))
            and ((Not GotCtrlDoc) or (Include_Aggregate)) then

        {$B+}

        Begin



          ShowStatus(2,'Processing '+OurRef+TTMsg);

          If (Not GotCtrlDoc) then
          Begin
            If (TransMode<2) then
            Begin

              LStatus:=LGetPos(Fnum,NInvAddr);


              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOn,Locked);

              GotCtrlDoc:=LOk and Locked;

              If (GotCtrlDoc) then
              Begin
                NInv:=LInv;
                BaseCost:=NInv.TotalCost;
                LastYTDFolio:=FolioNum;
              end;
            end
            else
              Write_PostLogDD(OurRef+' not aggregated as it is a Practial or Final Application.',BOn,OurRef,0);

          end
          else
          If (OurRef<>NInv.OurRef) then
          Begin
            LStatus:=LGetPos(Fnum,AutoAddr);

            If (LStatusOk) then
            Begin


              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOn,Locked);

              If (LOk) and (Locked) {and (GotHed or GotSBill)} then
              Begin
                LGetRecAddr(Fnum);

                NInv.CurrSettled:=NInv.CurrSettled+CurrSettled; {* Amalgamate parent *}

                If (FolioNum>LastYTDFolio) and (NInv.TransNat=2) then
                  NInv.TotalInvoiced:=TotalInvoiced {* Amalgamate Applied checksum *}
                else
                  NInv.TotalInvoiced:=NInv.TotalInvoiced+TotalInvoiced; {* Amalgamate Applied checksum *}

                If (NInv.ManVat) then
                Begin
                  For VS:=Low(VATType) to High(VATType) do
                    NInv.InvVatAnal[VS]:=NInv.InvVatAnal[VS]+InvVATAnal[VS];

                end;

                {If (FolioNum>LastYTDFolio) then
                Begin
                  NInv.TotalOrdered:=TotalOrdered;
                  NInv.PostDiscAm:=PostDiscAm;
                  NInv.TotOrdOS:=TotOrdOS;
                  NInv.TotalReserved:=TotalReserved;
                  LastYTDFolio:=FolioNum;
                end;}


                If (TTEnabled) then
                  TTMsg:='. Protected Mode.';

                Aggregate_JSALines(NInv,LastYTDFolio, Abort,TTEnabled);

                If (Not Abort) then
                Begin

                  {* Unlock New Doc *}
                  LStatus:=LUnLockMLock(Fnum);


                  If (TranOk2Run) then
                  Begin
                    LStatus:=LCtrl_BTrans(1);

                    TTEnabled:=LStatusOk;

                    {* Wait until All clear b4 continuing *}
                    If (TTEnabled) then
                      WaitForHistLock;

                  end;

                  LSetDataRecOfs(Fnum,AutoAddr);

                  LStatus:=LGetDirect(Fnum,KeyPath,0);

                  {* Re-lock under transaction as we will be deleting it *}

                  LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOn,Locked);


                  If (LOk) and (Locked) then
                  Begin
                    SBInv:=LInv;

                    LStatus:=LDelete_Rec(Fnum,Keypath);

                    LReport_BError(Fnum,LStatus);

                    If (LStatusOk) then
                      B_Func:=B_GetGEq;

                    LSetDataRecOfs(Fnum,NInvAddr);

                    LStatus:=LGetDirect(Fnum,KeyPath,0);

                    If (Not AddFirstLine) then
                    Begin
                      LAdd_Notes(NoteDCode,NoteCDCode,FullNomKey(NInv.FolioNum),Today,
                      NInv.OurRef+' (Orig. applied '+SSymb(NInv.Currency)+Form_Real(BaseCost,0,2)+') ',NInv.NLineCount);
                      AddFirstLine:=BOn;
                    end;

                    LAdd_Notes(NoteDCode,NoteCDCode,FullNomKey(NInv.FolioNum),Today,
                    SBInv.OurRef+' (applied '+SSymb(SBInv.Currency)+Form_Real(SBInv.TotalCost,0,2)+') aggregated into '+OurRef,NInv.NLineCount);

                    LInv:=NInv;

                    LStatus:=LPut_Rec(Fnum,Keypath);

                    LReport_BError(Fnum,LStatus);

                  end;

                  If (TTEnabled) and (Syss.ProtectPost) then
                  With MTExLocal^ do
                  Begin
                    UnLockHistLock;

                    LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                    ThreadRec^.THAbort:=AbortTran;

                    LReport_BError(InvF,LStatus);
                  end;

                  {* Delete notes - Keep these out of Btrv transaction or system will run out of locks *}
                  GenStr:=PartNoteKey(NoteTCode,NoteDCode,FullNCode(FullNomKey(SBInv.FolioNum)));

                  LDeleteLinks(GenStr,PWrdF,Length(GenStr),PWK,BOff);

                  LRemove_MatchPay(SBInv.OurRef,DocMatchTyp[BOn],MatchSCode,BOff); {* Delete matching *}


                  {* Delete Links *}

                  GenStr:=LetterTCode + LetterDocCode+FullNomKey(SBInv.FolioNum);

                  LDeleteLinks(GenStr,MiscF,Length(GenStr),MIK,BOff);

                end; {If Abort..}
              end
              else
                B_Func:=B_GetNext;

            end; {If Address found ok..}
          end;


        end {If Document  tagged and matches ..}
        else
        Begin
          B_Func:=B_GetNext;

          Abort:=(SuspendDoc(HoldFlg)); {*If Suspended, stop here *}
        end;

        LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,DocKey)

      end; {While..}

      If (GotCtrlDoc) then {* Recalculate it *}
      Begin
        If (TranOk2Run) then
        Begin
          LStatus:=LCtrl_BTrans(1);

          TTEnabled:=LStatusOk;

          {* Wait until All clear b4 continuing *}
          If (TTEnabled) then
            WaitForHistLock;

        end;

        {* Allocate new JSA number? &}

        LSetDataRecOfs(Fnum,NInvAddr);

        LStatus:=LGetDirect(Fnum,KeyPath,0);

        LInv:=NInv;

        LInv.Tagged:=0;
        
        LStatus:=LPut_Rec(Fnum,Keypath);

        LReport_BError(Fnum,LStatus);

        AssignToGlobal(InvF);

        If (TTEnabled) and (Syss.ProtectPost) then
        With MTExLocal^ do
        Begin
          UnLockHistLock;

          LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

          LReport_BError(InvF,LStatus);
        end;

        LastRecAddr[Fnum]:=NInvAddr;

        LStatus:=LUnLockMLock(Fnum);

        
        SendMessage(CallBackH,WM_FormCloseMsg,188,0);

      end;

      UpdateProgress(ThreadRec^.PTotal)

    end;

  end; {Proc..}



  Procedure TPostJobApp.Post_JAPSingle(Manual    :  Boolean;
                                   Var TTEnabled :  Boolean);

  Var
    Ok2Cont  :  Boolean;

  Begin
    With MTExLocal^ do
    Begin

       LInv:=jpAppCtrlRec.awDoc;

       Post_JAPBatch(BOff,Ok2Cont);

    end;
  end;


Function TPostJobApp.LGetJBudgetBudget(PJBudget  :  JobCtrlRec)  :  Double;

Var
  Profit,
  Sales,
  Purch,
  Bud1,
  Bud2,
  Cleared,

  Dnum,
  Dnum1,
  Dnum2,
  CommitVal  :  Double;

  TmpCtrl    :  JobCtrlRec;

Begin

  With MTExLocal^, PJBudget.JobBudg do
  Begin

    If (Not SyssJob^.JobSetUp.PeriodBud) then {* Replace period bud with anal bud *}
    Begin
      If (BRValue<>0.0) then
        Result:=BRValue
      else
        Result:=BOValue;

      {$IFDEF EX601}
        Result:=JBBCurrency_Txlate(Result,JBudgetCurr,0);
      {$ENDIF}
    end
    else
    Begin
      With LJobRec^ do
        Profit:=LTotal_Profit_To_Date(JobType,FullJDHistKey(JobCode,HistFolio),0,
                                      GetLocalPr(0).CYr,Syss.PrInYr,Purch,Sales,Cleared,Bud1,Bud2,Dnum1,Dnum2,BOn);
      If (Bud2<>0.0) then
        Result:=Bud2
      else
        Result:=Bud1;
    end;

    
  end; {With..}


end;

{== Scan & update lower level job budget lines with top level setting ==}

Procedure TPostJobApp.LApply_ValLowerDownBudget(PJBudget  :  JobCtrlRec);


Const
  Fnum     =  JCtrlF;
  Keypath  =  JCSecK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Loop,
  LOk        : Boolean;



Begin
  KeyS:=''; KeyChk:=''; Loop:=BOff;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=JBRCode+JBSubAry[6]+FullJBDDKey(LJobRec^.JobCode,PJBudget.JobBudg.AnalHed);
    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
    With LJobCtrl^,JobBudg do
    Begin
      JAPcntApp:=PJBudget.JobBudg.JAPcntApp;
      JABBAsis:=PJBudget.JobBudg.JABBasis;

      RevValuation:=NearestValue(DivWchk(JAPcntApp,100)*LGetJBudgetBudget(LJobCtrl^));

      LStatus:=LPut_Rec(Fnum,Keypath);

      LReport_BError(Fnum,LStatus);


      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


    end; {While//}

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
  end; {With..}
end;


{== Scan & update lower level job budget lines with top level setting ==}

Procedure TPostJobApp.LApply_ValLowerDownHed(PJBudget  :  JobCtrlRec);


Const
  Fnum     =  JCtrlF;
  Keypath  =  JCK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Loop,
  LOk        : Boolean;


Begin
  KeyS:=''; KeyChk:=''; Loop:=BOff;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=Strip('R',[#0],JBRCode+JBSubAry[5]+FullJBCode(LJobRec^.JobCode,0,FullNomKey(HFolio_Txlate(PJBudget.JobBudg.AnalHed))));
    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
    With LJobCtrl^,JobBudg do
    Begin
      JAPcntApp:=PJBudget.JobBudg.JAPcntApp;
      JABBAsis:=PJBudget.JobBudg.JABBasis;

      LStatus:=LPut_Rec(Fnum,Keypath);

      LReport_BError(Fnum,LStatus);

      LApply_ValLowerDownBudget(PJBudget);

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


    end; {While//}

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
  end; {With..}
end;


{== Scan all lower level job records with top level setting ==}

Procedure TPostJobApp.LHunt_LowerLevels(JobR      :  JobRecType;
                                        PJBudget  :  JobCtrlRec;
                                        Level     :  LongInt);


Const
  Fnum     =  JobF;
  Keypath  =  JobCatK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Loop,
  LOk        : Boolean;


Begin
  KeyS:=''; KeyChk:=''; Loop:=BOff;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin

    KeyChk:=FullJobCode(JobR.JobCode);
    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
    With LJobRec^ do
    Begin
      ShowStatus(2,'Processing '+dbFormatName(JobCode,JobDesc));

      LApply_ValLowerDownHed(PJBudget);

      If (JobType=JobGrpCode) then
      Begin
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        LHunt_LowerLevels(LJobRec^,PJBudget,Succ(Level));

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


    end; {While//}


  end; {With..}
end;

{== Return value based on rounding rules  ==}

Function TPostJobApp.NearestValue(Value   :  Double)  :  Double;

Begin
  With jpAppCtrlRec do
  Begin
    If (awIntReverse) then
      Result:=Round_Dn(Value,2)
    else
      Result:=Round_Up(Value,2);

    Case awTagNo of
      1  :  Result:=ForceNearestWhole(Result,2);
      2..4
         :  Result:=Round(Round_Up(DivWChk(Result,Power(10,awTagNo+1)),2)*Power(10,awTagNo+1));

    end; {Case..}

  end;
end;


{== Scan & update lower level job budget lines with top level setting ==}

Procedure TPostJobApp.LScan_ContractValuation;


Const
  Fnum     =  JCtrlF;
  Keypath  =  JCK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Loop,
  LOk        : Boolean;

  JobR       : JobRecType;


Begin
  KeyS:=''; KeyChk:=''; Loop:=BOff;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin
    If (LJobRec^.JobCode<>jpAppCtrlRec.awJobCode) then
      LOk:=LGetMainRecPos(JobF,jpAppCtrlRec.awJobCode)
    else
      LOk:=BOn;

    If (LOk) then
    Begin
      JobR:=LJobRec^;



      KeyChk:=Strip('R',[#0],JBRCode+JBSubAry[5]+FullJBCode(LJobRec^.JobCode,0,FullNomKey(HFolio_Txlate(1))));
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
      With LJobCtrl^,JobBudg do
      Begin

        If (JAPcntApp<>0.0) then
        Begin
          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          LHunt_LowerLevels(JobR,LJobCtrl^,0);

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


      end; {While//}


    end; {If Job FoundOk..}
  end; {With..}
end;


{== Work out pro-rata revenue type contribution ==}

Function TPostJobApp.LRev_Prorata(PJBudget  :  JobCtrlRec;
                                  RevType   :  Byte)  :  Double;


Const
  Fnum     =  JCtrlF;
  Keypath  =  JCSecK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Loop,
  LOk        : Boolean;

  TotBudget  :  Double;


Begin
  KeyS:=''; KeyChk:=''; Loop:=BOff;  TotBudget:=0.0;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=JBRCode+JBSubAry[6]+FullJBDDKey(LJobRec^.JobCode,1);
    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
    With LJobCtrl^,JobBudg do
    Begin
      If (LGetJobMisc(AnalCode,2)) then
      Begin
        If (LJobMisc^.JobAnalRec.RevenueType=RevType) then
        Begin
          TotBudget:=TotBudget+LGetJBudgetBudget(LJobCtrl^);
        end;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


    end; {While//}

    Result:=DivWChk(LGetJBudgetBudget(PJBudget),TotBudget);

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
  end; {With..}
end;


{== Scan all expenditure codes for matching types ==}

Procedure TPostJobApp.LScan_Expenditure(PJBudget  :  JobCtrlRec;
                                        RevType   :  Byte);


Const
  Fnum     =  JCtrlF;
  Keypath  =  JCK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Loop,
  LOk        : Boolean;

  Profit,
  Sales,
  Purch,
  Bud1,
  Bud2,
  Cleared,

  Dnum,
  Dnum1,
  Dnum2,
  CommitVal  :  Double;

  TotBudget  :  Double;


Begin
  KeyS:=''; KeyChk:=''; Loop:=BOff; TotBudget:=0.0; JACumAct:=0.0; JACumCnt:=0;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=JBRCode+JBSubAry[6]+FullJobCode(LJobRec^.JobCode);
    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
    With LJobCtrl^,JobBudg do
    Begin
      CommitVal:=0.0; Profit:=0.0;

      If (LGetJobMisc(AnalCode,2)) then
      Begin
        If (LJobMisc^.JobAnalRec.AnalHed=RevType) then
        Begin

          With LJobRec^ do
            If (jpAppCtrlRec.awValAct In [0,1]) then
              Profit:=LTotal_Profit_To_Date(JobType,FullJDHistKey(JobCode,HistFolio),0,
                                       GetLocalPr(0).CYr,Syss.PrinYr,Purch,Sales,Cleared,Bud1,Bud2,Dnum1,Dnum2,BOn);

          If (jpAppCtrlRec.awValAct In [1,2]) then
            With LJobRec^ do
              CommitVal:=LTotal_Profit_To_Date(CommitHCode,FullJDHistKey(JobCode,HistFolio),0,
                                     GetLocalPr(0).CYr,Syss.PrinYr,Purch,Sales,Cleared,Bud1,Bud2,Dnum1,Dnum2,BOn);

          TotBudget:=LGetJBudgetBudget(LJobCtrl^);

          DNum1:=DivWChk(Profit+CommitVal,TotBudget)*100;

          If (DNum1>0.0) then
          Begin
            JACumAct:=JACumAct+DNum1;

            Inc(JACumCnt);
          end;
        end;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


    end; {While//}

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
  end; {With..}
end;

{== For each revenue type find out expenditure completion  ==}

Procedure TPostJobApp.LGet_ValuationxExpenditure;


Const
  Fnum     =  JCtrlF;
  Keypath  =  JCSecK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Locked,
  LOk        : Boolean;

  TotBudget,
  GrossBudget,
  ThisRata  :  Double;


Begin
  KeyS:=''; KeyChk:=''; Locked:=BOff;  TotBudget:=0.0;  GrossBudget:=0.0;


  With MTExLocal^ do
  Begin
    Begin
      KeyChk:=JBRCode+JBSubAry[6]+FullJBDDKey(LJobRec^.JobCode,1);
      KeyS:=KeyChk;

      With LJobRec^ do
        ShowStatus(2,'Processing '+dbFormatName(JobCode,JobDesc));

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
      With LJobCtrl^,JobBudg do
      Begin
        If (LGetJobMisc(AnalCode,2)) then
        Begin
          LStatus:=LGetPos(Fnum,TmpRecAddr);

          n:=LJobMisc^.JobAnalRec.RevenueType;

          ThisRata:=LRev_Prorata(LJobCtrl^,n);

          LScan_Expenditure(LJobCtrl^,n);

          LSetDataRecOfs(Fnum,TmpRecAddr);

          LStatus:=LGetDirect(Fnum,KeyPath,0);


          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

          If (LOk) and (Locked) then
          Begin

            LGetRecAddr(Fnum);

            TotBudget:=LGetJBudgetBudget(LJobCtrl^);


            RevValuation:=NearestValue((DivWChk(DivWchk(JACumAct,JACumCnt)*ThisRata,100)*TotBudget)+GrossBudget);

            

            JAPCntApp:=Round_Up((DivWchk(JACumAct,JACumCnt)*ThisRata),2);

            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);

            LStatus:=LUnLockMLock(Fnum);
          end;



        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


      end; {While//}
    end; {IF found Job OK..}

  end; {With..}
end;

{== Scan all lower level job records with top level setting ==}

Procedure TPostJobApp.LHunt_ValuationExpenditure(JobC  :  Str10;
                                                 Level :  LongInt);


Const
  Fnum     =  JobF;
  Keypath  =  JobCatK;

Var
  n          : Byte;
  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;

  KeyChk,
  KeyS       : Str255;

  Loop,
  LOk        : Boolean;


Begin
  KeyS:=''; KeyChk:=''; Loop:=BOff;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin
    If (LJobRec^.JobCode<>JobC) then
      LOk:=LGetMainRecPos(JobF,JobC)
    else
      LOk:=BOn;


    If (LOK) and (LJobRec^.JobType=JobGrpCode) then
    Begin
      KeyChk:=FullJobCode(LJobRec^.JobCode);
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
      With LJobRec^ do
      Begin
        
        If (JobType=JobGrpCode) then
        Begin
          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          LHunt_ValuationExpenditure(JobCode,Succ(Level));

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
        end
        else
          LGet_ValuationxExpenditure;

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


      end; {While//}
    end
    else
      LGet_ValuationxExpenditure;


  end; {With..}
end;



{$IFDEF DBD}
  {== Scan all lower level job records with top level setting ==}

  Procedure TPostJobApp.Check_Run512(Level :  LongInt);


  Const
    Fnum     =  JDetlF;
    Keypath  =  JDPostedK;

  Var
    n          : Byte;
    TmpStat,
    TmpKPath   : Integer;
    TmpRecAddr : LongInt;

    KeyChk,
    KeyS       : Str255;

    Loop,
    LOk        : Boolean;


  Begin
    KeyS:=''; KeyChk:=''; Loop:=BOff;

    TmpKPath:=GetPosKey;

    With MTExLocal^ do
    Begin
      KeyChk:=PartCCKey(JBRCode,JBECode);

      KeyS:=KeyChk+#0#0#0#1;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) do
      With LJobDetl^.JobActual do
      Begin
        ShowStatus(2,'Processing '+Trim(JobCode)+', '+LineORef+'. '+Form_Int(PostedRun,0));

        If (LineORef='PIN010698') then
            MessageBeep(0);


        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);


      end; {While//}

      LStatus:=LFind_Rec(B_GetPrev,Fnum,keypath,KeyS);

      If (LStatus=9) then
      With LJobDetl^.JobActual do
        ShowStatus(2,'Processing '+Trim(JobCode)+', '+LineORef);

    end; {With..}
  end;



{$ENDIF}



{* Process modes:-
   50. Post all J?A's from relevent daybook
   51. Post single J?A from daybook using batch process
   52. Apply reveneue valuation % to lower levels from contract
   53. Apply Revenue valaution from expenditure
   54. Aggregate tagged JSA's
   99. Test Rig
*}

  Procedure TPostJobApp.Process;

  Var
    Ok2Cont  :  Boolean;

  Begin
    Inherited Process;

    If (SPMode In [50..54,99]) then
    With MTExLocal^ do
    Begin
      {*Update heading*}
      ShowStatus(0,'Post Certified Applications');

      Ok2Cont:=BOn;

      // CJS: 07/04/2011 ABSEXCH-10439
      InitProgress(100);
      UpdateProgress(0);
      
      If (Ok2Cont) then
      With LJobRec^ do
      Case SPMode of

        50
            :  Begin
                 ShowStatus(0,'Post Certified Applications');

                 Post_JAPBatch(BOff,Ok2Cont);
               end;
        51
            :  Begin
                 ShowStatus(0,'Post Certified Application');

                 Post_JAPSingle(BOff,Ok2Cont);
               end;

        52
            :  Begin
                 ShowStatus(0,'Apply Contract Valuation');

                 LScan_ContractValuation;

               end;

        53
            :  Begin
                 ShowStatus(0,'Calculate Valuation from Expenditure');

                 LHunt_ValuationExpenditure(jpAppCtrlRec.awJobCode,0);

               end;

        54
            :  Begin
                 ShowStatus(0,'Aggregate Tagged Apps');

                 Aggregate_TagJSAs(Ok2Cont);

               end;


        99
            :  Begin
                 ShowStatus(0,'Check posting run');

                 {$IFDEF DBD}
                   Check_Run512(511);


                 {$ENDIF}

               end;

      end; {Case..}

      UpdateProgress(ThreadRec^.PTotal);

    end;

    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) and (SPMode In [50,54]) then
          PostLog.PrintLog(PostRepCtrl,'Job Costing Posting run omissions and exception log. '+PoutDate(Today));

      {$ENDIF}
    {$ENDIF}



  end;


  Procedure TPostJobApp.Finish;

  Begin
    SendMessage(CallBackH,WM_FormCloseMsg,75,0);


    Inherited Finish;


  end;




{ ============== }

Procedure AddJobPostApp2Thread(AOwner   :  TObject;
                               SMode    :  Byte;
                               JCRPtr   :  tJAppWizRec;
                               MyHandle :  THandle);


  Var
    LCheck_Batch :  ^TPostJobApp;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          If (Start(SMode,MyHandle)) and (Create_BackThread) then
          Begin

            jpAppCtrlRec:=JCRPtr;

            With BackThread do
              AddTask(LCheck_Batch,'Job Applications');
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


  Procedure Post_SingleApp(InvR    :  InvRec;
                           DocHed  :  DocTypes;
                           Owner   :  TWinControl);

  var
    jpAppCtrlRec  :  tJAppWizRec;
  Begin
    With InvR do
    If (PDiscTaken) then
    Begin
      If (CustomDlg(Owner,'Please Confirm','Post Application',
                 'Please confirm you wish to post this Certifed Application',
                 mtConfirmation,
                 [mbOk,mbCancel])=mrOk) then
      With jpAppCtrlRec do
      Begin
        Blank(jpAppCtrlRec,Sizeof(jpAppCtrlRec));

        awDT:=DocHed;
        awDoc:=InvR;
        AddJobPostApp2Thread(Owner,51,jpAppCtrlRec,Owner.Handle);
      end;

    end
    else
      CustomDlg(Owner,'Please note!','Application not Certified',
                 'This Application is not Certified'+#13+#13+
                 ' Please Certify it and then attempt to post.',
                 mtInformation,
                 [mbOk]);

  end;



end.