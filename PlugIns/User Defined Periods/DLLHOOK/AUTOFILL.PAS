unit AutoFill;

{ nfrewer440 15:19 19/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, Mask, ExtCtrls;

type
  TPeriodType = (perDays, perWeeks, perMonths, perPeriods);

  TfrmAutoFill = class(TForm)
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    cbxPeriodType: TComboBox;
    cbxStartDate: TDateTimePicker;
    updPeriodLength: TUpDown;
    edtPeriodLength: TMaskEdit;
    Label3: TLabel;
    cbxEndDate: TDateTimePicker;
    Label4: TLabel;
    edtPeriodStart: TMaskEdit;
    updPeriod: TUpDown;
    Label5: TLabel;
    edtYear: TMaskEdit;
    updYear: TUpDown;
    Bevel1: TBevel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    fStartDate    : TDateTime;
    fEndDate      : TDateTime;
    fPeriodStart  : integer;
    fPeriodType   : TPeriodType;
    fPeriodLength : integer;
    fYear         : integer;
  protected
    procedure SetPeriodType;
  public
    property PeriodStart : integer read fPeriodStart;
    property PeriodType : TPeriodType read fPeriodType;
    property StartDate : TDateTime read fStartDate;
    property EndDate : TDateTime read fEndDate;
    property PeriodLength : integer read fPeriodLength;
    property Year : integer read fYear;
  end;

var
  frmAutoFill: TfrmAutoFill;

implementation

{$R *.DFM}

//------------------------------------------------------------------------------------

procedure TfrmAutoFill.FormCreate(Sender: TObject);
var
  CurDay, CurMonth, CurYear : word;
begin
  // Initialise to convenient values
  cbxPeriodType.ItemIndex := 2;
  cbxStartDate.Date := Now;
  cbxEndDate.Date := IncMonth(Now, 12);
  DecodeDate(Now, CurYear, CurMonth, CurDay);
  edtYear.Text := IntToStr(CurYear);
  updYear.Position := CurYear;
end;

//------------------------------------------------------------------------------------

procedure TfrmAutoFill.SetPeriodType;
begin
  case cbxPeriodType.ItemIndex of
    0 : fPeriodType := perDays;
    1 : fPeriodType := perWeeks;
    2 : fPeriodType := perMonths;
    3 : fPeriodType := perPeriods;
  end;
end;

//------------------------------------------------------------------------------------

procedure TfrmAutoFill.btnOKClick(Sender: TObject);
begin
  SetPeriodType;
  fStartDate := cbxStartDate.Date;
  fEndDate := cbxEndDate.Date;
  fPeriodLength := StrToInt(edtPeriodLength.Text);
  fPeriodStart := StrToInt(edtPeriodStart.Text);
  fYear := StrToInt(edtYear.Text);
end;

//------------------------------------------------------------------------------------

end.

