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
                      {SS 03/08/2016 2016-R3
                       ABSEXCH-12818:Batch Payment - Range Check Error
                      -Change datatype from Longint to Double because exception raises when user input larger value then Longint datatype can store.
                      Longint Range = -2147483648...2147483647}
                      AmountP   :  Double;
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

                       IgnoreHook :  Boolean;
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
                                           Dig     :  Integer)  :  Str20; overload;
                       Function Form_ZInt (Inum    :  Double;
                                           Dig     :  Integer)  :  Str20; overload;

                       Function Pennies(Inum  :  Real) : LongInt;  overload;
                       Function Pennies(Inum  :  Double) : Double; overload;

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
                                           SPMode,
                                           ReRun       :  Boolean);


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

                       // CJS 2015-07-07 - ABSEXCH-16578 - PPD Write-Off uses wrong Control Code
                       Procedure Generate_AutoPPY(PayOwnVal,
                                                 PayBase,
                                                 PayIBase,
                                                 PaySDOV    :  Real;
                                                 PayRef     :  Str10;
                                                 Fnum,
                                                 Keypath    :  Integer;
                                                 UseSettlementDiscount: Boolean = False);


                       Function LBACSHook2(HID     :  LongInt)  :  Boolean;

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

  {$IFDEF JC}
    JChkUseU,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ReportHU,
  FrmThrdU,
  DocSupU1,
  BPyItemU,
  ExBtTh1U,
  SalTxl1U,
  PassWR2U,
  LedgSupU,
  ExThrd2U,
  AuditNotes,


  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  //PR: 25/07/2013 Added for SEPA
  EncryptionUtils,

  MathUtil,
  oSystemSetup,

  // CJS 2015-05-26 - v7.0.14 - T2-158 - Batch Payment / Sales Receipt processing
  PromptPaymentDiscountFuncs,
  oTakePPD,
  TransactionHelperU
  ;



   Const
     BACSFName   =  'EXCHBACS.IMP';
     DDebFName   =  'EXCHDDEB.IMP';
     BANKFiltSet :  CharSet = [#32,'&','.','/','-','\'];




  { ========== TPayBatch methods =========== }

  Constructor TPayBatch.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpHigher;
    fSetPriority:=BOn;

    IsParentTo:=BOn;
    
    IgnoreHook:=BOff;

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

  {SS 03/08/2016 2016-R3
   ABSEXCH-12818:Batch Payment - Range Check Error and Run number not incrementing
   when BACS payment over £21m with no BACS software installed.}

  {====== Function to Format an Double No. & return in Str Format =====}
  Function TPayBatch.Form_ZInt (Inum : Double; Dig : Integer)  :  Str20;
  Var
    TmpStr  :  Str50;   
  Begin
    TmpStr:='';
    //AP 23/10/2017 ABSEXCH-19334 CLONE-Change to the BACs file that is produced in a Payment or Receipt batch - Patch required for 2017 R1
    TmpStr:=ConstStr('0',Dig-Length(FloatToStr(Inum)))+FloatToStr(Inum);
    Form_ZInt:=TmpStr;
  end;


  { ==== Function to convert Real No into Pennies Equivalent ==== }


  Function TPayBatch.Pennies(Inum  :  Real) : LongInt;
  Begin
    Pennies:=Round(Inum * 100);
  end;

  {SS 03/08/2016 2016-R3
   ABSEXCH-12818:Batch Payment - Range Check Error and Run number not incrementing
   when BACS payment over £21m with no BACS software installed.}
  { ==== Function to convert Double No into Pennies Equivalent ==== }

  Function TPayBatch.Pennies(Inum  :  Double) : Double;
  begin
    Pennies:=Round(Inum * 100);
  end;


  { ===== Function to Filter an NON BACS legal Chars ====== }


  Function TPayBatch.BACS_Safe(TStr  :  Str255)  :  Str255;

  Const
    BACSAll :  CharSet = [#32,'&','.','/','0'..'9','A'..'Z'];


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

                 //PR: 25/07/2013 Added handling for SEPA fields
                 DestSort:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankSortCode(Syss.ssBankSortCode)));
                 DestAcc:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankAccountCode(Syss.ssBankAccountCode)));

                 CompSort:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankSortCode(Syss.ssBankSortCode)));
                 CompAcc:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankAccountCode(Syss.ssBankAccountCode)));


                 If (EmptyKey(Syss.UserRef,BankRLen)) then
                   CompName:='BACS '+Form_Int(TRunNo,0)
                 else
                   CompName:=BACS_Safe(Syss.UserRef);

                 CompRef:=LJVar('CONTRA',Pred(Sizeof(CompRef)));

                 DestName:=BACS_Safe(Syss.UserName);

               end;


        2   :  Begin

                 DestSort:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankSortCode(LCust.acBankSortCode)));
                 DestAcc:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankAccountCode(LCust.acBankAccountCode)));

                 CompSort:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankSortCode(Syss.ssBankSortCode)));
                 CompAcc:=BACS_Safe(Strip('A',BankFiltSet,DecryptBankAccountCode(Syss.ssBankAccountCode)));

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
                                SPMode,
                                ReRun       :  Boolean);


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
    GetReRunCurr,
    NoAbort,
    UseHook,
    RejectB :  Boolean;

    OPayCurr,
    TCode   :  Byte;

    ContTot,
    ITot    :  Real;

    OBankNom,
    ICount  :  LongInt;

    TCh     :  Char;

    UseFName:  Str255;


  {== Func to return a previous runs bank G/L ==}

  Procedure Get_BankNom(Var BNom  :  LongInt;
                            ICurr :  Byte);

  Const
    IFnum     =  IDetailF;

    IKeypath  =  IdFolioK;

  Var
    IKeyChk,
    IKeyS     :    Str255;

    IFoundOk  :    Boolean;

  Begin
    With MTExLocal^ do
    Begin
      IKeyChk:=FullNomKey(LInv.FolioNum);
      IKeyS:=IKeyChk;

      IFoundOk:=BOff;

      LStatus:=LFind_Rec(B_GetGEq,IFnum,IKeyPath,IKeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoAbort) and (Not ThreadRec^.THAbort) and (Not IFoundOK) do
      With LId do
      Begin
        IFoundOk:=(Currency=ICurr);

        If (Not IFoundOk) then
          LStatus:=LFind_Rec(B_GetNext,IFnum,IKeyPath,IKeyS)
        else
          BNom:=NomCode;

      end;
    end;
  end;

  Procedure Refresh_ReRun;

  Begin
    KeyS:=KeyChk;

    With MTExLocal^ do
    Begin
      ShowStatus(1,'Please Wait. Establishing previous BACS details for Run '+Form_Int(TRunNo,0));

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoAbort) and (Not ThreadRec^.THAbort) and (Not GetReRunCurr) do
      With LInv do
      Begin
        {$IFDEF MC_On}
          GetReRunCurr:=(Currency>1);
        {$ELSE}
          GetReRunCurr:=BOn;
        {$ENDIF}

        If (Not GetReRunCurr) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS)
        else
        Begin
          If (LInv.Currency<>BatchCtrl.BACSCRec.PayCurr) then
            BatchCtrl.BACSCRec.PayCurr:=LInv.Currency;

          Get_BankNom(BatchCtrl.BACSCRec.BankNom,BatchCtrl.BACSCRec.PayCurr);
        end;


      end;
    end; {With..}

    KeyS:=KeyChk;
  end;

  Begin

    KeyChk:=MatchK;

    KeyS:=KeyChk;

    NoAbort:=BOn;

    ContTot:=0;

    ITot:=0;

    ICount:=0;

    RejectB:=BOff;  GetReRunCurr:=BOff;

    TCh:=ResetKey;

    If (SPMode) then
      UseFName:=DDebFName
    else
      UseFName:=BACSFName;

    UseHook:=LBACSHook(01,0,0,BOff,0.0);

    OPayCurr:=BatchCtrl.BACSCRec.PayCurr;
    OBankNom:=BatchCtrl.BACSCRec.BankNom;

    ShowStatus(0,'BACS '+BatchPTit(BatchCtrl.BACSCRec.SalesMode)+'s - ');


    {Scan first payment/receipt for run and set batch currency to payment/receipt currency}

    If (ReRun) then
      Refresh_ReRun;

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

          With LCust do //PR: 25/07/2013 Amended for SEPA codes
            If (LOk) and (PayType=BACSRCode)  and ((Not UseHook and (Not EmptyKeyS(acBankSortCode,BankSLen,BOff))
                    and (Not EmptyKeyS(acBankAccountCode,BankALen,BOff))) or
                    (UseHook and LBACSHook(20,TRunNo,0,SPMode,0.0))) then
            Begin
              
          
          {$B+}

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
             With LCust do //PR: 25/07/2013 Added handling for SEPA
              If (LOk) and (Not EmptyKey(acBankSortCode,BankSLen))
                      and (Not EmptyKey(acBankAccountCode,BankALen))
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

      {* Restore last currency just in case *}
      If (GetReRunCurr) then
      Begin
        BatchCtrl.BACSCRec.PayCurr:=OPayCurr;
        BatchCtrl.BACSCRec.BankNom:=OBankNom;
      end;

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

      { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
      TransactionOriginator.SetOriginator(LInv);

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

                {$IFDEF EXSQL}
                if SQLUtils.UsingSQL then
                  FolioNum:=LGetNextCount(FOL,BOn,BOff,0)
                else
                {$ENDIF}
                  FolioNum:=GetNextCount(FOL,BOn,BOff,0);

                Settled:=Settled+Round_Up(BaseTotalOS(LInv),2);

                CurrSettled:=CurrSettled+CurrencyOS(LInv,BOn,BOff,BOff);

                Set_DocAlcStat(LInv);  {* Set Allocation Status *}

                If (Autho_Need(Syss.AuthMode)) then
                  HoldFlg:=HoldP;

                BatchLink:=Pay_RunNo(InvDocHed,TagRunNo);

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



  Var
    NewObject  :  Boolean;

  Begin

    With MTExLocal^,LId, BatchCtrl.BACSCRec do
    Begin

      LResetRec(Fnum);

      CustCode := LInv.CustCode;

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

      ABSLineNo:=LInv.ILineCount;

      Inc(LInv.ILineCount);


      NetValue:=BAmount;

      Currency:=BCr;

      CXRate:=SyssCurr^.Currencies[Currency].CRates;

      SetTriRec(Currency,UseORate,CurrTriR);

      NomCode:=BNomCode;

      CCDep:=BCCDep;

      If (UseACD) then {* Overwrite with Cust own cc.Dep *}
      With LCust do
      Begin
        CCDep:=GetCustProfileCCDep(CustCC,CustDep,CCDep,0);

        {* If account defaults are blank, revert to input defaults *}
        
        If (EmptyKey(CCDep[BOn],CCKeyLen)) then
          CCDep[BOn]:=BCCDep[BOn];

        If (EmptyKey(CCDep[BOFF],CCKeyLen)) then
          CCDep[BOFF]:=BCCDep[BOFF];

      end;

      Payment:=SetRPayment(LInv.InvDocHed);


      If ((Syss.AutoClearPay) or (BACSClr)) then
        Reconcile:=ReconC;

      {$IFDEF CU}
        If (Not IgnoreHook) and (LHaveHookEvent(2050,101-Ord(SalesMode),NewObject)) then
        Begin
          try
            LExecuteHookEvent(2050,101-Ord(SalesMode),MTExLocal^);
            IgnoreHook:=BOff;
          except
            IgnoreHook:=BOn;
          end; {try..}
        end;
      {$ENDIF}


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
                                       Keypath    :  Integer;
                                       UseSettlementDiscount: Boolean);



  Var
    PDiscAm,
    VarAm     :  Real;

    NextCQNo  :  Str80;

    PayMatch  :  Str20;

    PDiscGL   :  LongInt;

    BACSClr   :  Boolean;

    PPDValue: Double;
  Begin

    ShowStatus(2,'Generating '+PayRef);

    NextCQNo:='';

    With MTExLocal^,BatchCtrl.BACSCRec do
    Begin

      // CJS 2015-07-07 - ABSEXCH-16578 - PPD Write-Off uses wrong Control Code
      if UseSettlementDiscount then
      begin
        // Pre-April 2015 - Settlement Discount
        If (SalesMode) then
          PDiscGL:=Syss.NomCtrlCodes[DiscountGiven]
        else
          PDiscGL:=Syss.NomCtrlCodes[DiscountTaken];
      end
      else
        // Post-April 2015 - Prompt Payment Discount
        PDiscGL := SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL;


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

      // MH 08/07/2010 v6.4 ABSEXCH-10017: Added YourRef field into Batch Payments/Receipts Wizard
      LInv.YourRef := BatchCtrl.BACSCRec.YourRef;

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

      //GS 03/11/2011 added audit note to the PPY record that gets created
      if Status = 0 then
      begin
        TAuditNote.WriteAuditNote(anTransaction, anCreate, TdMTExLocalPtr(MtExLocal)^);
      end;

      LReport_BError(Fnum,LStatus);

      If (Not Syss.UpBalOnPost) then
        LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOff,2);



    end; {With..}


  end; {Proc..}


  Function TPayBatch.LBACSHook2(HID     :  LongInt)  :  Boolean;


  Var
    NewObject  :  Boolean;

  Begin
    Result:=BOn;

    {$IFDEF CU}
      If (LHaveHookEvent(2050,HID,NewObject)) then
      Begin
        try
          Result:=LExecuteHookEvent(2050,HId,MTExLocal^);

        except
          Result:=BOn;
        end; {try..}
      end;
    {$ENDIF}
  end;

  { ========= BACS Processing Routine ======= }


Procedure TPayBatch.BATCH_PayProcess(Fnum, Keypath: Integer);
Const
  IFnum = InvF;
Var
  KeyS,
  KeyChk,
  KeyIS,
  KeyIChk    :  Str255;

  PayRef     :  Str10;

  SetDTaken,
  LOk,
  UseOSKey,
  NeedHed,
  Locked     :  Boolean;

  B_Func,
  B_Func2,
  DiscSign   :  Integer;

  ItemCount  :  LongInt;

  IKeypath   :  Integer;

  BColNo,
  UOR,
  BHoldMode  :  Byte;

  TmpPWord   :  PassWordRec;

  PayOwnVal,
  PaySDOwnVal,
  PayBase,
  PayIBase,
  DocINow,
  DocIThen,
  DocNow,
  DocThen    :  Real;

  EInv       :  InvRec;

{$IFDEF EXSQL}
  lSQLPrefillCacheID : LongInt;
  lSQLWhereClause : ANSIString;
  lSQLColumns : ANSIString;
  lSQLPFCRes : LongInt;
{$ENDIF}

  // CJS 2015-05-26 - v7.0.14 - T2-158 - Batch Payment / Sales Receipt processing
  PPDAvailableInBase: Double;
  PPDAvailableInCurrency: Double;
  TakePPD: ITakePPD;
  TakePPDStatus: Integer;
  HasPPD: Boolean;

  //------------------------------

  {$IFDEF EXSQL}
  // MH 07/12/2009: To speed up processing in the SQL Edition delete any non-tagged rows
  // at the start so the emulator doesn't even see them
  Procedure DeleteUnTaggedEntries (Const RunNo : LongInt);
  Var
    sCompany : ShortString;
    sWhere : ANSIString;
  Begin // DeleteUnTaggedEntries
    sCompany := GetCompanyCode(SetDrive);
    sWhere := '(RecMFix=''X'') And (SubType=''S'') And ' +
              '(TagRunNo = ' + IntToStr(RunNo) + ') And ' +
              '(TotalTagged1 = 0)';

    // CJS 2011-10-19: ABSEXCH-11513 - discarding cached data is now handled
    //                 automatically by DeleteRows().
    DeleteRows(sCompany, 'ExStkChk.Dat', sWhere, MTExLocal^.ExClientID);

    // Dump cache to ensure no emulator issues
    // DiscardCachedData('ExStkChk.Dat', MTExLocal^.ExClientID);
  End; // DeleteUnTaggedEntries
  {$ENDIF}

  //------------------------------

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
  BColNo:=0;
  UOR:=0;
  BHoldMode:=0;
  B_Func:=B_GetNext;
  PayRef:='';
  UseOSKey:=BOff;
  IKeypath:=InvCustK;
  B_Func2:=B_GetNext;
  ItemCount:=0;
  HasPPD := False;
  TakePPDStatus := 0;

  With MTExLocal^, BatchCtrl.BACSCRec do
  Begin
    // Initialise the Object Thread Controller progress display
    InitProgress(TagCount);
    ShowStatus(1, 'Batch Run No. ' + Form_Int(TagRunNo, 0));

    // If this is a post-v5 Exchequer version, use the new index
    UseOSKey := BatchCtrl.BacsCRec.UseOsNdx;

    If (UseOSKey) then
      IKeyPath := InvOSK
    else
      IKeyPath := InvCustK;

    // Populate the structure used by the Extended Btrieve commands
    With ExtCustRec^ do
    Begin
      FCr := InvCurr;

      FNomAuto := BOn;

      FMode := 3;

      FAlCode := TradeCode[SalesMode];
      FCSCode := FALCode;

      FCtrlNom := TagCtrlCode;

      FDirec := BOn;

      FB_Func[BOff] := B_GetPrev;
      FB_Func[BOn]  := B_GetNext;

    end;

    {$IFDEF EXSQL}
      // MH 07/12/2009: To speed up processing in the SQL Edition delete any non-tagged rows
      // at the start so the emulator doesn't even see them
      If SQLUtils.UsingSQLAlternateFuncs Then
      Begin
        DeleteUnTaggedEntries(TagRunNo);
      End; // If SQLUtils.UsingSQLAlternateFuncs
    {$ENDIF}

    // Set up a key to find all the 'XS' MiscF records (the header records for
    // each Trader Account included in the Batch Payments run), taking the run
    // number from the control record (BatchCtrl.BACSCRec)
    KeyChk := PartCCKey(MBACSCode, MBACSSub) + FullNomKey(TagRunNo);
    KeyS   := KeyChk;

    // Work through all the matching records
    LStatus := LFind_Rec(B_GetGEq, Fnum, KeyPath, KeyS);
    While (LStatusOk) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) and (Not ThreadRec^.THAbort) do
    With LMiscRecs^.BACSSRec do
    Begin

      NeedHed   := BOn;
      PayOwnVal := 0;
      PayBase   := 0;
      PayIBase  := 0.0;

      // Retrieve the actual Trader Record
      KeyIS := TagCustCode;
      LOk   := LGetMainRec(CustF, KeyIS);

      // Update the progress message on the Object Thread Controller
      With LCust do
        ShowStatus(2, 'Processing ' + dbFormatName(CustCode, Company));

      // CJS 2015-05-27 - v7.0.14 - T2-158 - Batch Payment / Sales Receipt processing
      TakePPD := GetTakePPD;

      //PR: 26/05/2016 ABSEXCH-17505 Share ExLocal instance with TakePPD object
      TakePPD.tpExLocal := MTExLocal;
      TakePPD.tpDate := TagAsDate;
      TakePPD.tpAccount := LCust;

      // Lock the Batch Payments Account record
      If (LOk) then
        LOk := LGetMultiRec(B_GetDirect, B_MultLock, KeyS, KeyPath, Fnum, BOn, Locked);

      If (LOk) and (Locked) then
      Begin
        // Retrieve the record address (into MTExLocal.LastRecAddr[])
        LGetRecAddr(Fnum);

        // Only process records if transactions have been tagged
        If (TotalTagged[0] <> 0) then
        Begin

          // Set up a key to find all the Transactions against the current
          // Trader Account
          With LCust do
          If (UseOSKey) then
            KeyIChk := TradeCode[BatchCtrl.BacsCRec.SalesMode] + FullCustCode(CustCode)
          else
            // Obsolete version, no longer used
            KeyIChk := FullLedgerKey(CustCode, CustSupp, BOn);

          KeyIS := KeyIChk;

          // Copy the current Trader code into the Extended Btrieve search
          // structure
          With ExtCustRec^ do
          Begin
            FCusCode := TagCustCode;
          end;

          {$IFDEF EXSQL}
          // For SQL, use a standard search with a Prefill Cache 'WHERE' clause
          // to find only transactions which are still outstanding
          If SQLUtils.UsingSQLAlternateFuncs Then
          Begin
            lSQLWhereClause :=  '(thOutstanding=' + QuotedStr(ExtCustRec^.FAlCode) + ') ' +
                                'And (thAcCodeComputed=' + QuotedStr(ExtCustRec^.FCusCode) + ')';

            If (ExtCustRec^.FCr <> 0) Then
              lSQLWhereClause := lSQLWhereClause + ' And (thCurrency=' + IntToStr(ExtCustRec^.FCr) + ')';

            lSQLColumns := '';
            lSQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[IFnum], lSQLWhereClause, lSQLColumns, lSQLPrefillCacheID, MTExLocal^.ExClientId);

            If (lSQLPFCRes = 0) Then
              UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
            LStatus := LFind_Rec(B_GetGEq,IFnum,IKeypath,KeyIS)
          End // If SQLUtils.UsingSQLAlternateFuncs
          Else
          {$ENDIF}
          Begin
            // For Pervasive, use an Extended Btrieve search to find only
            // transactions which are still outstanding
            lSQLPFCRes := -1;
            LStatus := GetExtCusALCid(ExtCustRec, CustAlObj, IFnum, IKeypath, B_GetGEq, 1, KeyIS);  // Effectively a GetGEq
          End;

          // Work through all the Transactions against this Trader
          While (LStatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (Not ThreadRec^.THAbort) do
          With LInv do
          Begin
            EInv := LInv;

            B_Func2 := B_GetNext;

              // Only process Transactions which are still outstanding (not fully
              // settled). Also allow the Batch Payments hook point (2050, 174/5)
              // to accept or reject the Transaction.

              // CJS 2015-03-02 - ABSEXCH-16164 - Exclude Order Payment SRCs from Batch Receipts
              // Added check for Order Payments Sales Receipts
              If (ExtCusFiltCid(0,ExtCustRec,CustAlObj)) and (Not SettledFull(LInv)) and LBACSHook2(174+Ord(BatchCtrl.BACSCRec.SalesMode))
                and ((LInv.thOrderPaymentElement = opeNA) or (LInv.InvDocHed <> SRC)) then
            Begin
              // Determine which Aging column this Transaction would appear in
              BColNo:=Succ(AgedPos(Get_StaChkDate(LInv),TagAsDate,AgeType,AgeInt));

              // Include this Transaction if it is tagged, or if it is in an
              // Aging column which is marked as being tagged at the account
              // level and the transaction has not been explicitly excluded.

              // Exclude the Transaction if it was added after the user began
              // this Batch Payments/Sales Receipts run.
              If ((Tagged = 1) or ((HasTagged[BColNo]) and (Not UnTagged))) and (FolioNum<=LastInv) then {* Include this Item *}
              Begin
                {$IFDEF EXSQL}
                  If (lSQLPFCRes = 0) Then
                    UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
                {$ENDIF}

                // Lock the Transaction record
                LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyIS,IKeyPath,IFnum,BOn,Locked);

                If (LOk) and (Locked) then
                Begin
                  {$IFDEF EXSQL}
                    If (lSQLPFCRes = 0) Then
                      UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
                  {$ENDIF}
                  // Retrieve the Transaction record address (into MTExLocal.LastRecAddr[])
                  LGetRecAddr(IFnum);

                  // If we haven't added the Batch Payments / Sales Receipts
                  // Transaction yet, get a new document number for it
                  If (NeedHed) then
                  Begin
                    {$IFDEF EXSQL}
                    if SQLUtils.UsingSQL then
                      PayRef:=LFullDocNum(BatchDocHed(SalesMode),BOn)
                    else
                    {$ENDIF}
                      PayRef:=FullDocNum(BatchDocHed(SalesMode),BOn);

                    NeedHed:=BOff;
                  end;

                  {DocI* = Value including discount added back in}

                  {$B-}
                  { CJS 2012-11-13 - ABSEXCH-13670
                    Amended BDiscount/DiscSetAm check to avoid rounding
                    errors under SQL (BDiscount is Double, DiscSetAm is
                    Real). }
                  If (BDiscount<>0.0) and (Round_Up(BDiscount, 6)=Round_Up(DiscSetAm, 6)) and (IncSDisc) and (RunNo=0) and (Settled=0.0) then
                  {$B+}
                  {* Lets set settlement discount by taking it *}
                  Begin
                    If (Not Syss.UpBalOnPost) then {* We will be reducing value, so have to reduce balance *}
                      // Post the balance to History
                      LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOn,2);

                    DiscTaken := BOn;
                    BDiscount := 0.0;
                    SetDTaken := BOn;
                  end
                  else
                    SetDTaken := BOff;

                  If (Tagged = 1) then
                  Begin
                    // This Transaction was individually tagged
                    DocThen  := BatchThen;
                    DocNow   := BatchNow;
                    DiscSign := DocCnst[InvDocHed] * DocNotCnst;
                    UOR      := fxUseORate(BOff, BOn, CXRate, UseORate, Currency, 0);

                    DocIThen := DocThen + (Round_Up(Conv_TCurr(BDiscount, XRate(CXRate, BOff, Currency), Currency, UOR, BOff), 2)
                                           * DiscSign);

                    DocINow  := DocNow + (Round_Up(BDiscount, 2) * DiscSign);
                  end;

                  //PR: 28/08/2015 ABSEXCH-16796 Moved from below, as my fix for 16740 broke things
                  // CJS 2015-05-26 - v7.0.14 - T2-158 - Batch Payment / Sales Receipt processing
                  HasPPD := PPDFieldsPopulated(EInv);

                  //PR: 25/08/2015 ABSEXCH-16740 Don't let a part allocation go through this section as its values will get overwritten.
                  //PL: 02-10-2017 R2 2017 ABSEXCH-18960 Copyrite Business Solutions Ltd - Batch sales receipts showing zero value
                  if (Tagged = 0 ) or (Tagged = 6) or (Round_Up(DocThen, 2) = BaseTotalOS(LInv)) then
                  begin
                    // Apply Settlement Discount to the transaction. On return,
                    // EInv will have the settlement discount applied.
                    ForceInvSDisc(LInv, EInv, BatchCtrl, 1);

                    {
                    HasPPD := ValidPPDAvailable(EInv,
                                                    BatchCtrl.BACSCRec.IntendedPaymentDate,
                                                    BatchCtrl.BACSCRec.PPDExpiryToleranceDays);
                    }
                    if HasPPD and (EInv.thBatchPayPPDStatus = PPD_BATCHPAY_SET) then
                    begin
                      PPDAvailableInBase := Conv_TCurr(EInv.thPPDGoodsValue + EInv.thPPDVATValue, XRate(EInv.CXRate, BOff, EInv.Currency), EInv.Currency, 0, BOff);
                      PPDAvailableInBase := PPDAvailableInBase * DocCnst[EInv.InvDocHed] * DocNotCnst;
                      PPDAvailableInCurrency := EInv.thPPDGoodsValue + EInv.thPPDVATValue;
                      PPDAvailableInCurrency := PPDAvailableInCurrency * DocCnst[EInv.InvDocHed] * DocNotCnst;
                    end
                    else
                    begin
                      PPDAvailableInBase := 0.0;
                      PPDAvailableInCurrency := 0.0;
                    end;

                    // DocThen and DocNow hold the values after the discount
                    // has been applied.
                    DocThen  := BaseTotalOS(EInv) - PPDAvailableInBase;
                    DocNow   := CurrencyOS(EInv, BOn, BOff, BOff) - PPDAvailableInCurrency;

                    // DocIThen and DocINow hold the values before the discount
                    // has been applied.
                    DocIThen := BaseTotalOS(LInv) - PPDAvailableInBase;
                    DocINow  := CurrencyOS(LInv, BOn, BOff, BOff) - PPDAvailableInCurrency;
                  end; //(Tagged = 0) or (Round_Up(DocThen, 2) = BaseTotalOS(LInv))

                  If (Not Syss.UpBalOnPost) and (SetDTaken) then
                    // Post the balance to History
                    LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOff,2);

                  {$IFDEF MC_On}
                    If (PayCurr = Currency) then
                    Begin
                      PayOwnVal   := PayOwnVal + DocNow;
                      PaySDOwnVal := PaySDOwnVal + DocINow;
                    end
                    else
                    Begin
                      PayOwnVal   := PayOwnVal + Currency_ConvFT(DocThen, 0, PayCurr, UseCoDayRate);
                      PaySDOwnVal := PaySDOwnVal + Currency_ConvFT(DocIThen, 0, PayCurr, UseCoDayRate);
                    end;
                  {$ELSE}
                    PayOwnVal   := PayOwnVal + DocThen;
                    PaySDOwnVal := PaySDOwnVal + DocIThen;
                  {$ENDIF}

                  // PayBase holds the total amount against this account after
                  // the discount has been applied, in Base Currency.
                  PayBase  := PayBase+DocThen;

                  // PayIBase holds the total amount against this account
                  // before the discount has been applied, in Base Currency.
                  PayIBase := PayIBase+DocIThen;

                  Tagged   := 0;
                  UnTagged := BOff;

                  {* Update invoice *}
                  Settled     := Settled + DocIThen;
                  CurrSettled := CurrSettled + DocINow;

                  //GS 06/10/2011 ABSEXCH-11367: modified the call to 'Set_DocAlcStat' for
                  //allowing bypassing the updating of the batch records
                  Set_DocAlcStat(LInv, False);

                  If (Not RightSignDoc(LInv)) or (Not (InvDocHed In MatchSet - CreditSet)) then
                    RemitNo := PayRef;

                  BatchNow  := 0;
                  BatchThen := 0;
                  BDiscount := 0.0;

                  If (GetHoldType(HoldFlg)=HoldA) then
                    BHoldMode:=HoldDel;

                  { CJS 2012-08-24 - ABSEXCH-10865 - Error 80 on processing }
                  SetHold(BHoldMode,IFnum,IKeyPAth,BOff,LInv,False);

                  If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* ENv4.22 Cash Accounting set VATdate to Current VAT Period *}
                  Begin
                    // VATPostDate:=SyssVAT.VATRates.CurrPeriod;
                    VATPostDate:=CalcVATDate(TagRunDate);  {v5.71. CA Allows jump to future period, set from period of receipt date}
                  end;

                  If (AllocStat=#0) then {* Only set date if fully allocated *}
                    UntilDate := Today;

                  {$IFDEF JC}
                    Set_DocCISDate(LInv, BOff);
                  {$ENDIF}

                  {$IFDEF EXSQL}
                    If (lSQLPFCRes = 0) Then
                      UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
                  {$ENDIF}
                  LStatus := LPut_Rec(IFnum,IKeyPath);

                  if HasPPD and (EInv.thBatchPayPPDStatus = PPD_BATCHPAY_SET) then
                    TakePPD.AddInvoice(LInv);

                  //GS 23/11/2011 added audit note to the new PIN TX
                  //if Status = 0 then
                  //begin
                  //  TAuditNote.WriteAuditNote(anTransaction, anCreate, TdMTExLocalPtr(MtExLocal)^);
                  //end;

                  LReport_BError(IFnum, LStatus);

                  {$IFDEF EXSQL}
                    If (lSQLPFCRes = 0) Then
                      UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
                  {$ENDIF}
                  LStatus := LUnLockMLock(IFnum);

                  TmpPWord := BatchCtrl;

                  {v5.01.001. EL 10/12/2002}
                  If (LStatusOk) and (UseOSKey) and (AllocStat=#0) then {* Only use get GEq if status has changed *}
                    B_Func2:=B_GetGEq;

                  {* v5.60.020 Dummy up remitno here so matching fooled into adding correct entery for stray credit *}

                  If (RightSignDoc(LInv)) and ((InvDocHed In MatchSet)) then
                  Begin
                    RemitNo := PayRef; {* This is temorarily set to complete the matching *}

                    {$IFDEF MC_On}

                      LMatch_Payment(LInv, DocIThen, DocINow, 23);

                    {$ELSE}  {* Just in case AddNow causes problems on SC *}

                      LMatch_Payment(LInv, DocIThen, DocIThen, 23);

                    {$ENDIF}

                  end;

                  {$IFDEF MC_On}

                    LMatch_Payment(LInv, DocIThen, DocINow, 3);

                  {$ELSE}  {* Just in case AddNow causes problems on SC *}

                    LMatch_Payment(LInv, DocIThen, DocIThen, 3);

                  {$ENDIF}

                  BatchCtrl := TmpPWord;

                end; // If (LOk) and (Locked) then...

              end; // If ((Tagged = 1) or...

            end; // If (ExtCusFiltCid(0,ExtCustRec,CustAlObj)) and...

            {$IFDEF EXSQL}
              If SQLUtils.UsingSQLAlternateFuncs Then
              Begin
                If (lSQLPFCRes = 0) Then
                  UseCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
                LStatus:=LFind_Rec(B_GetNext,IFnum,IKeypath,KeyIS)
              End // If SQLUtils.UsingSQLAlternateFuncs
              Else
            {$ENDIF}
                LStatus:=GetExtCusALCId(ExtCustRec,CustAlObj,IFnum,IKeypath,B_Func2,1,KeyIS);
          end; {While..}

          {$IFDEF REPPFC}
            If (lSQLPFCRes = 0) Then
              DropCustomPrefillCache(lSQLPrefillCacheID, MTExLocal^.ExClientID);
          {$ENDIF}

          If (Not NeedHed) then {* Generate PPY Hed *}
          Begin
            // Amount in Transaction currency
            PayOwnVal   := PayOwnVal * DocCnst[BatchDocHed(SalesMode)];
            PaySDOwnVal := PaySDOwnVal * DocCnst[BatchDocHed(SalesMode)];

            // Amount in Base currency
            PayBase  := PayBase * DocCnst[BatchDocHed(SalesMode)];
            PayIBase := PayIBase * DocCnst[BatchDocHed(SalesMode)];

            Generate_AutoPPY(PayOwnVal, PayBase, PayIBase, PaySDOwnVal,
                             PayRef, IFnum, IKeypath,
                             TransactionHelper(@LInv).SettlementDiscountSupported);
          end;

        end; // If (TotalTagged[0]<>0) then...

        {* Remove Misc Ref *}

        LStatus:=LDelete_Rec(Fnum,KeyPath);

        LReport_BError(Fnum,LStatus);

        If (LStatusOk) then
          B_Func:=B_GetGEq
        else
          B_Func:=B_GetNext;

      end; // If (LOk) and (Locked) then...

      // CJS 2015-05-27 - v7.0.14 - T2-158 - Batch Payment / Sales Receipt processing
      if TakePPD.tpInvoiceCount > 0 then
        TakePPDStatus := TakePPD.Execute;

      if (TakePPDStatus <> 0) then
        LReport_Error('Failed to create PPD credit note: ' + TakePPD.tpErrorString);

      TakePPD := nil;

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
    Begin
      BACS_CtrlGet(PWrdF,PWK,BatchCtrl,SPMode,MTExLocal);
      
      {Lock for the duration of the export}
      BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal,2);
    end;

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
        Send_BACS(Pay_RunNo(BatchDocHed(SalesMode),TagRunNo),TagRunNo,SalesMode,ReRun);

        {BATCH_PayPrint(Pay_RunNo(BatchDocHed(SalesMode),TagRunNo),Abort,IDetailF,IdFolioK,Ord(BACSMode),
                         DEFDEFMode[BatchDocHed(SalesMode)]);}


      If (Not ReRun) then
      Begin

        Blank(TotalTag,Sizeof(TotalTag));

        TagCount:=0;

        TagStatus:=BOff;

        LastTagRunNo:=TagRunNo;

        TagRunNo:=BACS_GetRunNo(BOn,SPMode,MTExLocal);

        {$IFDEF EXSQL}
        if SQLUtils.UsingSQL then
          CQStart:=IntStr(MTExLocal.LGet_NextChequeNo(BOff))
        else
       {$ENDIF}
          CQStart:=IntStr(Get_NextChequeNo(BOff));

        BACS_CtrlPut(PWrdF,PWK,BatchCtrl,MTExLocal,0);

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

    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
    begin
      // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
      if (not Assigned(LPostLocal)) then
        Result := Create_LocalThreadFiles;

      ThisRunNo:=-1;

      If (Result) then
      begin
        MTExLocal := LPostLocal;

        BatchCtrl:=BCtrl;

        ThisRunNo:=BatchCtrl.BACSCRec.TagRunNo;

        CallBackH:=InpWinH;
      end;
    end
    else
    {$ENDIF}
    begin
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
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}

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