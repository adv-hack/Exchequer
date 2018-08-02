unit TasksConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, CTKUtil, KPICommon;

type
  TfrmConfigureTasks = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpStock: TAdvOfficePage;
    gbFilters: TGroupBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label1: TLabel;
    rbAllTasks: TRadioButton;
    rbTodaysTasks: TRadioButton;
    cbIncludeNoDueDate: TCheckBox;
    Label2: TLabel;
    ccbSort1: TColumnComboBox;
    Label3: TLabel;
    ccbSort2: TColumnComboBox;
    pnlSort1: TPanel;
    rbSort1Asc: TRadioButton;
    rbSort1Desc: TRadioButton;
    pnlSort2: TPanel;
    rbSort2Asc: TRadioButton;
    rbSort2Desc: TRadioButton;
    procedure advPanelDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ccbSort1Change(Sender: TObject);
    procedure ccbSort2Change(Sender: TObject);
    procedure rbAllTasksClick(Sender: TObject);
    procedure rbTodaysTasksClick(Sender: TObject);
  private
    FCanClose: boolean;
    procedure MakeRounded(Control: TWinControl);
    procedure SetHost(Value: HWND);
    procedure SetIncludeNoDueDate(const Value: boolean);
    procedure SetSort1(const Value: WideString);
    procedure SetSort1Asc(const Value: boolean);
    procedure SetSort2(const Value: WideString);
    procedure SetSort2Asc(const Value: boolean);
    procedure SetWhichTasks(const Value: WideString);
    function GetIncludeNoDueDate: boolean;
    function GetSort1: WideString;
    function GetSort1Asc: boolean;
    function GetSort2: WideString;
    function GetSort2Asc: boolean;
    function GetWhichTasks: WideString;
  public
    Property Host : HWND Write SetHost;
    property WhichTasks: WideString read GetWhichTasks write SetWhichTasks;
    property IncludeNoDueDate: boolean read GetIncludeNoDueDate write SetIncludeNoDueDate;
    property Sort1: WideString read GetSort1 write SetSort1;
    property Sort2: WideString read GetSort2 write SetSort2;
    property Sort1Asc: boolean read GetSort1Asc write SetSort1Asc;
    property Sort2Asc: boolean read GetSort2Asc write SetSort2Asc;
    procedure Startup;
  end;

implementation

{$R *.dfm}

procedure TfrmConfigureTasks.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

//=========================================================================

procedure TfrmConfigureTasks.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
end;

Procedure TfrmConfigureTasks.SetHost (Value : HWND);
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


procedure TfrmConfigureTasks.Startup;
begin
end;

procedure TfrmConfigureTasks.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureTasks.MakeRounded(Control: TWinControl);
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

procedure TfrmConfigureTasks.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureTasks.FormActivate(Sender: TObject);
begin
  ofpStock.SetFocus;
end;

procedure TfrmConfigureTasks.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

procedure TfrmConfigureTasks.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmConfigureTasks.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

procedure TfrmConfigureTasks.SetIncludeNoDueDate(const Value: boolean);
begin
  cbIncludeNoDueDate.Checked := Value;
end;

procedure TfrmConfigureTasks.SetSort1(const Value: WideString);
begin
  ccbSort1.ItemIndex := ccbSort1.ComboItems.IndexInColumnOf(0, Value);
  ccbSort1Change(nil);
end;

procedure TfrmConfigureTasks.SetSort1Asc(const Value: boolean);
begin
  rbSort1Asc.Checked := Value;
end;

procedure TfrmConfigureTasks.SetSort2(const Value: WideString);
begin
  ccbSort2.ItemIndex := ccbSort2.ComboItems.IndexInColumnOf(0, Value);
  ccbSort2Change(nil);
end;

procedure TfrmConfigureTasks.SetSort2Asc(const Value: boolean);
begin
  rbSort2Asc.Checked := Value;
end;

procedure TfrmConfigureTasks.SetWhichTasks(const Value: WideString);
begin
  rbAllTasks.Checked    := Value = 'All';
  rbTodaysTasks.Checked := Value = 'Todays';
end;

function TfrmConfigureTasks.GetIncludeNoDueDate: boolean;
begin
  result := cbIncludeNoDueDate.Checked;
end;

function TfrmConfigureTasks.GetSort1: WideString;
begin
  result := ccbSort1.ColumnItems[ccbSort1.ItemIndex, 0];
end;

function TfrmConfigureTasks.GetSort1Asc: boolean;
begin
  result := rbSort1Asc.Checked;
end;

function TfrmConfigureTasks.GetSort2: WideString;
begin
  result := ccbSort2.ColumnItems[ccbSort2.ItemIndex, 0];
end;

function TfrmConfigureTasks.GetSort2Asc: boolean;
begin
  result := rbSort2Asc.Checked;
end;

function TfrmConfigureTasks.GetWhichTasks: WideString;
begin
  if rbAllTasks.Checked then
    result := 'All'
  else
    result := 'Todays';
end;

procedure TfrmConfigureTasks.ccbSort1Change(Sender: TObject);
begin
  rbSort1Asc.enabled  := ccbSort1.ItemIndex <> 0;
  rbSort1Desc.enabled := ccbSort1.ItemIndex <> 0;
end;

procedure TfrmConfigureTasks.ccbSort2Change(Sender: TObject);
begin
//  rbSort2Asc.enabled  := ccbSort2.ItemIndex <> 0;
//  rbSort2Desc.enabled := ccbSort2.ItemIndex <> 0;
end;

procedure TfrmConfigureTasks.rbAllTasksClick(Sender: TObject);
begin
  cbIncludeNoDueDate.Enabled := rbTodaysTasks.Checked;
end;

procedure TfrmConfigureTasks.rbTodaysTasksClick(Sender: TObject);
begin
  cbIncludeNoDueDate.Enabled := rbTodaysTasks.Checked;
end;

end.
