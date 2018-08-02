unit TopProductsConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, Enterprise01_TLB, ComObj, ActiveX, CTKUtil,
  KPICommon;

type
  TfrmConfigureTopProducts = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpStock: TAdvOfficePage;
    Label4: TLabel;
    lblPort: TLabel;
    seRows: TAdvSpinEdit;
    ccbCompany: TColumnComboBox;
    gbFilters: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    lblUserDef1: TLabel;
    lblUserDef2: TLabel;
    lblUserDef3: TLabel;
    lblUserDef4: TLabel;
    ccbCostCentre: TColumnComboBox;
    ccbDepartment: TColumnComboBox;
    edtUserDef1: TAdvEdit;
    edtUserDef4: TAdvEdit;
    edtUserDef2: TAdvEdit;
    edtUserDef3: TAdvEdit;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    Label3: TLabel;
    ccbLocation: TColumnComboBox;
    Label1: TLabel;
    ccbStockGroup: TColumnComboBox;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label9: TLabel;
    ccbCurrency: TColumnComboBox;
    edtUserDef5: TAdvEdit;
    edtUserDef6: TAdvEdit;
    lblUserDef5: TLabel;
    lblUserDef6: TLabel;
    lblUserDef7: TLabel;
    lblUserDef8: TLabel;
    edtUserDef7: TAdvEdit;
    edtUserDef8: TAdvEdit;
    lblUserDef9: TLabel;
    edtUserDef9: TAdvEdit;
    lblUserDef10: TLabel;
    edtUserDef10: TAdvEdit;
    procedure FormCreate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ccbCompanyChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure ccbCurrencyChange(Sender: TObject);
    procedure seRowsChange(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure advPanelDblClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCanClose: boolean;
    FCompany: ShortString;
    FCostCentre: ShortString;
    FDataPath: ShortString;
    FDepartment: ShortString;
    FLocation: ShortString;
    FStockGroup: integer;
    FCurrency: integer;
    FCurrSymb: WideString;
    Function  GetCompany : ShortString;
    Procedure SetHost (Value : HWND);
    Function  GetRows : SmallInt;
    Procedure SetRows (Value : SmallInt);
    function  GetCostCentre: string;
    function  GetDept: string;
    procedure SetCostCentre(const Value: string);
    procedure SetDept(const Value: string);
    function  GetLocation: string;
    function  GetStockGroup: integer;
    procedure SetLocation(const Value: string);
    procedure MakeRounded(Control: TWinControl);
    procedure PopulateCCDeptLocCurrLists;
    procedure PopulateCompanyList;
    procedure PopulateLists;
    function  GetUDF1: WideString;
    function  GetUDF2: WideString;
    function  GetUDF3: WideString;
    function  GetUDF4: WideString;
    function  GetUDF5: WideString;
    function  GetUDF6: WideString;
    function  GetUDF7: WideString;
    function  GetUDF8: WideString;
    function  GetUDF9: WideString;
    function  GetUDF10: WideString;
    procedure SetUDF1(const Value: WideString);
    procedure SetUDF2(const Value: WideString);
    procedure SetUDF3(const Value: WideString);
    procedure SetUDF4(const Value: WideString);
    procedure SetUDF5(const Value: WideString);
    procedure SetUDF6(const Value: WideString);
    procedure SetUDF7(const Value: WideString);
    procedure SetUDF8(const Value: WideString);
    procedure SetUDF9(const Value: WideString);
    procedure SetUDF10(const Value: WideString);
    function  GetCurrency: integer;
    procedure SetCurrency(const Value: integer);
  public
    { Public declarations }
    Property Company : ShortString Read GetCompany Write FCompany;
    Property Host : HWND Write SetHost;
    Property Rows : SmallInt Read GetRows Write SetRows;
    property CostCentre: string read GetCostCentre write SetCostCentre;
    property Currency:   integer    read GetCurrency write SetCurrency;
    property CurrSymb:   WideString read FCurrSymb write FCurrSymb;
    property DataPath: ShortString read FDataPath write FDataPath;
    property Dept: string read GetDept write SetDept;
    property Location: string read GetLocation write SetLocation;
    property StockGroup: integer read GetStockGroup write FStockGroup;
    property UDF1:       WideString read GetUDF1 write SetUDF1;
    property UDF2:       WideString read GetUDF2 write SetUDF2;
    property UDF3:       WideString read GetUDF3 write SetUDF3;
    property UDF4:       WideString read GetUDF4 write SetUDF4;
    property UDF5:       WideString read GetUDF5 write SetUDF5;
    property UDF6:       WideString read GetUDF6 write SetUDF6;
    property UDF7:       WideString read GetUDF7 write SetUDF7;
    property UDF8:       WideString read GetUDF8 write SetUDF8;
    property UDF9:       WideString read GetUDF9 write SetUDF9;
    property UDF10:      WideString read GetUDF10 write SetUDF10;
    procedure Startup;
  end;

implementation

{$R *.dfm}

//=========================================================================

procedure TfrmConfigureTopProducts.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
end;

//-------------------------------------------------------------------------

function TfrmConfigureTopProducts.GetCompany: ShortString;
begin
  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;

//------------------------------

Procedure TfrmConfigureTopProducts.SetHost (Value : HWND);
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

function TfrmConfigureTopProducts.GetRows: SmallInt;
begin
  Result := seRows.Value;
end;
procedure TfrmConfigureTopProducts.SetRows(Value: SmallInt);
begin
  seRows.Value := Value;
end;

//-------------------------------------------------------------------------


function TfrmConfigureTopProducts.GetCostCentre: string;
begin
  result := ccbCostCentre.ColumnItems[ccbCostCentre.ItemIndex, 0];
  if result = '<none>' then result := '';
end;

function TfrmConfigureTopProducts.GetDept: string;
begin
  result := ccbDepartment.ColumnItems[ccbDepartment.ItemIndex, 0];
  if result = '<none>' then result := '';
end;

procedure TfrmConfigureTopProducts.SetCostCentre(const Value: string);
begin
  if Value = '' then
    FCostCentre := '<none>'
  else
    FCostCentre := value;
end;

procedure TfrmConfigureTopProducts.SetDept(const Value: string);
begin
  if Value = '' then
    FDepartment := '<none>'
  else
    FDepartment := Value;
end;

function TfrmConfigureTopProducts.GetLocation: string;
begin
  result := ccbLocation.ColumnItems[ccbLocation.ItemIndex, 0];
  if result = '<none>' then result := '';
end;

function TfrmConfigureTopProducts.GetStockGroup: integer;
begin
  result := ccbStockGroup.ItemIndex;
end;

procedure TfrmConfigureTopProducts.SetLocation(const Value: string);
begin
  if Value = '' then
    FLocation := '<none>'
  else
    FLocation := value;
end;

procedure TfrmConfigureTopProducts.PopulateLists;
begin
  PopulateCompanyList;
  PopulateCCDeptLocCurrLists;
end;

procedure TfrmConfigureTopProducts.PopulateCompanyList;
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

procedure TfrmConfigureTopProducts.PopulateCCDeptLocCurrLists;
var
  toolkit: IToolkit;
  i : SmallInt;
  CCDept: ICCDept;
  Location: ILocation;
  res: integer;

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

  toolkit := OpenToolkit(FDataPath, true);
  try
    ccbCostCentre.ComboItems.Clear;
    with ccbCostCentre.ComboItems.Add do begin
      strings.Add('<none>');
      strings.Add(' ');
    end;
    if toolkit.SystemSetup.ssUseCCDept then begin
      CCDept := Toolkit.CostCentre;
      if assigned(CCDept) then
      try
        with CCDept do begin
          index := cdIdxCode;
          res := GetFirst;
          while res = 0 do begin
            with ccbCostCentre.ComboItems.Add do begin
              strings.Add(trim(cdCode));
              strings.Add(trim(cdName));
            end;
            res := GetNext;
          end;
        end;
        ccbCostCentre.ItemIndex := ccbCostCentre.ComboItems.IndexInColumnOf(0, FCostCentre);
      finally
        CCDept := nil;
      end;
    end;

    ccbDepartment.ComboItems.Clear;
    with ccbDepartment.ComboItems.Add do begin
      strings.Add('<none>');
      strings.Add(' ');
    end;
    if toolkit.SystemSetup.ssUseCCDept then begin
      CCDept := Toolkit.Department;
      if assigned(CCDept) then
      try
        with CCDept do begin
          index := cdIdxCode;
          res := GetFirst;
          while res = 0 do begin
            with ccbDepartment.ComboItems.Add do begin
              strings.Add(trim(cdCode));
              strings.Add(trim(cdName));
            end;
            res := GetNext;
          end;
        end;
        ccbDepartment.ItemIndex := ccbDepartment.ComboItems.IndexInColumnOf(0, FDepartment);
      finally
        CCDept := nil;
      end;
    end;

    ccbLocation.ComboItems.Clear;
    with ccbLocation.ComboItems.Add do begin
      strings.Add('<none>');
      strings.Add(' ');
    end;
    if toolkit.SystemSetup.ssUseLocations then begin
      Location := Toolkit.Location;
      if assigned(Location) then
      try
        with Location do begin
          index := loIdxCode;
          res := GetFirst;
          while res = 0 do begin
            with ccbLocation.ComboItems.Add do begin
              strings.Add(trim(loCode));
              strings.Add(trim(loName));
            end;
            res := GetNext;
          end;
        end;
        ccbLocation.ItemIndex := ccbLocation.ComboItems.IndexInColumnOf(0, FLocation);
      finally
        Location := nil;
      end;
    end;

    ccbCurrency.Clear;
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

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    with toolkit.SystemSetup.ssUserFields as ISystemSetupUserFields4 do
    begin
      lblUserDef1.Caption  := ufStockDesc[1];
      lblUserDef2.Caption  := ufStockDesc[2];
      lblUserDef3.Caption  := ufStockDesc[3];
      lblUserDef4.Caption  := ufStockDesc[4];
      lblUserDef5.Caption  := ufStockDesc[5];
      lblUserDef6.Caption  := ufStockDesc[6];
      lblUserDef7.Caption  := ufStockDesc[7];
      lblUserDef8.Caption  := ufStockDesc[8];
      lblUserDef9.Caption  := ufStockDesc[9];
      lblUserDef10.Caption := ufStockDesc[10];
    end;

  finally
    toolkit := nil;
  end;

  btnSave.enabled := true;
end;

procedure TfrmConfigureTopProducts.Startup;
begin
  PopulateLists;
end;

procedure TfrmConfigureTopProducts.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureTopProducts.MakeRounded(Control: TWinControl);
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

procedure TfrmConfigureTopProducts.ccbCompanyChange(Sender: TObject);
begin
  btnSave.enabled := false;
  FCompany  := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
  FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
  PopulateCCDeptLocCurrLists;
end;

function TfrmConfigureTopProducts.GetUDF1: WideString;
begin
  result := edtUserDef1.Text;
end;

function TfrmConfigureTopProducts.GetUDF2: WideString;
begin
  result := edtUserDef2.Text;
end;

function TfrmConfigureTopProducts.GetUDF3: WideString;
begin
  result := edtUserDef3.Text;
end;

function TfrmConfigureTopProducts.GetUDF4: WideString;
begin
  result := edtUserDef4.Text;
end;

procedure TfrmConfigureTopProducts.SetUDF1(const Value: WideString);
begin
  edtUserDef1.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF2(const Value: WideString);
begin
  edtUserDef2.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF3(const Value: WideString);
begin
  edtUserDef3.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF4(const Value: WideString);
begin
  edtUserDef4.Text := Value;
end;

procedure TfrmConfigureTopProducts.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureTopProducts.FormActivate(Sender: TObject);
begin
  ofpStock.SetFocus;
end;

function TfrmConfigureTopProducts.GetCurrency: integer;
begin
 result := FCurrency;
end;

procedure TfrmConfigureTopProducts.SetCurrency(const Value: integer);
begin
  FCurrency := Value;
end;

procedure TfrmConfigureTopProducts.ccbCurrencyChange(Sender: TObject);
begin
  FCurrency := StrToInt(ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 1]);
  FCurrSymb := ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 0];
end;

procedure TfrmConfigureTopProducts.seRowsChange(Sender: TObject);
begin
  if seRows.Value < 1 then // if you set a MinVal you must also set MaxValue (and MinVal = 0 means no minimum)
    seRows.Value := 1;     // so need to control minimum value manually
end;

procedure TfrmConfigureTopProducts.AdvGlowButton1Click(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

procedure TfrmConfigureTopProducts.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureTopProducts.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmConfigureTopProducts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

function TfrmConfigureTopProducts.GetUDF10: WideString;
begin
  result := edtUserDef10.Text;
end;

function TfrmConfigureTopProducts.GetUDF5: WideString;
begin
  result := edtUserDef5.Text;
end;

function TfrmConfigureTopProducts.GetUDF6: WideString;
begin
  result := edtUserDef6.Text;
end;

function TfrmConfigureTopProducts.GetUDF7: WideString;
begin
  result := edtUserDef7.Text;
end;

function TfrmConfigureTopProducts.GetUDF8: WideString;
begin
  result := edtUserDef8.Text;
end;

function TfrmConfigureTopProducts.GetUDF9: WideString;
begin
  result := edtUserDef9.Text;
end;

procedure TfrmConfigureTopProducts.SetUDF10(const Value: WideString);
begin
  edtUserDef10.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF5(const Value: WideString);
begin
  edtUserDef5.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF6(const Value: WideString);
begin
  edtUserDef6.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF7(const Value: WideString);
begin
  edtUserDef7.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF8(const Value: WideString);
begin
  edtUserDef8.Text := Value;
end;

procedure TfrmConfigureTopProducts.SetUDF9(const Value: WideString);
begin
  edtUserDef9.Text := Value;
end;

end.
