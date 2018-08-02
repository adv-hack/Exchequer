unit SchedLst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, uMultiList, uDBMultiList, uExDatasets,
  uBtrieveDataset, ExtCtrls, ComCtrls, Enterprise01_TLB, ComObj, uSettings,
  Menus;

type
  TfrmTaskList = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    dsTasks: TBtrieveDataset;
    mlTasks: TDBMultiList;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnDelete: TSBSButton;
    btnClose: TSBSButton;
    btnSettings: TSBSButton;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    mniEdit: TMenuItem;
    mniDelete: TMenuItem;
    Settings1: TMenuItem;
    Close1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    N2: TMenuItem;
    SaveCoordinates1: TMenuItem;
    N3: TMenuItem;
    Active1: TMenuItem;
    btnRefresh: TSBSButton;
    About1: TMenuItem;
    N4: TMenuItem;
    Refresh1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure dsTasksGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure mlTasksAfterLoad(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure mlTasksRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Properties1Click(Sender: TObject);
    procedure Active1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure mlTasksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dsTasksFilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure About1Click(Sender: TObject);
    procedure mlTasksChangeSelection(Sender: TObject);
  private
    { Private declarations }
    bRestore : Boolean;
    IsSystemUser : Boolean;
    function AuthorizedUser(const ID, Pass : ShortString) : SmallInt;
    procedure StartLogIn;
    procedure AddTestRec;
    procedure SetButtons;
    procedure AddTask;
    procedure EditTask;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    function GetSelected(Lock : Boolean = False) : Boolean;
    function GetCustomTaskTypeString(const sClassName : string) : string;
    procedure ShowErrorMessage(const sMsg : string);
    procedure SetAllViewsOn;
  public
    { Public declarations }
  end;

var
  frmTaskList: TfrmTaskList;

implementation

{$R *.dfm}
{$R SchedXP.res}

uses
  SchedVar, ConfigF, GlobVar, DailyPw, EtStrU, BtrvU2, DataObjs, SchedWiz, About, CustIni,
  ExScheduler_TLB, LoginF, PasswordComplexityConst, AuthenticateUserTKUtil,
  ApiUtil, FileUtil, CTKUtil, StrUtils, ADOConnect, EntLicence;

{ TfrmTaskList }

function TfrmTaskList.AuthorizedUser(const ID,
  Pass: ShortString): SmallInt;
var
  Res, i : Smallint;

  //this function will extract UserID from Windows-ID
    function GetUserID: string;
    var
      AUserID: String;
      ARes: integer;
    begin
      AUserID := '';
      with oToolkit as IToolkit2 do
      begin
        UserProfile.Index := usIdxLogin;
        ARes := UserProfile.GetFirst;
        while ARes = 0 do
        begin
          with UserProfile as IUserProfile4 do
          begin
            if (UpperCase(upWindowsUserID) = UpperCase(ID)) or (UpperCase(upUserID) = UpperCase(ID)) then
            begin
              AUserID := upUserID;
              break;
            end;
          end;
          ARes := UserProfile.GetNext;
        end;  {while FuncRes = 0}
      end;  {with FToolkit as IToolkit2}
      Result := AUserID;                
    end;

begin
  Result := 0;
  with oToolkit do
  begin
    if oToolkit.Status = tkClosed then
    begin
      Configuration.DataDirectory := CompanyPath;
      Result := OpenToolkit;
    end
    else
      Result := 0;
      
    if Result = 0 then
    begin

      Result := Functions.entCheckPassword(ID, Pass);

      if (Result = 0) then
      begin
        CurrentUser := ID;    // SSK 11/06/2018 2018-R1.1 ABSEXCH-20734: GetUserID replaced with ID to fix the issue of task-list not getting displayed
        Res := Functions.entCheckSecurity(ID, pwAllNomViews);       // SSK 01/06/2018 2018-R1.1 ABSEXCH-20574: Windows Login will be handled inside entCheckSecurity
        for i := 0 to 9 do
          ViewsAllowed[i] := False;
        AllViewsAllowed := False;
        AnyViewsAllowed := False;
        if Res = 0 then
        begin
          Res := Functions.entCheckSecurity(ID, pwRefreshNomViews);     // SSK 01/06/2018 2018-R1.1 ABSEXCH-20574: Windows Login will be handled inside entCheckSecurity
          if Res = 0 then
          begin
            AllViewsAllowed := True;
            for i := 0 to 9 do
            begin
              ViewsAllowed[i] := Functions.entCheckSecurity(ID, pwAccessViewBase + i) = 0;    // SSK 01/06/2018 2018-R1.1 ABSEXCH-20574: Windows Login will be handled inside entCheckSecurity
              AllViewsAllowed := AllViewsAllowed and ViewsAllowed[i];
              AnyViewsAllowed := AnyViewsAllowed or ViewsAllowed[i];
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmTaskList.StartLogIn;
var
  lGotPassWord: Boolean;
  lLoginFrm: TfrmLogin;
begin
  lGotPassWord := False;
  lLoginFrm := TfrmLogin.Create(Application);
  try
    with lLoginFrm do
    begin
      LoginDialog := ldScheduler;
      OnCheckValidUser := AuthorizedUser;
      InitDefaults; //Init Defaults values
      ShowModal;
      lGotPassWord := ModalResult = mrOK;
      if lGotPassWord then
      begin
        if txtUserName.Text = 'SYSTEM' then
          CurrentUser :=   txtUserName.Text;
        IsSystemUser := txtUserName.Text = 'SYSTEM';
      end;
    end; {with lLoginFrm do}
  finally
    FreeAndNil(lLoginFrm);
  end;

  if not lGotPassword then  {* Force abort..}
    Halt;
end;

procedure TfrmTaskList.FormCreate(Sender: TObject);
var
  Res : Integer;
begin
  IsSystemUser := False;
  PluginList.ReadIniFile;
  bRestore := False;
  oToolkit := CreateToolkitWithBackdoor;
  StartLogin;
  if IsSystemUser then
  begin
    SetAllViewsOn; //PR: 14/04/2011 ABSEXCH-2809 System user wasn't seeing GL Views.
    with oToolkit do
    begin
      if oToolkit.Status = tkClosed then
      begin
        Configuration.DataDirectory := CompanyPath;
        OpenToolkit;
      end;
    end;
  end;
  Caption := SchedAdminName + ' - ' + oToolkit.SystemSetup.ssCompanyName;
  Res := ConfigObject.OpenFile;
  if Res <> 0 then
    DoMessage('Unable to open Settings file. Error ' + IntToStr(Res));
  Res := TaskObject.OpenFile;
  if Res <> 0 then
    DoMessage('Unable to open Task file. Error ' + IntToStr(Res));
  dsTasks.FileName := CompanyPath + TaskFileName;
  mlTasks.Active := True;
  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
  oSettings.UserName := GetUserID;
  LoadAllSettings;
end;

procedure TfrmTaskList.FormDestroy(Sender: TObject);
begin
  ConfigObject.CloseFile;
  TaskObject.CloseFile;
  oToolkit := nil;
end;

procedure TfrmTaskList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTaskList.AddTestRec;
var
  Res : Integer;
begin
  FillChar(TaskRec, SizeOf(TaskRec), 0);
  TaskRec.stTaskName := LJVar('Task 6', 50);
  TaskRec.stNextRunDue := FormatDateTime('yyyymmddhhnn', Now);
  TaskRec.stTaskType := 'A';

  TaskRec.stTaskID := '003';
  TaskRec.stStatus := 0;

  Res := Add_Rec(F[TaskF], TaskF, TaskRec, 0);
  DoMessage(IntToStr(Res));
end;

procedure TfrmTaskList.btnSettingsClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmTaskList.btnAddClick(Sender: TObject);
begin
  AddTask;
end;

procedure TfrmTaskList.dsTasksGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
var
  LTaskRec : ^TScheduledTaskRec;

  function Processname(s : string) : string;
  var
    i, j : integer;
  begin
    i := Pos('_', s);
    Result := Copy(s, 1, i-1);
    j := Pos('Daybook', s);
    Result := Copy(s, i + 1, j + 6 - i) + ' (' + Result + ')';
    Result := AnsiReplaceStr(Result, 'ZJob', 'Job');
  end;

begin
  LTaskRec := PData;
  Case FieldName[1] of
     'N' : if LTaskRec.stOneTimeOnly then
             FieldValue := ProcessName(Trim(LTaskRec.stTaskName))
           else
             FieldValue := Trim(LTaskRec.stTaskName);
     'R' : FieldValue := DateTimeToStr(STr2DT(LTaskRec.stNextRunDue));
     'S' : FieldValue := StatusString(LTaskRec.stStatus);
     'T' : if LTaskRec.stTaskType = tcCustom then
             FieldValue := GetCustomTaskTypeString(Trim(LTaskRec.stCustomClassName))
           else
             FieldValue := TaskTypeString(LTaskRec.stTaskType);
  end;
end;

procedure TfrmTaskList.SetButtons;
begin
  btnEdit.Enabled := mlTasks.ItemsCount > 0;
  btnDelete.Enabled := btnEdit.Enabled;
  mniEdit.Enabled := btnEdit.Enabled;
  mniDelete.Enabled := btnDelete.Enabled;
  mlTasksChangeSelection(mlTasks);
end;

procedure TfrmTaskList.mlTasksAfterLoad(Sender: TObject);
begin
  SetButtons;
end;

procedure TfrmTaskList.AddTask;
var
  Res : Integer;
begin
  with TfrmTaskWizard.Create(Application) do
  Try
    Caption := 'Add Task';
    PageControl1.TabIndex := 0;
    PageControl1Change(Self);
    cbWeekMonthChange(Self);
    ConfigObject.GetRecord;
    edtEmail.Text := Trim(ConfigObject.EmailAddress);
    ActiveControl := cbTaskType;
    ShowModal;
    if ModalResult = mrOK then
    begin
      FormToTask;
      TaskObject.Status := tsIdle;
      if TaskObject.TimeType = 1 then
        TaskObject.LastRun := Trunc(Now)
      else
        TaskObject.LastRun := Now;

//      TaskObject.TaskType := 'A';
      Res := TaskObject.AddRec;
      if Res <> 0 then
        DoMessage(IntToStr(Res))
      else
        mlTasks.RefreshDB;
    end;
  Finally
    Free;
  End;
end;

function TfrmTaskList.GetSelected(Lock : Boolean = False): Boolean;
var
  Res : Integer;
  LocalRec : ^TScheduledTaskRec;
begin
  LocalRec := dsTasks.GetRecord;
  if Assigned(LocalRec) then
  begin
    TaskObject.Index := 0;
    Res := TaskObject.FindRecord(B_GetEq, LocalRec.stTaskName, Lock);
    if Lock and (Res in [84, 85]) then
      DoMessage('Record is currently locked by another user');
    Result := Res = 0;
  end;
end;

procedure TfrmTaskList.btnDeleteClick(Sender: TObject);
var
  Res : Integer;
begin
  if GetSelected(False) then
  begin
    if msgBox('Are you sure you want to delete this task?', mtConfirmation, [mbYes, mbNo], mbYes, 'Delete Task') = mrYes then
    begin
      Res := TaskObject.DeleteRec;
      if Res <> 0 then
        DoMessage('Failed to delete record. Error ' + IntToStr(Res))
      else
        mlTasks.RefreshDB;
    end;
  end;
end;

procedure TfrmTaskList.EditTask;
var
  Res : Integer;
begin
  if GetSelected(True) then
  with TfrmTaskWizard.Create(Application) do
  Try
    Caption := 'Edit Task - ' + Trim(TaskObject.Name);
    IsEdit := True;
    TaskToForm;
    if not TaskObject.OneTimeOnly then
    begin
      PageControl1.TabIndex := 0;
      ActiveControl := cbTaskType;
    end
    else
    begin //From Enter1 - Disable controls so that user can't radically change task.
      PageControl1.TabIndex := pgDetails;
      PageControl1.ActivePage := tsDetails;
      cbTaskType.Enabled := False;
      edtTaskName.Enabled := False;
      cbWeekMonth.Enabled := False;
      rbMins.Enabled := False;
      rbMinsBetween.Enabled := False;
    end;
    PageControl1Change(Self);
    cbWeekMonthChange(Self);
    DayOrTimeChanged := False;
    ShowModal;
    if ModalResult = mrOK then
    begin
      FormToTask;
      TaskObject.Status := tsIdle;
      Res := TaskObject.PutRec(DayOrTimeChanged);
      if Res <> 0 then
        DoMessage('Unable to store task. Error ' + IntToStr(Res))
      else
        mlTasks.RefreshDB;
    end
    else
      GetSelected; //Remove lock
  Finally
    Free;
  End;
end;

procedure TfrmTaskList.btnEditClick(Sender: TObject);
begin
  EditTask;
end;

procedure TfrmTaskList.mlTasksRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  EditTask;
end;

procedure TfrmTaskList.FormResize(Sender: TObject);
begin
  if Height < 200 then
    Height := 200;
  if Width < 200 then
    Width := 200;
end;

procedure TfrmTaskList.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlTasks, Self.Name);
end;

procedure TfrmTaskList.SaveAllSettings;
begin
  oSettings.SaveList(mlTasks, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmTaskList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmTaskList.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlTasks, Self.Name, nil) of
{    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);}
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlTasks, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmTaskList.Active1Click(Sender: TObject);
begin
  if GetSelected(True) then
  begin
    if Active1.Checked then
      TaskObject.Status := tsIdle
    else
      TaskObject.Status := tsInactive;

    TaskObject.PutRec;
    mlTasks.RefreshDB;
  end;
end;

procedure TfrmTaskList.PopupMenu1Popup(Sender: TObject);
begin
  if GetSelected then
    Active1.Checked := TaskObject.Status > 0;
end;

procedure TfrmTaskList.btnRefreshClick(Sender: TObject);
begin
  mlTasks.RefreshDB;
end;

procedure TfrmTaskList.mlTasksKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    mlTasks.RefreshDB;
end;

procedure TfrmTaskList.dsTasksFilterRecord(Sender: TObject; PData: Pointer;
  var Include: Boolean);
var
  LTaskRec : ^TScheduledTaskRec;
  ViewIdx : Integer;
begin
  //Allow system password user to view all jobs
  if IsSystemUser then
  begin
    Include := True;
    EXIT;
  end;
  LTaskRec := PData;
  Case LTaskRec.stTaskType of
    tcView :  begin
                if LTaskRec.stTaskID = '0000' then
                  Include := AllViewsAllowed
                else
                begin
                  Try
                    ViewIdx := (StrToInt(LTaskRec.stTaskID) - 1) div 100;
                    Include := ViewsAllowed[ViewIdx];
                  Except
                    Include := False;
                  End;
                end;
              end;
    tcSalesDaybook   : Include := PostAllowed(pwPostSales);
    tcPurchDaybook   : Include := PostAllowed(pwPostPurch);
    tcNominalDaybook : Include := PostAllowed(pwPostNominal);
    tcStockDaybook   : Include := PostAllowed(pwPostStock);
    tcJobDaybook     : Include := PostAllowed(pwPostJob) or PostAllowed(pwPostTSH);
    else //Custom
      Include := PluginList.PluginExists(Trim(LTaskRec.stCustomClassName));
  end; //Case

  //Don't allow standard user to see  jobs scheduled from Daybook Posting in Exchequer.
  //PR: 29/03/2011 Include one offs in list
//  Include := Include and not LTaskRec.stOneTimeOnly;
end;

Function  CheckParam(ChkStr,PStr  :  Str255;
                 Var DefStr       :  Str255)  :  Boolean;


Var
  n      :  Byte;
  TmpBo  :  Boolean;

Begin
  n:=Length(ChkStr);

  TmpBo:=(UpCaseStr(ChkStr)=UpcaseStr(Copy(PStr,1,n)));

  If (TmpBo) then
    DefStr:=Copy(PStr,Succ(n),(Length(PStr)-n));

  CheckParam:=TmpBo;

end;


Procedure GetParam;

Var
  n      :  Word;
  TmpBo  :  Boolean;
  TmpStr :  Str255;


Begin

  TmpBo:=BOff;


  SBSIn:=BOff;

  DumpFileOff:=BOff;

  ResetBtOnExit:=BOff;

  NoXLogo:=BOff;


  If (ParamCount>0) then
    For n:=1 to ParamCount do
    Begin

      TmpStr:='';

      If (Not SBSIn) then
        SBSIn:=CheckParam(PSwitch+SBSPass,ParamStr(n),TmpStr);

      If (Not DumpFileOff) then
        DumpFileOff:=CheckParam(DumpSwitch,ParamStr(n),TmpStr);

      If (Not ResetBtOnExit) then
        ResetBtOnExit:=CheckParam(ResetBTSwitch,ParamStr(n),TmpStr);

      If (Not NoXLogo) then
        NoXLogo:=CheckParam(NoXLogoSwitch,ParamStr(n),TmpStr);

      If (Not AccelMode) then
        AccelMode:=CheckParam(AccelSwitch,ParamStr(n),TmpStr);

{      If (Not GotPassWord) then
      Begin

        GotPassWord:=CheckParam(AutoPWSwitch,ParamStr(n),TmpStr);

        If (GotPassWord) then
          GotPassWord:=GetLoginRec(TmpStr);
      end; }
    end; {Loop..}


//  SetLoginParams;

{  If (AccelMode) then
    AccelParam^:=AccelSwitch;}

  { avoid COM server registration error for apps which uses com toolkit object for PSQL}
  if EnterpriseLicence.IsSQL and (Not Assigned(GlobalAdoConnection)) then
    InitialiseGlobalADOConnection(SetDrive);


end; {Proc..}

procedure TfrmTaskList.About1Click(Sender: TObject);
begin
  with TfrmAbout.Create(nil) do
  Try
    ShowModal;
  Finally
    Free;
  end;
end;

function TfrmTaskList.GetCustomTaskTypeString(const sClassName : string) : string;
var
  oTask : IScheduledTask;
begin
  oTask := PlugInList.GetItemByClassName(sClassName);
  if Assigned(oTask) then
  Try
    Result := oTask.stType;
  Finally
    oTask := nil;
  End
  else
    Result := '';
end;

procedure TfrmTaskList.ShowErrorMessage(const sMsg: string);
begin
  msgBox(sMsg, mtWarning, [mbOK], mbOK, 'Exchequer Scheduler');
end;

procedure TfrmTaskList.mlTasksChangeSelection(Sender: TObject);
var
  pTask : PScheduledTaskRec;
begin
  pTask := PScheduledTaskRec(dsTasks.GetRecord);
  if Assigned(pTask) then
    btnEdit.Enabled := not pTask^.stOneTimeOnly;
end;

//PR: 14/04/2011 ABSEXCH-2809 System user wasn't seeing GL Views.
procedure TfrmTaskList.SetAllViewsOn;
var
  i : integer;
begin
  AllViewsAllowed := True;
  AnyViewsAllowed := True;
  for i := 0 to 9 do
    ViewsAllowed[i] := True;
end;

Initialization
  GetParam;

end.
