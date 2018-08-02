unit DaybookTotalsConfigForm;

interface

// the width of the options checklistboxes is set to 14 pixels which is the
// minimum width that prevents the focus bar from appearing when a box is
// clicked.

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, CheckLst, TEditVal,
  ComObj, ActiveX, Enterprise01_TLB, CTKUtil, AdvOfficePager,
  AdvOfficePagerStylers, AdvCombo, ColCombo, AdvGlowButton, AdvPanel, KPICommon,
  AdvOfficeButtons, Contnrs, ConfigureDaybookTotalsFrameU, Menus;

type
  TfrmConfigureDaybookTotals = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofp: TAdvOfficePage;
    Label8: TLabel;
    ccbCompany: TColumnComboBox;
    gbFilters: TGroupBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    ccbCurrency: TColumnComboBox;
    Label9: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    PopupMenu: TPopupMenu;
    Documenttype1: TMenuItem;
    Total1: TMenuItem;
    OS1: TMenuItem;
    Today1: TMenuItem;
    VATincl1: TMenuItem;
    procedure advPanelDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label2DblClick(Sender: TObject);
    procedure cbCurrencyChange(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ccbCompanyChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure Documenttype1Click(Sender: TObject);
    procedure Total1Click(Sender: TObject);
    procedure OS1Click(Sender: TObject);
    procedure Today1Click(Sender: TObject);
    procedure VATincl1Click(Sender: TObject);
    procedure Label2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FCanClose: boolean;
    FCompany: WideString;
    FCurrency: integer;
    FDataPath: ShortString;
    FCurrSymb: WideString;
    FRowTop: Integer;
    FRows: TObjectList;
    FMousePos: TPoint;
    { Private declarations }
    procedure CheckAllBoxes(ID: Integer; Value: Boolean = True);
    Function  GetCompany : WideString;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    procedure SetCurrency(const Value: integer);
    procedure MakeRounded(Control: TWinControl);
    function  GetCurrency: integer;
    function  GetDataPath: ShortString;
    procedure PopulateCompanyList;
  public
    { Public declarations }
    Property  Company : WideString Read GetCompany Write FCompany;
    property  Currency: integer read GetCurrency write SetCurrency;
    property  CurrSymb: WideString read FCurrSymb write FCurrSymb;
    property  DataPath: ShortString read GetDataPath write FDataPath;
    Property  Host : HWND Write SetHost;
    procedure AddRow(WithCaption: string; IncludeVATCheckbox: Boolean = True);
    procedure PopulateLists;
    procedure PopulateCurrencyList;
    procedure Startup;

    function DocTypeRequired(Index: Integer): Boolean;
    function TotalRequired(Index: Integer): Boolean;
    function OSRequired(Index: Integer): Boolean;
    function TodayRequired(Index: Integer): Boolean;
    function VATRequired(Index: Integer): Boolean;

    procedure SetDocTypeRequired(Index: Integer; Value: Boolean);
    procedure SetTotalRequired(Index: Integer; Value: Boolean);
    procedure SetOSRequired(Index: Integer; Value: Boolean);
    procedure SetTodayRequired(Index: Integer; Value: Boolean);
    procedure SetVATRequired(Index: Integer; Value: Boolean);

  end;

implementation

{$R *.dfm}

procedure TfrmConfigureDaybookTotals.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

//=========================================================================

procedure TfrmConfigureDaybookTotals.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  FRowTop := 0;
  FRows := TObjectList.Create;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
end;

//-------------------------------------------------------------------------

function TfrmConfigureDaybookTotals.GetCompany: WideString;
begin
  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;
procedure TfrmConfigureDaybookTotals.SetCompany(Value: ShortString);
begin
  FCompany := Value;
end;

//------------------------------

Procedure TfrmConfigureDaybookTotals.SetHost (Value : HWND);
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

//-------------------------------------------------------------------------

procedure TfrmConfigureDaybookTotals.CheckAllBoxes(ID: Integer; Value: Boolean);
var
  i: integer;
begin
  for i := 0 to FRows.Count - 1 do
  begin
    case ID of
      0: SetDocTypeRequired(i, Value);
      1: SetTotalRequired(i, Value);
      2: SetOSRequired(i, Value);
      3: SetTodayRequired(i, Value);
      4: SetVATRequired(i, Value);
    end;
  end;
end;

procedure TfrmConfigureDaybookTotals.Label2DblClick(Sender: TObject);
var
  ActualPos: TPoint;
begin
  ActualPos := TLabel(sender).ClientToScreen(FMousePos);
  PopupMenu.Popup(ActualPos.X, ActualPos.Y);
end;

procedure TfrmConfigureDaybookTotals.SetCurrency(const Value: integer);
begin
  FCurrency := Value;
end;

procedure TfrmConfigureDaybookTotals.cbCurrencyChange(Sender: TObject);
begin
  FCurrency := StrToInt(ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 1]);
  FCurrSymb := ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 0];
end;

procedure TfrmConfigureDaybookTotals.MakeRounded(Control: TWinControl);
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

procedure TfrmConfigureDaybookTotals.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

function TfrmConfigureDaybookTotals.GetCurrency: integer;
begin
 result := FCurrency;
end;

function TfrmConfigureDaybookTotals.GetDataPath: ShortString;
begin
  Result := FDataPath;
end;

procedure TfrmConfigureDaybookTotals.FormActivate(Sender: TObject);
begin
  ofp.SetFocus;
end;

procedure TfrmConfigureDaybookTotals.Startup;
begin
  lblInfo.Caption := self.Caption;
  PopulateLists;
end;

procedure TfrmConfigureDaybookTotals.AddRow(WithCaption: string;
  IncludeVATCheckbox: Boolean);
var
  Row: TConfigureDaybookTotalsFrame;
  RowName: string;
begin
  // Create a new frame (each frame holds the row of checkboxes)
  Row := TConfigureDaybookTotalsFrame.Create(self);
  Row.PopupMenu := PopupMenu;
  RowName := 'Frame' + StringReplace(WithCaption, ' ', '', [rfReplaceAll]);
  RowName := StringReplace(RowName, '&', '', [rfReplaceAll]);
  Row.Name := RowName;
  Row.Parent := Panel1;
  Row.Height := 23;
  Row.Top  := FRowTop;
  // Create the checkboxes
  Row.CreateCheckboxes(WithCaption, IncludeVATCheckbox);
  // Store a reference to the frame
  FRows.Add(Row);
  // Prepare the position of the next frame
  FRowTop := FRowTop + Row.Height;
end;

procedure TfrmConfigureDaybookTotals.PopulateLists;
begin
  PopulateCompanyList;
  PopulateCurrencyList;
end;

procedure TfrmConfigureDaybookTotals.PopulateCompanyList;
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

procedure TfrmConfigureDaybookTotals.PopulateCurrencyList;
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

procedure TfrmConfigureDaybookTotals.ccbCompanyChange(Sender: TObject);
begin
  btnSave.enabled := false;
  FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
  PopulateCurrencyList;
end;

procedure TfrmConfigureDaybookTotals.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureDaybookTotals.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

function TfrmConfigureDaybookTotals.OSRequired(Index: Integer): Boolean;
begin
  if (Index >= 0) and (Index < FRows.Count) then
    Result := TConfigureDaybookTotalsFrame(FRows[Index]).cbOS.Checked
  else
    Result := False;
end;

procedure TfrmConfigureDaybookTotals.SetOSRequired(Index: Integer;
  Value: Boolean);
begin
  if (Index >= 0) and (Index < FRows.Count) then
  begin
    TConfigureDaybookTotalsFrame(FRows[Index]).cbOS.Checked := Value;
    TConfigureDaybookTotalsFrame(FRows[Index]).CheckOptions;
  end;
end;

procedure TfrmConfigureDaybookTotals.SetTodayRequired(Index: Integer;
  Value: Boolean);
begin
  if (Index >= 0) and (Index < FRows.Count) then
  begin
    TConfigureDaybookTotalsFrame(FRows[Index]).cbToday.Checked := Value;
    TConfigureDaybookTotalsFrame(FRows[Index]).CheckOptions;
  end;
end;

procedure TfrmConfigureDaybookTotals.SetTotalRequired(Index: Integer;
  Value: Boolean);
begin
  if (Index >= 0) and (Index < FRows.Count) then
  begin
    TConfigureDaybookTotalsFrame(FRows[Index]).cbTotal.Checked := Value;
    TConfigureDaybookTotalsFrame(FRows[Index]).CheckOptions;
  end;
end;

procedure TfrmConfigureDaybookTotals.SetVATRequired(Index: Integer;
  Value: Boolean);
begin
  if (Index >= 0) and (Index < FRows.Count) then
    if TConfigureDaybookTotalsFrame(FRows[Index]).cbVAT <> nil then
    begin
      TConfigureDaybookTotalsFrame(FRows[Index]).cbVAT.Checked := Value;
      TConfigureDaybookTotalsFrame(FRows[Index]).CheckVAT;
    end;
end;

function TfrmConfigureDaybookTotals.TodayRequired(Index: Integer): Boolean;
begin
  if (Index >= 0) and (Index < FRows.Count) then
    Result := TConfigureDaybookTotalsFrame(FRows[Index]).cbToday.Checked
  else
    Result := False;
end;

function TfrmConfigureDaybookTotals.TotalRequired(Index: Integer): Boolean;
begin
  if (Index >= 0) and (Index < FRows.Count) then
    Result := TConfigureDaybookTotalsFrame(FRows[Index]).cbTotal.Checked
  else
    Result := False;
end;

function TfrmConfigureDaybookTotals.VATRequired(Index: Integer): Boolean;
begin
  if (Index >= 0) and (Index < FRows.Count) then
  begin
    if TConfigureDaybookTotalsFrame(FRows[Index]).cbVAT <> nil then
      Result := TConfigureDaybookTotalsFrame(FRows[Index]).cbVAT.Checked
    else
      Result := False;
  end
  else
    Result := False;
end;

function TfrmConfigureDaybookTotals.DocTypeRequired(
  Index: Integer): Boolean;
begin
  if (Index >= 0) and (Index < FRows.Count) then
    Result := TConfigureDaybookTotalsFrame(FRows[Index]).cbDocType.Checked
  else
    Result := False;
end;

procedure TfrmConfigureDaybookTotals.SetDocTypeRequired(Index: Integer;
  Value: Boolean);
begin
  if (Index >= 0) and (Index < FRows.Count) then
  begin
    TConfigureDaybookTotalsFrame(FRows[Index]).cbDocType.Checked := Value;
    TConfigureDaybookTotalsFrame(FRows[Index]).CheckDocType;
    if (Value = False) then
    begin
      Total1.Checked := False;
      OS1.Checked := False;
      Today1.Checked := False;
      VATIncl1.Checked := False;
    end;
  end;
end;

procedure TfrmConfigureDaybookTotals.Documenttype1Click(Sender: TObject);
begin
  DocumentType1.Checked := not DocumentType1.Checked;
  CheckAllBoxes(0, DocumentType1.Checked);
end;

procedure TfrmConfigureDaybookTotals.Total1Click(Sender: TObject);
begin
  Total1.Checked := not Total1.Checked;
  CheckAllBoxes(1, Total1.Checked);
end;

procedure TfrmConfigureDaybookTotals.OS1Click(Sender: TObject);
begin
  OS1.Checked := not OS1.Checked;
  CheckAllBoxes(2, OS1.Checked);
end;

procedure TfrmConfigureDaybookTotals.Today1Click(Sender: TObject);
begin
  Today1.Checked := not Today1.Checked;
  CheckAllBoxes(3, Today1.Checked);
end;

procedure TfrmConfigureDaybookTotals.VATincl1Click(Sender: TObject);
begin
  VATIncl1.Checked := not VATIncl1.Checked;
  CheckAllBoxes(4, VATIncl1.Checked);
end;

procedure TfrmConfigureDaybookTotals.Label2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMousePos.X := X;
  FMousePos.Y := Y;
end;

end.
