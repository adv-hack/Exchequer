unit JobQueue;

{******************************************************************************}
{ Job Queue provides the visual representation of the operations of TJobQueue. }
{ TJobQueue is responsible for executing each import job in turn and           }
{ TfrmJobQueue indicates success or failure to the user and gives them the     }
{ means to control TJobQueue's functions.                                      }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, uMultiList, GlobalTypes,
  psvDialogs, Menus, TImportJobClass, TJobQueueClass;

type

  TfrmJobQueue = class(TForm)
    PageControl: TPageControl;
    tsSettings: TTabSheet;
    gbSettings: TGroupBox;
    mlJobQueue: TMultiList;
    btnStop: TButton;
    btnGo: TButton;
    btnClose: TButton;
    btnHoldJob: TButton;
    btnReleaseJob: TButton;
    btnDeleteJob: TButton;
    btnDeleteAllJobs: TButton;
    PopupMenu: TPopupMenu;
    mniHoldJob: TMenuItem;
    mniReleaseJob: TMenuItem;
    mniDeleteJob: TMenuItem;
    N1: TMenuItem;
    mniProperties: TMenuItem;
    mniSaveCoordinates: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure mlJobQueueRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlJobQueueChangeSelection(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnRefreshSettingsClick(Sender: TObject);
    procedure btnDeleteJobClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnHoldJobClick(Sender: TObject);
    procedure btnHoldAllJobsClick(Sender: TObject);
    procedure btnReleaseJobClick(Sender: TObject);
    procedure btnReleaseAllJobsClick(Sender: TObject);
    procedure btnDeleteAllJobsClick(Sender: TObject);
    procedure WMSysCommand(var msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMNewJob(var Msg: TMessage); message WM_IMPORTJOB_NEWJOB;
    procedure WMJobStarted(var Msg: TMessage); message WM_IMPORTJOB_STARTED;
    procedure WMJobFinished(var Msg: TMessage); message WM_IMPORTJOB_FINISHED;
    procedure WMJobHeld(var Msg: TMessage); message WM_IMPORTJOB_HELD;
    procedure WMJobReleased(var Msg: TMessage); message WM_IMPORTJOB_RELEASED;
    procedure WMJobDeleted(var Msg: TMessage); message WM_IMPORTJOB_DELETED;
    procedure WMImportQueueStarted(var Msg: TMessage); message WM_IMPORTQUEUE_STARTED;
    procedure WMImportQueueStopped(var Msg: TMessage); message WM_IMPORTQUEUE_STOPPED;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniPropertiesClick(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override;
  private
{* internal fields *}
    FDoubleClicking: boolean;
    FSettingType: TSettingType;
    FDeleting: boolean;
    FIsDirty: boolean;
{* property fields *}
{* procedural methods *}
    function  AddJob(ImportJob: TImportJob): integer;
    procedure ChangeCaption;
    procedure CheckColour;
    procedure DeleteJob(AJobNo: integer; AFileNo: integer);
    procedure EnableDisableEtc;
    function  FindJob(AJobNo: integer; AFileNo: integer): integer;
    procedure HoldJob(AJobNo: integer);
    procedure GetCurrentJobList;
    procedure InitForm;
    procedure IsDirty;
    procedure JobFinished(AJobNo: integer; AFileNo: integer);
    procedure JobStarted(AJobNo: integer; AFileNo: integer);
    procedure ReleaseJob(AJobNo: integer);
    procedure Shutdown;
    procedure Startup;
    function  AnyJobStatus(AJobStatus: string): boolean;
    procedure ChangeJobStatus(AJobIx: integer; AJobStatus: string);
    function  JobStatus(AJobIx: integer): string;
    procedure RestoreJobStatus(AJobIx: integer);
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show;
    class procedure CloseWindow;
  end;

implementation

uses utils, GlobalConsts, TIniClass, MapMaint, IniMaint, LoginF, ViewLogFile,
     Scheduler;

const
  COL_DEFJOB         = 0;
  COL_JOBNO          = 1;
  COL_FILENO         = 2;
  COL_STATUS         = 3;
  COL_FILENAME       = 4;
  COL_JOBFILE        = 5;
  COL_LOGFILENAME    = 6;
  COL_PREVIOUSSTATUS = 7;

var
  frmJobQueue: TfrmJobQueue;

{$R *.dfm}

class procedure TfrmJobQueue.Show;
// overrides the inherited Show method.
// Callers must call "TrmScheduler.Show" to display this form.
// This method takes care of creating an instance if necessary.
begin
  if not assigned(frmJobQueue) then
    frmJobQueue := TfrmJobQueue.Create(nil);

  frmJobQueue.ChangeCaption;

// inherited show
  frmJobQueue.visible := true;
  frmJobQueue.BringToFront;

  frmJobQueue.EnableDisableEtc;
end;

class procedure TfrmJobQueue.CloseWindow;
begin
  if assigned(frmJobQueue) then
    frmJobQueue.Close;
end;

constructor TfrmJobQueue.create(AOwner: TComponent);
// Reduced visibility to discourage creation of more than one instance.
// Accepted method of displaying this form is to call "TfrmJobQueue.show"
// or "TfrmJobQueue.CreateHidden".
// which creates an instance if one doesn't already exist.
begin
  inherited create(AOwner);
  InitForm;

  SetConstraints(Constraints, height, width);
end;

{* Procedural Methods *}

procedure TfrmJobQueue.InitForm;
begin
  if not SchedulerMode then
    FormStyle := fsMDIChild;

  ImportJobQueue.Poster.RegisterWindow(handle); // tell job queue we want to receive it's messages
end;

function TfrmJobQueue.AddJob(ImportJob: TImportJob): integer;
begin
  mlJobQueue.DesignColumns[COL_JOBNO].Items.Add(IntToStr(ImportJob.JobNo));
  mlJobQueue.DesignColumns[COL_JOBFILE].Items.Add(ExtractFileName(ImportJob.JobFile));
  mlJobQueue.DesignColumns[COL_FILENO].Items.Add(IntToStr(ImportJob.FileNo));
  mlJobQueue.DesignColumns[COL_FILENAME].Items.Add(ImportJob.ImportFileName);
  mlJobQueue.DesignColumns[COL_LOGFILENAME].Items.Add(ImportJob.LogFileName);
  application.ProcessMessages; // otherwise multilist.ItemsCount doesn't update
  MLSelectFirst(mlJobQueue);
  result := mlJobQueue.ItemsCount - 1;
  EnableDisableEtc;
end;

function TfrmJobQueue.AnyJobStatus(AJobStatus: string): boolean;
// returns true if any job's status matches the parameter
var
  i: integer;
begin
  Result := False;
  for i := 0 to mlJobQueue.ItemsCount - 1 do begin
    result := JobStatus(i) = AJobStatus;
    if result then exit;
  end;
end;

procedure TfrmJobQueue.ChangeCaption;
var
  s: string;
begin
  if ImportJobQueue.Running then
    s := ' - [<Running>]'
  else
    s := ' - [<Stopped>]';

  if FIsDirty then
    s := s + '*';

  Caption := format('Import Job Queue%s', [s]);

  if SchedulerMode then
    btnClose.Caption := 'Hide'
  else
    btnClose.Caption := 'Close';
end;

procedure TfrmJobQueue.ChangeJobStatus(AJobIx: integer; AJobStatus: string);
begin
  if AJobIx = -1 then exit;

  mlJobQueue.DesignColumns[COL_PREVIOUSSTATUS].Items[AJobIx] :=
                              mlJobQueue.DesignColumns[COL_STATUS].Items[AJobIx]; // save the current status

  mlJobQueue.DesignColumns[COL_STATUS].Items[AJobIx] := AJobStatus;
end;

procedure TfrmJobQueue.CheckColour;
// if a row in the ML has been flagged for deletion highlight it in red
// otherwise highlight a row in white.
begin
  if mlJobQueue.Selected = -1 then exit;
  if mlJobQueue.DesignColumns[COL_DEFJOB].Items[mlJobQueue.Selected] = 'ERR' then
    mlJobQueue.HighlightFont.Color := clRed
  else
    mlJobQueue.HighlightFont.Color := clWhite;
end;

procedure TfrmJobQueue.DeleteJob(AJobNo: integer; AFileNo: integer);
var
  ix: integer;
begin
  ix := FindJob(AJobNo, AFileNo);

  if ix <> -1 then
    MLDeleteRow(mlJobQueue, ix);
end;

procedure TfrmJobQueue.EnableDisableEtc;
// change what's enabled/disabled depending on which tabsheet is being viewed.
begin
  if PageControl.ActivePage = tsSettings then begin
    btnHoldJob.Enabled             := (mlJobQueue.ItemsCount <> 0) and (mlJobQueue.Selected <> -1) and (JobStatus(mlJobQueue.Selected) <> 'Held');
//    btnHoldAllJobs.Enabled         := mlJobQueue.ItemsCount <> 0;
    btnReleaseJob.Enabled          := (mlJobQueue.ItemsCount <> 0) and (mlJobQueue.Selected <> -1) and (JobStatus(mlJobQueue.Selected) = 'Held');
//    btnReleaseAllJobs.Enabled      := (mlJobQueue.ItemsCount <> 0) and AnyJobStatus('Held');
    btnDeleteJob.Enabled           := (mlJobQueue.ItemsCount <> 0) and (mlJobQueue.Selected <> -1) and not ImportJobQueue.Running;
    btnDeleteAllJobs.Enabled       := mlJobQueue.DesignColumns[0].Items.Count <> 0;
  end;

  btnStop.Enabled                  := ImportJobQueue.Running;
  btnGo.Enabled                    := not ImportJobQueue.Running;
end;

function TfrmJobQueue.FindJob(AJobNo, AFileNo: integer): integer;
var
  i: integer;
  JobNo: string;
  FileNo: string;
begin
  JobNo  := IntToStr(AJobNo);
  FileNo := IntToStr(AFileNo);

  result := -1;
  i := -1;

  try
  for i := 0 to mlJobQueue.ItemsCount - 1 do
    if  (mlJobQueue.DesignColumns[COL_JOBNO].items[i] = JobNo)
    and (mlJobQueue.DesignColumns[COL_FILENO].items[i] = FileNo) then begin
      result := i;
      break;
  end;
  except
    ShowMessage('2. invalid row ' + IntToStr(i));
  end;
end;

procedure TfrmJobQueue.GetCurrentJobList;
var
  i: integer;
begin
  mlJobQueue.ClearItems;
  for i := 0 to ImportJobQueue.JobCount - 1 do begin
    mlJobQueue.DesignColumns[COL_JOBNO].Items.Add(IntToStr(ImportJobQueue.Jobs[i].JobNo));
    mlJobQueue.DesignColumns[COL_JOBFILE].Items.Add(ExtractFileName(ImportJobQueue.Jobs[i].JobFile));
    mlJobQueue.DesignColumns[COL_FILENO].Items.Add(IntToStr(ImportJobQueue.Jobs[i].FileNo));
    mlJobQueue.DesignColumns[COL_FILENAME].Items.Add(ImportJobQueue.Jobs[i].ImportFileName);
    mlJobQueue.DesignColumns[COL_LOGFILENAME].Items.Add(ImportJobQueue.Jobs[i].LogFileName);
  end;
  application.ProcessMessages; // other MultiList.ItemsCount doesn't get updated in time for next bit of code
  MLSelectFirst(mlJobQueue);
end;

procedure TfrmJobQueue.HoldJob(AJobNo: integer);
// holds the entire job not just the one file - so finds all files with the
// same job number and sets their status to Held
var
  i: integer;
begin
  for i := 0 to mlJobQueue.ItemsCount -1 do
    if mlJobQueue.DesignColumns[COL_JOBNO].Items[i] = IntToStr(AJobNo) then
      ChangeJobStatus(i, 'Held');

  IsDirty;
end;

procedure TfrmJobQueue.IsDirty;
// the job list has been altered.
begin
  FIsDirty := true;
  ChangeCaption;
  EnableDisableEtc;
end;

procedure TfrmJobQueue.JobFinished(AJobNo: integer; AFileNo: integer);
var
  ix: integer;
begin
  ix := FindJob(AJobNo, AFileNo);
  if ix <> -1 then begin
    mlJobQueue.DesignColumns[COL_STATUS].Items[ix] := 'Finished';
    application.ProcessMessages;
  end;
end;

procedure TfrmJobQueue.JobStarted(AJobNo: integer; AFileNo: integer);
var
  ix: integer;
begin
  ix := FindJob(AJobNo, AFileNo);
  if ix <> -1 then begin
    mlJobQueue.Selected := ix;
    mlJobQueue.DesignColumns[COL_STATUS].Items[ix] := 'Importing';
  end;
end;

function TfrmJobQueue.JobStatus(AJobIx: integer): string;
begin
  if AJobIx = -1 then exit;

  result := mlJobQueue.DesignColumns[COL_STATUS].Items[AJobIx];
end;

procedure TfrmJobQueue.RestoreJobStatus(AJobIx: integer);
begin
  if AJobIx = -1 then exit;

  mlJobQueue.DesignColumns[COL_STATUS].Items[AJobIx] :=
                      mlJobQueue.DesignColumns[COL_PREVIOUSSTATUS].Items[AJobIx];
end;

procedure TfrmJobQueue.ReleaseJob(AJobNo: integer);
// changes the status of all items with a matching job number to the status
// it had prior to the job being held
var
  i: integer;
begin
  for i := 0 to mlJobQueue.ItemsCount - 1 do
    if mlJobQueue.DesignColumns[COL_JOBNO].Items[i] = IntToStr(AJobNo) then
     ChangeJobStatus(i, mlJobQueue.DesignColumns[COL_PREVIOUSSTATUS].Items[i]);

  IsDirty;
end;

procedure TfrmJobQueue.Shutdown;
begin
  if mniSaveCoordinates.Checked then
    FormSaveSettings(Self, nil);
//  FreeObjects([FIniSections]);
end;

procedure TfrmJobQueue.Startup;
begin
  MLInit(mlJobQueue);
  FormLoadSettings(Self, nil);
  MLLoadSettings(mlJobQueue, Self);
  EnableDisableEtc;
  GetCurrentJobList;
end;

{* Event Procedures *}

procedure TfrmJobQueue.FormCreate(Sender: TObject);
begin
  Startup;
end;

procedure TfrmJobQueue.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Shutdown;
  action := caFree;
  frmJobQueue := nil;
end;

procedure TfrmJobQueue.btnCloseClick(Sender: TObject);
begin
  if SchedulerMode then
    visible := false
  else begin
    close;
//    left := 0 - width; // who says you can't hide an MDIChild ?  :)
//    application.MainForm.Next;
  end;
end;

procedure TfrmJobQueue.mlJobQueueRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true;

  TfrmViewLogFile.Show(mlJobQueue.DesignColumns[COL_LOGFILENAME].Items[RowIndex]);
end;

procedure TfrmJobQueue.mlJobQueueChangeSelection(Sender: TObject);
begin
  if not FDoubleClicking then
    EnableDisableEtc;

  CheckColour;

  FDoubleClicking := false;
end;

procedure TfrmJobQueue.btnSaveClick(Sender: TObject);
begin
//  DoSettings(slSave, FIniSection);
end;

procedure TfrmJobQueue.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if AdminModeChanged(key) then
    ChangeCaption;
end;

procedure TfrmJobQueue.btnRefreshSettingsClick(Sender: TObject);
begin
//  DoSettings(slLoad, 'name of job file ?');
end;

procedure TfrmJobQueue.btnDeleteJobClick(Sender: TObject);
begin
  if mlJobQueue.Selected = -1 then exit;

  ImportJobQueue.DeleteJob(StrToInt(mlJobQueue.DesignColumns[COL_JOBNO].Items[mlJobQueue.Selected]));
end;

procedure TfrmJobQueue.btnStopClick(Sender: TObject);
begin
  ImportJobQueue.Running := false;
  ChangeCaption;
  EnableDisableEtc;
end;

procedure TfrmJobQueue.btnGoClick(Sender: TObject);
begin
  ImportJobQueue.Running := true;
  application.ProcessMessages;
  ChangeCaption;
  EnableDisableEtc;
end;

procedure TfrmJobQueue.FormShow(Sender: TObject);
begin
//  left := 450;
end;

procedure TfrmJobQueue.FormActivate(Sender: TObject);
begin
//  left := 450;
end;

procedure TfrmJobQueue.btnHoldJobClick(Sender: TObject);
// Requests that ImportJobQueue holds the job. If successful, ImportJobQueue
// issues a WM_IMPORTJOB_HELD message which is handled by the WMJOBHELD proc.
begin
  if mlJobQueue.Selected = -1 then exit;

  ImportJobQueue.HoldJob(StrToInt(mlJobQueue.DesignColumns[COL_JOBNO].Items[mlJobQueue.Selected]));
end;

procedure TfrmJobQueue.btnHoldAllJobsClick(Sender: TObject);
// causes all jobs to be held
var
  i: integer;
begin
  for i := 0 to mlJobQueue.ItemsCount - 1 do
    ImportJobQueue.HoldJob(StrToInt(mlJobQueue.DesignColumns[COL_JOBNO].Items[i]));
end;

procedure TfrmJobQueue.btnReleaseJobClick(Sender: TObject);
// sets the displayed status of a job to the status it had before it was Held
begin
  if mlJobQueue.Selected = -1 then exit;

  ImportJobQueue.ReleaseJob(StrToInt(mlJobQueue.DesignColumns[COL_JOBNO].Items[mlJobQueue.Selected]));
end;

procedure TfrmJobQueue.btnReleaseAllJobsClick(Sender: TObject);
var
  i: integer;
begin
  if mlJobQueue.ItemsCount = 0 then exit;

  for i := 0 to mlJobQueue.ItemsCount - 1 do
    ImportJobQueue.ReleaseJob(StrToInt(mlJobQueue.DesignColumns[COL_JOBNO].Items[i]));
end;

procedure TfrmJobQueue.btnDeleteAllJobsClick(Sender: TObject);
// requests that ImportJobQueue deletes the job.
// ImportJobQueue responds by sending a WM_IMPORTJOB_DELETED message for each
// JobNo/FileNo on the queue.
// We only call DeleteJob once for each distinct JobNo;
// We can't loop through the ML rows because TJobQueue.DeleteJob is sending
// WM_IMPORTJOB_DELETE messages which is causing TfrmJobQueue.DeleteJob to
// delete rows from the ML.
begin
  if mlJobQueue.ItemsCount = 0 then exit;

  while mlJobQueue.ItemsCount > 0 do begin
    ImportJobQueue.DeleteJob(StrToInt(mlJobQueue.DesignColumns[COL_JOBNO].Items[0]));
    application.ProcessMessages; // Process the WM_IMPORT_DELETED message for the deleted job
  end;

  IsDirty;
end;

{* Message Handlers *}

procedure TfrmJobQueue.WMJobFinished(var Msg: TMessage);
begin
  JobFinished(Msg.WParam, Msg.LParam); // JobNo and FileNo
end;

procedure TfrmJobQueue.WMJobHeld(var Msg: TMessage);
begin
  HoldJob(msg.WParam); // JobNo
end;

procedure TfrmJobQueue.WMJobStarted(var Msg: TMessage);
begin
  JobStarted(Msg.wParam, Msg.lParam); // JobNo, FileNo
end;

procedure TfrmJobQueue.WMNewJob(var Msg: TMessage);
begin
  AddJob(TImportJob(Msg.WParam)); // TImportJob in WParam
end;


procedure TfrmJobQueue.WMJobReleased(var Msg: TMessage);
begin
  ReleaseJob(Msg.WParam); // JobNo
end;

procedure TfrmJobQueue.WMJobDeleted(var Msg: TMessage);
begin
  DeleteJob(Msg.WParam, Msg.LParam);
end;

procedure TfrmJobQueue.WMImportQueueStarted(var Msg: TMessage);
begin
  ChangeCaption;
  EnableDisableEtc;
end;

procedure TfrmJobQueue.WMImportQueueStopped(var Msg: TMessage);
begin
  ChangeCaption;
  EnableDisableEtc;
end;

procedure TfrmJobQueue.WMSysCommand(var msg: TWMSysCommand);
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

{* Message Handlers *}
procedure TfrmJobQueue.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmJobQueue.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

procedure TfrmJobQueue.mniPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlJobQueue, Self, nil);
end;

procedure TfrmJobQueue.mniSaveCoordinatesClick(Sender: TObject);
begin
  mniSaveCoordinates.Checked := not mniSaveCoordinates.Checked;
end;

initialization
  frmJobQueue := nil;

end.
