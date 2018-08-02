unit DeliveryDlgU;
{
  Dialog for entering the delivery details -- specifically the book-in time,
  and the 'week commencing' flag.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, EnterToTab;

type
  TDeliveryDlg = class(TForm)
    DeliveryGrp: TGroupBox;
    DeliveryDateLbl: TLabel;
    WeekCommencingChk: TCheckBox;
    BookinTimeLbl: TLabel;
    BookInTimePicker: TDateTimePicker;
    DeliveryDateDisplayLbl: TStaticText;
    OkBtn: TButton;
    CancelBtn: TButton;
    EnterToTab1: TEnterToTab;
  private
    FBookInTime: string;
    FDeliveryDate: string;
    function GetBookInTime: string;
    function GetDeliveryDate: string;
    procedure ParseBookInTime(TimeStr: string);
    procedure SetBookInTime(const Value: string);
    procedure SetDeliveryDate(const Value: string);
  public
    property BookInTime: string read GetBookInTime write SetBookInTime;
    property DeliveryDate: string read GetDeliveryDate write SetDeliveryDate;
  end;

var
  DeliveryDlg: TDeliveryDlg;

implementation

{$R *.dfm}

uses DateUtils, StrUtil;

// =============================================================================
// TDeliveryDlg
// =============================================================================
function TDeliveryDlg.GetBookInTime: string;
begin
//  Result := FBookInTime;
  Result := TimeToStr(BookInTimePicker.Time);
  if WeekCommencingChk.Checked then
    Result := 'Monday ' + Result;
end;

// -----------------------------------------------------------------------------

function TDeliveryDlg.GetDeliveryDate: string;
begin
  Result := FDeliveryDate;
end;

// -----------------------------------------------------------------------------

procedure TDeliveryDlg.ParseBookInTime(TimeStr: string);
begin
  TimeStr := Trim(Lowercase(TimeStr));
  if (TimeStr <> '') then
  begin
    if (Copy(TimeStr, 1, 6) = 'monday') then
    begin
      WeekCommencingChk.Checked := True;
      TimeStr := Copy(TimeStr, 8, Length(TimeStr));
    end
    else
    begin
      WeekCommencingChk.Checked := False;
    end;
    try
      BookInTimePicker.Time := StrToTime(TimeStr);
    except
      MessageDlg('Invalid book-in time found. Using default time instead',
                 mtError, [mbOk], 0);
      BookInTimePicker.Time := StrToTime('12:00');
    end;
  end
  else
    BookInTimePicker.Time := StrToTime('12:00');
end;

// -----------------------------------------------------------------------------

procedure TDeliveryDlg.SetBookInTime(const Value: string);
begin
  FBookInTime := Value;
  ParseBookInTime(FBookInTime);
end;

// -----------------------------------------------------------------------------

procedure TDeliveryDlg.SetDeliveryDate(const Value: string);
var
  FullDate: TDateTime;
  DateStr: string;
const
  Days: array[1..7] of string =
  (
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  );
begin
  FDeliveryDate := Value;
  FullDate := StrUtil.Str8ToDate(FDeliveryDate);
  DateStr := FormatDateTime('dd/mm/yyyy', FullDate);
  DeliveryDateDisplayLbl.Caption := DateStr + ' (' + Days[DayOfTheWeek(FullDate)] + ')';
end;

// -----------------------------------------------------------------------------

end.
