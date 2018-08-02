{-----------------------------------------------------------------------------
 Unit Name: uWait
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uWait;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AdvCircularProgress;


const
  cDEFAULTSTOPTIME = 60000;
//  cEXTENDEDSTOPTIME = 20000;
  cPROGRESSINTERVAL = 100;

Type
  TProcessMessages = Class(TThread)
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  end;


  TfrmWait = Class(TForm)
    pnlInfo: TPanel;
    tmClose: TTimer;
    Progress: TAdvCircularProgress;
    Procedure tmCloseTimer(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDeactivate(Sender: TObject);
  Private
    Procedure HideTitleBar;
  Public
    Procedure Start(Const pMsg: String = 'Loading...');
    Procedure Stop;
  End;

Var
  frmWait: TfrmWait;
  glFrmWaitStop: Boolean;

Implementation

{$R *.dfm}

{ TfrmWait }

{-----------------------------------------------------------------------------
  Procedure: Start
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.Start(Const pMsg: String = 'Loading...');
Begin
  Progress.Position := 0;
  Progress.Interval := cPROGRESSINTERVAL;
  glFrmWaitStop := False;

  with TProcessMessages.Create do
    Resume;

  {just in case the form get stuck in something, this timer will close it...}
  tmClose.Enabled := True;
  
  pnlInfo.Caption := ' ' + pMsg;
  pnlInfo.Update;
  Application.ProcessMessages;

  with Self do 
    SetWindowPos(Handle, // handle to window
                 HWND_TOPMOST, // placement-order handle {*}
                 Left,  // horizontal position
                 Top,   // vertical position
                 Width,
                 Height,
                 // window-positioning options
                 SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);


  Application.MainForm.Enabled := False;
  Self.Show;
End;

{-----------------------------------------------------------------------------
  Procedure: Stop
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.Stop;
Begin
  Application.MainForm.Enabled := True;
  tmClose.Enabled := False;
  tmClose.Interval := cDEFAULTSTOPTIME;
  glFrmWaitStop := True;
  Progress.Interval := 0;
  Progress.Position := 0;
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: tmCloseTimer
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.tmCloseTimer(Sender: TObject);
Begin
  tmClose.Interval := cDEFAULTSTOPTIME;
  Application.MainForm.Enabled := True;
  glFrmWaitStop := True;
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: HideTitleBar
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.HideTitleBar;
Var
  Style: Longint;
Begin
  If BorderStyle = bsNone Then
    Exit;
    
  Style := GetWindowLong(Handle, GWL_STYLE);
  If (Style And WS_CAPTION) = WS_CAPTION Then
  Begin
    Case BorderStyle Of
      bsSingle,
        bsSizeable: SetWindowLong(Handle, GWL_STYLE, Style And
          (Not (WS_CAPTION)) Or WS_BORDER);
      bsDialog: SetWindowLong(Handle, GWL_STYLE, Style And
          (Not (WS_CAPTION)) Or DS_MODALFRAME Or WS_DLGFRAME);
    End; {Case BorderStyle Of}
    Height := Height - GetSystemMetrics(SM_CYCAPTION);
    Refresh;
  End; {If (Style And WS_CAPTION) = WS_CAPTION Then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.FormCreate(Sender: TObject);
Begin
  HideTitleBar;
  tmClose.Interval := cDEFAULTSTOPTIME;
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmClose.Interval := cDEFAULTSTOPTIME;
  Application.MainForm.Enabled := True;
  glFrmWaitStop := True;
  Progress.Interval := 0;
end;

{-----------------------------------------------------------------------------
  Procedure: FormCloseQuery
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmWait.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Application.MainForm.Enabled := True;
  glFrmWaitStop := True;
end;

{-----------------------------------------------------------------------------
  Procedure: FormDeactivate
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TfrmWait.FormDeactivate(Sender: TObject);
begin
  Application.MainForm.Enabled := True;
  glFrmWaitStop := True;
end;


{ TProcessMessages }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
constructor TProcessMessages.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
end;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
destructor TProcessMessages.Destroy;
begin

  inherited Destroy;
end;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
procedure TProcessMessages.Execute;
var
  lTick: Longint;
  msg: TMsg;
begin
  lTick := GetTickCount + cDEFAULTSTOPTIME;

  while (lTick > GetTickCount) and not Terminated do
  begin
    Application.ProcessMessages;

    if glFrmWaitStop then
      Break;

    Sleep(10);
  end; {while not Terminated do}

  Terminate;
end;

End.

