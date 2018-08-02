unit Trayf;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Menus, ExtCtrls, ShellAPI, SchedVar;

const
  wm_IconMessage = wm_User;
  wm_IconClose   = wm_User+1;
  wm_StopPolling = wm_User+2;
  wm_StartPolling = wm_User+3;

type
  elTrayIconType = (icPolling, icPaused, icError);

  TfrmSchedTray = class(TForm)
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    nid : TNotifyIconData;
    bOKToShowMenu : boolean;
    FirstTime : Boolean;
  public
    { Public declarations }
    Closing : Boolean;
    procedure SetTrayIcon(State : elTrayIconType);
    procedure IconTray(var Msg : TMessage); message wm_IconMessage;
    procedure IconClose(var Msg : TMessage); message wm_IconClose;
    procedure SetPause;

  end;

var
  frmSchedTray: TfrmSchedTray;

implementation

{$R *.DFM}
uses
  MainF, ElVar, About, CloseF;

procedure TfrmSchedTray.IconTray(var Msg : TMessage);
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

procedure TfrmSchedTray.IconClose(var Msg : TMessage);
{This Will force a close upon start up}
begin
  mniCloseClick(Nil);
end;



procedure TfrmSchedTray.mniCloseClick(Sender: TObject);
begin
  Closing := True;
  Close;
end;

procedure TfrmSchedTray.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not Closing then
  begin
    Action := caNone;
    ShowWindow(Handle, sw_Hide);
  end
  else
  begin
    Closing := True;
    Application.ProcessMessages;
    nid.uFlags := 0;
    Shell_NotifyIcon(NIM_DELETE, @nid);
    Application.ProcessMessages;
    //Application.Terminate;
    frmScheduler.Close;
  end;

end;

procedure TfrmSchedTray.SetTrayIcon(State : elTrayIconType);
begin

    bOKToShowMenu := FALSE;
    Closing := false;
    with nid do begin
      cbSize := sizeof(nid);
      wnd := Handle;
      uID := 1;
      uCallBackMessage := wm_IconMessage;


      if State = icPaused then
      begin
        hIcon := imgPaused.Picture.Icon.Handle;
        szTip := 'Exchequer Scheduler - Paused';
      end
      else
      begin
        hIcon := imgRunning.Picture.Icon.Handle;
        szTip := 'Exchequer Scheduler';
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


procedure TfrmSchedTray.FormCreate(Sender: TObject);
begin
  Caption := SchedEngineName;
  FirstTime := True;
  SetTrayIcon(icPolling);
end;

procedure TfrmSchedTray.Show1Click(Sender: TObject);
begin
  if frmScheduler.Visible then
    ShowWindow(Application.Handle, SW_RESTORE)
  else
    frmScheduler.Show;
end;

procedure TfrmSchedTray.Paused1Click(Sender: TObject);
begin
  frmScheduler.ToolButton2Click(Self);
end;

procedure TfrmSchedTray.SetPause;
begin
{  Paused1.Checked := not Paused1.Checked;}
  if Paused1.Caption = '&Pause' then
    begin
      Paused1.Caption := '&Resume';
      Paused1.ImageIndex := 7;
      SetTrayIcon(icPaused);
    end
  else begin
    Paused1.Caption := '&Pause';
    Paused1.ImageIndex := 6;
    SetTrayIcon(icPolling);
  end;{if}
end;


procedure TfrmSchedTray.About1Click(Sender: TObject);
begin
  with TfrmAbout.Create(nil) do
  Try
    ShowModal;
  Finally
    Free;
  end;
end;


procedure TfrmSchedTray.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
{  Sleep(100);
  if frmThreadMaster.Running then
    frmThreadMaster.ToolButton2Click(Self);
  Application.ProcessMessages;
  Sleep(100);
  frmThreadMaster.FormCloseQuery(Sender, CanClose);
  Application.ProcessMessages;
  Sleep(100);
  Closing := CanClose;}


end;

end.
