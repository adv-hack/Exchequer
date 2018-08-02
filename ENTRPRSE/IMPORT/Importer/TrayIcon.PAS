unit TrayIcon;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ShellAPI, StdCtrls, ExtCtrls, ImgList, EntLicence, About;

const
  wm_IconMessage = wm_User + 39247;
  wm_IconClose   = wm_User + 39248;

type
  TTimeoutOrVersion = record                                                                        
    case Integer of          // 0: Before Win2000; 1: Win2000 and up
      0: (uTimeout: UINT);
      1: (uVersion: UINT);   // Only used when sending a NIM_SETVERSION message
  end;
  
  TNotifyIconDataEx = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;  // Previously 64 chars, now 128
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    TimeoutOrVersion: TTimeoutOrVersion;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
    guidItem: TGUID;  // Reserved for WinXP; define _WIN32_IE_600 if needed
  end;

  TfrmTrayIcon = class(TForm)
    mnuPopUp: TPopupMenu;
    mniClose: TMenuItem;
    imgImport: TImage;
    mniAbout: TMenuItem;
    ImageList1: TImageList;
    mniHelp: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    mniShowScheduler: TMenuItem;
    mniShowJobQueue: TMenuItem;
    Timer: TTimer;
    mniLogout: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniCloseClick(Sender: TObject);
    procedure mniAboutClick(Sender: TObject);
    procedure mniHelpClick(Sender: TObject);
    procedure mniShowSchedulerClick(Sender: TObject);
    procedure mniShowJobQueueClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure mniLogoutClick(Sender: TObject);
 private
    nid : TNotifyIconDataEx;
 public
    procedure IconTray(var Msg : TMessage); message wm_IconMessage;
    procedure IconClose(var Msg : TMessage); message wm_IconClose;
 end;

var
  frmTrayIcon: TfrmTrayIcon;

Implementation

uses Scheduler, JobQueue, GlobalConsts, LoginF;

{$R *.DFM}

procedure TfrmTrayIcon.IconTray(var Msg : TMessage);
{This dictates what happens when a mouse event happens on the tray icon}
var
  Pt : TPoint;
begin
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
        if not LoginOK then
          TfrmLogin.Show;
        if LoginOk then
          TfrmScheduler.Show('', true);
//        SetForegroundWindow(Handle);
//        PostMessage(Handle, WM_NULL, 0, 0);
      end;
    end;{case}
end;

procedure TfrmTrayIcon.IconClose(var Msg : TMessage);
{This Will force a close upon start up}
begin
  mniCloseClick(Nil);
end;

procedure TfrmTrayIcon.FormCreate(Sender: TObject);
// Display the icon in the System Tray then display the pop-up info balloon
var
  sVersion : shortString;
begin
  try
    FillChar(nid, SizeOf(nid), 0);
    with nid do begin
      cbSize := sizeof(nid);
      wnd := Handle;
      uID := 1;
      uCallBackMessage := wm_IconMessage;
      hIcon := imgImport.Picture.Icon.Handle;
      if EnterpriseLicence.IsLITE then
        sVersion := 'IRIS Accounts Office Importer Version: ' + APPVERSION
      else
        sVersion := 'Exchequer Importer ' + APPVERSION;
      Move(sVersion[1], szTip, Length(sVersion));

      uFlags := nif_Message or nif_Icon or nif_Tip;
      Shell_NotifyIcon(NIM_ADD, @nid);

      uFlags := $00000010;
      Move(sVersion[1], szInfoTitle, Length(sVersion));

      szInfo := 'Import Scheduler Started';
      TimeoutOrVersion.uTimeout := 5;
      dwInfoFlags := $00000001;
    end;
      Shell_NotifyIcon(NIM_MODIFY, @nid);
  except
    On E: Exception do
    begin
      ShowMessage(E.Message + #10 + 'This program will close');
      Application.Terminate;
    end;
  end;

end;

procedure TfrmTrayIcon.FormDestroy(Sender: TObject);
// remove the icon from the System Tray
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
  Application.ProcessMessages;
end;

procedure TfrmTrayIcon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmTrayIcon.mniCloseClick(Sender: TObject);
begin
  TfrmScheduler.CloseWindow;
  TfrmJobQueue.CloseWindow;
  application.MainForm.Close; // this IS the main form when running in Scheduler mode
end;

procedure TfrmTrayIcon.mniAboutClick(Sender: TObject);
begin
  with TfrmAbout.Create(nil) do
  try
    ShowModal;
  finally
    free;
  end;
end;

procedure TfrmTrayIcon.mniHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER,0);
end;

procedure TfrmTrayIcon.mniShowSchedulerClick(Sender: TObject);
// Display the Scheduler window if they've logged in OK
begin
  if not LoginOK then
    TfrmLogin.Show;
  if LoginOk then
    TfrmScheduler.Show('', true);
end;


procedure TfrmTrayIcon.mniShowJobQueueClick(Sender: TObject);
// Display the Job Queue window if they've logged in OK
begin
  if not LoginOK then
    TfrmLogin.Show;
  if LoginOk then
    TfrmJobQueue.Show;
end;

procedure TfrmTrayIcon.TimerTimer(Sender: TObject);
// cancel the pop-up info balloon
begin
  timer.enabled := false;
  with nid do begin
    uFlags := uFlags or $00000010; // NIF_INFO;
    StrPCopy(szInfo, '');
  end;
  Shell_NotifyIcon(NIM_MODIFY, @nid);
end;

procedure TfrmTrayIcon.mniLogoutClick(Sender: TObject);
begin
  LoginOK := false;
end;

end.
