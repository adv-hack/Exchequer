unit CustSupU;



interface

{$I DEFOVR.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VarConst,BtrvU2,BTSupU1,ExWrap1U, BorBtns,SupListU,

  VarSortV,
  SortCust,

  Recon3U,
  ExtGetU,
  SBSComp;

const
  PPD_EXPIRY_COL = 10;



type
  TCLMList  =  Class(TDDMList)
  private
    function GetSortView: TCustomerLedgerSortView;
    procedure SetSortView(const Value: TCustomerLedgerSortView);
  Public

    TSales,
    TCost,
    TProfit  :  Real;

    CusExtRecPtr       :  ExtCusRecPtr;

    CusExtObjPtr       :  GetNomMode;



    LNHCtrl  :  TNHCtrlRec;

    ViewingAuto
             :  Boolean;

    Procedure ExtObjCreate; Override;

    Procedure ExtObjDestroy; Override;

    Function ExtFilter  :  Boolean; Override;

    Function GetExtList(B_End      :  Integer;
                    Var KeyS       :  Str255)  :  Integer; Override;



    Function SetCheckKey  :  Str255; Override;

    Function CheckRowEmph :  Byte; Override;

    {$IFDEF SOP}
      Function GetCustOFilt(RStr  :  Str255;

                            InvR  :  InvRec)  :  Str255;
    {$ENDIF}

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLedg(Col  :  Byte)  :  Str255;

    {$IFDEF STK}

      Function OutOrd(Col  :  Byte)  :  Str255;


      {$IFDEF RET}
        Function OutRET(Col  :  Byte)  :  Str255;
      {$ENDIF}

    {$ENDIF}

    {$IFDEF JAP}
      Function OutJAP(Col  :  Byte)  :  Str255;
    {$ENDIF}

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Function FindxCode(KeyChk  :  Str255;
                       SM      :  SmallInt)  :  Boolean;


    {$IFDEF MC_On}

      Procedure Set_CurrencyFilt;

    {$ENDIF}

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SortViewType(Value: Integer);

    procedure ModifyCell(Col, Row: Integer; var CellDetails: TCellDetails); override;
    property SortView: TCustomerLedgerSortView read GetSortView write SetSortView;

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  {$IFDEF RET}
    RetSup1U,
  {$ENDIF}
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvFSu3U,
  SysU1,
  SysU2,
  DocSupU1,
  PWarnU,
  CustLedg,
  SalTxl1U,
  StrUtils,

  //PR: 08/05/2015 ABSEXCH-16284 v7.0.14 T2-121
  oSystemSetup, PromptPaymentDiscountFuncs;




{ ============== TCLMList Methods =============== }


constructor TCLMList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SortView := TCustomerLedgerSortView.Create(True);
end;

destructor TCLMList.Destroy;
begin
  FreeAndNil(FSortView);
  inherited Destroy;
end;

function TCLMList.GetSortView: TCustomerLedgerSortView;
begin
  Result := FSortView as TCustomerLedgerSortView;
end;

procedure TCLMList.SortViewType(Value: Integer);
begin
  if (Value = 0) then
  begin
    FSortView.ListType := svltCustLedger;
    FSortView.ListDesc := 'Customer Ledger List';
  end
  else if (Value = 1) then
  begin
    FSortView.ListType := svltSuppLedger;
    FSortView.ListDesc := 'Supplier Ledger List';
  end;
end;

procedure TCLMList.SetSortView(const Value: TCustomerLedgerSortView);
begin
  inherited SetSortView(Value);
end;

procedure TCLMList.ExtObjCreate;

Begin
  Inherited;

  CusExtRecPtr:=nil;
  CusExtObjPtr:=nil;

  ViewingAuto:=BOff;

  If (LNHCtrl.NHNeedGExt) then
  Begin
    New(CusExtRecPtr);

    FillChar(CusExtRecPtr^,Sizeof(CusExtRecPtr^),0);

    New(CusExtObjPtr,Init);

    ExtRecPtr:=CusExtRecPtr;
    ExtObjPtr:=CusExtObjPtr;
  end;
end;

procedure TCLMList.ExtObjDestroy;

Begin
  If (CusExtRecPtr<>nil) then
    Dispose(CusExtRecPtr);

  If (CusExtObjPtr<>nil) then
    Dispose(CusExtObjPtr,Done);

  Inherited;

  CusExtRecPtr:=nil;
  CusExtObjPtr:=nil;

end;


Function TCLMList.ExtFilter  :  Boolean;

Var
  TmpBo      :  Boolean;
  CtrlCode   :  LongInt;
  

Begin
  With CusExtRecPtr^ do
  Begin
    Case FMode of

        3,4
           :  Begin

                TmpBo:=((Inv.NomAuto=FNomAuto) and ((FCr=Inv.Currency) or (FCr=0)) and ((Inv.AllocStat=FAlCode) or (FMode=4)));

                {* Check also eventualy for hold modes, if on hold ignore?. Authorised only *}

                TmpBo:=((TmpBo) and (((Autho_Doc(Inv) and ((Not OnHold(Inv.HoldFlg)) or (GetHoldType(Inv.HoldFlg)=HoldA))) or (FMode=4))));  {* Check if Authorised *}

                {* Check if being edited at present *}

                {.$IFNDEF JC}

                  If (TmpBo) then {* Check if in list of currently edited documents *}
                    TmpBo:=(Found_DocEditNow(Inv.FolioNum)=0);

                  If (TmpBo) and (FCheckLI) then
                    TmpBo:=(Inv.FolioNum<=FLastInv);

                {.$ENDIF}

                If (TmpBo) and (FMode=4) then
                  TmpBo:=((Inv.AllocStat=FAlCode) or (Inv.UntilDate>=FAlDate));

                If (TmpBo) and (FCtrlNom<>0) and (FMode<>4) then
                Begin
                  If (((Inv.InvDocHed In SalesSplit) and (FCtrlNom=Syss.NomCtrlCodes[Debtors]))
                    or  ((Inv.InvDocHed In PurchSplit) and (FCtrlNom=Syss.NomCtrlCodes[Creditors])))
                    and (Inv.CtrlNom=0) then
                      CtrlCode:=FCtrlNom
                    else
                      CtrlCode:=Inv.CtrlNom;

                  TmpBo:=(CtrlCode=FCtrlNom);
                end;


              end;

        else  Begin

                TmpBo:=((FYr=Inv.AcYr) and ((FPr=Inv.AcPr) or (FPr In [YTD,YTDNCF])) and (Inv.NomAuto=FNomAuto));

                If (FMode=2) then
                  TmpBo:=((TmpBo) and (FCr=Inv.Currency));

              end;
      end; {Case..}

  end;

  Result:=TmpBo;

end;

Function  TCLMList.GetExtList(B_End      :  Integer;
                          Var KeyS       :  Str255)  :  Integer;

Var
  TmpStat   :  Integer;


Begin

  TmpStat:=0;

  Begin

    With CusExtRecPtr^ do
    Begin

      If (B_End In [B_GetPrev,B_GetNext]) and (CusExtObjPtr<>nil) then
      Begin

        DispExtMsg(BOn);

        TmpStat:=CusExtObjPtr^.GetSearchRec3(B_End+30,ScanFileNum,KeyPath,KeyS,FCusCode,FNomAuto,FAlCode,FAlDate,FCr,FYr,FPr,FMode);

        DispExtMsg(BOff);

      end
      else

        TmpStat:=Find_Rec(B_End,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);

    end;{With..}

  end; {With..}

  Result:=TmpStat;

end; {Func..}




Function TCLMList.SetCheckKey  :  Str255;


Var

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);


  if SortView.Enabled then
    DumStr := SortTempRec.svtField1 + SortTempRec.svtField2 + FullNomKey(SortTempRec.svtFolio)
  else
    Case DisplayMode of

      3  :

      else  With Inv do
              Case Keypath of
                InvOSK  :  Begin
                             DumStr:=AllocStat+FullCustCode(CustCode);

                             If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                               DumStr:=DumStr+NdxWeight;
                           end;
                else       Begin
                             If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                               DumStr:=FullCustType(CustCode,CustSupp)+NdxWeight
                             else
                               DumStr:=FullLedgerKey(CustCode,CustSupp,NomAuto);
                           end;
              end; {case..}

    end; {Case..}

  SetCheckKey:=DumStr;
end;

Function TCLMList.CheckRowEmph :  Byte;

Var
  ChkRecon  :  Byte;

Begin
  Result:=0;

  Case DisplayMode of
    9  :  Result:=Ord(Not Inv.PDiscTaken);

    {$IFDEF RET}
      10  :  Result:=Ord((Inv.RunNo=PRNUPRunNo) or (Inv.RunNo=SRNUPRunNo));
    {$ENDIF}

  end {Case..}

end;



  {$IFDEF SOP}
    Function TCLMList.GetCustOFilt(RStr  :  Str255;
                                   InvR  :  InvRec)  :  Str255;

    Begin
      Result:=RStr;

      With InvR do
      Case FilterMode of {Live Orders}
        1  :  If (Not (InvDocHed In StkAllSet+StkOrdSet)) or ((RunNo<>OrdUSRunNo) and (RunNo<>OrdUPRunNo)) then
                Result:=NdxWeight;

                {Orders }
        2  :  If (Not (InvDocHed In StkAllSet+StkOrdSet)) then
                Result:=NdxWeight;
                {Orders}
        3  :  If (Not (InvDocHed In DeliverSet)) then
                Result:=NdxWeight;

        4  :  Begin
                FilterMode:=0;
                Filter[1,1]:=#0;
              end;

      end; {Case..}

    end;


{$ENDIF}


Function TCLMList.SetFilter  :  Str255;

Begin
  Result:=Chr(Inv.Currency);

  {$IFDEF SOP}
    If (FilterMode<>0) then
      Result:=GetCustOFilt(Result,Inv);

  {$ENDIF}

  {$IFDEF JAP}
    If (DisplayMode=9) and (Not (Inv.InvDocHed In JAPJAPSplit)) then
      Result:=NdxWeight;

  {$ENDIF}
end;


Function TCLMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TCLMList.OutLedg(Col  :  Byte)  :  Str255;

{
Var

  GenStr :  Str255;

  UOR,
  n,
  TCr    :  Byte;

  Rnum   :  Real;

  ExLocal: ^TdExLocal;
}
Begin
  Result := CustLedg.LedgerColumn(ListLocal, LNHCtrl, DisplayMode, Col);

(*
  UOR:=0;

  ExLocal:=ListLocal;


   With ExLocal^,LNHCtrl,Inv do
   Begin
     Case Col of

       0  :  OutLedg:=Pr_OurRef(Inv);

       1  :  If (NomAuto) then
               OutLedg:=POutDate(TransDate)
             else
               OutLedg:=Pr_AutoDue(Inv);


       2  :  Begin
               Case DisplayMode of

                 0  :  Begin

                         If (NHCr=0) then
                           Rnum:=Settled
                         else
                           Rnum:=CurrSettled;


                       end;

                 6  :  Begin
                         TSales:=ITotal(Inv)-InvVAT;

                         If (NHCr=0) then
                         Begin
                           UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                           TSales:=Conv_TCurr(TSales,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                         end;

                         Rnum:=(TSales*DocCnst[InvDocHed]*DocNotCnst);
                       end;

               end; {Case..}


               OutLedg:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);
             end;

       3  :  Begin
               Case DisplayMode of
                 0  :  Begin
                         If (NHCr=0) then
                           Rnum:=BaseTotalOs(Inv)
                         else
                           Rnum:=CurrencyOS(Inv,BOn,BOff,BOff);
                       end;

                 6  :  Begin
                         If (InvDocHed In SalesSplit-RecieptSet) and (Show_CMG(InvDocHed)) then
                           TCost:=TotalCost
                         else
                           TCost:=0;

                         If (NHCr=0) then
                         Begin
                           UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                           TCost:=Conv_TCurr(TCost,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                         end;

                         Rnum:=(TCost*DocCnst[InvDocHed]*DocNotCnst);
                       end;

               end; {Case..}

               OutLedg:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);

             end;


       4  :  Begin
               TCr:=NHCr;

               Case DisplayMode of
                 0  :  Begin
                         If (NHCr<>0) then
                           TCr:=0;

                         Rnum:=(ConvCurrItotal(Inv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst);
                       end;
                 6  :  Begin
                         If (InvDocHed In SalesSplit-RecieptSet) and (Show_CMG(InvDocHed))  then
                         Begin
                           TProfit:=TSales-TCost;

                           Rnum:=TProfit;

                         end
                         else
                           Rnum:=0;

                       end;
               end; {Case..}

               OutLedg:=FormatCurFloat(GenRealMask,Rnum,BOff,TCr);

             end;

       5  :  Begin
               Case DisplayMode of
                 0  :  Begin
                         Rnum:=(Itotal(Inv)*DocCnst[InvDocHed]*DocNotCnst);
                         OutLedg:=FormatCurFloat(GenRealMask,Rnum,BOff,Currency);
                       end;
                 6  :  Begin
                         If (InvDocHed In SalesSplit-RecieptSet) and (Show_CMG(InvDocHed))  then
                           Rnum:=Calc_Pcnt(TSales,TProfit)
                         else
                           Rnum:=0;

                         OutLedg:=FormatFloat(GenPcntMask,Rnum);

                       end;

               end; {Case..}

             end;

       6  :  If (Not SWInfoSOn) then
               Result:=dbFormatSlash(YourRef,TransDesc)
             else
               Result:=TransDesc;


       7  :  OutLedg:=POutDate(DueDate);

       8  :  Begin
               Result:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,BOff,OnPickRun);

               n:=0+(1*Ord((DiscSetAm<>0)))+(1*Ord((DiscTaken=True) or (PDiscTaken=True)));

               If (n>=Low(DiscStatus)) and (n<=High(DiscStatus)) then
                 GenStr:=DiscStatus[n]
               else
                 Genstr:='';

               If (Trim(GenStr)<>'') then
                 Result:=GenStr+' ! '+Result;

             end;

       else
             OutLedg:='';
     end; {Case..}


   end; {With..}
*)
end;




{ ========== Generic Function to Return Formatted Display for List ======= }

{$IFDEF STK}

  Function TCLMList.OutOrd(Col  :  Byte)  :  Str255;
  const
    discountStatus : Array[0..2] of string[3] = ('   ','SDA','SDT');
  Var
    ExLocal : ^TdExLocal;
    Rnum2, Rnum : Real;
    GenStr : Str255;
    DrCr : DrCrType;
    UOR : Byte;
  Begin

    ExLocal:=ListLocal;

    UOR:=0;  Rnum:=0.0;

     With ExLocal^,LNHCtrl,Inv do
     Begin
       Case Col of

         0  :  OutOrd:=OurRef;
         1  :  OutOrd:=POutDate(TransDate);
         2  :  Begin
                 Case DisplayMode of

                   7  :  Begin
                           TSales:=ITotal(Inv)-InvVAT;

                           If (FilterMode<>1) then
                             Rnum2:=TSales
                           else
                             Rnum2:=TotOrdOS;

                           If (NHCr=0) then
                           Begin
                             UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                             Rnum2:=Conv_TCurr(Rnum2,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                             TSales:=Conv_TCurr(TSales,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                           end;

                           Rnum:=(Rnum2*DocCnst[InvDocHed]*DocNotCnst);
                         end;

                   8  :  If PChkAllowed_In(143) then
                           Rnum:=TotalCost
                         else
                           Rnum:=0.0;

                 end; {Case..}


                 OutOrd:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);
               end;

         3  :  Begin
                 If (InvDocHed In SalesSplit-RecieptSet) and (PChkAllowed_In(143)) then
                 Begin
                   TCost:=TotalCost+TotalCost2;

                   If (NHCr=0) then
                   Begin
                     UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                     TCost:=Conv_TCurr(TCost,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                   end;

                   TProfit:=TSales-TCost;
                 end
                 else
                 Begin
                   TCost:=0;
                   TProfit:=0;
                 end;


                 Case DisplayMode of
                   7  :  Begin
                           If (InvDocHed In SalesSplit-RecieptSet) and (PChkAllowed_In(143)) then
                             Rnum:=Calc_Pcnt(TSales,TProfit)
                           else
                             Rnum:=0;

                           OutOrd:=FormatFloat(GenPcntMask,Rnum);

                         end;
                   8  :  Begin
                           Rnum:=Calc_Pcnt(TotalCost,TotalInvoiced);

                           OutOrd:=FormatFloat(GenPcntMask,Rnum);

                         end;

                 end; {Case..}

               end;

         4  :  Begin
                 //TW 11/08/2011: Changed to use a 3 string array with revised values
                 //               part of ABSEXCH-10697.
                 // MH 24/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
                 GenStr := discountStatus[ 0 +
                                          (1 * Ord((DiscSetAm <> 0) Or (thPPDGoodsValue <> 0.0) Or (thPPDVATValue <> 0.0))) +
                                          // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                                          (1 * Ord(DiscTaken Or (thPPDTaken <> ptPPDNotTaken)))];

                 if (HoldFlg > 0) then
                 begin
                   if(GenStr <> '   ') then
                     GenStr := GenStr + '/' + DisplayHold(HoldFlg)
                   else
                     GenStr := DisplayHold(HoldFlg);
                 end;
                 Result:=GenStr;
               end;
         5  :  Begin
                 Case DisplayMode of
                   7  :  Begin
                           Rnum:=TProfit;
                         end;
                 end; {Case..}

                 OutOrd:=FormatCurFloat(GenRealMask,Rnum,BOff,NHCr);
               end;

         6  :  Begin
                 Case DisplayMode of
                   7  :  Begin

                           Rnum:=(TCost*DocCnst[InvDocHed]*DocNotCnst);
                         end;

                 end; {Case..}

                 OutOrd:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);

               end;



         else
               OutOrd:='';
       end; {Case..}


     end; {With..}
  end;




{$ENDIF}


{ ========== Generic Function to Return Formatted Display for List ======= }

{$IFDEF JAP}

  Function TCLMList.OutJAP(Col  :  Byte)  :  Str255;


  Var
    UOR    :  Byte;

    GenStr :  Str255;

    DrCr   :  DrCrType;

    Rnum2,
    Rnum   :  Real;

    ExLocal: ^TdExLocal;

  Begin

    ExLocal:=ListLocal;

    UOR:=0;  Rnum:=0.0;

     With ExLocal^,LNHCtrl,Inv do
     Begin
       Case Col of

         0  :  Result:=OurRef;
         1  :  Result:=POutDate(TransDate);
         2  :  Begin
                 Case DisplayMode of

                   9  :  Begin
                           Rnum:=(Round_Up(TotalCost,2));


                           If (NHCr=0) then
                           Begin
                             UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                             Rnum:=Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                           end;
                         end;


                 end; {Case..}


                 Result:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);
               end;


         3  :  Result:=DJobCode;

         5  :  Begin
                 Rnum:=(Round_Up(InvNetVal,2));

                 If (NHCr=0) then
                 Begin
                   UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                   Rnum:=Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                 end;

                 Result:=FormatCurFloat(GenRealMask,Rnum,(DisplayMode=0),NHCr);
               end;


         6  :  Begin
                  Result:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,PDiscTaken,BOff);

               end;



         else
               Result:='';
       end; {Case..}


     end; {With..}
  end;

{$ENDIF}


{ ========== Generic Function to Return Formatted Display for List ======= }

{$IFDEF RET}

  Function TCLMList.OutRET(Col  :  Byte)  :  Str255;

  Const
    GenPcnt0Mask   =  ' #0%;-#0%';


  Var
    UOR    :  Byte;

    GenStr :  Str255;

    DrCr   :  DrCrType;

    Rnum2,
    Rnum   :  Real;

    Dnum   :  Double;

    ExLocal: ^TdExLocal;

    RetStr :  TStrings;

  Begin

    ExLocal:=ListLocal;

    UOR:=0;  Rnum:=0.0;

     With ExLocal^,LNHCtrl,Inv do
     Begin
       Case Col of

         0  :  Result:=OurRef;
         1  :  Result:=POutDate(TransDate);
         2  :  Begin
                 If (PChkAllowed_In(143)) then
                 Begin
                   Dnum:=Itotal(Inv)-InvVAT-DocLSplit[6];
                 end
                 else
                   Dnum:=0.0;

                 
                 Result:=FormatCurFloat(GenRealMask,Dnum,BOff,Currency);

               end;


         

         3  :  Begin
                 Result:=FormatFloat(GenPcnt0Mask,(Round(DivWChk(Round_Up(DocLSplit[3]+DocLSplit[4],2),Round_Up(DocLSplit[1],2))*100)));
               end;

         5  :  Result:=TransDesc;

         6  :  Begin
                 Result:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,PDiscTaken,BOff);

                 If (TransMode>0) then
                 Begin
                   If (Result<>'') then
                     Result:=Result+'/';

                   RetStr:=TStringList.Create;

                   Try
                     Set_DefaultRetStat(RetStr,(InvDocHed In StkRetSalesSplit),BOff);

                     If (TransMode<RetStr.Count) then
                       Result:=Result+RetStr.Strings[TransMode];
                   finally
                     RetStr.Free;
                   end;{Try..}
                 end;
               end;



         else
               Result:='';
       end; {Case..}


     end; {With..}
  end;

{$ENDIF}


Function TCLMList.OutLine(Col  :  Byte)  :  Str255;

Begin
  Case DisplayMode of
    0,6  :  Result:=OutLedg(Col);

    {$IFDEF STK}
      7,8  :  Result:=OutOrd(Col);
    {$ENDIF}

    {$IFDEF JAP}
      9  :  Result:=OutJAP(Col);
    {$ENDIF}

    {$IFDEF RET}
      10  :  Result:=OutRet(Col);
    {$ENDIF}


  end; {Case..}
end;


Function TCLMList.FindxCode(KeyChk  :  Str255;
                            SM      :  SmallInt)  :  Boolean;

Const
  OFnum     =  InvF;

Var
  OKeyS     :  Str255;
  OKeypath  :  Integer;

Begin
  OKeypath:=InvOurRefK;
  OKeyS:=KeyChk;

  Case SM of
    5  :  OKeypath:=InvOurRefK;
  end; {case..}

  Status:=Find_Rec(B_GetGEq,F[OFnum],OFnum,RecPtr[OFnum]^,OKeyPath,OKeyS);

  If (Status=0) and (CheckKey(KeyChk,OKeyS,Length(KeyChk),BOff)) and (LineOk(SetCheckKey)) then
  Begin
    Result:=BOn;
    if SortViewEnabled then
    begin
      SortView.SyncTemp;
      Status:=GetPos(F[SortTempF],SortTempF,PageKeys^[0]);
      KeyRef := '';
    end
    else
      Status:=GetPos(F[OFnum],OFnum,PageKeys^[0]);

    MUListBoxes[0].Row:=0;
    PageUpDn(0,BOn);
  end
  else
    Result:=BOff;

end;


{$IFDEF MC_On}

  Procedure TCLMList.Set_CurrencyFilt;

  Var
    ThisLine  :  Integer;

  Begin
    With LNHCtrl do
    Begin
      If (NHCr=0) then
        Filter[1,0]:=''
      else
        Filter[1,0]:=Chr(NHCr);

      PageUpDn(0,BOn);

      If (PageKeys^[0]=0) then
        InitPage;

    end;
  end;

{$ENDIF}

//PR: 07/05/2015 ABSEXCH-16284 T2-121 Event handler to colour cell for PPD Expiry date
procedure TCLMList.ModifyCell(Col, Row: Integer;
  var CellDetails: TCellDetails);
var
  DaysLeftBeforeExpiry : Integer;
  ExpiryDate : string;
begin
  inherited;

  //Only bother if it's the correct column
  if Col = PPD_EXPIRY_COL then
  begin
    //Check if we've got a date. also need to remove separators in order to use Date2Store function
    ExpiryDate := AnsiReplaceStr(CellDetails.Contents, '/', '');
    if Trim(ExpiryDate) <> '' then
    begin
      // MH 20/05/2015 v7.0.14 ABSEXCH-16443: Don't colour code non-date fields
      ExpiryDate := Date2Store(ExpiryDate);
      If (ExpiryDate <> '00000000') Then
      Begin
        //How many days left?
        DaysLeftBeforeExpiry := NoDays(EtDateU.Today, ExpiryDate);

        //Set colours appropriately
        SetPPDColours(DaysLeftBeforeExpiry, CellDetails.TextColour, CellDetails.BackColour, CellDetails.Font);
      End; // If (ExpiryDate <> '00000000')
    end;  //if Trim(ExpiryDate) <> ''
  end;  // if Col = PPD_EXPIRY_COL
end;

end.
