unit TJobQueueClass;

{******************************************************************************}
{     TJobQueue maintains a list of TImportJob objects. When the job queue     }
{     is active, each ImportJob's "Execute" method is called in turn and       }
{     removed from the Job Queue until the queue is empty.                     }
{     TJobQueue issues windows messages with information about the status of   }
{     jobs. Windows which want to receive those messages (e.g. TfrmJobQueue    }
{     and TfrmScheduler) must call RegisterWindow with their window handle     }
{     when they are created.                                                   }
{     TJobQueue uses a sub-classed version of TList to store the pointers to   }
{     all the TImportJob objects. This is purely to save having to frequently  }
{     typecast, for example, TImportJob(FImportJobs[i]).JobNo  etc.            }
{     which now becomes simply FImportJobs[i].JobNo                            }
{******************************************************************************}

interface

uses messages, TPosterClass, TImportJobClass;

const
  WM_IMPORTJOB_NEWJOB      = WM_USER + 12468; // wParam = TImportJob, lParam = 0
  WM_IMPORTJOB_STARTED     = WM_USER + 12469; // wParam = JobNo, lParam = FileNo
  WM_IMPORTJOB_FINISHED    = WM_USER + 12470; // wParam = JobNo, lParam = FileNo
  WM_IMPORTJOB_HELD        = WM_USER + 12471; // wParam = JobNo, lParam = 0
  WM_IMPORTJOB_RELEASED    = WM_USER + 12472; // wParam = JobNo, lParam = 0
  WM_IMPORTJOB_DELETED     = WM_USER + 12473; // wParam = JobNo, lParam = FileNo
  WM_IMPORTQUEUE_STARTED   = WM_USER + 12474; // wParam = 0, lParam = 0
  WM_IMPORTQUEUE_STOPPED   = WM_USER + 12475; // wParam = 0, lParam = 0
  WM_REFRESHJOBFILES       = WM_USER + 12476; // wParam = 0, lParam = 0
  WM_IMPORTJOB_PROGRESS    = WM_USER + 12477; // wParam = Max, lParam = Progress
  WM_IMPORTJOB_FAILED      = WM_USER + 12478; // wParam = JobNo, lParam = FileNo
  WM_IMPORTJOB_PHASE1      = WM_USER + 12479; // v.084
  WM_IMPORTJOB_PHASE2      = WM_USER + 12480; // v.084

type
  IJobQueue = interface
    ['{7854904C-06F4-4D4B-9FAB-6614106684E4}']

    // Getters and Setter for public properties
    function  GetJobCount: integer;
    function  GetJobs(index: integer): TImportJob;
    function  GetRunning: boolean;
    procedure SetRunning(const Value: boolean);
    function  GetPoster: TPoster;
    procedure SetPoster(const Value: TPoster);
    // public functions and properties
    function  AddJob(ANewJob: TImportJob): integer;
    procedure BeginUpdate;
    procedure DeleteJob(AJobNo: integer);
    procedure EndUpdate;
    procedure HoldJob(AJobNo: integer);
    procedure ReleaseJob(AJobNo: integer);
    function  RunJobs: integer;
    property  JobCount: integer read GetJobCount;
    property  Jobs[index: integer]: TImportJob read GetJobs;
    property  Poster: TPoster read GetPoster write SetPoster;
    property  Running: boolean read GetRunning write SetRunning;
  end;

function ImportJobQueue: IJobQueue;

implementation

uses Classes, ExtCtrls, forms, windows,
     TAutoIncClass, Utils, TErrors, GlobalConsts,
     //PR: 24/06/2013 ABSEXCH-14317 Add Job Handler. Add SysUtils for FreeAndNil call
     TJobHandlerClass,
     SysUtils;

type

  TImportJobList = class(TList)   // saves having to keep typecasting
    function  Get(Index: Integer): TImportJob;
    procedure Put(Index: Integer; Item: TImportJob);
  private
  public
    property  Items[Index: Integer]: TImportJob read Get write Put; default;
  end;

  TJobQueue = class(TInterfacedObject, IJobQueue)
  private
{* internal fields *}
    FAutoInc: TAutoInc;
    FAutoInced: boolean;
    FHeldJobs: TList; // contains the JobNo's of held jobs
    FImporting: boolean;
    FImportJobs: TImportJobList; // contains the list of TImportJob object
    FRegisteredWindows: TList; // contains the HWND's of windows that want to received JobQueue messages
    FTimer: TTimer;
    FUpdating: boolean;

    //PR: 24/06/2013 ABSEXCH-14317 Add job handler to preserve errors on multi-file jobs
    FJobHandler : TJobHandler;
{* property fields *}
    FRunning: boolean;
    FPoster: TPoster;
{* procedural methods *}
{* getters and setters *}
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(Value: string);
    function  GetJobCount: integer;
    function  GetJobs(index: integer): TImportJob;
    function  JobHeld(AJobNo: integer): boolean;
    procedure SetRunning(const Value: boolean);
    procedure TimerTimer(Sender: TObject);
    procedure SetPoster(const Value: TPoster);
    function  GetPoster: TPoster;
    function  GetRunning: boolean;
  public
    constructor create;
    destructor  destroy; override;
    function  AddJob(ANewJob: TImportJob): integer;
    procedure BeginUpdate;
    procedure DeleteJob(AJobNo: integer);
    procedure EndUpdate;
    procedure HoldJob(AJobNo: integer);
    procedure ReleaseJob(AJobNo: integer);
    function  RunJobs: integer;
    property  JobCount: integer read GetJobCount;
    property  Jobs[index: integer]: TImportJob read GetJobs;
    property  Poster: TPoster read GetPoster write SetPoster;
    property  Running: boolean read GetRunning write SetRunning;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

var
  FJobQueue: IJobQueue;

function ImportJobQueue: IJobQueue;
begin
  if not assigned(FJobQueue) then
    FJobQueue := TJobQueue.create;
    
  result := FJobQueue;
end;

{ TJobQueue }

constructor TJobQueue.create;
begin
  inherited;

  FPoster         := TPoster.create;

  FRunning        := SchedulerMode;

  FImportJobs     := TImportJobList.Create;
  FHeldJobs       := TList.Create;
  FRegisteredWindows := TList.Create;
  FTimer          := TTimer.Create(nil);
  FTimer.Enabled  := FRunning;
  FTimer.Interval := 5000;
  FTimer.OnTimer  := TimerTimer;

  //PR: 24/06/2013 ABSEXCH-14317
  FJobHandler := nil;
end;

destructor TJobQueue.destroy;
begin
  FreeObjects([FImportJobs, FTimer, FHeldJobs, FPoster]);

  inherited;
end;

{* Procedural Methods *}

function TJobQueue.AddJob(ANewJob: TImportJob): integer;
begin
  result := -1;

  FImportJobs.Add(ANewJob);

  FPoster.PostMsg(WM_IMPORTJOB_NEWJOB, integer(ANewJob), 0); // post message to any forms that registered to received them

  result := 0;
end;

procedure TJobQueue.BeginUpdate;
// pause jobs while items are added or deleted from the job queue.
// Won't return to caller until the current file, if any, has finished being imported.
begin
  FUpdating := true;        // flag to RunJobs that we're waiting to add new jobs
end;

procedure TJobQueue.DeleteJob(AJobNo: integer);
// we let the current job finish before starting to delete items out of FImportJobs.
var
  i: integer;
begin
  BeginUpdate; // won't return until current job has finished

  for i := FImportJobs.Count - 1 downto 0 do
    if FImportJobs[i].JobNo = AJobNo then begin
      FPoster.PostMsg(WM_IMPORTJOB_DELETED, FImportJobs[i].JobNo, FImportJobs[i].FileNo);
      FImportJobs.Delete(i);
    end;

  EndUpdate;
end;

procedure TJobQueue.EndUpdate;
// new jobs have been added, start importing again
begin
  FUpdating := false;
end;

procedure TJobQueue.HoldJob(AJobNo: integer);
var
  i: integer;
begin
  for i := 0 to FHeldJobs.Count - 1 do
    if FHeldJobs[i] = pointer(AJobNo) then exit; // don't add it again

  FHeldJobs.Add(pointer(AJobNo));

  FPoster.PostMsg(WM_IMPORTJOB_HELD, AJobNo, 0);
end;

function TJobQueue.JobHeld(AJobNo: integer): boolean;
// is the job with the matching JobNo held ?
var
  i: integer;
begin
  result := false;
  for i := 0 to FHeldJobs.Count - 1 do begin
    result :=  FHeldJobs[i] = pointer(AJobNo);
    if result then break;
  end;
end;

procedure TJobQueue.ReleaseJob(AJobNo: integer);
// removes a job number from the list of held jobs
// The job number might not exist, since this proc will be called for each file
// in a job and the first call will result in the entry being deleted.
var
  i: integer;
begin
  for i := 0 to FHeldJobs.Count - 1 do
    if FHeldJobs[i] = pointer(AJobNo) then begin
      FHeldJobs.Delete(i);
      FPoster.PostMsg(WM_IMPORTJOB_RELEASED, AJobNo, 0);
      break;
    end;
end;

function TJobQueue.RunJobs: integer;
// cycle through all the jobs in the queue and get each TImportJob to import it's file.
// If "Carry Over Auto Inc" is set to yes in the job file, we copy the TAutoInc object
// from one TImportJob and use it in the next instead of starting with a blank one.
var
  i: integer;
  JobCount: integer;
  JobHandler : TJobHandler;
begin
  Result := 0;
  try
    JobCount := FImportJobs.Count - 1;
    for i := 0 to JobCount do begin
      application.ProcessMessages;                             // allow button clicks to get actioned
      if (not FRunning) or FUpdating then break;                // is the loop being interrupted ?
      if JobHeld(FImportJobs[0].JobNo) then continue;          // don't run Held jobs

      FImporting := true;                                      // signal to BeginUpdate that a file's being imported
      FPoster.PostMsg(WM_IMPORTJOB_STARTED, FImportJobs[0].JobNo, FImportJobs[0].FileNo);
      FPoster.PostMSg(WM_IMPORTJOB_PROGRESS, 100, 0);          // signals start of job to any Progress Bars/Gauges
      FImportJobs[0].Poster := FPoster;                        // assign Poster so that job can send progress messages
      application.ProcessMessages;                             // allow visual indicators to be updated immediately

{* if this is the first file of a job, we store the pointer to the TAutoInc instance *}
      if (FImportJobs[0].FileNo = 1) then begin
        if FAutoInced then begin   // Got a previous AutoInc object ?
          FreeObjects([FAutoInc]); // free the instance from the previous job if there is one
          FAutoInc   := nil;
          FAutoInced := false;     // Haven't got one now
        end;
        if FImportJobs[0].CarryOverAutoInc then begin // do we need to carry it over ?
          FAutoInc   := FImportJobs[0].AutoInc;       // copy the object pointer
          FAutoInced := true;                         // remember we've now got a previous AutoInc object
        end;

        //PR: 24/06/2013 ABSEXCH-14317 If we already have a job handler, then destroy it which will post the appropriate
        //                             message to the scheduler window
        if Assigned(FJobHandler) then
          FreeAndNil(FJobHandler);

        //PR: 24/06/2013 ABSEXCH-14317 Create job handler and assign reference to poster for messages.
        //TODO: Make poster a singleton so that we don't need each object to have an individual reference to it
        FJobHandler := TJobHandler.Create(FImportJobs[0].JobNo);
        FJobHandler.Poster := FPoster;

      end
      else // for file 2 onwards...
        if (FImportJobs[0].CarryOverAutoInc) then     // Are we carrying over AutoInc objects ?
          FImportJobs[0].AutoInc := FAutoInc;         // use the stored one for this job too

      result := FImportJobs[0].Execute;                        // Import the file

      if result = 0 then
        FPoster.PostMsg(WM_IMPORTJOB_FINISHED, FImportJobs[0].JobNo, FImportJobs[0].FileNo)
      else
      begin
        FPoster.PostMsg(WM_IMPORTJOB_FAILED, FImportJobs[0].JobNo, FImportJobs[0].FileNo);
        FJobHandler.ImportError := True; //PR: 24/06/2013 ABSEXCH-14317 Set error status
      end;

      FPoster.PostMSg(WM_IMPORTJOB_PROGRESS, 0, 0);  // signals end of job to any ProgressBars/Gauges
      application.ProcessMessages;

      try
        FImportJobs[0].Free;                            // Free the Import Job
      except                                            // testing possible madExcept problem on Win2000
      end;
      FImportJobs.Delete(0);                          // remove it from the Job Queue
      if (FImportJobs.count = 0) and FAutoInced then begin // no more jobs to carry over to
        FreeObjects([FAutoInc]);
        FAutoInced := false;
      end;
      FImporting := false;
    end;
  finally
    FImporting := false;

    //PR: 24/06/2013 ABSEXCH-14317 Destroy the job handler so that it will post the appropriate message to the
    //                             scheduler window.
    if Assigned(FJobHandler) then
      FreeAndNil(FJobHandler);
  end;
end;

{* getters and setters *}

function TJobQueue.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TJobQueue.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TJobQueue.SetSysMsg(Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

function TJobQueue.GetJobCount: integer;
begin
  result := FImportJobs.Count;
end;

function TJobQueue.GetJobs(index: integer): TImportJob;
begin
  result := FImportJobs[index];
end;

procedure TJobQueue.SetRunning(const Value: boolean);
begin
  FRunning := Value;
  FTimer.Interval := 5000; // give the user chance to change their mind
  FTimer.Enabled := Value;
  if FRunning then
    FPoster.PostMsg(WM_IMPORTQUEUE_STARTED, 0, 0)
  else
    FPoster.PostMsg(WM_IMPORTQUEUE_STOPPED, 0, 0);
end;

procedure TJobQueue.TimerTimer(Sender: TObject);
begin
  FTimer.Interval := 1000;
  FTimer.Enabled  := false;
  if not FUpdating then
    RunJobs;
  FTimer.Enabled  := true;
end;

{* Getters and Setters *}

procedure TJobQueue.SetPoster(const Value: TPoster);
begin
  FPoster := Value;
end;

function TJobQueue.GetPoster: TPoster;
begin
  result := FPoster;
end;

function TJobQueue.GetRunning: boolean;
begin
  result := FRunning;
end;

{ TImportJobList }

function TImportJobList.Get(Index: Integer): TImportJob;
begin
 result := TImportJob(inherited Get(Index));
end;

procedure TImportJobList.Put(Index: Integer; Item: TImportJob);
begin
  inherited Put(Index, pointer(item));
end;

initialization
  FJobQueue := nil;

finalization
  FJobQueue := nil;

end.
