unit ExBtTh1u;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VARRec2U,VarConst,BtrvU2,BtSupU1,ExWrap1U,

  {$IFDEF CU}
     CustIntU,

  {$ENDIF}

  SBSComp2;


type


  TdPostExLocalPtr  =  ^TdPostExLocal;

  TdPostExLocal  =  Object(TdMTExLocal)

                      CustLockOn  :  Boolean;

                    Constructor Create(CIdNo  :  SmallInt);

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

                    Procedure LFillBudget(Const  Fnum,
                                                 Keypath  :  Integer;
                                          Var    Mode     :  Byte;
                                                 NKey     :  Str255);

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

                    Function LTotal_Profit_To_Date(NType        :  Char;
                                                   NCode        :  Str20;
                                                   PCr,PYr,PPr  :  Byte;
                                               Var Purch,PSales,
                                                   PCleared,
                                                   PBudget,
                                                   PRBudget     :  Double;
                                               Var BValue1,
                                                   BValue2      :  Double;
                                                   Range        :  Boolean)  :  Double;

                    {$IFDEF OLE}

                    Function LTotal_QtProfit_To_Date(NType        :  Char;
                                                     NCode        :  Str20;
                                                     PCr,PYr,PPr  :  Byte;
                                                 Var Purch,PSales,
                                                     PCleared,
                                                     PBudget,
                                                     PRBudget     :  Double;
                                                 Var Qty1, Qty2   :  Double;
                                                     Range        :  Boolean)  :  Double;

                    {$ENDIF}

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

                    Procedure LRemove_MatchPay(InvR     :  InvRec;
                                               MTyp     :  Char;
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
                        {$ENDIF}
                        {$ENDIF}
                        {$ENDIF}
                      {$ENDIF}
                    {$ENDIF}

                    Procedure LSet_PrintedStatus(ToPrinter,
                                                 AlsoPicked:  Boolean;
                                                 InvR     :  InvRec);

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
                                        Var Charge   :  Double;
                                            Mode     :  Byte)  :  Boolean;



                    {$ENDIF}
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

                       Procedure UpdateProgress(Max  :  Integer;
                                                  s1 : ShortString = '';
                                                  s2 : ShortString = '';
                                                  s3 : ShortString = '';
                                                  s4 : ShortString = '');


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

                   end; {Class..}




Var
  PostExLocal,
  RepExLocal   :  TdPostExLocalPtr;


  Function Create_ThreadFiles  :  Boolean;

  Function Create_ReportFiles  :  Boolean;

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

  BTSFrmU1;


{ ============== TdMTExLocal Methods ============== }

Constructor TdPostExLocal.Create(CIdNo  :  SmallInt);

Begin

  Inherited Create(CIdNo);

  CustLockOn:=BOff;

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


  CEStatus:=Find_RecCId(B_GetGEq+B_KeyOnly,TmpFn,FileNum,LRecPtr[FileNum]^,KeyPath,KeyS,ExClientId);

  LCheckExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=LPresrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);

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

  Begin
    If (UseReset) then
      LResetAuditHist(Code,KLen)
    else
    Begin

      KeyS:=Code;


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



  { ================== Procedure to Reset all History Records Matching a give Code and after purge year ============= }

  Procedure tdPostExLocal.LResetAuditHist (Code  :  AnyStr;
                                           KLen  :  Integer);
  Const
    Fnum     =  NHistF;
    Keypth   =  NHK;

  Var
    KeyS   :  AnyStr;
    LOk,
    Locked :  Boolean;

    Tries,TryMax,
    LAddr  :  LongInt;



  Begin
    KeyS:=Code;

    Tries:=0; TryMax:=1000;

    LStatus:=Find_RecCId(B_GetGEq,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,Keypth,KeyS,ExClientId);


    While (LStatus=0) and (CheckKey(Code,KeyS,KLen,BOn)) do
    With LNHist do
    Begin

      If (AfterPurge(Yr,0)) then
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

      LStatus:=LFind_Rec(B_GetNext,Fnum,Keypth,KeyS);

    end;
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

        If (NType In [StkStkQCode,StkDLQCode,StkBillQCode]) then  {* This mod necessary,
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


  { ============ Procedure to Create any Blank history records ============ }

Procedure tdPostExLocal.LFillBudget(Const  Fnum,
                                           Keypath  :  Integer;
                                    Var    Mode     :  Byte;
                                           NKey     :  Str255);

Var
  n      :  Byte;

Begin

  Begin

    LResetRec(Fnum);

    Extract_NHistfromNKey(Nkey,LNHist);

    With LNHist do
    For n:=1 to Syss.PrinYr do
      If (Not LCheckExsists(FullNHistKey(ExClass,Code,Cr,Syss.CYr,n),Fnum,KeyPath)) then
        LAdd_NHist(ExClass,Code,Cr,Syss.CYr,n,Fnum,KeyPAth);

    Mode:=4
  end;

end; {Proc..}




  { =============== Procedure to Post Actual History Record =============== }

  Procedure tdPostExLocal.LPost_To_Hist(NType         :  Char;
                                      NCode         :  Str20;
                                      PPurch,PSales,
                                      PCleared
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



  Begin
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
      If (ExClass In StkProdSet+[StkGrpCode,StkDescCode,StkStkQCode,StkBillQCode,CuStkHistCode]) then
        QtyNoDecs:=Syss.NoQtyDec;


      PrevBal:=Purchases-Sales;

      Purchases:=Round_Up(Purchases+Round_Up(PPurch,2),2);

      Sales:=Round_Up(Sales+Round_Up(PSales,2),2);

      Cleared:=Round_Up(Cleared+Round_Up(PCleared,QtyNoDecs),QtyNoDecs);

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

    LReport_BError(Fnum,LStatus);

  end; {Proc..}





  { ================ Recursivley Post to YTD & Future Year to dates ============== }

  Procedure tdPostExLocal.LPost_To_CYTDHist(NType          :  Char;
                                          NCode          :  Str20;
                                          PPurch,PSales,
                                          PCleared       :  Double;
                                          PCr,PYr,PPr    :  Byte);

  Var
    Rnum   :  Double;

  Begin
    Rnum:=0;

    LPost_To_Hist(NType,NCode,PPurch,PSales,PCleared,PCr,PYr,PPr,Rnum);

    If (LLast_YTD(NType,NCode,PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
      LPost_To_CYTDHist(NType,NCode,PPurch,PSales,PCleared,PCr,LNHist.Yr,PPr);
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
     Rnum:=LProfit_To_Date(NType,NCode,PCr,PYr,99,Purch,Sales,Cleared,BOn);

     {$B-}
     If ((Purch<>0.0) or (Sales<>0.0) or (Cleared<>0.0)) and (LLast_YTD(NType,NCode,PCr,AdjYr(PYr,BOn),PPr,NHistF,NHK,BOn)) then
     {$B+}
     Begin
       LPost_To_CYTDHist(NType,NCode,Purch,Sales,Cleared,PCr,LNHist.Yr,PPr);
     end;
   end;
 end;



Function tdPostExLocal.LTotal_Profit_To_Date(NType        :  Char;
                                             NCode        :  Str20;
                                             PCr,PYr,PPr  :  Byte;
                                         Var Purch,PSales,
                                             PCleared,
                                             PBudget,
                                             PRBudget     :  Double;
                                         Var BValue1,
                                             BValue2      :  Double;
                                             Range        :  Boolean)  :  Double;


Const
  Fnum  =  NHistF;
  NPath =  NHK;



Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Bal          :  Double;



Begin
  Purch:=0; PSales:=0; PCleared:=0;  PBudget:=0; Bal:=0; PRBudget:=0;

  BValue1:=0.0; BValue2:=0.0;

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

      PRBudget:=PRBudget+Budget2;
    end;

    BValue1:=BValue1+Value1;
    BValue2:=BValue2+Value2;

    LStatus:=LFind_Rec(B_GetNext,Fnum,NPath,NHKey);
  end;


  LTotal_Profit_To_Date:=Bal;

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


Var
  Lcnt  :  LongInt;
  StrLnt:  Str255;


Begin
  LCnt:=0; StrLnt:='';

  Lcnt:=LGetNextCount(DocHed,Increment,BOff,0);

  Str(Lcnt:0,StrLnt);

  LFullDocNum:=DocCodes[DocHed]+SetPadNo(StrLnt,(DocKeyLen-Length(DocCodes[DocHed])));
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

Begin
  With UInv do
  Begin

    Blank(CrDr,Sizeof(CrDr));  PBal:=0;

    StartCode:=CustHistCde;

    FCust:=FullCustCode(CustCode);

    If (Not EmptyKey(FCust,CustKeyLen)) then
    Begin
      { == Get Actual Customer Rec == }

      Locked:=BOn;

      If (CustLockOn) then
        LOk:=BOn
      else
        LOk:=LGetMultiRec(B_GetEq,B_MultLock,FCust,CustCodeK,CustF,BOn,Locked);

      If (LOk) and (Locked) then
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
          For Deduct:=BOff to BOn do
            CrDr[Deduct]:=Round_Up((CrDr[Deduct]*Cnst),2);



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


          If (StartCode=CustHistCde) and (InvDocHed In StkOutSet) then  {* Post to GP Screen *}
          Begin

            LPost_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,AcPr,PBal);

                                                                        {* Post to Non C/F YTD *}
            LPost_To_Hist(CustHistGpCde,FCust,NetAdj,CosAdj,0,0,AcYr,YTDNCF,PBal);

          end;


          StartCode:=CustHistPCde;

          Deduct:=Not Deduct;

        Until (Deduct);

        If (Not CustLockOn) then
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
  If (InvDocHed In PSOPSet) then
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


Procedure tdPostExLocal.LRemove_MatchPay(InvR     :  InvRec;
                                         MTyp     :  Char;
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

Begin

  Fnum      := PWrdF;

  If (RemMatch) then
    KeyPath:=HelpNdxK
  else
    Keypath   := PWK;

  TmpStatus:=LStatus;

  ScanKey:=FullMatchKey(MatchTCode,MatchSCode,InvR.OurRef);

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

    3,5,20
           :  With LPassword do
              With MatchPayRec do
              Begin

                LResetRec(Fnum);

                RecPFix:=MatchTCode;
                SubType:=MatchSCode;

                DocCode:=InvR.OurRef;
                PayRef:=InvR.RemitNo;

                AltRef:=InvR.YourRef;

                SettledVal:=AddT;

                OwnCVal:=AddN;

                MCurrency:=InvR.Currency;

                MatchType:=DocMatchTyp[(Mode=20)];

                LStatus:=LAdd_Rec(Fnum,KeyPath);

                LReport_BError(Fnum,LStatus);

              end;


    4,21
         :  Begin

              LRemove_MatchPay(InvR,DocMatchTyp[(Mode=21)],BOff);

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

  LastModLine,
  BigCount  :  LongInt;

  B_Func    :  Integer;


Begin

  BigCount:=1; LastModLine:=0;

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

        If (LastModLine=LineNo) then {*have we been here before, bypass it *}
          B_Func:=B_GetNext;

        LastModLine:=LineNo;
      end
      else
        B_Func:=B_GetNext;
    {$ENDIF}

    LStatus:=LFind_Rec(B_Func,Fnum,Keypath,KeyS);

  end; {While..}

  If (BigCount>1) then {* Set Next Line to 1 more than largest line, leave if not used yet *}
    BigCount:=Succ(BigCount);

  LCheck_NoteNo:=BigCount;

end; {Func..}
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
                    For n:=1 to NofSNoms do
                      NomCodes[n]:=lsDefNom[n];

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
          If (n In [0,1,5,7]) then
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

          NewRec:=(Status=4);


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


{$IFDEF OLE}
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

        PRBudget:=PRBudget+Budget2;
      end;

      Qty1:=Qty1+Value1;
      Qty2:=Qty2+Value2;

      LStatus:=LFind_Rec(B_GetNext,Fnum,NPath,NHKey);
    end;


    Result:=Bal;

  end; {Func..}
{$ENDIF}



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
                                  Var Charge   :  Double;
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
      Charge:=0.0;

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

                  end;

            2,3
               :  With LJobCtrl^.JobBudg do
                  Begin

                    If (Mode=3) then
                      HistPFix:=CommitHCode
                    else
                      HistPFix:=LJobRec^.JobType;

                    NomBal:=LProfit_To_Date(HistPFix,FullJDHistKey(JCode,HistFolio),0,
                                           Syss.CYr,Syss.CPr,Purch,Sales,Cleared,BOn);


                   AllowChrge:=(((NomBal+Charge)<BrValue) or (BrValue=0) or (Not Syss.WarnJC));

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

  If (fMyOwner is TForm) then
    fOwnHandle:=TForm(fMyOwner).Handle
  else
    fOwnHandle:=0;

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
  If (Assigned(ThreadRec)) then
  With ThreadRec^,MLines do
  Begin
    Strings[Lno]:=LText;

    Inc(THUpStr);
  end;
end;


Procedure TThreadQueue.InitProgress(Max  :  Integer);

Begin
  If (Assigned(ThreadRec)) then
  With ThreadRec^ do
  Begin
    PTotal:=Max;

  end;
end;


Procedure TThreadQueue.UpdateProgress(Max  :  Integer;
                                      s1 : ShortString = '';
                                      s2 : ShortString = '';
                                      s3 : ShortString = '';
                                      s4 : ShortString = '');

Begin
  If (Assigned(ThreadRec)) then
  With ThreadRec^ do
  Begin
    PTotal := 100;
    PCount:=Max;

    Inc(THUpBar);
    Inc(THUpStr);

    MLines.Clear;
    MLines.Add(s1);
    MLines.Add(s2);
    MLines.Add(s3);
    MLines.Add(s4);
  end;
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
           EntSysObj.WinId:=EnterpriseBase+WId; EntSysObj.HandlerId:=EID;

         end
         else
         Begin
           EntSysObj := TEnterpriseSystem.Create(EnterpriseBase+WId, EId);


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
           EntSysObj.AssignExLocal(ExLocal);

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

           If ValidStatus and DataChanged then
           Begin
             Case ((WId * 1000) + EId) Of
               2000080  :  Begin { Override Period relative to Date function }
                            ExLocal.LInv.AcYr:=EntSysObj.Transaction.thYear;
                            ExLocal.LInv.AcPr:=EntSysObj.Transaction.thPeriod;
                          End;

               2000081  :  Begin { Override Period relative to Date function }
                             ExLocal.LInv.TransDate:=EntSysObj.Transaction.thTransDate;
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
   Begin
     Result:=BOff;

     LBuildHookEvent(WID,EID,ExLocal);

     If (Assigned(ThreadCustomEvent)) then
     try
       With ThreadCustomEvent do
       Begin
         Result:=EntSysObj.BoResult;
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

end;


Initialization

  PostExLocal:=nil;
  RepExLocal:=nil

Finalization

  Destroy_ThreadFiles;

end.
