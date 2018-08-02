unit RwWrap1U;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VarConst,BtrvU2,BtSupU1,BTSupU3,
  RwOpenF;


type

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

                  LJobMisc
                         :   JobMiscPtr;

                  LJobRec
                         :   JobRecPtr;

                  LJobCtrl
                         :   JobCtrlPtr;

                  LJobDetl
                         :   JobDetlPtr;

                  LInvNetAnal
                         :    INetAnalType;

                  LInvNetTrig
                         :    IVATAnalType;

                  LRepGen : RepGenPtr;
                  LastRepGen: RepGenPtr;

                  LDict    : DataDictPtr;
                  LastDict : DataDictPtr;

                  LRecPtr
                         :   Array[1..MaxFiles] of RecCPtr;

                  StartNo,
                  EndNo  :  Integer;

                  LastIns,
                  LastEdit,
                  InAddEdit,
                  LViewOnly
                         :  Boolean;
                  LastRecAddr
                         :  Array[1..MaxFiles] of LongInt;


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


               ==}

  TdMTExLocalPtr  =  ^TdMTExLocal;

  TdMTExLocal  =  Object(TdExLocal)

                    LocalF      :  ^FPosBlkType;
                    ExClientId  :  ^ClientIdType;
                    LStatus     :  SmallInt;
                    LWinHandle  :  THandle;
                    LThShowMsg  :  TSBSMsgEvent;
                    LThPrintJob :  TSBSPrintEvent;

                    Constructor Create(CIdNo  :  SmallInt);

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


                    Function LGetMainRec(Fnum  :  SmallInt;
                                         KeyS  :  Str255)  :  Boolean;

                    Procedure LReport_BError(Fnum,ErrNo  :  SmallInt);

                    Procedure LReport_IOError(ErrNo   :  Integer;
                                              Fname   :  Str255);

                    Function LUnLockMLock(Fnum :  SmallInt)  :  SmallInt;


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
  BTSFrmU1;

{ ============== TdExLocal Methods ============== }

Constructor TdExLocal.Create;

Begin

  New(LMiscRecs);
  New(LastMisc);

  New(LRepScr);

  New(LJobMisc);

  New(LJobRec);
  New(LJobCtrl);

  New(LJobDetl);

  New (LRepGen);
  New (LastRepGen);

  New (LDict);
  New (LastDict);


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

  LRecPtr[RepGenF]:=@LRepGen^;

  LRecPtr[DictF]:=@LDict^;

  LastEdit:=BOff;
  InAddEdit:=BOff;
  LastIns:=BOff;

  FillChar(LastRecAddr,Sizeof(LAstRecAddr),0);
  FillChar(LInvNetAnal,Sizeof(LInvNetAnal),0);
  FillChar(LInvNetTrig,Sizeof(LInvNetTrig),0);
  FillChar(LastMisc^,Sizeof(LastMisc^),0);


end;


Destructor TdExLocal.Destroy;

Begin
  Dispose(LMiscRecs);
  Dispose(LastMisc);

  Dispose(LRepScr);

  Dispose(LJobMisc);

  Dispose(LJobRec);

  Dispose(LJobCtrl);

  Dispose(LJobDetl);

  Dispose(LRepGen);
  Dispose(LastRepGen);

  Dispose(LDict);
  Dispose(LastDict);
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
   SysF     :  FillChar(LSyss,FileRecLen[FNum],0);
   ReportF  :  FillChar(LRepScr^,FileRecLen[FNum],0);
   RepGenF  :  FillChar(LRepGen^,FileRecLen[FNum],0);
   DictF    :  FillChar(LDict^,FileRecLen[FNum],0);
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
      RepGenF    :  LRepGen^:=RepGenRecs^;
      DictF      :  LDict^:=DictRec^;
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
      RepGenF    :  RepGenRecs^:=LRepGen^;

    end; {Case..}

end;

Procedure TdExLocal.LGetRecAddr(Fnum :  Integer);

Begin

  Status:=GetPos(F[Fnum],Fnum,LastRecAddr[Fnum]);

end;


Function tdExLocal.LGetMainRecPos(Fnum  :  SmallInt;
                                  KeyS  :  Str255)  :  Boolean;

  Var
    CStatus  :  SmallInt;

  Begin
    CStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    Result:=(CStatus=0);

    If (Not Result) then
      ResetRec(Fnum);
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


{ =============================================================== }


{ ============== TdMTExLocal Methods ============== }

Constructor TdMTExLocal.Create(CIdNo  :  SmallInt);

Begin

  Inherited Create;

  LStatus:=0;

  New(LocalF);
  FillChar(LocalF^,Sizeof(LocalF^),0);

  New(ExClientId);

  Prime_ClientIdRec(ExClientId^,'EX',CIdNo);

  LWinHandle:=0;

  LThShowMsg:=nil;
  LThPrintJob:=nil;

end;


Destructor TdMTExLocal.Destroy;

Begin

  Close_Files;

  If (Assigned(LocalF)) then
    Dispose(LocalF);

  If (Assigned(ExClientId)) then
    Dispose(ExClientId);

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

                   Repeat

                     mbRet:=MessageDlg('Record in use by another station!',
                                        MtConfirmation,[mbRetry,mbCancel],0);

                     BCode:=LTry_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);

                   Until (MbRet=IdCancel) or (Bcode=0);

                   Locked:=(Bcode=0);

                   {* Set record found *}
                   Bcode:=Fcode;

                 end
                 else
                 Begin

                   {* tell Thread form to display lock message *}

                   If (Assigned(LThShowMsg)) then
                   Begin
                     Send_UpdateList(01);

                     Repeat

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



Procedure TdMTExLocal.Open_System(Start,Fin  :  Integer);


  Const
    NoAttempts     =  100;   {* No of retries before giving up *}
  Var
    Choice,NoTrys,
    SetAccel     :  Integer;
    mbRet        :  Word;

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


      If (Check4BtrvOK) then
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

          mbRet:=MessageDlg('Error in File:'+FileNames[Choice]+' Type '+InttoStr(LStatus),mtInformation,[mbOk],0);


          If (Not (LStatus In [85,86])) then
          Begin

            mbRet:=MessageDlg('Create new file?',mtConfirmation,mbOkCancel,0);

          end
          else
            mbRet:=MessageDlg('About to Abort',mtInformation,[mbOk],0);


          If (mbRet=IdOk) and (Not (LStatus In [85,86]))  then
          Begin
            LStatus:=Make_FileCId(LocalF^[Choice],SetDrive+FileNames[Choice],FileSpecOfs[Choice]^,FileSpecLen[Choice],ExClientId);

            If (Debug) then Status_Means(LStatus);
          end
          else
          Halt;
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

    LStatus:=GetFileSpecCId(LocalF^[Choice],Choice,FSpec,ExClientId);

    If (LStatusOk) then
      LStatus:=Close_FileCId(LocalF^[Choice],ExClientId);

  end;

  LStatus:=Reset_BCId(ExClientId);

  If (Debug) then
    Status_Means(LStatus);

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
      end;
    end
    else
      Report_MTBError(Fnum,ErrNo,ExClientId);
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
    MbRet:=MessageDlg(IOMess1+#13+IOError(ErrNo)+IOMEss3+#13+Fname,mtError,[mbOk],0);

end;


Function TdMTExLocal.LUnLockMLock(Fnum :  SmallInt)  :  SmallInt;

Begin
  Result:=UnLockMLock(Fnum,LastRecAddr[Fnum]);
end;




Initialization


Finalization


end.
