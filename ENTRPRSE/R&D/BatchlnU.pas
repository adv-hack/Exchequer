unit BatchlnU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, Math, StrUtils,
  GlobVar,VARRec2U,VarConst,ExWrap1U,SalTxl2U,BorBtns;

{$I DEFOVR.Inc}

type
  BatchLineRec  =  Record

                     SBTRef     :   String[10];
                     BCustCode  :   String[10];
                     BCustSupp  :   Char;
                     BPDate     :   LongDate;
                     BYourRef   :   String[20];//RJ 08/02/2016 2016-R1 ABSEXCH-15984: The field Size for your ref is increased to 20 char. 
                     BNomCode   :   LongInt;
                     BCtrlNom   :   LongInt;
                     BDesc      :   String[60];
                     BCCDep     :   CCDepType;
                     NetValue   :   Double;
                     VATCode    :   Char;
                     VATIncFlg  :   Char;
                     LineVAT    :   Double;
                     BOpName    :   Str10;
                     STDisc     :   Double;
                     SettleDisc :   Double;
                     SetDays    :   Integer;
                     SetDisc    :   Double;
                     DiscTake   :   Boolean;
                     BDocHed    :   DocTypes;
                     BatchSplit :   Boolean;
                     BJobCode   :   Str10;
                     BJobAnal   :   Str10;
                     BCQNo      :   String[60];
                     BTransMode :   Byte;
                     BDelTerms  :   String[3];
                     IncNetValue:   Double;
                     ECService  :   Boolean;
                     ECServiceStartDate
                                :   LongDate;
                     ECServiceEndDate
                                :   LongDate;
                   end;


  TBEntryLine = class(TForm)
    SBSPanel1: TSBSPanel;
    Id1ORefF: Text8Pt;
    Label88: Label8;
    Label81: Label8;
    Id1ACF: Text8Pt;
    Label82: Label8;
    Id1DateF: TEditDate;
    Id1YRefF: Text8Pt;
    Id1Desc1F: Text8Pt;
    Label83: Label8;
    Id1NomF: Text8Pt;
    Label84: Label8;
    Id1CCF: Text8Pt;
    Id1DepF: Text8Pt;
    CCLab1: Label8;
    Id1JCF: Text8Pt;
    Id1JAF: Text8Pt;
    Id1JALab: Label8;
    Id1JCLab: Label8;
    Id3VATF: TSBSComboBox;
    Id1NetF: TCurrencyEdit;
    Id1VATF: TCurrencyEdit;
    Label85: Label8;
    Label86: Label8;
    VATCClab: Label8;
    Id1Desc2F: Text8Pt;
    IdTotF: TCurrencyEdit;
    Label89: Label8;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    chkService: TBorCheck;
    dtServiceStart: TEditDate;
    lblServiceTo: TLabel;
    dtServiceEnd: TEditDate;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Id1CCFExit(Sender: TObject);
    procedure Id1ACFExit(Sender: TObject);
    procedure Id1JAFExit(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Id1NomFExit(Sender: TObject);
    procedure Id1JCFExit(Sender: TObject);
    procedure Id1YRefFExit(Sender: TObject);
    procedure Id1VATFExit(Sender: TObject);
    procedure Id3VATFChange(Sender: TObject);
    procedure Id1YRefFChange(Sender: TObject);
    procedure chkServiceClick(Sender: TObject);
    procedure Id1DateFExit(Sender: TObject);
  private
    { Private declarations }
    fFrmClosing,
    IdStored,
    StopPageChange,
    InOutId,
    fRecordAuth,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    OldConTot,
    LastQtyValue :  Double;

    AuthBy       :  Str10;

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    AcSetDays    :   Integer;
    AcSetDisc    :   Double;

    // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
    procedure ApplyJobCCDeptRules(JobCode: string);

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure OutId;

    procedure Form2Id;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    procedure EnableECServiceCheckBox;

  public
    { Public declarations }

    DocHed     :  DocTypes;

    ExLocal    :  TdExLocal;
    LastBL,
    LBatchLine :  BatchLineRec;
    BInv       :  InvRec;



    procedure ShowLink(InvR      :  InvRec;
                       VOMode    :  Boolean);

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    procedure EditLine(InvR       :  InvRec;
                       Edit,
                       ViewOnly   :  Boolean);

    procedure SetHelpContextIDs; // NF: 25/07/06

  end;


  Procedure Calc_BatchVAT(Var  BatchLineR  :  BatchLineRec);


  Function Calc_BatchLine(BatchLineR  :  BatchLineRec)  :  Double;


  Procedure Doc2Batch(Var  BatchLineR  :  BatchLineRec;
                           InvR        :  InvRec);
  Procedure Get_BatchId(Var  BatchLineR  :  BatchLineRec;
                             InvR        :  InvRec);

  Procedure UpdateBATBal(BatchLineR  :  BatchLineRec;
                     Var InvR        :  InvRec;
                         Mode        :  Byte);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  BTSupU1,
  BTSupU2,
  CurrncyU,
  SBSComp2,
  ComnUnit,
  ComnU2,

  {$IFDEF PF_On}

     InvLst2U,

  {$ENDIF}

  ColCtrlU,
  CmpCtrlU,
  SysU1,
  SysU2,
  SysU3,
  MiscU,

  {$IFDEF NP}
    NoteSupU,

  {$ENDIF}

  BatchEnU,

  InvListU,

  InvCTSUU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF VAT}
     GIRateU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  {$IFDEF SY}
    AUWarnU,

  {$ENDIF}

  {$IFDEF JC}
    JChkUseU,
  {$ENDIF}

  Warn1U,

  PassWR2U,
  Saltxl1U,

  // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
  JobUtils,

  // MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  // MH 17/06/2015 v7.0.14 ABSEXCH-16553: Added PPD support to Batch Transactions
  PromptPaymentDiscountFuncs,
  SavePos;

{$R *.DFM}




{ *Evalu =================== Calculate Line VAT ============== }

Procedure Calc_BatchVAT(Var  BatchLineR  :  BatchLineRec);

Var
  IdLineDecs
             :  Byte;

  VATRateLine,
  VATRateStd,
  VATUAMnt,
  VATUDiff,
  NewTotal,
  LineDiscount,
  OrigValue  :  Double;

  TmpLine    :  BatchLineRec;


Begin
  VATUAmnt:=0.0;  VATUDiff:=0.0;

  With BatchLineR do
  Begin
    VATRateLine:=TrueReal(SyssVAT^.VATRates.VAT[GetVATNo(VatCode,VATIncFlg)].Rate,10);
    VATRateStd:=TrueReal(SyssVAT^.VATRates.VAT[GetIVATNo(VATIncFlg)].Rate,10);


    Case VatCode of
      'S','Z','E','1'..'9','A','D','T','X','B','C','F','G','R','W','Y'
          :  Begin
               LineVAT:=Round_Up((NetValue-Calc_PAmount(NetValue,SetDisc,PcntChr))*VATRateLine,2);
               IncNetValue:=0.0;
             end;
      'I','M'
          :  Begin

               If (IncNetValue=0.0) or (VATCode='I') then
                 LineDiscount:=Calc_PcntPcnt(NetValue,0.0,SetDisc,#0,PcntChr)
               else
                 LineDiscount:=Calc_PcntPcnt(IncNetValue,0.0,SetDisc,#0,PCntChr);

               If (BDocHed In PurchSplit) then
                 IdLineDecs:=Syss.NoCosDec
               else
                 IdLineDecs:=Syss.NoNetDec;

               If (VATCode=VATMCode) then
               Begin
                 If (IncNetValue=0.0) then
                 Begin
                   NetValue:=(Round_Up(NetValue,IdLineDecs)+LineVAT);
                 end
                 else
                   NetValue:=IncNetValue;
               end
               else
               Begin
                 IncNetValue:=NetValue;


               end;


	       OrigValue:=Round_Up(NetValue,IdLineDecs)-
			  Round_Up(LineDiscount,2);


               {VAT:=Round_Up(Round_Up(((OrigValue*VATRateStd)/
                               (VATRateStd+1)),2)*Qty,2);}

               {Altered in v4.31 so that inclusive VAT is worked out by comparing the total inclusive
                against the calculated VAT and adjusted accordingly *}

                VATUAMnt:=Round_Up(((OrigValue*VATRateStd)/
                               (VATRateStd+1)),2);

                NewTotal:=(NetValue-LineDiscount);

                {If (Round_Up(Calc_PcntPcnt(NetValue,Discount,SetlDisc,DiscountChr,PcntChr),2)=0.0) then}
                  NetValue:=NetValue-((NewTotal*VATRateStd)/
                                   (VATRateStd+1));




               LineVAT:=Round_Up(VATUAmnt,2);


               VATUAmnt:=Round_Up(OrigValue,2);

               NewTotal:=(Round_Up((Round_Up(NetValue,IdLineDecs)-
			  Round_Up(LineDiscount,2)),2)+LineVAT);

               VATUDiff:=Round_Up(VATUAmnt-NewTotal,2);



               LineVAT:=LineVAT+VATUDiff;

               {v5.60.063. We need to do a final round up here as it is really the invnetval we are generating so it cannot be left floating}
               NetValue:=Round_Up(NetValue,2);

               If (IncNetValue<>0.0) and (SetDisc<>0.0)  then
               Begin
                 LineDiscount:=0.0;

                 NewTotal:=(IncNetValue-LineDiscount);

                 NetValue:=Round_Up(IncNetValue-((NewTotal*VATRateStd)/(VATRateStd+1)),idLineDecs);

                 TmpLine:=BatchLineR;

                 With TmpLine do
                 Begin
                   If (VATIncFlg In VATSet) then
                     VATCode:=VATIncFlg
                   else
                     VATCode:=VATSTDCode;

                   Calc_BatchVAT(TmpLine);
                 end;

                 LineVAT:=TmpLine.LineVAT;

               end;


               If (LineVAT<>0.0) then
                 VATCode:=VATMCode;
             end;

    end; {case..}
  end; {With..}
end; {Proc..}



{ ============ Function to return Line Total Value ============= }

Function Calc_BatchLine(BatchLineR  :  BatchLineRec)  :  Double;


Begin

  With BatchLineR do
  Begin

    Calc_BatchLine:=(Round_Up(NetValue+LineVAT-(STDisc+(SettleDisc*Ord(DiscTake))),2)*DocCnst[BDocHed]*DocNotCnst);

  end; {With..}

end; {Func..}





 { ========= Procedure to Transfer between Batch Line & Doc ======== }

 Procedure Doc2Batch(Var  BatchLineR  :  BatchLineRec;
                          InvR        :  InvRec);

 Begin

   With BatchLineR do
     With InvR do
     Begin

       Blank(BatchLineR,Sizeof(BatchLineR));

       SBTRef:=OurRef;

       BCustCode:=CustCode;

       BPDate:=TransDate;

       BYourRef:=Trim(YourRef);
       BCustSupp:=CustSupp;

       NetValue:=InvNetVal;

       LineVAt:=InvVAT;

       BDocHed:=InvDocHed;

       STDisc:=DiscAmount;

       SettleDisc:=DiscSetAm;

       SetDays:=DiscDays;

       SetDisc:=DiscSetl;

       DiscTake:=DiscTaken;

       BOpName:=OpName;

       BCtrlNom:=CtrlNom;

       BJobCode:=DJobCode;
       BJobAnal:=DJobAnal;

       BTransMode:=TransMode;
       BDelTerms:=DelTerms;

     end; {With..}

   end; {Proc..}




 { ========= Procedure to Transfer between Doc & Batch Line ======== }

 Procedure Batch2Doc(     BatchLineR  :  BatchLineRec;
                     Var  InvR        :  InvRec);


 Begin

   With BatchLineR do
     With InvR do
     Begin

       OurRef:=SBTRef;

       {$IFDEF JC}
         If (CustCode<>BCustCode) then
           Reset_DOCCIS(InvR,BOn);
       {$ENDIF}

       CustCode:=BCustCode;
       CustSupp:=BCustSupp;

       CtrlNom:=BCtrlNom;

       TransDate:=BPDate;

       DueDate:=CalcDueDate(TransDate,Cust.PayTerms);

       YourRef:=LJVar(BYourRef,DocYref1Len);

       If (Syss.WarnYRef) then
         YourRef:=UpCaseStr(YourRef);


       InvNetVal:=NetValue;

       DiscAmount:=STDisc;

       DiscSetAm:=SettleDisc;

       DiscDays:=SetDays;

       DiscSetl:=SetDisc;

       InvVAT:=LineVAT;

       InvDocHed:=BDocHed;

       DJobCode:=BJobCode;
       DJobAnal:=BJobAnal;

       CtrlNom:=BCtrlNom;

       TransMode:=BTransMode;
       DelTerms:=BDelTerms;

       ILineCount:=2;
       NLineCount:=1;

       OpName:=EntryRec^.LogIn;

       { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
       TransactionOriginator.SetOriginator(InvR);

       Blank(InvVATAnal,Sizeof(InvVATAnal)); {* Bug fix, as otherwise if you edit a line after
                                                storing, and change the VAT rate, the old rates
                                                vat value remains. *}

       InvVATAnal[GETVatNo(VATCode,VATIncFlg)]:=LineVAT;

       DiscTaken:=DiscTake;

       If (InvDocHed In DirectSet) then
       Begin

         TotalInvoiced:=ConvCurrITotal(InvR,BOff,BOff,BOff);

         Settled:=ConvCurrITotal(InvR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst;



         CurrSettled:=ITotal(InvR)*DocCnst[InvDocHed]*DocNotCnst;  {**** Full Currency Value Settled ****}



         CXRate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];


       end;


       InvR.DiscSetAm:=Round_Up(Calc_PAmount((InvR.InvNetVal-InvR.DiscAmount),InvR.DiscSetl,PcntChr),2);
     end; {With..}

     // MH 17/06/2015 v7.0.14 ABSEXCH-16553: Added PPD support to Batch Transactions
     // Zero down any pre-existing PPD settings from previous calls
     InvR.thPPDPercentage := 0.0;
     InvR.thPPDDays := 0;
     If (Not SettlementDiscountSupportedForDate(InvR.TransDate)) And (InvR.InvDocHed In PPDTransactions) Then
     Begin
       // Load customer and set/calculate the PPD - as we have to use the global files, due to
       // this being a standalone routine, we need to save and restore the existing position/record
       With TBtrieveSavePosition.Create Do
       Begin
         Try
           // Save the current position in the file for the current key
           SaveFilePosition (CustF, GetPosKey);
           SaveDataBlock (@Cust, SizeOf(Cust));

           // Load the Customer details
           If Global_GetMainRec(CustF, FullCustCode(InvR.CustCode)) Then
           Begin
             // Check whether PPD should be applied
             If (Cust.acPPDMode <> pmPPDDisabled) Then
             Begin
               InvR.thPPDPercentage := Pcnt(Cust.DefSetDisc);
               InvR.thPPDDays := Cust.DefSetDDays;
             End; // If (Cust.acPPDMode <> pmPPDDisabled)
           End; // If Global_GetMainRec(CustF, FullCustCode(InvR.CustCode))

           // Restore position in file
           RestoreDataBlock (@Cust);
           RestoreSavedPosition;
         Finally
           Free;
         End; // Try..Finally
       End; // With TBtrieveSavePosition.Create
     End; // If (Not SettlementDiscountSupportedForDate(InvR.TransDate)) And (InvR.InvDocHed In PPDTransactions)
     // Recalculate the PPD Goods and VAT values for the current PPPD Percentage
     UpdatePPDTotals (InvR);
   end; {Proc..}



 Procedure Batch2Line(     Direct      :  Boolean;
                           BatchLineR  :  BatchLineRec;
                      Var  IdR         :  IDetail;
                      Var  BInv,
                           InvR        :  InvRec);
 Begin
  With InvR,IdR, BatchLineR do
  Begin

    Blank(IdR,Sizeof(IdR));

    FolioRef:=FolioNum;

    DocPRef:=InvR.OurRef;

    LineNo:=(RecieptCode*Ord(Direct))+(1*Ord(Not Direct));



    {ABSLineNo:=InvR.ILineCount+Ord(Direct);}

    ABSLineNo:=1+Ord(Direct);

    Qty:=1;

    QtyMul:=1;

    QtyPack:=QtyMul;

    PriceMulX:=1.0;

    IdR.Currency:=InvR.Currency;

    IdR.CXRate:=InvR.CXRate;

    IdR.CurrTriR:=InvR.CurrTriR;

    PYr:=AcYr;

    PPr:=AcPr;

    IDDocHed:=InvDocHed;

    {$IFDEF STK}

      LineType:=StkLineType[IdDocHed];

    {$ENDIF}


    IdR.CustCode:=InvR.CustCode;

    PDate:=TransDate;


    IdR.JobCode:=BJobCode;
    IdR.AnalCode:=BJobAnal;

    CCDep:=BCCDep;


    If (Direct) then
    Begin

      IdR.NetValue:=ITotal(InvR);

      NomCode:=BInv.BatchNom;

      Payment:=SetRPayment(IdDocHed);

      If (IdDocHed In SalesSplit) then
      Begin

        StockCode:=Pre_PostPayInKey(PayInCode,BInv.RemitNo);

      end;

      With IdR do
      Begin
        If (IDDocHed In ChequeSet) then
        Begin
          If (BCQNo='') then
            Desc:=Get_NextChequeNo(BOn)
          else
            Desc:=BCQNo;
        end
        else
          Desc:=BDesc;

      end; {With..}
    end
    else
    Begin

      IdR.VATCode:=BatchLineR.VATCode;
      IdR.VATIncFlg:=BatchLineR.VATIncFlg;

      Payment:=DocPayType[IdDocHed];

      IdR.NetValue:=InvNetVal;

      If (DiscAmount<>0) then
      Begin

        Discount:=Round_Up(DivWChk(DiscAmount,InvNetVal),2);

        DiscountChr:=PcntChr;

      end;


      VAT:=LineVAT;

      Idr.IncNetValue:=IncNetValue;

      NomCode:=BNomCode;

      Desc:=BDesc;

      Idr.ECService := ECService;
      Idr.ServiceStartDate := ECServiceStartDate;
      Idr.ServiceEndDate := ECServiceEndDate;
    end;
  end; {With..}
end;


{ ============ Procedure to Create Batch Lines =========== }

Procedure Gen_BatchId(Direct      :  Boolean;
                      BatchLineR  :  BatchLineRec;
                      BInv,
                      InvR        :  InvRec);



Const
  Fnum    =  IDetailF;
  Keypath =  IDFolioK;


Begin

  With InvR do
    With Id do
      With BatchLineR do

    Begin
      Batch2Line(Direct,BatchLineR,Id,BInv,InvR);



      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      {$IFDEF PF_On} {* Calling this here is a wate of time as In.Nomsuto is set to false and hence will not get through *}
                     {* Part of the posting routines will explode the job details as well at the posting stage *}

        {If (JbCostOn) and (InvLTotal(Id,BOn,0)<>0) and (StatusOk) and (Not Direct) then
          Update_JobAct(Id,InvR);}
      {$ENDIF}

      If (IDDocHed In DirectSet) and (Not Direct) and (StatusOk) then
        Gen_BatchId(BOn,BatchLineR,BInv,InvR);

    end; {With..}
end; {Proc..}


{ ========== Procedure to Read in Batch Lines ============= }


Procedure Get_BatchId(Var  BatchLineR  :  BatchLineRec;
                           InvR        :  InvRec);


Const
  Fnum    =  IDetailF;
  Keypath =  IDFolioK;


Var
  KeyChk,
  KeyS    :  Str255;

  LineCnt :  LongInt;

  Split   :  Boolean;


Begin
  KeyChk:=FullNomKey(InvR.FolioNum);

  LineCnt:=0;

  Split:=BOff;

  KeyS:=KeyChk;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Split) do
  With Id do
  Begin

    Inc(LineCnt);

    Split:=(LineCnt>1);

    If (Not Split) then
    Begin

      BatchLineR.BDesc:=Desc;

      BatchLineR.BNomCode:=NomCode;

      BatchLineR.VATCode:=VATCode;
      BatchLineR.VATIncFlg:=VATIncFlg;
      BatchLineR.IncNetValue:=IncNetValue;


      BatchLineR.BCCDep:=CCDep;

       BatchLineR.ECService := ECService;
       BatchLineR.ECServiceStartDate := ServiceStartDate;
       BatchLineR.ECServiceEndDate := ServiceEndDate;
    end
    else
      If (LineNo<>RecieptCode) then
      Begin

        BatchLineR.BDesc:='* Full Document *';

        BatchLineR.BNomCode:=0;

        Blank(BatchLineR.BCCDep,Sizeof(BatchLineR.BCCDep));

        BatchLineR.VATCode:=C0;
        BatchLineR.VATIncFlg:=C0;

        BatchLineR.BatchSplit:=BOn;

      end
      else
        BatchLineR.BCQNo:=Desc;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}
end; {Proc..}




{ ============ Procedure to update the Batch balances ============= }

Procedure UpdateBATBal(BatchLineR  :  BatchLineRec;
                   Var InvR        :  InvRec;
                       Mode        :  Byte);

Var
  DocUCnst  :  Integer;

Begin

  With InvR do
    With BatchLineR do
    Begin

      Case Mode of

        0  :  DocUCnst:=1;
        1  :  DocUCnst:=-1;
        else
          DocUCnst := 1;

      end; {Case..}

      DiscTaken:=BOn;


      InvNetVal:=InvNetVal+(NetValue*DocUCnst*DocCnst[BDocHed]*DocNotCnst);

      DiscAmount:=DiscAmount+(STDisc*DocUCnst*DocCnst[BDocHed]*DocNotCnst);

      DiscSetAm:=DiscSetAm+(SettleDisc*DocUCnst*DocCnst[BDocHed]*DocNotCnst*Ord(DiscTake));

      InvVAT:=InvVAT+(LineVAT*DocUCnst*DocCnst[BDocHed]*DocNotCnst);

    end; {With..}

end; {Proc..}



procedure TBEntryLine.ShowLink(InvR      :  InvRec;
                               VOMode    :  Boolean);

Var
  FoundCode  :  Str20;

begin
  ExLocal.AssignFromGlobal(InvF);


  ExLocal.LGetRecAddr(InvF);

  BInv:=InvR;

  Doc2Batch(LBatchLine,ExLocal.LInv);

  Get_BatchId(LBatchLine,ExLocal.LInv);

  Caption:=Pr_OurRef(BInv)+' Transaction Line';

  ExLocal.LViewOnly:=VOMode;

  OutId;


  JustCreated:=BOff;

end;




{ ========== Build runtime view ======== }

procedure TBEntryLine.BuildDesign;


begin


end;



procedure TBEntryLine.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  {* Set Version Specific Info *}
  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}


  Id1CCF.Visible:=Not HideCC;
  Id1DepF.Visible:=Not HideCC;

  CCLab1.Visible:=Id1CCF.Visible;

  Set_DefaultVAT(Id3VATF.Items,BOn,BOff);
  Set_DefaultVAT(Id3VATF.ItemsL,BOn,BOn);

  VATCCLab.Caption:=CCVATName^+VATCCLab.Caption;

  If (Not JBCostOn) then
  Begin
    Id1JCF.Visible:=BOff;
    Id1JAF.Visible:=BOff;
    Id1JCLab.Visible:=BOff;
    Id1JALab.Visible:=BOff;
  end;

  if SyssVat.VatRates.EnableECServices and (LBatchLine.bDocHed in SalesSplit) then
  begin
    chkService.Visible := True;
    chkService.Enabled := True;
    dtServiceStart.Visible := True;
    dtServiceEnd.Visible := True;

    Height := 270;
    SBSPanel1.Height := 197;
  end
  else
  begin
    chkService.Visible := False;
    chkService.Enabled := False;
    dtServiceStart.Visible := False;
    dtServiceEnd.Visible := False;

    Height := 235;
    SBSPanel1.Height := 161;
  end;

  dtServiceStart.Enabled := False;
  dtServiceEnd.Enabled := False;
  OKCp1Btn.Top := SBSPanel1.Top + SBSPanel1.Height + 7;
  CanCp1Btn.Top := OKCp1Btn.Top;
  BuildDesign;

end;




procedure TBEntryLine.FormCreate(Sender: TObject);
begin
  fFrmClosing:=BOff;
  ExLocal.Create;

  JustCreated:=BOn;

  InOutId:=BOff;

  SKeypath:=0;

  LastQtyValue:=0;

  fRecordAuth:=BOff;

  AuthBy:='';

  // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  AcSetDisc := -1;
  AcSetDays := -1;

  ClientHeight:=168;
  ClientWidth:=615;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TBatchEntry) then
    With TBatchEntry(Owner) do
      Self.SetFieldProperties(SBSPanel3,I1BNomF);

  FormDesign;
end;




procedure TBEntryLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=ConfirmQuit;

      If (CanClose) then
        Send_UpdateList(BOff,101);
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;

procedure TBEntryLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TBEntryLine.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TBEntryLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TBEntryLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TBEntryLine.Send_UpdateList(Edit   :  Boolean;
                                   Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



Function TBEntryLine.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TBEntryLine.SetFieldFocus;

Begin
  Id1ACF.SetFocus;

end; {Proc..}


procedure TBEntryLine.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If OkCP1Btn.CanFocus Then
        OkCP1Btn.SetFocus;
      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) Then
      begin
        StoreId(InvF,SKeypath);
      end;
    end
    else
      If (ModalResult=mrCancel) then
      Begin

        Begin
          Close;
          Exit;
        end;
      end;
  end; {With..}
end;



Function TBEntryLine.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(InvF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(InvF,LastRecAddr[InvF]);

                Send_UpdateList(BOff,20);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}



procedure TBEntryLine.SetIdStore(EnabFlag,
                             VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  OkCP1Btn.Enabled:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

end;



{ ============== Display Id Record ============ }

Procedure TBEntryLine.OutId;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

Begin
  InOutId:=BOn;

  With LBatchLine do
  Begin
    Id1ORefF.Text:=SBTRef;
    Id1ACF.Text:=BCustCode;
    Id1DateF.DateValue:=BPDate;
    Id1YRefF.Text:=BYourRef;
    Id1Desc1F.Text:=BDesc;
    Id1NomF.Text:=Form_BInt(BNomCode,0);

    If ExLocal.LGetMainRecPos(NomF,FullNomKey(BNomCode)) then
      Id1Desc2F.Text:=ExLocal.LNom.Desc
    else
      Id1Desc2F.Text:='';

    Id1CCF.Text:=BCCDep[BOn];
    Id1DepF.Text:=BCCDep[BOff];

    If (VATCode In VATSet) then
      Id3VATF.ItemIndex:=GetVATIndex(VATCode);

    Id1VATF.Value:=LineVAT;
    Id1NetF.Value:=NetValue;

    Id1JCF.Text:=BJobCode;
    Id1JAF.Text:=BJobAnal;

    IdTotF.Value:=Calc_BatchLine(LBatchLine);

    EnableECServiceCheckBox;
    chkService.Checked := ECService;
    if ECService then
    begin
      dtServiceStart.DateValue := ECServiceStartDate;
      dtServiceEnd.DateValue := ECServiceEndDate;
    end
    else
    begin
      dtServiceStart.DateValue := BPDate;//FormatDateTime('yyyymmdd', Now);
      dtServiceEnd.DateValue := BPDate;//FormatDateTime('yyyymmdd', Now);
    end;

  end;
  InOutId:=BOff;
end;


procedure TBEntryLine.Form2Id;

Begin

  With LBatchLine do
  Begin
    SBTRef:=Id1ORefF.Text;
    BCustCode:=Id1ACF.Text;
    BPDate:=Id1DateF.DateValue;
    BYourRef:=Id1YRefF.Text;
    BDesc:=Id1Desc1F.Text;
    BNomCode:=IntStr(Id1NomF.Text);

    BCCDep[BOn]:=Id1CCF.Text;
    BCCDep[BOff]:=Id1DepF.Text;

    With Id3VATF do
      If (ItemIndex>-1) then
        VATCode:=Items[ItemIndex][1]
      else
        VATCode:=VATSTDCode;

    LineVAT:=Id1VATF.Value;
    NetValue:=Id1NetF.Value;

    BJobCode:=Id1JCF.Text;
    BJobAnal:=Id1JAF.Text;

    ECService := chkService.Checked;
    if ECService then
    begin
      ECServiceStartDate := dtServiceStart.DateValue;
      ECServiceEndDate := dtServiceEnd.DateValue;
    end
    else
    begin
      ECServiceStartDate := LJVar(' ', 8);
      ECServiceEndDate := LJVar(' ', 8);
    end;
  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TBEntryLine.ProcessId(Fnum,
                                Keypath     :  Integer;
                                Edit        :  Boolean);

Var
  KeyS  :  Str255;


Begin

  Addch:=ResetKey;

  IdStored:=BOff;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  OldConTot:=0;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      If (Not LViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;

      OldConTot:=ConsolITotal(Inv);
    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LInv,LBatchLine do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RunNo:=BatchRunNo;

      InvDocHed:=DocHed;

      TransDate:=BInv.TransDate;

      DueDate:=TransDate;

      ACPr:=BInv.ACPr;
      ACYr:=BInv.ACYr;

      NLineCount:=1;
      ILineCount:=1;

      VATCode:=VATStdCode;

      Currency:=BInv.Currency;

      {$IFDEF MC_On}

        CXrate[BOn]:=SyssCurr^.Currencies[Currency].CRates[BOn];

      {$ELSE}

        CXrate:=SyssCurr^.Currencies[Currency].CRates;

      {$ENDIF}

      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);

      SetTriRec(Syss.VATCurr,UseORate,VATTriR);

      OurRef:=FullDocNum(DocHed,BOff);

      BatchLink:=BInv.OurRef;


      TransNat:=SetTransNat(InvDocHed);

      
      TransMode:=1;

      Doc2Batch(LBatchLine,LInv);

    end;

    LastBL:=LBatchLine;

    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);

  end; {If Abort..}

end; {Proc..}




Function TBEntryLine.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  11;

Type
  PossMsgType  = Array[1..NofMsgs] of String[89];

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  WTrig,
  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  FoundLong
           :  LongInt;

  OrigInv  :  InvRec;


Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:='Account Code is not valid.';
  PossMsg^[3]:='Cost Centre/ Department Code not valid.';
  PossMsg^[4]:='Job Code is not valid.';
  PossMsg^[5]:='Job Analysis Code is not Valid.';
  PossMsg^[6]:='Bank General Ledger Code is not valid.';
  PossMsg^[7]:='An additional check is made via an external hook';
  PossMsg^[8]:='Check Authorisation levels - make this the last one always to avoid the annoyance factor';
  PossMsg^[9]:='Check Authorisation levels - make this the last one always to avoid the annoyance factor';
  PossMsg^[10]:='EC Service Dates must be set.';
  PossMsg^[11]:='The EC Service End Date must not be earlier than the Start Date.';




  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With LBatchLine do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=GetNom(Self,Form_Int(BNomCode,0),FoundLong,-1);

            end;

      2  :  Begin

              Result:=GetCust(Self,BCustCode,Foundcode,BOn,-1);

            end;




      {$IFDEF PF_On}

        3  :  Begin
                Result:=(Not Syss.UseCCDep);

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(Self,BCCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

        4  :  Begin

                Result:=((Not JBCostOn) or (EmptyKey(BJobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJob(Self,BJobCode,FoundCode,-1);

              end;

        5  :  Begin

                Result:=((Not JBCostOn) or (EmptyKey(BJobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJobMisc(Self,BJobAnal,FoundCode,2,-1);

              end;

        6  :  Begin
                Result:=(Not (BDocHed In DirectSet));

                If (Not Result) then
                  Result:=GetNom(Self,TBatchEntry(Owner).I1BNomF.Text,FoundLong,-1);

              end;


        7  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}
                   OrigInv:=ExLocal.LInv;

                   Batch2Doc(LBatchLine,ExLocal.LInv);
                   With ExLocal do
                     Batch2Line(BOff,LBatchLine,LId,BInv,LInv);

                   Result:=ValidExitHook(4000,22,ExLocal);
                   ShowMsg:=BOff;

                   ExLocal.LInv:=OrigInv;
                 {$ENDIF}
              end;

      {$ENDIF}

        8  :   With ExLocal do
               Begin
                 ShowMsg:=BOff;

                 {$IFDEF SY}
                   OrigInv:=LInv;

                   Batch2Doc(LBatchLine,LInv);

                   Result:=Check_UserAuthorisation(Self,LInv,AuthBy);

                   fRecordAuth:=(Result) and (AuthBy<>'');

                   LInv:=OrigInv;
                 {$ELSE}
                   Result:=BOn
                 {$ENDIF}

               end;

      9   : If (LBatchLine.BDocHed In [SIN, SRI]) Then
              With ExLocal do
              Begin
                If (Cust.CustCode <> BCustCode) Then
                  GetCust(Self, BCustCode, Foundcode, BOn, -1);

                OrigInv:=ExLocal.LInv;
                Batch2Doc(LBatchLine, LInv);

                WTrig:=BOff;
                Result := Not Check_AccForCredit(Cust, ConsoliTotal(LInv), OldConTot, BOn, BOn, WTrig, Self);

                LInv := OrigInv;

                ShowMsg:=BOff;
              End; // With ExLocal

      10 :    if LBatchLine.ECService then
              begin
                Result := ValidDate(LBatchLine.ECServiceStartDate) and
                          ValidDate(LBatchLine.ECServiceEndDate);
              end
              else
                Result := True;

      11 :   if LBatchLine.ECService then
               Result := (LBatchLine.ECServiceStartDate <= LBatchLine.ECServiceEndDate)
             else
               Result := True;
    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


procedure TBEntryLine.StoreId(Fnum,
                              Keypath  :  Integer);

Var
  SendFullMsg,
  COk  :  Boolean;

  LastCIS
       :  Double;
  TmpInv
       :  InvRec;

  KeyS :  Str255;

  HMode:  Byte;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';  SendFullMsg:=BOff;  LastCIS:=0.0;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := OKCP1Btn.Enabled;
  CursorState := Cursor;

  OKCP1Btn.Enabled := False;
  try

    HMode:=232;
    Form2Id;

    With ExLocal,LInv,LBatchLine do
    Begin

      COk:=CheckCompleted(LastEdit,BOff);

      If (COk) then
      Begin
        Cursor:=CrHourGlass;

        Calc_BatchVAT(LBatchLine);

        Batch2Doc(LBatchLine,LInv);

        If (Not LastEdit) then {*v5 assign next doc nos here}
          SetNextDocNos(LInv,BOn);

        {$IFDEF NP}

            If (fRecordAuth) then {Add a note entry}
            Begin
              Add_Notes(NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum),Today,
                        LInv.OurRef+' was authorised for floor limit by '+Trim(AuthBy)+'. For '+FormatCurFloat(GenRealMask,ITotal(LInv),BOff,Currency),
                        NLineCount);

              SetHold(HMode,Fnum,Keypath,BOff,LInv);

              AuthAmnt:=ConvCurrITotal(LInv,BOff,BOn,BOn); {Record prev total in base for subsequent authorisation comparison}

            end;
        {$ENDIF}


        If (LastEdit) then
        Begin

          If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
          Begin

            TmpInv:=LInv;

            LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

            Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

            LInv:=TmpInv;

          end;

          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end
        else
        Begin
          Inc(BInv.ILineCount);


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end;

        Report_BError(Fnum,Status);

        If (StatusOk) then
        Begin

          UpdateBatBal(LastBL,BInv,1);

          UpdateBatBal(LBatchLine,BInv,0);

          KeyS:=FullNomKey(LInv.FolioNum);

          DeleteLinks(KeyS,IdetailF,Length(KeyS),IdFolioK,BOff);

          Gen_BatchId(BOff,LBatchLine,BInv,LInv);

          {$IFDEF JC}
              {$B-}
              LastCIS:=LInv.CISTax;
              LInv.ILineCount:=BInv.ILineCount;

              If (Calc_CISTaxInv(LInv,BOn)<>0.0) then
              {$B+}
              Begin
                If (LastCIS<>CISTax) then {* Recalc invoice total *}
                  CalcInvTotals(LInv,ExLocal,Not ManVAT,BOn);

                Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

                Report_BError(Fnum,Status);

                SendFullMsg:=StatusOk;
              end;
          {$ENDIF}
        end;

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        InAddEdit:=Boff;

        If (LastEdit) then
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        SetIdStore(BOff,BOff);

        IdStored:=BOn;

        Send_UpdateList(LastEdit,8);

        {$IFDEF JC}
          If (SendFullMsg) then {Force recalc as CIS added}
            Send_UpdateList(LastEdit,-82);
        {$ENDIF}

        LastValueObj.UpdateAllLastValues(Self);

        Close;
      end
      else
        SetFieldFocus;

    end; {With..}

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  finally
    Cursor := CursorState;
    OKCP1Btn.Enabled := ButtonState;
  end;

end;


procedure TBEntryLine.SetFieldProperties(Panel  :  TSBSPanel;
                                      Field  :  Text8Pt) ;

Var
  n  : Integer;


Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=Field.Color;}
        Color:=Panel.Color;
      end;

  end; {Loop..}


end;


procedure TBEntryLine.EditLine(InvR       :  InvRec;
                           Edit,
                           ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ShowLink(InvR,ViewOnly);

    ProcessId(InvF,InvBatchK,LastEdit);
  end;
end;






procedure TBEntryLine.Id1NomFExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn)  then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);

        Id1Desc2F.Text:=Nom.Desc;

      end;


      If (FoundOk) then
      With ExLocal,LId do
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);


      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;




procedure TBEntryLine.Id1CCFExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (Syss.UseCCDep) then
      Begin

        // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
        // For Job Costing, allow the user to pass through the Cost Centre and
        // Department fields without selecting anything, but if they have
        // entered values, do the normal validation.
        if (FoundCode <> '') or (not Id1JCF.Visible) then
        begin
          StillEdit:=BOn;

          FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

          If (FoundOk) then {* Credit Check *}
          With ExLocal do
          Begin

            AssignFromGlobal(PWrdF);

          end;


          If (FoundOk) then
          Begin

            StillEdit:=BOff;

            Text:=FoundCode;


          end
          else
          Begin

            SetFocus;
          end; {If not found..}
        end;
      end;

    end; {with..}
  {$ENDIF}
end;





procedure TBEntryLine.Id1JCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,4));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          AssignFromGlobal(JobF);

          Text:=FoundCode;

          If (DocHed In PurchSplit-[PPY]) and (JBCostOn) and (Not StopPageChange) then {* Set Nominal Code *}
          With LBatchLine do
          Begin
            Form2Id;
            BNomCode:=Job_WIPNom(BNomCode,BJobCode,BJobAnal,'','',BCustCode);
            OutId;
          end;
          // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
          if JBCostOn then
            ApplyJobCCDeptRules(FoundCode);

        end
        else
        Begin

          SetFocus;
        end; {If not found..}

      end
      else
        If (FoundCode='') then {* Reset Janal code *}
          Id1JAF.Text:='';

    end;
  {$ENDIF}
end;



procedure TBEntryLine.Id1JAFExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(Id1JCF.Text,JobCodeLen))) and (ActiveControl<>CanCP1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,Anal_FiltMode(ExLocal.LInv.InvDocHed)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;


          If (DocHed In PurchSplit-[PPY]) and (JBCostOn) and (Not StopPageChange) then {* Set Nominal Code *}
          With LBatchLine do
          Begin
            Form2Id;
            BNomCode:=Job_WIPNom(BNomCode,BJobCode,BJobAnal,'','',BCustCode);
            OutId;
          end;

        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;





procedure TBEntryLine.Id1ACFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;
  OrigInv    :  InvRec;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self.Owner,FoundCode,FoundCode,(DocHed In SalesSplit),3));


      If (FoundOk) then
      With ExLocal,LBatchLine do
      Begin

        StillEdit:=BOff;


        ExLocal.AssignFromGlobal(CustF);

        Send_UpdateList(BOff,31);

        If (Not LastEdit) and (BNomCode=0) then
        Begin
          VATCode:=LCust.VATCode;
          VATIncFlg:=LCust.CVATIncFlg;

          BCustSupp:=LCust.CustSupp;

          {BCCDep[BOff]:=LCust.CustDep; v4.32 method
          BCCDep[BOn]:=LCust.CustCC;}

          With LCust do
            BCCDep:=GetCustProfileCCDep(CustCC,CustDep,BCCDep,0);

          // MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
          AcSetDisc := Pcnt(LCust.DefSetDisc);
          AcSetDays := LCust.DefSetDDays;
          If SettlementDiscountSupportedForDate(Id1DateF.DateValue) Then
          Begin
            SetDisc := AcSetDisc;
            SetDays := AcSetDays;
          End; // If SettlementDiscountSupportedForDate(Id1DateF.DateValue)

          BTransMode:=Cust.SSDModeTr;
          BDelTerms:=Cust.SSDDelTerms;        
          OutId;
        end;
 		    //HV 08/02/2016 2016-R1 ABSEXCH-16209: While change the account code it doesn't bring in the customer defaults GL Code properly
        BNomCode:=LCust.DefNomCode;
        If (BNomCode=0) then
          BNomCode:=LCust.DefCOSNom;
        Id1NomF.Text:=Form_BInt(BNomCode,0);

        Text:=FoundCode;

        BCtrlNom:=LCust.DefCtrlNom;

        SendToObjectCC(FoundCode,0);
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

    {$IFDEF CU} {* Call notification hook regardless of edit state *}
      OrigInv:=ExLocal.LInv;

      Batch2Doc(LBatchLine,ExLocal.LInv);

      With ExLocal do
        Batch2Line(BOff,LBatchLine,LId,BInv,LInv);

      GenHooks(2000,101,ExLocal);

      ExLocal.LInv:=OrigInv;
    {$ENDIF}


  end; {with..}
end;




procedure TBEntryLine.Id1YRefFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is Text8pt) and (Syss.WarnYRef) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    Modified:=BOff;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) then
    Begin

      FoundOk:=(Not Check4DupliYRef(LJVar(FoundCode,DocYref1Len),FullCustCode(Id1AcF.Text),InvF,InvYrRefK,ExLocal.LInv,'Reference ('+FoundCode+') for this account'));

    end;
  end; {With..}
end;

procedure TBEntryLine.Id1VATFExit(Sender: TObject);
begin
  Form2Id;

  OutId;
end;

procedure TBEntryLine.Id3VATFChange(Sender: TObject);
begin
  If (Id3VATF.Modified) or (Id1VatF.Value=0) and (Not InOutId) then
  Begin
    Form2Id;

    {$IFDEF VAT}
      With LBatchLine do
      If (VATCode=VATICode) then
        With TSBSComboBox(Sender) do
          GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)),Color,Font,Self.Parent,ExLocal.LViewOnly,VATIncFlg);
    {$ENDIF}

    Calc_BatchVAT(LBatchLine);
    OutId;
  end;
end;

procedure TBEntryLine.SetHelpContextIDs;
// NF: 25/07/06 Fix for incorrect Context IDs
begin
  if (DocHed In SalesSplit) then
  begin
    Id1ACF.HelpContext := 7091;
    Id1DateF.HelpContext := 7092;
  end else
  begin
    Id1ACF.HelpContext := 2091;
    Id1DateF.HelpContext := 2092;
  end;{if}
end;

// MHYR 25/10/07
procedure TBEntryLine.Id1YRefFChange(Sender: TObject);
begin
  Id1YRefF.Hint := Id1YRefF.Text;
end;

procedure TBEntryLine.chkServiceClick(Sender: TObject);
begin
  dtServiceStart.Enabled := chkService.Checked;
  dtServiceEnd.Enabled := chkService.Checked;

  dtServiceStart.Color := IfThen(dtServiceStart.Enabled, Id1NetF.Color, clBtnFace);
  dtServiceStart.Font.Color := IfThen(dtServiceStart.Enabled, Id1NetF.Font.Color, clBtnShadow);
  dtServiceStart.Visible := False; dtServiceStart.Visible := True;

  lblServiceTo.Font.Color := Label86.Font.Color;

  dtServiceEnd.Font.Color := dtServiceStart.Font.Color;
  dtServiceEnd.Color := dtServiceStart.Color;
  dtServiceEnd.Visible := False; dtServiceEnd.Visible := True;
end;

procedure TBEntryLine.EnableECServiceCheckBox;
begin
  chkService.Enabled := (LBatchLine.BDocHed in SalesSplit) and (LBatchLine.VATCode = 'D');
  chkService.Font.Color := IfThen(chkService.Enabled, Label86.Font.Color, clBtnShadow);
  chkServiceClick(Self);
end;

procedure TBEntryLine.Id1DateFExit(Sender: TObject);
begin
  If (Not chkService.Checked) Then
  Begin
    dtServiceStart.DateValue := Id1DateF.DateValue;
    dtServiceEnd.DateValue := Id1DateF.DateValue;
  End; // If (Not chkService.Checked)

  // MH 20/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  If (Not SettlementDiscountSupportedForDate (Id1DateF.DateValue)) And
     ((LBatchLine.SetDisc <> 0.0) Or (LBatchLine.SetDays <> 0)) Then
  Begin
    // Remove settlement discount and update totals
    Form2Id;
    LBatchLine.SetDisc := 0.0;
    LBatchLine.SetDays := 0;
    Calc_BatchVAT(LBatchLine);
    OutId;
  End // If (Not SettlementDiscountSupportedForDate (...
  Else
    // Check to see if Settlement Discount needs to be re-instated
    If SettlementDiscountSupportedForDate (Id1DateF.DateValue) And
       ((LBatchLine.SetDisc = 0.0) Or (LBatchLine.SetDays = 0)) And
       ((AcSetDisc > 0.0) Or (AcSetDays > 0)) Then
    Begin
      Form2Id;
      LBatchLine.SetDisc := AcSetDisc;
      LBatchLine.SetDays := AcSetDays;
      Calc_BatchVAT(LBatchLine);
      OutId;
    End; // If SettlementDiscountSupportedForDate (...
end;

// CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
procedure TBEntryLine.ApplyJobCCDeptRules(JobCode: string);
var
  JobCCDept: CCDepType;
  OriginalCCDept: CCDepType;
  ReplacementCCDept: CCDepType;
begin
  JobUtils.GetJobCCDept(JobCode, JobCCDept);

  OriginalCCDept[True] := Id1CCF.Text;
  OriginalCCDept[False] := Id1DepF.Text;

  // Get the default Cost Centre/Department for the Job.
  ReplacementCCDept := GetCustProfileCCDepEx(ExLocal.LCust.CustCC, ExLocal.LCust.CustDep, OriginalCCDept, JobCCDept, 1);

  // Update Cost Centre
  Id1CCF.Text := ReplacementCCDept[True];
  // Update Department
  Id1DepF.Text := ReplacementCCDept[False];
end;

Initialization


end.
