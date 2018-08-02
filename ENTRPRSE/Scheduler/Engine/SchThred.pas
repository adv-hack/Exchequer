unit SchThred;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, ExBtTh1u, ElVar,  GlobVar, PostSp2U, VarConst, SchedVar, Enterprise01_TLB, CtkUtil,
  ActiveX, PostingU, JobPostU, SchCustm;

type

     TPollThread = Class(TElOpenThread)
     protected
       function GetTerminated : Boolean;
     public
       Constructor Create;
       Destructor  Destroy; override;
       procedure Execute; override;
       procedure SyncProgress;
       procedure SyncError;
       property IsTerminated : Boolean read GetTerminated;
     end;

     //Helper class
     TSchedFunctions = Class
       MTExLocal : TdPostExLocalPtr;
       OwnerName : string; //Name of task which owns this instance
       function SendEmail(const ASubject, AMessage : string) : integer;
     end;


     TSchedCheckNom = Object(TCheckNom)
       protected
         UnableToProcess : Boolean;
       public
         LTaskName : Str255;
         LNom : NominalRec;
         LFuncs : TSchedFunctions;
         Constructor Create(AOwner  :  TObject);
         destructor Destroy; virtual;
         Procedure Reset_ViewHistory; virtual;
         function LockTask : Integer;
         Procedure Finish;  Virtual;
         Procedure Process; Virtual;
         Function Start(NNom     :   NominalRec;
                        LCAMode  :   Byte)  :  Boolean;

       end;

       TSchedPost = Object(TEntPost)
       protected
         UnableToProcess : Boolean;
         FErrorMsg : string;
       public
         LTaskName : Str255;
         LiveCommit : Boolean;
         LFuncs : TSchedFunctions;
         LPostSeparate,
         LPostProtected : Boolean;
         LEmailTo : string;
         function LockTask : Integer;
         Procedure Finish;  Virtual;
         Procedure Process; Virtual;
         Function Start(LMode  :  Byte{;
                        PostParam
                            :  PostRepPtr})  :  Boolean;
         constructor Create(AOwner : TObject);
         destructor Destroy; virtual;
       end;

       TSchedJobPost = Object(TPostJob)
       protected
         UnableToProcess : Boolean;
       public
         LTaskName : Str255;
         LiveCommit : Boolean;
         LFuncs : TSchedFunctions;
         LPostSeparate,
         LPostProtected : Boolean;
         LEmailTo : string;
         function LockTask : Integer;
         Procedure Finish;  Virtual;
         Procedure Process; Virtual;
         Function Start(LMode  :  Byte{;
                        PostParam
                            :  PostRepPtr})  :  Boolean;
         constructor Create(AOwner : TObject);
         destructor Destroy; virtual;
       end;

       TSchedCustomTask = Object(TThreadQueue)
       protected
         UnableToProcess : Boolean;
       public
         LTaskName : Str255;
         LNom : NominalRec;
         LFuncs : TSchedFunctions;
         LClassName : string;
         LSchedEventsHandler : TExSchedCustom;
         LCID : Integer;
         Constructor Create(AOwner  :  TObject);
         destructor Destroy; virtual;
         function LockTask : Integer;
         Procedure Finish;  Virtual;
         Procedure Process; Virtual;
         Function Start  :  Boolean;
         procedure DoTaskProgress(const sMessage : WideString; iPercent : Integer);
         function CreateMTExLocal : Boolean;
       end;


   procedure AddELT2Q(AOwner : TObject; Ename, UserID : ShortString;
                      DataPath : AnsiString; APurpose : TSentinelPurpose; APriority : Byte);


   Procedure AddSchedCheckNom2Thread(AOwner   :  TObject;
                                     ANom     :  NominalRec;
                                     AJob     :  JobRecType;
                                     LCAM     :  Byte;
                                     DataPath :  string);

   Procedure AddSchedPost2Thread(LMode    :  Byte;
                                 AOwner   :  TObject;
                                 IncludeDocs : DocSetType;
                                 PostSep,
                                 PostProt :  Boolean;
                                 TaskName,
                                 DataPath,
                                 EmailTo :  string);

   Procedure AddSchedJobPost2Thread(LMode    :  Byte;
                                    AOwner   :  TObject;
                                    PostOpts : longint;
                                    PostSep,
                                    PostProt : Boolean;
                                    TaskName,
                                    DataPath,
                                    EmailTo :  string);

   Procedure AddCustomTask2Thread(AOwner   :  TObject;
                                  TaskName,
                                  ClassName,
                                  DataPath :  string);



var
  PollThread : TPollThread;
  SyncEmailProc : Procedure;

implementation

uses
  ExThrd2U, Forms, SysUtils, {RepObjCU, RepObjNU, RwFuncs, RwOpenF,}
   BtSupU1, Windows, EtStrU, Btrvu2, LogF, CommsInt, JobSup1U, EmailSet, ExScheduler_TLB, ComObj,
   GlobType, DllInt, HelpSupU, FileUtil, SQLUtils, Dialogs, BtKeys1U,
   ADOConnect, oProcessLock;

const
  BOn  = True;
  BOff = False;

{  ThreadDesc : Array[spQuery..spConveyor] of String[8] =
                 ('Running ', 'Sending ');
}
function ThreadDesc(Purpose : TSentinelPurpose) : String;
begin
end;

procedure AddELT2Q(AOwner : TObject; Ename, UserID : ShortString;
                      DataPath : AnsiString; APurpose : TSentinelPurpose;
                      APriority : Byte);
{var
  ELT1 : ^TElThread;}
begin
{  if APurpose in [spQuery, spConveyor, spReportConveyor, spReportQuery,
                  spCSVConveyor, spEmailCheck, spVisualReportConveyor] then
  begin
    New(ELT1, Create(AOwner));
    ELT1^.EName := Trim(EName);
    ELT1^.UserID := UserID;
    ELT1^.Purpose := APurpose;
    ELT1^.DataPath := DataPath;
    if APurpose in [spQuery, spReportQuery] then
      ELT1^.fPrintJob := True
    else
      ELT1^.fPrintJob := False;
    ELT1^.fSetPriority := True;
    if APurpose = spQuery then
    begin
      ELT1^.FTQNo := 1;
      Case APriority of
        0 : ELT1^.fPriority := tpLower;
        1 : ELT1^.fPriority := tpHigher;
        else
          ELT1^.fPriority := tpLower;
      end;
    end
    else
    begin
      ELT1^.FTQNo := 3;
      ELT1^.fPriority := tpNormal;
    end;

    if Create_BackThread then
    begin
       if ELT1^.Start then
         BackThread.AddTask(ELT1, ThreadDesc(APurpose) + Trim(Ename));
    end;
  end
  else //spReport
  begin
    //not used
  end;}
end;


Constructor TPollThread.Create;
begin
  inherited Create(True);
  Priority := tpLower;
  FreeOnTerminate := True;
  SyncProc := SyncProgress;
  SyncErr := SyncError;
end;

Destructor TPollThread.Destroy;
begin
  inherited Destroy;
end;

procedure TPollThread.Execute;
begin
  if Assigned(PollProc) then
//    Synchronize(PollProc);
    PollProc;
end;

procedure TPollThread.SyncProgress;
begin
  if Assigned(ProgressProc) then
    Synchronize(ProgressProc);
end;

function TPollThread.GetTerminated : Boolean;
begin
  Result := Terminated;
end;

procedure TPollThread.SyncError;
begin
  if Assigned(ErrorProc) then
    Synchronize(ErrorProc);
end;

Procedure AddSchedCheckNom2Thread(AOwner   :  TObject;
                                  ANom     :  NominalRec;
                                  AJob     :  JobRecType;
                                  LCAM     :  Byte;
                                  DataPath :  string);
Var
  LCheck_Nom :  ^TSchedCheckNom;
  Res : Integer;
Begin

  If (Create_BackThread) then
  Begin
    New(LCheck_Nom,Create(AOwner));
    try
      With LCheck_Nom^ do
      Begin
        LDataPath := DataPath;
        LNom := ANom;
        Res := 0;
        If (Start(ANom,LCAM)) and (Create_BackThread) then
        Begin
          FTQNo := 1;
          If (LCAM=7) then
            DelJobR:=AJob
          else
            If (LCAM=6) then
            begin
              tViewNo:=ANom.CarryF;
              LTaskName := ANom.AltCode;
            end;
            With BackThread do
              AddTask(LCheck_Nom,'Process task ' + Trim(LTaskName));
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LCheck_Nom,Destroy);
          DoLog('Unable to start task  ' + QuotedStr(Trim(ANom.AltCode)));
        end;
      end; {with..}

    except
      Dispose(LCheck_Nom,Destroy);

    end; {try..}
  end; {If process got ok..}

end;

Procedure AddSchedPost2Thread( LMode    :  Byte;
                               AOwner   :  TObject;
                               IncludeDocs : DocSetType;
                               PostSep,
                               PostProt :  Boolean;
                               TaskName,
                               DataPath,
                               EmailTo :  string);



Var
  EntPost  :  ^TSchedPost;

Begin

  If (Create_BackThread) then
  Begin
    New(EntPost,Create(AOwner));

    try
      With EntPost^ do
      Begin
          LDataPath := DataPath;
          LTaskName := TaskName;
          LEmailTo := EmailTo;

//        If (FormHandle is TForm) then {v4.40, overwrite fMyownhandle so we can send messages to the form}
//          fOwnHandle:=TForm(FormHandle).Handle;

        If (Start(LMode{,RPParam,PostParam,Ask})) and (Create_BackThread) then
        Begin
          FTQNo := 1;

          if IncludeDocs <> [] then
            PostRepCtrl^.IncDocFilt := IncludeDocs
          else
            PostRepCtrl^.NoIdCheck := BOn;

          LPostSeparate := PostSep;
          LPostProtected := PostProt;

          With BackThread do
            AddTask(EntPost,'Process task ' + Trim(LTaskName));

        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntPost,Destroy);
          DoLog('Unable to start task  ' + QuotedStr(Trim(LTaskName)));
        end;
      end; {with..}

    except
      Dispose(EntPost,Destroy);

    end; {try..}
  end; {If process got ok..}

end;

Procedure AddSchedJobPost2Thread(LMode    :  Byte;
                                 AOwner   :  TObject;
                                 PostOpts : longint;
                                 PostSep,
                                 PostProt : Boolean;
                                 TaskName,
                                 DataPath,
                                 EmailTo :  string);
  Var
    LPost :  ^TSchedJobPost;
    JPostCtrl  :  JInvHedRec;
    SMode  :  Byte;
  Begin

    If (Create_BackThread) then
    Begin
      New(LPost,Create(AOwner));

      try
        FillChar(JPostCtrl, SizeOf(JPostCtrl), 0);
        With JPostCtrl do
        Begin
          ChkComm:= PostOpts and jpCommitment = jpCommitment;
          PostJD:=PostOpts and jpActuals = jpActuals;
          ChkExpRet:=PostOpts and jpRetentions = jpRetentions;

          SMode:=1+(2*Ord(PostOpts and jpTimesheets = jpTimesheets));

        end;

        With LPost^ do
        Begin
          FTQNo := 1;
          JCloseCtrlRec^:= JPostCtrl;
          LDataPath := DataPath;
          LTaskName := TaskName;
          LEmailTo := EmailTo;
//        ThisJobCode:=JCode;

          LPostSeparate := PostSep;
          LPostProtected := PostProt;

          ThisJobCode := '';
          If (Start(SMode)) and (Create_BackThread) then
          Begin



            With BackThread do
              AddTask(LPost,'Job Post');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LPost,Destroy);
          end;
        end; {with..}

      except
        Dispose(LPost,Destroy);

      end; {try..}
    end; {If process got ok..}

end;

Procedure AddCustomTask2Thread(AOwner   :  TObject;
                               TaskName,
                               ClassName,
                               DataPath :  string);

Var
  LTask :  ^TSchedCustomTask;
Begin

  If (Create_BackThread) then
  Begin
    New(LTask,Create(AOwner));

    try

      With LTask^ do
      Begin
        FTQNo := 3;
        LCID := 3;
        LDataPath := DataPath;
        LTaskName := TaskName;
        LClassName := ClassName;
//        ThisJobCode:=JCode;
        If (Start) and (Create_BackThread) then
        Begin



          With BackThread do
            AddTask(LTask,LTaskName);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(LTask,Destroy);
        end;
      end; {with..}

    except
      Dispose(LTask,Destroy);

    end; {try..}
  end; {If process got ok..}

end;



{ TSchedCheckNom }

constructor TSchedCheckNom.Create(AOwner: TObject);
begin
  UnableToProcess := False;
  inherited Create(AOwner);
  IsParentTo := True;
  LFuncs := TSchedFunctions.Create;
end;

destructor TSchedCheckNom.Destroy;
begin
  if Assigned(LFuncs) then
    LFuncs.Free;
  inherited;
end;

procedure TSchedCheckNom.Finish;
var
  Res : Integer;
begin
  with MTExLocal^ do
  begin
    if LTaskRec.stStatus <> tsError then //if it was an error then
    begin
      LTaskRec.stRestartCount := 0;
      if not UnableToProcess then
      begin
        LTaskRec.stStatus := tsIdle;
        LTaskRec.stLastRun := Now;
        LTaskRec.stNextRunDue := DT2Str(FindNextRunDue(LTaskRec));
        Res := LPut_Rec(TaskF, 0);
        RemoveInUse(LSetDrive, LTaskRec.stTaskName);
        ThreadDoLog('Task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + ' finished.');
      end
      else
      begin
        LTaskRec.stStatus := tsIdle;
        Res := LPut_Rec(TaskF, 0);
        ThreadDoLog('Unable to run task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + '. Ready to run again');
      end;
    end;
  end;

  inherited Finish;
  If  Assigned(PostExLocal) then //close files and destroy
  begin
    PostExLocal^.Close_Files;
    Dispose(PostExLocal, Destroy);
    PostExLocal := nil;
  end;

  Close_file(F[NomF]);
  Close_file(F[SysF]);

//  Dispose(MTExLocal, Destroy);
  MTExLocal := nil;
end;

function TSchedCheckNom.LockTask: Integer;
var
  KeyS : Str255;
begin
  KeyS := LJVar(LTaskName, 50);
  with MTExLocal^ do
    Result := LFind_Rec(B_GetEq + B_SingNWLock, TaskF, 0, KeyS);
end;

procedure TSchedCheckNom.Process;
var
  s : string;
  Res, Res2 : Integer;
  bRes : Boolean;
  KeyS : Str255;
begin
{  If  Assigned(PostExLocal) then //close files and destroy
  begin
    PostExLocal^.Close_Files;
    Dispose(PostExLocal, Destroy);
    PostExLocal := nil;
    Close_file(F[NomF]);
  end;}
  bRes := Create_ThreadFiles(LDataPath); //Open files
  If bRes then
  begin
    MTExLocal:=PostExLocal;
    LFuncs.MTExLocal := MTExLocal;
    MTExLocal^.LNom:=LNom;
    SetDrive := LDataPath;
    Open_System(NomF, NomF);
    Open_System(SysF, SysF);
    bRes := False;
    GetMultiSys(False, bRes, SysR);
    EntryRec^.Login := 'SCHEDULER';
    Res := LockTask;
    if Res <> 0 then
    begin
      KeyS := LTaskName;
      Res2 := MTExLocal^.LFind_Rec(B_GetEq, TaskF, 0, KeyS);
      ThreadDoLog('Unable to lock task record. Error ' + IntToStr(Res) + QuotedStr(Trim(LTaskName)));
      if Res2 = 0 then
        LFuncs.SendEmail('Problem with scheduled task ' + QuotedStr(Trim(LTaskName)),
                     SchedErrMessage +
                     'Unable to lock task record. Error ' + IntToStr(Res) )
      else
        ThreadDoLog('Unable to send notification email');
      UnableToProcess := True;
      RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
    end
    else
    Try
      inherited Process;
    Except
      on E:Exception do
      begin
        with MTExLocal^ do
        begin
          LTaskRec.stStatus := tsError;
          Res := LPut_Rec(TaskF, 0);
          //Log error and Send email
          ThreadDoLog(E.Message);
          //email
          LFuncs.SendEmail('Error in scheduled task ' + QuotedStr(Trim(LTaskRec.stTaskName)),
                    SchedErrMessage + E.Message);
          RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
        end;
      end;
    End;
  end;
end;


procedure TSchedCheckNom.Reset_ViewHistory;
 Const
   Fnum      =  NomViewF;
   Keypath   =  NVCodeK;


 Var
   KeyChk,
   KeyS      :  Str255;

   LOk,
   Locked    :  Boolean;

   Res,
   ItemCount :  LongInt;


 Begin
   {$IFDEF EXSQL}
     If SQLUtils.UsingSQLAlternateFuncs Then
     Begin
       If (tViewNo <> 0) then
         // Zero down specific Nominal View
         // CJS 2011-08-04 ABSEXCH-11373 - Added Client ID to call
         Res := ResetViewHistory(LDataPath, tViewNo, MTExLocal^.ExClientId)
       Else
         // Zero down all Nominal Views
         // CJS 2011-08-04 ABSEXCH-11373 - Added Client ID to call
         Res := ResetViewHistory(LDataPath, 0, MTExLocal^.ExClientId);
       If (Res < 0) Then
         raise Exception.Create('TCheckNom.Reset_ViewHistory: ResetViewHistory failed for ' + IntToStr(tViewNo) + ' with an error ' + SQLUtils.LastSQLError);
     End // If SQLUtils.UsingSQLAlternateFuncs
     Else
   {$ENDIF}
     Begin
       KeyChk:=PartCCKey(NVRCode,NVVSCode);

       If (tViewNo<>0) then {* One view only *}
         KeyChk:=KeyChk+FullNomKey(tViewNo);

       KeyS:=KeyChk;

       ItemCount:=0;

       Locked:=BOff;

       With MTEXLocal^ do
       Begin
         LStatus:=LFind_Rec(B_GetGEq,Fnum,keypath,KeyS);

         While (LStatusOk) and (Not ThreadRec^.THAbort) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
         With LNomView^.NomViewLine do
         Begin
           Inc(ItemCount);

           UpdateProgress(ItemCount);


           Reset_NomViewActual;

           LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);
         end; {While..}
       end; {With.}
     End;
end;

function TSchedCheckNom.Start(NNom: NominalRec; LCAMode: Byte): Boolean;
begin
  LFuncs.OwnerName := LTaskName;
  UCode:=NNom.NomCode;
  CheckActMode:=LCAMode;

  //PR: 05/06/2017 ABSEXCH-18683 v2017 R1 Check process lock before running
  Result:= GetProcessLockWithRetry(plUpdateGLViews);
  if Result then
    ProcessLockType := plUpdateGLViews
  else
  begin
    //Call finish method to reset status so task will run again automatically
    //Need to create ExLocal for finish
    Create_ThreadFiles(LDataPath); //Open files
    MTExLocal:=PostExLocal;

    UnableToProcess := True;
    LockTask;
    Finish;
  end;
end;

{ TSchedPost }

constructor TSchedPost.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  fTQNo:=1;
  fCanAbort:=BOn;

  fPriority:=tpNormal;
  fSetPriority:=BOn;
  LFuncs := TSchedFunctions.Create;

  LPostSeparate := False;
  LPostProtected := False;
//  PostLog := nil;
end;

destructor TSchedPost.Destroy;
begin
  if Assigned(LFuncs) then
    LFuncs.Free;
  inherited;
end;

procedure TSchedPost.Finish;
var
  Res : Integer;
  sFilename : string;
begin
  with MTExLocal^ do
  begin
    if LTaskRec.stStatus <> tsError then //if it wasn't an error then
    begin
      LTaskRec.stRestartCount := 0;
      if not UnableToProcess then
      begin
        //PR: 15/12/2010 ABSEXCH-10543 After running delete tasks sent from Exchequer
        if LTaskRec.stOneTimeOnly then
          Res := LDelete_Rec(TaskF, 0)
        else
        begin
          LTaskRec.stStatus := tsIdle;
          LTaskRec.stLastRun := Now;
          LTaskRec.stNextRunDue := DT2Str(FindNextRunDue(LTaskRec));
          Res := LPut_Rec(TaskF, 0);
        end;
        RemoveInUse(LSetDrive, LTaskRec.stTaskName);
        ThreadDoLog('Task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + ' finished.');
        sbsForm_DeInitialise;
      end
      else
      begin
        LTaskRec.stStatus := tsIdle;
        Res := LPut_Rec(TaskF, 0);
        ThreadDoLog('Unable to run task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + '. Ready to run again');
      end;
    end;
  end;

  inherited Finish;
  If  Assigned(PostExLocal) then //close files and destroy
  begin
    PostExLocal^.Close_Files;
    Dispose(PostExLocal, Destroy);
    PostExLocal := nil;
  end;


  if LiveCommit then
  begin
    If  Assigned(LCommitExLocal) then //close files and destroy
    begin
      LCommitExLocal^.Close_Files;
      Dispose(LCommitExLocal, Destroy);
      LCommitExLocal := nil;
    end;
  end;

  Close_file(F[NomF]);
  Close_file(F[NHistF]);
  Close_file(F[SysF]);

  MTExLocal := nil;
end;

function TSchedPost.LockTask: Integer;
var
  KeyS : Str255;
begin
  KeyS := LJVar(LTaskName, 50);
  with MTExLocal^ do
    Result := LFind_Rec(B_GetEq + B_SingNWLock, TaskF, 0, KeyS);
end;

procedure TSchedPost.Process;
var
  bRes : Boolean;
  Res, Res2 : Integer;
  KeyS : Str255;
  SysLock : Boolean;
  NewRunNo : longint;
  EmailSettings : TEmailSettings;
  bTemp : Boolean;
begin
  bRes := False;

  //AP:31/01/2018 ABSEXCH-19680 CLONE-Postings through Scheduler failing for transactions where a line has a VAT code D or A
  //RB:21/06/2018 ABSEXCH-20840 PSQL > Scheduler > Daybook posting is not working 
  if UsingSQL then
    InitialiseGlobalADOConnection(LDataPath);
  
  If (LiveCommit) then
  Begin
    If (Not Assigned(LCommitExLocal)) then { Open up files here }
      bRes:=Create_LiveCommitFiles(LDataPath);

    If (bRes) then
      MTExLocal:=LCommitExLocal;
  end
  else
  Begin
    If (Not Assigned(PostExLocal)) then { Open up files here }
      bRes:=Create_ThreadFiles(LDataPath);

    If (bRes) then
      MTExLocal:=PostExLocal;
  end;


  If (bRes) then {* Check if we can lock it *}
  begin
    SetDrive := LDataPath;
    Open_System(NomF, NomF);
    Open_System(NHistF, NHistF);
    Open_System(SysF, SysF);
    Open_System(IncF, IncF);
{    bRes := False;
    GetMultiSys(False, bRes, SysR);
    GetMultiSys(False, bRes, CurR);
    GetMultiSys(False, bRes, FormR);
    GetMultiSys(False, bRes, VATR);}
    Init_AllSys;
    Syss.SepRunPost := LPostSeparate;
    Syss.ProtectPost := LPostProtected;
    TranOK2Run := False;
    //Get the next run number without updating it, so we can use it in the
    //subject for the email of any Auto Transactions
    NewRunNo := MTExLocal^.LGetNextCount(RUN, False, False, 0);

    FPaperlessAvailable := Check_ModRel(8,BOn);

    EmailSettings := TEmailSettings.Create;
    EmailSettings.esDataPath := LDataPath;

    Try
      if (Trim(LEmailTo) <> '') and FPaperlessAvailable then
      begin
          PostRepCtrl.PParam.PDevRec.feEmailSubj :=
            'Auto Transactions from Posting Run ' + IntToStr(NewRunNo);
          PostRepCtrl.PParam.PDevRec.fePrintMethod := 2; //email
          PostRepCtrl.PParam.PDevRec.feEmailPriority := 1; //normal
          PostRepCtrl.PParam.PDevRec.feEmailAtType := EmailSettings.esAttachmentType;
          PostRepCtrl.PParam.PDevRec.feEmailMAPI := EmailSettings.esUseMapi;
          if Trim(LEmailTo) <> '' then
            PostRepCtrl.PParam.PDevRec.feEmailTo := LEmailTo + ';' + LEmailTo + ';';
          if not PostRepCtrl.PParam.PDevRec.feEmailMAPI then
          begin
            PostRepCtrl.PParam.PDevRec.feEmailFromAd := EmailSettings.esSenderName;
            PostRepCtrl.PParam.PDevRec.feEmailFrom := EmailSettings.esSender;
          end;
      end //Paperless available
      else
      begin
        PostRepCtrl.PParam.PDevRec.fePrintMethod := 4; //to file
        PostRepCtrl.PParam.PDevRec.feEmailAtType := EmailSettings.esAttachmentType;
        PostRepCtrl.PParam.PDevRec.feOutputFileName := LDataPath +
                    'Reports\' + Trim(LTaskName) + ' ' + IntToStr(NewRunNo) + EmailSettings.esAttachmentExt;
      end;

    Finally
      EmailSettings.Free;
    End;

    PostRepCtrl.PParam.PDevRec.Preview := False;

    With SystemInfo Do Begin
      ExVersionNo      := 11;
      MainForm         := Application.MainForm;
      AppHandle        := Application;
      ExDataPath       := LDataPath;
      ControllerHandle := Nil;
      DefaultFont      := Nil;
      DebugOpen        := False;
    End; { With }
    sbsForm_Initialise(SystemInfo, bTemp);

    If (Syss.ProtectPost) then
    Begin
      fPriority:=tpHigher;
      fSetPriority:=BOn;
    end;
    With MTExLocal^, PostRepCtrl^ do
    Begin
      LFuncs.MTExLocal := MTExLocal;

      If (Not LiveCommit) then
      Begin
        bRes:=PostLockCtrl(PostMode);

        If (bRes) then
          LastRunNo:=CheckAbortedRun;

        If (LastRunNo<>0) and (Syss.ProtectPost) and (bRes) then
        With LMiscRecs^,MultiLocRec do
        Begin
  {          ShowMessage('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                      'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC+#13+#13+
                      'Attempting to complete this posting run now.');

          AddErrorLog('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                      'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC,'',4);}
        end;
      end;

      If  (bRes) then
      Begin
        If (Syss.ProtectPost) and (BTFileVer>=6) then
        Begin
          If (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(1)
          else
            LStatus:=0;

          TranOk2Run:=LStatusOk or (LStatus=37) {* Is already running *};

          If (Not TranOk2Run) then
          Begin
  {             AddErrorLog('Posting Run. Protected Mode could not be started. (Error '+Form_Int(LStatus,0)+')','',4);

             LReport_BError(InvF,LStatus);

             Result:=(CustomDlg(Application.MainForm,'WARNING!','Posting Transactions',
                             'It was not possible to start Protected Mode Posting due to an error. '+
                             Form_Int(LStatus,0)+'.'#13+
                             'Do you wish to continue posting without Protected Mode?',
                             mtWarning,
                             [mbYes,mbNo]
                             )=mrOk);}


          end;

          If (LStatusOk) and (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(0);

        end;

        If (bRes) and Not (LiveCommit) then {* Check for valid NCC *}
        Begin
          bRes:=CheckValidNCC(CommitAct);

          If (Not bRes) then
          Begin
            FErrorMsg := 'One or more of the General Ledger Control Codes is not valid';
  {            AddErrorLog('Post Transactions. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

            CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                           'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                           'Posting cannot continue until this problem has been rectified.'+#13+#13+
                           'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                           mtError,
                           [mbOk]);}


          end;

        end;

        If (Not bRes) then {* Remove lock... *}
          PostUnLock(0);

      end
      else
        TranOk2Run:=BOff;

    end;
  end;


  if bRes then
  begin

    EntryRec^.Login := 'SCHEDULER';
    Res := LockTask;
    if Res <> 0 then
    begin
      KeyS := LTaskName;
      Res2 := MTExLocal^.LFind_Rec(B_GetEq, TaskF, 0, KeyS);
      ThreadDoLog('Unable to lock task record. Error ' + IntToStr(Res) + QuotedStr(Trim(LTaskName)));
      if Res2 = 0 then
        LFuncs.SendEmail('Problem with scheduled task ' + QuotedStr(Trim(LTaskName)),
                     SchedErrMessage +
                     'Unable to lock task record. Error ' + IntToStr(Res) )
      else
        ThreadDoLog('Unable to send notification email');
      UnableToProcess := True;
      RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
    end
    else
    Try
      ReportDataPath := MTExLocal^.LSetDrive;
      inherited Process;
    Except
      on E:Exception do
      begin
        with MTExLocal^ do
        begin
          LTaskRec.stStatus := tsError;
          Res := LPut_Rec(TaskF, 0);
          //Log error and Send email
          ThreadDoLog(E.Message);
          //email
          LFuncs.SendEmail('Error in scheduled task ' + QuotedStr(Trim(LTaskRec.stTaskName)),
                    SchedErrMessage + E.Message);
          RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
        end;
      end;
    End;
  end
  else
  begin
    ThreadDoLog('Problem with Task ' + QuotedStr(Trim(LTaskName) + ': ' + FErrorMsg));
    MTExLocal^.LTaskRec.stStatus := tsError;
    Res := MTExLocal^.LPut_Rec(TaskF, 0);
    if Res <> 0 then
      ThreadDoLog('Unable to update Task Status. Error ' + IntToStr(Res));
    UnableToProcess := True;
    RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
  end;
end;


function TSchedPost.Start(LMode  :  Byte{;
                          PostParam
                                 :  PostRepPtr})  :  Boolean;
Begin
  PostMode:=LMode;
  LFuncs.OwnerName := LTaskName;
  LiveCommit:=(LMode=50) and (CommitAct);

  //PR: 05/06/2017 ABSEXCH-18683 v2017 R1 Check process lock before running
  Result:= GetProcessLockWithRetry(plDaybookPost);
  if Result then
  begin
    ProcessLockType := plDaybookPost;
    //PR: 12/01/2018 ABSEXCH-19316 Check for new SQL Posting availability
    UseSQLPost := CanPostUsingSQL(LMode);
  end
  else
  begin
    //Call finish method to reset status so task will run again automatically
    //Call finish method to reset status so task will run again automatically
    //Need to create ExLocal for finish
    Create_ThreadFiles(LDataPath); //Open files
    MTExLocal:=PostExLocal;

    UnableToProcess := True;
    LockTask;
    Finish;
  end;
end;

{ TSchedFunctions }

function TSchedFunctions.SendEmail(const ASubject,
  AMessage: string): integer;
var
  EntEmail : TEntEmail;
  Res : Integer;
  EmailSettings : TEmailSettings;
begin
  Result := 0;
  if Trim(MTExLocal^.LTaskRec.stEmailAddress) <> '' then
  begin
    Result := -1;

    EntEmail := TEntEmail.Create;
    EmailSettings := TEmailSettings.Create;
    EmailSettings.esDataPath := MTExLocal^.LSetDrive;
    Try
      EntEmail.SuppressMessages := True; //Don't show error messages
      EntEmail.Recipients.Add(Trim(MTExLocal^.LTaskRec.stEmailAddress));
      EntEmail.Subject := ASubject;
      EntEmail.Message := PChar(AMessage);

      EntEmail.UseMAPI := EmailSettings.esUseMAPI;
      if not EntEmail.UseMAPI then
      begin
        EntEmail.Sender := EmailSettings.esSender;
        EntEmail.SenderName := EmailSettings.esSenderName;
        EntEmail.SMTPServer := EmailSettings.esSMTPServer;
        if (Trim(EntEmail.Sender) = '') or (Trim(EntEmail.SMTPServer) = '') then
          Result := -2;
      end;

      if Result = 0 then
        Result := EntEmail.Send(False); //False means don't auto-unload the dll
    Finally
      EntEmail.Free;
      EmailSettings.Free;
    End;
  end;
end;

{ TSchedJobPost }

constructor TSchedJobPost.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  fTQNo:=1;
  fCanAbort:=BOn;

  fPriority:=tpNormal;
  fSetPriority:=BOn;
  LFuncs := TSchedFunctions.Create;

  LPostSeparate := False;
  LPostProtected := False;
end;

destructor TSchedJobPost.Destroy;
begin
  if Assigned(LFuncs) then
    LFuncs.Free;
  inherited;
end;

procedure TSchedJobPost.Finish;
var
  Res : Integer;
begin
  with MTExLocal^ do
  begin
    if LTaskRec.stStatus <> tsError then //if it wasn't an error then
    begin
      LTaskRec.stRestartCount := 0;
      if not UnableToProcess then
      begin
        //PR: 15/12/2010 ABSEXCH-10543 After running delete tasks sent from Exchequer
        if LTaskRec.stOneTimeOnly then
          Res := LDelete_Rec(TaskF, 0)
        else
        begin
          LTaskRec.stStatus := tsIdle;
          LTaskRec.stLastRun := Now;
          LTaskRec.stNextRunDue := DT2Str(FindNextRunDue(LTaskRec));
          Res := LPut_Rec(TaskF, 0);
        end;
        RemoveInUse(LSetDrive, LTaskRec.stTaskName);
        ThreadDoLog('Task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + ' finished.');
        sbsForm_DeInitialise;
      end
      else
      begin
        LTaskRec.stStatus := tsIdle;
        Res := LPut_Rec(TaskF, 0);
        ThreadDoLog('Unable to run task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + '. Ready to run again');
      end;
    end;
  end;

  inherited Finish;
  If  Assigned(PostExLocal) then //close files and destroy
  begin
    PostExLocal^.Close_Files;
    Dispose(PostExLocal, Destroy);
    PostExLocal := nil;
  end;


  if LiveCommit then
  begin
    If  Assigned(LCommitExLocal) then //close files and destroy
    begin
      LCommitExLocal^.Close_Files;
      Dispose(LCommitExLocal, Destroy);
      LCommitExLocal := nil;
    end;
  end;

  Close_file(F[NomF]);
  Close_file(F[NHistF]);
  Close_file(F[SysF]);

  MTExLocal := nil;

  //PR: 25/04/2016 ABSEXCH-17370 Close and free ado connection
  TerminateGlobalADOConnection;
end;

function TSchedJobPost.LockTask: Integer;
var
  KeyS : Str255;
begin
  KeyS := LJVar(LTaskName, 50);
  with MTExLocal^ do
    Result := LFind_Rec(B_GetEq + B_SingNWLock, TaskF, 0, KeyS);
end;

procedure TSchedJobPost.Process;
var
  bRes : Boolean;
  Res, Res2 : Integer;
  KeyS : Str255;
  NewRunNo : longint;
  EmailSettings : TEmailSettings;
  bTemp : Boolean;
begin
  bRes := True;

  //PR: 25/04/2016 ABSEXCH-17370 Need to create global ado connection as it is used in
  //                             JobPostU.DeleteHistory
  //RB:27/06/2018 ABSEXCH-20840 PSQL > Scheduler > Daybook posting is not working
  if UsingSQL then
    InitialiseGlobalADOConnection(LDataPath);
(*  If (LiveCommit) then
  Begin
    If (Not Assigned(LCommitExLocal)) then { Open up files here }
      bRes:=Create_LiveCommitFiles(LDataPath);

    If (bRes) then
      MTExLocal:=LCommitExLocal;
  end
  else *)
  Begin
    If (Not Assigned(PostExLocal)) then { Open up files here }
      bRes:=Create_ThreadFiles(LDataPath);

    If (bRes) then
      MTExLocal:=PostExLocal;
  end;


  If (bRes) then {* Check if we can lock it *}
  begin
    SetDrive := LDataPath;
    Open_System(NomF, NomF);
    Open_System(NHistF, NHistF);
    Open_System(SysF, SysF);
    Open_System(IncF, IncF);
    bRes := False;
    Init_AllSys;
    Syss.SepRunPost := LPostSeparate;
    Syss.ProtectPost := LPostProtected;
    TranOK2Run := False;
    //Get the next run number without updating it, so we can use it in the
    //subject for the email of any Auto Transactions
    NewRunNo := MTExLocal^.LGetNextCount(RUN, False, False, 0);

    FPaperlessAvailable := Check_ModRel(8,BOn);

    EmailSettings := TEmailSettings.Create;
    EmailSettings.esDataPath := LDataPath;

    Try
      if (Trim(LEmailTo) <> '') and FPaperlessAvailable then
      begin
          PostRepCtrl.PParam.PDevRec.feEmailSubj :=
            'Auto Transactions from Posting Run ' + IntToStr(NewRunNo);
          PostRepCtrl.PParam.PDevRec.fePrintMethod := 2; //email
          PostRepCtrl.PParam.PDevRec.feEmailPriority := 1; //normal
          PostRepCtrl.PParam.PDevRec.feEmailAtType := EmailSettings.esAttachmentType;
          PostRepCtrl.PParam.PDevRec.feEmailMAPI := EmailSettings.esUseMapi;
          if Trim(LEmailTo) <> '' then
            PostRepCtrl.PParam.PDevRec.feEmailTo := LEmailTo + ';' + LEmailTo + ';';
          if not PostRepCtrl.PParam.PDevRec.feEmailMAPI then
          begin
            PostRepCtrl.PParam.PDevRec.feEmailFromAd := EmailSettings.esSenderName;
            PostRepCtrl.PParam.PDevRec.feEmailFrom := EmailSettings.esSender;
          end;
      end //Paperless available
      else
      begin
        PostRepCtrl.PParam.PDevRec.fePrintMethod := 4; //to file
        PostRepCtrl.PParam.PDevRec.feEmailAtType := EmailSettings.esAttachmentType;
        PostRepCtrl.PParam.PDevRec.feOutputFileName := LDataPath +
                    'Reports\' + Trim(LTaskName) + ' ' + IntToStr(NewRunNo) + EmailSettings.esAttachmentExt;
      end;

    Finally
      EmailSettings.Free;
    End;

    PostRepCtrl.PParam.PDevRec.Preview := False;

    With SystemInfo Do Begin
      ExVersionNo      := 11;
      MainForm         := Application.MainForm;
      AppHandle        := Application;
      ExDataPath       := LDataPath;
      ControllerHandle := Nil;
      DefaultFont      := Nil;
      DebugOpen        := False;
    End; { With }
    sbsForm_Initialise(SystemInfo, bTemp);

    TranOK2Run := False;
    If (Syss.ProtectPost) then
    Begin
      fPriority:=tpHigher;
      fSetPriority:=BOn;
    end;
    With MTExLocal^, PostRepCtrl^ do
    Begin
      LFuncs.MTExLocal := MTExLocal;

      If (Not LiveCommit) then
      Begin
        bRes:=PostLockCtrl(PostMode);

        If (bRes) then
          LastRunNo:=CheckAbortedRun;

        If (LastRunNo<>0) and (Syss.ProtectPost) and (bRes) then
        With LMiscRecs^,MultiLocRec do
        Begin
  {          ShowMessage('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                      'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC+#13+#13+
                      'Attempting to complete this posting run now.');

          AddErrorLog('Posting Run '+Form_Int(LastRunNo,0)+' did not finish correctly.'+#13+
                      'The posting run was started by user '+Trim(LOCDESC)+' on '+LOCFDESC,'',4);}
        end;
      end;

      If  (bRes) then
      Begin
        If (Syss.ProtectPost) and (BTFileVer>=6) then
        Begin
          If (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(1)
          else
            LStatus:=0;

          TranOk2Run:=LStatusOk or (LStatus=37) {* Is already running *};

          If (Not TranOk2Run) then
          Begin
  {             AddErrorLog('Posting Run. Protected Mode could not be started. (Error '+Form_Int(LStatus,0)+')','',4);

             LReport_BError(InvF,LStatus);

             Result:=(CustomDlg(Application.MainForm,'WARNING!','Posting Transactions',
                             'It was not possible to start Protected Mode Posting due to an error. '+
                             Form_Int(LStatus,0)+'.'#13+
                             'Do you wish to continue posting without Protected Mode?',
                             mtWarning,
                             [mbYes,mbNo]
                             )=mrOk);}


          end;

          If (LStatusOk) and (Not AlreadyInPost) then
            LStatus:=LCtrl_BTrans(0);

        end;

        If (bRes) and Not (LiveCommit) then {* Check for valid NCC *}
        Begin
          bRes:=CheckValidNCC(CommitAct);

          If (Not bRes) then
          Begin
  {            AddErrorLog('Post Transactions. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

            CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                           'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                           'Posting cannot continue until this problem has been rectified.'+#13+#13+
                           'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                           mtError,
                           [mbOk]);}


          end;

        end;

        If (Not bRes) then {* Remove lock... *}
          PostUnLock(0);

      end
      else
        TranOk2Run:=BOff;

    end;
  end;


  if bRes then
  begin

    EntryRec^.Login := 'SCHEDULER';
    Res := LockTask;
    if Res <> 0 then
    begin
      KeyS := LTaskName;
      Res2 := MTExLocal^.LFind_Rec(B_GetEq, TaskF, 0, KeyS);
      ThreadDoLog('Unable to lock task record. Error ' + IntToStr(Res) + QuotedStr(Trim(LTaskName)));
      if Res2 = 0 then
        LFuncs.SendEmail('Problem with scheduled task ' + QuotedStr(Trim(LTaskName)),
                     SchedErrMessage +
                     'Unable to lock task record. Error ' + IntToStr(Res) )
      else
        ThreadDoLog('Unable to send notification email');
      UnableToProcess := True;
      RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
    end
    else
    Try
      inherited Process;
    Except
      on E:Exception do
      begin
        with MTExLocal^ do
        begin
          LTaskRec.stStatus := tsError;
          Res := LPut_Rec(TaskF, 0);
          //Log error and Send email
          ThreadDoLog(E.Message);
          //email
          LFuncs.SendEmail('Error in scheduled task ' + QuotedStr(Trim(LTaskRec.stTaskName)),
                    SchedErrMessage + E.Message);
          RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
        end;
      end;
    End;
  end;
end;

function TSchedJobPost.Start(LMode: Byte): Boolean;
var
  EmailSettings : TEmailSettings;
  bTemp : Boolean;
begin
  LFuncs.OwnerName := LTaskName;
  PostMode:=LMode;
  SPMode := LMode;

  //PR: 05/06/2017 ABSEXCH-18683 v2017 R1 Check process lock before running
  Result:= GetProcessLockWithRetry(plDaybookPost);
  if Result then
    ProcessLockType := plDaybookPost
  else
  begin
    //Call finish method to reset status so task will run again automatically
    //Need to create ExLocal for finish
    Create_ThreadFiles(LDataPath); //Open files
    MTExLocal:=PostExLocal;

    UnableToProcess := True;
    LockTask;
    Finish;
  end;
end;

{ TSchedCustomTask }

constructor TSchedCustomTask.Create(AOwner: TObject);
begin
  inherited Create(AOwner);
  fTQNo:=1;
  fCanAbort:=BOn;

  fPriority:=tpNormal;
  fSetPriority:=BOn;
  LFuncs := TSchedFunctions.Create;

end;

function TSchedCustomTask.CreateMTExLocal: Boolean;
Begin
  Result:=BOff;

  New(MTExLocal);

  With MTExLocal^ do
  Begin
    try
      Create(60);
      LSetDrive := LDataPath;
      Open_System(TaskF,TaskF);

      Result:=BOn;
    except
      MTExLocal:=nil;
      Result:=BOff;
    end; {try..}

  end;

end;

destructor TSchedCustomTask.Destroy;
begin

end;

procedure TSchedCustomTask.DoTaskProgress(const sMessage: WideString; iPercent : Integer);
var
  s : ShortString;
begin
  s := sMessage;
  ShowStatus(2, Trim(s));
  UpdateProgress(iPercent);
end;

procedure TSchedCustomTask.Finish;
var
  Res : Integer;
begin
  with MTExLocal^ do
  begin
    if LTaskRec.stStatus <> tsError then //if it was an error then
    begin
      LTaskRec.stRestartCount := 0;
      if not UnableToProcess then
      begin
        LTaskRec.stStatus := tsIdle;
        LTaskRec.stLastRun := Now;
        LTaskRec.stNextRunDue := DT2Str(FindNextRunDue(LTaskRec));
        Res := LPut_Rec(TaskF, 0);
        RemoveInUse(LSetDrive, LTaskRec.stTaskName);
        ThreadDoLog('Task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + ' finished.');
      end
      else
      begin
        LTaskRec.stStatus := tsIdle;
        Res := LPut_Rec(TaskF, 0);
        ThreadDoLog('Unable to run task ' + QuotedStr(Trim(LTaskRec.stTaskName)) + '. Ready to run again');
      end;
    end;
  end;

  inherited Finish;
  If  Assigned(MTExLocal) then //close files and destroy
  begin
    MTExLocal^.Close_Files;
    Dispose(MTExLocal, Destroy);
    MTExLocal := nil;
  end;


end;

function TSchedCustomTask.LockTask: Integer;
var
  KeyS : Str255;
begin
  KeyS := LJVar(LTaskName, 50);
  with MTExLocal^ do
    Result := LFind_Rec(B_GetEq + B_SingNWLock, TaskF, 0, KeyS);
end;

procedure TSchedCustomTask.Process;
var
  oTask : IScheduledTask;
  i : integer;
  AList : TStringList;
  bRes : Boolean;
  Res, Res2 : Integer;
  KeyS : Str255;
  ErrStr : string;
begin
  bRes := CreateMTExLocal; //Open files
  If bRes then
  begin
//    MTExLocal:=PostExLocal;
    EntryRec^.Login := 'SCHEDULER';
    Res := LockTask;
    if Res <> 0 then
    begin
      KeyS := LTaskName;
      Res2 := MTExLocal^.LFind_Rec(B_GetEq, TaskF, 0, KeyS);
      ThreadDoLog('Unable to lock task record. Error ' + IntToStr(Res) + QuotedStr(Trim(LTaskName)));
      if Res2 = 0 then
        LFuncs.SendEmail('Problem with scheduled task ' + QuotedStr(Trim(LTaskName)),
                     SchedErrMessage +
                     'Unable to lock task record. Error ' + IntToStr(Res) )
      else
        ThreadDoLog('Unable to send notification email');
      UnableToProcess := True;
      RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
    end
    else
    begin
      CoInitialize(nil);
      oTask := CreateOLEObject(LClassName) as IScheduledTask;
      if Assigned(oTask) then
      Try
        Try
          oTask.stName := Trim(LTaskName);
          oTask.stDataPath := MTExLocal^.LSetDrive;
          oTask.Load;

          InitStatusMemo(3);
          ShowStatus(0, 'Processing Task ' + QuotedStr(Trim(LTaskName)));
          InitProgress(100);
          //Add event handling
          LSchedEventsHandler := TExSchedCustom.Create(Application);
          LSchedEventsHandler.ScheduledTask := oTask;
          LSchedEventsHandler.OnProgress := DoTaskProgress;
          LSchedEventsHandler.Connect;
          oTask.Run
        Except
          on E:Exception do
          begin
            with MTExLocal^ do
            begin
              LTaskRec.stStatus := tsError;
              Res := LPut_Rec(TaskF, 0);
              //Log error and Send email
              ThreadDoLog('Error in task ' + Trim(LTaskRec.stTaskName) + ': ' + QuotedStr(E.Message));
              //email
              LFuncs.SendEmail('Error in scheduled task ' + QuotedStr(Trim(LTaskRec.stTaskName)),
                        SchedErrMessage + E.Message);
              RemoveInUse(MTExLocal^.LSetDrive, LTaskName);
            end;
          end;
        End;
      Finally
        LSchedEventsHandler.Disconnect;
        oTask := nil;
      End;
      CoUninitialize;
    end;
  end;
end;

function TSchedCustomTask.Start: Boolean;
begin
  LFuncs.OwnerName := LTaskName;

  Result := True;
end;


end.
