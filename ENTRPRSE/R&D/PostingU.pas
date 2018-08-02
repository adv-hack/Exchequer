unit PostingU;

{$I DEFOVR.Inc}

// CJS - 18/04/2011: ABSEXCH-11252 - Posting Run performance enhancements

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VARRec2U,VarConst,BtrvU2,ExBtTh1U,SQL_DaybookPosting,
  Recon3U,

  {$IFDEF FRM}
    FrmThrdU,
  {$ENDIF}

  BTSupU3,

  // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
  {$IFDEF EXSQL}
  SQLCallerU,
  SQLRep_Config,
  IndeterminateProgressF,
  {$ENDIF}

  //PR: 27/10/2011 v6.9
  AuditNotes,

  oProcessLock;


type


   ControlSet  = (DebCred,VATCtrl,DiscCtrl,LDiscCtrl);

   ControlAry  =  Array[ControlSet] of Longint;  { =========== Doc Header Control ============ }




  { === Generic Thread Queue member class ===}


  TEntPost  =  Object(TThreadQueue)

                     private

                       LLockAddr: Array[0..30] of LongInt;

                       AbortLines,
                       COSHookEvent,
                       ADJNomHookEvent,
                       ProtectLDateEvent,
                       LockApplied,
                       fFromSV

                                 :  Boolean;


                       CommitMode:  Byte;
                       CHistRAddr,
                       ThisPRunNo,
                       ItemCtrlCount,
                       ItemCtrlTotal,
                       LastFolio :  LongInt;


                       {$IFDEF FRM}
                         ThisFList :  TPFormList;

                       {$ENDIF}

                       //PR: 27/10/2011 v6.9
                       oAuditNote : TAuditNote;


                       // CJS 2016-01-22 - ABSEXCH-17181 - Posting – Intrastat Out of Period flag being set on Non-Intrastat transactions
                       HasIntrastat: Boolean;

                       // CJS 2014-06-12 - ABSEXCH-15320 - multiple stockcode lines on ADJ
                       {$IFDEF SOP}
                       ExcludedLines: array of LongInt;

                       procedure Exclude(RecordAddress: LongInt);
                       function IsExcluded(RecordAddress: LongInt): Boolean;
                       {$ENDIF}

                       Function HistLockOk  :  Boolean;


                       Function ChkHistLock(Const LMode  :  Byte;
                                            Var   LAddr  :  LongInt)  :  Boolean;


                       Function Include_Transaction(Var PostSet      :  DocSetType;
                                                    Var AutoRecover  :  Boolean;
                                                    Var PRunNo       :  LongInt;
                                                        BatchMode    :  Boolean)  :  Boolean;

                     protected
                       { CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
                       LLockLocal: TdPostExLocalPtr;

                     { PR 18/07/2008 - Moved these to TThreadQueue so they can be used by all descendants
                       // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
                       LPostLocal: TdPostExLocalPtr;

                       // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
                       function Create_LocalThreadFiles: Boolean;
                      }
                        function CalcPurchaseServiceVATTotal: double;
                     public
                       AbortTran,
                       HaveAborted,
                       InCheckStock,
                       TranOk2Run,
                       IsParentTo:  Boolean;

                       //PR: 21/06/2017 ABSEXCH-18774 Variable to indicate if we can use the SQL posting -
                       //saves calling a function every time
                       UseSQLPost : Boolean;

                       CheckActMode,
                       PostMode  :  Byte;

                       PostRepCtrl
                                 :  PostRepPtr;

                       CommitDedMode
                               :  SmallInt;
                       CommitId
                               :  IDetail;

                       UnpostRunNo
                               :  LongInt;


                       {$IFDEF FRM}
                         PostLog   :  TPostLog;

                       {$ENDIF}
                         //PR: 16/05/2017 ABSEXCH-18683 v2017 R1 Identifier for process lock
                       ProcessLockType : TProcessLockType;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Function Has_Aborted  :  Boolean;

                       Function  ReverseUnpost  :  SmallInt;


                       procedure ThreadDelay(dt  :  Word;
                                             SAPM:  Boolean);

                       { CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
                       function Create_LockLocal: Boolean;

                       {$IFDEF PF_On}

                         Function Auto_Include(InvR  :  InvRec)  :  Boolean;
                         Procedure Set_NextAuto(Var  InvR  :  InvRec);
                         Function Expire_Auto(InvR  :  InvRec)  :  Boolean;
                         Procedure Generate_AutoLines(InvR       :  InvRec;
                                                      AutoFolio  :  Str255;
                                                      PostOPtr   :  Pointer);



                         Procedure Print_AutoItems;

                         Procedure Post_ItAuto(PostSet       :  DocSetType;
                                           Var PrintToQueue,
                                               ItemsOnQ      :  Boolean;
                                               Curr_Pno      :  Byte;
                                               NormalPost    :  Boolean);

                       {$ENDIF}

                       Procedure InitPostingSumm(Var  PostSummary  :  PostingSummaryArray;
                         	                      Put          :  Boolean);

                       // CJS - 18/04/2011: ABSEXCH-11252 - Posting Run performance enhancements
                       procedure UpdatePostingSummary(var PostSummary: PostingSummaryArray;
                                                          DocumentType: DocTypes);

                       Procedure CalcSum(DocHed       :  DocTypes;
                                         SalesOn,
                                         DebRun       :  Boolean;
                                     Var PostSummary  :  PostingSummaryArray;
                                         Amount       :  Real);


                       Procedure Write_PostLogDD(S         :  String;
                                                 SetWrite  :  Boolean;
                                                 DK        :  Str255;
                                                 DM        :  Byte);

                       Procedure Write_PostLog(S         :  String;
                                               SetWrite  :  Boolean);

                       procedure Post_ECVAT(VYr, VPr: Integer; Undo: Boolean);

                       Procedure Post_VAT(VYr,VPr  :  Integer;
                                          Undo     :  Boolean);

                       Procedure SetControlCodes(DocHed  :  DocTypes;
                                             Var CtrlSet :  ControlAry);

                       Procedure ShowPostFailMsg(SMsg  :  Str255);


                       Function Posting_Title(Mode  :  Byte)  :  Str80;

                       Function Has_PayinMode(NomCode  :  LongInt)  :  Boolean;

                       Procedure Add_PayInRec(NextRef  :  Str10;
                                              Idr      :  IDetail;
                                              SingleItem
                                                       :  Boolean);

                       Function LCheck_PayInStatus(Var IdR  :  IDetail)  :  Byte;

                       Procedure Process_Payin(CurrKeyPath  :  Integer);

                       Procedure AutoReverseNom(Fnum2,Keypath2  :  Integer;
                                                NomInv          :  InvRec;
                                                RecAddr2        :  LongInt);

                      Function FoundB2BLink(IdR  :  IDetail;
                                          Var NInv :  InvRec)  :  Boolean;

                       Function AdjPartPosted(BInv    :  InvRec;
                                          Var NInv    :  InvRec;
                                              Fnum,
                                              Keypath :  Integer)  :  Boolean;

                     {$IFDEF STK}

                        Procedure Post_To_Stock(NCode         :  Str20;
                                                PPurch,PSales,
                                                PCleared,
                                                PValue1
                                                              :  Double;
                                                PCr,PYr,PPr   :  Byte;
                                                Level         :  Longint;

                                                PostYTD,AutoLZ,
                                                PostYTDNCF,
                                                QtyMode,
                                                ChkMode       :  Boolean;

                                                CXRate        :  CurrTypes;
                                                LineCOSRate   :  Double;
                                                Locn          :  Str10;
                                                UOR           :  Byte);


                        Procedure Post_CuStkHist(NCode         :  Str20;
                                                 PPurch,PSales,
                                                 PCleared
                                                               :  Real;
                                                 PCr,PYr,PPr   :  Byte;

                                                 CXRate        :  CurrTypes;
                                                 LineCOSRate   :  Double;
                                                 UOR           :  Byte);

                        Procedure Ctrl_CuStkHist(IdR       :  IDetail;
                                                 Reverse   :  Integer);

                        Procedure Stock_PostCtrl(Idr   :  IDetail;
                                                 CTot  :  Real;
                                                 PHOnly:  Boolean);


                        Function GotBOMLine(SFolio,SLineNo  :  LongInt;
                                            Fnum,
                                            IKeyPath        :  Integer;
                                        Var BOMLine         :  IDetail)  :  Boolean;

                        Function GotBOMCOSGL(BOMLine         :  IDetail;
                                             Fnum,
                                             IKeyPath        :  Integer)  :  LongInt;

                        {$IFDEF SOP}
                          Function Get_LocTxfrNom(WOffNom  :  LongInt;
                                              Var ExclLn   :  LongInt;
                                              Var OCCDep   :  CCDepType;
                                                  Fnum,
                                                  Keypath  :  Integer;
                                                  KeyS     :  Str255;
                                                  KeyChk   :  Str255;
                                                  BInv     :  InvRec)  :  LongInt;
                        {$ENDIF}

                        Procedure Post_AdjDetails(BInv          :  InvRec;
                                              Var GotHed        :  Boolean;
                                              Var NInv          :  InvRec;
                                                  PostOPtr      :  Pointer); {*EN431JCWIP*}


                      {$ENDIF}


                      {$IFDEF JC}
                        Function JCHasUplift(IdR      :  IDetail;
                                         Var UpValue  :  Double;
                                             UCr      :  Byte;  {Currency Uplift required in, own or 0}
                                         Var UpGL     :  LongInt)  :  Boolean;

                        Procedure PostJCUplift(Fnum2,
                                               Keypath2  :  Integer;
                                               PRunNo    :  LongInt);

                        Procedure Post_BatchJobDetails(BInv          :  InvRec;
                                                       PostOPtr      :  Pointer);
                      {$ENDIF}

                      Procedure Post_BatchDetails(BInv          :  InvRec;
                                                  TTEnabled     :  Boolean;
                                                  PostOPtr      :  Pointer);

                      Procedure Post_BatchBal(BInv          :  InvRec;
                                          Var TTEnabled     :  Boolean;
                                              PostOPtr      :  Pointer);

                      Procedure Post_ItBatch(PostSet       :  DocSetType;
                                         Var PostingCount  :  LongInt);

                      Function CCDepMatch(LinkCCDep :  Boolean;
                                          RCCDep    :  CCDepType)  :  Boolean;

                      Procedure Add_CtrlDetail(CtrlCode,RNo  :  Longint;
                                               PCr,PPYr,PPPr :  Byte;
                                               CRates        :  CurrTypes;
                                               RCCDep        :  CCDepType;
                                               Fnum,NPath    :  Integer);

                      Procedure Post_To_RunCtrl(CtrlCode,RunNo  :  Longint;
                                                PNm,PCr,PYr,PPr :  Byte;
                                                CXRate          :  CurrTypes;
                                                Amount          :  Real;
                                                MultiLine       :  Boolean;
                                                LinkCCDep       :  Boolean;
                                                RCCDep          :  CCDepType;
                                                InvR            :  InvRec;
                                                ReverseCharge   :  Boolean = False);

                      {$IFDEF STK}
                        Procedure Stock_GenAVal(IdR      :  IDetail;
                                                Fnum,
                                                Keypath  :  Integer;
                                                PRunNo,
                                                BOMCOSGL :  LongInt);

                      {$ENDIF}

                      Procedure LPost_To_YTDHist(PPurch,PSales,
                                                 PCleared       :  Double;
                                                 PCr,PYr,PPr    :  Byte);

                      Function  GetPrevPrBal(NType         :  Char;
                                             NCode         :  Str10;
                                             PCr,PYr,PPr   :  Byte)  :  Double;


                       Function GLPostKey(NomFolio  :  LongInt)  :  Str20;

                       Procedure LPost_To_Nominal(NCode         :  Str20;
                                                  PPurch,PSales,
                                                  PCleared
                                                                :  Double;
                                                  PCr,PYr,PPr   :  Byte;
                                                  Level         :  Longint;
                                                  PostYTD,AutoLZ,
                                                  PostYTDNCF    :  Boolean;
                                                  CXRate        :  CurrTypes;
                                              Var PrevBal       :  Double;
                                              Var ActualNomCode :  LongInt;
                                                  UOR           :  Byte);

                        Function CCPostKey(NomFolio  :  LongInt;
                                           LC        :  Str10)  :  Str20;

                       Procedure LPost_To_CCYTDHist(PPurch,PSales,
                                                    PCleared       :  Double;
                                                    PCr,PYr,PPr    :  Byte;
                                                    CCode          :  Str10);

                       Procedure LPost_To_CCNominal(NCode         :  Str20;
                                                    PPurch,PSales,
                                                    PCleared
                                                                  :  Double;
                                                    PCr,PYr,PPr   :  Byte;
                                                    Level         :  Longint;
                                                    PostYTD,AutoLZ,
                                                    PostYTDNCF    :  Boolean;
                                                    CXRate        :  CurrTypes;
                                                    CCode         :  Str10;
                                                    UOR           :  Byte);


                       Procedure Stock_PostAValue(RunNo,
                                                  SearchRunNo  :  LongInt;
                                                  SMode        :  Byte;
                                                  AutoRecover  :  Boolean);

                       Procedure Post_Details(DocFno,RunNo  :  LongInt;
                                              VYr,VPr       :  Integer;
                                              CtrlSet       :  ControlAry;
                                          Var LineTotal     :  Real;
                                              AutoRecover   :  Boolean);

                       Function LinesPartPosted(DocFno,RunNo  :  LongInt;
                                                AutoRecover   :  Boolean)  :  Boolean;

                       Procedure Post_CtrlDetails(RunNo         :  LongInt;
                                                   AutoRecover   :  Boolean);


                       Procedure Post_It(PostSet   :  DocSetType;
                                         Mode      :  Byte;
                                         ItemTotal :  LongInt);

                       Procedure Control_Posting(Mode  :  Byte);

                       function CanPostUsingSQL(Mode : Byte):Boolean;
                       procedure InitPostLog(aRunNo : Integer; aSQLDayBookPosting : TSQLDayBookPosting);


                       procedure DayBookPostUsingSQL(PostSet:DocSetType; Mode : Byte);



                       {$IFDEF SOP}
                         Procedure Remove_LastCommit;

                         procedure SQLRemoveLastCommit;

                         Procedure Post_Commited(CrDr    :  DrCrDType;
                                                 CMode,
                                                 DPr,DYr :  Byte);

                         Procedure Post_CommitOrd;

                         Procedure Update_LiveCommit(IdR      :  IDetail;
                                                     DedMode  :  SmallInt);


                       {$ENDIF}

                       Function Start(LMode  :  Byte;
                                      RPParam:  TPrintParamPtr;
                                      PostParam
                                             :  PostRepPtr;
                                      Ask    :  Boolean)  :  Boolean;

                       Function PostLockCtrl(Const LMode  :  Byte)  :  Boolean;

                       Function PostLock(Const LMode  :  Byte;
                                         Var   LAddr  :  LongInt)  :  Boolean;

                       Procedure PostUnLock(NewRunNo  :  LongInt);

                       Function CheckAbortedRun  :  LongInt;

                       Procedure UnLockHistLock;

                       Procedure WaitForHistLock;

                       Procedure Process; Virtual;
                       Procedure Finish; Virtual;

                       Procedure AbortfromStart; Virtual;

                   end; {Class..}


  TCheckCust      =  Object(TEntPost)

                     private
                       //PR: 05/01/2015 ABSEXCH-15961 Removed SetUnalloc variable as part of separating unallocate from check
                       AllAccounts  :  Boolean;

                       UCCode   :  Str10;

                       fCuStkMode,
                       UReCalc  :  Boolean;
                       UCFnum,
                       UCKeyPAth:  Integer;
                       UpdateOldestDebtOnly: Boolean; //HV 20/05/2016 2016-R2 ABSEXCH-17430: Recalculate Trader Oldest Debt Correctly for


                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       {$IFDEF STK}
                         {$IFDEF PF_On}

                           Function LGet_LastLineNo(cc  :  Str20)  :  LongInt;

                           Procedure LStock_AddCustAnal(IdR     :  IDetail;
                                                        GetSRec :  Boolean;
                                                        Mode    :  Byte);

                           Procedure cu_DeleteHistory(CCode    :  Str20;
                                                      UseReset :  Boolean);


                           Procedure cu_DeleteCStkHistory(CCode    :  Str20;
                                                          SFolio   :  LongInt;
                                                          UseReset :  Boolean);


                           Procedure cuStk_CheckHist(CCode        :  Str20;
                                                     IsaC         :  Boolean);

                         {$ENDIF}
                       {$ENDIF}

                       Procedure Check_Cust(CCode   :  Str10;
                                            Auto,
                                            ReCalc  :  Boolean;
                                            CFnum,
                                            CKeyPAth:  Integer);

                       {$IFDEF SOP}

                         Procedure Check_HOCust(CCode   :  Str10;
                                                Auto,
                                                ReCalc  :  Boolean;
                                                CFnum,
                                                CKeyPAth:  Integer);
                       {$ENDIF}

                       Procedure Check_AllCust(ReCalc   :  Boolean);


                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;


                       // CJS 09/03/2011 v6.7 ABSEXCH-10901 - CustSupp parameter added
                       Function Start(CCode    :  Str10;
                                      AllMode,
                                      ReCalc,
                                      CuStkMode:  Boolean;
                                      CustSupp: Char = #0)  :  Boolean;


                       Function Build_Title(CCode  :  Str10;
                                            AllMode:  Boolean)  :  Str50;


                   end; {Class..}


  //PR: 05/01/2015 ABSEXCH-15961 Object to unallocate transactions for a range of accounts
  TUnallocateTransactions = Object(TEntPost)
  private
     FAccountFrom : string;
     FAccountTo   : string;
     FAccountType : Byte; //Customer, Consumer or Supplier
     procedure CheckMatchedTransactions;
     procedure UnallocateAccount(ThisAccount : Str255);
  public
     Constructor Create(AOwner  :  TObject);
     Procedure Process; Virtual;
     Procedure Finish;  Virtual;

     Function Start  :  Boolean;

     property AccountFrom : string read FAccountFrom write FAccountFrom;
     property AccountTo : string read FAccountTo write FAccountTo;
     property AccountType : Byte read FAccountType write FAccountType;
  end;


  TCheckCCDep     =  Object(TEntPost)

                     private
                       PCount :  LongInt;

                       {$IFDEF EXSQL}
                       FProgressFrm: TIndeterminateProgressFrm;
                       FSQLCaller: TSQLCaller;
                       FCompanyCode: string;
                       {$ENDIF}

                       Procedure Remove_CCDepBalances;

                       Procedure RePost_CCDepLines;

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start  :  Boolean;


                   end; {Class..}



{$IFDEF STK}

  TCheckStk      =  Object(TEntPost)

                     private
                       UInv  :  InvRec;
                       UId   :  IDetail;
                       UStk  :  StockRec;

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;

                       Procedure ProcessFromCheck(StkRec  : StockRec;
                                                  IdR     : IDetail;
                                                  InvR    : InvRec);

                       Procedure Finish;  Virtual;

                       Function Start(StkRec  : StockRec;
                                      IdR     : IDetail;
                                      InvR    : InvRec)  :  Boolean;



                   end; {Class..}



{$ENDIF}


TUnTagSOP  =  Object(TEntPost)

                   private
                     KeyTagChk  :  Str255;
                     KeyTagLen,
                     OFNum,
                     OKeypath   :  SmallInt;
                     MyOwner    :  TObject;
                     MyHandle   :  THandle;

                   public
                     ClearTag   :  Byte;

                     Constructor Create(AOwner  :  TObject);

                     Destructor  Destroy; Virtual;

                     Procedure Process; Virtual;
                     Procedure Finish;  Virtual;

                     Function Start(DBkKey  : Str255;
                                    DBKLen,
                                    DBKFnum,
                                    DBKKpath
                                            : SmallInt;
                                    AOwner  : TObject)  :  Boolean;


                 end; {Class..}

TCheckCAlloc      =  Object(TEntPost)

                     private
                       UCCode     :  Str10;
                       CustAlObj  :  GetExNObjCid;

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start(CCode  :  Str10)  :  Boolean;

                   end; {Class..}

  { === Generic Thread Queue member class ===}


  TThreadTest  =  Object(TThreadQueue)

                     private

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure StartLoop;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;



                   end; {Class..}

  TDumR1Test  =  Object(TThreadTest)

                     private

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

  TDumR2Test  =  Object(TThreadTest)

                     private

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}



Function SetPostMode(DH  :  DocTypes)  :  Byte;

Procedure GetPostMode(Mode  :  Byte;
                      Var PSet  :  DocSetType);

Function Build_Title(LMode :  Byte)  :  Str80;

Function CheckValidNCC(ChkComm  :  Boolean)  :  Boolean;


Function HasUnpAlloc(Var HasUnpd,HasCur1  :  Boolean;
                     Var ORef             :  Str20) :  Boolean;

Function HasFutureTrans(Var FYr  :  Byte;
                        Var ORef :  Str20) :  Boolean;

Procedure CheckCurMethod(OldSGC,
                         NewSGC           :  GCurRec;
                         OldCurr          :  CurrRec;
                     Var IX,CFLoat,CTri   :  Boolean);

Procedure DayBkPostCtrl(LMode     :  Byte;
                        AOwner   :  TObject);

Function GlobPostLockCtrl(Const LMode  :  Byte)  :  Boolean;

Procedure AddPost2Thread(LMode    :  Byte;
                         AOwner,
                         FormHandle
                                  :  TObject;
                         Ask      :  Boolean;
                         RPParam  :  TPrintParamPtr;
                         PostParam:  PostRepPtr;
                     Var StartedOk:  Boolean);

Procedure AddLiveCommit2Thread(IdR  : IDetail; DedMode  :  SmallInt);

// CJS 09/03/2011 v6.7 ABSEXCH-10901 - CustSupp parameter added
// CJS 2015-03-31 - ABSEXCH-16163 - Check All Accounts, SQL improvements -
// 'Ask' parameter removed
Procedure AddCheckCust2Thread(AOwner   :  TObject;
                              CCode    :  Str10;
                              AllMode,
                              ReCalc,
                              CuStkMode: Boolean;
                              CustSupp: Char = #0); Overload;

Procedure AddCheckCust2Thread(AOwner   :  TObject;
                              CCode    :  Str10;
                              AllMode,
                              ReCalc,
                              CuStkMode: Boolean;
                              UpdateOldestDebt: Boolean;
                              CustSupp: Char = #0); Overload;

Procedure AddChkCAlloc2Thread(AOwner   :  TObject;
                              CCode    :  Str10);




Procedure AddCheckCCDep2Thread(AOwner   :  TObject);


{$IFDEF STK}

  Procedure AddCheckStk2Thread(AOwner   :  TObject;
                               InvR     :  InvRec;
                               StkRec   :  StockRec;
                               IdR      :  IDetail);


{$ENDIF}

  Procedure AddUnTagSOP2Thread(AOwner   :  TObject;
                               KeyChk   :  Str255;
                               KeyLen,
                               KFnum,
                               KKeypath :  SmallInt;
                               TagNo    :  Byte);

Procedure AddTest2Thread(LMode    :  Byte;
                         AOwner   :  TObject);

Procedure AddR12Thread(LMode    :  Byte;
                       AOwner   :  TObject);

Procedure AddR22Thread(LMode    :  Byte;
                       AOwner   :  TObject);

procedure AddUnallocateTransactions2Thread(AOwner : TObject;
                                           AccountType : Byte;
                                           AccountFrom : string;
                                           AccountTo : string);

//PR: 21/06/2017 ABSEXCH-18774 function to check if any hooks set to trigger
//                             during posting
function PostingHookEnabled : Boolean;

var
  ClientIds: TBits;
  AlreadyInPost  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  DateUtils,
  Dialogs,
  Forms,
  RPDefine,
  ETDateU,
  ETStrU,
  ETMiscU,
  BTSFrmU1,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  ExWrap1U,
  GenWarnU,
  ReValU2U,

  {$IFDEF CL_On}
    LedgSupU,
  {$ENDIF}

  {$IFDEF FRM}
    PrintFrm,
  {$ENDIF}

  {$IFDEF Rp}
    Report2U,
  {$ENDIF}

  {$IFDEF SOP}
    InvLst3U,
    MiscU,
  {$ENDIF}

  {$IFDEF STK}
    {$IFDEF PF_On}
      CuStkA4U,
    {$ENDIF}
  {$ENDIF}

  LedgSu2U,

  Excep2U,
  Event1U,

  {$IFDEF JC}
    JobPst2U,

    JChkUseU,

  {$ENDIF}

  {$IFDEF CU}
    PassWR2U,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  RevChrgU,
  ExThrd2U,
  PWarnU,

  { CJS - 2013-10-25 - MRD2.6 - Transaction Originator }
  TransactionOriginator,

  ConsumerUtils,

  // MH 23/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU,

  UA_Const,

  // CJS 2012-03-30 - ABSEXCH-12203 - Check All Accounts, SQL improvements
  SQL_CheckAllAccounts,

  // CJS 2016-01-06 - ABSEXCH-17096 - Intrastat Out of Period flag
  oSystemSetup,

  CustIntU
  ;

//PR: 21/06/2017 ABSEXCH-18774 function to check if any hooks set to trigger
//                             during posting
function PostingHookEnabled : Boolean;
type
  THookId = Record
    WinId : Integer;
    HandlerId : Integer;
  end;
const
  NoOfPostingHooks = 6;
  PostingHooks : Array[1..NoOfPostingHooks] of THookId =
    (
     (WinId : 104000; HandlerId : 52), //Override cost of sales
     (WinId : 104000; HandlerId : 57), //Protect line date
     (WinId : 104000; HandlerId : 88), //Override CC/Dept
     (WinId : 102000; HandlerId : 80), //Convert date to period
     (WinId : 102000; HandlerId : 81), //Convert period to date
     (WinId : 190001; HandlerId : 2)   //Override VAT date during posting
    );
var
  i : Integer;
begin
{$IFDEF CU}
  Result := False;
  for i := 1 to NoOfPostingHooks do
  with PostingHooks[i] do
  begin
    if CustIntU.CustomHandlers.HookPointEnabled(WinId, HandlerId) then
    begin
      Result := True;
      Break;
    end;
  end;
{$ENDIF CU}
end;

{ ================= Function to Set Mode Based on Doc Type =============== }

  Function SetPostMode(DH  :  DocTypes)  :  Byte;

  Var
      Tmode  :  Byte;

  Begin
    Tmode:=0;

    If (DH In SalesSplit) then
      TMode:=1
    else
      If (DH In PurchSplit) then
        TMode:=2
      else
      If (DH In NomSplit) then
        TMode:=3
      else
        If (DH In StkAdjSplit) then
          TMode:=4;

    SetPostMode:=TMode;
  end; {Func..}


{ =============== Procedure to Return PSet Based On Mode
                    0  =  All Modes
                    1  =  Sales
                    2  =  Purchasing
                    3  =  Nominal Transfers
                    4  =  Stock Adjustments
                                                             =================== }


  Procedure GetPostMode(Mode  :  Byte;
                    Var PSet  :  DocSetType);


  Begin
    FillChar(Pset,Sizeof(Pset),0);

    Case Mode of
      0  :  PSet:=SalesSplit+PurchSplit+NomSplit+StkAdjSplit-QuotesSet;
      1  :  PSet:=SalesSplit-QuotesSet;
      2  :  PSet:=PurchSplit-QuotesSet;
      3  :  PSet:=NomSplit;
      4  :  PSet:=StkAdjSplit;
    end; {Case..}
  end; {PRoc..}




  { =============== Function to Check for Hold or Suspend ============== }

  Function CheckHold(DocHed    :  DocTypes;
                     DocStatus :  Byte;
                 Var PostSet   :  DocSetType)  :  Boolean;

  Var
    PSet  :  DocSetType;
    Mode  :  Byte;


  Begin
    If (SuspendDoc(DocStatus)) then
    Begin
      Mode:=SetPostMode(DocHed);

      GetPostMode(Mode,PSet);

      PostSet:=PostSet-PSet;
    end;

    CheckHold:=Not OnHold(DocStatus);
  end; {Func..}



Function Build_Title(LMode :  Byte)  :  Str80;

Const
  PostTit  :  Array[0..4] of Str20 = ('All','Sales','Purchase','General','Stock');

Var
  AutoOn   :  Boolean;


Begin
  AutoOn:=(LMode>10);

  If (AutoOn) then
    LMode:=LMode-20;

  If (LMode In [0..4]) then
  Begin
    Result:=PostTit[LMode];

    If (AutoOn) then
      Result:='Automatic '+Result;

    If (LMode=0) then
      Result:=Result+' Daybooks.'
    else
      Result:=Result+' Ledger Daybook.';
  end
  else
    Result:='Error in title. Mode '+Form_Int(LMode,0);


end; {Func..}



Function CheckValidNCC(ChkComm  :  Boolean)  :  Boolean;

Const
  ExcludeNCC :  Set of NomCtrlType = [PLStart,PLEnd,SalesComm,PurchComm];

Var
  N     :  NomCtrlType;
  m     :  Byte;
{$IFDEF GLCCDEBUG}
  DbgList : TStringList;
  KeyS : Str255;
  CStatus : SmallInt;
{$ENDIF}
Begin
  Result:=BOn;

{$IFDEF GLCCDEBUG}
  DbgList := TStringList.Create;
{$ENDIF}

  N:=NomCtrlStart;

  {$IFDEF SOP}
    If (ChkComm) then
      ExcludeNCC:=ExcludeNCC-[SalesComm,PurchComm];

  {$ENDIF}

  While (Result) and (N<=NomCtrlEnd) do
  Begin
    {$IFNDEF MC_On}
       If (N<>CurrVar) and (Not (N In ExcludeNCC)) and ((N<>FreightNC) or (Syss.UseUpLiftNC)) then

    {$ELSE}
       If (Not (N In ExcludeNCC)) and ((N<>FreightNC) or (Syss.UseUpliftNC)) then

    {$ENDIF}

    With Syss do
    Begin
{$IFDEF GLCCDEBUG}
  GLCC_CheckSyssRecord;

  KeyS := FullNomKey(NomCtrlCodes[N]);
  CStatus:=Find_Rec(B_GetEq,F[NomF],NomF,RecPtr[NomF]^,0,KeyS);
DbgList.Add ('Syss GL=' + IntToStr(NomCtrlCodes[N]) + ', FindRec Result=' + IntToStr(CStatus));
  Result:=(CStatus=0);
{$ELSE}
      Result:=GLobal_GetMainRec(NomF,FullNomKey(NomCtrlCodes[N]));
{$ENDIF}

      If (Result) then
      Begin
        Result:=(Not (Nom.NomType In [NomHedCode,CarryFlg]));
{$IFDEF GLCCDEBUG}
If (Not Result) then
  DbgList.Add ('  Failed NomType Check 1 - NomType=' + Nom.NomType);
{$ENDIF}
      End; // If (Result)

      If (Result) and (N=ProfitBF) then {* Check Type *}
      Begin
        Result:=(Nom.NomType In [CtrlNHCode]);
{$IFDEF GLCCDEBUG}
If (Not Result) then
  DbgList.Add ('  Failed NomType Check 2 - NomType=' + Nom.NomType);
{$ENDIF}
      End; // If (Result)

    end;

    If (Result) then
      Inc(N);
  end;


  If (Result) and (JBCostOn) then {* Check for timesheet control code validity *}
  With SyssJob^.JobSetUp do
  Begin
    For m:=1 to 3 do
    Begin
{$IFDEF GLCCDEBUG}
  KeyS := FullNomKey(EmployeeNom[m,BOff]);
  CStatus:=Find_Rec(B_GetEq,F[NomF],NomF,RecPtr[NomF]^,0,KeyS);
DbgList.Add ('SyssJob (' + SyssJob^.IDCode + ') GL=' + IntToStr(EmployeeNom[m,BOff]) + ', FindRec Result=' + IntToStr(CStatus));
  Result:=(CStatus=0);
{$ELSE}
      Result:=GLobal_GetMainRec(NomF,FullNomKey(EmployeeNom[m,BOff]));
{$ENDIF}

      If (Result) then
      Begin
        Result:=(Not (Nom.NomType In [NomHedCode,CarryFlg]));
{$IFDEF GLCCDEBUG}
If (Not Result) then
  DbgList.Add ('  Failed NomType Check 1 - NomType=' + Nom.NomType);
{$ENDIF}
      End; // If (Result)

      If (Not Result) then
        Break;

    end;
  end;

{$IFDEF GLCCDEBUG}
  If (Not Result) Then
    GLCC_ErrLog (DbgList);
  FreeAndNIL(DbgList);
{$ENDIF}
end;


{ =========== Procedure to check for allocated unposted transactions ======== }

Function HasUnpNoms(Var ORef             :  Str20) :  Boolean;

Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;


  Var
    KeyS,
    KeyChk   :  Str255;

    
    FoundOk  :  Boolean;


  Function Has_CurrLines(InvR  :  InvRec)  :  Boolean;
  Const
    IFnum     =  IdetailF;
    IKeypath  =  IdFolioK;

  Var
    IFoundOk  :  Boolean;
    
    IKeyS,
    IKeyChk   :  Str255;

  Begin
    IFoundOk:=BOff;

    IKeyChk:=FullNomKey(InvR.FolioNum);

    IKeyS:=IKeyChk;

    Status:=Find_Rec(B_GetGEq,F[IFnum],IFnum,RecPtr[IFnum]^,IKeyPath,IKeyS);

    While (StatusOk) and (CheckKey(IKeyChk,IKeyS,Length(IKeyChk),BOn)) and (Not IFoundOk) do
    With Id do
    Begin
      Application.ProcessMessages;

      IFoundOk:=(Currency>1) or (CXRate[BOff]<>1.00);

      If (Not IFoundOk) then
        Status:=Find_Rec(B_GetNext,F[IFnum],IFnum,RecPtr[IFnum]^,IKeyPath,IKeyS);

    end;

    Result:=IFoundOk;
  end;


  Begin
    FoundOk:=BOff;

    KeyChk:=FullNomKey(0)+DocCodes[NMT][1];

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With Inv do
    Begin
      Application.ProcessMessages;


      FoundOk:=Has_CurrLines(Inv);;

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    If (FoundOk) then {Let them know which one}
      ORef:=Inv.OurRef;

    HasUnpNoms:=FoundOk;
  end;


  { =========== Procedure to check for allocated unposted transactions ======== }

Function HasUnpAlloc(Var HasUnpd,HasCur1  :  Boolean;
                     Var ORef             :  Str20) :  Boolean;

Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;


  Var
    KeyS,
    KeyChk   :  Str255;

    Loop,
    FoundOk  :  Boolean;


  Begin
    FoundOk:=BOff; Loop:=BOff; HasUnPd:=BOff; HasCur1:=BOff;

    KeyChk:=FullNomKey(0)+DocCodes[SIN][1];

    Repeat
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
      With Inv do
      Begin
        Application.ProcessMessages;

        If (Not HasUnPd) then
          HasUnPd:=(Not (InvDocHed In BatchSet+QuotesSet));

        If (Not HasCur1) then
          HasCur1:=(UseORate=1);

        FoundOk:=((Round_Up(Settled,2)<>0.0) and (Not (InvdocHed In DirectSet)));

        If (Not FoundOk) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      Loop:=Not Loop;

      KeyChk:=FullNomKey(0)+DocCodes[PIN][1];

    Until (FoundOk) or (Not Loop);

    If (FoundOk) then {Let them know which one}
      ORef:=Inv.OurRef;

    If (Not HasUnPd) and (Not HasCur1) then {* See if first invoice has been set *}
    Begin
      KeyS:='P';

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,InvOurRefK,KeyS);

      HasCur1:=(StatusOk) and (Inv.UseORate=1);
    end;

    Result:=FoundOk;

    If (Not Result) and (Not UseCoDayRate) then
    Begin
      Result:=HasUnpNoms(ORef);

      HasCur1:=BOff; HasUnPd:=BOff;
    end;
  end;




{ =========== Procedure to check for future posted transactions ======== }

Function HasFutureTrans(Var FYr  :  Byte;
                        Var ORef :  Str20) :  Boolean;

Const
  Fnum     =  InvF;
  Keypath  =  InvYrPrK;


  Var
    B_Func1,
    B_Func2  :  Integer;
    KeyS,
    KeyChk   :  Str255;

    UseNdx,
    FoundOk  :  Boolean;


  Begin
    FoundOk:=BOff; FYr:=GetLocalPr(0).CYr; ORef:='';

    FillChar(KeyS,Sizeof(KeyS),#0);
    FillChar(KeyChk,Sizeof(KeyChk),#0);

    B_Func1:=B_GetGretr;
    B_Func2:=B_GetNext;

    UseNdx:=(GetFullFile_StatCId(F[Fnum],Fnum,nil).KS[19].KeyFlags AND AltColSeq = AltColSeq);


    KeyChk:=Chr(FYr); 

    If (UseNdx) then
    Begin
      KeyChk:=KeyChk+Chr(Syss.PrInYr);
      
      KeyS:=Chr(149);
      B_Func1:=B_GetLess;
      B_Func2:=B_GetPrev;

    end
    else
      KeyS:=Chr(FYr);{*v4.32 Note could not use a bigger number like 149 here as it seems the sorting takes
                                        into account lower case ASCII which is Hex 65-Hex 7A. Need to specify InvYrPrK as a number
                                        to get around this. Still no need to worry for another 20 years (19/03/2001) *}

    Status:=Find_Rec(B_Func1,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (KeyS>KeyChk) and (Not FoundOk) do
    With Inv do
    Begin
      Application.ProcessMessages;

      FoundOk:=(Pr2Fig(AcYr,AcPr)>Pr2Fig(GetLocalPr(0).CYr,99)) and (RunNo>0);

      If (Not FoundOk) then
        Status:=Find_Rec(B_Func2,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    Result:=FoundOk;

    If (Result) then
    Begin
      FYr:=Inv.AcYr;
      ORef:=Inv.OurRef;
    end;

  end;


  { === Procedure to Detect Fundemental changes to currency set up === }

  Procedure CheckCurMethod(OldSGC,
                           NewSGC           :  GCurRec;
                           OldCurr          :  CurrRec;
                       Var IX,CFLoat,CTri   :  Boolean);


  Var
    N  :  Integer;


    FoundOk
       :  Boolean;

  Begin
    IX:=BOff; CFLoat:=BOff; CTri:=BOff; FoundOK:=BOff;

    For n:=0 to CurrencyType do
    Begin
      Application.ProcessMessages;

      IX:=(OldSGC.GhostRates.TriInvert[n]<>NewSGC.GhostRates.TriInvert[n]);
      CFloat:=(OldSGC.GhostRates.TriFloat[n]<>NewSGC.GhostRates.TriFloat[n]);
      CTri:=(OldSGC.GhostRates.TriEuro[n]<>NewSGC.GhostRates.TriEuro[n]);

      With OldCurr.Currencies[n] do {* Check it was not previously blank *}
        FoundOk:=(IX or CFLoat or CTri) and ((Desc<>'') and (CRates[BOff]+CRates[BOn] <> 0));

      If (FoundOk) then
        Break;

    end;

  end; {Proc..}




{ ========== TThreadQueue methods =========== }

Constructor TEntPost.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 This will be set to the appropriate
  //value in Start methods
  ProcessLockType := plNone;

  fTQNo:=1;

  fCanAbort:=BOn;

  If (Syss.ProtectPost) then
  Begin
    fPriority:=tpHigher;
    fSetPriority:=BOn;
  end;

  FillChar(LLockAddr,Sizeof(LLockAddr),0);

  IsParentTo:=BOff;

  LastFolio:=0;
  CHistRAddr:=0;
  AbortTran:=BOff;
  TranOk2Run:=BOff;
  HaveAborted:=BOff;
  AbortLines:=BOff;
  LockApplied:=BOff;
  CommitMode:=0;
  InCheckStock:=BOff;
  fFromSV:=BOff;

  CheckActMode:=0;

  ThisPRunNo:=0;

  ItemCtrlCount:=0;
  ItemCtrlTotal:=0;

  COSHookEvent:=BOff;
  ADJNomHookEvent:=BOff;
  ProtectLDateEvent:=BOff;

  UseSQLPost := False;

  {$IFDEF FRM}
    ThisFList:=nil;

    PostLog:=nil;

  {$ENDIF}

  New(PostRepCtrl);

  try
    FillChar(PostRepCtrl^,Sizeof(PostRepCtrl^),0);

    With PostRepCtrl^.PParam do
    Begin
      UFont:=TFont.Create;
      UFont.Size:=7;
      PDevRec.NoCopies:=1;
      Orient:=RPDefine.poLandscape;

      try
        UFont.Assign(Application.MainForm.Font);
      except
        UFont.Free;
        UFont:=nil;
      end;
    end;

  except
    Dispose(PostRepCtrl);
    PostRepCtrl:=nil;
  end;

end;

Destructor TEntPost.Destroy;

Begin
  If (Assigned(PostRepCtrl)) then
  Begin
    PostRepCtrl^.PParam.UFont.Free;
    Dispose(PostRepCtrl);
    PostRepCtrl:=nil;
  end;

  // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
  if Assigned(LPostLocal) then
  begin
    // CJS - 07/03/2011: ABSEXCH-9461 - Fix to release ClientID Bit after use
    Reset_ClientBit;

    Dispose(LPostLocal, Destroy);
  end;

  {$IFDEF FRM}
    If (Assigned(PostLog)) then
      FreeAndNil(PostLog);
  {$ENDIF}

  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
  if Assigned(Application.Mainform) then
    SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(ProcessLockType), 0);

  Inherited Destroy;
end;


{$IFDEF PF_On}

  { ============== Function to Check if Auto Item ready for Inclusion ============= }

    Function TEntPost.Auto_Include(InvR  :  InvRec)  :  Boolean;

    Var
      TmpBo  :  Boolean;


    Begin
      TmpBo:=BOff;

      With InvR do
        Case AutoIncBy of
          PeriodInc  :  TmpBo:=(Pr2Fig(AcYr,AcPr)<=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr));
          DayInc     :  TmpBo:=(TransDate<=Today);
        end; {Case..}

      Auto_Include:=TmpBo;
    end; {Func..}

    { ============= Procedure to Set Next Auto Period / Date ============== }

  Procedure TEntPost.Set_NextAuto(Var  InvR  :  InvRec);

  Var
    n       :   Integer;
    AutoYr,
    AutoPr  :   Byte;

   Function Calc_NewAutoDate(LastVDate  :  LongDate;
                            NoMnths    :  Integer)  :  LongDate;

  Var
    Vd,Vm,Vy  :  Word;
    lLastDate  : TDateTime;

  Begin
    DateStr(LastVDate,Vd,Vm,Vy);

    AdjMnth(Vm,Vy,NoMnths);

    //SS:23/07/2017:2017-R2:ABSEXCH-18101:Auto Transactions Created With Invalid Dates.
    if not IsValidDate(Vy,Vm,Vd) then
    begin
      lLastDate  := EndOfAMonth(Vy,Vm);
      DecodeDate(lLastDate,Vy,Vm,Vd);
    end;

    Result:=StrDate(Vy,Vm,Vd);
  end;



  Begin
    With InvR do
      Case AutoIncBy of
        PeriodInc  :  Begin
                        n:=AcPr+AutoInc;

                        AutoPr:=n mod Syss.PrinYr;

                        If (AutoPr=0) then     {* Normal mod /div rules don't apply if are sitting on
                                                    the actual value eg 12 mod 12 =0 *}
                        Begin
                          AutoPr:=Syss.PrinYr;
                          AcYr:=Pred(AcYr);
                        end;

                        AutoYr:=ACYr+(n div Syss.PrinYr);

                        ACPr:=AutoPr;
                        ACYr:=AutoYr;

                        If (OnPickRun) then
                          TransDate:=Calc_NewAutoDate(Transdate,AutoInc);
                      end;
        DayInc     :  Begin
                        TransDate:=CalcDueDate(TransDate,AutoInc);
                        DueDate:=CalcDueDate(TransDate,AutoInc);

                      end;
      end; {Case..}
  end; {Proc..}


  { === Function to Reverse effect of value == }

  Function  TEntPost.ReverseUnpost  :  SmallInt;

  Begin
    Result:=1;

    If (UnPostRunNo>0) then
      Result:=-1;

  end;

  { == Psuedo call to ThreadRec^.Abort == }

  Function TEntPost.Has_Aborted  :  Boolean;

  Begin
    If (Assigned(ThreadRec)) then
      Result:=ThreadRec^.THAbort
    else
      Result:=BOff;
  end;

  { =============== Function to Expire an AutoItem ================ }

  Function TEntPost.Expire_Auto(InvR  :  InvRec)  :  Boolean;

  Var
    TmpBo  :  Boolean;


  Begin
    TmpBo:=BOff;

    With InvR do
      Case AutoIncBy of
        PeriodInc  :  TmpBo:=(Pr2Fig(AcYr,AcPr)>Pr2Fig(UnYr,UnPr));
        DayInc     :  TmpBo:=(TransDate>UntilDate);
      end; {Case..}

    Expire_Auto:=TmpBo;

  end; {Func..}




  { =============== Generate Automatic Daybook Lines ============== }

  Procedure TEntPost.Generate_AutoLines(InvR       :  InvRec;
                                        AutoFolio  :  Str255;
                                        PostOPtr   :  Pointer);


  Const
    Fnum     =  IDetailF;
    KeyPath  =  IdFolioK;

  Var
    KeyChk    :  Str255;
    AutoAddr  :  LongInt;
    AutoId    :  IDetail;

    {$IFDEF JC}
      PostJobObj  :  ^TPostJobObj;
    {$ENDIF}

    TmpInv : InvRec;


  Begin
    {$IFDEF JC}
      PostJobObj:=PostOPtr;
    {$ENDIF}

    With MTExLocal^ do
    Begin

      KeyChk:=AutoFolio;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,AutoFolio);

      While (LStatusOk) and (CheckKey(KeyChk,AutoFolio,Length(KeyChk),BOn)) do
      Begin

        {Application.ProcessMessages;}

        AutoId:=LId;

        LStatus:=LGetPos(Fnum,AutoAddr);

        If (LStatusOk) then
        Begin
          LId.FolioRef:=InvR.FolioNum;

          LId.DocPRef:=InvR.OurRef;

          LId.PDate:=InvR.TransDate;

          LId.PPr:=InvR.AcPr;

          LId.PYr:=InvR.AcYr;

          LId.PostedRun:=0;

          //PR: Set Service Start & End Date to Transaction Date.
          if LId.ECService then
          begin
            LId.ServiceStartDate := InvR.TransDate;
            LId.ServiceEndDate := InvR.TransDate;
          end;

          {$IFDEF MC_On}

            if (not InvR.SOPKeepRate) then
            begin
              if (InvR.InvDocHed=NMT) then
              Begin
                LId.CXRate:=SyssCurr.Currencies[LId.Currency].CRates; {* Set in case of Co. rate change *}
                LId.UseORate:=0;
                SetTriRec(LId.Currency,LId.UseORate,LId.CurrTriR);

              end
              else if (InvR.Currency=LId.Currency) then  {* if not a variance line *}
                Begin
                  LId.CXRate:=InvR.CXRate;
                  LId.UseORate:=InvR.UseORate;
                  LId.CurrTriR:=InvR.CurrTriR;

                end;
            end;
          {$ENDIF}


          LStatus:=LAdd_Rec(Fnum,Keypath);

          LReport_BError(Fnum,LStatus);

          {$IFDEF JC}
            If (LStatusOk) and (JBCostOn) and (Assigned(PostJobObj)) and (DetLTotal(LId,BOn,BOff,0.0)<>0) and (LId.KitLink=0) then
              PostJobObj^.LUpdate_JobAct(LId,InvR);
          {$ENDIF}

          {$IFDEF SOP} {Include affect on committed as we create the auto transaction}
            If (CommitAct) then
              Update_LiveCommit(LId,1);
          {$ENDIF}

          LSetDataRecOfs(Fnum,AutoAddr);

          LStatus:=LGetDirect(Fnum,KeyPath,0);

(* PR: 23/09/2009 Not used by request of MH.
          //PR: 23/09/2009 If we have a service line then we need to recalculate the start & end dates
          if LId.ECService then
          begin
            //Copy Transaction Header into Temporary Record so we can use EL's Set_NextAuto procecure.
            TmpInv := LInv;
            TmpInv.OnPickRun := True; //Need to set this so that Set_NextAuto routing respects the date when incrementing by period.

            //StartDate
            TmpInv.TransDate := LId.ServiceStartDate;
            Set_NextAuto(TmpInv);
            LId.ServiceStartDate := TmpInv.TransDate;

            //End Date
            TmpInv.TransDate := LId.ServiceEndDate;
            Set_NextAuto(TmpInv);
            LId.ServiceEndDate := TmpInv.TransDate;

            LStatus := LPut_Rec(FNum, KeyPath);
          end; *)
          
        end;
  
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,AutoFolio);
      end; {While..}
    end; {With..}
  end; {Proc..}


  Procedure TEntPost.Print_AutoItems;

  Var
    RForm  :  Str10;
    RMode  :  Byte;

  Begin
    With MTExLocal^,LInv,PostRepCtrl^,PParam do
    Begin
      {$IFDEF FRM}

        RMode:=EntDefPrnMode[InvDocHed];

        If (LCust.CustCode<>CustCode) then {* Get Cust record for form def switch over *}
          LGetMainRec(CustF,CustCode);

        RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[RMode];

        If (Assigned(ThisFList)) then
        Begin
          Try
            ThisFList.AddVisiRec(PDevRec,DEFDEFMode[InvDocHed],RForm,InvF,InvOurRefK,IdetailF,IdFolioK,
                                 OurRef,FullNomKey(FolioNum));

          Except
            ThisFList.Free;
            ThisFList:=nil;
          end;
        end;

      {$ENDIF}
    end; {With..}
  end;


  { =============== Automatic daybook Posting Procedure -
                    Scans Automatic daybook (Run No.-2)
                    creates an entry in the daybook for all those due.
                                                               =============== }

  Procedure TEntPost.Post_ItAuto(PostSet       :  DocSetType;
                             Var PrintToQueue,
                                 ItemsOnQ      :  Boolean;
                                 Curr_Pno      :  Byte;
                                 NormalPost    :  Boolean);

  Const
    Fnum    =  InvF;
    KeyPath =  InvRnoK;


  Var
    DocKey   :  Str255;
    AutoInv  :  InvRec;
    AutoAddr :  LongInt;
    MsgForm  :  TForm;
    HookNotify,
    LOk,
    Locked   :  Boolean;
    APostSet :  DocSetType;

    {$IFDEF JC}
      PostJobObj  :  ^TPostJobObj;
    {$ELSE}
      PostJobObj  :  Pointer;
    {$ENDIF}

  Begin
    {$IFDEF JC}
      If (JBCostOn) then {* Create obj to give access to Job_UpdateActual..}
        New(PostJobObj,Create(Self.fMyOwner))
      else
        PostJobObj:=nil;
    {$ELSE}

      PostJobObj:=nil;

    {$ENDIF}



    {$IFDEF CU}

      HookNotify:=LHaveHookEvent(2000,106,LOk);

    {$ELSE}
      HookNotify:=BOff;

    {$ENDIF}


    Try
      {$IFDEF JC}
        If (Assigned(PostJobObj)) then
          PostJobObj^.MTExLocal:=Self.MTExLocal;

      {$ENDIF}

      Addch:=ResetKey;

      Fillchar(DocKey,Sizeof(DocKey),0);

      ShowStatus(2,'Please Wait. Generating Automatic Items.');


      APostSet:=PostSet;

      If (SIN In APostSet) then
      Begin
        APostSet:=APostSet+[SQU];
        With PostRepCtrl^ do
          IncDocFilt:=IncDocFilt+[SQU];
      end;

      If (PIN In APostSet) then
      Begin
        APostSet:=APostSet+[PQU];

        With PostRepCtrl^ do
          IncDocFilt:=IncDocFilt+[PQU];
      end;

      DocKey:=FullDayBkKey(AutoRunNo,FirstAddrD,'')+NdxWeight;

      {$IFDEF FRM}

        ThisFList:=TPFormList.Create;


      {$ENDIF}

      With MTExLocal^ do
      Begin

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,DocKey);

        While (LStatusOk) and (LInv.RunNo=AutoRunNo) and (Not ThreadRec^.THAbort) do
        With LInv do
        Begin
          {Application.ProcessMessages;}


          {$B-}

          If (CheckHold(InvDocHed,HoldFlg,APostSet))
            and (InvDocHed In APostSet)
            and ((InvDocHed In PostRepCtrl^.IncDocFilt) or (PostRepCtrl^.NoIDCheck))
            and (Auto_Include(LInv))
            and ((AutoPost) or (NormalPost)) then

          {$B+}

          Begin

            AutoInv:=LInv;

            LStatus:=LGetPos(Fnum,AutoAddr);


            If (LStatusOk) then
            Begin
              {$IFDEF MC_On}

                If (InvDocHed<>NMT) then
                Begin
                  CXRate:=SyssCurr.Currencies[Currency].CRates;

                  SetTriRec(Currency,0,CurrTriR);

                  If (Not (InvDocHed In DirectSet)) then
                     CXRate[BOff]:=0;
                end;

                UseORate:=0;

              {$ENDIF}

              Case AutoIncBy of
                PeriodInc  :  If (Not OnPickRun) then
                                TransDate:=LPr2Date(AcPr,AcYr,MTExLocal); {v5.52. OnPickRun True, Date is worked out by incrementing date with same period increment}
                DayInc     :  Begin
                                ACPr:=GetLocalPr(0).CPr;
                                ACYr:=GetLocalPr(0).CYr;

                                LDate2Pr(TransDate,AcPr,AcYr,MTExLocal);
                              end;
              end; {Case..}

              // MH 27/02/2015 v7.0.13 ABSEXCH-15298: Prevent creation of Auto-Transactions with Settlement Discount from 01/04/2015
                 // Transaction Type doesn't support settlement discount
              If (Not DocTypeCanHaveSettlementDiscount(InvDocHed))
                 Or
                 // Settlement Discount not specified
                 ((DiscSetl = 0.0) And (DiscDays = 0.0))
                 Or
                 // Settlement Discount supported for Transaction Date
                 SettlementDiscountSupportedForDate (TransDate) Then
              Begin
                RunNo:=0;

                NomAuto:=BOn;

                //PR: 23/09/2009 If re-instating Service Date adjustments, move the next line to after Generate_AutoLines.
                AutoIncBy:=#0;  AutoInc:=0;

                AutoPost:=BOff; OnPickRun:=BOff;

                LGetMainRec(CustF,CustCode);

                DueDate:=CalcDueDate(TransDate,LCust.PayTerms);

                OpName:=EntryRec^.LogIn;

                { CJS - 2013-10-25 - MRD2.6.02 - Transaction Originator }
                TransactionOriginator.SetOriginator(LInv);

                If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) and
                   (InvDocHed In DirectSet) then  {* Cash Accounting set VATdate to Current VATPeriod for Directs only *}
                Begin

                  // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                  VATPostDate:=CalcVATDate(TransDate);  {v5.71. CA Allows jump to future period, set from period of self}

                  UntilDate:=Today;

                end;

                Set_DocAlcStat(LInv);

                LSetNextDocNos(LInv,BOn);

                Generate_AutoLines(LInv,FullIdkey(AutoInv.FolioNum,0),PostJobObj);

                //PR: 23/09/2009 Moved from above
                {AutoIncBy:=#0;  AutoInc:=0;} //PR: 23/09/2009 Undone at MH's request.


                LStatus:=LAdd_Rec(Fnum,Keypath);

                LReport_BError(Fnum,LStatus);

                If (LStatusOk) then
                Begin
                  //PR: 27/10/2011 v6.9 Add Audit Note to auto transaction.
                  oAuditNote.AddNote(anTransaction, LInv.FolioNum, anCreate);

                  {* Add to Cust balance *}

                  If (Not Syss.UpBalOnPost) and (Not (InvDocHed In QuotesSet+PSOPSet)) then
                    LUpdateBal(LInv,BaseTotalOS(LInv),
                                  (ConvCurrICost(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                  (ConvCurrINet(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                  BOff,2);

                  //PR: 15/12/2010 ABSEXCH-2154 Don't try to print auto transactions from the scheduler
                  {$IFNDEF SCHEDULER}
                  {* Add to print Q all Normal print docs, except PPY, as these will not be allocated *}
                  If (LInv.InvDocHed In AutoPrnSet-[PPY])  then
                  Begin
                    Print_AutoItems;

                    {* Ex 32 use this flag if you want to warn items were printed *}

                    If (Not ItemsOnQ) then
                      ItemsOnQ:=BOn;

                  end;
                  {$ENDIF}

                  {$IFDEF CU}
                      {* Notification event to inform customisation new transaction created via auto daybook process }

                      If (HookNotify) then
                        LExecuteHookEvent(2000,106,MTExlocal^);

                  {$ENDIF}
                end;

                LSetDataRecOfs(Fnum,AutoAddr);

                LStatus:=LGetDirect(Fnum,KeyPath,0);

                LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOn,Locked);

                If (LOk) and (Locked) then
                Begin
                  LGetRecAddr(Fnum);

                  Set_NextAuto(LInv);

                  If (Expire_Auto(LInv)) then  {* Check if auto item expired *}
                  Begin

                    LStatus:=LDelete_Rec(Fnum,KeyPath);

                    LReport_BError(Fnum,LStatus);

                    If (LStatusOk) then  {* Delete lines *}
                      LDeleteLinks(FullIdkey(LInv.FolioNum,StkLineNo),IdetailF,Sizeof(LInv.FolioNum),IdFolioK,BOff);


                  end
                  else
                  Begin
                    LStatus:=LPut_Rec(Fnum,Keypath);

                    LReport_BError(Fnum,LStatus);

                    LStatus:=LUnLockMLock(Fnum);
                  end;


                end;
              End // If (Not DocTypeCanHaveSettlementDiscount(InvDocHed)) Or ...
              Else
                // Log warning that transaction was not created
                Write_PostLogDD(LInv.OurRef+' not processed due to Settlement Discount being specified.', BOn, LInv.OurRef, 0);
            end; {If Address found ok..}
          end; {If Document ready to post..}



          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,DocKey);
        end; {While..}

        {$IFDEF FRM}
          If (Assigned(ThisFList)) then
            With ThisFList do
              If (HasItems) then
                Print_BatchList(Application.MainForm,ThisFList);
        {$ENDIF}
      end; {With..}

     {MsgForm.Free;}

     PrintToQueue:=BOff;

    finally

      {$IFDEF JC}
        If (Assigned(PostJobObj)) then
          Dispose(PostJobObj,Destroy);

      {$ENDIF}
    end; {Try..}

  end; {Proc..}

{$ENDIF}



 { ============================== Control Posting Summary ========================= }

 Procedure TEntPost.InitPostingSumm(var PostSummary: PostingSummaryArray;
                         	   	          Put: Boolean);

 Var
   n       :  Byte;
   TL      :  LongInt;
   SalesOn :  Boolean;


 Begin
   If (Not Put) then
     Blank(PostSummary,Sizeof(PostSummary));

   TL:=0;

   For SalesOn:=BOff to BOn do
     For n:=1 to MaxPostingAnalysisTypes do
     With PostSummary[SalesOn,n] do
     Begin
       If (Not Put) then
      	 DocumentType := PostingAnalysisDocTypes[SalesOn,n];

       With MTExLocal^ do
         {If (Not Put) or (PSumm[2]<>0) then {* Only store if some movement has taken place. v4.32.001 check altered not to look at movment*}
         {
           Use LGetNextCount to locate the record which holds the next
           transaction number for the document type. The return value from this
           function is ignored, and will instead be read directly from the
           record (which LGetNextCount() is assumed to have located).
         }
           TL:=LGetNextCount(DocumentType,BOff,Put,Totals[3]);

       If (Not Put) then
       Begin
         { Store the next transaction number }
	       Totals[1] := Round_Up(MTExLocal^.LCount.LastValue,2);
         Totals[3] := Totals[1];
       end;
     end; {Loop..}

 end; {Proc..}

// CJS - 18/04/2011: ABSEXCH-11252 - Posting Run performance enhancements
procedure TEntPost.UpdatePostingSummary(var PostSummary: PostingSummaryArray;
  DocumentType: DocTypes);
var
  SalesOn: Boolean;
  n: Integer;
begin
  // Find the Posting Summary entry for the Document Type
  for SalesOn := False to True do
     for n := 1 to MaxPostingAnalysisTypes do
       if PostSummary[SalesOn, n].DocumentType = DocumentType then
       begin
         // Update EXCHQNUM and exit
         MTExLocal^.LGetNextCount(DocumentType, False, True, PostSummary[SalesOn, n].Totals[3]);
         break;
       end;
end;



 { ============= Calculate Various Posting Summaries ============= }

 Procedure TEntPost.CalcSum(DocHed       :  DocTypes;
                            SalesOn,
                            DebRun       :  Boolean;
                        Var PostSummary  :  PostingSummaryArray;
                            Amount       :  Real);

 Var
   n    :  Byte;

 Begin
   If (DocHed In DirectSet) then
     Case DocHed of
       SRI,PPI
               :  If (DebRun) then
                    DocHed:=PostingAnalysisDocTypes[SalesOn,2]
                  else
                    DocHed:=PostingAnalysisDocTypes[SalesOn,1];
       SRF,PRF
               :  If (DebRun) then
                    DocHed:=PostingAnalysisDocTypes[SalesOn,2]
                  else
                    DocHed:=PostingAnalysisDocTypes[SalesOn,3];
     end; {Case..}

   For n:=1 to MaxPostingAnalysisTypes do
     With PostSummary[SalesOn,n] do
       If (DocumentType = DocHed) then
       Begin
      	 Totals[2] := Totals[2] + Round_Up(Amount, 2);
      	 Totals[3] := Round_Up(Totals[3], 2) + Round_Up(Amount, 2);
       end;

 end; {Proc..}




 { ================ Post Doc VAT Summary to VAT History ============== }

 Procedure TEntPost.Post_VAT(VYr,VPr  :  Integer;
                             Undo     :  Boolean);

 Var
   V    :  VATType;
   DumR :  Double;
   DedCnst
        :  Integer;


 Begin

   If (Undo) then
     DedCnst:=-1
   else
     DedCnst:=1;



   With MTExLocal^,LInv do
     For V:=VStart to VEnd do
       If (InvVATAnal[V]<>0) then
         LPost_To_Hist(IOVATCode(InvDocHed,NOMVATIO),
                       FullCustCode(SyssVAT.VATRates.VAT[V].Code),
                       (Conv_VATCurr(InvVATAnal[V],VATCRate[BOn],Calc_BConvCXRate(LInv,CXRate[BOn],BOn),
                       Currency,UseORate)*DocCnst[InvDocHed]*DocNotCnst*DedCnst),
                       0,0,0,VYr,VPr,DumR);
 end; {Proc..}

procedure TEntPost.Post_ECVAT(VYr, VPr: Integer; Undo: Boolean);
var
  IdKey,
  BaseIdKey :  Str255;
  DumR: Double;
  DedCnst: Integer;
  TempCleared: Double;
  LineVATRate: Double;
begin
  If (Undo) then
    DedCnst := -1
  else
    DedCnst := 1;
  with MTExLocal^ do
  begin
    with LInv do
    begin
      BaseIdKey := FullNomKey(FolioNum);
      IdKey   := FullIdKey(FolioNum, 1);

      LStatus := LFind_Rec(B_GetGEq, IdetailF, IdFolioK, IdKey);

      while (LStatusOk) and (Checkkey(BaseIdKey, IdKey, Length(BaseIdKey), BOn)) do
      begin
        if LId.PurchaseServiceTax <> 0.0 then
        begin
          LPost_To_Hist('I',
                        FullCustCode(LId.VATCode),
                        Conv_VATCurr(
                                      LId.PurchaseServiceTax,
                                      LInv.VATCRate[BOn],
                                      Calc_BConvCXRate(LInv, LInv.CXRate[BOn], BOn),
                                      LId.Currency,
                                      LId.UseORate
                                    )
                                    * DocCnst[LInv.InvDocHed]
                                    * DocNotCnst
                                    * DedCnst,
                        0, 0, 0, VYr, VPr, DumR
                       );

          LPost_To_Hist('O',
                        FullCustCode(LId.VATCode),
                        Conv_VATCurr(
                                      LId.PurchaseServiceTax,
                                      LInv.VATCRate[BOn],
                                      Calc_BConvCXRate(LInv, LInv.CXRate[BOn], BOn),
                                      LId.Currency,
                                      LId.UseORate
                                    )
                                    * DocCnst[LInv.InvDocHed]
                                    * DedCnst,
                        0, 0, 0, VYr, VPr, DumR
                       );
          if Undo then
          begin
            If (Not (LInv.InvDocHed In NOMSplit)) then
            Begin
              If (LInv.OldORates[UsecoDayRate]<>0.0) then {* We have been through a conversion, and this needs to be stated
                                            in original currency*}
                LineVATRate:=LInv.OldORates[UseCoDayRate]
              else
                If (UseCoDayRate) then
                  LineVATRate:=LId.CXrate[UseCoDayRate]
                else
                  LineVATRate:=LInv.OrigRates[UseCoDayRate];
            end
            else
              LineVATRate:=LId.CXrate[UseCoDayRate];
            TempCleared:=Conv_VATCurr(DetLTotal(LId,BOn,LInv.DiscTaken,LInv.DiscSetl),LInv.VATCRate[UseCoDayRate],
                                 LineVATRate,LInv.Currency,LInv.UseORate);
            If (TempCleared<>0) then
            begin
              LPost_To_Hist('O',
                            FullCustCode(SyssVAT.VATRates.VAT[GetVATNo(LId.VATCode,LId.VATIncFlg)].Code),
                            0,TempCleared * DocNotCnst,0,0,VYr,VPr,
                            TempCleared);
            end;
          end;
        end;
        LStatus := LFind_Rec(B_GetNext, IdetailF, IdFolioK, IdKey);
      end;
    end;
  end;
end;


{ ================= Procedure to Set DocCtrlCodes ================ }

Procedure TEntPost.SetControlCodes(DocHed  :  DocTypes;
                               Var CtrlSet :  ControlAry);


Begin
  Blank(CtrlSet,Sizeof(CtrlSet));

  If (DocHed In SalesSplit) then
  Begin
    CtrlSet[DebCred]:=Syss.NomCtrlCodes[Debtors];
    CtrlSet[VATCtrl]:=Syss.NomCtrlCodes[OutVAT];
    CtrlSet[DiscCtrl]:=Syss.NomCtrlCodes[DiscountGiven];
    CtrlSet[LDiscCtrl]:=Syss.NomCtrlCodes[LDiscGiven];
  end
  else
  If (DocHed In PurchSplit) then
  Begin
    CtrlSet[DebCred]:=Syss.NomCtrlCodes[Creditors];
    CtrlSet[VATCtrl]:=Syss.NomCtrlCodes[InVAT];
    CtrlSet[DiscCtrl]:=Syss.NomCtrlCodes[DiscountTaken];
    CtrlSet[LDiscCtrl]:=Syss.NomCtrlCodes[LDiscTaken];
  end;
end;





  Procedure TEntPost.ShowPostFailMsg(SMsg  :  Str255);
  Begin
    If (Assigned(MTExLocal^.LThShowMsg)) then
      MTExLocal^.LThShowMsg(nil,2,SMsg)
    else
      ShowMessage(SMsg);
  end;


  { ================ Construct Posting Title ============== }

  Function TEntPost.Posting_Title(Mode  :  Byte)  :  Str80;


  Const
    PostXlate  :  Array[1..3] of Byte = (2,1,3);


  Var
    TStr  :  Str80;



  Begin

    TStr:='All Ledgers - ';

    If (Mode>0) then
      TStr:=DocGroup[PostXLate[Mode]]+' Ledger - ';

    Posting_Title:=TStr;

  end; {Func..}




 { ===== Function to determine if a Nominal has a Paying in mode setup ====== }


 Function TEntPost.Has_PayinMode(NomCode  :  LongInt)  :  Boolean;


 Const
   Fnum     =   IDetailF;
   Keypath  =   IDNomK;




 Var

   TmpKPath,
   TmpStat  :   Integer;

   TmpRecAddr
            :  LongInt;

   TmpId    :  IDetail;

   KeyS,
   KeyChk   :   Str255;



 Begin

   With MTExLocal^ do
   Begin
     TmpId:=LId;

     TmpKPath:=GetPosKey;

     TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

     KeyChk:=FullIdKey(NomCode*DocNotCnst,PayInNomMode);

     KeyS:=KeyChk;

     LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

     Has_PayInMode:=((LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)));

     TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

     LId:=TmpId;
   end; {With..}
 end; {Func..}




 { ============ Procedure Add Pay_In Collation Line ============= }

 Procedure TEntPost.Add_PayInRec(NextRef  :  Str10;
                                 Idr      :  IDetail;
                                 SingleItem
                                          :  Boolean);



 Const

   Fnum     =  IDetailF;
   Keypath  =  IdStkK;



 Begin

   With MTExLocal^,LId do
   Begin

     LResetRec(Fnum);

     PPr:=Idr.PPr;
     PYr:=Idr.PYr;

     Currency:=Idr.Currency;

     NomCode:=Idr.NomCode*DocNotCnst;   

     CXRate:=Idr.CXRate;

     CurrTriR:=Idr.CurrTriR;

     PDate:=Idr.PDate;

     QtyMul:=1;

     PriceMulX:=1.0;

     IdDocHed:=RUN;

     PostedRun:=PayInRunNo;

     NomMode:=PayInNomMode;

     Reconcile:=IdR.Reconcile;

     If (SingleItem) then
     Begin
       CustCode:=Idr.CustCode;
       Desc:=Idr.Desc;
     end
     else
       Desc:=NextRef;

     Qty:=1;

     StockCode:=Full_PostPayInKey(PayOutCode,NomCode,Currency,NextRef);

     LStatus:=LAdd_Rec(Fnum,KeyPath);

     LReport_BError(Fnum,LStatus);

   end; {With..}

 end; {Proc..}

{ ============ Payin In Status Check =========== }
{ Reproduced non threaded in ExtGetU }

Function TEntPost.LCheck_PayInStatus(Var IdR  :  IDetail)  :  Byte;

Const
  Fnum       =  IDetailF;
  Keypath2   =  IDStkK;


Var

  TmpKPath,
  TmpStat :  Integer;

  TmpRecAddr
          :  LongInt;

  KeyS,
  KeyChk  :  Str255;
  PayId   :  Idetail;

  AllClear,
  SomeClear
          :  Boolean;


Begin

  With MTExLocal^ do
  Begin
    TmpKPath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    PayId:=IdR;

    With PayId do
      KeyChk:=Full_PostPayInKey(PayInCode,NomCode,Currency,Extract_PayRef2(StockCode));

    AllClear:=BOn;

    SomeClear:=BOff;

    KeyS:=KeyChk;

    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath2,KeyS);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LId do
    Begin

      If (AllClear) then
        AllClear:=(Reconcile=ReconC);

      If (Not SomeClear) then
        SomeClear:=(Reconcile=ReconC);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath2,KeyS);

    end; {While..}

    LCheck_PayInStatus:=(Ord(SomeClear)+Ord(AllClear));

    IdR:=PayId;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

  end; {With..}

end; {Func..}


 { ============ Process Pay_In Lines ============= }


 Procedure TEntPost.Process_Payin(CurrKeyPath  :  Integer);



 Const

   Fnum     =  IDetailF;

   Keypath  =  IdStkK;

   ItemStr  :  Array[BOff..BOn] of Str10 =(' Item ',' Items ');


 Var
   Idr      :  IDetail;

   KeyChk,
   KeyS     :  Str255;

   NextRef  :  Str10;

   LOk,
   Locked,
   SingleItem
            :  Boolean;

   RecAddr  :  LongInt;




 Begin

   With MTExLocal^ do
   Begin

     Idr:=LId;

     RecAddr:=0;

     SingleItem:=BOff;

     With LId do
     Begin


       NextRef:=Extract_PayRef1(StockCode);

       SingleItem:=(EmptyKey(NextRef,PIKeyLen));


       {$B-}

       If ((IS_PayInLine(StockCode)) and ((Not SingleItem) or (Has_PayInMode(NomCode)))) then

       {$B+}

       Begin

         LStatus:=LGetPos(Fnum,RecAddr);  {* Preserve Posn of Invoice Line *}

         If (LStatusOk) then
         Begin

           If  (SingleItem) then
             NextRef:=LFullDocNum(API,BOn);

           KeyChk:=Full_PostPayInKey(PayOutCode,NomCode,Currency,NextRef);

           KeyS:=KeyChk;

           LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

           If (Not LStatusOk) then
             Add_PayInRec(NextRef,Idr,SingleItem);


           KeyS:=KeyChk;

           If (LStatusOk) then
             LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked)
           else
             LOk:=BOff;

           If (LOk) and (Locked) then
           Begin
             LGetRecAddr(Fnum);

             NetValue:=NetValue+DetLTotal(Idr,Not Syss.SepDiscounts,BOff,0.0);

             If (Not SingleItem) then
             Begin

               QtyWOFF:=QtyWOFF+1;

               Desc:=NextRef+' '+Form_Real(QtyWOFF,1,0)+ItemStr[(QtyWOFF>1)];
             end;

             If (Reconcile=ReconC) and (IdR.Reconcile<>ReconC) then {* Only change if was cleared *}
               Reconcile:=IdR.Reconcile;

             { CJS 2013-09-02 - ABSEXCH-14199 - tlRecon date not preserved after
               unpost - added check that the date is not already set }
             if Trim(ReconDate) = '' then
             begin
               If (Reconcile=ReconC) then
                 ReconDate:=Today
               else
                 ReconDate:=MaxUntilDate;
             end;

             LStatus:=LPut_Rec(Fnum,KeyPath);

             LReport_BError(Fnum,LStatus);

             LStatus:=LUnLockMLock(Fnum);

             If (LStatusOk) then  {* Update original Line *}
             Begin

               LSetDataRecOfs(Fnum,RecAddr);

               LStatus:=LGetDirect(Fnum,CurrKeyPath,0);

               If (LStatusOk) then
                 LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,CurrKeyPath,Fnum,BOn,Locked)
               else
                 LOk:=BOff;

               If (LOk) and (Locked) then
               Begin
                 LGetRecAddr(Fnum);

                 StockCode:=Full_PostPayInKey(PayInCode,NomCode,Currency,NextRef);

                 LStatus:=LPut_Rec(Fnum,CurrKeyPath);

                 LReport_BError(Fnum,LStatus);

                 LStatus:=LUnLockMLock(Fnum);

               end; {If Locked ok..}

             end; {If Payin Line updated ok..}

           end {If Payin Line Locked Ok..}
           else
             LId:=Idr;  {* attempt to restore record.. *}

         end; {If Actual detail line pos recorded ok..}
       end; {If Line is possible to process..}
     end; {With..}
   end; {With..}
 end; {Proc..}


 { == Procedure to Create an auto reversing journal ==}


 Procedure TEntPost.AutoReverseNom(Fnum2,Keypath2  :  Integer;
                                   NomInv          :  InvRec;
                                   RecAddr2        :  LongInt);

 Const
   Fnum     =  IDetailF;
   Keypath  =  IdFolioK;


 Var
   TTEnabled:  Boolean;
   HasData  :  Boolean;

   TStatus  :  Integer;

   RecAddr1 :  LongInt;

   VLoop    :  VATType;


   KeyChk,
   KeyS     :  Str255;

   TmpInv   :  InvRec;
   TmpId    :  IDetail;

 Begin
   With MTExLocal^ do
   Begin
     HasData:=BOff;
     TmpInv:=LInv;
     TmpId:=LId;

     {* Preserve current Inv position &}

     {LStatus:=LGetPos(Fnum2,RecAddr2); Not needed as routine already passed this in }

     With LInv do
     Begin
       RunNo:=AutoRunNo;
       NomAuto:=BOff;

       AdjPr(AcYr,AcPr,BOn);

       TransDesc:=TransDesc+'. Auto Reverse';

       AutoIncBy:=PeriodInc;

       AutoInc:=1;

       UntilDate:=MaxUntilDate;

       UnYr:=AcYr;

       UnPr:=AcPr;

       AutoPost:=BOn;

       UnTagged:=BOff;

       Blank(VATPostDate,Sizeof(VATPostDate));

       InvVAT:=InvVAT*DocNotCnst;

       //PR: ABSEXCH-18997 Need to also reverse InvNetVal
       InvNetVal := InvNetVal * DocNotCnst;

       For VLoop:=VStart to VEnd do
         InvVATAnal[VLoop]:=InvVATAnal[VLoop]*DocNotCnst;

     end;


     If (TranOk2Run) then
     Begin
       LStatus:=LCtrl_BTrans(1);

       TTEnabled:=LStatusOk;

       {* Wait until All clear b4 continuing *}
       If (TTEnabled) then
         WaitForHistLock;

     end
     else
       //PR: 18/02/2016 v2016 R1 FIX_WARNINGS Set TTEnabled to false if we don't have a transaction
       TTEnabled := False;


     KeyChk:=FullNomKey(NomInv.FolioNum);
     KeyS:=FullIdKey(NomInv.FolioNum,1);

     LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

     While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
     With LId do
     Begin
       {* Preserve current Inv position &}

       LStatus:=LGetPos(Fnum,RecAddr1);

       If (Not HasData) then
       Begin
         HasData:=BOn;

         SetNextAutoDocNos(LInv,BOn);

       end;

       PostedRun:=0;
       PreviousBal:=0.0;
       FolioRef:=LInv.FolioNum;
       DocPRef:=LInv.OurRef;
       PYr:=LInv.ACYr;
       PPr:=LInv.ACPr;



       NetValue:=Round_Up(NetValue*DocNotCnst,2);

       VAT:=Round_Up(VAT*DocNotCnst,2);



       LStatus:=LAdd_Rec(Fnum,Keypath);

       LReport_BError(Fnum,LStatus);

       If (Not AbortTran) then
         AbortTran:=(Not LStatusOk) and (TTEnabled);

       LSetDataRecOfs(Fnum,RecAddr1);

       LStatus:=LGetDirect(Fnum,KeyPath,0);

       LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

     end; {While..}

     If (HasData) and (Not AbortTran) then {* Add Header + Restore Pos *}
     Begin
       LStatus:=LAdd_Rec(Fnum2,Keypath2);

       LReport_BError(Fnum2,LStatus);

       LSetDataRecOfs(Fnum2,RecAddr2);

       LStatus:=LGetDirect(Fnum2,KeyPath2,0);

       {* Original nom marked as having generated its reversal so it never generates it again*}
       LInv.PrePostFlg:=1;

       LStatus:=LPut_Rec(Fnum2,Keypath2);

       LReport_BError(Fnum2,LStatus);


     end;


     If (TTEnabled) and (Syss.ProtectPost) then
     With MTExLocal^ do
     Begin
       UnLockHistLock;

       LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

       LReport_BError(InvF,LStatus);
     end;

     LInv:=TmpInv;
     LId:=TmpId;

   end; {With..}

 end; {Proc..}


  { == Functions to enable an interrupted post to be restarted == }

 Function TEntPost.FoundB2BLink(IdR  :  IDetail;
                            Var NInv :  InvRec)  :  Boolean;


 Const
   Fnum      =  InvF;
   Keypath   =  InvFolioK;

 Var
   KeyI  :  Str255;

 Begin
   Result:=BOff;

   With MTExLocal^ do
   Begin
     If (IdR.B2BLink<>0) then
     Begin
       KeyI:=FullNomKey(IdR.B2BLink);

       LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyI);

       NInv:=LInv;

       Result:=LStatusOk and (NInv.RunNo=0);
     end;
   end;
 end;


 { == Check to see if any lines of the adj have already been posted == }

 Function TEntPost.AdjPartPosted(BInv    :  InvRec;
                             Var NInv    :  InvRec;
                                 Fnum,
                                 Keypath :  Integer)  :  Boolean;

 Var
   KeyChk,KeyS  :  Str255;

 Begin
   Result:=BOff;

   With MTExLocal^ do
   Begin
     KeyChk:=FullNomKey(Binv.FolioNum);

     KeyS:=FullIdKey(BInv.FolioNum,StkLineNo);


     LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

     While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Result) do
     With LId do
     Begin
       Result:=FoundB2BLink(LId,NInv);

       If (Not Result) then
         LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

     end; {While..}
   end;
 end;


{$IFDEF STK}


 { ================ Procedure to Access Stock Tree Chain ============== }

 Procedure TEntPost.Post_To_Stock(NCode         :  Str20;
                                  PPurch,PSales,
                                  PCleared,
                                  PValue1
                                                :  Double;
                                  PCr,PYr,PPr   :  Byte;
                                  Level         :  Longint;

                                  PostYTD,AutoLZ,
                                  PostYTDNCF,
                                  QtyMode,
                                  ChkMode       :  Boolean;

                                  CXRate        :  CurrTypes;
                                  LineCOSRate   :  Double;
                                  Locn          :  Str10;
                                  UOR           :  Byte);




 Const
   Fnum  =  StockF;
   NPath =  StkCodeK;

   WMess = '** WARNING! - Unable to post to ';
   WMEss2= ', Check Manual **';
   WMEss3= ', Bad Date!';



 Var
   NKey      :  Str255;
   HistCr,n,
   CnvCr     :  Byte;
   CurrLoop  :  Boolean;

   Rate,
   COSRate,
   PrevBal,
   NoPBal    :  Double;

   NType     :  Char;


 Begin
   Rate:=1.0;  CurrLoop:=BOn;  NType:=ResetKey; COSRate:=1.0;

   NoPBal:=0; CnvCr:=0;

   If (PYr<>0) and (PPr<>0) then
   With MTExLocal^ do
   Begin
     NKey:=NCode;

     If (LStock.StockCode<>NCode) or ((Syss.UseMLoc) and (Not ChkMode)) then
       LStatus:=LFind_Rec(B_GetEq,Fnum,NPath,NKey)
     else
       LStatus:=0;

     CurrLoop:=BOn;

     {* Allow Stk code anal all non Desc codes, or Desc if Anal of desc switched on!!}

     If (LStatusOK) and ((LStock.StockType<>StkDescCode) or ((Syss.AnalStkDesc) and (Not QtyMode))) then
     Begin


       HistCr:=PCr;

       NType:=LStock.StockType;

       If (QtyMode) then
         NType:=Calc_AltStkHCode(Ntype);

       If (Level=1) then
       Begin

         PostYTD:=(NType In YTDSet);

         PostYTDNCF:=((NType In YTDNCFSet) and (Not PostYTD));

       end;

       {* Post First to Doc Cur Hist, then 0 Currency *}

       Repeat

         If (PPr<>YTD) then
         Begin
           LPost_To_Hist2(NType,CalcKeyHistMve(LStock.StockFolio,Locn),
                         Conv_TCurr(PPurch,COSRate,CnvCr,UOR,BOff),
                         Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                         PCleared,                    {* Don't convert as its a qty! *}
                         PValue1,
                         0,
                         HistCr,PYr,PPr,PrevBal);

         end;


         If (LStatusOK) then
         Begin
           If (PostYTD) then {* Post to rolling YTD *}
             LPost_To_CYTDHist2(NType,CalcKeyHistMve(LStock.StockFolio,Locn),
                               Conv_TCurr(PPurch,COSRate,CnvCr,UOR,BOff),
                               Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                               PCleared,
                               PValue1,
                               0,
                               HistCr,PYr,YTD)
           else
             If (PostYTDNCF) then {* Only post to this YTD *}
               LPost_To_Hist2(NType,CalcKeyHistMve(LStock.StockFolio,Locn),
                             Conv_TCurr(PPurch,COSRate,CnvCr,UOR,BOff),
                             Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                             PCleared,                    {* Don't convert as its a qty! *}
                             PValue1,
                             0,
                             HistCr,PYr,YTDNCF,NoPBal);

         end; {If StatusOk..}


           Rate:=XRate(CXrate,BOff,PCr);

           If (LineCOSRate=0.0) then
             COSRate:=Rate
           else
             COSRate:=LineCOSRate;


           HistCr:=0; CnvCr:=PCr;


           CurrLoop:=Not CurrLoop;

       Until (CurrLoop) or (PCr=0) or (Not AutoLZ);


       If (LStatusOK) and (Not EmptyKey(Strip('B',[#32,#0],LStock.StockCat),StkKeyLen))
          and ((PPurch<>0) or (PSales<>0) or (PCleared<>0)) {*EN500UC*}{Do not travel up the tree unless one of the other values is set}
          and (Not QtyMode) then

         Post_To_Stock(LStock.StockCat,PPurch,PSales,PCleared,PValue1,PCr,PYr,PPr,
                       Succ(Level),PostYTD,AutoLZ,PostYTDNCF,BOff,ChkMode,CXRate,LineCOSRate,Locn,UOR);

     end
     else
       If (Not LStatusOk) then
         ShowPostFailMsg(WMess+Strip('B',[#32],NCode));
   end
   else
     ShowPostFailMsg(WMess+Strip('B',[#32],NCode)+WMess3);
 end; {Proc..}






   Procedure TEntPost.Post_CuStkHist(NCode         :  Str20;
                                     PPurch,PSales,
                                     PCleared
                                                   :  Real;
                                     PCr,PYr,PPr   :  Byte;

                                     CXRate        :  CurrTypes;
                                     LineCOSRate   :  Double;
                                     UOR           :  Byte);

   Var
     CurrLoop  :  Boolean;
     HistCr,
     CnvCr     :  Byte;
     Rate,
     COSRate,
     PBal      :  Double;

   Begin
     PBal:=0;  Rate:=1.0; HistCr:=PCr; COSRate:=1.0;

     CurrLoop:=BOff;  CnvCr:=0;

     With MTExLocal^ do
     Repeat
       LPost_To_Hist(CuStkHistCode,NCode,
                                   Conv_TCurr(PPurch,COSRate,CnvCr,UOR,BOff),
                                   Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                                   PCleared,HistCr,PYr,PPr,PBal);

                                                                     {* Post to Non C/F YTD *}

       LPost_To_Hist(CuStkHistCode,NCode,
                                   Conv_TCurr(PPurch,COSRate,CnvCr,UOR,BOff),
                                   Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                                   PCleared,HistCr,PYr,YTDNCF,PBal);

       Rate:=XRate(CXrate,BOff,PCr);

       If (LineCOSRate=0.0) then
         COSRate:=Rate
       else
         COSRate:=LineCOSRate;


       HistCr:=0; CnvCr:=PCr;


       CurrLoop:=Not CurrLoop;

     Until (Not CurrLoop) or (PCr=0) ;

   end;




   { ============ Procedure to post on line history ========== }

   Procedure TEntPost.Ctrl_CuStkHist(IdR       :  IDetail;
                                     Reverse   :  Integer);
   Var
     CTot,
     TotCost,
     TotQty,
     PBal    :  Real;

     Locked,
     LOk,
     Loop    :  Boolean;

     StkFolio:  LongInt;
     GenStr  :  Str255;



   Begin
     PBal:=0;

     With MTExLocal^,IdR do
     Begin
       If (LStock.StockCode<>StockCode) then
         LOk:=LGetMainRecPos(StockF,StockCode)
       else
         LOK:=BOn;

       If (LOK) then
       Begin

         StkFolio:=LStock.StockFolio;

         TotQty:=(Qty*StkAdjCnst[IdDocHed]*DocNotCnst);

         TotCost:=(CostPrice*Calc_IdQty(TotQty,QtyMul,UsePack))*Reverse;

         TotQty:=(TotQty*QtyMul)*Reverse;  {* Adjust qty as costprice already takes into account QtyMul *}

         Ctot:=DetLTotal(IdR,BOn,BOff,0.0)*Reverse*DocNotCnst;


         Post_CuStkHist(Full_CuStkHKey1(CustCode,StkFolio),
                        TotCost,
                        CTot,
                        TotQty,
                        Currency,
                        PYr,PPr,
                        CXRate,
                        COSConvRate,
                        UseORate);

         {* Post to CC/Dep *}

         If (Syss.PostCCNom) and (Syss.UseCCDep) then
         Begin
           Loop:=BOff;

           Repeat
             If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
             Begin

               Post_CuStkHist(Full_CuStkHKey2(CustCode,StkFolio,PostCCKey(Loop,CCDep[Loop])),
                        TotCost,
                        CTot,
                        TotQty,
                        Currency,
                        PYr,PPr,
                        CXRate,
                        COSConvRate,
                        UseORate);

             end;

             Loop:=Not Loop;

           Until (Not Loop);
         end;


         {* Post to MLoc *}

         {$IFDEF SOP} {* Post again for location *}
           If (Syss.UseMLoc) and (Not EmptyKey(MLocStk,MLocKeyLen)) then
             Post_CuStkHist(Full_CuStkHKey3(CustCode,StkFolio,MLocStk),
                            TotCost,
                            CTot,
                            TotQty,
                            Currency,
                            PYr,PPr,
                            CXRate,
                            COSConvRate,
                            UseORate);

         {$ENDIF}

       end; {With..}
     end; {Find Stock}
   end;





 { ========= Procedure to Control Stock Posting ========= }


 Procedure TEntPost.Stock_PostCtrl(Idr   :  IDetail;
                                   CTot  :  Real;
                                   PHOnly:  Boolean);



 Var
   TotCost,
   TotQty,
   QtyUsed   :  Real;

   CrDr      :  DrCrType;



 Begin

   TotQty:=0;

   TotCost:=0;  QtyUsed:=0.0;


   With MTExLocal^,Idr do
   Begin

     If ((Is_FullStkCode(StockCode)) and (Not (IdDocHed In RecieptSet))) then
     Begin

       CTot:=DetLTotal(LId,BOn,BOff,0.0)*ReverseUnpost;


       If (IdDocHed In StkOutSet) and (LineNo>=0) and (Not PHOnly) then  {* Update Sales Values Main invoice lines only *}
       Begin
         TotQty:=(Qty*StkAdjCnst[IdDocHed]*DocNotCnst)*ReverseUnpost;

         TotCost:=(CostPrice*Calc_IdQty(TotQty,QtyMul,UsePack));

         TotQty:=(TotQty*QtyMul);  {* Adjust qty as costprice already takes into account QtyMul *}

         Post_To_Stock(StockCode,TotCost,(CTot*DocNotCnst),TotQty,0,Currency,PYr,PPr,1,BOff,BOn,BOff,BOff,PHOnly,CXRate,COSConvRate,'',UseORate);

         {$IFDEF SOP} {* Post again for location *}
           If (Syss.UseMLoc) and (Not EmptyKey(MLocStk,LocKeyLen)) then
             Post_To_Stock(StockCode,TotCost,(CTot*DocNotCnst),TotQty,0,Currency,PYr,PPr,1,BOff,BOn,BOff,BOff,PHOnly,CXRate,COSConvRate,MLocStk,UseORate);
         {$ENDIF}
       end;

       ShowDrCr(Ctot,CrDr);

       TotQty:=(DeductQty*StkAdjCnst[IdDocHed])*ReverseUnpost;

       If (((IdDocHed In StkAdjSplit) and (KitLink=0)) or (LineNo=StkLineNo)) then  {* Update usage count from hidden lines and Adj Lines*}
         QtyUsed:=TotQty*DocNotCnst;


       {* Update Posting Stock deduct *}


       Post_To_Stock(StockCode,CrDr[BOff],CrDr[BOn],TotQty,QtyUsed,0,PYr,PPr,1,BOff,BOn,BOff,BOn,PHOnly,CXRate,0.0,'',UseORate);

       {$IFDEF SOP} {* Post again for location *}
         If (Syss.UseMLoc) and (Not EmptyKey(MLocStk,LocKeyLen)) then
           Post_To_Stock(StockCode,CrDr[BOff],CrDr[BOn],TotQty,QtyUsed,0,PYr,PPr,1,BOff,BOn,BOff,BOn,PHOnly,CXRate,0.0,MLocStk,UseORate);
       {$ENDIF}

       {$IFDEF PF_On}
         If (AnalCuStk) and (Not (IdDocHed In StkAdjSplit)) and (Not InCheckStock) then
           Ctrl_CuStkHist(LId,ReverseUnpost);

       {$ENDIF}


       {$IFDEF C_On}   {* v5.52 Re-calculate next Note No. in case of corruption *}

        // MH 22/07/08: Removed after consultation with Eduardo as it is unnecessary to calculate the
        //              next note line number for the stock for every transaction line processed.  This
        //              check will be done in TStkChkFrm.Re_CalcStockLevels to minimise overhead, and the
        //              change should improve performance when checking stock and possibly when posting
        //LStock.NLineCount:=LCheck_NoteNo(NoteSCode,FullNCode(FullNomKey(LStock.StockFolio)));

      {$ENDIF}


     end;

   end; {With..}

 end; {Proc..}



{
  == Function to link back to BOMParent Line ==

  This preserves the existing record position in DETAILS.DAT, but populates
  the BOMLine record structure with the contents of the parent line (if found).

  It returns True if a parent line was found  (it assumes that SFolio is the
  folio number for the current transaction, and SLineNo is the line number of
  the parent line), otherwise it returns False.

  It will also return False if a parent line was found, but its B2BLineNo
  is 1.
}
Function TEntPost.GotBOMLine(SFolio,SLineNo  :  LongInt;
                             Fnum,
                             IKeyPath        :  Integer;
                         Var BOMLine         :  IDetail)  :  Boolean;


Var
  KeyI  :  Str255;
  TmpId :  IDetail;

  TmpStat      :  Integer;

  TmpRecAddr   :  LongInt;


Begin
  With MTExLocal^ do
  Begin
    Result:=BOff;

    TmpId:=LId;

    Blank(BOMLine,Sizeof(BomLine));

    TmpStat:=LPresrv_BTPos(Fnum,IKeyPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyI:=FullIdKey(SFolio,SLineNo);

    LStatus:=LFind_Rec(B_GetEq,Fnum,IdLinkK,KeyI);

    If (LStatusOk) then
    Begin
      Result:=(LId.B2BLineNo<>1);
      BOMLine:=LId;

    end;

    TmpStat:=LPresrv_BTPos(Fnum,IKeyPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    LId:=TmpId;
  end;

  GotBOMLine:=Result;

end;


{ == Function to link back to BOMParent Line Stock Record == }

Function TEntPost.GotBOMCOSGL(BOMLine         :  IDetail;
                              Fnum,
                              IKeyPath        :  Integer)  :  LongInt;


Var
  KeyI  :  Str255;

  LOK   :  Boolean;

  TmpStat
        :  Integer;

  TmpRecAddr
        :  LongInt;


Begin
  Result:=0;

  With MTExLocal^ do
  Begin

    TmpStat:=LPresrv_BTPos(Fnum,IKeyPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyI:=FullStockCode(BOMLine.StockCode);

    LOK:=(LStock.StockCode=KeyI);

    If (Not LOk) then
    Begin
      TmpStat:=LFind_Rec(B_GetEq,Fnum,IKeyPath,KeyI);
      LOK:=(TmpStat=0);
    end;

    If (LOK) then
    Begin
      {$IFDEF SOP}
        LStock_LocNSubst(LStock,BOMLine.MLocStk);
      {$ENDIF}

      Result:=LStock.NomCodes[2];
    end;

    TmpStat:=LPresrv_BTPos(Fnum,IKeyPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);
  end;

end;

{$IFDEF SOP}
 { == Function to post the location transfer directly from the out balance sheet account to the in balance sheet account}

 Function TEntPost.Get_LocTxfrNom(WOffNom  :  LongInt;
                              Var ExclLn   :  LongInt;
                              Var OCCDep   :  CCDepType;
                                  Fnum,
                                  Keypath  :  Integer;
                                  KeyS     :  Str255;
                                  KeyChk   :  Str255;
                                  BInv     :  InvRec)  :  LongInt;


 Var

  TmpStat
        :  Integer;

  TmpRecAddr
        :  LongInt;

  TmpId :  IDetail;
  StockR:  StockRec;

  KeyI  :  Str255;

{
  On entry, this routine expects to be on an 'Out' adjustment line. It looks
  for the matching 'In' line, returning the G/L code for the stock item, and
  setting ExclLn to the absolute line number of this line, and returning the
  cost centre/department of the stock item, in OCCDep.

  The Pervasive version of this routine assumes that the 'In' line immediately
  follows the 'Out' line (in physical database position), as the index key
  for these lines will be the same, and cannot therefore be used to identify
  the correct line.

  Because the order of the records cannot be guaranteed under SQL, this revised
  version instead looks for the matching 'In' line using the DelTerms, Stock
  Code, and Qty values.
}

  function FindMatchingLine: Integer;
  { Internal function for finding the 'In' transaction line which matches the
    current 'Out' transaction line. }
  const
    FNum    = IDetailF;
    KeyPath = IdFolioK;
  var
    FolioNum: Integer;
    Key: Str255;
    KeyChk: Str255;
    // CJS 2014-06-12 - ABSEXCH-15320 - multiple stockcode lines on ADJ
    RecAddr: LongInt;
  begin
    { Construct a search key to find all the transaction lines }
    Key := FullNomKey(BInv.FolioNum);
    KeyChk := Key;
    with MTExLocal^ do
    begin
      { Cycle through all the lines in the transaction }
      Result := LFind_Rec(B_GetGEq, FNum, KeyPath, Key);
      while (Result = 0) and (CheckKey(KeyChk, Key, Length(KeyChk), BOn)) do
      begin
        // CJS 2014-06-12 - ABSEXCH-15320 - multiple stockcode lines on ADJ
        LGetPos(Fnum, RecAddr);
        { Is this the matching 'In' record? }
        if (LId.Qty > 0) and
           (BInv.DelTerms <> '') and
           (LId.MLocStk = BInv.DelTerms) and
           (Is_FullStkCode(LId.StockCode)) and
           (LId.StockCode = TmpId.StockCode) and
           // CJS 2014-06-12 - ABSEXCH-15320 - multiple stockcode lines on ADJ
           (not IsExcluded(RecAddr)) then
        begin
          { Record found }
          Result := 0;
          break;
        end;
        Result := LFind_Rec(B_GetNext, FNum, KeyPath, Key);
      end;
    end;
  end;

Begin
  Result:=WOffNom;
  ExclLn:=0;

  With MTExLocal^ do
  Begin
    KeyI := KeyS;

    { Save the current details and position }
    TmpId:=LId;
    StockR:=LStock;
    TmpStat:=LPresrv_BTPos(Fnum,KeyPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    { Locate the 'In' line. }
{$IFDEF EXSQL}
    if SQLUtils.UsingSQLAlternateFuncs then
      TmpStat := FindMatchingLine
    else
{$ENDIF}
    TmpStat:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyI);

    If (TmpStat=0) and (CheckKey(KeyChk,KeyI,Length(KeyChk),BOn))  and (LId.Qty>0) and (BInv.DelTerms<>'') and
       (LId.MLocStk=BInv.DelTerms) and (Is_FullStkCode(LId.StockCode)) and (LId.StockCode=TmpId.StockCode) then
    Begin
      If (LStock.StockCode<>LId.StockCode) then
        LGetMainRec(StockF,LId.StockCode);

      LStock_LocNSubst(LStock,LId.MLocStk); {Override G/L}

      If (LStock.StockType=StkBillCode) then
        Result:=LStock.NomCodes[5]
      else
        Result:=LStock.NomCodes[4];

      If (LId.CCDep[BOff]<>'') and (LId.CCDep[BOn]<>'') then
        OCCDep:=LId.CCDep;

{$IFDEF EXSQL}
      LGetPos(Fnum, ExclLn);
{$ELSE}
      ExclLn:=LId.ABSLineNo;
{$ENDIF}
    end;

    TmpStat:=LPresrv_BTPos(Fnum,KeyPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    LId:=TmpId;
    LStock:=StockR;
  end;

 end; {Func..}

// CJS 2014-06-12 - ABSEXCH-15320 - multiple stockcode lines on ADJ
// =============================================================================
// Support routines for In-Location transfers under SQL
// =============================================================================
procedure TEntPost.Exclude(RecordAddress: LongInt);
{ Adds the specified record address to the list of transaction line records
  which should not be processed. This is used when generating nominal
  transaction lines from an In-Location Adjustment, where the system-generated
  'In' lines have already been dealt with. }
begin
  if (Length(ExcludedLines) > 0) then
    SetLength(ExcludedLines, High(ExcludedLines) + 2)
  else
    SetLength(ExcludedLines, 1);
  ExcludedLines[High(ExcludedLines)] := RecordAddress;
end;

// -----------------------------------------------------------------------------

function TEntPost.IsExcluded(RecordAddress: LongInt): Boolean;
{ Returns True if the specified record address is in the list of transaction
  line records which should not be processed. }
var
  i: Integer;
begin
  Result := False;
  if (Length(ExcludedLines) > 0) then
  begin
    for i := Low(ExcludedLines) to High(ExcludedLines) do
    begin
      if ExcludedLines[i] = RecordAddress then
      begin
        Result := True;
        break;
      end;
    end;
  end;
end;
// =============================================================================

{$ENDIF}

{ =========== Procedure to Scan Adjustment Documents and Adjust posted stock ========= }

 Procedure TEntPost.Post_AdjDetails(BInv          :  InvRec;
                                Var GotHed        :  Boolean;
                                Var NInv          :  InvRec;
                                    PostOPtr      :  Pointer);


 Const
    Fnum     =  IDetailF;
    KeyPath  =  IdFolioK;



  Var
    KeyS,
    KeyI,
    KeyChk   :  Str255;

    RecAddr  :  LongInt;

    NewObject,  {*EL v6.01 Custom CC/Dep Overide Hook  *}
    owHLineCCDep,
    SingNT,
    LOk,
    Locked,
    CuLoop,
    TTEnabled,
    IsWORBuildLine,
    IsRetLine,
    Abort    :  Boolean;

    SBSNom,
    WOFFNom,
    CustomNom,
    UPNom,
    ExclLNo  :  LongInt;

    LineCost :  Real;

    UPVal,
    MatchVal :  Double;

    DedCnst  :  Integer;

    RCCDep,
    OCCDep   :  CCDepType;

    TmpStk,
    TmpStk2  :  StockRec;

    {$IFDEF JC}
      PostJobObj  :  ^TPostJobObj;
    {$ELSE}
      PostJobObj  :  Pointer;
    {$ENDIF}


    CuInv    :  InvRec;
    TmpLine,
    BOMLine  :  IDetail;

    TmpFolioNo  : LongInt;

  Begin

    RecAddr:=0;

    Abort:=BOff;

    //PR: 18/02/2016 v2016 R1 FIX_WARNINGS Initialise TmpFolio to 0 to avoid warning
    TmpFolioNo := 0;

    TTEnabled:=BOff;  LOk:=BOff;  Locked:=BOff;  CustomNom:=0; CuLoop:=BOff;

    Blank(BOMLine,Sizeof(BOMLine));

    Blank(TmpLine,Sizeof(TmpLine));

    Blank(RCCDep,Sizeof(RCCDep));

    WOFFNom:=0; UPNom:=0;  UPVal:=0.0;
    SBSNom:=0;  KeyI:='';

    LineCost:=0;  IsWORBuildLine:=BOff;

    IsRetLine:=BOff;

    {*EL v6.01 Custom CC/Dep Overide Hook  *}

    NewObject:=BOff;
    {$IFDEF CU}
      owHLineCCDep:=LHaveHookEvent(4000,100,NewObject);
    {$ELSE}
      owHLineCCDep:=BOff;
    {$ENDIF}

    {==================}
    
    DedCnst:=1;  MatchVal:=0.0; ExclLNo:=0;

    SingNT:=Syss.AutoValStk; {and (Some other switch)  {* Could be connected to a SS switch *}
    {Also reinstate the call to Reset_NomTxfr lines in Post_Batch if a SS switch used }

    If (Not Syss.AutoValStk) then {* Set NInv so B2B still has a folio no to work from *}
      NInv:=BInv;

    PostJobObj:=PostOPtr;

    With MTExLocal^ do
    Begin

      If (Not GotHed) or (SingNT) then  {* Generate Nom Txfr Header *}
      Begin
        {Modes... 1 = One Nom for all posted ADJ's
                  6 = One Nom per ADJ
        }

        If (Not ADJPartPosted(BInv,LInv,Fnum,Keypath)) then
        Begin

          If (TranOk2Run) then
          Begin
            LStatus:=LCtrl_BTrans(1);

            TTEnabled:=LStatusOk;

            {* Wait until All clear b4 continuing *}
            If (TTEnabled) then
              WaitForHistLock;

          end;

          Create_NTHedInv(Abort,GotHed,'',1+(5*Ord(SingNT)),BInv,MTExLocal);

          If (TTEnabled) and (Syss.ProtectPost) then
          With MTExLocal^ do
          Begin
            UnLockHistLock;

            LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

            LReport_BError(InvF,LStatus);
          end;
        end
        else
          GotHed:=BOn;

        NInv:=LInv;

      end;

      If (BInv.DelTerms<>'') then
      Begin
        LastInv:=BInv;
      end
      else
        LastInv:=LInv;

      KeyChk:=FullNomKey(Binv.FolioNum);

      KeyS:=FullIdKey(BInv.FolioNum,StkLineNo);

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LId do
      Begin

        IsWORBuildLine:=BOff;

        IsRetLine:=BOff;


        If (TranOk2Run) then
        Begin
          LStatus:=LCtrl_BTrans(1);

          TTEnabled:=LStatusOk;

          {* Wait until All clear b4 continuing *}
          If (TTEnabled) then
            WaitForHistLock;

        end;

        LStatus:=LGetPos(Fnum,RecAddr);

        Stock_PostCtrl(LId,0,BOff);

        TmpStk:=LStock;


        If (B2BLink=0) or (B2BLink=FolioRef) then {* It has not already been posted *}
        Begin
          {* Removed v4.31 so BOM hidden lines affect valuation instead *}
          {If ((GotHed) and (Syss.AutoValStk) and (LineNo<>StkLineNo)) and (B2BLink=0) then {* Generate Nom Txfr Valuation, exclude BOM Lines *}

          {* exclude built BOM Lines *}
{$IFDEF EXSQL}
          LGetPos(Fnum, ExclLNo);
          If ((GotHed) and (Syss.AutoValStk) and ((KitLink<>1) or (B2BLineNo=1) or ((LStock.StockType<>StkBillCode)))
             and (B2BLink=0) and ((LineNo<>StkLineNo) or (SOPLineNo<>0)))
             {$IFDEF SOP}and not IsExcluded(ExclLNo){$ENDIF} then
{$ELSE}
          If ((GotHed) and (Syss.AutoValStk) and ((KitLink<>1) or (B2BLineNo=1) or ((LStock.StockType<>StkBillCode)))
           and (B2BLink=0) and ((LineNo<>StkLineNo) or (SOPLineNo<>0))) and ((ABSLineNo<>ExclLNo) or (ExclLNo=0)) then
{$ENDIF}
          Begin


            LInv:=NInv;

            {$IFDEF SOP}
              LStock_LocNSubst(LStock,MLocStk);
            {$ENDIF}

            RCCDep:=CCDep;


            If (LineNo=StkLineNo) then
            Begin
              If (GotBOMLine(FolioRef,SOPLineNo,Fnum,Keypath,BOMLine)) then
              Begin
                WOFFNom:=BOMLine.NomCode;

                RCCDep:=BOMLine.CCDep;

                {$IFDEF CU} {*EL v6.01 Custom CC/Dep Overide Hook  *}

                NewObject:=BOff;
                {$B-}
                {* If we are posting seperate lines, then provide opportunity to override CC/Dep for hidden component lines *}
                If (Syss.SepRunPost) and (owHLineCCDep) then
                {$B+}
                Begin
                  Try
                    TmpFolioNo := MTExLocal^.LID.FolioRef;
                    MTExLocal^.LID.FolioRef := MTExLocal^.LInv.FolioNum;
                    LBuildHookEvent(4000,100,MTExLocal^);
                  Finally
                    MTExLocal^.LID.FolioRef := TmpFolioNo;
                  End; // Try..Finally

                  If  ((LId.CCDep[BOff]<>'') and (LId.CCDep[BOn]<>'')) then
                    RCCDep:=LId.CCDep;
                end;

              {$ENDIF}

              end
              else
              Begin
                WOFFNom:=LStock.NomCodeS[3];

              end;

              If (NomCode=0) then
              Begin
                If (LStock.StockType=StkBillCode) then
                  SBSNom:=LStock.NomCodeS[5]
                else
                  SBSNom:=LStock.NomCodeS[4];
              end
              else
                SBSNom:=NomCode;

            end
            else
            Begin
              WOFFNom:=NomCode;
              SBSNom:=LStock.NomCodes[4];

              {$B-} {Check if adj line came from a WOR}
              If ((SOPLink<>0) and (LStock.StockType=StkBillCode)) {We need to go and get BOM line for bom within bom processing}
                and (GotBOMLine(SOPLink,SOPLineNo,Fnum,Keypath,BOMLine)) and (BOMLine.IdDocHed=WOR) and (BOMLine.LineNo=1) then
              {$B+}
              Begin
                SBSNom:=NomCode;

                WOFFNom:=LStock.NomCodes[5];

                IsWORBuildLine:=BOn;

              end
              else
              Begin
                IsWORBuildLine:=BOff;

                {$B-} {Check if adj line came from a WOR}
                If ((SOPLink<>0) and (GotBOMLine(SOPLink,SOPLineNo,Fnum,Keypath,BOMLine)) and (BOMLine.IdDocHed In StkRetSplit)) then
                {$B+}
                Begin
                  If (LStock.StockType=StkBillCode) then
                    SBSNom:=LStock.NomCodes[5] {Adjust PRN between fin goods or stock value and purch ret stock}
                  else
                    SBSNom:=LStock.NomCodes[4];

                  IsRetLine:=BOn;
                end
                else
                  IsRetLine:=BOff;

              end;


            end;


            If (WOFFNom=0) then
              WOFFNom:=LStock.NomCodes[3];

            If (LStock.StockType=StkBillCode) and ((KitLink<>1) or (B2BLineNo=1)) and (LineNo<>StkLineNo) then {* Its a build so reverse effect *}
            Begin
              DedCnst:=-1;

              If (IdDocHed=ADJ) and (KitLink<>1) and (Not IsWORBuildLine) and (Not IsRetLine) then {* Its not a build so do not affect B/S value *}
              Begin

                  {$B-}                             {For Loc txfr, force fin goods g/l code to be used}
                  If (BOMLine.IdDocHed=WOR) or ((BInv.DelTerms<>'') and (Qty<0) and (MLocStk<>BInv.DelTerms))

                  {$IFDEF JC} or ((JBCostOn) and (Assigned(PostJobObj)) and (WOFFNom=PostJobObj^.LJob_WIPNom(0,JobCode,AnalCode,StockCode,MLocStk,CustCode))) {$ENDIF} then
                  {$B+}

                  Begin
                    SBSNOM:=LStock.NomCodes[5];
                    DedCnst:=1;
                  end
                  else

                If (WOffNom<>LStock.NomCodes[3]) then  {* If it is not already set to Write Off *}
                Begin
                  SBSNom:=LStock.NomCodes[3];
                end
                else                                   {* It must be coming from a stock take *}
                Begin
                  SBSNom:=LStock.NomCodes[5];
                  DedCnst:=1;
                end;
              end;
            end
            else
              DedCnst:=1;

            LineCost:=Round_Up((Qty*QtyMul)*CostPrice*DedCnst,Syss.NoCosDec);

            OCCDep:=RCCDep;

            {$IFDEF SOP} {V5.00. If Out line within a location transfer then, make the movement a journal between the two b/s items}
               If (BInv.DelTerms<>'') and (Qty<0) and (MLocStk<>BInv.DelTerms) then
               Begin
                 TmpStk2:=LStock;
                 LStock:=TmpStk;

                 WOFFNom:=Get_LocTxfrNom(WOffNom,ExclLNo,OCCDep,Fnum,Keypath,KeyS,KeyChk,BInv);
{$IFDEF EXSQL}
                 if (ExclLNo <> 0) then
                   Exclude(ExclLNo);
{$ENDIF}
                 LStock:=TmpStk2;

               end;


            {$ENDIF}

            {If (SBSNom<>WOffNom) or (RCCDep[BOff]<>OCCdep[BOff]) or (RCCDep[BOn]<>OCCDep[BOn]) then {V5.00, only generate an entry between different g/l codes}

            {$IFDEF CU} {v5.61. Allow customisation to override W/Off & Stock val G/L Code }
              If (ADJNomHookEvent) then
              Begin
                CuLoop:=BOff;

                TmpLine:=LId;

                LId:=BOMLine;

                CuInv:=LInv;

                LInv:=BInv;

                Try
                  Repeat
                    {$B-}


                    MTExLocal^.LCtrlInt:=0;

                    If  (LExecuteHookEvent(4000,85+Ord(CuLoop),MTExlocal^)) then
                      CustomNom:=MTExLocal^.LCtrlInt
                    else
                      CustomNom:=0;


                    If (CustomNom>0) and (LGetMainRec(NomF,FullNomKey(CustomNom))) then
                    {$B+}
                    With LNom do
                    Begin

                      If (NomType In [BankNHCode,PLNHCode]) then
                      Begin
                        If (Not CuLoop) then
                          WOffNom:=CustomNom
                        else
                          SBSNom:=CustomNom;
                      end;
                    end;

                    CuLoop:=Not CuLoop;

                  Until (Not CuLoop) or (ThreadRec^.THAbort);

                finally
                  LId:=TmpLine;
                  LInv:=CuInv;

                end; {Try..}
              end;
            {$ENDIF}


            TmpLine:=LId;


            Add_StockValue(SBSNom,WOFFNom,LineCost,MLocStk,BInv.OurRef,RCCDep,OCCDep,Syss.SepRunPost,Abort,MTExLocal);


              {$IFDEF JC}

                  LId:=TmpLine;

                  If (JCHasUplift(LId,UPVal,0,UPNom)) then {Post supplemental uplift cost}
                    Add_StockValue(WOFFNom,UPNom,UPVal,MLocStk,BInv.OurRef,RCCDep,OCCDep,Syss.SepRunPost,Abort,MTExLocal);

              {$ENDIF}


          end
          else
            ExclLNo:=0;

          LSetDataRecOfs(Fnum,RecAddr);

          LStatus:=LGetDirect(Fnum,KeyPath,0);

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyI,KeyPath,Fnum,BOn,Locked);

          If (LOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            B2BLink:=NInv.FolioNum;

            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_BError(Fnum,LStatus);


            If (Not AbortTran) then
              AbortTran:=(Not LStatusOk) and (TTEnabled);

            LStatus:=LUnLockMLock(Fnum);

          end;



        end;

        LStock:=TmpStk;

        If (TTEnabled) and (Syss.ProtectPost) then
        With MTExLocal^ do
        Begin
          UnLockHistLock;

          LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

          LReport_BError(InvF,LStatus);
        end;


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);


      end; {While..}
    end; {With..}


    If (Syss.AutoValStk) and (GotHed) and (SingNT) then
    Begin

      Reset_NomTxfrLines(NInv,MTExLocal);

      With NInv do
      Begin
        RemitNo:=BInv.OurRef;

        MTExLocal^.LMatch_Payment(NInv,BInv.TotalCost,BInv.TotalCost,23);
        RemitNo:='';
      end;
    end;
  end; {Proc..}


{$ENDIF}




{$IFDEF JC}

 { =========== Procedure to Scan Adjustment Documents and Adjust posted stock ========= }

 Procedure TEntPost.Post_BatchJobDetails(BInv          :  InvRec;
                                         PostOPtr      :  Pointer);


 Const
    Fnum     =  IDetailF;

    KeyPath  =  IdFolioK;



  Var
    KeyS,
    KeyChk   :  Str255;

    RecAddr  :  LongInt;

    PostJobObj
             :  ^TPostJobObj;


  Begin
    PostJobObj:=PostOPtr;

    With MTExLocal^ do
    Begin

      RecAddr:=0;

      KeyChk:=FullNomKey(Binv.FolioNum);

      KeyS:=FullIdKey(BInv.FolioNum,1);

      Status:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LId do
      Begin


        If (Not EmptyKey(JobCode,JobCodeLen)) and (DetLTotal(LId,BOn,BOff,0.0)<>0) and (Assigned(PostJobObj)) then
        Begin

          LStatus:=LGetPos(Fnum,RecAddr);

          PostJobObj^.LUpdate_JobAct(LId,BInv);

          LSetDataRecOfs(Fnum,RecAddr);

          LStatus:=LGetDirect(Fnum,KeyPath,0);

        end;


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);


      end; {While..}
    end; {With..}
  end; {Proc..}


  { == Function to detect and return value of Uplift == }

  Function TEntPost.JCHasUplift(IdR      :  IDetail;
                            Var UpValue  :  Double;
                                UCr      :  Byte;  {Currency Uplift required in, own or 0}
                            Var UpGL     :  LongInt)  :  Boolean;

  Const
    Fnum      =  JDetlF;
    Keypath   =  JDLookK;

  Var
    UOR      :  Byte;

    TmpKPath,
    TmpStat  :   Integer;

    TmpRecAddr
             :  LongInt;

    TJD{,
    UJD}     :  JobDetlRec;

    KeyChk   :  Str255;

  Begin
    Result:=BOff; UpValue:=0.0;  UpGL:=0;  UOR:=0;

    With MTExLocal^ do
    Begin
      TJD:=LJobDetl^;

      With IdR do
        If (Not EmptyKey(JobCode,JobKeyLen)) then
        Begin
          TmpKPath:=GetPosKey;

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDLookKey(FolioRef,ABSLineNo);

          LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

          {UJD:=LJobDetl^; For debug purposes}
          {$B-}
          Result:= (LStatusOk) and (LJobDetl^.JobActual.UpliftTotal<>0.0);  {* We have uplift present, so generate entry *}

          If (Result) then
          With LJobDetl^.JobActual do
          Begin
            If (UCr=Currency) then
              UpValue:=Round_Up(Qty*UpliftTotal,2)
            else
            Begin
              UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

              UpValue:=Round_Up(Qty*Conv_TCurr(UpliftTotal,XRate(CXrate,BOff,Currency),Currency,UOR,BOff),2);

            end;

            UpValue:=UpValue*DocCnst[IdDocHed]; {* v5.70 Account for credit notes *}

            If (UPLiftGL<>0) then
              UpGL:=UPLiftGL
            else
              UpGL:=NomCode;
          end;

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        end; {With..}
      LJobDetl^:=TJD;
    end;{With..}

  end;

  { == Procedure to post supplemental uplift costs to WIP or COS == }

  Procedure TEntPost.PostJCUplift(Fnum2,
                                  Keypath2  :  Integer;
                                  PRunNo    :  LongInt);



  Var
    UOR      :  Byte;
    RecAddr  :  LongInt;
    KeyS     :  Str255;

    CTot,
    PostTot  :  Double;

    AutoLZ,
    LOk,
    AltNC    :  Boolean;

    UPNC,
    BSNC     :  LongInt;

    HistCr   :  Byte;

    KeyChk   :  Str255;

    IdR      :  IDetail;

  Begin
    BSNC:=0;
    UOR:=0;

    PostTot:=0.0;

    With MTExLocal^ do
    Begin
      IdR:=LId;

      If (IdR.JobCode<>LJobRec^.JobCode) then
        LOK:=LGetMainRec(JobF,IdR.JobCode)
      else
        LOK:=BOn;


      With IdR do
      {$B-}       {* Apply for WIP based jobs only *}
        If (LOK) and (LJobRec^.JobStat<JobCompl) and (JCHasUplift(IdR,CTot,Currency,UPNC)) then
      {$B+}
        Begin
          {* Preserve current position &}

          LStatus:=LGetPos(Fnum2,RecAddr);

          AutoLZ:=(Currency<>0);

          AltNC:=BOn;

          HistCr:=Currency;

          Repeat

            Repeat              {* For each entry on MC, two run ctrl lines are generated
                                in line with normal Run Ctrl lines. This is due primeraly
                                to Debtors which needs a seperate level 0 as it is not a straight
                                coversion when variance is involved. The same approach is used here
                                to ensure reports will process these lines in the same way *}

              If (AltNC) then
                BSNC:=NomCode
              else
                BSNC:=UPNC;

              If (BSNC=0) then
                BSNC:=NomCode;

              If (Currency<>HistCr) and (HistCr=0) then
              Begin
                UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                PostTot:=Conv_TCurr(CTot,XRate(CXrate,BOff,Currency),Currency,UOR,BOff);

              end
              else
              Begin
                PostTot:=CTot;

              end;


              If (CTot<>0.0) then
                Post_To_RunCtrl(BSNC,JCUpliftARunNo+(PRunNo*DocNotCnst),0,HistCr,PYr,PPr,CXRate,
                               PostTot,Syss.SepRunPost,BOn,CCDep,LInv);

              CTot:=CTot*DocNotCnst;

              AltNC:=Not AltNC;

            Until (AltNC);

            HistCr:=0;

            AutoLZ:=Not AutoLZ;

          Until (AutoLZ);

          LSetDataRecOfs(Fnum2,RecAddr);

          LStatus:=LGetDirect(Fnum2,KeyPath2,0);

        end;
    end; {With..}
  end; {Proc..}

{$ENDIF}

 { =========== Procedure to Scan Batch Documents and add to DayBook ========= }

 Procedure TEntPost.Post_BatchDetails(BInv          :  InvRec;
                                      TTEnabled     :  Boolean;
                                      PostOPtr      :  Pointer);


 Const
    Fnum     =  InvF;

    KeyPath  =  InvBatchK;



  Var
    KeyS,
    KeyChk   :  Str255;

    LOk,
    Locked
             :  Boolean;


  Begin

    With MTExLocal^ do
    Begin

      KeyChk:=BInv.OurRef;

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
      With LInv do
      Begin
        {Application.ProcessMessages;}


        If (RunNo=BatchRunNo) then {* Ok to process otherwise its been through an unpost *}
        Begin
          //PR: 22/07/2014 ABSEXCH-15288 We need to lock the record inside the transaction - if we lock it here, then
          //                             under P-SQL v11 it doesn't get unlocked.

          //Do we want a transaction - if so try to start one
          If (TranOk2Run) then
          Begin
            LStatus:=LCtrl_BTrans(1);

            TTEnabled:=LStatusOk;

            {* Wait until All clear b4 continuing *}
            If (TTEnabled) then
              WaitForHistLock;

          end;

          if TTEnabled or not TranOk2Run then //TTEnabled = transaction ok; not TranOk2Run = don't want transaction
          begin

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);


            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              RunNo:=0;

              NomAuto:=BOn;


              If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) and
                 (InvDocHed In DirectSet) then  {* Cash Accounting set VATdate to Current VATPeriod for Directs only *}
              Begin

                // VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                VATPostDate:=CalcVATDate(TransDate);  {v5.71. CA Allows jump to future period, set from period of self}

                UntilDate:=Today;

              end;

              Set_DocAlcStat(LInv);

              LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              If (Not AbortTran) and (TTEnabled) then
                AbortTran:=(Not LStatusOk);


              LStatus:=LUnLockMLock(Fnum);

              {* Add to Cust balance *}

              {* v4.23p -only update balances here if not protected mode posting, otherwise too many locks occur *}
              If (Not Syss.UpBalOnPost) and (LStatusOk) and (Not TTEnabled) then {* Update now *}
                LUpdateBal(LInv,BaseTotalOS(LInv),
                              (ConvCurrICost(LINV,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                              (ConvCurrINet(LINV,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                              BOff,2);

              {$IFDEF JC}
                {* Only update job actuals here if not protected mode posting *}
                If (JBCostOn) and (Not TTEnabled) then
                  Post_BatchJobDetails(LInv,PostOPtr);

              {$ENDIF}

            end; {If Locked Ok..}

            If (TTEnabled) and (Syss.ProtectPost) then
            With MTExLocal^ do
            Begin
              UnLockHistLock;

              LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

              LReport_BError(InvF,LStatus);
            end;

          end; // TTEnabled or not TranOk2Run
        end; // If (RunNo=BatchRunNo)

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}
    end; {With..}
  end; {Proc..}



 { =========== Procedure to Scan Batch Documents and Adjust account balance ========= }

 Procedure TEntPost.Post_BatchBal(BInv          :  InvRec;
                              Var TTEnabled     :  Boolean;
                                  PostOPtr      :  Pointer);


 Const
    Fnum     =  InvF;

    KeyPath  =  InvBatchK;



  Var
    KeyS,
    KeyChk   :  Str255;

    LOk,
    Locked   :  Boolean;



  Begin
    Try
      
      With MTExLocal^ do
      Begin

        KeyChk:=BInv.OurRef;

        KeyS:=KeyChk;

        {$IFDEF EXSQL}
        if (SQLUtils.UsingSQL) then
          SQLUtils.DiscardCachedData('DOCUMENT.DAT', ExClientID);
        {$ENDIF}

        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not AbortTran) do
        With LInv do
        Begin
          {Application.ProcessMessages;}


          If (RunNo=0) then {* Ok to process otherwise it has not posted yet*}
          Begin

            If (TranOk2Run) then
            Begin
              LStatus:=LCtrl_BTrans(1);

              TTEnabled:=LStatusOk;

              {* Wait until All clear b4 continuing *}
              If (TTEnabled) then
                WaitForHistLock;

            end;


              {* Add to Cust balance *}
              If (Not Syss.UpBalOnPost) then
                LUpdateBal(LInv,BaseTotalOS(LInv),
                            (ConvCurrICost(LINV,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                            (ConvCurrINet(LINV,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                            BOff,2);

              {$IFDEF JC}

                {* Only update job actuals here if protected mode posting *}
                If (JBCostOn) then
                  Post_BatchJobDetails(LInv,PostOPtr);

              {$ENDIF}

            If (TTEnabled)  then
            With MTExLocal^ do
            Begin
              UnLockHistLock;

              LStatus:=LCtrl_BTrans(0);

              LReport_BError(InvF,LStatus);

            end;


          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        end; {While..}
      end; {With..}
    Finally

    end; {Try..}

  end; {Proc..}



 {============ Procedure to Scan Daybooks and Explode all Batches, adding contents to Daybooks ========= }


  Procedure TEntPost.Post_ItBatch(PostSet       :  DocSetType;
                              Var PostingCount  :  LongInt);

  Const
    Fnum    =  InvF;
    KeyPath =  InvRnoK;


  Var
    DocKey   :  Str255;

    PRunNo,
    AutoAddr :  LongInt;

    B_Func   :  Integer;

    NInv     :  InvRec;

    TTEnabled,
    LOk,Locked,
    AutoRecover,
    IncludeRec,
    WasPosted,
    GotHed   :  Boolean;

    MsgForm  :  TForm;

    {$IFDEF JC}
      PostJobObj  :  ^TPostJobObj;
    {$ELSE}
      PostJobObj  :  Pointer;
    {$ENDIF}



  Begin
    {$IFDEF JC}
      If (JBCostOn) then {* Create obj to give access to Job_UpdateActual..}
        New(PostJobObj,Create(Self.fMyOwner))
      else
        PostJobObj:=nil;
    {$ELSE}

      PostJobObj:=nil;

    {$ENDIF}


    Try
      {$IFDEF JC}
        If (Assigned(PostJobObj)) then
          PostJobObj^.MTExLocal:=Self.MTExLocal;

      {$ENDIF}


      B_Func:=B_GetNext;

      Addch:=ResetKey;  AutoRecover:=BOff;

      Fillchar(DocKey,Sizeof(DocKey),0);

      PostingCount:=0;  TTEnabled:=BOff;

      LastFolio:=0;  PRunNo:=0;

      GotHed:=Not Syss.AutoValStk;

      With MTExLocal^ do
      Begin
        ShowStatus(2,'Please Wait. Processing Batch Items and Adjustments.');



        DocKey:=FullDayBkKey(0,FirstAddrD,'')+NdxWeight;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,DocKey);

        While (LStatusOk) and (LInv.RunNo=0) and (Not ThreadRec^.THAbort) do
        With LInv do
        Begin

          {Application.ProcessMessages;}

          Inc(PostingCount);

          If (LastFolio<FolioNum) then {* Keep track of last invoice and do not go beyond it *}
            LastFolio:=FolioNum;

          {$B-}

          {$IFDEF V430_and_before }

            If (CheckHold(InvDocHed,HoldFlg,PostSet))
              and (InvDocHed In PostSet)
              and (InvDocHed In BatchSet+StkAdjSplit)
              and ((InvDocHed In PostRepCtrl^.IncDocFilt) or (PostRepCtrl^.NoIDCheck))
              and (((Pr2Fig(AcYr,AcPr)<=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Not Syss.PrevPrOff))
                    or ((Pr2Fig(AcYr,AcPr)=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Syss.PrevPrOff)))
               and (TransDate<=Today) then
          {$ELSE}

            IncludeRec:=BOff;

            If (Include_Transaction(PostSet,AutoRecover,PRunNo,BOn)) then
            Begin
              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOff,Locked);

              IncludeRec:=(LOK) and (Locked);
            end;

            If IncludeRec then

          {$ENDIF}

          {$B+}

          Begin
            WasPosted:=BOff;

            LStatus:=LGetPos(Fnum,AutoAddr);

            If (LStatusOk) then
            Begin

              Case InvDocHed of

                SBT,
                PBT  :  Post_BatchDetails(LInv,TTEnabled,PostJobObj);

                {$IFDEF STK}

                  ADJ  :  Post_AdjDetails(LInv,GotHed,NInv,PostJobObj);

                {$ENDIF}

              end; {Case..}

              LSetDataRecOfs(Fnum,AutoAddr);

              LStatus:=LGetDirect(Fnum,KeyPath,0);

              If (TranOk2Run) then
              Begin
                LStatus:=LCtrl_BTrans(1);

                TTEnabled:=LStatusOk;

                {* Wait until All clear b4 continuing *}
                If (TTEnabled) then
                  WaitForHistLock;

              end;


              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOn,Locked);

              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum);

                Case InvDocHed of

                  SBT,
                  PBT  :  Begin
                            WasPosted:=(RunNo=BatchPostRunNo);

                            RunNo:=BatchPostRunNo;
                          end;

                  ADJ  :  Begin
                            RunNo:=StkAdjRunNo;

                            If (NInv.OurRef<>'') then
                              RemitNo:=NInv.OurRef;
                          end;

                end; {Case..}


                LStatus:=LPut_Rec(Fnum,Keypath);

                LReport_BError(Fnum,LStatus);

                If (Not AbortTran) then
                  AbortTran:=(Not LStatusOk) and (TTEnabled);

                LStatus:=LUnLockMLock(Fnum);


                If (TTEnabled) and (Syss.ProtectPost) then
                With MTExLocal^ do
                Begin
                  UnLockHistLock;

                  LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                  LReport_BError(InvF,LStatus);

                  If (Not AbortTran) and (InvDocHed In BatchSet) and (Not WasPosted) then  {* Adjust account balances here as otherwise we run out of locks *}
                  Begin
                    Post_BatchBal(LInv,TTEnabled,PostJobObj);

                    LSetDataRecOfs(Fnum,AutoAddr);

                    LStatus:=LGetDirect(Fnum,KeyPath,0);

                  end;
                end;

                B_Func:=B_GetGEq;

                Dec(PostingCount);

              end;
            end; {If Address found ok..}
          end {If Document ready to post..}
          else
            B_Func:=B_GetNext;



          LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,DocKey);

        end; {While..}


        {$IFDEF DONOTUSESTK}
          Removed as now done individually, needs to be reinstaed
                                  if a seperate ss switch ever intriduced to control sep NOMs

          //If (Syss.AutoValStk)  then
          //  Reset_NomTxfrLines(NInv,MTExLocal);

        {$ENDIF}


        {MsgForm.Free;}

      end;{With..}

    finally

       {$IFDEF JC}
         If (Assigned(PostJobObj)) then
           Dispose(PostJobObj,Destroy);

       {$ENDIF}
    end; {Try..}
  end; {Proc..}


 { ======== Function to Match CC/Dep sensitive lines ======== }

 Function TEntPost.CCDepMatch(LinkCCDep :  Boolean;
                              RCCDep    :  CCDepType)  :  Boolean;


 Var
   TmpBo   :  Boolean;


 Begin

   TmpBo:=(Not LinkCCDep) or (Not Syss.UseCCDep);

   If (LinkCCDep) and (Syss.UseCCDep) then
   With MTExLocal^,LId do
     TmpBo:=((CheckKey(RCCDep[BOff],CCDep[BOff],Length(RCCDep[BOff]),BOff))
           and (CheckKey(RCCDep[BOn],CCDep[BOn],Length(RCCDep[BOn]),BOff)));


   CCDepMatch:=TmpBo;

 end; {Func..}




 { ============= Procedure to Add a Run Time Detail Line ============ }


 Procedure TEntPost.Add_CtrlDetail(CtrlCode,RNo  :  Longint;
                                   PCr,PPYr,PPPr :  Byte;
                                   CRates        :  CurrTypes;
                                   RCCDep        :  CCDepType;
                                   Fnum,NPath    :  Integer);


 Begin
   With MTExLocal^ do
   Begin
     LResetRec(Fnum);
     With LId do
     Begin
       PostedRun:=Rno;
       NomCode:=CtrlCode;
       Currency:=PCr;
       PYr:=PPYr;
       PPr:=PPPr;
       Qty:=1;
       IDDocHed:=RUN;
       CXRate:=CRAtes;

       CCDep:=RCCDep;

       If (PCr=0) then  {** Set to Zero Level Currency **}
         CXRate:=SyssCurr.Currencies[PCr].CRates;

       If (CXRate[BOff]=0) then             {* If Still 0 set to system Rate *}
         CXRate[BOff]:=SyssCurr.Currencies[Currency].CRates[BOff];

       SetTriRec(Currency,UseORate,CurrTriR);


       Payment:=DocPayType[IDDocHed];


       {Pre v5.61}
       {Reconcile:=ReconC; {* Auto Clear *}

       {If (Reconcile=ReconC) then
         ReconDate:=Today
       else
         ReconDate:=MaxUntilDate;}

       {v5.61. Do not autoclear generated lines from SV routine}

       If (Not fFromSV) then
         Reconcile:=ReconC; {* Auto Clear *}

       ReconDate:=Today;


       LStatus:=LAdd_Rec(Fnum,Npath);

       LReport_BError(Fnum,LStatus);

       Inc(ItemCtrlCount);

       If (Not AbortTran) then
         AbortTran:=(Not LStatusOk) and (TranOk2Run);

     end; {With..}
   end; {With..}
 end; {Proc..}




 { =============== Procedure to Crerate Control Code Posting Record =============== }

 Procedure TEntPost.Post_To_RunCtrl(CtrlCode,RunNo  :  Longint;
                                    PNm,PCr,PYr,PPr :  Byte;
                                    CXRate          :  CurrTypes;
                                    Amount          :  Real;
                                    MultiLine       :  Boolean;
                                    LinkCCDep       :  Boolean;
                                    RCCDep          :  CCDepType;
                                    InvR            :  InvRec;
                                    ReverseCharge   :  Boolean);

 Const
   Fnum  =  IDetailF;
   NPath =  IdNomK;

   BaseMultiLineMsg =  'Posting Run Control';


 Var
   NKey,
   SKey,
   NChkKey
         :  Str255;

   LOk,
   Locked,
   FoundCtrl
         :  Boolean;

   B_FuncN,
   B_FuncG
         :  SmallInt;


   CrDr  :  DrCrType;

   {$IFDEF SOP}
     OrdLine  :  IDetail;

   {$ENDIF}

   MultiLineMsg: string;

 Begin

   {MultiLine:=(MultiLine and (Pcr=0));  { ******* Multiple Control Lines Only Apply to level 0 ******** }

   if ReverseCharge then
    MultiLineMsg := ' - RC ' + BaseMultiLineMsg
   else
     MultiLineMsg := ' - ' + BaseMultiLineMsg;

   FoundCtrl:=BOff;

   If (Amount<>0) then
   With MTExLocal^ do
   Begin

     If (Not MultiLine) then
     Begin
       If (RunNo>=0) then
       Begin
         B_FuncG:=B_GetGEq;
         B_FuncN:=B_GetNext;
       end
       else
       Begin
         B_FuncG:=B_GetLessEq;
         B_FuncN:=B_GetPrev;
       end;

       Blank(NKey,Sizeof(NKey));

       NKey:=FullIdPostKey(CtrlCode,RunNo,PNm,PCr,PYr,PPr);

       NChkKey:=NKey;

       LStatus:=LFind_Rec(B_FuncG,Fnum,NPath,NKey);

       {* Re-establish Compare Str, as trailing '0's Stripped *}

       Blank(SKey,Sizeof(SKey));

       SKey:=NKey;

       NKey:=FullIdPostKey(LId.NomCode,LId.PostedRun,LId.NomMode,LId.Currency,LId.PYr,LId.PPr);

       {* Search for true Run-time Control Line *}

       While (LStatusOk) and (CheckKey(NChkKey,NKey,Length(NChkKey),BOn))
             and ((Not CCDepMatch(LinkCCDep,RCCDep)) or (LId.IdDocHed<>RUN)) do
       Begin
         {Application.ProcessMessages;}

         LStatus:=LFind_Rec(B_FuncN,Fnum,NPath,SKey);

         {* Re-establish Compare Str, as trailing '0's Stripped *}

         NKey:=FullIdPostKey(LId.NomCode,LId.PostedRun,LId.NomMode,LId.Currency,LId.PYr,LId.PPr);

       end; {While..}

       FoundCtrl:=((LStatusOk) and (LId.IdDocHed=RUN) and (CheckKey(NChkKey,NKey,Length(NChkKey),BOn))
                  and (CCDepMatch(LinkCCDep,RCCDep)));

       {$IFDEF SOP}
          Blank(OrDLine,Sizeof(OrdLine));

       {$ENDIF}
     end
     else
     Begin
       {$IFDEF SOP}
         If (RunNo=CommitOrdRunNo) then
           OrdLine:=LId;

       {$ENDIF}

     end;


     If (Not FoundCtrl) or (MultiLine) then
       Add_CtrlDetail(CtrlCode,RunNo,PCr,PYr,PPr,CXRate,RCCDep,Fnum,NPath);


     Blank(NKey,Sizeof(NKey));

     NKey:=FullIdPostKey(CtrlCode,RunNo,PNm,PCr,PYr,PPr);

     Locked:=BOff;

     LOk:=LGetMultiRec(B_GetDirect,B_MultLock,NKey,NPath,Fnum,BOn,Locked);

     If (LOk) and (Locked) then
     With LId do
     Begin
       LGetRecAddr(Fnum);

       ShowDrCr(Round_Up(Amount,2),CrDr);

       NetValue:=NetValue+CrDr[BOff];   { Debits..}
       Discount:=Discount+CrDr[BOn];    { Credits..}

       If (MultiLine) then
       Begin
         If (RunNo>=0) then
           Desc:=InvR.OurRef+MultiLineMsg
         else
           Desc:=InvR.OurRef;

         {$IFDEF SOP}
           If (RunNo=CommitOrdRunNo) then {* Set up a link to the original line *}
           Begin
             SOPLink:=InvR.FolioNum;
             SOPLineNo:=OrdLine.AbsLineNo;
             Desc:=Desc+', '+Trim(OrdLine.StockCode)+':'+Form_Real(Qty_OS(OrdLine),0,Syss.NoQtyDec)+'. Commitment as at '+PoutDate(Today);
           end;

         {$ENDIF}

         DocPRef:=InvR.OurRef;
       end
       else
       Begin
         {$IFDEF SOP}
           If (RunNo=CommitOrdRunNo) then {* Set up a suitable description *}
           Begin
             Desc:='Commitment Posting Control as at '+PoutDate(Today);
           end;

         {$ENDIF}


       end;

       LStatus:=LPut_Rec(Fnum,Npath);

       LReport_Berror(Fnum,LStatus);

       If (Not AbortTran) then
         AbortTran:=(Not LStatusOk) and (TranOk2Run);

       LStatus:=LUnLockMLock(Fnum);

     end
     else
       If (Not LOk) then
         LStatus:=4
       else
         LStatus:=84;

     LReport_BError(Fnum,LStatus);
   end;
 end; {Proc..}


 {$IFDEF STK}

   { ========== Proc to Generate auto Cost of Sales Run time Ctrl lines ========= }


   Procedure TEntPost.Stock_GenAVal(IdR      :  IDetail;
                                    Fnum,
                                    Keypath  :  Integer;
                                    PRunNo,
                                    BOMCOSGL :  LongInt);

   Const
     Fnum2    =  StockF;
     Keypath2 =  StkCodeK;


   Var
     UOR      :  Byte;
     RecAddr  :  LongInt;
     KeyS     :  Str255;

     CTot,
     PostTot  :  Real;

     LOk,
     Locked,
     AutoLZ,
     AltNC    :  Boolean;

     COSNC,
     StkNC,
     BSNC,
     SafeNC   :  LongInt;

     HistCr   :  Byte;
     COSRate,
     POSRate  : CurrTypes;

     {$IFDEF CU}
       {LocalExLocal
              : ^TdExLocal;}
     {$ENDIF}


   Begin

     BSNC:=0;
     COSNC:=0; UOR:=0;  SafeNC:=0;

     PostTot:=0.0;

     {$IFDEF CU}

       {LocalExLocal:=nil;}

     {$ENDIF}

     Blank(COSRate,Sizeof(COSRate));
     Blank(POSRate,Sizeof(POSRate));


     With MTExLocal^,IdR do
     Begin

       If ((Is_FullStkCode(StockCode))
       and (((IdDocHed In SalesSplit)) or ((IdDocHed in PurchSplit) and (CostPrice<>0.0) and (Syss.UseUpliftNC)))) then
       Begin

         POSRate:=CXRate;

         {* Preserve current position &}

         LStatus:=LGetPos(Fnum,RecAddr);

         KeyS:=StockCode;

         COSRate:=LInv.OrigRates;

         If (COSConvRate<>0.0) then
           COSRate[UseCoDayRate]:=COSConvRate
         else
           COSRate[UseCoDayRate]:=0.0;

         {
            Make sure that we are on the correct Stock record.
         }
         LOk := (LStock.StockCode = KeyS);
         If (Not LOk) then
         Begin
           LStatus := LFind_Rec(B_GetEq,Fnum2,Keypath2,KeyS);
           LOk     := LStatusOk;
         end;

         If (LOk) then
         Begin
           {
              Read the Stock Location details (if any).
           }
           {$IFDEF SOP}
             LStock_LocNSubst(LStock,MLocStk);
           {$ENDIF}

           {CTot:=Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*CostPrice,Syss.NoCosDec)*DocCnst[IdDocHed];}

           {* v4.20 - Deduct qty used here instead, as otherwise BOMS which always deduct stock
           also affect stock value as well as the components, which is not correct,
           In the end could not use, as deduct lines meant to have a costptice of 0 *}

           {CTot:=Round_Up(DeductQty*CostPrice,Syss.NoCosDec)*DocCnst[IdDocHed];}

           {*V4.31, had another go by splitting between the lones and hidden lines}

           {
              If this is a Bill of Materials line on a Sales transaction,
              calculate the total cost using the DeductQty, otherwise calculate
              it using the actual Qty.
           }
           If (LStock.StockType=StkBillCode) and (B2BLineNo<>1) and (IdDocHed in SalesSplit) then
             CTot:=Round_Up(DeductQty*Calc_StkCP(CostPrice,QtyMul,UsePack),Syss.NoCosDec)*DocCnst[IdDocHed]
           else
             CTot:=Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*CostPrice,Syss.NoCosDec)*DocCnst[IdDocHed];

           AutoLZ:=(Currency<>0);

           AltNC:=BOn;

           HistCr:=Currency;

           If (LStock.StockType=StkBillCode) then
             BSNC:=LStock.Nomcodes[5]   // Final Goods code
           else
             BSNC:=LStock.Nomcodes[4];  // Balance Sheet Nominal

           If (IdDocHed In SalesSplit) then
           Begin

             If (CustCode<>LCust.CustCode) then
               LGetMainRec(CustF,CustCode);

             {* OverWrite With Cust COS if present *}

             {$B-} {v5.70. Added check for COSNomcode as override for B2B returns where the sales repair needs to reverse out the w/off account }
             If (COSNomCode<>0) and (LGetMainRec(NomF,FullNomKey(COSNomCode))) and (LNom.NomType In [BankNHCode,PLNHCode]) then
             {$B+}
               COSNC:=COSNomCode;

             If (COSNC=0) then
               COSNC:=LCust.DefCOSNom;

             If (COSNC=0) then {* Use BOM Stock COS *}
               COSNC:=BOMCOSGL;

             If (COSNC=0) then {* Use Stock COS *}
               COSNC:=LStock.NomCodes[2];

             If (UseCoDayRate) and (COSConvRate<>0.0) then
             Begin

               POSRate[UseCoDayRate]:=COSConvRate;

             end;
           end
           else {* For purchases we are going betweeen freight NC and Stk or Fin Goods *}
           Begin
             COSNC:=Syss.NomCtrlCodes[FreightNC];

           end;

           { == v4.31.004 Allow hook to substitute a G/L code here.  Additional validation will still take palce and
                any failures will result in the original being used == }

           { == The opening and closing of the event here may well slow down the posting to unacceptable levels
                in which case a more dedicated version would be required which started the event at the beginning of posting == }

           {$IFDEF CU}
             If (COSHookEvent) then
             Begin
               {New(LocalExLocal,Create);

               LocalExLocal^.LId:=MTExLocal^.LId;
               LocalExLocal^.LInv:=MTExLocal^.LInv;}


               If (LExecuteHookEvent(4000,52,MTExlocal^)) then
                 SafeNC:=MTExLocal^.LCtrlInt
               else
                 SafeNC:=0;

               {Dispose(LocalExLocal,Destroy);}

               {$B-}
               If (SafeNC>0) and (LGetMainRec(NomF,FullNomKey(SafeNC))) then
               {$B+}
               With LNom do
               Begin

                 If (NomType In [BankNHCode,PLNHCode]) then
                   COSNC:=SafeNC;
               end;
             end;
           {$ENDIF}



           Repeat

             Repeat              {* For each entry on MC, two run ctrl lines are generated
                                    in line with normal Run Ctrl lines. This is due primeraly
                                    to Debtors which needs a seperate level 0 as it is not a straight
                                    coversion when variance is involved. The same approach is used here
                                    to ensure reports will process these lines in the same way *}


               If (AltNC) then
                 StkNC:=BSNC
               else
                 StkNC:=COSNC;


               If (Currency<>HistCr) and (HistCr=0) then
               Begin
                 {*v4.30 31/12/98 Modified so that the lines exchange rate is used to calculate cos rather than global daily rate *}

                 {UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                 PostTot:=Conv_TCurr(CTot,XRate(CXrate,BOff,Currency),Currency,UOR,BOff);}

                 {Currency_ConvFT(CTot,Currency,HistCr,UseCoDayRate)}

                 {*v4.31 28/10/99 Modified back to use daily rate, as when a cost of sale price
                                  is translated onto an invouce it uses the daily rate, so when it gets
                                  posted it should use the daily rate again otherwise you increase the changes
                                  of a difference.
                                  For eg, see email from LanPro 26/10/1999 Pauline Choo}

                 {PostTot:=Currency_ConvFT(CTot,Currency,HistCr,UseCoDayRate);}

                 {v4.31.003.  Modifed to use original rates as a compromise so that sk hist and recon reports would be able to convert the cost price back*}

                 If (IdDocHed In SalesSplit) then
                 Begin
                   If (COSRate[UseCoDayRate]=0.0) then
                     PostTot:=Currency_ConvFT(CTot,Currency,HistCr,UseCoDayRate)
                   else
                   Begin
                     UOR:=fxUseORate(BOff,BOn,COSRate,UseORate,Currency,0);

                     PostTot:=Conv_TCurr(CTot,XRate(COSRate,BOff,Currency),Currency,UOR,BOff);
                   end;
                 end
                 else
                 Begin
                   UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                   PostTot:=Conv_TCurr(CTot,XRate(CXrate,BOff,Currency),Currency,UOR,BOff);

                 end;

               end
               else
               Begin
                 PostTot:=CTot;

               end;

               try
                 fFromSV:=BOn;

                 If (CTot<>0.0) then
                   Post_To_RunCtrl(StkNC,StkValARunNo+(PRunNo*DocNotCnst),0,HistCr,PYr,PPr,POSRate,
                                  PostTot,Syss.SepRunPost,BOn,CCDep,LInv);
               finally
                 fFromSV:=BOff;
               end; {try..}

               CTot:=CTot*DocNotCnst;

               AltNC:=Not AltNC;

             Until (AltNC);

             HistCr:=0;

             AutoLZ:=Not AutoLZ;

           Until (AutoLZ);

         end; {If Ok..}

         LSetDataRecOfs(Fnum,RecAddr);

         LStatus:=LGetDirect(Fnum,KeyPath,0);

       end; {If Valid Line..}

     end; {With..}

   end; {Proc..}


 {$ENDIF}




 { ================ Recursivley Post to YTD & Future Year to dates ============== }

 Procedure TEntPost.LPost_To_YTDHist(PPurch,PSales,
                                     PCleared       :  Double;
                                     PCr,PYr,PPr    :  Byte);

 Var
   Rnum   :  Double;

 Begin
   Rnum:=0;
   With MTExLocal^,LNom do
   Begin
     LPost_To_Hist(NomType,GLPostKey(NomCode),PPurch,PSales,PCleared,PCr,PYr,PPr,Rnum);

     If (LLast_YTD(NomType,GLPostKey(NomCode),PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
       LPost_To_YTDHist(PPurch,PSales,PCleared,PCr,LNHist.Yr,PPr);
   end; {With..}
 end;


 { =================== Get Balance of Previous Period Line todate to add to this period =============== }

 Function  TEntPost.GetPrevPrBal(NType         :  Char;
                                 NCode         :  Str10;
                                 PCr,PYr,PPr   :  Byte)  :  Double;


 Var
   Purch,Sales,Cleared  :  Double;



 Begin

   AdjPr(PYr,PPr,BOff);

   GetPrevPrBal:=MTExLocal^.LProfit_To_Date(NType,NCode,PCr,PYr,PPr,Purch,Sales,Cleared,BOn);

 end; {Func..}


 Function TEntPost.HistLockOk  :  Boolean;

 Begin
   If (Syss.ProtectPost) and (TranOk2Run) then
   Begin
     Result:=ChkHistLock(255,CHistRAddr);
   end
   else
     Result:=BOn;

 end;


 Procedure TEntPost.UnLockHistLock;

 Begin

   If (CHistRAddr<>0) then
   With MTExLocal^ do
     LStatus:=UnLockMLock(JMiscF,CHistRAddr);

 end;


 Function TEntPost.ChkHistLock(Const LMode  :  Byte;
                               Var   LAddr  :  LongInt)  :  Boolean;

Const
  Fnum     =  JMiscF;
  Keypath  =  JMK;

Var
  KeyS  :  Str255;
  NewRec:  Boolean;

  TmpKPath,
  TmpStat
        :   Integer;

  TmpRecAddr
        :  LongInt;

  TmpJMisc
        :  JobMiscRec;

Begin
  TmpJMisc:=MTExLocal^.LJobMisc^;
  TmpKPath:=GetPosKey;

  With MTExLocal^ do
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

  KeyS:=FullPLockKey(PostUCode,PostLCode,LMode);

  LAddr:=0;

  Result:=BOff;

  With MTExLocal^,LJobMisc^,JobTypeRec do
  Begin

    LStatus:=LFind_Rec(B_GetEq+B_MultNWLock,Fnum,KeyPath,KeyS);

    If (LStatus In [0,4,9]) then {* record found, or not found *}
    Begin
      NewRec:=(LStatus<>0);

      If (NewRec) then
      Begin
        LResetRec(Fnum);
        RecPFix:=PostUCode;
        SubType:=PostLCode;

        JobType:=PartPLockKey(LMode);
        JTNameCode:=EntryRec^.Login;
        JTypeName:=DateTimetoStr(Now);
      end;

      If (NewRec) then
      Begin
        LStatus:=LAdd_Rec(Fnum,Keypath);

        LReport_BError(Fnum,LStatus);

        If (LStatusOk) then
        Begin
          KeyS:=FullPLockKey(PostUCode,PostLCode,LMode);

          LStatus:=LFind_Rec(B_GetEq+B_MultNWLock,Fnum,KeyPath,KeyS);
        end;

      end;


      Result:=LStatusOk;

      If (LStatusOk) then
        LStatus:=LGetPos(Fnum,LAddr);

    end
    else {* We have another error here which needs to be dealt with, best abort the run *}
         {* v4.23p/ however ignore locking messages *}
    If (Not (LStatus In [84,85])) then
    Begin
      LReport_BError(Fnum,LStatus);

      If (Assigned(ThreadRec)) then
        ThreadRec^.THAbort:=BOn;

    end;

  end;

  With MTExLocal^ do
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

  MTExLocal^.LJobMisc^:=TmpJMisc;

end;


Procedure TEntPost.WaitForHistLock;

Begin
  If (Not HistLockOk) then
  Begin
    Send_UpdateList(01);

    While (Not HistLockOk) and (Not Has_Aborted) do
    Begin
      ThreadDelay(100,BOff);

    end;

    Send_UpdateList(00);

  end;

end;

{ == Build key based on commitment value == }

 Function TEntPost.GLPostKey(NomFolio  :  LongInt)  :  Str20;


 Begin
   {$IFDEF SOP}

     If (CommitMode<>0) then
     Begin
       Case CommitMode of
         1,2  :  Result:=CommitGLKey(NomFolio);
       end; {Case..}
     end
     else
       Result:=FullNomKey(NomFolio);

   {$ELSE}
     Result:=FullNomKey(NomFolio);
   {$ENDIF}
 end;




 { ================ Procedure to Access Nominal Chain ============== }

 Procedure TEntPost.LPost_To_Nominal(NCode         :  Str20;
                                     PPurch,PSales,
                                     PCleared
                                                   :  Double;
                                     PCr,PYr,PPr   :  Byte;
                                     Level         :  Longint;
                                     PostYTD,AutoLZ,
                                     PostYTDNCF    :  Boolean;
                                     CXRate        :  CurrTypes;
                                 Var PrevBal       :  Double;
                                 Var ActualNomCode :  LongInt;
                                     UOR           :  Byte);




 Const
   Fnum  =  NomF;
   NPath =  NomCodeK;

   WMess = '** WARNING! - Unable to post to ';
   WMEss2= ', Check Manual **';
   WMEss3= ', Bad Date!';



 Var
   NKey      :  Str255;
   HistCr,n,
   CnvCr     :  Byte;

   CurrLoop  :  Boolean;

   Rate,
   NoPBal    :  Double;

   NType,
   PostNomType
             :  Char;

   TNCode,
   ReturnNCode
             :  LongInt;



 Begin
   Rate:=1;  CurrLoop:=BOn;  NType:=ResetKey;

   ReturnNCode:=0;

   Move(NCode[1],TNCode,Sizeof(TNCode));

   ActualNomCode:=TNCode;


   NoPBal:=0; CnvCr:=0;


   If (PYr<>0) and (PPr<>0) then
   With MTExLocal^ do
   Begin
     NKey:=NCode;

     Repeat
       LStatus:=LFind_Rec(B_GetEq,Fnum,NPath,NKey);

       If (Not LStatusOk) or ((LNom.NomType In [NomHedCode,CarryFlg]) and (Level=1)) then  {** If Code Can't be Found or is a
                                                                                             heading/Carry Fwrd then Post to
                                                                                             Suspenders Account **}
       Begin
         NKey:=FullNomKey(Syss.NomCtrlCodes[UnRCurrVar]);

         LStatus:=04;  {* Force Error *}
       end;


       CurrLoop:=Not CurrLoop;

     Until (LStatusOk) or (CurrLoop);

     CurrLoop:=BOn;

     If (LStatusOK) then
     Begin


       ActualNomCode:=LNom.NomCode;  {* Set Return Code to Actual Nominal Used, this allows unpostable
                                       transactions to be renumbered with the suspense account *}

       HistCr:=PCr;


       {$IFDEF SOP}
         If (CommitMode<>2) then
           PostNomType:=LNom.NomType
         else
           PostNomType:=StkBillCode;  {* Force through as a special type for the temp live commitment value *}

       {$ELSE}
           PostNomType:=LNom.NomType;
       {$ENDIF}

       NType:=PostNomType;

       If (Level=1) then
       Begin

         PostYTD:=(NType In YTDSet);

         PostYTDNCF:=((NType In YTDNCFSet) and (Not PostYTD));

       end;

       {* Post First to Doc Cur Hist, then 0 Currency *}

       Repeat

         If (PPr<>YTD) then
         With LNom do
         Begin
           LPost_To_Hist(PostNomType,GLPostKey(NomCode),
                         Conv_TCurr(PPurch,Rate,CnvCr,UOR,BOff),
                         Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                         Conv_TCurr(PCleared,Rate,CnvCr,UOR,BOff),
                         HistCr,PYr,PPr,PrevBal);

           {*** Add Last Period Balance to this period to give running total **** }
           {03/02/94 Do not B/F P&L accounts if period 1 }

           If (HistCr=0) and ((PPr<>1) or (Not (NomType In ProfitBFSet))) then
             PrevBal:=PrevBal+GetPrevPrBal(PostNomType,GLPostKey(NomCode),HistCr,PYr,PPr);
         end;


         If (LStatusOK) then
         Begin

           If (PostYTD) then
             LPost_To_YTDHist(Conv_TCurr(PPurch,Rate,CnvCr,UOR,BOff),
                             Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                             Conv_TCurr(PCleared,Rate,CnvCr,UOR,BOff),
                             HistCr,PYr,YTD)
           else
             If (PostYTDNCF) then
             With LNom do
               LPost_To_Hist(PostNomType,GLPostKey(NomCode),
                             Conv_TCurr(PPurch,Rate,CnvCr,UOR,BOff),
                             Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                             Conv_TCurr(PCleared,Rate,CnvCr,UOR,BOff),
                             HistCr,PYr,YTDNCF,NoPBal);
         end;


           Rate:=XRate(CXrate,BOff,PCr);

           HistCr:=0; CnvCr:=PCr;


           CurrLoop:=Not CurrLoop;

       Until (CurrLoop) or (PCr=0) or (Not AutoLZ);


       If (LStatusOK) and (LNom.Cat<>0) and ((PPurch<>0) or (PSales<>0)) and (CommitMode<>2) and (CheckActMode=0) then
         LPost_To_Nominal(FullNomKey(LNom.Cat),PPurch,PSales,0,PCr,PYr,PPr,
                         Succ(Level),PostYTD,AutoLZ,PostYTDNCF,CXRate,Rate,ReturnNCode,UOR);

       If (NType In ProfitBFSet) and (Level=1) and (LStatusOk) and (CommitMode<>2) and (CheckActMode=0) then
         LPost_To_Nominal(FullNomKey(Syss.NomCtrlCodes[ProfitBF]),PPurch,PSales,0,PCr,PYr,YTD,
                         Level,PostYTD,AutoLZ,BOff,CXRate,Rate,ReturnNCode,UOR);

     end
     else
     Begin
       ShowPostFailMsg(WMess+FOrm_Int(TNCode,0)+WMess2);
       AbortTran:=BOn;
     end;
   end
   else
   Begin
     ShowPostFailMsg(WMess+Form_Int(TNCode,0)+WMess3);
     AbortTran:=BOn;
   end;
 end; {Proc..}





 {$IFDEF PF_On}

 Function TEntPost.CCPostKey(NomFolio  :  LongInt;
                             LC        :  Str10)  :  Str20;


 Begin
   {$IFDEF SOP}

     If (CommitMode<>0) then
     Begin
       Case CommitMode of
         1,2  :  Result:=CommitGLCCKeyOn(NomFolio,LC);
       end; {Case..}
     end
     else
       Result:=CalcCCKeyHistOn(NomFolio,LC);

   {$ELSE}
     Result:=CalcCCKeyHistOn(NomFolio,LC);
   {$ENDIF}
 end;

   { ================ Recursivley Post to YTD & Future Year to dates ============== }

   Procedure TEntPost.LPost_To_CCYTDHist(PPurch,PSales,
                                         PCleared       :  Double;
                                         PCr,PYr,PPr    :  Byte;
                                         CCode          :  Str10);

   Var
     Rnum   :  Double;

   Begin
     Rnum:=0;
     With MTExLocal^,LNom do
     Begin
       LPost_To_Hist(NomType,CCPostKey(NomCode,CCode),PPurch,PSales,PCleared,PCr,PYr,PPr,Rnum);

       If (LLast_YTD(NomType,CCPostKey(NomCode,CCode),PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
         LPost_To_CCYTDHist(PPurch,PSales,PCleared,PCr,LNHist.Yr,PPr,CCode);
     end; {With..}
   end;




   { ================ Procedure to Access Nominal Chain ============== }

   Procedure TEntPost.LPost_To_CCNominal(NCode         :  Str20;
                                         PPurch,PSales,
                                         PCleared
                                                       :  Double;
                                         PCr,PYr,PPr   :  Byte;
                                         Level         :  Longint;
                                         PostYTD,AutoLZ,
                                         PostYTDNCF    :  Boolean;
                                         CXRate        :  CurrTypes;
                                         CCode         :  Str10;
                                         UOR           :  Byte);



   Const
     Fnum  =  NomF;
     NPath =  NomCodeK;

     WMess = '** WARNING! - Unable to post to ';
     WMEss2= ', Check Manual **';
     WMEss3= ', Bad Date!';



   Var
     NKey      :  Str255;
     HistCr,n,
     CnvCr     :  Byte;

     CurrLoop  :  Boolean;

     PrevBal,
     Rate,
     NoPBal    :  Double;

     NType,
     PostNomType
               :  Char;

     TNCode,
     ReturnNCode
               :  LongInt;



   Begin
     Rate:=1;  CurrLoop:=BOn;  NType:=ResetKey;

     ReturnNCode:=0; CnvCr:=0;

     Move(NCode[1],TNCode,Sizeof(TNCode));

     NoPBal:=0; PrevBal:=0;

     If (PYr<>0) and (PPr<>0) then
     With MTExLocal^ do
     Begin
       NKey:=NCode;

       Repeat
         LStatus:=LFind_Rec(B_GetEq,Fnum,NPath,NKey);

         If (Not LStatusOk) or ((LNom.NomType In [NomHedCode,CarryFlg]) and (Level=1)) then  {** If Code Can't be Found or is a
                                                                                               heading/Carry Fwrd then Post to
                                                                                               Suspenders Account **}
         Begin
           NKey:=FullNomKey(Syss.NomCtrlCodes[UnRCurrVar]);

           LStatus:=04;  {* Force Error *}
         end;


         CurrLoop:=Not CurrLoop;

       Until (LStatusOk) or (CurrLoop);

       CurrLoop:=BOn;

       If (LStatusOK) then
       Begin


         HistCr:=PCr;

         {$IFDEF SOP}
           If (CommitMode<>2) then
             PostNomType:=LNom.NomType
           else
             PostNomType:=StkBillCode;  {* Force through as a special type for the temp live commitment value *}

         {$ELSE}
             PostNomType:=LNom.NomType;
         {$ENDIF}

         NType:=PostNomType;

         If (Level=1) then
         Begin

           PostYTD:=(NType In YTDSet);

           PostYTDNCF:=((NType In YTDNCFSet) and (Not PostYTD));

         end;

         {* Post First to Doc Cur Hist, then 0 Currency *}

         Repeat

           If (PPr<>YTD) then
           With LNom do
           Begin

             LPost_To_Hist(PostNomType,CCPostKey(NomCode,CCode),
                           Conv_TCurr(PPurch,Rate,CnvCr,UOR,BOff),
                           Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                           Conv_TCurr(PCleared,Rate,CnvCr,UOR,BOff),
                           HistCr,PYr,PPr,PrevBal);

           end;


           If (LStatusOK) then
           Begin

             If (PostYTD) then
               LPost_To_CCYTDHist(Conv_TCurr(PPurch,Rate,CnvCr,UOR,BOff),
                               Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                               Conv_TCurr(PCleared,Rate,CnvCr,UOR,BOff),
                               HistCr,PYr,YTD,CCode)
             else
               If (PostYTDNCF) then
               With LNom do
                 LPost_To_Hist(PostNomType,CCPostKey(NomCode,CCode),
                               Conv_TCurr(PPurch,Rate,CnvCr,UOR,BOff),
                               Conv_TCurr(PSales,Rate,CnvCr,UOR,BOff),
                               Conv_TCurr(PCleared,Rate,CnvCr,UOR,BOff),
                               HistCr,PYr,YTDNCF,NoPBal);
           end;

             Rate:=XRate(CXrate,BOff,PCr);

             HistCr:=0; CnvCr:=PCr;


             CurrLoop:=Not CurrLoop;

         Until (CurrLoop) or (PCr=0) or (Not AutoLZ);


         If (LStatusOK) and (LNom.Cat<>0) and ((PPurch<>0) or (PSales<>0)) and (CommitMode<>2) and (CheckActMode=0) then
           LPost_To_CCNominal(FullNomKey(LNom.Cat),PPurch,PSales,0,PCr,PYr,PPr,
                           Succ(Level),PostYTD,AutoLZ,PostYTDNCF,CXRate,CCode,UOR);

       end
       else
       Begin
         ShowPostFailMsg(WMess+FOrm_Int(TNCode,0)+WMess2);
         AbortTran:=BOn;
       end;
     end
     else
     Begin
       ShowPostFailMsg(WMess+Form_Int(TNCode,0)+WMess3);
       AbortTran:=BOn;
     end;
   end; {Proc..}
{$ENDIF}




 { ========= Procedure to Collect STK Val Ctrl Lines ======= }

 Procedure TEntPost.Stock_PostAValue(RunNo,
                                     SearchRunNo  :  LongInt;
                                     SMode        :  Byte;
                                     AutoRecover  :  Boolean);


 Const
   Fnum      =  IDetailF;
   Keypath   =  IdRunK;


 Var
   KeyS,
   KeyChk    :  Str255;
   RecORef   :  Str10;

   TTEnabled,
   Loop      :  Boolean;

   B_Func    :  Integer;


 Begin
   TTEnabled:=BOff;


   KeyChk:=FullNomKey(SearchRunNo);

   KeyS:=KeyChk;

   RecORef:='';

   B_Func:=0;

   With MTExLocal^ do
   Begin

     LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);


     While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
     With LId do
     Begin

       {Application.ProcessMessages;}

       If (IdDocHed=RUN) and ((PDate='') or (Not AutoRecover)) then
       Begin
           If (TranOk2Run) then
           Begin
             LStatus:=LCtrl_BTrans(1);

             TTEnabled:=LStatusOk;

             {* Wait until All clear b4 continuing *}
             If (TTEnabled) then
               WaitForHistLock;

           end;

         PostedRun:=RunNo;

         LPost_To_Nominal(FullNomKey(NomCode),NetValue,Discount,0,Currency,PYr,PPr,1,BOff,BOff,BOff,
                         CXRate,PreviousBal,NomCode,UseORate);

         If (Syss.SepRunPost) then
           RecORef:=Desc;

         Case SMode of
           0  :  Desc:='Stock movement valuation';
           1  :  Desc:='Multiple Dr/Cr Control Movement';

           {$IFDEF JC}
             2  :  Desc:='Job Uplift Adjustment to Cost';
           {$ENDIF}

         end; {Case..}

         If (Syss.SepRunPost) then
           Desc:=RecORef+' - '+Desc;

         

         ShowStatus(2,'Posting '+Desc+'. '+dbFormatName(IntToStr(NomCode),Copy(LNom.Desc,1,5)));

         Inc(ItemCtrlTotal);

         UpdateProgress(ItemCtrlTotal);

         
         PDate:=Form_Int(RunNo,LDateKeyLen);

         LStatus:=LPut_Rec(Fnum,Keypath);

         If (Not AbortTran) then
           AbortTran:=(Not LStatusOk) and (TTEnabled);

         LReport_BError(Fnum,LStatus);

         {$IFDEF PF_On}

           If (Syss.PostCCNom) and (Syss.UseCCDep) and (LStatusOk) then
           Begin
             Loop:=BOff;

             Repeat
               If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
               Begin
                 LPost_To_CCNominal(FullNomKey(NomCode),NetValue,Discount,0,Currency,PYr,PPr,1,BOff,BOff,BOff,
                         CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);

                 
                 If (Syss.PostCCDCombo) then {* Post to combination *}
                   LPost_To_CCNominal(FullNomKey(NomCode),NetValue,Discount,0,Currency,PYr,PPr,1,BOff,BOff,BOff,
                         CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate);

               end;

               Loop:=Not Loop;

             Until (Not Loop);
           end;

         {$ENDIF}


          If (TTEnabled) and (Syss.ProtectPost) then
          Begin
            UnLockHistLock;

            LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

            LReport_BError(InvF,LStatus);


          end;

         If (Not AbortTran) then
           B_Func:=B_GetGEq
         else
           B_Func:=B_GetNext;
       end
       else
         B_Func:=B_GetNext;

       LStatus:=LFind_Rec(B_Func,Fnum,Keypath,KeyS);

     end; {While..}
   end; {With..}

 end; {Proc..}


 procedure TEntPost.ThreadDelay(dt  :  Word;
                                SAPM:  Boolean);

Var
  ThTimeS,
  thTimeN   :  TDateTime;

  thGap     :  Double;

Begin
  thTimeS:=Now;

  thGap:=dt/1e8;

  Repeat
    thTimeN:=Now-ThTimeS;

    If (SAPM) then
      Application.ProcessMessages;

  Until (thTimeN>thgap);

end;


 { ============= Procedure to Post All Doc Detail Lines ============= }

 Procedure TEntPost.Post_Details(DocFno,RunNo  :  LongInt;
                                 VYr,VPr       :  Integer;
                                 CtrlSet       :  ControlAry;
                             Var LineTotal     :  Real;
                                 AutoRecover   :  Boolean);


 Const
   Fnum     =  IDetailF;
   KeyPath  =  IDFolioK;



 Var
   UOR         :  Byte;

   Key,ScanKey :  Str255;


   Cleared     :  Double;
   TempCleared : Double;

   CrDr,
   DiscCrDr    :  DrCrDType;

   BOMCOSGL    :  LongInt;

   LineDisc,CTot,
   LineVATRate :  Double;

   TTEnabled,
   BeenPosted,
   WarnAbort,
   Loop,
   GenStkAV    :  Boolean;

   BOMLine     :  IDetail;


 Begin
   WarnAbort:=BOff;

   Loop:=BOff;  TTEnabled:=BOff;  UOR:=0;

   GenStkAV:=BOff; BOMCOSGL:=0; LineVATRate:=0.0;

   FillChar(BOMLine,Sizeof(BOMLine),0);

   Key:=FullNomKey(DocFno);

   ScanKey:=FullIdKey(DocFno,StkLineNo);

   LineTotal:=0.0;  LineDisc:=0.0;


   With MTExLocal^ do
   Begin


     LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,ScanKey);

     While (LStatusOk) and (CheckKey(Key,ScanKey,Length(Key),BOn)) do

     With LId do
     Begin
       BeenPosted:=(PostedRun<>0) and AutoRecover; {* Check it has been posted already *}
       TTEnabled:=BOff;

        If (Not BeenPosted) and (TranOk2Run) then
        Begin
          LStatus:=LCtrl_BTrans(1);

          TTEnabled:=LStatusOk;

          {* Wait until All clear b4 continuing *}
          If (TTEnabled) then
            WaitForHistLock;

        end
        else
          TTEnabled:=BOff;


       If (Not WarnAbort) and (Has_Aborted) then
       Begin
         ShowStatus(3,'Please wait, finishing current transaction.');
         WarnAbort:=BOn;
       end;


       CTot:=DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0);

       If (NetValue<>0) or (CTot<>0) or (LineNo=StkLineNo) then
       Begin

         if LID.VATCode in ['A', 'D'] then
          HasIntrastat := True;

         If (Syss.SepDiscounts) then
           LineDisc:=Round_Up((CTot-DetLTotal(LId,Syss.SepDiscounts,BOff,0.0))*DocNotCnst,2)
         else
           LineDisc:=0.0;

         ShowDrCrD(CTot,CrDr);

         ShowDrCrD(LineDisc,DiscCrDr);



         If (Reconcile=ReconC) then
           Cleared:=(CrDr[BOff]-CrDr[BOn])
         else
           Cleared:=0;

         { CJS 2013-09-02 - ABSEXCH-14199 - tlRecon date not preserved after
           unpost - added check that the date is not already set }
         if Trim(ReconDate) = '' then
         begin
           If (Reconcile=ReconC) then
             ReconDate:=Today
           else
             ReconDate:=MaxUntilDate;
         end;

         PYr:=LInv.AcYr; PPr:=LInv.AcPr;

         CustCode:=LInv.CustCode;


         If (SOPLink=0) and (SOPLineNo=0) and (Not ProtectLDateEvent) then
           PDate:=LInv.TransDate;


         If (CXRate[BOff]=0.0) then
           CXRate[BOff]:=LInv.CXRate[BOff];     {* Mainly needed for a Post after an Unpost, to ensure the

                                                rate matches that of the header *}


         If (CXRate[BOff]=0.0) then             {* If Still 0 set to system value *}
           CXRate[BOff]:=SyssCurr.Currencies[Currency].CRates[BOff];

         {$B-}
         If (UseCoDayRate) and (CXRate[BOn]=0.0) and (LInv.CXRate[BOn]<>0.0) then
           CXRate[BOn]:=LInv.CXRate[BOn];

         If (UseCoDayRate) and (IdDocHed In SalesSplit+PurchSplit-RecieptSet) and (LineNo<>RecieptCode)
           and (CXRate[BOn]<>LInv.CXRate[BOn]) then
           CXRate[BOn]:=LInv.CXRate[BOn];

         {$B+}


         {* Keep rate at posting used for COS *}

         If (COSConvRate=0.0) then {* Only set once, so a repost will  not alter it*}
           COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];



         If (LineNo<>StkLineNo) and ((PPr<>0) and (PYr<>0)) then  {* Ignore Stock deduct lines or cost only lines *}
         Begin
           UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

           If (Not BeenPosted) then
             LPost_To_Nominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,BOn,BOff,
                             CXRate,PreviousBal,NomCode,UOR);


           { ========= Calculate Equivalent Line total net value ========= }

           LineTotal:=Round_Up(LineTotal,2)+Round_Up(Conv_TCurr(CTot,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);


           If (Not BeenPosted) then
           Begin
             PostedRun:=RunNo;

             {$IFDEF PF_On}
               If (Syss.PostCCNom) and (Syss.UseCCDep) then
               Begin
                 Repeat
                   If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
                   Begin
                     LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                       CXRate,PostCCKey(Loop,CCDep[Loop]),UOR);

                     {* Post to combination *}
                     If (Syss.PostCCDCombo) then
                       LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                       CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UOR);

                     If (Syss.SepDiscounts) and (LineDisc<>0.0) then
                     Begin

                       LPost_To_CCNominal(FullNomKey(CtrlSet[LDiscCtrl]),DiscCrDr[BOff],DiscCrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                       CXRate,PostCCKey(Loop,CCDep[Loop]),UOR);

                       {* Post to combination *}
                       If (Syss.PostCCDCombo) then
                         LPost_To_CCNominal(FullNomKey(CtrlSet[LDiscCtrl]),DiscCrDr[BOff],DiscCrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                       CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UOR);
                     end;
                   end;

                   Loop:=Not Loop;

                 Until (Not Loop);
               end;

           {$ENDIF}
           end;
         end;


         If (Not BeenPosted) then
         Begin
           {$IFDEF STK}
              LiveUpLift:=(IdDocHed In PurchSplit) and (Syss.AutoValStk) and (Syss.UseUpliftNC);

           {$ENDIF}

           LStatus:=LPut_Rec(Fnum,Keypath);

           LReport_BError(Fnum,LStatus);

           If (Not AbortTran) then
             AbortTran:=(Not LStatusOk) and (TTEnabled);


           {* Post to VAT History do NOT post to :-
              Directs - payment part lines,
              Reciepts,
              Nom Txfrs.
              Do not post either if a triangulation or process invoice (v4.31)
              DO Not Post here if Cash Accounting Mode,
              or Auto Deduct Line.

           *}

           If (LStatusOk) and
           ((Not (LInv.InvDocHed In RecieptSet+NomSplit))
           or  ((LInv.InvDocHed In NOMSplit) and (LInv.NomVATIO<>C0)))
           and (VATCode<>C0)
              and (LineNo<>StkLineNo)
              and (Not (LInv.SSDProcess In ['P','T']))
              and (Not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then
           Begin


             { ========= Post to VAT History for Line ========== }

             If (Not (LInv.InvDocHed In NOMSplit)) then
             Begin
               If (LInv.OldORates[UsecoDayRate]<>0.0) then {* We have been through a conversion, and this needs to be stated
                                             in original currency*}
                 LineVATRate:=LInv.OldORates[UseCoDayRate]
               else
                 If (UseCoDayRate) then
                   LineVATRate:=LId.CXrate[UseCoDayRate]
                 else
                   LineVATRate:=LInv.OrigRates[UseCoDayRate];
             end
             else
               LineVATRate:=LId.CXrate[UseCoDayRate];

             Cleared:=Conv_VATCurr(DetLTotal(LId,BOn,LInv.DiscTaken,LInv.DiscSetl),LInv.VATCRate[UseCoDayRate],
                                   LineVATRate,LInv.Currency,LInv.UseORate)*DocNotCnst;


             If (Cleared<>0) then
             begin
               TempCleared := Cleared;
               LPost_To_Hist(IOVATCode(IdDocHed,LInv.NOMVATIO),
                            FullCustCode(SyssVAT.VATRates.VAT[GetVATNo(VATCode,VATIncFlg)].Code),
                            0,Cleared,0,0,VYr,VPr,
                            Cleared);
               if DoReverseCharge(LInv, LId) then
                 LPost_To_Hist('O',
                              FullCustCode(SyssVAT.VATRates.VAT[GetVATNo(VATCode,VATIncFlg)].Code),
                              0,TempCleared * DocNotCnst,0,0,VYr,VPr,
                              TempCleared);

             end;
             LStatus:=0;
           end;
         end; {If Already posted... }
       end
       else
       Begin
         {$IFDEF STK} {b560.057. Realign period on lines with zero value which still generate a COS movement *}
           If (Syss.AutoValStk) then {* Perform auto Stock transfer *}
           Begin
             PYr:=LInv.AcYr; PPr:=LInv.AcPr;
           end;
         {$ENDIF}

       end;


       If (LStatusOk) and (Not BeenPosted) then
       Begin
         {$IFDEF STK}

           Stock_PostCtrl(LId,Ctot,BOff);

           {
              If Syss.AutoValStk is True, this is a 'Live Stock' system (as
              opposed to a 'Cost of Sales' system).
           }
           If (Syss.AutoValStk) then {* Perform auto Stock transfer *}
           Begin
             {
                If this is a Sales transaction and a hidden Stock Deduct (BOM)
                line...
             }
             If (IdDocHed In SalesSplit) and (LineNo=StkLineNo) then
             Begin
              {
                ...locate the matching parent line (the line number is assumed
                to be stored in the SOPLineNo field). The details of the parent
                line (if found) will be returned in BOMLine.
              }
              {$B-}
               GenStkAV:=(CostPrice<>0.0) and (B2BLineNo<>1) and (GotBOMLine(FolioRef,SOPLineNo,Fnum,Keypath,BOMLine));
              {$B+}

               If (GenStkAV) then
               Begin
                 LId.Currency:=BOMLine.Currency;
                 LId.CCDep:=BOMLine.CCDep;
                 BOMCOSGL:=GotBOMCOSGL(BOMLine,StockF,StkCodeK);
               end;

             end
             else
             Begin
               GenStkAV:=BOn;
               BOMCOSGL:=0; {Reset this each time incase next line is not a BOM component!}
             end;



             If (GenStkAV) then
               Stock_GenAVal(LId,Fnum,Keypath,RunNo,BOMCOSGL);

             {$IFDEF SOP}
                {* Reverse any effect on live commitment value as it is now posted *}
                If (CommitAct) then
                  Update_LiveCommit(LId,-1);
             {$ENDIF}

           end;

         {$ENDIF}



         If (Syss.UsePayIn) then
           Process_PayIn(Keypath);

         {$IFDEF JC}
            If (JBCostOn) then {* See if any supplemental uplift needs to be taken into account *}
              PostJCUplift(Fnum,Keypath,RunNo);
         {$ENDIF}
        end;

         If (TTEnabled) and (Syss.ProtectPost) then
         With MTExLocal^ do
         Begin
           UnLockHistLock;

           LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

           LReport_BError(IdetailF,LStatus);

           {$IFDEF EXSQL}
           if not SQLUtils.UsingSQL then
           {$ENDIF}
           ThreadDelay(600,BOff); {* This delay seemed necessary in order to give other ws a chance to issue system transactions *}

           If (Not AbortLines) then
             AbortLines:=AbortTran;

           AbortTran:=BOff;

         end
         else
           LStatus:=0;

       If (LStatusOk) or (TTEnabled) then
         LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,ScanKey);
     end; {While..}


   end; {With..}
 end; {Proc..}


  { ============= Procedure to Post All Doc Detail Lines ============= }

 Function TEntPost.LinesPartPosted(DocFno,RunNo  :  LongInt;
                                   AutoRecover   :  Boolean)  :  Boolean;


 Const
   Fnum     =  IDetailF;
   KeyPath  =  IDFolioK;



 Var
   Key,ScanKey :  Str255;

   BeenPosted  :  Boolean;

 Begin
   BeenPosted:=BOff;

   Key:=FullNomKey(DocFno);

   ScanKey:=FullIdKey(DocFno,StkLineNo);

   If (AutoRecover) then
   With MTExLocal^ do
   Begin


     LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,ScanKey);

     While (LStatusOk) and (CheckKey(Key,ScanKey,Length(Key),BOn)) and (Not BeenPosted) do
     With LId do
     Begin
       BeenPosted:=(PostedRun=RunNo); {* Check it has been posted already *}

       If (Not BeenPosted) then
         LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,ScanKey);

     end; {While..}

   end; {With..}

   Result:=BeenPosted;
 end; {Proc..}



 { ============= Procedure to Post All Doc Detail Lines ============= }

 Procedure TEntPost.Post_CtrlDetails(RunNo         :  LongInt;
                                     AutoRecover   :  Boolean);

 Const
   Fnum     =  IDetailF;
   KeyPath  =  IDRunK;
   ExcludeNCC :  Set of NomCtrlType = [PLStart,PLEnd,SalesComm,PurchComm];




 Var
   Key,ScanKey :  Str255;
   N           :  NomCtrlType;

   TTEnabled   :  Boolean;


 Begin
   TTEnabled:=BOff;

   With MTExLocal^ do
   Begin
     For N:=NomCtrlStart to NomCtrlEnd do
     Begin

       Key:=FullRunNoKey(RunNo,Syss.NomCtrlCodes[N]);
       ScanKey:=Key;


       LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,ScanKey);

       With LId do
         ScanKey:=FullRunNoKey(PostedRun,NomCode);

       {$IFDEF MC_On}  {* Post all Ctrl Codes *}

         While (LStatusOk) and (CheckKey(Key,ScanKey,Length(Key),BOn))
           and (Not (N In ExcludeNCC)) and ((N<>FreightNC) or (Syss.UseUpliftNC)) do


       {$ELSE} {* If Single currency DO NOT Post Currency variance *}

        While (LStatusOk) and (CheckKey(Key,ScanKey,Length(Key),BOn)) and (N<>CurrVar) and
            (Not (N In ExcludeNCC)) and ((N<>FreightNC) or (Syss.UseUpliftNC)) do

       {$ENDIF}


       With LId do
       Begin
         {Application.ProcessMessages;}

         
         If (IdDocHed=RUN) and ((PDate='') or (Not AutoRecover)) then
         Begin
           If (TranOk2Run) then
           Begin
             LStatus:=LCtrl_BTrans(1);

             TTEnabled:=LStatusOk;

             {* Wait until All clear b4 continuing *}
             If (TTEnabled) then
               WaitForHistLock;

           end;

           LPost_To_Nominal(FullNomKey(NomCode),NetValue,Discount,0,Currency,PYr,PPr,1,BOff,BOff,BOff,CXRate,PreviousBal,NomCode,UseORate);


           ShowStatus(2,'Post G/L Ctrl Lines '+Desc+'. '+dbFormatName(IntToStr(NomCode),Copy(LNom.Desc,1,5)));

           Inc(ItemCtrlTotal);

           UpdateProgress(ItemCtrlTotal);

           
           PDate:=Form_Int(RunNo,LDateKeyLen);

           LStatus:=LPut_Rec(Fnum,Keypath);

           LReport_BError(Fnum,LStatus);

           If (Not AbortTran) then
             AbortTran:=(Not LStatusOk) and (TTEnabled);

           If (TTEnabled) and (Syss.ProtectPost) then
           Begin
             UnLockHistLock;

             LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

             LReport_BError(InvF,LStatus);

             {$IFDEF EXSQL}
             if not SQLUtils.UsingSQL then
             {$ENDIF}
             ThreadDelay(600,BOff); {* This delay seemed necessary in order to give other ws a chance to issue system transactions *}
           end;

         end;

         LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,ScanKey);

         ScanKey:=FullRunNoKey(PostedRun,NomCode);
       end; {While..}

     end; {Loop..}

     Stock_PostAValue(RunNo,StkValARunNo+(RunNo*DocNotCnst),0,AutoRecover); {* Post Auto Stk Lines *}

     Stock_PostAValue(RunNo,MDCCARunNo+(RunNo*DocNotCnst),1,AutoRecover); {* Post Multiple Dr/Cr Accounts *}

     {$IFDEF JC}
        Stock_PostAValue(RunNo,JCUpliftARunNo+(RunNo*DocNotCnst),2,AutoRecover); {* Post JC Uplift Accounts *}
     {$ENDIF}

   end; {With..}
 end; {Proc..}


{ == Proc to Write to Log == }



Procedure TEntPost.Write_PostLogDD(S         :  String;
                                   SetWrite  :  Boolean;
                                   DK        :  Str255;
                                   DM        :  Byte);

Begin
  {$IFDEF FRM}
    If (Not Assigned(PostLog)) then
    Begin
      PostLog:=TPostLog.Create;


      try
        With PostLog do
        Begin
          Write_Msg('Log started '+ConCat(DateToStr(Now),' - ',TimeToStr(Now)));
          Write_Msg(ConstStr('-',100));
          Write_Msg('');
        end;

      except
        FreeAndNil(PostLog);
      end;

    end;

    try
      If (Assigned(PostLog)) then
      With PostLog do
      Begin
        If (SetWrite) and (Not Got2Print) then
          Got2Print:=SetWrite;

        Write_MsgDD(S,DK,DM);
      end;
    except
      FreeAndNil(PostLog);
    end;

  {$ENDIF}
end;

Procedure TEntPost.Write_PostLog(S         :  String;
                                 SetWrite  :  Boolean);
Begin
  Write_PostLogDD(S,SetWrite,'',0);
end;


{ == Function to check and log a document for inclusion == }

Function TEntPost.Include_Transaction(Var PostSet      :  DocSetType;
                                      Var AutoRecover  :  Boolean;
                                      Var PRunNo       :  LongInt;
                                          BatchMode    :  Boolean)  :  Boolean;

Var
  TInc,
  BelongsPSet  :  Boolean;

  OrigSet      :  DocSetType;

Begin
  Result:=BOff;

  With MTExLocal^,LInv do
  Begin
    {$B-}

    OrigSet:=PostSet;

    TInc:= ((InvDocHed In PostRepCtrl^.IncDocFilt) or (PostRepCtrl^.NoIDCheck) or (AutoRecover))
      and ((Not AutoRecover) or (LinesPartPosted(FolioNum,PRunNo,AutoRecover)));

    Result:=TInc;

    BelongsPSet:=TInc;

    If (BatchMode) then
    Begin
      TInc:=(InvDocHed In BatchSet+StkAdjSplit);

      Result:=(TInc and Result);

      BelongsPSet:=(TInc and BelongsPSet);

    end;

    {
      CheckHold() returns False if the Transaction is on hold. If the
      Transaction has the Suspend flag set, the PostSet set of document types
      will be adjusted to exclude the documents types for the same daybook.
    }
    TInc:= (CheckHold(InvDocHed,HoldFlg,PostSet));

    BelongsPSet:=((InvDocHed In OrigSet) or AutoRecover) and BelongsPSet;

    {
      If the document is on Hold, but would otherwise have been included, an
      appropriate message is added to the posting log.
    }
    If (SuspendDoc(HoldFlg)) and (InvDocHed In OrigSet) and ((Not BatchMode) or (InvDocHed In BatchSet+StkAdjSplit)) then
      // MH 30/07/2015 2015-R1 ABSEXCH-11984: Corrected spelling of suspended
      Write_PostLogDD(OurRef+' not posted due to the posting run being suspended at this point. Any transactions after this one will not be posted either.',BOn,OurRef,0)
    else
      If (Not TInc) and (BelongsPSet) then
      Begin
           Write_PostLogDD(OurRef+' not posted due to it being on hold.',BOn,OurRef,0);
      end;

    Result:=(TInc and Result);

    TInc:=((InvDocHed In PostSet) or AutoRecover);

    Result:=(TInc and Result);

    BelongsPSet:=(TInc and BelongsPSet);


    TInc:=((FolioNum<=LastFolio) or (LastFolio=0) or (AutoRecover) or BatchMode);

    If (Not TInc) and (BelongsPSet) then
      Write_PostLogDD(OurRef+' not posted as it was created after the posting run had started.',BOn,OurRef,0);

    Result:=(TInc and Result);



    TInc:=(((Pr2Fig(AcYr,AcPr)<=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Not Syss.PrevPrOff))
            or ((Pr2Fig(AcYr,AcPr)=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Syss.PrevPrOff)));

    If (Not TInc) and (BelongsPSet)  then
    Begin
      If (Syss.PrevPrOff) then
        Write_PostLogDD(OurRef+' not posted as it is either to future period, or to a past period, and posting to previous periods is not allowed.',BOn,OurRef,0)
      else
        Write_PostLogDD(OurRef+' not posted as it is for a future period to the current period.',BOn,OurRef,0);

    end;

    Result:=(TInc and Result);

    TInc:=((CXRate[BOn]<>0.0) or (InvDocHed In NomSplit) or BatchMode);

    If (Not TInc) and (BelongsPSet)  then
      Write_PostLogDD(OurRef+' not posted due to the daily exchange rate being zero.',BOn,OurRef,0);

    Result:=(TInc and Result);

    TInc:=(TransDate<=Today);

    If (Not TInc) and (BelongsPSet)  then
      Write_PostLogDD(OurRef+' not posted due to the transaction date being in the future.',BOn,OurRef,0);

    Result:=(TInc and Result);

   {*EN420}

    Tinc:=(AfterLastAudit(TransDate,0) and AfterPurge(AcYr,0));

    If (Not TInc) and (BelongsPSet)  then
      Write_PostLogDD(OurRef+' not posted as it belongs to a previously purged period, or is outside the Last Audit Date.',BOn,OurRef,0);

    Result:=(TInc and Result);

    {$B+}

   end;
end;

{ Calculates and returns the Purchase Service VAT Total for the current
  transaction. }
function TEntPost.CalcPurchaseServiceVATTotal: double;
var
  Key: Str255;
begin
  Result := 0.0;
  with MTExLocal^ do
  begin
    Key := FullNomKey(LInv.FolioNum);
    LStatus := LFind_Rec(B_GetGEq, IdetailF, IdFolioK, Key);
    while (LStatusOk) and (LId.FolioRef = LInv.FolioNum) and (not ThreadRec^.THAbort) do
    begin
      Result := Result + LId.PurchaseServiceTax;
      LStatus := LFind_Rec(B_GetNext, IdetailF, IdFolioK, Key);
    end;
  end;
end;

{ =============== Main Posting Procedure -
                    Posts all Control Codes from doc header,
                    & then posts details for Doc
                  Creates Control Detail Lines, & Posts them =============== }

Procedure TEntPost.Post_It(PostSet   :  DocSetType;
                           Mode      :  Byte;
                           ItemTotal :  LongInt);

Const
  Fnum    =  InvF;
  KeyPath =  InvRnoK;


Var
  AutoRecover,
  TTEnabled,
  LOk,
  Locked,
  AutoLZ,
  SalesOn,
  SetCtrlCCDep,
  UseCCDep :  Boolean;

  UOR,
  HistCr   :  Byte;
  CtrlSet  :  ControlAry;
  TTMsg    :  Str20;
  DocKey   :  Str255;
  N        :  ControlSet;

  B_Func,
  VYr,VPr  :  Integer;

  VATTot,
  VATCurrTot,
  ECVATTot,
  ECVATCurrTot,
  InvGTot,
  InvDisc,
  InvLDisc,
  IGEquiv
           :  Real;

  PRunNo,
  ItemProgress,
  ItemCount:  LongInt;

  PostCCDep,
  DefCCDep
           :  CCDepType;

  PostSummary
	   :  PostingSummaryArray;

  MsgForm  :  TForm;

  PurchaseServiceVATTotal: double;

{Functions to override the VAT Ctrl Account when posting NOMS}

Function VATCtrlGL  :  LongInt;

Begin
  With MTExLocal^.LInv do
  Begin
    If (InvDocHed=NMT) then
    Begin
      If (NOMVATIO=IOVATCh[BOff]) or (NOMVATIO=IOVATCh[BOn]) then
      Begin
        If (NOMVATIO=IOVATCh[BOn]) then
          Result:=Syss.NomCtrlCodes[OutVAT]
        else
          Result:=Syss.NomCtrlCodes[InVAT];
      end
      else
        Result:=CtrlSet[VATCtrl];
    end
    else
      Result:=CtrlSet[VATCtrl];

  end; {With..}
end; {Proc..}

Begin

  Blank(DocKey,Sizeof(DocKey));

  VATTot:=0; VATCurrTot:=0; InvGTot:=0;  InvDisc:=0; AutoLZ:=BOn;

  PRunNo:=0; HistCr:=0;  InvLDisc:=0; SalesOn:=BOff; UseCCDep:=BOff;

  IGEquiv:=0; AutoRecover:=BOff;

  UOR:=0;

  PurchaseServiceVATTotal := 0;
  
  TTEnabled:=BOff;  TTMsg:='';

  Blank(PostCCDep,SizeOf(PostCCDep));

  Blank(DefCCDep,SizeOf(DefCCDep));

  ItemCount:=0;


  ItemProgress:=0;

  //PR: 18/02/2016 v2016 R1 FIX_WARNINGS Initialise VYr & VPr to 0.
  VYr := 0;
  VPr := 0;

  If (TranOk2Run) then {* Have another go at setting up transaction *}
  With MTExLocal^ do
  Begin
    LStatus:=LCtrl_BTrans(1);

    TranOk2Run:=LStatusOk;

    If (Not TranOk2Run) then
    Begin
       AddErrorLog('Posting Run. Protected Mode could not be started. (Error '+Form_Int(LStatus,0)+')','',4);

       LReport_BError(InvF,LStatus);
    end;

    LStatus:=LCtrl_BTrans(0);
  end;


  InitProgress(ItemTotal);

  { Reset the Posting Summary array values to zero }
  InitPostingSumm(PostSummary,BOff);

  DocKey:=FullDayBkKey(0,0,'');

  With MTExLocal^ do
  Begin

    AutoRecover:=(PostRepCtrl^.LastRunNo<>0) and Syss.ProtectPost;

    {$IFDEF CU}
      LOk:=BOff;

      // CJS 05/05/2011: ABSEXCH-11283 - Incorrect hook point in Posting Run
      // Corrected WinID to 4000 (was 2000)
      SetCtrlCCDep := LHaveHookEvent(4000, 88, LOk);

    {$ELSE}
      SetCtrlCCDep:=BOff;

    {$ENDIF}

    If (AutoRecover) then
      PRunNo:=PostRepCtrl^.LastRunNo;

    { Find the first transaction with a line number of zero (=unposted) }
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,DocKey);

    While (LStatusOk) and (LInv.RunNo=0) and (Not ThreadRec^.THAbort) do
    Begin
      Inc(ItemCount);

      UpdateProgress(ItemCount);


      B_Func:=B_GetNext;

      // CJS 2016-01-22 - ABSEXCH-17181 - Posting – Intrastat Out of Period flag being set on Non-Intrastat transactions
      HasIntrastat := False;

      {Application.ProcessMessages;}

      With LInv do
      Begin
        {$B-}

        {$IFDEF V430_and_before }
        If (CheckHold(InvDocHed,HoldFlg,PostSet))
           and ((InvDocHed In PostSet) or AutoRecover)

           and ((InvDocHed In PostRepCtrl^.IncDocFilt) or (PostRepCtrl^.NoIDCheck) or (AutoRecover))
           and ((Not AutoRecover) or (LinesPartPosted(FolioNum,PRunNo,AutoRecover)))
           and ((FolioNum<=LastFolio) or (LastFolio=0) or (AutoRecover))

           and (((Pr2Fig(AcYr,AcPr)<=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Not Syss.PrevPrOff))
                or ((Pr2Fig(AcYr,AcPr)=Pr2Fig(GetLocalPr(0).CYr,GetLocalPr(0).CPr)) and (Syss.PrevPrOff)))

           and ((CXRate[BOn]<>0.0) or (InvDocHed In NomSplit))
           and (TransDate<=Today)
       {*EN420} and (AfterLastAudit(TransDate,0) and AfterPurge(AcYr,0)) then

       {$ELSE}

         {v431}

           If Include_Transaction(PostSet,AutoRecover,PRunNo,BOff) then
       {$ENDIF}

        {$B+}

        Begin

          ShowStatus(2,'Checking Document '+LInv.OurRef);

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,DocKey,KeyPath,Fnum,BOff,Locked);

          If (LOk) and (Locked) then
          Begin

            LGetRecAddr(Fnum);


            SetControlCodes(InvDocHed,CtrlSet);

            SalesOn:=SalesOrPurch(InvDocHed);


            If (PRunNo=0) then { Only Set Next Run No if Items to be Posted }
            Begin
              PRunNo:=LGetNextCount(RUN,BOn,BOff,0);

              ShowStatus(1,'Run No.: '+Form_Int(PRunNo,0)+TTMsg);

              PostUnLock(PRunNo);
            end;

            ShowStatus(2,'Posting Document '+OurRef);


            If (PostDate='') then {* Mark date posted *}
              PostDate:=Today;

            If (Not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then {* Only Post to individual VAT History if not
                                                                     Cash Accounting *}
            Begin
              If (VATPostDate='') and ((Not (InvDocHed In RecieptSet+NomSplit)) or ((InvDocHed In NOMSplit) and (NOMVATIO<>C0)) ) then
                VATPostDate:=LSetVATPostDate(MTExLocal^,2,''); {v5.51. Allows override of VAT post date by hook}

              If (VATPostDate<>'') then
              Begin
                VYr:=Part_Date('Y',VATPostDate)-1900;

                VPr:=Part_Date('M',VATPostDate);
              end
              else
              Begin
                VYr:=0;
                VPr:=0;
              end;
            end;

            AbortLines:=BOff;

            {* Preserve original Posted Co. Rate *}

                                    {* v Added v4.32.001 *}
            If (PostDate=Today) and (OrigRates[BOff]=0.0)  then {* A check was made here in v4.31.004 to stop an unpost/repost
                                             on revalued systems altering the vat returns.  should this need
                                               resetting, a SF to reset this on unposted trans would be needed,
                                               or if the vat periods get reset then postdate gets reset

                                                v4.32.001 added check to only set if origrates was zero as per a new o/s transaction,
                                                otherwise when the unpost resetting the vat periods is run, the vat return will go out
                                                *}
              OrigRates[BOff]:=SyssCurr.Currencies[Currency].CRates[BOff];

            {* Finalise daily rate at posting *}

            If (PostDate=Today) then
              OrigRates[BOn]:=CXRate[BOn];



            Post_Details(FolioNum,PRunNo,VYr,VPr,CtrlSet,IGEquiv,AutoRecover);

            If (Not AbortLines) then
            Begin

              If (TranOk2Run) then
              Begin
                LStatus:=LCtrl_BTrans(1);

                TTEnabled:=LStatusOk;

                TRanOk2Run:=TTEnabled;

                If (TTEnabled) then
                  TTMsg:='. Protected Mode.';

                ShowStatus(1,'Run No.: '+Form_Int(PRunNo,0)+TTMsg);

                {* Wait until All clear b4 continuing *}
                If (TTEnabled) then
                  WaitForHistLock;

              end
              else
                TTEnabled:=BOff;

              // CJS 2016-01-25 - ABSEXCH-17181 - Intrastat Out of Period flag not being set correctly when Posting
              // Make sure we have the right Trader record
              If (LInv.CustCode <> LCust.CustCode) then
                LGetMainRec(CustF,CustCode);

              // CJS 2016-01-06 - ABSEXCH-17096 - Intrastat Out of Period flag
              thIntrastatOutOfPeriod := False;
              // CJS 2016-01-22 - ABSEXCH-17181 - Posting – Intrastat Out of Period flag being set on Non-Intrastat transactions
              if Syss.Intrastat and LCust.EECMember and HasIntrastat then
              begin
                // Check for and report on transactions posted into closed
                // Intrastat periods
                if InvDocHed in [PIN, PJI, PCR, PJC, PPI, PRF] then
                begin
                  if TransDate <= SystemSetup.Intrastat.isLastClosedArrivalsDate then
                  begin
                    thIntrastatOutOfPeriod := True;
                    Write_PostLogDD(LInv.OurRef + ' has been posted to a closed Intrastat period - the Intrastat Supplementary Declaration must be amended.', BOn, LInv.OurRef, 0);
                  end;
                end
                else if InvDocHed in [SIN, SJI, SCR, SJC, SRI, SRF] then
                begin
                  if TransDate <= SystemSetup.Intrastat.isLastClosedDispatchesDate then
                  begin
                    thIntrastatOutOfPeriod := True;
                    Write_PostLogDD(LInv.OurRef + ' has been posted to a closed Intrastat period - the Intrastat Supplementary Declaration must be amended.', BOn, LInv.OurRef, 0);
                  end;
                end;
              end;

              If (CtrlSet[DebCred]<>0) or ((InvDocHed In NOMSplit) and (NOMVATIO<>C0)) then
              Begin
                VATTot:=Conv_TCurr(InvVAT,CXRate[BOn],Currency,UseORate,BOff);

                {* Calculate VAT currency equivalent *}

                VATCurrTot:=Conv_VATCurr(InvVAT,VATCRate[BOn],Calc_BConvCXRate(LInv,CXRate[BOn],BOn),Currency,UseORate);


                If (Not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then {* Only Post to individual VAT History if not
                                                                         Cash Accounting *}
                Begin

                  {If (VATPostDate='') and (Not (InvDocHed In RecieptSet+NomSplit)) then
                    VATPostDate:=CalcVATDate(TransDate);


                  VYr:=Part_Date('Y',VATPostDate)-1900;

                  VPr:=Part_Date('M',VATPostDate);}

                  Post_VAT(VYr,VPr,BOff);  {* Post to Individual VAT History *}

                end;

                {* Post Base Currency VAT Content to 0 Debtors/Creditors & VAT Ip/Op
                   Also post VAT in its own currency (as specified by Syss.CurrVAT) to
                   its own currency *}


                If (VATTot<>0) then
                Begin
                  Post_To_RunCtrl(VATCtrlGL,PRunNo,0,0,AcYr,AcPr,CXRate,(VATTot*DocCnst[InvDocHed]),Syss.SepRunPost,
                                  UseCCDep,PostCCDep,LInv);

                  CalcSum(PostingAnalysisDocTypes[VATSalesMode(SalesOn,Spare8),8],VATSalesMode(SalesOn,Spare8),BOff,PostSummary,(VATTot*DocCnst[InvDocHed]));  {* Post to Summary Array }


                  If (Syss.VATCurr<>0) and (VATCurrTot<>0) then {* Post separetly to VAT own currency *}
                    Post_To_RunCtrl(VATCtrlGL,PRunNo,0,Syss.VATCurr,AcYr,AcPr,CXRate,(VATCurrTot*DocCnst[InvDocHed]),Syss.SepRunPost,
                                    UseCCDep,PostCCDep,LInv);


                end;

                if (InvDocHed in PurchSplit) and DoReverseCharge then
                begin
                  PurchaseServiceVATTotal := CalcPurchaseServiceVATTotal;
                  if (PurchaseServiceVATTotal <> 0) and not VAT_CashAcc(SyssVAT.VATRates.VATScheme) then
                  begin
                    ECVATTot := Conv_TCurr(PurchaseServiceVATTotal, CXRate[BOn], Currency, UseORate, BOff);
                    ECVATCurrTot := Conv_VATCurr(PurchaseServiceVATTotal, VATCRate[BOn], Calc_BConvCXRate(LInv, CXRate[BOn], BOn), Currency, UseORate);

                    if (ECVATTot <> 0) then
                    Begin
                      { Post Input VAT }
                      Post_To_RunCtrl(Syss.NomCtrlCodes[InVAT], PRunNo, 0, 0,
                                      AcYr, AcPr, CXRate,
                                      (ECVATTot * DocCnst[InvDocHed]),
                                      Syss.SepRunPost, UseCCDep, PostCCDep,
                                      LInv, True);

                      { Post to Summary Array }
                      CalcSum(PostingAnalysisDocTypes[VATSalesMode(SalesOn, Spare8), 8],
                              VATSalesMode(SalesOn,Spare8), BOff, PostSummary,
                              (ECVATTot*DocCnst[InvDocHed]));

                      { Post in VAT currency }
                      if (Syss.VATCurr <> 0) and (ECVATCurrTot <> 0) then
                        Post_To_RunCtrl(Syss.NomCtrlCodes[InVAT], PRunNo, 0,
                                        Syss.VATCurr, AcYr,AcPr,CXRate,
                                        (ECVATCurrTot * DocCnst[InvDocHed]),
                                        Syss.SepRunPost, UseCCDep, PostCCDep,
                                        LInv, True);

                      { Post Output VAT }
                      Post_To_RunCtrl(Syss.NomCtrlCodes[OutVAT], PRunNo, 0, 0,
                                      AcYr, AcPr, CXRate,
                                      (ECVATTot * DocCnst[InvDocHed] * -1.0),
                                      Syss.SepRunPost, UseCCDep, PostCCDep,
                                      LInv, True);

                      { Post to Summary Array }
                      CalcSum(PostingAnalysisDocTypes[not VATSalesMode(SalesOn, Spare8), 8],
                              not VATSalesMode(SalesOn,Spare8), BOff, PostSummary,
                              (ECVATTot*DocCnst[InvDocHed] * -1.0));

                      { Post in VAT currency }
                      if (Syss.VATCurr <> 0) and (ECVATCurrTot <> 0) then
                        Post_To_RunCtrl(Syss.NomCtrlCodes[OutVAT], PRunNo, 0,
                                        Syss.VATCurr, AcYr,AcPr,CXRate,
                                        (ECVATCurrTot * DocCnst[InvDocHed] * -1.0),
                                        Syss.SepRunPost, UseCCDep, PostCCDep,
                                        LInv, True);

                      { Post VAT to History }
                      Post_ECVAT(VYr, VPr, False);
                    end;
                  end;
                end;

                {Application.ProcessMessages;}


                If (CtrlSet[DebCred]<>0) then
                Begin

                  {$IFDEF MC_On} {v4.30c}

                    InvGTot:=ITotal(LInv){-Inv.InvVAT}; {  Deduct VAT so that currency version of debtors does not include vat
                                                        this is so that a revaluation will only affect the net part of the
                                                        nominal, as VAT is already converted @ the Day rate }
                  {$ELSE}

                      InvGTot:=ITotal(LInv)+LInv.PostDiscAm{-Inv.InvVAT}; {  Deduct VAT so that currency version of debtors does not include vat
                                                        this is so that a revaluation will only affect the net part of the
                                                        nominal, as VAT is already converted @ the Day rate }

                      {Add in settlement discount if single currency, as otherwise does not get included}

                  {$ENDIF}

                  InvDisc:=0;  InvLDisc:=0;


                  InvLDisc:=DiscAmount;

                  If (DiscTaken) then
                    InvDisc:=InvDisc+DiscSetAm;

                  HistCr:=Currency;

                  {* Post  Control Codes, First to Doc Currency, then to Base,
                     This is because you are combining reciepts (day rate) with
                     Invoices, in to debtors run time line, which can only store
                     one currency type *}

                  AutoLZ:=(Currency<>0);  { IF Not MC Version then Only Post Ctrl Accounts Once }

                  Repeat

                    If (Not AutoLZ) then  {* Post to Summary Array *}
                      CalcSum(InvDocHed,SalesOn,BOff,PostSummary,
                              ((InvGTot-Round_Up(VATTot,2)+Round_Up(InvDisc,2)+Round_Up(InvLDisc,2))*DocCnst[InvDocHed]));

                    If (Not (InvDocHed In DirectSet)) then
                    Begin


                      {* Post Invoice Total to Native/Base Currency *}

                      If (CtrlNom<>0) then {* Divert control account to doc specified account *}
                        Post_To_RunCtrl(CtrlNom,MDCCARunNo+(PRunNo*DocNotCnst),0,HistCr,AcYr,AcPr,CXRate,(InvGTot*DocCnst[InvDocHed]*DocNotCnst),
                                  Syss.SepRunPost,UseCCDep,PostCCDep,LInv)
                      else
                        Post_To_RunCtrl(CtrlSet[DebCred],PRunNo,0,HistCr,AcYr,AcPr,CXRate,(InvGTot*DocCnst[InvDocHed]*DocNotCnst),
                                        Syss.SepRunPost,UseCCDep,PostCCDep,LInv);

                      If (Not AutoLZ) then   {* Post to Summary Array *}
                        CalcSum(PostingAnalysisDocTypes[SalesOn,9],SalesOn,BOn,PostSummary,(InvGTot*DocCnst[InvDocHed]*DocNotCnst));


                    end {* Do not touch debtors/Creditors if Direct *}
                    else
                      If (Not AutoLZ) then
                        CalcSum(InvDocHed,SalesOn,BOn,PostSummary,(InvGTot*DocCnst[InvDocHed]*DocNotCnst));{* Post to Summary Array *}


                    {* Post Settle Disc Taken/Given to Nominal *}

                    DefCCDep:=PostCCDep;

                    {$IFDEF CU} {v5.70 Set a default cc/dep on settlement}
                      If (Syss.UseCCDep) and (SetCtrlCCDep) then
                      Begin
                        With LCust do
                          DefCCDep:=GetCustProfileCCDep(CustCC,CustDep,PostCCDep,0);

                      end;
                    {$ENDIF}

                    Post_To_RunCtrl(CtrlSet[DiscCtrl],PRunNo,0,HistCr,AcYr,AcPr,CXRate,
                                   (InvDisc*DocCnst[InvDocHed]*DocNotCnst),Syss.SepRunPost,UseCCDep,DefCCDep,LInv);

                    {Application.ProcessMessages;}

                    If (Not AutoLZ) then                                                                 {* Post to Summary Array *}
                        CalcSum(PostingAnalysisDocTypes[SalesOn,6],SalesOn,BOff,PostSummary,(InvDisc*DocCnst[InvDocHed]*DocNotCnst));


                    {* Post Line Disc Taken/Given to Nominal *}

                    If (Syss.SepDiscounts) then
                      Post_To_RunCtrl(CtrlSet[LDiscCtrl],PRunNo,0,HistCr,AcYr,AcPr,CXRate,
                                     (InvLDisc*DocCnst[InvDocHed]*DocNotCnst),Syss.SepRunPost,UseCCDep,PostCCDep,LInv);

                    If (Not AutoLZ) then                                                                 {* Post to Summary Array *}
                      CalcSum(PostingAnalysisDocTypes[SalesOn,7],SalesOn,BOff,PostSummary,(InvLDisc*DocCnst[InvDocHed]*DocNotCnst));

                    HistCr:=0;


                    AutoLZ:=Not AutoLZ;

                    If (Not AutoLZ) then
                    Begin

                      InvGTot:=ConvCurrITotal(LInv,BOff,BOn,BOn);

                      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                      InvDisc:=Conv_TCurr(InvDisc,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

                      InvLDisc:=Conv_TCurr(InvLDisc,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

                    {$IFDEF MC_On} {* Only posts on MC Version when Currency Zero *}


                        LUpdateBal(LInv,(InvGTot*DocCnst[InvDocHed]*DocNotCnst),
                                       (ConvCurrICost(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                       (ConvCurrINet(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                       BOff,(0+Ord(Not Syss.UpBalOnPost)));

                        {$IFDEF EX601} {*Implement post V6*}
                          InvGtot:=InvGTot-Round_Up(LInv.ReValueAdj,2); {* v6.01. Ignore effects of revaluation inside header so original values get reposted. Rely on reval journal to bring in rev effect *}

                        {$ENDIF}

                    {$ENDIF}

                    
                    end;


                    {$IFDEF MC_On}

                    {$ELSE}   {* On Single Currency Post Cust Bal here, as loop only runs once with AutoLZ True *}

                      LUpdateBal(LInv,(InvGTot*DocCnst[InvDocHed]*DocNotCnst),
                                     (ConvCurrICost(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                     (ConvCurrINet(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                                     BOff,(0+Ord(Not Syss.UpBalOnPost)));

                    {$ENDIF}

                  Until (AutoLZ);
                end; {If NOM with VAT only}

              end {*If Nom TXfr..*}
              else
                VATTot:=0.0;

                {Post_Details(FolioNum,PRunNo,VYr,VPr,IGEquiv,BOff);}


              { ========== Post any Differences Due to Currency Rounding Problems ======= }


              If (Syss.NomCtrlCodes[UnRCurrVar]>0) then
              Begin
                If (Not (InvDocHed In DirectSet)) then               {* Round_up Neccesary as otherwise tiny inaccuracies
                                                                        <.001 cause 0 error *}
                  IGEquiv:=Round_Up(((InvGTot*DocCnst[InvDocHed])-
                            (ItotEqL((IGEquiv*DocCnst[InvDocHed]),VATTot,InvLDisc,InvDisc,0.0)*DocCnst[InvDocHed])),2)
                else
                  IGEquiv:=ItotEqL((IGEquiv*DocCnst[InvDocHed]),VATTot,InvLDisc,InvDisc,0.0)*DocCnst[InvDocHed]*DocNotCnst;


                Post_To_RunCtrl(Syss.NomCtrlCodes[UnRCurrVar],PRunNo,0,HistCr,AcYr,AcPr,CXRate,IGEquiv,PostMultiRunCtrl,
                                UseCCDep,PostCCDep,LInv);
              end;



              RunNo:=PRunNo;


              {$IFDEF JC}
                Set_DocCISDate(LInv,BOff);
              {$ENDIF}

              {If (Not Debug) then}
                LStatus:=LPut_Rec(Fnum,Keypath);

              LReport_BError(Fnum,LStatus);

              If (PRunNo<>0) and (TTEnabled) then {* Update it for each post under protected mode*}
//                InitPostingSumm(PostSummary,BOn);
                // CJS - 18/04/2011: ABSEXCH-11252 - Posting Run performance enhancements
                UpdatePostingSummary(PostSummary, LInv.InvDocHed);



              If (Not AbortTran) then
                AbortTran:=(Not LStatusOk) and (TTEnabled);

              B_Func:=B_GetGEq;

              If (TTEnabled) and (Syss.ProtectPost) then
              With MTExLocal^ do
              Begin
                UnLockHistLock;
                
                LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

                LReport_BError(InvF,LStatus);

                If (AbortTran) then
                  B_Func:=B_GetNext;

                If (Not HaveAborted) then
                  HaveAborted:=AbortTran;

                AbortTran:=BOff;
              end;

              {* Check if it is an auto reversing journal *}

              If (InvDocHed=NMT) and (PrePostFlg=0) and (UnTagged) then
                AutoReverseNom(Fnum,Keypath,LInv,LastRecAddr[Fnum]);

            end
            else
              HaveAborted:=BOn;

            LStatus:=LUnLockMLock(Fnum);
            {B_Func:=B_GetNext; {************ For De-bugging purposes only when putrec has been diabled ************* }
          end {If not locked}
          else
          Begin
            Write_PostLogDD(LInv.OurRef+' not posted due to record being locked.',BOn,LInv.OurRef,0);

          end;


        end; {If Doc Not Suitable for Posting..}
        {else {* Un lock it! *
          LStatus:=LUnLockMLock(Fnum);}

      end; {If Not Found/Locked..}

      LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,DocKey);
    end; {While..}

    If (AutoRecover) then
    Begin
      ShowStatus(1,'Finishing Run No.: '+Form_Int(PRunNo,0));
    end;

    {* v5.6 Reset progress so we can keep the progress going during the ctrl line generation *}

    InitProgress(ItemCtrlCount);

    UpdateProgress(0);


    ShowStatus(2,'Generating Posting Report');

    If (ThreadRec^.ThAbort) then
      ShowStatus(3,'Aborting...');

    If (Not HaveAborted) then
      Post_CtrlDetails(PRunNo,AutoRecover);

    If (PRunNo<>0) then
      InitPostingSumm(PostSummary,BOn);


    {* Start print job thread *}

      If (PRunNo<>0) then
      Begin
        {$IFDEF Rp}

          PostRepCtrl^.PostSummary:=PostSummary;

          AddPostRep2Thread(2,PRunNo,0,PostRepCtrl,BOff,fMyOwner);

        {$ENDIF}

        ThisPRunNo:=PRunNo;
      end;


  end; {With..}

end; {Proc..}


{$IFDEF SOP}
  { == Proc to Remove all previous commitment postings == }

  Procedure TEntPost.Remove_LastCommit;

  Const
    GLNHCodes  :  Array[0..4] of Char = (StkBillCode,NomHedCode,PLNHCode,BankNHCode,CtrlNHCode);

  Var
    n     :  Byte;
    KeyS  :  Str255;

  Begin
{$IFDEF EXSQL}
    if SQLUtils.UsingSQLAlternateFuncs then
    begin
      ShowStatus(2,'Removing Previous Commitment Values');
      // CJS 2011-08-04 ABSEXCH-11373 - Added Client ID to call
//      SQLUtils.RemoveLastCommit(SetDrive, MTExLocal^.ExClientId);
      //PR 27/06/2017 ABSEXCH-18860 Changed to call stored proc directly so
      //timeout can be set
      SQLRemoveLastCommit;
    end
    else
{$ENDIF}
    With MTExLocal^ do
    Begin
      ShowStatus(2,'Removing Previous Commitment Values');

      KeyS:=CommitKey;

      For n:=Low(GLNHCodes) to High(GLNHCodes) do {Remove History}
      Begin
        LDeleteLinks(GLNHCodes[n]+KeyS,NHistF,Succ(Length(KeyS)),NHK,BOff);

        If (Has_Aborted) then
          Break;
      end;

      Blank(KeyS,Sizeof(KeyS));

      KeyS:=FullNomKey(CommitOrdRunNo);

      If (Not Has_Aborted) then
        LDeleteLinks(KeyS,IdetailF,Length(KeyS),IdRunK,BOff);

    end; {With..}
  end;


  Procedure TEntPost.Post_Commited(CrDr    :  DrCrDType;
                                   CMode,
                                   DPr,DYr :  Byte);


  Var
    TTEnabled,
    Loop  :  Boolean;
    OldCM :  Byte;



  Begin
    With MTExLocal^,LId do
    Begin
      OldCM:=CommitMode;
      CommitMode:=CMode;

      If (TranOk2Run) then
      Begin
        LStatus:=LCtrl_BTrans(1);

        TTEnabled:=LStatusOk;

        {* Wait until All clear b4 continuing *}
        If (TTEnabled) then
          WaitForHistLock;

      end
      else
        TTEnabled:=BOff;

      LPost_To_Nominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],0,Currency,DYr,DPr,1,BOff,BOn,BOff,CXRate,PreviousBal,NomCode,UseORate);


      Loop:=BOff;

      If (Syss.PostCCNom) and (Syss.UseCCDep) then
      Begin
        Repeat
          If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
          Begin

            LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],0,Currency,PYr,PPr,1,BOff,BOn,BOff,
                              CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);

            {* Post to combination *}
            If (Syss.PostCCDCombo) then
              LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],0,Currency,PYr,PPr,1,BOff,BOn,BOff,
                              CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate); {* EN440CCDEP *}

          end;

          Loop:=Not Loop;

        Until (Not Loop);
      end;

      If (TTEnabled) and (Syss.ProtectPost) then
      With MTExLocal^ do
      Begin
        UnLockHistLock;

        LStatus:=LCtrl_BTrans(0+(2*Ord(AbortTran)));

        LReport_BError(IdetailF,LStatus);

        {$IFDEF EXSQL}
        if not SQLUtils.UsingSQL then
        {$ENDIF}
        ThreadDelay(600,BOff); {* This delay seemed necessary in order to give other ws a chance to issue system transactions *}

        If (Not AbortLines) then
          AbortLines:=AbortTran;

        AbortTran:=BOff;

      end;

      CommitMode:=OldCM;

    end; {With..}
  end;


  Procedure TEntPost.Post_CommitOrd;

  Const
    Fnum     =  IdetailF;
    Keypath  =  IdAnalK;
    Keypath2 =  IdRunK;
    Keypath3 =  IdFolioK;

    IFnum    =  InvF;
    IKeypath1=  InvOurRefK;
    IKeypath2=  InvRNoK;

    DocFilt  :  Array[BOff..Bon] of DocTypes = (SOR,POR);

    GLNCC    :  Array[BOff..BOn] of NomCtrlType = (SalesComm,PurchComm);


  Var
    Loop,
    AutoLZ   :  Boolean;

    HistCr,
    UOR,
    DYr,DPr  :  Byte;
    IKeypath,
    TmpKPath,
    TmpStat  :   Integer;

    Count,
    GenCount,
    GLNomCode,
    TmpRecAddr
             :  LongInt;
    KeyI,
    KeyS1,
    KeyIChk,
    KeyChk  :  Str255;

    LineValue
            :  Double;

    CrDr    :  DrCrDType;


  {Generate run time line for individual commitment}

  Procedure Post_LineToCommited(KRest  :  Integer);
  Begin
    With MTExLocal^, LId do
    Begin
      TmpKPath:=KRest;

      LastId:=LId;
      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      LineValue:=InvLOOS(LId,BOn,0.0)*DocCnst[IdDocHed];

      If (LInv.FolioNum<>FolioRef) then
      Begin
        KeyI:=FullNomKey(FolioRef);

        LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,KeyI);

        If (Not LStatusOk) then
          LResetRec(InvF);
      end;

      HistCr:=Currency;

      //AutoLZ:=(Currency<>0);  { IF Not MC Version then Only Post Ctrl Accounts Once }

      AutoLZ:=BOff;

      If (PDate='') then
        PDate:=LInv.DueDate;

      LDate2Pr(PDate,DPr,DYr,MTExLocal);

      If (LineValue<>0.0) then
      Repeat
        GenCount:=GenCount+2;

        Post_To_RunCtrl(NomCode,CommitOrdRunNo,0,HistCR,DYr,DPr,CXRate,LineValue,
                          BOn,Syss.UseCCDep,CCDep,LInv);

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        LId:=LastId;

        Post_To_RunCtrl(GLNomCode,CommitOrdRunNo,0,HistCR,DYr,DPr,CXRate,LineValue*DocNotCnst,
                          Syss.SepRunPost,Syss.UseCCDep,CCDep,LInv);

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        LId:=LastId;

        HistCr:=0;

        AutoLZ:=Not AutoLZ;

        {$IFDEF MC_On}

          If (Not AutoLZ) then
          Begin
            UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

            LineValue:=Conv_TCurr(LineValue,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

          end;
        {$ENDIF}

      Until (AutoLZ) or (Has_Aborted);

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    end; {If not o/s}

  end;


  Begin
    Remove_LastCommit;

    UOR:=0;  Count:=0;  GenCount:=0;
    Blank(CrDr,Sizeof(CrDr));

    With MTExLocal^ do
    Begin

      ShowStatus(2,'Generating Commitment Audit');

      InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));

      UpdateProgress(Count);


      Loop:=(Not (SOR In PostRepCtrl^.IncDocFilt));

      Repeat
        KeyChk:=StkLineType[DocFilt[Loop]];

        GLNomCode:=Syss.NomCtrlCodes[GLNCC[Loop]];

        KeyS1:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS1);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS1,Length(KeyChk),BOn)) and (Not Has_Aborted) do
        With LId do
        Begin
          Inc(Count);

          UpdateProgress(Count);

          If (Qty_OS(LId)>0.0) then
            Post_LineToCommited(KeyPath);

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS1);

        end; {While..}

        Loop:=Not Loop;


      Until (Not Loop) or (Has_Aborted) or (Not (POR In PostRepCtrl^.IncDocFilt));

      If (POR In PostRepCtrl^.IncDocFilt) then {Pick up other purchases like delivery notes}
      Begin
        Loop:=BOff;

        KeyIChk:=DocCodes[PDN];
        IKeypath:=IKeypath1;

        GLNomCode:=Syss.NomCtrlCodes[GLNCC[BOn]];

        Repeat
          KeyI:=KeyIChk;

          LStatus:=LFind_Rec(B_GetGEq,IFnum,IKeyPath,KeyI);

          While (LStatusOk) and (CheckKey(KeyIChk,KeyI,Length(KeyIChk),BOn)) and (Not Has_Aborted) do
          With LInv do
          Begin
            If (InvDocHed In CommitLSet) then
            Begin
              KeyChk:=FullNomKey(FolioNum);
              KeyS1:=KeyChk;

              LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath3,KeyS1);

              While (LStatusOk) and (CheckKey(KeyChk,KeyS1,Length(KeyChk),BOn)) and (Not Has_Aborted) do
              With LId do
              Begin
                Inc(Count);

                UpdateProgress(Count);

                If (Qty<>0.0) and (LineNo<RecieptCode) then
                  Post_LineToCommited(KeyPath3);

                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath3,KeyS1);

              end; {While..}
            end; {If..}

            LStatus:=LFind_Rec(B_GetNext,IFnum,IKeyPath,KeyI);

          end; {While..}

          Loop:=Not Loop;


          KeyIChk:=FullNomKey(0)+DocCodes[PIN][1]; {* Now get any unposted purchase transactions which qualify *}

          IKeypath:=IKeypath2;

        Until (Not Loop) or (Has_Aborted);

      end;




      If (Not Has_Aborted) and (GenCount>0) then {* Post run time lines *}
      Begin
        KeyChk:=FullNomKey(CommitOrdRunNo);
        KeyS1:=KeyChk;

        ShowStatus(2,'Posting Commitment Values');

        InitProgress(GenCount);

        Count:=0;

        UpdateProgress(Count);


        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath2,KeyS1);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS1,Length(KeyChk),BOn)) and (Not Has_Aborted) do
        With LId do
        Begin
          Inc(Count);

          UpdateProgress(Count);

          CrDr[BOff]:=NetValue; CrDr[BOn]:=Discount;

          Post_Commited(CrDr,1,PPr,PYr);

          
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath2,KeyS1);
        end; {While..}

        UpdateProgress(GenCount);

      end;

    end; {With..}
  end; {Proc..}


  Procedure TEntPost.Update_LiveCommit(IdR      :  IDetail;
                                       DedMode  :  SmallInt);

  Var
    CrDr      :  DrCrDType;
    LineValue :  Double;
    DYr,DPr   :  Byte;

  Begin
    If (IdR.IdDocHed In CommitLSet) then
    With MTExLocal^,LId do
    Begin
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL and not FLocalFilesOpen then
      begin
        MTExLocal^.Open_System(1,Totfiles);
        FLocalFilesOpen := True;
      end;
      {$ENDIF}
      LId:=IdR;
      Blank(CrDr,Sizeof(CrDr));

      LineValue:=InvLOOS(LId,BOn,0.0)*DocCnst[IdDocHed]*DedMode;

      ShowDrCrD(LineValue,CrDr);

      If (PDate='') or (Not (IdR.IdDocHed In PSOPSet)) then
      Begin
        DPr:=PPR; DYr:=PYr;
      end
      else
        LDate2Pr(PDate,DPr,DYr,MTExLocal);


      Post_Commited(CrDr,2,DPr,DYr);


    end;
  end; {Proc..}


{$ENDIF}


{SS 17/02/2017 2017-R1:ABSEXCH-18134:Incorporate the new Stored Procedures into the Exchequer Daybook Posting Process.}
//Posting using stored procedure is only for Sales/Purchase/Nominal.
function TEntPost.CanPostUsingSQL(Mode : Byte):Boolean;
var
  lHookEnabled : Boolean;
begin
  Result := False;

  //SS 20/03/2017 2017-R1:ABSEXCH-18473:SQL Posting Not Checking for Enabled Hook Points.
  lHookEnabled := False;
  {$IFDEF CU}
  //PR: 21/06/2017 ABSEXCH-18774 Changed to use PostingHookEnabled function as the variables
  //previously being used were only being populated once Process had started so wouldn't give
  //the proper result during the AddPost2Thread procedure. Also removed check of ADJ GL codes
  //override hooks as ADJs aren't posted using the new SQL procedures
  lHookEnabled := PostingHookEnabled;
  {$ENDIF}


  {$IFDEF EXSQL}
   //SS 27/02/2017 2017-R1:ABSEXCH-17704:If printing revaluation report to html, report is overwritten by following posting report.
   //PL 09/03/2017 2017-R1 ABSEXCH-13159: added Mode = 0 for the menu option "post all daybooks"
   Result := (SQLUtils.UsingSQLAlternateFuncs) and
             // MH 04/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
             (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] = psPassed) and
             (Mode in [0,1,2,3]) and (not lHookEnabled);
  {$ENDIF}    
end;

      

{SS 20/02/2017 2017-R1:ABSEXCH-18134:Incorporate the new Stored Procedures into the Exchequer Daybook Posting Process.}
//Prepare posting log for the transactions which are excluded. 
procedure TEntPost.InitPostLog(aRunNo : Integer; aSQLDayBookPosting : TSQLDayBookPosting);
var
  lExculdedList : TStringList;
  lRes,I : Integer;
  lOurRef : String;
begin
  lExculdedList := TStringList.Create;
  try
    lRes := aSQLDayBookPosting.ExecPostRunExclusionReport(aRunNo,lExculdedList);
    if lRes = 0 then
    begin
      for I := 0 to lExculdedList.Count - 1 do
      begin
        lOurRef := lExculdedList.Names[I];
        Write_PostLogDD(lExculdedList.Values[lOurRef],Bon,lOurRef,0);
      end;
    end;
  finally
    lExculdedList.Free;
  end;  
end;

{SS 17/02/2017 2017-R1:ABSEXCH-18134:Incorporate the new Stored Procedures into the Exchequer Daybook Posting Process.
 - Run Daybook Posting usging SQL.}
procedure TEntPost.DayBookPostUsingSQL(PostSet:DocSetType; Mode : Byte);
var
  lPostRunNo : Integer;
  lRes : Integer;
  lSQLDayBookPosting : TSQLDayBookPosting;
  lPostSummary: PostingSummaryArray;
begin
  lPostRunNo := 0;
  lSQLDayBookPosting := TSQLDayBookPosting.Create;
  try
    //SS:22/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
    ShowStatus(0,'Daybook Posting...');

    //SS:31/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
    ShowStatus(2,'Posting in progress...');

    {PL 17/03/2017 2017-R1ABSEXCH-18459: Future period Transactions are get posted for old period.
    ABSEXCH-18496: Transactions are not get posted when 'Disable postings to previous periods' is enabled.
    The reason behind both the issues was passing wrong formate of Year to the stored procedure.}
    lRes := lSQLDayBookPosting.ExecDayBookPost(PostSet,lPostRunNo,GetLocalPr(0).CYr,GetLocalPr(0).CPr,Mode,Ord(Syss.SepRunPost),EntryRec^.LogIn);

    if (lRes = 0) and (lPostRunNo <> 0)  then
    begin
      ShowStatus(1,'Finishing Run No.: '+Form_Int(lPostRunNo,0));


      ShowStatus(2,'Generating Posting Report');

      If (ThreadRec^.ThAbort) then
        ShowStatus(3,'Aborting...');

      Blank(lPostSummary,Sizeof(lPostSummary));
      lRes := lSQLDayBookPosting.ExecPostRunSummaryReport(lPostRunNo,lPostSummary);

      if lRes = 0 then
      begin
         {$IFDEF Rp}
          PostRepCtrl^.PostSummary:=lPostSummary;
          AddPostRep2Thread(2,lPostRunNo,0,PostRepCtrl,BOff,fMyOwner);
        {$ENDIF}
        ThisPRunNo := lPostRunNo;
      end;      
      InitPostLog(lPostRunNo,lSQLDayBookPosting);

    end else
    begin
      //SS:09/06/2017:2017-R1:ABSEXCH-18759:If an error occurs during posting, the error is not returned to Exchequer and depending on the error nothing is posted.
      if lSQLDayBookPosting.ErrorMsg <> EmptyStr then
        Write_PostLogDD(lSQLDayBookPosting.ErrorMsg,Bon,'',0);
    end;
  finally
    lSQLDayBookPosting.Free;
  end;

end;

{ ================ Master Posting Control ============= }

Procedure TEntPost.Control_Posting(Mode  :  Byte);


Var
  PSet,
  lStkAdjSplitPset :  DocSetType;  //PL 10/03/2017 2017-R1 ABSEXCH-18464: handled ADJ externally when user select post all daybooks
  AutoOn,
  PrintToQueue,
  Ok2Post,
  TTEnabled,
  ItemOnQ :  Boolean;

  PostCount
          :  LongInt;

Begin

  Addch:=ResetKey;

  PostCount:=0;

  ItemOnQ:=BOff;
  PrintToQueue:=BOff;
  TTEnabled:=BOff;

  lStkAdjSplitPset := StkAdjSplit;
  
  Ok2Post:=BOn;

  If (Ok2Post) then
  Begin

    {If (fMyOwner is TForm) then {* Disable daybook from closing, as causes GPF if closed during posting... *}
     { SendMEssage(TForm(fMyOwner).Handle,WM_FormCloseMsg,84,0); v4.40, was passing in daybook as owner, but if daybook closed, caused GPF,
     so now passing application.mainform to see if it cures it}

    If (fOwnHandle<>0) then {* v4.40 Disable daybook from closing, as causes GPF if closed during posting... *}
     SendMEssage(fOwnHandle,WM_FormCloseMsg,84,0);


    AutoOn:=(Mode>10);

    If (AutoOn) then
      Mode:=Mode-20;

    GetPostMode(Mode,PSet);

    {$IFDEF CU}  {* Check to see if we have a COS override installed *}
      COSHookEvent:=EnableCustBtns(4000,52);

      {*v5.61. Check to see if we have an ADJ override of G/L Codes *}
      ADJNomHookEvent:=EnableCustBtns(4000,85) or EnableCustBtns(4000,86);

      {* Stop the line date from being resynchronised with the header date if this hook enabled *}
      ProtectLDateEvent:=EnableCustBtns(4000,57);


    {$ENDIF}


    {$IFDEF Pf_On}

      If (AutoOn) then
      Begin
        Post_ItAuto(PSet,PrintToQueue,ItemOnQ,0{Curr_Pno},BOn);

        {$IFDEF Rp}
          {$IFDEF FRM}
             If (Assigned(PostLog)) then
               PostLog.PrintLog(PostRepCtrl,'Posting run omissions and exception log. Run '+Form_Int(ThisPRunNo,0));
          {$ENDIF}
        {$ENDIF}
      end
      else

    {$ENDIF}

      Begin
                   
        If (Addch<>Esc) then  {* Print not Aborted *}
        Begin


          {$IFDEF Pf_On}

          {* Auto Post any Auto Items due with AutoPost set to yes *}

          PrintToQueue:=BOff;

          Post_ItAuto(PSet,PrintToQueue,ItemOnQ,0{Curr_Pno},BOff);

          {$ENDIF}
           //PL 10/03/2017 2017-R1 ABSEXCH-18464: handled ADJ externally when user select post all daybooks
          If (Mode=0) and (ADJ in Pset) and UseSQLPost then
            Post_ItBatch(lStkAdjSplitPSet,PostCount)
          else
            Post_ItBatch(PSet,PostCount);          


          If (Mode<>4) then  {* If Adjustments only, Do not post main Ledgers *}
          Begin
            {SS 20/02/2017 2017-R1:ABSEXCH-18134:Incorporate the new Stored Procedures into the Exchequer Daybook Posting Process.}
            if UseSQLPost then
            begin
            
              {SS 27/02/2017 2017-R1:ABSEXCH-17704:If printing revaluation report to html, report is overwritten by following posting report.
              - DochedType should not be checked when NoIDCheck flag is true.}    

              if PostRepCtrl^.NoIDCheck then
                DayBookPostUsingSQL(PSet,Mode)
              else
              begin
              //PL 10/03/2017 2017-R1 ABSEXCH-18464: handled ADJ externally when user select post all daybooks
                if (Mode=0) and (ADJ in Pset) then
                  PostRepCtrl^.IncDocFilt:= PostRepCtrl^.IncDocFilt-lStkAdjSplitPSet;
				
              {SS:04/05/2017 2017-R1:ABSEXCH-18653:Daybook posting generating Control entries for xQU transactions causing a TB imbalance.
              - Remove SQU and PQU transaction from the list.}

              if (Mode in [0,1,2]) then
                PostRepCtrl^.IncDocFilt:= PostRepCtrl^.IncDocFilt-QuotesSet;
					
                DayBookPostUsingSQL(PostRepCtrl^.IncDocFilt,Mode);
              end;
            end  else
            begin

              Post_It(PSet,Mode,PostCount);

              {$IFDEF SOP}
                If ((SOR In PostRepCtrl^.IncDocFilt) or (POR In PostRepCtrl^.IncDocFilt)) and (CommitAct) then  {* Post commitments*}
                  Post_CommitOrd;

              {$ENDIF}

              {*EX32 If (ItemOnQ) then
                PopAnyKey(2,BotW,'Automatic transactions have been posted. Check Print Queue.'); *}

              {$IFDEF XRp}

                {*EX32 }

                Print_EndControl;

              {$ENDIF}
            end;
          end;

          {$IFDEF Rp}
            {$IFDEF FRM}

               If (Assigned(PostLog)) then
                 PostLog.PrintLog(PostRepCtrl,'Posting run omissions and exception log. Run '+Form_Int(ThisPRunNo,0));

            {$ENDIF}
          {$ENDIF}


        end; {If Printout aborted}
      end;


  end;
end; {Proc..}





Function TEntPost.Start(LMode  :  Byte;
                        RPParam:  TPrintParamPtr;
                        PostParam
                               :  PostRepPtr;
                        Ask    :  Boolean)  :  Boolean;
Var
  mbRet        :  Word;
  LiveCommit   :  Boolean;

Begin
  //If post has been kicked off from Revaluation then we don't want to use
  //process lock - finish will start CheckAllAccounts which will release
  //Revaluation process lock

  //PR: 24/07/2017 ABSEXCH-18986 Need to check that PostParam is assigned
  if Assigned(PostParam) then
  begin
    if not PostParam.AfterRevaluation then
      ProcessLockType := plDaybookPost;
  end
  else
    ProcessLockType := plDaybookPost;

  PostMode:=LMode;

  {$IFDEF SOP}

    LiveCommit:=(LMode=50) and (CommitAct);

  {$ELSE}

    LiveCommit:=BOff;

  {$ENDIF}

  If (Ask) and ((Assigned(RPParam)) or (LiveCommit)) then {Only prompt if we are not asking for a printer as we can cancel the job via the printer}
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('Please Confirm you wish to Post.',mtConfirmation,[mbYes,mbNo],0);

    Result:=(mbRet=mrYes);

    Set_BackThreadMVisible(BOff);

  end
  else
    Result:=BOn;

  {$IFDEF FRM}
    {$IFDEF Rp}
      If (Result) and (Not LiveCommit) then
        With PostRepCtrl^.PParam do
        Begin
          If (Assigned(RPParam)) and (RPParam<>nil) then {* Set printer remotely *}
          Begin
            PDevRec:=RPParam^.PDevRec;
            UFont.Assign(RPParam^.UFont);
            Orient:=RPParam^.Orient;
          end
          else
          Begin
            Set_BackThreadMVisible(BOn);

            Result:=pfSelectPrinter(PDevRec,UFont,Orient);

            Set_BackThreadMVisible(BOff);
          end;

          If (Assigned(PostParam)) then
          begin
            PostRepCtrl^.IncDocFilt:=PostParam^.IncDocFilt;

            //PR: 24/05/2016 ABSEXCH-17450
            PostRepCtrl^.AfterRevaluation := PostParam^.AfterRevaluation;
            PostRepCtrl^.NoIdCheck := PostParam^.NoIdCheck;
          end
          else
            PostRepCtrl^.NoIdCheck:=BOn;

        end;

    {$ENDIF}
  {$ENDIF}


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
    If (LiveCommit) then
    Begin
      If (Not Assigned(LCommitExLocal)) then { Open up files here }
        Result:=Create_LiveCommitFiles;

      If (Result) then
        MTExLocal:=LCommitExLocal;
    end
    else
    Begin
      begin
        If (Not Assigned(PostExLocal)) then { Open up files here }
          Result:=Create_ThreadFiles;

        If (Result) then
          MTExLocal:=PostExLocal;

      end;
    end;


    If (Result) then {* Check if we can lock it *}
    With MTExLocal^, PostRepCtrl^ do
    Begin
      If (Not LiveCommit) then
      Begin
        Result:=PostLockCtrl(LMode);

        If (Result) then
          LastRunNo:=CheckAbortedRun;

        If (LastRunNo<>0) and (Syss.ProtectPost) and (Result) then
        With LMiscRecs^,MultiLocRec do
        Begin
          ShowMessage('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                      'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC+#13+#13+
                      'Attempting to complete this posting run now.');

          AddErrorLog('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                      'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC,'',4);
        end;
      end;

      If  (Result) then
      Begin
        If (Syss.ProtectPost) and (BTFileVer>=6) then
        Begin
          { CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
          {
          If (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(1)
          else
          }
            LStatus:=0;

          TranOk2Run:=LStatusOk or (LStatus=37) {* Is already running *};

          If (Not TranOk2Run) then
          Begin
             AddErrorLog('Posting Run. Protected Mode could not be started. (Error '+Form_Int(LStatus,0)+')','',4);

             LReport_BError(InvF,LStatus);

             Result:=(CustomDlg(Application.MainForm,'WARNING!','Posting Transactions',
                             'It was not possible to start Protected Mode Posting due to an error. '+
                             Form_Int(LStatus,0)+'.'#13+
                             'Do you wish to continue posting without Protected Mode?',
                             mtWarning,
                             [mbYes,mbNo]
                             )=mrOk);


          end;

          { CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
          {
          If (LStatusOk) and (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(0);
          }

        end;

        If (Result) and Not (LiveCommit) then {* Check for valid NCC *}
        Begin
          {$IFDEF EXSQL}
           if SQLUtils.UsingSQL and not Ask and Assigned(RPParam) and Assigned(MTExLocal) then
             Result := MTExLocal.LCheckValidNCC(CommitAct)
           else
          {$ENDIF}
            Result:=CheckValidNCC(CommitAct);

          If (Not Result) then
          Begin
            AddErrorLog('Post Transactions. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

            CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                           'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                           'Posting cannot continue until this problem has been rectified.'+#13+#13+
                           'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                           mtError,
                           [mbOk]);


          end;

        end;

        If (Not Result) then {* Remove lock... *}
          PostUnLock(0);

      end
      else
        TranOk2Run:=BOff;

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

{== LModes == }

{0 = Post 1-4 & 21-24
 1 = Sales,
 2 = Purchase
 3 = Nom
 4 = Adj

 9 = Job Daybook

 20    = Post all Auto Daybboks
 21-24 = Auto Daybook version of 1-4
}

Function TEntPost.PostLockCtrl(Const LMode  :  Byte)  :  Boolean;

Const
  LockSet  :  Set of Byte = [1..4,9,21..24];

Var
  n,ns,ne  :  Byte;

Begin
  { CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
  Result := Create_LockLocal;
  LockApplied:=Result;

  Case LMode of

    0  :  Begin
            ns:=1; ne:=High(LLockAddr);
          end;
   20  :  Begin
            ns:=21; ne:=High(LLockAddr);
          end;

   //PR: 18/02/2016 v2016 R1 FIX_WARNINGS Changed to set ns/ne to 1 - not sure what effect that will have but better
   //                                     than overwriting random memory. Don't believe 255 is ever be used as LMode
   255 :  begin
            ns := 1; ne := 1;
          end;  {* Reserved for Hist Lock *}

   else   Begin
            ns:=LMode; ne:=LMode;
          end;

  end; {Case..}


  For n:=ns to ne do       {* Exclude JC from all lock mode *}
    If (n In LockSet) and ((n<>9) or (LMode<>0)) then
    Begin
      Result:=PostLock(n,LLockAddr[n]);

      If (Not Result) then
      Begin
        PostUnlock(0); {* Unlock everything we have locked so far *}
        Exit;
      end;

    end;

  LockApplied:=Result;

end;

{
  Sets up the lock for the specified Daybook Post (see PostLockCtrl() above for
  details of the LMode values).

  This writes or updates a Lock record in EXSTKCHK, and locks it for the
  duration of the Daybook Posting run. It returns False if the record cannot
  be locked.
}
Function TEntPost.PostLock(Const LMode  :  Byte;
                           Var   LAddr  :  LongInt)  :  Boolean;
Const
  Fnum     =  MiscF;
  Keypath  =  MIK;
Var
  KeyS  :  Str255;
  NewRec:  Boolean;
  ThisAddr
        :  LongInt;
  TmpMisc
        :  MiscRec;
Begin
  KeyS:=FullPLockKey(PostUCode,PostLCode,LMode);

  LAddr:=0;

  Result:=BOff;

  { CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
  With LLockLocal^,LMiscRecs^,MultiLocRec do
  Begin

    // Search EXSTKCHK for a lock record for the current posting mode, and
    // attempt to lock it
    LStatus:=LFind_Rec(B_GetEq+B_MultNWLock,Fnum,KeyPath,KeyS);

    If (LStatusOk) then
      LStatus:=LGetPos(Fnum,ThisAddr);

    // If the search succeeded (0), update the record.
    // If a record could not be found (4, 9), add a new record
    // Any other status code indicates some kind of error.
    If (LStatus In [0,4,9]) then
    Begin
      NewRec:=(LStatus<>0);

      If (NewRec) then
      Begin
        LResetRec(Fnum);
        RecMFix:=PostUCode; // 'L'
        SubType:=PostLCode; // 'K'
        MLocC:=PartPLockKey(LMode);
      end;

      LocDesc:=EntryRec^.Login;
      LocFDesc:=DateTimetoStr(Now);

      If (NewRec) then
      Begin
        LStatus:=LAdd_Rec(Fnum,Keypath);

        If (LStatusOk) then
        Begin
          KeyS:=FullPLockKey(PostUCode,PostLCode,LMode);

          LStatus:=LFind_Rec(B_GetEq+B_MultNWLock,Fnum,KeyPath,KeyS);

          If (LStatusOk) then
            LStatus:=LGetPos(Fnum,LAddr);

        end;
      end
      else
      Begin
        TmpMisc:=LMiscRecs^;

        LSetDataRecOfS(Fnum,ThisAddr);

        LStatus:=LGetDirect(Fnum,Keypath,0); {* Re-Establish Position *}

        LMiscRecs^:=TmpMisc;

        LStatus:=LPut_Rec(Fnum,Keypath);

        If (LStatusOk) then
          LAddr:=ThisAddr;
      end;

      LReport_BError(Fnum,LStatus);

      Result:=BOn;

    end
    else
    // Assume that the lock failed, and that therefore some one else is posting
    Begin
      Sleep(500);  {* Wait for .5 secs incase record is still being written *}

      KeyS:=FullPLockKey(PostUCode,PostLCode,LMode);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

      KeyS:='This Ledger is currently being posted ';

      If (LocDesc<>'') then
        KeyS:=KeyS+' by '+Trim(LOCDESC);

      KeyS:=KeyS+' (since '+LOCFDESC+'). Posting Run '+Form_Int(LocRunNo,0);

      ShowMessage(KeyS);

    end; {If lock failed..}
  end;
end;

{
  Unlocks all the Daybook Post lock records for the current posting run.

  Confusingly, this function is also used to simply update the lock records
  with the current run number. If NewRunNo is zero, the records are unlocked,
  otherwise they are simply located and updated.
}
Procedure TEntPost.PostUnLock(NewRunNo  :  LongInt);
Const
  Fnum     =  MiscF;
  Keypath  =  MIK;
Var
  nl  :  Byte;
  Res : Integer;
  MiscFOpened : Boolean;
Begin
  { CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
  With LLockLocal^ do
  Begin
    MiscFOpened := False;
    // Go through the array of record addresses for the locked records
    For nl:=Low(LLockAddr) to High(LLockAddr) do
    If (LLockAddr[nl]<>0) then
    Begin
      LSetDataRecOfS(Fnum,LLockAddr[nl]);

      LStatus:=LGetDirect(Fnum,Keypath,0); {* Re-Establish Position *}

      {
        PR 31/10/2008: This procedure is called when a Posting Job is deleted.
        Not normally a problem but if it is deleted from the OTC queue, then
        (under SQL) the MTExLocal files will have been closed (to be reopened
        when running in the thread), so we need to check the result and re-open
        the lock file if necessary.
      }
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL and (LStatus = 3) then
      begin
        Open_System(FNum, FNum);
        MiscFOpened := True;
        LStatus:=LGetDirect(Fnum,Keypath,0); {* Re-Establish Position *}
      end;
      {$ENDIF}

      // Update the record with the supplied run number
      If (LStatusOk) and (Not AbortTran) and (Not HaveAborted) then {* Reset Current Run No, unless Transaction aborted *}
      With LMiscRecs^,MultiLocRec do
      Begin
        LocRunNo:=NewRunNo;

        LStatus:=LPut_Rec(Fnum,Keypath);

        LReport_BError(Fnum,LStatus);
      end
      else
      Begin
        {$IFDEF DBD}
        ShowMessage('Post Ctrl Rec not reset. BStatus : '+Form_Int(LStatus,0)+'. AbortTran: '+Form_Int(Ord(AbortTran),0)+'. HaveAborted: '+Form_Int(Ord(HaveAborted),0));
        {$ENDIF}
      end;

      // A run number of zero means that we are releasing the locks
      If (NewRunNo=0) then
      Begin
        LStatus:=UnLockMLock(Fnum,LLockAddr[nl]);

        // Ignore lock errors (code 81), but report any other errors
        If (LStatus<>81) then
          LReport_BError(Fnum,LStatus);

        LLockAddr[nl]:=0;
      end;
    end; { For nl:=Low(LLockAddr)... If (LLockAddr[nl]<>0... }
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL and MiscFOpened then
      Close_Files
    {$ENDIF}
  end;
end;

{
  This function is used by the Start() method to check for a previously aborted
  posting run. It is called immediately after calling PostLockCtrl(), which
  locks the Daybook Post Lock records, but before they are updated (via
  PostUnlock()) with the current run number.

  If the records were successfully locked (indicating that no-one else is
  performing the relevant Daybook Posts), but at least one of the locked
  records holds an actual run number, this indicates that a previous Daybook
  Posting run did not complete (i.e. it did not get to the point of clearing
  the lock records).

  This function returns 0 if the records are clear, otherwise it returns the
  run number of the failed posting run.
}
Function TEntPost.CheckAbortedRun  :  LongInt;

Const
  Fnum     =  MiscF;
  Keypath  =  MIK;

Var
  nl  :  Byte;

  TST :  Integer;

Begin
  Result:=0;  TST:=0;

  With MTExLocal^ do
  Begin
    For nl:=Low(LLockAddr) to High(LLockAddr) do
    If (LLockAddr[nl]<>0) then
    Begin

      LSetDataRecOfS(Fnum,LLockAddr[nl]);


      LStatus:=LGetDirect(Fnum,Keypath,0); {* Re-Establish Position *}

      If (LStatusOk) then {* Reset Current Run No. *}
      With LMiscRecs^,MultiLocRec do
      If (SubType=PostLCode) then
      Begin
        Result:=LocRunNo;

        If (Result<>0) then
        Begin
          TST:=Result;
          Break;
        end;
      end;

    end;
  end;

end;



Procedure TEntPost.Process;

Begin
  AlreadyInPost:=TranOk2Run;

  Inherited Process;

  //PR: 27/10/2011 v6.9 Create AuditNote object for auto transactions
  oAuditNote := TAuditNote.Create(EntryRec.Login, @MTExLocal.LocalF[PWrdF], MTExLocal.ExClientId);

  Try
    If (Not IsParentTo) and (PostMode<>50) then {* Stop calling this if we are being decended from *}
    Begin
      ShowStatus(0,'Posting '+Build_Title(PostMode));


      Control_Posting(PostMode);
    end
    else
      If (Not IsParentTo) and (PostMode=50) then {* Stop calling this if we are being decended from *}
      Begin
        {$IFDEF SOP}
          Update_LiveCommit(CommitId,CommitDedMode);
        {$ENDIF}

      end;
  Finally
    //PR: 27/10/2011 v6.9
    if Assigned(oAuditNote) then
      oAuditNote.Free;

  End;
end;


Procedure TEntPost.Finish;
Begin
  Inherited Finish;

  {* Release lock on ledger post *}

  If (Not IsParentTo) or (LockApplied) then
    PostUnLock(0);


  AlreadyInPost:=BOff;

  // CJS 2014-11: Order Payments - Phase 5 - VAT Return
  if (fOwnHandle <> 0) then
  begin
    //PR: 24/05/2016 ABSEXCH-17450 Indicates posting run after a revaluation,
    //                             so post message to main form to start check all accounts
    if PostRepCtrl^.AfterRevaluation then
      PostMessage(fOwnHandle, WM_THREADFINISHED, PID_POSTING_AFTER_REVAL, 0)
    else
      PostMessage(fOwnHandle, WM_CONTINUEVATRETURN, PID_POSTING, 0);
  end;


  {* Getting rid of the posting files here causes problems *}
end;


Procedure TEntPost.AbortfromStart;
Begin
  Inherited AbortfromStart;

  {* Release lock on ledger post, as this is done even while its in the queue *}

  If (Not IsParentTo) or (LockApplied) then
    PostUnLock(0);


  {* Getting rid of the posting files here causes problems *}
end;





Function GlobPostLock(Const LMode  :  Byte)  :  Boolean;

Const
  Fnum     =  MiscF;
  Keypath  =  MIK;

Var
  JDesc,
  KeyS  :  Str255;

  LAddr :  LongInt;

Begin
  KeyS:=FullPLockKey(PostUCode,PostLCode,LMode);

  LAddr:=0;

  If (LMode=9) then
    JDesc:='Job '
  else
    JDesc:='';

  Result:=BOn;

  With MiscRecs^,MultiLocRec do
  Begin

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    If (StatusOk) then {* record found, or not found *}
    Begin
      If (LocRunNo<>0) then {* Is it still being run ? *}
      Begin
        Status:=GetPos(F[Fnum],Fnum,LAddr);

        Status:=Find_Rec(B_GetEq+B_MultNWLock,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        If (StatusOk) then
        Begin
          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          CustomDlg(Application.MainForm,'WARNING!','Posting Transactions',
                             JDesc+'Posting Run '+Form_Int(LocRunNo,0)+' did not finish properly.'+#13+
                             'Please inform user '+Trim(LocDesc)+' and re run the '+JDesc+'posting run immediately so that '+
                             'The system can recover the posting data.'+#13+#13+
                             'Please also make sure you repost with Protected Mode switched ON.',
                             mtError,
                             [mbOk]);

          AddErrorLog(JDesc+'Posting Run '+Form_Int(LocRunNo,0)+' did not finish correctly.'+#13+
                      'The '+JDesc+'posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC,'',4);
          Result:=BOff;
        end;
      end;
    end;
  end;
end;


Function GlobPostLockCtrl(Const LMode  :  Byte)  :  Boolean;

Const
  LockSet  :  Set of Byte = [1..4,9,21..24];

Var
  n,ns,ne  :  Byte;

Begin
  Result:=BOff;

  //PR: 18/02/2016 v2016 R1 FIX_WARNINGS Removed Case LMode statement as this is only ever called with LMode = 0
  ns:=1; ne:=9;


  For n:=ns to ne do    {* Exclude JC from all lock mode *}
    If (n In LockSet)  and ((n<>9) or (LMode<>0)) then
    Begin
      Result:=GlobPostLock(n);

      If (Not Result) then
      Begin
        Exit;
      end;

    end;
end;

{ ======== }


{ ========== TCheckCust methods =========== }

Constructor TCheckCust.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);
  UpdateOldestDebtOnly := False;
  fTQNo:=1;
  fCanAbort:=BOff;

  IsParentTo:=BOn;
end;

Destructor TCheckCust.Destroy;

Begin
  Inherited Destroy;
end;


{$IFDEF STK}
  {$IFDEF PF_On}

     { ====== Function to Return Last Line No ========= }

   Function TCheckCust.LGet_LastLineNo(cc  :  Str20)  :  LongInt;

   Const
     Fnum      =  MLocF;
     Keypath   =  MLK;

   Var
     KeyS,
     KeyChk  :  Str255;

   Begin
     Result:=1;

     KeyChk:=PartCCKey(MatchTCode,MatchSCode)+FullCustCode(cc);

     Keys:=KeyChk+Full_CuStkLKey(cc,65535);

     With MTExLocal^ do
     Begin

       LStatus:=LFind_Rec(B_GetLessEq,Fnum,KeyPath,KeyS);

       If (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
         Result:=LMLocCtrl^.CuStkRec.csLineNo+1;
     end;

     LGet_LastLineNo:=Result;

   end;


   { ============= Procdure to maintain location deductions ============= }

   Procedure TCheckCust.LStock_AddCustAnal(IdR     :  IDetail;
                                           GetSRec :  Boolean;
                                           Mode    :  Byte);


   Const
     Fnum      =  MLocF;
     Keypath   =  MLSecK;
     Fnum2     =  IdetailF;
     Keypath2  =  IdCAnalK;


   Var
     KeyS,
     KeyChk  :  Str255;

     GenStr  :  Str20;
     n       :  Byte;

     OStat,
     OStat2  :  Integer;

     TmpKPath,
     TmpStat
             :  Integer;
     UseNext,
     TmpRecAddr,
     LAddr
             :  LongInt;

     KeepRec,
     NewRec,
     RunOk,
     Locked  :  Boolean;

     OldId   :  Idetail;


   Begin

     Locked:=BOff;

     
     OStat:=Status;

      RunOk:=BOn;

     With MTExLocal^ do
     Begin
       OldId:=LId;

       If (Not EmptyKey(IdR.CustCode,CustKeyLen)) and (Is_FullStkCode(IdR.StockCode)) and (AnalCuStk)
          and (Not (IdR.IdDocHed In QuotesSet)) and (IdR.LineNo>0) and (RunOk) then
       Begin

         KeepRec:=BOff;

         With IdR do
           KeyChk:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(CustCode,StockCode);

         LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

         NewRec:=(LStatus=4) and (Mode<>1);

         If ((LStatusOk) or (NewRec))  then
         With IdR do
         Begin

           If (NewRec) then
           With LMLocCtrl^,CuStkRec do
           Begin
             RunOk:=BOn;
             Locked:=BOn;

             UseNext:=LGet_LastLineNo(CustCode);

             LResetRec(Fnum);

             RecPFix:=MatchTCode;

             SubType:=MatchSCode;

             csLineNo:=UseNext;

             csCode1:=Full_CuStkLKey(CustCode,csLineNo);
             csCode2:=Full_CuStkKey(CustCode,StockCode);
             csCode3:=Full_CuStkKey2(CustCode,StockCode);

             csCustCode:=CustCode;
             csStockCode:=StockCode;

             If (GetSRec) and (LStock.StockCode<>StockCode) then
             Begin
               LGetMainRecPos(StockF,StockCode);

             end;

             csStkFolio:=LStock.StockFolio;
             //HV 02/12/2015, JIRA-15768, On Telesales Screen defaulting line-type value based on selected Stock Code
             csLineType:=LStock.StkLinkLT;


           end
           else
             RunOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked);

           If (RunOk) and (Locked) then
           With LMLocCtrl^,CuStkRec do
           Begin
             LGetRecAddr(Fnum);

             If (Mode=1) then {* its a deduct check if any other lines have it, else delete it *}
             Begin
               TmpKPath:=GetPosKey;

               TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],TmpRecAddr,BOff,BOff);

               KeyChk:=LineType+Full_CuStkKey(CustCode,StockCode);

               KeyS:=KeyChk;

               LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS);

               KeepRec:=(LStatusOk) and (CheckKey(KeyS,KeyChk,Length(KeyChk),BOff)) and
                        (FullRunNoKey(IdR.FolioRef,IdR.AbsLineNo)<>FullRunNoKey(LId.FolioRef,LId.AbSLineNo));

               TmpStat:=LPresrv_BTPos(Fnum2,TmpKPath,LocalF^[Fnum2],TmpRecAddr,BOn,BOff);

               LId:=OldId;
             end
             else
               KeepRec:=BOn;


             If (KeepRec) then
             Begin
               If (Mode<>1) and (IdDocHed In SalesSplit-CreditSet) then
               Begin
                 csLastDate:=PDate;
                 csLPCurr:=Currency;

                 If (LStock.CalcPack) then
                   QtyMul:=1;


                 Qty:=1;

                 csLastPrice:=DetLTotal(IdR,BOn,BOff,0.0)*DocNotCnst;

               end;

               If (NewRec) then
                 LStatus:=LAdd_Rec(Fnum,KeyPath)
               else
               Begin
                 LStatus:=LPut_Rec(Fnum,KeyPath);


                 OStat2:=LUnLockMLock(Fnum);
               end;

             end
             else
             Begin

               LStatus:=LDelete_Rec(Fnum,KeyPath);

             end;

             LReport_BError(Fnum,LStatus);

           end;
         end; {With..}

       end; {If no cust, or stock code}

       LId:=OldId;

       LStatus:=OStat;
     end; {With..}
   end; {Proc..}

  Procedure TCheckCust.cu_DeleteHistory(CCode     :  Str20;
                                        UseReset  :  Boolean);

    Var
      KeyChk  :  Str255;

    Begin
      With MTExLocal^ do
      Begin

        Blank(KeyChk,Sizeof(KeyChk));

        KeyChk:=CuStkHistCode+FullCustCode(CCode);

        {* Remove posted history *}

        LDeleteAuditHist(KeyChk,Length(KeyChk),UseReset);


        {* Remove CC/Dep history *}

        KeyChk:=CuStkHistCode+#1+FullCustCode(CCode);


        LDeleteAuditHist(KeyChk,Length(KeyChk),UseReset);


        {* Remove Loc history *}

        KeyChk:=CuStkHistCode+#2+FullCustCode(CCode);


        LDeleteAuditHist(KeyChk,Length(KeyChk),UseReset);

      end; {With..}

    end;


    Procedure TCheckCust.cu_DeleteCStkHistory(CCode    :  Str20;
                                              SFolio   :  LongInt;
                                              UseReset :  Boolean);

    Var
      KeyChk  :  Str255;

    Begin
      With MTExLocal^ do
      Begin


        Blank(KeyChk,Sizeof(KeyChk));

        KeyChk:=CuStkHistCode+Full_CuStkHKey1(CCode,SFolio);

        {* Remove posted history *}

        LDeleteAuditHist(KeyChk,Length(KeyChk),UseReset);



        {* Remove CC/Dep history *}

        KeyChk:=CuStkHistCode+#1+Full_CuStkHKey1(CCode,SFolio);


        LDeleteAuditHist(KeyChk,Length(KeyChk),UseReset);



        {* Remove Loc history *}

        KeyChk:=CuStkHistCode+#2+Full_CuStkHKey1(CCode,SFolio);


        LDeleteAuditHist(KeyChk,Length(KeyChk),UseReset);

      end;
    end;


    Procedure TCheckCust.cuStk_CheckHist(CCode        :  Str20;
                                         IsaC         :  Boolean);


    Const
      Fnum      =  IdetailF;
      Keypath   =  IdCAnalK;

      Fnum2     =  MLocF;
      Keypath2  =  MLSecK;

    Var
      KeyChk,KeyS,
      KeyS2,KeyChk2  :  Str255;

      LType          :  Char;

      ChkRun         :  LongInt;

    Begin
      ChkRun:=0;

      With MTExLocal^ do
      Begin
        cu_DeleteHistory(CCode,BOn);

        Blank(KeyChk,Sizeof(KeyChk));

        If (IsaC) then
          LType:=StkLineType[SIN]
        else
          LType:=StkLineType[PIN];


        KeyChk:=LType+FullCustCode(CCode);

        KeyS:=LType+Full_CuStkKey(CCode,#33); {*Get past blanks}


        LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With LId do
        Begin

          If (Is_FullStkCode(LId.StockCode)) and (LineNo>0) then
          Begin

            KeyChk2:=PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(CustCode,StockCode);

            LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyChk2);

            If (Not LStatusOk) then {* Add Entry - If you want the last date/price paid updated,
                                                  remove check and let it sort itself out *}
              LStock_AddCustAnal(LId,BOn,0);

            If (PostedRun=0) and (NetValue=0.0) and (Qty<>0.0) then
            Begin
              KeyS2:=FullNomKey(FolioRef);

              LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,KeyS2);

              If (LStatusOk) then
                ChkRun:=LInv.RunNo
              else
                ChkRun:=PostedRun;
            end
            else
              ChkRun:=PostedRun;

            If (ChkRun>0) then
              Ctrl_CuStkHist(LId,1);

          end;


          LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);

        end;


        UpdateProgress(5);

      end; {With..}
    end;

  {$ENDIF}
{$ENDIF}




{ ============ Procedure to Scan a Customer Rec & Re-calc the Balance,
               Calc oldest debt, & optionaly unallocated the docs ============ }

Procedure TCheckCust.Check_Cust(CCode   :  Str10;
                                Auto,
                                ReCalc  :  Boolean;
                                CFnum,
                                CKeyPAth:  Integer);


Type
  tMDCList  =  Array[0..999] of LongInt;
  ptMDCList =  ^tMDCList;

Const
  Fnum    =  InvF;
  KeyPath =  InvCustK;

Var
//PR: 05/01/2015 ABSEXCH-15961 Removed Unallc variable as part of separating unallocate from check
  WarnAbort,
  Locked,
  LOk,
  Ok2Match:  Boolean;

  KeyS,
  ScanKey :  Str255;
  OldDate :  LongDate;
  KeyLen  :  Integer;
  Bos     :  Real;
  UOR,
  n       :  Byte;

  MDCList : ptMDCList;


Procedure  AddToMDCList(CNom  :  LongInt);

Var
  nl       :  LongInt;
  FoundList:  Boolean;

Begin
  FoundList:=BOff;

  For nl:=1 to High(MDCList^) do
  Begin
    FoundList:=CNom=MDCList^[nl];

    If (FoundList) or (MDCList^[nl]=0) then
      Break;

  end;

  If (Not FoundList) and (nl<=High(MDCList^)) then
    MDCList^[nl]:=CNom;


end;



Procedure PrimeMDCHist;

Var
  nl,nm  :  LongInt;

Begin
  For nl:=Low(MDCList^) to High(MDCList^) do
  Begin
    If (nl>0) and (MDCList^[nl]=0) then {* we have reached the end of the list *}
      Break;

    For nm:=1 to 3 do
      MTExLocal^.Prime_To_CYTDHist(CustHistAry[nm],FullNCode(Ccode)+FullNomKey(MDCList^[nl]),0,Syss.AuditYr,YTD);


  end;

end;



Begin
  KeyS:=FullCustCode(Ccode);

  OldDate:=Today;  Bos:=0;

  Ok2Match:=BOff; UOR:=0;

  WarnAbort:=BOff;

  MDCList:=nil;


  If (Not AllAccounts) then
    InitProgress(4+Ord(AnalCuStk));

  With MTExLocal^ do
  Begin

    LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,CKeyPAth,CFnum,BOn,Locked);

    If (LOk) and (Locked) then
    Begin
      New(MDCList);

      FillChar(MDCList^,Sizeof(MDCList^),0);


      LGetRecAddr(CFnum);

      ShowStatus(2,dbFormatName(LCust.CustCode,LCust.Company));

      If (ReCalc) and (Not UpdateOldestDebtOnly) then
        For n:=1 to 3 do
        Begin
          {LDeleteLinks(FullNHistKey(CustHistAry[n],Ccode,0,0,0),NHistF,Succ(CustKeyLen),NHK,BOff);}
          {Altered to multiple Dr/Cr accounts get reset too }
          {LDeleteLinks(CustHistAry[n]+FullNCode(Ccode),NHistF,Succ(CustKeyLen),NHK,BOff);}
          {* Changed so only deletes up to last purge *}
          LResetAuditHist(CustHistAry[n]+FullNCode(Ccode),Succ(CustKeyLen));

          Prime_To_CYTDHist(CustHistAry[n],FullNCode(Ccode),0,Syss.AuditYr,YTD);

        end;


      If (Not AllAccounts) then
        UpdateProgress(1);

      KeyS:=FullCustCode(Ccode);

      ScanKey:=KeyS;

      KeyLen:=Length(KeyS);

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,ScanKey);

      While (LStatusOk) and (CheckKey(KeyS,ScanKey,KeyLen,BOff)) do
      With LInv do
      Begin
        If (Not WarnAbort) and (Has_Aborted) then
        Begin
          ShowStatus(3,'Please Wait, finishing this account.');

          WarnAbort:=BOn;
        end;

        If (Not (InvDocHed In QuotesSet+PSOPSet+WOPSplit+JAPSplit+StkRetSplit)) then
        Begin
          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,ScanKey,KeyPAth,Fnum,BOn,Locked);

          If (LOk) and (Locked) then {v5.52. Moved individual lock to only happen if we need it, as otherwise if a transaction is
                                     being edited by anotheruse whilst check is in operation, you get a deadlock situation}
          Begin

            LGetRecAddr(Fnum);

            Bos:=(ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst);

            {* Note Auto Items are automaticly excluded from here because they are not on the index *}
            {* 01/11/96 - Not True *}

            If (ReCalc) and ((RunNo>0) or (Not Syss.UpBalOnPost)) and (NomAuto) and (Not UpdateOldestDebtOnly) then
            Begin
              CustLockOn:=BOn; {* Stop updatebal from unlocking cust record at this point *}

              LUpdateBal(LInv,Bos,
                            (ConvCurrICost(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                            (ConvCurrINet(LInv,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                            BOff,(0+(2*Ord((RunNo=0)))));

              CustLockOn:=BOff;

              If (LInv.CtrlNom<>0) then {Keep track of the MDC Codes}
                AddToMDCList(LInv.CtrlNom);
            end;

(*            If (Unallc) and (Not (InvDocHed in DirectSet)) and ((Not ReValued(LInv))) then
            Begin

              Settled:=0;

              CurrSettled:=0;

              If (AfterPurge(AcYr,0)) then {* v4.32 don't reset this on purged year transactions *}
                CXRate[BOff]:=0;

              Ok2Match:=(RemitNo<>'');  {* Has Doc got auto Match Lines *}

              FillChar(RemitNo,Sizeof(RemitNo),0);

              If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* Cash Accounting set Blank VATdate &
                                                                    Until Date *}
              Begin
                If (SettledVAT=0) then
                Begin

                  FillChar(VATPostDate,Sizeof(VATPostDate),0);

                  UntilDate:=NdxWeight;

                  {FillChar(UntilDate,Sizeof(UntilDate),0);}

                end
                else
                Begin

                  VATPostDate:=SyssVAT.VATRates.CurrPeriod;

                  UntilDate:=Today;

                end;
              end
              else
                UntilDate:=NdxWeight;

              CustSupp:=LCust.CustSupp;

              If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
                CustSupp:=Chr(Succ(Ord(CustSupp)));


              {$IFDEF JC}
                Set_DocCISDate(LInv,BOn);
              {$ENDIF}

              Set_DocAlcStat(LInv);  {* Set Allocation Status *}



              LStatus:=LPut_Rec(Fnum,KeyPath);

              If (LStatusOk) then
                LStatus:=LUnLockMLock(Fnum);

            {$IFDEF CL_On}

              If (LStatusOk) then
              Begin
                LRemove_MatchPay(LInv.OurRef,DocMatchTyp[BOff],MatchSCode,Not Ok2Match);  {* Delete Auto Account match lines *}

                LRemove_MatchPay(LInv.OurRef,DocMatchTyp[BOn],MatchSCode,Ok2Match);  {* Delete Artificial match lines from batch payments*}

              end;

            {$ENDIF}

            end
            else *)
              If ((InvDocHed In DirectSet) and (SBSIn) and (BaseTotalOS(LInv)<>0)) and (Not UpdateOldestDebtOnly) then {* Direct faulty *}
              Begin

                Settled:=ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst;

                CurrSettled:=ITotal(LInv)*DocCnst[InvDocHed]*DocNotCnst;  {**** Full Currency Value Settled ****}

                CXRate[BOff]:=SyssCurr.Currencies[Currency].CRates[BOff];

                LStatus:=LPut_Rec(Fnum,KeyPath);

                If (LStatusOk) then
                  LStatus:=LUnLockMLock(Fnum);

              end
                else
                Begin
                  If (AllocStat<>#0) and (UntilDate='') and (Not UpdateOldestDebtOnly) then
                  Begin
                    UntilDate:=NDXWeight;

                    LStatus:=LPut_Rec(Fnum,KeyPath);

                    LReport_BError(Fnum,LStatus);

                  end;

                  LStatus:=LUnLockMLock(Fnum);

                end;


            {$B-}

            If ((DueDate<>'') and (DueDate<OldDate) and (BaseTotalOs(LInv)*DocCnst[InvDocHed]*DocNotCnst>0))
            and (InvDocHed In SalesSplit+PurchSplit-RecieptSet-CreditSet) then

              OldDate:=DueDate;

            {$B+}


            LReport_BError(Fnum,LStatus);

          end; {If not Locked..}
        end; {If a Quote..}

        {$IFDEF SOP}
                                        {* Update O/S Balance, unposted items only *}
          If (InvDocHed In PSOPSet) and ((RunNo=OrdUSRunNo) or (RunNo=OrdUPRunNo)) and (Not UpdateOldestDebtOnly) then
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

            //PR: 20/06/2012 Changed to use correct o/s depending on system setup flag ABSEXCH-11528
            LUpdateOrdBal(LInv, LTransOSValue(LInv) *
                         DocCnst[InvDocHed]*DocNotCnst,
                         0,0,
                         BOff,0);

          end;
        {$ENDIF}



        {$IFDEF JAP}
                                        {* Update O/S Balance, unposted items only *}
          If (InvDocHed In JAPOrdSplit) and ((RunNo=JSTUPRunNo) or (RunNo=JCTUPRunNo))
          and ((InvDocHed<>JST) or EmptyKey(LInv.DeliverRef,DocKeyLen))
          and (Not UpdateOldestDebtOnly) then  {*EN560 some way to indicate no longer o/s needed *}
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

            LUpdateOrdBal(LInv,(Round_Up(Conv_TCurr(TotalCost-TotalOrdered,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2)*
                         DocCnst[InvDocHed]*DocNotCnst),
                         0,0,
                         BOff,0);

          end;
        {$ENDIF}

        If (LStatusOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,ScanKey);

      end; {While..}

      If (Not AllAccounts) then
        UpdateProgress(2);

      If (OldDate=Today) then
        OldDate:='';

      LCust.CreditStatus:=CalcWksODue(OldDate);


      If (Not AllAccounts) then
        UpdateProgress(3);

      {$IFDEF C_On}   {* Re-calculate next Note No. in case of corruption *}

        LCust.NLineCount:=LCheck_NoteNo(NoteCCode,LCust.CustCode);


      {$ENDIF}

      If (Recalc) then {Prime any stray MDC}
        PrimeMDCHist;


      LStatus:=LPut_Rec(CFnum,CKeyPath);

      LReport_BError(CFnum,LStatus);

      LStatus:=LUnLockMLock(CFnum);

      If (Not AllAccounts) then
        UpdateProgress(4);


      If (Assigned(MDCList)) then
        Dispose(MDCList);

    end; {If Cust Locked..}
  end;
end; {Proc..}

{$IFDEF SOP}

{Routine to check the head office account if a delivery address is being checked}

  Procedure TCheckCust.Check_HOCust(CCode   :  Str10;
                                    Auto,
                                    ReCalc  :  Boolean;
                                    CFnum,
                                    CKeyPAth:  Integer);


  Const
    Fnum    =  CustF;

    KeyPAth =  CustInvToK;

  Var
    KeyChk,
    KeyS     :  Str255;

    LOK,
    ProcessDAddr
             :  Boolean;

    TmpKPath,
    TmpKPath2,
    TmpStat  :  Integer;

    TmpRecAddr,
    TmpRecAddr2
             :  LongInt;

    LocalCust:  CustRec;

    SubsCCode:  Str10;



  Begin
    With MTExLocal^ do
    Begin
      KeyS:='';  KeyChk:='';  ProcessDAddr:=BOff;

      SubsCCode:=CCode;

      LocalCust:=Cust;

      TmpKPath:=GetPosKey;


      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);


      If (LCust.CustCode<>CCode) then
        LOK:=LGetMainRec(Fnum,CCode)
      else
        LOK:=BOn;

      If (LOK) then
      Begin
        If (Not EmptyKey(LCust.SOPInvCode,CustKeyLen)) then
        Begin
          KeyS:=FullCustCode(LCust.SOPInvCode);

          LOK:=LGetMainRec(Fnum,KeyS);

          ProcessDAddr:=(LOk) and (LCust.SOPConsHO=1);

          If (ProcessDAddr) then
            SubsCCode:=KeyS;
        end
        else
          ProcessDAddr:=(LCust.SOPConsHO=1);
      end;

      Check_Cust(SubsCCode,Auto,ReCalc,CFnum,CKeypath);


      If (ProcessDAddr) then
      Begin
        KeyChk:=SubsCCode;
        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

        While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not Has_Aborted) do
        With LCust do
        Begin
          TmpKPath2:=Keypath;

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOff,BOff);

          Check_Cust(CustCode,Auto,ReCalc,CFnum,CKeypath);

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath2,LocalF^[Fnum],TmpRecAddr2,BOn,BOff);

          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
        end;
      end;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


      LCust:=LocalCust;
    end; {With..}

  end; {Proc..}



{$ENDIF}


{ ================ Procedure to Scan all Customers and Re-Calc/check status ============== }

Procedure TCheckCust.Check_AllCust(ReCalc  :  Boolean);


Const
  Fnum  =  CustF;

  {$IFDEF SOP}

    KeyPAth =  CustInvToK;
  {$ELSE}
    KeyPAth =  CustCodeK;

  {$ENDIF}



Var
  KeyS     :  Str255;

  Ok2Cont  :  Boolean;

  Count    :  LongInt;

  {$IFDEF SOP}
    TmpKPath,
    TmpStat:  Integer;

    TmpRecAddr
           :  LongInt;
  {$ENDIF}


Begin
  KeyS:='';


  Count:=0;

  With MTExLocal^ do
  Begin
    InitProgress(Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId));

    {$IFDEF SOP}
       TmpKPath:=KeyPath; 
    {$ENDIF}

    LStatus:=LFind_Rec(B_GetFirst,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (Not Has_Aborted) do
    With LCust do
    Begin
      {$IFDEF SOP}
         TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);
      {$ENDIF}


      Check_Cust(CustCode,BOn,ReCalc,Fnum,CustCodeK);

      {$IFDEf STK}
        {$IFDEF PF_On}  {* Recalc Product analysis *}
          If (AnalCuStk)  then
            cuStk_CheckHist(CustCode,IsaCust(CustSupp));
        {$ENDIF}
      {$ENDIF}

      Inc(Count);

      UpdateProgress(Count);

      {$IFDEF SOP}
         TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocaLF^[Fnum],TmpRecAddr,BOn,BOff);
      {$ENDIF}


      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);
    end;
  end;

end; {Proc..}


Const
  CCCustTit  :  Array[BOff..BOn] of Str20 = ('this account.','all accounts.');


Procedure TCheckCust.Process;


Var
  Ok2Cont  :  Boolean;

Begin
  InMainThread:=BOn;

  Inherited Process;

  If (Not fCuStkMode) then
  Begin
    ShowStatus(0,'Recalculate account balance.');

    If (AllAccounts) then
      Check_AllCust(UReCalc)
    else
     {$IFDEF SOP}
       Check_HOCust(UCCode,BOff,UReCalc,CustF,CustCodeK);
     {$ELSE}
       Check_Cust(UCCode,BOff,UReCalc,CustF,CustCodeK);
     {$ENDIF}
  end
  else
  With MTExLocal^,LCust do
  Begin
    ShowStatus(0,'Recalculate account stock analysis.');

    If (UCCode<>CustCode) then
      LGetMainRecPos(CustF,UCCode);

    {$IFDEf STK}
      {$IFDEF PF_On}  {* Recalc Product analysis *}
          cuStk_CheckHist(UCCode,IsaCust(CustSupp));
      {$ENDIF}
    {$ENDIF}


  end;

end;


Procedure TCheckCust.Finish;
Begin
  Inherited Finish;

  {Overridable method}

  InMainThread:=BOff;

  //PR: 05/04/2016 ABSEXCH-17412 Set thread controller to normal operation
  if Assigned(BackThread) then
    BackThread.ThreadOneOnly := False;
end;



Function TCheckCust.Start(CCode    :  Str10;
                          AllMode,
                          ReCalc,
                          CuStkMode: Boolean;
                          CustSupp: Char)  :  Boolean;
Var
  mbRet  :  Word;

Begin
  //PR: 18/02/2016 v2016 R1 FIX_WARNINGS ABSEXCH-17145 Result wasn't being initialised - could be causing this issue
  Result := True;
  UCCode:=CCode;
  AllAccounts:=AllMode;

  fCanAbort:=AllMode;
  fCuStkModE:=CuStkMode;

  //PR: 06/06/2017 ABSEXCH-18683 If customer stock analysis then get a process lock
  if cuStkMode then
  begin
    if not GetProcessLock(plCheckCustStockAnal) then
    begin
      Result := False;
      EXIT;
    end;

    ProcessLockType := plCheckCustStockAnal;
  end; //if cuStkMode
  

  // CJS 2015-04-13 - ABSEXCH-16345 - Unallocate All not working
  // Removed check for Result
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

    If (Result) then
      MTExLocal:=PostExLocal;
  end;

  UReCalc:=ReCalc;

  {$IFDEF EXSQL}
  if Result and SQLUtils.UsingSQL then
  begin
    MTExLocal^.Close_Files;
    CloseClientIdSession(MTExLocal^.ExClientID, False);
  end;
  {$ENDIF}

end;


Function TCheckCust.Build_Title(CCode  :  Str10;
                                AllMode:  Boolean)  :  Str50;

Begin
  If (AllMode) then
    Result:=CCCustTit[BOn]
  else
    Result:='account '+CCode;


end;




{ ============== }



{ ========== TThreadTest methods =========== }

Constructor TThreadTest.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  fTQNo:=2;
  fCanAbort:=BOn;

end;

Destructor TThreadTest.Destroy;

Begin
  Inherited Destroy;
end;


Procedure TThreadTest.StartLoop;

Var
  n  :  Integer;
Begin
  ShowStatus(2,'Calculating Totals');

  With ThreadRec^ do
  Begin
    InitProgress(90000000);

    UpdateProgress(0);

    For n:=0 to 5000000 do
    Begin
      UpdateProgress(n);

      If (THAbort) then
        Exit
    end;

    ShowStatus(2,'Printing Report');


    For n:=5000001 to 90000000 do
    Begin
      UpdateProgress(n);

      If (THAbort) then
        Exit
    end;
  end; {With..}
end;


Procedure TThreadTest.Process;
Var
  Ok2Cont  :  Boolean;

Begin

  InitStatusMemo(4);

  ShowStatus(0,'General Ledger Posting Report');

  StartLoop;

end;


Procedure TThreadTest.Finish;
Begin

  {Overridable method}


end;



{ ======== }


{ ========== TDumR1Test methods =========== }

Constructor TDumR1Test.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  fTQNo:=2;
  fCanAbort:=BOn;

end;

Destructor TDumR1Test.Destroy;

Begin
  Inherited Destroy;
end;


Procedure TDumR1Test.Process;
Var
  Ok2Cont  :  Boolean;

Begin

  InitStatusMemo(4);

  ShowStatus(0,'Customer List');

  StartLoop;

end;


Procedure TDumR1Test.Finish;
Begin

  {Overridable method}


end;


{ ======== }

{ ========== TDumR2Test methods =========== }

Constructor TDumR2Test.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  fTQNo:=2;
  fCanAbort:=BOn;

end;

Destructor TDumR2Test.Destroy;

Begin
  Inherited Destroy;
end;


Procedure TDumR2Test.Process;
Var
  Ok2Cont  :  Boolean;

Begin

  InitStatusMemo(4);

  ShowStatus(0,'Aged Debtors Report.');

  StartLoop;

end;


Procedure TDumR2Test.Finish;
Begin

  {Overridable method}


end;





{ ========== TCheckCCDep methods =========== }

Constructor TCheckCCDep.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  fTQNo:=1;
  fCanAbort:=BOn;

  IsParentTo:=BOn;

end;

Destructor TCheckCCDep.Destroy;
Begin
  // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
  {$IFDEF EXSQL}
  FreeAndNil(FSQLCaller);
  FProgressFrm := nil;
  {$ENDIF}

  Inherited Destroy;
end;



{ ========== Zero All CC/Dep based balances ========== }

Procedure TCheckCCDep.Remove_CCDepBalances;

Const
  GLNHCodes  :  Array[0..3] of Char = (NomHedCode,PLNHCode,BankNHCode,CtrlNHCode);

Var
  n     :  Byte;
  Loop  :  Boolean;
  KeyS  :  Str255;

Begin
  With MTExLocal^ do
  Begin
    ShowStatus(2,'Removing Previous CC/Dept Values');

    Loop:=BOff;

    Try
      DelCCDepHist:=BOn;

      Repeat
        KeyS:=CSubCode[Loop];

        For n:=Low(GLNHCodes) to High(GLNHCodes) do {Remove History}
        Begin
          LResetAuditHist(GLNHCodes[n]+KeyS,Succ(Length(KeyS)));

          If (ThreadRec^.THAbort) then
            Break;
        end;

        Loop:=Not Loop;

      Until (Not Loop) or (ThreadRec^.THAbort);
    finally
      DelCCDepHist:=BOff;

    end; {try..}

  end; {With..}
end;



{ ============ Repost all CC/Dep Lines =========== }

Procedure TCheckCCDep.RePost_CCDepLines;

Const
  Fnum       =  IDetailF;
  Keypath2   =  IDRunK;


Var
  UOR         :  Byte;

  TmpKPath,
  TmpStat :  Integer;

  TmpRecAddr
          :  LongInt;

  KeyS,
  KeyChk  :  Str255;

  DiscGL,
  LineCount,
  HistCount:  LongInt;

  LOk,
  Locked,
  Loop    :  Boolean;

  LVal,
  Cleared,
  LineDisc:  Double;

  CrDr,
  DiscCrDr:  DrCrDType;
  CtrlSet :  ControlAry;

Begin

  LVal:=0; UOR:=0; Cleared:=0.0;  DiscGL:=0;

  With MTExLocal^ do
  Begin
    LineCount:=Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId);
    HistCount:=Used_RecsCId(LocalF^[NHistF],NHistF,ExCLientId);

    InitProgress(LineCount+HistCount);

    Begin
      ShowStatus(2,'Clearing current balances.');

      Remove_CCDepBalances;

      PCount:=HistCount;

      UpdateProgress(PCount);


      KeyChk:=FullNomKey(1);


      KeyS:=KeyChk;

      TmpKPath:=KeyPath2;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath2,KeyS);


      ShowStatus(2,'Calculating new balances.');

      While (LStatusOk) and (LId.PostedRun>0) and (Not ThreadRec^.THAbort) do
      With LId do
      Begin

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);


        Inc(PCount);

        UpdateProgress(PCount);

        If (AfterPurge(LId.PYr,0)) then
        Begin

          LVal:=DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0);

          ShowDrCrD(LVal,CrDr);

          If (Syss.SepDiscounts) then
            LineDisc:=Round_Up((LVal-DetLTotal(LId,Syss.SepDiscounts,BOff,0.0))*DocNotCnst,2)
          else
            LineDisc:=0.0;


          {$IFDEF PF_On}
           If ((LVal+LineDisc<>0) or (NetValue<>0)) and (LId.PYr<>0) and (LId.PPr<>0)  then
           Begin
             Loop:=BOff;

             UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

             SetControlCodes(IdDocHed,CtrlSet);


             ShowDrCrD(LineDisc,DiscCrDr);

             Repeat

               If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
               Begin

                 LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,(IdDocHed<>RUN),BOff,
                                   CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);


                 {* Post to combination *}

                 If (Syss.PostCCDCombo) then
                   LPost_To_CCNominal(FullNomKey(NomCode),CrDr[BOff],CrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,(IdDocHed<>RUN),BOff,
                                   CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate); {* EN440CCDEP *}



                 If ((Syss.SepDiscounts) and (LineDisc<>0.0) and (CtrlSet[LDiscCtrl]<>0)) or ((IdDocHed=RUN) and (LineDisc<>0.0)) then
                 Begin
                   If (IdDocHed=RUN) then
                     DiscGL:=NomCode
                   else
                     DiscGL:=CtrlSet[LDiscCtrl];


                   LPost_To_CCNominal(FullNomKey(DiscGL),DiscCrDr[BOff],DiscCrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,(IdDocHed<>RUN),BOff,
                                   CXRate,PostCCKey(Loop,CCDep[Loop]),UOR);


                   {* Post to combination *}
                   If (Syss.PostCCDCombo) then
                     LPost_To_CCNominal(FullNomKey(DiscGL),DiscCrDr[BOff],DiscCrDr[BOn],Cleared,Currency,PYr,PPr,1,BOff,(IdDocHed<>RUN),BOff,
                                   CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UOR); {* EN440CCDEP *}


                 end;
               end;

               Loop:=Not Loop;

             Until (Not Loop);
           end;

         {$ENDIF}


        end;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOn);

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath2,KeyS);


      end; {While..}

    end;

    UpdateProgress(LineCount+HistCount);

  end; {With..}

end; {Proc..}



Procedure TCheckCCDep.Process;
Begin
  InMainThread:=BOn;

  Inherited Process;

  ShowStatus(0,'Recalculate General Ledger CC/Dept balances.');

  {$IFDEF EXSQL}
  if SQLUtils.UsingSQLAlternateFuncs then
  begin
    FSQLCaller.ExecSQL('EXEC [COMPANY].esp_RecalculateCCDeptnominalBalances @iv_Mode = 0', FCompanyCode);
  end
  else
  {$ENDIF}
    RePost_CCDepLines;

end;


Procedure TCheckCCDep.Finish;
Begin
  Inherited Finish;

  if SQLUtils.UsingSQLAlternateFuncs then
  begin
    FProgressFrm.Stop;
    FProgressFrm := nil;
  end;


  {Overridable method}

  InMainThread:=BOff;

  PostUnLock(0);

end;



Function TCheckCCDep.Start :  Boolean;

Var
  mbRet  :  Word;
  KeyS   :  Str255;
{$IFDEF EXSQL}
  ConnectionString,
  lPassword: WideString;
{$ENDIF}
Begin
  Set_BackThreadMVisible(BOn);

  mbRet:=CustomDlg(Application.MainForm,'Please confirm','Re-calculate CC/Dept balances',
                             'Please confirm you wish to re-calculate the CC/Dept balances.'+#13+#13+
                             'Depending on the amount of data involved, this procedure may take several hours to complete,'+
                             ' during which, all postings to other ledgers will be locked.',
                             mtConfirmation,
                             [mbYes,mbNo]);

  Result:=(mbRet=mrOK);

  Set_BackThreadMVisible(BOff);

  If (Result) then
  Begin
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
    begin
      // CJS 2016-03-24 - ABSEXCH-17381 - Check CC-Dept Balances - SQL improvements
      if SQLUtils.UsingSQLAlternateFuncs then
      begin
        // Create the SQL Caller instance
        FSQLCaller := TSQLCaller.Create(nil);

        // Determine the company code
        FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

        // Set up the ADO Connection for the SQL Caller
        //SQLUtils.GetConnectionString(FCompanyCode, False, ConnectionString);
        SQLUtils.GetConnectionStringWOPass(FCompanyCode, False, ConnectionString, lPassword);
        FSQLCaller.ConnectionString := ConnectionString;
        FSQLCaller.Connection.Password := lPassword;
        // Set the time-outs to 60 minutes
        FSQLCaller.Connection.CommandTimeout := SQLReportsConfiguration.CheckCCDeptBalancesTimeoutInSeconds;
        FSQLCaller.Query.CommandTimeout := SQLReportsConfiguration.CheckCCDeptBalancesTimeoutInSeconds;

        FProgressFrm := TIndeterminateProgressFrm.Create(Application.MainForm);
        FProgressFrm.Start('Check CC/Dept Balances', 'Recalculating General Ledger CC/Dept balances');
        Application.ProcessMessages;
      end;

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

      If (Result) then
      Begin
        MTExLocal:=PostExLocal;

      end;
    end;
  end;

  If (Result) then {Attempt to lock all posting modes}
    Result:=PostLockCtrl(0);

  If (Result) then
  With MTExLocal^,PostRepCtrl^ do
  Begin
    LastRunNo:=CheckAbortedRun;

    If (LastRunNo<>0) and (Syss.ProtectPost) and (Result) then
    With LMiscRecs^,MultiLocRec do
    Begin
      ShowMessage('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                  'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC+#13+#13+
                  'Checking CC/Dept cannot continue until the last posting is re run.');

      AddErrorLog('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                  'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC+#13+
                  'Checking CC/Dept Aborted.','',4);

      Result:=BOff;
    end;
  end; {With..}

  If (Not Result) then {* Remove lock... *}
    PostUnLock(0);

  {$IFDEF EXSQL}
  if Result and SQLUtils.UsingSQL then
  begin
    MTExLocal^.Close_Files;
    CloseClientIdSession(MTExLocal^.ExClientID, False);
  end;
  {$ENDIF}

end;


{ ============== }




{$IFDEF STK}

  { ========== TCheckStk methods =========== }

  Constructor TCheckStk.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOff;

    fPriority:=tpHigher;
    fSetPriority:=BOn;

    IsParentTo:=BOn;

  end;

  Destructor TCheckStk.Destroy;

  Begin
    Inherited Destroy;
  end;



  Procedure TCheckStk.Process;



  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Recalculate Stock Ledger posted balance.');

    With MTExLocal^ do
    Begin
      With LStock do
        ShowStatus(1,dbFormatName(StockCode,Desc[1]));

      LInv:=UInv;

      ShowStatus(2,'Document : '+LInv.OurRef);

      InitProgress(1);

      LId:=UId;
      LStock:=UStk;

      If (LId.PPr=0) and (LId.PYr=0) then {* Correct period problems here *}
      Begin
        LId.PPr:=LInv.AcPr;
        LId.PYr:=LInv.AcYr;
      end;

      Stock_PostCtrl(LId,0,BOn);
    end;

    UpdateProgress(1);

  end;


  Procedure TCheckStk.ProcessFromCheck(StkRec  : StockRec;
                                       IdR     : IDetail;
                                       InvR    : InvRec);

  Begin
    With MTExLocal^ do
    Begin

      LInv:=InvR;

      LId:=IdR;
      LStock:=StkRec;

      InCheckStock:=BOn;

      If (LId.PPr=0) and (LId.PYr=0) then {* Correct period problems here *}
      Begin
        LId.PPr:=LInv.AcPr;
        LId.PYr:=LInv.AcYr;
      end;

      Stock_PostCtrl(LId,0,BOn);
    end;

  end;



  Procedure TCheckStk.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;



  Function TCheckStk.Start(StkRec  : StockRec;
                           IdR     : IDetail;
                           InvR    : InvRec)  :  Boolean;

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

      If (Result) then
      begin
        MTExLocal := LPostLocal;

        UInv:=InvR;
        UId:=IdR;
        UStk:=StkRec;
      end;
    end
    else
    {$ENDIF}
    begin
      If (Not Assigned(PostExLocal)) then { Open up files here }
        Result:=Create_ThreadFiles;

      If (Result) then
      Begin
        MTExLocal:=PostExLocal;

        UInv:=InvR;
        UId:=IdR;
        UStk:=StkRec;
      end;
    end;
    // CJS 2011-10-17: 27 - v6.9 - ABSEXCH-11565 - Check All Stock clears the
    //                 Posted value.
    //
    //                 The following lines are only relevant for Posting objects
    //                 which are run in a thread -- the thread will re-open the
    //                 files. TCheckStk is no longer ever used in a thread, so
    //                 the files should be left open.
    (*
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
    *)
  end;





{$ENDIF}


  { ========== TUntagSOP methods =========== }

  Constructor TUnTagSOP.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=1;
    fCanAbort:=BOn;

    fPriority:=tpHigher;
    fSetPriority:=BOn;

    IsParentTo:=BOn;

  end;

  Destructor TUnTagSOP.Destroy;

  Begin
    Inherited Destroy;
  end;



  Procedure TUnTagSOP.Process;



  Var
    KeyS    :  Str255;
    GotOk,
    Locked  :  Boolean;
    Fnum,
    Keypath :  Integer;
    ITotal,
    ICount  :  LongInt;

  Begin

    InMainThread:=BOn;  ICount:=0; ITotal:=0;

    Fnum:=OFnum; Keypath:=OKeypath;

    Inherited Process;

    If (MyHandle<>0) then
      SendMessage(MyHandle,WM_FormCloseMsg,84,0);

    ShowStatus(0,'Clear all Tagged Orders.');

    With MTExLocal^ do
    Begin
      ITotal:=Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId);

      InitProgress(ITotal);

      KeyS:=KeyTagChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

      While (LStatusOk) and (CheckKey(KeyTagChk,KeyS,KeyTagLen,BOn)) and (Not ThreadRec^.THAbort) do
      With LInv do
      Begin

        If (Tagged=ClearTag) or (ClearTag=0) then
        Begin
          ShowStatus(1,'Document : '+LInv.OurRef);

          Locked:=BOff; GotOk:=BOff;

          GotOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

          If (GotOk) and (Locked) then
          Begin
            LGetRecAddr(Fnum);

            Tagged:=0;

            LStatus:=LPut_Rec(Fnum,Keypath);

            LReport_Berror(Fnum,LStatus);

            LStatus:=LUnLockMLock(Fnum);
          end;
        end;

        Inc(ICount);

        UpdateProgress(ICount);

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}

      UpdateProgress(ITotal);

    end; {With..}

  end;


  Procedure TUnTagSOP.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

    If (MyHandle<>0) then
      SendMessage(MyHandle,WM_CustGetRec,182,0);

    If (MyHandle<>0) then
      SendMessage(MyHandle,WM_FormCloseMsg,74,0);

  end;



  Function TUnTagSOP.Start(DBkKey  : Str255;
                           DBKLen,
                           DBKFnum,
                           DBKKpath
                                   : SmallInt;
                           AOwner  : TObject)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOn;

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

        If (Result) then
          MTExLocal:=PostExLocal;
      end;

      if Result then
      Begin
        KeyTagChk:=DBkKey;
        KeyTagLen:=DBKLen;
        OFnum:=DBKFnum;
        OKeypath:=DBKKPath;
        MyOwner:=AOwner;


        If (MyOwner is TForm) then
          MyHandle:=TForm(MyOwner).Handle
        else
          MyHandle:=0;
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






  { ========== TCheckCAlloc methods =========== }

  Constructor TCheckCAlloc.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=3; {v5 Must be one instead of three, if it is to share the posting thread files}
    fCanAbort:=BOff;

    IsParentTo:=BOn;

    fOwnMT:=Not Syss.LiveCredS; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

    New(CustAlObj,Init);

  end;

  Destructor TCheckCAlloc.Destroy;

  Begin
    Dispose(CustAlObj,Done);

    Inherited Destroy;
  end;



  Procedure TCheckCAlloc.Process;



  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Recalculate Credit Status for account : '+Trim(UCCode));

    With MTExLocal^ do
    Begin

      CustAlObj.MTExLocal:=MTExLocal;

      InitProgress(1);

      Update_CreditStatus(UCCode,InvF,InvCDueK,CustF,CustCodeK,0,CustAlObj);

    end;

    UpdateProgress(1);

  end;


  Procedure TCheckCAlloc.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

  end;



  Function TCheckCAlloc.Start(CCode  :  Str10)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOn;

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
      If (Not fOwnMT) then {If live credit status then use a pooled set of files for speed}
      Begin
        If (Not Assigned(LCSExLocal)) then { Open up files here }
          Result:=Create_LiveCSFiles;

        If (Result) then
          MTExLocal:=LCSExLocal;
      end
      else {Create and destroy files each time used}
      Begin
        If (Not Assigned(MTExLocal)) then { Open up files here}
        Begin
          New(MTExLocal,Create(15));

          try
            With MTExLocal^ do
              Open_System(CustF,InvF);

          except
            Dispose(MTExLocal,Destroy);
            MTExLocal:=nil;

          end; {Except}

          Result:=Assigned(MTExLocal);
        end;
      end;

      If (Result) then
      Begin
        UCCode:=CCode;
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

{ ===== Procedure to Print Preposting Reports ===== }

Procedure DayBkPostCtrl(LMode     :  Byte;
                        AOwner   :  TObject);



Var
  Ok2Cont  :  Boolean;
  EntPost  :  ^TEntPost;

Begin
  If (Not Assigned(PostExLocal)) then { Open up files here }
    Ok2Cont:=Create_ThreadFiles
  else
    Ok2Cont:=BOn;

  If (Ok2Cont) then {* atempt to startup main posting object *}
  Begin
    New(EntPost,Create(AOwner));

    try
      With EntPost^ do
      Begin
        MTExLocal:=PostExLocal;

        Control_Posting(LMode)

      end;
    finally

      Dispose(EntPost,Destroy);

      Destroy_ThreadFiles;

    end; {try..}

  end; {If files opened ok..}
end; {Proc..}



Procedure AddPost2Thread(LMode    :  Byte;
                         AOwner,
                         FormHandle
                                  :  TObject;
                         Ask      :  Boolean;
                         RPParam  :  TPrintParamPtr;
                         PostParam:  PostRepPtr;
                     Var StartedOk:  Boolean);



Var
  EntPost  :  ^TEntPost;

Begin
  StartedOk:=BOff;

  If (Create_BackThread) then
  Begin
    New(EntPost,Create(AOwner));

    try
      With EntPost^ do
      Begin
        // CJS 2011-08-03 ABSEXCH-11019 - Stock Valuation access violation
        // Added try..except to catch possible errors when called from other
        // areas (the Stock Valuation error has been fixed in RevalueU.pas).
        try
          If (FormHandle is TForm) then {v4.40, overwrite fMyownhandle so we can send messages to the form}
            fOwnHandle:=TForm(FormHandle).Handle;
        except
          on Exception do
            fOwnHandle := 0;
        end;

        If (Start(LMode,RPParam,PostParam,Ask)) and (Create_BackThread) then
        Begin
          //PR: 24/05/2017 ABSEXCH-18683
          //PR: 24/07/2017 ABSEXCH-18986 Need to check that PostParam is assigned
          if Assigned(PostParam) then
            if PostParam.AfterRevaluation then
              ProcessLockType := plNone;
          With BackThread do
          begin
            {***
              SS:16/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
              SS:01/06/2017:ABSEXCH-18755:The original progress bar is no longer displayed if SQL posting is disabled with SQLconfig.ini.
              - Display progressbar on the OTC for sales, purchase & nominal only for SQL Daybook Posting and when DayBookPostingUsingSQL flag is on.
            ***}
            UseSQLPost := CanPostUsingSQL(LMode);
            if UseSQLPost then
              EntPost.ShowProgressBar :=  LMode in [0,1,2,3];
              
            
            AddTask(EntPost,'Post '+Build_Title(LMode));
          end;

          StartedOk:=BOn;
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntPost,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntPost,Destroy);

    end; {try..}
  end; {If process got ok..}

end;



Procedure AddLiveCommit2Thread(IdR  : IDetail; DedMode  :  SmallInt);

Var
  EntPost  :  ^TEntPost;

Begin
  If (Create_BackThread) then
  Begin
    New(EntPost,Create(Application.MainForm));

    try
      With EntPost^ do
      Begin
        If (Start(50,nil,nil,BOff)) and (Create_BackThread) then
        Begin
          CommitId:=IdR; CommitDedMode:=DedMode;

          With BackThread do
            AddTask(EntPost,'Update Live Commit');

        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntPost,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntPost,Destroy);

    end; {try..}
  end; {If process got ok..}

end;


// CJS 2015-03-31 - ABSEXCH-16163 - Check All Accounts, SQL improvements
Procedure AddCheckCust2Thread(AOwner   :  TObject;
                              CCode    :  Str10;
                              AllMode,
                              ReCalc,
                              CuStkMode: Boolean;
                              CustSupp: Char);




Var
  LCheck_Cust :  ^TCheckCust;

Begin

  If (Create_BackThread) then
  Begin
    New(LCheck_Cust,Create(AOwner));

    try
      With LCheck_Cust^ do
      Begin
        // CJS 09/03/2011 v6.7 ABSEXCH-10901 - CustSupp parameter added
        If (Start(CCode,AllMode,ReCalc,CuStkMode,CustSupp)) and (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(LCheck_Cust,'Check '+Build_Title(CCode,AllMode));
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Cust,Destroy);
        end;
      end; {with..}

    except
      Dispose(LCheck_Cust,Destroy);

    end; {try..}
  end; {If process got ok..}

end;

//HV 20/05/2016 2016-R2 ABSEXCH-17430: Recalculate Trader Oldest Debt Correctly for
Procedure AddCheckCust2Thread(AOwner   :  TObject;
                              CCode    :  Str10;
                              AllMode,
                              ReCalc,
                              CuStkMode: Boolean;
                              UpdateOldestDebt: Boolean;
                              CustSupp: Char);
Var
  LCheck_Cust :  ^TCheckCust;

Begin

  If (Create_BackThread) then
  Begin
    New(LCheck_Cust,Create(AOwner));

    try
      With LCheck_Cust^ do
      Begin
        UpdateOldestDebtOnly := UpdateOldestDebt;
        If (Start(CCode,AllMode,ReCalc,CuStkMode,CustSupp)) and (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(LCheck_Cust,'Check '+Build_Title(CCode,AllMode));
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Cust,Destroy);
        end;
      end; {with..}

    except
      Dispose(LCheck_Cust,Destroy);

    end; {try..}
  end; {If process got ok..}


end;


Procedure AddChkCAlloc2Thread(AOwner   :  TObject;
                              CCode    :  Str10);


  Var
    LCheck_Stk :  ^TCheckCAlloc;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          If (Start(CCode)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Stk,'Cred Status');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;





Procedure AddCheckCCDep2Thread(AOwner   :  TObject);




Var
  LCheck_Nom :  ^TCheckCCDep;

Begin

  If (Create_BackThread) then
  Begin
    New(LCheck_Nom,Create(AOwner));

    try
      With LCheck_Nom^ do
      Begin
        If (Start) and (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(LCheck_Nom,'Check CC/Dept ');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Nom,Destroy);
        end;
      end; {with..}

    except
      Dispose(LCheck_Nom,Destroy);

    end; {try..}
  end; {If process got ok..}

end;



{$IFDEF STK}

  Procedure AddCheckStk2Thread(AOwner   :  TObject;
                               InvR     :  InvRec;
                               StkRec   :  StockRec;
                               IdR      :  IDetail);




  Var
    LCheck_Stk :  ^TCheckStk;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          If (Start(StkRec,IdR,InvR)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Stk,'Check '+Trim(StkRec.StockCode));
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;





{$ENDIF}

  Procedure AddUnTagSOP2Thread(AOwner   :  TObject;
                               KeyChk   :  Str255;
                               KeyLen,
                               KFnum,
                               KKeypath :  SmallInt;
                               TagNo    :  Byte);

  Var
    LCheck_Stk :  ^TUnTagSOP;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Stk,Create(AOwner));

      try
        With LCheck_Stk^ do
        Begin
          ClearTag:=TagNo;

          If (Start(KeyChk,KeyLen,KFnum,KKeypath,AOwner)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Stk,'Clear Tags');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Stk,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Stk,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;



Procedure AddTest2Thread(LMode    :  Byte;
                         AOwner   :  TObject);


Var
  EntTest  :  ^TThreadTest;

Begin

  If (Create_BackThread) then
  Begin
    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        If (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(EntTest,'Posting Report');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;


Procedure AddR12Thread(LMode    :  Byte;
                       AOwner   :  TObject);


Var
  EntTest  :  ^TDumR1Test;

Begin

  If (Create_BackThread) then
  Begin
    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        If (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(EntTest,'Customer List');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;  
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;



Procedure AddR22Thread(LMode    :  Byte;
                       AOwner   :  TObject);


Var
  EntTest  :  ^TDumR2Test;

Begin

  If (Create_BackThread) then
  Begin
    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        If (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(EntTest,'Aged Debtors');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;

{ CJS 2013-09-27 - ABSEXCH-14026 - GL imbalance following Protected Mode Recovery - SQL Only }
function TEntPost.Create_LockLocal: Boolean;
const
  ClientID: Integer = 702;
begin
  Result := BOff;

  New(LLockLocal);
  with LLockLocal^ do
  begin
    try
      Create(ClientId);

      //PR: 03/01/2014 ABSEXCH-14901 Need to set the local SetDrive for Scheduler.
      {$IFDEF SCHEDULER}
       LsetDrive := LDataPath;
      {$ENDIF}

      Open_System(MiscF, MiscF);

      fOwnMT := False;

      Result := BOn;
    except
      LLockLocal := nil;
    end; {try..}
  end;
end;

{ TUnallocateTransactions }

//Goes through matched transactions and reduces settled amount on any OP transactions that may be partly matched to current transaction
procedure TUnallocateTransactions.CheckMatchedTransactions;
var
  Res : Integer;
  KeyS : Str255;
  KeyCheck : Str255;

  InvRes : Integer;
  InvKeyS : Str255;
  InvKeyCheck : Str255;

  Idx : Integer;
  LOK : Boolean;
  Locked : Boolean;

  TmpStat : Integer;
  TmpKPath : Integer;
  TmpRecAddr : Integer;
begin
  with MTExLocal^ do
  begin
    //Save position in file
    TmpKPath := GetPosKey;
    TmpStat:=LPresrv_BTPos(InvF,TmpKPath,LocalF^[InvF],TmpRecAddr,BOff,BOff);

    //Set search key
    KeyCheck := FullMatchKey(MatchTCode, MatchSCode, LInv.OurRef);

    // We'll need to check on both indexes
    for Idx := PWK to HelpNDXK do
    begin
      //Reset search key
      KeyS := KeyCheck;

      //Find first match record
      Res := LFind_Rec(B_GetGEq, PWrdF, Idx, KeyS);

      while (Res = 0) and CheckKey(KeyCheck, KeyS, Length(keyCheck), True) do
      with LPassword.MatchPayRec do
      begin

        //Financial Matching only
        if MatchType = 'A' then
        begin

          //OurRef of matching transaction is in the field other than the one we're searching on
          if Idx = PWK then
            InvKeyS := PayRef
          else
            InvKeyS :=DocCode;


          //Find transaction
          InvRes := LFind_Rec(B_GetEq, InvF, InvOurRefK, InvKeyS);

          if InvRes = 0 then
          begin

            //Only care if it's an OP transaction - non-OP will be fully unallocated in the normal process
            if LInv.thOrderPaymentElement <> opeNA then
            begin
              LOk:=LGetMultiRec(B_GetDirect, B_MultLock, InvKeyS, InvOurRefK, InvF, BOn, Locked);

              If (LOk) and (Locked) then
              Begin
                //Store record address for unlocking
                LGetRecAddr(InvF);

                //Reduce settled values as required
                LInv.Settled := LInv.Settled - SettledVal;
                LInv.CurrSettled := LInv.CurrSettled - OwnCVal;

                //Store transaction record
                LStatus:=LPut_Rec(InvF, InvCustK);

                //Unlock transaction record
                If (LStatusOk) then
                 LStatus:=LUnLockMLock(InvF);
              end; //If (LOk) and (Locked)


            end; //LInv.thOrderPaymentsElement <> opeNA
          end; // if InvRes = 0
        end; //if MatchType = 'A'

        //Get next matching rec
        Res := LFind_Rec(B_GetNext, PWrdF, Idx, KeyS);
      end; //while (Res = 0)

    end; // for Idx := HelpNDXK to PWK

    //Restore position
    TmpStat:=LPresrv_BTPos(InvF,TmpKPath,LocaLF^[InvF],TmpRecAddr,BOn,BOff);
  end; //with MTExLocal
end;

constructor TUnallocateTransactions.Create(AOwner: TObject);
begin
  Inherited Create(AOwner);

  fTQNo:=1;
  fCanAbort:=BOn;

  IsParentTo:=BOn;

end;

procedure TUnallocateTransactions.Finish;
begin
  Inherited Finish;


  {Overridable method}

  InMainThread:=BOff;

  PostUnLock(0);
end;

procedure TUnallocateTransactions.Process;
var
  KeyS : Str255;
  KeyEnd : Str255;
  Key2 : Str255;
  Count : Integer;

  UseHeadOffice : Boolean;
  TmpStat : Integer;
  TmpKPath : Integer;
  TmpRecAddr : Integer;

begin
  InMainThread:=BOn;

  Inherited Process;

  Count:=0;

  //Set KeyStrings - we're doing either Customers, Consumers or Suppliers so
  //Use the CustAcCodeK index (SubType/CustCode) and prefix the code with the appropriate subtype
  KeyS:= AcTypePrefix[FAccountType];
  if Trim(FAccountFrom) <> '' then
   KeyS := KeyS + FullCustCode(FAccountFrom);

  KeyEnd := AcTypePrefix[FAccountType];
  if Trim(FAccountTo) <> '' then
    KeyEnd := KeyEnd + FullCustCode(FAccountTo)
  else
    KeyEnd := KeyEnd + StringOfChar(Char(255), 6);

  With MTExLocal^ do
  Begin
    InitProgress(Used_RecsCId(LocalF^[CustF], CustF, ExCLientId));

    //get first required account
    LStatus:=LFind_Rec(B_GetGEq, CustF, CustACCodeK, KeyS);

    While (LStatusOk) and (Not Has_Aborted) and (KeyS <= KeyEnd) do
    With LCust do
    Begin
      {$IFDEF SOP}
       //Check if Invoice To is populated
       UseHeadOffice := Trim(LCust.SOPInvCode) <> '';
       if UseHeadOffice then
       begin
         //Save position & index
         TmpKPath := GetPosKey;
         TmpStat:=LPresrv_BTPos(CustF,TmpKPath,LocalF^[CustF],TmpRecAddr,BOff,BOff);

         //Find H/O account
         Key2 := LCust.SOPInvCode;
         LStatus := LFind_Rec(B_GetEq, CustF, CustCodeK, Key2);

         //PR: 18/02/2016 v2016 R1 FIX_WARNINGS Amended to check LStatus rather than Res which was never used
         if LStatus <> 0 then //If we didn't find the H/O account then reload this account
         begin
           TmpStat:=LPresrv_BTPos(CustF,TmpKPath,LocaLF^[CustF],TmpRecAddr,BOn,BOff);
           UseHeadOffice := False;
         end;
       end;
      {$ENDIF}


      //Call function to unallocate the transactions for the account
      UnallocateAccount(LCust.CustCode);

      Inc(Count);

      UpdateProgress(Count);

      {$IFDEF SOP}
      //Restore position and index if required
      if UseHeadOffice then
         TmpStat:=LPresrv_BTPos(CustF,TmpKPath,LocaLF^[CustF],TmpRecAddr,BOn,BOff);
      {$ENDIF}

      //Find next account
      LStatus:=LFind_Rec(B_GetNext, CustF, CustACCodeK, KeyS);
    end;
  end;



end;

function TUnallocateTransactions.Start: Boolean;
begin
  Result := True;

  Set_BackThreadMVisible(BOff);

  if SQLUtils.UsingSQL then
  begin
    // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
    if (not Assigned(LPostLocal)) then
      Result := Create_LocalThreadFiles;

    If (Result) then
      MTExLocal := LPostLocal;

  end
  else
  begin
    If (Not Assigned(PostExLocal)) then { Open up files here }
      Result:=Create_ThreadFiles;

    If (Result) then
    Begin
      MTExLocal:=PostExLocal;

    end;
  end;

  If (Result) then {Attempt to lock all posting modes}
    Result:=PostLockCtrl(0);

  If (Not Result) then {* Remove lock... *}
    PostUnLock(0);

  if Result and SQLUtils.UsingSQL then
  begin
    MTExLocal^.Close_Files;
    CloseClientIdSession(MTExLocal^.ExClientID, False);
  end;
end;

//procedure to unallocate all transactions for ThisAccount. Mostly copied from EL's code that was previously in TCheckCust.Check_Cust
procedure TUnallocateTransactions.UnallocateAccount(ThisAccount: Str255);
var
  KeyS : Str255;
  WarnAbort : Boolean;
  Locked : Boolean;
  LOk : Boolean;
  Ok2Match : Boolean;
  KeyLen : Integer;

begin
  WarnAbort:=BOff;

  With MTExLocal^ do
  Begin
    ShowStatus(2, dbFormatName(LCust.CustCode, LCust.Company));

    //Set key strings
    KeyS := ThisAccount;
    KeyLen := Length(KeyS);

    //Find first transaction for account
    LStatus:=LFind_Rec(B_GetGEq, InvF, InvCustK, KeyS);

    While (LStatusOk) and (CheckKey(ThisAccount,KeyS,KeyLen,BOff)) do
    With LInv do
    Begin
      If (Not WarnAbort) and (Has_Aborted) then
      Begin
        ShowStatus(3,'Please Wait, finishing this account.');

        WarnAbort:=BOn;
      end;

      //Don't allow Order Payments or revalued transactions to be unallocated
      If Not (InvDocHed In QuotesSet + PSOPSet + WOPSplit + JAPSplit + StkRetSplit + DirectSet) and
             Not ReValued(LInv) and (thOrderPaymentElement = opeNA) then
      Begin
        LOk:=LGetMultiRec(B_GetDirect, B_MultLock, KeyS, InvCustK, InvF, BOn, Locked);

        If (LOk) and (Locked) then
        Begin
          //Store record address for unlocking
          LGetRecAddr(InvF);

          ShowStatus(3, 'Processing ' + OurRef);

          //Zero settled values
          Settled:=0;
          CurrSettled:=0;

          If (AfterPurge(AcYr,0)) then {* v4.32 don't reset this on purged year transactions *}
            CXRate[BOff]:=0;

          Ok2Match := (RemitNo<>'');  {* Has Doc got auto Match Lines *}

          FillChar(RemitNo,Sizeof(RemitNo),0);

          If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* Cash Accounting set Blank VATdate & Until Date *}
          Begin
            If (SettledVAT=0) then
            Begin

              FillChar(VATPostDate,Sizeof(VATPostDate),0);

              UntilDate:=NdxWeight;

              {FillChar(UntilDate,Sizeof(UntilDate),0);}

            end
            else
            Begin

              VATPostDate:=SyssVAT.VATRates.CurrPeriod;

              UntilDate:=Today;

            end;
          end
          else
            UntilDate:=NdxWeight;


          {$IFDEF JC}
            Set_DocCISDate(LInv,BOn);
          {$ENDIF}

          Set_DocAlcStat(LInv);  {* Set Allocation Status *}



         LStatus:=LPut_Rec(InvF, InvCustK);

         If (LStatusOk) then
           LStatus:=LUnLockMLock(InvF);

        {$IFDEF CL_On}
          //Remove matching
          If (LStatusOk) then
          Begin
            //Check for any matched OP transactions
            CheckMatchedTransactions;

            //SS:22/08/2017:2017-R2:ABSEXCH-19006:Unallocating from utilities menu option does not set matching correctly resulting in a doubling up of matching information when resettling.
            LRemove_MatchPay(LInv.OurRef,DocMatchTyp[BOff],MatchSCode, Ok2Match);  {* Delete Auto Account match lines *}

            LRemove_MatchPay(LInv.OurRef,DocMatchTyp[BOn],MatchSCode,not Ok2Match);  {* Delete Artificial match lines from batch payments*}

          end;
        {$ENDIF}


        end; {If Locked..}
      end; //Not (InvDocHed In QuotesSet + PSOPSet, etc


      If (LStatusOk) then  //Get next transaction
        LStatus:=LFind_Rec(B_GetNext, InvF, InvCustK, KeyS);

    end; {While..}

  end;
end;

procedure AddUnallocateTransactions2Thread(AOwner : TObject;
                                           AccountType : Byte;
                                           AccountFrom : string;
                                           AccountTo : string);
var
  UnallocateTrans : ^TUnallocateTransactions;
begin
  if (Create_BackThread) then
  begin
    //create unallocation object
    New(UnallocateTrans,Create(AOwner));

    try
      //Set properties
      UnallocateTrans.AccountType := AccountType;
      UnallocateTrans.AccountFrom := AccountFrom;
      UnallocateTrans.AccountTo := AccountTo;

      with UnallocateTrans^ do
      begin
        If (Start) and (Create_BackThread) then
        Begin
          With BackThread do
            AddTask(UnallocateTrans,'Unllocating transactions');
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(UnallocateTrans,Destroy);
        end;
      end; {with..}

    except
      Dispose(UnallocateTrans,Destroy);

    end; {try..}
  end; {If process got ok..}
end;

//PR 27/06/2017 ABSEXCH-18860 function to call RemovedLastCommit stored proc directly so
//a timeout can be set. Takes the timeout from DeleteCommitmentHistoryTimeoutInSeconds in
//SQLConfig.ini
{$IFDEF SOP}
procedure TEntPost.SQLRemoveLastCommit;
var
  SQLCaller : TSQLCaller;
  CompanyCode : string;
  ConnectionString,
  lPassword : WideString;
begin
  SQLCaller := TSQLCaller.Create(nil);

  Try
    // Determine the company code
    CompanyCode := SQLUtils.GetCompanyCode(SetDrive);

    // Set up the ADO Connection for the SQL Caller
    //SQLUtils.GetConnectionString(CompanyCode, False, ConnectionString);
    SQLUtils.GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword);
    SQLCaller.ConnectionString := ConnectionString;
    SQLCaller.Connection.Password := lPassword;
    //Set timeout
    SQLCaller.Connection.CommandTimeOut := SQLReportsConfiguration.DeleteCommitmentHistoryTimeoutInSeconds;
    SQLCaller.Connection.ConnectionTimeOut := SQLReportsConfiguration.DeleteCommitmentHistoryTimeoutInSeconds;

    //Call stored procedure
    SQLCaller.ExecSQL('EXEC [COMPANY].isp_RemovedLastCommit', CompanyCode);

  Finally
    SQLCaller.Free;
  End;
end;
{$ENDIF}
Initialization


  AlreadyInPost:=BOff;

Finalization


end.
