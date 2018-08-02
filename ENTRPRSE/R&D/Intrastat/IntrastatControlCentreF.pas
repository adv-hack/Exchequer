unit IntrastatControlCentreF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, TEditVal, ComCtrls, ThemeMgr, Menus,
  AdvMenus, ImgList, EntWindowSettings, oSystemSetup, IntrastatDataClass,
  UKIntrastatReport, AuditSystemSetupTable, AuditIntf;

type

  TfrmIntrastatControlCentre = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    chkEnableIntrastat: TCheckBox;
    lblLastClosedIntrastatDateArrivals: TLabel;
    lblSupplementaryDeclarationReporting: TLabel;
    Bevel2: TBevel;
    lblIntrastatPeriodYear: TLabel;
    lblDateRangeFrom: TLabel;
    edtFromDate: TEditDate;
    lblDateRangeTo: TLabel;
    edtToDate: TEditDate;
    lstAggregationMode: TComboBox;
    lblAggregationMode: TLabel;
    btnPrintDispatchesSD: TButton;
    btnPrintArrivalsSD: TButton;
    chkShowDeliveryTerms: TCheckBox;
    chkShowModeOfTransport: TCheckBox;
    lstIntrastatPeriod: TComboBox;
    lblIntrastatPeriodControl: TLabel;
    Bevel3: TBevel;
    mnuPrintPopup: TPopupMenu;
    mnuClosePeriodAndPrintReport: TMenuItem;
    mnuClosePeriodAndExportToCSV: TMenuItem;
    SaveDialog1: TSaveDialog;
    lblArrivalsDate: TLabel;
    lblDispatchesDate: TLabel;
    lblLastClosedIntrastatDateDispatches: TLabel;
    chkIncludeOutOfPeriodCommodityCodesOnly: TCheckBox;
    lblReportOptions: TLabel;
    mnuPrintReport: TMenuItem;
    N1: TMenuItem;
    mnuExportToCSV: TMenuItem;
    WARNINGDateRangeincludesOpenPeriod1: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    mnuWindowSettingsPopup: TPopupMenu;
    PropFlg: TMenuItem;
    MenuItem1: TMenuItem;
    optStoreCoordinates: TMenuItem;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnPrintArrivalsSDClick(Sender: TObject);
    procedure btnPrintDispatchesSDClick(Sender: TObject);
    procedure mnuClosePeriodAndExportToCSVClick(Sender: TObject);
    procedure WARNINGDateRangeincludesOpenPeriod1DrawItem(Sender: TObject;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure chkEnableIntrastatClick(Sender: TObject);
    procedure chkShowDeliveryTermsClick(Sender: TObject);
    procedure chkShowModeOfTransportClick(Sender: TObject);
    procedure lstIntrastatPeriodChange(Sender: TObject);
    procedure mnuClosePeriodAndPrintReportClick(Sender: TObject);
    procedure mnuPrintReportClick(Sender: TObject);
    procedure mnuExportToCSVClick(Sender: TObject);
    procedure edtToDateExit(Sender: TObject);
  private
    { Private declarations }
    FSettings : IWindowSettings;
    FColorsChanged: Boolean;
    FSystemSetup: ISystemSetup;

    FIntrastatDirection: TIntrastatDirection;

    FOriginalShowDeliveryTerms: string;
    FOriginalShowModeOfTransport: string;
    FOriginalPeriod: string;
    FOriginalFromDate: string;
    FOriginalToDate: string;
    FOriginalAggregationMode: Integer;

    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    FIntrastatAudit: IBaseAudit;

    procedure PrintReport;
    function ClosePeriod: Boolean;
    procedure ExportToCSV;
    procedure SaveReportSettings;
    function GetParameters : TIntrastatParametersRec;
    procedure UpdateDateRange;
    procedure PopulateLastClosedDates;
    procedure EnableControls(Enable: Boolean);
    function DateRangeIncludesOpenPeriod(IntrastatDirection: TIntrastatDirection): Boolean;
  	// MH 28/01/2016 2016-R1 ABSEXCH-17229: Modified to check TO date and Workstation Date
    function ToDateIsInClosedPeriod(IntrastatDirection: TIntrastatDirection): Boolean;
    function ToDateIsInFuture : Boolean;
    // CJS 2016-02-01 - ABSEXCH-17235 - Intrastat Control Centre allows To Date earlier than From Date
    function ToDateIsBeforeFromDate: Boolean;
    function ValidateDateRange: Boolean;
  public
    { Public declarations }
  end;

var
  frmIntrastatControlCentre: TfrmIntrastatControlCentre;

implementation

{$R *.dfm}

Uses StrUtils, VarConst, WM_Const, BTSupU1, ETDateU,
  // CJS 2016-01-21 - ABSEXCH-17169 - Apply user permissions to Intrastat Control Centre
  PWarnU,
  UA_Const;

const
  idDescription: array[idArrivals..idDispatches] of string =
  (
    'Arrivals',
    'Dispatches'
  );

// =============================================================================
// TfrmIntrastatControlCentre
// =============================================================================

procedure TfrmIntrastatControlCentre.FormCreate(Sender: TObject);
Var
  Year, Month, Day : Word;
  DefaultYear, DefaultMonth, CurrentYear, CurrentMonth, EndYear, EndMonth : Word;
begin
  FSystemSetup := oSystemSetup.SystemSetup(True);

  lstIntrastatPeriod.Clear;

  // Establish the starting position as 12 months in the past
  DecodeDate(IncMonth(Now, -12), Year, Month, Day);
  CurrentYear := Year;
  CurrentMonth := Month;

  // Establish the finishing period as 12 months into the future
  DecodeDate(IncMonth(Now, 12), Year, Month, Day);
  EndYear := Year;
  EndMonth := Month;

  // Default to printing last months SD
  DecodeDate(IncMonth(Now, -1), Year, Month, Day);
  DefaultYear := Year;
  DefaultMonth := Month;

  // MH 28/01/2016 2016-R1 ABSEXCH-17224: Apply previous Period/Year
  If (Trim(SystemSetup.Intrastat.isLastReportPeriodYear) <> '') Then
  Begin
    // isLastReportPeriodYear saved in MMYY format
    DefaultYear := 2000 + StrToIntDef(Copy(SystemSetup.Intrastat.isLastReportPeriodYear, 3, 2), Year);
    DefaultMonth := StrToIntDef(Copy(SystemSetup.Intrastat.isLastReportPeriodYear, 1, 2), Month);
  End; // If (Trim(SystemSetup.Intrastat.isLastReportPeriodYear) <> '')

  // Populate the list of periods
  Repeat
    lstIntrastatPeriod.Items.Add (Format('%2.2d/%2.2d - %s %d', [CurrentMonth,
                                                                 CurrentYear Mod 100,
                                                                 LongMonthNames[CurrentMonth],
                                                                 CurrentYear]));

    If (CurrentMonth = DefaultMonth) And (CurrentYear = DefaultYear) Then
      lstIntrastatPeriod.ItemIndex := lstIntrastatPeriod.Items.Count - 1;

    CurrentMonth := CurrentMonth + 1;
    If (CurrentMonth > 12) Then
    Begin
      CurrentMonth := 1;
      CurrentYear := CurrentYear + 1;
    End; // If (CurrentMonth > 12)
  Until (CurrentYear >= EndYear) And (CurrentMonth >= EndMonth);
  UpdateDateRange;

  FColorsChanged := False;
  FSettings := GetWindowSettings(Self.ClassName);
  If Assigned(FSettings) Then
  Begin
    FSettings.LoadSettings;

    If (Not FSettings.UseDefaults) Then
    Begin
      FSettings.SettingsToWindow(Self);
      FSettings.SettingsToParent(Self);
    End; // If (Not FSettings.UseDefaults)
  End; // If Assigned(FSettings)

  // Store the original values of the Intrastat settings. We need these when
  // the settings are updated, because the SystemSetup object requires both
  // the new values and the original values (see SystemSetup.UpdateValue).
  FOriginalShowDeliveryTerms   := IfThen(SystemSetup.Intrastat.isShowDeliveryTerms, '1', '0');
  FOriginalShowModeOfTransport := IfThen(SystemSetup.Intrastat.isShowModeOfTransport, '1', '0');
  FOriginalPeriod              := SystemSetup.Intrastat.isLastReportPeriodYear;
  FOriginalFromDate            := SystemSetup.Intrastat.isLastReportFromDate;
  FOriginalToDate              := SystemSetup.Intrastat.isLastReportToDate;
  FOriginalAggregationMode     := SystemSetup.Intrastat.isLastReportMode;

  chkEnableIntrastat.Checked     := Syss.Intrastat;
  chkShowDeliveryTerms.Checked   := SystemSetup.Intrastat.isShowDeliveryTerms;
  chkShowModeOfTransport.Checked := SystemSetup.Intrastat.isShowModeOfTransport;

  // Set the various date fields. Note that dates are stored in yyyymmdd
  // format in the database, but uninitialised dates will be blank.
  PopulateLastClosedDates;

  // CJS 2016-01-21 - ABSEXCH-17162 - Invalid Date Range From – To Dates
  if ValidDate(SystemSetup.Intrastat.isLastReportFromDate) then
    edtFromDate.DateValue := SystemSetup.Intrastat.isLastReportFromDate;

  if ValidDate(SystemSetup.Intrastat.isLastReportToDate) then
    edtToDate.DateValue := SystemSetup.Intrastat.isLastReportToDate;

  lstAggregationMode.ItemIndex := SystemSetup.Intrastat.isLastReportMode;

  EnableControls(chkEnableIntrastat.Checked);

  // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
  FIntrastatAudit :=  TSystemSetupTableAudit.Create(atIntrastatSettings);
  FIntrastatAudit.BeforeData := SystemSetup(True).AuditData;      // True = Refresh Settings
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.PopulateLastClosedDates;
begin
  // CJS 2016-01-21 - ABSEXCH-17161 - Invalid Arrivals/Dispatches Closed Dates
  if ValidDate(SystemSetup.Intrastat.isLastClosedArrivalsDate) then
    lblArrivalsDate.Caption := POutDate(SystemSetup.Intrastat.isLastClosedArrivalsDate)
  else
    lblArrivalsDate.Caption := '(No closed arrivals period)';

  if ValidDate(SystemSetup.Intrastat.isLastClosedDispatchesDate) then
    lblDispatchesDate.Caption := POutDate(SystemSetup.Intrastat.isLastClosedDispatchesDate)
  else
    lblDispatchesDate.Caption := '(No closed dispatches period)';
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.btnPrintArrivalsSDClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  if ValidateDateRange then
  begin
    mnuPrintReport.Enabled               := True;
    mnuExportToCSV.Enabled               := True;
    mnuClosePeriodAndPrintReport.Enabled := True;
    mnuClosePeriodAndExportToCSV.Enabled := True;

    if (chkIncludeOutOfPeriodCommodityCodesOnly.Checked) or
       (lstAggregationMode.ItemIndex = 2 {Detailed Audit}) then
    begin
      mnuExportToCSV.Enabled               := False;
      mnuClosePeriodAndExportToCSV.Enabled := False;
    end;

    if (Sender = btnPrintArrivalsSD) then
    begin
      FIntrastatDirection := idArrivals;
      WARNINGDateRangeincludesOpenPeriod1.Visible := DateRangeIncludesOpenPeriod(idArrivals);
      // MH 28/01/2016 2016-R1 ABSEXCH-17229: Modified to check TO date and Workstation Date
      // CJS 2016-02-10 - ABSEXCH-17268 - close period should be disabled for out of period transactions
      if ToDateIsInClosedPeriod(idArrivals) Or ToDateIsInFuture Or chkIncludeOutOfPeriodCommodityCodesOnly.Checked then
      begin
        mnuClosePeriodAndPrintReport.Enabled := False;
        mnuClosePeriodAndExportToCSV.Enabled := False;
      end;
    end
    else
    begin
      FIntrastatDirection := idDispatches;
      WARNINGDateRangeincludesOpenPeriod1.Visible := DateRangeIncludesOpenPeriod(idDispatches);
      // MH 28/01/2016 2016-R1 ABSEXCH-17229: Modified to check TO date and Workstation Date
      // CJS 2016-02-10 - ABSEXCH-17268 - close period should be disabled for out of period transactions
      if ToDateIsInClosedPeriod(idDispatches) Or ToDateIsInFuture Or chkIncludeOutOfPeriodCommodityCodesOnly.Checked then
      begin
        mnuClosePeriodAndPrintReport.Enabled := False;
        mnuClosePeriodAndExportToCSV.Enabled := False;
      end;
    end;

    GetCursorPos(ListPoint);
    mnuPrintPopup.Popup(ListPoint.X, ListPoint.Y);
  end; // if ValidateDateRange then...
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.btnPrintDispatchesSDClick(Sender: TObject);
begin
  btnPrintArrivalsSDClick(Sender);
end;

// -----------------------------------------------------------------------------

// Draw Date Range Warning menu option (on menu pop-up from the two Print buttons)
procedure TfrmIntrastatControlCentre.WARNINGDateRangeincludesOpenPeriod1DrawItem(
  Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var
  ImgID: integer;

  procedure DrawItemText(X: integer;ACanvas: TCanvas;ARect: TRect;Text: string);
  begin
    ARect.Left := X;
    DrawText(ACanvas.Handle, PChar(Text), -1, ARect, DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
  end;

begin
  // Always use the default background colour (i.e. never highlight this entry)
  ACanvas.Brush.Color := clMenu;
  ACanvas.FillRect(ARect) ;

  ImageList1.Draw(ACanvas,2,ARect.Top + 2,0) ;

  ACanvas.Font.Color := clBlack;
  ACanvas.Font.Style := [fsBold];

  // User-defined text drawing function
  DrawItemText(23, ACanvas, ARect, WARNINGDateRangeincludesOpenPeriod1.Caption);
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
  FIntrastatAudit := nil;

  // Tell the main form that we are closing, so that it can set the form
  // pointer variable to nil
  SendMessage(Application.MainForm.Handle, WM_FormCloseMsg, WP_CLOSE_ICC_FORM, 0);
  Action := caFree;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.FormDestroy(Sender: TObject);
begin
  If Assigned(FSettings) And (optStoreCoordinates.Checked Or FColorsChanged) Then
  Begin
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(Self, edtFromDate);
    FSettings.SaveSettings(optStoreCoordinates.Checked);
  End; // If Assigned(FSettings) And (optStoreCoordinates.Checked Or FColorsChanged)
  FSettings := NIL;
  FSystemSetup := NIL;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.PropFlgClick(Sender: TObject);
begin
  If (FSettings.Edit(Self, edtFromDate) = mrOK) Then
    FColorsChanged := True;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.EnableControls(Enable: Boolean);
begin
  // CJS 2016-01-21 - ABSEXCH-17169 - Apply user permissions to Intrastat Control Centre
  if ChkAllowed_In(uaIntrastatChangeSettings) then
  begin
    chkEnableIntrastat.Enabled := True;
    chkShowDeliveryTerms.Enabled := Enable;
    chkShowModeOfTransport.Enabled := Enable;
  end
  else
  begin
    chkEnableIntrastat.Enabled := False;
    chkShowDeliveryTerms.Enabled := False;
    chkShowModeOfTransport.Enabled := False;
  end;
  if ChkAllowed_In(uaIntrastatClosePeriod) then
  begin
    N1.Visible := True;
    mnuClosePeriodAndPrintReport.Visible := True;
    mnuClosePeriodAndExportToCSV.Visible := True;
  end
  else
  begin
    N1.Visible := False;
    mnuClosePeriodAndPrintReport.Visible := False;
    mnuClosePeriodAndExportToCSV.Visible := False;
  end;
  lblIntrastatPeriodControl.Enabled := Enable;
  lblLastClosedIntrastatDateArrivals.Enabled := Enable;
  lblArrivalsDate.Enabled := Enable;
  lblLastClosedIntrastatDateDispatches.Enabled := Enable;
  lblDispatchesDate.Enabled := Enable;
  lblSupplementaryDeclarationReporting.Enabled := Enable;
  lblIntrastatPeriodYear.Enabled := Enable;
  lstIntrastatPeriod.Enabled := Enable;
  lblDateRangeFrom.Enabled := Enable;
  edtFromDate.Enabled := Enable;
  lblDateRangeTo.Enabled := Enable;
  edtToDate.Enabled := Enable;
  if Enable then
  begin
    edtFromDate.Color := clWindow;
    edtFromDate.Font.Color := clWindowText;
    edtToDate.Color := clWindow;
    edtToDate.Font.Color := clWindowText;
    FSettings.SettingsToParent(self);
  end
  else
  begin
    edtFromDate.Color := clBtnFace;
    edtFromDate.Font.Color := clGrayText;
    edtToDate.Color := clBtnFace;
    edtToDate.Font.Color := clGrayText;
  end;
  lblAggregationMode.Enabled := Enable;
  lstAggregationMode.Enabled := Enable;
  lblReportOptions.Enabled := Enable;
  chkIncludeOutOfPeriodCommodityCodesOnly.Enabled := Enable;
  btnPrintArrivalsSD.Enabled := Enable;
  btnPrintDispatchesSD.Enabled := Enable;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.chkEnableIntrastatClick(
  Sender: TObject);
begin
  Syss.Intrastat := chkEnableIntrastat.Checked;
  EnableControls(chkEnableIntrastat.Checked);
  PutMultiSys(SysR, True);
end;

// -----------------------------------------------------------------------------

function TfrmIntrastatControlCentre.DateRangeIncludesOpenPeriod(IntrastatDirection: TIntrastatDirection): Boolean;
begin
  Result := False;
  case IntrastatDirection of
    idArrivals:   begin
                    if (edtFromDate.DateValue > SystemSetup.Intrastat.isLastClosedArrivalsDate) or
                       // MH 28/01/2016 2016-R1 ABSEXCH-17222: Corrected check to AFTER closed date
                       (edtToDate.DateValue > SystemSetup.Intrastat.isLastClosedArrivalsDate) then
                      Result := True;
                  end;
    idDispatches: begin
                    if (edtFromDate.DateValue > SystemSetup.Intrastat.isLastClosedDispatchesDate) or
                       // MH 28/01/2016 2016-R1 ABSEXCH-17222: Corrected check to AFTER closed date
                       (edtToDate.DateValue > SystemSetup.Intrastat.isLastClosedDispatchesDate) then
                      Result := True;
                  end;
  end;
end;

// -----------------------------------------------------------------------------

// MH 28/01/2016 2016-R1 ABSEXCH-17229: Modified to check Workstation Date
function TfrmIntrastatControlCentre.ToDateIsInFuture : Boolean;
Begin // ToDateIsInFuture
  Result := edtToDate.DateValue > Today;
End; // ToDateIsInFuture

//-------------------------------------------------------------------------

// MH 28/01/2016 2016-R1 ABSEXCH-17229: Modified to check TO date
function TfrmIntrastatControlCentre.ToDateIsInClosedPeriod(IntrastatDirection: TIntrastatDirection): Boolean;
begin
  Result := False;
  case IntrastatDirection of
    idArrivals:   begin
                    if (edtToDate.DateValue <= SystemSetup.Intrastat.isLastClosedArrivalsDate) then
                      Result := True;
                  end;
    idDispatches: begin
                    if (edtToDate.DateValue <= SystemSetup.Intrastat.isLastClosedDispatchesDate) then
                      Result := True;
                  end;
  end;
end;

// -----------------------------------------------------------------------------

// CJS 2016-02-01 - ABSEXCH-17235 - Intrastat Control Centre allows To Date earlier than From Date
function TfrmIntrastatControlCentre.ToDateIsBeforeFromDate: Boolean;
begin
  Result := edtToDate.DateValue < edtFromDate.DateValue;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.chkShowDeliveryTermsClick(
  Sender: TObject);
var
  NewValue: string;
begin
  NewValue := IfThen(chkShowDeliveryTerms.Checked, '1', '0');
  if (NewValue <> FOriginalShowDeliveryTerms) then
  begin
    SystemSetup.UpdateValue(siShowDeliveryTerms, FOriginalShowDeliveryTerms, NewValue);
    FOriginalShowDeliveryTerms := NewValue;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.chkShowModeOfTransportClick(
  Sender: TObject);
var
  NewValue: string;
begin
  NewValue := IfThen(chkShowModeOfTransport.Checked, '1', '0');
  if (NewValue <> FOriginalShowModeOfTransport) then
  begin
    SystemSetup.UpdateValue(siShowModeOfTransport, FOriginalShowModeOfTransport, NewValue);
    FOriginalShowModeOfTransport := NewValue;
  end;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.lstIntrastatPeriodChange(
  Sender: TObject);
begin
    UpdateDateRange;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.UpdateDateRange;
var
  Period: string;
  StartDate: string;
  EndDate: string;
begin
  Period := StringReplace(Copy(lstIntrastatPeriod.Text, 1, 6), '/', '', [rfReplaceAll]);
  StartDate := '20' + Copy(Period, 3, 2) + Copy(Period, 1, 2) + '01';
  EndDate := MonthEnd(StartDate);
  edtFromDate.DateValue := StartDate;
  edtToDate.DateValue := EndDate;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.SaveReportSettings;
var
  OldValue: string;
  NewValue: string;
begin
  // Period/Year
  OldValue := FOriginalPeriod;
  NewValue := StringReplace(Copy(lstIntrastatPeriod.Text, 1, 6), '/', '', [rfReplaceAll]);
  if (NewValue <> OldValue) then
  begin
    SystemSetup.UpdateValue(siLastReportPeriodYear, OldValue, NewValue);
    FOriginalPeriod := NewValue;
  end;

  // Date From
  OldValue := FOriginalFromDate;
  NewValue := edtFromDate.DateValue;
  if (NewValue <> OldValue) then
  begin
    SystemSetup.UpdateValue(siLastReportFromDate, OldValue, NewValue);
    FOriginalFromDate := NewValue;
  end;

  // Date To
  OldValue := FOriginalToDate;
  NewValue := edtToDate.DateValue;
  if (NewValue <> OldValue) then
  begin
    SystemSetup.UpdateValue(siLastReportToDate, OldValue, NewValue);
    FOriginalToDate := NewValue;
  end;

  // Aggregation Mode
  OldValue := IntToStr(FOriginalAggregationMode);
  NewValue := IntToStr(lstAggregationMode.ItemIndex);
  if (NewValue <> OldValue) then
  begin
    SystemSetup.UpdateValue(siLastReportMode, OldValue, NewValue);
    FOriginalAggregationMode := StrToInt(NewValue);
  end;

end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.mnuPrintReportClick(Sender: TObject);
begin
  PrintReport;
  SaveReportSettings;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.mnuExportToCSVClick(Sender: TObject);
begin
  ExportToCSV;
  SaveReportSettings;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.mnuClosePeriodAndPrintReportClick(
  Sender: TObject);
begin
  if ClosePeriod then
    PrintReport;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.mnuClosePeriodAndExportToCSVClick(Sender: TObject);
begin
  if ClosePeriod then
    ExportToCSV;
end;

// -----------------------------------------------------------------------------

function TfrmIntrastatControlCentre.ClosePeriod: Boolean;
var
  EndDate: string;
begin
  EndDate := POutDate(edtToDate.DateValue);
  if (MessageDlg('Are you sure you want to close the ' + idDescription[FIntrastatDirection] + ' Intrastat period up to ' + EndDate, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    if FIntrastatDirection = idArrivals then
    begin
      SystemSetup.UpdateValue(siLastClosedArrivalsDate, SystemSetup.Intrastat.isLastClosedArrivalsDate, edtToDate.DateValue);
    end
    else
    begin
      SystemSetup.UpdateValue(siLastClosedDispatchesDate, SystemSetup.Intrastat.isLastClosedDispatchesDate, edtToDate.DateValue);
    end;
    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    SaveReportSettings;

    SystemSetup.Refresh;
    PopulateLastClosedDates;

    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    if Assigned(FIntrastatAudit) Then
    Begin
      // Audit
      FIntrastatAudit.AfterData := SystemSetup.AuditData;
      FIntrastatAudit.WriteAuditEntry;
      // Re-read the 'before' data so that it is up-to-date if the user edits
      // another currency, or re-edits this currency.
      FIntrastatAudit.BeforeData := SystemSetup.AuditData;
    End; // if Assigned(FIntrastatAudit)...

    Result := True;
  end
  else
    Result := False;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.ExportToCSV;
begin
  RunUKIntrastatCSVExport(GetParameters, Self);
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.PrintReport;
begin
  RunUKIntrastatReport(GetParameters, Self);
end;

// -----------------------------------------------------------------------------

//Get parameters for report and put them into record to pass to report functions
function TfrmIntrastatControlCentre.GetParameters : TIntrastatParametersRec;
var
  APeriod : Byte;
  AYear : Byte;
  sPeriod : string;
begin

  //Get period and year bytes from list text
  with lstIntrastatPeriod do
  begin
    APeriod := StrToInt(Copy(Items[ItemIndex], 1, 2));
    AYear   := 100 + StrToInt(Copy(Items[ItemIndex], 4, 2));
  end;

  Result.StartDate := edtFromDate.DateValue;
  Result.EndDate := edtToDate.DateValue;
  Result.Period := APeriod;
  Result.Year   := AYear;
  Result.ISReportMode := TIntrastatReportMode(lstAggregationMode.ItemIndex);
  Result.ISDirection := FIntrastatDirection;

  //PR: 29/01/2016 ABSEXCH-17208 v2016 R1 Set out of period flag
  Result.OutOfPeriodOnly := chkIncludeOutOfPeriodCommodityCodesOnly.Checked;
end;

// -----------------------------------------------------------------------------

procedure TfrmIntrastatControlCentre.edtToDateExit(Sender: TObject);
begin
  ValidateDateRange;
end;

// -----------------------------------------------------------------------------

function TfrmIntrastatControlCentre.ValidateDateRange: Boolean;
begin
  Result := True;
  if ToDateIsBeforeFromDate then
  begin
    MessageDlg('"From" date is later than "To" date', mtError, [mbOk], 0);
    if edtFromDate.CanFocus then
      edtFromDate.SetFocus;
    Result := False;
  end;
end;

end.
