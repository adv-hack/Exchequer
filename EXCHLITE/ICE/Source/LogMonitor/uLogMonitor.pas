{-----------------------------------------------------------------------------
 Unit Name: uLogMonitor
 Author:    vmoura
 Date:      23-Nov-2005
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uLogMonitor;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, uCommon, uConsts, ShellCtrls;

Type
  TfrmIceLogMonitor = Class(TForm)
    mmLog: TMemo;
    scnLog: TShellChangeNotifier;
    ppmRefresh: TPopupMenu;
    Refresh1: TMenuItem;
    MainMenu1: TMainMenu;
    Log1: TMenuItem;
    mnuDSR: TMenuItem;
    mnuPlugins: TMenuItem;
    Procedure FormCreate(Sender: TObject);
    Procedure scnLogChange;
    Procedure Refresh1Click(Sender: TObject);
    Procedure mnuDSRClick(Sender: TObject);
    Procedure mnuPluginsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  Private
    fFile: String;
    Procedure LoadLog(pGoEnd: Boolean);
    Procedure ChangeFile;
  Public
  End;

Var
  frmIceLogMonitor: TfrmIceLogMonitor;

Implementation

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: LoadLog
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmIceLogMonitor.LoadLog(pGoEnd: Boolean);
Var
  lFile: String;
Begin
  mmLog.Lines.Clear;
  If _FileSize(fFile) > 0 Then
  Try
    mmLog.Lines.LoadFromFile(fFile);
    If pGoEnd Then
      mmLog.Perform(WM_VSCROLL, SB_BOTTOM, 0);
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmIceLogMonitor.FormCreate(Sender: TObject);
Begin
  LockWindowUpdate(mmLog.Handle);
  mnuDSR.Checked := True;
  ChangeFile;
  LoadLog(True);
End;

{-----------------------------------------------------------------------------
  Procedure: scnLogChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmIceLogMonitor.scnLogChange;
Begin
  ChangeFile;
  LoadLog(True);
End;

{-----------------------------------------------------------------------------
  Procedure: Refresh1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmIceLogMonitor.Refresh1Click(Sender: TObject);
Begin
  ChangeFile;
  LoadLog(True);
End;

{-----------------------------------------------------------------------------
  Procedure: DSRandDashboard1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmIceLogMonitor.mnuDSRClick(Sender: TObject);
Begin
  mnuDSR.Checked := True;
  mnuPlugins.Checked := False;
  ChangeFile;
  LoadLog(True);
End;

{-----------------------------------------------------------------------------
  Procedure: Plugins1Click
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmIceLogMonitor.mnuPluginsClick(Sender: TObject);
Begin
  mnuDSR.Checked := False;
  mnuPlugins.Checked := True;
  ChangeFile;

  LoadLog(True);
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeFile
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmIceLogMonitor.ChangeFile;
Begin
  If mnuDSR.Checked Then
  begin
    try
      scnLog.Root := _GetApplicationPath + cLogDir;
    except
    end;
    fFile := _GetApplicationPath + cLogDir + '\' + FormatDateTime('yyyymmdd',
      date) + cLogFileExt
  end
  Else
  begin
    try
      scnLog.Root := _GetApplicationPath + cPLUGINSDIR + '\' + cLogDir;
    except
    end;  
    fFile := _GetApplicationPath + cPLUGINSDIR + '\' + cLogDir + '\' +
      FormatDateTime('yyyymmdd', date) + cLogFileExt;
  end;
End;

procedure TfrmIceLogMonitor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LockWindowUpdate(0);
end;

End.

