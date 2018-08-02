unit Trayform;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ShellAPI, StdCtrls, ExtCtrls, ImgList, AuthObjs, PMsg;

const
  wm_IconMessage = wm_User;
  wm_IconClose   = wm_User+1;

type
  TfrmeEARTray = class(TForm)
    mnuPopUp: TPopupMenu;
    mniClose: TMenuItem;
    imgImport: TImage;
    About1: TMenuItem;
    ImageList1: TImageList;
    Help1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    mniSetup: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniCloseClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure mniSetupClick(Sender: TObject);
 private
    nid : TNotifyIconData;
    Closing, bOKToShowMenu : boolean;
    EARMonitor : TPaEARMonitor;
 public
    procedure IconTray(var Msg : TMessage); message wm_IconMessage;
    procedure IconClose(var Msg : TMessage); message wm_IconClose;
 end;

 Function ECMAPIAVAILABLE : WordBool; StdCall; external 'ENTCOMMS.DLL' Index 3;

var
  frmeEARTray: TfrmeEARTray;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

uses
  About, AuthVar, Crypto;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
const
  AdminLib = 'ExPaSet.dll';

{$R *.DFM}

procedure ShowAuthAdmin; external AdminLib;

//-----------------------------------------------------------------------

procedure TfrmeEARTray.IconTray(var Msg : TMessage);
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
        PostMessage(Handle, WM_NULL, 0, 0);
      end;
    end;{case}
  end;{if}
end;


procedure TfrmeEARTray.IconClose(var Msg : TMessage);
{This Will force a close upon start up}
begin
  mniCloseClick(Nil);
end;


//-----------------------------------------------------------------------

procedure TfrmeEARTray.FormCreate(Sender: TObject);
var
  Res : SmallInt;
begin
  ChangeCryptoKey(19701115);
  MapiOK := ECMAPIAVAILABLE;
  if ParamCount > 0 then
    DebugModeOn := UpperCase(ParamStr(1))[2] = 'D'
  else
    DebugModeOn := False;

  PMsgForm := TPMsgForm.Create(nil);
  StartToolkit;
  FToolkit.Configuration.AutoSetStockCost := False;
  Try
    EARMonitor := TPaEARMonitor.Create;
    //Check whether data files are available
    EARMonitor.OpenFiles;
    EARMonitor.CloseFiles;
    bOKToShowMenu := FALSE;
    Closing := false;
    with nid do begin
      cbSize := sizeof(nid);
      wnd := Handle;
      uID := 1;
      uCallBackMessage := wm_IconMessage;
      hIcon := imgImport.Picture.Icon.Handle;
      szTip := 'Exchequer Authoris-e EAR Monitor';
      uFlags := nif_Message or nif_Icon or nif_Tip;
    end;{with}
    Shell_NotifyIcon(NIM_ADD, @nid);

    Res := EARMonitor.Start;
    if Res = erNoProblem then
      bOKToShowMenu := TRUE
    else
    begin
      Case Res of
        erNoServer :  begin
                        ShowMessage('No SMTP server has been specified.   ' +
                        'This program will now close'#10 +
                         'Please specify an SMTP server before running this program again');
                        Application.Terminate;
                      end;
        erComtkNotOpen : begin
                           ShowMessage('It was not possible to open the Com Toolkit. ' +
                           'This program will now close');
                           Application.Terminate;
                       end;
      end; //case
    end;
  Except
    On E: Exception do
    begin
      ShowMessage(E.Message + #10 + 'This program will close');
      Application.Terminate;
    end;
  End;

end;

//-----------------------------------------------------------------------

procedure TfrmeEARTray.FormDestroy(Sender: TObject);
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
  Application.ProcessMessages;
  EARMonitor.Stop;
  EARMonitor.Free;
  EndToolkit;
  if Assigned(PMsgForm) then
    PMsgForm.Free;
end;

//-----------------------------------------------------------------------

procedure TfrmeEARTray.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Closing then
  begin
    Action := caNone;
    ShowWindow(Handle, sw_Hide);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmeEARTray.mniCloseClick(Sender: TObject);
begin
  if EARMonitor.Busy then
  begin
    ShowMessage('The EAR Monitor is currently busy processing.'+#13+
                'Closing is not possible at this time.'+#13+
                'The monitor will close as soon as it has finished.');
    while EARMonitor.Busy do
      Application.ProcessMessages;
  end;
  Closing := true;
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmeEARTray.About1Click(Sender: TObject);
begin
  EARMonitor.Stop;
  with TfrmAbout.Create(Self) do
    try
      Caption := 'About Exchequer Authoris-e EAR Monitor';
      lblTitle.Caption := 'Exchequer Authoris-e EAR Monitor';
      lblVersion.Caption := 'Version: ' + EARMonitor.Version;
      ShowModal;
    finally
      Free;
    end;
  EARMonitor.Start;
end;

//-----------------------------------------------------------------------

procedure TfrmeEARTray.Help1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER,0);
end;

//-----------------------------------------------------------------------

procedure TfrmeEARTray.mniSetupClick(Sender: TObject);
begin
  EARMonitor.Stop;
  ShowAuthAdmin;
  EARMonitor.Start;
end;


end.
