unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ToolWin, ImgList, StdCtrls, Gauges, ExtCtrls,
  LoginF, PasswordComplexityConst, AppEvnts, ECBUtil, TJobQueueClass, AdvToolBar, 
  AdvToolBarStylers, AdvGlowButton;

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    FileCompList: TMenuItem;
    FileCompSepBar: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    XXXEdit1: TMenuItem;
    XXXCutItem: TMenuItem;
    XXXCopyItem: TMenuItem;
    XXXPasteItem: TMenuItem;
    mnuImportJobs: TMenuItem;
    Records1: TMenuItem;
    Window1: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    Help1: TMenuItem;
    XXXSDebug: TMenuItem;
    XXXdbClear1: TMenuItem;
    XXXRPos: TMenuItem;
    HBG1: TMenuItem;
    XXXDisHKey1: TMenuItem;
    XXXSPAccess1: TMenuItem;
    XXXAllocSRC1: TMenuItem;
    XXXAllocPPY1: TMenuItem;
    XXXAllocSRC2: TMenuItem;
    XXXAllocPPY2: TMenuItem;
    XXXUnalocate1: TMenuItem;
    XXXCISGen1: TMenuItem;
    XXXReCalcGLHed1: TMenuItem;
    XXXTranCradle1: TMenuItem;
    XXXResetbusylock1: TMenuItem;
    N2: TMenuItem;
    miHelpContents: TMenuItem;
    miSearchHelp: TMenuItem;
    HelpHowToUse: TMenuItem;
    What1: TMenuItem;
    N4: TMenuItem;
    Sess1: TMenuItem;
    mnuAbout: TMenuItem;
    StatusPanel: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Gauge1: TGauge;
    Panel3: TPanel;
    Gauge2: TGauge;
    Panel5: TPanel;
    StatusBar: TStatusBar;
    Timer1: TTimer;
    Logs1: TMenuItem;
    Options1: TMenuItem;
    mnuNewJobFile: TMenuItem;
    mnuOpenJobFile: TMenuItem;
    mnuFieldmaps: TMenuItem;
    NewFieldMap: TMenuItem;
    OpenFieldMap: TMenuItem;
    mnuFileOpenJobFile: TMenuItem;
    mnuFileOpenFieldMap: TMenuItem;
    ImportLog1: TMenuItem;
    ImportFile1: TMenuItem;
    OpenScheduler1: TMenuItem;
    JobQueue1: TMenuItem;
    mniFileNew: TMenuItem;
    mniFileNewImportJob: TMenuItem;
    mniFileNewFieldMap: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    imgBackground: TImage;
    Login1: TMenuItem;
    N3: TMenuItem;
    mniTestForm: TMenuItem;
    SpeedPanelv6: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    ilTBar24: TImageList;
    ilTBar16: TImageList;
    btnDefaultSettings: TAdvGlowButton;
    ExitBtn: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    btnOpenScheduler: TAdvGlowButton;
    OpenJobQueue: TAdvGlowButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    btnViewLogs: TAdvGlowButton;
    btnNewFieldMap: TAdvGlowButton;
    btnOpenFieldMap: TAdvGlowButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    btnNewJob: TAdvGlowButton;
    btnOpenJobFile: TAdvGlowButton;
    AdvStyler: TAdvToolBarOfficeStyler;
    procedure Exit1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuSettingsClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure mnuOpenJobFileClick(Sender: TObject);
    procedure NewFieldMapClick(Sender: TObject);
    procedure mnuNewJobFileClick(Sender: TObject);
    procedure OpenFieldMapClick(Sender: TObject);
    procedure OpenScheduler1Click(Sender: TObject);
    procedure JobQueue1Click(Sender: TObject);
    procedure mniFileNewImportJobClick(Sender: TObject);
    procedure mniFileNewFieldMapClick(Sender: TObject);
    procedure Logs1Click(Sender: TObject);
    procedure WMCOMPANYCHANGED(var msg: TMessage); message WM_COMPANYCHANGED;
    procedure btnNewJobFileClick(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);
    procedure WindowTileItemClick(Sender: TObject);
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    procedure Login1Click(Sender: TObject);
    procedure WindowMinimizeItemClick(Sender: TObject);
    procedure btnOpenJobFileClick(Sender: TObject);
    procedure btnOpenFieldMapClick(Sender: TObject);
    procedure btnOpenSchedulerClick(Sender: TObject);
    procedure btnOpenJobQueueClick(Sender: TObject);
    procedure btnDefaultSettingsClick(Sender: TObject);
    procedure btnViewLogsClick(Sender: TObject);
    procedure btnNewFieldMapClick(Sender: TObject);
    procedure miHelpContentsClick(Sender: TObject);
    procedure miSearchHelpClick(Sender: TObject);
    procedure btnWhatsThisClick(Sender: TObject);
    procedure What1Click(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure HelpHowToUseClick(Sender: TObject);
    procedure MainTSBtnClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
{* Internal Fields *}
    FCID: integer;
    FSpeedPanelHeight: integer;
{* Procedural Methods *}
    procedure ChangeCaption;
    procedure CloseMDIChildren;
    procedure FinishLog;
    procedure InitLog;
    procedure LoadBackground;
    procedure LoadToolbarIcons;
    procedure LogEntry(Entry: string);
    procedure Startup;
{* Message Handlers *}
    procedure WMImportJobProgress(var Msg: TMessage); message WM_IMPORTJOB_PROGRESS;
    procedure WMImportJobPhase1(var Msg: TMessage); message WM_IMPORTJOB_PHASE1;
    procedure WMImportJobPhase2(var Msg: TMessage); message WM_IMPORTJOB_PHASE2;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses FileViewer, IniMaint, DefaultSettings, Wizard, TIniClass,
     MapMaint, IniRecMaint, Utils, Scheduler, JobQueue,
     TLoggerClass, GlobalConsts, ViewLogFile, DateUtils, VAOUtil, GFXUtil, About,
     Brand, EntLicence, conHTMLHelp, AboutU;

{$R *.dfm}

{* Procedural Methods *}

procedure TfrmMain.ChangeCaption;
// caption is set to 'Xchequer' at design-time so that the EnumWindows in the
// project file can't find it during debugging.
begin
  if EnterpriseLicence.IsLITE then
    caption := 'IRIS Accounts Office Importer ' + APPVERSION + ' - [' + LoginCompany + ']'
  else
    caption := 'Exchequer Importer ' + APPVERSION + ' - [' + LoginCompany + ']';
  if InAdminMode then caption := caption + '^';
end;

procedure TfrmMain.CloseMDIChildren;
// explicity call the close methods otherwise the "Do you want to save your
// changes" messages don't show up if the user closes the app using the System
// Menu or the X coz then the MDIChildren get Destroy-ed not Close-d
var
  i: integer;
begin
  for i := 0 to MDIChildCount -1 do
   if MDIChildren[i] <> nil then
     MDIChildren[i].Close;
end;

procedure TfrmMain.FinishLog;
var
  Entry: string;
begin
  LogEntry('');
  Entry := Format('Importer: Finished at %s on %s', [TimeToStr(time), DateToStr(SysUtils.Date)]);
  LogEntry(Entry);
  FillChar(Entry[1], length(Entry), '=');
  LogEntry(Entry);
end;

procedure TfrmMain.InitLog;
var
  Entry: string;
begin
  LogEntry('');
  Entry := format('Importer: Started at %s on %s', [TimeToStr(time), DateToStr(SysUtils.Date)]);
  LogEntry(Entry);
  FillChar(Entry[1], length(Entry), '=');
  LogEntry(Entry);
end;

procedure TfrmMain.LoadBackground;
// Load background bitmap from ECB File
var
  BackBitmap  : TBitMap;
  RectD      : TRect;
  sECBFile : string;
begin
  BackBitmap := nil;
  try
    if EnterpriseLicence.IsLITE then
      sECBFile := GetECBFilename(waEnterprise, 1, Self, StatusPanel.Height + FSpeedPanelHeight)
    else
      sECBFile := GetECBFilename(waImporter, 1, Self, StatusPanel.Height + FSpeedPanelHeight);
    BackBitmap := GetBitmapFromECB(sECBFile);

    if (Assigned(BackBitmap)) then
    begin

      GetCentreOfBitmap(BackBitmap, Self, StatusPanel.Height + FSpeedPanelHeight);

      with BackBitmap do
      begin
        RectD:=Rect(0,0,Width,Height);
      end;

      with imgBackground.Picture.Bitmap do
      begin
        Width:=RectD.Right;
        Height:=RectD.Bottom;

        DeleteObject(imgBackground.Picture.BitMap.Palette);
        imgBackground.Picture.BitMap.Palette:=CopyPalette(BackBitmap.Palette);
        imgBackground.Picture.Bitmap.Canvas.CopyRect(RectD,BackBitmap.Canvas,RectD);
      end;

      imgBackground.Width  := ClientWidth;
      imgBackground.Height := BackBitmap.Height;
      imgBackground.Top    := 0;
      imgBackground.Left   := 0;

    end;
  finally
    if (Assigned(BackBitmap)) then BackBitmap.Free;
  end;
end;

procedure TfrmMain.LoadToolbarIcons;
begin
  {$IFNDEF IMPv6} // no menu icons as of v6 :(
  case ColorMode(self.Canvas) of
    cm256Colors, cm16Colors, cmMonochrome, cmUnknown: begin
      MainMenu.Images := ilTBar16;
      Toolbar.Images  := ilTBar16;
    end;
  else begin
//cm64Bit, cm32Bit, cm24Bit, cm16Bit,
    MainMenu.Images := ilTBar24;
    Toolbar.Images  := ilTBar24;
    end;
  end;
  {$ENDIF}
end;

procedure TfrmMain.LogEntry(Entry: string);
// the first call to TLogger.LogEntry will cause TLogger to determine the
// name of the main application log file and open it.
begin
  Logger.LogEntry(0, Entry);
end;

procedure TfrmMain.Startup;
// This supresses the default MDIForm scroll bars.
// We can then mimic hiding MDIChild forms (which you can't usually do)
// by positioning out of view.
// 14/12/2005: Leave MDI interface to operate as expected.
begin

//  if ClientHandle <> 0 then
//    if GetWindowLong( ClientHandle, GWL_USERDATA ) = 0 then // can only subclass client window if userdata not already in use
//      SetWindowLong( ClientHandle, GWL_USERDATA,
//                     SetWindowLong( ClientHandle, GWL_WNDPROC,
//                                   integer( @ClientWindowProc)));

//*** TEMPORARY
//  Gauge1.Progress := trunc(DayOfTheYear(now) / DayOfTheYear(StrToDateTime('25/12/2005')) * 100);
//  Gauge1.Hint     := 'Days ''til Xmas';
//  Gauge2.Progress := 10;
//  Gauge2.Hint     := 'Xmas presents bought';
//***
  {$IFDEF ADMIN}
  if StartInAdminMode then
    AdminSet(true);
  {$ENDIF}

  {$IFDEF IMPv6} // v.075
    SpeedPanelv6.Visible := true;
    FSpeedPanelHeight := SpeedPanelv6.Height;
  {$ELSE}
    SpeedPanelv5.Visible := true;
    FSpeedPanelHeight := SpeedPanelv5.Height;
  {$ENDIF}

  Gauge1.progress := PercentDiskFree(LoginPath);
  Gauge2.ShowText := false;

{* For Utils.WindowMoving - currently bypassed *}
  MainClientWidth  := ClientWidth;
  MainClientTop    := 86; // roughly the height of the title bar, menu bar and TCoolbar
  MainClientBottom := ClientHeight - StatusPanel.height + FSpeedPanelHeight + 6; // roughly

  if not (VAOInfo.vaoHideBitmaps or NoLogo) then
    LoadBackground;

  LoadToolbarIcons;

  InitLog;
  ChangeCaption;
  StatusBar.panels[0].Text := FormatDateTime('dd/mm/yyyy', SysUtils.Date);

  mniTestForm.Visible := DebugIt;

  ImportJobQueue.Poster.RegisterWindow(handle); // register to receive messages from the JobQueue.

  {$IFDEF IMPv6}
  Application.OnHelp := hhHelper.ApplicationHelp; // v.080 ensure that TApplicationEvents doesn't override the D6/D7 HTML Help fix
  {$ENDIF}
end;

{* Event Procedures *}

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  StatusBar.panels[1].Text := TimeToStr(now);
end;

Function ClientWindowProc( wnd: HWND; msg: Cardinal; wparam,
                           lparam: Integer ): Integer; stdcall;
// used to suppress MDIForm scroll bars. probably redundant now that each
// MDIChild form captures the WM_MOVING message - see Utils.WindowMoving
// 14/12/2005: MDIChild windows behaviour is left as standard.
Var
  f: Pointer;
Begin
  f:= Pointer( GetWindowLong( wnd, GWL_USERDATA ));
  Case msg of
    WM_NCCALCSIZE: Begin
        If ( GetWindowLong( wnd, GWL_STYLE ) and
             (WS_HSCROLL or WS_VSCROLL)) <> 0
        Then
          SetWindowLong( wnd, GWL_STYLE,
                         GetWindowLong( wnd, GWL_STYLE )
                         and not (WS_HSCROLL or WS_VSCROLL));
      End;
  End;
  Result := CallWindowProc( f, wnd, msg, wparam, lparam );
End;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Startup;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseMDIChildren;
  FinishLog;
  action := caFree;
end;

procedure TfrmMain.mnuSettingsClick(Sender: TObject);
begin
  TfrmIniMaint.Show('');
end;

procedure TfrmMain.Options1Click(Sender: TObject);
begin
  TfrmDefaultSettings.Show('');
end;


procedure TfrmMain.mnuOpenJobFileClick(Sender: TObject);
begin
  TfrmWizard.Show(true, '', false, 0);
end;

procedure TfrmMain.NewFieldMapClick(Sender: TObject);
begin
  TfrmMapMaint.Show('', '', false);
end;

procedure TfrmMain.mnuNewJobFileClick(Sender: TObject);
begin
  TfrmWizard.Show(false, '', false, 0);
end;

procedure TfrmMain.OpenFieldMapClick(Sender: TObject);
begin
  TfrmMapMaint.Show('', '', true);
end;

procedure TfrmMain.OpenScheduler1Click(Sender: TObject);
begin
  TfrmScheduler.Show('', true);
end;

procedure TfrmMain.JobQueue1Click(Sender: TObject);
begin
  TfrmJobQueue.Show;
end;

procedure TfrmMain.mniFileNewImportJobClick(Sender: TObject);
begin
  TfrmWizard.Show(false, '', false, 0);
end;

procedure TfrmMain.mniFileNewFieldMapClick(Sender: TObject);
begin
  TfrmMapMaint.Show('', '', false);
end;

procedure TfrmMain.Logs1Click(Sender: TObject);
begin
  TfrmViewLogFile.Show('');
end;

procedure TfrmMain.WMCOMPANYCHANGED(var msg: TMessage);
// received from TfrmLogin
begin
  ChangeCaption;
end;

procedure TfrmMain.btnNewJobFileClick(Sender: TObject);
begin
  TfrmWizard.Show(false, '', false, 0);
end;

procedure TfrmMain.ApplicationEventsHint(Sender: TObject);
begin
  StatusBar.Panels[2].Text := application.Hint;
end;

procedure TfrmMain.ExitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.FileExitItemClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.WindowTileItemClick(Sender: TObject);
begin
  Tile;
end;

procedure TfrmMain.WindowCascadeItemClick(Sender: TObject);
begin
  Cascade;
end;

procedure TfrmMain.WindowArrangeItemClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TfrmMain.Login1Click(Sender: TObject);
begin
  TfrmLogin.Show;
  LoginOK := true; // either they've changed companies successfully or they're
                   // still logged-in to the original one.
end;

procedure TfrmMain.WindowMinimizeItemClick(Sender: TObject);
var
  i: integer;
begin
   for i:= MDIChildCount - 1 downto 0 do
    MDIChildren[i].WindowState := wsMinimized;
end;

procedure TfrmMain.btnOpenJobFileClick(Sender: TObject);
begin
  TfrmWizard.Show(true, '', false, 0);
end;

procedure TfrmMain.btnOpenFieldMapClick(Sender: TObject);
begin
  TfrmMapMaint.Show('', '', true);
end;

procedure TfrmMain.btnOpenSchedulerClick(Sender: TObject);
begin
  TfrmScheduler.Show('', true);
end;

procedure TfrmMain.btnOpenJobQueueClick(Sender: TObject);
begin
  TfrmJobQueue.Show;
end;

procedure TfrmMain.btnDefaultSettingsClick(Sender: TObject);
begin
  TfrmDefaultSettings.Show('');
end;

procedure TfrmMain.btnViewLogsClick(Sender: TObject);
begin
  TfrmViewLogFile.Show('');
end;

procedure TfrmMain.btnNewFieldMapClick(Sender: TObject);
begin
  TfrmMapMaint.Show('', '', false);
end;

{* Message Handlers *}

procedure TfrmMain.WMImportJobProgress(var Msg: TMessage);
// WParam = Maximum
// LParam = Current Progress
// If both are zero, we stop the gauge from displaying 0%
begin
  Gauge2.MaxValue := Msg.WParam;
  Gauge2.Progress := Msg.LParam;
  Gauge2.ShowText := not ((Msg.WParam = 0) and (Msg.LParam = 0));
end;

procedure TfrmMain.WMImportJobPhase1(var Msg: TMessage);
begin
  Gauge2.ForeColor := clNavy;
end;

procedure TfrmMain.WMImportJobPhase2(var Msg: TMessage);
begin
  Gauge2.ForeColor := clBlue;
end;

procedure TfrmMain.miHelpContentsClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TfrmMain.miSearchHelpClick(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_KEY, 0);
end;

procedure TfrmMain.btnWhatsThisClick(Sender: TObject);
begin
  PostMessage(Self.Handle,WM_SysCommand,SC_CONTEXTHELP,0);
end;

procedure TfrmMain.What1Click(Sender: TObject);
begin
  PostMessage(Self.Handle,WM_SysCommand,SC_CONTEXTHELP,0);
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  with TAboutFrm.Create(nil) do
  try
    ShowModal;
  finally
    free;
  end;
end;

procedure TfrmMain.HelpHowToUseClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TfrmMain.MainTSBtnClick(Sender: TObject);
begin
//  with TForm1.create(nil) do begin
//    ShowModal;
//    free;
//  end;
end;

procedure TfrmMain.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  CallHelp: boolean;
begin
  if msg.CharCode = VK_F1 then
//    if GetKeyState(VK_CONTROL) <> 0 then
//      btnWhatsThisClick(nil)
//    else
   {$IFDEF IMPv6}
      hhHelper.ApplicationHelp(HELP_CONTEXT, HelpContext, CallHelp);
   {$ELSE}
      Application.HelpCommand(HELP_CONTEXT, HelpContext);
   {$ENDIF}

end;

end.
