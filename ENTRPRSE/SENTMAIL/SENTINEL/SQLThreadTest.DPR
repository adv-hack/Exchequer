program SQLThreadTest;

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  D6OnHelpFix,
  conHTMLHelp,
  Forms,
  Windows,
  SQLTHREAD1 in 'SQLTHREAD1.PAS' {frmThreadMaster},
  ExTHSu1U in 'EXTHSU1U.PAS' {ProgTForm},
  ExThrd2U in 'EXTHRD2U.PAS',
  elThred in 'elThred.pas',
  status in 'status.pas' {frmStatus},
  Trayf in 'Trayf.pas' {frmElertTray},
  ElHooku in 'ElHooku.pas',
  Previnst2 in 'Previnst2.pas',
  LogForm in 'LOGFORM.PAS' {frmSentinelLog},
  Diagf in 'DIAGF.PAS' {frmDiag},
  Pform in 'Pform.pas' {frmPrint},
  ChkPrntr,
  ElVar,
  Flags in 'Flags.pas',
  Notify in 'Notify.pas',
  closef in 'closef.pas' {frmCloseStatus},
  history in 'history.pas',
  acform in 'acform.pas' {frmAccount},
  NewParam in 'NewParam.pas',
  VAOUtil;

{$R *.RES}

{$R Arrows.RES}

{$IFDEF BindingRTLI} {* Include Run time Line Information *}
  {$R *.RLI}
{$ENDIF}


begin
  Application.Initialize;
//  Application.ShowMainForm := False;
  Application.Title := 'Sentimail Monitor';
  Application.HelpFile := 'Sentmail.chm';
    Application.CreateForm(TfrmThreadMaster, frmThreadMaster);
  Application.CreateForm(TfrmStatus, frmStatus);
  Application.CreateForm(TfrmDiag, frmDiag);
  Application.Run;
end.
