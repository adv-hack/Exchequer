unit TimesheetLineFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AdvEdit, AdvCombo, ColCombo, AdvOfficePager,
  AdvOfficePagerStylers, AdvGlowButton, TTimesheetDataClass, Enterprise01_TLB, CtkUtil,
  ExtCtrls, TEmployeeRateClass, TTimesheetIniClass;

type
  TPopType = (ptAll, ptCC, ptDept, ptCurr, ptJobs, ptRate, ptAnalysis, ptEmp, ptUser, ptAssUser, ptTsStatus, ptNoteGen, ptUDFs);

  TTimesheetLineEvent = procedure(sender: TObject) of object;
  TFrameTimesheetLine = class(TFrame)
    gbTransactionLine: TGroupBox;
    lblNarrative: TLabel;
    lblRateAnalysisCodes: TLabel;
    lblJobCode: TLabel;
    lblDay1: TLabel;
    lblDay2: TLabel;
    lblDay3: TLabel;
    lblDay4: TLabel;
    lblDay5: TLabel;
    lblDay6: TLabel;
    lblDay7: TLabel;
    lblDate1: TLabel;
    lblDate2: TLabel;
    lblDate3: TLabel;
    lblDate4: TLabel;
    lblDate5: TLabel;
    lblDate6: TLabel;
    lblDate7: TLabel;
    lblHrsQty: TLabel;
    xlblChargeOutCurrency: TLabel;
    xlblCostHourCurrency: TLabel;
    lblChargeOutRate: TLabel;
    lblCostHour: TLabel;
    lblTLUDF1: TLabel;
    lblTLUDF2: TLabel;
    ccbCostCentre: TColumnComboBox;
    ccbDepartment: TColumnComboBox;
    edtNarrative: TAdvEdit;
    ccbRateCode: TColumnComboBox;
    ccbAnalysisCode: TColumnComboBox;
    ccbJobCode: TColumnComboBox;
    edtDay1: TAdvEdit;
    edtDay2: TAdvEdit;
    edtDay3: TAdvEdit;
    edtDay4: TAdvEdit;
    edtDay5: TAdvEdit;
    edtDay6: TAdvEdit;
    edtDay7: TAdvEdit;
    edtHrsQty: TAdvEdit;
    edtTotChargeOutRate: TAdvEdit;
    edtTotCostHour: TAdvEdit;
    edtTLUDF1: TAdvEdit;
    edtTLUDF2: TAdvEdit;
    lblRateCode: TLabel;
    edtChargeOutRate: TAdvEdit;
    edtCostHour: TAdvEdit;
    lblTLUDF7: TLabel;
    lblTLUDF8: TLabel;
    edtTLUDF7: TAdvEdit;
    edtTLUDF8: TAdvEdit;
    lblTLUDF9: TLabel;
    lblTLUDF10: TLabel;
    edtTLUDF9: TAdvEdit;
    edtTLUDF10: TAdvEdit;
    lblTLUDF5: TLabel;
    edtTLUDF5: TAdvEdit;
    lblTLUDF6: TLabel;
    edtTLUDF6: TAdvEdit;
    cbDelete: TCheckBox;
    procedure cbDeleteClick(Sender: TObject);
    procedure ccbAnalysisCodeChange(Sender: TObject);
    procedure ccbCostCentreChange(Sender: TObject);
    procedure ccbDepartmentChange(Sender: TObject);
    procedure ccbJobCodeChange(Sender: TObject);
    procedure ccbRateCodeChange(Sender: TObject);
    procedure edtChargeOutRateExit(Sender: TObject);
    procedure edtCostHourExit(Sender: TObject);
    procedure edtDay1Exit(Sender: TObject);
    procedure edtDay1KeyPress(Sender: TObject; var Key: Char);
    procedure edtHrsQtyExit(Sender: TObject);
    procedure edtNarrativeChange(Sender: TObject);
    procedure edtTLUDF1Change(Sender: TObject);
    procedure edtTLUDF2Change(Sender: TObject);
    procedure edtTLUDF5Change(Sender: TObject);
    procedure edtTLUDF6Change(Sender: TObject);
    procedure edtTLUDF7Change(Sender: TObject);
    procedure edtTLUDF8Change(Sender: TObject);
    procedure edtTLUDF9Change(Sender: TObject);
    procedure edtTLUDF10Change(Sender: TObject);
  private
    FBoxWasEdited: Boolean;
    FTimesheetLine: TTimesheetLine;
    FRecalcTotals: TTimesheetLineEvent;
    FDataPath: string;
    FDeleteClick: TTimesheetLineEvent;
    FLineChanged: TTimesheetLineEvent;
    FIgnoreChanges: boolean;
    FEmpCode: string;
    FPrecision: integer;
    FUseCCDeps: boolean;
    procedure ChangeLineCaption;
    procedure DisableDayBoxes(TheParent: TWinControl; EnableFlag: boolean);
    procedure DoLineChanged(Recalc: boolean);
    procedure RecalcHrsQtyEtc;
    procedure PopulateBoxesEtc;
    procedure SetColors;
    procedure SetTimesheetLine(const Value: TTimesheetLine);
    procedure PopulateCCDeptCurrListsEtc(LoggedIn: boolean; PopWhat: TPopType);
    procedure SetPrecision(const Value: integer);
    procedure HideRestrictedControls;
    procedure RebuildRateCodeList;
  public
    procedure FillComboBoxes;
    property DataPath: string read FDataPath write FDatapath;
    property EmpCode: string read FEmpCode write FEmpCode;
    property IgnoreChanges: boolean read FIgnoreChanges write FIgnoreChanges;
    property TimesheetLine: TTimesheetLine read FTimesheetLine write SetTimesheetLine;
    property OnDeleteClick: TTimesheetLineEvent read FDeleteClick write FDeleteClick;
    property OnRecalcTotals: TTimesheetLineEvent read FRecalcTotals write FRecalcTotals;
    property OnLineChanged: TTimesheetLineEvent read FLineChanged write FLineChanged;
    property Precision: integer read FPrecision write SetPrecision;
    property UseCCDeps: boolean read FUseCCDeps write FUseCCDeps;
  end;

implementation

{$R *.dfm}

procedure TFrameTimesheetLine.cbDeleteClick(Sender: TObject);
begin
  TimesheetLine.MarkedForDeletion := cbDelete.Checked;

  SetColors;

  if assigned(FDeleteClick) then FDeleteClick(self);
end;

procedure TFrameTimesheetLine.ccbAnalysisCodeChange(Sender: TObject);
begin
  ChangeLineCaption;
  FTimesheetLine.AnalysisCode := ccbAnalysisCode.ColumnItems[ccbAnalysisCode.ItemIndex, 0];
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.ccbCostCentreChange(Sender: TObject);
begin
  FTimesheetLine.CostCentre := ccbCostCentre.ColumnItems[ccbCostCentre.ItemIndex, 0];
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.ccbDepartmentChange(Sender: TObject);
begin
  FTimesheetLine.Department := ccbDepartment.ColumnItems[ccbDepartment.ItemIndex, 0];
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.RebuildRateCodeList;
var
  i: integer;
begin
 with TEmployeeRate.Create do begin
   DataPath := FDataPath;
   FindRates(FEmpCode, ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 0], ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 0]);
   ccbRateCode.ComboItems.Clear;
   for i := 0 to RateCodes.Count - 1 do
     with TRateCode(RateCodes[i]) do
       with ccbRateCode.ComboItems.Add do begin
         strings.Add(trim(rcRateCode));
         strings.Add(trim(rcDesc));
         strings.Add(trim(rcAnalysisCode));
       end;

 end;
 lblRateCode.Visible := ccbRateCode.ComboItems.Count = 0; // "No rates set for this job / employee"
 lblRateAnalysisCodes.Visible := ccbRateCode.ComboItems.Count > 0; // "Rate / Analysis Code"
end;

procedure TFrameTimesheetLine.ccbJobCodeChange(Sender: TObject);
begin
  FTimesheetLine.JobCode := ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 0];
  RebuildRateCodeList;
  ChangeLineCaption;
  DoLineChanged(true);
end;

procedure TFrameTimesheetLine.ccbRateCodeChange(Sender: TObject);
begin
  ChangeLineCaption;
  FTimesheetLine.RateCode := ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 0];

  if ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 2] <> '' then begin
    ccbAnalysisCode.ItemIndex := ccbAnalysisCode.ComboItems.IndexInColumnOf(0, ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 2]); // 2nd column of ccbRateCode contains the AnalysisCode
    ccbAnalysisCodeChange(nil);
  end;

  DoLineChanged(true);
end;

procedure TFrameTimesheetLine.PopulateCCDeptCurrListsEtc(LoggedIn: boolean; PopWhat: TPopType);
var
  toolkit: IToolkit2;
  i : SmallInt;
  CCDept: ICCDept;
  res: integer;
  JobAnalysis: IJobAnalysis;
  TimeRates: ITimeRates;
  Job: IJob;

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

  toolkit := OpenToolkit(FDataPath, true) as IToolkit2;
  try


    if (PopWhat in [ptAll, ptCC]) then begin
      ccbCostCentre.ComboItems.Clear;
      if LoggedIn then
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
           //     strings.Add(trim(cdName));
              end;
              res := GetNext;
            end;
          end;
//          ccbCostCentre.ItemIndex := ccbCostCentre.ComboItems.IndexInColumnOf(0, TimesheetLine.CostCentre);
//          if (ccbCostCentre.ItemIndex = -1) and (ccbCostCentre.ComboItems.Count > 0) then ccbCostCentre.ItemIndex := 0;
        finally
          CCDept := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptDept]) then begin
      ccbDepartment.ComboItems.Clear;
      if LoggedIn then
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
//          ccbDepartment.ItemIndex := ccbDepartment.ComboItems.IndexInColumnOf(0, TimesheetLine.Department);
//          if (ccbDepartment.ItemIndex = -1) and (ccbDepartment.ComboItems.Count > 0) then ccbDepartment.ItemIndex := 0;
        finally
          CCDept := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptJobs]) then begin
      ccbJobCode.ComboItems.Clear;
      if LoggedIn then begin
        Job := Toolkit.JobCosting.Job;
        if assigned(Job) then
        try
          with Job do begin
            index := jrIdxCode;
            res   := GetFirst;
            while res = 0 do begin
              if (jrStatus = jStatusActive) and (jrType = JTypeJob) then
                with ccbJobCode.ComboItems.Add do begin
                  strings.Add(trim(jrCode));
                  strings.Add(trim(jrDesc));
                end;
              res := GetNext;
            end;
          end;
//          ccbJobCode.ItemIndex := ccbJobCode.ComboItems.IndexInColumnOf(0, TimesheetLine.JobCode);
//          if (ccbJobCode.ItemIndex = -1) and (ccbJobCode.ComboItems.Count > 0) then ccbJobCode.ItemIndex := 0;
        finally
          Job := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptRate]) then begin
      ccbRateCode.ComboItems.Clear;
      if LoggedIn then begin
        TimeRates := Toolkit.JobCosting.TimeRates;
        if assigned(TimeRates) then
        try
          with TimeRates do begin
            res := GetFirst;
            while res = 0 do begin
              with ccbRateCode.ComboItems.Add do begin
                strings.Add(trim(trRateCode));
                strings.Add(trim(trDescription));
                strings.Add(trim(trAnalysisCode));
              end;
              res := GetNext;
            end;
//            ccbRateCode.ItemIndex := ccbRateCode.ComboItems.IndexInColumnOf(0, TimesheetLine.RateCode);
//            if (ccbRateCode.ItemIndex = -1) and (ccbRateCode.ComboItems.Count > 0) then ccbRateCode.ItemIndex := 0;
          end;
        finally
          TimeRates := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptAnalysis]) then begin
      ccbAnalysisCode.ComboItems.Clear;
      if LoggedIn then begin
        JobAnalysis := Toolkit.JobCosting.JobAnalysis;
        if assigned(JobAnalysis) then
        try
          with JobAnalysis do begin
            index := anIdxCode;
            res   := GetFirst;
            while res = 0 do begin
              with ccbAnalysisCode.ComboItems.Add do begin
                strings.Add(trim(anCode));
                strings.Add(trim(anDescription));
              end;
              res := GetNext;
            end;
//            ccbAnalysisCode.ItemIndex := ccbAnalysisCode.ComboItems.IndexInColumnOf(0, TimesheetLine.AnalysisCode);
//            if (ccbAnalysisCode.ItemIndex = -1) and (ccbAnalysisCode.ComboItems.Count > 0) then ccbAnalysisCode.ItemIndex := 0;
          end;
        finally
          JobAnalysis := nil;
        end;
      end;
    end;

  finally
    toolkit := nil;
  end;
//  btnSave.enabled := true;
end;

procedure TFrameTimesheetLine.DisableDayBoxes(TheParent: TWinControl; EnableFlag: boolean);
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

procedure TFrameTimesheetLine.edtDay1Exit(Sender: TObject);
begin
  if FBoxWasEdited then begin
    edtHrsQty.FloatValue := edtDay1.FloatValue + edtDay2.FloatValue + edtDay3.FloatValue + edtDay4.FloatValue + edtDay5.FloatValue + edtDay6.FloatValue + edtDay7.FloatValue;

    FTimesheetLine.HoursForDay[TComponent(Sender).Tag] := TAdvEdit(Sender).FloatValue;
    DoLineChanged(true);
  end;
  FBoxWasEdited := false;
end;

procedure TFrameTimesheetLine.edtHrsQtyExit(Sender: TObject);
begin
  if FBoxWasEdited then begin
    edtDay1.FloatValue := 0; edtDay2.FloatValue := 0; edtDay3.FloatValue := 0; edtDay4.FloatValue := 0;
    edtDay5.FloatValue := 0; edtDay6.FloatValue := 0; edtDay7.FloatValue := 0;

    with FTimesheetLine do begin
      HoursForDay[1] := 0; HoursForDay[2] := 0; HoursForDay[3] := 0; HoursForDay[4] := 0;
      HoursForDay[5] := 0; HoursForDay[6] := 0; HoursForDay[7] := 0;
    end;

    RecalcHrsQtyEtc;
    if assigned(FRecalcTotals) then FRecalcTotals(self);
  end;
  FBoxWasEdited := false;
end;

procedure TFrameTimesheetLine.PopulateBoxesEtc;
begin
  with FTimesheetLine do begin
    edtNarrative.Text              := Narrative;
    edtHrsQty.FloatValue           := Hours;
    edtChargeOutRate.FloatValue    := ChargeOutRate;
    edtCostHour.FloatValue         := CostPerHour;
    edtCostHour.Prefix := {lblCostHourCurrency.Caption    :=} GCurrencySymbols[CostCurrency] + ' ';
    edtTotCostHour.Prefix          := GCurrencySymbols[CostCurrency] + ' ';
    edtChargeOutRate.Prefix := {lblChargeOutCurrency.Caption   :=} GCurrencySymbols[ChargeCurrency] + ' ';
    edtTotChargeOutRate.Prefix     := GCurrencySymbols[ChargeCurrency] + ' ';
    edtTotChargeOutRate.FloatValue := ChargeOutRate * Hours;
    edtTotCostHour.FloatValue      := CostPerHour * Hours;

    cbDelete.Checked            := MarkedForDeletion;

    ccbCostCentre.ItemIndex := ccbCostCentre.ComboItems.IndexInColumnOf(0, CostCentre);
    if (ccbCostCentre.ItemIndex = -1) and (ccbCostCentre.ComboItems.Count > 0) then begin
      ccbCostCentre.ItemIndex := 0;
      TimesheetLine.CostCentre := ccbCostCentre.ColumnItems[0, 0];
    end;

    ccbDepartment.ItemIndex := ccbDepartment.ComboItems.IndexInColumnOf(0, Department);
    if (ccbDepartment.ItemIndex = -1) and (ccbDepartment.ComboItems.Count > 0) then begin
      ccbDepartment.ItemIndex := 0;
      TimesheetLine.Department := ccbDepartment.ColumnItems[0, 0];
    end;

    if TimesheetLine.JobCode = '' then begin
      ccbJobCode.ItemIndex := ccbJobCode.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultJobCode);
      FTimesheetLine.JobCode := ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 0]; // v13
      // ccbJobCode.ItemIndex := -1           // New line: forcing user to select a job will result in a call to TEmployeeRateClass.FindRates
    end
    else begin
      ccbJobCode.ItemIndex := ccbJobCode.ComboItems.IndexInColumnOf(0, TimesheetLine.JobCode);
      // if (ccbJobCode.ItemIndex = -1) and (ccbJobCode.ComboItems.Count > 0) then begin
        // ccbJobCode.ItemIndex := 0; // v13 No No No - we shouldn't be changing the Job Code on an existing transaction line !
        // TimesheetLine.JobCode := ccbJobCode.ColumnItems[0, 0]; // v13 see above
      // end;
    end;
    RebuildRateCodeList; // v12

    ccbRateCode.ItemIndex := ccbRateCode.ComboItems.IndexInColumnOf(0, RateCode);
    if (ccbRateCode.ItemIndex = -1) and (ccbRateCode.ComboItems.Count > 0) then begin
      ccbRateCode.ItemIndex := 0;
      TimesheetLine.RateCode := ccbRateCode.ColumnItems[0, 0];
    end;

    ccbAnalysisCode.ItemIndex := ccbAnalysisCode.ComboItems.IndexInColumnOf(0, AnalysisCode);
    if (ccbAnalysisCode.ItemIndex = -1) and (ccbAnalysisCode.ComboItems.Count > 0) then begin
      ccbAnalysisCode.ItemIndex := 0;
      TimesheetLine.AnalysisCode := ccbAnalysisCode.ColumnItems[0, 0];
    end;
  end;

  edtDay1.FloatValue := TimesheetLine.HoursForDay[1];
  edtDay2.FloatValue := TimesheetLine.HoursForDay[2];
  edtDay3.FloatValue := TimesheetLine.HoursForDay[3];
  edtDay4.FloatValue := TimesheetLine.HoursForDay[4];
  edtDay5.FloatValue := TimesheetLine.HoursForDay[5];
  edtDay6.FloatValue := TimesheetLine.HoursForDay[6];
  edtDay7.FloatValue := TimesheetLine.HoursForDay[7];

  edtTLUDF1.Text     := TimesheetLine.UserField1;
  edtTLUDF2.Text     := TimesheetLine.UserField2;

  { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
  edtTLUDF5.Text     := TimesheetLine.UserField5;
  edtTLUDF6.Text     := TimesheetLine.UserField6;
  edtTLUDF7.Text     := TimesheetLine.UserField7;
  edtTLUDF8.Text     := TimesheetLine.UserField8;
  edtTLUDF9.Text     := TimesheetLine.UserField9;
  edtTLUDF10.Text    := TimesheetLine.UserField10;

  SetColors;

  ChangeLineCaption;
end;

procedure TFrameTimesheetLine.RecalcHrsQtyEtc;
begin
  TimesheetLine.Hours            := edtHrsQty.FloatValue;
  edtTotChargeOutRate.FloatValue := TimesheetLine.Hours * TimesheetLine.ChargeOutRate;
  edtTotCostHour.FloatValue      := TimesheetLine.Hours * TimesheetLine.CostPerHour;
end;

procedure TFrameTimesheetLine.SetTimesheetLine(const Value: TTimesheetLine);
begin
  FTimesheetLine := Value;

  FIgnoreChanges := true;
  HideRestrictedControls;
  PopulateBoxesEtc;
  FIgnoreChanges := false;
end;

procedure TFrameTimesheetLine.FillComboBoxes;
begin
  FIgnoreChanges := true;
  PopulateCCDeptCurrListsEtc(True, ptAll);

  ccbJobCode.ItemIndex := 0;

  ChangeLineCaption;
  FIgnoreChanges := false;
end;

procedure TFrameTimesheetLine.ChangeLineCaption;
var
  NewCaption: string;
begin
  NewCaption := ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 1];
  with TimesheetSettings('') do begin
    if ShowRateCode      then NewCaption := NewCaption + ' / ' + ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 1];
    if ShowAnalysisCode  then NewCaption := NewCaption + ' / ' + ccbAnalysisCode.ColumnItems[ccbAnalysisCode.ItemIndex, 1];
  end;
  gbTransactionLine.Caption := NewCaption;

//  gbTransactionLine.Caption := format('%s / %s / %s', [ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 1], ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 1], ccbAnalysisCode.ColumnItems[ccbAnalysisCode.ItemIndex, 1]]);
end;

procedure TFrameTimesheetLine.DoLineChanged(Recalc: boolean);
begin
  FTimesheetLine.LineChanged := not FIgnoreChanges;
  if Recalc then begin
    with TEmployeeRate.Create do begin
      DataPath := FDataPath;
      FindRates(FEmpCode, ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 0], ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 0]);
      if CurrentRateCode <> nil then
        with CurrentRateCode do begin
          FTimesheetLine.ChargeOutRate  := rcTimeCharge;
          FTimesheetLine.CostPerHour    := rcTimeCost;
          FTimesheetLine.ChargeCurrency := rcChargeCurrency;
          FTimesheetLine.CostCurrency   := rcCostCurrency;
          edtChargeOutRate.FloatValue   := rcTimeCharge; // v14
          edtCostHour.FloatValue        := rcTimeCost;   // v14
          edtChargeOutRate.Prefix       := GCurrencySymbols[rcChargeCurrency] + ' ';
          edtTotChargeOutRate.Prefix    := GCurrencySymbols[rcChargeCurrency] + ' ';
          edtCostHour.Prefix            := GCurrencySymbols[rcCostCurrency] + ' ';
          edtTotCostHour.Prefix         := GCurrencySymbols[rcCostCurrency] + ' ';
        end;
      free;
    end;
    RecalcHrsQtyEtc;
    if assigned(FRecalcTotals) then FRecalcTotals(self);
  end;
  if assigned(FLineChanged) then FLineChanged(self);
end;

procedure TFrameTimesheetLine.edtChargeOutRateExit(Sender: TObject);
begin
  if FBoxWasEdited then begin
    FTimesheetLine.ChargeOutRate := edtChargeOutRate.FloatValue;
    FTimesheetLine.LineChanged := not FIgnoreChanges;
    RecalcHrsQtyEtc;
    if assigned(FRecalcTotals) then FRecalcTotals(self);
    if assigned(FLineChanged) then FLineChanged(self);
  end;
end;

procedure TFrameTimesheetLine.edtCostHourExit(Sender: TObject);
begin
  if FBoxWasEdited then begin
    FTimesheetLine.CostPerHour := edtCostHour.FloatValue;
    FTimesheetLine.LineChanged := not FIgnoreChanges;
    RecalcHrsQtyEtc;
    if assigned(FRecalcTotals) then FRecalcTotals(self);
    if assigned(FLineChanged) then FLineChanged(self);
  end;
end;

procedure TFrameTimesheetLine.edtDay1KeyPress(Sender: TObject; var Key: Char);
// N.B. All day boxes and the total QtyHrs box KeyPress-es come through here.
// The user can press the enter key to tab through all the boxes.
// When this happens, the weekly total should not be recalculated just because they Enter-ed out of a day box with zero hours.
// In a week with no day hours, this would set the week hours to zero.
// So, if the first key they press is not Enter, then we flag that editing is taking place.
// We're not interested in the Enter key if it was preceded by another key press.
// Or, to put it another way...
// We only take notice of the Enter key if they haven't started editing the box contents as it means they're exiting the box without editing it.
// Assuming that all the above is useful in describing what this procedure is for, and
// also assuming that these two lines of code aren't entirely self-explanatory, its interesting
// to note the ratio of comment lines to lines of code, 11:2. I wonder what it is in characters ?
begin
  if not FBoxWasEdited then
    FBoxWasEdited := Key <> #13;
end;

procedure TFrameTimesheetLine.edtNarrativeChange(Sender: TObject);
begin
  FTimesheetLine.Narrative := edtNarrative.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF1Change(Sender: TObject);
begin
  FTimesheetLine.UserField1 := edtTLUDF1.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF2Change(Sender: TObject);
begin
  FTimesheetLine.UserField2 := edtTLUDF2.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF5Change(Sender: TObject);
begin
  FTimesheetLine.UserField5 := edtTLUDF5.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF6Change(Sender: TObject);
begin
  FTimesheetLine.UserField6 := edtTLUDF6.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF7Change(Sender: TObject);
begin
  FTimesheetLine.UserField7 := edtTLUDF7.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF8Change(Sender: TObject);
begin
  FTimesheetLine.UserField8 := edtTLUDF8.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF9Change(Sender: TObject);
begin
  FTimesheetLine.UserField9 := edtTLUDF9.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.edtTLUDF10Change(Sender: TObject);
begin
  FTimesheetLine.UserField10 := edtTLUDF10.Text;
  DoLineChanged(false);
end;

procedure TFrameTimesheetLine.SetColors;
begin
  with FTimesheetLine do
    if MarkedForDeletion then begin
      gbTransactionLine.Caption := '  ! This line has been marked for deletion  ';
      gbTransactionLine.Font.Color := clRed
    end
    else begin
      ChangeLineCaption;
      if IsNewLine then
        gbTransactionLine.Font.Color := clGreen
      else
        gbTransactionLine.Font.Color := clBlack;
    end;
end;

procedure TFrameTimesheetLine.SetPrecision(const Value: integer);
begin
  FPrecision := Value;
  edtHrsQty.Precision := FPrecision;
end;

procedure TFrameTimesheetLine.HideRestrictedControls;
begin
  with TimesheetSettings('') do begin
     EmpCode := FEmpCode;
     ccbRateCode.Visible     := ShowRateCode;
     ccbAnalysisCode.Visible := ShowAnalysisCode;
     lblRateAnalysisCodes.Visible := ShowRateCode or ShowAnalysisCode;
     if not ShowRateCode     then lblRateAnalysisCodes.Caption := 'Analysis Code';
     if not ShowAnalysisCode then lblRateAnalysisCodes.Caption := 'Rate Code';
     edtTotChargeOutRate.Visible  := ShowChargeOutRate;
     edtChargeOutRate.Visible     := ShowChargeOutRate;
//     lblChargeOutCurrency.Visible := ShowChargeOutRate;
     lblChargeOutRate.Visible     := ShowChargeOutRate;
     edtTotCostHour.Visible       := ShowCostPerHour;
     edtCostHour.Visible          := ShowCostPerHour;
//     lblCostHourCurrency.Visible  := ShowCostPerHour;
     lblCostHour.Visible          := ShowCostPerHour;
     edtTLUDF1.Visible            := ShowTLUDF1;
     lblTLUDF1.Visible            := ShowTLUDF1;
     edtTLUDF2.Visible            := ShowTLUDF2;
     lblTLUDF2.Visible            := ShowTLUDF2;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
     edtTLUDF5.Visible            := ShowTLUDF5;
     lblTLUDF5.Visible            := ShowTLUDF5;
     edtTLUDF6.Visible            := ShowTLUDF6;
     lblTLUDF6.Visible            := ShowTLUDF6;
     edtTLUDF7.Visible            := ShowTLUDF7;
     lblTLUDF7.Visible            := ShowTLUDF7;
     edtTLUDF8.Visible            := ShowTLUDF8;
     lblTLUDF8.Visible            := ShowTLUDF8;
     edtTLUDF9.Visible            := ShowTLUDF9;
     lblTLUDF9.Visible            := ShowTLUDF9;
     edtTLUDF10.Visible           := ShowTLUDF10;
     lblTLUDF10.Visible           := ShowTLUDF10;

     ccbCostCentre.Visible        := ShowCostCentre;
     ccbDepartment.Visible        := ShowDepartment;
     if not (ShowCostCentre or ShowDepartment) then lblNarrative.Caption := 'Narrative'
     else
     if not ShowCostCentre then lblNarrative.Caption := 'Narrative / Dep'
     else
     if not ShowDepartment then lblNarrative.Caption := 'Narrative / CC';
  end;

  if not FUseCCDeps then begin // Exchequer says "no"
    ccbCostCentre.Visible := false;
    ccbDepartment.Visible := false;
    lblNarrative.Caption  := 'Narrative';
  end;
end;

end.
