unit ECSalesCriteriaDlgU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, TEditVal, Mask, bkgroup, GlobVar, BTSupU3;

type
  TECSalesCriteriaDlg = class(TForm)
    SBSBackGroup1: TSBSBackGroup;
    ReportContentGrp: TSBSBackGroup;
    ExportGrp: TSBSBackGroup;
    ReportByMonthChk: TRadioButton;
    ReportByQuarterChk: TRadioButton;
    ReportByRangeChk: TRadioButton;
    StartDateEdt: TEditDate;
    EndDateEdt: TEditDate;
    Label81: Label8;
    MonthCmb: TComboBox;
    MonthYearEdt: TEdit;
    MonthYearSpin: TUpDown;
    QuarterCmb: TComboBox;
    QuarterYearEdt: TEdit;
    QuarterYearSpin: TUpDown;
    ReportOnGoodsChk: TCheckBox;
    ReportOnServicesChk: TCheckBox;
    ReportContentLbl: TLabel;
    Label2: TLabel;
    CheckGoodsBtn: TButton;
    CancelBtn: TButton;
    OkBtn: TButton;
    SaveDialog: TSaveDialog;
    ExportLbl: TLabel;
    FilenameEdt: TEdit;
    SelectFilenameBtn: TButton;
    procedure EnableControls(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelBtnClick(Sender: TObject);
    procedure MonthCmbExit(Sender: TObject);
    procedure QuarterCmbExit(Sender: TObject);
    procedure SelectFilenameBtnClick(Sender: TObject);
    procedure CheckGoodsBtnClick(Sender: TObject);
    procedure FilenameEdtExit(Sender: TObject);
    procedure Label2DblClick(Sender: TObject);
    procedure QuarterYearEdtExit(Sender: TObject);
    procedure MonthYearEdtExit(Sender: TObject);
  private
    FRepParam: CVATRepPtr;
    FPageTitle: string;
    ForExport: Boolean;
    //AP:20/07/2017-ABSEXCH-//15994:EC Sales List Summary - No standard report showing what makes these figures up
    ECSalesRepMode: Integer;
    procedure ForceToShortFileName;
    procedure HideExportControls;
    procedure HideReportContentControls;
    procedure ReadDateRange;
    procedure ShowExportControls;
    procedure StartReport(AECSalesRepMode: Integer);
    procedure SuggestDates(LastDate: LongDate; var StartDate, EndDate: LongDate);
  public
    constructor CreateForReport(AOwner: TComponent);
    constructor CreateForExport(AOwner: TComponent);
  end;

procedure ECSalesReport(AOwner: TComponent);
procedure ECSalesExport(AOwner: TComponent);

var
  ECSalesCriteriaDlg: TECSalesCriteriaDlg;

implementation

{$R *.dfm}

uses DateUtils, ETDateU, ETMiscU, VarConst, ReportAU, VATEdiTU, StrUtil,
  ECGoodsThresholdDlgU, ECSalesDetailedReport;  

// -----------------------------------------------------------------------------

procedure ECSalesReport(AOwner: TComponent);
var
  Dlg: TECSalesCriteriaDlg;
begin
  Dlg := TECSalesCriteriaDlg.CreateForReport(AOwner);
end;

// -----------------------------------------------------------------------------

procedure ECSalesExport(AOwner: TComponent);
var
  Dlg: TECSalesCriteriaDlg;
begin
  Dlg := TECSalesCriteriaDlg.CreateForExport(AOwner);
end;

// =============================================================================
// TECSalesCriteriaDlg
// =============================================================================
procedure TECSalesCriteriaDlg.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.CheckGoodsBtnClick(Sender: TObject);
var
  Dlg: TECGoodsThresholdDlg;
var
  Ld, Lm, Ly: Word;
begin
  Dlg := TECGoodsThresholdDlg.Create(nil);
  try
    ReadDateRange;

    { Calculate the quarter date }
    DateStr(FRepParam^.VATStartD, Ld, Lm, Ly);

    Lm := (((Lm - 1) div 3) * 3) + 1;
    Dlg.StartDate := StrDate(Ly, Lm, Ld);

    { Calculate the end date }
    AdjMnth(Lm, Ly, 2);
    Ld := Monthdays[Lm];
    Dlg.EndDate := StrDate(Ly, Lm, Ld);

    Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

// -----------------------------------------------------------------------------

constructor TECSalesCriteriaDlg.CreateForExport(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HelpContext := 8058;
  ForExport := True;
  if not SyssVAT.VATRates.EnableECServices then
    HideReportContentControls;
  Caption := 'EC Sales List Export';
end;

// -----------------------------------------------------------------------------

constructor TECSalesCriteriaDlg.CreateForReport(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HelpContext := 8056;
  ForExport := False;
  HideExportControls;
  if not SyssVAT.VATRates.EnableECServices then
    HideReportContentControls;
  //AP:20/07/2017-ABSEXCH-//15994:EC Sales List Summary - No standard report showing what makes these figures up
  if AOwner is TMenuItem then
  begin
    ECSalesRepMode := TMenuItem(AOwner).Tag;
    case TMenuItem(AOwner).Tag of   
      0 : Caption := 'EC Sales List Report';
      1 : Caption := 'EC Sales List Breakdown';
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.EnableControls(Sender: TObject);
begin
  MonthCmb.Enabled          := False;
  MonthCmb.Color            := clBtnFace;
  MonthCmb.Font.Color       := clGrayText;
  MonthCmb.SelLength        := 0;
  MonthYearEdt.Enabled      := False;
  MonthYearEdt.Color        := clBtnFace;
  MonthYearEdt.Font.Color   := clGrayText;
  MonthYearSpin.Enabled     := False;
  QuarterCmb.Enabled        := False;
  QuarterCmb.Color          := clBtnFace;
  QuarterCmb.Font.Color     := clGrayText;
  QuarterCmb.SelLength      := 0;
  QuarterYearEdt.Enabled    := False;
  QuarterYearEdt.Color      := clBtnFace;
  QuarterYearEdt.Font.Color := clGrayText;
  QuarterYearSpin.Enabled   := False;
  StartDateEdt.Enabled      := False;
  StartDateEdt.Color        := clBtnFace;
  StartDateEdt.Font.Color   := clGrayText;
  EndDateEdt.Enabled        := False;
  EndDateEdt.Color          := clBtnFace;
  EndDateEdt.Font.Color     := clGrayText;
  if ReportByMonthChk.Checked then
  begin
    MonthCmb.Enabled        := True;
    // CA ABSEXCH-12952/81 Changed from clWindow and clWindowText to below
    MonthCmb.Color          := clWhite;
    MonthCmb.Font.Color     := clNavy;
    MonthCmb.SelLength      := 0;
    MonthYearEdt.Enabled    := True;
    // CA ABSEXCH-12952/81 Changed from clWindow and clWindowText to below
    MonthYearEdt.Color      := clWhite;
    MonthYearEdt.Font.Color := clNavy;
    MonthYearSpin.Enabled   := True;
  end
  else if ReportByQuarterChk.Checked then
  begin
    QuarterCmb.Enabled        := True;
    // CA ABSEXCH-12952/81 Changed from clWindow and clWindowText to below
    QuarterCmb.Color          := clWhite;
    QuarterCmb.Font.Color     := clNavy;
    QuarterCmb.SelLength      := 0;
    QuarterYearEdt.Enabled    := True;
    // CA ABSEXCH-12952/81 Changed from clWindow and clWindowText to below
    QuarterYearEdt.Color      := clWhite;
    QuarterYearEdt.Font.Color := clNavy;
    QuarterYearSpin.Enabled   := True;
  end
  else if ReportByRangeChk.Checked then
  begin
    StartDateEdt.Enabled    := True;
    // CA ABSEXCH-12952/81 Changed from clWindow and clWindowText to below
    StartDateEdt.Color      := clWhite;
    StartDateEdt.Font.Color := clNavy;
    EndDateEdt.Enabled      := True;
    // CA ABSEXCH-12952/81 Changed from clWindow and clWindowText to below
    EndDateEdt.Color        := clWhite;
    EndDateEdt.Font.Color   := clNavy;
  end;
  CheckGoodsBtn.Enabled :=
    ReportOnGoodsChk.Checked and
    (ReportByMonthChk.Checked or ReportByQuarterChk.Checked);
  OkBtn.Enabled := (ReportOnGoodsChk.Checked or ReportOnServicesChk.Checked);
  if (OkBtn.Enabled and ForExport) then
    OkBtn.Enabled := (Trim(FilenameEdt.Text) <> '');
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.FilenameEdtExit(Sender: TObject);
begin
  ForceToShortFileName;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.ForceToShortFileName;
var
  BaseFileName, Path, Ext: string;
begin
  Ext := ExtractFileExt(FilenameEdt.Text);
  BaseFileName := Copy(JustFilename(FilenameEdt.Text), 1, 8);
  Path := ExtractFilePath(FilenameEdt.Text);
  if (Path <> '') then
    Path := IncludeTrailingPathDelimiter(Path);
  FilenameEdt.Text := Path + BaseFilename + Ext;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 { if (Assigned(FRepParam)) then
    Dispose(FRepParam);        }
  Action := caFree;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.FormCreate(Sender: TObject);
begin
  New(FRepParam);
  try
    FillChar(FRepParam^, Sizeof(FRepParam^), 0);
    SuggestDates(SyssVAT.VATRates.LastECSalesDate,
                 FRepParam^.VATStartD,
                 FRepParam^.VATEndD);
    FilenameEdt.Text := SetDrive + 'Q' +
                        IntToStr(QuarterCmb.ItemIndex + 1) +
                        IntToStr(QuarterYearSpin.Position) + '.csv';
  except
    Dispose(FRepParam);
    FRepParam := nil;
  end;
  EnableControls(nil);
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.HideExportControls;
begin
  ExportGrp.Visible := False;
  ExportLbl.Visible := False;
  FilenameEdt.Visible := False;
  SelectFilenameBtn.Visible := False;

  CheckGoodsBtn.Top := CheckGoodsBtn.Top - ExportGrp.Height;
  OkBtn.Top         := OkBtn.Top - ExportGrp.Height;
  CancelBtn.Top     := CancelBtn.Top - ExportGrp.Height;
  Height            := Height - ExportGrp.Height;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.HideReportContentControls;
begin
  ReportContentGrp.Visible    := False;
  ReportContentLbl.Visible    := False;
  ReportOnGoodsChk.Visible    := False;
  ReportOnServicesChk.Visible := False;
  ReportOnGoodsChk.Checked    := True;
  if ExportGrp.Visible then
  begin
    ExportGrp.Top := ExportGrp.Top - ReportContentGrp.Height;
    ExportLbl.Top := ExportLbl.Top - ReportContentGrp.Height;
    FilenameEdt.Top := FilenameEdt.Top - ReportContentGrp.Height;
    SelectFilenameBtn.Top := SelectFilenameBtn.Top - ReportContentGrp.Height;
  end;
  CheckGoodsBtn.Top := CheckGoodsBtn.Top - ReportContentGrp.Height;
  OkBtn.Top         := OkBtn.Top - ReportContentGrp.Height;
  CancelBtn.Top     := CancelBtn.Top - ReportContentGrp.Height;
  Height            := Height - ReportContentGrp.Height;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.MonthCmbExit(Sender: TObject);
begin
  MonthCmb.SelLength := 0;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.OkBtnClick(Sender: TObject);
begin
  // MH 06/01/2011 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
  //                                   fields which processes the text and updates the value
  If (ActiveControl <> OkBtn) Then
    // Move focus to OK button to force any OnExit validation to occur
    OkBtn.SetFocus;

  // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
  If (ActiveControl = OkBtn) Then
    if (not ForExport) or (not FileExists(FilenameEdt.Text)) or
       (MessageDlg(ExtractFilename(FilenameEdt.Text) +
                   ' already exists in that directory. Overwrite?',
                   mtConfirmation,[mbYes,mbNo],0) = mrYes) then
    begin
      //AP:20/07/2017-ABSEXCH-//15994:EC Sales List Summary - No standard report showing what makes these figures up
      StartReport(ECSalesRepMode);
      Close;
    end;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.QuarterCmbExit(Sender: TObject);
begin
  QuarterCmb.SelLength := 0;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.ReadDateRange;
var
  Year, Month: Word;
begin
  if ReportByMonthChk.Checked then
  begin
    Year := MonthYearSpin.Position;
    Month := MonthCmb.ItemIndex + 1;
    FRepParam^.VATStartD := StrDate(Year, Month, 1);
    FRepParam^.VATEndD   := StrDate(Year, Month, DaysInAMonth(Year, Month));
    FPageTitle := 'Value Added Tax EC Sales list, for ' + MonthCmb.Text + ' ' + IntToStr(Year);
  end
  else if ReportByQuarterChk.Checked then
  begin
    Year  := QuarterYearSpin.Position;
    Month := (QuarterCmb.ItemIndex * 3) + 1;
    FRepParam^.VATStartD := StrDate(Year, Month, 1);
    FRepParam^.VATEndD   := StrDate(Year, Month + 2, DaysInAMonth(Year, Month + 2));
    FPageTitle := 'Value Added Tax EC Sales list, for Quarter ' +
                  IntToStr(QuarterCmb.ItemIndex + 1) + ', ' +
                  IntToStr(Year);
  end
  else if ReportByRangeChk.Checked then
  begin
    FRepParam^.VATStartD := StartDateEdt.DateValue;
    FRepParam^.VATEndD   := EndDateEdt.DateValue;
    FPageTitle := 'Value Added Tax EC Sales list, for the period ' +
                  PoutDate(FRepParam^.VATStartD) + ' to ' +
                  PoutDate(FRepParam^.VATEndD);
  end;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.SelectFilenameBtnClick(Sender: TObject);
begin
  SaveDialog.Filename   := ExtractFilename(FilenameEdt.Text);
  SaveDialog.InitialDir := ExtractFilePath(FilenameEdt.Text);
  if SaveDialog.Execute then
  begin
    FilenameEdt.Text := SaveDialog.Filename;
    ForceToShortFileName;
  end;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.ShowExportControls;
begin
  Height            := Height + ExportGrp.Height;
  CheckGoodsBtn.Top := CheckGoodsBtn.Top + ExportGrp.Height;
  OkBtn.Top         := OkBtn.Top + ExportGrp.Height;
  CancelBtn.Top     := CancelBtn.Top + ExportGrp.Height;

  ExportGrp.Visible         := True;
  ExportLbl.Visible         := True;
  FilenameEdt.Visible       := True;
  SelectFilenameBtn.Visible := True;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.StartReport(AECSalesRepMode: Integer);
begin
  ReadDateRange;
  FRepParam.EDIHedTit := 'EC Sales List';
  if ForExport then
    AddVATEDI2Thread(Application.MainForm, EC_SALES_EXPORT_MODE, FRepParam,
                     FilenameEdt.Text, ReportOnGoodsChk.Checked,
                     ReportOnServicesChk.Checked)
  else
  begin
    //AP:20/07/2017-ABSEXCH-//15994:EC Sales List Summary - No standard report showing what makes these figures up
    if (AECSalesRepMode = 0) then  
      AddECVATRep2Thread(EC_SALES_REPORT_MODE, FRepParam, Owner,
                       ReportOnGoodsChk.Checked, ReportOnServicesChk.Checked,
                       FPageTitle, True)
    else
    if (AECSalesRepMode = 1) then
      ECSalesDetailed_Report(Owner, FRepParam,
                       ReportOnGoodsChk.Checked, ReportOnServicesChk.Checked);
  end;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.SuggestDates(LastDate: LongDate;
  var StartDate, EndDate: LongDate);
{ Copied from Get_ECSuggest in RepInpFU.pas and amended }
var
  Ld, Lm, Ly: Word;
begin
  { Calculate a new start date }
  DateStr(LastDate, Ld, Lm, Ly);
  StartDate := StrDate(Ly, Lm, Ld);

  { Update the controls }
  MonthCmb.ItemIndex := Lm - 1;
  MonthYearSpin.Position := Ly;

  QuarterCmb.ItemIndex := (Lm - 1) div 3;
  QuarterYearSpin.Position := Ly;

  StartDateEdt.DateValue := StartDate;

  { Calculate a new end date. If the last report date was the start of a
    quarter, calculate the end of the quarter, otherwise calculate the end
    of the month. }
  if (((Lm - 1) mod 3) = 0) then
    AdjMnth(Lm, Ly, 2);
  Ld := DaysInAMonth(Ly, Lm);
  EndDate := StrDate(Ly, Lm, Ld);

  { Update the controls }
  EndDateEdt.DateValue := EndDate;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.Label2DblClick(Sender: TObject);
begin
  ShowMessage('Last report date: ' + SyssVAT.VATRates.LastECSalesDate);
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.QuarterYearEdtExit(Sender: TObject);
var
  Year: Integer;
begin
  Year := StrToIntDef(QuarterYearEdt.Text, 0);
  if (Year < QuarterYearSpin.Min) or (Year > QuarterYearSpin.Max) then
  begin
    ShowMessage('"' + QuarterYearEdt.Text + '" is not a valid year');
    if QuarterYearEdt.CanFocus then
      QuarterYearEdt.SetFocus;
  end
  else
  begin
    QuarterYearSpin.Position := StrToInt(QuarterYearEdt.Text);
  end;
end;

// -----------------------------------------------------------------------------

procedure TECSalesCriteriaDlg.MonthYearEdtExit(Sender: TObject);
var
  Year: Integer;
begin
  Year := StrToIntDef(MonthYearEdt.Text, 0);
  if (Year < MonthYearSpin.Min) or (Year > MonthYearSpin.Max) then
  begin
    ShowMessage('"' + MonthYearEdt.Text + '" is not a valid year');
    if MonthYearEdt.CanFocus then
      MonthYearEdt.SetFocus;
  end
  else
  begin
    MonthYearSpin.Position := StrToInt(MonthYearEdt.Text);
  end;
end;

// -----------------------------------------------------------------------------

end.
