unit SdiMainf;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, SentU, Menus, ImgList, ComCtrls, ToolWin, About, jpeg,
  ElVar, {$IFDEF AQ}WorkSta2, StdCtrls, AdvToolBar, AdvToolBarStylers,
  AdvGlowButton{$ELSE}workStat{$ENDIF}, Flags, AgentList;

const
  WM_StartPolling = WM_APP + 2001;
  WM_SHUTDOWN = WM_APP + 2002;
  VAOEntDirRootKey = HKEY_CURRENT_USER;
  VAOEntDirKey = 'Software\Exchequer\Enterprise';
  VAOEntName = 'SystemDir';

type
  TServiceCallBackProc = procedure(WhichFunc : Byte; const Msg : string = '') of Object;

  TfrmEngine = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Polling1: TMenuItem;
    Start1: TMenuItem;
    Setup1: TMenuItem;
    Workstation1: TMenuItem;
    Help1: TMenuItem;
    HelpContents1: TMenuItem;
    About1: TMenuItem;
    ImageList1: TImageList;
    StatBar: TStatusBar;
    lvStatus: TListView;
    Timer1: TTimer;
    AdvStyler: TAdvToolBarOfficeStyler;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    btnRun: TAdvGlowButton;
    btnPause: TAdvGlowButton;
    btnStart: TAdvGlowButton;
    DDn1Btn: TAdvGlowButton;
    btnExit: TAdvGlowButton;
    btnWorkStation: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    procedure ToolButton5aClick(Sender: TObject);
    procedure btnWorkStationClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Workstation1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure HelpContents1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FSentinel : TSentinelPoller;
    FServiceCallBack : TServiceCallBackProc;
    Abort : Boolean;
    FirstTime, FirstActivate : Boolean;
    AmClosing : Boolean;
    FlagsInUse : Boolean;
    FCoList, FDirList, FDebug : TStringList;
    EntPath, ToolkitVersion : string;
    MapiOk : Boolean;
    ToolkitOK : Boolean;
    FMappedDrive : String;
    FLocalPath : string;
    FLogF : TextFile;
    Running : Boolean;

    FAgentList : TAgentList;
    CurrentData : SmallInt;
    LocalPath : string;
    function InBackupWindow : Boolean;
    function CheckPath(const DataPath : AnsiString) : Boolean;
    function WantSetFlag(SetOn : Boolean; Flags : Word; Ws : TElertWorkstationSetup) : Boolean;
    procedure ResetFlags(DataPath : AnsiString);
    procedure ClearFlags;
    procedure StartFlags;

    procedure SetServiceDriveStrings;

    procedure SentProgress(PollProgress : TPollProgressRec);
    procedure DisplayHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);

    procedure InitGlobalVars;
    procedure ResetCrashedSentinels(const DataPath : string);
    procedure ResetAllCrashedSentinels;
    procedure ResetOneCrashedSentinel(const ADataPath : string;
                                      const AUser : string;
                                      const AName : string);
    procedure PurgeOutputs(const UID, EN : string);

    function GetCompanyCode(const Apath : string) : string;

    function NewSentinel(Ename, UserID : ShortString;
                          DataPath : AnsiString; APurpose : TSentinelPurpose;
                          APriority : Byte; ARep : ShortString = ''; NewRep : Boolean = False) : Boolean;


    procedure Run(DataPath : AnsiString);
    procedure Start;
    procedure Stop;
    procedure ClearFlagFiles;

    procedure DeleteLogFiles(const aPath : string);
    procedure DeleteAllOldLogFiles;

    procedure AddToPollLog(const s : string);
    procedure SetMenuItems(Running : Boolean);

   { procedure WMStopPolling(var Msg : TMessage); message WM_StopPolling}
    procedure WMStartPolling(var Msg : TMessage); message WM_StartPolling;
    procedure WMShutDown(var Msg : TMessage); message WM_SHUTDOWN;



    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

  public
    { Public declarations }
    property ServiceCallBack : TServiceCallBackProc read FServiceCallBack write FServiceCallBack;
    procedure DoLog(const s : string);
    procedure ShutDown;
  end;

  procedure MapDriveFromIniFile;

var
  frmEngine: TfrmEngine;
  DriveMapped : Boolean;


implementation

{$R *.dfm}
{$R SentXP.Res}

uses
  Enterprise01_TLB, VarConst,
  CommsInt, {$IFNDEF SERVICE}TrayF,{$ENDIF} SecCodes, Logform, DiagF, notifyf, GlobIni, DebugLog,
  Pform, SBS_Int, Variants, GlobVar, SentLic, Btrvu2, APIUtil, CloseF, FileUtil, RegUtil
  {$IFDEF DBF}, DbfInt{$ENDIF}, BtSupU2, BtSupU1, UDebug, VAOUtil, Registry, ActiveX, CTKUtil, Localu, ComObj,
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  StrUtils, DateUtils, VarFPosU, HideMadExcept,

  ServiceDrive;

const
  ChkString = ' checking sentinels';

type
  TCompanyCode = Class
    coCode : string;
  end;

var
    MainToolkit : IToolkit;



procedure MapDriveFromIniFile;
begin
  DriveMapped := ConnectNetworkDrive in [NO_ERROR, ERROR_ALREADY_ASSIGNED];
end;

procedure TfrmEngine.ToolButton5aClick(Sender: TObject);
begin
  Hide;
end;

procedure TfrmEngine.btnWorkStationClick(Sender: TObject);
begin
  Workstation1Click(Self);
end;

procedure TfrmEngine.btnRunClick(Sender: TObject);
begin
  if Running then  //PR: 13/05/2011 Removed check for not in backup window ABSEXCH-11355
  begin
    WorkStation1.Enabled := True;
    btnWorkStation.Enabled := True;
    Start1.Caption := '&Resume Sentimail';
    Start1.ImageIndex := 5;
    btnRun.Hint := 'Start' + ChkString;

    btnRun.Picture.Assign(btnStart.Picture);

  {$IFNDEF SERVICE}
    frmElertTray.SetPause(True);
    StatBar.Panels[0].Text := 'Paused';
    StatBar.Refresh;
  {$ENDIF}


    if Assigned(FSentinel) then
    begin
      FSentinel.Abort := True;
      FSentinel.DebugMessage('Sentimail engine paused', 0, True);
    end;
  {$IFNDEF SERVICE}
    Application.ProcessMessages;
  {$ENDIF}
    Stop;
    ClearFlags;
    Timer1.Enabled := True;
  end
  else
  begin
    WorkStation1.Enabled := False;
    btnWorkStation.Enabled := False;
    Timer1.Enabled := False;
    Start1.Caption := '&Pause Sentimail';
    Start1.ImageIndex := 4;
    btnRun.Hint := 'Stop' + ChkString;
  {$IFNDEF SERVICE}
    frmElertTray.SetPause(False);
  {$ENDIF}

    btnRun.Picture.Assign(btnPause.Picture);
  {$IFNDEF SERVICE}
    Application.ProcessMessages;
  {$ENDIF}

    Abort := False;
    if Assigned(FSentinel) then
      FSentinel.DebugMessage('Sentimail engine started', 0, True);

    with TElertWorkStationSetup.Create do
    Try
      WantDebug := AllowDebug;
    Finally
      Free;
    End;

{      FSentinel.OnTooManyRetries := SyncErr;
    ErrorProc := NotifyErrorSync;}

    Start;
  end;
end;

procedure TfrmEngine.FormCreate(Sender: TObject);
const
  DbgFileName = 'DebugSentimail.txt';
var
  a, b, c : longint;
  Res : Word;
  Stat : longint;
begin
//  BugReportName := GetEnterpriseDirectory + 'SentimailEngineBugReport.txt';
  FAgentList := TAgentList.Create;
  FAgentList.AddToPollLog := AddToPollLog;

  AssignFile(FLogF, ExtractFilePath(Application.ExeName) + 'SentServdebug.txt');
//  Init_STDCurrList; //In btsupu2.pas  //PR: 21/09/2009 Memory Leak Change
  if ParamCount > 0 then
    DebugModeOn := UpperCase(ParamStr(1))[2] = 'D'
  else
  if FileExists(ExtractFilePath(Application.ExeName) + DbgFileName) then
    DebugModeOn := True
  else
    DebugModeOn := False;
  WorkStationName := WinGetComputerName;
  MapiOK := ECMAPIAVAILABLE; //need this call for static linking of entcomms.dll
  FirstActivate := True;
  AmClosing := True;
  DefineFiles('');
  frmPrint := TfrmPrint.Create(Application);
  Close_files(True);//close global files
  Abort := False;
  Running := False;
  {$IFNDEF VAO}
  Try
    DoLog('Create Main Toolkit');
    MainToolkit := CreateToolkitWithBackdoor;
  Except
   on E:Exception do
   begin

    DoLog('Unable to create COM Toolkit. ' + E.Message + ' ' + MainToolkit.LastErrorString);
    MainToolkit := nil;
    {$IFNDEF SERVICE}
    ShowMessage('Unable to create COM Toolkit. Application will terminate');
    Application.Terminate;
    {$ENDIF}
    end;
  End;
  {$ENDIF}

  Try
    CreateDBFComObject;
  Except
  {$IFNDEF SERVICE}
    MessageDlg('A required component (Dbfwrite.dll) is not registered correctly on this workstation.'#10#10 +
               'Please close down your Exchequer system and run WorkStation Setup'#10 +
               'which can be found in the Wstation sub-folder of your Exchequer directory.' +
               #10#10 + 'If you are unsure of how to run Workstation Setup, ' +
               'please contact'#10'your Technical Support.',
               mtError, [mbOK], 0);
  {$ENDIF}
  End;

  begin

    FCoList := TStringList.Create;
    FDirList := TStringList.Create;
    {$IFNDEF VAO}
    InitGlobalVars;
    {$ENDIF}

    {$IFNDEF VAO}
    Try
    with MainToolkit do
    begin
      Try
        DoLog('Set COMTK.DataDirectory: ' + FCoList[0]);
        MainToolkit.Configuration.DataDirectory := FCoList[0];
      Except
        on E:Exception do
          DoLog('Exception ' + E.Message);
      End;
      Stat := OpenToolkit;
      if Stat = 0 then
      begin
        ReportsAvailable := SystemSetup.ssReleaseCodes.rcReportWriter <> rcDisabled;
        with SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes2 do
          VisualReportsAvailable := rcVisualReportWriter <> rcDisabled;
        CloseToolkit;
      end
      else
      {$IFNDEF SERVICE}
        ShowMessage('Unable to open Com toolkit. Error: ' + IntToStr(Stat) +
                #10#10 + QuotedStr(LastErrorString));
      {$ELSE}
        begin
           DoLog('Unable to open Com toolkit. Error: ' + IntToStr(Stat) +
                #10#10 + QuotedStr(LastErrorString));
          ReportsAvailable := False;
        end;
      {$ENDIF}
    end;
    Finally
      MainToolkit := nil;
    End;

    //PR: 18/02/2010
    ClearFlagFiles;
    ResetAllCrashedSentinels;
    DeleteAllOldLogFiles;
    {$ELSE}
    ReportsAvailable := True;
    VisualReportsAvailable := True;
    {$ENDIF}

    //Check for crashed sentinels

    {$IFDEF SERVICE}
    Try
    {$ENDIF}
      if VAOInfo.vaoMode <> smVAO then
      with TElertWorkStationSetup.Create do
      Try
        if SMSAvailable then
        begin

          Try
            FSMSSender := CreateOLEObject('EnterpriseSMS.SMSSender');{ as ISMSSender}
          Except
            RegisterComServer(ExtractFilePath(Application.ExeName) + 'entsms.dll');
            FSMSSender := CreateOLEObject('EnterpriseSMS.SMSSender');
          End;

          {$IFDEF NewSMS}
           FSMSSender.Reset;
          {$ENDIF}
          IgnoreSMS := True;
        end
        else
        begin
          if not IgnoreSMS then //only happens first time we run
          begin
            ReadSetupUSR; //read settings from workstation setup
            Res := SMSQuery;
            if Res = mrYes then
            {$IFDEF OldSMS}
              WorkStation1Click(Self);
            {$ELSE}
            begin
              RegisterComServer(ExtractFilePath(Application.ExeName) + 'entsms.dll');
              {$IFNDEF SERVICE}
              ShowMessage('SMS Sender registered');
              {$ENDIF}
              FSMSSender := CreateOLEObject('EnterpriseSMS.SMSSender');
            end;
            {$ENDIF}
            IgnoreSMS := True;
          end;
        end;
      Finally
        Free;
      End;
    {$IFDEF SERVICE}
    Except
      on E : Exception do
      begin
        if Assigned(FServiceCallBack) then
          FServiceCallback(1, E.Message);
      end;
    End;
    {$ENDIF}
    CurrentData := 0;
    SentinelsSoFar := 0;
    EntEmail := TEntEmail.Create;
  end;

  Application.OnShowHint := DisplayHint;
  Application.HintPause := 100;
//  ProgressProc := SentProgress;


  FSentinel := TSentinelPoller.Create;
  FSentinel.OnSentinelFound := NewSentinel;
  FSentinel.OnProgress := SentProgress;
  if DebugModeOn then
    if Assigned(FSentinel) then
      FSentinel.DebugMessage('About to start polling', 0, True);
  DoLog('About to start polling');
 {$IFNDEF SERVICE}
  PostMessage(Self.Handle, WM_StartPolling, 0, 0);
 {$ENDIF}
 {$IFDEF Debug}
  Caption := Caption + ' (Debug Version)';
 {$ENDIF}
end;

procedure TfrmEngine.ShutDown;
begin
end;

procedure TfrmEngine.Start;
begin
  SentinelsSoFar := 0;
  Abort := False;
  while not Abort do
  begin
    Running := True;

    if Not Abort then
    begin
      Run(FCoList[CurrentData]);
    end;
    {$IFNDEF SERVICE}
    Application.ProcessMessages;
    {$ENDIF}
    if Not Abort then
      inc(CurrentData);
    if CurrentData > Pred(FCoList.Count) then
    begin
      CurrentData := 0;
      SentinelsSoFar := 0;
      ClearFlagFiles; //PR: 18/02/2010
    end;
  end;
  Running := False;
end;

procedure TfrmEngine.Stop;
begin
  Abort := True;
 {$IFNDEF SERVICE}
  Application.ProcessMessages;
 {$ENDIF}
end;

procedure TfrmEngine.Run(DataPath: AnsiString);
begin
  DataPath := Trim(DataPath);
  if CheckPath(DataPath) then
  begin
    FAgentList.CheckForFinishedAgents;
    FAgentList.CheckForStalledAgents;
    SetMenuItems(not InBackupWindow);
    if InBackupWindow then
    begin
      if FlagsInUse then
        ClearFlags;
      FSentinel.ShowProgress('','',spPoller,True);
      Wait(1000);
    end
    else
    begin
      if not FlagsInUse then
      begin
        FlagsInUse := True;
        StartFlags;
      end;
      if FlagsInUse then
        ResetFlags(EntPath);
      FSentinel.Poll(DataPath);
    end;
  end;
end;

function TfrmEngine.CheckPath(const DataPath: AnsiString): Boolean;
var
  s : AnsiString;
begin
  s := IncludeTrailingBackSlash(DataPath) + ElPath;
  Result := TableExists(s + 'SENT.DAT') and TableExists(s + 'SENTLINE.DAT');
end;

function TfrmEngine.InBackupWindow: Boolean;
var
  t1Start, t1End, t2Start, t2End, T : TDateTime;
  FCrossMidnight1, FCrossMidnight2 : Boolean;

  function GetTime(const s : string) : TDateTime;
  begin
    Try
      Result := StrToTime(s);
    Except
      Result := 0;
    End;
  end;

begin
  with TElertWorkstationSetup.Create do
  Try
    t1Start := GetTime(Offline1Start);
    t1End := GetTime(Offline1End);

    FCrossMidnight1 := t1Start > t1End;

    t2Start := GetTime(Offline2Start);
    t2End := GetTime(Offline2End);

    FCrossMidnight2 := t2Start > t2End;

    T := Now;
    T := T - Trunc(T);

    if FCrossMidnight1 then
      Result := (T > t1Start) or (T < t1End)
    else
      Result := (T > t1Start) and (T < t1End);

    if not Result then
    begin
      if FCrossMidnight2 then
        Result := (T > t2Start) or (T < t2End)
      else
        Result := (T > t2Start) and (T < t2End);
    end;

  Finally
    Free;
  End;
end;

procedure TfrmEngine.ClearFlags;
begin
  if Assigned(SentimailFlags) then
    SentimailFlags.Free;
  FlagsInUse := False;
  SentimailFlags := nil;
end;

procedure TfrmEngine.ResetFlags(DataPath: AnsiString);
var
  i : Word;
  Flags, Mask : Word;
  Ws : TElertWorkStationSetup;
  OpenStatus : SmallInt;
  WhichFlag : Word;
begin
  begin
    Ws := TElertWorkStationSetup.Create;
    Try
      Flags := 0;
      Mask := 1;
      for i := 1 to 8 do
      begin
        WhichFlag := i;
        if WantSetFlag(False, WhichFlag, ws) then
          Flags := Flags or Mask;
        Mask := Mask shl 1;
      end;

      if Flags <> 0 then
        with SentimailFlags do
          SetFlags(Flags);
    Finally
      Ws.Free;
    End;
  end
end;

procedure TfrmEngine.StartFlags;
begin
  SentimailFlags := TSentimailFlags.Create(EntPath);
  FlagsInUse := True;
end;

function TfrmEngine.WantSetFlag(SetOn: Boolean; Flags: Word;
  Ws: TElertWorkstationSetup): Boolean;
var
  WantThis : Boolean;
begin
  WantThis := False;

  Case Flags of
    1  : WantThis := Ws.CanSendEmail;
    2  : WantThis := Ws.CanSendSMS;
    3  : WantThis := Ws.CanSendFax;
    4  : WantThis := Ws.CanSendFTP;
    5  : WantThis := Ws.CanRunAlerts;
    6  : WantThis := Ws.CanRunReports;
    7  : WantThis := Ws.CanRunHighPriority;
    8  : WantThis := Ws.CanRunLowPriority;
  end;

  Result := WantThis;
end;

procedure TfrmEngine.InitGlobalVars;
var
  i : integer;
  a, b, c : longint;
  CompCode : TCompanyCode;

  DriveLetter : string;
  NetworkPath : string;
begin
  {$IFDEF VAO}
  ResetVAOInfo;
  MainToolkit := nil;
  SleepEx(1000, True);
  {$ENDIF}
  if Assigned(MainToolkit) then
  begin
    FCoList.Clear;
    ToolkitVersion := MainToolkit.Version;
    {$IFDEF SERVICE}
    if not DriveMapped then
      SetServiceDriveStrings;
    {$ENDIF}
    for i := 1 to MainToolkit.Company.cmCount do
    begin
      CompCode := TCompanyCode.Create;
      CompCode.coCode := Trim(MainToolkit.Company.cmCompany[i].coCode);
      FCoList.AddObject(Trim(MainToolkit.Company.cmCompany[i].coPath), CompCode);
      DoLog('Added company to list: ' + FCoList[FCoList.Count - 1]);
    end;
    GlobalEntPath := GetEnterpriseDirectory;
    EntPath := GlobalEntPath;
    DoLog('Enterprise dir: ' + EntPath);
    GlobalIniFileName := GlobalEntPath + 'SentMail.ini';
    {$IFDEF VAO}
    with TElertWorkstationSetup.Create do
    Try
      LogDir := IncludeTrailingBackslash(VAOLogsDir);
      DoLog('LogDir: ' + LogDir);
      if not FileExists(LogDir) then
        CreateDir(LogDir);
    Finally
      GlobalIniFileName := LogDir + 'SentMail.ini';
      Free;
    End;
    {$ELSE}
    LogDir := GlobalEntPath + 'LOGS\';
    {$ENDIF}
  end;
end;

procedure TfrmEngine.ResetCrashedSentinels(const DataPath: string);
var
  Res, Res1, BFunc : Integer;
  KeyS : Str255;

  //PR 15/08/2008 Added to work around SQL Emulator locking fault
  function SafeRecordLock : Integer;
  begin
    Result := Find_Rec(22, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);

    if Result = 0 then
      Result := Find_Rec(B_GetDirect + B_SingNWLock, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);
  end;

begin
  Res := Open_File(F[ElertF], DataPath + FileNames[ElertF], 0);
  Res1 := Open_File(F[LineF], DataPath + FileNames[LineF], 0);
  BFunc := B_StepFirst;
  while (Res in  [0, 84, 85]) do
  begin
    Res := Find_Rec(BFunc, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);
    if Res = 0 then
      Res := SafeRecordLock;

    if Res = 0 then
    begin
      if (TElertStatus(ElertRec.elStatus) in RunningSet) then
      begin
        if Trim(ElertRec.elWorkStation) = WorkstationName then
        begin
          PurgeOutputs(ElertRec.elUserID, ElertRec.elElertName);
          ElertRec.elStatus := Ord(esIdle);
          ElertRec.elWorkstation := BlankWorkStation;
          Put_Rec(F[ElertF], ElertF,RecPtr[ElertF]^, elIdxElertName);
        end;
      end;
    end
    else  //if can't lock then position on rec so that we can move on to next rec
    if Res in [84, 85] then
      Res := Find_Rec(BFunc, F[ElertF],LineF,RecPtr[ElertF]^, ellIdxElert, KeyS);

    BFunc := B_StepNext;
  end; //while
  Close_File(F[LineF]);
  Close_File(F[ElertF]);

end;

procedure TfrmEngine.PurgeOutputs(const UID, EN: string);
var
  Res, BFunc : Integer;
  KeyS : Str255;
begin
  FillChar(KeyS, SizeOf(KeyS), #0);
  KeyS := pxElOutput + LJVar(UID, 10) + LJVar(EN, 30);
  Res := Find_Rec(B_GetGEq, F[LineF],LineF,RecPtr[LineF]^, ellIdxLineType, KeyS);
  while (Res = 0) and (LineRec.Output.eoUserID = UID) and
                      (LineRec.Output.eoElertName = EN) and
                      (LineRec.Prefix = pxElOutput) do
  begin
    if LineRec.Output.eoOutputType in Outputs2Go then
      Res := Delete_Rec(F[LineF],LineF, ellIdxLineType);

    if Res = 0 then
       Res := Find_Rec(B_GetNext, F[LineF],LineF,RecPtr[LineF]^, ellIdxLineType, KeyS);
  end;
end;

procedure TfrmEngine.ResetAllCrashedSentinels;
var
  i : integer;
begin
  for i := 0 to FCoList.Count -1 do
      ResetCrashedSentinels(Trim(FCoList[i]));
end;

procedure TfrmEngine.Workstation1Click(Sender: TObject);
begin
  with TfrmWorkstationSetup.Create(Application) do
  Try
    IniDir := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)));
    ReadIniFile;
    SMSSender := FSMSSender;
    ShowModal;
    SMSSender := UnAssigned;
  Finally
    FAgentList.Refresh;
    Free;
  End;
end;

procedure TfrmEngine.DoLog(const s: string);
begin
  {$IFDEF Service}
  if DebugModeOn then
  begin
    if FileExists(ExtractFilePath(Application.ExeName) + 'SentServdebug.txt') then
      Append(FLogF)
    else
      Rewrite(FLogF);
    Try
      WriteLn(FLogF, FormatDateTime('hh:nn:ss:zzz', Time) + '>' + s);
    Finally
      CloseFile(FLogF);
    End;
  end;
  {$ENDIF}
end;

procedure TfrmEngine.ClearFlagFiles;
var
  Res  : Integer;
  SRec : TSearchRec;
  FTime : TDateTime;
begin
  //Find all .flg files in the logs folder. If any is more than 10 seconds old then delete it.
  Res := FindFirst(LogDir + '*.flg', faAnyFile, SRec);
  Try
    while Res = 0 do
    begin
      FTime := FileDateToDateTime(SRec.Time);
      if Abs(SecondsBetween(FTime, Now)) > 10 then
        DeleteFile(LogDir + SRec.Name);

      Res := FindNext(SRec);
    end;
  Finally
    FindClose(SRec);
  End;
end;

procedure TfrmEngine.DisplayHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
{  if Assigned(HintInfo.HintControl) then
    StatBar.Panels[0].Text := GetLongHint(HintInfo.HintControl.Hint);}
end;

function TfrmEngine.NewSentinel(Ename, UserID: ShortString;
  DataPath: AnsiString; APurpose: TSentinelPurpose; APriority: Byte;
  ARep: ShortString; NewRep: Boolean) : Boolean;
var
  sCoCode : string;
  sUser : string;
begin
  if APurpose = spEmailCheck then
  begin
    sCoCode := 'n/a';
    sUser := 'SYSTEM';
  end
  else
  begin
    sCoCode := GetCompanyCode(DataPath);
    sUser := UserID;
  end;
  Result := FAgentList.Add(Datapath, EName, sUser, APurpose, ARep, sCoCode);
end;

procedure TfrmEngine.WMShutDown(var Msg: TMessage);
begin
  Screen.Cursor := crHourglass;
  Timer1.Enabled := False;
  if Running then
    btnRunClick(Self);
  Stop;
  if Assigned(FSentinel) then
    FSentinel.Abort := True;
  //PollThread.Terminate;
  ClearFlags;
//  SleepEx(2000, True);
  Screen.Cursor := crDefault;
  Close;
end;

procedure TfrmEngine.WMStartPolling(var Msg: TMessage);
begin
  {$IFDEF SERVICE}
   {$IFNDEF VAO}
   if not CheckLicenceOK then
   begin
     if Assigned(FServiceCallBack) then
       FServiceCallBack(1, 'Sentimail is not licenced. Closing down.');
   end
   else
{   if not Assigned(MainToolkit) then
   begin
     if Assigned(FServiceCallBack) then
       FServiceCallBack(1, 'Unable to create COM Toolkit. Closing down.');
   end
   else}
   {$ENDIF}
   begin
  {$ENDIF}
  FirstTime := True;
  btnRunClick(Self);
  FirstTime := False;
  {$IFDEF SERVICE}
  end;
  {$ENDIF}
end;

procedure TfrmEngine.FormDestroy(Sender: TObject);
begin
  Try
    DoLog('Shutting down');
    MainToolkit := nil;
    if Assigned(FAgentList) then
      FAgentList.Free;
    if Assigned(FSentinel) then
      FSentinel.Free;
  Finally
    SetWantToClose;
  End;

end;

procedure TfrmEngine.SentProgress(PollProgress: TPollProgressRec);
begin
  {$IFNDEF SERVICE}
  FAgentList.ShowProgress(lvStatus);
  with PollProgress do
    if Offline then
      StatBar.Panels[0].Text := 'Offline'
    else
      StatBar.Panels[0].Text := 'Polling ' + DataPath + ' - Checking Sentinel ' +
                               QuotedStr(Trim(EName));
  Application.ProcessMessages;
  {$ENDIF}
end;

procedure TfrmEngine.About1Click(Sender: TObject);
begin
  with TfrmAbout.Create(nil) do
  Try
    //PR: 08/07/2013 ABSEXCH-14438 Rebranding
    lblTitle.Caption := 'Exchequer Sentimail';
    lblVersion.Caption := 'Version: ' + ElVersion;
    ShowModal;
  Finally
    Free;
  end;
end;

procedure TfrmEngine.HelpContents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TfrmEngine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TfrmEngine.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if FAgentList.Count > 0 then
  begin
    FAgentList.CheckForFinishedAgents;
    FAgentList.ShowProgress(lvStatus);
    Timer1.Enabled := True;
  end;
end;

function TfrmEngine.GetCompanyCode(const Apath: string): string;
var
  i : integer;
begin
  i := FCoList.IndexOf(APath);
  if i > -1 then
    with FCoList.Objects[i] as TCompanyCode do
      Result := coCode
  else
    Result := '';
end;

procedure TfrmEngine.DeleteLogFiles(const aPath : string);
var
  Res  : Integer;
  SRec : TSearchRec;
  FTime : TDateTime;
  LogDir : string;
begin
  //Called at startup
  //Find all .log files in the logs folder. If any have the same WorkstationId then delete it, since it must be left
  //from a previous run.
  LogDir := aPath + 'Logs\';
  Res := FindFirst(LogDir + '*.log', faAnyFile, SRec);
  Try
    while Res = 0 do
    begin
      if Pos(WorkStationName, SRec.Name) = 1 then
          DeleteFile(LogDir + SRec.Name);

      Res := FindNext(SRec);
    end;
  Finally
    FindClose(SRec);
  End;
end;

procedure TfrmEngine.DeleteAllOldLogFiles;
var
  i : integer;
begin
  for i := 0 to FCoList.Count -1 do
      DeleteLogFiles(Trim(FCoList[i]));
end;

procedure TfrmEngine.ResetOneCrashedSentinel(const ADataPath, AUser,
  AName: string);
var
  Res, Res1, BFunc : Integer;
  KeyS : Str255;

  //PR 15/08/2008 Added to work around SQL Emulator locking fault
  function SafeRecordLock : Integer;
  begin
    Result := Find_Rec(22, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);

    if Result = 0 then
      Result := Find_Rec(B_GetDirect + B_SingNWLock, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);
  end;

begin
  Res := Open_File(F[ElertF], ADataPath + FileNames[ElertF], 0);
  Res1 := Open_File(F[LineF], ADataPath + FileNames[LineF], 0);

  KeyS := MakeElertNameKey(AUser, AName);

  Res := Find_Rec(B_GetEq, F[ElertF],ElertF,RecPtr[ElertF]^, elIdxElertName, KeyS);

  if Res = 0 then
    Res := SafeRecordLock;

  if Res = 0 then
  begin
    if (TElertStatus(ElertRec.elStatus) in RunningSet) then
    begin
      if Trim(ElertRec.elWorkStation) = WorkstationName then
      begin
        PurgeOutputs(ElertRec.elUserID, ElertRec.elElertName);
        ElertRec.elStatus := Ord(esIdle);
        ElertRec.elWorkstation := BlankWorkStation;
        Put_Rec(F[ElertF], ElertF,RecPtr[ElertF]^, elIdxElertName);
      end;
    end;
  end; //while
  Close_File(F[LineF]);
  Close_File(F[ElertF]);
end;

procedure TfrmEngine.AddToPollLog(const s: string);
begin
  if Assigned(FSentinel) then
    FSentinel.DebugMessage(s, 0, True);
end;

procedure TfrmEngine.WMSysCommand(var Message: TMessage);
begin
//Intercept close commands from form and just hide it
   if (Message.wParam = SC_CLOSE) then
     Hide
   else
     Inherited;
end;

procedure TfrmEngine.SetServiceDriveStrings;
var
  s, NetPath : string;
  i, j, Res : integer;
begin
  LocalPath := UpperCase(WinGetShortPathName(ExtractFilePath(ParamStr(0))));
  DoLog('LocalPath: ' + LocalPath);
  with MainToolkit.Company do
  begin
    for i := 1 to cmCount do
    begin
      s := UpperCase(Trim(cmCompany[i].coPath));
      FMappedDrive := Copy(s, 1, 3);
      ServiceMappedDrive := FMappedDrive;
      DoLog('FMappedDrive: ' + FMappedDrive);
      s := Copy(s, 4, Length(s));
      j := Pos(s, LocalPath);
      if j > 0 then
      begin
        FLocalPath := IncludeTrailingBackslash(Copy(LocalPath, 1, j - 1));
        ServiceLocalDir := FLocalPath;
        DoLog('FLocalPath: ' + FLocalPath);
        Break;
      end;

    end;
  end;
  NetPath := FLocalPath;
  //PR: 16/08/2011 Leave drive letter and use full local path to find correct share name.
//  Delete(NetPath, 1, 2); //Remove drive letter + ':'
  if NetPath[Length(NetPath)] = '\' then
    Delete(NetPath, Length(NetPath), 1);
  NetPath := '\\' + WinGetComputerName + '\' + GetShareNameFromPath(NetPath);

  Res := ConnectNetworkDrive(FMappedDrive, NetPath);
  if not (Res in [NO_ERROR, ERROR_ALREADY_ASSIGNED]) then
  begin
    DoLog('Error: ConnectDrive returned  ' + IntToStr(Res));
    Application.Terminate;
  end;

end;

procedure TfrmEngine.SetMenuItems(Running: Boolean);
begin
{$IFNDEF SERVICE}
  Start1.Enabled := Running;
  btnRun.Enabled := Running;

  Workstation1.Enabled := not Running;
  btnWorkStation.Enabled := not Running;

  frmElertTray.Paused1.Enabled := Running;
{$ENDIF}
end;

Initialization
  DriveMapped := False;
end.
