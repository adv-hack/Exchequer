unit ServThred;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, SentU, Menus, ImgList, ComCtrls, ToolWin, About, jpeg,
  ElVar, {$IFDEF AQ}WorkSta2, StdCtrls{$ELSE}workStat{$ENDIF}, Flags;

const

  WM_StartPolling = WM_APP + 2001;

type
  TAppExcept = class
    procedure CardException(Sender: TObject; E: Exception);
  end;

  TfrmThreadMaster = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Setup1: TMenuItem;
    Workstation1: TMenuItem;
    ToolBar1: TToolBar;
    Help1: TMenuItem;
    ToolButton1: TToolButton;
    ImageList1: TImageList;
    ToolButton2: TToolButton;
    BackGroundImage: TImage;
    Polling1: TMenuItem;
    Start1: TMenuItem;
    HideBackground1: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    About1: TMenuItem;
    N1: TMenuItem;
    StatBar: TStatusBar;
    Diagnostics1: TMenuItem;
    HelpContents1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Workstation1Click(Sender: TObject);
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
    procedure Diagnostics1Click(Sender: TObject);
    procedure HelpContents1Click(Sender: TObject);
  private
    { Private declarations }
    FSentinel : TSentinelPoller;
    Abort : Boolean;
    MDIDefProc:pointer;
    MDIInstance:TFarProc;
    FirstTime, FirstActivate : Boolean;
    AmClosing : Boolean;
    FlagsInUse : Boolean;
    FCoList : TStringList;
    EntPath, ToolkitVersion : string;
    MapiOk : Boolean;
    procedure MDIWndProc(var prmMsg:TMessage);
    procedure CreateWnd;override;
    procedure ShowBitmap(prmDC:hDC);

    procedure NewSentinel(Ename, UserID : ShortString;
                          DataPath : AnsiString; APurpose : TSentinelPurpose;
                          APriority : Byte; ARep : ShortString = ''; NewRep : Boolean = False);
    procedure SentProgress;
    function CheckPath(const DataPath : AnsiString) : Boolean;
    procedure DisplayHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure HideMe;
    procedure NotifyError(Sender : TObject; WhichType : TElertTransmissionType);
    procedure NotifyErrorSync;
    procedure WMSetFocus(var Msg : TMessage); message WM_SetFocus;
    function InBackupWindow : Boolean;
    function WantSetFlag(SetOn : Boolean; Flags : Word; Ws : TElertWorkstationSetup) : Boolean;
    procedure ResetFlags(DataPath : AnsiString);
    procedure ClearFlags;
    procedure StartFlags;
    procedure InitGlobalVars;
    procedure ResetCrashedSentinels(const DataPath : string);
    procedure ResetAllCrashedSentinels;
    procedure PurgeOutputs(const UID, EN : string);
    function CloseFormPos : integer;
    procedure ClearFlagFiles;
  public
    { Public declarations }
    CurrentData : SmallInt;
    Running : Boolean;
    procedure Run(DataPath : AnsiString);
    procedure Start;
    procedure Stop;

   { procedure WMStopPolling(var Msg : TMessage); message WM_StopPolling}
    procedure WMStartPolling(var Msg : TMessage); message WM_StartPolling;
    procedure StartPolling;
  end;


var
  frmThreadMaster: TfrmThreadMaster;




implementation


{$R *.DFM}
uses
  ElThred, ComObj, Enterprise04_TLB, VarConst,
  CommsInt, ExThrd2U, TrayF, SecCodes, Logform, DiagF, notifyf, GlobIni, DebugLog,
  Pform, SBS_Int, Variants, GlobVar, SentLic, Btrvu2, APIUtil, CloseF, FileUtil, RegUtil
  {$IFDEF DBF}, DbfInt{$ENDIF}, BtSupU2, BtSupU1, UDebug,
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  VAOUtil;

const
  ChkString = ' checking sentinels';

var
  AppExcept : TAppExcept;


function TfrmThreadMaster.CheckPath(const DataPath : AnsiString) : Boolean;
var
  s : AnsiString;
begin
  s := IncludeTrailingBackSlash(DataPath) + ElPath;
{$IFDEF EXSQL}
  Result := TableExists(s + 'SENT.DAT') and TableExists(s + 'SENTLINE.DAT');
{$ELSE}
  Result := FileExists(s + 'SENT.DAT') and FileExists(s + 'SENTLINE.DAT');
{$ENDIF}
end;

procedure TfrmThreadMaster.Run(DataPath : AnsiString);
begin
  if FlagsInUse then
    ResetFlags(EntPath);
  DataPath := Trim(DataPath);
//  ShowWindow(Application.Handle, SW_HIDE);
//  ShowMessage('[Run]: DataPath = ' + DataPath);
  if CheckPath(DataPath) then
  begin
//    FSentinel := TSentinelPoller.Create;
    Try
      FSentinel.OnSentinelFound := NewSentinel;
      FSentinel.OwningThread := PollThread;
//      FSentinel.OnProgress := SentProgress;
//      FSentinel.OnTooManyRetries := NotifyError;
      if InBackupWindow then
      begin
//        ShowMessage('In backup window');
        if FlagsInUse then
          ClearFlags;
        FSentinel.ShowProgress('','',spPoller,True);
        SleepEx(60000, True);
      end
      else
      begin
        if not FlagsInUse then
        begin
          FlagsInUse := True;
          StartFlags;
        end;
        FSentinel.Poll(DataPath);
      end;
    Finally
//      FSentinel.Free;
    End;
  end;
end;

procedure TfrmThreadMaster.NewSentinel(Ename, UserID : ShortString;
                                       DataPath : AnsiString; APurpose : TSentinelPurpose;
                                       APriority : Byte; ARep : ShortString = ''; NewRep : Boolean = False);
begin
  if TSentinelPurpose(APurpose) in [spQuery, spConveyor, spReportConveyor, spReportQuery,
                                    spCSVConveyor, spEmailCheck, spVisualReportConveyor] then
    AddELT2Q(Self, EName, UserID, DataPath, APurpose, APriority)
  else
  begin
    if NewRep then
      AddNewReportToQueue(EName, UserID, ARep, DataPath)
    else
      AddReportToQueue(EName, UserID, ARep, DataPath);
//    LogIt(spReport, 'Added ' + Trim(EName) + ' to queue');
  end;
end;


procedure TfrmThreadMaster.FormCreate(Sender: TObject);
var
  a, b, c : longint;
  Res : Word;
  Stat : longint;
begin
  Init_STDCurrList; //In btsupu2.pas
  if ParamCount > 0 then
    DebugModeOn := UpperCase(ParamStr(1))[2] = 'D'
  else
    DebugModeOn := False;

  DebugModeOn := True;
  WorkStationName := WinGetComputerName;
  HideBackGround1.Checked := NoXLogo;

  MapiOK := ECMAPIAVAILABLE; //need this call for static linking of entcomms.dll
  FirstActivate := True;
  AmClosing := True;
  PollThread := nil;
  DefineFiles('');
  frmPrint := TfrmPrint.Create(Application);
  Close_files(True);//close global files
  Abort := False;
  Running := False;
  Try
    FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  Except
    ShowMessage('Unable to create COM Toolkit. Application will terminate');
    Application.Terminate;
  End;
  //licence tk thru bakdoor here
{  if (FToolkit.Version >= 'TKCOM-v4.32.035') or
     (Copy(FToolkit.Version, 1, 9) = 'TKCOM-500') or
     ((FToolkit.Version[7] = 'b') and (FToolkit.Version >= 'TKCOM-b500.100')) then}

  Try
    CreateDBFComObject;
  Except
    MessageDlg('A required component (Dbfwrite.dll) is not registered correctly on this workstation.'#10#10 +
               'Please close down your Exchequer system and run WorkStation Setup'#10 +
               'which can be found in the Wstation sub-folder of your Exchequer directory.' +
               #10#10 + 'If you are unsure of how to run Workstation Setup, ' +
               'please contact'#10'your Technical Support.',
               mtError, [mbOK], 0);
  End;

  begin
    FCoList := TStringList.Create;
    InitGlobalVars;
    EncodeOpCode(97, a, b, c);
    FToolkit.Configuration.SetDebugMode(a, b, c);
    with FToolkit do
    begin
      Stat := OpenToolkit;
      if Stat = 0 then
      begin
        ReportsAvailable := SystemSetup.ssReleaseCodes.rcReportWriter <> rcDisabled;
        with SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes2 do
          VisualReportsAvailable := rcVisualReportWriter <> rcDisabled;
        CloseToolkit;
      end
      else
        ShowMessage('Unable to open Com toolkit. Error: ' + IntToStr(Stat) +
                #10#10 + QuotedStr(LastErrorString));
    end;
//    FToolkit.Configuration.SetDebugMode(a, b, c);

    //Check for crashed sentinels
    ResetAllCrashedSentinels;
    //PR: 18/02/2010

    if VAOInfo.vaoMode <> smVAO then
    with TElertWorkStationSetup.Create do
    Try
      if SMSAvailable then
      begin
      //Check if we have an old sms sender registered - if so, register the new one
{        if UpperCase(GetCOMObjectDir('EnterpriseSMS.SMSSender')) <>
             UpperCase(ExtractFilePath(Application.ExeName)) then
                RegisterComServer(ExtractFilePath(Application.ExeName) + 'entsms.dll');}

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
            ShowMessage('SMS Sender registered');
            FSMSSender := CreateOLEObject('EnterpriseSMS.SMSSender');
          end;
          {$ENDIF}
          IgnoreSMS := True;
        end;
      end;
    Finally
      Free;
    End;
    CurrentData := 0;
    SentinelsSoFar := 0;
    EntEmail := TEntEmail.Create;
    EntEmail.SuppressMessages := True;
  end;
{  else
  begin
    ShowMessage('Invalid COM Toolkit version');
    Halt(0);
  end;}

  CheckLicenceOK;

  Application.OnShowHint := DisplayHint;
  Application.HintPause := 100;
  ProgressProc := SentProgress;

  FSentinel := TSentinelPoller.Create;
  FSentinel.OnSentinelFound := NewSentinel;
 // FSentinel.OnProgress := SentProgress;
  if DebugModeOn then
    if Assigned(FSentinel) then
      FSentinel.DebugMessage('About to start polling');

  PostMessage(Self.Handle, WM_StartPolling, 0, 0);


end;

procedure TfrmThreadMaster.Workstation1Click(Sender: TObject);
begin
  with TfrmWorkstationSetup.Create(nil) do
  Try
    IniDir := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)));
    ReadIniFile;
    SMSSender := FSMSSender;
    ShowModal;
    SMSSender := UnAssigned;
  Finally
    Free;
  End;
end;

procedure TfrmThreadMaster.ToolButton2Click(Sender: TObject);
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
      Start1.Caption := '&Resume Sentimail';
      Start1.ImageIndex := 5;
      ToolButton2.ImageIndex := 0;
      ToolButton2.Hint := 'Start' + ChkString;
      if Assigned(FSentinel) then
      begin
        FSentinel.Abort := True;
        FSentinel.DebugMessage('Sentimail engine paused');
      end;
      Application.ProcessMessages;
      Stop;
      PollThread.Terminate;
      ClearFlags;
     //
    end
    else
    begin
//      Reset_B;
      Start1.Caption := '&Pause Sentimail';
      Start1.ImageIndex := 4;
      ToolButton2.ImageIndex := 1;
      ToolButton2.Hint := 'Stop' + ChkString;
      Application.ProcessMessages;
      PollProc := Start;
  //    for i := 1 to FToolkit.Company.cmCount do
  //        ResetFlags(EntPath);

      Running := True;
      Abort := False;
      if Assigned(FSentinel) then
        FSentinel.DebugMessage('Sentimail engine started');

      with TElertWorkStationSetup.Create do
      Try
        WantDebug := AllowDebug;
      Finally
        Free;
      End;

      PollThread := TPollThread.Create;
      FSentinel.OnTooManyRetries := SyncErr;
      ErrorProc := NotifyErrorSync;

      ResetCloseFlags;
      StartFlags;
      Pollthread.Resume;
    end;
    if not FirstTime then
      frmElertTray.SetPause;
  end;
end;

procedure TfrmThreadMaster.FormDestroy(Sender: TObject);
begin
  STDCurrList.Free; //In btsupu2.pas
  if SBSOpened then
    DeInitSBS;
  FToolkit := nil;
  if Assigned(FSentinel) then
    FSentinel.Free;
  FSMSSender := Unassigned;
{  if Assigned(EntEmail) then
    EntEmail.Free;}
  if Assigned(SentimailFlags) then
    SentimailFlags.Free;
  if Assigned(FCoList) then
    FCoList.Free;
  Try
    if Assigned(PollThread) then
      PollThread.Terminate;
  Except
  End;
end;

procedure TfrmThreadMaster.Start;
begin
  SentinelsSoFar := 0;
  Abort := False;
  while not Abort and not PollThread.IsTerminated do
  begin
    Running := True;
{   Application.ProcessMessages;}
    if Not Abort then
    begin
{      ShowMessage('About to poll company ' + IntToStr(CurrentData) + ': '
                     + Trim(FToolkit.Company.cmCompany[CurrentData].coPath));}
      Run(FCoList[CurrentData]);
    end;
    Application.ProcessMessages;
    if Not Abort then
      inc(CurrentData);
    if CurrentData > Pred(FCoList.Count) then
    begin
      CurrentData := 0;
      SentinelsSoFar := 0;
    end;
{   Application.ProcessMessages;}
  end;
 StatBar.Panels[1].Text := 'Paused';
{  Application.ProcessMessages;}
end;

procedure TfrmThreadMaster.Stop;
begin
  Abort := True;
  Running := False;
end;

procedure TfrmThreadMaster.SentProgress;
var
  i, j : longint;
begin
  with PollProgress do
    if Offline then
      StatBar.Panels[1].Text := 'Offline'
    else
      StatBar.Panels[1].Text := 'Polling ' + DataPath + ' - Checking Sentinel ' +
                               QuotedStr(Trim(EName));
  Application.ProcessMessages;
end;


procedure TfrmThreadMaster.MDIWndProc(var prmMsg:TMessage);
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

procedure TfrmThreadMaster.CreateWnd;
begin
 inherited CreateWnd;
 MDIInstance:=MakeObjectInstance(MDIWndProc); { create wrapper }
 MDIDefProc:=pointer(SetWindowLong(ClientHandle,GWL_WNDPROC,
     longint(MDIInstance)) );
end;

procedure TfrmThreadMaster.ShowBitmap(prmDC:hDC);
(* var
  wrkSource:TRect;
  wrkTarget:TRect;
  wrkX:integer;
  wrkY:integer;
begin
 {tile bitmap }
   if FormStyle=fsNormal then
    begin
     wrkY:=0;
     while wrkY < ClientHeight do    { go from top to bottom.. }
      begin
       wrkX:=0;
       while wrkX < ClientWidth do   { ..and left to right. }
        begin
         Canvas.Draw(wrkX,wrkY,BackGroundImage.Picture.Bitmap);
         Inc(wrkX,BackGroundImage.Picture.Width);
        end;
       Inc(wrkY,BackGroundImage.Picture.Height);
      end;
    end
   else if FormStyle=fsMDIForm then
    begin
     Windows.GetClientRect(ClientHandle,wrkTarget);
     wrkY:=0;
     while wrkY < wrkTarget.Bottom do
      begin
       wrkX:=0;
       while wrkX < wrkTarget.Right do
        begin
         BitBlt(longint(prmDC),wrkX,wrkY,BackGroundImage.Picture.Width,BackGroundImage.Picture.Height,
                  BackGroundImage.Picture.bitmap.Canvas.Handle,0,0,SRCCOPY);
         Inc(wrkX,BackGroundImage.Picture.Width);
        end;
       Inc(wrkY,BackGroundImage.Picture.Height);
      end;
    end;
end;*)
Var
  MyDC       : hDC;
  Ro, Co     : Word;
  OldPalette : HPalette;


Begin

  MyDC := prmDC;

  OldPalette:=SelectPalette(MyDC,BackgroundImage.Picture.BitMap.Palette,False);
  try
    RealizePalette(MyDC);

    for Ro := 0 TO ClientHeight DIV BackgroundImage.Picture.Height DO
       for Co := 0 TO ClientWIDTH DIV BackgroundImage.Picture.Width DO
         BitBlt(MyDC, Co*BackgroundImage.Picture.Width, Ro*BackgroundImage.Picture.Height,
                BackgroundImage.Picture.Width, BackgroundImage.Picture.Height,
                BackgroundImage.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    SelectPalette(MyDC,OldPalette,true);
  end; {try..}

end;





procedure TfrmThreadMaster.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  T : Integer;
  TerminateNow : Boolean;
begin
  if ToolButton2.ImageIndex <> 0 then
    ToolButton2Click(Self);
  Application.ProcessMessages;
  Poller_WantToClose := True;
  Application.ProcessMessages;
  Show;
  Application.ProcessMessages;
  Sleep(100);
  Application.ProcessMessages;
  if not OKToClose then
  begin
    with TfrmCloseStatus.Create(Self) do
    Try
      T := CloseFormPos;
      if T + Height < Screen.Height then
        Top := T;
      Show;
      Application.ProcessMessages;
      Sleep(100);
      while not OKToClose do
      begin
        Application.ProcessMessages;
        SleepEx(1, True);
        SetActiveLabel(0, Poller_OkToClose);
        SetActiveLabel(1, GetQuery_OkToClose);
        SetActiveLabel(2, Conveyor_OkToClose);
        IncProgress;
        TerminateNow := DoTerminate;
        if DoTerminate then
          SetWantToClose;
        Application.ProcessMessages;
      end;
      Close;
    Finally
      Free;
    End;
  end;
  CanClose := True;
end;

{procedure WMStopPolling(var Msg : TMessage); message WM_StopPolling;
procedure WMStartPolling(var Msg : TMessage); message WM_StartPolling;}


procedure TfrmThreadMaster.Exit1Click(Sender: TObject);
begin
  HideMe;
end;

procedure TfrmThreadMaster.HideBackground1Click(Sender: TObject);
begin
  HideBackGround1.Checked := not HideBackGround1.Checked;
  InvalidateRect(0, nil, True);
  Application.ProcessMessages;
end;

procedure TfrmThreadMaster.About1Click(Sender: TObject);
begin
  oToolkit := FToolkit;
  with TfrmAbout.Create(nil) do
  Try

    lblTitle.Caption := 'Exchequer Sentimail';
    lblVersion.Caption := 'Version: ' + ElVersion;
    ShowModal;
  Finally
    Free;
    oToolkit := nil;
  end;
end;

procedure TfrmThreadMaster.DisplayHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if Assigned(HintInfo.HintControl) then
    StatBar.Panels[0].Text := GetLongHint(HintInfo.HintControl.Hint);
end;

procedure TfrmThreadMaster.FormResize(Sender: TObject);
begin
  StatBar.Panels[0].Width := StatBar.Width div 2;
end;


Procedure TfrmThreadMaster.WMSysCommand(Var Message  :  TMessage);
begin
//Intercept close commands from form and just hide it
   if (Message.wParam = SC_CLOSE) {or (Message.wParam = SC_MINIMIZE) }then
   begin
     HideMe;
   end
   else
     Inherited;
end;

procedure TfrmThreadMaster.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  WaitCount : integer;
begin
{   if Running then
     ToolButton2Click(Self); }
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

procedure TfrmThreadMaster.HideMe;
begin
   Hide;

end;

procedure TfrmThreadMaster.FormHide(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TfrmThreadMaster.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_SHOW);
end;


procedure TfrmThreadMaster.Diagnostics1Click(Sender: TObject);
var
  WasClosed : Boolean;
  i : integer;
begin
  with TfrmDiag.Create(Self) do
  Try
      memDiag.Lines.Add('COM Toolkit version: ' + ToolkitVersion);
      memDiag.Lines.Add('Exchequer directory: ' + EntPath);
      for i := 0 to FCoList.Count - 1 do
      begin
        memDiag.Lines.Add('Company ' + IntToStr(i + 1) + ': ' +
                      FCoList[i]);
{$IFDEF EXSQL}
        if TableExists(IncludeTrailingBackSlash(FCoList[i])
                               + ElPath + 'Sent.dat') then
{$ELSE}
        if FileExists(IncludeTrailingBackSlash(FCoList[i])
                               + ElPath + 'Sent.dat') then
{$ENDIF}
          memDiag.Lines.Add('Sent.dat found')
        else
          memDiag.Lines.Add('Sent.dat not found');

{$IFDEF EXSQL}
        if TableExists(IncludeTrailingBackSlash(FCoList[i])
                      + ElPath + 'Sentline.dat') then
{$ELSE}
        if FileExists(IncludeTrailingBackSlash(FCoList[i])
                      + ElPath + 'Sentline.dat') then
{$ENDIF}
          memDiag.Lines.Add('SentLine.dat found')
        else
          memDiag.Lines.Add('SentLine.dat not found');

      end;
    memDiag.Lines.Add(MemFreeString);
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TfrmThreadMaster.NotifyError(Sender : TObject; WhichType : TElertTransmissionType);
var
  s, s1, s2 : ShortString;
begin

  frmElertTray.SetTrayIcon(icError);
  Case WhichType of
    etrEmail : s := 'Email';
    etrSMS   : s := 'SMS';
    etrFTP   : s := 'FTP';
    etrFax   : s := 'Fax';
  end;


  if Sender is TSentinelPoller then
    with TSentinelPoller(Sender) do
    begin
      with TfrmNotify.Create(Self) do
      begin
        Width := 421;
        Height := 165;
        Label1.Caption := 'Error sending ' + s;
        Label2.Caption := 'User: ' + Trim(User);
        Label3.Caption := 'Sentinel: ' + Trim(ElertName);
        if WhichType = etrSMS then
          Label4.Caption := 'Error: ' + LastSMSError
        else
        if WhichType = etrFTP then
          Label4.Caption := 'Error: ' + LastFTPError
        else
          Label4.Caption := '';
        Show;
        SleepEx(600, True);
      end;

    end;
end;

procedure TfrmThreadMaster.WMSetFocus(var Msg : TMessage);
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



function TfrmThreadMaster.InBackupWindow : Boolean;
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

procedure TfrmThreadMaster.NotifyErrorSync;
begin
  NotifyError(ErrorSender, ErrorTransType);
end;

procedure TfrmThreadMaster.WMStartPolling(var Msg : TMessage);
begin
{  FirstTime := True;
  ToolButton2Click(Self);
  FirstTime := False;}
//  StartPolling;

end;

function TfrmThreadMaster.WantSetFlag(SetOn : Boolean; Flags : Word; Ws : TElertWorkstationSetup) : Boolean;
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

procedure TfrmThreadMaster.ReSetFlags(DataPath : AnsiString);
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

procedure TfrmThreadMaster.ClearFlags;
begin
  if Assigned(SentimailFlags) then
    SentimailFlags.Free;
  FlagsInUse := False;
  SentimailFlags := nil;
end;

procedure TfrmThreadMaster.StartFlags;
begin
  SentimailFlags := TSentimailFlags.Create(EntPath);
  FlagsInUse := True;
end;


procedure TfrmThreadMaster.InitGlobalVars;
var
  i : integer;
begin
  if Assigned(FToolkit) then
  begin
    ToolkitVersion := FToolkit.Version;
    for i := 1 to FToolkit.Company.cmCount do
      FCoList.Add(Trim(FToolkit.Company.cmCompany[i].coPath));
    GlobalEntPath := GetEnterpriseDirectory;
    EntPath := GlobalEntPath;
    GlobalIniFileName := GlobalEntPath + 'SentMail.ini';
    LogDir := GlobalEntPath + 'LOGS\';
  end;

end;

procedure TfrmThreadMaster.ResetCrashedSentinels(const DataPath : string);
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

procedure TfrmThreadMaster.PurgeOutputs(const UID, EN : string);
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


procedure TfrmThreadMaster.ResetAllCrashedSentinels;
var
  i : integer;
begin
  for i := 1 to FToolkit.Company.cmCount do
    ResetCrashedSentinels(Trim(FToolkit.Company.cmCompany[i].coPath));
end;

procedure TfrmThreadMaster.HelpContents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

function TfrmThreadMaster.CloseFormPos : integer;
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





procedure TAppExcept.CardException(Sender: TObject; E: Exception);
var
  MapFileAddress: DWORD;
  UnitName,
  ProcedureName,
  LineNumber: string;
begin
  MapFileAddress := GetMapAddressFromAddress(DWORD(ExceptAddr));
  UnitName := GetModuleNameFromAddress(MapFileAddress);
  ProcedureName := GetProcNameFromAddress(MapFileAddress);
  LineNumber := GetLineNumberFromAddress(MapFileAddress);

  MsgBox(E.Message + #13#13
  + 'File :            '#9 + UnitName + #13
  + 'Procedure : '#9 + ProcedureName + #13
  + 'Line No :      '#9 + LineNumber
  , mtError, [mbOk], mbOK, 'VECCARD.EXE Exception');

{  TechSuppLog('EXCEPTION : ' + E.Message);
  TechSuppLog('                          File : ' + UnitName + ', Procedure : ' + ProcedureName
  + ', Line No : ' + LineNumber);}
end;


procedure TfrmThreadMaster.StartPolling;
begin
  FirstTime := True;
  ToolButton2Click(Self);
  FirstTime := False;

end;

//Added in to delete any left over .flg files in the logs folder, as they can slow performance significantly.
procedure TfrmThreadMaster.ClearFlagFiles;
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

Initialization
{  LoadAndParseMapFile;
  AppExcept := TAppExcept.Create;
  Application.OnException := AppExcept.CardException;}

finalization
//  AppExcept.Free;




end.
