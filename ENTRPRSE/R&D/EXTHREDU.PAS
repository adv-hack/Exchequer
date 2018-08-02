unit ExThredU;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VarConst,BtrvU2,BtSupU1,ExWrap1U,
  ExBtTh1U;



type
  TMainThread = class(TEXSThread)
  private

  protected

    procedure Execute; override;

  public
    ParentQ     :  Integer;
    MainFinish,
    FinishedAll,
    ExecuteOff  :  Boolean;

    ThreadObj   :  Pointer;

    constructor Create(TObj        :  Pointer;
                       TPriority   :  TThreadPriority;
                       DoneMethod  :  TNotifyEvent;
                       PQ          :  Integer);

    Destructor Destroy; override; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390

    Function WaitforTerminate  :  Boolean;

    Property Terminated;

    procedure ForceTerminateStatus;

  private
    ThreadQueue  :  ^TThreadQueue;

    procedure ProcessThreadQueue;

  end;


{$IFDEF DBD} {OTC_Hang}
Var
  DebugThreadName  :  ^Str100;

{$ENDIF}


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

  BTSFrmU1;

{ TMainThread }

{$O-} {* Switch optimizer off *}

constructor TMainThread.Create(TObj        :  Pointer;
                               TPriority   :  TThreadPriority;
                               DoneMethod  :  TNotifyEvent;
                               PQ          :  Integer);

begin
 // MH OTC_Hang
  // MH 11/05/07: This should really be the first thing in a Constructor
  inherited Create(True);

  ThreadQueue:=TObj;

  ThreadObj:=TObj;

  ExecuteOff:=BOff;
  MainFinish:=BOff;
  FinishedAll:=BOff;

  ParentQ:=PQ;

  // MH 11/05/07: This should really be the first thing in a Constructor
  {inherited Create(True);}

  FreeOnTerminate := BOn;

  Priority:=TPriority;

  OnTerminate:=DoneMethod;

  {Resume; *Resume inside thread controller *}
end;

Destructor TMainThread.Destroy;

Begin
  Inherited Destroy;
end;


Function TMainThread.WaitforTerminate  :  Boolean;

Var
  n       :  Integer;

  TmpBo   :  Boolean;

Begin
  n:=0;

  Repeat

    Inc(n);

    Application.ProcessMessages;

    TmpBo:=((Terminated) and (ExecuteOff));

  Until (TmpBo) or (n>99999);

  Result:=TmpBo;
end;


{ Process ThreadQueue Object}

procedure TMainThread.ProcessThreadQueue;


begin
  If (Assigned(ThreadQueue)) then
  Begin

    try

      {$IFDEF DBD} {OTC_Hang}
        
        DebugThreadName^:=ThreadQueue^.ThreadRec^.THTaskDesc+'. Started';

        PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,500,LongInt(DebugThreadName));
      {$ENDIF}

      With ThreadQueue^ do
      Begin
        TQThreadObj:=Self;

        StartCOM;



        Process;

        {* 01/11/96.Slow thread up before finishing, as some report based threads
           were crashing because the finish was to quick? Perhaps the
           call back for producing the print file had a timing problem *}

        {If (Priority>tpLowest) then {* Changed to idle 04/03/97
          Priority:=tpLowest;}

         If (Priority>tpIdle) then
          Priority:=tpIdle;


        Finish;


        {$IFDEF DBD} {OTC_Hang}
          DebugThreadName^:=ThreadRec^.THTaskDesc+'. Stopped';
        {$ENDIF}

      end;

    finally
      MainFinish:=BOn;
      ThreadObj:=Nil;
      try
        Dispose(ThreadQueue,Destroy);

        {$IFDEF DBD} {OTC_Hang}
          PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,501,LongInt(DebugThreadName));
        {$ENDIF}

        StopCOM;

        {$IFDEF DBD} {OTC_Hang}
          DebugThreadName^:=DebugThreadName^+'. / COM Stopped';

          PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,501,LongInt(DebugThreadName));
        {$ENDIF}

      finally
        ThreadQueue:=nil;
      end;
    end; {try..}
  end
  else
    MessageBeep(0);

end;

{* In the event of a termination attempt to finish the basics *}

procedure TMainThread.ForceTerminateStatus;

Begin
  If (Assigned(ThreadQueue)) and (Not FinishedAll) then
  With ThreadQueue^ do
  Begin
    try
      BaseObjFinish;
    Finally

      FinishedAll:=BOn;

    end; {try..}
  end;
end;

{ The Execute method is called when the thread starts }

procedure TMainThread.Execute;


begin
 ExecuteOff:=BOff;

  try
    ProcessThreadQueue;
  finally
    ExecuteOff:=BOn;
  end;

end;



{$O+} {* Switch optimizer on *}


Initialization

{$IFDEF DBD} {OTC_Hang}
  New(DebugThreadName);


  FillChar(DebugThreadName^,Sizeof(DebugThreadName^),#0);

{$ENDIF}


Finalization

 {$IFDEF DBD} {OTC_Hang}
    Dispose(DebugThreadName);
 {$ENDIF}
end.
