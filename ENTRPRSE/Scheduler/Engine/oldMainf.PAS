unit Mainf;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, Menus, ImgList, ComCtrls, ToolWin, About, jpeg, ElVar,
  SchedVar, BTSupU1, VarConst;

const

  WM_StartPolling = WM_APP + 2001;
  VAOEntDirRootKey = HKEY_CURRENT_USER;
  VAOEntDirKey = 'Software\Exchequer\Enterprise';
  VAOEntName = 'SystemDir';



type

  TServiceCallBackProc = procedure(WhichFunc : Byte; const Msg : string = '') of Object;

  TfrmScheduler = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    ToolBar1: TToolBar;
    Help1: TMenuItem;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    BackGroundImage: TImage;
    Polling1: TMenuItem;
    Start1: TMenuItem;
    HideBackground1: TMenuItem;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    About1: TMenuItem;
    N1: TMenuItem;
    StatBar: TStatusBar;
    HelpContents1: TMenuItem;
    ImageList2: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Exit1Click(Sender: TObject);
    procedure HideBackground1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpContents1Click(Sender: TObject);
  private
    { Private declarations }
    FServiceCallBack : TServiceCallBackProc;
    Abort : Boolean;
    MDIDefProc:pointer;
    MDIInstance:TFarProc;
    FirstTime, FirstActivate : Boolean;
    AmClosing : Boolean;
    FlagsInUse : Boolean;
    FCoList, FDirList, FDebug : TStringList;
    EntPath, ToolkitVersion : string;
    MapiOk : Boolean;
    ToolkitOK : Boolean;
    FMappedDrive : String;
    FLocalPath : string;
    MyDC       : hDC;
    FPrevState : TWindowState;
    procedure MDIWndProc(var prmMsg:TMessage);
    procedure CreateWnd;override;
    procedure ShowBitmap(prmDC:hDC);

    procedure SentProgress(const TaskName, DataPath : string; OffLine : Boolean);
    function CheckPath(const DataPath : AnsiString) : Boolean;
    procedure DisplayHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure HideMe;
    procedure NotifyError(Sender : TObject; WhichType : Integer);
    procedure NotifyErrorSync;
    procedure WMSetFocus(var Msg : TMessage); message WM_SetFocus;
    function InBackupWindow : Boolean;
    procedure InitGlobalVars;
    function CloseFormPos : integer;
    procedure SetEnterpriseDir(const ADir : AnsiString);
    procedure LoadDirList;
    function Localise(const APath : string) : string;
    procedure SetServiceDriveStrings;
    function GetImagePath : string;
    procedure AddTaskToQueue(DataRec : TScheduledTaskRec; DataPath: string);
    Procedure Print_File(SetAddr  :  LongInt);
  public
    { Public declarations }
    CurrentData : SmallInt;
    Running : Boolean;
    LocalPath : string;
    procedure Run(DataPath : AnsiString);
    procedure Start;
    procedure Stop;
    procedure ShutDown;

   { procedure WMStopPolling(var Msg : TMessage); message WM_StopPolling}
    procedure WMStartPolling(var Msg : TMessage); message WM_StartPolling;
    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;
    property ServiceCallBack : TServiceCallBackProc read FServiceCallBack write FServiceCallBack;

    procedure StartPolling;
    procedure StartVAO;

    property PrevState : TWindowState read FPrevState;
  end;


var
  frmScheduler: TfrmScheduler;




implementation


{$R *.DFM}
uses
  SchThred, ComObj, Enterprise01_TLB,
  CommsInt, ExThrd2U, {$IFNDEF SERVICE}TrayF,{$ENDIF} SecCodes, Variants,
   GlobVar, Btrvu2, APIUtil, CloseF, FileUtil, RegUtil,
  BtSupU2, UDebug, VAOUtil, Registry, ActiveX, StrUtils,  DataObjs, CtkUtil,
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  LogF;

const
  ChkString = ' checking tasks';



function TfrmScheduler.CheckPath(const DataPath : AnsiString) : Boolean;
//Returns true if there's a scheduled task data file in the Company Dataset in DataPath
begin
{$IFDEF EXSQL}
  Result := SQLUtils.TableExists(IncludeTrailingBackSlash(DataPath) + TaskFileName);
{$ELSE}
  Result := FileExists(IncludeTrailingBackSlash(DataPath) + TaskFileName);
{$ENDIF}
end;

procedure TfrmScheduler.Run(DataPath : AnsiString);
var
  Res : Integer;
begin
  DataPath := Trim(DataPath);
  if CheckPath(DataPath) then
  begin
    if InBackupWindow then
    begin
      SentProgress('', '', True);
      SleepEx(60000, True);

    end
    else
    begin
      //Read all scheduled tasks in this company's datafile. If any are due to
      //run, add them to the thread queue.
      CompanyPath := DataPath;
      Res := TaskObject.OpenFile;
      if Res = 0 then
      begin
        Res := TaskObject.FindRecord(B_GetFirst, '');

        while (Res in [0, 84, 85]) and not Abort do //If record locked then ignore it and go to next
        begin
          SentProgress(Trim(TaskObject.Name), DataPath,  False);
{          if TaskObject.TaskType in ['B', 'C'] then
            DoLog(Trim(TaskObject.Name) + ': Include: ' + IntToStr(TaskObject.IncludeInPost));}
          if (Res = 0) and (TaskObject.Status = tsIdle) and (TaskObject.NextRunDue <= Now) then
          begin
            //LockRecord
            Res := TaskObject.FindRecord(B_GetEq, LJVar(TaskObject.Name, 50), True);
            if Res = 0 then
            begin
              TaskObject.Status := tsProcessing;
              TaskObject.PutRec;
              AddTaskToQueue(TaskObject.DataRecord, DataPath);
              DoLog('Path: ' + DataPath + '. Task ' +
                       QuotedStr(Trim(TaskObject.Name)) + ' added to queue.');
            end
            else
              Res := TaskObject.FindRecord(B_GetEq, LJVar(TaskObject.Name, 50));
          end;
          SleepEx(1000, True);
          Res := TaskObject.FindRecord(B_GetNext, '');
        end;

        Res := TaskObject.CloseFile;
      end;
    end;
  end;
end;

procedure TfrmScheduler.FormCreate(Sender: TObject);
const
  DbgFileName = 'DebugSentimail.txt';
var
  a, b, c : longint;
  Res : Word;
  Stat : longint;
begin
  MyDC := 0;
  Caption := SchedEngineName;
  Init_STDCurrList; //In btsupu2.pas
  if ParamCount > 0 then
    DebugModeOn := UpperCase(ParamStr(1))[2] = 'D'
  else
{  if FileExists('d:\' + DbgFileName) or FileExists('c:\' + DbgFileName) then
    DebugModeOn := True
  else}
    DebugModeOn := False;
  WorkStationName := WinGetComputerName;
  HideBackGround1.Checked := NoXLogo;
//  MapiOK := ECMAPIAVAILABLE; //need this call for static linking of entcomms.dll
  FirstActivate := True;
  AmClosing := True;
  Abort := False;
  Running := False;
  {$IFNDEF VAO}
  Try
    FToolkit := CreateToolkitWithBackDoor;
//    DoLog('Toolkit created');
  Except
    FToolkit := nil;
    {$IFNDEF SERVICE}
    msgBox('Unable to create COM Toolkit. Application will terminate', mtError, [mbOK], mbOK, 'Exchequer Scheduler');
    Application.Terminate;
    {$ENDIF}
  End;
  {$ENDIF}

    FCoList := TStringList.Create;
    FDirList := TStringList.Create;
    FDebug := TStringList.Create;

    CurrentData := 0;

  {$IFNDEF SERVICE}
  Application.OnShowHint := DisplayHint;
  Application.HintPause := 100;
  {$ENDIF}
//  ProgressProc := SentProgress;
  InitGlobalVars;
  FPrevState := WindowState;

 {$IFNDEF SERVICE}
  PostMessage(Self.Handle, WM_StartPolling, 0, 0);
 {$ENDIF}
end;


procedure TfrmScheduler.ToolButton2Click(Sender: TObject);
var
  i : integer;
begin
  if FirstActivate then
  begin
    Create_BackThread;
    FirstActivate := False;
  end;

  if not InBackupWindow then
  begin
    if Running then
    begin
      Running := False;
      Start1.Caption := '&Resume';
      Start1.ImageIndex := 1;
      ToolButton2.ImageIndex := 1;
//      ToolButton2.Hint := Start1.Caption;
      DoLog('Scheduler paused');
      Application.ProcessMessages;
      Stop;
      PollThread.Terminate;
      StatBar.Panels[1].Text := 'Paused';
     //
    end
    else
    begin
      Reset_B;
      Start1.Caption := '&Pause';
      Start1.ImageIndex := 0;
      ToolButton2.ImageIndex := 0;
//      ToolButton2.Hint := 'Stop' + ChkString;
      DoLog('Scheduler started');
      Application.ProcessMessages;
      {$IFDEF VAO}
      PollProc := StartVAO;
      {$ELSE}
      PollProc := Start;
      {$ENDIF}

      Running := True;
      Abort := False;


      PollThread := TPollThread.Create;
      ErrorProc := NotifyErrorSync;

      ResetCloseFlags;
      Pollthread.Resume;
    end;
    ToolButton2.Hint := Copy(Start1.Caption, 2, 6);
    {$IFNDEF SERVICE}
    if not FirstTime then
      frmSchedTray.SetPause;
    {$ENDIF}
  end;
end;

procedure TfrmScheduler.FormDestroy(Sender: TObject);
begin

  FToolkit := nil;
  STDCurrList.Free; //In btsupu2.pas
  if Assigned(FCoList) then
    FCoList.Free;
  if Assigned(FDirList) then
    FDirList.Free;
  Try
    if Assigned(PollThread) then
      PollThread.Terminate;
  Except
  End;
  {$IFDEF SERVICE}
  Try
    if Assigned(BackThread) then
    begin
      while not BackThread.AllClear do
        SleepEx(100, True);
      FreeAndNil(BackThread);
    end;
  Except
  End;
  {$ENDIF}
end;

procedure TfrmScheduler.Start;
begin
  SentinelsSoFar := 0;
  Abort := False;
  while not Abort and not PollThread.IsTerminated do
  begin
    Running := True;
    if Not Abort then
    begin
      Run(FCoList[CurrentData]);
    end;
    Running := False;
    {$IFNDEF SERVICE}
    Application.ProcessMessages;
    {$ENDIF}
    if Not Abort then
      inc(CurrentData);
    if CurrentData > Pred(FCoList.Count) then
      CurrentData := 0;
  end;
end;

procedure TfrmScheduler.Stop;
begin
  Abort := True;
  Running := False;
end;

procedure TfrmScheduler.SentProgress(const TaskName, DataPath : string; OffLine : Boolean);
var
  i, j : longint;
begin
    if Offline then
      StatBar.Panels[1].Text := 'Offline'
    else
      if Running then
        StatBar.Panels[1].Text := 'Polling ' + DataPath + ' - Checking Task ' +
                                 QuotedStr(Trim(TaskName));
  {$IFNDEF SERVICE}
  Application.ProcessMessages;
  {$ENDIF}
end;


procedure TfrmScheduler.MDIWndProc(var prmMsg:TMessage);
begin
 with prmMsg do
  begin
   if (Msg=WM_ERASEBKGND) and not HideBackGround1.Checked then
    begin
      ShowBitmap(wParam);
      Result :=1;
    end
{    else
    if Msg = WM_SetFocus then
      WMSetFocus(prmMsg)     }
    else
    Result:=CallWindowProc(MDIDefProc,ClientHandle,Msg,wParam,lParam);
  end;
end;

procedure TfrmScheduler.CreateWnd;
begin
 inherited CreateWnd;
 MDIInstance:=MakeObjectInstance(MDIWndProc); { create wrapper }
 MDIDefProc:=pointer(SetWindowLong(ClientHandle,GWL_WNDPROC,
     longint(MDIInstance)) );
end;

procedure TfrmScheduler.ShowBitmap(prmDC:hDC);
Var
//  MyDC       : hDC;
  Ro, Co     : Word;
  OldPalette : HPalette;

Begin

  MyDC := prmDC;

  OldPalette:=SelectPalette(MyDC,BackgroundImage.Picture.BitMap.Palette,False);
  try
    RealizePalette(MyDC);

    Ro := (BackgroundImage.Picture.Height - ClientHeight) div 2;
    Co := (BackgroundImage.Picture.Width - ClientWidth) div 2;

{    for Ro := 0 TO ClientHeight DIV BackgroundImage.Picture.Height DO
       for Co := 0 TO ClientWIDTH DIV BackgroundImage.Picture.Width DO
         BitBlt(MyDC, Co*BackgroundImage.Picture.Width, Ro*BackgroundImage.Picture.Height,
                BackgroundImage.Picture.Width, BackgroundImage.Picture.Height,
                BackgroundImage.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);}


     BitBlt(MyDC, 0, 0,
            ClientWidth, ClientHeight,
            BackgroundImage.Picture.Bitmap.Canvas.Handle, Co, Ro, SRCCOPY);

  finally
    SelectPalette(MyDC,OldPalette,true);
  end; {try..}

end;

procedure TfrmScheduler.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  T : Integer;
  TerminateNow : Boolean;
  FinishCount : longint;
begin
  Poller_WantToClose := True;
  {$IFNDEF SERVICE}
  if ToolButton2.ImageIndex <> 1 then
    ToolButton2Click(Self);
  Application.ProcessMessages;
  Application.ProcessMessages;
  Show;
  Abort := True;
  Application.ProcessMessages;
  Sleep(100);
  Application.ProcessMessages;

  if AnyTasksInUse then
  begin
    with TfrmSchedCloseStatus.Create(Self) do
    Try
      T := CloseFormPos;
      if T + Height < Screen.Height then
        Top := T;
      Show;
      Application.ProcessMessages;
      Sleep(100);
      while AnyTasksInUse and not TerminateNow do
      begin
        Application.ProcessMessages;
        SleepEx(1, True);
{        SetActiveLabel(0, Poller_OkToClose);
        SetActiveLabel(1, GetQuery_OkToClose);
        SetActiveLabel(2, Conveyor_OkToClose);}
        IncProgress;
        TerminateNow := DoTerminate;
{        if DoTerminate then
          Application.Terminate;}
        Application.ProcessMessages;
        if TerminateNow then
        begin
          //If we have any tasks queued in the object controller, their current status will be 'processing'.
          //We need to reset them to idle, so they will be run when the engine runs again.
          if not Running then
            ResetQueuedTasks;
        end;
      end;
      Close;
    Finally
      Free;
    End;
  end;
  {$ELSE}
  FinishCount := 1;
  while AnyTasksInUse and (FinishCount < ServiceTimeOut) do
  begin
    Application.ProcessMessages;
    SleepEx(1000, True);
    inc(FinishCount);
  end;
  {$ENDIF}
  CanClose := True;
end;

{procedure WMStopPolling(var Msg : TMessage); message WM_StopPolling;
procedure WMStartPolling(var Msg : TMessage); message WM_StartPolling;}


procedure TfrmScheduler.Exit1Click(Sender: TObject);
begin
  HideMe;
end;

procedure TfrmScheduler.HideBackground1Click(Sender: TObject);
begin
  HideBackGround1.Checked := not HideBackGround1.Checked;
  InvalidateRect(0, nil, True);
  Application.ProcessMessages;
end;

procedure TfrmScheduler.About1Click(Sender: TObject);
begin
  with TfrmAbout.Create(nil) do
  Try
    lblTitle.Caption := SchedEngineName;
    lblVersion.Caption := 'Version: ' + SchedulerVersion;
    ShowModal;
  Finally
    Free;
  end;
end;

procedure TfrmScheduler.DisplayHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if Assigned(HintInfo.HintControl) then
    StatBar.Panels[0].Text := GetLongHint(HintInfo.HintControl.Hint);
end;

procedure TfrmScheduler.FormResize(Sender: TObject);
begin
{  if not HideBackGround1.Checked then
  begin
    InvalidateRect(0, nil, False);
    Application.ProcessMessages;
  end;}
{  if MyDC <> 0 then
    ShowBitmap(MyDC);}
  StatBar.Panels[0].Width := StatBar.Width div 2;
  FPrevState := WindowState;
end;


Procedure TfrmScheduler.WMSysCommand(Var Message  :  TMessage);
begin
//Intercept close commands from form and just hide it
   if (Message.wParam = SC_CLOSE) {or (Message.wParam = SC_MINIMIZE) }then
   begin
     HideMe;
   end
   else
     Inherited;
end;

procedure TfrmScheduler.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  WaitCount : integer;
begin
   if Running then
     ToolButton2Click(Self);
   WaitCount := 1;
   While FlagsInUse and (WaitCount < 11) do
   begin
     Sleep(10);
     inc(WaitCount);
   end;

   Application.ProcessMessages;
   SetWindowLong(ClientHandle,GWL_WNDPROC,longint(MDIDefProc));
 { dispose of instance }
   FreeObjectInstance(MDIInstance);
end;

procedure TfrmScheduler.HideMe;
begin
   Hide;
end;

procedure TfrmScheduler.FormHide(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TfrmScheduler.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_SHOW);
  FormResize(Self);
end;


procedure TfrmScheduler.NotifyError(Sender : TObject; WhichType : Integer);
begin
 {$IFNDEF SERVICE}
  frmSchedTray.SetTrayIcon(icError);
 {$ENDIF}
end;

procedure TfrmScheduler.WMSetFocus(var Msg : TMessage);
var
  OtherID, MyID : Longint;
  p : PChar;
begin
{  if not Visible then
  with Msg do
  begin
    GetMem(p, 256);
    GetWindowText(HWnd(wParam),
    OtherID := GetWindowThreadProcessId(HWnd(wParam), nil);
    MyID := GetCurrentThreadId;
    if AttachThreadInput(MyID, OtherID, True) then
    begin
      Windows.SetFocus(HWnd(wParam));
      AttachThreadInput(MyID, OtherID, False);
      Result := 0;
    end;
  end;}
end;



function TfrmScheduler.InBackupWindow : Boolean;
var
  t1Start, t1End, T : TDateTime;
  FCrossMidnight : Boolean;

  function GetTime(const s : string) : TDateTime;
  begin
    Try
      Result := StrToTime(s);
    Except
      Result := 0;
    End;
  end;

begin
  Result := IsInBackupWindow(Now);
{  Result := False;
  ConfigObject.OpenFile;
  Try
    ConfigObject.GetRecord;
    t1Start := ConfigObject.StartTime;
    t1End := ConfigObject.EndTime;

    FCrossMidnight := t1Start > t1End;



    T := Now;
    T := T - Trunc(T);

    if FCrossMidnight then
      Result := (T > t1Start) or (T < t1End)
    else
      Result := (T > t1Start) and (T < t1End);
  Finally
    ConfigObject.CloseFile;
  End;}
end;

procedure TfrmScheduler.NotifyErrorSync;
begin
 // NotifyError(ErrorSender, ErrorTransType);
end;

procedure TfrmScheduler.WMStartPolling(var Msg : TMessage);
begin
  StartPolling;
end;



procedure TfrmScheduler.InitGlobalVars;
var
  i : integer;
  a, b, c : longint;
begin
  {$IFDEF VAO}
  ResetVAOInfo;
  FToolkit := nil;
  SleepEx(1000, True);
  FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  {$ENDIF}
  if Assigned(FToolkit) then
  begin
    FCoList.Clear;
    ToolkitVersion := FToolkit.Version;
    {$IFDEF SERVICE}
    SetServiceDriveStrings;
    {$ENDIF}
    for i := 1 to FToolkit.Company.cmCount do
    {$IFNDEF SERVICE}
      FCoList.Add(Trim(FToolkit.Company.cmCompany[i].coPath));
    {$ELSE}
      FCoList.Add(Localise(Trim(FToolkit.Company.cmCompany[i].coPath)));
    {$ENDIF}
{    FCoList.SaveToFile('c:\complist.txt');
    FDebug.SaveToFile('c:\debug.txt');}
    GlobalEntPath := GetEnterpriseDirectory;
    EntPath := GlobalEntPath;
    {$IFDEF VAO}
    {$ELSE}
//    LogDir := GlobalEntPath + 'LOGS\';
    {$ENDIF}
  end;
{  for i := 0 to FCoList.Count - 1 do
    DoLog(FCoList[i]);}
end;


procedure TfrmScheduler.HelpContents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

function TfrmScheduler.CloseFormPos : integer;
var
  P : TPoint;
  i : integer;
  t, h : integer;
begin
  for i := 0 to MDIChildCount - 1 do
    if Pos('Object', MDIChildren[i].Caption) > 0 then
    begin
      t := MDIChildren[i].Top;
      h := MDIChildren[i].Height;
    end;
  P := Point(0, t);

  P := ClientToScreen(P);

  if P.Y < 250 then
  begin
    P := Point(0, t + h + 16);
    P := ClientToScreen(P);
  end
  else
    P.Y := P.Y - 250;

  Result := P.Y;
end;







procedure TfrmScheduler.StartPolling;
begin
  {$IFDEF SERVICE}
   {$IFNDEF VAO}
{   if not CheckLicenceOK then
   begin
     if Assigned(FServiceCallBack) then
       FServiceCallBack(1, 'Sentimail is not licenced. Closing down.');
   end
   else}
   if not Assigned(FToolkit) then
   begin
     if Assigned(FServiceCallBack) then
       FServiceCallBack(1, 'Unable to create COM Toolkit. Closing down.');
   end
   else
   {$ENDIF}
   begin
  {$ENDIF}
  FirstTime := True;
  DoLog('Start Polling');
  ToolButton2Click(Self);
  FirstTime := False;
  {$IFDEF SERVICE}
  end;
  {$ENDIF}
end;

procedure TfrmScheduler.ShutDown;
begin
  if Running then
    ToolButton2Click(Self);
  Stop;
  SleepEx(2000, True);
  Close;
end;

procedure TfrmScheduler.SetEnterpriseDir(const ADir : AnsiString);
begin
  with TRegistry.Create do
  Try
    LazyWrite := False;
    RootKey := VAOEntDirRootKey;
    OpenKey(VAOEntDirKey, True);
    WriteString(VAOEntName, ADir);
  Finally
    Free;
  End;
end;


procedure TfrmScheduler.LoadDirList;
//Used by vao service to create a list of Exchequer directories
var
  SRec : TSearchRec;
  s, DirMask, SubDir : string;
begin
{  with TElertWorkstationSetup.Create do
  Try
    DirMask := VAODirPrefix + '*';
    SubDir := IncludeTrailingBackslash(VAOSubDir);
  Finally
    Free;
  End;}

  FDirList.Clear;
  if FindFirst(DirMask, faDirectory, SRec) = 0 then
  begin
    repeat
      s := Copy(DirMask, 1, 3) + IncludeTrailingBackslash(SRec.Name);
{$IFDEF EXSQL}
      if SQLUtils.ValidCompany(s + SubDir) then
{$ELSE}
      if FileExists(s + SubDir + 'Company.Dat') then
{$ENDIF}
        FDirList.Add(s + SubDir);
      Application.ProcessMessages;
    until FindNext(SRec) <> 0;
    FindClose(SRec);
  end;
end;

procedure TfrmScheduler.StartVAO;
var
  CurrentDir : Integer;
begin
  SentinelsSoFar := 0;
  Abort := False;
  LoadDirList;
  CurrentDir := 0;
  CoInitialize(nil);
  while not Abort and not PollThread.IsTerminated do
  begin
    Running := True;

    SetEnterpriseDir(FDirList[CurrentDir]);
    InitGlobalVars;

    while not Abort and not PollThread.IsTerminated and (CurrentData < FCoList.Count) do
    begin
      if Not Abort then
      begin
        Run(FCoList[CurrentData]);
      end;
      Application.ProcessMessages;
      if Not Abort then
      inc(CurrentData);

    end; //while

    if CurrentData > Pred(FCoList.Count) then
    begin
      CurrentData := 0;
      SentinelsSoFar := 0;
      while not BackThread.AllClear do
        SleepEx(100, True);
      inc(CurrentDir);
      if CurrentDir > Pred(FDirList.Count) then
      begin
        LoadDirList; //refresh directories
        CurrentDir := 0;
      end;
    end;

  end; //while

end;

function TfrmScheduler.Localise(const APath: string): string;
begin
  {$IFNDEF VAO}
  Result := AnsiReplaceStr(APath, FMappedDrive, FLocalPath);
  Result := WinGetShortPathName(Result);
  FDebug.Add('Localise: ' + APath + ', Result: ' + Result);
  {$ELSE}
   Result := APath;
  {$ENDIF}
end;

procedure TfrmScheduler.SetServiceDriveStrings;
var
  s : string;
  i, j : integer;
begin
  LocalPath := UpperCase(ExtractFilePath(ParamStr(0)));
  FDebug.Add('LocalPath: ' + LocalPath);
  with FToolkit.Company do
  begin
    for i := 1 to cmCount do
    begin
      s := UpperCase(Trim(cmCompany[i].coPath));
      FMappedDrive := Copy(s, 1, 3);
      ServiceMappedDrive := FMappedDrive;
      FDebug.Add('FMappedDrive: ' + FMappedDrive);
      s := Copy(s, 4, Length(s));
      FDebug.Add('s : ' + s);
      j := Pos(s, LocalPath);
      if j > 0 then
      begin
        FLocalPath := IncludeTrailingBackslash(Copy(LocalPath, 1, j - 1));
        ServiceLocalDir := FLocalPath;
        FDebug.Add('FLocalPath: ' + FLocalPath);
        Break;
      end;

    end;
  end;
end;

function TfrmScheduler.GetImagePath: string;
begin
  with TRegistry.Create(KEY_READ) do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey('SYSTEM\CurrentControlSet\Services\' + 'SentimailService', False) then
    begin
      Result := UpperCase(ExtractFilePath(ReadString('ImagePath')));
    end;
  finally
    Free;
  end;


end;

procedure TfrmScheduler.AddTaskToQueue(DataRec : TScheduledTaskRec; DataPath: string);
var
  ANom     :  NominalRec;
  AJob     :  JobRecType;
begin
  if not Abort then
  begin
    //We need to keep a record of tasks currently queued to avoid losing them if the application is closed.
    AddInUse(DataPath, DataRec.stTaskName);
    Case DataRec.stTaskType of
      tcView           : begin
                           FillChar(ANom, SizeOf(ANom), 0);
                           ANom.CarryF := StrToInt(Copy(DataRec.stTaskID, 1, 4));
                           ANom.AltCode := DataRec.stTaskName;
                           AddSchedCheckNom2Thread(Self, ANom, AJob, 6, DataPath);
                         end;
      tcSalesDaybook..tcStockDaybook
                       : begin
                           AddSchedPost2Thread(Ord(DataRec.stTaskType) - Ord(tcView),
                                               Self,
                                               GetDocTypesInPost(DataRec.stIncludeInPost),
                                               DataRec.stPostSeparated, DataRec.stPostProtected,
                                               DataRec.stTaskName,
                                               DataPath,
                                               DataRec.stEmailAddress);
                         end;
      tcJobDaybook     : begin
                           AddSchedJobPost2Thread(0, Self, DataRec.stIncludeInPost, DataRec.stTaskName,
                                                    DataPath, DataRec.stEmailAddress);
                         end;
      else
        AddCustomTask2Thread(Self, DataRec.stTaskName, DataRec.stCustomClassName, DataPath);
    end; //Case
  end;
end;

procedure TfrmScheduler.Print_File(SetAddr: Integer);
begin
  If (Assigned(BackThread)) then
  Try
    BackThread.PrintJobAddr:=SetAddr;
    BackThread.Print_ThJob;
  except;

  end; {Try..}
end;

procedure TfrmScheduler.WMFormCloseMsg(var Message: TMessage);
begin
  With Message do
  Begin

    Case WParam of
      98  :  Print_File(LParam);
    end;
  end;
end;

Initialization

finalization



end.
