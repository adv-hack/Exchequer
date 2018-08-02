unit vatprset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Mask{, dtpick{, TEditVal};

type

  TDialogMode = (dmAdd, dmInsert, dmEdit);

  TfrmVatPerSet = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label1: TLabel;
    cbPeriod: TComboBox;
    cbYear: TComboBox;
    Label4: TLabel;
    Label2: TLabel;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure dtpStartDateDropDown(Sender: TObject);
  private
    { Private declarations }
    procedure SetDatePicker(Index : Integer; Value : String);
    function ValidatePeriod : Boolean;
    function CheckPreviousPeriod : Boolean;
    function CheckNextPeriod : Boolean;
  public
    { Public declarations }
    CurrentYear : Integer;
    AccessMode : TDialogMode;
    OKPressed : Boolean;
    CancelPressed : Boolean;
    ListIndex : integer;
    LView : TListView;
    procedure LoadYears;
    procedure LoadPeriods;
    property StartDate : String Index 0 Write SetDatePicker;
    property EndDate : String Index 1 Write SetDatePicker;
  end;

var
  frmVatPerSet: TfrmVatPerSet;

implementation

{$R *.dfm}
uses
  VatPrObj;

procedure TfrmVatPerSet.LoadYears;
var
  i : integer;
begin
  for i := CurrentYear - 10 to CurrentYear + 10 do
    cbYear.Items.Add(IntToStr(i));
  cbYear.ItemIndex := cbYear.Items.IndexOf(IntToStr(CurrentYear));
end;

procedure TfrmVatPerSet.SetDatePicker(Index : Integer; Value : String);
begin
  Case Index of
    0  :  dtpStartDate.Date := StrToDate(Value);
    1  :  dtpEndDate.Date := StrToDate(Value);
  end;
end;

function TfrmVatPerSet.ValidatePeriod : Boolean;
var
  PeriodString : string;
  SDate, EDate : string;
begin
  EDate := FormatDateTime('YYYYMMDD', dtpEndDate.Date);
  SDate := FormatDateTime('YYYYMMDD', dtpStartDate.Date);
  Result := True;
{  if AccessMode in  [dmAdd, dmInsert] then
  begin
    PeriodString := cbYear.Text + cbPeriod.Text;
    VatPeriod.Index := 1;
    Result := VatPeriod.GetEqual(PeriodString) in [4, 9];
    if not Result then
      ShowMessage('Period ' + cbPeriod.Text + '/' + cbYear.Text + ' already exists');
  end;}

  if Result then
  begin
    Result := EDate > SDate;

    if not Result then
      ShowMessage('End Date must be later than Start Date');
  end;

  if Result then
  begin
     Result := CheckPreviousPeriod;

     if not Result then
       ShowMessage('End Date must be later than the End Date of the previous period');
  end;

  if Result then
  begin
     Result := CheckNextPeriod;

     if not Result then
       ShowMessage('End Date must be earlier than the End Date of the next period');
  end;

  if OkPressed then
    OkPressed := Result;
end;

procedure TfrmVatPerSet.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (not OkPressed) or ValidatePeriod;
end;

procedure TfrmVatPerSet.FormCreate(Sender: TObject);
begin
  OkPressed := False;
end;

procedure TfrmVatPerSet.btnOKClick(Sender: TObject);
begin
  OkPressed := True;
  Close;
end;

procedure TfrmVatPerSet.Button2Click(Sender: TObject);
begin
  OkPressed := False;
  Close;
end;

function TfrmVatPerSet.CheckPreviousPeriod : Boolean;
//Check that startdate is > than previous end date
var
  EDate : TDate;
  i : integer;
begin
  if ListIndex > 0 then
  begin
    i := ListIndex - 1;
{    while (i > 0) and (LView.Items[i].Caption > cbPeriod.Text) or
                       (LView.Items[i].SubItems[0] > cbYear.Text) do
                         Dec(i);}
    EDate := StrToDateTime(LView.Items[i].SubItems[2]);
    Result := EDate < Trunc(dtpEndDate.Date);
  end
  else
    Result := True;
end;

function TfrmVatPerSet.CheckNextPeriod : Boolean;
//Check that enddate < next start date if applicable
var
  EDate : TDate;
  i : Integer;
begin
  if ListIndex < LView.Items.Count - 1 then
  begin
    i := ListIndex + 1;
{    while (i < LView.Items.Count - 1) and (LView.Items[i].Caption < cbPeriod.Text) or
                       (LView.Items[i].SubItems[0] < cbYear.Text) do
                         Inc(i);            }
    EDate := StrToDateTime(LView.Items[i].SubItems[2]);
    Result := EDate > Trunc(dtpEndDate.Date);
  end
  else
    Result := True;
end;


procedure TfrmVatPerSet.dtpStartDateDropDown(Sender: TObject);
{var
  Wnd :HWND;
  Style : integer;
//Turn off ShowToday & ShowTodayCircle on the dropdown calendar.}
begin
// NF: 24/07/2008 Removed, as it seemed pretty pointless, and I could not debug this form as I did not have "TExtendedDateTimePicker"
{  if Sender is TExtendedDateTimePicker then
    with Sender as TExtendedDateTimePicker do
    begin
      Wnd := CalendarHandle;
      Style := GetWindowLong(Wnd, GWL_STYLE);
      Style := Style or 24;
      SetWindowLong(Wnd, GWL_STYLE, Style);
    end;}
end;

procedure TfrmVatPerSet.LoadPeriods;
var
  i : integer;
  s : string;
begin
  for i := 1 to VatPeriod.MaxPeriods do
  begin
    s := intToStr(i);
    if i < 10 then
      s := '0' + s;
    cbPeriod.Items.Add(s);
  end;
end;

end.
