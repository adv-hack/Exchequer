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
  Dialogs, StdCtrls, ExtCtrls, AdvCircularProgress, AdvPanel;

Const
  cDEFAULTSTOPTIME = 300000;
//  cEXTENDEDSTOPTIME = 20000;
  cPROGRESSINTERVAL = 100;

Type
  TProcessMessages = Class(TThread)
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End;

  TfrmWait = Class(TForm)
    pnlInfo: TAdvPanel;
    tmClose: TTimer;
    Progress: TAdvCircularProgress;
    Procedure tmCloseTimer(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Procedure FormDeactivate(Sender: TObject);
  Private
//    Procedure HideTitleBar;
    Function GetpnlMessage: String;
    Procedure SetPnlMessage(Const Value: String);
  Protected
    Procedure CreateParams(Var Params: TCreateParams); Override;
  Public
    Procedure Start(Const pMsg: String = ''; Const pShowAnimation: Boolean = True);
    Procedure Stop;
  Published
    Property pnlMessage: String Read GetpnlMessage Write SetPnlMessage;

  End;

Var
  frmWait: TfrmWait;
  glFrmWaitStop: Boolean;

Implementation

{$R *.dfm}

{ TfrmWait }

{-----------------------------------------------------------------------------
  Procedure: CreateParams
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.CreateParams(Var Params: TCreateParams);
Begin
  Inherited CreateParams(Params);
  Params.Style := Params.Style And Not WS_CAPTION Or WS_POPUP;
End;

{-----------------------------------------------------------------------------
  Procedure: Start
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.Start(Const pMsg: String = ''; Const pShowAnimation: Boolean =
  True);
Begin
  Progress.Position := 0;
  Progress.Visible := pShowAnimation;
  Progress.Interval := cPROGRESSINTERVAL;
  glFrmWaitStop := False;

  Application.ProcessMessages;

  With TProcessMessages.Create Do
    Resume;

  {just in case the form get stuck in something, this timer will close it...}
  tmClose.Enabled := True;

  //pnlInfo.Caption := ' ' + pMsg;
  If Trim(pnlInfo.Text) = '' Then
    pnlInfo.Text := ' ' + pMsg;

  pnlInfo.Update;
  Application.ProcessMessages;

  With Self Do
    SetWindowPos(Handle, // handle to window
      HWND_TOPMOST, // placement-order handle {*}
      Left, // horizontal position
      Top, // vertical position
      Width,
      Height,
                 // window-positioning options
      SWP_NOACTIVATE Or SWP_NOMOVE Or SWP_NOSIZE);

  If Application.MainForm <> Nil Then
    Application.MainForm.Enabled := False;
  Self.Show;
End;

{-----------------------------------------------------------------------------
  Procedure: Stop
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.Stop;
Begin
  If Application.MainForm <> Nil Then
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

  If Application.MainForm <> Nil Then
    Application.MainForm.Enabled := True;

  glFrmWaitStop := True;
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: HideTitleBar
  Author:    vmoura
-----------------------------------------------------------------------------}
(*
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

  Application.ProcessMessages;
End;
*)
{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.FormCreate(Sender: TObject);
Begin
  //HideTitleBar;
  tmClose.Interval := cDEFAULTSTOPTIME;
  pnlInfo.Text := '';
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  tmClose.Interval := cDEFAULTSTOPTIME;

  If Application.MainForm <> Nil Then
    Application.MainForm.Enabled := True;

  glFrmWaitStop := True;
  Progress.Interval := 0;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCloseQuery
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
  If Application.MainForm <> Nil Then
    Application.MainForm.Enabled := True;

  glFrmWaitStop := True;
End;

{-----------------------------------------------------------------------------
  Procedure: FormDeactivate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.FormDeactivate(Sender: TObject);
Begin
  If Application.MainForm <> Nil Then
    Application.MainForm.Enabled := True;

  glFrmWaitStop := True;
End;

{ TProcessMessages }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TProcessMessages.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TProcessMessages.Destroy;
Begin

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TProcessMessages.Execute;
Var
  lTick: Longword;
Begin
  lTick := GetTickCount + cDEFAULTSTOPTIME;

  While (lTick > GetTickCount) And Not Terminated Do
  Begin
    Application.ProcessMessages;
    If glFrmWaitStop Then
      Break;

    Sleep(3);
  End; {while not Terminated do}

  Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: GetpnlMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmWait.GetpnlMessage: String;
Begin
  //Result := pnlInfo.Caption;
  Result := pnlInfo.Text;
End;

{-----------------------------------------------------------------------------
  Procedure: SetPnlMessage
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmWait.SetPnlMessage(Const Value: String);
Begin
  //pnlInfo.Caption := Value;
  pnlInfo.Text := Value;
  pnlInfo.Update;
End;

End.

