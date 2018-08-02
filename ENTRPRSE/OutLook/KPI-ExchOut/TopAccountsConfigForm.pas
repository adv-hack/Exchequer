unit TopAccountsConfigForm;

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


{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvMenus,
  AdvMenuStylers, GradientLabel, AdvGlowButton, AdvSpin, htmlbtns, Mask,
  AdvOfficePager, AdvPanel, AdvOfficePagerStylers, AdvCombo, ColCombo,
  rtflabel, Enterprise01_TLB, ComObj, ActiveX, AdvEdit, KPICommon;

type
  TfrmConfigureTopAccounts = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpCustSupp: TAdvOfficePage;
    Label3: TLabel;
    gbFilters: TGroupBox;
    lblDbServer: TLabel;
    lbServiceServer: TLabel;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    lblPort: TLabel;
    seRows: TAdvSpinEdit;
    ccbCostCentre: TColumnComboBox;
    edtArea: TAdvEdit;
    edtAcType: TAdvEdit;
    Label1: TLabel;
    Label5: TLabel;
    ccbDepartment: TColumnComboBox;
    ccbCompany: TColumnComboBox;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label9: TLabel;
    ccbCurrency: TColumnComboBox;
    lblUserDef1: TLabel;
    lblUserDef2: TLabel;
    lblUserDef3: TLabel;
    lblUserDef4: TLabel;
    edtUserDef1: TAdvEdit;
    edtUserDef4: TAdvEdit;
    edtUserDef2: TAdvEdit;
    edtUserDef3: TAdvEdit;
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
    procedure advPanelDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edtUserDef1Enter(Sender: TObject);
    procedure ccbCompanyChange(Sender: TObject);
    procedure ccbCurrencyChange(Sender: TObject);
    procedure seRowsChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCanClose: boolean;
    FCompany: ShortString;
    FCustSupp: WideString;
    FDataPath: WideString;
    FCostCentre: ShortString;
    FDepartment: ShortString;
    FNetworkName: string;
    FUserName: WideString;
    F1: boolean;
    FCount: integer;
    FCurrency: integer;
    FCurrSymb: WideString;
    Function  GetCompany : ShortString;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    Function  GetRows : SmallInt;
    Procedure SetRows (Value : SmallInt);
    function  GetAcType: WideString;
    function  GetArea: WideString;
    procedure SetAcType(const Value: WideString);
    procedure SetArea(const Value: WideString);
    function  GetCostCentre: WideString;
    function  GetDept: WideString;
    function  GetUDF1: WideString;
    function  GetUDF2: WideString;
    function  GetUDF3: WideString;
    function  GetUDF4: WideString;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
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

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    procedure SetUDF5(const Value: WideString);
    procedure SetUDF6(const Value: WideString);
    procedure SetUDF7(const Value: WideString);
    procedure SetUDF8(const Value: WideString);
    procedure SetUDF9(const Value: WideString);
    procedure SetUDF10(const Value: WideString);

    procedure PopulateLists;
    procedure PopulateCompanyList;
    procedure PopulateCCDeptCurrLists;
    procedure SetCostCentre(const Value: WideString);
    procedure MakeRounded(Control: TWinControl);
    procedure SetCustSupp(const Value: WideString);
    procedure SetUserName(const Value: WideString);
    procedure LoadDLL;
    function  GetCurrency: integer;
    procedure SetCurrency(const Value: integer);
    procedure SetDept(const Value: WideString);
  public
    constructor create(DataPath: WideString);
    procedure Startup;
    Property Company :   ShortString Read GetCompany Write SetCompany;
    property Currency:   integer    read GetCurrency write SetCurrency;
    property CurrSymb:   WideString read FCurrSymb write FCurrSymb;
    property CustSupp:   WideString read FCustSupp write SetCustSupp;
    Property Host :      HWND Write SetHost;
    Property Rows :      SmallInt Read GetRows Write SetRows;
    property AcType:     WideString read GetAcType write SetAcType;
    property Area:       WideString read GetArea write SetArea;
    property CostCentre: WideString read GetCostCentre write SetCostCentre;
    property Dept:       WideString read GetDept write SetDept;
    property UDF1:       WideString read GetUDF1 write SetUDF1;
    property UDF2:       WideString read GetUDF2 write SetUDF2;
    property UDF3:       WideString read GetUDF3 write SetUDF3;
    property UDF4:       WideString read GetUDF4 write SetUDF4;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    property UDF5:       WideString read GetUDF5 write SetUDF5;
    property UDF6:       WideString read GetUDF6 write SetUDF6;
    property UDF7:       WideString read GetUDF7 write SetUDF7;
    property UDF8:       WideString read GetUDF8 write SetUDF8;
    property UDF9:       WideString read GetUDF9 write SetUDF9;
    property UDF10:      WideString read GetUDF10 write SetUDF10;
    
    property UserName:   WideString read FUserName write SetUserName;
  protected
  end;

implementation

uses CTKUtil;

{$R *.dfm}

type
  TWinPos = Record
    wpLeft, wpTop, wpWidth, wpHeight : LongInt;
  End;

  TExecutePlugin = function(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos;
                       var bResult, bShown : boolean; bValidate : boolean = FALSE): string; stdcall;
  TOpenFiles     = function(asPath : ANSIString) : boolean; stdcall;
  TCloseFiles    = procedure; stdcall;
  
var
  FDLLHandle:    THandle;
  ExecutePlugin: TExecutePlugin;
  OpenFiles:     TOpenFiles;
  CloseFiles:    TCloseFiles;


//{EXTERNAL FUNCTIONS LOCATED IN USRFDLG.DLL}
//function ExecutePlugIn(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos;
//                       var bResult, bShown : boolean; bValidate : boolean = FALSE): string; stdCall; external 'USRFDLG.DLL';

//=========================================================================

procedure TfrmConfigureTopAccounts.FormCreate(Sender: TObject);
var
  buffer: array[0..20] of char;
  buflen: cardinal;
begin
  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height - - Self.Height) Div 2;
  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
  buflen := 20;
  GetUserName(buffer, buflen);
  FNetworkName := string(buffer);
end;

//-------------------------------------------------------------------------

function TfrmConfigureTopAccounts.GetCompany: ShortString;
begin
  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;
procedure TfrmConfigureTopAccounts.SetCompany(Value: ShortString);
begin
  FCompany := Value;
end;

//------------------------------

Procedure TfrmConfigureTopAccounts.SetHost (Value : HWND);
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

function TfrmConfigureTopAccounts.GetRows: SmallInt;
begin
  Result := seRows.Value;
end;
procedure TfrmConfigureTopAccounts.SetRows(Value: SmallInt);
begin
  seRows.Value := Value;
end;

//-------------------------------------------------------------------------

function TfrmConfigureTopAccounts.GetAcType: WideString;
begin
  result := edtAcType.text;
end;

function TfrmConfigureTopAccounts.GetArea: WideString;
begin
  result := edtArea.Text;
end;

procedure TfrmConfigureTopAccounts.SetAcType(const Value: WideString);
begin
  edtAcType.Text := Value;
end;

procedure TfrmConfigureTopAccounts.SetArea(const Value: WideString);
begin
  edtArea.Text := Value;
end;

function TfrmConfigureTopAccounts.GetCostCentre: WideString;
begin
  result := ccbCostCentre.ColumnItems[ccbCostCentre.ItemIndex, 0];
  if result = '<none>' then result := '';
end;

function TfrmConfigureTopAccounts.GetDept: WideString;
begin
  result := ccbDepartment.ColumnItems[ccbDepartment.ItemIndex, 0];
  if result = '<none>' then result := '';
end;

function TfrmConfigureTopAccounts.GetUDF1: WideString;
begin
  result := edtUserDeF1.Text;
end;

function TfrmConfigureTopAccounts.GetUDF2: WideString;
begin
  result := edtUserDeF2.Text;
end;

function TfrmConfigureTopAccounts.GetUDF3: WideString;
begin
  result := edtUserDeF3.Text;
end;

function TfrmConfigureTopAccounts.GetUDF4: WideString;
begin
  result := edtUserDeF4.Text;
end;

procedure TfrmConfigureTopAccounts.SetCostCentre(const Value: WideString);
begin
  if Value = '' then
    FCostCentre := '<none>'
  else
    FCostCentre := value;
end;

procedure TfrmConfigureTopAccounts.SetDept(const Value: WideString);
begin
  if Value = '' then
    FDepartment := '<none>'
  else
    FDepartment := Value;
end;

procedure TfrmConfigureTopAccounts.SetUDF1(const Value: WideString);
begin
  edtUserDeF1.Text := value;
end;

procedure TfrmConfigureTopAccounts.SetUDF2(const Value: WideString);
begin
  edtUserDeF2.Text := value;
end;

procedure TfrmConfigureTopAccounts.SetUDF3(const Value: WideString);
begin
  edtUserDeF3.Text := value;
end;

procedure TfrmConfigureTopAccounts.SetUDF4(const Value: WideString);
begin
  edtUserDeF4.Text := value;
end;

constructor TfrmConfigureTopAccounts.create(DataPath: WideString);
begin
  inherited create(nil);
  DataPath  := trim(DataPath);
  FDataPath := DataPath;
end;

procedure TfrmConfigureTopAccounts.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureTopAccounts.Startup;
begin
  lblInfo.Caption := self.Caption;
  ofpCustSupp.Caption := FCustSupp + ' Settings';
  PopulateLists;
end;

procedure TfrmConfigureTopAccounts.PopulateLists;
begin
  PopulateCompanyList;
  PopulateCCDeptCurrLists;
end;

procedure TfrmConfigureTopAccounts.PopulateCompanyList;
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

procedure TfrmConfigureTopAccounts.PopulateCCDeptCurrLists;
var
  toolkit: IToolkit;
  i : SmallInt;
  CCDept: ICCDept;
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
    ccbCostCentre.Clear;
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

    ccbDepartment.Clear;
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
      lblUserDef1.Caption  := ufCustDesc[1];
      lblUserDef2.Caption  := ufCustDesc[2];
      lblUserDef3.Caption  := ufCustDesc[3];
      lblUserDef4.Caption  := ufCustDesc[4];
      lblUserDef5.Caption  := ufCustDesc[5];
      lblUserDef6.Caption  := ufCustDesc[6];
      lblUserDef7.Caption  := ufCustDesc[7];
      lblUserDef8.Caption  := ufCustDesc[8];
      lblUserDef9.Caption  := ufCustDesc[9];
      lblUserDef10.Caption := ufCustDesc[10];
    end;

  finally
    toolkit := nil;
  end;
  btnSave.enabled := true;
end;

procedure TfrmConfigureTopAccounts.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureTopAccounts.FormActivate(Sender: TObject);
begin
  ofpCustSupp.SetFocus;
end;

procedure TfrmConfigureTopAccounts.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureTopAccounts.MakeRounded(Control: TWinControl);
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

procedure TfrmConfigureTopAccounts.SetCustSupp(const Value: WideString);
begin
  FCustSupp := Value;
end;

procedure TfrmConfigureTopAccounts.edtUserDef1Enter(Sender: TObject);
// this event has been detached from the user-def field edit boxes
// until the Sharemem issue has been resolved.
var
  WinPos: TWinPos;
  res: boolean;
  shown: boolean;
  CSuser: string;
  BoxCaption: string;
begin
  LoadDLL;
  WinPos.wpLeft   := self.Left + 20;
  WinPos.wpTop    := self.Top  + 20;
  WinPos.wpWidth  := 200;
  WinPos.wpHeight := 200;
  case CustSupp[1] of
    'C': CSuser := 'CustUser';
    'S': CSuser := 'SuppUser';
  end;
  with TAdvEdit(Sender) do begin
    case tag of
      1: BoxCaption := lblUserDef1.Caption;
      2: BoxCaption := lblUserDef2.Caption;
      3: BoxCaption := lblUserDef3.Caption;
      4: BoxCaption := lblUserDef4.Caption;
    end;
    CSuser := CSuser + IntToStr(Tag); // e.g. CustUser1
    Text := ExecutePlugin(CSuser, Text, BoxCaption, FDataPath, FUserName, WinPos, res, shown, false);
  end;
end;

procedure TfrmConfigureTopAccounts.SetUserName(const Value: WideString);
begin
  FUserName := Value;
end;

procedure TfrmConfigureTopAccounts.LoadDLL;
// the user-def field plug-in functionality is currently disabled because
// it uses Sharemem which causes Outlook to crash on Exit.
// As a result, the LoadLibrary command below has been left in its original
// test state.
begin
  if FDLLhandle = 0 then begin
    FDLLHandle := LoadLibrary('c:\ent571\usrfdlg.dll');
    if FDLLHandle = 0 then
      ShowMessage('Cannot load UserDef library')
    else begin
       OpenFiles     := GetProcAddress(FDLLHandle, 'OpenFiles');
       ExecutePlugin := GetProcAddress(FDLLHandle, 'ExecutePlugIn');
       CloseFiles    := GetProcAddress(FDLLHandle, 'CloseFiles');
       OpenFiles(FDataPath);
    end;
  end;
end;

procedure TfrmConfigureTopAccounts.ccbCompanyChange(Sender: TObject);
begin
  btnSave.enabled := false; // until the currency list has been built
  FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
  PopulateCCDeptCurrLists;
end;

function TfrmConfigureTopAccounts.GetCurrency: integer;
begin
 result := FCurrency;
end;

procedure TfrmConfigureTopAccounts.SetCurrency(const Value: integer);
begin
  FCurrency := Value;
end;

procedure TfrmConfigureTopAccounts.ccbCurrencyChange(Sender: TObject);
begin
  FCurrency := StrToInt(ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 1]);
  FCurrSymb := ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 0];
end;

procedure TfrmConfigureTopAccounts.seRowsChange(Sender: TObject);
begin
  if seRows.Value < 1 then // if you set a MinVal you must also set MaxValue (and MinVal = 0 means no minimum)
    seRows.Value := 1;     // so need to control minimum value manually
end;

procedure TfrmConfigureTopAccounts.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

procedure TfrmConfigureTopAccounts.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmConfigureTopAccounts.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

{ CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
function TfrmConfigureTopAccounts.GetUDF10: WideString;
begin
  result := edtUserDef10.Text;
end;

function TfrmConfigureTopAccounts.GetUDF5: WideString;
begin
  result := edtUserDef5.Text;
end;

function TfrmConfigureTopAccounts.GetUDF6: WideString;
begin
  result := edtUserDef6.Text;
end;

function TfrmConfigureTopAccounts.GetUDF7: WideString;
begin
  result := edtUserDef7.Text;
end;

function TfrmConfigureTopAccounts.GetUDF8: WideString;
begin
  result := edtUserDef8.Text;
end;

function TfrmConfigureTopAccounts.GetUDF9: WideString;
begin
  result := edtUserDef9.Text;
end;

procedure TfrmConfigureTopAccounts.SetUDF10(const Value: WideString);
begin
  edtUserDef10.Text := Value;
end;

procedure TfrmConfigureTopAccounts.SetUDF5(const Value: WideString);
begin
  edtUserDef5.Text := Value;
end;

procedure TfrmConfigureTopAccounts.SetUDF6(const Value: WideString);
begin
  edtUserDef6.Text := Value;
end;

procedure TfrmConfigureTopAccounts.SetUDF7(const Value: WideString);
begin
  edtUserDef7.Text := Value;
end;

procedure TfrmConfigureTopAccounts.SetUDF8(const Value: WideString);
begin
  edtUserDef8.Text := Value;
end;

procedure TfrmConfigureTopAccounts.SetUDF9(const Value: WideString);
begin
  edtUserDef9.Text := Value;
end;

initialization
  FDLLHandle := 0;

finalization
  if FDLLHandle <> 0 then begin
    CloseFiles;
    FreeLibrary(FDLLHandle);
  end;
end.
