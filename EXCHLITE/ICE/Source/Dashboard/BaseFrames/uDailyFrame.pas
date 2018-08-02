{-----------------------------------------------------------------------------
 Unit Name: uDailyFrame
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDailyFrame;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, AdvPanel, Spin, Mask, AdvSpin,
  AdvGlowButton, htmlbtns;

Type
  TfrmDailyFrame = Class(TFrame)
    advPanelSchedule: TAdvPanel;
    lblDailyDesc: TLabel;
    lblStartTime: TLabel;
    edtStartTime: TDateTimePicker;
    lblPerformTask: TLabel;
    edtStartDate: TDateTimePicker;
    lblStartDate: TLabel;
    rbAllDays: THTMLRadioButton;
    rbWeekdays: THTMLRadioButton;
    rbEvery: THTMLRadioButton;
    seDays: TAdvSpinEdit;
    lblEndDate: TLabel;
    edtEndDate: TDateTimePicker;
    btnOk: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    Procedure rbEveryClick(Sender: TObject);
  Private
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    Procedure DisableAll;
  End;

Implementation

Uses Dateutils;

{$R *.dfm}

{ TfrmDaily }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TfrmDailyFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(Aowner);
  edtStartTime.DateTime := IncMinute(Now, -1);
  edtStartDate.DateTime := Now;
  edtEndDate.DateTime := IncDay(Now);
  rbAllDays.Checked := true;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmDailyFrame.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: rbEveryClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDailyFrame.rbEveryClick(Sender: TObject);
Begin
  If rbEvery.Checked Then
    seDays.Enabled := True
  Else
    seDays.Enabled := False
End;

{-----------------------------------------------------------------------------
  Procedure: DisableAll
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmDailyFrame.DisableAll;
Begin
  edtStartTime.Enabled := False;
  edtStartDate.Enabled := False;
  rbAllDays.Enabled := False;
  rbWeekdays.Enabled := False;
  rbEvery.Enabled := False;
  seDays.Enabled := False;
  edtEndDate.Enabled := False;
  btnOk.Enabled := False;
End;

End.
