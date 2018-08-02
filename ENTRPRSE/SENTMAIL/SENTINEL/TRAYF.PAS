unit Trayf;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Menus, ExtCtrls, ShellAPI;

const
  wm_IconMessage = wm_User;
  wm_IconClose   = wm_User+1;
  wm_StopPolling = wm_User+2;
  wm_StartPolling = wm_User+3;

type
  elTrayIconType = (icPolling, icPaused, icError);

  TfrmElertTray = class(TForm)
    imgRunning: TImage;
    mnuPopUp: TPopupMenu;
    Paused1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    N2: TMenuItem;
    mniClose: TMenuItem;
    ImageList1: TImageList;
    imgPaused: TImage;
    Show1: TMenuItem;
    imgError: TImage;
    procedure mniCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure Paused1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    bPopup : Boolean;
    nid : TNotifyIconData;
    bOKToShowMenu : boolean;
    FirstTime : Boolean;
    procedure NewWndProc(var Message : TMessage);
  public
    { Public declarations }
    Closing : Boolean;
    procedure SetTrayIcon(State : elTrayIconType);
    procedure IconTray(var Msg : TMessage); message wm_IconMessage;
    procedure IconClose(var Msg : TMessage); message wm_IconClose;
    procedure SetPause(SetToPause : Boolean);
    procedure ReshowIcon;

  end;

var
  frmElertTray: TfrmElertTray;

implementation

{$R *.DFM}
uses
  SdiMainf, ElVar, About, CloseF;

var
  wm_RestartSystemTray : UINT;  //Message Id for 'TaskbarCreated'

procedure TfrmElertTray.IconTray(var Msg : TMessage);
{This dictates what happens when a mouse event happens on the tray icon}
var
  Pt : TPoint;
begin
  if bOKToShowMenu then begin
    case Msg.lParam of
      {Right Button Click}
      WM_RBUTTONDOWN : begin
        SetForegroundWindow(Handle);
        GetCursorPos(Pt);
        mnuPopup.Popup(Pt.x, Pt.y);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;

      {Double Click Click}
      WM_LBUTTONDBLCLK : begin
        SetForegroundWindow(Handle);
        Show1Click(self);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;
    end;{case}
  end;{if}
end;

procedure TfrmElertTray.IconClose(var Msg : TMessage);
{This Will force a close upon start up}
begin
  mniCloseClick(Nil);
end;



procedure TfrmElertTray.mniCloseClick(Sender: TObject);
begin
  Closing := True;
  Close;
end;

procedure TfrmElertTray.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not Closing then
  begin
    Action := caNone;
    ShowWindow(Handle, sw_Hide);
  end
  else
  begin
    WindowProc := WndProc;
    SendMessage(frmEngine.Handle, WM_SHUTDOWN, 0, 0);
    Action := caFree;
    Closing := True;
    Application.ProcessMessages;
    nid.uFlags := 0;
    Shell_NotifyIcon(NIM_DELETE, @nid);
    Application.ProcessMessages;
    //Application.Terminate;
  end;

end;

procedure TfrmElertTray.SetTrayIcon(State : elTrayIconType);
begin

    bOKToShowMenu := FALSE;
    Closing := false;
    with nid do begin
      cbSize := sizeof(nid);
      wnd := Handle;
      uID := 1;
      uCallBackMessage := wm_IconMessage;

      //PR: 08/07/2013 ABSEXCH-14438 Rebranding
      if State = icPaused then
      begin
        hIcon := imgPaused.Picture.Icon.Handle;
        szTip := 'Exchequer Sentimail - Paused';
      end
      else
      if State = icError then
      begin
        hIcon := imgError.Picture.Icon.Handle;
        szTip := 'Error - Exchequer Sentimail';
      end
      else
      begin
        hIcon := imgRunning.Picture.Icon.Handle;
        szTip := 'Exchequer Sentimail';
      end;
      uFlags := nif_Message or nif_Icon or nif_Tip;
    end;{with}
    if FirstTime then
    begin
      Shell_NotifyIcon(NIM_ADD, @nid);
      FirstTime := False;
    end
    else
      Shell_NotifyIcon(NIM_MODIFY, @nid);
    bOkToShowMenu := True;
end;


procedure TfrmElertTray.FormCreate(Sender: TObject);
begin
  FirstTime := True;
  SetTrayIcon(icPolling);

  //If explorer crashes and restarts then we we need to put the icon back into
  //the system tray. The 'TaskbarCreated' message is sent to all top-level windows
  //when this happens, so register it and replace the current windowproc with
  //one that handles it.
  wm_RestartSystemTray := RegisterWindowMessage(PChar('TaskbarCreated'));
  WindowProc := NewWndProc;
end;

procedure TfrmElertTray.Show1Click(Sender: TObject);
begin
//  Application.MainForm.Show;
  frmEngine.Show;
  ShowWindow(Application.Handle, SW_SHOW);
end;

procedure TfrmElertTray.Paused1Click(Sender: TObject);
begin
  frmEngine.btnRunClick(Self);
end;

procedure TfrmElertTray.SetPause(SetToPause : Boolean);
begin
{  Paused1.Checked := not Paused1.Checked;}
  if SetToPause then
    begin
      Paused1.Caption := '&Resume Sentimail';
      Paused1.ImageIndex := 5;
      SetTrayIcon(icPaused);
    end
  else begin
    Paused1.Caption := '&Pause Sentimail';
    Paused1.ImageIndex := 4;
    SetTrayIcon(icPolling);
  end;{if}
end;


procedure TfrmElertTray.About1Click(Sender: TObject);
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


//New window proc to check for explorer restarting after a crash.
procedure TfrmElertTray.NewWndProc(var Message : TMessage);
begin
  if Message.Msg = wm_RestartSystemTray then
    ReshowIcon
  else
    WndProc(Message);
end;

procedure TfrmElertTray.ReshowIcon;
begin
//Add the tray icon to the system tray again when explorer restarts after a crash
  FirstTime := True;
  if Paused1.ImageIndex = 4 then
    SetTrayIcon(icPolling)
  else
    SetTrayIcon(icPaused);
end;

end.
