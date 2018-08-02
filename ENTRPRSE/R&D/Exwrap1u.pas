unit ExWrap1U;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VARRec2U,VarConst,

  VarJCStU,

  BtrvU2,BtSupU1,BTSupU3

   ,MultiBuyVar
   ,QtyBreakVar  //PR: 09/02/2012 ABSEXCH-9795
   ,BudgetHistoryVar //PR: 04/07/2012 ABSEXCH-12957

  {$IFDEF RW}
    ,RwOpenF
  {$ENDIF}
  {$IFDEF XO}
    ,XOVarCon
  {$ENDIF}
  {$IFDEF WCA}
    ,CardVarC
  {$ENDIF}

  ;


type

  // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
  TVATDirection = (vatInput, vatOutput);

  // Array of values which have been excluded from the VAT Report because
  // they were against NoTCs which should not be reported on. We need to
  // keep a record of these so that we can subtract them from the totals
  // returned from History (used by Box1, Box 6 and Box 7)
  TExcludedNoTCValues = array[vatInput..vatOutput] of Double;

  TdExLocalPtr  =  ^TdExLocal;

  TdExLocal  =  Object

                  LCust,
                  LastCust
                         :  CustRec;

                  LInv,
                  LastInv
                         :  InvRec;

                  LId,
                  LastId :   Idetail;

                  LNom,
                  LastNom:   NominalRec;

                  LStock,
                  LastStock
                         :   StockRec;

                  LNomView,
                  LastNomView
                       :   NomViewPtr;

                  LMLocCtrl,
                  {$IFDEF OLE}
                  LMLoc,
                  LMStkLoc,
                  LMAltCode,
                  {$ENDIF}
                  LastMLoc
                         :   MLocPtr;

                  LastHist,
                  LNHist :   HistoryRec;

                  LastCount,
                  LCount :   IncrementRec;

                  LastPassword,
                  LPassword
                         :   PasswordRec;

                  LastMisc,
                  LMiscRecs
                         :   MiscRecPtr;

                  LRepScr
                         :   RepScrPtr;

                  LSyss  :   Sysrec;
                  LSyssVAT
                         :   VATRecT;
                  LSyssCurr
                         :   CurrRec;

                  LSyssDEF
                         :   DefRecT;

                  {$IFDEF OLE}
                  LSyssGCur
                         :   GCurRec;

                  LSyssCurr1P
                         :   ^Curr1PRec;
                  LSyssGCur1P
                         :   ^GCur1PRec;

                  LSyssJob
                         :   JobSRecT;

                  LSyssMod
                         :   ^ModRelRecType;
                  lSyssEDI2: ^EDI2Rec;

                  LSyssCIS   : CISRecT;
                  {$ENDIF}

                  LJobMisc,
                  LastJobMisc
                         :   JobMiscPtr;

                  LJobRec,
                  LastJobRec
                         :   JobRecPtr;

                  LJobCtrl,
                  LastJobCtrl
                         :   JobCtrlPtr;

                  LJobDetl,
                  LastJobDetl
                         :   JobDetlPtr;

                  LInvNetAnal,
                  LInvVATAnal,  // Only required for Irish VAT
                  LInvNetAnalLessServices
                         :    INetAnalType;

                  LInvNetTrig
                         :    IVATAnalType;

                  LJAPLineTotal
                         :   tJALLTTypes;

                  LMultiBuyDiscount,
                  LastMultiBuyDiscount
                         : TMultiBuyDiscount;

                  //PR: 09/02/2012 ABSEXCH-9795
                  LQtyBreakRec,
                  LastQtyBreakRec
                         : TQtyBreakRec;

                  //PR: 04/07/2012 ABSEXCH-12957
                  LBudgetHistory,
                  LastBudgetHistory
                         : TBudgetHistoryRec;
                  {$IFDEF RW}
                  LRepGen : RepGenPtr;
                  LastRepGen: RepGenPtr;

                  LDict    : DataDictPtr;
                  LastDict : DataDictPtr;
                  {$ENDIF}

                  {$IFDEF XO}
                  LxoList     : xoListRecPtr;
                  LastxoList  : xoListRecPtr;

                  LxoGroup    : xoGroupFilePtr;
                  LastxoGroup : xoGroupFilePtr;
                  {$ENDIF}

                  {$IFDEF WCA}
                  LcsCard     : csCardRecPtr;
                  LastcsCard  : csCardRecPtr;

                  LcsInv      : csInvRecPtr;
                  LastcsInv   : csInvRecPtr;

                  LcsSales    : csSalesDetRecPtr;
                  LastcsSales : csSalesDetRecPtr;
                  {$ENDIF}

                  LRecPtr
                         :   Array[1..MaxFiles] of RecCPtr;

                  { CJS 2013-05-28 - v7.0.4 - ABSEXCH-11898 - Notional VAT on EC Purchases }
                  NotionalVATSource: Double;
                  NotionalVAT: Double;

                  // CJS 2014-03-03 - ABSEXCH-15076 - Irish VAT EC Services
                  InvECServiceTotals: TECServiceTotals;

                  // CJS 2015-05-28 - ABSEXCH-16260 - VAT100 report Box 8
                  LFreeOfChargeAnalysis: INetAnalType;

                  // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
                  // Array of excluded Nature of Transaction Code values
                  ExcludedNoTCValues: TExcludedNoTCValues;

                  // Flag to indicate that we are running a VAT Return -- see
                  // MiscU.pas, LDef_InvCalc()
                  ForVATReturn: Boolean;

                  StartNo,
                  EndNo  :  Integer;

                  LastIns,
                  LastEdit,
                  InAddEdit,
                  LForcedAdd,
                  LNeedRefs,
                  LSetRefs,
                  LViewOnly,
                  LManVATOR
                         :  Boolean;
                  LastRecAddr
                         :  Array[1..MaxFiles] of LongInt;

                  LCtrlInt
                         :  LongInt;  {Hook variable used to exchange non record info from/to hooks}

                  LCtrlDbl
                         :  Double;  {Hook variable used to exchange non record info from/to hooks}
                  LCtrlStr
                         :  Str255;  {Hook variable used to exchange non record info from/to hooks}

                  Constructor Create;

                  Destructor Destroy;

                  Procedure LResetRec(FNum  :  Integer);

                  Procedure LSetDataRecOfs(FileNum  :  Integer;
                                           Ofset    :  LongInt);

                  Procedure SetStart(IdxNo  :  Integer);

                  Procedure AssignFromGlobal(IdxNo  :  Integer);

                  Procedure AssignToGlobal(IdxNo  :  Integer);

                  Procedure LGetRecAddr(Fnum :  Integer);

                  Function LGetMainRecPos(Fnum  :  SmallInt;
                                          KeyS  :  Str255)  :  Boolean;

                  Function LGetMainRecPosKey(Fnum,
                                             KPath :  SmallInt;
                                             KeyS  :  Str255)  :  Boolean;

                  Function LGetDirectRec(Fnum,
                                         KeyPath :  Integer)  :  Integer;

                  Function UnLockMLock(Fnum    :  Integer;
                                       LRAddr  :  LongInt)  :  Integer;


                  Function LPresrv_BTPos(Fnum      :  Integer;
                                     Var Keypath   :  Integer;
                                     Var LFV       :  FileVar;
                                     Var RecAddr   :  LongInt;
                                         UsePos,
                                         RetRec    :  Boolean)  :  Integer;

                  Function LGetMultiRec(Func      :  Integer;
                                        LockType  :  Integer;
                                    Var Key2S     :  Str255;
                                        KeyPth    :  Integer;
                                        Fnum      :  Integer;
                                        Wait      :  Boolean;
                                    Var Locked    :  Boolean) : Boolean;


                  Function LSecure_Add(Fnum,
                                       Keypath  :  Integer;
                                       Mode     :  Byte)  :  Boolean;

                  Function LSecure_InvPut(Fnum,
                                          Keypath  :  Integer;
                                          Mode     :  Byte)  :  Integer;


               end;


               { == This instance of Exlocal is used to control seperate thread versions of all the files == }

               { == Id registry ==

                   2  =  main posting thread

                   3-5,
                   6-8  Daybook totals form. 1 for each daybook type+ double if order version of daybook

                   10   Bank Rec Cleared Status
                   11   Stk BOM update Costings
                   12   VAT Cash Accounting Close Period.
                   13   Update Budget Headings globally
                   14   Main Report Thread
                   15   Live credit status update credit status
                   16   Update default Stock valuation type
                17-23   SOP Batch Run mode
                   25   Live Comitted Update
                   27   Individual Form print via Thread.
                   28   Move Stock to new global location
                   29   Credit Controller Aging
                   30      "      "       SPOP break down
                   31   Stock Enquiry Thread.
                   32   Job Costing Employee Ceretificate update;
                33-40   Move Thread
                   41   Accrual Posting
                   42   Roll up Budget Cc/Dep Totals
                   50   Object Price Lookup
                   51   Recalc TeleSales Totals

                   60   E-business module
                   61        "       "
                   62        "       "
                   63,64 EBanking
                80-89  Customisation
                90-99  OLE Server
                   90  Temporary Id in Job Application form
                   91  PPD Ledger (v7.0.14)
                   92  Take PPD business object (v7.0.14)
                   93  Order Payments Unmatched Receipts

                  700  Stock Levels Form
                  701  SQL Full Trial Balance - Being_Posted Check
                NOTE:  Id's appear to be 2 character numbers. ie. 00-99. If numbers
                       above this are used miscellaneous GPF's occur.
                 CJS:  SQL can go up to 4000 (see SetThreadKeyPath in BtrvU2.pas)
               ==}

  TdMTExLocalPtr  =  ^TdMTExLocal;

  TdMTExLocal  =  Object(TdExLocal)

                    LocalF      :  ^FPosBlkType;
                    ExClientId  :  ^ClientIdType;
                    LStatus     :  Integer;
                    LWinHandle  :  THandle;
                    LThShowMsg  :  TSBSMsgEvent;
                    LThPrintJob :  TSBSPrintEvent;

                    UsePrompt   :  Boolean;

                    Constructor Create(CIdNo  :  SmallInt); Overload;
                    // MH 23/07/2014 v7.X: Added ability to change Client Id Prefix for Order Payments
                    Constructor Create(CIdNo : SmallInt; Const CIdPrefix : ShortString); Overload;

                    Destructor Destroy;

                    Procedure LGetRecAddr(Fnum :  Integer);

                    Function LGetDirectRec(Fnum,
                                           KeyPath :  Integer)  :  Integer;

                    Function UnLockMLock(Fnum    :  Integer;
                                         LRAddr  :  LongInt)  :  Integer;


                    Function LPresrv_BTPos(Fnum      :  Integer;
                                       Var Keypath   :  Integer;
                                       Var LFV       :  FileVar;
                                       Var RecAddr   :  LongInt;
                                           UsePos,
                                           RetRec    :  Boolean)  :  Integer;

                    //PR: 15/07/2015 A version of LPresrv_BTPos which updates the local rather than global record (See ABSEXCH-16672)
                    Function LPresrv_BTPosLocal(Fnum      :  Integer;
                                           Var Keypath   :  Integer;
                                           Var LFV       :  FileVar;
                                           Var RecAddr   :  LongInt;
                                               UsePos,
                                               RetRec    :  Boolean)  :  Integer;


                    Function LLock_Direct(Func  :  Integer;
                                          Fnum  :  Integer;
                                          KeyPth:  Integer;
                                          BtRec :  RecCPtr)  :  Integer;

                    Function LTry_Lock(Func      :  Integer;
                                       LockType  :  Integer;
                                   Var Key2S     :  Str255;
                                       KeyPth    :  Integer;
                                       Fnum      :  Integer;
                                       BtRec     :  RecCPtr)  :  Integer;

                    Procedure Send_UpdateList(Mode   :  Integer);

                    Function LGetMultiRec(Func      :  Integer;
                                          LockType  :  Integer;
                                      Var Key2S     :  Str255;
                                          KeyPth    :  Integer;
                                          Fnum      :  Integer;
                                          Wait      :  Boolean;
                                      Var Locked    :  Boolean) : Boolean;

                    Function LGetMultiRecAddr(Func      :  Integer;
                                          LockType  :  Integer;
                                      Var Key2S     :  Str255;
                                          KeyPth    :  Integer;
                                          Fnum      :  Integer;
                                          Wait      :  Boolean;
                                      Var Locked    :  Boolean;
                                      Var LRecAddr  :  LongInt) : Boolean;


                    Function NonFatalStatus(StatNo  :  Integer)  :  Boolean;

                    Procedure Open_System(Start,Fin  :  Integer);

                    Procedure Close_Files;

                    Function LStatusOk  :  Boolean;

                    Function LFind_Rec(BFunc,
                                       FNum,
                                       KPath  :  SmallInt;
                                   Var FKey   :  Str255)  :  SmallInt;

                    Function LAdd_Rec(FNum,
                                      KPath  :  SmallInt)  :  SmallInt;

                    Function LPut_Rec(FNum,
                                      KPath  :  SmallInt)  :  SmallInt;

                    Function LDelete_Rec(FNum,
                                         KPath  :  SmallInt)  :  SmallInt;

                    Function LGetPos(FNum     :  SmallInt;
                                 Var RecAddr  :  LongInt)  :  SmallInt;

                    Function LGetDirect(FNum,
                                        KPath,
                                        LMode  :  SmallInt)  :  SmallInt;


                    Function LCtrl_BTrans(BeginMode  :  Byte)  :  SmallInt;

                    Function LGetMainRec(Fnum  :  SmallInt;
                                         KeyS  :  Str255)  :  Boolean;

                    Function LGetMainRecPos(Fnum  :  SmallInt;
                                            KeyS  :  Str255)  :  Boolean;

                    Function LGetMainRecPosKey(Fnum,
                                               KPath :  SmallInt;
                                               KeyS  :  Str255)  :  Boolean;

                    Procedure LReport_BError(Fnum,ErrNo  :  SmallInt);

                    procedure LReport_Error(ErrorMsg: Str255);

                    Procedure LReport_IOError(ErrNo   :  Integer;
                                              Fname   :  Str255);

                    Function LUnLockMLock(Fnum :  SmallInt)  :  SmallInt;

                    Function LFileVer(FNum  :  SmallInt)  :  Byte;

                    {$IFDEF EXSQL}
                    Function LGetNextCount(DocHed     :  DocTypes;
                                           Increment,
                                           UpLast     :  Boolean;
                                           NewValue   :  Real)  :  LongInt;
                    Function LGet_NextChequeNo(Increment  :  Boolean)  :  Str80;

                    Procedure LPut_NextChequeNo(NewVal     :  Str80;
                                                Increment  :  Boolean);

                    Function LGetMultiFrmDefs(PageNo  :  Integer)  :  FormDefsRecType;

                    Function LCheckValidNCC(ChkComm  :  Boolean)  :  Boolean;
                    {$ENDIF}

                  end; {object..}



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,Forms,
  ETMiscU,
  ETStrU,
  SysU1,
  BTKeys1U,

  {$IFNDEF RW}
    {$IFNDEF XO}
      {$IFNDEF OLE}
        {$IFNDEF EDLL}
         {$IFNDEF ENDV}
         {$IFNDEF WCA}    { Windows Card System }
         {$IFNDEF EXDLL}
          {$IFNDEF COMP}
          {$IFNDEF EBAD}
            Excep2U,
          {$ENDIF}
          {$ENDIF}
         {$ENDIF}
         {$ENDIF}
         {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  BTSFrmU1;

{ ============== TdExLocal Methods ============== }

Constructor TdExLocal.Create;

Begin

  New(LMiscRecs);
  New(LastMisc);

  New(LRepScr);

  New(LJobMisc);
  New(LastJobMisc);

  New(LJobRec);

  New(LastJobRec);

  New(LJobCtrl);

  New(LastJobCtrl);

  New(LJobDetl);

  New(LastJobDetl);

  New(LMLocCtrl);
  New(LastMLoc);

  New(LNomView);
  New(LastNomView);

  {$IFDEF OLE}
    New(LMLoc);
    FillChar(LMLoc^,Sizeof(LMLoc^),0);

    New(LMStkLoc);
    FillChar(LMStkLoc^,Sizeof(LMStkLoc^),0);

    New(LMAltCode);
    FillChar(LMAltCode^,Sizeof(LMAltCode^),0);

    New(LSyssCurr1P);
    FillChar(LSyssCurr1P^,Sizeof(LSyssCurr1P^),0);

    New(LSyssGCur1P);
    FillChar(LSyssGCur1P^,Sizeof(LSyssGCur1P^),0);

    New(LSyssMod);
    FillChar(LSyssMod^,Sizeof(LSyssMod^),0);
    {HV 14/11/2017 ABSEXCH-19415: this line added to fix the Forgot Password Functionality not working in OLE Server
    this line is added to initialize company's Fax/Email settings}
    New(lSyssEDI2);
    FillChar(lSyssEDI2^,Sizeof(lSyssEDI2^),0);

    FillChar(LSyssCIS,Sizeof(LSyssCIS),0);
  {$ENDIF}

  {$IFDEF RW}
  New (LRepGen);
  New (LastRepGen);

  New (LDict);
  New (LastDict);
  {$ENDIF}

  {$IFDEF XO}
    New (LxoList);
    New (LastxoList);

    New (LxoGroup);
    New (LastxoGroup);
  {$ENDIF}

  {$IFDEF WCA}
    New(LcsCard);
    New(LastcsCard);

    New (LcsInv);
    New (LastcsInv);

    New (LcsSales);
    New (LastcsSales);

  {$ENDIF}

  LRecPtr[CustF]:=@LCust;
  LRecPtr[InvF]:=@LInv;
  LRecPtr[IDetailF]:=@LId;
  LRecPtr[NomF]:=@LNom;
  LRecPtr[StockF]:=@LStock;
  LRecPtr[NHistF]:=@LNHist;
  LRecPtr[IncF]:=@LCount;
  LRecPtr[PWrdF]:=@LPassword;
  LRecPtr[MiscF]:=@LMiscRecs^;

  LRecPtr[ReportF]:=@LRepScr^;
  LRecPtr[SysF]:=@LSyss;

  LRecPtr[JMiscF]:=@LJobMisc^;

  LRecPtr[JobF]:=@LJobRec^;

  LRecPtr[JCtrlF]:=@LJobCtrl^;

  LRecPtr[JDetlF]:=@LJobDetl^;

  LRecPtr[MLocF]:=@LMLocCtrl^;

  LRecPtr[NomViewF]:=@LNomView^;

  {.$IFDEF SOP}
  LRecPtr[MultiBuyF]:=@LMultiBuyDiscount;
  {.$ENDIF}

  //PR: 07/02/2012 ABSEXCH-9795
  LRecPtr[QtyBreakF]:=@LQtyBreakRec;

  //PR: 04/07/2012 ABSEXCH-12957
  LRecPtr[BudgetHistoryF]:=@LBudgetHistory;

  {$IFDEF RW}
  LRecPtr[RepGenF]:=@LRepGen^;
  LRecPtr[DictF]:=@LDict^;
  {$ENDIF}

  {$IFDEF XO}
  LRecPtr[xoListF]:=@LxoList^;
  LRecPtr[xoGroupF]:=@LxoGroup^;
  {$ENDIF}

  {$IFDEF WCA}
  LRecPtr[csCardF]:=@LcsCard^;
  LRecPtr[csInvF]:=@LcsInv^;
  LRecPtr[csSalesF]:=@LcsSales^;
  {$ENDIF}

  LastEdit:=BOff;
  InAddEdit:=BOff;
  LastIns:=BOff;
  LForcedAdd:=BOff;

  LCtrlDbl:=0.0;
  LNeedRefs:=BOff;
  LSetRefs:=BOff;

  FillChar(LastRecAddr,Sizeof(LAstRecAddr),0);
  FillChar(LInvNetAnal,Sizeof(LInvNetAnal),0);
  FillChar(LInvNetAnalLessServices,Sizeof(LInvNetAnalLessServices),0);
  FillChar(LInvNetTrig,Sizeof(LInvNetTrig),0);
  FillChar(LastMisc^,Sizeof(LastMisc^),0);
  FillChar(LastJobMisc^,Sizeof(LastJobMisc^),0);
  FillChar(LastJobCtrl^,Sizeof(LastJobCtrl^),0);
  FillChar(LastJobDetl^,Sizeof(LastJobDetl^),0);

  FillChar(LJAPLineTotal,Sizeof(LJAPLineTotal),0);


  LResetRec(CustF);
  LResetRec(InvF);
  LResetRec(IDetailF);
  LResetRec(StockF);
  LResetRec(PWrdF);
  LResetRec(NHistF);
  LResetRec(SysF);
  LResetRec(NomF);
  LResetRec(IncF);

  LResetRec(NomViewF);
  FillChar(LastNomView^,Sizeof(LastNomView^),#0);

  FillChar(LastCust,Sizeof(LastCust),0);
  FillChar(LastInv,Sizeof(LastInv),0);
  FillChar(LastId,Sizeof(LastId),0);
  FillChar(LastStock,Sizeof(LastStock),0);
  FillChar(LastNom,Sizeof(LastNom),0);
  FillChar(LastCount,Sizeof(LastCount),0);

  LManVATOR:=BOff;

  // CJS 2016-02-18 - ABSEXCH-16569 - exclude NoTc from Box 8 and 9 on VAT return
  ForVATReturn := False;
end;


Destructor TdExLocal.Destroy;

Begin

If (Assigned(LMiscRecs)) then
    Dispose(LMiscRecs);

  LMiscRecs:=nil;


  If (Assigned(LastMisc)) then
    Dispose(LastMisc);

  LastMisc:=nil;

  If (Assigned(LRepScr)) then
    Dispose(LRepScr);

  LRepScr:=nil;

  If (Assigned(LJobMisc)) then
    Dispose(LJobMisc);

  LJobMisc:=nil;

  If (Assigned(LastJobMisc)) then
    Dispose(LastJobMisc);

  LastJobMisc:=nil;

  If (Assigned(LJobRec)) then
    Dispose(LJobRec);

  LJobRec:=nil;

  If (Assigned(LastJobRec)) then
    Dispose(LastJobRec);

  LastJobRec:=nil;

  If (Assigned(LJobCtrl)) then
    Dispose(LJobCtrl);

  LJobCtrl:=nil;

  If (Assigned(LastJobCtrl)) then
    Dispose(LastJobCtrl);

  LastJobCtrl:=nil;


  If (Assigned(LJobDetl)) then
    Dispose(LJobDetl);

  LJobDetl:=nil;

  If (Assigned(LastJobDetl)) then
    Dispose(LastJobDetl);

  LastJobDetl:=nil;

  If (Assigned(LNomView)) then
    Dispose(LNomView);

  LNomView:=nil;

  If (Assigned(LastNomView)) then
    Dispose(LastNomView);

  LastNomView:=nil;

  {$IFDEF OLE}
    If Assigned (LMLoc) Then Dispose(LMLoc);
    LMLoc := Nil;

    If Assigned (LMStkLoc) Then Dispose(LMStkLoc);
    LMStkLoc := Nil;

    If Assigned (LMAltCode) Then Dispose(LMAltCode);
    LMAltCode := Nil;

    If Assigned (LSyssCurr1P) Then Dispose(LSyssCurr1P);
    LSyssCurr1P := Nil;

    If Assigned (LSyssGCur1P) Then Dispose(LSyssGCur1P);
    LSyssGCur1P := Nil;

    If Assigned (LSyssMod) Then Dispose(LSyssMod);
    {HV 14/11/2017 ABSEXCH-19415: this line added to fix the Forgot Password Functionality not working in OLE Server
    this line is added to initialize company's Fax/Email settings}
    If Assigned (lSyssEDI2) Then Dispose(lSyssEDI2);
    LSyssMod := Nil;
  {$ENDIF}

  If (Assigned(LMLocCtrl)) then
    Dispose(LMLocCtrl);

  LMLocCtrl:=nil;

  If (Assigned(LastMLoc)) then
    Dispose(LastMLoc);

  LastMLoc:=nil;

  {$IFDEF RW}
  Dispose(LRepGen);
  Dispose(LastRepGen);

  Dispose(LDict);
  Dispose(LastDict);
  {$ENDIF}

  {$IFDEF XO}
    Dispose(LxoList);
    Dispose(LastxoList);

    Dispose(LxoGroup);
    Dispose(LastxoGroup);
  {$ENDIF}

  {$IFDEF WCA}
    Dispose(LcsCard);
    Dispose(LastcsCard);

    Dispose (LcsInv);
    Dispose (LastcsInv);

    Dispose (LcsSales);
    Dispose (LastcsSales);
  {$ENDIF}
end;


{ ================ Procedure to Reset Current Record ============== }

Procedure TdExLocal.LResetRec(FNum  :  Integer);

Begin
  Case Fnum of

   CustF    :  FillChar(LCust,FileRecLen[FNum],0);
   InvF     :  FillChar(LInv,FileRecLen[FNum],0);
   IdetailF :  FillChar(LId,FileRecLen[FNum],0);
   NomF     :  FillChar(LNom,FileRecLen[FNum],0);
   StockF   :  FillChar(LStock,FileRecLen[FNum],0);
   NHistF   :  FillChar(LNHist,FileRecLen[FNum],0);
   IncF     :  FillChar(LCount,FileRecLen[FNum],0);
   PWrdF    :  FillChar(LPassWord,FileRecLen[FNum],0);
   MiscF    :  FillChar(LMiscRecs^,FileRecLen[FNum],0);
   JMiscF   :  FillChar(LJobMisc^,FileRecLen[FNum],0);
   JobF     :  FillChar(LJobRec^,FileRecLen[FNum],0);
   JCtrlF   :  FillChar(LJobCtrl^,FileRecLen[FNum],0);
   JDetlF   :  FillChar(LJobDetl^,FileRecLen[FNum],0);
   MLocF    :  FillChar(LMLocCtrl^,FileRecLen[FNum],0);
   SysF     :  FillChar(LSyss,FileRecLen[FNum],0);
   ReportF  :  FillChar(LRepScr^,FileRecLen[FNum],0);

   NomViewF
            :  FillChar(LNomView^,FileRecLen[FNum],0);

   MultiBuyF:  FillChar(LMultiBuyDiscount, FileRecLen[FNum],0);

   //PR: 09/02/2012 ABSEXCH-9795
   QtyBreakF:  FillChar(LQtyBreakRec, FileRecLen[FNum],0);

   {$IFDEF RW}
   RepGenF  :  FillChar(LRepGen^,FileRecLen[FNum],0);
   DictF    :  FillChar(LDict^,FileRecLen[FNum],0);
   {$ENDIF}
   {$IFDEF XO}
   xoListF  :  FillChar(LxoList^,FileRecLen[FNum],0);
   xoGroupF :  FillChar(LxoGroup^,FileRecLen[FNum],0);
   {$ENDIF}
   {$IFDEF WCA}
    csCardF  :  FillChar(LcsCard^,FileRecLen[FNum],0);
    csInvF   :  FillChar(LcsInv^,FileRecLen[FNum],0);
    csSalesF :  FillChar(LcsSales^,FileRecLen[FNum],0);
   {$ENDIF}
  end; {Case..}
end;





{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }

Procedure TdExLocal.LSetDataRecOfs(FileNum  :  Integer;
                                   Ofset    :  LongInt);

Begin

  Move(Ofset,LRecPtr[FileNum]^,Sizeof(Ofset));

end;


Procedure TdExLocal.SetStart(IdxNo  :  Integer);

Begin

  If (IdxNo=0) then
  Begin
    StartNo:=1;
    EndNo:=TotFiles;
  end
  else
  Begin
    StartNo:=IdxNo;
    EndNo:=IdxNo;
  end;

end;

Procedure TdExLocal.AssignFromGlobal(IdxNo  :  Integer);

Var
  n         :   Integer;
Begin


  SetStart(IdxNo);

  For n:=StartNo to EndNo do
    Case n of

      CustF      :  LCust:=Cust;
      InvF       :  LInv:=Inv;
      IdetailF   :  LId:=Id;
      NomF       :  LNom:=Nom;
      StockF     :  LStock:=Stock;
      NHistF     :  LNHist:=NHist;
      IncF       :  LCount:=Count;
      PWrdF      :  LPassword:=Password;
      MiscF      :  LMiscRecs^:=MiscRecs^;
      ReportF    :  LRepScr^:=RepScr^;
      SysF       :  LSyss:=Syss;
      JMiscF     :  LJobMisc^:=JobMisc^;
      JobF       :  LJobRec^:=JobRec^;
      JCtrlF     :  LJobCtrl^:=JobCtrl^;
      JDetlF     :  LJobDetl^:=JobDetl^;
      MLocF      :  LMLocCtrl^:=MLocCtrl^;

      NomViewF
                 :  LNomView^:=NomView^;

      //PR: 07/02/2012 Added QtyBreak for ABSEXCH-9795. Noticed the MultiBuyDiscount was missing, so added that as well.
      QtyBreakF  :  LQtyBreakRec := QtyBreakRec;
      MultiBuyF
                 :  LMultiBuyDiscount := MultiBuyDiscount;

      {$IFDEF RW}
      RepGenF    :  LRepGen^:=RepGenRecs^;
      DictF      :  LDict^:=DictRec^;
      {$ENDIF}
      {$IFDEF XO}
      xoListF    :  LxoList^  := xoList^;
      xoGroupF   :  LxoGroup^ := xoGroup^;
      {$ENDIF}
      {$IFDEF WCA}
       csCardF   :  LcsCard^ := csCard;
       csInvF    :  LcsInv^ := csInv;
       csSalesF  :  LcsSales^ := csSalesDet;
      {$ENDIF}
    end; {Case..}

end;


Procedure TdExLocal.AssignToGlobal(IdxNo  :  Integer);

Var
  n     :   Integer;
Begin

  SetStart(IdxNo);

  For n:=StartNo to EndNo do
    Case n of

      CustF      :  Cust:=LCust;
      InvF       :  Inv:=LInv;
      IdetailF   :  Id:=LId;
      NomF       :  Nom:=LNom;
      StockF     :  Stock:=LStock;
      NHistF     :  NHist:=LNHist;
      IncF       :  Count:=LCount;
      PWrdF      :  Password:=LPassword;
      MiscF      :  MiscRecs^:=LMiscRecs^;
      ReportF    :  RepScr^:=LRepScr^;
      SysF       :  Syss:=LSyss;
      JMiscF     :  JobMisc^:=LJobMisc^;
      JobF       :  JobRec^:=LJobRec^;
      JCtrlF     :  JobCtrl^:=LJobCtrl^;
      JDetlF     :  JobDetl^:=LJobDetl^;
      MLocF      :  MLocCtrl^:=LMLocCtrl^;

      NomViewF
                 :  NomView^:=LNomView^;

      //PR: 07/02/2012 Added QtyBreak for ABSEXCH-9795. Noticed the MultiBuyDiscount was missing, so added that as well.
      QtyBreakF  :  QtyBreakRec := LQtyBreakRec;
      MultiBuyF
                 :  MultiBuyDiscount := LMultiBuyDiscount;

      {$IFDEF RW}
      RepGenF    :  RepGenRecs^:=LRepGen^;
      DictF      :  DictRec^:=LDict^;
      {$ENDIF}
      {$IFDEF XO}
      xoListF    :  xoList^  := LxoList^;
      xoGroupF   :  xoGroup^ := LxoGroup^;
      {$ENDIF}
      {$IFDEF WCA}
       csCardF   :  csCard := LcsCard^;
       csInvF    :  csInv := LcsInv^;
       csSalesF  :  csSalesDet := LcsSales^;
      {$ENDIF}
    end; {Case..}

end;

Procedure TdExLocal.LGetRecAddr(Fnum :  Integer);

Begin

  Status:=GetPos(F[Fnum],Fnum,LastRecAddr[Fnum]);

end;


Function tdExLocal.LGetMainRecPos(Fnum  :  SmallInt;
                                  KeyS  :  Str255)  :  Boolean;

  Begin
    Result:=LGetMainRecPosKey(Fnum,0,KeyS);
  end;


Function tdExLocal.LGetMainRecPosKey(Fnum,
                                     KPath :  SmallInt;
                                     KeyS  :  Str255)  :  Boolean;

  Var
    CStatus  :  SmallInt;

  Begin
    CStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KPath,KeyS);

    Result:=(CStatus=0);

    If (Not Result) then
      LResetRec(Fnum);
  end;


Function TdExLocal.LGetDirectRec(Fnum,
                                 KeyPath :  Integer)  :  Integer;

Begin

  LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);


  Result:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}
end;


Function TdExLocal.UnLockMLock(Fnum    :  Integer;
                               LRAddr  :  LongInt)  :  Integer;

Var
  KeyS    :  Str255;
  DumRec  :  Array[1..4000] of Char;


Begin

  If (LRAddr=0) then
    LGetRecAddr(Fnum)
  else
    LastRecAddr[Fnum]:=LRAddr;

  {* Preserve Record *}



  Move(LRecPtr[Fnum]^,DumRec,FileRecLen[Fnum]);

  LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);


  Result:=Find_Rec(B_Unlock,F[Fnum],Fnum,LRecPtr[Fnum]^,-1,KeyS);

  {* Restore Record *}

  Move(DumRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);

end; {Func..}








{ ======= General Routine to Atempt a Record Lock ========= }

Function TdExLocal.LGetMultiRec(Func      :  Integer;
                                LockType  :  Integer;
                            Var Key2S     :  Str255;
                                KeyPth    :  Integer;
                                Fnum      :  Integer;
                                Wait      :  Boolean;
                            Var Locked    :  Boolean) : Boolean;

Var
  Bcode,
  Fcode    :  Integer;
  MbRet    :  Word;
  TmpForm  :  TBTWaitLock;

Begin
  Locked:=BOff; Fcode:=0;

  TmpForm:=NIL;

  BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);


  If (Bcode<>0) then
  Case Bcode of
       81     :  Report_Berror(Fnum,BCode);  {* Lock table full *}
       84,85  {$IFDEF Su_On}

              :  Begin
                   mbRet:=MessageDlg('Network Violation! - Closing System',
                                      mtError,[mbOk],0);

                   Halt;
                 end;

              {$ELSE}


              :  If (Not Wait) then
                 Begin
                   {* Establish if record found at all *}

                   Fcode:=Find_Rec(Func,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPth,Key2s);

                   Repeat

                     mbRet:=MessageDlg('Record in use by another station!',
                                        MtConfirmation,[mbRetry,mbCancel],0);

                     BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);

                   Until (MbRet=IdCancel) or (Bcode=0);

                   Locked:=(Bcode=0);

                   {* Set record found *}
                   Bcode:=Fcode;

                 end
                 else
                 Begin

                   TmpForm:=TBTWaitLock.Create(Application.Mainform);

                   Try

                     TMpForm.Init_Test(Func,Fnum,Keypth,LockType,Key2S,LRecPtr[Fnum],nil);

                     BCode:=(TmpForm.ShowModal-mrOk);

                   Finally

                     TmpForm.Free;

                   end;


                   Locked:=(Bcode=0);

                 end;

               {$ENDIF}

       22      : Begin
                   Locked:=(VariFile[Fnum]);
                   If (Locked) then
                     Bcode:=0;
                 end;


  end {Case..}
  else
    Locked:=BOn;

  {If (Bcode<>0) and (Debug) then Status_Means(Bcode);}


  Addch:=#0; {* Reset Lock Key *}


  LGetMultiRec:=(Bcode=0);
end;


Function TdExLocal.LPresrv_BTPos(Fnum      :  Integer;
                             Var Keypath   :  Integer;
                             Var LFV       :  FileVar;
                             Var RecAddr   :  LongInt;
                                 UsePos,
                                 RetRec    :  Boolean)  :  Integer;



Var
  TmpStat    :  Integer;
  DumRecLen  :  Integer;
  DumRec     :  Array[1..4000] of Char;


Begin

  TmpStat:=0;

  If (UsePos) then
  Begin
    If (RecAddr<>0) and (Keypath>=0) then
    Begin

      FillChar(DumRec,Sizeof(DumRec),0);

      Move(RecAddr,DumRec,Sizeof(RecAddr));

      TmpStat:=GetDirect(LFV,Fnum,DumRec,Keypath,0); {* Re-Establish Position *}

      If (TmpStat=0) and (RetRec) then
        Move(DumRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);

    end
    else
      TmpStat:=8;
  end
  else
  Begin

    RecAddr:=0;

    TmpStat:=GetPos(LFV,Fnum,RecAddr);

    If (Keypath=GetPosKey) then {* Calculate current key from pos blk *}
      If (TmpStat=0) then
        Keypath:=CurrKeyPath^[Fnum]
      else
        KeyPath:=0;

  end;

  LPresrv_BTPos:=TmpStat;

end; {Func..}


{ ========= Store transaction header in advance, incase system crashes before completion ======== }

Function TdExLocal.LSecure_Add(Fnum,
                               Keypath  :  Integer;
                               Mode     :  Byte)  :  Boolean;


Var
  Locked,
  LOk  :  Boolean;

  KeyW :  Str255;

  TmpInv
       :  InvRec;

Begin
  KeyW:='';


  If (Not LForcedAdd) then
  Begin
    TmpInv:=LInv;

    Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

    Report_BError(Fnum,Status);

    If (StatusOk) then
    Begin
      KeyW:=LInv.OurRef;

      {* v4.24a
         This find required, as Btrieve did not retuen the correct record position immediately after the add, if the user had added via the daybook
         when highlighting a blank line

         We suspect that this somehow corrupted FPOS, and so it did not update itself correctly.
      *}

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,InvOurRefK,KeyW);

      If (StatusOk) then
      Begin
        LGetRecAddr(Fnum);  {* Refresh record address *}

        LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

        Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyW,KeyPAth,Fnum,BOn,Locked);

        LForcedAdd:=(LOk and Locked);

        If (TmpInv.Folionum<>LInv.FolioNum) then
        Begin
          MessageDlg('An error has ocurred attempting to store transaction '+TmpInv.OurRef+#13+#13+
                     'The System has returned '+LInv.OurRef+#13+
                     'Please abandon this transaction before adding any lines to it.',mtError,[mbOk],0);

          {$IFNDEF RW}
          {$IFNDEF XO}
            {$IFNDEF OLE}
              {$IFNDEF EDLL}
                {$IFNDEF ENDV}
                {$IFNDEF EXDLL}
                 {$IFNDEF COMP}
                 {$IFNDEF EBAD}
                   AddErrorLog('Btrieve returned '+LInv.OurRef+', when looking for '+TmpInv.OurRef,'User advised to abandon '+TmpInv.OurRef,3);
                 {$ENDIF}
                 {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
        end;

      end;
    end
    else
      LForcedAdd:=BOff;
  end;


  Result:=LForcedAdd;

end;

{ ========= Store transaction header in advance, incase system crashes before completion ======== }

Function TdExLocal.LSecure_InvPut(Fnum,
                                  Keypath  :  Integer;
                                  Mode     :  Byte)  :  Integer;


Var
  TmpInv  :  InvRec;
  ExStat  :  Integer;

Begin

  If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
  Begin
    TmpInv:=LInv;

    LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

    ExStat:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

    LInv:=TmpInv;

  end;

  ExStat:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

  Result:=ExStat;

end; {Func..}

{ =============================================================== }


{ ============== TdMTExLocal Methods ============== }

// MH 23/07/2014 v7.X: Added ability to change Client Id Prefix for Order Payments
Constructor TdMTExLocal.Create(CIdNo : SmallInt; Const CIdPrefix : ShortString);
Begin // Create
  Inherited Create;

  LStatus:=0;

  New(LocalF);
  FillChar(LocalF^,Sizeof(LocalF^),0);

  New(ExClientId);

  // MH 23/07/2014 v7.X: Added ability to change Client Id Prefix for Order Payments
  If (CIdPrefix <> '') And (Length(CIdPrefix) = 2) Then
    Prime_ClientIdRec(ExClientId^,CIdPrefix,CIdNo)
  Else
    // MH 24/05/05: Changed to fix clash with COMTK use in plug-in and posting run
    {$IFDEF COMTK}
      Prime_ClientIdRec(ExClientId^,'TK',CIdNo);
    {$ELSE}
      {$IFDEF REP_ENGINE}
        // VRW - RepEngine.Dll
        Prime_ClientIdRec(ExClientId^,'VR',CIdNo);
    {$ELSE}
        Prime_ClientIdRec(ExClientId^,'EX',CIdNo);
      {$ENDIF}
    {$ENDIF}


  LWinHandle:=0;

  LThShowMsg:=nil;
  LThPrintJob:=nil;

  UsePrompt:=BOff;
End; // Create

Constructor TdMTExLocal.Create(CIdNo  :  SmallInt);
Begin
  Create (CIdNo, '');
end;


Destructor TdMTExLocal.Destroy;

Begin

  // Added v5.51.001 as part of mods for COM TK

  {$IFNDEF COMTK552}
    Close_Files;
  {$ENDIF}

  // MH 29/10/2008: Added reset to NIL as was getting Invalid Pointer Operations here
  If (Assigned(LocalF)) then
  Begin
    Dispose(LocalF);
    //LocalF := NIL;
  End; // If (Assigned(LocalF))

  // MH 29/10/2008: Added reset to NIL as was getting Invalid Pointer Operations here
  If (Assigned(ExClientId)) then
  Begin
    Dispose(ExClientId);
    ExClientId := NIL;
  End; // If (Assigned(ExClientId))

  Inherited Destroy;

end;

Procedure TdMTExLocal.LGetRecAddr(Fnum :  Integer);

Begin

  LStatus:=GetPosCId(LocalF^[Fnum],Fnum,LastRecAddr[Fnum],ExClientId);

end;


Function TdMTExLocal.LGetDirectRec(Fnum,
                                   KeyPath :  Integer)  :  Integer;

Begin

  LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);


  Result:=GetDirectCId(LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,0,ExClientId); {* Re-Establish Position *}
end;


Function TdMTExLocal.UnLockMLock(Fnum    :  Integer;
                                 LRAddr  :  LongInt)  :  Integer;

Var
  KeyS    :  Str255;
  DumRec  :  Array[1..4000] of Char;


Begin

  If (LRAddr=0) then
    LGetRecAddr(Fnum)
  else
    LastRecAddr[Fnum]:=LRAddr;

  {* Preserve Record *}

  Move(LRecPtr[Fnum]^,DumRec,FileRecLen[Fnum]);

  LGetDirectRec(Fnum,GetThreadKeyPath(Fnum,ExClientId));

  LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

  Result:=Find_RecCId(B_Unlock,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,-1,KeyS,ExClientId);

  {* Restore Record *}

  Move(DumRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);

end; {Func..}


{ ============ Lock via a DirectCall ============ }

Function TdMTExLocal.LLock_Direct(Func  :  Integer;
                                  Fnum  :  Integer;
                                  KeyPth:  Integer;
                                  BtRec :  RecCPtr)  :  Integer;


Var
  LockCode  :  Integer;
  RecAddr   :  LongInt;



Begin
  LockCode:=GetPosCId(LocalF^[Fnum],Fnum,RecAddr,ExClientId);

  If (LockCode=0) then
  Begin
    SetDataRecOfsPtr(Fnum,RecAddr,BtRec^);

    LockCode:=GetDirectCId(LocalF^[Fnum],Fnum,BtRec^,KeyPth,Func,ExClientId);
  end;

  LLock_Direct:=LockCode;

end;


{ ======= Lower Level Routine to Atempt a Record Lock ========= }

Function TdMTExLocal.LTry_Lock(Func      :  Integer;
                               LockType  :  Integer;
                           Var Key2S     :  Str255;
                               KeyPth    :  Integer;
                               Fnum      :  Integer;
                               BtRec     :  RecCPtr)  :  Integer;


Begin

   If (Func<>B_GetDirect) then
    LTry_Lock:=Find_RecCId(Func+LockType,LocalF^[Fnum],Fnum,BtRec^,KeyPth,Key2s,ExClientId)
  else
    LTry_Lock:=LLock_Direct(LockType,Fnum,KeyPth,BtRec);

end; {Func..}


Procedure TdMTExLocal.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage(LWinHandle,Msg,WParam,LParam);

end; {Proc..}



{ ======= General Routine to Atempt a Record Lock ========= }

Function TdMTExLocal.LGetMultiRec(Func      :  Integer;
                                  LockType  :  Integer;
                              Var Key2S     :  Str255;
                                  KeyPth    :  Integer;
                                  Fnum      :  Integer;
                                  Wait      :  Boolean;
                              Var Locked    :  Boolean) : Boolean;

Var
  Bcode,
  Fcode    :  Integer;
  MbRet    :  Word;
  TmpForm  :  TBTWaitLock;



Begin
  Locked:=BOff; Fcode:=0;

  TmpForm:=NIL;

  BCode:=LTry_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);


  If (Bcode<>0) then
  Case Bcode of
       81     :  Report_MTBError(Fnum,BCode,ExClientId);  {* Lock table full *}
       84,85  {$IFDEF Su_On}

              :  Begin
                   mbRet:=MessageDlg('Network Violation! - Closing System',
                                      mtError,[mbOk],0);

                   Halt;
                 end;

              {$ELSE}


              :  If (Not Wait) then
                 Begin
                   {* Establish if record found at all *}

                   Fcode:=Find_RecCId(Func,LocalF[Fnum],Fnum,LRecPtr[Fnum]^,KeyPth,Key2s,ExClientId);

                   If (UsePrompt) then
                   Begin
                     Repeat

                       mbRet:=MessageDlg('Record in use by another station!',
                                        MtConfirmation,[mbRetry,mbCancel],0);

                       BCode:=LTry_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);

                     Until (MbRet=IdCancel) or (Bcode=0);
                   end
                   else
                     BCode:=LTry_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);

                   Locked:=(Bcode=0);

                   {* Set record found *}
                   Bcode:=Fcode;

                 end
                 else
                 Begin

                   {* tell Thread form to display lock message *}

                   If (Assigned(LThShowMsg)) then
                   Begin
                     
                     Repeat
                       Send_UpdateList(01);

                       BCode:=LTry_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);

                       Application.ProcessMessages;

                     Until (Bcode=0);

                     Locked:=(Bcode=0);

                     {* Tell thread form, lock is over *}

                     Send_UpdateList(00);
                   end
                   else {* Use standard display *}
                   Begin

                     TmpForm:=TBTWaitLock.Create(Application.Mainform);

                     Try

                       TMpForm.Init_Test(Func,Fnum,Keypth,LockType,Key2S,LRecPtr[Fnum],@Self);

                       BCode:=(TmpForm.ShowModal-mrOk);

                     Finally

                       TmpForm.Free;

                     end;


                     Locked:=(Bcode=0);
                   end;

                 end;

               {$ENDIF}

       22      : Begin
                   Locked:=(VariFile[Fnum]);
                   If (Locked) then
                     Bcode:=0;
                 end;


  end {Case..}
  else
    Locked:=BOn;

  {If (Bcode<>0) and (Debug) then Status_Means(Bcode);}


  Addch:=#0; {* Reset Lock Key *}


  LGetMultiRec:=(Bcode=0);
end;


Function TdMTExLocal.LPresrv_BTPos(Fnum      :  Integer;
                             Var Keypath   :  Integer;
                             Var LFV       :  FileVar;
                             Var RecAddr   :  LongInt;
                                 UsePos,
                                 RetRec    :  Boolean)  :  Integer;





Begin

  LPresrv_BTPos:=Presrv_BTPosCId(Fnum,Keypath,LFV,REcAddr,UsePos,RetRec,ExClientId);

end; {Func..}


Function TdMTExLocal.NonFatalStatus(StatNo  :  Integer)  :  Boolean;


Begin

  NonFatalStatus:=(StatNo=11) Or (StatNo=20) or (StatNo =35) or (StatNo=88)
               or (StatNo=81) or (StatNo=85)  or (StatNo=86) or (StatNo=87) or
                  (StatNo=133);


end;


Procedure TdMTExLocal.Open_System(Start,Fin  :  Integer);


  Const
    NoAttempts     =  100;   {* No of retries before giving up *}
  Var
    Choice,NoTrys,
    SetAccel     :  Integer;
    mbRet        :  Word;
    {$IFDEF EXSQL}
    OKToContinue : Boolean;
    {$ENDIF}
  Begin
     { =========== Set Accelrated mode ============ }

     mbRet:=0;

     SetAccel:=-1*Ord(AccelMode);

     { =========== Open Files ========== }
  {$I-}

      Choice:=Start;

      NoTrys:=0;


        {* If (Not Check4BTrvOk) then  * Try Shelling Out and force load Btrieve
          JumpStart_Btrieve;           Won't work because heap too big..! use MUCDOS *}

       //PR 16/07/2008 - changed to allow this to be called from a thread without confusing the SQL Emulator
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
        OKToContinue := True
      else
        OKToContinue := Check4BtrvOK;

      if OKToContinue then
      {$ELSE}
      If (Check4BtrvOK) then
      {$ENDIF}
      While (Choice<=Fin) do
      Begin

        NoTrys:=0;

      Repeat
        Elded:=BOff;

        LStatus:=Open_FileCId(LocalF^[Choice],SetDrive+FileNames[Choice],SetAccel,ExClientId);

        If (LStatus <>0) and (NoTrys>NoAttempts) then
        Begin

          If (Debug) then Status_Means(LStatus);
          Elded:=BOff;

          {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
          begin
            LReport_BError(Choice, LStatus);
            Halt;
          end
          else
          begin
          {$ENDIF}
            mbRet:=MessageDlg('Error in File:'+FileNames[Choice]+' Type '+InttoStr(LStatus),mtInformation,[mbOk],0);


            If (Not NonFatalStatus(LStatus)) then
            Begin

              If (Debug) or SBSIn then
                mbRet:=MessageDlg('Create new file?',mtConfirmation,mbOkCancel,0)
              else
                mbRet:=IdCancel;

            end
            else
              mbRet:=MessageDlg('About to Abort',mtInformation,[mbOk],0);


            If (mbRet=IdOk) and (Not NonFatalStatus(LStatus)) then
            Begin
              LStatus:=Make_FileCId(LocalF^[Choice],SetDrive+FileNames[Choice],FileSpecOfs[Choice]^,FileSpecLen[Choice],ExClientId);

              If (Debug) then Status_Means(LStatus);
            end
            else
              Halt;
          {$IFDEF EXSQL}
          end;
          {$ENDIF}
        end
        else
          If (LStatus=0) then
            Elded:=BOn
          else
            Inc(NoTrys);

      Until (Elded) ;

      Inc(Choice);

      end; {while..}

      If (LStatus<>0) then
      Begin
        mbRet:=MessageDlg('Btrieve Error!'+InttoStr(LStatus),mtInformation,[mbOk],0);

        Halt;
      end;
      Elded:=BOff;

  end;




  { ============= Close All Open Files ============= }

  Procedure TdMTExLocal.Close_Files;


  Var

    Choice  :  Byte;
    FSpec   : FileSpec;


  Begin

  {$I-}
  For Choice:=1 to TotFiles do
  Begin
    {* Check file is open *}


    {$IFDEF EXSQL}
    // MH 05/11/2009: Modified to ignore BStat call in SQL Edition as was causing significant delay
    if SQLUtils.UsingSQLAlternateFuncs then
      LStatus := 0
    Else
    {$ENDIF}
      LStatus:=GetFileSpecCId(LocalF^[Choice],Choice,FSpec,ExClientId);

    If (LStatusOk) then
      LStatus:=Close_FileCId(LocalF^[Choice],ExClientId)
    else
      LStatus:=0;

  end;

  LStatus:=Reset_BCId(ExClientId);


  If (Debug) then
  Begin
    If (LStatus<>0) then
      ShowMessage('Inside TdMTExLocal.Close_Files');

    Status_Means(LStatus);

  end;

    {$I+}
  end;


  Function TdMTExLocal.LStatusOk  :  Boolean;

  Begin

    Result:=(LStatus=0);

  end;


  Function TdMTExLocal.LFind_Rec(BFunc,
                                 FNum,
                                 KPath  :  SmallInt;
                             Var    FKey   :  Str255)  :  SmallInt;

  Begin
    Result:=Find_RecCId(BFunc,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Kpath,FKey,ExClientId);
  end;

  Function TdMTExLocal.LAdd_Rec(FNum,
                                KPath  :  SmallInt)  :  SmallInt;

  Begin
    Result:=Add_RecCId(LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Kpath,ExClientId);
  end;


  Function TdMTExLocal.LPut_Rec(FNum,
                                KPath  :  SmallInt)  :  SmallInt;

  Begin
    Result:=Put_RecCId(LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Kpath,ExClientId);
  end;

  Function TdMTExLocal.LDelete_Rec(FNum,
                                   KPath  :  SmallInt)  :  SmallInt;

  Begin
    Result:=Delete_RecCId(LocalF^[Fnum],Fnum,Kpath,ExClientId);
  end;


  Function TdMTExLocal.LGetPos(FNum     :  SmallInt;
                           Var RecAddr  :  LongInt)  :  SmallInt;

  Begin
    Result:=GetPosCId(LocalF^[Fnum],Fnum,RecAddr,ExClientId);
  end;


  Function TdMTExLocal.LGetDirect(FNum,
                                  KPath,
                                  LMode  :  SmallInt)  :  SmallInt;

  Begin
    Result:=GetDirectCId(LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Kpath,LMode,ExClientId);
  end;


  Function TdMTExLocal.LFileVer(FNum  :  SmallInt)  :  Byte;

  Begin
    Result:=File_VerCid(LocalF^[Fnum],Fnum,ExClientId);
  end;

  Function TdMTExLocal.LCtrl_BTrans(BeginMode  :  Byte)  :  SmallInt;

  Var
    B_Func  :  Integer;

  Begin
    B_Func := 0;
    Case BeginMode of 
      0  :  B_Func:=B_EndTrans;
      1  :  B_Func:=B_BeginTrans;
      2  :  B_Func:=B_AbortTrans;
    end; {Case..}

    Result:=Ctrl_BTransCId(B_Func,ExClientId);
  end;


  Function tdMTExLocal.LGetMainRec(Fnum  :  SmallInt;
                                   KeyS  :  Str255)  :  Boolean;

  Var
    CStatus  :  SmallInt;

  Begin
    CStatus:=LFind_Rec(B_GetEq,Fnum,0,KeyS);

    Result:=(CStatus=0);

    If (Not Result) then
      LResetRec(Fnum);
  end;


  Function tdMTExLocal.LGetMainRecPos(Fnum  :  SmallInt;
                                      KeyS  :  Str255)  :  Boolean;

  Begin
    Result:=LGetMainRec(Fnum,KeyS);
  end;


  Function tdMTExLocal.LGetMainRecPosKey(Fnum,
                                         KPath :  SmallInt;
                                         KeyS  :  Str255)  :  Boolean;

  Var
    CStatus  :  SmallInt;

  Begin
    CStatus:=LFind_Rec(B_GetEq,Fnum,KPath,KeyS);

    Result:=(CStatus=0);

    If (Not Result) then
      LResetRec(Fnum);
  end;


  Procedure TdMTExLocal.LReport_BError(Fnum,ErrNo  :  SmallInt);

  Var
    ErrStr    :  Str255;
    mbRet     :  Word;
    ThStr     :  Str255;
    ClientIdR :  ClientIdType;

  Begin
    ThStr:='';

    If (Assigned(LThShowMsg)) then
    Begin
      If (ErrNo<>0) then
      Begin
        ErrStr:=Set_StatMes(ErrNo);

        If (Assigned(ExClientId)) then
          ThStr:=#13+#13+'In thread '+Form_Int(ExClientId.TaskId,0);

        LThShowMsg(nil,2,'Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr);

        {$IFNDEF RW}
          {$IFNDEF XO}
            {$IFNDEF OLE}
              {$IFNDEF EDLL}
                {$IFNDEF ENDV}
                {$IFNDEF EXDLL}
                 {$IFNDEF COMP}
                 {$IFNDEF EBAD}
                   AddErrorLog('Btrieve Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr,'',3);
                 {$ENDIF}
                 {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      end;
    end
    else
      Report_MTBError(Fnum,ErrNo,ExClientId);
  end;


procedure TdMTExLocal.LReport_Error(ErrorMsg: Str255);
var
  ThStr: Str255;
begin
  ThStr := '';

  if (Assigned(LThShowMsg)) then
  begin
    If (Assigned(ExClientId)) then
      ThStr := #13#13 + 'In thread ' + Form_Int(ExClientId.TaskId, 0);

    LThShowMsg(nil, 2, ErrorMsg + ThStr);

    {$IFNDEF RW}
      {$IFNDEF XO}
        {$IFNDEF OLE}
          {$IFNDEF EDLL}
            {$IFNDEF ENDV}
              {$IFNDEF EXDLL}
                {$IFNDEF COMP}
                  {$IFNDEF EBAD}
                  AddErrorLog(ErrorMsg + ThStr, '', 3);
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  end;
end;

  { =========== Report IOError =========== }


Procedure TdMTExLocal.LReport_IOError(ErrNo   :  Integer;
                                      Fname   :  Str255);


Const
  IOMess1  =  ' WARNING! - I/O Error ';
  IOMess3  =  ' in file';

Var
  ThStr     :  Str255;
  mbRet     :  Word;

Begin
  ThStr:='';

  If (Assigned(LThShowMsg)) then
  Begin
    If (ErrNo<>0) then
    Begin
      If (Assigned(ExClientId)) then
        ThStr:=#13+'In thread '+Form_Int(ExClientId.TaskId,0);

      LThShowMsg(nil,2,IOMess1+#13+IOError(ErrNo)+IOMEss3+#13+Fname+ThStr);
    end;
  end
  else
    If (ErrNo<>0) then
      MbRet:=MessageDlg(IOMess1+#13+IOError(ErrNo)+IOMEss3+#13+Fname,mtError,[mbOk],0);

  {$IFNDEF RW}
    {$IFNDEF XO}
      {$IFNDEF OLE}
        {$IFNDEF EDLL}
          {$IFNDEF ENDV}
          {$IFNDEF COMP}
          {$IFNDEF EXDLL}
          {$IFNDEF EBAD}
            If (ErrNo<>0) then
              AddErrorLog(IOMess1+#13+IOError(ErrNo)+IOMEss3+#13+ThStr,'In File : '+Fname,0);
          {$ENDIF}
          {$ENDIF}
          {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;


Function TdMTExLocal.LUnLockMLock(Fnum :  SmallInt)  :  SmallInt;

Begin
  Result:=UnLockMLock(Fnum,LastRecAddr[Fnum]);
end;



{$IFDEF EXSQL}
function TdMTExLocal.LGetMultiRecAddr(Func, LockType: Integer;
  var Key2S: Str255; KeyPth, Fnum: Integer; Wait: Boolean;
  var Locked: Boolean; var LRecAddr: Integer): Boolean;
begin
  Result := LGetMultiRec(Func,LockType,Key2S,Keypth,Fnum,Wait,Locked);

  if Result then
    LGetPos(Fnum,LRecAddr);
end;

function TdMTExLocal.LGet_NextChequeNo(Increment: Boolean): Str80;
Var
  TmpStr  :  Str80;

Begin

  TmpStr:=Form_BInt(LGetNextCount(ACQ,Increment,BOff,0),0);

  If (Increment) then
    LPut_NextChequeNo(TmpStr,BOn);

  LGet_NextChequeNo:=TmpStr;

end;

function TdMTExLocal.LGetNextCount(DocHed: DocTypes; Increment,
  UpLast: Boolean; NewValue: Real): LongInt;
Const
  Fnum     :  Integer  =  IncF;
  Keypath  :  Integer  =  IncK;

Var
  Key2F  :  Str255;
  TmpOk  :  Boolean;
  Lock   :  Boolean;
  TmpStatus
         :  Integer;
  LAddr,
  Cnt,NewCnt
         :  LongInt;



Begin
  Lock:=BOff;  Cnt:=0;  NewCnt:=0; TmpStatus:=0;

  Blank(Key2F,Sizeof(Key2F));

  Key2F:=DocNosXlate[DocHed];

  TmpOk:=LGetMultiRec(B_GetEq,B_MultLock,Key2F,Keypath,Fnum,BOn,Lock);

  If (TmpOk) and (Lock) then
  With LCount do
  Begin
    LGetRecAddr(Fnum);

    Move(NextCount[1],Cnt,Sizeof(Cnt));

    If (Increment)then
    Begin
      NewCnt:=Cnt+IncxDocHed[DocHed];
      Move(NewCnt,NextCount[1],Sizeof(NewCnt));
    end;

    If (UpLast) then
      LastValue:=NewValue;

    If (Increment) or (UpLast) then
      TmpStatus:=LPut_Rec(Fnum,Keypath);

    LReport_BError(Fnum,TmpStatus);

    TmpStatus:=LUnLockMLock(Fnum);

  end;

  LGetNextCount:=Cnt;
end;

procedure TdMTExLocal.LPut_NextChequeNo(NewVal: Str80; Increment: Boolean);
Var
  Key2F  :  Str255;
  TmpOk  :  Boolean;
  Lock   :  Boolean;
  TmpStatus
         :  Integer;
  LAddr,
  NewCnt
         :  LongInt;



Begin
  Lock:=BOff;  NewCnt:=0;

  NewCnt:=LIntStr(Strip('B',[#32],NewVal));

  If (NewCnt<>0) then
  Begin
    Blank(Key2F,Sizeof(Key2F));

    Key2F:=DocNosXlate[ACQ];

    TmpOk:=LGetMultiRecAddr(B_GetEq,B_MultLock,Key2F,IncK,IncF,BOn,Lock,LAddr);

    If (TmpOk) and (Lock) then
    With Count do
    Begin
      If (Increment) then
        NewCnt:=NewCnt+IncxDocHed[ACQ];

      Move(NewCnt,NextCount[1],Sizeof(NewCnt));

      TmpStatus:=LPut_Rec(IncF, IncK);

      LReport_BError(IncF,TmpStatus);

      Status:=UnLockMLock(IncF,LAddr);

    end;
  end; {NewCnt not a a value..}
end;

function TdMTExLocal.LGetMultiFrmDefs(PageNo: Integer): FormDefsRecType;
Var
 TempSys  :  Sysrec;
 Key2F    :  Str255;
 iStatus  :  SmallInt;
Begin

 TempSys:=LSyss;

 If (PageNo<=0) then
   Result:=SyssForms^
 else
 Begin
   Key2F:=Copy(SysNames[FormR],1,2)+Chr(PageNo+100);

   LStatus:=LFind_Rec(B_GetEq,SysF,0,Key2F);

   If (LStatus=0) then
     Move(LSyss,Result,Sizeof(Result))
   else
     Result:=SyssForms^;

 end; {If Ok..}

 LSyss:=TempSys;
end;


{$ENDIF}


function TdMTExLocal.LCheckValidNCC(ChkComm: Boolean): Boolean;
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
  CStatus:=LFind_Rec(B_GetEq,NomF,0,KeyS);
DbgList.Add ('Syss GL=' + IntToStr(NomCtrlCodes[N]) + ', FindRec Result=' + IntToStr(CStatus));
  Result:=(CStatus=0);
  If (Not Result) then
    LResetRec(NomF);
{$ELSE}
      Result:=LGetMainRec(NomF,FullNomKey(NomCtrlCodes[N]));
{$ENDIF}

      If (Result) then
      Begin
        Result:=(Not (LNom.NomType In [NomHedCode,CarryFlg]));
{$IFDEF GLCCDEBUG}
If (Not Result) then
  DbgList.Add ('  Failed NomType Check 1 - NomType=' + LNom.NomType);
{$ENDIF}
      End; // If (Result)

      If (Result) and (N=ProfitBF) then {* Check Type *}
      Begin
        Result:=(LNom.NomType In [CtrlNHCode]);
{$IFDEF GLCCDEBUG}
If (Not Result) then
  DbgList.Add ('  Failed NomType Check 2 - NomType=' + LNom.NomType);
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
  CStatus:=LFind_Rec(B_GetEq,NomF,0,KeyS);
DbgList.Add ('SyssJob (' + SyssJob^.IDCode + ') GL=' + IntToStr(EmployeeNom[m,BOff]) + ', FindRec Result=' + IntToStr(CStatus));
  Result:=(CStatus=0);
  If (Not Result) then
    LResetRec(NomF);
{$ELSE}
      Result:=LGetMainRec(NomF,FullNomKey(EmployeeNom[m,BOff]));
{$ENDIF}

      If (Result) then
      Begin
        Result:=(Not (LNom.NomType In [NomHedCode,CarryFlg]));
{$IFDEF GLCCDEBUG}
If (Not Result) then
  DbgList.Add ('  Failed NomType Check 1 - NomType=' + LNom.NomType);
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

//PR: 15/07/2015 A version of LPresrv_BTPos which updates the local rather than global record (See ABSEXCH-16672)
function TdMTExLocal.LPresrv_BTPosLocal(Fnum: Integer;
                                    var Keypath: Integer;
                                    var LFV: FileVar;
                                    var RecAddr: Integer;
                                        UsePos,
                                        RetRec: Boolean): Integer;
var
  DumRec     :  Array[1..4000] of Char;
begin
  If (UsePos) then //Restore position in file
  Begin
    If (RecAddr<>0) and (Keypath>=0) then
    Begin

      FillChar(DumRec,Sizeof(DumRec),0);

      Move(RecAddr,DumRec,Sizeof(RecAddr));

      Result := GetDirectCId(LFV,Fnum,DumRec,Keypath,0,ExClientId); {* Re-Establish Position *}

      //If RetRec is true then we want to copy the returned record into the local record
      If (Result = 0) and (RetRec) then
        Move(DumRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);

    end
    else
      Result := 8;
  end
  else
  Begin //Get position and store in RecAddr
    RecAddr:=0;

    Result := GetPosCId(LFV,Fnum,RecAddr,ExClientId);

    If (Keypath=GetPosKey) then {* Calculate current key from pos blk *}
      If (Result = 0) then
        Keypath:=GetThreadKeyPath(Fnum, ExClientId)
      else
        KeyPath:=0;

  end;
end;

Initialization


Finalization

end.
