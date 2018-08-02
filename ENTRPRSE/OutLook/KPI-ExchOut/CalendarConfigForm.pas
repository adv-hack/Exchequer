unit CalendarConfigForm;

{******************************************************************************}
{* The following change has been made to the TMS Components to draw a box     *}
{* around a flat TColumnComboBox:-                                            *}
{* In AdvCombo.pas, procedure TAdvCustomCombo.DrawControlBorder(DC: HDC);

    if FFlat and (FFlatLineColor <> clNone) then
    begin
      OldPen := SelectObject(DC,CreatePen( PS_SOLID,1,ColorToRGB(FFlatLineColor)));
      MovetoEx(DC,ARect.Left - 2,Height - 1,nil);
      LineTo(DC,ARect.Right - 18 ,Height - 1);
      LineTo(DC,ARect.Right - 18, 0);            // ***BJH***
      LineTo(DC, 0, 0);                          // ***BJH***
      LineTo(DC, 0, Height - 1);                 // ***BJH***
      DeleteObject(SelectObject(DC,OldPen));
    end;


{* The project must be compiled with TMSDISABLEOLE defined.
{* There appears to be a problem with the OLE subsystem not unloading which in
{* turn prevents the Outlook process from terminating even though the UI closes.
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvMenus,
  AdvMenuStylers, GradientLabel, AdvGlowButton, AdvSpin, htmlbtns, Mask,
  AdvOfficePager, AdvPanel, AdvOfficePagerStylers, AdvCombo, ColCombo,
  rtflabel, ComObj, ActiveX, KPICommon;

type
  TfrmConfigureCalendar = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpCustSupp: TAdvOfficePage;
    gbFilters: TGroupBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label1: TLabel;
    seDays: TAdvSpinEdit;
    procedure advPanelDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
  private
    FDays: integer;
    procedure MakeRounded(Control: TWinControl);
    procedure SetHost(Value: HWND);
    procedure SetDays(const Value: integer);
  public
    destructor destroy; override; 
    procedure Startup;
  published
    property Days: integer read FDays write SetDays;
  end;

implementation

uses CommCtrl;

{$R *.dfm}

destructor TfrmConfigureCalendar.destroy;
begin
  inherited destroy;
end;

procedure TfrmConfigureCalendar.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureCalendar.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height - - Self.Height) Div 2;
  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
end;

Procedure TfrmConfigureCalendar.SetHost (Value : HWND);
Var
  lpRect: TRect;
Begin // SetHost
  If (Value <> 0) Then
  Begin
    // Get the host window position and centre the login dialog over it
    If GetWindowRect(Value, lpRect) Then
    Begin
      // Top = Top of Host + (0.5 * Host Height) - (0.5 * Self Height)
      Self.Top := lpRect.Top + ((lpRect.Bottom - lpRect.Top - Self.Height) Div 2);

      // Left = Left of Host + (0.5 * Host Width) - (0.5 * Self Width)
      Self.Left := lpRect.Left + ((lpRect.Right - lpRect.Left - Self.Width) Div 2);

      // Make sure it is still fully on the screen
      If (Self.Top < 0) Then Self.Top := 0;
      If ((Self.Top + Self.Height) > Screen.Height) Then Self.Top := Screen.Height - Self.Height;
      If (Self.Left < 0) Then Self.Left := 0;
      If ((Self.Left + Self.Width) > Screen.Width) Then Self.Left := Screen.Width - Self.Width;
    End; // If GetWindowRect(Value, lpRect)
  End; // If (Value <> 0)
End; // SetHost

procedure TfrmConfigureCalendar.Startup;
begin
//
end;

procedure TfrmConfigureCalendar.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureCalendar.FormActivate(Sender: TObject);
begin
  ofpCustSupp.SetFocus;
end;

procedure TfrmConfigureCalendar.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureCalendar.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

procedure TfrmConfigureCalendar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmConfigureCalendar.btnSaveClick(Sender: TObject);
begin
  FDays := seDays.Value;
end;

procedure TfrmConfigureCalendar.SetDays(const Value: integer);
begin
  FDays := Value;
  seDays.Value := Value;
end;

initialization

finalization

end.
