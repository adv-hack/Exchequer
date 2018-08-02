unit SQLCheckAllJobsFrmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, StdCtrls, ComCtrls, ExtCtrls, AdvProgressBar,
  GlobVar,
  SQLCallerU,
  SQLUtils,
  SQLThreadU,
  EntLoggerClass,
  EntLogIniClass;

type
  TSQLCheckAllJobsFrm = class(TForm)
    MainPanel: TPanel;
    ButtonPanel: TPanel;
    btnNext: TButton;
    btnCancel: TButton;
    PageControl: TPageControl;
    ConfirmationPage: TTabSheet;
    ProgressPage: TTabSheet;
    FinishPage: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    lblFinish: TLabel;
    ProgressBar: TAdvProgressBar;
    chkRecreateAnalysisControlRecords: TCheckBox;
    procedure btnNextClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FSQLCaller: TSQLCaller;
    FCompanyCode: AnsiString;
    FVerified: Boolean;

    // Logger instance for recording data discrepancies to a CSV file
    FLog: TEntBaseLogger;

    // Reference to the form which this wizard was originally launched from.
    // This will either be the main Exchequer window (via the Check All Jobs
    // item from the Utilities/Data Rebuild menu) or the Job Tree window. It
    // must never be nil.
    FSender: TForm;

    // Pointers to field objects returned from query.
    FErrorNo: TIntegerField;   // IntegrityErrorNo
    FErrorCode: TStringField;  // IntegrityErrorCode
    FErrorMessage: TMemoField; // IntegrityErrorMessage
    FErrorTable: TStringField; // TableName

    // Prepares the field objects, binding them to the relevant columns in
    // the SQL recordset returned by the Verify Job Data stored procedure.
    procedure PrepareFields;

    // Calls the Verify Job Data stored procedure and copies any errors into
    // the Error list. If no errors are found, moves automatically on to the
    // next page of the wizard (the Progress page).
    procedure VerifyData;

    // Calls the actual Check All Job Totals stored procedure.
    procedure Process;

    // Displays the specified error message on the last page of the wizard,
    // and switches to this page
    procedure ShowError(Msg: string);

    // Switches to the specified page and sets up the buttons appropriately.
    procedure ChangePageTo(Page: TTabSheet);

    // Switches the progress bar on and off
    procedure StartProgress;
    procedure StopProgress;
  public
    { Public declarations }
    property Sender: TForm read FSender write FSender;
  end;

procedure SQLCheckAllJobs(Sender: TForm);

implementation

{$R *.dfm}

uses JobPostU, BtSupU1, SQLCheckAllJobsWarningFrmU, ADOConnect, oProcessLock;

// -----------------------------------------------------------------------------

procedure SQLCheckAllJobs(Sender: TForm);
var
  CheckFrm: TSQLCheckAllJobsFrm;
begin
  //PR: 23/05/2017 ABSEXCH-18683 Try to get process lock
  if not GetProcessLock(plCheckJobs) then
    EXIT;
  CheckFrm := TSQLCheckAllJobsFrm.Create(nil);
  try
    // Assign the sender -- a message will be sent to this form when the
    // process has completed, so that the sender form can update (this is
    // used when this routine is called from the Job Tree).
    CheckFrm.Sender := Sender;
    CheckFrm.ShowModal;
  finally
    CheckFrm.Free;
  end;
end;

// =============================================================================
// TCheckAllJobsFrm
// =============================================================================

procedure TSQLCheckAllJobsFrm.btnNextClick(Sender: TObject);
begin
  if (PageControl.ActivePage = ConfirmationPage) then
  begin
    // CJS 2015-03-06 - ABSEXCH-16133 - include option to run original routine
    if chkRecreateAnalysisControlRecords.Checked then
    begin
      // Run the original routines
      FVerified := False;
      Process;
    end
    else
      VerifyData;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.ChangePageTo(Page: TTabSheet);
begin
  PageControl.ActivePage := Page;
  if PageControl.ActivePage = ConfirmationPage then
  begin
    btnNext.Visible := True;
    btnNext.Enabled := True;
    btnNext.Caption := 'C&onfirm';
    btnCancel.Enabled := True;
    btnCancel.Caption := '&Cancel';
  end
  else if PageControl.ActivePage = ProgressPage then
  begin
    btnNext.Visible := False;
    btnCancel.Caption := '&Close';
    btnCancel.Enabled := False;
  end
  else if PageControl.ActivePage = FinishPage then
  begin
    btnNext.Visible := False;
    btnCancel.Caption := '&Close';
    btnCancel.Enabled := True;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.FormCreate(Sender: TObject);
begin
  // Create and initialise a SQL Caller instance for running the stored
  // procedures
  FSQLCaller := TSQLCaller.Create(GlobalADOConnection);
  // Determine the company code, based on the current Exchequer path
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  // 60 min timeout
  FSQLCaller.Connection.CommandTimeout := 3600;
  FSQLCaller.Query.CommandTimeout := 3600;

  // Create a TEntBaseLogger instance
  StartLogging(SetDrive);
  FLog := TEntBaseLogger.Create('JobCosting');
  FLog.Level := llError;

  // The Verified flag will be set to True if data verification succeeds, and
  // is then used to determine whether to run the SQL-optimised Check All Jobs
  // or the original version.
  FVerified  := False;

  // Make sure we start on the first page
  ChangePageTo(ConfirmationPage);
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.FormDestroy(Sender: TObject);
begin
  StopLogging;
  if Assigned(FSQLCaller) then
    FreeAndNil(FSQLCaller);
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.PrepareFields;
begin
  // Bind our internal variables to the matching fields in the recordset
  FErrorNo      := FSQLCaller.Records.FieldByName('IntegrityErrorNo') as TIntegerField;
  FErrorCode    := FSQLCaller.Records.FieldByName('IntegrityErrorCode') as TStringField;
  FErrorMessage := FSQLCaller.Records.FieldByName('IntegrityErrorMessage') as TMemoField;
  FErrorTable   := FSQLCaller.Records.FieldByName('TableName') as TStringField;
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.Process;
var
  FuncRes: LongInt;
  StoredProcedureThread: TSQLThread;
  ErrorMsg: string;
begin
  if FVerified then
  begin
    // Create a thread to run the stored procedure in (so that our progress
    // bar can continue to update in the main thread).
    StoredProcedureThread := TSQLThread.CreateForSQLExec(FSQLCaller, '[COMPANY].esp_RecalculateJobActuals', FCompanyCode);

    Screen.Cursor := crHourGlass;
    StartProgress;
    ErrorMsg := '';
    try
      try
        // Start the thread, and wait for it to finish.
        StoredProcedureThread.Resume;
        while not StoredProcedureThread.Terminated do
          Application.ProcessMessages;

        // Retrieve any error message from the thread object, then free it
        ErrorMsg := StoredProcedureThread.ErrorMsg;
        StoredProcedureThread.Free;

        // If the thread reported no errors, retrieve any error message from
        // the SQL Caller
        if (ErrorMsg = '') then
          ErrorMsg := FSQLCaller.ErrorMsg;
      except
        on E:Exception do
          ErrorMsg := E.Message;

      end;
    finally
      StopProgress;
      Screen.Cursor := crDefault;
      //PR: 23/05/2017 ABSEXCH-18683 Release lock
      SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plCheckJobs), 0);
    end;

    // Check for any errors
    if (ErrorMsg = '') then
    begin
      // Update tree (if visible) and switch to the final page
      SendMessage(Sender.Handle, WM_FormCloseMsg, 75, 0);
      ChangePageTo(FinishPage);
    end
    else
      ShowError('The following error occurred while checking Jobs:'#13 + ErrorMsg);
  end
  else
  begin
    // Data discrepancies were found, or the user selected the
    // chkRecreateAnalysisControlRecords option, either of which cases require
    // the original routines to be used.
    //
    // In the latter case we will pass False to the 'confirm recreate' parameter
    // so that the user is not asked again whether they want to recreate the
    // records.
    AddJobPost2Thread(FSender, 40, '', Nil, FSender.Handle, False, not chkRecreateAnalysisControlRecords.Checked);
    // Once the thread has been started we can close this form
    Close;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.ShowError(Msg: string);
begin
  lblFinish.Caption := Msg;
  ChangePageTo(FinishPage);
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.StartProgress;
begin
  ProgressBar.Infinite := True;
  ProgressBar.Animated := True;
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.StopProgress;
begin
  ProgressBar.Animated := False;
  ProgressBar.Infinite := False;
  ProgressBar.Position := 0;
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.VerifyData;
var
  WarningFrm: TSQLCheckAllJobsWarningFrm;
  WarningResult: Word;
  CanContinue: Boolean;
  StoredProcedureThread: TSQLThread;
  ErrorMsg: string;
begin
  ChangePageTo(ProgressPage);
  CanContinue := True;

  // Create a thread to run the stored procedure in (so that our progress
  // bar can continue to update in the main thread).
  StoredProcedureThread := TSQLThread.CreateForSQLSelect(FSQLCaller, '[COMPANY].esp_CheckJobIntegrity', FCompanyCode);

  Screen.Cursor := crHourGlass;
  StartProgress;
  ErrorMsg := '';
  try
    try
      // Start the thread, and wait for it to finish.
      StoredProcedureThread.Resume;
      while not StoredProcedureThread.Terminated do
        Application.ProcessMessages;

      // Retrieve any error message from the thread object, then free it
      ErrorMsg := StoredProcedureThread.ErrorMsg;
      StoredProcedureThread.Free;

      // If the thread reported no errors, retrieve any error message from
      // the SQL Caller
      if (ErrorMsg = '') then
        ErrorMsg := FSQLCaller.ErrorMsg;
    except
      on E:Exception do
        ErrorMsg := E.Message;
    end;
  finally
    StopProgress;
    Screen.Cursor := crDefault;
  end;

  if (ErrorMsg <> '') then
  begin
    // The stored-procedure call itself failed
    ShowError('The following error occurred while verifying Job data:' +
              #13 + ErrorMsg);
    CanContinue := False;
  end
  else
  begin
    try
      PrepareFields;
      if FErrorNo.Value = 0 then
      begin
        // All Ok -- move to the actual processing
        FVerified := True;
        CanContinue := True;
      end
      else
      begin
        // The verification found errors. Display the errors in the error list
        // dialog to give the user the option to continue or cancel.
        WarningFrm := TSQLCheckAllJobsWarningFrm.Create(nil);
        try
          while not FSQLCaller.Records.Eof do
          begin
            // Add the error to the list...
            WarningFrm.ErrorList.Items.Add(FErrorMessage.Value);
            // ...and also add it to the log file
            FLog.LogError(FErrorMessage.Value);
            FSQLCaller.Records.Next;
          end;
          WarningResult := WarningFrm.ShowModal;
        finally
          WarningFrm.Free;
        end;

        // If the user opts to continue...
        if (WarningResult = mrYes) then
        begin
          // ...cancel the verification flag, so that the Process routine will
          // run the original routines rather than the SQL-optimised routines.
          FVerified := False;
          CanContinue := True;
        end
        else
        begin
          CanContinue := False;
          Close;
        end;
      end;
    except
      on E:Exception do
      begin
        ShowError('The following error occurred after verifying Job Data:' +
                  #13 + E.Message);
        CanContinue := False;
      end;
    end;
  end;
  // Assuming all went well, move on to the actual Check All Jobs processing
  if CanContinue then
    Process;
end;

// -----------------------------------------------------------------------------

procedure TSQLCheckAllJobsFrm.btnCancelClick(Sender: TObject);
begin
  //PR: 23/05/2017 ABSEXCH-18683 Release lock on cancel
  SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plCheckJobs), 0);
end;

end.

