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
  rtflabel, Enterprise01_TLB, ComObj, ActiveX, AdvEdit, KPICommon, TTimesheetDataClass, Math,
  TimesheetLineFrame, TTimesheetIniClass, TNoteDataClass, TEmployeeRateClass,
  DBAdvEd, ImgList;

type
  TfrmEnterTimesheets = class(TForm)
    advPanel: TAdvPanel;
    btnCloseCancel: TAdvGlowButton;
    ofPager: TAdvOfficePager;
    opTimesheet: TAdvOfficePage;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    gbTransactionHeader: TGroupBox;
    opNotes: TAdvOfficePage;
    gbTotals: TGroupBox;
    btnScrollUp: TAdvGlowButton;
    btnScrollDn: TAdvGlowButton;
    lblDesc: TLabel;
    edtDesc: TAdvEdit;
    lblDate: TLabel;
    edtDate: TAdvMaskEdit;
    lblPerYr: TLabel;
    edtPrYr: TAdvMaskEdit;
    lblWkMonth: TLabel;
    edtWkMonth: TAdvEdit;
    cbWeekCommencing: TCheckBox;
    lblWC: TLabel;
    edtTotChargeOutRate: TAdvEdit;
    edtTotCostHour: TAdvEdit;
    xlblTotalCostHourCurrency: TLabel;
    xlblTotalChargeOutRateCurrency: TLabel;
    edtTotDay1: TAdvEdit;
    edtTotDay2: TAdvEdit;
    edtTotDay3: TAdvEdit;
    edtTotDay4: TAdvEdit;
    edtTotDay5: TAdvEdit;
    edtTotDay6: TAdvEdit;
    edtTotDay7: TAdvEdit;
    lblTimesheetStatus: TLabel;
    ccbTimesheetStatus: TColumnComboBox;
    edtTotHrsQty: TAdvEdit;
    lblTotHrsQty: TLabel;
    btnSave: TAdvGlowButton;
    btnAddLine: TAdvGlowButton;
    btnDelete: TAdvGlowButton;
    lblLine1: TLabel;
    lblLine2: TLabel;
    lblLineCount: TLabel;
    gbNotesHeader: TGroupBox;
    Label25: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label35: TLabel;
    edtNoteHDesc: TAdvEdit;
    edtNoteHDate: TAdvEdit;
    edtNoteHPrYr: TAdvEdit;
    edtNoteHWkMonth: TAdvEdit;
    cbNoteHWC: TCheckBox;
    ccbNoteTimesheetStatus: TColumnComboBox;
    gbEditNote: TGroupBox;
    edtNoteText: TAdvEdit;
    edtNoteDate: TAdvEdit;
    cbShowNoteDate: TCheckBox;
    edtNoteAlarmDate: TAdvEdit;
    Label26: TLabel;
    ccbNoteUserProfile: TColumnComboBox;
    cbNoteAlarmed: TCheckBox;
    Label36: TLabel;
    edtNoteDays: TAdvEdit;
    lblNoteDays: TLabel;
    GroupBox3: TGroupBox;
    btnSaveNote: TAdvGlowButton;
    btnCancelNote: TAdvGlowButton;
    btnAddNote: TAdvGlowButton;
    btnEditNote: TAdvGlowButton;
    btnDeleteNote: TAdvGlowButton;
    btnSwitchNoteView: TAdvGlowButton;
    gbNotes: TGroupBox;
    lblNoteDate: TLabel;
    lbNoteDate: TListBox;
    Label39: TLabel;
    lbNoteText: TListBox;
    Label40: TLabel;
    lbNoteUser: TListBox;
    FrameTimesheetLine1: TFrameTimesheetLine;
    FrameTimesheetLine2: TFrameTimesheetLine;
    ccbEvery: TColumnComboBox;
    ImageList1: TImageList;
    TSHScrollBox: TScrollBox;
    lblTHUDF1: TLabel;
    lblTHUDF3: TLabel;
    edtTHUDF1: TAdvEdit;
    edtTHUDF3: TAdvEdit;
    lblTHUDF2: TLabel;
    lblTHUDF4: TLabel;
    edtTHUDF2: TAdvEdit;
    edtTHUDF4: TAdvEdit;
    edtTHUDF6: TAdvEdit;
    lblTHUDF6: TLabel;
    lblTHUDF5: TLabel;
    edtTHUDF5: TAdvEdit;
    lblTHUDF7: TLabel;
    lblTHUDF8: TLabel;
    edtTHUDF7: TAdvEdit;
    edtTHUDF8: TAdvEdit;
    lblTHUDF9: TLabel;
    lblTHUDF10: TLabel;
    edtTHUDF9: TAdvEdit;
    edtTHUDF10: TAdvEdit;
    NotesScrollBox: TScrollBox;
    lblNoteTHUDF1: TLabel;
    lblNoteTHUDF3: TLabel;
    lblNoteTHUDF2: TLabel;
    lblNoteTHUDF4: TLabel;
    lblNoteTHUDF6: TLabel;
    lblNoteTHUDF5: TLabel;
    lblNoteTHUDF7: TLabel;
    lblNoteTHUDF8: TLabel;
    lblNoteTHUDF9: TLabel;
    lblNoteTHUDF10: TLabel;
    edtNoteTHUDF1: TAdvEdit;
    edtNoteTHUDF3: TAdvEdit;
    edtNoteTHUDF2: TAdvEdit;
    edtNoteTHUDF4: TAdvEdit;
    edtNoteTHUDF6: TAdvEdit;
    edtNoteTHUDF5: TAdvEdit;
    edtNoteTHUDF7: TAdvEdit;
    edtNoteTHUDF8: TAdvEdit;
    edtNoteTHUDF9: TAdvEdit;
    edtNoteTHUDF10: TAdvEdit;
    lblOriginator: TLabel;
    procedure advPanelDblClick(Sender: TObject);
    procedure btnAddLineClick(Sender: TObject);
    procedure btnAddNoteClick(Sender: TObject);
    procedure btnCancelNoteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditNoteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveNoteClick(Sender: TObject);
    procedure btnScrollDnClick(Sender: TObject);
    procedure btnScrollUpClick(Sender: TObject);
    procedure btnSwitchNoteViewClick(Sender: TObject);
    procedure cbNoteAlarmedClick(Sender: TObject);
    procedure cbShowNoteDateClick(Sender: TObject);
    procedure cbWeekCommencingClick(Sender: TObject);
    procedure ccbEveryChange(Sender: TObject);
    procedure ccbNoteUserProfileChange(Sender: TObject);
    procedure ccbTimesheetStatusChange(Sender: TObject);
    procedure edtDateChange(Sender: TObject);
    procedure edtDateExit(Sender: TObject);
    procedure edtDateKeyPress(Sender: TObject; var Key: Char);
    procedure edtDescChange(Sender: TObject);
    procedure edtNoteAlarmDateChange(Sender: TObject);
    procedure edtNoteDateChange(Sender: TObject);
    procedure edtNoteDateKeyPress(Sender: TObject; var Key: Char);
    procedure edtNoteDaysChange(Sender: TObject);
    procedure edtNoteTextChange(Sender: TObject);
    procedure edtPrYrChange(Sender: TObject);
    procedure edtPrYrKeyPress(Sender: TObject; var Key: Char);
    procedure edtTHUDF1Change(Sender: TObject);
    procedure edtTHUDF2Change(Sender: TObject);
    procedure edtTHUDF3Change(Sender: TObject);
    procedure edtTHUDF4Change(Sender: TObject);
    procedure edtWkMonthChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbNoteDateClick(Sender: TObject);
    procedure lbNoteDateDblClick(Sender: TObject);
    procedure ofPagerChanging(Sender: TObject; FromPage, ToPage: Integer; var AllowChange: Boolean);
    procedure edtTHUDF5Change(Sender: TObject);
    procedure edtTHUDF6Change(Sender: TObject);
    procedure edtTHUDF7Change(Sender: TObject);
    procedure edtTHUDF8Change(Sender: TObject);
    procedure edtTHUDF9Change(Sender: TObject);
    procedure edtTHUDF10Change(Sender: TObject);
  private
    FBoxWasEdited: Boolean;
    FCanClose: boolean;
    FUpdatingNoteDetails: Boolean;
    FCompany: ShortString;
    FDataPath: WideString;
    FNetworkName: string;
    FCount: integer;
    FCurrency: integer;
    FCurrSymb: WideString;
    FEmployeeID: WideString;
    FEmployeeName: WideString;
    FOurRef: WideString;
    FTimesheetData: TTimesheetData;
    FCurrentLineNo: integer;
    FFrames: array[1..2] of TFrameTimesheetLine;
    FLabels: array[1..2] of TLabel;
    FStartup: boolean;
    FOperator: WideString;
    FNoteData: TNoteData;
    FNotesType: TNotesType;
    procedure ChangeButtons;
    procedure ChangeLineCountCaption;
    function  CreateNote: string;
    procedure DisplayTimesheetHeader;
    procedure DisplayTimesheetLines;
    procedure EditNewNote;
    Function  GetCompany : ShortString;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    procedure PopulateLists;
    procedure MakeRounded(Control: TWinControl);
    function  GetCurrency: integer;
    procedure SetCurrency(const Value: integer);
    function  ItsOdd(WhatsOdd: integer): boolean;
    procedure RecalcFooterTotals(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure EditNote(ALineNo: Integer);
    procedure LineChanged(Sender: TObject);
    procedure HideRestrictedControls;
    procedure ReadNotes(ANotesType: TNotesType);
    procedure CopyNoteFields(ANote: TNote);
    procedure ClearNoteDetails;
    procedure RefreshNoteData;
    function  UnravelExchDate(const AnExchDate: string): string;
    function  YYYYMMDD(ADate: string): string;
  public
    constructor create(ADataPath: WideString; AnEmployeeID: WideString; AnEmployeeName: WideString; AnOurRef: WideString; AnOperator: WideString);
    destructor destroy; override;
    procedure Startup;
    procedure NoteDataChanged;
    Property Company :   ShortString Read GetCompany Write SetCompany;
    property Currency:   integer    read GetCurrency write SetCurrency;
    property CurrSymb:   WideString read FCurrSymb write FCurrSymb;
    Property Host :      HWND Write SetHost;
  protected
  end;

implementation

uses CTKUtil, TUDPeriodClass;

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

  procedure EnableDisableControls(AWinControl: TWinControl; Enable: boolean);
  var
    i: integer;
  begin
    for i := 0 to AWinControl.ControlCount - 1 do
      AWinControl.Controls[i].Enabled := Enable;
  end;

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
  ofPager.ActivePage := opTimesheet;

  FFrames[1] := FrameTimesheetLine1;
  FFrames[2] := FrameTimesheetLine2;
  FLabels[1] := lblLine1;
  FLabels[2] := lblLine2;

  ofPager.ActivePageIndex := 0;
  EnableDisableControls(gbEditNote, false);
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

constructor TfrmEnterTimesheets.create(ADataPath: WideString; AnEmployeeID: WideString; AnEmployeeName: WideString; AnOurRef: WideString; AnOperator: WideString);
begin
  inherited create(nil);
  FDataPath     := trim(ADataPath);
  FEmployeeID   := AnEmployeeID;
  FEmployeeName := AnEmployeeName;
  FOurRef       := AnOurRef;
  FOperator     := AnOperator;
end;

procedure TfrmEnterTimesheets.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
  btnSave.Left := btnDelete.Left + ((btnCloseCancel.Left - btnDelete.Left) div 2); // half between btnDelete and btnCloseCancel
end;

procedure TfrmEnterTimesheets.btnAddLineClick(Sender: TObject);
begin
  if btnSaveNote.Enabled then EXIT; // ignore clicks if the user is editing notes
  if FTimesheetData.Timesheet = nil then EXIT;
  with FTimesheetData.Timesheet.AddNewLine do begin
    Narrative := 'New Line ' + IntToStr(LogicalLineNo);
    with TimesheetSettings do begin
      EmpCode      := FEmployeeID;      // set the employee code before reading the following properties from the TTimesheetSettings class
      JobCode      := DefaultJobCode;
      RateCode     := DefaultRateCode;
      AnalysisCode := DefaultAnalysisCode;
      CostCentre   := DefaultCostCentre;
      Department   := DefaultDepartment;

      with TEmployeeRate.Create do begin
        DataPath := FDataPath;
        FindRates(EmpCode, JobCode, RateCode);
        if CurrentRateCode <> nil then
        with CurrentRateCode do begin
          ChargeCurrency := rcChargeCurrency;
          CostCurrency   := rcCostCurrency;
        end;
        free;
      end;

    end;
  end;

  if ItsOdd(FTimesheetData.Timesheet.TimesheetLiveLineCount) then // set CurrentLineNo to one less than the first line we want displayed in Frame 1
    FCurrentLineNo := FTimesheetData.Timesheet.TimesheetLiveLineCount - 1
  else
    FCurrentLineNo := FTimesheetData.Timesheet.TimesheetLiveLineCount - 2;

  DisplayTimesheetLines;
end;

procedure TfrmEnterTimesheets.Startup;
var
  i: integer;
begin
  FStartup := true; // prevent the timesheet being flagged as changed while we populate the edit boxes
  UDPeriod(FDataPath); // initial all to set the data path
  lblInfo.Caption := format('Timesheet Data Entry [%s: %s]', [FEmployeeID, FEmployeeName]);
  gbTransactionHeader.Caption := format(' Timesheet: %s ', [FEmployeeName]);
  gbNotesHeader.Caption := format(' Timesheet: %s ', [FEmployeeName]);

  FTimesheetData := TTimesheetData.Create(FDataPath, FEmployeeID);
  if trim(FOurRef) <> '' then
    FTimesheetData.LocateTimesheet(FOurRef)    // side-effect is a call to FTimesheetData.FetchTimesheetData
  else begin
    FTimesheetData.NewTimesheet;               // side-effect is a call to FTimesheetData.FetchTimesheetData, just to set FTimesheetData.QtyDecimals below
    opNotes.TabVisible := false;
  end;

  // CJS 2013-11-04 - MRD2.6.43 - Support for Transaction Originator
  lblOriginator.Caption := FTimesheetData.OriginatorCaption;

  for i := 1 to 2 do
    with FFrames[i] do begin
      IgnoreChanges  := true; // stop transaction line from being flagged as changed while we're populating the boxes
      OnRecalcTotals := RecalcFooterTotals;
      OnDeleteClick  := DeleteClick;
      OnLineChanged  := LineChanged;
      Precision      := FTimesheetData.QtyDecimals;
      lblTLUDF1.Caption  := FTimesheetData.TLUDF1Desc;
      lblTLUDF2.Caption  := FTimesheetData.TLUDF2Desc;
      { CJS 2012-08-29 - ABSEXCH-13379 - ODD support for UDFs 5-10 }
      lblTLUDF5.Caption  := FTimesheetData.TLUDF5Desc;
      lblTLUDF6.Caption  := FTimesheetData.TLUDF6Desc;
      lblTLUDF7.Caption  := FTimesheetData.TLUDF7Desc;
      lblTLUDF8.Caption  := FTimesheetData.TLUDF8Desc;
      lblTLUDF9.Caption  := FTimesheetData.TLUDF9Desc;
      lblTLUDF10.Caption := FTimesheetData.TLUDF10Desc;
    end;

  lblTHUDF1.Caption := FTimesheetData.THUDF1Desc;
  lblTHUDF2.Caption := FTimesheetData.THUDF2Desc;
  lblTHUDF3.Caption := FTimesheetData.THUDF3Desc;
  lblTHUDF4.Caption := FTimesheetData.THUDF4Desc;

  { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
  lblTHUDF5.Caption  := FTimesheetData.THUDF5Desc;
  lblTHUDF6.Caption  := FTimesheetData.THUDF6Desc;
  lblTHUDF7.Caption  := FTimesheetData.THUDF7Desc;
  lblTHUDF8.Caption  := FTimesheetData.THUDF8Desc;
  lblTHUDF9.Caption  := FTimesheetData.THUDF9Desc;
  lblTHUDF10.Caption := FTimesheetData.THUDF10Desc;

  edtTotHrsQty.Precision := FTimesheetData.QtyDecimals;

  PopulateLists;

  if FTimesheetData.Timesheet.HoldStatus = -1 then begin // v20 -1, so must be new timesheet and we can use the DefaultTimesheetStatus
    ccbTimesheetStatus.ItemIndex := ccbTimesheetStatus.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultTimesheetStatus);
    FTimesheetData.Timesheet.HoldStatus := ccbTimesheetStatus.ItemIndex;
  end
  else
    ccbTimesheetStatus.ItemIndex := FTimesheetData.Timesheet.HoldStatus;

  HideRestrictedControls;
  DisplayTimesheetHeader;
  FCurrentLineNo := 0;
  DisplayTimesheetLines;
  RecalcFooterTotals(nil);
  FStartup := false; // because populating each frame's controls will have triggered OnLineChanged events
  FFrames[1].IgnoreChanges := false;
  FFrames[2].IgnoreChanges := false;

  edtTotChargeOutRate.Prefix := GCurrencySymbols[0] + ' ';
  edtTotCostHour.Prefix      := GCurrencySymbols[0] + ' ';
end;

procedure TfrmEnterTimesheets.PopulateLists;
  procedure PopulateUserProfile;
  var
    toolkit: IToolkit2;
    UserProfile: IUserProfile;
    res: integer;
  begin
      toolkit := OpenToolkit(FDataPath, true) as IToolkit2;
      ccbNoteUserProfile.ComboItems.Clear;
      if toolkit <> nil then begin
        UserProfile := Toolkit.UserProfile;
        if assigned(UserProfile) then
        try
          with UserProfile do begin
            index := usIdxLogin;
            res   := GetFirst;
            while res = 0 do begin
              with ccbNoteUserProfile.ComboItems.Add do begin
                strings.Add(trim(upUserID));
                strings.Add(trim(upName));
              end;
              res := GetNext;
            end;
          end;
        finally
          UserProfile := nil;
          toolkit.CloseToolkit;
          toolkit := nil;
        end;
      end;
      ccbNoteUserProfile.ItemIndex := -1;
  end;
begin
  ccbTimesheetStatus.ComboItems.Clear;
  ccbTimesheetStatus.ComboItems.Add.Strings.Add('Not Held');
  ccbTimesheetStatus.ComboItems.Add.Strings.Add('Hold for Query');
  ccbTimesheetStatus.ItemIndex := 0;

  ccbNoteTimesheetStatus.ComboItems.Clear;
  ccbNoteTimesheetStatus.ComboItems.Add.Strings.Add('Not Held');
  ccbNoteTimesheetStatus.ComboItems.Add.Strings.Add('Hold for Query');
  ccbNoteTimesheetStatus.ItemIndex := 0;

  ccbEvery.ComboItems.Clear;
  ccbEvery.ComboItems.Add.Strings.Add('every');
  ccbEvery.ComboItems.Add.Strings.Add('next month on the');
  ccbEvery.ComboItems.Add.Strings.Add('at the end of next month');
  ccbEvery.ComboItems.Add.Strings.Add('every 2 months on the');
  ccbEvery.ComboItems.Add.Strings.Add('every 3 months on the');
  ccbEvery.ComboItems.Add.Strings.Add('every 4 months on the');
  ccbEvery.ComboItems.Add.Strings.Add('every 5 months on the');
  ccbEvery.ItemIndex := 0;

  FrameTimesheetLine1.DataPath := FDataPath;
  FrameTimesheetLine2.DataPath := FDataPath;
  FrameTimesheetLine1.FillComboBoxes;
  FrameTimesheetLine2.FillComboBoxes;
  FrameTimesheetLine1.EmpCode := FEmployeeID;
  FrameTimesheetLine2.EmpCode := FEmployeeID;
  FrameTimesheetLine1.UseCCDeps := FTimesheetData.UseCCDeps;
  FrameTimesheetLine2.UseCCDeps := FTimesheetData.UseCCDeps;

  PopulateUserProfile;
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
  opTimesheet.SetFocus;
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
  if btnSaveNote.Enabled then EXIT; // ignore clicks if the user is editing notes
  FCanClose := not FTimesheetData.Timesheet.TimesheetChanged
            or (MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TfrmEnterTimesheets.btnSaveClick(Sender: TObject);
var
  res: integer;
begin
  FTimesheetData.Timesheet.Operator := FOperator;
  res := FTimesheetData.SaveTimesheet(FOurRef);
  if res = 0 then begin
    MessageDlg('Timesheet Saved' + CreateNote, mtInformation, [mbOK], 0);
    FCanClose := true;
  end
  else
    MessageDlg(format('Unable to save this timesheet: error code %d%s', [res, #13#10'"' + FTimesheetData.LastError + '"']), mtWarning, [mbOK], 0);
end;

procedure TfrmEnterTimesheets.btnScrollDnClick(Sender: TObject);
begin
  DisplayTimesheetLines;
end;

function TfrmEnterTimesheets.ItsOdd(WhatsOdd: integer): boolean;
begin
  result := WhatsOdd <> (WhatsOdd div 2) * 2;
end;

procedure TfrmEnterTimesheets.btnScrollUpClick(Sender: TObject);
begin
  if ItsOdd(FCurrentLineNo) then // set CurrentLineNo to one less than the first line we want displayed in Frame 1
    FCurrentLineNo := FCurrentLineNo - 3
  else
    FCurrentLineNo := FCurrentLineNo - 4;
  DisplayTimesheetLines;
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

procedure TfrmEnterTimesheets.btnAddNoteClick(Sender: TObject);
begin
  EditNewNote;
end;

procedure TfrmEnterTimesheets.RefreshNoteData;
begin
  ClearNoteDetails;
  ReadNotes(ntTypeDated);
  btnSaveNote.Enabled := false;
  btnCancelNote.Enabled := false;
  btnAddNote.Enabled    := true;
  btnEditNote.Enabled   := false;
end;

procedure TfrmEnterTimesheets.btnCancelNoteClick(Sender: TObject);
begin
  RefreshNoteData;
end;

procedure TfrmEnterTimesheets.btnDeleteClick(Sender: TObject);
var msg, lines: string;
begin
  if FTimesheetData.Timesheet.LinesMarkedForDeletion = 1 then
    lines := 'line'
  else
    lines := format('%d lines', [FTimesheetData.Timesheet.LinesMarkedForDeletion]);
  msg := format('Are you sure you want to delete the %s marked for deletion ?', [lines]);
  if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrNo then EXIT;
  FTimesheetData.Timesheet.TimesheetChanged := true;

  FTimesheetData.Timesheet.ConfirmLineDeletions;
  FTimesheetData.Timesheet.TimesheetChanged := true;
  btnDelete.Enabled := FTimesheetData.Timesheet.LinesMarkedForDeletion <> 0;
  FCurrentLineNo := 0;
  DisplayTimesheetLines;
  RecalcFooterTotals(nil);
//  btnCancel.Enabled := FTimesheetData.Timesheet.TimesheetChanged;
  if FTimesheetData.Timesheet.TimesheetChanged then Changebuttons;
end;

procedure TfrmEnterTimesheets.btnEditNoteClick(Sender: TObject);
begin
  EditNote(integer(lbNoteDate.Items.Objects[lbNoteDate.ItemIndex]));
end;

procedure TfrmEnterTimesheets.btnSaveNoteClick(Sender: TObject);
var res: integer;
begin
  if FNoteData.Note = nil then EXIT;
  FNoteData.Note.NoteType := FNotesType;
  res := FNoteData.SaveNote;
  if res  <> 0 then
    ShowMessage(format('Error %d when saving note', [res]))
  else begin
    RefreshNoteData;
    EnableDisableControls(gbNotes, true);
  end;
end;

procedure TfrmEnterTimesheets.btnSwitchNoteViewClick(Sender: TObject);
begin
  if FNotesType = ntTypeGeneral then
    ReadNotes(ntTypeDated)
  else
    ReadNotes(ntTypeGeneral);
end;

procedure TfrmEnterTimesheets.cbNoteAlarmedClick(Sender: TObject);
begin
  if FUpdatingNoteDetails then EXIT;
  if FNoteData.Note = nil then EXIT;
  if cbNoteAlarmed.Checked then
    FNoteData.Note.AlarmDate := YYYYMMDD(edtNoteAlarmDate.Text)
  else
    FNoteData.Note.AlarmDate := '';
  NoteDataChanged;
end;

procedure TfrmEnterTimesheets.cbShowNoteDateClick(Sender: TObject);
begin
  if FupdatingNoteDetails then EXIT;
  if FNoteData.Note = nil then EXIT;
  FNoteData.Note.ShowNoteDate := cbShowNoteDate.Checked; // ntAlarmSet actually means Show Note Date in Exchequer.
  if length(edtNoteDate.Text) = 10 then
    FNoteData.Note.NoteDate := YYYYMMDD(edtNoteDate.Text);
  NoteDataChanged;
end;

procedure TfrmEnterTimesheets.cbWeekCommencingClick(Sender: TObject);
begin
  if not FStartup then begin
    //*** which field gets week/commencing flag ?
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.ccbEveryChange(Sender: TObject);
begin
  if FUpdatingNoteDetails then EXIT;
  if FNoteData.Note = nil then EXIT;
//  cbNoteAlarmed.Checked := true;
  edtNoteDays.Visible := ccbEvery.ItemIndex <> 2;
  if ccbEvery.ItemIndex = 2 then // "end of next month"
    edtNoteDays.Text := '';
  lblNoteDays.Caption := FNoteData.Note.SetAlarmDays(ccbEvery.ColumnItems[ccbEvery.ItemIndex, 0], edtNoteDays.IntValue);
  NoteDataChanged;
end;

procedure TfrmEnterTimesheets.ccbNoteUserProfileChange(Sender: TObject);
begin
  if FUpdatingNoteDetails then EXIT;
  if FNoteData.Note = nil then EXIT;
  FNoteData.Note.AlarmUser := ccbNoteUserProfile.ColumnItems[ccbNoteUserProfile.ItemIndex, 0];
  NoteDataChanged;
end;

procedure TfrmEnterTimesheets.ccbTimesheetStatusChange(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.HoldStatus := ccbTimesheetStatus.ItemIndex;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.ChangeButtons;
begin
  btnSave.Enabled := FTimesheetData.Timesheet.LinesMarkedForDeletion = 0; // user must confirm line deletions before they can save the timesheet
  btnCloseCancel.Caption := '&Cancel';
  btnCloseCancel.Hint    := 'Cancel all changes and close this window';
end;

procedure TfrmEnterTimesheets.ChangeLineCountCaption;
begin
  if FTimesheetData.Timesheet = nil then
    lblLineCount.Caption := '0 Lines'
  else
  if FTimesheetData.Timesheet.TimesheetLiveLineCount = 1 then
    lblLineCount.Caption := '1 Line'
  else
    lblLineCount.Caption := IntToStr(FTimesheetData.Timesheet.TimesheetLiveLineCount) + ' Lines';
end;

procedure TfrmEnterTimesheets.DisplayTimesheetLines;
// try to display the next one or two lines depending on how many we've got

    procedure ChangeLineNoLabel(WhichLabel: integer; MakeVisible: boolean);
    begin
      with FLabels[WhichLabel] do begin
        Visible := MakeVisible;
        if Visible then
          Caption := IntToStr(FTimesheetData.Timesheet.CurrentLine.LogicalLineNo);
      end;
    end;
    procedure DisplayFrame(WhichFrame: integer; MakeVisible: boolean);
    begin
      with FFrames[WhichFrame] do begin
        Visible            := MakeVisible;
        if MakeVisible then
          TimesheetLine    := FTimesheetData.Timesheet.CurrentLine;
      end;
      ChangeLineNoLabel(WhichFrame, MakeVisible);
    end;
    function MoreLines: boolean;
    begin
      result := (FTimesheetData.Timesheet <> nil) and (FCurrentLineNo < FTimesheetData.Timesheet.TimesheetLiveLineCount);
    end;
    function NextLine: TTimesheetLine;
    begin
      if MoreLines then begin
        inc(FCurrentLineNo);
        FTimesheetData.Timesheet.LocateLogicalLine(FCurrentLineNo);
        result := FTimesheetData.Timesheet.CurrentLine;
      end
      else
        result := nil;
    end;
begin
  try

    ChangeLineCountCaption;

    DisplayFrame(1, NextLine <> nil);
    DisplayFrame(2, NextLine <> nil);

  finally
    btnScrollUp.Enabled := FCurrentLineNo > 2;
    btnScrollDn.Enabled := MoreLines;
  end;
end;

procedure TfrmEnterTimesheets.DisplayTimesheetHeader;
begin
  if FTimesheetData.Timesheet <> nil then
    with FTimesheetData.Timesheet do begin
      edtDesc.Text := Description;
      edtDate.Text := copy(TransDate, 7, 2) + '/' + copy(TransDate, 5, 2) + '/' + copy(TransDate, 1, 4);
      edtPrYr.Text := format('%.2d/%d', [Period, Year + 1900]);
      edtWkMonth.Text := IntToStr(WeekMonth);
      edtTHUDF1.Text := UserField1;
      edtTHUDF2.Text := UserField2;
      edtTHUDF3.Text := UserField3;
      edtTHUDF4.Text := UserField4;

      { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
      edtTHUDF5.Text  := UserField5;
      edtTHUDF6.Text  := UserField6;
      edtTHUDF7.Text  := UserField7;
      edtTHUDF8.Text  := UserField8;
      edtTHUDF9.Text  := UserField9;
      edtTHUDF10.Text := UserField10;

      if HoldStatus > 1 then begin
        ShowMessage(format('Unexpected Hold Flag: %d', [HoldStatus]));
        ccbTimesheetStatus.ItemIndex := 0;
      end
      //else // v20 commented out - leave as default for Employee
        //ccbTimesheetStatus.ItemIndex := HoldStatus; // v20 commented out
    end;
end;

procedure TfrmEnterTimesheets.RecalcFooterTotals(Sender: TObject);
begin
  if FTimesheetData.Timesheet <> nil then begin
    with FTimesheetData.Timesheet do begin
      edtTotHrsQty.FloatValue        := TotalQtyHrs;
      edtTotCostHour.FloatValue      := TotalCost;
      edtTotChargeOutRate.FloatValue := TotalCharge;

      edtTotDay1.FloatValue := TotalHoursForDay[1];
      edtTotDay2.FloatValue := TotalHoursForDay[2];
      edtTotDay3.FloatValue := TotalHoursForDay[3];
      edtTotDay4.FloatValue := TotalHoursForDay[4];
      edtTotDay5.FloatValue := TotalHoursForDay[5];
      edtTotDay6.FloatValue := TotalHoursForDay[6];
      edtTotDay7.FloatValue := TotalHoursForDay[7];
    end;
  end;
end;

procedure TfrmEnterTimesheets.DeleteClick(Sender: TObject);
begin
  btnDelete.Enabled := FTimesheetData.Timesheet.LinesMarkedForDeletion <> 0;
  ChangeButtons;
end;

function TfrmEnterTimesheets.YYYYMMDD(ADate: string): string;
var
  PosSlash1, PosSlash2: integer;
begin
  PosSlash1 := pos('/', ADate);
  PosSlash2 := LastDelimiter('/', ADate);
  result := copy(ADate, PosSlash2 + 1, 4)                         // 4-digit year
          + copy(ADate, PosSlash1 + 1, PosSlash2 - PosSlash1 - 1) // 1- or 2-digit month
          + copy(ADate, 1, PosSlash1 - 1);                        // 1- or 2-digit day
end;

  function InvalidDate(ADate: string): boolean;
  var
    dd, mm, yy: integer;
    PosSlash1, PosSlash2: integer;
  begin
    result := (length(ADate) < 8) or (length(ADate) > 10);
    if not result then result := pos('//', ADate) <> 0;
    if not result then begin
      PosSlash1 := pos('/', ADate);
      PosSlash2 := LastDelimiter('/', ADate);
      dd := StrToIntDef(copy(ADate, 1, PosSlash1 - 1), 0);
      mm := StrToIntDef(copy(ADate, PosSlash1 + 1, PosSlash2 - PosSlash1 - 1), 0);
      yy := StrToIntDef(copy(ADate, PosSlash2 + 1, 4), 0);
      result := (dd < 1) or (dd > 31) or (mm < 1) or (mm > 12) or (yy < 1900);
      if not result then result := (mm = 2) and (dd > 29);
      if not result then result := (mm = 2) and (dd = 29) and (yy <> (yy div 4) * 4); // arf arf. Who forget about the "mod" operator then ?
    end;
  end;

procedure TfrmEnterTimesheets.edtDateChange(Sender: TObject);
begin
  if not FStartup then begin
    if InvalidDate(edtDate.Text) then begin
      edtDate.Color := clRed;
      EXIT;
    end;

    edtDate.Color := clWhite;
    FTimesheetData.Timesheet.TransDate := YYYYMMDD(edtDate.Text);
    FTimesheetData.Timesheet.TimesheetChanged := true;

    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtDescChange(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.Description := edtDesc.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtPrYrChange(Sender: TObject);
var
  pr, yr: integer;
  wrong: boolean;
begin
  if not FStartup then begin
    if (length(edtPrYr.Text) < 6) or (length(edtPrYr.Text) > 7) or (pos('/', edtPrYr.text) > 3) then begin
      edtPrYr.Color := clRed;
      EXIT;
    end;

    pr := StrToIntDef(copy(edtPrYr.Text, 1, pos('/', edtPrYr.Text) - 1), 0);
    yr := StrToIntDef(copy(edtPrYr.Text, pos('/', edtPrYr.Text) + 1, 4), 0);
    if (pr < 1) or (pr > 12) or (yr < 1900) then begin
      edtPrYr.Color := clRed;
      EXIT;
    end;

    FTimesheetData.Timesheet.Period := pr;
    FTimesheetData.Timesheet.Year   := yr;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    if FBoxWasEdited then
      UDPeriod.SetTransPeriodByDate := false; // v16 - manual edit of period overrides "Set relative to date" and the period plug-in
    FBoxWasEdited := false; 
    edtPrYr.Color := clWhite;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF1Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField1 := edtTHUDF1.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF2Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField2 := edtTHUDF2.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF3Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField3 := edtTHUDF3.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF4Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField4 := edtTHUDF4.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

{ CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
procedure TfrmEnterTimesheets.edtTHUDF5Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField5 := edtTHUDF5.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF6Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField6 := edtTHUDF6.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF7Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField7 := edtTHUDF7.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF8Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField8 := edtTHUDF8.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF9Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField9 := edtTHUDF9.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtTHUDF10Change(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.UserField10 := edtTHUDF10.Text;
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.edtWkMonthChange(Sender: TObject);
begin
  if not FStartup then begin
    FTimesheetData.Timesheet.WeekMonth := StrToIntDef(edtWkMonth.Text, 0);
    FTimesheetData.Timesheet.TimesheetChanged := true;
    ChangeButtons;
  end;
end;

procedure TfrmEnterTimesheets.LineChanged(Sender: TObject);
begin
  if not FStartup then ChangeButtons;
end;

procedure TfrmEnterTimesheets.HideRestrictedControls;
begin
  with TimesheetSettings(FDataPath) do begin
    EmpCode := FEmployeeID;
    edtTHUDF1.Visible := ShowTHUDF1;
    lblTHUDF1.Visible := ShowTHUDF1;
    edtTHUDF2.Visible := ShowTHUDF2;
    lblTHUDF2.Visible := ShowTHUDF2;
    edtTHUDF3.Visible := ShowTHUDF3;
    lblTHUDF3.Visible := ShowTHUDF3;
    edtTHUDF4.Visible := ShowTHUDF4;
    lblTHUDF4.Visible := ShowTHUDF4;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    edtTHUDF5.Visible := ShowTHUDF5;
    lblTHUDF5.Visible := ShowTHUDF5;
    edtTHUDF6.Visible := ShowTHUDF6;
    lblTHUDF6.Visible := ShowTHUDF6;
    edtTHUDF7.Visible := ShowTHUDF7;
    lblTHUDF7.Visible := ShowTHUDF7;
    edtTHUDF8.Visible := ShowTHUDF8;
    lblTHUDF8.Visible := ShowTHUDF8;
    edtTHUDF9.Visible := ShowTHUDF9;
    lblTHUDF9.Visible := ShowTHUDF9;
    edtTHUDF10.Visible := ShowTHUDF10;
    lblTHUDF10.Visible := ShowTHUDF10;

    edtTotChargeOutRate.Visible           := ShowChargeOutRate;
//    lblTotalChargeOutRateCurrency.Visible := ShowChargeOutRate;
    edtTotCostHour.Visible                := ShowCostPerHour;
//    lblTotalCostHourCurrency.Visible      := ShowCostPerHour;
  end;
end;

procedure TfrmEnterTimesheets.ofPagerChanging(Sender: TObject; FromPage, ToPage: Integer; var AllowChange: Boolean);
begin
//  AllowChange := not FTimesheetData.Timesheet.TimesheetChanged;
//  if not AllowChange then
//    ShowMessage('Please save your changes before switching to the Notes tab');
  if ToPage = 1 then // changing to the Notes tab
    ReadNotes(ntTypeDated)
  else
    AllowChange := not btnSaveNote.Enabled; // don't allow them to leave the notes tab if there are outstanding changes
end;

procedure TfrmEnterTimesheets.ClearNoteDetails;
begin
  FUpdatingNoteDetails := true;
  try
    edtNoteDate.Text := '';
    edtNoteText.Text := '';
    cbShowNoteDate.Checked := false;
    ccbNoteUserProfile.ItemIndex := -1;
    cbNoteAlarmed.Checked := false;
    edtNoteAlarmDate.Text := '';
    edtNoteDays.Text      := '';
    lbNoteDate.Clear;
    lbNoteText.Clear;
    lbNoteUser.Clear;
  finally
    FUpdatingNoteDetails := false;
  end;
end;

procedure TfrmEnterTimesheets.ReadNotes(ANotesType: TNotesType);
  procedure DisableControls(AWinControl: TWinControl);
  var
    i: integer;
  begin
    for i := 0 to AWinControl.ControlCount - 1 do
      if (AWinControl.Controls[i] <> NotesScrollBox) then
        AWinControl.Controls[i].Enabled := False;
  end;
  procedure CopyTSHeaderFieldsEtc;
  begin
    edtNoteHDesc.Text := edtDesc.Text;
    ccbNoteTimesheetStatus.ItemIndex := ccbTimesheetStatus.ItemIndex;
    edtNoteHDate.Text := edtDate.Text;
    cbNoteHWC.Checked := cbWeekCommencing.Checked;
    edtNoteHPrYr.Text := edtPrYr.Text;
    edtNoteHWkMonth.Text := edtWkMonth.Text;
    edtNoteTHUDF1.Text   := edtTHUDF1.Text;
    edtNoteTHUDF2.Text   := edtTHUDF2.Text;
    edtNoteTHUDF3.Text   := edtTHUDF3.Text;
    edtNoteTHUDF4.Text   := edtTHUDF4.Text;
    lblNoteTHUDF1.Caption := lblTHUDF1.Caption;
    lblNoteTHUDF2.Caption := lblTHUDF2.Caption;
    lblNoteTHUDF3.Caption := lblTHUDF3.Caption;
    lblNoteTHUDF4.Caption := lblTHUDF4.Caption;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    edtNoteTHUDF5.Text   := edtTHUDF5.Text;
    edtNoteTHUDF6.Text   := edtTHUDF6.Text;
    edtNoteTHUDF7.Text   := edtTHUDF7.Text;
    edtNoteTHUDF8.Text   := edtTHUDF8.Text;
    edtNoteTHUDF9.Text   := edtTHUDF9.Text;
    edtNoteTHUDF10.Text  := edtTHUDF10.Text;

    lblNoteTHUDF5.Caption  := lblTHUDF5.Caption;
    lblNoteTHUDF6.Caption  := lblTHUDF6.Caption;
    lblNoteTHUDF7.Caption  := lblTHUDF7.Caption;
    lblNoteTHUDF8.Caption  := lblTHUDF8.Caption;
    lblNoteTHUDF9.Caption  := lblTHUDF9.Caption;
    lblNoteTHUDF10.Caption := lblTHUDF10.Caption;

  end;
begin
  FNotesType := ANotesType;
  DisableControls(gbNotesHeader);

  { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
  // Re-enable the scroll box (otherwise the user can't scroll down the UDFs
  // when on the Notes tab).
  NotesScrollBox.Enabled := True;
  // ...but disable the controls ON the scroll-box
  DisableControls(NotesScrollBox);

  ClearNoteDetails;
  CopyTSHeaderFieldsEtc;
  if FOurRef = '' then EXIT;
  if FNoteData <> nil then FNoteData.Free;
  FNoteData := TNoteData.Create(FDataPath, FOurRef);
  with FNoteData do begin
    Operator := FOperator;
    FirstNote;
    while Note <> nil do begin
      with Note do
        if NoteType = ANotesType then  begin
          lbNoteDate.Items.AddObject(UnravelExchDate(NoteDate), TObject(LineNo));
          lbNoteText.Items.Add(Text);
          lbNoteUser.Items.Add(Operator);
        end;
      NextNote;
    end;
  end;
  lbNoteDate.Visible  := ANotesType = ntTypeDated;
  lblNoteDate.Visible := ANotesType = ntTypeDated;
end;

function TfrmEnterTimesheets.UnravelExchDate(const AnExchDate: string): string;
begin
  result := trim(AnExchDate);
  if result <> '' then
    result := format('%s/%s/%s', [copy(result, 7, 2), copy(result, 5, 2), copy(result, 1, 4)]);
end;

procedure TfrmEnterTimesheets.CopyNoteFields(ANote: TNote);
var
  EveryDays: integer;
begin
  with ANote do begin
    cbShowNoteDate.Checked := ShowNoteDate;
    if ShowNoteDate then                             // if ntAlarmSet (i.e. ShowDate) is set use the note's date on the note record
      edtNoteDate.Text := UnravelExchDate(NoteDate)
    else
      edtNoteDate.Text := FormatDateTime('dd/mm/yyyy', date); // ...otherwise fill in the note date for the user a la Exchequer
    edtNoteText.Text := Text;
    ccbNoteUserProfile.ItemIndex := ccbNoteUserProfile.ComboItems.IndexInColumnOf(0, trim(AlarmUser));
    cbNoteAlarmed.Checked := Trim(AlarmDate) <> '';
    if cbNoteAlarmed.Checked then // alarm date on the note record so...
      edtNoteAlarmDate.Text := UnravelExchDate(AlarmDate) // show the date on the record...
    else
      edtNoteAlarmDate.Text := FormatDateTime('dd/mm/yyyy', date); // ...otherwise fill in the alarm date for the user a la Exchequer
    ccbEvery.ItemIndex    := GetAlarmDays(AlarmDays, EveryDays);
    edtNoteDays.IntValue  := EveryDays;
    lblNoteDays.Caption   := SetAlarmDays(ccbEvery.ColumnItems[ccbEvery.ItemIndex, 0], EveryDays);
  end;
end;

procedure TfrmEnterTimesheets.EditNewNote;
begin
  EnableDisableControls(gbNotes, false);
  if FNoteData = nil then
    ShowMessage('NoteData = nil');
  CopyNoteFields(FNoteData.NewNote(FNotesType));
  btnAddNote.Enabled := false;
  btnEditNote.Enabled := false;
  btnSaveNote.Enabled := false;
  btnCancelNote.Enabled := false;
  EnableDisableControls(gbEditNote, true);
  edtNoteDate.SetFocus;
end;

procedure TfrmEnterTimesheets.EditNote(ALineNo: Integer);
begin
  FNoteData.LocateNote(ALineNo);
  if FNoteData.Note = nil then EXIT;
  FUpdatingNoteDetails := true;
  try
    CopyNoteFields(FNoteData.Note);
    EnableDisableControls(gbEditNote, true);
    edtNoteDate.SetFocus;
  finally
    FUpdatingNoteDetails := false;
  end;
end;

procedure TfrmEnterTimesheets.edtNoteAlarmDateChange(Sender: TObject);
begin
  if FUpdatingNoteDetails then EXIT;
  if FNoteData.Note = nil then EXIT;
  FNoteData.Note.AlarmDate := YYYYMMDD(edtNoteAlarmDate.Text);
  NoteDataChanged;
end;

procedure TfrmEnterTimesheets.edtNoteDateChange(Sender: TObject);
begin
  if FUpdatingNoteDetails then EXIT;
  if FNoteData.Note <> nil then begin
    if InvalidDate(edtNoteDate.Text) then begin
      edtNoteDate.Color := clRED;
      EXIT;
    end;
    edtNoteDate.Color := clWhite;
    FNoteData.Note.NoteDate := YYYYMMDD(edtNoteDate.Text);
    NoteDataChanged;
  end;
end;

procedure TfrmEnterTimesheets.edtNoteDaysChange(Sender: TObject);
begin
  if FUpdatingNoteDetails then EXIT;
  if FNoteData.Note = nil then EXIT;
  if (edtNoteDays.IntValue > 500) or ((ccbEvery.ItemIndex <> 0) and (edtNoteDays.IntValue > 31)) then begin
    edtNoteDays.Color := clRed;
    edtNoteDays.SetFocus;
    lblNoteDays.Caption := '';
    EXIT;
  end;
//  cbNoteAlarmed.Checked := edtNoteDays.IntValue > 0;
  edtNoteDays.Color := clWindow;
  lblNoteDays.Caption := FNoteData.Note.SetAlarmDays(ccbEvery.ColumnItems[ccbEvery.ItemIndex, 0], edtNoteDays.IntValue);
//  FNoteData.Note.AlarmDays := edtNoteDays.IntValue;
  NoteDataChanged;
end;

procedure TfrmEnterTimesheets.edtNoteTextChange(Sender: TObject);
begin
  if FUpdatingNoteDetails then EXIT;
  if FNoteData.Note <> nil then begin
    FNoteData.Note.Text := edtNoteText.Text;
    NoteDataChanged;
  end;
end;

procedure TfrmEnterTimesheets.lbNoteDateClick(Sender: TObject);
var ix: integer;
begin
  ix := TListBox(Sender).ItemIndex;
  lbNoteDate.ItemIndex := ix;
  lbNoteText.ItemIndex := ix;
  lbNoteUser.ItemIndex := ix;
  btnEditNote.Enabled := ix <> -1;
end;

procedure TfrmEnterTimesheets.lbNoteDateDblClick(Sender: TObject);
begin
  lbNoteDateClick(Sender);
  EditNote(integer(lbNoteDate.Items.Objects[lbNoteDate.ItemIndex]));
end;

procedure TfrmEnterTimesheets.NoteDataChanged;
begin
  FNoteData.Note.NoteChanged := true;
  btnSaveNote.Enabled   := true;
  btnCancelNote.Enabled := true;
end;

function TfrmEnterTimesheets.CreateNote: string;
var
  NewNote: TNote;
  res: integer;
begin
  if TimesheetSettings.AutoGenNoteStatus = 'Never Generate Note' then EXIT;
  if TimesheetSettings.AutoGenNoteStatus = 'Generate for ALL Timesheets' then
  else
  if (TimesheetSettings.AutoGenNoteStatus = 'Generate for Timesheets NOT on Query') and (FTimesheetData.Timesheet.HoldStatus = 0) then
  else
  if (TimesheetSettings.AutoGenNoteStatus = 'Generate for Timesheets on Query') and (FTimesheetData.Timesheet.HoldStatus = 1) then
  else
    EXIT;

  ReadNotes(ntTypeDated);
  NewNote := FNoteData.NewNote(ntTypeDated);
  with NewNote do begin
    Operator := FOperator;
    Text     := TimesheetSettings.AutoGenNoteText;
  end;
  res := FNoteData.SaveNote;
  if res = 0 then
    result := ' and new note created'
  else
    result := #13#10#13#10 + format('Error %d when trying to auto-generate a note', [res]);
end;

procedure TfrmEnterTimesheets.edtDateExit(Sender: TObject);
var
  Pos1stSlash: integer;
  Pos2ndSlash: integer;
begin                        
  if FBoxWasEdited then begin
    UDPeriod.SetTransPeriodByDate := FTimesheetData.ssSetTransPeriodByDate; // v16
    if (not InvalidDate(edtDate.Text)) and (FTimesheetData.Timesheet <> nil) then
      with FTimesheetData.Timesheet do begin
        if UDPeriod.UsePlugin[FDataPath] then begin
          Period := UDPeriod.GetPeriod(YYYYMMDD(edtDate.Text), true);
          Year   := UDPeriod.GetYear(YYYYMMDD(edtDate.Text), false);
        end
        else
        if UDPeriod.AutoSetPeriod then begin
          Pos1stSlash := pos('/', edtDate.Text);
          Pos2ndSlash := LastDelimiter('/', edtDate.Text);
          Period := StrToInt(copy(edtDate.Text, Pos1stSlash + 1, Pos2ndSlash - Pos1stSlash - 1));
          Year   := StrToInt(copy(edtDate.Text, Pos2ndSlash + 1, 4)) - 1900;
        end
        else begin
          Period := UDPeriod.GlobalPeriod;
          Year   := UDPeriod.GlobalYear;
        end;
        edtPrYr.Text := format('%.2d/%d', [Period, Year + 1900]);
      end;
    FBoxWasEdited := false;
  end;
end;

procedure TfrmEnterTimesheets.edtDateKeyPress(Sender: TObject; var Key: Char);
begin
  if not FBoxWasEdited then          // need to do this as we're using the edtDateExit event
    FBoxWasEdited := Key <> #13;

  if not (key in ['0'..'9', '/', #8]) then key := #0; // #8 is backspace
end;

procedure TfrmEnterTimesheets.edtNoteDateKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', '/', #8]) then key := #0; // #8 is backspace
end;

procedure TfrmEnterTimesheets.edtPrYrKeyPress(Sender: TObject; var Key: Char);
begin
  if not FBoxWasEdited then
    FBoxWasEdited := key <> #13;
    
  if not (key in ['0'..'9', '/', #8]) then key := #0; // #8 is backspace
end;

initialization
  FDLLHandle := 0;

finalization
  if FDLLHandle <> 0 then begin
    CloseFiles;
    FreeLibrary(FDLLHandle);
  end;
end.
