unit PerSet;

{ nfrewer440 15:19 19/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, ExtCtrls;

type
  TEditMode = (edmPeriod, edmLastDate);
  TProcessMode = (prcEdit, prcAdd);

  TfrmPeriodSet = class(TForm)
    pnlFields: TPanel;
    Label1: TLabel;
    edtPeriod: TMaskEdit;
    updPeriod: TUpDown;
    updYear: TUpDown;
    edtYear: TMaskEdit;
    Label2: TLabel;
    panDate: TPanel;
    lblCalendar: TLabel;
    calPeriodDate: TMonthCalendar;
    panButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtPeriodExit(Sender: TObject);
    procedure edtYearExit(Sender: TObject);
  private
    fPeriod : integer;
    fYear : integer;
    fSelDate : TDateTime;
    fEditMode: TEditMode;
    fProcessMode : TProcessMode;
  protected
    procedure SetEditMode(const Value : TEditMode);
    procedure SetProcessMode(const Value : TProcessMode);
    procedure SetInteger(Index, Value : integer);
    procedure SetSelDate(Value : TDateTime);
    function  CheckPeriod(Period : integer) : integer;
    function  CheckYear(Year : integer) : integer;
  public
    property EditMode : TEditMode read fEditMode write SetEditMode;
    property ProcessMode : TProcessMode read fProcessMode write SetProcessMode;
    property Period : integer index 1 read fPeriod write SetInteger;
    property Year : integer index 2 read fYear write SetInteger;
    property SelDate : TDateTime read fSelDate write SetSelDate;
  end;

var
  frmPeriodSet: TfrmPeriodSet;

implementation

{$R *.DFM}

function TfrmPeriodSet.CheckPeriod(Period : integer) : integer;
// Notes : Periods must be in the range 1 - 99
begin
  if Period < 1 then
    Result := 1
  else
    if Period > 99 then
      Result := 99
    else
      Result := Period
end;

//------------------------------------------------------------------------------------

function TfrmPeriodSet.CheckYear(Year : integer) : integer;
begin
  if Year < 1980 then
    Result := 1980
  else
    if Year > 2100 then
      Result := 2100
    else
      Result := Year;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.SetInteger(Index, Value : integer);
begin
  case Index of
    1: fPeriod := CheckPeriod(Value);
    2: fYear := CheckYear(Value);
  end;
end; // TfrmPeriodSet.SetInteger

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.SetSelDate(Value: TDateTime);
begin
  fSelDate := Value;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.SetEditMode(const Value: TEditMode);
begin
  fEditMode := Value;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.SetProcessMode(const Value: TProcessMode);
begin
  fProcessMode := Value;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.FormShow(Sender: TObject);
begin
  edtPeriod.Text := IntToStr(Period);
  edtYear.Text := IntToStr(Year);
  calPeriodDate.Date := SelDate;
  updPeriod.Position := Period;
  updYear.Position := Year;
  if EditMode = edmLastDate then
  begin
    pnlFields.Visible := false;
    panDate.Top := 8;
    ClientHeight := ClientHeight - pnlFields.Height - 8;
    PanButtons.Top := PanButtons.Top - pnlFields.Height - 8;
    Caption := 'Edit Last Date Details';
    lblCalendar.Caption := 'Last Date';
  end
  else
    if ProcessMode = prcAdd then
      Caption := 'Add Period Details';
end; // TfrmPeriodSet.FormShow

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.btnOKClick(Sender: TObject);
begin
  Period := StrToInt(edtPeriod.Text);
  Year := StrToInt(edtYear.Text);
  SelDate := calPeriodDate.Date;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.edtPeriodExit(Sender: TObject);
begin
  edtPeriod.Text := IntToStr(CheckPeriod(StrToInt(edtPeriod.Text)));
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodSet.edtYearExit(Sender: TObject);
begin
  edtYear.Text := IntToStr(CheckYear(StrToInt(edtYear.Text)));
end;

//------------------------------------------------------------------------------------

end.
