Unit LedgSupU;



{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 11/01/96                      }
{                                                              }
{                 Ledger Controller Support Unit               }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Graphics,
     Controls,
     GlobVar,
     VarConst;


Const
  DocMatchTyp   :  Array[BOff..BOn] of Char = ('A','O');


Function RightSignDoc(InvR  :  InvRec)  :  Boolean;

Procedure Warn_ReValued;

Procedure Warn_Autho;

Procedure Warn_DocEditNow;

//PR: 14/05/2015 ABSEXCH-16284 Added PPD value to pass through to part allocation form
Function PartAlloc(InvR          :  InvRec;
                   SRCCurr       :  Byte;
                   PColor        :  TColor;
                   PFont         :  TFont;
                   Handle        :  TWinControl;
               Var FullPartAll,
                   FullOwnAll    :  Real;
               Var Ok2Store      :  Boolean;
               var TakePPD       :  Boolean;
                   PPDAvailableInBase : Double = 0.00;
                   FullAllocationWithPPD :  Boolean = False;
                   WriteOff      : Double = 0.0)  :  Real;

Function Master_Allocate(InvR  :  InvRec)  :  Boolean;



  //PR: 13/02/2013 ABSEXCH-13752  v7.0.2 Changed Remove_MatchPay from procedure to boolean function
  //so that BlockUnallocate knows whether it has deleted any matching records in order to trigger hook.
  //Existing calls will ignore the result so won't be affected.
  function Remove_MatchPay(ORef     :  Str20;
                          MTyp,
                          STyp     :  Char;
                          RemMatch :  Boolean) : Boolean;


  Procedure Match_Payment(Var InvR  :  InvRec;
                              AddT,
                              AddN  :  Real;
                              Mode  :  Byte);


  Procedure Renumb_MatchPay(OldDoc,
                            NewDoc:  Str10;
                            MTyp  :  Char);


  Procedure Update_MatchPay(DocRef,
                            MatchDoc :  Str10;
                            AddT,
                            AddN     :  Real;
                            Deduct   :  Boolean;
                            MTyp     :  Char);


  Procedure SetDocDisc(Const  Fnum,
                              Keypath  :  Integer;
                       Const  ViaAlloc,
                              LiveAlloc:  Boolean);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETMiscU,
   ETStrU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   Dialogs,
   CurrncyU,
   BTKeys1U,
   BTSupU1,

   //PR: 15/05/2015 v7.0.14 ABSEXCH-16284 Removed mc_on ifdefs so that same form can be used for mc & sc
   {.$IFDEF MC_On}
     CLPALMCU,

   {.$ELSE}
     CLPALU,

   {.$ENDIF}

   {$IFDEF CU}
     Event1U,

   {$ENDIF}

   Saltxl1U,
   SysU1,

   oTakePPD;




{ ======= Function to Check if Document has right sign ======= }

Function RightSignDoc(InvR  :  InvRec)  :  Boolean;

Begin

  RightSignDoc:=(ITotal(InvR)>=0);

end; {Func..}


{ ============ Return Part Allocate Value =========== }

//PR: 14/05/2015 ABSEXCH-16284 Added PPD value to pass through to part allocation form
Function PartAlloc(InvR          :  InvRec;
                   SRCCurr       :  Byte;
                   PColor        :  TColor;
                   PFont         :  TFont;
                   Handle        :  TWinControl;
               Var FullPartAll,
                   FullOwnAll    :  Real;
               Var Ok2Store      :  Boolean;
               var TakePPD       :  Boolean;
                   PPDAvailableInBase : Double = 0.00;
                   FullAllocationWithPPD :  Boolean = False;
                   WriteOff      : Double = 0.0)  :  Real;


const
  Term : CharSet  =  StdInputSet;



Var
  UOR            :  Byte;
  NewAlloc,
  PAllo,
  SuggPAllo,
  PAlloRatio
                 :  Real;


  L              :  LongInt;

  mrResult       :  Word;
  IsNeg,
  ForceORate,
  UseRatio       :  Boolean;

  //PR: 15/05/2015 v7.0.14 ABSEXCH-16284 Removed mc_on ifdefs so that same form can be used for mc & sc
  ISCtrl         :  TCLPAMCL;

  PMCValue       :  Double;




Begin

  With InvR,GlobalAllocRec^[SalesorPurch(InvDocHed)] do
  Begin

    PAllo:=0; SuggPAllo:=0; PAlloRatio:=0;  UOR:=0;


    {$IFDEF CU}
      ForceORate:=(UseCoDayRate and ((Not EnableCustBtns(2000,200)) or (SRCCurr<>Currency))); {*EL v6.01 Force behavior of part allocation to use Invoice exchange rate*}
    {$ELSE}
      ForceORate:=UseCoDayRate;
    {$ENDIF}


    IsNeg:=BOff; UseRatio:=BOff;

    NewAlloc:=LUnallocated+(LFullDisc*DocNotCnst);

    If (ABS(BaseTotalOS(InvR))<ABS(NewAlloc)) or (NewAlloc=0) then
      SuggPAllo:=BaseTotalOS(InvR)
    else
      SuggPAllo:=NewAlloc;

    SuggPAllo:=ABS(SuggPAllo);

    PAllo:=SuggPAllo;

    {$IFDEF MC_On}

      PMCValue:=0;

      If (ABS(CurrencyOS(InvR,BOff,BOn,BOff))<ABS(LFullUnallocated)) or (LFullUnallocated=0) then
      Begin
        FullPartAll:=CurrencyOS(InvR,BOff,BOn,BOff);
        FullOwnAll:=CurrencyOS(InvR,BOff,BOn,ForceORate{BOff});

        {This flag has been set-up to cater for the allocation of variance only receipts}

        UseRatio:=(LFullUnallocated=0.0) and (LUnallocated<>0.0) and (Pallo<>0.0);
      end
      else
      Begin
        FullPartAll:=LFullUnallocated;
        FullOwnAll:=LFullOwnUnAlloc;
      end;

    {$ENDIF}

    if not FullAllocationWithPPD then //standard part allocation with or without PPD
    begin
    //PR: 15/05/2015 v7.0.14 ABSEXCH-16284 Removed mc_on ifdefs so that same form can be used for mc & sc
      ISCtrl:=TCLPAMCL.Create(Handle);

    try
      With ISCtrl do
      Begin
        PAValue:=PAllo;

        {$IFDEF MC_On}
           PDayRateFlg:=ForceORate;


        {$ENDIF}

        LocalInv:=InvR;
        //PR: 14/05/2015 ABSEXCH-16284 Set PPD values on the part-allocate form
        SetPPDValues(ABS(CurrencyOS(InvR,BOff,BOn,BOff)), PPDAvailableInBase);

        mrResult:=InitIS(BOff,PColor,PFont);

        If (mrResult=mrOk) then
        Begin
          PAllo:=PAValue;
          TakePPD := TakeThePPD;

          {$IFDEF MC_On}
            PMCValue:=MCValue;
          {$ENDIF}
        end;

      end;

    finally

      ISCtrl.Free;

    end; {Try..}

    end //if FullAllocationWithPPD
    else
    begin
      mrResult := mrOK;

      //Set currency value to o/s less PPD
      PMCValue := Round_Up(CurrencyOS(InvR, True, False, False) - (WriteOff +
                                  InvR.thPPDGoodsValue + InvR.thPPDVATValue) * DocCnst[InvR.InvDocHed]*DocNotCnst, 2);

      //Set base value from currency value
      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);
      PAllo := Round_Up(Conv_TCurr(PMCValue,XRate(CXRate,ForceORate{BOff},Currency),Currency,UOR,BOff)
                          * DocCnst[InvR.InvDocHed]*DocNotCnst, 2);
    end;


    If (MrResult<>mrOk) then
    Begin
      PAllo:=0;

      {$IFDEF MC_On}

        FullPartAll:=0; FullOwnAll:=0;

      {$ENDIF}

      Ok2Store:=BOff;
    end
    else
    Begin


      {$IFDEF MC_On}
        //If we're doing a full allocation with PPD then we need to go through here to set the values correctly,
        //as if we'd changed the value on the part allocation form
        If (Round_Up(PAllo,2)<>Round_Up(SuggPAllo,2)) or (UseRatio) or FullAllocationWithPPD then
        Begin

          {* Instead of calculating a ratio, convert into the documents currency,
             then convert back using the unrounded values to give these equivalents *}

          UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

          PAlloRatio:=Conv_TCurr(PAllo,XRate(CXRate,BOff,Currency),Currency,UOR,BOn);

          {PAlloRatio:=DivWChk(PAllo,SuggPAllo); * Ratio not used, not accurate enough }

          IsNeg:=(PAllo<0.0);

          FullPartAll:=PAllo;

          UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

          If (Not UseRatio) and (SRCCurr=Currency) and (SRCCurr>1) then {Take own currency value from dialog if currencies match}
            FullOwnAll:=Conv_TCurr(PMCValue,XRate(CXRate,ForceORate{BOff},Currency),Currency,UOR,BOff)
          else
            FullOwnAll:=Conv_TCurr(PAlloRatio,XRate(CXRate,ForceORate{BOff},Currency),Currency,UOR,BOff);


        end
        else
          PAllo:=SuggPAllo;  {* Keep the same as input Rounds up/truncates *}


        FullPartAll:=(ABS(FullPartAll)*DocCnst[InvDocHed]*DocNotCnst);
        FullOwnAll:=(ABS(FullOwnAll)*DocCnst[InvDocHed]*DocNotCnst);

        If (IsNeg) then
          FullOwnAll:=FullOwnAll*DocNotCnst;


      {$ENDIF}

      PAllo:=(Pallo*DocCnst[InvDocHed]*DocNotCnst);

    end;

  end; {With..}

  PartAlloc:=Pallo;
end;




{ ================= Warn Record Incomplete ================ }

Procedure Warn_ReValued;

Var
  mbRet  :  Word;

Begin
  mbRet:=MessageDlg('Not allowed on revalued documents!',mtInformation,[mbOk],0);
end;


{ ================= Warn Record Incomplete ================ }

Procedure Warn_Autho;

Var
  mbRet  :  Word;

Begin
  mbRet:=MessageDlg('This transaction has not been authorised!',mtInformation,[mbOk],0);
end;


{ ================= Warn Record Incomplete ================ }

Procedure Warn_DocEditNow;

Var
  mbRet  :  Word;

Begin
  mbRet:=MessageDlg('This transaction is being edited elsewhere!',mtInformation,[mbOk],0);
end;


{ ==== Function to determine if we should set a new match master, primeraly
       designed to allow Credit notes to be allocated to PPY etc. ==== }

Function Master_Allocate(InvR  :  InvRec)  :  Boolean;


Var
  TmpBo  :  Boolean;


Begin

  TmpBO:=BOff;

  TmpBo:=((InvR.InvDocHed In MatchSet) and (RightSignDoc(InvR)));

  If (Not TmpBo) then {* Check to see if it is a reversed transaction v4.20b
                           Done so that -ve invoices can act as a matching host *}
      TmpBo:=((Not (InvR.InvDocHed In MatchSet)) and (Not RightSignDoc(InvR)));


  With GlobalAllocRec^[SalesorPurch(InvR.InvDocHed)] do
    TmpBo:=((TmpBo) and ((Round(LUnallocated)=0) or (Not (LLastMDoc In RecieptSet))));

  Master_Allocate:=TmpBo;

end; {Func..}




{ ======== Procedure to remove the match payment pattern ======= }
{ == Replicated inside Exbtth1u for thread safe == }

//PR: 13/02/2013 ABSEXCH-13752 v7.0.2 Changed Remove_MatchPay from procedure to boolean function
//so that BlockUnallocate knows whether it has deleted any matching records in order to trigger hook.
//Existing calls will ignore the result so won't be affected.
function Remove_MatchPay(ORef     :  Str20;
                         MTyp,
                         STyp     :  Char;
                         RemMatch :  Boolean) : Boolean;
Var
  ScanKey,
  ChkKey  :  Str255;

  UOk,Locked
          :  Boolean;

  Fnum,
  Keypath,
  TmpStatus
          :  Integer;

Begin
  Result := False;

  Fnum      := PWrdF;

  If (RemMatch) then
    KeyPath:=HelpNdxK
  else
    Keypath   := PWK;

  TmpStatus:=Status;

  ScanKey:=FullMatchKey(MatchTCode,STyp,ORef);

  ChkKey:=ScanKey;

  UOk:=BOn; Locked:=BOn;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);

  While (StatusOk) and (UOk) and (Locked) and (CheckKey(ChkKey,ScanKey,Length(ChkKey),BOn)) do
  Begin

    If (PassWord.MatchPayRec.MatchType=MTyp) then
    Begin
      UOk:=GetMultiRec(B_GetDirect,B_MultLock,ScanKey,KeyPAth,Fnum,BOn,Locked);

      If (UOK) and (Locked) then
      Begin

        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        Report_BError(Fnum,Status);

        //PR: 13/02/2013 ABSEXCH-13752 Set result to true if we've successfully removed match record(s)
        Result := Status = 0;

      end;
    end;

    If (StatusOk) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);
  end; {While..}

  Status:=TmpStatus;

end; {Proc..}



  { ======== Procedure to Store the match payment pattern ======= }
  { Reporduced in ExBtTh1U LMatch_Payment, and LRemoveMatch }


  Procedure Match_Payment(Var InvR  :  InvRec;
                              AddT,
                              AddN  :  Real;
                              Mode  :  Byte);

  Const
    Fnum      = PWrdF;
    Keypath   = PWK;



  Begin

    Case Mode of

      3,5,20,23
             :  With Password do
                With MatchPayRec do
                Begin

                  ResetRec(Fnum);

                  RecPFix:=MatchTCode;
                  SubType:=MatchSCode;

                  {* Mode 23 added for back to back matching *}
                  If (Mode=23) then
                  Begin
                    DocCode:=InvR.RemitNo;
                    PayRef:=InvR.OurRef;
                  end
                  else
                  Begin
                    DocCode:=InvR.OurRef;
                    PayRef:=InvR.RemitNo;
                  end;

                  AltRef:=InvR.YourRef;

                  SettledVal:=AddT;

                  OwnCVal:=AddN;

                  MCurrency:=InvR.Currency;

                  MatchType:=DocMatchTyp[(Mode In [20,23])];

                  Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                  Report_BError(Fnum,Status);

                end;


      4,21
           :  Begin
                Remove_MatchPay(InvR.OurRef,DocMatchTyp[(Mode=21)],MatchSCode,BOff);
               
              end;

    end; {Case..}

  end; {Proc..}


  { ======== Procedure to renumber the match payment pattern ======= }

  Procedure Renumb_MatchPay(OldDoc,
                            NewDoc:  Str10;
                            MTyp  :  Char);




  Var
    ScanKey,
    ChkKey  :  Str255;

    UOk,Locked
            :  Boolean;

    Fnum,
    KeyPath,
    TmpStatus,
    B_Func
            :  Integer;

    LAddr   :  LongInt;

  Begin

    Fnum      := PWrdF;
    Keypath   := PWK;

    TmpStatus:=Status;

    ScanKey:=FullMatchKey(MatchTCode,MatchSCode,OldDoc);

    ChkKey:=ScanKey;

    UOk:=BOn; Locked:=BOn;

    B_Func:=B_GetNext;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);

    While (StatusOk) and (UOk) and (Locked) and (CheckKey(ChkKey,ScanKey,Length(ChkKey),BOn)) do
    Begin

      If (PassWord.MatchPayRec.MatchType=MTyp) then
      Begin
        UOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,ScanKey,KeyPAth,Fnum,BOn,Locked,LAddr);

        If (UOK) and (Locked) then
        Begin

          PassWord.MatchPayRec.DocCode:=NewDoc;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          

          If (StatusOk) then
            B_Func:=B_GetGEq
          else
            B_Func:=B_GetNext;

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end
        else
         B_Func:=B_GetNext;
      end
      else
       B_Func:=B_GetNext;



      If (StatusOk) then
        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);

    end; {While..}

    Status:=TmpStatus;

  end; {Proc..}


  { ======== Procedure to adjust the match payment value ======= }

  Procedure Update_MatchPay(DocRef,
                            MatchDoc :  Str10;
                            AddT,
                            AddN     :  Real;
                            Deduct   :  Boolean;
                            MTyp     :  Char);

  Var
    ScanKey,
    ChkKey  :  Str255;

    UOk,Locked,
    FoundOk
            :  Boolean;
    Fnum,
    Keypath,
    DedCnst :  Integer;


    TmpStatus,
    B_Func
            :  Integer;

    LAddr   :  LongInt;

  Begin


    Fnum      := PWrdF;
    Keypath   := PWK;


    TmpStatus:=Status;

    ScanKey:=FullMatchKey(MatchTCode,MatchSCode,DocRef);

    ChkKey:=ScanKey;

    UOk:=BOn; Locked:=BOn;

    B_Func:=B_GetNext;

    FoundOk:=BOff;

    If (Deduct) then
      DedCnst:=-1
    else
      DedCnst:=1;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);

    While (StatusOk) and (UOk) and (Locked) and (CheckKey(ChkKey,ScanKey,Length(ChkKey),BOn)) and (Not FoundOk) do
    With PassWord.MatchPayRec do
    Begin

      If (MatchType=MTyp) and (MatchDoc=PayRef) then
      Begin

        FoundOk:=BOn;

        UOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,ScanKey,KeyPAth,Fnum,BOn,Locked,LAddr);

        If (UOK) and (Locked) then
        Begin

          OwnCVal:=OwnCVal+(AddN*DedCnst);

          SettledVal:=SettledVal+(AddT*DedCnst);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end;

      end;


      If (StatusOk) and (Not FoundOk) then
        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,ScanKey);

    end; {While..}

    Status:=TmpStatus;

  end; {Proc..}


{* Work out if settlement discount is still available. If due date falls on weekend, advance to next Mon *}

Function CalcDiscDue(TransD  :  LongDate;
                      NoDays  :  Integer)  :  Boolean;

Var
  OfficDate  :  LongDate;

  DOW,
  IncX       :  Integer;

Begin
  OfficDate:=CalcDueDate(TransD,NoDays);

  DOW:=DayofWeek(OfficDate);

  If (DOW In [1,7]) then
    IncX:=(1*Ord(DOW=1))+(2*Ord(DOW=7))
  else
    IncX:=0;

  Result:=(CalcDueDate(OfficDate,IncX)>Today);

end;


  { ============ Check if No Disc Days Expired =========== }

Function Warn_DiscDays(TransD  :  LongDate;
                       NoDays  :  Integer)  :  Boolean;

Var
  mbRet  :  Word;

Begin
  Result:=BOn;

  If Not CalcDiscDue(TransD,NoDays) then
  Begin
    mbRet:=MessageDlg('Warning! - Settlement Period has Expired.'+#13+#13+'Use anyway?',
                         mtConfirmation,[mbYes,mbNo],0);
    Result:=(mbRet=mrYes);
  end;

end; {Proc..}


{ ============ Set Discount Toggle ============ }

Procedure SetDocDisc(Const  Fnum,
                            Keypath  :  Integer;
                     Const  ViaAlloc,
                            LiveAlloc:  Boolean);

Var
  OInv     :  InvRec;
  Ok2Cont  :  Boolean;

  UOR,
  LMode    :  Byte;

  DCnst    :  Integer;
  AlMsg    :  Str255;

  mbRet    :  Word;


Begin
  OInv:=Inv;
  LMode:=0;
  DCnst:=1;

  UOR:=0;

  Ok2Cont:=BOn;

  AlMsg:='';

  With Inv do
  Begin
    If (Not (InvDocHed In RecieptSet+QuotesSet+PSOPSet)) and
        ((BaseTotalOS(Inv)<>0) or (RunNo>0)) and (DiscSetAm<>0) {and
        {((CalcDiscDue(TransDate,DiscDays) and (Not PDiscTaken)) or (Not ViaAlloc)) and}
        {((RunNo=0) or (LiveAlloc))} then
    Begin
      If (Not DiscTaken) and (Not PDiscTaken) then
        Ok2Cont:=Warn_DiscDays(TransDate,DiscDays);

      If ((ViaAlloc) or (RunNo>0)) and (Not DiscTaken) and (Not PDiscTaken) {and ((LiveAlloc) or (RunNo=0))}  and (Ok2Cont) then
      Begin
        If (LiveAlloc) or (RunNo=0) then
        Begin
          mbRet:=MessageDlg('A Settlement discount of '+FormatCurFloat(GenRealMask,DiscSetAm,BOn,Currency)+' is available.'+
                              #13+#13+'Do you wish to take this discount?',mtConfirmation,[mbYes,mbNo],0);
          Ok2Cont:=(mbRet=mrYes);
        end
        else
        Begin
          mbRet:=MessageDlg('A Settlement discount of '+FormatCurFloat(GenRealMask,DiscSetAm,BOn,Currency)+' is available.'+
                              #13+#13+'A manual adjustment is required in order to take this discount.',mtInformation,[mbOk],0);

          Ok2Cont:=BOff;
        end;

      end;

      If (Ok2Cont) then
      Begin
        If (RunNo=0) then
        Begin
          DiscTaken:=Not DiscTaken;

          If (Not DiscTaken) and (Not Syss.NoHoldDisc) then
            LMode:=HoldSA
          else
            If (GetHoldType(HoldFlg)=HoldA) then
              LMode:=HoldDel;

          SetHold(LMode,Fnum,KeyPath,BOn,Inv);

          If (Not Syss.UpBalOnPost) then
            UpDateCustBal(OInv,Inv);
        end
        else
          If (RunNo>0) and (Ok2Cont) then
          Begin
            Ok2Cont:=(Not PDiscTaken) and (Not DiscTaken);


            If (PDiscTaken) and (Not DiscTaken) then
            Begin
              mbRet:=MessageDlg('WARNING!'+#13+'A Settlement discount of '+FormatCurFloat(GenRealMask,DiscSetAm,BOn,Currency)+' has already been taken.'+
                            #13+#13+'Do you wish to cancel this discount?',mtWarning,[mbYes,mbNo],0);

              Ok2Cont:=(mbRet=mrYes);

              DCnst:=-1;
            end;

            If (Ok2Cont) then
            With GlobalAllocRec^[SalesorPurch(InvDocHed)] do
            Begin
              If (PDiscTaken) then
                PDiscTaken:=False
              else
                PDiscTaken:=True;

              UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

              LFullDisc:=LFullDisc+(Conv_TCurr(DiscSetAm,XRate(CXRate,BOff,Currency),Currency,UOR,BOff)*DCnst*DocCnst[InvDocHed]*DocNotCnst);

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

              Report_BError(Fnum,Status);

            end;
          end;
      end;
    end;
  end; {With..}
end; {Proc..}




end.