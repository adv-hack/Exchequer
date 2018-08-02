unit SentimailConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, KPICommon;

type
  TfrmConfigureSentimail = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpNotes: TAdvOfficePage;
    Label3: TLabel;
    lblPort: TLabel;
    seRows: TAdvSpinEdit;
    ccbCompany: TColumnComboBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure seRowsChange(Sender: TObject);
    procedure ccbCompanyChange(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure advPanelDblClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCanClose: boolean;
    FCompany: ShortString;
    FDataPath: ShortString;
    Function  GetCompany : ShortString;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    Function  GetRows : SmallInt;
    Procedure SetRows (Value : SmallInt);
    procedure MakeRounded(Control: TWinControl);
    procedure PopulateCompanyList;
    procedure PopulateLists;
  public
    { Public declarations }
    Property Company : ShortString Read GetCompany Write SetCompany;
    property DataPath: ShortString read FDataPath write FDataPath;
    Property Host : HWND Write SetHost;
    Property Rows : SmallInt Read GetRows Write SetRows;
    procedure Startup;
  end;

implementation

{$R *.dfm}

//=========================================================================

procedure TfrmConfigureSentimail.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
end;

//-------------------------------------------------------------------------

function TfrmConfigureSentimail.GetCompany: ShortString;
begin
  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;
procedure TfrmConfigureSentimail.SetCompany(Value: ShortString);
begin
  FCompany := Value;
end;

//------------------------------

Procedure TfrmConfigureSentimail.SetHost (Value : HWND);
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

//------------------------------

function TfrmConfigureSentimail.GetRows: SmallInt;
begin
  Result := seRows.Value;
end;
procedure TfrmConfigureSentimail.SetRows(Value: SmallInt);
begin
  seRows.Value := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmConfigureSentimail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureSentimail.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureSentimail.MakeRounded(Control: TWinControl);
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

procedure TfrmConfigureSentimail.FormActivate(Sender: TObject);
begin
  ofpNotes.SetFocus;
end;

procedure TfrmConfigureSentimail.Startup;
begin
  PopulateLists;
end;

procedure TfrmConfigureSentimail.PopulateLists;
begin
  PopulateCompanyList;
end;

procedure TfrmConfigureSentimail.PopulateCompanyList;
var
  toolkit: IToolkit;
  i : SmallInt;
begin
  toolkit := CoToolkit.Create;
  if assigned(toolkit) then
  try
    if (Toolkit.Company.cmCount > 0) then
      with Toolkit.Company do
        for i := 1 to cmCount do
          if DirectoryExists(cmCompany[i].coPath) then
             with ccbCompany.ComboItems.Add do begin
                strings.Add(trim(cmCompany[i].coCode));
                strings.Add(trim(cmCompany[i].coName));
                strings.Add(trim(cmCompany[i].coPath));
             end;
    ccbCompany.ItemIndex := ccbCompany.ComboItems.IndexInColumnOf(0, FCompany);
  finally
    toolkit := nil;
  end;
end;

procedure TfrmConfigureSentimail.seRowsChange(Sender: TObject);
begin
  if seRows.Value < 1 then // if you set a MinVal you must also set MaxValue (and MinVal = 0 means no minimum)
    seRows.Value := 1;     // so need to control minimum value manually
  if ccbCompany.ItemIndex <> -1 then
    btnSave.Enabled := true;
end;

procedure TfrmConfigureSentimail.ccbCompanyChange(Sender: TObject);
begin
  btnSave.enabled := true;
  FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
//  PopulateCurrencyList;
end;

procedure TfrmConfigureSentimail.AdvGlowButton1Click(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

procedure TfrmConfigureSentimail.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureSentimail.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmConfigureSentimail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

end.
