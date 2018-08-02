Unit ConvDocU;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/01/96                      }
{                Covert/Copy/Reverse Document Unit             }
{                                                              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


{$I DEFOVR.Inc}

Interface

Uses
  GlobVar,
  VarConst,
  ExWrap1U;


{.$IFDEF SOP}

  { ========== Procedure to copy detail for Back to Back ========== }


  Procedure SetB2B_Copy(Var   Idr          : IDetail;
                        Var   InvR         : InvRec;
                              LCust        : CustRec;
                              B2BCtrl      : B2BInpRec;
                        Const B2BBuildMode : Boolean = False);

  Function B2bLine(IdR  :  IDetail;
                 Var LastS:  Boolean)  :  Boolean;




  Procedure SetInv_Copy(Var  InvR     :  InvRec;
                        Var  DocCnst  :  Integer;
                             Contra   :  Byte;
                             CCode    :  Str10;
                             B2BAPick :  Boolean;
                             UseSupplierDeliveryAddress: Boolean = False);
{.$ENDIF}


Procedure ContraCopy_Doc(DocFolio  :  LongInt;
                         ContraM   :  Byte;
                         SupCode   :  Str10);


Function Quo_To_Inv(Fnum,KeyPath  :  Integer;
                    ConvMode      :  Byte;
                    ExLocalPtr    :  TdExLocalPtr = nil)  :  Boolean;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Windows,
   Forms,
   Dialogs,
   ETMiscU,
   ETStrU,
   ETDateU,
   BtrvU2,
   VarJCstU,
   ComnUnit,
   ComnU2,
   CurrncyU,

   InvListU,
   {$IFDEF STK}

     InvCTSuU,

     {$IFDEF Pf_On}
       CuStkA3U,

     {$ENDIF}

   {$ENDIF}

   {$IFDEF SOP}

     InvCt2Su,

     MiscU,

     DiscU3U,

     InvFSU2U,

     {$IFNDEF SOPDLL}
     SalTxl2U,

     LedgSupU,
     {$ENDIF}
     StkRORdR,
     PayF2U,
     PWarnU,

     {$IFNDEF EXDLL}
       SOPCt4U,
     {$ENDIF}
   {$ELSE}
     {$IFDEF SOPDLL}
     InvFSU2U,
     StkRORdR,
     MiscU,
     {$ENDIF}
   {$ENDIF}

   {$IFDEF PF_On}

     InvLSt2U,


   {$ENDIF}

   {$IFNDEF SOPDLL}
   SalTxl1U,
   {$ELSE}
   SpDllSup,
   BTS1,
   {$ENDIF}
   NoteSupU,

   BTSupU1,
   BTSupU2,
   BTKeys1U,
   Event1U,
   SysU1,
   SysU2,
   GenWarnU,
   
  {$IFDEF SY}
    AUWarnU,
  {$ENDIF}


   {$IFDEF Ltr}
     LettrDlg,
   {$ENDIF}


  //PR: 04/11/2011 v6.9
  {$IFDEF SOPDLL}
  AuditNotes,
  AuditNoteIntf,
  {$ENDIF}

   SysU3,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  // MH 10/06/2015 v7.0.14 ABSEXCH-16518: Reset PPD Flags for Copied and Reversed transactions
  PromptPaymentDiscountFuncs,


  //PR: 02/03/2015  ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU;




Const

  NofContras =  14;

  ConvTable  :  Array[BOff..BOn,1..NofContras] of DocTypes =

                ((SIN,SRC,SRI,SJI,SQU,SOR,SDN,PIN,PPY,PPI,PJI,POR,PDN,NMT),
                 (SCR,SRC,SRF,SJC,SQU,SOR,SDN,PCR,PPY,PRF,PJC,POR,PDN,NMT));


{ == Function to check if sufficient stock exists for a quote conversion, or copy/reverse == }

{$IFDEF SOPDLL}
  {$UNDEF EXDLL}
{$ENDIF}


{$IFDEF STK}
  {$IFNDEF  EXDLL}

  Function Check_EnoughStk(OpoMode  :  SmallInt;
                           LInv     :  InvRec;
                           Ignore   :  Boolean)  :  Boolean;


  Const
    Fnum     = IdetailF;
    Keypath  = IdFolioK;


  Var
    KeyS,KeyChk  :  Str255;
    ChkDoc       :  DocTypes;


  Begin
    
    ChkDoc:=SIN;

    Result:=(Not CheckNegStk) or (Not Syss.UseStock) or
            (Not (LInv.InvdocHed In StkInSet+StkOutSet+StkAdjSplit+QuotesSet+StkRetPurchSplit)) or (Ignore);

    If (Not Result) then
    Begin
      KeyChk:=FullNomKey(LInv.FolioNum);
      KeyS:=FullIdKey(LInv.FolioNum,1);

      If (LInv.InvDocHed In StkAdjSplit) then
        OpoMode:=OpoMode*-1;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Result) do
      With Id do
      Begin
        If (Is_FullStkCode(StockCode)) and (Qty<>0) then
        Begin
          If (Stock.StockCode<>StockCode) then
            Global_GetMainRec(StockF,StockCode);

          If (LInv.InvDocHed<>PQU) or (Qty<0) then {We have to force the transaction type into Check_StockCtrl as this routine is called by quotes}
            ChkDoc:=SIN
          else
            ChkDoc:=PIN;

          If ((IdDocHed=ADJ) and ((Qty<0) or (KitLink=1) or (Stock.StockType<>StkBillCode))) or (IdDocHed<>ADJ) then
            Check_StockCtrl(StockCode,(Qty*QtyMul)*OpoMode,
                            2+Ord(IdDocHed=ADJ),Result,ChkDoc,Id,
                            {$IFNDEF SOPDLL}
                            Application.MainForm.Handle
                            {$ELSE}
                            0
                            {$ENDIF}
                            );

        end;

        If (Not Result) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end;

      Result:=Not Result;
    end;

  end;

  {$ENDIF}
{$ENDIF}


{ ============= Function to Determine equivalent Document Number ============= }

Function ContraDocHed(Contra      :  Byte;
                      InvRDocHed  :  DocTypes;
                  Var DocCnst     :  Integer)  :  DocTypes;


Var
  TBo,
  FoundOk   :   Boolean;
  TDocHed   :   DocTypes;
  n         :   Byte;



Begin
  FoundOk:=BOff;

  TDocHed:=InvRDocHed;

  n:=1;

  DocCnst:=n;

  TBo:=BOn;

  Case Contra of

    2,4
       :  Begin
            Repeat

              n:=1;

              TBo:=Not TBo;

              While (Not FoundOk) and (n<=NofContras) do
              Begin
                FoundOk:=(InvRDocHed=ConvTable[TBo,n]);

                If (Not FoundOk) then
                  Inc(n);
              end;

            Until (TBo) or (FoundOk);

            If (FoundOk) then
              TDocHed:=ConvTable[Not Tbo,n]
            else
              TDocHed:=InvRDocHed;

            If (TDocHed=InvRDocHed) then  {* Set all values to Contra *}
              DocCnst:=-1;

          end;

    3  :  Begin

            If (InvRDocHed In [SOR,WOR]) then
              TDocHed:=POR
            else
              TDocHed:=SOR;

          end;
  end; {Case..}




  ContraDocHed:=TDocHed;
end; {Func..}



{ ========== Procedure to Set The Inv Part of a Copy ========== }

// CJS 2014-07-07 - ABSEXCH-2925 - delivery address on back to back orders -
//                  added UseSuppliedDeliveryAddress parameter
Procedure SetInv_Copy(Var  InvR     :  InvRec;
                      Var  DocCnst  :  Integer;
                           Contra   :  Byte;
                           CCode    :  Str10;
                           B2BAPick :  Boolean;
                           UseSupplierDeliveryAddress: Boolean = False);

Var
  VLoop    :  VATType;

  FoundCode:  Str20;

  OldORef  :  Str10;

  LOk      :  Boolean;

  //------------------------------
{$IFNDEF SOPDLL}
  Function CheckForVAT (Const InvR : InvRec) : Boolean;
  Var
    sKey : Str255;
    iStatus : SmallInt;
    iVATCode : VATType;
  Begin // CheckForVAT
    Result := False;

    // Run through VAT Analysis array to detect VAT in use
    For iVATCode := Low(VATType) To High(VATType) Do
    Begin
      Result := InvR.InvVATAnal[iVATCode] <> 0.0;
      If Result Then
        Break;
    End; // For iVATCode

    If (Not Result) Then
      // Run through the lines and check we done have two+ VAT Lines that nett out to 0.0
      With TBtrieveSavePosition.Create Do
      Begin
        Try
          // Save the current position in the file for the current key
          SaveFilePosition (IDetailF, GetPosKey);
          SaveDataBlock (@Id, SizeOf(Id));

          //------------------------------

          sKey := FullNomKey(InvR.FolioNum);
          iStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
          While (iStatus = 0) And (Id.FolioRef = InvR.FolioNum) And (Not Result) Do
          Begin
            Result := (Id.NOMIOFlg <> 0) Or (Id.VAT <> 0.0);

            iStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
          End; // While (iStatus = 0) And (Id.FolioRef = InvR.FolioNum) And (Not Result)

          //------------------------------

          // Restore position in file
          RestoreDataBlock (@Id);
          RestoreSavedPosition;
        Finally
          Free;
        End; // Try..Finally
      End; // With TBtrieveSavePosition.Create
  End; // CheckForVAT

{$ENDIF not SOFDLL}
  //------------------------------

Begin
//PR: 04/02/2016 v2016 R1 ABSEXCH-17212 Toolkit needs this function for Back2Back orders
{.$IFNDEF SOPDLL}

  With InvR do
  Begin

    OldORef:=OurRef;

    LOk:=BOff;

    InvDocHed:=ContraDocHed(Contra,InvDocHed,DocCnst);

    If (Not (InvDocHed In DirectSet+NomSplit)) then  {* Zero Co.Rate & Reset Ex Rate*}
    Begin
      CXrate:=SyssCurr.Currencies[Currency].CRates;

      CXrate[BOff]:=0;

      VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;


      {* Preserve original Co. Rate *}

      OrigRates:=SyssCurr.Currencies[Currency].CRates;

      UseORate:=0;

      SetTriRec(Currency,UseORate,CurrTriR);
      SetTriRec(Syss.VATCurr,UseORate,VATTriR);
      SetTriRec(Currency,UseORate,OrigTriR);

    end;

    FillChar(VATPostDate,Sizeof(VATPostDate),0);
    FillChar(PostDate,Sizeof(PostDate),0);
    FillChar(OldORates,Sizeof(OldORates),0);

    SettledVAT:=0;
    VATClaimed:=0;

    LastLetter:=0;

    {* Set intrastat details *}

    If (Not JBFieldOn) then
    Begin
      TransNat:=SetTransNat(InvDocHed);
    end;

    If (InvDocHed In CISDocSet) then
    Begin
      CISDeclared:=0.0;

      Blank(CISDate,Sizeof(CISDate));
    end;

    If (Contra=3) then  {* Force unposted POR thru *}
      RunNo:=OrdUPRunNo
    else
      If (Contra=4) then
      Begin
        RunNo:=AutoRunNo;
        NomAuto:=BOff;
      end;

    If (Not (InvDocHed In DirectSet+NomSplit)) then
    Begin

      Settled:=0;

      CurrSettled:=0;

      Variance:=Variance*DocCnst;

      PostDiscAm:=PostDiscAm*DocCnst; {V4.40. Reverse this so that any set disc taken is also nullified}

      DiscSetl:=DiscSetl*DocCnst;  {V4.40. Reverse this so that any set disc taken is also nullified}

      Set_DocAlcStat(Inv);  {* Set Allocation Status *}

    end
    else
    Begin

      // MH 06/07/2009: 20080129143539
      // For Copied or Reversed NOM's under cash accounting check whether the VATPostDate should
      // be set - run through lines and check for VAT usage - we can't use the VAT Total as we
      // also need to detect VAT on lines that may reverse out each other giving a nett of 0.0

      //PR: 04/02/2016 v2016 R1 ABSEXCH-17212
      {$IFNDEF SOPDLL}
      If (Contra In [1, 2]) And (InvR.InvDocHed = NMT) And VAT_CashAcc(SyssVAT.VATRates.VATScheme) And (InvR.NomAuto) And CheckForVAT(InvR) Then
      Begin
        VATPostDate:=CalcVATDate(TransDate);
      End; // If (Contra In [1, 2]) And (InvR.InvDocHed = NMT) And VAT_CashAcc(SyssVAT.VATRates.VATScheme) And (InvR.NomAuto) And CheckForVAT(InvR)
      {$ENDIF not SOPDLL}

      If (InvDocHed In DirectSet) and
         (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) and
         (RunNo<>AutoRunNo) then  {* Cash Accounting set VATdate to Current VATPeriod
                             Genuine Direct Docs Only *}
      Begin

        // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

        VATPostDate:=CalcVATDate(TransDate);  {v5.71. CA Allows jump to future period, set from self as self balancing receipt}

        UntilDate:=Today;

      end;


      If (Contra In [2,4]) then
      Begin
        Settled:=Settled*DocNotCnst;

        CurrSettled:=CurrSettled*DocNotCnst;

        Variance:=Variance*DocNotCnst;

        PostDiscAm:=PostDiscAm*DocNotCnst; {V4.40. Reverse this so that any set disc taken is also nullified}

        DiscSetl:=DiscSetl*DocNotCnst;  {V4.40. Reverse this so that any set disc taken is also nullified}
      end;

    end;


    ReValueAdj:=0;
    PrePostFlg:=0;

    If (RunNo<>AutoRunNo) then {* Normal Daybook or posted item or Belongs to Batch *}
    Begin
      {$IFDEF SOP}

        {* Check for posted SOP Items *}

        If ((RunNo=OrdPSRunNo) or (RunNo=OrdPPRunNo)) then
          RunNo:=RunNo+2
        else

      {$ENDIF}

      {$IFDEF WOP}
          If  (RunNo=WORPPRunNo) then
            RunNo:=RunNo+2
          else

      {$ENDIF}

      {$IFDEF RET}
          If  (RunNo=SRNPRunNo) or (RunNo=PRNPRunNo) then
            RunNo:=RunNo+1
          else

      {$ENDIF}

        If ((RunNo>0) or (InvDocHed In [TSH,Adj])) then
          RunNo:=0;

      SetNextDocNos(InvR,BOn);
    end
    else  {* Auto Item...}
    Begin
      SetNextAutoDocNos(Inv,BOn);
    end;

    // MH 10/06/2015 v7.0.14 ABSEXCH-16518: Reset PPD Flags for Copied and Reversed transactions
    If (Contra = 1 {Copy}) Or (Contra = 2 {Reverse}) Then
    Begin
      // Check if the transaction being created is of a type that can have PPD fields set, e.g. a
      // SIN being Copy-Reversed will create an SCR which should not have the fields set, but the
      // SIN can
      If (Not (Inv.InvDocHed In PPDTransactions)) Then
      Begin
        // Nope - zero down the PPD Value fields
        thPPDPercentage := 0.0;
        thPPDDays       := 0;
        thPPDGoodsValue := 0.0;
        thPPDVATValue   := 0.0;
      End; // If (Not (Inv.InvDocHed In PPDTransactions))

      thPPDTaken := ptPPDNotTaken;
      thPPDCreditNote := False;
      thBatchPayPPDStatus := 0;
    End; // If (Contra = 1 {Copy}) Or (Contra = 2 {Reverse})

    If (Not (Contra In [2,4])) and (InvDocHed In OrderSet) and (HoldFlg AND HoldNotes=HoldNotes) then
      HoldFlg:=HoldNotes
    else
      HoldFlg:=0;

    {$IFDEF STK}

      If (InvDocHed In OrderSet) then  {* Reset Delivery Order *}
        BatchLink:=QUO_DelDate(InvDocHed,DueDate);

    {$ENDIF}

    {$IFDEF SOPDLL}
      {$DEFINE SOP}
    {$ENDIF}

    {$IFDEF SOP}

      If (Contra=3) then {* Set POR details from SOR details *}
      Begin

        TransDesc:=YourRef;
        YourRef:=OldORef;
        CustCode:=CCode;

        PORPickSOR:=B2BAPick;

        ILineCount:=1;

        TransDate:=Today;
        DueDate:=Today;

        If (CCode<>Cust.CustCode) then
          LOk:=GetCust(Application.MainForm,CCode,FoundCode,BOff,-1)
        else
          LOk:=BOn;

        If (LOk)  then
        Begin
          // CJS 2014-07-07 - ABSEXCH-2925 - delivery address on back to back orders
          If (DAddr[1]='') or UseSupplierDeliveryAddress then {*EN421 so any delivery address can be carried accross *}
          Begin
            DAddr:=Cust.DAddr;
            // MH 25/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Code support
            thDeliveryCountry := Cust.acDeliveryCountry;
            thDeliveryPostCode := Cust.acDeliveryPostCode  // This appears to be missing
          End; // If (DAddr[1]='') or UseSupplierDeliveryAddress

          CtrlNom:=Cust.DefCtrlNom;

          //PR: 02/03/2015  ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
          if TransactionHelper(@InvR).SettlementDiscountSupported then
          begin
            DiscSetl:=Pcnt(Cust.DefSetDisc);
            DiscDays:=Cust.DefSetDDays;

            //PR 26/03/2015 v7.0.14 ABSEXCH-16284: Added support for PPD
            thPPDPercentage := 0.0;
            thPPDDays       := 0;
          end // if TransactionHelper(InvR).SettlementDiscountSupported
          else
          begin
            DiscSetl:=0.0;
            DiscDays:=0;

            //PR 26/03/2015 v7.0.14 ABSEXCH-16284: Added support for PPD
            thPPDPercentage := Pcnt(Cust.DefSetDisc);
            thPPDDays       := Cust.DefSetDDays;
          end;

          {$IFDEF SOP}
            DelTerms:=Cust.SSDDelTerms;
            TransMode:=Cust.SSDModeTr;

          {$ENDIF}

          If (Cust.DefTagNo>0) then
            Tagged:=Cust.DefTagNo;

          {$IFDEF MC_On}

            If (Currency<>Cust.Currency) then
            Begin
              Currency:=Cust.Currency;

              CXRate:=SyssCurr^.Currencies[Currency].CRates;

              CXRate[BOff]:=0;

              VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;

              {* Preserve original Co. Rate *}

              OrigRates:=SyssCurr^.Currencies[Currency].CRates;

              UseORate:=0;

              SetTriRec(Currency,UseORate,CurrTriR);
              SetTriRec(Syss.VATCurr,UseORate,VATTriR);
              SetTriRec(Currency,UseORate,OrigTriR);

            end;

          {$ENDIF}
        end;


        CustSupp:=Chr(Succ(Ord(TradeCode[BOff])));

      end;

    {$ENDIF}

    {$IFDEF SOPDLL}
      {$UNDEF SOP}
    {$ENDIF}

    If (Contra=4) then {* It is an auto reversing item, so set period +1 }
    Begin
      AdjPr(AcYr,AcPr,BOn);

      TransDesc:=TransDesc+'. Auto Reverse';

      AutoIncBy:=PeriodInc;

      AutoInc:=1;

      UntilDate:=MaxUntilDate;

      UnYr:=AcYr;

      UnPr:=AcPr;

      AutoPost:=BOn;
    end;

    // MH 12/11/2014 Order Payments: Reset Order Payments fields on Copy/Reverse
    // MH 21/01/2015 v7.1 ABSEXCH-16056: Reset Order Payments fields on Back-to-Back POR
    If (Contra In [1 {Copy}, 2 {Reverse}, 3 {Back-to-Back POR}]) Then
    Begin
      thOrderPaymentOrderRef := '';
      // MH 11/02/2015 v7.1 ABSEXCH-16152: Re-instate ability for copied SORs to take their own payments
      If (Contra <> 1 {Copy}) Or (thOrderPaymentElement <> opeOrder) Then
        thOrderPaymentElement := opeNA;
      thOrderPaymentFlags := 0;
      thCreditCardType := '';
      thCreditCardNumber := '';
      thCreditCardExpiry := '';
      thCreditCardAuthorisationNo := '';
      thCreditCardReferenceNo := '';
    End; // If (Contra In [1 {Copy}, 2 {Reverse}])

    OpName:=EntryRec^.LogIn;

    { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
    TransactionOriginator.SetOriginator(InvR);

    FillChar(RemitNo,Sizeof(RemitNo),0);

    AuditFlg:=BOff;

    PrintedDoc:=BOff;

    ExternalDoc:=BOff;

    OrdMatch:=BOff;

    FillChar(DeliverRef,Sizeof(DeliverRef),0);

    { ========== Financial Contra =========== }

    InvNetVal:=InvNetVal*DocCnst;

    InvVAT:=InvVAT*DocCnst;

    For VLoop:=VStart to VEnd do
      InvVATAnal[VLoop]:=InvVATAnal[VLoop]*DocCnst;

      If (Not (InvDocHed In JAPSplit)) then
        PDiscTaken:=BOff;

    DiscSetAm:=DiscSetAm*DocCnst;

    DiscAmount:=DiscAmount*DocCnst;

    TotalOrdered:=TotalOrdered*DocCnst;

    CISGross:=CISGross*DocCnst;
    CISTax:=CISTax*DocCnst;

    {$IFDEF WOP}
      If (InvDocHed In WOPSplit) then {Reset delivered and issued so far}
      Begin
        TotalReserved:=0.0;

        TotalInvoiced:=0.0;
      end
      else
    {$ENDIF}

    {$IFDEF RET}
      If (InvDocHed In StkRetSplit) then {Reset delivered and issued so far}
      Begin
        TransMode:=0;

        Blank(DocLSplit,Sizeof(DocLSplit));
      end
      else
    {$ENDIF}

    {$IFDEF JAP}
      If (InvDocHed In JAPSplit) then {Reset YTD. No keep as is so true copy/reverse}
      Begin
        TotalReserved:=TotalReserved*DocCnst;
        TotalInvoiced:=TotalInvoiced*DocCnst;
        BDiscount:=BDiscount*DocCnst;

        TotOrdOS:=TotOrdOS*DocCnst;

        RunNo:=Set_JAPRunNo(InvDocHed,Not NomAuto,BOff);

      end
      else
    {$ENDIF}

    Begin
      TotalReserved:=TotalReserved*DocCnst;

      TotalInvoiced:=TotalInvoiced*DocCnst;
    end;

    TotalCost:=TotalCost*DocCnst;

    AuthAmnt:=ConvCurrITotal(InvR,BOff,BOn,BOn); {Record prev total in base for subsequent authorisation comparison}

    {$IFDEF SOP}
      If (InvDocHed In OrderSet) then
        TotOrdOS:=InvNetVal-DiscAmount;

      If (InvDocHed=ADJ) and (DelTerms<>'') and (Contra=2) then {A loc transfer must revert to a normal adj upon reversal}
        Blank(DelTerms,Sizeof(Delterms));
    {$ENDIF}

  end; {With..}
//PR: 04/02/2016 v2016 R1 ABSEXCH-17212 Comment out ifdef
{.$ENDIF not SOFDLL}

end;



{ ========== Procedure to copy detail Line  ========== }


Procedure SetId_Copy(Var  Idr     :  IDetail;
                          InvR    :  InvRec;
                          DocCnst :  Integer;
                          ContraM :  Byte;
                     Var  WarnJC  :  Boolean);

Var
  StkDedMode :  Byte;
  Foundcode  :  Str10;
  SuggNomCode:  LongInt;
  TmpInv     :  InvRec;
  TmpId      :  IDetail;

Begin
  With Idr do
  Begin

    TmpInv:=Inv;
    TmpId:=Id;

    StkDedMode:=2;

    FolioRef:=InvR.FolioNum;

    DocPRef:=InvR.OurRef;

    If (InvR.RunNo>=0)
    and (Not (IdDocHed In StkAdjSplit)) then    {* Auto Items & Stk Adj Run No. do
                                                   Not match Lines kept at 0/ unchanged to stop appearing on Nom *}
      PostedRun:=InvR.RunNo;

    IdDocHed:=InvR.InvDocHed;

    PreviousBal:=0;

    {* Do NOT reset currency on Variance Lines, or Nom Txfr lines, as these have their own
       independant currency *}

    If (NomCode<>Syss.NomCtrlCodes[CurrVar]) and (Not (IdDocHed In NomSplit)) then
    Begin
      CXRate:=InvR.CXRate;
      CurrTriR:=InvR.CurrTriR;

      UseORate:=0;
    end;



    If (IS_PayInLine(StockCode)) then {* Destroy paying in ref *}
      FillChar(StockCode,Sizeof(StockCode),0);


    {$IFDEF STK}

      {* If Order then we need to redeuct Qty_OS stock not DeductQty stock, as this could well be 0 *}

      If (IdDocHed In OrderSet) then
        StkDedMode:=0;

      {* If stock deduct, and reversing same doc type, then qty must be reveresed *}

      If ((DeductQty<>0) and (Is_FullStkCode(StockCode))) or (IdDocHed In [TSH,WOR]+OrderSet) then
      Begin
        DeductQty:=DeductQty*DocCnst;
        Qty:=Qty*DocCnst;
      end
      else
      Begin
        NetValue:=NetValue*DocCnst;

        If (IdDocHed=ADJ) and (Is_FullStkCode(StockCode)) then
          Qty:=Qty*DocCnst;

        If (IdDocHed In JAPSplit) then
        Begin
          CostPrice:=CostPrice*DocCnst;
          Qty:=Qty*DocCnst;
        end;

      end;

      If (Not (IdDocHed In JAPSplit)) then
      Begin
        QtyDel:=0;
        QtyWOff:=0;

        If (Not (IdDocHed In DeliverSet)) then {* Leave these on deliveries, as otherwise they will not get invoiced *}
        Begin
          QtyPick:=0;

          If (Not (IdDocHed In WOPSplit)) then
            QtyPWoff:=0
          else
          Begin
            SSDUplift:=0.0; {Reset could build figure}
            QtyPWoff:=QtyPWOff*DocCnst;
          end;

          {$IFDEF RET}
          If ((IdDocHed In StkRetSplit)) then
          Begin
            SSDUplift:=0.0;
            QtyPick:=Qty;  {* Not if serial no or bin perhaps? }
            Qty:=0.0;
            PreviousBal:=0.0;
          end;
          {$ENDIF}
        end;

      If (LineNo<>StkLineNo)  then {* Preserve these on reverse stk deduct lines *}
      
      Begin
        SOPLink:=0;
        SOPLineNo:=0;
        B2BLineNo:=0;
        B2BLink:=0;
      end
      else
        If (IdDocHed=ADJ) then {v5.01, reset on adj as otherwise posting rotuine thinks it has been part posted
                                as this links to Nom folio}
          B2BLink:=0;

      SerialQty:=0;

        BinQty:=0.0;
      end;
    {$ELSE}
      If (IdDocHed=TSH) then
      Begin
        DeductQty:=DeductQty*DocCnst;
        Qty:=Qty*DocCnst;
      end
      else
      {$IFDEF JAP}
        If (IdDocHed In JAPSplit) then {Reset YTD}
        Begin
          {SOPLink:=0;
          SOPLineNo:=0;
          QtyDel:=0;
          QtyWOff:=0;
          QtyPWoff:=0}

          CostPrice:=CostPrice*DocCnst;
          NetValue:=NetValue*DocCnst;

        end
        else
      {$ENDIF}

        NetValue:=NetValue*DocCnst;

    {$ENDIF}


    VAT:=VAT*DocCnst;

    

    If (Not (IdDocHed In JAPSplit)) then
      Begin
        If (LineNo=RecieptCode) then
          Payment:=SetRPayment(IdDocHed)
        else
          Payment:=DocPayType[IdDocHed];

        Reconcile:=0;

        // CJS 2014-07-10 - ABSEXCH-15136 - Bank Rec Date on copied transactions
        ReconDate := '';

      end;



    {$IFDEF STK}

     LineType:=StkLineType[IdDocHed];

     {* Deduct Genuine Stock Codes Only will not work out bill mat levels, as this is simply
        an exact copy of what happened on the last invoice,
        unless an order, in which case stk deduct reflects currently OS! *}

      If (Is_FullStkCode(StockCode)) then
      Begin
        Stock_Deduct(Idr,InvR,BOn,BOn,StkDedMode);

        {$IFDEF SOP} {v5.52. Open up for non SPOP versions using multi bins}
          TmpId:=IdR;

          Control_SNos(TmpId,InvR,Stock,1,Application.MainForm);

          IdR:=TmpId;
        {$ENDIF}
      end;

    {$ENDIF}

    If (ContraM=4) then
    Begin
      PPr:=InvR.ACPr; PYr:=InvR.AcYr;
    end;

    {$IFDEF JC}
       {$B-}
       If (Not WarnJC) and (Qty<>0.0) and (NetValue<>0.0) and (Not EmptyKey(JobCode,JobKeyLen))
        and (Global_GetMainRec(JobF,JobCode)) then {* Check status of job *}

       Begin
         WarnJC:=JobRec^.JobStat In [JobClosed];

         If (Not WarnJC) then
           WarnJC:=(JobRec^.JobStat In [JobCompl]) and (Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode)<>NomCode);
       end;

       {$B+}
    {$ENDIF}

    Inv:=TmpInv;
  end; {with..}
end; {Proc..}




{.$IFDEF SOP}

  { ========== Procedure to copy detail for Back to Back ========== }


  Procedure SetB2B_Copy(Var   Idr          : IDetail;
                        Var   InvR         : InvRec;
                              LCust        : CustRec;
                              B2BCtrl      : B2BInpRec;
                        Const B2BBuildMode : Boolean = False);

  Var
    StkDedMode :  Byte;
    Flg,
    KOPFlg     :  Boolean;
    TotQty     :  Real;
    OrigLine   :  IDetail;

  Begin
    With Idr do
    Begin

      OrigLine:=IdR;

      StkDedMode:=0;

      TotQty:=0.0;

      Flg:=BOn;  KOPFlg:=BOff;

      {* Preserve link to SOR for auto pick status *}

      B2BLink:=FolioRef;
      B2BLineNo:=ABSLineNo;

      FolioRef:=InvR.FolioNum;

      DocPRef:=InvR.OurRef;

      CXRate:=InvR.CXRate; {* In case of supplier currency change, set rate *}

      Currency:=InvR.Currency;

      CurrTriR:=InvR.CurrTriR;

      UseORate:=InvR.UseORate;

      PriceMulX:=1.0;

      If (OrigLine.KitLink<>0) and (Not Is_FullStkCode(StockCode)) then
      Begin {v5.01. If kitlink is doc folio, use new doc folio, otherwise it must be a stock folio, and preserve}
        If (OrigLine.KitLink=OrigLine.FolioRef) then
          KitLink:=FolioRef
        else
          KitLink:=OrigLine.KitLink;
      end
      else
        KitLink:=0;

      If (InvR.RunNo>=0)
      and (Not (IdDocHed In StkAdjSplit)) then    {* Auto Items & Stk Adj Run No. do
                                                     Not match Lines kept at 0/ unchanged to stop appearing on Nom *}
        PostedRun:=InvR.RunNo;

      IdDocHed:=InvR.InvDocHed;

      PreviousBal:=0;

      {* Do NOT reset currency on Variance Lines, or Nom Txfr lines, as these have their own
         independant currency *}

      {$IFDEF STK}

        {* If Order then we need to redeuct Qty_OS stock not DeductQty stock, as this could well be 0 *}

        If (IdDocHed In OrderSet) then
          StkDedMode:=0;

        {* If stock deduct, and reversing same doc type, then qty must be reveresed *}


        QtyDel:=0;
        QtyWOff:=0;

        If (Not (IdDocHed In DeliverSet)) then {* Leave these on deliveries, as otherwise they will not get invoiced *}
        Begin
          QtyPick:=0;
          QtyPWoff:=0;
        end;

        SOPLink:=0;
        SOPLineNo:=0;

        SerialQty:=0;

          BinQty:=0.0;

      {$ENDIF}


      If (LineNo=RecieptCode) then
        Payment:=SetRPayment(IdDocHed)
      else
        Payment:=DocPayType[IdDocHed];

      Reconcile:=0;

      CostPrice:=0;
      Discount:=0;

      // MH 24/03/2009: Added support for 2 new discounts for Advanced Discounts
      Discount2 := 0.0;
      Discount2Chr := C0;
      Discount3 := 0.0;
      Discount3Chr := C0;
      Discount3Type := 0;


      {Blank(JobCode,Sizeof(JobCode)); {Back to back should reset Job codes}
      Blank(AnalCode,Sizeof(AnalCode));

      
      {* New section for taking into account buying qty *}

      If (Is_FullStkCode(StockCode)) and (Not ShowCase)  then
      Begin
        
        Case B2BCtrl.QtyMode of
          1,3
            :  Begin
                  TotQty:=Qty_Os(OrigLine)-((OrigLine.QtyPick+(OrigLine.QtyPWOff*Ord(OrigLine.IdDocHed<>WOR)))*Ord(B2BCtrl.QtyMode=3));

                  If (OrigLine.IdDocHed<>WOR) then
                    TotQty:=TotQty*QtyMul;

                  If (Stock.BuyUnit>1) then
                    QtyMul:=Stock.BuyUnit
                  else
                    QtyMul:=1;

                  Qty:=Round_Up(DivWChk(TotQty,QtyMul),Syss.NoQtyDec);

                  If (Stock.BuyUnit>1) then {* Check we are buying whole cases*}
                  Begin
                    If ((Qty-Trunc(Qty))<>0) then {* increase order to next whole case *}
                      Qty:=Trunc(Qty)+1;

                  end;
                end;
          2  :  Begin
                  Qty:=Stk_SuggROQ(Stock,BOff,BOff);

                end
        else    Begin
                  If (OrigLine.IdDocHed<>WOR) then
                    TotQty:=Qty*QtyMul
                  else
                    TotQty:=WORReqQty(OrigLine);


                  If (Stock.BuyUnit>1) then
                    QtyMul:=Stock.BuyUnit
                  else
                    QtyMul:=1;

                  Qty:=Round_Up(DivWChk(TotQty,QtyMul),Syss.NoQtyDec);

                  If (Stock.BuyUnit>1) then {* Check we are buying whole cases*}
                  Begin
                    If ((Qty-Trunc(Qty))<>0) then {* increase order to next whole case *}
                      Qty:=Trunc(Qty)+1;

                  end;
                end;
        end; {Case..}
      end;


      LineNo:=InvR.ILineCount;
      ABSLineNo:=InvR.ILineCount;

      InvR.ILineCount:=InvR.ILineCount+2;

      {$IFDEF STK}

       LineType:=StkLineType[IdDocHed];

       VATCode:=Correct_PVAT(VATCode,LCust.VATCode);

       PDate:=InvR.TransDate; {Set line date to today. Will be overridden by lead time in Link Stk}

       {* Deduct Genuine Stock Codes Only will not work out bill mat levels, as this is simply
          an exact copy of what happened on the last invoice,
          unless an order, in which case stk deduct reflects currently OS! *}

        If (Is_FullStkCode(StockCode)) then
        Begin

          If (Stock.StockCode<>StockCode) then
            Global_GetMainRec(StockF,StockCode);


          VATCode:=Correct_PVAT(Stock.VATCode,LCust.VATCode);

            With B2BCtrl do {Do not explode kit lines here for multimode, or WOR}
            If ((MultiMode or Stock.ShowAsKit) and (Not PORBOMMode)) or (OrigLine.IdDocHed=WOR) then
            Begin
              KOPFlg:=Stock.KitOnPurch;
              Stock.KitOnPurch:=BOff;
            end;

          If (Not B2BBuildMode) Then
            Link_StockCtrl(IdR,InvR,LCust,LineNo,0,0,Qty*QtyMul,98-Ord(B2BCtrl.PORBOMMode),BOff,nil);

            With B2BCtrl do
            If ((MultiMode or Stock.ShowAsKit) and (Not PORBOMMode)) or (OrigLine.IdDocHed=WOR) then
            Begin
              Stock.KitOnPurch:=KOPFlg;
            end;

          {If we wish to preserve the line date to be same as original SOR date}

          If (B2BCtrl.KeepLDates) then {v5.50}
            PDate:=OrigLine.PDate; {Set line date to today. In case overridden by lead time in Link Stk}


          // MH 20/05/2009: Don't want to do it when building a B2B line to check for Multi-Buy Discounts
          {V4.32.002, moved here so otherwise re-order/cost price is set from original sales line as new POR cost price not set yet}
          {Don't perform any stock deduct whilst we are producing a surrogate b2b por bom line}
          If (Not B2BBuildMode) And (Not B2BCtrl.PORBOMMode) then
            Stock_Deduct(Idr,InvR,BOn,BOn,StkDedMode);


        end
        else
        Begin
          NetValue:=OrigLine.CostPrice;
          CostPrice:=0.0;

        end;



        If (Not Is_FullStkCode(StockCode)) then
          CalcVat(IdR,InvR.DiscSetl);

      {$ENDIF}



    end; {with..}
  end; {Proc..}

  Function B2bLine(IdR  :  IDetail;
               Var LastS:  Boolean)  :  Boolean;

  Var
    KeyS    :  Str255;

  Begin
    Result:=BOff;
    KeyS:='';

    With IdR do
    Begin
      If (KitLink=0) then {* Refresh Status *}
      Begin
        If (Is_FullStkCode(StockCode)) then
        Begin
          If (Stock.StockCode<>StockCode) then
            Global_GetMainRec(StockF,StockCode);
                                                       {* v5.00. If a kit is both sales & purch, treat as just sales for b2b otherwise auto pick will fail *}
          LastS:=((Stock.StockType=StkBillCode) and (Stock.KitOnPurch) and (Not Stock.ShowAsKit));

          Result:=BOn;

        end
        else
        Begin
          Result:=BOn;
          LastS:=BOff;
          ResetRec(StockF);
        end;
      end
      else
      Begin

        Result:=Not LastS;

      end;
    end;

  end;

{.$ENDIF}


{ == Function to determine if the operation would exceed any authorisation limits == }

Function Got_Authorisation(InvR      :  InvRec;
                           ContraM   :  Byte;
                       Var AuthCode  :  Str10)  :  Boolean;

Var
  NewDocHed  :  DocTypes;
  DocCnst    :  Integer;

Begin
  Result:=BOn;  DocCnst:=1;

  If (ContraM<>4) then
  With InvR do
  Begin
    NewDocHed:=ContraDocHed(ContraM,InvDocHed,DocCnst);

    If (Not (NewDocHed In CreditSet+DeliverSet)) or (ITotal(InvR)<0.0) then
    Begin
      AuthAmnt:=0.0; {Reset prev auth amount as new transaction}

      InvR.InvDocHed:=NewDocHed;

      {$IFDEF SY}
        Result:=Check_UserAuthorisation(Application.MainForm,InvR,AuthCode);
      {$ENDIF}

    end;

  end;

end;


{ ========== Procedure to Copy/Reverse a Document ========== }
{DocFolio contains the master transaction folio number upon which the copy/reverse will be based.
It is also assumed that the global Inv structure contains the mater transaction.

ContraM contains the operation code we wish to perform on the transaction.
1 - Copy
2 - Reverse
3 - Single back to back. (Not used any more as back to back wizard now controls)
4 - Generate Auto Reversing Nom. (Not used any more as the posting routines now generate an auto daybook reversing nom

SupCode contains the supplier code for the original back to back operations, which have now been superceeded by
their own routtines
}

Procedure ContraCopy_Doc(DocFolio  :  LongInt;
                         ContraM   :  Byte;
                         SupCode   :  Str10);



Const
  Fnum     =  InvF;

  Fnum2    =  IdetailF;
  KeyPath2 =  IdFolioK;

  SearchTit:  Array[1..4] of Str20 = ('Copying','Reversing','Adding Back to Back','Auto Reversing');

Var
  HMode,
  UOR     :  Byte;

  TmpOk,
  Locked,
  DelMode,
  KeepDel,
  B2BAutoPick,
  WarnJC,
  WarnLocTxfr,
  Contra  :  Boolean;

  KeyS,
  KeyChk  :  Str255;

  Keypath,
  TStatus,
  IdResult,
  DocCnsts:  Integer;

  LAddr,
  RecAddr :  LongInt;

  AuthBy  :  Str10;

  TmpInv,
  OrigInv :  InvRec;

  ExLocal :  TdExLocal;

  MsgForm :  TForm;

  B2BCtrl :  B2BInpRec;

  {$IFDEF SOP}
    CommitPtr
        :  Pointer;
  {$ENDIF}



Begin

  KeyPath:=InvFolioK;  HMode:=232;

  Contra:=(ContraM In [2,4]);

  B2BAutoPick:=(ContraM=5);

  If (B2BAutoPick) then
    ContraM:=3;

  OrigInv:=Inv;

  AuthBy:=''; WarnJC:=BOff; WarnLocTxfr:=BOff;

  Blank(B2BCtrl,SizeOf(B2BCtrl));

  {$IFDEF SOP}
    CommitPtr:=nil;
  {$ENDIF}


  {$B-}
  If (ContraM<>0) and (Got_Authorisation(OrigInv,ContraM,AuthBy)) then
  {$B+}
  Begin

    ExLocal.Create;

    ExLocal.AssignFromGlobal(InvF);

    {$IFDEF CU}
      {$B-}
      If (ContraM>2) or (ValidExitHook(2000,86+ContraM,ExLocal)) then
      {$B+}
    {$ENDIF}

    Begin
      TmpOk:=BOff;

      UOR:=0;

      Locked:=BOff;

      KeepDel:=BOff;

      TStatus:=Status;

      IdResult:=0;

      KeyS:=FullNomKey(DocFolio);

      {$IFNDEF SOPDLL}
      MsgForm:=CreateMessageDialog('Please Wait...'+#13+SearchTit[ContraM]+' Document',mtInformation,[]);
      MsgForm.Show;
      MsgForm.Update;
      {$ENDIF}

      RecAddr:=0;

      DocCnsts:=1;

      TmpOk:=GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,KeyPath,Fnum,BOff,Locked,LAddr);


      {$B-}

      If (TmpOk) and (Locked) {and ((Not Inv.ExternalDoc) or (SBSIn))} and (Not (Inv.InvDocHed In BatchSet))

      {$IFDEF STK}
        and (Check_EnoughStk(1+(-2*Ord(ContraM=2)),Inv,(Inv.InvDocHed In QuotesSet) or (ContraM>2))) then

      {$ELSE}
        then

      {$ENDIF}


      {$B-}
      Begin
        {$IFDEF SOP}
           With Inv do
             WarnLocTxfr:=(InvDocHed=ADJ) and (DelTerms<>'') and (ContraM=2); {This is a loc transfer which will be reveresed}

        {$ENDIF}

        SetInv_Copy(Inv,DocCnsts,ContraM,SupCode,B2BAutoPick);

        Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
                    Inv.OurRef+' was created by '+SearchTit[ContraM]+' '+OrigInv.OurRef+' / '+OrigInv.YourRef+' '+OrigInv.TransDesc,
                    Inv.NLineCount);

        If (AuthBy<>'') then {Make a note}
        Begin
          Add_Notes(NoteDCode,NoteCDCode,FullNomKey(Inv.FolioNum),Today,
                    Inv.OurRef+' was authorised by '+Strip('R',[#32],AuthBy)+'. For '+FormatCurFloat(GenRealMask,ITotal(Inv),BOff,Inv.Currency),
                    Inv.NLineCount);

          SetHold(HMode,Fnum,Keypath,BOff,Inv);
        end;


        Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        If (StatusOk) then
        Begin
          If (Not (Inv.InvDocHed In QuotesSet+NomSplit+PSOPSet)) and (Not Syss.UpBalOnPost) and (Inv.RunNo=0) then
            UpdateBal(Inv,BaseTotalOS(Inv),
                          (ConvCurrICost(Inv,BOff,BOn)*DocCnst[Inv.InvDocHed]*DocNotCnst),
                          (ConvCurrINet(Inv,BOff,BOn)*DocCnst[Inv.InvDocHed]*DocNotCnst),
                          BOff,2);  {* Up Date Customer Balance, exclude auto item copies! *}

          {$IFDEF SOP}
            With Inv do
              If (InvDocHed In PSOPSet) and ((RunNo=OrdUSRunNo) or (RunNo=OrdUPRunNo)) then {* Update Order O/S Value *}
              Begin
                UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

                UpdateOrdBal(Inv,(Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                             DocCnst[InvDocHed]*DocNotCnst),
                             0,0,
                             BOff,0);
              end;

              {$IFNDEF EXDLL}

              {$B-}
                If (CommitAct) and (ContraM In [1..3]) and (Inv.InvDocHed=POR) then
              {$B+}
                  CommitPtr:=Conv_Create_CommitObject(BOff,nil);

              {$ENDIF}

          {$ENDIF}


          KeyChk:=FullNomKey(DocFolio);

          Case ContraM of

            3  :  KeyS:=FullIdKey(DocFolio,1); {* Do not copy invisible lines *}

            else  KeyS:=FullIdKey(DocFolio,StkLineNo);

          end; {Case..}


          Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
          With Id do
          Begin
            DelMode:=BOff;

            Status:=GetPos(F[Fnum2],Fnum2,RecAddr);


            Case ContraM of

              {$IFDEF SOP}

                3  :  Begin
                        {DelMode:=(Not Is_FullStkCode(Id.StockCode)) and (Id.KitLink<>0);}

                        DelMode:=Not B2BLine(Id,KeepDel);

                        If (Not DelMode) then
                        Begin
                          TmpInv:=Inv;

                          SetB2B_Copy(Id,TmpInv,Cust,B2BCtrl);

                          Inv:=TmpInv;
                        end;
                      end;

              {$ELSE}

                3  :  ;

              {$ENDIF}

              else  SetId_Copy(Id,Inv,DocCnsts,ContraM,WarnJC);

            end; {Case..}


            If (Not DelMode) then
              Status:=Add_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

            If (Status<>0) then
              IdResult:=Status
            else
            Begin {* Generate Job Actual *}

              {$IFDEF PF_On}

                If (JbCostOn) and ((DetLTotal(Id,BOn,BOff,0.0)<>0) or (Id.IdDocHed In [ADJ,TSH])) and (Id.LineNo>0)
                   and ((Id.LineNo<>RecieptCode) or (Not (Id.IdDocHed In PurchSet))) then
                  Update_JobAct(Id,Inv);

                {$IFDEF STK}
                  Stock_AddCustAnal(Id,BOn,0);


                  {$IFDEF SOP}
                    {$IFNDEF EXDLL} {Update live commitment from new POR}
                      Conv_Update_LiveCommit(Id,1,CommitPtr);
                    {$ENDIF}
                  {$ENDIF}


                {$ENDIF}

              {$ENDIF}

            end;

            SetDataRecOfs(Fnum2,RecAddr);

            Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);

            Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

          end; {While..}

          Report_BError(Fnum2,IdResult);

          {$IFDEF SOP}

            If (IdResult=0) and (ContraM=3) then {* Finalise Back to Back Document *}
            Begin

              CalcInvTotals(Inv,ExLocal,BOn,BOn); {* Calculate Invoice Total *}

              {* Store again *}

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

              Report_BError(Fnum,Status);

              {* Store matching information *}

              With Inv do
              Begin
                RemitNo:=OrigInv.OurRef;

                Match_Payment(Inv,Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                          ,TotOrdOS,23);
                RemitNo:='';
              end;

              With OrigInv do
              Begin
                RemitNo:=Inv.OurRef;
                Match_Payment(OrigInv,Round_Up(Conv_TCurr(Inv.TotOrdOS,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                          ,Inv.TotOrdOS,23);

                RemitNo:='';
              end;



            end;


          {$ENDIF}



          With Inv do  {* Copy Any Notes across *}
            If {(InvDocHed In OrderSet) and} (Not Contra) then
              CopyNoteFolio(NoteDCode,NoteDCode,FullNCode(FullNomKey(DocFolio)),FullNCode(FullNomKey(FolioNum)),0);


          {$IFNDEF SOPDLL}
          SendToObjectCC(Inv.CustCode,1);
          {$ENDIF}

        end; {If Inv Part Stored Ok..}

      end {If Locked Ok..}
      else
        MessageBeep(0); {* External! *}

      With ExLocal do
      Begin
        AssignFromGlobal(Fnum);

        {$IFDEF CU}
          {$B-}
          If (ContraM<=2) then
            (GenHooks(2000,97+ContraM,ExLocal));
          {$B+}
        {$ENDIF}



        Status:=LPresrv_BTPos(Fnum,Keypath,F[Fnum],RecAddr,BOff,BOff);
      end;

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      {$IFNDEF SOPDLL}
      MsgForm.Free;

      If (WarnJC) then
      Begin
        CustomDlg(Application.MainForm,'WARNING!','Invalid Job',
                           'This transaction contains Job Codes for Completed or Closed Jobs, which will'+#13+
                           'either not post correctly to Job Costing, or generate invalid work in progress.'+#13+#13+
                           'You must edit this transaction and correct the Job code and/or G/L code.',
                           mtWarning,
                           [mbOK]);

      end;


      {$IFDEF SOP}
        If (WarnLocTxfr) then
        Begin
          CustomDlg(Application.MainForm,'WARNING!','Reverse Location Transfer',
                             'This Stock Adjustment is a Location Transfer. '+#13+
                             'Reversing it has created a normal Stock Adjustment designed to reverse the stock effect of the original Location Transfer.'+#13+#13+
                             'However, the effect on the G/L when posting this Adjustment will not be an exact reversal of the original.',
                             mtWarning,
                             [mbOK]);

        end;



       {$IFNDEF EXDLL}

         If (Assigned(CommitPtr)) then {Remove the commit object}
           Conv_Create_CommitObject(BOn,CommitPtr);

       {$ENDIF}

      {$ENDIF}

      {$ENDIF not SOPDLL}

      Status:=TStatus; {* Restore Status Value *}

      With ExLocal do
      Begin
        AssignToGlobal(Fnum);

        Status:=LPresrv_BTPos(Fnum,Keypath,F[Fnum],RecAddr,BOn,BOff);
      end;
    end; {If Hook failed}


    ExLocal.Destroy;

  end; {If Abort Menu ..}

end; {Proc..}



{$IFDEF SOP}

  Function Check_AllCommit(OpoMode  :  Byte;
                           LInv     :  InvRec)  :  Boolean;


  Const
    Fnum     = IdetailF;
    Keypath  = IdFolioK;


  Var

    KeyS,KeyChk  :  Str255;
    BlankId      :  Idetail;


  Begin
    {$B-}
      Result:=(OpoMode=3) or (Not CommitAct) ;

    {$B+}

    Blank(BlankId,Sizeof(BlankId));

    If (Not Result) then
    Begin
      KeyChk:=FullNomKey(LInv.FolioNum);
      KeyS:=FullIdKey(LInv.FolioNum,1);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Result) do
      With Id do
      Begin
        Result:=Check_OverCommited(Id,BlankId,BOn);

        If (Not Result) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end;

      Result:=Not Result;

      If (Not Result) then {* If password allowed, then act as a warning, otherwise fail conversion *}
      With Id do
        Result:=(PChkAllowed_In(268) and (IdDocHed In [SQU,SOR])) or (PChkAllowed_In(269) and (IdDocHed In [PQU,POR]));
    end;

  end;
{$ENDIF}



{ ============== Procedure to Convert a ?QU to ?IN ============= }
{Quo_To_Inv
Assumes the Global Inv Structure contains the Tranaction to be processed.

{Fnum  :   InvF;
  Keypath : The InvF Keypath in operation prior to calling Quo_To_Inv so its position will be used when storing
  the new transaction.


}
Function Quo_To_Inv(Fnum,KeyPath  :  Integer;
                    ConvMode      :  Byte;
                    ExLocalPtr    :  TdExLocalPtr = nil)  :  Boolean;



Var
  UOR       :  Byte;

  LAddr,
  OldFolio  :  LongInt;

  FCustCode :  Str20;

  KeyS      :  Str255;

  ChangeSign:  Boolean;

  VLoop     :  VATType;


Begin
  ChangeSign:=BOff;
  UOR:=0;

  Result:=BOff;

  {$IFNDEF SOPDLL}
  {$IFDEF STK}
    {$B-}
    If (Check_EnoughStk(1,Inv,(ConvMode<>6))) {$IFDEF SOP} and Check_AllCommit(ConvMode,Inv) {$ENDIF} then
    {$B+}
  {$ENDIF}
  {$ENDIF}

  With Inv do
  Begin

    { Modes  6  ?UO - ?IN }
    {        14 ?UO - ?OR }
    {        3  PDN - PIN }


    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked,LAddr);

    If (Ok) and (GlobLocked) then
    Begin
      // MH 05/11/2014 ABSEXCH-15694: Moved customer lookup up as Cust was being referenced
      //                              before it was being populated
      FCustCode:=CustCode;
      GetCust(Application.MainForm,FCustCode,FCustCode,BOff,-1);

      Case ConvMode of

        6  :  Begin

                If (SalesorPurch(InvDocHed)) then
                Begin
                  If (InvNetVal>=0.0) then
                    InvDocHed:=SIN
                  else
                    InvDocHed:=SCR;
                end
                else
                Begin
                  If (InvNetVal>=0.0) then
                    InvDocHed:=PIN
                  else
                    InvDocHed:=PCR;
                end;

                ChangeSign:=(InvNetVal<0.0);

                {$IFDEF STK}

                  FillChar(BatchLink,Sizeof(BatchLink),0);  {* Blank PSOP Due date index *}

                {$ENDIF}

              end;

        14 :  Begin

                If (SalesorPurch(InvDocHed)) then
                  InvDocHed:=SOR
                else
                  InvDocHed:=POR;

                {$IFDEF STK}

                  BatchLink:=QUO_DelDate(InvDocHed,DueDate);

                  RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);

                  CustSupp:=Char(Succ(Ord(CustSupp)));

                  TotOrdOS:=InvNetVal-DiscAmount;

                {$ENDIF}

                  If (Syss.QuoOwnDate) then
                    DueDate:=TransDate;

                  If (InvDocHed =SOR) then
                  Begin
                    // CJS 2014-08-04 - v7.x Order Payments - T060 - set Order Payment element
                    if Cust.acAllowOrderPayments and Syss.ssEnableOrderPayments then
                      thOrderPaymentElement := opeOrder;
                  end;

              end;

        3  :  Begin

                If (SalesorPurch(InvDocHed)) then
                  InvDocHed:=SIN
                else
                  InvDocHed:=PIN;

                {$IFDEF STK}

                  FillChar(BatchLink,Sizeof(BatchLink),0);  {* Blank PSOP Due date index *}

                  RunNo:=0;

                  CustSupp:=Char(Pred(Ord(CustSupp)));

                {$ENDIF}

              end;

      end; {Case..}


      If (EmptyKey(YourRef,DocYRef1Len)) then
        YourRef:=OurRef
      else
        If (EmptyKey(TransDesc,DocYRef2Len)) then
          TransDesc:=OurRef;

      If (UseORate=1) then  {* Zero Co.Rate & Reset Ex Rate*}
      Begin
        CXrate:=SyssCurr^.Currencies[Currency].CRates;

        CXrate[BOff]:=0;

        VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;


        {* Preserve original Co. Rate *}

        OrigRates:=SyssCurr^.Currencies[Currency].CRates;

        UseORate:=0;

        SetTriRec(Currency,UseORate,CurrTriR);
        SetTriRec(Syss.VATCurr,UseORate,VATTriR);
        SetTriRec(Currency,UseORate,OrigTriR);

      end;


      // MH 05/11/2014 ABSEXCH-15694: Moved customer lookup up as Cust was being referenced
      //                              before it was being populated
      //FCustCode:=CustCode;
      //GetCust(Application.MainForm,FCustCode,FCustCode,BOff,-1);


      {$IFDEF SOP}
        If (ConvMode=6) then {* Check for invoice To condition *}
        With Cust do
        Begin
          If (Not EmptyKey(SOPInvCode,CustKeyLen)) then
          Begin

            FCustCode:=FullCustCode(SOPInvCode);

            If GetCust(Application.MainForm,FCustCode,FCustCode,BOff,-1) then
              Inv.CustCode:=FullCustCode(FCustCode);


          end;

        end;
      {$ENDIF}


      If (Not Syss.QuoOwnDate) then
      Begin

        TransDate:=Today;

        If (Syss.AutoPrCalc) then
        Begin

          Date2Pr(TransDate,AcPr,AcYr,nil);

        end
        else
        Begin
          ACPr:=GetLocalPr(0).CPr;
          ACYr:=GetLocalPr(0).CYr;
        end;

        If (Not (InvDocHed In OrderSet)) then
          DueDate:=CalcDueDate(TransDate,Cust.PayTerms);

      end;

      {* -- *}

      

      PrintedDoc:=BOff;

      Set_DocAlcStat(Inv);  {* Set Allocation Status *}

      OpName:=EntryRec^.LogIn;

      OldFolio:=FolioNum;

      SetNextDocNos(Inv,BOn);


      If (ChangeSign) and (ConvMode=6) then {* Alter sign as we convert *}
      Begin
        { ========== Financial Contra =========== }

        InvNetVal:=ABS(InvNetVal);

        InvVAT:=ABS(InvVAT);

        For VLoop:=VStart to VEnd do
          InvVATAnal[VLoop]:=ABS(InvVATAnal[VLoop]);


        DiscSetAm:=ABS(DiscSetAm);

        DiscAmount:=ABS(DiscAmount);

        TotalOrdered:=ABS(TotalOrdered);

        TotalReserved:=ABS(TotalReserved);

        TotalInvoiced:=ABS(TotalInvoiced);

        TotalCost:=ABS(TotalCost);

        TransNat:=SetTransNat(InvDocHed);

      end;

      {v500.002. Attempt to preserve ledger position by deleting old quote first, and adding newly converted transaction second}

      Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

      Report_BError(Fnum,Status);

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      //PR: 04/11/2011 v6.9 Add Audit Note for created Order.
      if Status = 0 then
        AuditNote.AddNote(anTransaction, Inv.FolioNum, anCreate);


      Report_BError(Fnum,Status);

      {Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr); v500.002. no need to unlock as we have deleted original}

      If (StatusOk) then
      Begin
        If (Not Syss.UpBalOnPost) and (Not (InvDocHed In OrderSet)) then
          UpdateBal(Inv,BaseTotalOS(Inv),
                        (ConvCurrICost(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                        (ConvCurrINet(Inv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                        BOff,2);

        //PR: 14/04/2014 ABSEXCH-12703 Removed SOP declaration so SQU-SOR updates committed balances
        {..$IFDEF SOP}


          If (ConvMode<>6) then
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

            Case ConvMode of

              3  :  Begin {* Deduct PDN value *}

                      UpdateOrdBal(Inv,(Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                                   DocCnst[InvDocHed]*DocNotCnst),
                                   0,0,
                                   BOn,0);

                    end;

             14  :  Begin {* Add to Order O/S *}
                      UpdateOrdBal(Inv,(Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                                   DocCnst[InvDocHed]*DocNotCnst),
                                   0,0,
                                   BOff,0);

                    end;

            end; {Case..}
          end;

        //PR: 14/04/2014 ABSEXCH-12703
        {..$ENDIF}

        {$IFNDEF STK}

          ChangeLinks(FullNomKey(OldFolio),'',IDetailF,Length(FullNomKey(OldFolio)),IDFolioK);   {** Reset Id Hed **}

        {$ELSE}


          {$IFDEF Inv}

            Delete_StockLinks(FullIdkey(OldFolio,StkLineNo),IdetailF,Sizeof(OldFolio),IdFolioK,BOn,Inv,1);
            //AP : 21/02/2017 2017-R1 ABSEXCH-17483 : COMTK - Notes not Copied when PQU Converted to PIN
            ChangeNoteFolio(NoteDCode,FullNomKey(OldFolio),FullNomKey(FolioNum)); 

          {$ENDIF}


        {$ENDIF}


        {$IFDEF C_On}

          ChangeNoteFolio(NoteDCode,FullNomKey(OldFolio),FullNomKey(FolioNum));

        {$ENDIF}


        {$IFDEF Ltr}
           ChangeLinkFolio(LetterDocCode,FullNomKey(OldFolio),FullNomKey(FolioNum));

        {$ENDIF}

        {$IFNDEF SOPDLL}
        SendToObjectCC(Inv.CustCode,1);
        {$ENDIF}

        Result:=BOn;
      end;

    end;

  end; {With..}
end; {Proc..}









end.
