unit TimesheetEntryForm;

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
  rtflabel, Enterprise01_TLB, ComObj, ActiveX, AdvEdit, KPICommon, TTimesheetDataClass, Math;

type
  TfrmEnterTimesheets = class(TForm)
    advPanel: TAdvPanel;
    btnCloseCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpCustSupp: TAdvOfficePage;
    gbTransactionLine1: TGroupBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    ccbCostCentre1: TColumnComboBox;
    lblNarrative: TLabel;
    ccbDepartment1: TColumnComboBox;
    edtNarrative1: TAdvEdit;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    gbTransactionHeader: TGroupBox;
    lblRateAnalysisCodes: TLabel;
    ccbRateCode1: TColumnComboBox;
    ccbAnalysisCode1: TColumnComboBox;
    AdvOfficePage1: TAdvOfficePage;
    gbTotals: TGroupBox;
    btnScrollUp: TAdvGlowButton;
    btnScrollDn: TAdvGlowButton;
    lblJobCode: TLabel;
    ccbJobCode1: TColumnComboBox;
    lblDayA1: TLabel;
    lblDayB1: TLabel;
    lblDayC1: TLabel;
    lblDayD1: TLabel;
    lblDayE1: TLabel;
    lblDayF1: TLabel;
    lblDayG1: TLabel;
    edtDayA1: TAdvEdit;
    edtDayB1: TAdvEdit;
    edtDayC1: TAdvEdit;
    edtDayD1: TAdvEdit;
    edtDayE1: TAdvEdit;
    edtDayF1: TAdvEdit;
    edtDayG1: TAdvEdit;
    lblDateA1: TLabel;
    lblDateB1: TLabel;
    lblDateC1: TLabel;
    lblDateD1: TLabel;
    lblDateE1: TLabel;
    lblDateF1: TLabel;
    lblDateG1: TLabel;
    edtHrsQty1: TAdvEdit;
    lblHrsQty1: TLabel;
    edtChargeOutRate1: TAdvEdit;
    edtCostHour1: TAdvEdit;
    lblChargeOutCurrency1: TLabel;
    lblCostHourCurrency1: TLabel;
    lblChargeOutRate1: TLabel;
    lblCostHour1: TLabel;
    edtTLUDF11: TAdvEdit;
    edtTLUDF21: TAdvEdit;
    lblTLUDF11: TLabel;
    lblTLUDF21: TLabel;
    cbDelete1: TCheckBox;
    lblDesc: TLabel;
    edtDesc: TAdvEdit;
    lblDate: TLabel;
    edtDate: TAdvEdit;
    lblPerYr: TLabel;
    edtPrYr: TAdvEdit;
    lblWkMonth: TLabel;
    edtWkMonth: TAdvEdit;
    cbWeekCommencing: TCheckBox;
    lblWC: TLabel;
    lblTHUDF1: TLabel;
    edtTHUDF1: TAdvEdit;
    lblTHUDF2: TLabel;
    edtTHUDF2: TAdvEdit;
    lblTHUDF3: TLabel;
    edtTHUDF3: TAdvEdit;
    lblTHUDF4: TLabel;
    edtTHUDF4: TAdvEdit;
    edtTotChargeOutRate: TAdvEdit;
    edtTotCostHour: TAdvEdit;
    lblTotalCostHourCurrency: TLabel;
    lblTotalChargeOutRateCurrency: TLabel;
    edtTotDayA: TAdvEdit;
    edtTotDayB: TAdvEdit;
    edtTotDayC: TAdvEdit;
    edtTotDayD: TAdvEdit;
    edtTotDayE: TAdvEdit;
    edtTotDayF: TAdvEdit;
    edtTotDayG: TAdvEdit;
    lblTimesheetStatus: TLabel;
    ccbTimesheetStatus: TColumnComboBox;
    edtTotHrsQty: TAdvEdit;
    lblTotHrsQty: TLabel;
    btnSave: TAdvGlowButton;
    btnCancel: TAdvGlowButton;
    btnAdd: TAdvGlowButton;
    btnDelete: TAdvGlowButton;
    gbTransactionLine2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblDayA2: TLabel;
    lblDayB2: TLabel;
    lblDayC2: TLabel;
    lblDayD2: TLabel;
    lblDayE2: TLabel;
    lblDayF2: TLabel;
    lblDayG2: TLabel;
    lblDateA2: TLabel;
    lblDateB2: TLabel;
    lblDateC2: TLabel;
    lblDateD2: TLabel;
    lblDateE2: TLabel;
    LabelF2: TLabel;
    lblDateG2: TLabel;
    lblHrsQty2: TLabel;
    lblChargeOutCurrency2: TLabel;
    lblCostHourCurrency2: TLabel;
    lblChargeOutRate2: TLabel;
    lblCostHour2: TLabel;
    lblTLUDF12: TLabel;
    lblTLUDF22: TLabel;
    ccbCostCentre2: TColumnComboBox;
    ccbDepartment2: TColumnComboBox;
    edtNarrative2: TAdvEdit;
    ccbRateCode2: TColumnComboBox;
    ccbAnalysisCode2: TColumnComboBox;
    ccbJobCode2: TColumnComboBox;
    edtDayA2: TAdvEdit;
    edtDayB2: TAdvEdit;
    edtDayC2: TAdvEdit;
    edtDayD2: TAdvEdit;
    edtDayE2: TAdvEdit;
    edtDayF2: TAdvEdit;
    edtDayG2: TAdvEdit;
    edtHrsQty2: TAdvEdit;
    edtChargeOutRate2: TAdvEdit;
    edtCostHour2: TAdvEdit;
    edtTLUDF12: TAdvEdit;
    edtTLUDF22: TAdvEdit;
    cbDelete2: TCheckBox;
    lblLine1: TLabel;
    lblLine2: TLabel;
    lblLineCount: TLabel;
    GroupBox1: TGroupBox;
    Label25: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    AdvEdit14: TAdvEdit;
    AdvEdit15: TAdvEdit;
    AdvEdit16: TAdvEdit;
    AdvEdit17: TAdvEdit;
    CheckBox2: TCheckBox;
    AdvEdit18: TAdvEdit;
    AdvEdit19: TAdvEdit;
    AdvEdit20: TAdvEdit;
    AdvEdit21: TAdvEdit;
    ColumnComboBox6: TColumnComboBox;
    GroupBox2: TGroupBox;
    AdvEdit22: TAdvEdit;
    AdvEdit23: TAdvEdit;
    CheckBox3: TCheckBox;
    AdvEdit24: TAdvEdit;
    Label26: TLabel;
    ColumnComboBox7: TColumnComboBox;
    CheckBox4: TCheckBox;
    Label36: TLabel;
    AdvEdit25: TAdvEdit;
    Label37: TLabel;
    GroupBox3: TGroupBox;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    AdvGlowButton4: TAdvGlowButton;
    AdvGlowButton5: TAdvGlowButton;
    AdvGlowButton6: TAdvGlowButton;
    GroupBox4: TGroupBox;
    Label38: TLabel;
    lbOurRef: TListBox;
    Label39: TLabel;
    lbDescription: TListBox;
    Label40: TLabel;
    lbDate: TListBox;
    procedure advPanelDblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnScrollDnClick(Sender: TObject);
    procedure btnScrollUpClick(Sender: TObject);
    procedure cbDelete1Click(Sender: TObject);
    procedure edtDayA1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtHrsQty1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCanClose: boolean;
    FCompany: ShortString;
    FDataPath: WideString;
    FNetworkName: string;
    FCount: integer;
    FCurrency: integer;
    FCurrSymb: WideString;
    FEmployeeID: WideString;
    FOurRef: WideString;
    FTimesheetData: TTimesheetData;
    FCurrentLineNo: integer;
    procedure DisplayTimesheetHeader;
    procedure DisplayTimesheetLines;
    Function  GetCompany : ShortString;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    procedure PopulateLists;
    procedure PopulateCCDeptCurrLists;
    procedure MakeRounded(Control: TWinControl);
    function  GetCurrency: integer;
    procedure SetCurrency(const Value: integer);
    procedure DisplayLine(ATimesheetLine: TTimesheetLine; WhichBox, ALineNo: integer);
    procedure DisableDayBoxes(TheParent: TWinControl);
  public
    constructor create(ADataPath: WideString; AnEmployeeID: WideString; AnOurRef: WideString);
    destructor destroy; override;
    procedure Startup;
    Property Company :   ShortString Read GetCompany Write SetCompany;
    property Currency:   integer    read GetCurrency write SetCurrency;
    property CurrSymb:   WideString read FCurrSymb write FCurrSymb;
    Property Host :      HWND Write SetHost;
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

procedure TfrmEnterTimesheets.FormCreate(Sender: TObject);
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

function TfrmEnterTimesheets.GetCompany: ShortString;
begin
//  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;
procedure TfrmEnterTimesheets.SetCompany(Value: ShortString);
begin
  FCompany := Value;
end;

//------------------------------

Procedure TfrmEnterTimesheets.SetHost (Value : HWND);
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

constructor TfrmEnterTimesheets.create(ADataPath: WideString; AnEmployeeID: WideString; AnOurRef: WideString);
begin
  inherited create(nil);
  FDataPath   := trim(ADataPath);
  FEmployeeID := AnEmployeeID;
  FOurRef     := AnOurRef;
end;

procedure TfrmEnterTimesheets.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmEnterTimesheets.btnAddClick(Sender: TObject);
begin
  // smoke and mirrors
  
end;

procedure TfrmEnterTimesheets.Startup;
begin
  lblInfo.Caption := format('Timesheet Data Entry [%s]', [FEmployeeID]); 
  FTimesheetData := TTimesheetData.Create(FDataPath, FEmployeeID);
  FTimesheetData.LocateTimesheet(FOurRef);
  FCurrentLineNo := 0;
  DisplayTimesheetHeader;
  DisplayTimesheetLines;
  PopulateLists;
end;

procedure TfrmEnterTimesheets.PopulateLists;
begin
  PopulateCCDeptCurrLists;
end;

procedure TfrmEnterTimesheets.PopulateCCDeptCurrLists;
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
    ccbCostCentre1.Clear;
    with ccbCostCentre1.ComboItems.Add do begin
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
            with ccbCostCentre1.ComboItems.Add do begin
              strings.Add(trim(cdCode));
              strings.Add(trim(cdName));
            end;
            res := GetNext;
          end;
        end;
        ccbCostCentre1.ItemIndex := ccbCostCentre1.ComboItems.IndexInColumnOf(0, '');
      finally
        CCDept := nil;
      end;
    end;

    ccbDepartment1.Clear;
    with ccbDepartment1.ComboItems.Add do begin
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
            with ccbDepartment1.ComboItems.Add do begin
              strings.Add(trim(cdCode));
              strings.Add(trim(cdName));
            end;
            res := GetNext;
          end;
        end;
        ccbDepartment1.ItemIndex := ccbDepartment1.ComboItems.IndexInColumnOf(0, '');
      finally
        CCDept := nil;
      end;
    end;


  finally
    toolkit := nil;
  end;
  btnSave.enabled := true;
end;

procedure TfrmEnterTimesheets.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmEnterTimesheets.FormActivate(Sender: TObject);
begin
  ofpCustSupp.SetFocus;
end;

procedure TfrmEnterTimesheets.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmEnterTimesheets.MakeRounded(Control: TWinControl);
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

function TfrmEnterTimesheets.GetCurrency: integer;
begin
  result := FCurrency;
end;

procedure TfrmEnterTimesheets.SetCurrency(const Value: integer);
begin
  FCurrency := Value;
end;

procedure TfrmEnterTimesheets.btnCloseCancelClick(Sender: TObject);
begin
//  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

procedure TfrmEnterTimesheets.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmEnterTimesheets.btnScrollDnClick(Sender: TObject);
begin
  DisplayTimesheetLines;
end;

procedure TfrmEnterTimesheets.btnScrollUpClick(Sender: TObject);
begin
  FCurrentLineNo := FCurrentLineNo - 3;
  DisplayTimesheetLines;
end;

procedure TfrmEnterTimesheets.cbDelete1Click(Sender: TObject);
begin
  if cbDelete1.Checked then begin
    gbTransactionLine1.Caption := '  ! This line has been marked for deletion  ';
    gbTransactionLine1.Font.Color := clRed;
    btnDelete.Enabled := true;
  end
  else begin
    gbTransactionLine1.Caption := ' The Royal Bath Hotel / General Rate / Electrical Engineer ';
    gbTransactionLine1.Font.Color := clBlack;
    btnDelete.Enabled := false;
  end;
end;

procedure TfrmEnterTimesheets.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

destructor TfrmEnterTimesheets.destroy;
begin
  if FTimesheetData <> nil then
    FTimesheetData.Free;
  inherited;
end;

procedure TfrmEnterTimesheets.DisplayLine(ATimesheetLine: TTimesheetLine; WhichBox: integer; ALineNo: integer);
begin

  with ATimesheetLine do begin
    TAdvEdit(ifthen(WhichBox = 1, integer(edtNarrative1), integer(edtNarrative2))).Text := Narrative;
  end;

end;

procedure TfrmEnterTimesheets.DisplayTimesheetLines;
// display the next one or two lines depending on how many we've got
begin
  try
    if FTimesheetData.Timesheet = nil then begin
      lblLineCount.Caption := '0 Lines';
      EXIT;
    end
    else
      lblLineCount.Caption := IntToStr(FTimesheetData.Timesheet.TimesheetLineCount) + ' Lines';

    if FCurrentLineNo >= FTimesheetData.Timesheet.TimesheetLineCount then begin
      gbTransactionLine1.Visible := false;
      gbTransactionLine2.Visible := false;
      lblLine1.Visible           := false;
      lblLine2.Visible           := false;
      EXIT;
    end;

    inc(FCurrentLineNo);

    FTimesheetData.Timesheet.LocateLine(FCurrentLineNo);

    if FTimesheetData.Timesheet.CurrentLine <> nil then begin
      DisplayLine(FTimesheetData.Timesheet.CurrentLine, 1, FCurrentLineNo);
      gbTransactionLine1.Visible := true;
      lblLine1.Caption := IntToStr(FCurrentLineNo);
      lblLine1.Visible := true;
    end
    else begin
      gbTransactionLine1.Visible := false;
      lblLine1.Visible           := false;
    end;

    if FCurrentLineNo >= FTimesheetData.Timesheet.TimesheetLineCount then begin
      gbTransactionLine2.Visible := false;
      lblLine2.Visible           := false;
      EXIT;
    end;

    inc(FCurrentLineNo);

    FTimesheetData.Timesheet.LocateLine(FCurrentLineNo);

    if FTimesheetData.Timesheet.CurrentLine <> nil then begin
      DisplayLine(FTimesheetData.Timesheet.CurrentLine, 2, FCurrentLineNo);
      gbTransactionLine2.Visible := true;
      lblLine2.Caption := IntToStr(FCurrentLineNo);
      lblLine2.Visible := true;
    end
    else begin
      gbTransactionLine2.Visible := false;
      lblLine2.Visible           := false;
    end;
  finally
    btnScrollUp.Enabled := FCurrentLineNo > 2;
    btnScrollDn.Enabled := (FTimesheetData.Timesheet <> nil) and (FCurrentLineNo < FTimesheetData.Timesheet.TimesheetLineCount);
  end;
end;

procedure TfrmEnterTimesheets.DisplayTimesheetHeader;
begin
  if FTimesheetData.Timesheet = nil then EXIT;
  with FTimesheetData.Timesheet do begin
    edtDesc.Text := Description;
    edtTHUDF1.Text := UserField1;
    edtTHUDF2.Text := UserField2;
    edtTHUDF3.Text := UserField3;
    edtTHUDF4.Text := UserField4;
  end;
end;

procedure TfrmEnterTimesheets.DisableDayBoxes(TheParent: TWinControl);
var
  i: integer;
  ItsName: string;
begin
  for i := 0 to TWinControl(TheParent).ControlCount - 1 do begin
    ItsName := TheParent.Controls[i].Name;
    if copy(ItsName, 1, 6) = 'edtDay' then begin
      TAdvEdit(TheParent.Controls[i]).Text := '';
      TAdvEdit(TheParent.Controls[i]).Enabled := false;
    end;
  end;
end;

procedure TfrmEnterTimesheets.edtDayA1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if trim(TAdvEdit(Sender).Text) <> '' then
    if TComponent(Sender).GetParentComponent = gbTransactionLine1 then begin
      edtHrsQty1.Text := '';
      edtHrsQty1.Enabled := false;
    end
    else begin
      edtHrsQty2.Text := '';
      edtHrsQty2.Enabled := false;
    end;
end;

procedure TfrmEnterTimesheets.edtHrsQty1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if trim(TAdvEdit(Sender).Text) <> '' then
    DisableDayBoxes(TWinControl(TComponent(Sender).GetParentComponent));
end;

initialization
  FDLLHandle := 0;

finalization
  if FDLLHandle <> 0 then begin
    CloseFiles;
    FreeLibrary(FDLLHandle);
  end;
end.
