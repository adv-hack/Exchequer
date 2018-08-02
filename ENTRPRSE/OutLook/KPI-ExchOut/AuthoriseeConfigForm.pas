unit AuthoriseeConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, KPICommon;

type
  TfrmConfigureAuthorisee = class(TForm)
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
    Label1: TLabel;
    Label2: TLabel;
    Label9: TLabel;
    ccbCurrency: TColumnComboBox;
    Label4: TLabel;
    seDays: TAdvSpinEdit;
    Label5: TLabel;
    edtAuthID: TAdvEdit;
    edtAuthCode: TAdvEdit;
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
    procedure ccbCurrencyChange(Sender: TObject);
    procedure edtAuthCodeKeyPress(Sender: TObject; var Key: Char);
  private
    FCanClose: boolean;
    FCompany: ShortString;
    FDataPath: ShortString;
    FCurrency: integer;
    FCurrSymb: WideString;
    Function  GetCompany : ShortString;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    Function  GetRows : SmallInt;
    Procedure SetRows (Value : SmallInt);
    procedure MakeRounded(Control: TWinControl);
    procedure PopulateCompanyList;
    procedure PopulateLists;
    function GetAuthID: ShortString;
    procedure SetAuthID(const Value: ShortString);
    procedure PopulateCurrencyList;
    function GetDataPath: ShortString;
    function GetCurrency: integer;
    procedure SetCurrency(const Value: integer);
    function GetAuthCode: ShortString;
    procedure SetAuthCode(const Value: ShortString);
    function GetLastDays: integer;
    procedure SetLastDays(const Value: integer);
  public
    { Public declarations }
    Property  Company : ShortString Read GetCompany Write SetCompany;
    property  Currency: integer read GetCurrency write SetCurrency;
    property  CurrSymb: WideString read FCurrSymb write FCurrSymb;
    Property  Host : HWND Write SetHost;
    Property  Rows : SmallInt Read GetRows Write SetRows;
    property  AuthID: ShortString read GetAuthID write SetAuthID;
    property  AuthCode: ShortString read GetAuthCode write SetAuthCode;
    property  DataPath: ShortString read GetDataPath write FDataPath;
    property  LastDays: integer read GetLastDays write SetLastDays;
    procedure Startup;
  end;

implementation

uses CTKUtil;

{$R *.dfm}

//=========================================================================

procedure TfrmConfigureAuthorisee.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
end;

//-------------------------------------------------------------------------

function TfrmConfigureAuthorisee.GetCompany: ShortString;
begin
  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;
procedure TfrmConfigureAuthorisee.SetCompany(Value: ShortString);
begin
  FCompany := Value;
end;

//------------------------------

Procedure TfrmConfigureAuthorisee.SetHost (Value : HWND);
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

function TfrmConfigureAuthorisee.GetRows: SmallInt;
begin
  Result := seRows.Value;
end;
procedure TfrmConfigureAuthorisee.SetRows(Value: SmallInt);
begin
  seRows.Value := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmConfigureAuthorisee.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureAuthorisee.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureAuthorisee.MakeRounded(Control: TWinControl);
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

procedure TfrmConfigureAuthorisee.FormActivate(Sender: TObject);
begin
  ofpNotes.SetFocus;
end;

procedure TfrmConfigureAuthorisee.Startup;
begin
  PopulateLists;
end;

procedure TfrmConfigureAuthorisee.PopulateLists;
begin
  PopulateCompanyList;
  PopulateCurrencyList;
end;

procedure TfrmConfigureAuthorisee.PopulateCompanyList;
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

procedure TfrmConfigureAuthorisee.PopulateCurrencyList;
var
  Toolkit: IToolkit;
  i: integer;

  function CheckCurrSymb(ACurrSymb: WideString): WideString;
  begin
    if ACurrSymb = '' then
      result := '-' else
    if trim(ACurrSymb) = #156 then
      result := '£'
    else
      result := ACurrSymb;
  end;

begin
  if FDataPath = '' then EXIT;

  ccbCurrency.Clear;
  Toolkit := OpenToolkit(FDataPath, true);
  if assigned(Toolkit) then
  try
    with Toolkit.SystemSetup do
      for i := 0 to ssMaxCurrency do
        with ssCurrency[i] do
          if scSymbol <> '' then
            with ccbCurrency.ComboItems.Add do begin
              strings.Add(CheckCurrSymb(scSymbol));
              strings.Add(IntToStr(i));
              if i = FCurrency then begin
                ccbCurrency.ItemIndex := ccbCurrency.ComboItems.Count - 1; // select latest addition
                FCurrSymb := CheckCurrSymb(scSymbol);
              end;
            end;
  finally
    Toolkit := nil;
  end;
    
  btnSave.Enabled := true; // prevent user from exiting until list has been drawn
end;

procedure TfrmConfigureAuthorisee.seRowsChange(Sender: TObject);
begin
  if seRows.Value < 1 then // if you set a MinVal you must also set MaxValue (and MinVal = 0 means no minimum)
    seRows.Value := 1;     // so need to control minimum value manually
end;

procedure TfrmConfigureAuthorisee.ccbCompanyChange(Sender: TObject);
begin
  btnSave.enabled := false;
  FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
  PopulateCurrencyList;
end;

procedure TfrmConfigureAuthorisee.AdvGlowButton1Click(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

procedure TfrmConfigureAuthorisee.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureAuthorisee.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmConfigureAuthorisee.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

function TfrmConfigureAuthorisee.GetAuthID: ShortString;
begin
  result := edtAuthID.Text;
end;

procedure TfrmConfigureAuthorisee.SetAuthID(const Value: ShortString);
begin
  EdtAuthID.Text := Value;
end;

function TfrmConfigureAuthorisee.GetDataPath: ShortString;
begin
  Result := FDataPath;
end;

function TfrmConfigureAuthorisee.GetCurrency: integer;
begin
 result := FCurrency;
end;

procedure TfrmConfigureAuthorisee.SetCurrency(const Value: integer);
begin
  FCurrency := Value;
end;

procedure TfrmConfigureAuthorisee.ccbCurrencyChange(Sender: TObject);
begin
  FCurrency := StrToInt(ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 1]);
  FCurrSymb := ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 0];
end;

function TfrmConfigureAuthorisee.GetAuthCode: ShortString;
begin
  result := edtAuthCode.Text;
end;

procedure TfrmConfigureAuthorisee.SetAuthCode(const Value: ShortString);
begin
  edtAuthCode.Text := Value;
end;

function TfrmConfigureAuthorisee.GetLastDays: integer;
begin
  result := seDays.Value;
end;

procedure TfrmConfigureAuthorisee.SetLastDays(const Value: integer);
begin
  seDays.Value := Value;
end;

procedure TfrmConfigureAuthorisee.edtAuthCodeKeyPress(Sender: TObject; var Key: Char);
begin
//  key := UpperCase(Key)[1];
end;

end.
