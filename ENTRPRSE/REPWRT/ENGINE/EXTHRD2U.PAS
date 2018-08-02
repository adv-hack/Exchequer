unit ExThrd2U;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

{$O-}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VarConst,BtrvU2,BtSupU1,ExWrap1U,
  SBSComp2,EXTHSu1U,ExThredU,BTSupU3, RPDevice{ElVar};

{$IFDEF EBUS}
  This section has been deliberately added to cause
  a compilation error in the eBusiness Modules.
{$ENDIF}
{$IFDEF EDLL}
  This section has been deliberately added to cause
  a compilation error in the Form Designer DLL.
{$ENDIF}
{$IFDEF COMP}
  This section has been deliberately added to cause
  a compilation error in the Multi-Company Manager DLL.
{$ENDIF}
{$IFDEF OLE}
  This section has been deliberately added to cause
  a compilation error in the OLE Server.
{$ENDIF}
{$IFDEF EX_DLL}
  This section has been deliberately added to cause
  a compilation error in the Toolkit DLL.
{$ENDIF}


type
  TPollProc = procedure of object;


  TBackThread = class(TThread)

  protected

    procedure Execute; override;

  public
    FlipFlop,
    ModalVisible,
    StayVisible,
    IdleMode,
    ThreadNowIdle,
    ExecuteOff  :  Boolean;

    TestLoop,
    VisibleThread
                :  LongInt;


    ProgTForm   :  TProgTForm;
    ThreadList  :  TThreadList;
    PrintJobAddr:  LongInt;

    DataPath,
    OurRef,
    FormName : AnsiString;
    PrintKey : longint;
    AttachMethod : Byte;

    NameRec : TSentimailData;

    MTMonRecs   :  Array[0..5] of TMonRec;
    MainThreads :  Array[0..5] of TMainThread;
    BeenTerminated
                :  Array[0..5] of Boolean;

    constructor Create;

    Destructor Destroy;

    Function WaitforTerminate  :  Boolean;

    procedure AddTask(PObj    :  Pointer;
                      PDesc   :  ShortString);

    Function ShowThreadMessage(Sender  :  TObject;
                        Const  SMode   :  Byte;
                        Const  SMsg    :  ShortString)  :  Boolean;

    Procedure UpdatePrintProgress(PProg  :  LongInt);


    {$IFDEF FRM}
      Procedure PrimeFax(Var PParam  :  TPrintParam);

      Procedure thSendEComms(CommsListPtr  :  Pointer);
    {$ENDIF}

    Procedure Print_ThJob;

    Function PrintPrintJob  :  Boolean;

    Procedure Close_VAT;

    Function RunPrintJob(Sender  :  TObject;
                  Const  SMode,
                         RMode   :  LongInt):  Boolean;

    procedure SuspendAll(StopNow  :  Boolean);

    Function MoveThread(Sender  :  TObject;
                  Const IdMode,
                        IdNo,
                        MoveX   :  LongInt)  :  Boolean;

    procedure ThreadDone(Sender: TObject);
    procedure TUnlockList(Sender: TObject);
    procedure InitSync(const DPath : AnsiString);
    function PrintSync(const ARef, AForm : AnsiString; AKey : longint;AttMethod : Byte) : ShortString;

    procedure InitProc;
    procedure PrintProc;
    procedure DeInitProc;
    procedure DeInitSync;

  private
    THUpdateForm,
    InSyncRS,
    InUFormTask,
    InUForm,
    StillPJob,
    StartModal,
    LockListUpDate,
    UpdateRadio,
    SysCaptionOn
             :  Boolean;



    BtMsgList,
    NewDesc  :  ShortString;

    AbortMsgList,
    TermMsgList,
    MsgList
             :  TStringList;

    ExitPassCount
             :  LongInt;


    LabelList:  Array[0..3] of TObject;

    MTOldThread
             :  Array[0..5] of Boolean;

    {CTPrintParam
             :  ^TPrintParam; * used to test printing via eparentu *}


    procedure InitVars;

    procedure DestroyVars;

    Procedure WaitForLockList;

    procedure CreateThreadMessage;
    procedure CreateThreadAbortMsg;
    procedure CreateThreadBtrieveMsg;
    procedure CreateThreadTerminateMsg;

    procedure SyncSetRadioStat;
    procedure SyncRevealForm;
    procedure RevealForm;

    procedure SyncHideForm;
    procedure HideForm;

    procedure SyncUpdateForm;
    procedure UpdateForm;

    procedure UpdateFormTask;

    Function ThreadsAlive  :  Boolean;

    procedure SetVisibleThread;
    procedure TerminateSlaveThread(Tn        :  Integer;
                                   ForceNow  :  Boolean);

    procedure ThreadDelay(dt  :  Word;
                          SAPM:  Boolean);

    procedure RefreshTaskList(Var Loop  :  Integer);

    function CheckHotKeyStat(ThreadQueuePtr  :  Pointer  )   :  Boolean;

    Function StillPreview  :  Boolean;

    procedure ScanBackgroundList;


  end;



Var
  BackThread  :  TBackThread;
  PollProc, SyncProc, ProgressProc,
  InitProc, SyncInit,
  PrintProc, SyncPrint,
  ErrorProc, SyncErr : TPollProc;
  ErrorSender : TObject;
//  ErrorTransType : TElertTransmissionType;



Function Create_BackThread  :  Boolean;
Procedure Set_BackThreadMVisible(State  :  Boolean);
Procedure Set_BackThreadFlip(State  :  Boolean);

Procedure Set_BackThreadSuspend(State  :  Boolean);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,Forms,
  ETMiscU,
  ETStrU,
  ETDateU,
  TEditVal,
  ComnUnit,
  SysU1,
  BTKeys1U,
  BTSFrmU1,

  {$IFDEF FRM}
    {$IFNDEF R_W}
      DLLInt,
      PrintFrm,
    {$ENDIF}

    FrmThrdu,
    {$IFNDEF EBUS}
    FaxIntO,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF RW}
    { replacement printing routines }
    RWPrintR,
  {$ENDIF}

  {$IFDEF VAT}
    {$IFNDEF RW}
      SetVATU,
    {$ENDIF}
  {$ENDIF}

  ExBtTh1U,
  ExThMsgU,
  PForm,
  SBS_Int{, DebugLog};



{ TMainThread }

{$O-} {* Switch optimizer off for all thread operations *}

constructor TBackThread.Create;

Var
  n     :  Integer;


begin

  {* You must create the thread suspended as otherwise it starts to execute before the reset of this
     method begins execution... *}

  inherited Create(True);

  FreeOnTerminate := {BOff}True;

  Priority:=tpIdle;

  ExecuteOff:=BOff;
  ExitPassCount:=0;

  IdleMode:=BOn;
  ThreadNowIdle:=BOff;

  UpdateRadio:=BOff;
  FlipFlop:=BOff; //was BOn. Changed to Boff so that thread is suspended to
                  //avoid 97% cpu usage before 1st sentinel runs.

  StayVisible:=BOff;
  ModalVisible:=BOff;

  LockListUpDate:=BOff;
  StartModal:=BOff;

  THUpdateForm:=BOff;
  SysCaptionOn:=BOff;

  VisibleThread:=0;
  TestLoop:=0;
  PrintJobAddr:=0;
  InUFormTask:=BOff;
  InUForm:=BOff;
  InSyncRS:=BOff;


  FillChar(MTOldThread,Sizeof(MTOldThread),0);
  FillChar(BeenTerminated,Sizeof(BeenTerminated),0);

  StillPJob:=BOff;

  {New(CTPrintParam);
  FillChar(CTPrintParam^,Sizeof(CTPrintParam^),0);}

  //ProgTForm := TProgTForm.Create(Application);
  RevealForm;
  Resume;

end;

Destructor TBackThread.Destroy;

Begin
  Inherited Destroy;


  AbortMsgList.Free;
  MsgList.Free;
  TermMsgList.Free;

  {Dispose(CTPrintParam);}

  Synchronize(DestroyVars);
  if Assigned(ProgTForm) then
    ProgTForm.Release;
end;


Function TBackThread.WaitforTerminate  :  Boolean;

Var
  n       :  Integer;

  TmpBo   :  Boolean;

Begin
  n:=0;

  Inc(ExitPassCount);

  Repeat

    Inc(n);

    Application.ProcessMessages;

    ThreadDelay(200,BOn);

    TmpBo:=Terminated;

    ThreadDelay(200,BOn);

    If (TmpBo) then
      TmpBo:=(ExecuteOff or (ExitPassCount>2));


  Until (TmpBo) or (n>9);

  Result:=TmpBo;
end;

procedure TBackThread.InitVars;

Var
  n  :  Integer;

Begin
  AbortMsgList:=TStringList.Create;
  MsgList:=TStringList.Create;
  TermMsgList:=TStringList.Create;

  For n:=Low(MTMonRecs) to High(MTMonRecs) do
  Begin
    FillChar(MTMonRecs[n],Sizeof(MTMonRecs[n]),0);

    MTMonRecs[n].MLines:=TStringList.Create;
    MTMonRecs[n].THPriority:=tpLowest;
  end;

  NewDesc:='';
  BtMsgList:='';

  ThreadList:=TThreadList.Create;

  For n:=Low(MainThreads) to High(MainThreads) do {* Shut down any idle threads *}
    MainThreads[n]:=nil;
end;


procedure TBackThread.DestroyVars;

Var
  n  :  Integer;

Begin

  For n:=Low(MTMonRecs) to High(MTMonRecs) do
    MTMonRecs[n].MLines.Free;

  ThreadList.Free;


end;


procedure TBackThread.CreateThreadMessage;

Var
  ThreadMsg  :  TThreadMsg;

Begin
  If (MsgList.Count>0) then
  Begin
    ThreadMsg:=TThreadMsg.Create(Application.MainForm);

    try
      With ThreadMsg do
      Begin
        Caption:='ObjectThread Controller';
        Label2.Caption:=MsgList.Strings[0];
        AdjustWidth(1,0);
        Show;
      end;
    except
      ThreadMsg.Free;

    end; {try..}

    MsgList.Delete(0);
  end;

end;


procedure TBackThread.CreateThreadAbortMsg;

Var
  ThreadMsg  :  TThreadMsg;

Begin
  If (AbortMsgList.Count>0) then
  Begin
    ThreadMsg:=TThreadMsg.Create(Application.MainForm);

    try
      With ThreadMsg do
      Begin
        ThreadRec:=@MTMonRecs[VisibleThread];

        If (Assigned(ProgTForm)) then
          OTForm:=ProgTForm.Handle;

        Caption:='Abort current thread job.';
        Label2.Caption:=AbortMsgList.Strings[0];
        AdjustWidth(1,1);
        Show;
      end;
    except
      ThreadMsg.Free;

    end; {try..}

    AbortMsgList.Delete(0);
  end;
end;




procedure TBackThread.CreateThreadBtrieveMsg;

Var
  ThreadMsg  :  TThreadMsg;

Begin
  ThreadMsg:=TThreadMsg.Create(Application.MainForm);

  try
    With ThreadMsg do
    Begin
      Caption:='ObjectThread Controller Error!';
      Label1.Caption:=BtMsgList;
      AdjustWidth(0,2);
      ShowModal;
    end;
  finally
    ThreadMsg.Free;

  end; {try..}


end;

procedure TBackThread.CreateThreadTerminateMsg;

Var
  ThreadMsg  :  TThreadMsg;

Begin
  If (TermMsgList.Count>0) then
  Begin
    ThreadMsg:=TThreadMsg.Create(Application.MainForm);

    try
      With ThreadMsg do
      Begin
        ThreadRec:=@MTMonRecs[VisibleThread];

        If (Assigned(ProgTForm)) then
          OTForm:=ProgTForm.Handle;

        Caption:='Terminate current thread job?';
        Label4.Caption:=TermMsgList.Strings[0];
        AdjustWidth(3,3);
        Show;
      end;
    except
      ThreadMsg.Free;

    end; {try..}

    TermMsgList.Delete(0);
  end;
end;


Procedure TBackThread.WaitForLockList;

Var
  n  :  Integer;

Begin
  n:=0;

  Repeat
    Inc(n);

    Application.ProcessMessages;

  Until (Not LockListUpdate) ;

  LockListUpdate:=BOn;

end;


procedure TBackThread.SuspendAll(StopNow  :  Boolean);

Var
  n  :  Integer;

Begin
  For n:=Low(MainThreads) to High(MainThreads) do
  Begin
    If (Assigned(MainThreads[n])) and (Not BeenTerminated[n]) then
    Begin
      If (StopNow) then
        MainThreads[n].Suspend
      else
        MainThreads[n].Resume;
    end;
  end;
end;

Procedure TBackThread.TUnlockList(Sender  :  TObject);

Begin
  If (Assigned(Sender)) then
    LockListUpdate:=BOff
  else
    WaitForLockList;
end;


Function TBackThread.MoveThread(Sender  :  TObject;
                          Const IdMode,
                                IdNo,
                                MoveX   :  LongInt)  :  Boolean;

Var
  n        :  Integer;

  NewPriority
           :  LongInt;

  TmpTHList:  ^TThreadQueue;
  TmpPtr   :  Pointer;

Begin
  NewPriority:=0;

  Case IdMode of
    0,1  :  With ThreadList do
            Begin
              {WaitforLockList;}

              n:=FindxId(IdNo);

              If (n>=0) then
              Begin
                Case IdMode of
                  0  :  Move(n,n+MoveX);
                  1  :  Begin
                          {* As we delete undo any start settings, like posting locks *}

                          TmpPtr:=IdRec(n).TMember;

                          If (Assigned(TmpPtr)) then
                          Begin
                            TmpTHList:=TmpPtr;

                            TmpTHList^.AbortfromStart;

                            Dispose(TmpTHList,Destroy);
                          end;

                          DeleteQueue(n);
                        end;
                end; {Case..}
              end;

              {* Unlock taken care of by call back to TUnlockList *}

            end; {With..}

    2     : Begin
              VisibleThread:=IdNo;

              With MTMonRecs[VisibleThread] do
              Begin
                {* Set to force a redraw *}
                Inc(THUpStr);

                Inc(THUpBar);

                Synchronize(SyncRevealForm);
              end;
            end;

    3    :  Begin
              {$B-}
              If (Assigned(MainThreads[VisibleThread])) and (Not MainThreads[VisibleThread].ExecuteOff) then
              {$B+}
              Begin
                NewPriority:=IdNo;

                {* EX32. Do not allow tpHigher+ against reports/forms, as this seems to cause corruption,
                   the main symptoms being unable to exit Enterprise, or worst...  This would
                   be worth investigating more when time permits. Reports/Stock/Shortages immediately upon
                   running is a good example. 01/11/96}

                {If (MainThreads[VisibleThread].ParentQ=2) and (NewPriority>Ord(tpNormal)) then
                  NewPriority:=Ord(tpNormal);}

                {* In the end this was not needed, as the priority of the thread was reduced within ExThread
                   Just before finish is executed, this is more efficient since it allows the processing of the
                   report to occur at full speed*}


                MTMonRecs[VisibleThread].THPriority:=TThreadPriority(NewPriority);

                try
                  {If (Assigned(MainThreads[VisibleThread])) then
                    MainThreads[VisibleThread].Suspend;}

                  If (Assigned(MainThreads[VisibleThread])) then
                    MainThreads[VisibleThread].Priority:=MTMonRecs[VisibleThread].THPriority;

                  {If (Assigned(MainThreads[VisibleThread])) then
                    MainThreads[VisibleThread].Resume;}
                except

                end;

              end;
            end;
  end; {Case..}

  Result:=BOn;
end;


Function TBackThread.ShowThreadMessage(Sender  :  TObject;
                                Const  SMode   :  Byte;
                                Const  SMsg    :  ShortString)  :  Boolean;


Var
  mbRet  :  Boolean;
  n      :  Byte;

Begin


  Case SMode of
    0  :  Begin
            MsgList.Add(SMsg);
            Synchronize(CreateThreadMessage);
          end;

    1  :  Begin
            {* Suspend all current threads pending a possible abort *}
            For n:=Low(MainThreads) to High(MainThreads) do
              If (Assigned(MainThreads[n])) then
              With MainThreads[n] do {* Only suspend once, as suspends get nested *}
              try
                If (Not Suspended) and (Not ExecuteOff) and (Not MainFinish) then
                  Suspend;
              except
                MainThreads[n]:=nil;
              end; {try..}


            AbortMsgList.Add(SMsg);
            Synchronize(CreateThreadAbortMsg);
          end;

    2  :  Begin
            BtMsgList:=SMsg;
            Synchronize(CreateThreadBtrieveMsg);
          end;

    3  :  Begin
            TermMsgList.Add(SMsg);
            Synchronize(CreateThreadTerminateMsg);
          end;

    4  :  Begin {* Force a termination *} {EX32 good place for a log entry...}
            If (Assigned(MainThreads[VisibleThread])) then
            With MainThreads[VisibleThread] do
            Begin
              try
                If (Not Suspended) then
                  Suspend;

                If (MTMonRecs[VisibleThread].thPrintJob) then {* Reset inPrint flag *}
                  InPrint:=BOff;

                Terminate;

              finally

                MainThreads[VisibleThread]:=nil;
              end; {try..fin..}
            end;
          end;

    5  :  Begin
            {* Resume all threads following an abort regardless of abort status, as THAbort will be
               Set so thread can finish safely *}
            For n:=Low(MainThreads) to High(MainThreads) do
              If (Assigned(MainThreads[n])) then
              With MainThreads[n] do
              try
                If (Suspended) then
                  Resume;
              except
                MainThreads[n]:=nil;
              end; {try..}
          end;

  end; {Case..}

  Result:=BOn;
end;



{* redirect form printing progress to thread progress *}

Procedure TBackThread.UpdatePrintProgress(PProg  :  LongInt);

Var
  ThisGo  :  LongInt;

Begin
  With MTMonRecs[2] do
  Begin

    ThisGo:=Trunc((PProg/1000)*PTotal);


    PCount:=PCount+(ThisGo-THPPCount);

    THPPCount:=ThisGo;

    Inc(ThUpBar);

    Synchronize(SyncRevealForm);
  end;

end;


{$IFDEF FRM}


  Procedure TBackThread.PrimeFax(Var PParam  :  TPrintParam);
  {$IFDEF EBUS}
  begin
  end;
  {$ELSE}

  Var

    EntFaxO : TEntFaxInt;
    Res     : SmallInt;
  Begin


    { IFNDEF RW}
      {$IFDEF FRM}
        With PParam do
        Begin

          With PDevRec do
          If (fePrintMethod = 1) And (feFaxMethod In [0,2]) Then
          Begin
            { Faxing via Enterprise }
            EntFaxO := TEntFaxInt.Create;

            Try
              With EntFaxO Do
              Begin
                fxDocName := 'Exchequer Enterprise Fax';

                fxRecipName := PDevRec.feFaxTo;
                fxRecipNumber := PDevRec.feFaxToNo;

                fxSenderName := PDevRec.feFaxFrom;
                fxSenderEmail := PDevRec.feEmailFromAd;


                fxUserDesc := {PDevRec.feFaxMsg;}  RepCaption;

                //fxPriority := 'N';
                InitFromPrnInfo (PDevRec);

                fxFaxDir:=SyssEDI2^.EDI2Value.FaxDLLPath;

                If (SyssEDI2^.EDI2Value.FxUseMAPI<>2) then
                  Res := StoreDetails  {Sent via main program}
                else
                  Begin {This is all experimental to see if we could solve Neils OLE GPF problem}
                    PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,99,LongInt(EntFaxO));
                    ThreadDelay(10000,BOn);
                    Res:=0;
                  end;

                If (Res = 0) Then
                Begin
                  { AOK - pull back print job title }
                  feJobtitle := fxDocName;

                End; { If }

                If (SyssEDI2^.EDI2Value.FxUseMAPI<>2) then
                  EntFaxO.Destroy;
              End; { With }
            Except
              EntFaxO.Destroy;
            End;

          end;

        end; {With..}
      {$ENDIF}
    { ELSE}
      //End; { With }
    { ENDIF}

  end;
{$ENDIF}

  Procedure TBackThread.thSendEComms(CommsListPtr  :  Pointer);

  Var
    CommFrmList  :  TeCommFrmList;

    n            :  Integer;

    Ok2Cont      :  Boolean;

    pbStaCtrl    :  StaCtrlRec;

  Begin
    CommFrmList:=TeCommFrmList(CommsListPtr);

    pbStaCtrl:=Nil;

    Try
      With CommFrmList do
      Begin
        If (HasItems) then
        Begin
          n:=0;

          Ok2Cont:=BOn;

          While (n<Count) and (Ok2Cont) do
          Begin
            With IdRec(n)^ do
            Begin
              PrimeFax(PParam);

              pbStaCtrl:=@AddBatchInfo;

              Ok2Cont:=pfPrintFormSta (PParam.PDevRec,
                                       DefMode,
                                       RForm,
                                       PFNum, PKeyPath,
                                       PKeyref,
                                       Fnum,Keypath,
                                       KeyRef,
                                       Descr,
                                       WinTitle,
                                       pbStaCtrl,
                                       BOff);
            end;

            Inc(n);
          end;

        end;
      end;
    Finally
      CommFrmList.Destroy;

    end; {Try..}

  end;
{$ENDIF}





Procedure TBackThread.Print_ThJob;

Var
  PParam,
  TParam  :  ^TPrintParam;

  DebugParam  : TPrintParam;


Begin

  If (Not StillPJob) then
  Begin
    StillPJob:=BOn;

    TParam:=Pointer(PrintJobAddr);

    New(PParam);

    PParam^:=TParam^;

    DebugParam:=PParam^;

    {$IFNDEF RW}
      {$IFDEF FRM}
        With PParam^ do
        Begin
          {InBuildPP:=PDevRec.Preview;}

          InBuildPP:=PBatch or PDevRec.Preview;

          {MTMonRecs[2].THInPReview:=InBuildPP;}

          With PDevRec do
          {If (fePrintMethod = 1) And (feFaxMethod = 0) Then}
          If (fePrintMethod = 1) And (feFaxMethod In [0,2]) Then
          Begin
            PrimeFax(PParam^)
          end;

          If (PBatch) then
          Begin
            If (PDevRec.feJobTitle='') then
              PDevRec.feJobTitle:='Exchequer';

            pfPrintBatch(RepCaption,PDevRec.NoCopies,BOff,PDevRec.feJobtitle);

             If (Assigned(ECommLink)) then {* Send all the emails *}
               thSendEcomms(ECommLink);


            If (DelSwapFile) and (SwapFileName<>'') then {* As we are combining multiple batches we need to keep common
                                                            scratch file open *}
            Begin
              ThreadDelay(600,BOff);

              pfDeleteSwapFile(SwapFileName);

            end;
          end
          else
          Begin
            PrintFileTo(PDevRec,FileName,RepCaption);
          end;

        end; {With..}
      {$ENDIF}
    {$ELSE}
      // Windows Report Writer

   {   With PParam^ do
      Begin
        InBuildPP:=PDevRec.Preview;

        With PDevRec do
          If (fePrintMethod = 1) And (feFaxMethod In [0,2]) Then
            PrimeFax(PParam^);

        PrintFileTo(PDevRec,FileName,RepCaption);
      End; { With }
    {$ENDIF}

    Dispose(PParam);
    Dispose(TParam);

  end;



end;



{$IFDEF X32} {* Control final stage of print job *}

Procedure TBackThread.Print_ThJob;

Var
  TParam  :  ^TPrintParam;


Begin

  If (Not StillPJob) then
  Begin
    StillPJob:=BOn;

    TParam:=Pointer(PrintJobAddr);

    CTPrintParam^:=TParam^;

    {* Get rid of TParam as quickly as possible *}

    {Dispose(TParam);}


    {$IFNDEF RW}
      {$IFDEF FRM}
        With CTPrintParam^ do
        Begin
          InBuildPP:=PDevRec.Preview;


          SendMessage(Application.MainForm.Handle,WM_FormCloseMsg,98,LongInt(@CTPrintParam^));

          {If (PBatch) then
            pfPrintBatch(RepCaption,PDevRec.NoCopies,BOff)
          else
            PrintFileTo(PDevRec,FileName,RepCaption);}
        end; {With..}
      {$ENDIF}
    {$ELSE}
      With PParam^ do Begin
        InBuildPP:=PDevRec.Preview;

        PrintFileTo(PDevRec,FileName,RepCaption);
      End; { With }
    {$ENDIF}

  end;

end;


Function TBackThread.RunPrintJob(Sender  :  TObject;
                          Const  SMode,
                                 RMode   :  LongInt):  Boolean;

Begin
  Result:=BOn;

  Case RMode of
    8  :  Synchronize(Close_VAT);

    else  Begin
            PrintJobAddr:=SMode;

            {* Wait for print dialog box to finish *}

            While (InModalDialog) do;

            Repeat
              Inc(TestLoop);
              Synchronize(Print_ThJob);
            Until (StillPJob);

            StillPJob:=BOff;

            If (InBuildPP) then {* Force a delay so any atempt to create a print dialog is detected *}
              ThreadDelay(2000,BOff);

            InBuildPP:=BOff;
          end;
  end; {Case..}
end;


{$ENDIF}

Procedure TBackThread.Close_VAT;

Begin
  {$IFDEF VAT}
    {$IFNDEF RW}
      Close_CurrPeriod;
    {$ENDIF}
  {$ENDIF}
end;

Function TBackThread.RunPrintJob(Sender  :  TObject;
                          Const  SMode,
                                 RMode   :  LongInt):  Boolean;

Begin
  Result:=BOn;

  Case RMode of
    8  :  Synchronize(Close_VAT);

    else  Begin
            MTMonRecs[2].THPPAddr:=SMode;
            MTMonRecs[2].THNeedPrint:=BOn;
          end;
  end; {Case..}
end;



Function TBackThread.PrintPrintJob  :  Boolean;

Begin
  Result:=BOn;

  PrintJobAddr:=MTMonRecs[2].THPPAddr;
  MTMonRecs[2].THNeedPrint:=BOff;
  MTMonRecs[2].THPPAddr:=0;

  {* Wait for print dialog box to finish *}

  While (InModalDialog) do;

  Repeat
    Inc(TestLoop);
    Synchronize(Print_ThJob);
  Until (StillPJob);

  StillPJob:=BOff;

  If (InBuildPP) then {* Force a delay so any atempt to create a print dialog is detected *}
    ThreadDelay(2000,BOff);

  InBuildPP:=BOff;
end;



procedure TBackThread.SyncSetRadioStat;

Var
  n  :  Integer;

Begin

  If (Assigned(ProgTForm)) and (Not InSyncRS) then
    With ProgTForm do
    Begin
      InSyncRS:=BOn;

      For n:=Low(ThreadFormQ) to High(ThreadFormQ) do
      With ThreadFormQ[n] do
      Begin
        {$B-}

        If (Assigned(MainThreads[n])) and (Not MainThreads[n].ExecuteOff) then

        {$B+}

        With MTMonRecs[n] do
        Begin
          If (IdNo<>ThIdNo) then
          Begin
            Radio.Enabled:=BOn;
            Radio.Caption:=THTaskDesc;
            IdNo:=ThIdNo;
          end;
        end
        else
        Begin
          Radio.Enabled:=BOff;
          Radio.Caption:='Idle.';
          IdNo:=0;
        end;
      end;

        If (VisibleThread>0) then
        With ThreadFormQ[VisibleThread] do
        Begin
          If (Radio.Enabled) and (Not Radio.Checked) then
            Radio.Checked:=BOn;

          If (Assigned(MainThreads[VisibleThread]))  then
            TrackBar1.Position:=Ord(MainThreads[VisibleThread].Priority);
        end;
      InSyncRS:=BOff;
    end; {If Assigned..}
end;

procedure TBackThread.SyncRevealForm;

Var
  WasNew  :  Boolean;

  LastFormFocus
          :  TForm;

Begin
  WasNew:=BOff;

  LastFormFocus:=Application.MainForm.ActiveMDIChild;

  {LastFormFocus:=Screen.ActiveForm;}

  If (Not (Assigned(ProgTForm))) then
  Begin
    ProgTForm:=TProgTForm.Create(Application.MainForm);
    WasNew:=BOn;

    If (Assigned(LastFormFocus)) and (LastFormFocus<>ProgTForm) then
      LastFormFocus.Show;
  end;
  {else  EL, Use this if we decide not to destroy form , auto minimised would need checking for
    If (ProgTForm.WindowState=wsMinimized) then
    Begin
      ProgTForm.WindowState:=wsNormal;
      ProgTForm.ThreadFinished:=BOff;

      If (Assigned(LastFormFocus)) and (LastFormFocus<>ProgTForm) then
        LastFormFocus.Show;
    end;}

  try
    With ProgTForm do
    Begin
      If (WasNew) Then
      Begin

        LabelList[0]:=Label1;
        LabelList[1]:=Label2;
        LabelList[2]:=Label3;
        LabelList[3]:=Label4;

        MsgCallBack:=ShowThreadMessage;
        UpdateThreadList:=MoveThread;
        UnlockList:=TUnlockList;

      end;

      If (UpdateRadio) then
        SyncSetRadioStat;

      Caption:='ObjectThread Controller. - '+MTMonRecs[VisibleThread].THTaskDesc;

      ModalResult:=mrNone;

      CanCP1Btn.Visible:=MTMonRecs[VisibleThread].THCanAbort;


    end;
  except
    ProgTForm.Free;
    ProgTForm:=nil;
  end; {try..}
end;


procedure TBackThread.RevealForm;


Begin

  If (Not (Assigned(ProgTForm))) then
    Synchronize(SyncRevealForm);

end;


procedure TBackThread.SyncHideForm;
Begin
  If (Assigned(ProgTForm)) then
  Begin
    ProgTForm.ThreadFinished:=BOn;
    {ProgTForm.Free;}

    ProgTForm.ShutDown;



//    ProgTForm:=nil;
    {* Reset gauge if used *}
    
    SendMessage(Application.MainForm.Handle,WM_ThreadPrintP,10,0);
    {* Use this if we decide not to destroy form *}
    {ProgTForm.WindowState:=wsMinimized;}

  end; {With..}
end;


procedure TBackThread.HideForm;
Begin

  If (Assigned(ProgTForm)) then
    Synchronize(SyncHideForm);

end;

procedure TBackThread.SyncUpdateForm;

Var
  n  :  Integer;


Begin
  If (Assigned(ProgTForm)) then
  With ProgTForm,MTMonRecs[VisibleThread] do
  Begin
    If (THUpStr>0) or (THUpBar>0) then
    Begin
      If (THUpStr>0) then
      Begin

        For n:=0 to Pred(MLines.Count) do
          If (Label8(LabelList[n]).Caption<>MLines.Strings[n]) then
            Label8(LabelList[n]).Caption:=MLines.Strings[n];

        Dec(THUpStr);
      end;

      If (THUpBar>0) then
      Begin
        If (PTotal<>Gauge1.MaxValue) then
          Gauge1.MaxValue:=PTotal;

        If (PCount<>Gauge1.Progress) then
          Gauge1.Progress:=PCount;

        Dec(THUpBar);

        If (WindowState=wsMinimized) then
        Begin
          SendMessage(Application.MainForm.Handle,WM_ThreadPrintP,11,Round(DivWChk(PCount,PTotal)*100));
        end;
      end;


    end; {With..}

    If (CanCP1Btn.Enabled<>(Not MTMonRecs[VisibleThread].THAbort)) then
    With MTMonRecs[VisibleThread] do
    Begin
      CanCP1Btn.Enabled:=Not THAbort;
      THShowAbort:=BOff;
      TermBtn.Enabled:=ThAbort;
    end;
    Application.ProcessMessages;
  end; {With..}
end;


procedure TBackThread.UpdateForm;


Begin
  If (Assigned(ProgTForm)) and (Not InUForm) then
  With MTMonRecs[VisibleThread] do
  Begin
    InUForm:=BOn;
    If (THUpStr>0) or (THUpBar>0) or (THShowAbort) or (THUpdateForm) then
      Synchronize(SyncUpdateForm);

    InUForm:=BOff;
  end; {With..}
end;



procedure TBackThread.UpdateFormTask;

Var
  n             :  Integer;
  VisiRec       :  TThreadListRec;
  VisiId        :  ThreadIdRec;

Begin
  If (Not InUFormTask) then
  Begin
    InUFormTask:=BOn;
    If (Assigned(ProgTForm))  then
    With ProgTForm do
    Begin
      SetButtonStatus(BOff);

      For n:=0 to Pred(ListBox1.Items.Count) do
      Begin
        If (Assigned(ListBox1.Items.Objects[n])) then
          ListBox1.Items.Objects[n].Free;
      end;

      ListBox1.Items.Clear;

      For n:=0 to Pred(ThreadList.Count) do
      Begin

        VisiRec:=ThreadList.IdRec(n);

        VisiId:=ThreadIdRec.Create;

        VisiId.IdNo:=VisiRec.TQId;

        ListBox1.Items.AddObject(VisiRec.TMembDesc,VisiId);
      end;

      SetButtonStatus(BOn);

    end;
    LockListUpdate:=BOff;
    InUFormTask:=BOff;
  end;
end;


Function TBackThread.ThreadsAlive  :  Boolean;

Var
  n  :  Integer;

Begin
  Result:=BOff;

  For n:=Low(MainThreads) to High(MainThreads) do
    If (Not Result) then
      Result:=Assigned(MainThreads[n]);


end;


procedure TBackThread.SetVisibleThread;

Var
  n  :  Integer;

Begin
  VisibleThread:=0;

  For n:=Low(MainThreads) to High(MainThreads) do
    If (Assigned(MainThreads[n])) then
    Begin
      VisibleThread:=n;
      Break;
    end;

  If (VisibleThread>0) then
    Synchronize(SyncSetRadioStat);

end;

procedure TBackThread.ThreadDone(Sender: TObject);

Var
  Tn  :  Integer;

Begin
  If (Sender is TMainThread) then
    With TMainThread(Sender) do
    Begin
      Tn:=ParentQ;


      If (VisibleThread=Tn) then
        SetVisibleThread;

      MainThreads[ParentQ]:=nil;
      BeenTerminated[ParentQ]:=BOn;

    end;
end;


procedure TBackThread.ThreadDelay(dt  :  Word;
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


{ * WINNT procedure TBackThread.TerminateSlaveThread(Tn        :  Integer;
                                           ForceNow  :  Boolean);

Begin
  If (Assigned(MainThreads[Tn])) then
  With MainThreads[Tn] do
  Begin
    If (ExecuteOff) or (ForceNow) then
    Begin
      Terminate;

      If WaitForTerminate then
      Begin
        Suspend;
        Free;
        MainThreads[Tn]:=nil;

        If (VisibleThread=Tn) then
          SetVisibleThread;
      end;
    end; {If..
  end; {With..
end;}


procedure TBackThread.TerminateSlaveThread(Tn        :  Integer;
                                           ForceNow  :  Boolean);

Begin
  If (Assigned(MainThreads[Tn])) then
  With MainThreads[Tn] do
  Begin
    If (ExecuteOff) or (ForceNow) then
    Begin
      Try

        ForceTerminateStatus;

      finally
        Terminate;
      end; {try..}

      {If (VisibleThread=Tn) then
        SetVisibleThread;

      If WaitForTerminate then
      Begin
        Suspend;
        Free;
        MainThreads[Tn]:=nil;


      end;}
    end; {If..}
  end; {With..}
end;

{ Main thread loop}

procedure TBackThread.RefreshTaskList(Var Loop  :  Integer);

Begin
  WaitForLockList;

  ThreadList.DeleteQueue(Loop);

  Dec(Loop);

  Synchronize(UpdateFormTask);

  LockListUpdate:=BOff;
end;

function TBackThread.CheckHotKeyStat(ThreadQueuePtr  :  Pointer  )   :  Boolean;

Var
  ThreadQueue  :  ^TThreadQueue;
  VShowMsg,
  VThreadRunning,
  FlagOn       :  Boolean;
  VWarnMsg     :  Str255;

Begin
  FlagOn:=BOff;
  VShowMsg:=BOff;
  VWarnMsg:='';

  VThreadRunning:=(Assigned(ThreadQueuePtr));

  Result:=((Not InCurr) and (Not InChangePr) and (Not InVATP) and (not InSysSS)
           and (Not InDocNum) and (Not InGLCC));

  If (Not Result) then
  Begin
    FlagOn:=BOn;

    If (VThreadRunning) then
    Begin
      VWarnMsg:='Please close System window.';
      VShowMsg:=BOn;
      SysCaptionOn:=BOn;
    end;
  end
  else
  Begin
    If (VThreadRunning) then
    Begin
      ThreadQueue:=ThreadQueuePtr;

      Result:=((Not InPrint) or (Not ThreadQueue^.fPrintJob));
    end;

    If (Not Result) and (Not FlagOn) then
    Begin
      VWarnMsg:='Waiting for thread to finish.';
      VShowMsg:=BOn;
      SysCaptionOn:=BOn;
    end;

    If (Result) and (SysCaptionOn) then
    Begin
      VWarnMsg:='';
      VShowMsg:=BOn;
      SysCaptionOn:=BOff;
    end;
  end;

  If (VShowMsg) and (Assigned(LabelList[3])) then
  Begin
    Label8(LabelList[3]).Caption:=VWarnMsg;
    THUpdateForm:=BOn;
    UpdateForm;
    ThUpdateForm:=BOff;
  end;
end;


Function TBackThread.StillPreview  :  Boolean;

Begin
  {$IFDEF RW}
    Result:=(NumPrevWins>0);
  {$ELSE}
    {$IFDEF FRM}
      Result:=(NumPrevWins>0);
    {$ELSE}
      Result:=BOff;
    {$ENDIF}
  {$ENDIF}

  If (Not Result) then  {* Keep alive if a print pending *}
    Result:=MTMonRecs[2].THNeedPrint;

  If (Not Result) then {* Stall to give preview window a chance to close *}
  Begin
    {MTMonRecs[2].THInPreview:=InBuildPP;}
    ThreadDelay(600,BOff);
  end
  else
  Begin
    {This added v4.31.004/build 125 06/09/2000.  When a preview window was left open the thread controller went into a
    loop waiting for the preview window to close.  This loop ramped up the processor usgae to 100%.
    This was not a problem on most installations as the thread idle yielded to any user interface or higher threads,
    but on Ctrtix with more than one screen on a preview window began to thrash the processor as they each demanded
    100% }

    SleepEx(600,BOn);

  end;

end;


procedure TBackThread.ScanBackgroundList;

Var
  VisiRec       :  TThreadListRec;
  ThreadQueue   :  ^TThreadQueue;
  Loop,
  n,
  NeedQ         :  Integer;

  ValidQueue,
  StillRunning,
  AnyAlive      :  Boolean;

begin
  NeedQ:=0;  ValidQueue:=BOff; AnyAlive:=BOff;

  While (Not Terminated) do
  Begin
    StillRunning:=BOff;

//    LogIt(spReport, '<>ScanBackGroundList 1750');
    {06/06/1997 This added here to correct AV when in print preview, basicly thread has finished by this point *}
    {Old RunPrintJob could be restored by removing THNeedPrint then copying back old version *}
    If (Not LockListUpDate) and (MTMonRecs[2].THNeedPrint) and (Not Assigned(MainThreads[2])) and (MTMonRecs[2].THPPAddr<>0) then {* Finish any prior jobs *}
      PrintPrintJob;


    If (StayVisible) then
      RevealForm;

    {$B-} {* 09/12/96. Threads were crashing here, if they were the first thing run, adding the additional
                       check for Assigned cured it despite the fact that Threadlist was not the problem.
                       Bug only present when run over a network *}
    If (Not LockListUpdate) and (Assigned(ThreadList)) and (ThreadList.Count>0) then {We have some list members}
    Begin

    {$B+}

      IdleMode:=BOff;
      ThreadNowIdle:=BOff;

      Loop:=0;

      Repeat

        VisiRec:=ThreadList.IdRec(Loop);

        ThreadQueue:=VisiRec.TMember;

        If (Assigned(ThreadQueue)) then
        Begin

          try
            NeedQ:=ThreadQueue^.fTQNo;


            StartModal:=ThreadQueue^.fShowModal;

            ValidQueue:=((NeedQ>=Low(MainThreads)) and (NeedQ<=High(MainThreads)));


            RevealForm;

            {*WINNT TerminateSlaveThread(NeedQ,BOff);}

            {$B-}

            If (ValidQueue) and (Not Assigned(MainThreads[NeedQ])) and (Not LockListUpdate) and (CheckHotKeyStat(ThreadQueue)) then
            Begin

            {$B+}


              FlipFlop:=BOff;


              If (ThreadQueue^.fPrintJob) then
                InPrint:=BOn;

              BeenTerminated[NeedQ]:=BOff;

              WaitForLockList;

              MTMonRecs[NeedQ].ThAbort:=BOff; {* Reset last abort..}
              MTMonRecs[NeedQ].ThAbortPrint:=BOff; {* Reset last abort..}
              MTMonRecs[NeedQ].PCount:=0;     {* Reset last count *}
              MTMonRecs[NeedQ].THCanAbort:=ThreadQueue^.fCanAbort;
              MTMonRecs[NeedQ].THTaskDesc:=VisiRec.TMembDesc;
              MTMonRecs[NeedQ].THIdNo:=VisiRec.TQId;
              MTMonRecs[NeedQ].THUpStr:=1;
              MTMonRecs[NeedQ].THUpBar:=1;
              MTMonRecs[NeedQ].THPrintJob:=ThreadQueue^.fPrintJob;


              If (ThreadQueue^.fSetPriority) then
                MTMonRecs[NeedQ].THPriority:=ThreadQueue^.fPriority;

              If (VisibleThread=0) then
                VisibleThread:=NeedQ;


              ThreadQueue^.ThreadRec:=@MTMonRecs[NeedQ];

              If (Assigned(ThreadQueue^.MTExLocal))  then {* Pass handle of form, so lock message can be displayed *}
              Begin {* Also pass handle of call back so any bt error messages can be synchronised *}

                ThreadQueue^.MTExLocal.LThShowMsg:=ShowThreadMessage;

                If (Assigned(ProgTForm)) then
                  ThreadQueue^.MTExLocal.LWinHandle:=ProgTForm.Handle;

                ThreadQueue^.MTExLocal.LThPrintJob:=RunPrintJob;

              end;


              If (MTOldThread[NeedQ]) then {* Place a delay b4 restarting next thread as can crash it
                                              seems if a new thread is stared b4 an old thread is destroyed *}
                ThreadDelay(600,BOff)
              else
                MTOldThread[NeedQ]:=BOn;

              {* Increase own priority whilst setting up new thread so new thread runs slower than OTC *}

              Self.Priority:=tpLowest;

              {* Start thread as idle so it cannot finish before this section has been completed *}

              try
                AnyAlive:=ThreadsAlive; {* Check to see if any other threads still running *}

                {* Start this thread as suspended so any updates can take place with no problems *}
                MainThreads[NeedQ]:=TMainThread.Create(VisiRec.TMember,MTMonRecs[NeedQ].THPriority,ThreadDone,NeedQ);

                UpdateRadio:=BOn;

                Synchronize(SyncRevealForm);

                ThreadList.DeleteQueue(Loop);

                Dec(Loop);

                Synchronize(UpdateFormTask);

                {* Slow down own priority once new thread ready to run *}

                Self.Priority:=tpIdle;

                {* Resume new thread to normal priority *}

                If Assigned(MainThreads[NeedQ]) then
                Begin
                  {MainThreads[NeedQ].Priority:=MTMonRecs[NeedQ].THPriority;}

                  MainThreads[NeedQ].Resume;

                  If (AnyAlive) then
                  Begin
                    If (VisibleThread=NeedQ) then  {* Redisplay priority *}
                      Synchronize(SyncSetRadioStat);
                  end
                  else {* Re-establish new thread *}
                    SetVisibleThread;
                end;


              except

              end;

              LockListUpdate:=BOff;

            end {Start slave thread}
            else
              If (Assigned(MainThreads[NeedQ])) and (Not LockListUpDate) and (CheckHotKeyStat(ThreadQueue)) then
              Begin
                If (BeenTerminated[NeedQ]) then {* Force abort *}
                Begin
                  MainThreads[NeedQ]:=nil;
                end;
              end;
            except
              LockListUpdate:=BOff;
              RefreshTaskList(Loop);
            end; {try..}
          end
          else {* its not valid, remove from list *}
          Begin
            RefreshTaskList(Loop);
          end;

        Inc(Loop);
      Until (Loop>Pred(ThreadList.Count)) or (LockListUpdate);
    end
    else
    If (Not LockListUpdate) then
    Begin

      For n:=Low(MainThreads) to High(MainThreads) do {* Shut down any idle threads *}
      Begin
        {* WINNT TerminateSlaveThread(n,BOff);*}

        If (Assigned(MainThreads[n])) then
          StillRunning:=BOn;
      end;


       If (Not StillRunning)  then {Finish}
       Begin
         IdleMode:=BOn;

         If (Not Terminated) and (Not StayVisible) and (Not ModalVisible) and (Not StillPreview) then
           HideForm;
       end;
    end;

    If (Not Terminated) then
      UpdateForm;

    If (Not Terminated) then
    Begin
      For n:=Low(MTMonRecs) to High(MTMonRecs) do {* Shut down any idle threads *}
        If (MTMonRecs[n].THAbort) then {* Terminate current thread, change to an index of currently selected job *}
          TerminateSlaveThread(n,BOn)
        else
          If (BeenTerminated[n]) then
            MainThreads[n]:=nil; {* Force abort *}
    end;


    If (IdleMode)  and (Not FlipFlop) and (Not StayVisible) and (Not ModalVisible) and (Not StillPreview) then
    Begin
      HideForm;
      ThreadNowIdle:=BOn;
      Suspend;
    end;

    SleepEx(1, True);

  end; {While..}

end;


{ The Execute method is called when the thread starts }

procedure TBackThread.Execute;


begin
  ExecuteOff:=BOff;

  try
    ScanBackgroundList;
  finally
    ExecuteOff:=BOn;
  end;

end;

procedure TBackThread.InitSync(const DPath : AnsiString);
begin
  DataPath := DPath;
  Synchronize(InitProc);
end;

function TBackThread.PrintSync(const ARef, AForm : AnsiString;
                                          AKey : longint;
                                          AttMethod : Byte) : ShortString;
begin

  OurRef := ARef;
  FormName := AForm;
  PrintKey := AKey;
  AttachMethod := AttMethod;

  Synchronize(PrintProc);

  Result := NameRec.sdFileName;

end;

procedure TBackThread.InitProc;
begin
  InitSBS(frmPrint, DataPath);
end;

procedure TBackThread.DeInitProc;
begin
  DeInitSBS;
end;

procedure TBackThread.DeInitSync;
begin
  Synchronize(DeInitProc);
end;

procedure TBackThread.PrintProc;
var
  EmailInfo : TEmailPrintInfoType;
  Res : Smallint;
begin
  FillChar(EmailInfo, SizeOf(EmailInfo), #0);
  EmailInfo.emPreview := False;
  EMailInfo.emCoverSheet := '';
  EmailInfo.emPriority := 1;
  FillChar(NameRec, SizeOf(NameRec), #0);

  if AddJob(PrintKey, OurRef, FormName) then
  begin
    Res := PrintToFile(@EmailInfo, @NameRec, SizeOf(EmailInfo), AttachMethod);
  end;


end;



procedure TBackThread.AddTask(PObj    :  Pointer;
                              PDesc   :  ShortString);

Begin
  If (Assigned(PObj)) then
  Begin
    WaitForLockList;

    With ThreadList do
      AddVisiRec(PObj,PDesc);

    Synchronize(UpdateFormTask);

    LockListUpdate:=BOff;
  end;
end;


Function Create_BackThread  :  Boolean;

Begin
  Result:=BOff;

  If (Not Assigned(BackThread)) then
  Begin
    BackThread:=TBackThread.Create;

    try

     BackThread.InitVars;

     If (Not Assigned(BackThread.AbortMsgList)) then
     Begin
       ShowMessage('BTrapped!');
     end;

    except

      BackThread.Free;
      BackThread:=nil;



    end; {Try..}
  end
  else
  Begin
    try
      BackThread.FlipFlop:=BOn;
      If (BackThread.Suspended) then
      Begin
        BackThread.Resume;
        BackThread.ThreadNowIdle:=BOff;
      end;
    except

      BackThread.Free;
      BackThread:=nil;
    end; {Try..}

  end;

  Result:=Assigned(BackThread);
end;




Procedure Set_BackThreadMVisible(State  :  Boolean);

Begin
  If (Assigned(BackThread)) then
    BackThread.ModalVisible:=State;

end;


Procedure Set_BackThreadFlip(State  :  Boolean);

Begin
  If (Assigned(BackThread)) then
    BackThread.FlipFlop:=State;
end;


Procedure Set_BackThreadSuspend(State  :  Boolean);

Var
  n  :  Byte;


Begin
  If (Assigned(BackThread)) then
  With BackThread do
  Begin
    {* Suspend/Resume all current threads pending a possible abort *}

    {* Suspend/resume main thread as well as otherwise it could still finish a print job and start another! *}
    If (State) then
    Begin
      If (Not Suspended) then
        Suspend
    end
    else
    Begin {* Resume only if main thread not genuinely suspended already due to no jobs *}
      If (Suspended) and (Not ThreadNowIdle) then  {* Only resume if was not currently idle *}
        Resume;
    end;

    For n:=Low(MainThreads) to High(MainThreads) do
      If (Assigned(MainThreads[n])) then
        With MainThreads[n] do {* Only suspend once, as suspends get nested *}
          try
            If (State) then
            Begin
              If (Not Suspended) and (Not ExecuteOff) and (Not MainFinish) then
                Suspend;
            end
            else
            Begin
              If (Suspended) then
                Resume;
            end;
          except
                MainThreads[n]:=nil;
          end; {try..}

  end;
end;



{$O+} {* Switch optimizer on *}

Initialization

  BackThread:=nil;

Finalization
end.
