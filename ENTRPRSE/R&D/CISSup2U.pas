unit CISSup2U;

interface

{$I DefOvr.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1, BTSupU3,

  {$IFDEF POST}
    PostingU,
    JobPostU,
  {$ENDIF}


  ExWrap1U;

Type
  {$IFDEF POST}

    TScanCIS      =  Object(TPostJob)

                       private
                         CRepParam  :  CVATRepPtr;

                         Procedure CIS_CalcDoc(BFnum,BKeypath  :  Integer);

                         Procedure LMatch_Voucher(InvR    :  InvRec;
                                                  VFolio  :  Str10;
                                                  AddT,
                                                  AddN,
                                                  AddG    :  Real;
                                                  Mode    :  Byte);


                         Procedure CIS_Scan;

                         Procedure Check_Totals(Fnum  :  Integer);

                       public
                         FuncMode  :  Byte;

                         Constructor Create(AOwner  :  TObject);

                         Destructor  Destroy; Virtual;

                         Function LChkDupliCertNo(CISChk  :  Str255;
                                                  LKeypath:  Integer;
                                                  ChkMode :  Byte)  :  Boolean;

                         Procedure Process; Virtual;
                         Procedure Finish;  Virtual;

                         Function Start(InpWinH  :  THandle)  :  Boolean;

                     end; {Class..}


    TSynchPayRate      =  Object(TPostJob)

                       private
                         MatchPayRate  :  Str20;
                         MatchCurrency :  Byte;
                         CIS6Date      :  LongDate;

                         Procedure UpdatePayRate;

                         Procedure CIS6RollOver;

                       public
                         FuncMode  :  Byte;

                         Constructor Create(AOwner  :  TObject);

                         Destructor  Destroy; Virtual;

                         Procedure Process; Virtual;
                         Procedure Finish;  Virtual;

                         Function Start(PCode      :  Str20;
                                        PCurrency  :  Byte)  :  Boolean;

                     end; {Class..}


    Procedure AddUPayRate2Thread(AOwner   :  TObject;
                                 PCode    :  Str20;
                                 PCurr    :  Byte;
                                 fMode    :  Byte);


    Procedure AddCIS6Update(AOwner   :  TObject;
                            OldDate  :  LongDate;
                            fMode    :  Byte);


  {$ELSE}
    TScanCIS = Class

                 end;

  {$ENDIF}


  Procedure AddCISScan2Thread(AOwner   :  TObject;
                              BCtrl    :  CVATRepParam;
                              MyHandle :  THandle;
                              fMode    :  Byte);



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
  {$ENDIF}

  {$IFDEF PF_On}
     InvLSt2U,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  
  IntMU,
  Event1U,
  SysU1,
  SysU2,
  JobSup1U,
  CISSup1U;



{$IFDEF POST}

  { ========== TScanCIS methods =========== }

  Constructor TScanCIS.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpHigher;
    fSetPriority:=BOn;

    IsParentTo:=BOn;

    New(CRepParam);

    FillChar(CRepParam^,Sizeof(CRepParam^),#0);


  end;

  Destructor TScanCIS.Destroy;

  Begin
    Dispose(CRepParam);

    Inherited Destroy;
  end;

{ == Generate Match for voucher. == }
{Reproduced in JChkUseU for non thread operation. Match_Voucher}

Procedure TScanCIS.LMatch_Voucher(InvR    :  InvRec;
                                  VFolio  :  Str10;
                                  AddT,
                                  AddN,
                                  AddG  :  Real;
                                  Mode  :  Byte);

Const
  Fnum      = PWrdF;
  Keypath   = PWK;



Begin

  With MTExLocal^ do
  Case Mode of

    8
           :  With LPassword do
              With MatchPayRec do
              Begin

                LResetRec(Fnum);

                RecPFix:=MatchTCode;
                SubType:=MatchCCode;

                DocCode:=InvR.OurRef;
                PayRef:=VFolio;

                AltRef:=InvR.YourRef;

                SettledVal:=AddT*DocCnst[InvR.InvDocHed];

                OwnCVal:=AddG*DocCnst[InvR.InvDocHed];

                RecOwnCVal:=AddN*DocCnst[InvR.InvDocHed];

                MCurrency:=InvR.Currency;

                MatchType:=MatchCCode;

                LStatus:=LAdd_Rec(Fnum,KeyPath);

                LReport_BError(Fnum,LStatus);

              end;
    end; {Case..}

end; {Proc..}



{ == Check for duplicate Cert & Folio No. == }

Function TScanCIS.LChkDupliCertNo(CISChk  :  Str255;
                                  LKeypath:  Integer;
                                  ChkMode :  Byte)  :  Boolean;

Const
  Fnum  =  JDetlF;

Var
  Keypath,
  TmpStat,
  TmpKPath : Integer;
  TmpRecAddr
           : LongInt;

  LJD      :  JobDetlRec;

  KeyChk,
  KeyS     :  Str255;

Begin
  Result:=BOff;

  With MTExLocal^ do
  Begin
    LJD:=LJobDetl^;

    Case ChkMode of
      0  :  Keypath:=JDStkK;
      1  :  Keypath:=JDPostedK;
    end; {Case..}

    TmpKPath:=LKeypath;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=CISPrefix+CISChk;
    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    Result:=(LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));


    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    LJobDetl^:=LJD;
  end;

end;

Procedure TScanCIS.CIS_CalcDoc(BFnum,BKeypath  :  Integer);


Const
  Fnum     =  InvF;
  Keypath  =  InvCISK;



Var
  sLen         :  Byte;

  KeyJF,
  KeyS2,
  KeyChk2,
  KeyChk,
  DelMatchK    :  Str255;

  ReverseVouch,
  LOk,
  UseOsKey,
  NewRec,
  Locked      :  Boolean;

  BStatus     :  Integer;

  CWorth,
  MGross,
  VWorth      :  Double;

  GenStr      :  String;




{ == Check CIS Type for filter == }

Function RightCISType  :  Boolean;
Var
  CT  :  Byte;

Begin
  Result:=BOff;

  With MTExLocal^,CRepParam^ do
  Begin
    KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(LInv.CISEmpl));

    If (LGetMainRec(JMiscF,KeyJF)) then
    With LJobMisc^,EmplRec do
    Begin
      CT:=ECISType2Voucher(CISType,LInv.CISTax,LInv.CISEmpl);

      Result:=((CISGMode=CT) or ((CISGMode=0) and (CT<>6)));
    end;
  end;
end;

Begin

  GenStr:='';

  Locked:=BOff;

  ItemCount:=0; SLen:=0;

  CWorth:=0.0; VWorth:=0.0; MGross:=0.0;

  UseOSKey:=CRepParam^.HasCISNdx;

  If (Not UseOSKey) then
  Begin

    Write_PostLog('The Transaction CIS index is missing in this data which prevents the CIS module from searching for CIS payments.',BOn);
    Write_PostLog('Rebuild Document.dat to rectify this situation.',BOn);
    Write_PostLog('',BOn);

    Exit;
  end;

  FillChar(KeyChk,Sizeof(KeyChk),#0);
  FillChar(KeyS2,Sizeof(KeyS2),#0);


  With MTExLocal^,CRepParam^, SyssCIS^.CISRates do
  Begin
    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));


    KeyChk:=VATStartD;
    KeyChk2:=VATEndD;
    KeyS2:=KeyChk;


    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

    While (LStatusOk) and (CheckKeyRange(KeyChk,KeyChk2,KeyS2,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
    With LInv do
    Begin
      {$B-}
      If (InvDocHed In CISDocSet) and (RunNo>0) and (Round_Up(CurrSettled,2)<>Round_Up(CISDeclared,2)) and (CISEmpl<>'') and (RightCISType) then
      {$B+}
      Begin
        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS2,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          NewRec:=(CISAggMode=1);

          ReverseVouch:=BOff;

          If (Not NewRec) then {Attempt to find the exisiting voucher}
          Begin
            KeyJF:=CISPrefix+FullCustCode(CustCode)+CISDate;

            LStatus:=LFind_Rec(B_GetEq,BFnum,JDLookK,KeyJF);

            If (LStatusOk) then
            Begin
              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyJF,BKeyPath,BFnum,BOn,Locked);

              LGetRecAddr(BFnum);
            end
            else
              NewRec:=(LStatus=4);

          end;


          With LJobDetl^,JobCISV do
          Begin

            If (NewRec) then
            Begin
              KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(CISEmpl));


              If (LGetMainRec(JMiscF,KeyJF)) and (LGetMainRec(CustF,CustCode)) then
                Prime_CISVoucher(LJobDetl^,LCust,LJobMisc^,LInv)
              else
              Begin
                LResetRec(BFnum);

                RecPfix:=JATCode;
                Subtype:=JBSCode;

                FillChar(NDXFill1,Sizeof(NdxFill1),NdxWeight);


                KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(CISEmpl));


                If (LGetMainRec(JMiscF,KeyJF)) then
                With LJobMisc^,EmplRec do
                Begin
                  CISCType:=ECISType2Voucher(CISType,CISTax,CISEmpl);

                  If (CIS340) then
                    CISVNINo:=UTRCode
                  else
                    CISVNINo:=ENINo;

                  CISVerNo:=VerifyNo;

                  CISVCert:=CertNo;

                  CISAddr:=Addr;

                  CISBehalf:=Trim(EmpName);

                  {$B-}
                  If (CurrentCountry<>IECCode) and (LGetMainRec(CustF,CustCode)) then
                  {$B+}
                  Begin
                    Case  CISCType of
                      4,5
                         :  CISBehalf:=Trim(LCust.Company);
                      6  :  Begin
                              CISBehalf:=CISBehalf+' acting for '+Trim(LCust.Company);
                              CISAddr[5]:=UserDef4;
                            end;
                    end; {Case..}

                  end;

                end
                else
                  CISCType:=4;

                CISvNLineCount:=1;

                CISCurr:=Syss.VATCurr;
              end;

              With CISVouchers[CISCType] do
              Begin
                Repeat
                  CISCertNo:=FullStockCode(Prefix+IntToStr(Counter));

                  Inc(Counter);

                Until (ThreadRec^.THAbort) or (Not LChkDupliCertNo(CISCertNo,BKeypath,0));
              end; {With..}

              Repeat
                CISFolio:=FullNomKey(CISVFolio)+HelpKStop;

                Inc(CISVFolio);
              Until (ThreadRec^.THAbort) or (Not LChkDupliCertNo(CISFolio,BKeyPath,1));


              CISVDateS:=CISDate+FullCustCode(CustCode)+ECISType2Key(CISCType);
              CISVSDate:=FullCustCode(CustCode)+CISDate;
              CISVCode1:=FullEmpKey(CISEmpl)+CISDate;
              CISVCode2:=CISDate+FullEmpKey(CISEmpl)+ECISType2Key(CISCType);


              {CISVEmplCode:=CISEmpl;}

              If (CISAggMode=1) then
                CISVORef:=OurRef;


            end; {If New..}


            Update_CISVoucher(LJobDetl^,LInv,VWorth,MGross,CWorth,0);

            BStatus:=0;

            If (NewRec) then
              LStatus:=LAdd_Rec(BFnum,BKeyPath)
            else
            With LJobDetl^,JobCISV do
            Begin
              If (Round_Up(CISvTaxDue+CISvAutoTotalTax+CISvGrossTotal+CISTaxableTotal,2)<>0.0) then
              Begin

                LStatus:=LPut_Rec(BFnum,BKeyPath);

                BStatus:=LUnLockMLock(BFnum);
              end
              else
              Begin {* Delete it as its not worth anything *}
                {* Delete matching first *}
                DelMatchK:=FullMatchKey(MatchTCode,MatchCCode,CISFolio);

                LDeleteLinks(DelMatchK,PWrdF,Length(DelMatchK),HelpNdxK,BOff);

                LStatus:=LDelete_Rec(BFnum,BKeyPath);

                With CISVouchers[CISCType] do
                Begin
                  sLen:=Length(PRefix);

                  DelMatchK:=Copy(CISCertNo,sLen+1,Length(CISCertNo)-sLen);

                  try
                    Counter:=StrToInt64(Trim(DelMatchK));
                  except;

                  end;

                  Move(CISFolio[1],CISVFolio,4);
                end; {With..}

                ReverseVouch:=BOn;
              end;

            end;

            LReport_BError(BFnum,LStatus);

            LReport_BError(BFnum,BStatus);

            LStatus:=LPut_Rec(Fnum,KeyPath);

            LStatus:=LUnLockMLock(Fnum);

            LReport_BError(Fnum,LStatus);

            {* Generate match record *}

            If (Not ReverseVouch) then
              LMatch_Voucher(LInv,FullOurRefKey(CISFolio),CWorth,VWorth,MGross,8);

            {$IFDEF FRM}
            If (CISCorrect) and (Assigned(PostLog)) then
            Begin
              Write_PostLogDD('The payment for '+Trim(OurRef)+' contained within '+GetIntMsg(4)+' '+Trim(CISCertNo)+' has already been declared on a',BOn,OurRef,0);
              Write_PostLogDD('previous return, but has since been unallocated and is being redeclared as an adjustment to this return.',BOn,OurRef,0);
              Write_PostLog('',BOn);


            end;

        {$ENDIF}


          end;
        end; {Locked..}
      end; {If Doc Ok..}

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      If (Not ThreadRec^.THAbort) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

    end; {While..}

  end; {With..}

end; {Proc..}



{ ======== Procedure to Scan All Accounts and Re-Calc Payment Screen ======= }


Procedure TScanCIS.CIS_Scan;

Begin


  With MTExLocal^ do
  Begin

    CIS_CalcDoc(JDetlF,JDLedgerK);

    {unLock Totals}

    {* Inform input window batch To Un lock *}

    SendMessage(CallBackH,WM_CustGetRec,65,0);


  end; {With..}
end; {Proc..}


{ ========= Check Routine ======= }


Procedure TScanCIS.Check_Totals(Fnum   :  Integer);




Var
  KeyS,
  KeyChk,
  KeyChk2    :  Str255;

  Keypath    :  Integer;

  TmpMisc    :  JobDetlRec;


Begin

  ItemCount:=0;

  FillChar(TmpMisc,Sizeof(TmpMisc),#0);

  With MTExLocal^, CRepParam^ do
  Begin

    SetCISListKeys(CRepParam^,KeyChk,KeyChk2,Keypath);

    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));

    ShowStatus(1,'Checking '+CCCISName^+' Totals');

    KeyS:=KeyChk;

    MatTot:=0.0; GrossTot:=0.0; TriTot:=0.0;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKeyRange(KeyChk,KeyChk2,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
    Begin
      //AP:10/10/2017 ABSEXCH-18533:CIS ledger
      if (LJobDetl.JobCISV.CISHTax <> 0) then
        Update_CISScreenTotals(CRepParam^,LJobDetl^,TmpMisc);

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

    end; {While..}


    SendMessage(CallBackH,WM_CustGetRec,68,LongInt(CRepParam));


  end; {With..}

end; {Proc..}

Procedure TScanCIS.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,CCCISName^+' Generation');

    With MTExLocal^ do
    Begin
      Write_PostLog('',BOff); {Initialise the exceptions log}

    {$IFDEF EXSQL}
    //PR 25/09/2008 - Need to clear the JDetlF cache for main file so that list displays newly-added vouchers.
     if UsingSQL and (FuncMode = 0) then
       DiscardCachedData(Filenames[JDetlF]);
    {$ENDIF}

      Case FuncMode of
        1  :  Check_Totals(JDetlF);
        else  CIS_Scan;

      end; {Case..}
    end;
  end;


  Procedure TScanCIS.Finish;
  Begin
    Inherited Finish;

    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          PostLog.PrintLog(PostRepCtrl,CCCISName^+' omissions and exception log.');

      {$ENDIF}
    {$ENDIF}


    {Overridable method}

    InMainThread:=BOff;


  end;



Function TScanCIS.Start(InpWinH  :  THandle)  :  Boolean;

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


Procedure AddCISScan2Thread(AOwner   :  TObject;
                            BCtrl    :  CVATRepParam;
                            MyHandle :  THandle;
                            fMode    :  Byte);

Var
  LCheck_Batch :  ^TScanCIS;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          FuncMode:=fMode;

          If (Start(MyHandle)) and (Create_BackThread) then
          Begin
            CRepParam^:=BCtrl;

            With BackThread do
              AddTask(LCheck_Batch,'Generate '+CCCISName^+' Rtrn');
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


    { ========== TSynchPayrate methods =========== }

  Constructor TSynchPayRate.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpLower;
    fSetPriority:=BOn;

    IsParentTo:=BOn;


  end;

  Destructor TSynchPayRate.Destroy;

  Begin

    Inherited Destroy;
  end;


Procedure TSynchPayRate.UpdatePayRate;

Const
  Fnum     =  JMiscF;
  Keypath  =  JMK;
  Fnum2    =  JCtrlF;
  Keypath2 =  JCK;

Var
  KeyChk,
  KeyS2,
  KeyS    :  Str255;

  MasterPR:  JobCtrlRec;

  LOk,Locked
          :  Boolean;


Begin
  With MTExLocal^ do
  Begin
    KeyS2:=PartCCKey(JBRCode,JBSubAry[3])+FullJBCode(FullNomKey(PRateCode),MatchCurrency,MatchPayRate);

    LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyS2);

    // CJS: 07/04/2011 ABSEXCH-10439
    ItemCount := 0;

    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));

    LOK:=BOff; Locked:=BOff;

    If (LStatusOk) then
    Begin
      MasterPR:=LJobCtrl^;

      KeyChk:=PartCCKey(JARCode,JASubAry[3]);
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
      Begin
        With LJobMisc^.EmplRec do
        Begin
          KeyS2:=PartCCKey(JBRCode,JBSubAry[4])+FullJBCode(EmpCode,MatchCurrency,MatchPayRate);

          ShowStatus(1,'Update '+dbFormatName(EmpCode,EmpName)+' based rates for '+Trim(MatchPayRate));

        end;

        LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS2,KeyPath2,Fnum2,BOn,Locked);

        If (LOk) and (Locked) then
        With LJobCtrl^.EmplPay do
        Begin
          LGetRecAddr(Fnum2);

          PayRDesc:=MasterPR.EmplPay.PayRDesc;

          If (CostCurr=MasterPR.EmplPay.CostCurr) then
          Begin
            Cost:=MasterPR.EmplPay.Cost;
          end;

          If (ChargeCurr=MasterPR.EmplPay.ChargeCurr) then
            ChargeOut:=MasterPR.EmplPay.ChargeOut;

          PayRFact:=MasterPR.EmplPay.PayRFact;
          PayRRate:=MasterPR.EmplPay.PayRRate;


          LStatus:=LPut_Rec(Fnum2,KeyPath2);

          LReport_BError(Fnum2,LStatus);

          LStatus:=LUnLockMLock(Fnum2);

        end;

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}


    end
    else
    Begin
      Write_PostLog('Unable to locate Global Rate '+Trim(MatchPayRate)+'. No updates have taken place.',BOn);


    end;
  end; {With..}

end;


Procedure TSynchPayRate.CIS6RollOver;

Const
  Fnum     =  InvF;
  Keypath  =  InvCISK;

Var
  B_Func  :  Integer;
  KeyChk,
  KeyS2,
  KeyS    :  Str255;

  LOk,Locked
          :  Boolean;


Begin
  With MTExLocal^ do
  Begin
    // CJS: 07/04/2011 ABSEXCH-10439
    ItemCount := 0;

    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));

    LOK:=BOff; Locked:=BOff;

    KeyChk:=CIS6Date;
    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
    With LInv do
    Begin
      B_Func:=B_GetNext;

      If (CISDeclared<>CurrSettled) and (CISDate<>'') and (CISEmpl<>'') then
      Begin
        KeyS2:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(CISEmpl));

        If (LGetMainRec(JMiscF,KeyS2)) then
        With LJobMisc^,EmplRec do
        If (CISType=3) then {CIS6 Type}
        Begin

          ShowStatus(1,'Update '+dbFormatName(EmpCode,EmpName)+'. '+Trim(OurRef));

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            CISDate:=SyssCIS^.CISRates.CurrPeriod;

            LStatus:=LPut_Rec(Fnum,KeyPath);

            If (LStatusOk) then
              B_Func:=B_GetGEq;

            LReport_BError(Fnum,LStatus);

            LStatus:=LUnLockMLock(Fnum);

          end;
        end; {If Employee Found..}
      end; {If.. needs checking}

      Inc(ItemCount);

      UpdateProgress(ItemCount);

      LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

    end; {While..}
  end; {With..}
end;

Procedure TSynchPayRate.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    Case FuncMode of
      1  :  ShowStatus(0,'Update Employee Rates '+Trim(MatchPayRate));
      2  :  ShowStatus(0,'Update Unmatched CIS24 Trans from '+POutDate(CIS6Date));
    end; {Case..}

    With MTExLocal^ do
    Begin
      Write_PostLog('',BOff); {Initialise the exceptions log}


      Case FuncMode of
        1  :  UpdatePayRate;
        2  :  CIS6RollOver;

      end; {Case..}
    end;

  end;


  Procedure TSynchPayRate.Finish;
  Begin
    Inherited Finish;

    {$IFDEF Rp}
      {$IFDEF FRM}
        If (Assigned(PostLog)) then
          PostLog.PrintLog(PostRepCtrl,'Employee Rate update omissions and exception log.');

      {$ENDIF}
    {$ENDIF}


    {Overridable method}

    InMainThread:=BOff;


  end;



Function TSynchPayRate.Start(PCode       :  Str20;
                             PCurrency   :  Byte)  :  Boolean;

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
        MatchPayRate:=PCode;
        MatchCurrency:=PCurrency;
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


Procedure AddUPayRate2Thread(AOwner   :  TObject;
                             PCode    :  Str20;
                             PCurr    :  Byte;
                             fMode    :  Byte);

Var
  LCheck_Batch :  ^TSynchPayRate;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          FuncMode:=fMode;

          If (Start(PCode,PCurr)) and (Create_BackThread) then
          Begin

            With BackThread do
              AddTask(LCheck_Batch,'Update PayRate');
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

  Procedure AddCIS6Update(AOwner   :  TObject;
                          OldDate  :  LongDate;
                          fMode    :  Byte);

  Var
    LCheck_Batch :  ^TSynchPayRate;

    Begin

      If (Create_BackThread) then
      Begin
        New(LCheck_Batch,Create(AOwner));

        try
          With LCheck_Batch^ do
          Begin
            FuncMode:=fMode;
            CIS6Date:=OldDate;
            
            If (Start('',0)) and (Create_BackThread) then
            Begin

              With BackThread do
                AddTask(LCheck_Batch,'Update CIS6 Invoices');
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

Procedure AddCISScan2Thread(AOwner   :  TObject;
                            BCtrl    :  CVATRepParam;
                            MyHandle :  THandle;
                            fMode    :  Byte);

Begin



end;


{$ENDIF}



end.