unit SchedWiz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, ExtCtrls, ComCtrls, TCustom, Mask,
  EnterToTab, BorBtns;

type
  TfrmTaskWizard = class(TForm)
    PageControl1: TPageControl;
    tsTask: TTabSheet;
    tsDay: TTabSheet;
    tsTime: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbView: TSBSComboBox;
    Panel2: TPanel;
    Label4: TLabel;
    cbWeekMonth: TSBSComboBox;
    grpWeek: TGroupBox;
    chkMonday: TCheckBox;
    chkTuesday: TCheckBox;
    chkWednesday: TCheckBox;
    chkThursday: TCheckBox;
    chkFriday: TCheckBox;
    chkSaturday: TCheckBox;
    chkSunday: TCheckBox;
    grpMonth: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    CheckBox29: TCheckBox;
    chkLast: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox31: TCheckBox;
    CheckBox32: TCheckBox;
    tsEmail: TTabSheet;
    Panel3: TPanel;
    Label5: TLabel;
    edtEmail: Text8Pt;
    Panel4: TPanel;
    Label6: TLabel;
    rbMins: TRadioButton;
    Label46: TLabel;
    rbMinsBetween: TRadioButton;
    Label28: TLabel;
    dtBetweenStart: TDateTimePicker;
    dtBetweenEnd: TDateTimePicker;
    Label29: TLabel;
    dtSpecific: TDateTimePicker;
    rbSpecific: TRadioButton;
    btnNext: TSBSButton;
    btnBack: TSBSButton;
    btnSave: TSBSButton;
    btnCancel: TSBSButton;
    Label7: TLabel;
    edtTaskName: Text8Pt;
    ceMins: TCurrencyEdit;
    ceMinsBetween: TCurrencyEdit;
    EnterToTab1: TEnterToTab;
    BorCheck1: TBorCheck;
    BorCheck2: TBorCheck;
    BorCheck3: TBorCheck;
    procedure cbWeekMonthChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbMinsClick(Sender: TObject);
    procedure edtTaskNameExit(Sender: TObject);
    procedure chkMondayClick(Sender: TObject);
  private
    { Private declarations }
    AllDone : Boolean;
    procedure LoadGLViews;
    function FindViewIndex(const vi : string) : Integer;
  public
    { Public declarations }
    IsEdit : Boolean;
    DayOrTimeChanged : Boolean;
    function FormToDayNo : longint;
    procedure DayNoToForm(Value : longint);
    procedure FormToTask;
    procedure TaskToForm;
  end;

var
  frmTaskWizard: TfrmTaskWizard;

implementation

{$R *.dfm}
uses
  DataObjs, SchedVar, BtrvU2;

procedure TfrmTaskWizard.cbWeekMonthChange(Sender: TObject);
begin
  grpWeek.Visible := cbWeekMonth.ItemIndex = 0;
  grpMonth.Visible := not grpWeek.Visible;
  grpWeek.TabStop := grpWeek.Visible;
  grpMonth.TabStop := grpMonth.Visible;
end;

procedure TfrmTaskWizard.btnNextClick(Sender: TObject);
begin
  PageControl1.SelectNextPage(True);
end;

procedure TfrmTaskWizard.btnBackClick(Sender: TObject);
begin
  PageControl1.SelectNextPage(False);
end;

procedure TfrmTaskWizard.PageControl1Change(Sender: TObject);
begin
  btnBack.Enabled := PageControl1.TabIndex > 0;
  btnNext.Enabled := PageControl1.TabIndex < 3;
  btnSave.Enabled := IsEdit or (PageControl1.TabIndex = 3) or AllDone;

  if PageControl1.TabIndex = 3 then
    AllDone := True;

  Case PageControl1.TabIndex of
    0 : ActiveControl := edtTaskName;
    1 : ActiveControl := cbWeekMonth;
    2 : if rbMins.Checked then
          ActiveControl := ceMins
        else
        if rbMinsBetween.Checked then
          ActiveControl := ceMinsBetween
        else
          ActiveControl := dtSpecific;
    3 : ActiveControl := edtEmail;
  end;
end;

procedure TfrmTaskWizard.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  PageControl1.TabIndex := 0;
  IsEdit := False;
  AllDone := False;
  LoadGLViews;  //When we add more task types, move this to onchange event for task type dropdown
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TCheckBox then
      with Components[i] as TCheckBox do
        OnClick := chkMondayClick;
end;

procedure TfrmTaskWizard.LoadGLViews;
var
  TempList : TStringList;
begin
  TempList := TStringList.Create;
  Try
    LoadNomViews(TempList);
    cbView.Items.AddStrings(TempList);
    cbView.ItemsT.AddStrings(TempList);
    cbView.ItemsL.AddStrings(TempList);
    cbView.ItemIndex := 0;
  Finally
    TempList.Free;
  End;
end;

procedure TfrmTaskWizard.DayNoToForm(Value: Integer);
var
  i, iMask : longint;
  Step : Byte;
begin
  Case cbWeekMonth.ItemIndex of
    0 : begin
          chkMonday.Checked := Value and 1 = 1;
          chkTuesday.Checked := Value and 2 = 2;
          chkWednesday.Checked := Value and 4 = 4;
          chkThursday.Checked := Value and 8 = 8;
          chkFriday.Checked := Value and 16 = 16;
          chkSaturday.Checked := Value and 32 = 32;
          chkSunday.Checked := Value and 64 = 64;
        end;
    1 : begin
          for i := 0 to ComponentCount - 1 do
          if (Components[i] is TCheckBox) and (Components[i].Tag > 0) then
          begin
            Step := Components[i].Tag - 1;
            iMask := 1 shl Step;
            (Components[i] as TCheckBox).Checked := Value and iMask = iMask;
          end;
        end;
  end;
end;

function TfrmTaskWizard.FormToDayNo: longint;
var
  i, iMask : longint;
  Step : Byte;
begin
  Result := 0;
  Case cbWeekMonth.ItemIndex of
    0 : begin
          if chkMonday.Checked then Result := Result or 1;
          if chkTuesday.Checked then Result := Result or 2;
          if chkWednesday.Checked then Result := Result or 4;
          if chkThursday.Checked then Result := Result or 8;
          if chkFriday.Checked then Result := Result or 16;
          if chkSaturday.Checked then Result := Result or 32;
          if chkSunday.Checked then Result := Result or 64;
        end;
    1 : begin
          for i := 0 to ComponentCount - 1 do
          if (Components[i] is TCheckBox) and (Components[i].Tag > 0) then
          begin
            if (Components[i] as TCheckBox).Checked then
            begin
              Step := Components[i].Tag - 1;
              iMask := 1;
              Result := Result or (iMask shl Step);
            end;
          end;
        end;
  end; //Case
end;

procedure TfrmTaskWizard.FormToTask;
begin
  if not IsEdit then
    TaskObject.Clear;
  TaskObject.Name := edtTaskName.Text;
  TaskObject.WeekMonth := cbWeekMonth.ItemIndex;
  TaskObject.DayNo := FormToDayNo;

  if rbMins.Checked then
  begin
    TaskObject.Interval := Trunc(ceMins.Value);
    TaskObject.TimeType := ttInterval;
  end
  else
  if rbMinsBetween.Checked then
  begin
    TaskObject.Interval := Trunc(ceMinsBetween.Value);
    TaskObject.TimeType := ttIntervalBetween;
    TaskObject.StartTime := TimeOnly(dtBetweenStart.Time);
    TaskObject.EndTime := TimeOnly(dtBetweenEnd.Time);
  end
  else
  begin
    TaskObject.TimeOfDay := TimeOnly(dtSpecific.Time);
    TaskObject.TimeType := ttSpecific;
  end;

  TaskObject.Email := edtEmail.Text;
  if UpperCase(cbView.Text) = 'ALL VIEWS' then
    TaskObject.TaskID := '0000'
  else
    TaskObject.TaskID := Copy(cbView.Text, 1, 4);
end;

procedure TfrmTaskWizard.TaskToForm;
begin
  edtTaskName.Text := Trim(TaskObject.Name);
  cbWeekMonth.ItemIndex := TaskObject.WeekMonth;
  DayNoToForm(TaskObject.DayNo);
  Case TaskObject.TimeType of
    ttSpecific :        begin
                          rbSpecific.Checked := True;
                          dtSpecific.Time := TaskObject.TimeOfDay;
                        end;
    ttInterval :        begin
                          rbMins.Checked := True;
                          ceMins.Value := TaskObject.Interval;
                        end;
    ttIntervalBetween : begin
                          rbMinsBetween.Checked := True;
                          ceMinsBetween.Value := TaskObject.Interval;
                          dtBetweenStart.Time := TaskObject.StartTime;
                          dtBetweenEnd.Time := TaskObject.EndTime;
                        end;
  end;

  edtEmail.Text := Trim(TaskObject.Email);
  cbView.ItemIndex := FindViewIndex(TaskObject.TaskID);

end;

procedure TfrmTaskWizard.rbMinsClick(Sender: TObject);
begin
  ceMins.Enabled := rbMins.Checked;
  ceMinsBetween.Enabled := rbMinsBetween.Checked;
  dtBetweenStart.Enabled := rbMinsBetween.Checked;
  dtBetweenEnd.Enabled := rbMinsBetween.Checked;
  dtSpecific.Enabled := rbSpecific.Checked;
  DayOrTimeChanged := True;
end;

procedure TfrmTaskWizard.edtTaskNameExit(Sender: TObject);
var
  Res : Integer;
begin
  if (ActiveControl <> btnCancel) and not IsEdit then
  begin
    TaskObject.Index := 0;
    Res := TaskObject.FindRecord(B_GetEq, Trim(edtTaskName.Text));
    if Res = 0 then
    begin
      DoMessage('Task ' + QuotedStr(Trim(edtTaskName.Text)) + ' already exists');
      ActiveControl := edtTaskName;
    end;
  end;
end;

procedure TfrmTaskWizard.chkMondayClick(Sender: TObject);
begin
  DayOrTimeChanged := True;
end;

function TfrmTaskWizard.FindViewIndex(const vi: string): Integer;
//vi will be View number in format '0001' - '9999'. Find it in the list and return the index
var
  i, j : Integer;
  Found : Boolean;
begin
  Found := False;
  if (vi = '0000') or (vi = '') then //All views
  begin
    Result := 0;
    Found := True;
  end
  else
  begin
    //Check if it's in the right position
    i := StrToInt(vi);
    if Copy(cbView.Items[i], 1, 4) = vi then
    begin
      Result := i;
      Found := True;
    end
    else
    begin
      //not in position, so need to go through all items in list until we find it
      for j := 1 to cbView.Items.Count - 1 do
        if Copy(cbView.Items[j], 1, 4) = vi then
        begin
          Result := j;
          Found := True;
          Break;
        end;
    end;
  end;
  if not Found then
    Result := -1;
end;

end.
