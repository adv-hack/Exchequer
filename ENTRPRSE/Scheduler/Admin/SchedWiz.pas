unit SchedWiz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, ExtCtrls, ComCtrls, TCustom, Mask,
  EnterToTab, BorBtns, VarConst, bkgroup, ExScheduler_TLB,
  {$IFDEF SCHEDDLL}
  Enterprise04_TLB;
  {$ELSE}
  Enterprise01_TLB;
  {$ENDIF}



type
  TClassIDObj = Class
    PluginClassName : string;
    Index : Integer;
  end;
  
  TfrmTaskWizard = class(TForm)
    PageControl1: TPageControl;
    tsTask: TTabSheet;
    tsDay: TTabSheet;
    tsTime: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    lblDay: TLabel;
    cbWeekMonth: TSBSComboBox;
    grpMonth: TGroupBox;
    tsEmail: TTabSheet;
    Panel3: TPanel;
    Label5: TLabel;
    edtEmail: Text8Pt;
    Panel4: TPanel;
    Label6: TLabel;
    Label46: TLabel;
    Label28: TLabel;
    dtBetweenStart: TDateTimePicker;
    dtBetweenEnd: TDateTimePicker;
    Label29: TLabel;
    dtSpecific: TDateTimePicker;
    btnNext: TSBSButton;
    btnBack: TSBSButton;
    btnSave: TSBSButton;
    btnCancel: TSBSButton;
    Label7: TLabel;
    edtTaskName: Text8Pt;
    ceMins: TCurrencyEdit;
    ceMinsBetween: TCurrencyEdit;
    EnterToTab1: TEnterToTab;
    chkFirstOfMonth: TBorCheck;
    BorCheck5: TBorCheck;
    BorCheck6: TBorCheck;
    BorCheck7: TBorCheck;
    BorCheck8: TBorCheck;
    BorCheck9: TBorCheck;
    BorCheck10: TBorCheck;
    BorCheck11: TBorCheck;
    BorCheck12: TBorCheck;
    BorCheck13: TBorCheck;
    BorCheck14: TBorCheck;
    BorCheck15: TBorCheck;
    BorCheck16: TBorCheck;
    BorCheck17: TBorCheck;
    BorCheck18: TBorCheck;
    BorCheck19: TBorCheck;
    BorCheck20: TBorCheck;
    BorCheck21: TBorCheck;
    BorCheck22: TBorCheck;
    BorCheck23: TBorCheck;
    BorCheck24: TBorCheck;
    BorCheck25: TBorCheck;
    BorCheck26: TBorCheck;
    BorCheck27: TBorCheck;
    BorCheck28: TBorCheck;
    BorCheck29: TBorCheck;
    BorCheck30: TBorCheck;
    BorCheck31: TBorCheck;
    BorCheck32: TBorCheck;
    BorCheck33: TBorCheck;
    BorCheck34: TBorCheck;
    grpWeek: TGroupBox;
    chkMonday: TBorCheck;
    chkTuesday: TBorCheck;
    chkWednesday: TBorCheck;
    chkThursday: TBorCheck;
    chkFriday: TBorCheck;
    chkSaturday: TBorCheck;
    chkSunday: TBorCheck;
    BorCheck1: TBorCheck;
    cbTaskType: TSBSComboBox;
    tsDetails: TTabSheet;
    pnlView: TPanel;
    Label3: TLabel;
    cbView: TSBSComboBox;
    pnlDaybook: TPanel;
    Label81: Label8;
    IncList: TListBox; 
    chkPostProt: TBorCheck;
    chkPostSep: TBorCheck;
    ExcList: TListBox;
    Inc1: TButton;
    IncAll: TButton;
    Exc1: TButton;
    ExcAll: TButton;
    Label82: Label8;
    pnlJobDaybook: TPanel;
    SBSPanel4: TSBSBackGroup;
    chkCommitment: TBorCheck;
    chkActuals: TBorCheck;
    chkTimesheets: TBorCheck;
    chkRetentions: TBorCheck;
    Label86: Label8;
    pnlCustom: TPanel;
    Panel5: TPanel;
    rbMins: TRadioButton;
    rbMinsBetween: TRadioButton;
    Label2: TLabel;
    Label8: TLabel;
    rbSpecific: TRadioButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    chkJobProtectedMode: TBorCheck;
    chkJobSepPosting: TBorCheck;
    pnlOneOff: TPanel;
    pnlDateTime: TPanel;
    dtOneOffDate: TDateTimePicker;
    Label4: TLabel;
    Label12: TLabel;
    dtOneOffTime: TDateTimePicker;
    Bevel1: TBevel;
    rbPostNow: TBorRadio;
    rbPostSchedule: TBorRadio;
    procedure cbWeekMonthChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbMinsClick(Sender: TObject);
    procedure edtTaskNameExit(Sender: TObject);
    procedure chkMondayClick(Sender: TObject);
    procedure grpWeekEnter(Sender: TObject);
    procedure grpMonthEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Inc1Click(Sender: TObject);
    procedure Exc1Click(Sender: TObject);
    procedure cbTaskTypeExit(Sender: TObject);
    procedure cbTaskTypeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNextExit(Sender: TObject);
    procedure btnCancelExit(Sender: TObject);
    procedure ceMinsExit(Sender: TObject);
    procedure dtSpecificExit(Sender: TObject);
    procedure chkFirstOfMonthClick(Sender: TObject);
    procedure IncListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure IncListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ExcListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure rbPostNowClick(Sender: TObject);
    procedure rbPostScheduleClick(Sender: TObject);
  private
    { Private declarations }
    AllDone : Boolean;
    PrevName : String;
    ResetDayBookLists : Boolean;
    CustomDetailsLoaded : Boolean;
    TaskFirstControl,
    TaskLastControl : HWND;
    PaperlessAvailable : Boolean;
    procedure LoadGLViews;
    function FindViewIndex(const vi : string) : Integer;
    procedure LoadTaskTypes;
    procedure ShowPanel(WhichOne : TPanel; WantToShow : Boolean);
    procedure ShowCustomPanel;
    procedure SetDetailsPanels;
    procedure LoadDaybookList(WhichOne : Byte);
    Procedure CreateEntry(DT  :  DocTypes; WhichList : TListBox);
    procedure TaskToView;
    procedure ViewToTask;
    procedure DaybookToTask;
    function GetIncludedDocTypes : DocSetType;
    procedure JobDaybookToTask;
    function GetActiveCustomTask : IScheduledTask;
    procedure SaveCustomTask;
    procedure CustomTaskToTask;
    function GetCustomIndex(const sClassName : string) : Integer;
    procedure LoadSystemRecord;
    procedure SetJobCheckboxes;
    function FindTaskTypeIndex : Byte;
    function ConfirmPost : Boolean;
  public
    { Public declarations }
    IsEdit : Boolean;
    DayOrTimeChanged : Boolean;
    CurrentDocTypes : DocSetType;
    procedure TaskToDaybook;
    procedure TaskToJobDaybook;

    function FormToDayNo : longint;
    procedure DayNoToForm(Value : longint);
    procedure FormToTask;
    procedure TaskToForm;
    procedure SetTaskIndex(Value : Integer);
    procedure SetOneOffDateAndTime(Value : Boolean);
  end;

  //PR: 18/04/2011 Added Screen parameter to avoid dialog in dll hiding when help is shown. ABSEXCH-11266
  function  AddScheduledPost(Const App       : TApplication;
                             Const Scr       : TScreen;
                             const DataPath  : ShortString;
                             const UserId    : ShortString;
                             const EmailAddr : ShortString;
                             DTypes          : DocSetType;
                             bProtectedMode  : Boolean;
                             bSeparate       : Boolean;
                             WhichPost       : Byte;
                             JobOptions      : Byte) : Integer; stdcall; Export;


var
  frmTaskWizard: TfrmTaskWizard;

implementation

{$R *.dfm}
uses
  DataObjs, SchedVar, BtrvU2, CustIni, GlobVar, CtkUtil04, DateUtils, ApiUtil;



Type
  PostDocType  =  Class (TObject)
                    DT  :  DocTypes;
                  end;

//  PostDocPtr   =  PostDocType;

var
  iJobDayNo : Integer;
  dtJobTime : TDateTime;
  bDontPostNow : Boolean;
  dtJobDate : TDateTime;

function  AddScheduledPost(Const App       : TApplication;
                           Const Scr       : TScreen;
                           const DataPath  : ShortString;
                           const UserId    : ShortString;
                           const EmailAddr : ShortString;
                           DTypes          : DocSetType;
                           bProtectedMode  : Boolean;
                           bSeparate       : Boolean;
                           WhichPost       : Byte;
                           JobOptions      : Byte) : Integer;
const
  PostNames : Array [ttSalesDaybook..ttJobDaybook] of String[8] = ('Sales','Purchase','GL','Stock','Job');
var
  Res : Integer;
  oldApp : TApplication;
  oldScreen : TScreen;

  function SortPrefix(WhichOne : integer) : string;
  begin
    if WhichOne = ttJobDaybook then  //Give Job post a prefix which puts it after other posts in the index which the engine uses.
      Result := 'Z'
    else
      Result := ' ';
  end;
begin
{$IFDEF SCHEDDLL}
  Result := -1; //Cancel
  CompanyPath := DataPath;
  CurrentUser := UserID;
  oToolkit := CreateToolkitWithBackdoor;

  //Store current application object and replace with parameter - integrates form into calling exe.
  oldApp := Application;
  oldScreen := Screen;
  Application := App;
  Screen := Scr;
  Try
    oToolkit.Configuration.DataDirectory := DataPath;
    Res := oToolkit.OpenToolkit;

    //Settings for Task Object
    TaskObject.OpenFile;
    TaskObject.Clear;
    TaskObject.Name := Trim(UserID) + '_Post ' + SortPrefix(WhichPost) + Trim(PostNames[WhichPost]) + ' Daybook ' +
                       FormatDateTime('yymmddnnss', Now);
    TaskObject.TaskType := Char(Ord('A') + WhichPost);

    TaskObject.PostProtected := bProtectedMode;
    TaskObject.PostSeparated := bSeparate;

    if WhichPost in [ttSalesDaybook..ttStockDaybook] then
      TaskObject.IncludeInPost := SetDocTypesInPost(DTypes)
    else
      TaskObject.IncludeInPost := JobOptions; //Job opts is already in the correct format

    TaskObject.WeekMonth := 1;
    TaskObject.DayNo := 1 shl (DayOfTheMonth(Today) - 1);
    TaskObject.TimeType := ttSpecific;
    TaskObject.TimeOfDay := Time;

    //PR: 23/03/2011 ABSEXCH-11088 If we're posting the job daybook with another daybook, pass the date & time from
    //the other daybook task to the job daybook task
    if (WhichPost = ttJobDaybook) and (iJobDayNo >= 0) then
    begin
      TaskObject.DayNo := iJobDayNo;
      TaskObject.TimeOfDay := IncMinute(dtJobTime, 2);  //Try to ensure job daybook posts after preceding sales/purchase daybook
    end;


    if Trim(EmailAddr) = '' then
      TaskObject.Email := oToolkit.SystemSetup.ssPaperless.ssYourEmailAddress
    else
      TaskObject.Email := EmailAddr;

    TaskObject.OneTimeOnly := True;


    //Create and populate form
    with TfrmTaskWizard.Create(App) do
    Try
      if WhichPost in [ttSalesDaybook..ttStockDaybook] then
        Caption := 'Schedule ' + Trim(PostNames[WhichPost]) + ' Daybook Post'
      else
        Caption := 'Schedule Job Costing Ledger Post';

      btnCancel.Caption := '&Cancel';
      IsEdit := True;
      SetTaskIndex(WhichPost);
      {$IFDEF SCHEDDLL}
      rbPostNow.Checked := True;
      {$ENDIF}
      TaskToForm;
      tsTime.Visible := False;
      tsTime.TabVisible := False;

      cbWeekMonth.Visible := False;
      cbWeekMonth.Enabled := False;

      grpMonth.Visible := False;
      grpMonth.Enabled := False;
      grpMonth.TabStop := False;

      grpWeek.Visible := False;
      grpWeek.Enabled := False;
      grpWeek.TabStop := False;

      rbMins.Enabled := False;
      rbMinsBetween.Enabled := False;

      ceMins.Enabled := False;
      ceMinsBetween.Enabled := False;

      dtBetweenStart.Enabled := False;
      dtBetweenEnd.Enabled := False;

      rbSpecific.Checked := True;

      pnlOneOff.Visible := True;
      pnlOneOff.Enabled := True;

      tsDay.Caption := 'Date/Time';

      chkPostProt.HelpContext := 717;
      chkPostSep.HelpContext := 609;

      tsDetails.HelpContext := 40167;
      tsDay.HelpContext := 40168;
      tsEmail.HelpContext := 40169;


      PageControl1.ActivePage := tsDetails;
      PageControl1Change(PageControl1);


      if ShowModal = mrOK then
      begin
        FormToTask;
        TaskObject.Status := tsIdle;
        TaskObject.LastRun := Now;

        if WhichPost <> ttJobDaybook then
        begin
          iJobDayNo := TaskObject.DayNo;
          dtJobTime := TaskObject.TimeOfDay;
          bDontPostNow := rbPostSchedule.Checked;
          dtJobDate := dtOneOffDate.Date;
        end;

        Result := TaskObject.AddRec(False);
        if Result = 0 then
          msgBox(Trim(PostNames[WhichPost]) + ' Daybook Post sent to Scheduler.', mtInformation, [mbOK], mbOK, 'Scheduled Post')
        else
          msgBox('Error sending task to Scheduler: ' + IntToStr(Result), mtError, [mbOK], mbOK, 'Scheduled Post');
      end;
    Finally
      Free;
    End;
  Finally
    TaskObject.CloseFile;
    Application := oldApp; //Restore original application object
    Screen := oldScreen;
    oToolkit.CloseToolkit;
    oToolkit := nil;
  End;
{$ENDIF}
end;


Function dbFormatName(Code,
                      Desc  :  String)  :  String;

Begin

  Result:=Trim(Code);

  If (Result<>'') and (Trim(Desc)<>'') then
    Result:=Result+', ';

  Result:=Result+Trim(Desc);
end; {Func..}



Procedure TfrmTaskWizard.CreateEntry(DT  :  DocTypes; WhichList : TListBox);

Var
  PDR   :  PostDocType;

Begin
  PDR:=PostDocType.Create;

  PDR.DT:=DT;

  WhichList.Items.AddObject(dbFormatName(DocCodes[DT],DocNames[DT]),PDR);
end;


procedure TfrmTaskWizard.cbWeekMonthChange(Sender: TObject);
begin
  grpWeek.Visible := cbWeekMonth.ItemIndex = 0;
  grpMonth.Visible := not grpWeek.Visible;
  grpWeek.TabStop := grpWeek.Visible;
  grpMonth.TabStop := grpMonth.Visible;
end;

procedure TfrmTaskWizard.btnNextClick(Sender: TObject);
begin
  PageControl1.SelectNextPage(True);
end;

procedure TfrmTaskWizard.btnBackClick(Sender: TObject);
begin
  PageControl1.SelectNextPage(False);
end;

procedure TfrmTaskWizard.PageControl1Change(Sender: TObject);
var
  LastTab : Integer;
begin
  if PaperlessAvailable then
    LastTab := pgEmail
  else
  {$IFDEF SCHEDDLL}
    LastTab := pgDay;
  {$ELSE}
    LastTab := pgTime;
  {$ENDIF}

{$IFDEF SCHEDDLL}
  btnBack.Enabled := PageControl1.TabIndex > pgDetails;
{$ELSE}
  btnBack.Enabled := PageControl1.TabIndex > pgTask;
{$ENDIF}

  btnNext.Enabled := PageControl1.TabIndex < LastTab;
  btnSave.Enabled := IsEdit or (PageControl1.TabIndex = LastTab) or AllDone;

  if PageControl1.TabIndex = LastTab then
    AllDone := True;

  Case PageControl1.TabIndex of
    pgDetails : SetDetailsPanels;
    pgDay     : if cbWeekMonth.CanFocus then
                  ActiveControl := cbWeekMonth;
   {$IFNDEF SCHEDDLL}
    pgTime    : begin
                  if rbMins.Checked then
                   ActiveControl := ceMins
                  else
                  if rbMinsBetween.Checked then
                    ActiveControl := ceMinsBetween
                  else
                    ActiveControl := dtSpecific;
                  rbMinsClick(Self);
                end;
   {$ENDIF}
    pgEmail   : ActiveControl := edtEmail;
  end;

  
  {$IFDEF SCHEDDLL}
  HelpContext := 40167 + PageControl1.TabIndex;
  PageControl1.HelpContext := HelpContext;
  if not (ActiveControl is TBorCheck) then
    ActiveControl.HelpContext := HelpContext;
  {$ENDIF}
end;

procedure TfrmTaskWizard.FormCreate(Sender: TObject);
var
  i : Integer;
begin
{$IFDEF SCHEDDLL}
  PageControl1.ActivePage := tsDetails;
  PageControl1.TabIndex := 1;
  tsTask.TabVisible := False;
  IsEdit := False;
  AllDone := False;
  LoadTaskTypes;
{$ELSE}
  PageControl1.ActivePage := tsTask;
  PageControl1.TabIndex := 0;
  IsEdit := False;
  AllDone := False;
  LoadTaskTypes;
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TBorCheck then
      with Components[i] as TBorCheck do
        if Tag = 0 then
          OnClick := chkMondayClick;
  CurrentDocTypes := [];
  ResetDaybookLists := False;
  LoadGLViews;
  LoadSystemRecord;
  CustomDetailsLoaded := False;
  TaskFirstControl := 0;
{$ENDIF not SCHEDDLL}
  PaperlessAvailable := oToolkit.SystemSetup.ssReleaseCodes.rcPaperless <> rcDisabled;
  tsEmail.TabVisible := PaperlessAvailable;
end;

procedure TfrmTaskWizard.LoadGLViews;
var
  TempList : TStringList;
begin
  if cbView.Items.Count = 0 then
  begin
    TempList := TStringList.Create;
    Try
      LoadNomViews(TempList);
      cbView.Items.AddStrings(TempList);
      cbView.ItemsT.AddStrings(TempList);
      cbView.ItemsL.AddStrings(TempList);
      cbView.ItemIndex := 0;
    Finally
      TempList.Free;
    End;
  end;
end;

procedure TfrmTaskWizard.DayNoToForm(Value: Integer);
var
  i, iMask : longint;
  Step : Byte;
begin
  Case cbWeekMonth.ItemIndex of
    0 : begin
          chkMonday.Checked := Value and iMonday = iMonday;
          chkTuesday.Checked := Value and iTuesday = iTuesday;
          chkWednesday.Checked := Value and iWednesday = iWednesday;
          chkThursday.Checked := Value and iThursday = iThursday;
          chkFriday.Checked := Value and iFriday = iFriday;
          chkSaturday.Checked := Value and iSaturday = iSaturday;
          chkSunday.Checked := Value and iSunday = iSunday;
        end;
    1 : begin
          for i := 0 to ComponentCount - 1 do
          if (Components[i] is TBorCheck) and (Components[i].Tag > 0) then
          begin
            Step := Components[i].Tag - 1;
            iMask := 1 shl Step;
            (Components[i] as TBorCheck).Checked := Value and iMask = iMask;
          end;
        end;
  end;
end;

function TfrmTaskWizard.FormToDayNo: longint;
var
  i, iMask : longint;
  Step : Byte;
begin
  Result := 0;
  if TaskObject.OneTimeOnly then
  begin
    Step := DayOf(dtOneOffDate.Date) - 1;
    iMask := 1;
    Result := Result or (iMask shl Step);
  end
  else
  Case cbWeekMonth.ItemIndex of
    0 : begin
          if chkMonday.Checked then Result := Result or iMonday;
          if chkTuesday.Checked then Result := Result or iTuesday;
          if chkWednesday.Checked then Result := Result or iWednesday;
          if chkThursday.Checked then Result := Result or iThursday;
          if chkFriday.Checked then Result := Result or iFriday;
          if chkSaturday.Checked then Result := Result or iSaturday;
          if chkSunday.Checked then Result := Result or iSunday;
        end;
    1 : begin
          for i := 0 to ComponentCount - 1 do
          if (Components[i] is TBorCheck) and (Components[i].Tag > 0) then
          begin
            if (Components[i] as TborCheck).Checked then
            begin
              Step := Components[i].Tag - 1;
              iMask := 1;
              Result := Result or (iMask shl Step);
            end;
          end;
        end;
  end; //Case
end;

procedure TfrmTaskWizard.FormToTask;
//Copy all properties from form back to the task object, ready for saving
begin
//Schedule properties
  if not IsEdit then
    TaskObject.Clear;
  cbTaskTypeExit(Self); //Reset task type after clear
  TaskObject.Name := edtTaskName.Text;
  TaskObject.WeekMonth := cbWeekMonth.ItemIndex;
  TaskObject.DayNo := FormToDayNo;
  if TaskObject.OneTimeOnly then
  begin
    TaskObject.TimeOfDay := TimeOnly(dtOneOffTime.Time);
    TaskObject.TimeType := ttSpecific;
    TaskObject.LastRun := Now;
    TaskObject.NextRunDue := Trunc(dtOneOffDate.Date) + (dtOneOffTime.Time - Trunc(dtOneOffTime.Time));

  end
  else
  if rbMins.Checked then
  begin
    TaskObject.Interval := Trunc(ceMins.Value);
    TaskObject.TimeType := ttInterval;
    TaskObject.LastRun := Now;
  end
  else
  if rbMinsBetween.Checked then
  begin
    TaskObject.Interval := Trunc(ceMinsBetween.Value);
    TaskObject.TimeType := ttIntervalBetween;
    TaskObject.StartTime := TimeOnly(dtBetweenStart.Time);
    TaskObject.EndTime := TimeOnly(dtBetweenEnd.Time);
  end
  else
  begin
    TaskObject.TimeOfDay := TimeOnly(dtSpecific.Time);
    TaskObject.TimeType := ttSpecific;
    TaskObject.LastRun := Now;
  end;

  if TaskObject.Interval < 0 then
    TaskObject.Interval := Abs(TaskObject.Interval);

  TaskObject.Email := edtEmail.Text;

  //Task-specific properties
  Case TaskObject.TaskType of
    tcView            : ViewToTask;
    tcSalesDaybook..tcStockDaybook
                      : DaybookToTask;
    tcJobDaybook      : JobDaybookToTask;
    else
      SaveCustomTask;
  end;

end;

procedure TfrmTaskWizard.TaskToForm;
begin
  if TaskObject.TaskType = tcCustom then
    cbTaskType.ItemIndex := GetCustomIndex(TaskObject.CustomClassName)
  else
    cbTaskType.ItemIndex := FindTaskTypeIndex;
  edtTaskName.Text := Trim(TaskObject.Name);
  PrevName := edtTaskName.Text;
  cbWeekMonth.ItemIndex := TaskObject.WeekMonth;
  DayNoToForm(TaskObject.DayNo);
  if TaskObject.OneTimeOnly then
    dtOneOffTime.Time := TaskObject.TimeOfDay
  else
  Case TaskObject.TimeType of
    ttSpecific :        begin
                          rbSpecific.Checked := True;
                          dtSpecific.Time := TaskObject.TimeOfDay;
                        end;
    ttInterval :        begin
                          rbMins.Checked := True;
                          ceMins.Value := TaskObject.Interval;
                          ceMinsExit(ceMins);
                        end;
    ttIntervalBetween : begin
                          rbMinsBetween.Checked := True;
                          ceMinsBetween.Value := TaskObject.Interval;
                          dtBetweenStart.Time := TaskObject.StartTime;
                          dtBetweenEnd.Time := TaskObject.EndTime;
                          ceMinsExit(ceMinsBetween);
                        end;
  end;

  edtEmail.Text := Trim(TaskObject.Email);
  Case TaskObject.TaskType of
    tcView            : TaskToView;
    tcSalesDaybook..tcStockDaybook
                      : TaskToDaybook;
    tcJobDaybook      : TaskToJobDaybook;
  end;

end;

procedure TfrmTaskWizard.rbMinsClick(Sender: TObject);
begin
  ceMins.Enabled := rbMins.Checked;
  ceMinsBetween.Enabled := rbMinsBetween.Checked;
  dtBetweenStart.Enabled := rbMinsBetween.Checked;
  dtBetweenEnd.Enabled := rbMinsBetween.Checked;
  dtSpecific.Enabled := rbSpecific.Checked;
  DayOrTimeChanged := True;
end;

procedure TfrmTaskWizard.edtTaskNameExit(Sender: TObject);
var
  Res : Integer;
begin
  if (ActiveControl <> btnCancel) then
  begin
    if Trim(edtTaskName.Text) = '' then
    begin
      DoMessage('Task name cannot be left blank');
      ActiveControl := edtTaskName;
    end
    else
    if not IsEdit then
    begin
      TaskObject.Index := 0;
      Res := TaskObject.FindRecord(B_GetEq, Trim(edtTaskName.Text));
      if Res = 0 then
      begin
        DoMessage('Task ' + QuotedStr(Trim(edtTaskName.Text)) + ' already exists');
        ActiveControl := edtTaskName;
      end;
    end;
  end;
end;

procedure TfrmTaskWizard.chkMondayClick(Sender: TObject);
begin
  DayOrTimeChanged := True;
end;

function TfrmTaskWizard.FindViewIndex(const vi: string): Integer;
//vi will be View number in format '0001' - '9999'. Find it in the list and return the index
var
  i, j : Integer;
  Found : Boolean;
begin
  Found := False;
  if (vi = '000') or (vi = '') then //All views
  begin
    Result := 0;
    Found := True;
  end
  else
  begin
    //Check if it's in the right position
    i := StrToInt(vi);
    if (i < cbView.Items.Count) and (Copy(cbView.Items[i], 1, 3) = vi) then
    begin
      Result := i;
      Found := True;
    end
    else
    begin
      //not in position, so need to go through all items in list until we find it
      for j := 1 to cbView.Items.Count - 1 do
        if Copy(cbView.Items[j], 1, 3) = vi then
        begin
          Result := j;
          Found := True;
          Break;
        end;
    end;
  end;
  if not Found then
    Result := -1;
end;

procedure TfrmTaskWizard.grpWeekEnter(Sender: TObject);
begin
  ActiveControl := chkMonday;
end;

procedure TfrmTaskWizard.grpMonthEnter(Sender: TObject);
begin
  ActiveControl := chkFirstOfMonth;
end;


procedure TfrmTaskWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
  begin
  {$IFDEF SCHEDDLL}
    CanClose := ConfirmPost;
  {$ELSE}
    if FormToDayNo = 0 then
    begin
      DoMessage('At least one day must be selected');
      CanClose := False;
      PageControl1.ActivePage := tsDay;
    end;
  {$ENDIF}
  end;
end;

procedure TfrmTaskWizard.LoadTaskTypes;
var
  i : integer;

  procedure AddItem(const sTypeName : string;
                    Idx : Integer;
                    const sClassName : string = ''
                    );
  var
    oID : TClassIDObj;
  begin
    oID := TClassIDObj.Create;
    oID.PluginClassName := sClassName;
    oID.Index := Idx;
    cbTaskType.Items.AddObject(sTypeName, oID);
  end;

begin
  {$IFNDEF SCHEDDLL}
  if AnyViewsAllowed then
    AddItem('Update GL Views', ttView);
  {$ENDIF}
  if PostAllowed(pwPostSales) then
    AddItem('Post Sales Daybook', ttSalesDaybook);
  if PostAllowed(pwPostPurch) then
    AddItem('Post Purchase Daybook', ttPurchDaybook);
  if PostAllowed(pwPostNominal) then
    AddItem('Post Nominal Daybook', ttNominalDaybook);
  if ((oToolkit.SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes2).rcFullStockControl <>
       rcDisabled) and
      PostAllowed(pwPostStock) then
    AddItem('Post Stock Daybook', ttStockDaybook);
  if (oToolkit.SystemSetup.ssReleaseCodes.rcJobCosting <> rcDisabled) and
      (PostAllowed(pwPostJob) or
       PostAllowed(pwPostTSH)) then
    AddItem('Post Job Daybook', ttJobDaybook);

 {$IFNDEF SCHEDDLL}
  for i := 0 to PluginList.Count - 1 do
    with PluginList.Item[i] as IScheduledTask do
       AddItem(stType, 10, PluginList.CustomClassName[i]);
 {$ENDIF}

  cbTaskType.ItemIndex := 0;

end;

procedure TfrmTaskWizard.ShowPanel(WhichOne: TPanel; WantToShow : Boolean);
begin
  WhichOne.Visible := WantToShow;
  WhichOne.TabStop := WantToShow;
end;

procedure TfrmTaskWizard.SetDetailsPanels;
var
  oID : TClassIDObj;
begin
  oID :=cbTaskType.Items.Objects[cbTaskType.ItemIndex] as TClassIdObj;
  Case oID.Index of
     ttView            : begin
                           ShowPanel(pnlView, True);
                           ShowPanel(pnlDayBook, False);
                           ShowPanel(pnlJobDayBook, False);
                           ShowPanel(pnlCustom, False);
                           LoadGLViews;
                           if cbView.CanFocus then
                             ActiveControl := cbView;
                         end;
     ttSalesDaybook..ttStockDaybook
                       : begin
                           ShowPanel(pnlView, False);
                           ShowPanel(pnlJobDayBook, False);
                           ShowPanel(pnlDayBook, True);
                           ShowPanel(pnlCustom, False);
                           //PR: 10/12/2010 ABSEXCH-2809 Was passing ItemIndex into function rather than the object index. This
                           //meant that if some options weren't available in the drop-down, the wrong value could be passed.
                           LoadDayBookList(oID.Index);
                           if not IsEdit then
                           begin
                             chkPostProt.Checked := Syss.ProtectPost;
                             chkPostSep.Checked := Syss.SepRunPost;
                           end;
                           if incList.CanFocus then
                             ActiveControl := incList;
                         end;
     ttJobDaybook      : begin
                           ShowPanel(pnlView, False);
                           ShowPanel(pnlDayBook, False);
                           ShowPanel(pnlJobDayBook, True);
                           ShowPanel(pnlCustom, False);
                           SetJobCheckBoxes;
                           if not IsEdit then
                           begin
                             chkJobProtectedMode.Checked := Syss.ProtectPost;
                             chkJobSepPosting.Checked := Syss.SepRunPost;
                           end;
                           if chkCommitment.CanFocus then
                             ActiveControl := chkCommitment;
                         end;
     else
       ShowCustomPanel;

   end;
end;

procedure TfrmTaskWizard.Inc1Click(Sender: TObject);
Var
  n,m,i  :  Integer;

  SendAll
       :  Boolean;

begin
  inherited;

  SendAll:=(Sender=IncAll);

  With IncList do
  If (SelCount>0) or (SendAll) then
  Begin
    n:=0; m:=0;

    i:=Items.Count-1;

    While (m<=i) do
    Begin
      {$B-}

      If (SendAll) or (Selected[n]) then

      {$B+}
      Begin
        ExcList.Items.AddObject(Items[n],Items.Objects[n]);
        Exclude(CurrentDocTypes, PostDocType(Items.Objects[n]).DT);
        {Dispose(Items.Objects[n]);}

        Items.Delete(n);
      end
      else
        Inc(n);

      Inc(m);
    end;
  end;

end;

procedure TfrmTaskWizard.Exc1Click(Sender: TObject);
Var
  n,m,i  :  Integer;

  SendAll
       :  Boolean;

begin
  inherited;

  SendAll:=(Sender=ExcAll);

  With ExcList do
  If (SelCount>0) or (SendAll) then
  Begin
    n:=0; m:=0;

    i:=Items.Count-1;

    While (m<=i) do
    Begin
      {$B-}

      If (SendAll) or (Selected[n]) then

      {$B+}
      Begin
        IncList.Items.AddObject(Items[n],Items.Objects[n]);
        Include(CurrentDocTypes, PostDocType(Items.Objects[n]).DT);
        Items.Delete(n);
      end
      else
        Inc(n);

      Inc(m);
    end;

  end;
end;

procedure TfrmTaskWizard.LoadDaybookList(WhichOne: Byte);
var
  ThisSet : DocSetType;
  DT : DocTypes;
begin
  if (IncList.Count = 0) and (ExcList.Count = 0) then
  begin
    Case WhichOne of
      ttSalesDaybook : ThisSet := SalesSplit-QuotesSet{-PSOPSet}-[SDN];
      ttPurchDaybook : ThisSet := PurchSplit-QuotesSet{-PSOPSet}-[PDN];
      ttNominalDaybook : ThisSet := [NMT];
      ttStockDaybook   : ThisSet := [ADJ];
    end;

    for DT := DocTypeFirst to DocTypeLast do
    Begin
      If (DT In ThisSet) {and (ChkAllowed_In(DDocPWMode[DT]))} then
      Begin
        if not IsEdit or (DT in CurrentDocTypes) or ResetDaybookLists then
        begin
          CreateEntry(DT, IncList);
          if not (DT in CurrentDocTypes) then
            Include(CurrentDocTypes, DT);
        end
        else
          CreateEntry(DT, ExcList);

      end;
    end;
  end;
  ResetDayBookLists := False;
end;

procedure TfrmTaskWizard.TaskToDaybook;
begin
  CurrentDocTypes := GetDocTypesInPost(TaskObject.IncludeInPost);
  chkPostProt.Checked := TaskObject.PostProtected;
  chkPostSep.Checked := TaskObject.PostSeparated;
end;

procedure TfrmTaskWizard.TaskToView;
begin
  cbView.ItemIndex := FindViewIndex(Copy(TaskObject.TaskID, 2, 3));
end;

procedure TfrmTaskWizard.DaybookToTask;
begin
  TaskObject.IncludeInPost := SetDocTypesInPost(CurrentDocTypes);
  TaskObject.PostProtected := chkPostProt.Checked;
  TaskObject.PostSeparated := chkPostSep.Checked;
end;

procedure TfrmTaskWizard.ViewToTask;
begin
  if UpperCase(cbView.Text) = 'ALL VIEWS' then
    TaskObject.TaskID := '0000'
  else
    TaskObject.TaskID := '0' + Copy(cbView.Text, 1, 3);
end;

function TfrmTaskWizard.GetIncludedDocTypes: DocSetType;
var
  i : Integer;
begin
  Result := [];
  for i := 0 to IncList.Count - 1 do
    Include(Result, PostDocType(IncList.Items.Objects[i]).DT);
end;

procedure TfrmTaskWizard.cbTaskTypeExit(Sender: TObject);
var
  ThisTask : Byte;
begin
  if TClassIDObj(cbTaskType.Items.Objects[cbTaskType.ItemIndex]).PluginClassName = '' then
  begin
    ThisTask := TClassIDObj(cbTaskType.Items.Objects[cbTaskType.ItemIndex]).Index;
    TaskObject.TaskType := Char(ThisTask + Ord(tcView))
  end
  else
    TaskObject.TaskType := '@'; //Custom type
end;

procedure TfrmTaskWizard.cbTaskTypeChange(Sender: TObject);
begin
  IncList.Items.Clear;
  ExcList.Items.Clear;
  CurrentDocTypes := [];
  ResetDaybookLists := True;
  CustomDetailsLoaded := False;
end;


procedure TfrmTaskWizard.JobDaybookToTask;
begin
  TaskObject.IncludeInPost := 0;
  if chkCommitment.Checked then
    TaskObject.IncludeInPost := jpCommitment;
  if chkActuals.Checked then
    TaskObject.IncludeInPost := TaskObject.IncludeInPost or jpActuals;
  if chkTimeSheets.Checked then
    TaskObject.IncludeInPost := TaskObject.IncludeInPost or jpTimesheets;
  if chkRetentions.Checked then
    TaskObject.IncludeInPost := TaskObject.IncludeInPost or jpRetentions;

  //PR: 10/12/2010 ABSEXCH-2914 - Added ProtectedMode & Separted Mode to Job posting - in Exchequer these are taken from the
  //previous Sales/Purchase daybook post.
  TaskObject.PostProtected := chkJobProtectedMode.Checked;
  TaskObject.PostSeparated := chkJobSepPosting.Checked;
end;

procedure TfrmTaskWizard.TaskToJobDaybook;
begin
  chkCommitment.Checked := TaskObject.IncludeInPost and jpCommitment = jpCommitment;
  chkActuals.Checked := TaskObject.IncludeInPost and jpActuals = jpActuals;
  chkTimesheets.Checked := TaskObject.IncludeInPost and jpTimesheets = jpTimesheets;
  chkRetentions.Checked := TaskObject.IncludeInPost and jpRetentions = jpRetentions;

  //PR: 10/12/2010 ABSEXCH-2914 - Added ProtectedMode & Separted Mode to Job posting - in Exchequer these are taken from the
  //previous Sales/Purchase daybook post.
  chkJobProtectedMode.Checked := TaskObject.PostProtected;
  chkJobSepPosting.Checked := TaskObject.PostSeparated;

  //PR: 29/03/2011
  {$IFDEF SCHEDDLL}
   if iJobDayNo >= 0 then
   begin
     rbPostSchedule.Checked := bDontPostNow;
     dtOneOffDate.Date := dtJobDate;
     iJobDayNo := -1;
   end;
  {$ENDIF}
end;

procedure TfrmTaskWizard.ShowCustomPanel;
var
  oTask : IScheduledTask;
begin
  ShowPanel(pnlView, False);
  ShowPanel(pnlDayBook, False);
  ShowPanel(pnlJobDayBook, False);
  ShowPanel(pnlCustom, True);

  if not CustomDetailsLoaded then
  begin
    oTask := GetActiveCustomTask;
    if Assigned(oTask) then
    Try
      oTask.stDataPath := CompanyPath;
      oTask.stName := edtTaskName.Text;
      oTask.Load;
      oTask.ShowDetails(Integer(pnlCustom.Handle));
      CustomDetailsLoaded := True;
      oTask.stNextControl := btnCancel.Handle;
      oTask.stPrevControl := btnNext.Handle;
      TaskFirstControl := oTask.stFirstControl;
      TaskLastControl := oTask.stLastControl;
      if TaskFirstControl > 0 then
        Windows.SetFocus(HWND(TaskFirstControl));
    Finally
      oTask := nil;
    End;
  end;
end;

function TfrmTaskWizard.GetActiveCustomTask: IScheduledTask;
var
  i : integer;
  sClassName : string;
begin
  i := cbTaskType.ItemIndex;
  with cbTaskType.Items.Objects[i] as TClassIDObj do
    sClassName := PluginClassName;
  Result := PluginList.GetItemByClassName(sClassName);
end;

procedure TfrmTaskWizard.SaveCustomTask;
var
  oTask : IScheduledTask;
begin
  oTask := GetActiveCustomTask;
  Try
    if Assigned(oTask) and CustomDetailsLoaded then
    begin
      oTask.stName := edtTaskName.Text;
      oTask.Save;
      CustomTaskToTask;
    end;
  Finally
    oTask := nil;
  End;
end;

procedure TfrmTaskWizard.FormDestroy(Sender: TObject);
var
  oTask : IScheduledTask;
begin
  oTask := GetActiveCustomTask;
  Try
    if Assigned(oTask) and CustomDetailsLoaded then
      oTask.FreeDetails;
  Finally
    oTask := nil;
  End;
end;

procedure TfrmTaskWizard.CustomTaskToTask;
var
  i : integer;
  sClassName : string;
begin
  i := cbTaskType.ItemIndex;
  with cbTaskType.Items.Objects[i] as TClassIDObj do
    TaskObject.CustomClassName := PluginClassName;

end;

function TfrmTaskWizard.GetCustomIndex(const sClassName: string): Integer;
var
  oTask : IScheduledTask;
  sTaskType : string;
begin
  oTask := PluginList.GetItemByClassName(sClassName);
  Try
    if Assigned(oTask) then
    begin
      Result := cbTaskType.Items.IndexOf(Trim(oTask.stType));
    end;
  Finally
    oTask := nil;
  End;



end;


procedure TfrmTaskWizard.btnNextExit(Sender: TObject);
begin
  if CustomDetailsLoaded and (PageControl1.ActivePage = tsDetails) and
    not (ActiveControl is TSBSButton) then
      Windows.SetFocus(TaskFirstControl);
end;

procedure TfrmTaskWizard.btnCancelExit(Sender: TObject);
begin
  if CustomDetailsLoaded and (PageControl1.ActivePage = tsDetails) and
    not (ActiveControl is TSBSButton) then
      Windows.SetFocus(TaskLastControl);
end;

procedure TfrmTaskWizard.LoadSystemRecord;
var
  KeyS : Str255;
begin
  KeyS := SysNames[SysR];
  Open_File(F[SysF], SetDrive + Filenames[SysF], 0);
  Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,KeyS);
  Close_File(F[SysF]);
end;

procedure TfrmTaskWizard.SetJobCheckboxes;
begin
  chkActuals.Enabled := PostAllowed(pwPostJob);
  chkCommitment.Enabled := chkActuals.Enabled;
  chkRetentions.Enabled := chkActuals.Enabled;
  chkTimesheets.Enabled := PostAllowed(pwPostTSH);
end;

procedure TfrmTaskWizard.ceMinsExit(Sender: TObject);
begin
  if Sender is TCurrencyEdit then
    with Sender as TCurrencyEdit do
      if (Trunc(Value) < 30) and (Trunc(Value) >= 0) then
        Value := 30;
end;

procedure TfrmTaskWizard.dtSpecificExit(Sender: TObject);
begin
  if IsInBackupWindow(dtSpecific.dateTime) then
    DoMessage('The time set falls within the off-line period ' + BackupWindowString +
               #10#10'This task will not run.');
end;

function TfrmTaskWizard.FindTaskTypeIndex: Byte;
var
  i : integer;
begin
  for i := 0 to cbTaskType.Items.Count - 1 do
    if  TClassIDObj(cbTaskType.Items.Objects[i]).Index =
        Ord(TaskObject.TaskType) - Ord(tcView) then
    begin
      Result := i;
      Break;
    end;

end;
procedure TfrmTaskWizard.SetTaskIndex(Value: Integer);
var
  oID : TClassIDObj;
  i : integer;
begin
  for i := 0 to cbTaskType.Items.Count - 1 do
  begin
    oID :=cbTaskType.Items.Objects[i] as TClassIdObj;
    if oID.Index = Value then
    begin
      cbTaskType.ItemIndex := i;
      Break;
    end;
  end;
end;

procedure TfrmTaskWizard.chkFirstOfMonthClick(Sender: TObject);

  function UncheckOtherDays : Boolean;
  var
    i : integer;
  begin
    with grpMonth do
    begin
      for i := 0 to ControlCount - 1 do
      if (Controls[i] is TBorCheck) and (Controls[i].Tag > 0) then
        if (Sender as TBorCheck).Tag <> (Controls[i] as TborCheck).Tag then
          if (Controls[i] as TborCheck).Checked then
          begin
            (Controls[i] as TborCheck).Checked := False;
            Break;
          end;
    end;
  end;
begin
  //If this is a OneTimeOnly task (i.e. from Enter1, then we stop users checking more than one day.
  if TaskObject.OneTimeOnly and (Sender as TBorCheck).Checked then
    UncheckOtherDays;
end;

procedure TfrmTaskWizard.IncListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source = IncList) or (Source = ExcList); 
end;

procedure TfrmTaskWizard.IncListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if Source = ExcList then
    Exc1Click(Exc1);
end;

procedure TfrmTaskWizard.ExcListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if Source = IncList then
    Inc1Click(Inc1);
end;

procedure TfrmTaskWizard.SetOneOffDateAndTime(Value: Boolean);
begin
  dtOneOffDate.Enabled := Value;
  dtOneOffTime.Enabled := Value;
end;

procedure TfrmTaskWizard.rbPostNowClick(Sender: TObject);
begin
  SetOneOffDateAndTime(False);
  dtOneOffDate.Date := SysUtils.Date;
  dtOneOffTime.Time := Time;
end;

procedure TfrmTaskWizard.rbPostScheduleClick(Sender: TObject);
begin
  SetOneOffDateAndTime(True);
end;

function TfrmTaskWizard.ConfirmPost: Boolean;
var
  s : string;
begin
  if rbPostNow.Checked then
    s := 'Now?'
  else
    s := 'at ' + FormatDateTime('hh:nn', dtOneOffTime.Time) + ' on ' +
      FormatDateTime('dddddd', dtOneOffDate.Date) + '?';

  Result := msgBox('Post this Daybook ' + s, mtConfirmation, [mbYes, mbNo], mbYes, Caption) = mrYes;
end;

Initialization
  iJobDayNo := -1;
end.
