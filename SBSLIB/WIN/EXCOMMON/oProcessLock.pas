unit oProcessLock;

interface
{PR: 08/12/2017 ABSEXCH-19513
Amended the way the process works to allow some processes to run at the same
time. Changed sql from updating one record to adding one record for each
process. Changed CurrentProcessLock variable to a list containing one instance
of TProcessLock for each current lock.
}

uses
  ProcessLockF, Classes, SQLCallerU;

type
  TProcessLockDialogType = (pldMDI, pldNormal, pldNone);

  TProcessLockType = (plNone = 0,
                      plDayBookPost = 1,
                      plUnpost = 2,
                      plCheckStock = 3,
                      plCheckAccounts = 4,
                      plCheckCustStockAnal = 5,
                      plRevaluation = 6,
                      plMoveGLCode = 7,
                      plMoveStock = 8,
                      plRenameAccount = 9,
                      plRenameStock = 10,
                      plStockTake = 11,
                      plRollUpGLBudgets = 12,
                      plMoveJob = 13,
                      plUpdateJobBudgets = 14,
                      plCheckGLTotals = 15,
                      plCheckJobs = 16,
                      plRecalcJobContractTotals = 17,
                      plInvoiceDeliveries = 18,
                      plBankReconciliation = 19,
                      plUpdateGLViews = 20,
                      plPostJobDaybook = 21,
                      plSpecialFunction = 22,
                      plSystemSetup = 23,
                      plChangePeriod = 24,
                      plCurrency = 25,
                      plCISSetup = 26,
                      plVATSetup = 27,
                      plControlCodes = 28);



  procedure RemoveCurrentProcessLock(ProcessType : TProcessLockType);
  function ProcessDescription(ProcessType : TProcessLockType) : string;

  //DialogType parameter allows for dialog to be created for non-MDI apps
  function GetProcessLock(ProcessType : TProcessLockType; DialogType : TProcessLockDialogType = pldMDI) : Boolean;

  //Automatic retries with no dialog displayed
  function GetProcessLockWithRetry(ProcessLockType : TProcessLockType; Retries : Integer = 10) : Boolean;


implementation

uses
  oSystemSetup, SysUtils, DateUtils, Forms, Windows, Messages, VarConst, SQLUtils,
  ADOConnect, ADODB, GlobVar, EtDateU, oProcessLockSQL, Controls, SQLRep_Config,
  Contnrs;

const
  RETRY_SECONDS = 1; //ABSEXCH-19466 Changed from 5 to 1 to improve user experience
  ID_PROCESS_LOCK = 25; //SysId of ProcessLocktype in SystemSetup table

  DIALOG_DELAY_SECONDS = 60; //Delay before displaying dialog (ABSEXCH-19466)

type
  TProcessLock = Class
  private
    //Existing values read from the lock records
    FExistingProcessLockType : TProcessLockType;
    FExistingUserId : string;
    FExistingTimeStamp : string;


    FProcessLockSQL : IProcessLockSQL;
    FDialog : TfrmProcessLock;
    FDialogCancelled : Boolean;
    FDialogType : TProcessLockDialogType;

    FLocked : Boolean;

    //Identifier for this process
    FProcessType : TProcessLockType;

    //User id for this process
    FUserID : string;
    FTimeStamp : string;


    function GetUserID : string;
    procedure SetUserID(const Value : string);


    function GetProcessType : TProcessLockType;

    function ReadExisting : Boolean;
    function DoSetLock : Boolean;
    function ShowTheDialog : Boolean;
    procedure DialogCancelled(Sender : TObject);
    function DoLockRecord : Boolean;
    procedure DoUnlockRecord;
    function FormatTimeStamp(const Timestamp : string) : string;
  public
    function SetLock : Boolean;
    procedure RemoveLock;
    constructor Create(ProcessType : TProcessLockType);
    destructor Destroy; override;

    property UserID : string read GetUserID write SetUserID;
    property ProcessType : TProcessLockType read GetProcessType;

    property DialogType : TProcessLockDialogType read FDialogType write FDialogType;
  end;

var
  //PR: 08/12/2017 Changed from one ProcessLock to a list of ProcessLocks
  //to allow some processes to run at the same time

  CurrentProcessLocks : TObjectList;

//function to create an instance of TProcessType and try to create a lock
//If the lock is successful (after retries if necessary) then the instance will
//be added to CurrentProcessLocks list; if the user has cancelled the diaolog then
//this function will distroy the instance.
//On pervasive systems, the function will always return True so that the
//calling process continues as normal.
function GetProcessLock(ProcessType : TProcessLockType; DialogType : TProcessLockDialogType = pldMDI) : Boolean;
var
  ProcessLock : TProcessLock;
begin
  if SQLUtils.UsingSQLAlternateFuncs and
     //PR: 22/11/2017 ABSEXCH-19466 Turn off lock mechanism if not using SQL Posting
     (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] = psPassed) and
     (ProcessType <> plNone) then
  begin
    ProcessLock := TProcessLock.Create(ProcessType);
    ProcessLock.DialogType := DialogType;

    Result := ProcessLock.SetLock;
    if not Result then
      FreeAndNil(ProcessLock);
  end
  else
    Result := True;
end;

function GetProcessLockWithRetry(ProcessLockType : TProcessLockType; Retries : Integer = 10) : Boolean;
var
  StartTime : TDateTime;
  Tries : Integer;
begin
  StartTime := Now;
  Tries := 0;

  //Initial try
  Result := GetProcessLock(ProcessLockType, pldNone);

  //Keep trying until successful or reached required number of retries
  while (not Result) and (Tries < Retries) do
  begin
    if SecondsBetween(Now, StartTime) > RETRY_SECONDS then
    begin
      Result := GetProcessLock(ProcessLockType, pldNone);
      StartTime := Now;
      Inc(Tries);
    end;
    Application.ProcessMessages;
  end;
end;


//In Enter1 this is called from EParentU when processes finish and the lock
//can be removed
procedure RemoveCurrentProcessLock(ProcessType : TProcessLockType);
var
  i : Integer;
  ProcessLock : TProcessLock;
begin
  for i := 0 to CurrentProcessLocks.Count - 1 do
  begin
    ProcessLock := TProcessLock(CurrentProcessLocks[i]);
    if (ProcessLock.ProcessType = ProcessType) then
    begin
      CurrentProcessLocks.Delete(i);
      Break;
    end;
  end;
end;

{ TProcessLock }

constructor TProcessLock.Create(ProcessType : TProcessLockType);
var
  sConnect : AnsiString;
begin
  inherited Create;
  FProcessType := ProcessType;
  FLocked := False;

  FProcessLockSQL := GetProcessLockSQL(FProcessType);
end;

function TProcessLock.GetUserID: string;
begin
  Result := FUserID;
end;

procedure TProcessLock.SetUserID(const Value: string);
begin
  FUserId := Value;
end;


//Try to populate the lock records
function TProcessLock.DoSetLock: Boolean;

  function CanRun : Boolean;
  begin
    //If a daybook post is running then nothing else can run
    Result := (FProcessLockSQL.ExistingProcessLockType <> plDaybookPost);

    //Daybook post not already running - if this is a daybook post
    //then it can only run if nothing else is; if it's any other process
    //then it can run
    if Result then
      Result := (FProcessType <> plDayBookPost) or
                (FProcessLockSQL.ExistingProcessLockType = plNone);
  end;
begin
  FLocked := False;

  //Create sql interface
  if not Assigned(FProcessLockSQL) then
    FProcessLockSQL := GetProcessLockSQL(FProcessType);

  //Get existing values
  FProcessLockSQL.ReadExisting;

  //If we're allowed to run then add a lock record
  if CanRun then
  begin
    Result := DoLockRecord;

    if Result then
    begin
      FLocked := True;
      CurrentProcessLocks.Add(Self);
    end;
  end
  else
  begin
    //Store existing values
    FExistingProcessLockType := FProcessLockSQL.ExistingProcessLockType;
    FExistingUserId := FProcessLockSQL.ExistingUserId;
    FExistingTimeStamp := FProcessLockSQL.ExistingTimeStamp;

    Result := False;

    //Release sql interface - if we keep the same instance, it seems to
    //keep returning the same data, even after the other transaction has
    //been rolled back
    FProcessLockSQL := nil;
  end;
end;

procedure TProcessLock.RemoveLock;
begin
  DoUnlockRecord;
end;

//Show the dialog
function TProcessLock.ShowTheDialog : Boolean;
begin
  FDialogCancelled := False;
  Result := True; //Default to avoid warning

  //If we're not in an MDI application then we need to create the form as
  //a normal form
  if FDialogType = pldNormal then
    FDialog := TfrmProcessLock.CreateWithMode(Application.MainForm, pfmNormal)
  else //Create as MDI child
    FDialog := TfrmProcessLock.Create(Application.MainForm);

  FDialog.CancelProcedure := DialogCancelled;
  FDialog.Caption := ProcessDescription(FProcessType);
  FDialog.lblProcessType.Caption := 'Running Process: ' + ProcessDescription(FExistingProcessLockType);
  FDialog.lblUserID.Caption := 'User: ' + FExistingUserID;
  FDialog.lblTimestamp.Caption := 'Time Started: ' + FormatTimeStamp(FExistingTimeStamp);

  //If not MDI then we need to show the form
  if FDialogType = pldNormal then
  begin
    FDialog.RetryProc := DoSetLock;
    FDialog.ShowModal;
    Result := FDialog.ModalResult = mrOK;
  end;
end;

function TProcessLock.SetLock: Boolean;
var
  StartTime : TDateTime;
  FirstStart : TDateTime;
begin
  //Not used in Pervasive so return 0
  if SQLUtils.UsingSQLAlternateFuncs then
  begin
    //Call function to populate the process lock record
    Result := DoSetLock;

    //Non-zero result means that it's already populated.
    //PR: 16/11/2017 ABSEXCH-19466 Try for 1 minute before showing dialog
    FirstStart := Now;
    StartTime := Now;

    //No dialog so change cursor to show something is happening
    Screen.Cursor := crHourglass;
    Try
      while (not Result) and (SecondsBetween(Now, FirstStart) < DIALOG_DELAY_SECONDS) do
      begin
        if SecondsBetween(Now, StartTime) > RETRY_SECONDS then
        begin
          Result := DoSetLock;
          StartTime := Now;
        end;
        Application.ProcessMessages;
      end;
    Finally
      Screen.Cursor := crDefault;
    End;

    //If required, show dialog and keep trying until successful or user cancels
    if (not Result) and (DialogType <> pldNone) then
    begin
      if DialogType = pldMDI then
        ShowTheDialog
      else
      begin
        Result := ShowTheDialog;
        FDialog := nil;
      end;
      StartTime := Now;
      while (not Result) and not FDialogCancelled do
      begin
        if SecondsBetween(Now, StartTime) > RETRY_SECONDS then
        begin
          Result := DoSetLock;
          StartTime := Now;
        end;
        Application.ProcessMessages;
      end;
      if Assigned(FDialog) then
      begin
        PostMessage(FDialog.Handle, WM_Close,0,0);
        FDialog := nil;
      end;
    end;
  end
  else
    Result := True;
end;

procedure TProcessLock.DialogCancelled(Sender: TObject);
begin
  FDialogCancelled := True;
end;

function ProcessDescription(ProcessType : TProcessLockType) : string;
const
  ProcessDesc : Array[TProcessLockType] of string[31] =
                     ('None',
                      'DayBook Post',
                      'Unpost',
                      'Check Stock',
                      'Check Accounts',
                      'Check Customer Stock Analysis',
                      'Currency Revaluation',
                      'Move GL Code',
                      'Move Stock',
                      'Rename Account',
                      'Rename Stock',
                      'StockTake',
                      'Roll Up GL Budgets',
                      'Move Job',
                      'UpdateBudgets',
                      'Check GL Totals',
                      'Check Jobs',
                      'Recalculate Job Contract Totals',
                      'Invoice Deliveries',
                      'Bank Reconciliation',
                      'Update GL Views',
                      'Job Daybook Post',
                      'SpecialFunction',
                      'Edit System Setup',
                      'Change Period',
                      'Edit Currency',
                      'Edit CIS Setup',
                      'Edit VAT Setup',
                      'Edit Control Codes');

begin
  Result := Trim(ProcessDesc[ProcessType]);
end;

function TProcessLock.GetProcessType: TProcessLockType;
begin
  Result := FProcessType;
end;

//Read existing values from the lock records
function TProcessLock.ReadExisting : Boolean;
begin
  Result := FProcessLockSQL.ReadExisting;
end;

function TProcessLock.DoLockRecord: Boolean;
begin
  Result := FProcessLockSQL.CreateLock;
end;

procedure TProcessLock.DoUnlockRecord;
begin
  FProcessLockSQL.ReleaseLock;
end;

destructor TProcessLock.Destroy;
begin
  FProcessLockSQL := nil;
  inherited;
end;

//Formate yyyymmddhhnnss timestamp to readable format
function TProcessLock.FormatTimeStamp(const Timestamp: string): string;
begin
  Result := Format('%s %s:%s:%s', [POutDate(Copy(TimeStamp, 1, 8)),
                                   Copy(TimeStamp, 9, 2),
                                   Copy(TimeStamp, 11, 2),
                                   Copy(TimeStamp, 13, 2)]);
end;



Initialization

  CurrentProcessLocks := TObjectList.Create;

Finalization
  FreeAndNil(CurrentProcessLocks);

end.
