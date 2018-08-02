unit AllocS1U;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1,ExWrap1U;


  Type

    ODDType  =  Record

                  NKeypath,
                  NLKeypath,
                  NLFnum,
                  NFnum    :   Integer;
                  NRecAddr :   LongInt;
                  NLKey,
                  NKey     :  Str255;
                  NCustSupp:  Char;
                  NNeedData:  Boolean;
                  NMiscMode:  Byte;
                  NOurRef  :  Str10;
                  NValue   :  Double;
                end; {Rec..}


Function AllocCtrlKey1(SPMode  :  Boolean;
                       CCode   :  Str10) :  Str20;

Function AllocCtrlKey2(SPMode  :  Boolean;
                       CCode   :  Str10) :  Str20;

Procedure Init_AllocCtrlUser(Var AllocCtrlRec  :  MLocRec);

Procedure Init_AllocCtrl(Var AllocCtrlRec  :  MLocRec);

Function Alloc_CtrlGet(SPMode     :  Boolean;
                       CCode      :  Str10;
                   Var AllocCtrlRec
                                  :  MLocRec;
                       MTExLocal  :  TdMTExLocalPtr;
                       GetMode    :  Byte)  :  Boolean;

Procedure Alloc_CtrlPut(Fnum,
                        Keypath      :  Integer;
                    Var AllocCtrlRec :  MLocRec;
                        MTExLocal    :  TdMTExLocalPtr;
                        PutMode      :  Byte);

Procedure AllocForceInvSDisc(Var  InvR, EInv  :  InvRec;
                                  AllocCtrl   :  MLocRec;
                                  Mode        :  Byte);

Procedure UpdateAllocCRec(OldAR,
                          NewAR  :  MiscRec;
                      Var AllocCtrl  :  MLocRec;
                          MTExLocal  :  TdMTExLocalPtr);

Function Calc_arcUnallocated(AllocCtrl  :  MLocRec;
                             UseOwn     :  Boolean)  :  Double;

Function SanityCheckAllocS(NewAR  :  MiscRec;
                           EInv   :  InvRec)  :  Byte;

Function Sanity_Reason(SR  :  Byte)  :  Str255;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  BTSFrmU1,
  ComnUnit,
  ComnU2,
  CurrncyU,
  Event1U,
  SysU1,
  SysU2,
  BPyItemU,
  PassWR2U;




{ ======== Function to Create First part of BACS Usr Str =======}

Function AllocCtrlKey1(SPMode  :  Boolean;
                       CCode   :  Str10) :  Str20;


Begin

  Result:=TradeCode[SPMode]+FullCustCode(CCode);

end; {Func..}


{ ======== Function to Create BACS Usr Str 2=======}

Function AllocCtrlKey2(SPMode  :  Boolean;
                       CCode   :  Str10) :  Str20;


Begin

  Result:=PartCCKey(MBACSCode,MBACSCTL)+AllocCtrlKey1(SPMode,CCode);

end; {Func..}



Procedure Init_AllocCtrlUser(Var AllocCtrlRec  :  MLocRec);

Var
  TimeR      :  TimeTyp;

Begin
  With AllocCtrlRec.AllocCRec do
  Begin
    arcOpoName:=EntryRec^.LogIn;
    arcStartDate:=Today;

    GetCurrTime(TimeR);

    arcStartTime:=SetN(TimeR.HH)+':'+SetN(TimeR.MM);

    arcWINLogIn:=WinGetUserName;

  end; {With..}

end;


Procedure Init_AllocCtrl(Var AllocCtrlRec  :  MLocRec);

Var
  Loop       :  Boolean;
  TestBankGL :  LongInt;
  TestCCDep  :  CCDepType;

Begin
  Loop:=BOff;

  With AllocCtrlRec.AllocCRec do
  Begin
    If (Cust.CustCode<>arcCustCode) then
       Global_GetMainRec(CustF,arcCustCode);

    // CJS 17/03/2011 - ABSEXCH-2515
    // Only write the Cost Centre and Department to the Allocation record if
    // we have actually read them from the Customer record.
     If (Syss.UseCCDep) then
     begin
       With Cust do
         TestCCDep:=GetCustProfileCCDep(CustCC,CustDep,arcCCDep,0);
       For Loop:=BOff to BOn do
         If (TestCCDep[Loop]<>'') then
           arcCCDep[Loop]:=TestCCDep[Loop];
     end;

     TestBankGL:=GetProfileBank(arcSalesMode);

     If (TestBankGL<>0) then
       arcBankNom:=TestBankGL;

     arcTransDate:=Today;

     If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
       Date2Pr(arcTransDate,arcTagRunPr,arcTagRunYr,nil)
     else
     Begin
       arcTagRunPr:=GetLocalPr(0).CPr;
       arcTagRunYr:=GetLocalPr(0).CYr;
     end;

     arcCtrlNom:=Cust.DefCtrlNom;

     {$IFDEF MC_On}
       arcPayCurr:=Cust.Currency;
     {$ELSE}
       arcPayCurr:=0;
       arcInvCurr:=0;
     {$ENDIF}

     arcCXrate:=SyssCurr.Currencies[arcPayCurr].CRates;
     arcCXrate[BOff]:=0.0;

     arcAutoTotal:=BOff;

     arcTransValue:=0.0;
     arcOwnTransValue:=0.0;

     arcCharge1Amt:=0.0;
     arcCharge2Amt:=0.0;


     arcFinVar:=BOff; arcFinSetD:=BOff;

     If (Syss.AutoCQNo) then
       arcChequeNo2:=Get_NextChequeNo(BOff);

     arcYourRef:=''; arcJobCode:=''; arcAnalCode:='';

     arcTotal:=0.0; arcTotalOwn:=0.0;

     arcUsePPD := False;


     {$IFDEF MC_On}
       arcIncVar:=BOn;
     {$ELSE}
       arcIncVar:=BOff;
     {$ENDIF}

     arcCheckFail:=BOff;

     Init_AllocCtrlUser(AllocCtrlRec);

  end;
end;

{ =========== Procedure to Get/Initialise Allocation Control Record ========== }
{Get Mode :-
 0 = Attempt to create or resuse record.
 1 =   As 0 + leave locked.
}

Function Alloc_CtrlGet(SPMode     :  Boolean;
                       CCode      :  Str10;
                   Var AllocCtrlRec
                                  :  MLocRec;
                       MTExLocal  :  TdMTExLocalPtr;
                       GetMode    :  Byte)  :  Boolean;

Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  TmpPWord  :  MLocRec;

  KeyS      :  Str255;

  FoundOk,
  Locked,
  LOk       :  Boolean;

  GStatus,
  TKeypath,
  TmpStat   :  Integer;
  UsrAddr,
  TmpRecAddr:  LongInt;

  

Begin
  LOk:=BOff;  Result:=BOff;

  KeyS:=AllocCtrlKey2(SPMode,CCode);


  If (Not Assigned(MTExLocal)) then
  Begin


    TmpPWord:=MLocCtrl^;  Locked:=BOff;

    TKeypath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOff,BOff);


    GStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (GStatus=0) then {Attempt to lock it}
      LOk:=(Try_Lock(B_GetDirect,B_SingNWLock+B_MultLock,KeyS,Keypath,Fnum,RecPtr[Fnum])=0);

    FoundOk:=(GStatus=0);

    Locked:=(FoundOk and Not LOk);


    With MLocCtrl^ do
    With AllocCRec do
    Begin
      If (Not Locked) then
      Begin

        If (Not FoundOk) then
        Begin

          ResetRec(Fnum);

          RecPfix:=MBACSCode;
          Subtype:=MBACSCTL;

          arcCode1:=AllocCtrlKey1(SPMode,CCode);

        end
        else
          GetPos(F[Fnum],Fnum,UsrAddr);


        If (Not FoundOk) or (arcLocked=0) then {* treat as fresh allocation *}
        Begin
          arcSalesMode:=SPMode;
          
          Init_AllocCtrl(MLocCtrl^);
          
          arcForceNew:=BOn;
        end;


        If (FoundOk) then
        Begin
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          If (GetMode=0) then {unlock it now}
          Begin
            Status:=UnLockMultiSing(F[Fnum],Fnum,UsrAddr);

          end;
        end
        else
        Begin
          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);


          If (GetMode=1) then {Leave it locked}
          Begin
            LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,UsrAddr);

          end;

        end;

        AllocCtrlRec:=MlocCtrl^;

        Result:=BOn;

      end
      else
    {If Locked warn}
      Begin
        AllocCtrlRec:=MlocCtrl^;
        Result:=BOn;
        AllocCtrlRec.AllocCrec.arcLocked:=2;

      end;


      TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOn,BOff);

      MLocCtrl^:=TmpPWord;
    end {With..}
  end
  else
  With MTExLocal^ do {Use thread safe version}
  Begin


  end;
end; {Proc..}

{ ========= Proc to Store/Update Allocation Ctrl Rec ========== }
{Modes : 0 Lock, update and unlock in one operation.
         1 Lock only, do not update.
         2 Update and do not unlock }

Procedure Alloc_CtrlPut(Fnum,
                        Keypath      :  Integer;
                    Var AllocCtrlRec :  MLocRec;
                        MTExLocal    :  TdMTExLocalPtr;
                        PutMode      :  Byte);



Var
  TmpPWord  :  MLocRec;

  LOk,
  Locked    :  Boolean;

  KeyS      :  Str255;

  LAddr     :  LongInt;


Begin

  Locked:=BOff;

  TmpPWord:=AllocCtrlRec;

  With AllocCtrlRec.AllocCRec do
      KeyS:=AllocCtrlKey2(arcSalesMode,arcCustCode);

  If (Not Assigned(MTExLocal)) then
  Begin


    If (PutMode In [0..2]) then
      LOk:=GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr)
    else
    Begin
      LOK:=BOn; Locked:=BOn;
    end;

    If (LOk) and (Locked) and (PutMode<>1) then
    Begin

      MLocCtrl^:=TmpPWord;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      If (PutMode<>2) then
        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


    end
    else
      If (LOk and Locked) and (PutMode=1) then
        AllocCtrlRec:=MLocCtrl^;

  end
  else
  With MTExLocal^ do
  Begin

    If (PutMode In [0..2]) then
      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked)
    else
    Begin
      LOK:=BOn; Locked:=BOn;
    end;


    If (LOk) and (Locked) and (PutMode<>1)  then
    Begin
      LGetRecAddr(Fnum);

      LMLocCtrl^:=TmpPWord;

      LStatus:=LPut_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      If (PutMode<>2) then
        LStatus:=LUnLockMLock(Fnum);

    end
    else
      If (LOk and Locked) and (PutMode=1) then
        AllocCtrlRec:=LMLocCtrl^;

  end;


end; {Proc..}


Procedure AllocForceInvSDisc(Var  InvR, EInv  :  InvRec;
                                  AllocCtrl   :  MLocRec;
                                  Mode        :  Byte);

Var
   BacsCtrl  :  PasswordRec;


Begin
  Blank(BacsCtrl,Sizeof(BACSCtrl));

  With BACSCtrl.BACSCRec,AllocCtrl,AllocCRec do
  Begin
    SDDaysOver:=arcSDDaysOver;
    TagAsDate:=Today;
    IncSDisc:=arcIncSDisc;

    ForceInvSDisc(InvR, EInv,BACSCtrl,Mode);

  end; {With..}
end; {Proc..}


{ == Proc to update alocation screen balance == }

Procedure UpdateAllocCRec(OldAR,
                          NewAR  :  MiscRec;
                      Var AllocCtrl  :  MLocRec;
                          MTExLocal  :  TdMTExLocalPtr);
Var
  UOR      :  Byte;
  Dbase,
  DSettle  :  Double;


Begin
  UOR:=0; DSettle:=0.0; DBase:=0.0;

  With NewAR, AllocCtrl.AllocCRec do
  Begin
    arcTotal:=Round_up(arcTotal-OldAR.AllocSRec.ariSettle*DocCnst[OldAR.AllocSRec.ariDocType]*DocNotCnst,2);
    arcTotal:=arcTotal+Round_Up(AllocSRec.ariSettle*DocCnst[AllocSRec.ariDocType]*DocNotCnst,2);

    If (arcPayCurr=arcInvCurr) or (arcPayCurr=OldAR.AllocSRec.ariOrigCurr) then
      DSettle:=OldAR.AllocSRec.ariSettleOwn*DocCnst[OldAR.AllocSRec.ariDocType]*DocNotCnst
    else
    Begin
      DBase:=Conv_TCurr(OldAR.AllocSRec.ariSettleOwn*DocCnst[OldAR.AllocSRec.ariDocType]*DocNotCnst,
                               XRate(OldAR.AllocSRec.ariCXRate,BOff,OldAR.AllocSRec.ariOrigCurr),OldAR.AllocSRec.ariOrigCurr,UOR,BOff);

      If (arcAutoTotal) then
        DBase:=DBase+OldAR.AllocSRec.ariRevalAdj;

      DSettle:=Currency_ConvFT(DBase,0,arcPayCurr,UseCoDayRate);

    end;

    arcTotalOwn:=Round_up(arcTotalOwn-Round_Up(DSettle,2),2);

    If (arcPayCurr=arcInvCurr) or (arcPayCurr=AllocSRec.ariOrigCurr) then
      DSettle:=AllocSRec.ariSettleOwn*DocCnst[AllocSRec.ariDocType]*DocNotCnst
    else
    Begin
      DBase:=Conv_TCurr(AllocSRec.ariSettleOwn*DocCnst[AllocSRec.ariDocType]*DocNotCnst,XRate(AllocSRec.ariCXRate,BOff,AllocSRec.ariOrigCurr),AllocSRec.ariOrigCurr,UOR,BOff);

      If (arcAutoTotal) then
        DBase:=DBase+AllocSRec.ariRevalAdj;

      DSettle:=Currency_ConvFT(DBase,0,arcPayCurr,UseCoDayRate);

    end;

    arcTotalOwn:=Round_Up(arcTotalOwn+Round_Up(DSettle,2),2);

    arcVariance:=arcVariance-Round_Up(OldAR.AllocSRec.ariVariance,2);
    arcVariance:=arcVariance+Round_Up(AllocSRec.ariVariance,2);


    arcSettleD:=arcSettleD-Round_Up(Conv_TCurr(OldAR.AllocSRec.ariSetDisc,XRate(OldAR.AllocSRec.ariCXRate,BOff,AllocSRec.ariOrigCurr),OldAR.AllocSRec.ariOrigCurr,UOR,BOff),2);

    arcSettleD:=arcSettleD+Round_Up(Conv_TCurr(AllocSRec.ariSetDisc,XRate(AllocSRec.ariCXRate,BOff,AllocSRec.ariOrigCurr),AllocSRec.ariOrigCurr,UOR,BOff),2);

    arcOwnSettleD:=arcOwnSettleD-Round_Up(Currency_ConvFT(Conv_TCurr(OldAR.AllocSRec.ariSetDisc,XRate(OldAR.AllocSRec.ariCXRate,BOff,OldAR.AllocSRec.ariOrigCurr),OldAR.AllocSRec.ariOrigCurr,UOR,BOff),0,arcPayCurr,
                      UseCoDayRate),2);

    arcOwnSettleD:=arcOwnSettleD+Round_Up(Currency_ConvFT(Conv_TCurr(AllocSRec.ariSetDisc,XRate(AllocSRec.ariCXRate,BOff,AllocSRec.ariOrigCurr),AllocSRec.ariOrigCurr,UOR,BOff),0,arcPayCurr,
                      UseCoDayRate),2);

    If (arcAutoTotal) then {Auto mode so keep tracking total based on allocated totals}
    Begin
      arcOwnTransValue:=arcTotalOwn;
      arcTransValue:=Round_Up(arcTotal+arcVariance,2);

    end;

    If (Not Assigned(MTExLocal)) then
      Alloc_CtrlPut(MLocF,MLK,AllocCtrl,nil,2);
  end; {With..}
end;


{ == Func to return total unallocated value == }

Function Calc_arcUnallocated(AllocCtrl  :  MLocRec;
                             UseOwn     :  Boolean)  :  Double;
Var
  TmpTotal  :  Double;

Begin
  Result:=0;

  With AllocCtrl.AllocCRec do
    If UseOwn then
      TmpTotal:=arcOwnTransValue-arcTotalOwn
    else
      TmpTotal:=arcTransValue-(arcTotal+arcVariance);

  Result:=TmpTotal;
end;

{ == Sanity check Func to compare allcoation record with invoice, and determine if there have been any changes == }

{Results
0 = All OK
1 = Original value chganged
2 = Currency changed
3 = Base Equivalent changed
4 = Base settled changed
5 = Original settled changed
6 = Exchange rate changed

}

Function SanityCheckAllocS(NewAR  :  MiscRec;
                           EInv   :  InvRec)  :  Byte;
var
  PPDValueInBase : Double;
  UOR : Byte;
Begin
  Result:=0;

  With NewAR.AllocSRec, EInv do
  Begin

    Result:=(1 * Ord(Round_up(ariOrigVal,2)<>Round_Up(Itotal(EInv)*DocCnst[InvDocHed]*DocNotCnst,2)));

    If (Result=0) then
      Result:=(2 * Ord(ariOrigCurr<>Currency));

    If (Result=0) then
      Result:=(3 * Ord(Round_Up(ariBaseEquiv,2)<>Round_Up(ConvCurrItotal(EInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst,2)));

    If (Result=0) then
    begin
      Result:=(4 * Ord(ariOrigSettle<>Settled));

      //PR: 22/05/2015 v7.0.14 If we've just taken PPD then the settled amount will have changed, so check with PPD
      if (Result = 4) and (ariPPDStatus > 0) then
      begin
        with EInv do
        begin
          {$IFDEF MC_ON}
          UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);
          PPDValueInBase := Round_Up(Conv_TCurr(thPPDGoodsValue + thPPDVATValue,XRate(CXRate,True,Currency),Currency,UOR,False), 2);
          {$ELSE}
          PPDValueInBase := Round_Up(thPPDGoodsValue + thPPDVATValue, 2);
          {$ENDIF}
          //PR: 03/06/2015 ABSEXCH-16476 Added DocCnst[InvDocHed]*DocNotCnst to ensure correct sign
          PPDValueInBase := PPDValueInBase * DocCnst[InvDocHed] * DocNotCnst;
        end;

        if Round_Up(ariOrigSettle + PPDValueInBase, 2) = Round_Up(Settled, 2) then
          Result := 0;
      end;
    end;

    If (Result=0) then
    begin
      Result:=(5 * Ord(ariOrigOCSettle<>CurrSettled));

      //PR: 22/05/2015 v7.0.14 If we've just taken PPD then the settled amount will have changed so check with PPD
      if (Result = 5) and (ariPPDStatus > 0) then
      begin
        //PR: 03/06/2015 ABSEXCH-16476 Added DocCnst[InvDocHed]*DocNotCnst to ensure correct sign
        if Round_Up(ariOrigOCSettle + ((EInv.thPPDGoodsValue + EInv.thPPDVATValue) * DocCnst[InvDocHed] * DocNotCnst) , 2)
                                               = Round_Up(CurrSettled, 2) then
          Result := 0;
      end;
    end;

    If (Result=0) then
      Result:=(6 * Ord((ariCXRate[BOff]<>CXRate[BOff]) or (ariCXRate[BOn]<>CXRate[BOn])));

  end;
end;


{== Convert Sanity result into meaningful string ==}

Function Sanity_Reason(SR  :  Byte)  :  Str255;

Begin
  Case SR of
    1 : Result:= 'the original value';
    2 : Result:= 'the currency';
    3 : Result:= 'the base equivalent value';
    4 : Result:= 'the base settled value';
    5 : Result:= 'the original settled value';
    6 : Result:= 'the exchange rate';
    7 : Result:= 'the amount outstanding';

    else  Result:=''

  end; {Case..}

  If (SR<>0) then
    Result:=Result+' has changed since the allocation was started.';

end;


end.
