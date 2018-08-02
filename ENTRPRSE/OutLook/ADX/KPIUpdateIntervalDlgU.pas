unit KPIUpdateIntervalDlgU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, ExtCtrls, AdvPanel, StdCtrls, Mask, AdvSpin;

type
  TKPIUpdateIntervalDlg = class(TForm)
    PanelStyler: TAdvPanelStyler;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    Panel1: TPanel;
    advPanel: TAdvPanel;
    RefreshDataChk: TCheckBox;
    IntervalPnl: TAdvPanel;
    EveryLbl: TLabel;
    HourLbl: TLabel;
    MinuteLbl: TLabel;
    Min1Chk: TRadioButton;
    Min15Chk: TRadioButton;
    Min30Chk: TRadioButton;
    Min60Chk: TRadioButton;
    MinCustomChk: TRadioButton;
    HourSpin: TAdvSpinEdit;
    MinuteSpin: TAdvSpinEdit;
    OkBtn: TAdvGlowButton;
    CancelBtn: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure IntervalChanged(Sender: TObject);
    procedure UpdateDisplay(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FInterval: Integer;
    procedure SetInterval(const Value: Integer);
  public
    property Interval: Integer read FInterval write SetInterval;
  end;

var
  KPIUpdateIntervalDlg: TKPIUpdateIntervalDlg;

implementation

{$R *.dfm}

uses Brand, VAOUtil, KPIUtils;

//=========================================================================
{ TKPIUpdateIntervalDlg }

procedure TKPIUpdateIntervalDlg.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height div 2) - (Self.Height Div 2);
  Self.Left := (Screen.Width - Self.Width) Div 2;

  // Branding
  InitBranding (IncludeTrailingPathDelimiter(VAOInfo.vaoAppsDir));
  self.Icon.Assign(Branding.pbProductIcon);

  MakeRounded(self);
  MakeRounded(pnlInfo);
  MakeRounded(advPanel);

  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TKPIUpdateIntervalDlg.IntervalChanged(Sender: TObject);
begin
  if Min1Chk.Checked then
    FInterval := 1
  else if Min15Chk.Checked then
    FInterval := 15
  else if Min30Chk.Checked then
    FInterval := 30
  else if Min60Chk.Checked then
    FInterval := 60
  else
    FInterval := (HourSpin.Value * 60) + MinuteSpin.Value;
  UpdateDisplay(Sender);
end;

// -----------------------------------------------------------------------------

procedure TKPIUpdateIntervalDlg.SetInterval(const Value: Integer);
begin
  FInterval := Value;
  RefreshDataChk.Checked := (FInterval <> 0);
  case Interval of
     1: Min1Chk.Checked := True;
    15: Min15Chk.Checked := True;
    30: Min30Chk.Checked := True;
    60: Min60Chk.Checked := True;
  else
    MinCustomChk.Checked := True;
    HourSpin.Value   := Value div 60;
    MinuteSpin.Value := Value mod 60;
  end;
  IntervalChanged(self);
end;

// -----------------------------------------------------------------------------

procedure TKPIUpdateIntervalDlg.UpdateDisplay(Sender: TObject);
var
  Enable: Boolean;
begin
  Enable := RefreshDataChk.Checked;
  EveryLbl.Enabled     := Enable;
  Min1Chk.Enabled      := Enable;
  Min15Chk.Enabled     := Enable;
  Min30Chk.Enabled     := Enable;
  Min60Chk.Enabled     := Enable;
  MinCustomChk.Enabled := Enable;

  Enable := (MinCustomChk.Checked and MinCustomChk.Enabled);
  HourSpin.Enabled   := Enable;
  MinuteSpin.Enabled := Enable;
  HourLbl.Enabled    := Enable;
  MinuteLbl.Enabled  := Enable;

  if not RefreshDataChk.Checked then
    FInterval := 0;
end;

// -----------------------------------------------------------------------------

procedure TKPIUpdateIntervalDlg.pnlInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

end.
