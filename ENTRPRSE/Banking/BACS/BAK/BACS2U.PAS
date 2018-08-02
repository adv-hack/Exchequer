unit BACS2U;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  GlobVar,VARRec2U,VarConst,BtrvU2,BTSupU1,ExWrap1U, BTSupU3, BorBtns,SupListU,

  Recon3U,

  PostingU;


Type   { BACS OutPut Files }

     BACSIntRec  =  Record
                      DESTSort  :  Array[1..6] of Char;
                      DESTAcc   :  Array[1..8] of Char;
                      ZFill1    :  Char;
                      TranCode  :  Array[1..2] of Char;
                      CompSort  :  Array[1..6] of Char;
                      CompAcc   :  Array[1..8] of Char;
                      ZFill2    :  Array[1..4] of Char;
                      AmountP   :  Array[1..11] of Char;
                      CompName  :  Array[1..18] of Char;
                      CompRef   :  Array[1..18] of Char;
                      DestName  :  Array[1..18] of Char;
                      PayDate   :  Array[1..06] of Char;
                      CrLF      :  Array[1..2] of Char;
                    end;

     BACSExRec  =  Record
                      DESTSort  :  String[6];
                      DESTAcc   :  String[8];
                      ZFill1    :  Integer;
                      TranCode  :  Integer;
                      CompSort  :  String[6];
                      CompAcc   :  String[8];
                      ZFill2    :  Integer;
                      AmountP   :  LongInt;
                      CompName  :  String[30];
                      CompRef   :  String[18];
                      DestName  :  String[30];
                      PayDate   :  String[06];
                      CRLF      :  String[2];
                    end;

TPayBatch      =  Object(TEntPost)

                     private
                       BatchCtrl  :  PassWordRec;
                       CustAlObj  :  GetExNObjCid;
                       ExtCustRec :  ExtCusRecPtr;
                       CallBackH  :  THandle;
                       BatchF     :  File of BACSIntRec;
                       SMemo      :  TStringList;

                       ThisRunNo  :  LongInt;


                       Procedure Open_ExDef(DFnam  :  Str255;
                                        Var IOFlg  :  Boolean);

                       Procedure Close_ExDef;

                       Procedure Str2_Char(    LStr   :  Str255;
                                           Var CharAry;
                                               SO     :  Integer);

                       Procedure Str2_ZChar(    LStr   :  Str255;
                                            Var CharAry;
                                                SO     :  Integer);

                       Function Form_ZInt (Inum    :  LongInt;
                                           Dig     :  Integer)  :  Str20;

                       Function Pennies(Inum  :  Real) : LongInt;

                       Function BACS_Safe(TStr  :  Str255)  :  Str255;

                       Function BACS_RunDate(TStr  :  LongDate)  :  Str10;

                       Procedure ConVEx2Batch(BatchEx  :  BACSExRec;
                                          Var BatchDR  :  BACSIntRec);

                       
                       {$IFDEF CU}
                         Procedure SetHKCtrlRec(TRunNo  :  LongInt;
                                                TMode   :  Byte;
                                                SPMode  :  Boolean;
                                                Amount  :  Double);
                       {$ENDIF}

                       Function LBACSHook(HID     :  LongInt;
                                          TRunNo  :  LongInt;
                                          TMode   :  Byte;
                                          SPMode  :  Boolean;
                                          Amount  :  Double)  :  Boolean;

                       Procedure Send_BACSDet(Mode,
                                              TCode    :  Integer;
                                              TRunNo   :  LongInt;
                                              ContTot  :  Real;
                                          Var NoAbort  :  Boolean);

                       Procedure Send_BACS(MatchK      :  Str255;
                                           TRunNo      :  LongInt;
                                           SPMode      :  Boolean);


                       Procedure Gen_PayHed(TDate  :  LongDate;
                                            TYr,
                                            TPr,
                                            RCr    :  Byte;
                                            PayOVal,
                                            PayVar,
                                            PaySDisc,
                                            PaySDOV:  Real;
                                            PayRef :  Str10;
                                            TagRunNo,
                                            CtrlCode
                                                   :  LongInt;
                                            SPMode :  Boolean;
                                            Mode   :  Byte);


                       Procedure Gen_AutoPPYLine(BNomCode:  LongInt;
                                                 BAmount :  Real;
                                                 BCr     :  Byte;
                                                 CQNo    :  Str30;
                                                 PayRef  :  Str20;
                                                 BCCDep  :  CCDepType;
                                                 UseACD  :  Boolean;
                                                 BACSClr :  Boolean;
                                                 Fnum,
                                                 Keypath :  Integer);

                       Procedure Generate_AutoPPY(PayOwnVal,
                                                 PayBase,
                                                 PayIBase,
                                                 PaySDOV    :  Real;
                                                 PayRef     :  Str10;
                                                 Fnum,
                                                 Keypath    :  Integer);


                       Procedure BATCH_PayProcess(Fnum,
                                                  Keypath  :  Integer);

                       Procedure BATCH_SetCqNo(MatchK      :  Str255;
                                               Fnum2,
                                               Keypath2    :  Integer);

                       Procedure BATCH_PayCtrl(Fnum,
                                               Keypath  :  Integer;
                                               ReRun,
                                               SPMode   :  Boolean);




                     public
                       OReRun ,
                       OSPMode    :  Boolean;
                       RFormRep   :  PFormRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start(BCtrl    :  PassWordRec;
                                      InpWinH  :  THandle)  :  Boolean;

                   end; {Class..}


Procedure AddBACSPay2Thread(AOwner   :  TObject;
                            BCtrl    :  PassWordRec;
                            RRun,
                            SPMode   :  Boolean;
                            FormRep  :  PFormRepPtr;
                            MyHandle :  THandle);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU2,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,

  SysU1,
  SysU2,

  ReportHU,
  FrmThrdU,
  DocSupU1,
  BPyItemU,
  ExBtTh1U,
  SalTxl1U,
  ExThrd2U;



   Const
     BACSFName   =  'EXCHBACS.IMP';
     DDebFName   =  'EXCHDDEB.IMP';




  { ========== TPayBatch methods =========== }

  Constructor TPayBatch.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpHigher;
    fSetPriority:=BOn;

    IsParentTo:=BOn;

    New(CustAlObj,Init);
    New(ExtCustRec);

    FillChar(ExtCustRec^,Sizeof(ExtCustRec^),0);

    SMemo:=TStringList.Create;

    New(RFormRep);

  end;

  Destructor TPayBatch.Destroy;

  Begin
    Dispose(CustAlObj,Done);
    Dispose(ExtCustRec);

    Dispose(RFormRep);

    {Free possibly causing application error when this finishes?}
    {SMemo.Free;}

    Inherited Destroy;
  end;



  Procedure TPayBatch.Open_ExDef(DFnam  :  Str255;
                             Var IOFlg  :  Boolean);

  Var
    TmpIO  :  Integer;

  Begin
    {$I-}

    Assign(BatchF,DFnam);

    ReWrite(BatchF);

    TmpIO:=IOResult;

    MTExLocal^.LReport_IOError(TmpIO,DFnam);

    IOFlg:=(TmpIO=0);

    {$I+}

  end;



  Procedure TPayBatch.Close_ExDef;

  Begin
    {$I-}

    Close(BatchF);

    {$I+}

    If (IOResult<>0) then ;
  end;





  { =========== Function to Convert Char Array to String ========= }

  Procedure TPayBatch.Str2_Char(    LStr   :  Str255;
                                Var CharAry;
                                    SO     :  Integer);

  Var
    TmpStr    :  Str255;
    n         :  Byte;

  Begin
    TmpStr:=LJVar(LStr,SO);

    Move(TmpStr[1],CharAry,SO);

  end;{Func..}



  { =========== Function to Convert Char Array to String ========= }

  Procedure TPayBatch.Str2_ZChar(    LStr   :  Str255;
                                 Var CharAry;
                                     SO     :  Integer);

  Var
    TmpStr    :  Str255;
    n         :  Byte;

  Begin
    n:=Length(LStr);

    TmpStr:=ConstStr('0',SO-n)+LStr;

    Move(TmpStr[1],CharAry,SO);

  end;{Func..}



  { ====== Function to Format an Integer No. & return in Str Format ===== }

  Function TPayBatch.Form_ZInt (Inum    :  LongInt;
                                Dig     :  Integer)  :  Str20;


  Var
    TmpStr  :  Str50;


  Begin

    TmpStr:='';


    Str(Inum:0,TmpStr);

    TmpStr:=ConstStr('0',Dig-Length(TmpStr))+TmpStr;

    Form_ZInt:=TmpStr;
  end;

  { ==== Function to convert Real No into Pennies Equivalent ==== }


  Function TPayBatch.Pennies(Inum  :  Real) : LongInt;

  Begin
    Pennies:=Round(Inum * 100);
  end;


  { ===== Function to Filter an NON BACS legal Chars ====== }


  Function TPayBatch.BACS_Safe(TStr  :  Str255)  :  Str255;

  Const
    BACSAll :  CharSet = [#32,'&','-','.','/','0'..'9','A'..'Z'];


  Var
    L,n  :  Byte;



  Begin

    L:=Length(TStr);

    For n:=1 to L do
    Begin

      TStr[n]:=Upcase(Tstr[n]);

      If (Not (TStr[n] In BACSAll)) then
        TStr[n]:=#32;

    end;

    BACS_Safe:=TStr;

  end;


  Function TPayBatch.BACS_RunDate(TStr  :  LongDate)  :  Str10;

  Var
    JulFrom,
    JulToo    :  Real;
    BPD       :  Integer;
    Ty,Tm,Td  :  Word;


  Begin
    DateStr(TStr,Td,Tm,Ty);

    JulFrom:=CalJul(01,01,Ty);

    DateStr(TStr,Td,Tm,Ty);

    JulToo:=CalJul(Td,Tm,Ty);

    BPD:=Succ(Round(JulToo-JulFrom));

    Result:=' '+SetPadNo(Form_Int(ConvTxYrVal(Ty,BOn),0),2)+SetPadNo(Form_Int(BPD,0),3);

  end;


  { ============= Convert Pos Record to SBS Equiv ============== }


  Procedure TPayBatch.ConVEx2Batch(BatchEx  :  BACSExRec;
                               Var BatchDR  :  BACSIntRec);



  Begin

    With BatchDR do
    Begin

      FillChar(BatchDR,Sizeof(BatchDR),32);


      Str2_ZChar(BatchEx.DestSort,DestSort,Sizeof(DestSort));

      Str2_ZChar(BatchEx.DestAcc,DestAcc,Sizeof(DestAcc));

      Str2_Char(Form_ZInt(BatchEx.ZFill1,Sizeof(ZFill1)),ZFill1,Sizeof(ZFill1));

      Str2_Char(Form_ZInt(BatchEx.TranCode,Sizeof(TranCode)),TranCode,Sizeof(TranCode));

      Str2_ZChar(BatchEx.CompSort,CompSort,Sizeof(CompSort));

      Str2_ZChar(BatchEx.CompAcc,CompAcc,Sizeof(CompAcc));

      Str2_Char(Form_ZInt(BatchEx.ZFill2,Sizeof(ZFill2)),ZFill2,Sizeof(ZFill2));

      Str2_Char(Form_ZInt(BatchEx.AmountP,Sizeof(AmountP)),AmountP,Sizeof(AmountP));

      Str2_Char(BatchEx.CompName,CompName,Sizeof(CompName));

      Str2_Char(BatchEx.CompRef,CompRef,Sizeof(CompRef));

      Str2_Char(BatchEx.DestName,DestName,Sizeof(DestName));
      Str2_Char(BatchEx.PayDate,PayDate,Sizeof(PayDate));

      Str2_Char(BatchEx.CRLF,CRLF,Sizeof(CRLF));

    end; {With..}


  end; {Proc..}


  { == Procedure to allow Hooks to override export file production == }


  {$IFDEF CU}
    Procedure TPayBatch.SetHKCtrlRec(TRunNo  :  LongInt;
                                     TMode   :  Byte;
                                     SPMode  :  Boolean;
                                     Amount  :  Double);


    Begin
      With MTExLocal^,BatchCtrl.BACSCRec do
      Begin
        LResetRec(StockF);

        With LStock do
        Begin
          StockFolio:=TRunNo;
          NomCodes[1]:=TagCtrlCode;
          NomCodes[2]:=BankNom;
          ROFlg:=SPMode;

          QtyFreeze:=Amount;
          DefMLoc:=SSymb(PayCurr);
          ROCurrency:=TMode;
          LastUsed:=TagRunDate;

        end;
      end; {With..}

    end; {Proc..}


  {$ENDIF}


  Function TPayBatch.LBACSHook(HID     :  LongInt;
                               TRunNo  :  LongInt;
                               TMode   :  Byte;
                               SPMode  :  Boolean;
                               Amount  :  Double)  :  Boolean;


  Var
    NewObject  :  Boolean;

  Begin
    Result:=BOff;

    {$IFDEF CU}
      If (LHaveHookEvent(2050,HID,NewObject)) then
      Begin
        SetHKCtrlRec(TRunNo,TMode,SPMode,Amount);

        try
          Result:=LExecuteHookEvent(2050,HId,MTExLocal^);

        except
          Result:=BOff;
        end; {try..}
      end;
    {$ENDIF}
  end;

  { ==== Procedure to Write Export Record ===== }

  Procedure TPayBatch.Send_BACSDet(Mode,
                                   TCode    :  Integer;
                                   TRunNo   :  LongInt;
                                   ContTot  :  Real;
                               Var NoAbort  :  Boolean);

  Var
    BatchRec   :  ^BACSIntRec;
    BatchExRec :  ^BACSExRec;

    TmpIO      :  Integer;


  Begin

    New(BatchRec);
    New(BatchExRec);

    TmpIO:=0;

    With MTExLocal^,BatchExRec^ do
    Begin

      Blank(BatchExRec^,Sizeof(BatchExRec^));

      TranCode:=TCode;

      AmountP:=Pennies(Round_Up(ContTot,2));

      CRLF:=#13+#10;

      PayDate:=BACS_RunDate(BatchCtrl.BACSCRec.TagRunDate);

      Case Mode of

        1   :  Begin

                 DestSort:=Syss.UserSort;
                 DestAcc:=Syss.UserAcc;

                 CompSort:=Syss.UserSort;
                 CompAcc:=Syss.UserAcc;


                 If (EmptyKey(Syss.UserRef,BankRLen)) then
                   CompName:='BACS '+Form_Int(TRunNo,0)
                 else
                   CompName:=BACS_Safe(Syss.UserRef);

                 CompRef:=LJVar('CONTRA',Pred(Sizeof(CompRef)));

                 DestName:=BACS_Safe(Syss.UserName);

               end;


        2   :  Begin

                 DestSort:=LCust.BankSort;
                 DestAcc:=LCust.BankAcc;

                 CompSort:=Syss.UserSort;
                 CompAcc:=Syss.UserAcc;

                 CompName:=BACS_Safe(Syss.UserName);

                 If (EmptyKey(LCust.BankRef,BankRLen)) then
                   CompRef:=LInv.OurRef+'/'+Form_Int(TRunNo,0)
                 else
                   CompRef:=BACS_Safe(LCust.BankRef);

                 DestName:=BACS_Safe(LCust.Company);
               end;

      end; {Case..}

    end; {With..}


    ConvEx2Batch(BatchExRec^,BatchRec^);

    {$I-}

      Write(BatchF,BatchRec^);

      TmpIO:=IOResult;

      MTExLocal^.LReport_IOError(TmpIO,BACSFName);

      NoAbort:=(TmpIO=0);

    {$I+}


    Dispose(BatchRec);
    Dispose(BatchExRec);


  end; {Proc..}


  {===== Procedure to control BACS sending =====}


  Procedure TPayBatch.Send_BACS(MatchK      :  Str255;
                                TRunNo      :  LongInt;
                                SPMode      :  Boolean);


  Const
      Fnum     =  InvF;

      Keypath  =  InvBatchK;

      TModes   :  Array[BOff..BOn,1..2] of Byte = ((99,17),(17,99));


  Var
    KeyS,
    KeyChk,
    KeyC    :  Str255;

    LOk,
    Locked,
    NoAbort,
    UseHook,
    RejectB :  Boolean;

    TCode   :  Byte;

    ContTot,
    ITot    :  Real;

    ICount  :  LongInt;

    TCh     :  Char;

    UseFName:  Str255;




  Begin

    KeyChk:=MatchK;

    KeyS:=KeyChk;

    NoAbort:=BOn;

    ContTot:=0;

    ITot:=0;

    ICount:=0;

    RejectB:=BOff;

    TCh:=ResetKey;

    If (SPMode) then
      UseFName:=DDebFName
    else
      UseFName:=BACSFName;

    UseHook:=LBACSHook(01,0,0,BOff,0.0);


    ShowStatus(0,'BACS '+BatchPTit(BatchCtrl.BACSCRec.SalesMode)+'s - ');

    {$B-}
    If (Not UseHook) or (Not LBACSHook(10,TRunNo,0,SPMode,0.0)) then
    Begin
      Open_ExDef(SetDrive+UseFName,NoAbort);

      UseHook:=BOff;
    end;

    {$B+}

    If (NoAbort) then
    With MTExLocal^ do
    Begin
      With SMemo do
      Begin
        Add('');
        Add('BACS Report for Processing Run No. '+Form_Int(TRunNo,0));
        Add('');
      end;

      ShowStatus(1,'Please Wait. Generating BACS file for Run No. '+Form_Int(TRunNo,0));

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoAbort) and (Not ThreadRec^.THAbort) do
      With LInv do
      Begin

        ITot:=ITotal(LInv);

        If (ITot>0) then
        Begin

          KeyC:=CustCode;

          LOk:=LGetMainRec(CustF,KeyC);

          {* Check for BACS type?? *}

          {$B-}

          With LCust do
            If (LOk) and (PayType=BACSRCode)  and ((Not UseHook and (Not EmptyKeyS(BankSort,BankSLen,BOff))
                    and (Not EmptyKeyS(BankAcc,BankALen,BOff))) or
                    (UseHook and LBACSHook(20,TRunNo,0,SPMode,0.0))) then

          {$B+}

            Begin

              Inc(ICount);

              ContTot:=ContTot+ITot;

              If (SPMode) then
              Begin
                Case DirDeb of
                  0  :  TCode:=1; {* New direct debit instruction *}
                  2  :  TCode:=18;{* Represented *}
                  3  :  TCode:=19;{* Last pickup *}
                  else  TCode:=TModes[SPMode,1];   {* Ongoing DD *}
                end; {Case..}
              end
              else
                TCode:=TModes[SPMode,1];

              If (Not UseHook) then
                Send_BACSDet(2,TCode,TRunNo,ITot,NoAbort)
              else
                NoAbort:=LBACSHook(30,TRunNo,2,SPMode,ITot);
            end
            else
            Begin

              If (Not RejectB) then
                RejectB:=BOn;


              With SMemo do
              Begin
                Add(' - WARNING! - ');
                Add(ConCat('Check bank details for account ',dbFormatName(CustCode,Company),'.'));

              end;

              LBACSHook(60,TRunNo,0,SPMode,0.0);
            end;

        end;


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}

      If (ContTot>0) and (NoAbort) and (Not ThreadRec^.THAbort) then
      Begin

        If (Not UseHook) then
          Send_BACSDet(1,TModes[SPMode,2],TRunNo,ContTot,NoAbort)
        else
          NoAbort:=LBACSHook(31,TRunNo,1,SPMode,ContTot);

      end;

      If (Not UseHook) then
        Close_ExDef
      else
        LBACSHook(50,TRunNo,0,SPMode,0.0);

      If (Not RejectB) and (SPMode) then {* Update any TCodes *}
      Begin
        ShowStatus(1,'Updating Direct Debit instructions for Run No. '+Form_Int(TRunNo,0));

        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoAbort) and (Not ThreadRec^.THAbort) do
        With LInv do
        Begin
          ITot:=ITotal(LInv);

          If (ITot>0) then
          Begin

            KeyC:=CustCode;

            LOk:=LGetMainRec(CustF,KeyC);

            {* Check for BACS type?? *}
             With LCust do
              If (LOk) and (Not EmptyKey(BankSort,BankSLen))
                      and (Not EmptyKey(BankAcc,BankALen))
                      and (PayType=BACSRCode) then
              Begin

                If (DirDeb<>1) then
                Begin
                  Locked:=BOff;

                  LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyC,0,CustF,BOn,Locked);

                  If (LOk) and (Locked) then
                  Begin
                    LGetRecAddr(CustF);

                    Case DirDeb of
                      0,2  :  DirDeb:=1;
                      3    :  DirDeb:=0;
                    end; {Case..}

                    LStatus:=LPut_Rec(CustF,0);

                    LReport_BError(CustF,LStatus);

                    LStatus:=LUnLockMLock(CustF);
                  end;
                end;
              end;
            end;
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end;

      end;

      With SMemo, BatchCtrl.BACSCRec do
      Begin
        Add('BACS Run No. '+Form_Int(TRunNo,0));

        If (RejectB) then
          Add('This BACS file has been rejected.')
        else
          Add('Total No. Payments : '+Form_Int(ICount,0)+'. Value '+FormatCurFloat(GenRealMask,ContTot,BOff,PayCurr));


        Add('');

        If (Not UseHook) then
          Add('BACS Import File : '+SetDrive+UseFName);
        Add('');
      end;

      If (RejectB) then
      Begin

        If (Not UseHook) then
        Begin
          Erase(BatchF);
          LReport_IOError(IOResult,BACSFName);

        end
        else
          LBACSHook(70,TRunNo,0,SPMode,0.0);


      end;

      If (UseHook) then {* Destroy hook internal object *}
        LBACSHook(80,TRunNo,0,SPMode,0.0);

    end;

  end; {Proc..}



  { ========= Procedure to Generate a Document Header ======= }

  Procedure TPayBatch.Gen_PayHed(TDate  :  LongDate;
                                 TYr,
                                 TPr,
                                 RCr    :  Byte;
                                 PayOVal,
                                 PayVar,
                                 PaySDisc,
                                 PaySDOV:  Real;
                                 PayRef :  Str10;
                                 TagRunNo,
                                 CtrlCode
                                        :  LongInt;
                                 SPMode :  Boolean;
                                 Mode   :  Byte);





  Begin

    With MTExLocal^,LInv do
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

      CXrate:=SyssCurr^.Currencies[Currency].CRates;

    {$ELSE}

      Currency:=0;

      CXrate:=SyssCurr^.Currencies[Currency].CRates;


    {$ENDIF}

      VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);

      SetTriRec(Syss.VATCurr,UseORate,VATTriR);

      OpName:=EntryRec^.LogIn;


      Case Mode of
        0  :  Begin
                InvDocHed:=BatchDocHed(SPMode);

                CustCode:=LCust.CustCode;

                CustSupp:=LCust.CustSupp;

                InvNetVal:=PayOVal;

                TotalInvoiced:=Currency_ConvFT(PayOVal,Currency,0,UseCoDayRate);

                TotalReserved:=PayVar+PaySDisc;

                Variance:=PayVar;

                PostDiscAm:=PaySDisc;

                DiscSetl:=PaySDisc;

                BDiscount:=PaySDOV;

                FolioNum:=GetNextCount(FOL,BOn,BOff,0);

                Settled:=Settled+Round_Up(BaseTotalOS(LInv),2);

                CurrSettled:=CurrSettled+CurrencyOS(LInv,BOn,BOff,BOff);

                Set_DocAlcStat(LInv);  {* Set Allocation Status *}

                If (Autho_Need(Syss.AuthMode)) then
                  HoldFlg:=HoldP;

                BatchLink:=Pay_RunNo(InvDocHed,TagRunNo);

                If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* ENv4.22 Cash Accounting set VATdate to Current VAT Period *}
                Begin

                  VATPostDate:=SyssVAT.VATRates.CurrPeriod;
                end;

                If (AllocStat=#0) then {* Only set date if fully allocated *}
                  UntilDate:=Today;



              end;


      end; {Case..}


    end; {With..}

  end; {Proc..}

  { ===== Procedure to Automaticly Generate PPY Line ====== }



  Procedure TPayBatch.Gen_AutoPPYLine(BNomCode:  LongInt;
                                      BAmount :  Real;
                                      BCr     :  Byte;
                                      CQNo    :  Str30;
                                      PayRef  :  Str20;
                                      BCCDep  :  CCDepType;
                                      UseACD  :  Boolean;
                                      BACSClr :  Boolean;
                                      Fnum,
                                      Keypath :  Integer);




  Begin

    With MTExLocal^,LId do
    Begin

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      IdDocHed:=LInv.InvDocHed;

      PDate:=LInv.TransDate;

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

      NetValue:=BAmount;

      Currency:=BCr;

      CXRate:=SyssCurr^.Currencies[Currency].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);

      NomCode:=BNomCode;

      CCDep:=BCCDep;

      If (UseACD) then {* Overwrite with Cust own cc.Dep *}
      With LCust do
      Begin
        If (Not EmptyKey(CustCC,CustKeyLen)) then
          CCDep[BOn]:=CustCC;

        If (Not EmptyKey(CustDep,CustKeyLen)) then
          CCDep[BOff]:=CustDep;
      end;

      Payment:=SetRPayment(LInv.InvDocHed);


      If ((Syss.AutoClearPay) or (BACSClr)) then
        Reconcile:=ReconC;

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);


    end; {With..}

  end; {Proc..}


  { ========== Procedure to Generate an automatich Payment ========= }

  Procedure TPayBatch.Generate_AutoPPY(PayOwnVal,
                                       PayBase,
                                       PayIBase,
                                       PaySDOV    :  Real;
                                       PayRef     :  Str10;
                                       Fnum,
                                       Keypath    :  Integer);



  Var
    PDiscAm,
    VarAm     :  Real;

    NextCQNo  :  Str80;

    PayMatch  :  Str20;

    PDiscGL   :  LongInt;

    BACSClr   :  Boolean;


  Begin

    ShowStatus(2,'Generating '+PayRef);

    NextCQNo:='';

    With MTExLocal^,BatchCtrl.BACSCRec do
    Begin
      If (SalesMode) then
        PDiscGL:=Syss.NomCtrlCodes[DiscountGiven]
      else
        PDiscGL:=Syss.NomCtrlCodes[DiscountTaken];


      BACSClr:=(PayType=BACSRCode);  {* Was setting Bacs items to autocleard, disabled 30/10/94
                                        Now soley determined by Syss.AutoClear,
                                        Re-Enabled 08/01/95, as also sets BACS paying mode! Call to
                                        AutoGenPPY line forces Clear off instead. *}


      VarAm:=Round_Up(PayBase-Currency_ConvFT(PayOwnVal,PayCurr,0,UseCoDayRate),2);

      PDiscAm:=Round_up(PayIBase-PayBase,2);

      If (PayOwnVal>0) then {* Only attribute a cq no. to a +ve payment *}
      Begin
        If (BACSClr) then
          NextCQNo:='BACS '+Form_Int(TagRunNo,0)
        else
          If (Not SalesMode) and (Not SetCQatP) then
            NextCQNo:=Get_NextChequeNo(BOn);
      end
      else
        NextCqNo:='';

      Gen_PayHed(TagRunDate,TagRunYr,TagRunPr,PayCurr,PayOwnVal,VarAm,PDiscAm,PaySDOV,PayRef,TagRunNo,TagCtrlCode,SalesMode,0);

      If (BACSClr) then
        PayMatch:='BACS '+Form_Int(TagRunNo,0)
      else
        If (Not SalesMode) then
          PayMatch:=PayRef {* Do not set CQ PPY's under one setting, as otherwise they will not
                            be seperated out *}
        else
          PayMatch:=SRCPIRef;


      Gen_AutoPPYLine(BankNom,PayOwnVal,PayCurr,NextCQNo,PayMatch,TagCCDep,UseAcCC,BOff,IDetailF,IDFolioK);

      If (VarAm<>0) then
        Gen_AutoPPYLine(Syss.NomCtrlCodes[CurrVar],VarAm,1,'','',TagCCDep,UseAcCC,BOff,IDetailF,IDFolioK);

      If (PDiscAm<>0) then
        Gen_AutoPPYLine(PDiscGL,PDiscAm,1,'','',TagCCDep,UseAcCC,BOff,IDetailF,IDFolioK);

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      If (Not Syss.UpBalOnPost) then
        LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOff,2);



    end; {With..}


  end; {Proc..}


  { ========= BACS Processing Routine ======= }


  Procedure TPayBatch.BATCH_PayProcess(Fnum,
                                       Keypath  :  Integer);



  Const
    IFnum      =  InvF;
    IKeypath   =  InvCustK;


  Var
    KeyS,
    KeyChk,
    KeyIS,
    KeyIChk    :  Str255;

    PayRef     :  Str10;

    LOk,
    NeedHed,
    Locked     :  Boolean;

    DiscSign   :  Integer;

    ItemCount   :  LongInt;

    B_Func      :  Integer;

    BColNo,
    UOR,
    BHoldMode   :  Byte;

    TmpPWord    :  PassWordRec;



    PayOwnVal,
    PaySDOwnVal,
    PayBase,
    PayIBase,
    DocINow,
    DocIThen,
    DocNow,
    DocThen     :  Real;

    EInv        :  InvRec;

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


    BColNo:=0;  UOR:=0;
    BHoldMode:=0;

    PayRef:='';

    B_Func:=B_GetNext;

    ItemCount:=0;

    With MTExLocal^,BatchCtrl.BACSCRec do
    Begin

      InitProgress(TagCount);

      ShowStatus(1,'Batch Run No. '+Form_Int(TagRunNo,0));

      With ExtCustRec^ do
      Begin
        FCr:=InvCurr;

        FNomAuto:=BOn;

        FMode:=3;

        FAlCode:=TradeCode[SalesMode];
        FCSCode:=FALCode;

        FCtrlNom:=TagCtrlCode;

        FDirec:=BOn;

        FB_Func[BOff]:=B_GetPrev;
        FB_Func[BOn]:=B_GetNext;

      end;

      KeyChk:=PartCCKey(MBACSCode,MBACSSub)+FullNomKey(TagRunNo);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
      With LMiscRecs^.BACSSRec do
      Begin

        NeedHed:=BOn;

        PayOwnVal:=0;
        PayBase:=0;
        PayIBase:=0.0;

        KeyIS:=TagCustCode;

        LOk:=LGetMainRec(CustF,KeyIS);

        With LCust do
          ShowStatus(2,'Processing '+dbFormatName(CustCode,Company));

        If (LOk) then
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          If (TotalTagged[0]<>0) then
          Begin

            With LCust do
              KeyIChk:=FullLedgerKey(CustCode,CustSupp,BOn);

            KeyIS:=KeyIChk;

            With ExtCustRec^ do
            Begin
              FCusCode:=TagCustCode;
            end;

            LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,IFnum,IKeypath,B_GetGEq,1,KeyIS);

            While (LStatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (Not ThreadRec^.THAbort) do
            With LInv do
            Begin
              EInv:=LInv;

              If (ExtCusFiltCid(0,ExtCustRec,CustAlObj)) and (Not SettledFull(LInv)) then
              Begin
                BColNo:=Succ(AgedPos(Get_StaChkDate(LInv),TagAsDate,AgeType,AgeInt));

                If ((Tagged) or ((HasTagged[BColNo]) and (Not UnTagged))) and (FolioNum<=LastInv) then {* Include this Item *}
                Begin
                  LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyIS,IKeyPath,IFnum,BOn,Locked);

                  If (LOk) and (Locked) then
                  Begin
                    LGetRecAddr(IFnum);

                    If (NeedHed) then
                    Begin

                      PayRef:=FullDocNum(BatchDocHed(SalesMode),BOn);

                      NeedHed:=BOff;

                    end;

                    {DocI* = Value including discount added back in}

                    If (Tagged) then
                    Begin
                      DocThen:=BatchThen;

                      DocNow:=BatchNow;

                      DiscSign:=DocCnst[InvDocHed]*DocNotCnst;

                      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                      DocIThen:=DocThen+(Round_Up(Conv_TCurr(BDiscount,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2)
                                         *DiscSign);

                      DocINow:=DocNow+(Round_Up(BDiscount,2)*DiscSign);
                    end
                    else
                    Begin
                      ForceInvSDisc(LInv,EInv,BatchCtrl,1);

                      DocThen:=BaseTotalOS(EInv);

                      DocNow:=CurrencyOS(EInv,BOn,BOff,BOff);

                      DocIThen:=BaseTotalOS(LInv);

                      DocINow:=CurrencyOS(LInv,BOn,BOff,BOff);
                    end;



                    {$IFDEF MC_On}

                      If (PayCurr=Currency) then
                      Begin
                        PayOwnVal:=PayOwnVal+DocNow;

                        PaySDOwnVal:=PaySDOwnVal+DocINow;
                      end
                      else
                      Begin
                        PayOwnVal:=PayOwnVal+Currency_ConvFT(DocThen,0,PayCurr,UseCoDayRate);
                        PaySDOwnVal:=PaySDOwnVal+Currency_ConvFT(DocIThen,0,PayCurr,UseCoDayRate);

                      end;

                    {$ELSE}

                      PayOwnVal:=PayOwnVal+DocThen;
                      PaySDOwnVal:=PaySDOwnVal+DocIThen;

                    {$ENDIF}


                    PayBase:=PayBase+DocThen;

                    PayIBase:=PayIBase+DocIThen;

                    Tagged:=BOff;
                    UnTagged:=BOff;
                    {* Update invoice *}

                    Settled:=Settled+DocIThen;

                    CurrSettled:=CurrSettled+DocINow;

                    Set_DocAlcStat(LInv);

                    RemitNo:=PayRef;

                    BatchNow:=0; BatchThen:=0; BDiscount:=0.0;

                    If (GetHoldType(HoldFlg)=HoldA) then
		      BHoldMode:=HoldDel;

		    SetHold(BHoldMode,IFnum,IKeyPAth,BOff,LInv);


                    If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* ENv4.22 Cash Accounting set VATdate to Current VAT Period *}
                    Begin

                      VATPostDate:=SyssVAT.VATRates.CurrPeriod;
                    end;

                    If (AllocStat=#0) then {* Only set date if fully allocated *}
                      UntilDate:=Today;



                    LStatus:=LPut_Rec(IFnum,IKeyPath);

                    LReport_BError(IFnum,LStatus);

                    LStatus:=LUnLockMLock(IFnum);

                    TmpPWord:=BatchCtrl;

                    {$IFDEF MC_On}

                      LMatch_Payment(LInv,DocIThen,DocINow,3);

                    {$ELSE}  {* Just in case AddNow causes problems on SC *}

                      LMatch_Payment(LInv,DocIThen,DocIThen,3);

                    {$ENDIF}

                    BatchCtrl:=TmpPWord;

                  end; {If Locked..}

                end; {If Part of Tag..}

              end; {If Passes Filter}

              LStatus:=GetExtCusALCId(ExtCustRec,CustAlObj,IFnum,IKeypath,B_GetNext,1,KeyIS);


            end; {While..}


            If (Not NeedHed) then {* Generate PPY Hed *}
            Begin

              PayOwnVal:=PayOwnVal*DocCnst[BatchDocHed(SalesMode)];

              PaySDOwnVal:=PaySDOwnVal*DocCnst[BatchDocHed(SalesMode)];

              PayBase:=PayBase*DocCnst[BatchDocHed(SalesMode)];

              PayIBase:=PayIBase*DocCnst[BatchDocHed(SalesMode)];

              Generate_AutoPPY(PayOwnVal,PayBase,PayIBase,PaySDOwnVal,PayRef,IFnum,IKeypath);

            end;

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

    end; {With..}

  end; {Proc..}




  Procedure TPayBatch.BATCH_SetCqNo(MatchK      :  Str255;
                                    Fnum2,
                                    Keypath2    :  Integer);


  Const
      Fnum     =  InvF;

      Keypath  =  InvBatchK;


  Var
    KeyS,
    KeyChk,
    KeyIChk,
    KeyIS   :  Str255;

    TmpFVar :  FileVar;

    LOk,
    FoundOk,
    Locked  :  Boolean;



  Begin

    KeyChk:=MatchK;

    KeyS:=KeyChk;

    FoundOk:=BOff;

    With MTExLocal^ do
    Begin

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not ThreadRec^.THAbort) do
      With LInv do
      Begin

        Locked:=BOff;

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) and (ITotal(LInv)>0) then {* Only Re-Number +ve Payments *}
        Begin
          LGetRecAddr(Fnum);

          KeyIChk:=Strip('R',[#0],FullIdKey(FolioNum,RecieptCode));

          KeyIS:=KeyIChk;

          FoundOk:=BOff;


          LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyIS);

          While (LStatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (Not FoundOk) and (Not ThreadRec^.THAbort) do
          With LId do
          Begin

            FoundOk:=(Not EmptyKey(Desc,DocDesLen));

            If (FoundOk) then
            Begin


              Desc:=Get_NextChequeNo(BOn);

              LStatus:=LPut_Rec(Fnum2,KeyPath2);

              LReport_BError(Fnum2,LStatus);
            end
            else
              LStatus:=LFind_Rec(B_GetNext,Fnum2,KeyPath2,KeyIS);

          end; {While..}

          LStatus:=LUnLockMLock(Fnum);


        end;


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}
    end;

  end; {Proc..}




  { =========== Procedure to Run Process and Re-Print =========== }



  Procedure TPayBatch.BATCH_PayCtrl(Fnum,
                                    Keypath  :  Integer;
                                    ReRun,
                                    SPMode   :  Boolean);



  Var
    BACSMode :  Boolean;


  Begin

    If (Not ReRun) then
      BACS_CtrlGet(PWrdF,PWK,BatchCtrl,SPMode,MTExLocal);

    With BatchCtrl.BACSCRec do
    Begin

      {If (Not ReRun) then
        Abort:=Inp_BACSDate(TagRunDate,TagRunYr,TagRunPr,'Set Batch '+BatchPTit(SalesMode)+' Date');}

      BACSMode:=(PayType=BACSRCode);

      If (Not ReRun) then
        BATCH_PayProcess(Fnum,Keypath)
      else
        If (CQStart<>0) and (Not BACSMode) and (Not SalesMode) and (Not SetCQatP) then  {* ReSet CQ No. }
          BATCH_SetCQNo(Pay_RunNo(PPY,TagRunNo),IDetailF,IdFolioK);


      If (BACSMode) then
        Send_BACS(Pay_RunNo(BatchDocHed(SalesMode),TagRunNo),TagRunNo,SalesMode);

        {BATCH_PayPrint(Pay_RunNo(BatchDocHed(SalesMode),TagRunNo),Abort,IDetailF,IdFolioK,Ord(BACSMode),
                         DEFDEFMode[BatchDocHed(SalesMode)]);}


      If (Not ReRun) then
      Begin

        Blank(TotalTag,Sizeof(TotalTag));

        TagCount:=0;

        TagStatus:=BOff;

        LastTagRunNo:=TagRunNo;
        
        TagRunNo:=BACS_GetRunNo(BOn,SPMode,MTExLocal);

        CQStart:=IntStr(Get_NextChequeNo(BOff));

        BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal);

      end;

    end; {With..}

  end; {Proc..}




  Procedure TPayBatch.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    With BatchCtrl.BACSCRec do
      ShowStatus(0,' - Process Batch '+BatchPTit(SalesMode)+'s - ');

    With MTExLocal^ do
    Begin

      CustAlObj.MTExLocal:=MTExLocal;

      Batch_PayCtrl(MiscF,MIK,OReRun,OSPMode);
    end;

  end;


  Procedure TPayBatch.Finish;
  Begin

    With BatchCtrl.BACSCRec do
    Begin
      If (SMemo.Count>0) then
        AddMemoRep2Thread(RFormRep^.PParam.PDevRec,SMemo,'Batch '+BatchPTit(SalesMode)+' Status',Application.MainForm);

      If (Not ThreadRec^.THAbort) then {* Print Docs *}
      Begin
        {* Allow form to set CQ no if not bacs run *}
        
        RFormRep^.PParam.PDevRec.ChequeMode:=(SetCQatP) and (PayType<>BACSRCode);

        Start_PPYThread(Application.MainForm,Pay_RunNo(BatchDocHed(SalesMode),ThisRunNo),RFormRep);
      end;
    end;

    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

    {* Inform input window batch has been calculated *}

    SendMessage(CallBackH,WM_CustGetRec,55,0);

  end;



  Function TPayBatch.Start(BCtrl    :  PassWordRec;
                           InpWinH  :  THandle)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOn;

    Begin
      If (Not Assigned(PostExLocal)) then { Open up files here }
        Result:=Create_ThreadFiles;

      ThisRunNo:=-1;

      If (Result) then
      Begin
        MTExLocal:=PostExLocal;
        BatchCtrl:=BCtrl;

        ThisRunNo:=BatchCtrl.BACSCRec.TagRunNo;

        CallBackH:=InpWinH;
      end;
    end;
  end;

{ ============== }


Procedure AddBACSPay2Thread(AOwner   :  TObject;
                            BCtrl    :  PassWordRec;
                            RRun,
                            SPMode   :  Boolean;
                            FormRep  :  PFormRepPtr;
                            MyHandle :  THandle);


  Var
    LCheck_Batch :  ^TPayBatch;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          OReRun:=RRun; OSPMode:=SPMode;
          RFormRep^:=FormRep^;

          If (Start(BCtrl,MyHandle)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,'Process Batch');
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




end.