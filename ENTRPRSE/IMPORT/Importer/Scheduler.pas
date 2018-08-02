unit Scheduler;

{******************************************************************************}
{ Scheduler reads through all the job files it finds in the job folder and for }
{ each enabled job, will call TBuildImportJobs at the appropriate time.        }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, uMultiList, GlobalTypes, IniFiles,
  TImportJobClass, TJobQueueClass, TScheduleClass, Menus, EntLicence;

type

  TfrmScheduler = class(TForm)
    PageControl: TPageControl;
    tsSettings: TTabSheet;
    gbSettings: TGroupBox;
    mlJobList: TMultiList;
    btnClose: TButton;
    btnHoldJob: TButton;
    btnReleaseJob: TButton;
    btnDeleteJob: TButton;
    Timer: TTimer;
    btnRunNow: TButton;
    edtTime: TEdit;
    btnJobQueue: TButton;
    btnStop: TButton;
    btnGo: TButton;
    btnShowLog: TButton;
    btnEditJob: TButton;
    PopupMenu: TPopupMenu;
    mniEditJob: TMenuItem;
    mniHoldJob: TMenuItem;
    mniReleaseJob: TMenuItem;
    mniDeleteJob: TMenuItem;
    mniRunNow: TMenuItem;
    N1: TMenuItem;
    mniProperties: TMenuItem;
    mniSaveCoordinates: TMenuItem;
    btnHoldAllJobs: TButton;
    btnReleaseAllJobs: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure mlJobListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlJobListChangeSelection(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnDeleteJobClick(Sender: TObject);
    procedure btnDeleteAllJobsClick(Sender: TObject);
    procedure btnHoldJobClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnJobQueueClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnShowLogClick(Sender: TObject);
    procedure btnHoldAllJobsClick(Sender: TObject);
    procedure btnReleaseJobClick(Sender: TObject);
    procedure btnReleaseAllJobsClick(Sender: TObject);
    procedure btnRunNowClick(Sender: TObject);
    procedure btnEditJobClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mniPropertiesClick(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override;
  private
{* internal fields *}
    FDeletedJobs: TStringList;
    FDoubleClicking: boolean;
    FHelping: boolean;
    FImporting: boolean;
    FIsDirty: boolean;
    FMissedWhen: TDateTime;
    FRunning: boolean;
    FJobFolder: string;
    FJobExt: string;
{* property fields *}
{* procedural methods *}
    function  AnyJobStatus(AJobStatus: string): boolean;
    procedure ChangeCaption;
    procedure ChangeJobStatus(AJobIx: integer; AJobStatus: string);
    procedure DeleteJob(AJobNo: integer);
    procedure DoSettings(SaveLoad: TSaveLoad; AJobFile: string);
    procedure EnableDisableEtc;
    function  FindNextRun(AIniFile: TMemIniFile): TDateTime;
    procedure Go;
    procedure HoldJob(AJobNo: integer);
    procedure IsDirty;
    function  JobFileLoaded(AJobFile: string): boolean;
    function  JobStatus(AJobIx: integer): string;
    procedure LoadAllJobFiles;
    procedure LogEntry(Entry: string);
    function  JobSetting(AIniFile: TMemIniFile; ASectionName: string; AJobSetting: string): string;
    procedure JobStarted(AJobNo: integer);
    procedure QueueJob(AJobIx: integer);
    procedure QueueJobs;
    procedure RefreshJobFiles;
    procedure ReleaseJob(AJobNo: integer);
    procedure RestoreJobStatus(AJobIx: integer);
    procedure Shutdown;
    procedure Startup;
    procedure Stop;
    function  FindJob(AJobNo: integer): integer;
    procedure JobFinished(AJobNo: integer; WithErrors: boolean);
{* Message Handlers *}
    procedure WMSysCommand(var msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMJobFailed(var Msg: TMessage); message WM_IMPORTJOB_FAILED;
    procedure WMJobFinished(var Msg: TMessage); message WM_IMPORTJOB_FINISHED;
    procedure WMJobStarted(var Msg: TMessage); message WM_IMPORTJOB_STARTED;
    procedure WMJobHeld(var Msg: TMessage); message WM_IMPORTJOB_HELD;
    procedure WMJobReleased(var Msg: TMessage); message WM_IMPORTJOB_RELEASED;
    procedure WMJobDeleted(var Msg: TMessage); message WM_IMPORTJOB_DELETED;
    procedure WMImportQueueStarted(var Msg: TMessage); message WM_IMPORTQUEUE_STARTED;
    procedure WMImportQueueStopped(var Msg: TMessage); message WM_IMPORTQUEUE_STOPPED;
    procedure WMRefreshJobFiles(var Msg: TMessage); message WM_REFRESHJOBFILES;
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show(AJobFile: string; ShowScheduler: boolean);
    class procedure CloseWindow;
  end;


implementation

uses utils, GlobalConsts, TIniClass, JobQueue, DateUtils, Wizard, TBuildImportJobsClass,
     TLoggerClass, ViewLogFile;

const
// TMultilist columns
  COL_DEFJOB          = 0; // not used
  COL_ENABLED         = 1;
  COL_JOBFILE         = 2;
  COL_DESC            = 3;
  COL_JOBNO           = 4;
  COL_STATUS          = 5;
  COL_NEXTRUN         = 6;
  COL_LASTRUN         = 7;
  COL_NEXTRUNDATETIME = 8;
  COL_COMPANY         = 9;  // v.066
  COL_FULLJOBFILENAME = 10; // not visible to the user
  COL_PREVIOUSSTATUS  = 11; // not visible to the user

var
  frmScheduler: TfrmScheduler;

{$R *.dfm}

class procedure TfrmScheduler.Show(AJobFile: string; ShowScheduler: boolean);
// overrides the inherited Show method.
// Callers must call "TrmScheduler.Show" to display this form.
// This method takes care of creating an instance if necessary.
// The addition of the ShowScheduler option means that this Show procedure
// might not - primarily introduced for SchedulerMode, see project source in .dpr
begin
  if not assigned(frmScheduler) then
    frmScheduler := TfrmScheduler.Create(nil);

  if AJobFile <> '' then
    frmScheduler.DoSettings(slLoad, AJobFile)
  else
    frmScheduler.LoadAllJobFiles;

  if ShowScheduler then begin
    frmScheduler.EnableDisableEtc;
// inherited show
    frmScheduler.visible := true;
    frmScheduler.BringToFront;
  end;
end;

class procedure TfrmScheduler.CloseWindow;
begin
  if assigned(frmScheduler) then
    frmScheduler.Close;
end;

constructor TfrmScheduler.create(AOwner: TComponent);
// Reduced visibility to discourage creation of more than one instance.
// Accepted method of displaying this form is to call "TfrmDefaultSettings.show"
// which creates an instance if one doesn't already exist.
begin
  inherited create(AOwner);

  if not SchedulerMode then
    FormStyle := fsMDIChild;

  Startup; // v94 moved from FormCreate as it does stuff that is required now when SchedulerMode = true;
    
  ImportJobQueue.Poster.RegisterWindow(handle); // v94 moved from just before the SetConstraints statement. Now able to receive the messages that ImportJobQueue.Running := true will generate.

  FRunning      := SchedulerMode;
  ImportJobQueue.Running := SchedulerMode;
//  Timer.Enabled := SchedulerMode;

  SetConstraints(Constraints, height, width);
end;

{* Procedural Methods *}

function TfrmScheduler.AnyJobStatus(AJobStatus: string): boolean;
// returns true if any job's status matches the parameter
var
  i: integer;
begin
  result := false; // happy compiler
  for i := 0 to mlJobList.ItemsCount - 1 do begin
    result := JobStatus(i) = AJobStatus;
    if result then exit;
  end;
end;

procedure TfrmScheduler.ChangeCaption;
var
  s: string;
begin
  if FRunning then
    s := ' - [<Running>]'
  else
    s := ' - [<Stopped>]';

  if FIsDirty then
    s := s + '*';

  if EnterpriseLicence.IsLITE then
    Caption := format('IRIS Accounts Office Importer %s - Scheduler%s', [APPVERSION, s])
  else
    Caption := format('Exchequer Importer %s - Scheduler%s', [APPVERSION, s]);

  if InAdminMode then
    Caption := Caption + '^';

  if SchedulerMode then
    btnClose.Caption := 'Hide'
  else
    btnClose.Caption := 'Close';
end;

procedure TfrmScheduler.ChangeJobStatus(AJobIx: integer; AJobStatus: string);
// save the current status in the PreviousStatus column and set the current
// status to the parameter value.
begin
  if AJobIx = -1 then exit;

  mlJobList.DesignColumns[COL_PREVIOUSSTATUS].Items[AJobIx] :=
                              mlJobList.DesignColumns[COL_STATUS].Items[AJobIx]; // save the current status

  mlJobList.DesignColumns[COL_STATUS].Items[AJobIx] := AJobStatus;
end;

procedure TfrmScheduler.DeleteJob(AJobNo: integer);
// This job has been removed from the JobQueue so we reset it's status here
// If this procedure has been called because the user clicked the Delete button for
// a job on the Job Queue, the first click will cancel the job, they need to click
// again to delete the job from Scheduler.
var
  ix: integer;
begin
  ix := FindJob(AJobNo);
  if ix = -1 then exit;

  ChangeJobStatus(ix, 'Cancelled');
  mlJobList.DesignColumns[COL_JOBNO].Items[ix] := '';
  application.ProcessMessages;
end;

procedure TfrmScheduler.DoSettings(SaveLoad: TSaveLoad; AJobFile: string);
// Load the job settings from the job file and enter in the multilist.
var
  JobEnabled: boolean;
  LastRun: string;
  NextRun: TDateTime;
  MemIniFile: TMemIniFile;
  FS: TFileStream;
begin
  case SaveLoad of
    slSave: begin
            try
              IniFile.DecryptIniFile(AJobFile, false);
              MemIniFile := TMemIniFile.create(AJobFile);
              try
                MemIniFile.WriteString(SCHEDULE, 'LastRun', DateToStr(Date) + ' ' + FormatDateTime('HH:nn', now));
              finally
                MemIniFile.UpdateFile;
                MemIniFile.free;
                if not PlainOut then
                  IniFile.EncryptIniFile(AJobFile);
              end;
            except on e:exception do
              ShowMessage(e.message + ' while writing settings to ' + AJobFile);
            end;
            end;
    slLoad: begin
            try
              IniFile.DecryptIniFile(AJobFile, false);
              MemIniFile := TMemIniFile.create(AJobFile);
              if not PlainOut then
                IniFile.EncryptIniFile(AJobFile);
              try
                mlJobList.DesignColumns[COL_DEFJOB].items.add('XXX'); // was 'DEF' // remember where we got the setting from  // v94 this data isn't used anymore but still need to populata because multilist.itemscount returns the columns[0].count
                JobEnabled := SettingTF(JobSetting(MemIniFile, SCHEDULE, 'Enabled'));
                if JobEnabled then
                  mlJobList.DesignColumns[COL_ENABLED].Items.add('Yes')
                else
                  mlJobList.DesignColumns[COL_ENABLED].Items.add('No');
                LastRun := JobSetting(MemIniFile, SCHEDULE, 'LastRun');
                if LastRun <> '' then
                  mlJobList.DesignColumns[COL_LASTRUN].Items.Add(FormatDateTime('dd/mm/yyyy hh:nn', StrToDateTime(LastRun)))
                else
                  mlJobList.DesignColumns[COL_LASTRUN].Items.Add(' ');
                if JobEnabled then begin
                  NextRun := FindNextRun(MemIniFile);
                  mlJobList.DesignColumns[COL_NEXTRUN].Items.Add(FormatRunDateTime(NextRun));
                  mlJobList.DesignColumns[COL_NEXTRUNDATETIME].Items.Add(DateTimeToStr(NextRun));
                end
                else begin
                  mlJobList.DesignColumns[COL_NEXTRUN].Items.Add(' ');
                  mlJobList.DesignColumns[COL_NEXTRUNDATETIME].Items.Add(' ');
                end;
                if JobScheduler.MissedJob and (double(FMissedWhen) <> 0) then
                  mlJobList.DesignColumns[COL_STATUS].Items.add('Missed - ' + DateToStr(FMissedWhen) + ' ' + FormatDateTime('HH:nn',FMissedWhen))
                else
                  mlJobList.DesignColumns[COL_STATUS].Items.add(' ');
                mlJobList.DesignColumns[COL_JOBNO].Items.Add('');
                mlJobList.DesignColumns[COL_JOBFILE].Items.Add(copy(ExtractFileName(AJobFile), 1, length(ExtractFileName(AJobFile)) - length(ExtractFileExt(ExtractFileName(AJobFile)))));
                mlJobList.DesignColumns[COL_DESC].Items.Add(JobSetting(MemIniFile, JOB_SETTINGS, 'Description'));
                mlJobList.DesignColumns[COL_COMPANY].Items.add(JobSetting(MemIniFile, IMPORT_SETTINGS, 'Exchequer Company')); // v.066
                mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items.Add(LowerCase(AJobFile));
                mlJobList.DesignColumns[COL_PREVIOUSSTATUS].Items.Add(' ');
                MLSelectLast(mlJobList);
              finally
                MemIniFile.free;
              end;
            except on e:exception do
              ShowMessage(e.message + ' while reading settings from ' + AJobFile);
            end;
            end;
  end;
  EnableDisableEtc;
  ChangeCaption;
end;

procedure TfrmScheduler.EnableDisableEtc;
// change what's enabled/disabled depending on which tabsheet is being viewed.
begin
  if PageControl.ActivePage = tsSettings then begin   // there were originally more tabs in this PageControl
    btnEditJob.Enabled       := (mlJobList.ItemsCount <> 0) and (mlJobList.Selected <> -1) and not SchedulerMode;
    btnHoldJob.Enabled       := (mlJobList.ItemsCount <> 0) and (mlJobList.Selected <> -1) and (JobStatus(mlJobList.Selected) <> 'Held');
    btnHoldAllJobs.Enabled    := mlJobList.ItemsCount <> 0;
    btnReleaseJob.Enabled    := (mlJobList.ItemsCount <> 0) and (mlJobList.Selected <> -1) and (JobStatus(mlJobList.Selected) = 'Held');
    btnReleaseAllJobs.Enabled := (mlJobList.ItemsCount <> 0) and AnyJobStatus('Held');
    btnDeleteJob.Enabled     := (mlJobList.ItemsCount <> 0) and (mlJobList.Selected <> -1) {and not FRunning};
//    btnDeleteAllJobs.Enabled  := mlJobList.ItemsCount <> 0;
    btnRunNow.Enabled        := (mlJobList.ItemsCount <> 0) and (mlJobList.Selected <> -1)
                                 and (JobStatus(mlJobList.Selected) <> 'Queued') and FRunning;

    if FImporting then
      btnRunNow.Enabled := false; // overrides the preceding statement.

    mniEditJob.Enabled    := btnEditJob.Enabled;
    mniHoldJob.Enabled    := btnHoldJob.Enabled;
    mniReleaseJob.Enabled := btnReleaseJob.Enabled;
    mniRunNow.Enabled     := btnRunNow.Enabled;
  end;

  edtTime.Visible := InAdminMode;
  btnStop.Enabled := FRunning;
  btnGo.Enabled   := not FRunning;
end;

function TfrmScheduler.FindJob(AJobNo: integer): integer;
// find the job in the multilist with the corresponding Job No
var
  i: integer;
  JobNo: string;
begin
  JobNo  := IntToStr(AJobNo);

  result := -1;

  for i := 0 to mlJobList.ItemsCount - 1 do
    if  (mlJobList.DesignColumns[COL_JOBNO].items[i] = JobNo) then begin
      result := i;
      break;
    end;
end;

function TfrmScheduler.FindNextRun(AIniFile: TMemIniFile): TDateTime;
// Determines the datetime of the next run for the current job file.
// Sets up TScheduler with all the schedule parameters from the job file.
// If the LastRun datetime is available we find out when the next run should have
// been, otherwise we calculate when the next run should be starting from Now.
// If TScheduler calculates that the next run datetime has passed it sets the
// MissedJob flag in which case we set the job to run immediately.
var
  LastRun: string;
begin
  LastRun            := JobSetting(AIniFile, SCHEDULE, 'LastRun');
  with JobScheduler do begin
    Monthly          := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Monthly'));
    Daily            := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Daily'));
    Monday           := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Monday'));
    Tuesday          := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Tuesday'));
    Wednesday        := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Wednesday'));
    Thursday         := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Thursday'));
    Friday           := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Friday'));
    Saturday         := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Saturday'));
    Sunday           := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Sunday'));
    Week1            := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Week1'));
    Week2            := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Week2'));
    Week3            := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Week3'));
    Week4            := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Week4'));
    RunInLastWeek    := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Weekx'));
    Every            := SettingTF(JobSetting(AIniFile, SCHEDULE, 'Every'));
    EveryMins        := StrToInt(JobSetting(AIniFile, SCHEDULE, 'EveryMins'));
    EveryBetween     := SettingTF(JobSetting(AIniFile, SCHEDULE, 'EveryBetween'));
    EveryBetweenMins := StrToInt(JobSetting(AIniFile, SCHEDULE, 'EveryBetweenMins'));
    BetweenFrom      := StrToTime(JobSetting(AIniFile, SCHEDULE, 'BetweenFrom'));
    BetweenTo        := StrToTime(JobSetting(AIniFile, SCHEDULE, 'BetweenTo'));
    OnceAt           := SettingTF(JobSetting(AIniFile, SCHEDULE, 'OnceAt'));
    OnceAtTime       := StrToTime(JobSetting(AIniFile, SCHEDULE, 'OnceAtTime'));
    UseISO8601       := SettingTF(JobSetting(AIniFile, SCHEDULE, 'ISO8601'));
    if LastRun <> '' then
      BaseDateTime   := StrToDateTime(LastRun)  // when should the next run have been ?
    else
      BaseDateTime   := Now; // Date + EncodeTime(HourOf(Time), MinuteOf(Time), 0, 0);
    result := NextRun;  // calculate the next rundate and runtime
    if LastRun = FormatDateTime('dd/mm/yyyy hh:nn', result) then begin // don't schedule a job twice in the same minute
      BaseDateTime := IncMinute(Now, 1);
      result := NextRun; // recalculate from a minute after the LastRun
    end;
  end;
//  if InAdminMode then
//    Caption := 'Last Run: ' + LastRun + ' Next Run: ' + DateTimeToStr(result);
  if JobScheduler.MissedJob then begin // missed job so run now
    FMissedWhen      := result;
    result := Now;                    // run the job now
  end;
end;

procedure TfrmScheduler.Go;
// called in response to a WM_IMPORTQUEUE_STARTED message from TJobQueue
begin
//  Timer.Enabled          := true;
  FRunning               := true;
  RefreshJobFiles;
  EnableDisableEtc;
  ChangeCaption;
end;

procedure TfrmScheduler.HoldJob(AJobNo: integer);
// called in response to a WM_IMPORTJOB_HELD message from TJobQueue
// Finds the job in the ML and changes it's status
var
  ix: integer;
begin
  ix := FindJob(AJobNo);
  if ix = -1 then exit;

  ChangeJobStatus(ix, 'Held');
  IsDirty;
end;

procedure TfrmScheduler.IsDirty;
// the job list has been altered.
begin
  FIsDirty := true;
  ChangeCaption;
  EnableDisableEtc;
end;

function TfrmScheduler.JobFileLoaded(AJobFile: string): boolean;
// determines whether the given job file is already displayed in the ML
var
  i: integer;
begin
  result := false;
  AJobFile := LowerCase(AJobFile);
  for i := 0 to mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items.Count - 1 do
    if mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[i] = AJobFile then begin
      result := true;
      break;
    end;
end;

procedure TfrmScheduler.JobFinished(AJobNo: integer; WithErrors: boolean);
// called in response to a WM_IMPORTJOB_FINISHED message from TJobQueue
// Saves the run datetime to the job file and changes the status in the ML
var
  ix: integer;
begin
  FImporting := false;
  ix := FindJob(AJobNo);

  if ix <> -1 then begin
    DoSettings(slSave, mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[ix]);
    mlJobList.DesignColumns[COL_LASTRUN].Items[ix] := FormatDateTime('dd/mm/yyyy hh:nn', now);
    if WithErrors then
      ChangeJobStatus(ix, 'Finished with Errors')
    else
      ChangeJobStatus(ix, 'Finished');
    application.ProcessMessages;
  end;
  RefreshJobFiles;
  EnableDisableEtc;
end;

function TfrmScheduler.JobSetting(AIniFile: TMemIniFile; ASectionName: string; AJobSetting: string): string;
// reads a particular job setting from the job file or, if not found, the
// default in the main settings file.
// In reality, Importer was changed so that each job file always contains it's
// own copy of all the settings whereas previously it only contained ones which
// the user had altered from the default.
begin
  result := trim(AIniFile.ReadString(ASectionName, AJobSetting, '')); // is there an override setting in the SAV file
  if result = '' then                                         // no ?.....
    result := trim(IniFile.ReturnValue(ASectionName, AJobSetting));   // then use the default setting
end;

procedure TfrmScheduler.JobStarted(AJobNo: integer);
// called in response to a WM_IMPORTJOB_STARTED message from TJobQueue
// Finds the job in the ML and changes it's status.
var
  ix: integer;
begin
  FImporting := true;
  ix := FindJob(AJobNo);

  if ix <> -1 then
    ChangeJobStatus(ix, 'Importing');

  EnableDisableEtc;
end;

function TfrmScheduler.JobStatus(AJobIx: integer): string;
// returns the status of the job from the given row of the ML
begin
  if AJobIx = -1 then exit;

  result := mlJobList.DesignColumns[COL_STATUS].Items[AJobIx];
end;

procedure TfrmScheduler.LoadAllJobFiles;
// finds all the job files in the user's Job Folder and loads them into the ML
// as long as
// a) they aren't already in the multilist
// b) the user hasn't previously deleted them from the multilist
var
  rc: integer;
  sr: TSearchRec;
  jobs: TStringList;
  i: integer;
begin
  FJobFolder := IncludeTrailingPathDelimiter(IniFile.ReadString(SYSTEM_SETTINGS, 'Job Folder', ''));
  FJobExt    := IniFile.ReadString(SYSTEM_SETTINGS, 'Job Ext', '');
  jobs := TStringList.create;
  try
    rc := FindFirst(FJobFolder + '*.' + FJobExt, faAnyFile, sr);
    while rc = 0 do begin
      jobs.Add(sr.Name);
      rc := FindNext(sr);
    end;
    FindClose(sr);

    jobs.Sorted := true;
    for i := 0 to jobs.Count - 1 do begin
      if (not JobFileLoaded(FJobFolder + jobs[i])) and (FDeletedJobs.IndexOf(LowerCase(FJobFolder + jobs[i])) = -1) then
        DoSettings(slLoad, FJobFolder + jobs[i]);
    end;

  finally
    jobs.Free;
  end;

{* TMultilist seems to have a problem sorting columns when the multilist is not visible, which is the case when running
   in scheduler mode. Hence, the following line has been replaced with the use of the sorted stringlist above *}
//  MLSortColumn(mlJobList, COL_JOBFILE, true); // make sure jobs are in alphabetical order

  application.ProcessMessages; // make sure ML.ItemsCount gets updated
end;

procedure TfrmScheduler.LogEntry(Entry: string);
// writes to Importer's application log file.
begin
  Logger.LogEntry(0, Entry);
end;

procedure TfrmScheduler.QueueJob(AJobIx: integer);
// Queues the job at the given row of the ML.
// TBuildImportJobs.BuildJobs reads the job file and creates an import job on the job queue
// for each file.
var
  BuildImportJobs: TBuildImportJobs;
  rc: integer;
  s: string;
begin
try
  mlJobList.DesignColumns[COL_STATUS].Items[AJobIx] := 'Queueing...';
  BuildImportJobs := TBuildImportJobs.create;
  try
    BuildImportJobs.SAVFileName := mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[AJobIx];
    rc := BuildImportJobs.BuildJobs;
    if (rc < 0) or BuildImportJobs.SysMsgSet then begin
      LogEntry(BuildImportJobs.SysMsg);
      mlJobList.DesignColumns[COL_STATUS].Items[AJobIx] := 'Not Queued - errors';
      DoSettings(slSave, mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[AJobIx]);  // update the last runtime in the job file
      mlJobList.DesignColumns[COL_LASTRUN].Items[AJobIx] := FormatDateTime('dd/mm/yyyy hh:nn', now); // update the last runtime in the ML
      FImporting := false; // enable the RunNow button
    end;
    if rc = 0 then begin // job queued with no errors
      LogEntry(format('Job No = %d', [BuildImportJobs.JobNo]));
      if (BuildImportJobs.AddedJobs <> 1) then s := 's'; // else s := '';
      LogEntry(format('%d file%s added to the Import Job Queue', [BuildImportJobs.AddedJobs, s]));
      LogEntry('');
      mlJobList.DesignColumns[COL_STATUS].Items[AJobIx] := 'Queued';    // change status in ML
      mlJobList.DesignColumns[COL_JOBNO].Items[AJobIx]  := IntToStr(BuildImportJobs.JobNo); // display Job No in ML
   end;
  finally
    BuildImportJobs.free;
  end;
  EnableDisableEtc;
except on e:exception do
  ShowMessage(e.Message + ' while queueing ' + mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[AJobIx]);
end;
end;

procedure TfrmScheduler.QueueJobs;
// cycle through the jobs displayed in the ML.
// For any job which isn't held and isn't already queued and/or in the process
// of importing files we check the next run date and time column.
// If that time has passed we run the job.
var
  i: integer;
  RunTime: TDateTime;
begin
  for i := 0 to mlJobList.ItemsCount - 1 do begin
    ImportJobQueue.BeginUpdate; // pause the job queue while we add new jobs to it - Run Now button might unset this so we set it each time
    application.ProcessMessages;
    if not FRunning then exit;
    if (mlJobList.DesignColumns[COL_ENABLED].Items[i] = 'Yes')
      and (mlJobList.DesignColumns[COL_STATUS].Items[i] <> 'Held')
      and (mlJobList.DesignColumns[COL_STATUS].Items[i] <> 'Queued')
      and (mlJobList.DesignColumns[COL_STATUS].Items[i] <> 'Queueing...')
      and (mlJobList.DesignColumns[COL_STATUS].Items[i] <> 'Importing') then begin
        if trim(mlJobList.DesignColumns[COL_NEXTRUNDATETIME].Items[i]) <> '' then begin
          RunTime := StrToDateTime(mlJobList.DesignColumns[COL_NEXTRUNDATETIME].Items[i]);
          if (Now > RunTime) then begin
            mlJobList.Selected := i; // highlight the job being queued
            QueueJob(i);
          end;
        end;
    end;
  end;
  ImportJobQueue.EndUpdate; // un-pause the job queue now we've finished adding jobs to it
end;

procedure TfrmScheduler.RefreshJobFiles;
// refresh the details of job files which haven't been sent to the job queue.
// Any new files in the job file folder which aren't already in the ML are
// added if Scheduler is running.
// For any job which isn't held and isn't already queued and/or in the process
// of importing files we calculate the next run date and time (if the job is
// enabled)
// This procedure picks up the details from the job file in case they've changed
// from the last refresh.
// The next run date and time is stored in two columns. COL_NEXTRUN is displayed
// to the user and is formatted so that the dd/mm/yyyy date is replaced by
// "Today" or "Tomorrow" if appropriate.
// COL_NEXTRUNDATETIME is hidden and is for our use.
// If TSchedule flags a missed job we display to the user the date and time that
// the job should have run, in which case QueueJobs will run it immediately.
var
  i: integer;
  JobEnabled: boolean;
  NextRun: TDateTime;
  MemIniFile: TMemIniFile;
  FN: string;
begin
try
  if FRunning then
    LoadAllJobFiles; // will add new files to the end of the list
  for i := 0 to mlJobList.ItemsCount - 1 do begin
    FN := mlJobList.DesignColumns[COL_FULLJOBFILENAME].items[i]; // just for the try..except message
    if  (mlJobList.DesignColumns[COL_STATUS].items[i] <> 'Importing')
    and (mlJobList.DesignColumns[COL_STATUS].items[i] <> 'Queued')
    and (mlJobList.DesignColumns[COL_STATUS].items[i] <> 'Held')
    and (mlJobList.DesignColumns[COL_STATUS].Items[i] <> 'Importing') then begin
      IniFile.DecryptIniFile(mlJobList.DesignColumns[COL_FULLJOBFILENAME].items[i], false);
      MemIniFile := TMemIniFile.create(mlJobList.DesignColumns[COL_FULLJOBFILENAME].items[i]);
      if not PlainOut then
        IniFile.EncryptIniFile(mlJobList.DesignColumns[COL_FULLJOBFILENAME].items[i]);
      try
//        mlJobList.DesignColumns[COL_DEFJOB].items[i] := 'DEF'; // remember where we got the setting from
        JobEnabled := SettingTF(JobSetting(MemIniFile, SCHEDULE, 'Enabled'));
        if JobEnabled then
          mlJobList.DesignColumns[COL_ENABLED].Items[i] := 'Yes'
        else
          mlJobList.DesignColumns[COL_ENABLED].Items[i] := 'No';
        if JobEnabled then begin
          NextRun := FindNextRun(MemIniFile);
          mlJobList.DesignColumns[COL_NEXTRUN].Items[i]         := FormatRunDateTime(NextRun);
          mlJobList.DesignColumns[COL_NEXTRUNDATETIME].Items[i] := DateTimeToStr(NextRun);
        end;
        if JobScheduler.MissedJob and (double(FMissedWhen) <> 0) then
          mlJobList.DesignColumns[COL_STATUS].Items[i] := ('Missed - ' + DateToStr(FMissedWhen) + ' ' + FormatDateTime('HH:nn',FMissedWhen));
      finally
        MemIniFile.free;
      end;
    end;
  end;
except on e:exception do
  ShowMessage(e.Message + ' while refreshing ' + FN);
end;
end;

procedure TfrmScheduler.ReleaseJob(AJobNo: integer);
// called in response to a WM_IMPORTJOB_RELEASED message from TJobQueue
// Changes the "Held" status back to the previous status
var
  ix: integer;
begin
  ix := FindJob(AJobNo);
  if ix = -1 then exit;

  ChangeJobStatus(ix, mlJobList.DesignColumns[COL_PREVIOUSSTATUS].Items[ix]);
  IsDirty;
end;

procedure TfrmScheduler.RestoreJobStatus(AJobIx: integer);
// changes the status column back to its previous status. I wonder why
// ReleaseJob doesn't call this ?
begin
  if AJobIx = -1 then exit;

  mlJobList.DesignColumns[COL_STATUS].Items[AJobIx] :=
                     mlJobList.DesignColumns[COL_PREVIOUSSTATUS].Items[AJobIx];
end;

procedure TfrmScheduler.Shutdown;
begin
  if mniSaveCoordinates.Checked then
    FormSaveSettings(Self, nil);
  FreeObjects([FDeletedJobs]);
end;

procedure TfrmScheduler.Startup;
begin
  ChangeCaption; // v.088
  MLInit(mlJobList);
  FormLoadSettings(Self, nil);
  MLLoadSettings(mlJobList, Self);
  FDeletedJobs := TStringList.Create;
  EnableDisableEtc;
  Timer.Enabled := true;
end;

procedure TfrmScheduler.Stop;
// called in response to a WM_IMPORTQUEUE_STOPPED message from TJobQueue
begin
//  Timer.Enabled          := false;
  FRunning               := false;
  EnableDisableEtc;
  ChangeCaption;
end;

{* Event Procedures *}

procedure TfrmScheduler.FormCreate(Sender: TObject);
begin
//  Startup; // v94 moved to the Create constructor as it wasn't being actioned at the correct point in Scheduler mode
end;

procedure TfrmScheduler.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Shutdown;
  action := caFree;
  frmScheduler := nil;
  if SchedulerMode then // selecting Exit from the tray icon closes the app
    application.MainForm.Close;
end;

procedure TfrmScheduler.btnCloseClick(Sender: TObject);
// When running in SchedulerMode from the Tray Icon, this button says "Hide"
begin
  if SchedulerMode then
    visible := false
  else
    close;
end;

procedure TfrmScheduler.mlJobListRowDblClick(Sender: TObject; RowIndex: Integer);
// Open the job file in the Build Job Wizard.
// If amendments are made and saved, the Wizard issues a WM_REFRESHJOBFILES
// message which causes TfrmScheduler to re-read the contents of the job file.
// This isn't allowed in SchedulerMode as the user has limited access to
// Importer's functionality when running in this mode.
begin
  if SchedulerMode then begin
    ShowMessage('You cannot edit Job Files while running in Scheduler Mode');
    exit;
  end;

  FDoubleClicking := true;

  TfrmWizard.Show(true, mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[RowIndex], true, handle);
end;

procedure TfrmScheduler.mlJobListChangeSelection(Sender: TObject);
// double-clicking a TMultilist list generates an OnChangeSelection event even
// when there hasn't been a change of selection.
begin
  if not FDoubleClicking then
    EnableDisableEtc;

  FDoubleClicking := false;
end;

procedure TfrmScheduler.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if AdminModeChanged(key) then
    ChangeCaption;
end;

procedure TfrmScheduler.btnDeleteJobClick(Sender: TObject);
// if a job has already been entered on the Job Queue we have to request that
// it's deleted, in which case the JobQueue issues a WM_IMPORTJOB_DELETED message.
// Otherwise, we can just delete it here.
begin
  if mlJobList.Selected = -1 then exit;

  if (mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] = 'Queued')
  or (mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] = 'Importing') then
    ImportJobQueue.DeleteJob(StrToInt(mlJobList.DesignColumns[COL_JOBNO].Items[mlJobList.Selected]))
  else begin
    FDeletedJobs.Add(LowerCase(mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[mlJobList.Selected]));
    MLDeleteRow(mlJobList, mlJobList.Selected);
    application.ProcessMessages;
    IsDirty;
  end;
end;

procedure TfrmScheduler.btnDeleteAllJobsClick(Sender: TObject);
// if a job has already been entered on the Job Queue we have to request that
// it's deleted, in which case the JobQueue issues a WM_IMPORTJOB_DELETED message.
// Otherwise, we can just delete it here.
// The button has been removed for now to simplify the UI - kept the code just
// in case it's every reinstated.
var
  i: integer;
  JobDeleted: boolean;
begin
  if mlJobList.ItemsCount = 0 then exit;

  JobDeleted := false;
  for i := mlJobList.ItemsCount - 1 downto 0 do
    if (mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] = 'Queued')
    or (mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] = 'Importing') then
      ImportJobQueue.DeleteJob(StrToInt(mlJobList.DesignColumns[COL_JOBNO].Items[i]))
    else begin
      MLDeleteRow(mlJobList, i);
      JobDeleted := true;
    end;

  if JobDeleted then
    IsDirty;
end;

procedure TfrmScheduler.btnHoldJobClick(Sender: TObject);
// if a job has already been entered on the Job Queue we have to request that
// it's held, in which case the JobQueue issues a WM_IMPORTJOB_HELD message.
// Otherwise, we can just set the status to Held here.
begin
  if mlJobList.Selected = -1 then exit;

  if (mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] = 'Queued')
  or (mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] = 'Importing') then
    ImportJobQueue.HoldJob(StrToInt(mlJobList.DesignColumns[COL_JOBNO].Items[mlJobList.Selected]))
  else begin
    ChangeJobStatus(mlJobList.Selected, 'Held');
    IsDirty;
  end;
end;

procedure TfrmScheduler.TimerTimer(Sender: TObject);
begin
  edtTime.text := FormatDateTime('hh:nn:ss', Time);
//  if copy(edtTime.text, 7, 2) = '00' then begin
  if copy(edtTime.text, 8, 1) = '0' then begin // every 10 seconds
    Timer.Enabled := false;
    if FRunning then
      QueueJobs;
    RefreshJobFiles;
    Timer.Enabled := true;
  end;
end;

procedure TfrmScheduler.FormShow(Sender: TObject);
begin
  if SchedulerMode then
    application.MainForm.Enabled := false;
end;

procedure TfrmScheduler.WMSysCommand(var msg: TWMSysCommand);
// If the user tries to minimize the window when Importer is running in SchedulerMode
// (meaning the main application window doesn't show) it gets hidden instead.
begin
  if not SchedulerMode then
    inherited
  else
    if (msg.CmdType = SC_MINIMIZE) or (msg.CmdType = SC_CLOSE) then
      visible := false
    else
      inherited;
end;

procedure TfrmScheduler.btnJobQueueClick(Sender: TObject);
begin
  TfrmJobQueue.Show;
end;

procedure TfrmScheduler.btnStopClick(Sender: TObject);
begin
  ImportJobQueue.Running := false;
end;

procedure TfrmScheduler.btnGoClick(Sender: TObject);
begin
  ImportJobQueue.Running := true;
end;

procedure TfrmScheduler.btnShowLogClick(Sender: TObject);
begin
  Logger.CloseLog(0); // app log will be re-opened automatically the next time it is written to

  TfrmViewLogFile.Show(AppLogFileName);
end;

procedure TfrmScheduler.btnHoldAllJobsClick(Sender: TObject);
// if a job has already been entered on the Job Queue we have to request that
// it's held, in which case the JobQueue issues a WM_IMPORTJOB_HELD message.
// Otherwise, we can just set the status to Held here.
var
  i: integer;
begin
  if mlJobList.ItemsCount = 0 then exit;

  for i := 0 to mlJobList.ItemsCount - 1 do
    if mlJobList.DesignColumns[COL_JOBNO].Items[i] <> '' then
      ImportJobQueue.HoldJob(StrToInt(mlJobList.DesignColumns[COL_JOBNO].Items[i]))
    else begin
      ChangeJobStatus(i, 'Held');
      IsDirty;
    end;
end;

procedure TfrmScheduler.btnReleaseJobClick(Sender: TObject);
// if a job has already been entered on the Job Queue we have to request that
// it's released, in which case the JobQueue issues a WM_IMPORTJOB_RELEASED message.
// Otherwise, we can just reset the status here.
begin
  if mlJobList.Selected = -1 then exit;

{* Just having a job number doesn't mean it's on the ImportJobQueue - it might have finished ! *} // so do both
  if mlJobList.DesignColumns[COL_JOBNO].Items[mlJobList.Selected] <> '' then
    ImportJobQueue.ReleaseJob(StrToInt(mlJobList.DesignColumns[COL_JOBNO].Items[mlJobList.Selected]));
//  else begin
    RestoreJobStatus(mlJobList.Selected);
    IsDirty;
//  end;

{* if the user does multiple "Hold All"/"Release", both the Status and PreviousStatus can end up as 'Held' *}
  if mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] = 'Held' then // if status is still 'Held' after the job has been released
    mlJobList.DesignColumns[COL_STATUS].Items[mlJobList.Selected] := ' ';        // ...blank it.
end;

procedure TfrmScheduler.btnReleaseAllJobsClick(Sender: TObject);
// if a job has already been entered on the Job Queue we have to request that
// it's released, in which case the JobQueue issues a WM_IMPORTJOB_RELEASED message.
// Otherwise, we can just reset the status here.
var
  i: integer;
begin
  if mlJobList.ItemsCount = 0 then exit;

  for i := 0 to mlJobList.ItemsCount - 1 do begin
    if mlJobList.DesignColumns[COL_JOBNO].Items[i] <> '' then
      ImportJobQueue.ReleaseJob(StrToInt(mlJobList.DesignColumns[COL_JOBNO].Items[i]));
//    else begin
      RestoreJobStatus(i);
      IsDirty;
{* if the user does multiple "Hold All"/"Release", both the Status and PreviousStatus can end up as 'Held' *}
    if mlJobList.DesignColumns[COL_STATUS].Items[i] = 'Held' then // if status is still 'Held' after the job has been released
      mlJobList.DesignColumns[COL_STATUS].Items[i] := ' ';        // ...blank it.
  end;
end;

procedure TfrmScheduler.btnRunNowClick(Sender: TObject);
begin
  if mlJobList.Selected = -1 then exit;
  FImporting := true; // disable the RunNow button until this job finishes
  EnableDisableEtc;

  ImportJobQueue.BeginUpdate; // prevent a new import job from starting while we queue this one
  QueueJob(mlJobList.Selected);
  ImportJobQueue.EndUpdate; // job queue can continue now.
end;

procedure TfrmScheduler.btnEditJobClick(Sender: TObject);
begin
  if SchedulerMode then begin
    ShowMessage('You cannot edit Job Files while running in Scheduler Mode');
    exit;
  end;

  FDoubleClicking := true;

  TfrmWizard.Show(true, mlJobList.DesignColumns[COL_FULLJOBFILENAME].Items[mlJobList.Selected], true, handle);
end;

{* Message Handlers *}

procedure TfrmScheduler.WMJobStarted(var Msg: TMessage);
begin
  JobStarted(Msg.WParam);
end;

procedure TfrmScheduler.WMJobFinished(var Msg: TMessage);
begin
  JobFinished(Msg.WParam, false);
end;

procedure TfrmScheduler.WMJobDeleted(var Msg: TMessage);
begin
  DeleteJob(Msg.WParam);
end;

procedure TfrmScheduler.WMJobHeld(var Msg: TMessage);
begin
  HoldJob(Msg.WParam);
end;

procedure TfrmScheduler.WMJobReleased(var Msg: TMessage);
begin
  ReleaseJob(Msg.WParam);
end;

procedure TfrmScheduler.WMImportQueueStarted(var Msg: TMessage);
begin
  Go;
end;

procedure TfrmScheduler.WMImportQueueStopped(var Msg: TMessage);
begin
  Stop;
end;

procedure TfrmScheduler.WMRefreshJobFiles(var Msg: TMessage);
begin
  RefreshJobFiles;
end;

procedure TfrmScheduler.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmScheduler.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

procedure TfrmScheduler.mniPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlJobList, Self, nil);
end;

procedure TfrmScheduler.mniSaveCoordinatesClick(Sender: TObject);
begin
  mniSaveCoordinates.Checked := not mniSaveCoordinates.Checked;
end;

procedure TfrmScheduler.WMJobFailed(var Msg: TMessage);
begin
  JobFinished(Msg.WParam, true);
end;

initialization
  frmScheduler := nil;

end.
