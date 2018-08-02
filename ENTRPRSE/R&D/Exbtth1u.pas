unit ExBtTh1u;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VARRec2U,VarConst,BtrvU2,BtSupU1,ExWrap1U,

  {$IFDEF CU}
     CustIntU,

  {$ENDIF}
  SyncObjs, //PR 16/10/07 Added for OTC issues

  SBSComp2;


type
  // CJS 2014-11: Order Payments - Phase 5 - VAT Return
  // Signature for event-handler for updating any display of the progress of
  // the report. This is passed the number of records that have been scanned so
  // far. This is for use with reports descended from TThreadQueue which are
  // not actually running in a thread (for reports running in a thread the
  // progress is displayed in the Object Thread Controller).
  TOnUpdateProgressProc = procedure(Records: Integer; var Cancelled: Boolean) of object;

  TdPostExLocalPtr  =  ^TdPostExLocal;

  TdPostExLocal  =  Object(TdMTExLocal)

                      CalcPurgeOB,
                      DelCCDepHist,
                      ForceYTNCF,
                      CustLockOn  :  Boolean;

                    Constructor Create(CIdNo  :  SmallInt); Overload;
                    // MH 23/07/2014 v7.X: Added ability to change Client Id Prefix for Order Payments
                    Constructor Create(CIdNo : SmallInt; Const CIdPrefix : ShortString); Overload;

                    Destructor Destroy;

                    Function  LCheckExsists(KeyR  :  AnyStr;
                                            FileNum,KeyPath
                                                  :  Integer)  :  Boolean;
                    Function  LCheckRecExsists(KeyR  :  AnyStr;
                                               FileNum,KeyPath
                                                     :  Integer)  :  Boolean;

                    Procedure LDeleteLinks (Code  :  AnyStr;
                                            Fnum  :  Integer;
                                            KLen  :  Integer;
                                            KeyPth:  Integer;
                                            DelInv:  Boolean);

                    Procedure LDeleteAuditHist (Code       :  AnyStr;
                                                KLen       :  Integer;
                                                UseReset   :  Boolean);

                    Function IsCCDepHist  :  Boolean;

                    Procedure LResetAuditHist (Code  :  AnyStr;
                                               KLen  :  Integer);

                    Function LLast_YTD(NType             :  Char;
                                       NCode             :  Str20;
                                       PCr,PYr,PPr       :  Byte;
                                       Fnum,NPath        :  Integer;
                                       Direc             :  Boolean)  :  Boolean;

                    Procedure LAdd_NHist(NType           :  Char;
                                         NCode           :  Str20;
                                         PCr,PYr,PPr     :  Byte;
                                         Fnum,NPath      :  Integer);

                    Procedure LHed_YTDType(MoveCode  :  LongInt;
                                           NTyp      :  Char;
                                           Fnum,
                                           Keypath   :  Integer;
                                       Var YTDOk,
                                           YTDNCFOk  :  Boolean);

                    Procedure LFillBudget(Const  Fnum,
                                                 Keypath  :  Integer;
                                          Var    Mode     :  Byte;
                                                 NKey     :  Str255);

                    Procedure LPost_To_Hist2(NType         :  Char;
                                             NCode         :  Str20;
                                             PPurch,PSales,
                                             PCleared,
                                             PValue1,
                                             PValue2
                                                           :  Double;
                                             PCr,PYr,PPr   :  Byte;
                                         Var PrevBal       :  Double);

                    Procedure LPost_To_CYTDHist2(NType          :  Char;
                                                 NCode          :  Str20;
                                                 PPurch,PSales,
                                                 PCleared,
                                                 PValue1,
                                                 PValue2        :  Double;
                                                 PCr,PYr,PPr    :  Byte);

                    Procedure LPost_To_Hist(NType         :  Char;
                                            NCode         :  Str20;
                                            PPurch,PSales,
                                            PCleared
                                                          :  Double;
                                            PCr,PYr,PPr   :  Byte;
                                        Var PrevBal       :  Double);

                    Procedure LPost_To_CYTDHist(NType          :  Char;
                                                NCode          :  Str20;
                                                PPurch,PSales,
                                                PCleared       :  Double;
                                                PCr,PYr,PPr    :  Byte);


                    Procedure Prime_To_CYTDHist(NType          :  Char;
                                                NCode          :  Str20;
                                                PCr,PYr,PPr    :  Byte);

                    // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
                    Function LTotal_Profit_To_Date(NType        :  Char;
                                                   NCode        :  Str20;
                                                   PCr,PYr,PPr  :  Byte;
                                               Var Purch,PSales,
                                                   PCleared,
                                                   PBudget,
                                                   RevisedBudget1 :  Double;
                                               Var BValue1,
                                                   BValue2      :  Double;
                                                   Range        :  Boolean)  :  Double;
                    // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
                    Function LTotal_Profit_to_Date_RevBudgets (    NType             : Char;
                                                                   NCode             : Str20;
                                                                   PCr,PYr,PPr       : Byte;
                                                               Var Purch,
                                                                   PSales,
                                                                   PCleared,
                                                                   PBudget,
                                                                   RevisedBudget1,
                                                                   RevisedBudget2,
                                                                   RevisedBudget3,
                                                                   RevisedBudget4,
                                                                   RevisedBudget5    : Double;
                                                               Var BValue1, BValue2  : Double;
                                                                   Range             : Boolean)  :  Double;

                    Function VATSalesMode(SalesOn  :  Boolean;
                                          VT       :  VATType)  :  Boolean;



                    {IFDEF OLE}
                    {$IF Defined(OLE) Or Defined(COMTK)}


                    Function LTotal_QtProfit_To_Date(NType        :  Char;
                                                     NCode        :  Str20;
                                                     PCr,PYr,PPr  :  Byte;
                                                 Var Purch,PSales,
                                                     PCleared,
                                                     PBudget,
                                                     PRBudget     :  Double;
                                                 Var Qty1, Qty2   :  Double;
                                                     Range        :  Boolean)  :  Double;

                    {$IFEND}

                    Function LProfit_To_Date(NType        :  Char;
                                             NCode        :  Str20;
                                             PCr,PYr,PPr  :  Byte;
                                         Var Purch,PSales,
                                             PCleared     :  Double;
                                             Range        :  Boolean)  :  Double;


                    Function LGetNextCount(DocHed     :  DocTypes;
                                           Increment,
                                           UpLast     :  Boolean;
                                           NewValue   :  Real)  :  LongInt;



                    Function LFullDocNum(DocHed    :  DocTypes;
                                         Increment :  Boolean)  :  Str20;

                    Procedure LSetNextDocNos(Var  InvR  :  InvRec;
                                                  SetOn :  Boolean);

                    Procedure SetNextAutoDocNos(Var  InvR  :  InvRec;
                                                     SetOn :  Boolean);

                    Function LFullAutoDocNum(DocHed    :  DocTypes;
                                             Increment :  Boolean)  :  Str20;

                    Procedure LUpdateBal(UInv   :  InvRec;
                                         BalAdj :  Real;
                                         CosAdj,
                                         NetAdj :  Real;
                                         Deduct :  Boolean;
                                         Mode   :  Byte);


                    Procedure LUpdateOrdBal(UInv   :  InvRec;
                                            BalAdj :  Real;
                                            CosAdj,
                                            NetAdj :  Real;
                                            Deduct :  Boolean;
                                            Mode   :  Byte);


                    Procedure LRemove_MatchPay(ORef     :  Str20;
                                               MTyp,
                                               STyp     :  Char;
                                               RemMatch :  Boolean);


                    Procedure LMatch_Payment(Var InvR  :  InvRec;
                                                 AddT,
                                                 AddN  :  Real;
                                                 Mode  :  Byte);


                    {$IFNDEF OLE}
                      {$IFNDEF RW}
                        {$IFNDEF WCA}
                        {$IFNDEF ENDV}
                        {$IFNDEF XO}
                          Function LCheck_NoteNo(NoteType  :  Char;
                                                 NoteFolio :  Str10)  :  LongInt;

                          Procedure LAdd_Notes(NoteType,
                                               NoteSType  :  Char;
                                               FolioCode  :  Str10;
                                               NDate      :  LongDate;
                                               NDesc      :  Str80;
                                           Var DLineCount :  LongInt);

                        {$ENDIF}
                        {$ENDIF}
                        {$ENDIF}
                      {$ENDIF}
                    {$ENDIF}

                    Procedure LSet_PrintedStatus(ToPrinter,
                                                 AlsoPicked:  Boolean;
                                                 InvR     :  InvRec);
                    Function Link_CustHO(CustHO  :  Str10)  :  CustRec;

                    {$IFNDEF O_LE}
                    {$IFNDEF RW}
                    {$IFNDEF XO}
                    {$IFNDEF ENDV}
                    {$IFNDEF WCA}
                    {$IFDEF STK}
                      {$IFDEF SOP}

                        {* Copied from InvLst3U *}

                        Function LLocOverride(lc    :  Str10;
                                              Mode  :  Byte)  :  Boolean;

                        Function LLocOPrice(lc  :  Str10)  :  Boolean;

                        Function LLocONom(lc  :  Str10)  :  Boolean;

                        Function LLocOCCDep(lc  :  Str10)  :  Boolean;

                        Function LLocOSupp(lc  :  Str10)  :  Boolean;

                        Function LLocORPrice(lc  :  Str10)  :  Boolean;

                        Function LLocOCPrice(lc  :  Str10)  :  Boolean;

                        Function LLinkMLoc_Stock(lc  :  Str10;
                                                 sc  :  Str20;
                                             Var TSL :  MStkLocType)  :  Boolean;

                        Procedure LStock_LocFullSubst(Var StockR  :  StockRec;
                                                          Lc      :  Str10;
                                                          Mode    :  Byte);

                        Procedure LStock_LocSubst(Var StockR  :  StockRec;
                                                      Lc      :  Str10);

                        Procedure LStock_LocROCPSubst(Var StockR  :  StockRec;
                                                          Lc      :  Str10);
                        Procedure LStock_LocROSubst(Var StockR  :  StockRec;
                                                        Lc      :  Str10);

                        Procedure LStock_LocBinSubst(Var StockR  :  StockRec;
                                                         Lc      :  Str10);

                        Procedure LStock_LocRep1Subst(Var StockR  :  StockRec;
                                                          Lc      :  Str10);

                        Procedure LStock_LocLinkSubst(Var StockR  :  StockRec;
                                                          Lc      :  Str10);

                        Procedure LStock_LocNSubst(Var StockR  :  StockRec;
                                                      Lc      :  Str10);

                        Procedure LStock_LocPSubst(Var StockR  :  StockRec;
                                                      Lc      :  Str10);

                        Procedure LStock_LocCSubst(Var StockR  :  StockRec;
                                                       Lc      :  Str10);

                        Procedure LStock_LocTKSubst(Var StockR  :  StockRec;
                                                       Lc      :  Str10);

                        Procedure LUpdate_LocROTake(StockR  :  StockRec;
                                                    lc      :  Str10;
                                                    Mode    :  Byte);

                      {$ENDIF}
                    {$ENDIF}
                    {$ENDIF}
                    {$ENDIF}
                    {$ENDIF}
                    {$ENDIF}
                    {$ENDIF}


                    {$IFDEF OLE}
                       {$DEFINE LocJC}
                     {$ENDIF}
                     {$IFDEF JC}
                       {$DEFINE LocJC}
                     {$ENDIF}
                     {$IFDEF LocJC}


                     Function LGet_BudgMUp(JCode,
                                           ACode    :  Str10;
                                           SCode    :  Str20;
                                           Curr     :  Byte;
                                       Var Charge,
                                           CostUp   :  Double;
                                           Mode     :  Byte)  :  Boolean;


                    {$ENDIF}

                    {$IFNDEF OLE}
                    {$IFDEF SOP}
                    //PR: 19/06/2012 ABSEXCH-11528 Function to return o/s value including VAT from a transaction
                    function LTransOSWithVAT(InvR : InvRec) : Double;

                    //PR: 25/06/2012 ABSEXCH-11528 To deal with manual vat, separated out function to read lines and calculate vat
                    //and added function to calculated os vat from header. TransOSWithVAT will call the appropriate function,
                    //depending upon value of InvR.ManVAT. Copied from MiscU.pas
                    function LTransOSWithVATFromLines(InvR : InvRec) : Double;

                    //PR: 19/06/2012 ABSEXCH-11528 Function to return required o/s value including or excluding VAT as required by system setup
                    function LTransOSValue(InvR : InvRec) : Double;
                    {$ENDIF SOP}
                    {$ENDIF not OLE}

                    //PR: 16/04/2014 Order Payments T038 Added LUpdateCustBal procedure
                    Procedure LUpdateCustBal(OI,IR  :  InvRec);
                  end; {object..}



  { === Extended Thread Class designed to allow override of Synchronise method === }


  TEXSThread   =  Class(TThread)
                    private
                      COMRunning  :  Boolean;

                    public

                      Procedure StartCOM;

                      Procedure StopCOM;

                      Procedure RunSync(Method  :  TThreadMethod);

                  end;


  { === Generic Thread Queue member class ===}


  TThreadQueue  =  Object

                     private

                     protected
                       // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                       FOnUpdateProgress: TOnUpdateProgressProc;
                       FCancelled: Boolean;

                       // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
                       LPostLocal: TdPostExLocalPtr;
                       FLocalFilesOpen : Boolean;
                       // CJS - 07/03/2011: ABSEXCH-9461 - Fix to release ClientID Bit after use
                       fHasClientBit: Boolean;

                       //SS:22/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
                       FShowProgressBar : Boolean;
                     public
                       fMyOwner     :  TObject;
                       fTQNo        :  Integer;
                       fOwnHandle   :  THandle;
                       fCanAbort,
                       fSetPriority,
                       fShowModal,
                       fPrintJob,
                       fOwnMT       :  Boolean;

                       fPriority    :  TThreadPriority;

                       MTExLocal    :  tdPostExLocalPtr;

                       {$IFDEF CU}
                          ThreadCustomEvent
                                    :  TCustomEvent;

                       {$ENDIF}

                       ThreadRec    :  ^TMonRec;

                       TQThreadObj    :  TEXSThread;

                       UsingEmulatorFiles : Boolean;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;

                       Procedure Send_UpdateList(Mode   :  Integer);

                       Procedure BaseObjFinish;

                       Procedure Finish; Virtual;

                       Procedure AbortfromStart ; Virtual;

                       Procedure InitStatusMemo(Lno  :  Integer);

                       Procedure ShowStatus(LNo   :  Integer;
                                            LText :  ShortString);

                       Procedure InitProgress(Max  :  Integer);

                       Procedure UpdateProgress(Max  :  Integer);

                       {$IFDEF CU}

                         Function LHaveHookEvent(WID,EID  :  Integer;
                                             Var NewObject:  Boolean)  :  Boolean;

                         Procedure LBuildHookEvent(WID,EID  :  Integer;
                                               Var ExLocal  :  TdExLocal);

                         Function LExecuteHookEvent(WID,EID  :  Integer;
                                                 Var ExLocal  :  TdExLocal)  :  Boolean;

                       {$ENDIF}

                         {= Replicated from Event1U =}

                         Procedure LDate2Pr(CDate  :  LongDate;
                                        Var PPr,PYr:  Byte;
                                            ExLPtr :  Pointer);

                         Function LPr2Date(PPr,PYr  :  Byte;
                                           ExLPtr   :  Pointer)  :  LongDate;

                         {$IFNDEF OLE}
                         {Thread safe Calc VAT}
                         Procedure LCalcThVAT(Var  IdR        :  IDetail;
                                                   SetlDisc   :  Double;
                                              Var  ExLocal    :  TdExLocal);

                         Function LSetVATPostDate(ExLocal    :  TdExLocal;
                                                  EId        :  Byte;
                                                  InpStr     :  Str255)  :  Str255;
                         {$ENDIF}

                       // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
                      {$IFDEF EXSQL}
                       function Create_LocalThreadFiles (Const OpenDataFiles : Boolean = True) : Boolean;
                       function ReOpen_LocalThreadfiles : Boolean;
                       procedure Reset_LocalThreadFiles;
                       function LCheck_PayInStatus(Var IdR  :  IDetail)  :  Byte;
                       // CJS - 07/03/2011: ABSEXCH-9461 - Fix to release ClientID Bit after use
                       procedure Reset_ClientBit;
                      {$ENDIF}
                      // CJS 2014-11: Order Payments - Phase 5 - VAT Return
                      property OnUpdateProgress: TOnUpdateProgressProc read FOnUpdateProgress write FOnUpdateProgress;

                      //SS:22/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
                      property ShowProgressBar : Boolean read FShowProgressBar write FShowProgressBar;
                   end; {Class..}




Var
  PostExLocal,
  RepExLocal,
  LCommitExLocal,
  LCSExLocal   :  TdPostExLocalPtr;

  StatusLock : TCriticalSection; //PR 16/10/07 Added for OTC issues


  ClientIds: TBits;
  ClientIDsLock : TCriticalSection;
  MainThreadID : Integer;

  Function Create_ThreadFiles  :  Boolean;

  Function Create_ReportFiles  :  Boolean;

  Function Create_LiveCSFiles  :  Boolean;

  Function Create_LiveCommitFiles  :  Boolean;

  Procedure Destroy_ThreadFiles;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,Forms,
  ETMiscU,
  ETStrU,
  ETDateU,
  ComnUnit,
  SysU1,
  BTKeys1U,

  {$IFNDEF OLE}
    {$IFNDEF RW}
     {$IFNDEF ENDV}
     {$IFNDEF WCA}
      {$IFNDEF XO}
        NoteSupU,

        {$IFDEF SOP}
          InvLst3U,
        {$ENDIF}
      {$ENDIF}
     {$ENDIF}
     {$ENDIF}
    {$ENDIF}
  {$ELSE}
    SalePric,
  {$ENDIF}

  {$IFDEF RW}
    RwOpenF,
  {$ENDIF}

  {$IFDEF CU}

      CustWinU,
      CustTypU,

      {$IFDEF COMCU}
        CustInit,
        ActiveX,
      {$ENDIF}

  {$ENDIF}
  {$IFNDEF OLE}
    MiscU,
  {$ENDIF}
  {$IFDEF EXSQL}
    SQLUtils,
    SQLFuncs,
  {$ENDIF} // EXSQL
  BTSFrmU1,
  //GS 14/10/2011 ABSEXCH-11706: For access to TABSInvLine9
  CustAbsU,

  //PR: 20/06/2012 ABSEXCH-11528
  CurrncyU;



{ ============== TdMTExLocal Methods ============== }

// MH 23/07/2014 v7.X: Added ability to change Client Id Prefix for Order Payments
Constructor TdPostExLocal.Create(CIdNo : SmallInt; Const CIdPrefix : ShortString);
Begin
  Inherited Create(CIdNo, CIdPrefix);

  CustLockOn:=BOff;
  CalcPurgeOB:=BOff;
  DelCCDepHist:=BOff;
  ForceYTNCF:=BOff;
end;

Constructor TdPostExLocal.Create(CIdNo  :  SmallInt);
Begin
  Create(CIdNo, '');
end;

Destructor TdPostExLocal.Destroy;

Begin

  Inherited Destroy;

end;


{ =========== Function to Check Exsistance of Given Code without disturbing record ========= }


Function  tdPostExLocal.LCheckExsists(KeyR  :  AnyStr;
                                   FileNum,KeyPath
                                            :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
//  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;

//PR: 16/09/2010 Changed to pass LocalF^ rather than TmpFn into database functions as, under SQL, the redirector requires the
//FileVar to have the same address as was used to open the file.
Begin
  KeyS:=KeyR;

//  TmpFn:=LocalF^[FileNum];

  TmpKPath:=GetPosKey;

  TmpStat:=LPresrv_BTPos(Filenum,TmpKPath,LocalF^[FileNum],TmpRecAddr,BOff,BOff);


  CEStatus:=Find_RecCId(B_GetGEq+B_KeyOnly,LocalF^[FileNum],FileNum,LRecPtr[FileNum]^,KeyPath,KeyS,ExClientId);

  LCheckExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=LPresrv_BTPos(Filenum,TmpKPath,LocalF^[FileNum],TmpRecAddr,BOn,BOff);

end;

{ =========== Function to Check Exsistance of Given Code and return record if found ========= }


Function  tdPostExLocal.LCheckRecExsists(KeyR  :  AnyStr;
                                       FileNum,KeyPath
                                             :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;



Begin
  KeyS:=KeyR;

  TmpFn:=LocalF^[FileNum];

  TmpKPath:=GetPosKey;

  TmpStat:=LPresrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


  CEStatus:=Find_RecCId(B_GetGEq,TmpFn,FileNum,LRecPtr[FileNum]^,KeyPath,KeyS,ExClientId);

  If (CEStatus<>0) then
    LResetRec(FileNum);

  LCheckRecExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=LPresrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

end;



{ ================== Procedure to Delete all Records Matching a give Code ============= }

Procedure tdPostExLocal.LDeleteLinks (Code  :  AnyStr;
                                    Fnum  :  Integer;
                                    KLen  :  Integer;
                                    KeyPth:  Integer;
                                    DelInv:  Boolean);

Var
  KeyS  :  AnyStr;
  LOk,
  Locked:  Boolean;

Begin
  KeyS:=Code;


  LStatus:=Find_RecCId(B_GetGEq,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Keypth,KeyS,ExClientId);

                                            {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (LStatus=0) and (CheckKey(Code,KeyS,KLen,BOn)) and ((Not DelInv) or ((DelInv) and (LId.LineNo<> RecieptCode))) do
  Begin

    LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked);

    If (LOk) and (Locked) then
    Begin
      LStatus:=LDelete_Rec(Fnum,KeyPth);

      {$IFDEF PF_On}

        {* If this does get called within the thread, would need to make delete job thread safe *}
        If (Not EmptyKey(LId.JobCode,JobKeyLen)) and (LStatusOk) and (Fnum=IdetailF) and (debug) then
          {EX32? Delete_JobAct(Id);}
          ShowMessage('Delete job called from within MTExLocal!');

      {$ENDIF}
    end;


    LStatus:=LFind_Rec(B_GetNext,Fnum,Keypth,KeyS);


  end;
end;


  { ================== Procedure to Delete all History Records Matching a give Code and after purge year ============= }

  Procedure tdPostExLocal.LDeleteAuditHist (Code     :  AnyStr;
                                            KLen     :  Integer;
                                            UseReset :  Boolean);
  Const
    Fnum     =  NHistF;
    Keypth   =  NHK;

  Var
    KeyS   :  AnyStr;
    LOk,
    Locked :  Boolean;
{$IFDEF EXSQL}
    sCompany: ShortString;
    sWhere: AnsiString;
{$ENDIF}
  Begin
    If (UseReset) then
      LResetAuditHist(Code,KLen)
    else
    Begin

      KeyS:=Code;

{$IFDEF EXSQL}
      // CJS 27/08/2008: Added an alternate direct to DB Engine version for SQL to improve performance
      if (SQLUtils.UsingSQLAlternateFuncs) Then
      begin
        sCompany := GetCompanyCode(SetDrive);

        if (Code <> '') then
          sWhere := '(' + GetDBColumnName('HISTORY.DAT', 'f_ex_class', '') + ' = ' + IntToStr(Ord(Code[1])) + ') AND ' +
                    '(SubString(' + GetDBColumnName('History.Dat', 'f_code', '') + ', 2, ' + IntToStr(KLen-1) + ') = ' + StringToHex(Copy(Code,2,KLen-1)) + ') AND ' +
                    '(' + GetDBColumnName('HISTORY.DAT', 'f_yr', '') + '>= ' + IntToStr(Syss.AuditYr) + ')'
        else
          sWhere := '(' + GetDBColumnName('HISTORY.DAT', 'f_yr', '') + '>= ' + IntToStr(Syss.AuditYr) + ')';

        // CJS 2011-10-19: ABSEXCH-11513 - added ClientID parameter.
        DeleteRows(sCompany, 'HISTORY.DAT', sWhere, ExClientId);

      end
      else
{$ENDIF} // EXSQL
      begin

        LStatus:=Find_RecCId(B_GetGEq,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Keypth,KeyS,ExClientId);


        While (LStatus=0) and (CheckKey(Code,KeyS,KLen,BOn)) do
        With LNHist do
        Begin

          If (AfterPurge(Yr,0)) then
          Begin
            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              LStatus:=LDelete_Rec(Fnum,KeyPth);
            end;
          end;

          LStatus:=LFind_Rec(B_GetNext,Fnum,Keypth,KeyS);

        end;
      end;
    end;
  end;


  Function tdPostExLocal.IsCCDepHist  :  Boolean;

  Begin
    Result:=BOn;

    If (DelCCDepHist) then
    Begin
      Result:=(LNHist.Code[6]>#32) or (LNHist.Code[7]>#32) or (LNHist.Code[8]>#32);
    end;
  end;

  { ================== Procedure to Reset all History Records Matching a give Code and after purge year ============= }

  Procedure tdPostExLocal.LResetAuditHist (Code  :  AnyStr;
                                           KLen  :  Integer);
  Const
    Fnum     =  NHistF;
    Keypth   =  NHK;

  Var
    LocalCode,
    KeyS   :  AnyStr;
    LOk,
    Locked :  Boolean;

    B_Func :  Integer;

    Tries,TryMax,
    LAddr  :  LongInt;

    {$IFDEF EXSQL}
      I : Byte;
      CustHistSet : Set of Char;
      Res : LongInt;
    {$ENDIF}

  {If we are deleting CC/Dep records, check it is one by making sure pos 6-8 does not contain spaces. v5.50
   A bug was found were G/L code 1092 is ASCI is D $04 00 00. The prefix for deps is D so the actual was being picked up by mistake *}


  Begin
    {$IFDEF EXSQL}
      CustHistSet := [];
      For I := Low(CustHistAry) To High(CustHistAry) Do
        CustHistSet := CustHistSet + [CustHistAry[I]];
      If SQLUtils.UsingSQLAlternateFuncs And
         (
           ((Length(Code) = (CustKeyLen + 1)) And (Code[1] In (CustHistSet + [CuStkHistCode])))  // Customer/Supplier or basic Acc Stk analysis
           Or
           ((Length(Code) = (CustKeyLen + 2)) And (Code[1] = CuStkHistCode)) // Acc Stk Anl with #1 or #2
         ) Then
      Begin
        // Resetting history for Customer/Supplier account
        Res := SQLUtils.ResetAuditHistory(SetDrive, Code, DelCCDepHist, Syss.AuditYr, Length(Code), ExClientId);
        If (Res < 0) Then
          MessageDlg ('tdPostExLocal.LResetAuditHist: ResetAuditHistory failed for ' + QuotedStr(Copy(Code, 1, 7)) + ' with an error ' + SQLUtils.LastSQLError,
                      mtError, [mbOK], 0);
      End // If SQLUtils.UsingSQLAlternateFuncs And (Code[1] In CustHistSet)
      Else
    {$ENDIF}
      Begin
        KeyS:=Code;  LocalCode:=Code;

         TryMax:=1000;

        LStatus:=Find_RecCId(B_GetGEq,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Keypth,KeyS,ExClientId);

        {$B-}
        While (LStatus=0) and (CheckKey(Code,KeyS,KLen,BOn)) do
        {$B+}
        With LNHist do
        Begin
          Tries:=0;  B_Func:=B_GetNext;

          If (AfterPurge(Yr,0)) and (IsCCDepHist)  then
          Begin
            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              LGetRecAddr(Fnum);

              Sales:=0; Purchases:=0; Cleared:=0;

              Repeat

                LStatus:=LPut_Rec(Fnum,KeyPth);

                Inc(Tries);

               Until (Not (LStatus In [84,85])) or (Tries>TryMax);


              LReport_Berror(Fnum,LStatus);



              LStatus:=LUnLockMLock(Fnum);
            end
            else
              If (Not LOk) then
                LStatus:=4
              else
                LStatus:=84;

            LReport_BError(Fnum,LStatus);

          end;

          LStatus:=LFind_Rec(B_Func,Fnum,Keypth,KeyS);

        end;
      End;
  end;




   { =============== Function to return last valid YTD ============= }

 Function tdPostExLocal.LLast_YTD(NType             :  Char;
                                NCode             :  Str20;
                                PCr,PYr,PPr       :  Byte;
                                Fnum,NPath        :  Integer;
                                Direc             :  Boolean)  :  Boolean;


  Var
    KeyChk,
    KeyS    :   Str255;
    B_Func  :   Integer;

    TmpBo   :   Boolean;

    CEStatus:   Integer;

  Begin

    CEStatus:=0;

    TmpBo:=BOff;

    If (Not Direc) then
      B_Func:=B_GetLessEq
    else
      B_Func:=B_GetGEq;

    KeyChk:=PartNHistKey(NType,NCode,PCr);

    KeyS:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

    CEStatus:=LFind_Rec(B_Func,Fnum,NPath,KeyS);

    TmpBo:=((CEStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and
               (((LNHist.Yr<=PYr) and (Not Direc)) or ((LNHist.Yr>=PYr) and (Direc))) and
               ((LNHist.Pr=PPr) or (Direc)));

    If (TmpBo) and (Direc) then {* Check for the exact YTD as this returns next History which will be a period *}

      TmpBo:=LCheckRecExsists(FullNHistKey(NType,NCode,PCr,LNHist.Yr,PPr),NHistF,NHK);

    LLast_YTD:=TmpBo;

  end; {Func..}



  { =============== Proc to Add a New History Record =============== }

  Procedure tdPostExLocal.LAdd_NHist(NType           :  Char;
                                   NCode           :  Str20;
                                   PCr,PYr,PPr     :  Byte;
                                   Fnum,NPath      :  Integer);

  Var
    LastPurch,
    LastSales,
    LastCleared:  Real;

    Tries,
    TryMax,
    N          :  LongInt;


  Begin
    LastPurch:=0; LastSales:=0; LastCleared:=0;

    N:=0; Tries:=0; TryMax:=1000;

    {$B-}

    If (PYr>0) then
    Begin

      If (PPr=YTD) and (LLast_YTD(NType,NCode,PCr,AdjYr(PYr,BOff),PPr,Fnum,NPath,BOff)) then
      With LNHist do
      Begin

        N:=(PYr-Yr);

        If (N>1) then  {* Add YTD In between *}
          For N:=AdjYr(Yr,BOn) to AdjYr(PYr,BOff) do
            LAdd_NHist(NType,NCode,PCr,N,PPr,Fnum,NPath);

        LastPurch:=Purchases;
        LastSales:=Sales;

        If (NType In [StkStkQCode,StkDLQCode,StkBillQCode,JobGrpCode,JobJobCode]) then  {* This mod necessary,
                                                          as otherwise qty adjustments which transend years
                                                          missed *}
          LastCleared:=Cleared;
      end;
      {$B+}


      With LNHist do
      Begin

        LResetRec(Fnum);

        ExClass:=NType;

        Code:=FullNHCode(NCode);

        Cr:=PCr;  Yr:=PYr; Pr:=PPr;

        Sales:=LastSales;  Purchases:=LastPurch;

        Cleared:=LastCleared;

        Repeat
          LStatus:=LAdd_Rec(Fnum,Npath);

          Inc(Tries);

       Until (Not (LStatus In [84,85])) or (Tries>TryMax);


        LReport_BError(Fnum,LStatus);

      end; {With..}
    end
    else
    Begin
      If (Debug) then  {Break point}
        MessageBeep(0);
    end;
  end; {Proc..}



 { ======== Proc to determine what type of YTD (if any) a heading type contains ===== }

Procedure tdPostExLocal.LHed_YTDType(MoveCode  :  LongInt;
                                     NTyp      :  Char;
                                     Fnum,
                                     Keypath   :  Integer;
                                 Var YTDOk,
                                     YTDNCFOk  :  Boolean);



Var
  FoundOk  :  Boolean;
  KeyS,
  KeyChk   :  Str255;



Begin

  YTDOk:=BOff;
  YTDNCFOk:=BOff;

  FoundOk:=BOff;

  KeyChk:=NTyp+FullNomKey(MoveCode);

  KeyS:=KeyChk;

  LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

  While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
  With LNHist do
  Begin

    FoundOk:=(Pr In [YTD,YTDNCF]);

    If (Not FoundOk) then
      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

  end; {While..}

  If (FoundOk) then
  With LNHist do
  Begin

    YTDOk:=(Pr=YTD);
    YTDNCFOk:=(Pr=YTDNCF);

  end;

end; {Proc..}


  { ============ Procedure to Create any Blank history records ============ }

Procedure tdPostExLocal.LFillBudget(Const  Fnum,
                                           Keypath  :  Integer;
                                    Var    Mode     :  Byte;
                                           NKey     :  Str255);

Var
  n,
  NeedYTD  :  Byte;

  HedYTD,
  HedYTDNCF,
  LOk, Locked
           :  Boolean;

  TSales,
  TPurch,
  TCleared,
  Rnum,
  TmpBudget,
  TBudget2,

  BV1,BV2    :  Double; 

  Tries,TryMax,
  MoveCode,
  RecAddr
              :  LongInt;

  GStr        :  Str5;

  LocalNHist  :  HistoryRec;

Begin
  NeedYTD:=0;  HedYTD:=BOff; HedYTDNCF:=BOff;

  LOk:=BOff; Locked:=BOff;

  Tries:=0; TryMax:=1000;

  Begin

    LResetRec(Fnum);

    Extract_NHistfromNKey(Nkey,LNHist);

    With LNHist do
    For n:=1 to Syss.PrinYr do
      If (Not LCheckExsists(FullNHistKey(ExClass,Code,Cr,GetLocalPr(0).CYr,n),Fnum,KeyPath)) then
        LAdd_NHist(ExClass,Code,Cr,GetLocalPr(0).CYr,n,Fnum,KeyPAth);


    With LNHist do
    Begin
      If (ExClass=NomHedCode) then
      Begin
        MoveCode:=0;    

        GStr:=Copy(Code,1,4);

        Move(GStr[1],MoveCode,4);

        LocalNHist:=LNHist;

        LHed_YTDType(MoveCode,ExClass,Fnum,Keypath,HedYTD,HedYTDNCF);

        LNHist:=LocalNHist;

      end;

      If ((ExClass In YTDSet) and (Not ForceYTNCF)) or (HedYTD) then
        NeedYTD:=YTD
      else
        If (ExClass In YTDNCFSet) or (HedYTDNCF) then
          NeedYTD:=YTDNCF;
    end;

    If (NeedYTD>0) then {Set YTD if Necessary}
    With LNHist do
    Begin
      If (Not LCheckExsists(FullNHistKey(ExClass,Code,Cr,GetLocalPr(0).CYr,NeedYTD),Fnum,KeyPath)) then
      Begin
        LocalNHist:=LNHist;

        Rnum:=LTotal_Profit_to_Date(ExClass,Code,Cr,GetLocalPr(0).CYr,Pr,TPurch,TSales,TCleared,TmpBudget,TBudget2,BV1,BV2,BOn);

        LNHist:=LocalNHist;

        LAdd_NHist(ExClass,Code,Cr,GetLocalPr(0).CYr,NeedYTD,Fnum,KeyPAth);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,NKey,KeyPath,Fnum,BOn,Locked);

        If (LOk) and (Locked) then
        Begin
          LGetRecAddr(Fnum);

          Sales:=TSales; Purchases:=TPurch; Cleared:=TCleared;

          Repeat

            LStatus:=LPut_Rec(Fnum,Keypath);

            Inc(Tries);

          Until (Not (LStatus In [84,85])) or (Tries>TryMax);

          LReport_Berror(Fnum,LStatus);

          LStatus:=LUnLockMLock(Fnum);

        end;

      end;

    end;


    Mode:=4
  end;

end; {Proc..}




  { =============== Procedure to Post Actual History Record =============== }

  Procedure tdPostExLocal.LPost_To_Hist2(NType         :  Char;
                                         NCode         :  Str20;
                                         PPurch,PSales,
                                         PCleared,
                                         PValue1,
                                         PValue2
                                                       :  Double;
                                         PCr,PYr,PPr   :  Byte;
                                     Var PrevBal       :  Double);

  Const
    Fnum  =  NHistF;
    NPath =  NHK;


  Var
    NKey       :  Str255;
    QtyNoDecs  :  Byte;

    Tries,TryMax,
    LAddr      :  LongInt;

    LOk,
    Locked     :  Boolean;

    FuncRes: Integer;

    Buffer: Str20;
  Begin
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQLAlternateFuncs then
    begin
      Buffer := StringOfChar(#32, 20);
      Move(NCode[1], Buffer[1], Length(NCode));
      FuncRes := SQLUtils.PostToHistory(NType, Buffer, PPurch, PSales, PCleared, PValue1, PValue2, PCr, PYr, PPr, Syss.NoQtyDec, PrevBal, LStatus, ExClientID);
      if (FuncRes <> 0) and (LStatus = 0) then
        LStatus := FuncRes;
      if (LStatus <> 0) then
        LReport_Error(SQLUtils.LastSQLError);
    end
    else
    {$ENDIF}
    begin
      Blank(NKey,Sizeof(NKey));  PrevBal:=0;

      NKey:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

      QtyNoDecs:=2; Tries:=0; TryMax:=1000;

      LStatus:=LFind_Rec(B_GetEq,Fnum,NPath,NKey);



      If (Not LStatusOK) then
        LAdd_NHist(NType,NCode,PCr,PYr,PPr,Fnum,NPath);


      Blank(NKey,Sizeof(NKey));

      NKey:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,NKey,NPath,Fnum,BOn,Locked);

      If (LOk) and (Locked) then
      With LNHist do
      Begin
        LGetRecAddr(Fnum);

        {* Adjust Rounding on Stock Qty Calculations, Cleared = Qty count *}
        If (ExClass In StkProdSet+[StkGrpCode,StkDescCode,StkStkQCode,StkBillQCode,CuStkHistCode]+[CommitHCode,JobGrpCode,JobJobCode]) then
          QtyNoDecs:=Syss.NoQtyDec;


        PrevBal:=Purchases-Sales;

        Purchases:=Round_Up(Purchases+Round_Up(PPurch,2),2);

        Sales:=Round_Up(Sales+Round_Up(PSales,2),2);

        Cleared:=Round_Up(Cleared+Round_Up(PCleared,QtyNoDecs),QtyNoDecs);

        Value1:=Round_Up(Value1+Round_Up(PValue1,QtyNoDecs),QtyNoDecs);
        Value2:=Round_Up(Value2+Round_Up(PValue2,QtyNoDecs),QtyNoDecs);


        Repeat

          LStatus:=LPut_Rec(Fnum,Npath);

          Inc(Tries);

         Until (Not (LStatus In [84,85])) or (Tries>TryMax);


        LReport_Berror(Fnum,LStatus);

        LStatus:=LUnLockMLock(Fnum);
      end
      else
        If (Not LOk) then
          LStatus:=4
        else
          LStatus:=84;
    end;

    LReport_BError(Fnum,LStatus);

  end; {Proc..}





  { ================ Recursivley Post to YTD & Future Year to dates ============== }

  Procedure tdPostExLocal.LPost_To_CYTDHist2(NType          :  Char;
                                             NCode          :  Str20;
                                             PPurch,PSales,
                                             PCleared,
                                             PValue1,
                                             PValue2        :  Double;
                                             PCr,PYr,PPr    :  Byte);

  Var
    Rnum   :  Double;
    FuncRes: Integer;
    Buffer: Str20;
  Begin
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQLAlternateFuncs then
    begin
      Buffer := StringOfChar(#32, 20);
      Move(NCode[1], Buffer[1], Length(NCode));
      FuncRes := SQLUtils.PostToYearDate(NType, Buffer, PPurch, PSales, PCleared, PValue1, PValue2, PCr, PYr, PPr, Syss.NoQtyDec, LStatus, ExClientID);
      if (FuncRes <> 0) and (LStatus = 0) then
        LStatus := FuncRes;
      if (LStatus <> 0) then
        LReport_Error(SQLUtils.LastSQLError);
    end
    else
    {$ENDIF}
    begin
      Rnum:=0;

      LPost_To_Hist2(NType,NCode,PPurch,PSales,PCleared,PValue1,PValue2,PCr,PYr,PPr,Rnum);

      If (LLast_YTD(NType,NCode,PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
        LPost_To_CYTDHist2(NType,NCode,PPurch,PSales,PCleared,PValue1,PValue2,PCr,LNHist.Yr,PPr);
    end;
  end;



  { =============== Procedure to Post Actual History Record =============== }

  Procedure tdPostExLocal.LPost_To_Hist(NType         :  Char;
                                        NCode         :  Str20;
                                        PPurch,PSales,
                                        PCleared
                                                      :  Double;
                                        PCr,PYr,PPr   :  Byte;
                                    Var PrevBal       :  Double);

  Begin
    LPost_To_Hist2(NType,NCode,PPurch,PSales,PCleared,0,0,PCr,PYr,PPr,PrevBal);


  end; {Proc..}





  { ================ Recursivley Post to YTD & Future Year to dates ============== }

  Procedure tdPostExLocal.LPost_To_CYTDHist(NType          :  Char;
                                            NCode          :  Str20;
                                            PPurch,PSales,
                                            PCleared       :  Double;
                                            PCr,PYr,PPr    :  Byte);


  Begin
    LPost_To_CYTDHist2(NType,NCode,PPurch,PSales,PCleared,0,0,PCr,PYr,PPr);
  end;



{ == Proc to prime reset NHist records with the closing balance of a purged year == }


 Procedure tdPostExLocal.Prime_To_CYTDHist(NType          :  Char;
                                           NCode          :  Str20;
                                           PCr,PYr,PPr    :  Byte);

 Var
   Rnum,
   Purch,Sales,Cleared  :  Double;


 Begin
   Rnum:=0;

   If (BeenPurge(0)) then
   Begin
     CalcPurgeOB:=BOn;

     Rnum:=LProfit_To_Date(NType,NCode,PCr,PYr,99,Purch,Sales,Cleared,BOn);

     CalcPurgeOB:=BOff;

     {$B-}
     If ((Purch<>0.0) or (Sales<>0.0) or (Cleared<>0.0)) and (LLast_YTD(NType,NCode,PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
     {$B+}
     Begin
       LPost_To_CYTDHist(NType,NCode,Purch,Sales,Cleared,PCr,LNHist.Yr,PPr);
     end;
   end;
 end;

//-------------------------------------------------------------------------

// MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
Function tdPostExLocal.LTotal_Profit_To_Date(NType        :  Char;
                                             NCode        :  Str20;
                                             PCr,PYr,PPr  :  Byte;
                                         Var Purch,PSales,
                                             PCleared,
                                             PBudget,
                                             RevisedBudget1 :  Double;
                                         Var BValue1,
                                             BValue2      :  Double;
                                             Range        :  Boolean)  :  Double;
Var
  RevisedBudget2 : Double;
  RevisedBudget3 : Double;
  RevisedBudget4 : Double;
  RevisedBudget5 : Double;
Begin // LTotal_Profit_To_Date
  RevisedBudget2 := 0.0;
  RevisedBudget3 := 0.0;
  RevisedBudget4 := 0.0;
  RevisedBudget5 := 0.0;

  Result := LTotal_Profit_to_Date_RevBudgets (NType, NCode, PCr, PYr, PPr, Purch, PSales, PCleared, PBudget,
                                              RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
                                              BValue1, BValue2, Range);
End; // LTotal_Profit_To_Date

//-----------------------------------

// MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
Function tdPostExLocal.LTotal_Profit_to_Date_RevBudgets (    NType             : Char;
                                                             NCode             : Str20;
                                                             PCr,PYr,PPr       : Byte;
                                                         Var Purch,
                                                             PSales,
                                                             PCleared,
                                                             PBudget,
                                                             RevisedBudget1,
                                                             RevisedBudget2,
                                                             RevisedBudget3,
                                                             RevisedBudget4,
                                                             RevisedBudget5    : Double;
                                                         Var BValue1, BValue2  : Double;
                                                             Range             : Boolean)  :  Double;
Const
  Fnum  =  NHistF;
  NPath =  NHK;
Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Bal          :  Double;
  FuncRes: Integer;
Begin
  Purch:=0; PSales:=0; PCleared:=0;  PBudget:=0; Bal:=0;

  // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
  RevisedBudget1 := 0.0;
  RevisedBudget2 := 0.0;
  RevisedBudget3 := 0.0;
  RevisedBudget4 := 0.0;
  RevisedBudget5 := 0.0;

  BValue1:=0.0; BValue2:=0.0;

{$IFDEF EXSQL}
  if SQLUtils.UsingSQLAlternateFuncs then
  begin
    // MH 19/05/2011 v6.7 ABSEXCH-11374: Added missing ExClientId parameter as OLE Server was using the wrong company dataset
    FuncRes := SQLUtils.TotalProfitToDateRange(SetDrive, NType, NCode, PCr, PYr, PPr, 0,
      Range, CalcPurgeOB, Purch, PSales, Bal, PCleared, PBudget,
      RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
      BValue1, BValue2, ExClientId);
    if FuncRes <> 0 then
    begin
      LReport_BError(Fnum, FuncRes);
    end;
  end
  else
{$ENDIF}
  Begin
    NHChK:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

    If (Range) then
      NHKey:=FullNHistKey(NType,NCode,PCr,PYr-1,YTD)
    else
      NHKey:=NHChk;

    If (NType In YTDSet+[NomHedCode,CustHistCde,CustHistPCde,CommitHCode]) and (Range) then  {** Get Last Valid YTD **}
    Begin
      NHKey2:=NHKey;
      LStatus:=LFind_Rec(B_GetLessEq,Fnum,NPath,NHKey2);

      If (LStatusOk) and (CheckKey(NHChk,NHKey2,Length(NHChk)-2,BOn)) and (LNHist.Pr=YTD) then
        NHKey:=NHKey2;
    end;


    LStatus:=LFind_Rec(B_GetGEq,Fnum,NPath,NHKey);


    While (LStatusOK) and (NHKey<=NHChk) do
    Begin
      If ((NType<>CustHistCde) or (Not (LNHist.Pr In [YTD,YTDNCF])))  or (CalcPurgeOB) then
      Begin
        Purch:=Purch+LNHist.Purchases;
        PSales:=PSales+LNHist.Sales;
      end;

      Bal:=Bal+(LNHist.Purchases-LNHist.Sales);

      PCleared:=PCleared+LNHist.Cleared;

      If (Not (LNHist.Pr In [YTD,YTDNCF])) then
      Begin
        PBudget:=PBudget+LNHist.Budget;

        // MH 04/05/2016 2016-R2 ABSEXCH-17353: Added Revised Budgets 1-5 to GL History
        RevisedBudget1 := RevisedBudget1 + LNHist.RevisedBudget1;
        RevisedBudget2 := RevisedBudget2 + LNHist.RevisedBudget2;
        RevisedBudget3 := RevisedBudget3 + LNHist.RevisedBudget3;
        RevisedBudget4 := RevisedBudget4 + LNHist.RevisedBudget4;
        RevisedBudget5 := RevisedBudget5 + LNHist.RevisedBudget5;
      end;

      BValue1:=BValue1+LNHist.Value1;
      BValue2:=BValue2+LNHist.Value2;

      LStatus:=LFind_Rec(B_GetNext,Fnum,NPath,NHKey);
    End; // While (LStatusOK) and (NHKey<=NHChk)
  End;

  Result := Bal;
end; {Func..}



{ =============== Procedure to GetNext Available Number ============== }

Function tdPostExLocal.LGetNextCount(DocHed     :  DocTypes;
                                     Increment,
                                     UpLast     :  Boolean;
                                     NewValue   :  Real)  :  LongInt;

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



{ ========== Return Full DocNum ============= }


Function tdPostExLocal.LFullDocNum(DocHed    :  DocTypes;
                                   Increment :  Boolean)  :  Str20;

Const
    ExtendSuffix  :  Array[0..22] of Char = ('A','B','C','D','E','F','G','H','J','K','L','M','N','P','Q','R','T','U','V','W','X','Y','Z');


  Var
    SIdx
          :  Byte;

    VR    :  Integer;
    Lcnt,
    SVal  :  LongInt;

    SSufix:  Str5;
    StrLnt:  Str255;


Begin
  LCnt:=0; StrLnt:=''; SSufix:='';

  Lcnt:=LGetNextCount(DocHed,Increment,BOff,0);

  Str(Lcnt:0,StrLnt);

  If (Length(StrLnt)>6) then
  Begin
    Val(Copy(StrLnt,1,2),SVal,Vr);

    If (Vr=0) and (SVal<33) and (SVal>=10) then
    Begin
      SSufix:=ExtendSuffix[SVal-10];

      StrLnt:=Copy(StrLnt,3,5);

      Val(StrLnt,SVal,Vr);

      If (Vr=0) then
      Begin
        Str(SVal:0,StrLnt);
      end;

    end;

  end;


  LFullDocNum:=DocCodes[DocHed]+SSufix+SetPadNo(StrLnt,(DocKeyLen-Length(DocCodes[DocHed])-Length(SSufix)));
end;




{ ======== Procedure to set next doc & Folio Nos ======= }
{ ** Duplicated in SysU1 *}


Procedure tdPostExLocal.LSetNextDocNos(Var  InvR  :  InvRec;
                                            SetOn :  Boolean);


Var
  FolioTyp  :  DocTypes;

  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;


Begin
  NotDupli:=BOn;

  UsedInv:=InvR;
  NORef:='ERROR!';
  NFolio:=0;

  Begin
    Repeat
      NORef:=LFullDocNum(UsedInv.InvDocHed,SetOn);

      If (SetOn) then
        NotDupli:=(Not LCheckExsists(NORef,InvF,InvOurRefK));

    Until (Not SetOn) or (NotDupli);

    If (UsedInv.InvDocHed In BatchSet+QuotesSet+StkAdjSplit+PSOPSet+TSTSplit) then
      FolioTyp:=AFL
    else
      FolioTyp:=FOL;

    Repeat
      NFolio:=LGetNextCount(FolioTyp,SetOn,BOff,0);

      If (SetOn) then
        NotDupli:=(Not LCheckExsists(Strip('R',[#0],FullNomKey(NFolio)),InvF,InvFolioK));

    Until (Not SetOn) or (NotDupli);

  end;

  With UsedInv do
  Begin
    OurRef:=NORef;
    FolioNum:=NFolio;
  end;

  InvR:=UsedInv;

end;




{ ========== Return Full Automatic Daybook DocNum ============= }


Function tdPostExLocal.LFullAutoDocNum(DocHed    :  DocTypes;
                                       Increment :  Boolean)  :  Str20;


Var
  Lcnt  :  LongInt;
  StrLnt:  Str255;


Begin
  LCnt:=0; StrLnt:='';

  Lcnt:=LGetNextCount(ADC,Increment,BOff,0);

  Str(Lcnt:0,StrLnt);

  LFullAutoDocNum:=DocCodes[DocHed]+SetPadNo(StrLnt,(Pred(DocKeyLen)-Length(DocCodes[DocHed])))+AutoPrefix;
end;




{ ======== Procedure to set next auto doc & Folio Nos ======= }
{ ** Duplicated in SysU1 *}


Procedure tdPostExLocal.SetNextAutoDocNos(Var  InvR  :  InvRec;
                                               SetOn :  Boolean);

Var
  NotDupli  :  Boolean;
  UsedInv   :  InvRec;
  NORef     :  Str20;
  NFolio    :  LongInt;


Begin
  NotDupli:=BOn;

  UsedInv:=InvR;
  NORef:='ERROR!';
  NFolio:=0;

  Begin
    Repeat
      NORef:=LFullAutoDocNum(UsedInv.InvDocHed,SetOn);

      If (SetOn) then
        NotDupli:=(Not LCheckExsists(NORef,InvF,InvOurRefK));

    Until (Not SetOn) or (NotDupli);

    Repeat
      NFolio:=LGetNextCount(AFL,SetOn,BOff,0);

      If (SetOn) then
        NotDupli:=(Not LCheckExsists(Strip('R',[#0],FullNomKey(NFolio)),InvF,InvFolioK));

    Until (Not SetOn) or (NotDupli);

  end;

  With UsedInv do
  Begin
    OurRef:=NORef;
    FolioNum:=NFolio;
  end;

  InvR:=UsedInv;

end;



{ ============== Get Profit To Current Period ============== }

Function tdPostExLocal.LProfit_To_Date(NType        :  Char;
                                       NCode        :  Str20;
                                       PCr,PYr,PPr  :  Byte;
                                   Var Purch,PSales,
                                       PCleared     :  Double;
                                       Range        :  Boolean)  :  Double;


Var
  PBudget,
  PBudget2  :  Double;

  DBudget1,
  DBudget2  :  Double;

Begin

  PBudget:=0.0;
  PBudget2:=0.0;

  DBudget1:=0.0;
  DBudget2:=0.0;

  LProfit_To_Date:=LTotal_Profit_to_Date(NType,NCode,PCr,PYr,PPr,Purch,PSales,PCleared,PBudget,PBudget2,DBudget1,DBudget2,Range);


end; {Func..}


{ ======= Procedure to update the Account Balances =========== }

Procedure tdPostExLocal.LUpdateBal(UInv   :  InvRec;
                                   BalAdj :  Real;
                                   CosAdj,
                                   NetAdj :  Real;
                                   Deduct :  Boolean;
                                   Mode   :  Byte);


{*  Mode definitions  *}

{   0 - Update both U & V & W type Cust balances }
{   1 - Update Only     V   "    "      "    }
{   2 - Update Only U & W   "    "      "    }

Var
  FCust  :  Str255;
  Cnst   :  Integer;
  PBal   :  Double;
  CrDr   :  DrCrType;
  StartCode
         :  Char;

  LOK,
  Locked :  Boolean;

  LAddr  :  LongInt;
  Deduct1 : Boolean;

Begin
  With UInv do
  Begin

    Blank(CrDr,Sizeof(CrDr));  PBal:=0;

    StartCode:=CustHistCde;

    FCust:=FullCustCode(CustCode);

    If (Not EmptyKey(FCust,CustKeyLen)) then
    Begin
      { == Get Actual Customer Rec == }
      {$IFDEF EXSQL}
      If SQLUtils.UsingSQL Then
      Begin
        // Account Last date used set by trigger
        Locked:=BOff;
        LOk:=BOff;

        // Position on Customer just in case that behaviour is required from calling code
        LFind_Rec(B_GetEq, CustF, CustCodeK, FCust);
      End // If SQLUtils.UsingSQLAlternateFuncs
      Else
      {$ENDIF}
      Begin
        Locked:=BOn;

        If (CustLockOn) then
          LOk:=BOn
        else
        Begin
          If (LTry_Lock(B_GetEq,B_SingNWLock+B_MultLock,FCust,CustCodeK,CustF,LRecPtr[CustF])=0) then
            LOk:=LGetMultiRec(B_GetEq,B_MultLock,FCust,CustCodeK,CustF,BOn,Locked)
          else
            LOk:=BOff;

        end;
      End;

      {If (LOk) and (Locked) then} {v5.52 Alter this to a non wait lock as we are only locking to update the last used flag.
                                         Having a lock here can cuase a dead lock if check is being run on an account by one
                                         user, whilst another has the same accounts transaction locked }
      Begin
        LGetRecAddr(CustF);


        If (Deduct) then
        Begin
          Cnst:=-1;
          BalAdj:=BalAdj*Cnst;

          CosAdj:=CosAdj*Cnst;

          NetAdj:=NetAdj*Cnst;
        end
        else
          Cnst:=1;

        BalAdj:=(BalAdj*Cnst);

        ShowDrCr(BalAdj,CrDr);

        If (InvDocHed In DirectSet) then      {* If Direct Put Same Amount on other Side to record turnover *}
          CrDr[(Not (BalAdj<0))]:=ABS(BalAdj);

        If (Deduct) then
          For Deduct1:=BOff to BOn do
            CrDr[Deduct1]:=Round_Up((CrDr[Deduct1]*Cnst),2);



        Case Mode of
          0  :  Deduct:=BOn;

          1  :  Begin
                  StartCode:=CustHistPCde;
                  Deduct:=BOff;
                end;

          2  :  Deduct:=BOff;
        end; {Case..}


        {*EN420}

        If (AfterPurge(AcYr,0)) then {* Only update balances for live period *}
        Repeat

          LPost_To_Hist(StartCode,FCust,CrDr[BOff],CrDr[BOn],0,0,AcYr,AcPr,PBal);

          LPost_To_CYTDHist(StartCode,FCust,CrDr[BOff],CrDr[BOn],0,0,AcYr,YTD);

          If (Not Deduct) then {* Post Hist for MD/C and 0, as Dr/Cr Ctrl accounts *}
          Begin
            LPost_To_Hist(StartCode,FCust+FullNomKey(Check_MDCCC(CtrlNom)),CrDr[BOff],CrDr[BOn],0,0,AcYr,AcPr,PBal);

            LPost_To_CYTDHist(StartCode,FCust+FullNomKey(Check_MDCCC(CtrlNom)),CrDr[BOff],CrDr[BOn],0,0,AcYr,YTD);
          end;

          If (StartCode=CustHistCde) and (InvDocHed In StkOutSet+StkInSet)  then  {* Post to GP Screen *}
          Begin

            LPost_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,AcPr,PBal);

                                                                        {* Post to Non C/F YTD *}
            LPost_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,YTDNCF,PBal);

          end;


          StartCode:=CustHistPCde;

          Deduct:=Not Deduct;

        Until (Deduct);

        If (Not CustLockOn) and (LOk) and (Locked) then
        With LCust do
        Begin
          {* Update last edited flag *}

          LastUsed:=Today;
          TimeChange:=TimeNowStr;

          LStatus:=LPut_Rec(CustF,CustCodeK);

          LReport_BError(CustF,LStatus);

          LStatus:=LUnLockMLock(CustF);
        end;

      end; {If locked..}
    end; {If Blank Cust..}
  end; {With..}
end;



Procedure tdPostExLocal.LUpdateOrdBal(UInv   :  InvRec;
                                      BalAdj :  Real;
                                      CosAdj,
                                      NetAdj :  Real;
                                      Deduct :  Boolean;
                                      Mode   :  Byte);

Const
    Fnum   =   CustF;

{*  Mode definitions  *}

{   1 - Update Only     U }

Var
  FCust  :  Str255;
  Cnst   :  Integer;
  PBal   :  Double;
  CrDr   :  DrCrType;
  StartCode
         :  Char;

  LOk,
  LoopComplete,
  Locked :  Boolean;

  TmpKPath,
  TmpStat:  Integer;

  TmpRecAddr,
  LoopCounter
         :  LongInt;
  OrigCCode,
  HOCCode:  Str10;

  LocalCust
         :  CustRec;


Begin
  With UInv do
  If (InvDocHed In PSOPSet+JAPOrdSplit) then
  Begin
    LoopCounter:=0; OrigCCode:=FullCustCode(UInv.CustCode); HOCCode:=NdxWeight;

    LocalCust:=LCust;  LOk:=BOff;

    Blank(CrDr,Sizeof(CrDr));  PBal:=0;

    StartCode:=CustHistCde;

    FCust:=FullCustCode(CustCode);

    If (Not EmptyKey(FCust,CustKeyLen)) then
    Begin
      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      If (Deduct) then
      Begin
        Cnst:=-1;
        BalAdj:=BalAdj*Cnst;

        CosAdj:=CosAdj*Cnst;

        NetAdj:=NetAdj*Cnst;
      end
      else
        Cnst:=1;


      Repeat
        LoopComplete:=BOn;

        If (LoopCounter=1) then
          HOCCode:=FCust;

        Inc(LoopCounter);


        LPost_To_Hist(StartCode,FCust,0,0,BalAdj,0,AcYr,AcPr,PBal);

        LPost_To_CYTDHist(StartCode,FCust,0,0,BalAdj,0,AcYr,YTD);


        If (LCust.CustCode<>FCust) then
          LOK:=LGetMainRec(CustF,FCust)
        else
          LOK:=BOn;

        If (LOK) and (Not EmptyKey(LCust.SOPInvCode,CustKeyLen)) then
        Begin
          FCust:=FullCustCode(LCust.SOPInvCode);

          LOK:=LGetMainRec(CustF,FCust);

          LoopComplete:=(Not LOK) or (LCust.SOPConsHO<>1);

        end;



      Until (LoopComplete) or (FCust=OrigCCode) or (FCust=HOCCode);

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


      LCust:=LocalCust;



    end; {If Blank Cust..}
  end; {With..}
end;


Procedure tdPostExLocal.LRemove_MatchPay(ORef     :  Str20;
                                         MTyp,
                                         STyp     :  Char;
                                         RemMatch :  Boolean);




Var
  ScanKey,
  ChkKey  :  Str255;

  UOk,Locked
          :  Boolean;

  Fnum,
  Keypath,
  TmpStatus
          :  Integer;

  {$IFDEF EXSQL}
    sCompany : ShortString;
    sWhere : ANSIString;

  Function ColName(Const ColumnName : ShortString; Const Variant : ShortString = 'T*') : ShortString;
  Begin // ColName
    Result := GetDBColumnName('ExchqChk.Dat', ColumnName, Variant)
  End; // ColName
  {$ENDIF} // EXSQL
Begin
{$IFDEF EXSQL}
  // MH 04/06/2008: Added an alternate direct to DB Engine version for SQL to improve performance
  If (Not SQLUtils.UsingSQLAlternateFuncs) or (STyp <> 'P') Then
  Begin
{$ENDIF} // EXSQL
    Fnum      := PWrdF;

    If (RemMatch) then
      KeyPath:=HelpNdxK
    else
      Keypath   := PWK;

    TmpStatus:=LStatus;

    ScanKey:=FullMatchKey(MatchTCode,STyp,ORef);

    ChkKey:=ScanKey;

    UOk:=BOn; Locked:=BOn;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,ScanKey);

    While (LStatusOk) and (UOk) and (Locked) and (CheckKey(ChkKey,ScanKey,Length(ChkKey),BOn)) do
    Begin

      If (LPassWord.MatchPayRec.MatchType=MTyp) then
      Begin
        UOk:=LGetMultiRec(B_GetDirect,B_MultLock,ScanKey,KeyPath,Fnum,BOn,Locked);

        If (UOK) and (Locked) then
        Begin

          LStatus:=LDelete_Rec(Fnum,KeyPath);

          LReport_BError(Fnum,LStatus);

        end;
      end;

      If (LStatusOk) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,ScanKey);
    end; {While..}

    LStatus:=TmpStatus;
{$IFDEF EXSQL}
  End // If (Not SQLUtils.UsingSQLAlternateFuncs)
  Else
  Begin
    // Do direct call to SQL Server to delete all rows in one go
    sCompany := GetCompanyCode(SetDrive);
    If RemMatch Then
      sWhere := '(PayRef = ''' + oRef + ''') AND '
    Else
      sWhere := '(DocRef = ''' + oRef + ''' ) AND ';
    sWhere := sWhere + '(MatchType = ' + QuotedStr(MTyp) + ')';
    DeleteRows(sCompany, 'FinancialMatching.Dat', sWhere);
  End; // Else
{$ENDIF} // EXSQL
end; {Proc..}



Procedure tdPostExLocal.LMatch_Payment(Var InvR  :  InvRec;
                                           AddT,
                                           AddN  :  Real;
                                           Mode  :  Byte);

Const
  Fnum      = PWrdF;
  Keypath   = PWK;
  DocMatchTyp   :  Array[BOff..BOn] of Char = ('A','O');



Begin


  Case Mode of

    3,5,20,23
           :  With LPassword do
              With MatchPayRec do
              Begin

                LResetRec(Fnum);

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

                LStatus:=LAdd_Rec(Fnum,KeyPath);

                LReport_BError(Fnum,LStatus);

              end;


    4,21
         :  Begin
                LRemove_MatchPay(InvR.OurRef,DocMatchTyp[(Mode=21)],MatchSCode,BOff);

            end;

  end; {Case..}

end; {Proc..}



{$IFNDEF OLE}
{$IFNDEF RW}
{$IFNDEF XO}
{$IFNDEF ENDV}
{$IFNDEF WCA}
Function tdPostExLocal.LCheck_NoteNo(NoteType  :  Char;
                                     NoteFolio :  Str10)  :  LongInt;


Const
  Fnum      =  PWrdF;

  Keypath   =  PWk;

Var
  KeyChk,
  KeyS,
  NewKey    :  Str255;

  BigCount, FNK  :  LongInt;

  B_Func    :  Integer;


Begin
  BigCount := 0;
  {$IFDEF EXSQL}
    If SQLUtils.UsingSQLAlternateFuncs And (NoteType In ['A', 'S']) Then
    Begin
      If (NoteType = 'A') Then
        // Customer / Supplier
        // CJS 2011-08-04 ABSEXCH-11373 - Added Client ID to call
        BigCount := GetLineNumberAccounts(SetDrive, NoteFolio, ExClientId)
      Else If (NoteType = 'S') Then
      Begin
        // Stock
        Move (NoteFolio[1], FNK, SizeOf(FNK));
        BigCount := GetLineNumberStock(SetDrive, FNK, ExClientId);
      End; // If (NoteType = 'S')
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
  {$ENDIF}
    Begin
      BigCount:=1;

      B_Func:=B_GetNext;

      NewKey:='';

      KeyChk:=PartNoteKey(NoteTCode,NoteType,FullNCode(NoteFolio));

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With LPassword.NotesRec do
      Begin

        If (LineNo>BigCount) then
          BigCount:=LineNo;


        {$IFDEF PREV432001} {Taken out as some corrupt ledgers can exceed 1E6 and then build keys which are in a loop}
          NewKey:=FullRNoteKey(NoteFolio,NType,LineNo);

          If (NewKey<>NoteNo) then {* Its the old form of numbering *}
          Begin

            NoteNo:=NewKey;

            LStatus:=LPut_Rec(Fnum,KeyPath);

            B_Func:=B_GetGEq;
          end
          else
            B_Func:=B_GetNext;
        {$ENDIF}

        LStatus:=LFind_Rec(B_Func,Fnum,Keypath,KeyS);

      end; {While..}

      If (BigCount>1) then {* Set Next Line to 1 more than largest line, leave if not used yet *}
        BigCount:=Succ(BigCount);
    End;

    LCheck_NoteNo:=BigCount;
end; {Func..}


Procedure tdPostExLocal.LAdd_Notes(NoteType,
                                   NoteSType  :  Char;
                                   FolioCode  :  Str10;
                                   NDate      :  LongDate;
                                   NDesc      :  Str80;
                               Var DLineCount :  LongInt);


 Const
   Fnum      =  PWrdF;

   Keypath   =  PWk;


 Begin
   With LPassword,NotesRec do
   Begin

     LResetRec(Fnum);

     LineNo:=DLineCount;

     NType:=NoteSType;

     RecPfix:=NoteTCode;
     SubType:=NoteType;

     NoteDate:=NDate;

     NoteLine:=NDesc;

     NoteFolio:=FullNCode(FolioCode);

     NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

     ShowDate:=(NoteDate<>'');

     LStatus:=LAdd_Rec(Fnum,KeyPath);

     LReport_BError(Fnum,LStatus);

     If (LStatusOk) then
       Inc(DLineCount);

   end; {With..}

 end; {Proc..}


{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}


{ ========= Set PrintedDoc Flag ========= }

Procedure tdPostExLocal.LSet_PrintedStatus(ToPrinter,
                                           AlsoPicked:  Boolean;
                                           InvR     :  InvRec);


Const
  PrintDocSet  :  Set of DocTypes  = [SOR,SDN,SIN,SCR,SRI,SRF];

  Fnum         =  InvF;

  Keypath      =  InvOurRefK;


Var
  KeyS  :  Str255;

  LOk,
  Locked:  Boolean;


Begin

  Begin

    If ((Not InvR.PrintedDoc) or ((Not InvR.OnPickRun) and (AlsoPicked))) and (ToPrinter) and (InvR.InvDocHed In PrintDocSet) then
    Begin

      With InvR do
        KeyS:=OurRef;

      LOk:=LGetMultiRec(B_GetEQ,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      If (LOk) and (Locked) then
      With LInv do
      Begin
        LGetRecAddr(Fnum);

        PrintedDoc:=BOn;

        If (InvDocHed In OrderSet) then
          OnPickRun:=AlsoPicked;

        LStatus:=LPut_Rec(Fnum,Keypath);

        LReport_BError(Fnum,LStatus);

        LStatus:=LUnLockMLock(Fnum);
      end;

    end; {If..}

  end; {With..}

end; {Proc..}


{ ========= Search for H/O account ========= }

Function tdPostExLocal.Link_CustHO(CustHO  :  Str10)  :  CustRec;

Const
  Fnum     =  CustF;

Var
  TmpStat,
  TKeypath     :  Integer;
  TmpRecAddr   :  LongInt;

  CKey      :  Str255;
  OrigCust  :  CustRec;

Begin
  OrigCust:=LCust;
  Result:=LCust;

  If (Trim(CustHO)<>'') then
  Begin
    TKeypath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum,TKeypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    CKey:=FullCustCode(CustHO);

    If LGetMainRec(Fnum,CKey) then
      Result:=LCust;


    TmpStat:=LPresrv_BTPos(Fnum,TKeypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

  end;

  LCust:=OrigCust;
end;

{$IFNDEF OL_E}
 {$IFNDEF RW}
 {$IFNDEF XO}
  {$IFNDEF ENDV}
  {$IFNDEF WCA}
  {$IFDEF STK}
    {$IFDEF SOP}
      Function tdPostExLocal.LLocOverride(lc    :  Str10;
                                          Mode  :  Byte)  :  Boolean;

      Const
        Fnum  =  MLocF;

      Var
        TmpLoc  :  MLocPtr;

        LOk     :  Boolean;

        TmpKPath,
        TmpStat    :  Integer;
        TmpRecAddr :  LongInt;



      Begin
        Begin
          Result:=BOff;

          New(TmpLoc);

          TmpKPath:=GetPosKey;

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          TmpLoc^:=LMLocCtrl^;

          LOk:=LGetMainRec(MLocF,Quick_MLKey(lc));

          With LMLocCtrl^.MLocLoc do
          Case Mode of

            0  :  Result:=loUsePrice;
            1  :  Result:=loUseNom;
            2  :  Result:=loUseCCDep;
            3  :  Result:=loUseSupp;
            4  :  Result:={loUseBinLoc;}BOn;
            5  :  Result:=loUseCPrice;
            6  :  Result:=loUseRPrice;


          end; {Case..}

          Result:=(LOk and Result);

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

          LMLocCtrl^:=TmpLoc^;

          Dispose(TmpLoc);
        end; {With..}
      end;


      Function tdPostExLocal.LLocOPrice(lc  :  Str10)  :  Boolean;

      Begin
        Result:=LLocOverride(lc,0);

      end;

      Function tdPostExLocal.LLocONom(lc  :  Str10)  :  Boolean;

      Begin
        Result:=LLocOverride(lc,1);

      end;


      Function tdPostExLocal.LLocOCCDep(lc  :  Str10)  :  Boolean;

      Begin
        Result:=LLocOverride(lc,2);

      end;

      Function tdPostExLocal.LLocOSupp(lc  :  Str10)  :  Boolean;

      Begin
        Result:=LLocOverride(lc,3);

      end;

      Function tdPostExLocal.LLocOCPrice(lc  :  Str10)  :  Boolean;

      Begin
        LLocOCPrice:=LLocOverride(lc,5);

      end;


      Function tdPostExLocal.LLocORPrice(lc  :  Str10)  :  Boolean;

      Begin
        LLocORPrice:=LLocOverride(lc,6);

      end;


      { =========== Proc to return linked stock record ======== }

      Function tdPostExLocal.LLinkMLoc_Stock(lc  :  Str10;
                                             sc  :  Str20;
                                         Var TSL :  MStkLocType)  :  Boolean;

      Const
        Fnum      =  MLocF;
        Keypath   =  MLSecK;

      Var
        KeyS,
        KeyChk     :  Str255;

        TmpKPath,
        TmpStat    :  Integer;
        TmpRecAddr :  LongInt;
        TmpMLoc    :  MLocRec;


      Begin
        TmpMLoc:=LMLocCtrl^;


        Blank(TSL,Sizeof(TSL));

        Result:=BOff;

        KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+Full_MLocLKey(lc,sc);

        KeyS:=KeyChk;

        TmpKPath:=GetPosKey;

        Begin
          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          TmpStat:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

          If (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
          Begin
            Result:=BOn;
            TSL:=LMLocCtrl^.MStkLoc;
          end;

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

          LMLocCtrl^:=TmpMLoc;

        end; {With..}

      end;


        { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocFullSubst(Var StockR  :  StockRec;
                                                      Lc      :  Str10;
                                                      Mode    :  Byte);
      Var
        TSL     :  MStkLocType;
        n       :  Byte;
        FoundOk :  Boolean;



      Begin
        If (Syss.UseMLoc) and (Not EmptyKey(lc,MLocKeyLen)) and (Not EmptyKey(StockR.StockCode,StkKeyLen)) then
        With StockR,TSL do
        Begin

          FoundOk:=LLinkMLoc_Stock(Lc,StockCode,TSL);


          Case Mode of
            0  :  Begin
                    QtyInStock:=lsQtyInStock;
                    QtyAllocated:=lsQtyAlloc;
                    QtyOnOrder:=lsQtyOnOrder;
                    QtyPosted:=lsQtyPosted;
                    QtyPicked:=lsQtyPicked;

                    QtyAllocWOR:=lsQtyAllocWOR;
                    QtyIssueWOR:=lsQtyIssueWOR;
                    QtyPickWOR:=lsQtyPickWOR;
                    QtyMin:=lsQtyMin;
                    QtyMax:=lsQtyMax;


                    QtyReturn:=lsQtyReturn;
                    QtyPReturn:=lsQtyPReturn;

                  end;
            1  :  Begin
                    {If (lsQtyMin<>0) then}
                      QtyMin:=lsQtyMin;

                    {If (lsQtyMax<>0) then}
                      QtyMax:=lsQtyMax;

                    MinFlg:=lsMinFlg;

                    ROQty:=lsRoQty;

                    RODate:=lsRODate;
                    ROCCDep:=lsROCCDep;

                    If (LLocORPrice(lc)) then
                    Begin
                      ROCPrice:=lsROPrice;
                      ROCurrency:=lsROCurrency;
                    end;


                    ROFlg:=lsROFlg;
                  end;
            2  :  Begin
                    QtyTake:=lsQtyTake;

                    QtyFreeze:=lsQtyFreeze;
                    StkFlg:=lsStkFlg;
                  end;

            3  :  If (FoundOk) and (LLocOPrice(lc)) then
                    SaleBands:=lsSaleBands;

            4  :  If (FoundOk) and (LLocONom(lc)) then
                  Begin
                    For n:=1 to NofSNoms do
                      NomCodes[n]:=lsDefNom[n];

                      
                    WOPWIPGL:=lsWOPWIPGL;

                    ReturnGL:=lsReturnGL;
                    PReturnGL:=lsPReturnGL;
                  end;

            5  :  If (FoundOk) and (LLocOCPrice(lc)) then
                  Begin
                    PCurrency:=lsPCurrency;
                    CostPrice:=lsCostPrice;
                  end;
            6  :  If (FoundOk) and (LLocOCCDep(lc)) then
                    CCDep:=lsCCDep;

            7  :  If (FoundOk) then
                    BinLoc:=lsBinLoc;

            8  :  If (FoundOk) and (LLocORPrice(lc)) then
                  Begin
                    ROCurrency:=lsROCurrency;
                    ROCPrice:=lsROPrice;
                  end;

          end; {Case..}
        end;


      end;


       { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocSubst(Var StockR  :  StockRec;
                                                  Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,0);

      end;

        { ==== Procedure to Substitute Stock levels for location levels ==== }
      { Duplicated in ExBtTh1U, TdexPost}

      Procedure tdPostExLocal.LStock_LocROSubst(Var StockR  :  StockRec;
                                                    Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,1);

      end;


      { ==== Procedure to Substitute Stock levels for location levels ==== }
      { Duplicated in ExBtTh1U, TdexPost}

      Procedure tdPostExLocal.LStock_LocROCPSubst(Var StockR  :  StockRec;
                                                      Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,8);

      end;

        { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocTKSubst(Var StockR  :  StockRec;
                                                   Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,2);

      end;

        { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocPSubst(Var StockR  :  StockRec;
                                                  Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,3);

      end;


      { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocCSubst(Var StockR  :  StockRec;
                                                   Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,5);

      end;

        { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocNSubst(Var StockR  :  StockRec;
                                                  Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,4);

      end;


      { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocLinkSubst(Var StockR  :  StockRec;
                                                      Lc      :  Str10);

      Var
        n  :  Byte;

      Begin
        For n:=4 to 8 do {* Set Cost Price, Re-Order Price, Nominal Codes *}
          If (n In [4..6,8]) then
            LStock_LocFullSubst(StockR,Lc,n);
      end;

      { ==== Procedure to Substitute Stock levels for location levels ==== }

      Procedure tdPostExLocal.LStock_LocRep1Subst(Var StockR  :  StockRec;
                                                      Lc      :  Str10);

      Var
        n  :  Byte;

      Begin
        For n:=0 to 7 do {* Set Cost Price, Re-Order Price, Nominal Codes *}
                         {&v5.60 mode 4 for nom codes added for location filter stock valuation to
                            pick up location nomcodes instead *} 
          If (n In [0,1,4,5,7]) then
            LStock_LocFullSubst(StockR,Lc,n);
      end;


      Procedure tdPostExLocal.LStock_LocBinSubst(Var StockR  :  StockRec;
                                                     Lc      :  Str10);


      Begin
        LStock_LocFullSubst(StockR,Lc,7);

      end;

       { ============ Proc to fill in StkLoc records for each location ========= }


      Procedure tdPostExLocal.LUpdate_LocROTake(StockR  :  StockRec;
                                                lc      :  Str10;
                                                Mode    :  Byte);

      Const
        Fnum      =  MLocF;
        Keypath   =  MLSecK;


      Var
        KeyChk     :  Str255;

        FoundStr   :  Str10;

        LAddr      :  LongInt;
        OStat      :  Integer;

        LOk,
        Locked,
        NewRec     :  Boolean;

        TLocLoc    :  MLocLocType;

      Begin

        Begin
          OStat:=LStatus;

          FoundStr:='';

          KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+Full_MLocLKey(lc,StockR.StockCode);

          LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

          NewRec:=(LStatus=4);


          Locked:=BOff;

          If ((LStatusOk) or (NewRec))  then
          Begin
            If (NewRec) then
            With LMLocCtrl^,MStkLoc do
            Begin
              LGetMainRec(MLocF,Quick_MLKey(lc));

              TLocLoc:=MLocLoc;

              LOk:=BOn;
              Locked:=BOn;

              LResetRec(Fnum);

              RecPFix:=CostCCode;

              SubType:=CSubCode[BOff];

              lsLocCode:=lc;

              SetROConsts(StockR,MStkLoc,TLocLoc);

            end
            else
              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked);

            If (LOk) and (Locked) then
            Begin
              If (Not NewRec) then
                LGetRecAddr(Fnum);

              Case Mode of
                0  :  SetROUpdate(StockR,LMLocCtrl^.MStkLoc);
                1  :  SetTakeUpdate(StockR,LMLocCtrl^.MStkLoc);
              end; {Case..}

              If (NewRec) then
                LStatus:=LAdd_Rec(Fnum,KeyPath)
              else
              Begin
                LStatus:=LPut_Rec(Fnum,KeyPath);

                If (LStatusOk) then
                  LStatus:=LUnLockMLock(Fnum);

              end;

              LReport_BError(Fnum,LStatus);
            end; {If Locked Ok..}

          end; {If found/ new record}

          LStatus:=OStat;
        end; {With..}
      end;
     {$ENDIF}
   {$ENDIF}
   {$ENDIF}
   {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}


{Functions to override the VAT Ctrl Account when posting NOMS}


Function tdPostExLocal.VATSalesMode(SalesOn  :  Boolean;
                                    VT       :  VATType)  :  Boolean;

Begin
  With LInv do
  Begin
    If (InvDocHed=NMT) then
    Begin
      If (NOMVATIO=IOVATCh[BOff]) or (NOMVATIO=IOVATCh[BOn]) then
        Result:=(NOMVATIO=IOVATCh[BOn])
      else
        Result:=SalesOn;
    end
    {$IFDEF EX603}
      else
        If (InvDocHed In PurchSplit) and (SyssVat^.VATRates.VAT[VT].Code=SyssCIS.CISRates.RCTRCV1)
         and (CurrentCountry=IECCode)  and (SyssCIS.CISRates.RCTUseRCV) and (VT<>Spare8) then
        Begin
          Result:=BOn;
        end
    {$ENDIF}
    else
      Result:=SalesOn;

  end;
end; {Proc..}



{IFDEF OLE}
{$IF Defined(OLE) Or Defined(COMTK)}

  { Total_Profit_To_Date modified for the Job Costing Budget Quantities }
  Function tdPostExLocal.LTotal_QtProfit_To_Date(NType        :  Char;
                                                 NCode        :  Str20;
                                                 PCr,PYr,PPr  :  Byte;
                                             Var Purch,PSales,
                                                 PCleared,
                                                 PBudget,
                                                 PRBudget     :  Double;
                                             Var Qty1, Qty2   :  Double;
                                                 Range        :  Boolean)  :  Double;


  Const
    Fnum  =  NHistF;
    NPath =  NHK;



  Var
    NHKey,NHChk,
    NHKey2       :  Str255;
    Bal          :  Real;



  Begin
    Purch:=0; PSales:=0; PCleared:=0;  PBudget:=0; Bal:=0; PRBudget:=0;
    Qty1:=0.0; Qty2:=0.0;

    NHChK:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

    If (Range) then
      NHKey:=FullNHistKey(NType,NCode,PCr,PYr-1,YTD)
    else
      NHKey:=NHChk;

    If (NType In YTDSet+[NomHedCode,CustHistCde,CustHistPCde]) and (Range) then  {** Get Last Valid YTD **}
    Begin
      NHKey2:=NHKey;
      LStatus:=LFind_Rec(B_GetLessEq,Fnum,NPath,NHKey2);

      If (LStatusOk) and (CheckKey(NHChk,NHKey2,Length(NHChk)-2,BOn)) and (LNHist.Pr=YTD) then
        NHKey:=NHKey2;
    end;


    LStatus:=LFind_Rec(B_GetGEq,Fnum,NPath,NHKey);


    While (LStatusOK) and (NHKey<=NHChk) do
    With LNHist do
    Begin

      If ((NType<>CustHistCde) or (Not (Pr In [YTD,YTDNCF]))) then
      Begin
        Purch:=Purch+Purchases;
        PSales:=PSales+Sales;
      end;

      Bal:=Bal+(Purchases-Sales);

      PCleared:=PCleared+Cleared;

      If (Not (Pr In [YTD,YTDNCF])) then
      Begin
        PBudget:=PBudget+Budget;

        PRBudget:=PRBudget+RevisedBudget1;
      end;

      Qty1:=Qty1+Value1;
      Qty2:=Qty2+Value2;

      LStatus:=LFind_Rec(B_GetNext,Fnum,NPath,NHKey);
    end;


    Result:=Bal;

  end; {Func..}

{$IFEND}



{$IFDEF OLE}
 {$DEFINE LocJC}
{$ENDIF}
{$IFDEF JC}
 {$DEFINE LocJC}
{$ENDIF}

{$IFDEF LocJC}


    { ====== Func to Get on cost markup information ====== }


  Function tdPostExLocal.LGet_BudgMUp(JCode,
                                      ACode    :  Str10;
                                      SCode    :  Str20;
                                      Curr     :  Byte;
                                  Var Charge,
                                      CostUp   :  Double;
                                      Mode     :  Byte)  :  Boolean;

  Const
    Fnum     =  JCtrlF;
    Keypath  =  JCK;



  Var
    KeyS,
    KeyChk   :  Str255;


    FoundOk,
    AllowChrge,
    Loop     :  Boolean;

    HistPFix :  Char;

    NomBal,
    Purch,
    Sales,
    Cleared,
    Bud1,
    Bud2,
    Rnum,

    Dnum,
    Dnum2    :  Double;


  Begin

    If (Mode=1) then
    Begin
      Charge:=0.0;

      CostUp:=0.0;
    end;

    AllowChrge:=BOn;

    Loop:=BOff;

    KeyChk:=PartCCKey(JBRCode,JBSCode)+FullJBCode(JCode,0,SCode);

    Begin

      Repeat

        KeyS:=KeyChk;

        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

        FoundOk:=((LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk)-1,BOn)));

        If (FoundOk) then
        Begin


          Case Mode of

            1  :  Begin

                    AllowChrge:=LJobCtrl^.JobBudg.ReCharge;

                    With LJobCtrl^.JobBudg do
                      If ((FoundOk) and (AllowChrge)) then
                        Charge:=OverCost;

                    If (FoundOk) then
                      CostUp:=LJobCtrl^.JobBudg.JBUpliftP;


                  end;

            2,3
               :  With LJobCtrl^.JobBudg do
                  Begin

                    If (Mode=3) then
                      HistPFix:=CommitHCode
                    else
                      HistPFix:=LJobRec^.JobType;

                    If (SyssJob^.JobSetUp.PeriodBud) then {* Set Budget from History *}
                    Begin
                      NomBal:=LTotal_Profit_To_Date(HistPFix,FullJDHistKey(JCode,HistFolio),0,
                                             GetLocalPr(0).CYr,GetLocalPr(0).CPr,Purch,Sales,Cleared,
                                             Bud1,Bud2,Dnum,Dnum2,BOn);

                      If (Bud2=0.0) and (Bud1<>0.0) then
                        Bud2:=Bud1;

                      AllowChrge:=(((NomBal+Charge)<Bud2) or (Bud2=0) or (Not Syss.WarnJC));
                    end
                    else
                    Begin
                      NomBal:=LProfit_To_Date(HistPFix,FullJDHistKey(JCode,HistFolio),0,
                                             GetLocalPr(0).CYr,GetLocalPr(0).CPr,Purch,Sales,Cleared,BOn);

                      If (BrValue=0.0) and (BOValue<>0.0) then
                        BrValue:=BOValue;

                      AllowChrge:=(((NomBal+Charge)<BrValue) or (BrValue=0) or (Not Syss.WarnJC));
                    end;



                  end;




          end; {Case..}

        end; {If match found..}

        KeyChk:=PartCCKey(JBRCode,JBBCode)+FullJBCode(JCode,0,ACode);

        Loop:=Not Loop;

      Until (Not Loop) or ((FoundOk) and (AllowChrge)) or ((FoundOk) and (Mode<>1));

    end; {With..}

    LGet_BudgMUp:=AllowChrge;

  end; {Func..}




{$ENDIF}


{ == TEXSThread methods Dummy wrapper to enable Threadsafe COM Hooks == }

Procedure TEXSThread.StartCOM;

Begin
  COMRunning:=BOff;
  
  {$IFDEF CU}

     {$IFDEF COMCU}
        If COMCustomisationEnabled and (ActiveCOMClients) then
        Begin
          CoInitialize(nil);
          COMRunning:=BOn;
        end;
      {$ENDIF}


   {$ENDIF}

end;


Procedure TEXSThread.StopCOM;

Begin
  {$IFDEF CU}

     {$IFDEF COMCU}
        If (COMRunning) then
          CoUnInitialize;

      {$ENDIF}


   {$ENDIF}

end;


Procedure TEXSThread.RunSync(Method  :  TThreadMethod);

Begin
  Synchronize(Method);
end;



{ ========== TThreadQueue methods =========== }

Constructor TThreadQueue.Create(AOwner  :  TObject);

Begin
  {Inherited Create;}
  fMyOwner:=AOwner;

  UsingEmulatorFiles := True;

  //SS:22/05/2017:2017-R1:ABSEXCH-18700:add indicator during MSSQL posting.
  FShowProgressBar := False;

  // CJS 2011-08-03 ABSEXCH-11019 - Stock Valuation access violation
  // Added try..except to catch possible errors when called from other areas
  // (the Stock Valuation error has been fixed in RevalueU.pas).
  try
    If (fMyOwner is TForm) then
      fOwnHandle:=TForm(fMyOwner).Handle
    else
      fOwnHandle:=0;
  except
    on Exception do
      FOwnHandle := 0;
  end;

  fTQNo:=0;
  fCanAbort:=BOn;
  fOwnMT:=BOff;

  fSetPriority:=BOff;

  fPriority:=tpLower;
  fShowModal:=BOff;
  fPrintJob:=BOff;

  ThreadRec:=nil;
  MTExLocal:=nil;

  TQThreadObj:=Nil;

  FLocalFilesOpen := False;
  {$IFDEF CU}
     ThreadCustomEvent:=nil;


  {$ENDIF}

end;

Destructor TThreadQueue.Destroy;

Begin
  If (Assigned(MTExLocal)) and (fOwnMT) then
    Dispose(MTExLocal,Destroy);

  {$IFDEF CU}
     If (Assigned(ThreadCustomEvent)) then
     Begin
       Try
        ThreadCustomEvent.Free;
       finally
         ThreadCustomEvent:=nil;

       end; {Try..}
     end;

  {$ENDIF}

  {Inherited Destroy;}
end;



Procedure TThreadQueue.Process;
Begin
  FCancelled := False;
  {$IFDEF EXSQL}
  if SQLUtils.UsingSQL And UsingEmulatorFiles then
  begin
    if not ReOpen_LocalThreadFiles then
    begin
      ThreadRec^.THAbort := True;
      ThreadRec^.THShowAbort := True;
    end;
  end;
  {$ENDIF}
  InMainThread:=BOn;

  InitStatusMemo(4);

  {Overridable method}

end;


Procedure TThreadQueue.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    If (fOwnHandle<>0) then
      MessResult:=SendMEssage(fOwnHandle,Msg,WParam,LParam);

end; {Proc..}


{* Base Object is called by ForceTerminateStatus in ExThredU when an thread is aborted, however this is just called once
   as soon as abort has been confirmed, and does not wait until the thread has actualy finished... *}

Procedure TThreadQueue.BaseObjFinish;
Begin
  Send_UpDateList(74);

end;


Procedure TThreadQueue.Finish;
Begin
  BaseObjFinish;

  {Overridable method}
  InMainThread:=BOff;
end;

Procedure TThreadQueue.AbortFromStart;
Begin

  {Overridable method}

end;


Procedure TThreadQueue.InitStatusMemo(Lno  :  Integer);

Var
  n  :  Integer;

Begin
  If (Assigned(ThreadRec)) then
  With ThreadRec^,MLines do
  Begin
    Clear;

    For n:=1 to Lno do
      Add(' ');

    
  end;
end;



Procedure TThreadQueue.ShowStatus(Lno   :  Integer;
                                  LText :  ShortString);

Begin
  //PR: Added critical section in attempt to cure OTC hang
  StatusLock.Enter;
  Try
    If (Assigned(ThreadRec)) then
    With ThreadRec^,MLines do
    Begin
      Strings[Lno]:=LText;

      Inc(THUpStr);
    end;
  Finally
    StatusLock.Leave;
  End;
end;


Procedure TThreadQueue.InitProgress(Max  :  Integer);

Begin
  If (Assigned(ThreadRec)) then
  With ThreadRec^ do
  Begin
    If (Max>=0) then
      PTotal:=Max
    else
      PTotal:=0;
  end;
end;


Procedure TThreadQueue.UpdateProgress(Max  :  Integer);

Begin
  If (Assigned(ThreadRec)) then
  With ThreadRec^ do
  Begin

    If (Max>=0) then
      PCount:=Max
    else
      PCount:=0;

    Inc(THUpBar);
  end
  // CJS 2014-11: Order Payments - Phase 5 - VAT Return
  else if Assigned(FOnUpdateProgress) then
    FOnUpdateProgress(Max, FCancelled);
end;


{$IFDEF CU}

   Function TThreadQueue.LHaveHookEvent(WID,EID  :  Integer;
                                    Var NewObject:  Boolean)  :  Boolean;

   Begin
     NewObject:=BOff;  Result:=BOff;

     If (Not Assigned(ThreadCustomEvent)) then
     Begin
       ThreadCustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);
       NewObject:=BOn;
     end;


     try
       With ThreadCustomEvent do
       Begin
         If (Not NewObject) then
         Begin
           {v5.00.003. Call to new method SetEventIDs so that both EntsysObj and the local WID & HID are set at the same time}

           SetEventIDs(EnterpriseBase+WId,EId);

           {EntSysObj.WinId:=EnterpriseBase+WId; EntSysObj.HandlerId:=EID;}

         end
         else
         Begin
           {v5.00.003. Moved into LBuildHookEvent as it seemed inefficient to create this here when just checking for the event being enabled *}
           {EntSysObj := TEnterpriseSystem.Create(EnterpriseBase+WId, EId);}


         end;


         Result:=GotEvent;
       end;

     except
       ThreadCustomEvent.Free;
       ThreadCustomEvent:=nil;
       Result:=BOff;
     end;
   end; {Function..}



   Procedure TThreadQueue.LBuildHookEvent(WID,EID  :  Integer;
                                      Var ExLocal  :  TdExLocal);
   Var
     NewObject    :  Boolean;

   Begin
     NewObject:=BOff;



     If (LHaveHookEvent(WID,EID,NewObject)) then
     Begin
       try
         With ThreadCustomEvent do
         Begin
           {v5.00.003 Check if EntSysObj assigned, and create if necessary}

           If (Not Assigned(EntSysObj)) then
             EntSysObj := TEnterpriseSystem.Create(EnterpriseBase+WId, EId);

           EntSysObj.AssignExLocal(ExLocal);

           EntSysObj.StrResult:=ExLocal.LCtrlStr;

           {$IFDEF COMCU}
             If COMCustomisationEnabled and (Assigned(TQThreadObj)) then
             begin{* Do not need this in v4.30b*}
               // HM 09/03/00: Removed during development of thread-safe COM Customisation
               //TQThreadObj.RunSync(Execute)

               // Check for a COM Hook
               If CustomHandlers.GotCOMHandler (EnterpriseBase+WId, EId) Then
               Begin
                 // Set Thread Index number -
                 ThreadIdx := fTQNo; { <== EL Set this by thread number }

                 // Marshal clients for cross-process use
                 TQThreadObj.RunSync(MarshalCOMClients);

                 // execute hook
                 ThreadExecute;
               End { If CustomHandlers.GotCOMHandler (WId, EId) }
               Else
                 { No COM Clients on this event - don't bother with marshalling - just do it! }
                 Execute;
             End { If }
             Else
           {$ENDIF}
               Execute;

           If ValidStatus and (DataChanged or (WID=(MiscBase+1))) then
           Begin
             

             Case ((WId * 1000) + EId) Of
               2000080  :  Begin { Override Period relative to Date function }
                            ExLocal.LInv.AcYr:=EntSysObj.Transaction.thYear;
                            ExLocal.LInv.AcPr:=EntSysObj.Transaction.thPeriod;
                          End;

               2000081  :  Begin { Override Period relative to Date function }
                             ExLocal.LInv.TransDate:=EntSysObj.Transaction.thTransDate;
                           End;


               2050100,
               2050101  :  Begin { Override Period relative to Date function }
                             ExLocal.LId.Desc:=EntSysObj.Transaction.thLines.thCurrentLine.tlDescr;
                           End;

               4000100  :  Begin { Override Line CC/Dep Codes} {*EL v6.01 Custom CC/Dep Overide Hook  *}
                             ExLocal.LId.CCDep[BOff]:=EntSysObj.Transaction.thLines.thCurrentLine.tlDepartment;
                             ExLocal.LId.CCDep[BOn]:=EntSysObj.Transaction.thLines.thCurrentLine.tlCostCentre;
                           End;
               5000080  :  Begin { Override Line G/L Code }
                             ExLocal.LId.NomCode:=EntSysObj.Transaction.thLines.thCurrentLine.tlGLCode;
                           End;

               5000100..5000103
                        :  Begin
                             If (EId=100) then
                               ExLocal.LId.CXrate[BOn]:=EntSysObj.Transaction.thLines.thCurrentLine.tlDailyRate;

                             ExLocal.LId.LineUser1:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef1;
                             ExLocal.LId.LineUser2:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef2;
                             ExLocal.LId.LineUser3:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef3;
                             ExLocal.LId.LineUser4:=EntSysObj.Transaction.thLines.thCurrentLine.tlUserDef4;
                             //GS 14/10/2011 ABSEXCH-11706: Added code to write to the 6 new user defined fields
                             ExLocal.LId.LineUser5:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef5;
                             ExLocal.LId.LineUser6:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef6;
                             ExLocal.LId.LineUser7:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef7;
                             ExLocal.LId.LineUser8:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef8;
                             ExLocal.LId.LineUser9:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef9;
                             ExLocal.LId.LineUser10:=TAbsInvLine9(EntSysObj.Transaction3.thLines.thCurrentLine).tlUserDef10;
                           end;

               90001002..90001004
                        :  Begin { Return suggested VAT postdate/ equivalent period date }
                             ExLocal.LCtrlStr:=EntSysObj.StrResult;
                           End;



             end; {Case..}
           end;
         end;

       except
         ThreadCustomEvent.Free;
         ThreadCustomEvent:=nil;

       end;
     end; {MTExLocal not ready..}

   end;


   Function TThreadQueue.LExecuteHookEvent(WID,EID  :  Integer;
                                        Var ExLocal  :  TdExLocal)  :  Boolean;
   Var
     NewObject    :  Boolean;

   Begin
     Result:=BOff;

     NewObject:=BOff;

     LBuildHookEvent(WID,EID,ExLocal);

     If (Assigned(ThreadCustomEvent))  then
     try
       With ThreadCustomEvent do
       If (Assigned(EntSysObj)) then
       Begin
         Result:=EntSysObj.BoResult;

         Case ((WId * 1000) + EId) Of
           2000104  :  If (Result) then
                         ExLocal.LCtrlStr:=EntSysObj.StrResult;

           4000051  :  Begin
                            Result:=(EntSysObj.BoResult);

                            If (Result) then
                              ExLocal.LId.NomCode:=EntSysObj.TransAction.thLines.thCurrentLine.tlGLCode;
                          end;

           4000052  :  Begin
                         ExLocal.LCtrlInt:=EntSysObj.IntResult;
                         Result:=BOn;
                       end;
           4000085,
           4000086  :  Begin
                         If (Result) then
                           ExLocal.LCtrlInt:=EntSysObj.IntResult;
                       end;
         end; {Case..}

       end;

     except
       ThreadCustomEvent.Free;
       ThreadCustomEvent:=nil;

     end;

   end;


{$ENDIF}

{= Replicated from Event1U =}

Procedure TThreadQueue.LDate2Pr(CDate  :  LongDate;
                            Var PPr,PYr:  Byte;
                                ExLPtr :  Pointer);


Var
  ExLocal    :  ^TdExLocal;


Begin
  {$IFDEF CU}
    If (Assigned(ExLPtr)) then
      ExLocal:=ExLPtr
    else
    Begin
      New(ExLocal,Create);

      try

        With ExLocal^,LInv do
        Begin
          FolioNum:=-1;
        end;

      except
        Dispose(ExLocal,Destroy);
        ExLocal:=nil;

      end;
    end;

  {$ELSE}
    ExLocal:=nil;
  {$ENDIF}


  SimpleDate2Pr(CDate,PPr,PYr);

  {$IFDEF CU}
     If (Assigned(ExLocal)) then
     With ExLocal^ do
     Begin
       LInv.AcYr:=PYr;
       LInv.AcPr:=PPr;
       LInv.TransDate:=CDate;

       LBuildHookEvent(2000,80,ExLocal^);

       PYr:=LInv.AcYr;
       PPr:=LInv.AcPr;

       If (Not Assigned(ExLPtr)) then
         Dispose(ExLocal,Destroy);
     end;
  {$ENDIF}

end;


{ =========== Function to Calculate the Date from the period ========= }
{= Replicated from Event1U =}

Function TThreadQueue.LPr2Date(PPr,PYr  :  Byte;
                               ExLPtr   :  Pointer)  :  LongDate;


Var
  ExLocal    :  ^TdExLocal;


Begin
  {$IFDEF CU}
    If (Assigned(ExLPtr)) then
      ExLocal:=ExLPtr
    else
    Begin
      New(ExLocal,Create);

      try

        With ExLocal^,LInv do
        Begin
          FolioNum:=-1;
        end;

      except
        Dispose(ExLocal,Destroy);
        ExLocal:=nil;

      end;
    end;

  {$ELSE}
    ExLocal:=nil;
  {$ENDIF}

  Result:=SimplePr2Date(PPr,PYr);

  {$IFDEF CU}
     If (Assigned(ExLocal)) then
     With ExLocal^ do
     Begin
       LInv.AcYr:=PYr;
       LInv.AcPr:=PPr;
       LInv.TransDate:=Result;

       LBuildHookEvent(2000,81,ExLocal^);

       Result:=LInv.TransDate;


       If (Not Assigned(ExLPtr)) then {* We must have created a local copy*}
         Dispose(ExLocal,Destroy);
     end;
  {$ENDIF}

end; {Func..}


  { *Evalu =================== Calculate Line VAT ============== See BatchLnU also using CalcVAT and MiscU }

  {$IFNDEF OLE}
  Procedure TThreadQueue.LCalcThVAT(Var  IdR        :  IDetail;
                                         SetlDisc   :  Double;
                                    Var  ExLocal    :  TdExLocal);


  Var
    NCO,
    VS,DC,
    UseCV        :  Boolean;



  Begin
    VS:=BOff; DC:=BOff;  NCO:=BOff; UseCV:=BOn;

    {$IFDEF CU}

      If (LHaveHookEvent(MiscBase+1,1,NCO)) then
      Begin
        ExLocal.LId:=IdR;

        LBuildHookEvent(MiscBase+1,1,ExLocal);

        If (Assigned(ThreadCustomEvent)) then
        With ThreadCustomEvent do
        Begin
          UseCV:=BOff;

          Try
            VS:=ValidStatus;
            DC:=DataChanged;

            If (VS and DC) then
            With ExLocal, EntSysObj.Transaction.thLines.thCurrentLine do
            Begin
              // HM 06/10/00: If any additional fields are returned then
              // Ex_CalcLineTax in the Toolkit DLL/COM Toolkit should
              // also be updated.

              If (tlVATCode In VATSet) then
                LId.VATCode:=tlVATCode;

              LId.VAT:=tlVATAmount;
              LId.NetValue:=tlNetValue;

              // HM 06/10/00: See comment above

              IdR:=LId;
            end;

          Except
            ThreadCustomEvent.Free;
            ThreadCustomEvent:=Nil;
          end; {try.}
        end;{With..  .}
      end;
    {$ENDIF}

    If (UseCV) then
      With ExLocal do
        CalcVAT(LId,LInv.DiscSetl);
  end; {Proc..}

 Function TThreadQueue.LSetVATPostDate(ExLocal    :  TdExLocal;
                                       EId        :  Byte;
                                       InpStr     :  Str255)  :  Str255;


Var
  NCO,
  UseCV        :  Boolean;



Begin
  UseCV:=BOn; NCO:=BOff;

  {$IFDEF CU}

    If (LHaveHookEvent(MiscBase+1,EId,NCO)) then
    Begin
      ExLocal.LCtrlStr:=InpStr;

      LBuildHookEvent(MiscBase+1,EId,ExLocal);

      If (Assigned(ThreadCustomEvent)) then
      With ThreadCustomEvent do
      Begin
        UseCV:=BOff;

        Try

          If (ValidStatus) then
          With ExLocal do
          Begin
            Result:=LCtrlStr;
          end;

        Except
          ThreadCustomEvent.Free;
          ThreadCustomEvent:=Nil;
        end; {try.}
      end;{With..  .}
    end;
  {$ENDIF}

  If (UseCV) then
    With ExLocal do
    Case EId of
      2..3  :  Result:=CalcVATDate(LInv.TransDate);
      4     :  Result:='';
    end; {Case..}
end; {Proc..}


  {$ENDIF}

{ ======== }

Function Create_ThreadFiles  :  Boolean;

Begin
  Result:=BOff;

  New(PostExLocal);

  With PostExLocal^ do
  Begin
    try
      Create(02);

      Open_System(1,TotFiles);

      Result:=BOn;
    except
      PostExLocal:=nil;
      ShowMessage('Unable to create Posting Routines Btrieve thread 02.');

      Result:=BOff;
    end; {try..}

  end;

end;


Function Create_LiveCommitFiles  :  Boolean;

Begin
  Result:=BOff;

  New(LCommitExLocal);

  With LCommitExLocal^ do
  Begin
    try
      Create(25);

      Open_System(1,TotFiles);

      Result:=BOn;
    except
      PostExLocal:=nil;
      ShowMessage('Unable to create Live Commitment Btrieve thread 25.');

      Result:=BOff;
    end; {try..}

  end;

end;



Function Create_ReportFiles  :  Boolean;

Begin
  Result:=BOff;

  New(RepExLocal);

  With RepExLocal^ do
  Begin
    try
      Create(14);

      {$IFDEF RW}
        Open_System ( 1, 15);
        Open_System (DictF, RepGenF);
      {$ELSE}
        Open_System(1,TotFiles);
      {$ENDIF}

      Result:=BOn;
    except
      RepExLocal:=nil;
      ShowMessage('Unable to create Report Btrieve thread 14.');

      Result:=BOff;
    end; {try..}

  end;

end;


Function Create_LiveCSFiles  :  Boolean;

Begin
  Result:=BOff;

  New(LCSExLocal);

  With LCSExLocal^ do
  Begin
    try
      Create(15);

      Open_System(CustF,InvF);

      Result:=BOn;
    except
      LCSExLocal:=nil;
      ShowMessage('Unable to create Report Btrieve thread 15.');

      Result:=BOff;
    end; {try..}

  end;

end;


Procedure Destroy_ThreadFiles;

Begin
  If (Assigned(PostExLocal)) then
  Begin
    Dispose(PostExLocal,Destroy);
    PostExLocal:=nil;
  end;

  If (Assigned(RepExLocal)) then
  Begin
    Dispose(RepExLocal,Destroy);
    RepExLocal:=nil;
  end;

  If (Assigned(LCSExLocal)) then
  Begin
    Dispose(LCSExLocal,Destroy);
    LCSExLocal:=nil;
  end;

  If (Assigned(LCommitExLocal)) then
  Begin
    Dispose(LCommitExLocal,Destroy);
    LCommitExLocal:=nil;
  end;

end;

{$IFDEF EXSQL}
// CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
function TThreadQueue.Create_LocalThreadFiles (Const OpenDataFiles : Boolean = True) : Boolean;
var
  ClientID: Integer;
begin
  Result := BOff;

  New(LPostLocal);

  with LPostLocal^ do
  begin
    try
      ClientIdsLock.Enter;
      Try
        ClientId := ClientIds.OpenBit;
        ClientIds[ClientId] := True;
        FHasClientBit := True;
      Finally
        ClientIdsLock.Leave;
      End;

      Create(ClientId + 500);

      If OpenDataFiles And UsingEmulatorFiles Then
        Open_System(1,TotFiles);

      Result := BOn;

      //PR Make sure ThreadQueue doesn't try to destroy MTExLocal after destroying LPostLocal - they point to the same object.
      fOwnMT := False;

      if Result then
        OutputDebugString(PChar('Create_LocalThreadFiles. ClientID = ' + IntToStr(ExClientID^.TaskID) + ' (' + IntToStr(Integer(@ExClientID)) + ')'+ '. ThreadID = ' + IntToStr(GetCurrentThreadID)));
    except
      LPostLocal := nil;
//      ShowMessage('Unable to create Posting Routines Btrieve thread 02.');
      Result := BOff;
    end; {try..}
  end;

end;

function TThreadQueue.ReOpen_LocalThreadfiles: Boolean;
begin
  if FLocalFilesOpen then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  if Assigned(MTExLocal) then
  begin
    Try
      OutputDebugString(PChar('ReOpen_LocalThreadFiles. ClientID = ' + IntToStr(MTExLocal.ExClientID^.TaskID) + '. ThreadID = ' + IntToStr(GetCurrentThreadID)));
      MTExLocal^.Open_System(1, TotFiles);
      FLocalFilesOpen := True;
      Result := True;
    Except
      MTExLocal := nil;
    End;
  end;
end;

procedure TThreadQueue.Reset_LocalThreadFiles;
begin
  if SQLUtils.UsingSQL And UsingEmulatorFiles then
  begin
    OutputDebugString(PChar('Reset_LocalThreadFiles. ClientID = ' + IntToStr(MTExLocal.ExClientID^.TaskID) +  '. ThreadID = ' + IntToStr(GetCurrentThreadID)));
    MTExLocal^.Close_Files;
    FLocalFilesOpen := False;
    CloseClientIdSession(MTExLocal^.ExClientID, False);
    OutputDebugString(PChar('CloseClientSessionID called. ClientID = ' + IntToStr(MTExLocal.ExClientID^.TaskID)  + '. ThreadID = ' + IntToStr(GetCurrentThreadID)));
  end;
end;

procedure TThreadQueue.Reset_ClientBit;
{
  CJS - 07/03/2011: ABSEXCH-9461 - Fix to release ClientID Bit after use.
  Note that this cannot be called from the Destroy of TThreadQueue, as by that
  point the MTExLocal object might already have been destroyed. It has to be
  called from the destructor of descendant classes when required.
}
begin
  if FHasClientBit then
  begin
    ClientIdsLock.Enter;
    try
      if Assigned(MTExLocal) then
        ClientIds[MTExLocal^.ExClientID^.TaskId - 500] := False;
      FHasClientBit := False;
    finally
      ClientIdsLock.Leave;
    end;
  end;
end;

{$ENDIF EXSQL}

function TThreadQueue.LCheck_PayInStatus(var IdR: IDetail): Byte;
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

end;


{$IFNDEF OLE}
{$IFDEF SOP}
function TdPostExLocal.LTransOSValue(InvR: InvRec): Double;
var
  UOR : Byte;
begin
  with InvR do
  begin
    if Syss.IncludeVATInCommittedBalance then
      Result := LTransOSWithVAT(InvR)
    else
    begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      Result := Round_Up(Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
    end;

  end;
end;

function TdPostExLocal.LTransOSWithVATFromLines(InvR: InvRec): Double;
var
  Res  : Integer;
  sKey : Str255;

  KPath : Integer;
  RecAddr : Longint;
begin
  Result := 0;

  //Store position in detail file
  Res := LPresrv_BTPos(IDetailF, KPath, LocalF^[IDetailF], RecAddr, False, False);

  //Iterate through all lines for the transaction, totalling the o/s value including VAT.
  sKey := FullNomKey(InvR.FolioNum);

  Try
    Res := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, sKey);
    while (Res = 0) and (LId.FolioRef = InvR.FolioNum) do
    begin
      //PR: 04/03/2015 ABSEXCH-14782 Changed Id to LId so that we're using the correct record.
      Result := Result + LineOSWithVAT(LId, InvR.DiscSetl);

      Res := LFind_Rec(B_GetNext, IDetailF, IdFolioK, sKey);
    end;
  Finally
    //Restore position in Detail File
    LPresrv_BTPos(IDetailF, KPath, LocalF^[IDetailF], RecAddr, True, False);
  End;
end;

function TdPostExLocal.LTransOSWithVAT(InvR: InvRec): Double;
var
  UOR : Byte;
begin
  //Direct to appropriate function depending upon manual vat flag
  if InvR.ManVAT then
    Result := TransOSWithManualVAT(InvR)
  else
    Result := LTransOSWithVATFromLines(InvR);

    //Convert result to base
    with InvR do
    begin
      UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

      Result := Round_Up(Conv_TCurr(Result,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
    end;
end;
{$ENDIF SOP}
{$ENDIF not OLE}

//PR: 16/04/2014 Order Payments T038 Added LUpdateCustBal procedure
procedure TdPostExLocal.LUpdateCustBal(OI, IR: InvRec);
begin
    With IR do
    Begin
      LUpdateBal(OI,(ConvCurrITotal(OI,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrICost(OI,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrINet(OI,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   BOn,2);

      LUpdateBal(IR,(ConvCurrITotal(IR,BOff,BOn,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrICost(IR,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   (ConvCurrINet(IR,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                   BOff,2);
    end;
end;


Initialization

  PostExLocal:=nil;
  RepExLocal:=nil;
  LCSExLocal:=nil;
  LCommitExLocal:=Nil;

  //PR: Added to help fix OTC problem
  StatusLock := TCriticalSection.Create;

  ClientIds := TBits.Create;
  ClientIds[0] := True; // Don't use 0, start from 1.
  ClientIdsLock := TCriticalSection.Create;

   MainThreadID := GetCurrentThreadID;

   OutputDebugString(PChar('MainThreadID = ' + IntToStr(MainThreadID)));
Finalization

  Destroy_ThreadFiles;

  //PR: Added to help fix OTC problem
  StatusLock.Free;

  FreeAndNil(ClientIds);
  ClientIdsLock.Free;

end.
